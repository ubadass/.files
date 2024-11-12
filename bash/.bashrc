#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='eza --group-directories-first -g'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR=/usr/bin/nvim

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function set_path() {
	# Check if user id is 1000 or higher
	[ "$(id -u)" -ge 1000 ] || return

	for i in "$@"; do
		# Check if the directory exists
		[ -d "$i" ] || continue

		# Check if it is not already in your $PATH.
		echo "$PATH" | grep -Eq "(^|:)$i(:|$)" && continue

		# Then append it to $PATH and export it
		export PATH="${PATH}:$i"
	done
}

set_path \
	"/usr/local/nodejs/bin" \
	"$HOME/.cargo/bin" \
	"$HOME/.local/bin"

if [ $TERM != 'linux' ]; then
	eval "$(starship init bash)"
fi
