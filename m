Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB6A0ED55
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfD2Xcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:32:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45916 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbfD2Xcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:32:53 -0400
Received: by mail-io1-f66.google.com with SMTP id e8so10541539ioe.12;
        Mon, 29 Apr 2019 16:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FHZfi5iW6HeO4gNAYB84MWqeizOGnBzEIRUuiVrwJMk=;
        b=DA1dD8zjmeBAeA1Ee0lzq8z1DPv/5z9EkHCvdNJsl9ufaIGEAcTgawaTU0HktsV/wt
         LMIWEAq0J/Ug+M23/B2TcLWn0daxB5B49FfBJ6oFbYjLHEoPp2cl3fhfS342JvkNPAno
         5zWRJ+94cOJXDlbuTkZ5AkVrSOHiryGZtwsmthriEzUmjjG9d0AqqiiGSVPocdzIh907
         YvaJxfhnzmVePC9V+H5WNWPE6Z1jcsIhuSUGt8bp62LGCEJvHMzjDNC0xoDhhwfLflUh
         0xoaE1nQ732BigqMzlUbaLwvOL8bU35fSO5hfx75NZRMVLhhtlxD7jWIdwRoGqOh1dac
         aJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FHZfi5iW6HeO4gNAYB84MWqeizOGnBzEIRUuiVrwJMk=;
        b=jyxWYKeccIk0+re2Hgxwwx45NzQZThh0Hlhuan/YvdOZp4/VquHHEANU4l4g8xyybv
         xdYeKdyHd7rtJC5gfkFY3F0B/MjXHCzLXr6V7jrLf9hktgtonEqTgYNfKZHuZBvrYoCG
         3XtxbUCW9Lv64FnlGol1aYHf5nqCPFNVIH6IL/FW0TNsVuyywLiDXmh0zfjYioGhL6qL
         LjleA22EMZvMQ8ya53Bi16ipznexvbQQxTBqrZ7ftFXkS8M6idCGmF4jmBdU+Rji9OeU
         9tIyT8bAG5LXyBUMp15WkUqIxOEeswmQcpdFfZTbWJZ0VqYiTp7Ku0EjSdceRadq0Ata
         EbJg==
X-Gm-Message-State: APjAAAXpt80d9mAxxqdWXz70cavdfQcgxO944Y8wqHg/Em9hyzk8WKgf
        LscckoO38Ytyhktote8M3J/2/DYmIskPxb4n3xU=
X-Google-Smtp-Source: APXvYqywEpn1WRJzCRSeJYcynIwRtSUCWThETR4iLXnUkIhfVMxUQN9YQ9NNXxUslGlgFc8TfvJfQ0SOWw+vOXBueJw=
X-Received: by 2002:a5d:8a02:: with SMTP id w2mr24390895iod.89.1556580771889;
 Mon, 29 Apr 2019 16:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190429095227.9745-1-quentin.monnet@netronome.com> <20190429095227.9745-2-quentin.monnet@netronome.com>
In-Reply-To: <20190429095227.9745-2-quentin.monnet@netronome.com>
From:   Y Song <ys114321@gmail.com>
Date:   Mon, 29 Apr 2019 16:32:15 -0700
Message-ID: <CAH3MdRUQn=ycpcDLbLxGAZwGhnVMoD-avPPcSCopAtwof4czNw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] tools: bpftool: add --log-libbpf option to
 get debug info from libbpf
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 2:53 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> libbpf has three levels of priority for output: warn, info, debug. By
> default, debug output is not printed to stderr.
>
> Add a new "--log-libbpf LOG_LEVEL" option to bpftool to provide more
> flexibility on the log level for libbpf. LOG_LEVEL is a comma-separated
> list of levels of log to print ("warn", "info", "debug"). The value
> corresponding to the default behaviour would be "warn,info".

Do you think option like "warn,debug" will be useful for bpftool users?
Maybe at bpftool level, we could allow user only to supply minimum level
for log output, e.g., "info" will output "warn,info"?

>
> Internally, we simply use the function provided by libbpf to replace the
> default printing function by one that prints logs for all required
> levels.
>
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  .../bpftool/Documentation/bpftool-prog.rst    |  6 ++
>  tools/bpf/bpftool/bash-completion/bpftool     | 41 ++++++++++++-
>  tools/bpf/bpftool/main.c                      | 61 ++++++++++++++++---
>  3 files changed, 100 insertions(+), 8 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> index e8118544d118..77d9570488d1 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> @@ -174,6 +174,12 @@ OPTIONS
>                   Do not automatically attempt to mount any virtual file system
>                   (such as tracefs or BPF virtual file system) when necessary.
>
> +       --log-libbpf *LOG_LEVEL*
> +                 Set the log level for libbpf output when attempting to load
> +                 programs. *LOG_LEVEL* must be a comma-separated list of the
> +                 levels of information to print, which can be **warn**,
> +                 **info** or **debug**. The default is **warn,info**.
> +
>  EXAMPLES
>  ========
>  **# bpftool prog show**
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 50e402a5a9c8..a232da1b158d 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -44,6 +44,34 @@ _bpftool_one_of_list()
>      COMPREPLY+=( $( compgen -W "$*" -- "$cur" ) )
>  }
>
> +# Complete a comma-separated list of items. For example:
> +#     _bpftool_cslist "abc def ghi"
> +# will suggest:
> +#     - "abc" and "abc,"        to complete "a"
> +#     - "abc,def" and "abc,ghi" to complete "abc,"
> +#     - "abc,ghi,def"           to complete "abc,ghi,"
> +_bpftool_cslist()
> +{
> +    local array_arg array_cur array_comp prevsubwords w ifs_back
> +    read -r -a array_arg <<< "$*"
> +    ifs_back=$IFS
> +    IFS="," read -r -a array_cur <<< "$cur"
> +    IFS=$ifs_back
> +    prevsubwords=${cur%,*}
> +    for w in "${array_arg[@]}"; do
> +            if [[ ! "$cur" =~ "," ]]; then
> +                array_comp+=( "$w" "$w," )
> +            elif [[ ! "$cur" =~ "$w," ]]; then
> +                if [[ "${#array_arg[@]}" > ${#array_cur[@]} ]]; then
> +                    array_comp+=( "$prevsubwords,$w" "$prevsubwords,$w," )
> +                else
> +                    array_comp+=( "$prevsubwords,$w" )
> +                fi
> +            fi
> +    done
> +    COMPREPLY+=( $( compgen -W "${array_comp[*]}" -- "$cur" ) )
> +}
> +
>  _bpftool_get_map_ids()
>  {
>      COMPREPLY+=( $( compgen -W "$( bpftool -jp map  2>&1 | \
> @@ -181,7 +209,7 @@ _bpftool()
>
>      # Deal with options
>      if [[ ${words[cword]} == -* ]]; then
> -        local c='--version --json --pretty --bpffs --mapcompat'
> +        local c='--version --json --pretty --bpffs --mapcompat --log-libbpf'
>          COMPREPLY=( $( compgen -W "$c" -- "$cur" ) )
>          return 0
>      fi
> @@ -203,12 +231,23 @@ _bpftool()
>              COMPREPLY=( $( compgen -W 'file' -- "$cur" ) )
>              return 0
>              ;;
> +        --log-libbpf)
> +            _bpftool_cslist 'warn info debug'
> +            return 0
> +            ;;
>      esac
>
>      # Remove all options so completions don't have to deal with them.
>      local i
>      for (( i=1; i < ${#words[@]}; )); do
>          if [[ ${words[i]::1} == - ]]; then
> +            # Remove arguments for options, if necessary
> +            case ${words[i]} in
> +                --log-libbpf)
> +                    words=( "${words[@]:0:i+1}" "${words[@]:i+2}" )
> +                    [[ $i -le $cword ]] && cword=$(( cword - 1 ))
> +                    ;;
> +            esac
>              words=( "${words[@]:0:i}" "${words[@]:i+1}" )
>              [[ $i -le $cword ]] && cword=$(( cword - 1 ))
>          else
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 1ac1fc520e6a..6318be6feb5c 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -10,6 +10,7 @@
>  #include <string.h>
>
>  #include <bpf.h>
> +#include <libbpf.h>
>
>  #include "main.h"
>
> @@ -26,6 +27,7 @@ bool json_output;
>  bool show_pinned;
>  bool block_mount;
>  int bpf_flags;
> +int log_level_libbpf;
>  struct pinned_obj_table prog_table;
>  struct pinned_obj_table map_table;
>
> @@ -77,6 +79,46 @@ static int do_version(int argc, char **argv)
>         return 0;
>  }
>
> +static int __printf(2, 0)
> +print_selected_levels(enum libbpf_print_level level, const char *format,
> +                     va_list args)
> +{
> +       if (!(log_level_libbpf & (1 << level)))
> +               return 0;
> +
> +       return vfprintf(stderr, format, args);
> +}
> +
> +static int set_libbpf_loglevel(const char *log_str)
> +{
> +       char *log_str_cpy, *token;
> +
> +       log_str_cpy = strdup(log_str);
> +       if (!log_str_cpy) {
> +               p_err("mem alloc failed");
> +               return -1;
> +       }
> +
> +       token = strtok(log_str_cpy, ",");
> +       while (token) {
> +               if (is_prefix(token, "warn"))
> +                       log_level_libbpf |= (1 << LIBBPF_WARN);
> +               else if (is_prefix(token, "info"))
> +                       log_level_libbpf |= (1 << LIBBPF_INFO);
> +               else if (is_prefix(token, "debug"))
> +                       log_level_libbpf |= (1 << LIBBPF_DEBUG);
> +               else
> +                       p_info("unrecognized log level for libbpf: %s", token);
> +
> +               token = strtok(NULL, ",");
> +       }
> +       free(log_str_cpy);
> +
> +       libbpf_set_print(print_selected_levels);
> +
> +       return 0;
> +}
> +
>  int cmd_select(const struct cmd *cmds, int argc, char **argv,
>                int (*help)(int argc, char **argv))
>  {
> @@ -310,13 +352,14 @@ static int do_batch(int argc, char **argv)
>  int main(int argc, char **argv)
>  {
>         static const struct option options[] = {
> -               { "json",       no_argument,    NULL,   'j' },
> -               { "help",       no_argument,    NULL,   'h' },
> -               { "pretty",     no_argument,    NULL,   'p' },
> -               { "version",    no_argument,    NULL,   'V' },
> -               { "bpffs",      no_argument,    NULL,   'f' },
> -               { "mapcompat",  no_argument,    NULL,   'm' },
> -               { "nomount",    no_argument,    NULL,   'n' },
> +               { "json",       no_argument,            NULL,   'j' },
> +               { "help",       no_argument,            NULL,   'h' },
> +               { "pretty",     no_argument,            NULL,   'p' },
> +               { "version",    no_argument,            NULL,   'V' },
> +               { "bpffs",      no_argument,            NULL,   'f' },
> +               { "mapcompat",  no_argument,            NULL,   'm' },
> +               { "nomount",    no_argument,            NULL,   'n' },
> +               { "log-libbpf", required_argument,      NULL,   'd' },
>                 { 0 }
>         };
>         int opt, ret;
> @@ -362,6 +405,10 @@ int main(int argc, char **argv)
>                 case 'n':
>                         block_mount = true;
>                         break;
> +               case 'd':
> +                       if (set_libbpf_loglevel(optarg))
> +                               return -1;
> +                       break;
>                 default:
>                         p_err("unrecognized option '%s'", argv[optind - 1]);
>                         if (json_output)
> --
> 2.17.1
>
