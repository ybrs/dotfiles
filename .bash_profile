function git_branch {
  git branch --no-color 2> /dev/null | egrep '^\*' | sed -e 's/^* //'
}
function git_dirty {
  # only tracks modifications, not unknown files needing adds
    if [ -z "`git status -s | awk '{print $1}' | grep '[ADMTU]'`" ] ; then
        return 1
    else
        return 0
    fi
}

function dirty_git_prompt {
    branch=`git_branch`
    if [ -z "${branch}" ] ; then
        return
    fi
    git_dirty && echo " (${branch})+"
}

function clean_git_prompt {
    branch=`git_branch`
    if [ -z "${branch}" ] ; then
        return
    fi
    git_dirty || echo " (${branch})"
}

export MYPS='$(echo -n "${PWD/#$HOME/~}" | awk -F "/" '"'"'{if (length($0) > 14) { if (NF>4) print $1 "/" $2 "/.../" $(NF-1) "/" $NF; else if (NF>3) print $1 "/" $2 "/.../" $NF; else print $1 "/.../" $NF; } else print $0;}'"'"')'
#PS1='$(eval "echo ${MYPS}")$ '

#PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'

PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}$(dirty_git_prompt)$(clean_git_prompt)\007"'

#if [[ "$TERM" == screen* ]]; then
screen_set_window_title () {
local HPWD="$PWD"
case $HPWD in
  $HOME) HPWD="~";;
  #$HOME/*) HPWD="~${HPWD#$HOME}";;
  *) HPWD=`basename "$HPWD"`;;
esac
printf '\ek%s\e\\' "$HPWD" # "$(eval echo ${MYPS})"
}


PROMPT_COMMAND="screen_set_window_title; $PROMPT_COMMAND"
#fi

#...
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
alias ls="ls -G"



PS1="\$ "



