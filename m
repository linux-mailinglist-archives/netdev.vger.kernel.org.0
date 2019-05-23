Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D43D28332
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbfEWQVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:21:07 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39175 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731089AbfEWQVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:21:05 -0400
Received: by mail-qt1-f193.google.com with SMTP id y42so7422272qtk.6;
        Thu, 23 May 2019 09:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sqLMv4lX+d0MEfaumfdwq2LTZ8ZVJEzvnBVcOyszC94=;
        b=nViIBdmO9HZGyp40cCQRlPa5m8sGIXpSeVvTQdKoXwvPoBFRhiePBroHblpU5AcfL2
         M8QnOnsdekMs1JUG7nOKenlyRQBj0yDtP0VbG3X2Ucsx8hAo7V37LzSHorCXom97cIob
         U+6RpmZETqzywie1CcEY6A405d4UffP4bbeuHuPm85Gc2Yyirxi0M7PqC8jL5M7UoCXd
         vXH+I6WumgPBE3wzs063PtoprctcmIV9REn+LdYseiH+W8hJgR5qAKcP0Ab5IxxGAPxE
         0VnlgVKf+4vmI2ukqlrfg0SlvQCFKmFEFRH+O1RkPBkJR0fGJoARFrg0EnpYsNzSPvO7
         vonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sqLMv4lX+d0MEfaumfdwq2LTZ8ZVJEzvnBVcOyszC94=;
        b=TAJZVgOdeJO8ZkQ33zXKFjVr+tt8m3a5C/vgTHSfG4c/xNILcmdX2Xnrt1RF1lXCdL
         dYSHIuZ1OjoCT6oYGBcUdCohAjCEbl7X30vZDWNYL5tbZp4+t/rkPA2V+74wpbOSnc+N
         vOvlzxMBtdOedPL87okGAFmx+JXOAPhiRMAqcidwjt3hWpKZvjAnGTHzdAZF21gjL7RI
         156sd1D+mMG0l5osGkvuTKMbH9tJbOtGRimS2jkcJAXavfP1TAKYzLvPQEb5F3XJhjjw
         3noAkol++5wenvhZyhqf6v0eW3s14i8MYMMitm2z/UTkrA+Hl5BuOGnRYaWUIzHBljwS
         bupQ==
X-Gm-Message-State: APjAAAUTW7fgCRIclgOpJm/m8b04V1d4w3iiGfRtmnZrwjs4WCly6uE6
        Hud1/fYpmqtH6W5KA/g1z72AhO3eTtZhigZOA+w=
X-Google-Smtp-Source: APXvYqwmsJ/IhZ3jyK/lUZojdM8/DYluIGAHal88T7ztU+LOoRrTxyj5X0JD0O6doj1+It8nr0FE/sPKFtw4JUKsCFk=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr65342950qtl.117.1558628464209;
 Thu, 23 May 2019 09:21:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190523105426.3938-1-quentin.monnet@netronome.com> <20190523105426.3938-2-quentin.monnet@netronome.com>
In-Reply-To: <20190523105426.3938-2-quentin.monnet@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 23 May 2019 09:20:52 -0700
Message-ID: <CAEf4BzZt75Wm29MQKx1g_u8cH2QYRF3HGYgnOpa3yF9NOMXysw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] tools: bpftool: add -d option to get
 debug output from libbpf
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, oss-drivers@netronome.com,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 3:54 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> libbpf has three levels of priority for output messages: warn, info,
> debug. By default, debug output is not printed to the console.
>
> Add a new "--debug" (short name: "-d") option to bpftool to print libbpf
> logs for all three levels.
>
> Internally, we simply use the function provided by libbpf to replace the
> default printing function by one that prints logs regardless of their
> level.
>
> v2:
> - Remove the possibility to select the log-levels to use (v1 offered a
>   combination of "warn", "info" and "debug").
> - Rename option and offer a short name: -d|--debug.

Such and option in CLI tools is usually called -v|--verbose, I'm
wondering if it might be a better name choice?

Btw, some tools also use -v, -vv and -vvv to define different levels
of verbosity, which is something we can consider in the future, as
it's backwards compatible.

> - Add option description to all bpftool manual pages (instead of
>   bpftool-prog.rst only), as all commands use libbpf.
>
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  tools/bpf/bpftool/Documentation/bpftool-btf.rst    |  4 ++++
>  tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |  4 ++++
>  .../bpf/bpftool/Documentation/bpftool-feature.rst  |  4 ++++
>  tools/bpf/bpftool/Documentation/bpftool-map.rst    |  4 ++++
>  tools/bpf/bpftool/Documentation/bpftool-net.rst    |  4 ++++
>  tools/bpf/bpftool/Documentation/bpftool-perf.rst   |  4 ++++
>  tools/bpf/bpftool/Documentation/bpftool-prog.rst   |  4 ++++
>  tools/bpf/bpftool/Documentation/bpftool.rst        |  3 +++
>  tools/bpf/bpftool/bash-completion/bpftool          |  2 +-
>  tools/bpf/bpftool/main.c                           | 14 +++++++++++++-
>  10 files changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> index 2dbc1413fabd..00668df1bf7a 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> @@ -67,6 +67,10 @@ OPTIONS
>         -p, --pretty
>                   Generate human-readable JSON output. Implies **-j**.
>
> +       -d, --debug
> +                 Print all logs available from libbpf, including debug-level
> +                 information.
> +
>  EXAMPLES
>  ========
>  **# bpftool btf dump id 1226**
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
> index ac26876389c2..36807735e2a5 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
> @@ -113,6 +113,10 @@ OPTIONS
>         -f, --bpffs
>                   Show file names of pinned programs.
>
> +       -d, --debug
> +                 Print all logs available from libbpf, including debug-level
> +                 information.
> +
>  EXAMPLES
>  ========
>  |
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> index 14180e887082..4d08f35034a2 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> @@ -73,6 +73,10 @@ OPTIONS
>         -p, --pretty
>                   Generate human-readable JSON output. Implies **-j**.
>
> +       -d, --debug
> +                 Print all logs available from libbpf, including debug-level
> +                 information.
> +
>  SEE ALSO
>  ========
>         **bpf**\ (2),
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
> index 13ef27b39f20..490b4501cb6e 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
> @@ -152,6 +152,10 @@ OPTIONS
>                   Do not automatically attempt to mount any virtual file system
>                   (such as tracefs or BPF virtual file system) when necessary.
>
> +       -d, --debug
> +                 Print all logs available from libbpf, including debug-level
> +                 information.
> +
>  EXAMPLES
>  ========
>  **# bpftool map show**
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
> index 934580850f42..d8e5237a2085 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
> @@ -65,6 +65,10 @@ OPTIONS
>         -p, --pretty
>                   Generate human-readable JSON output. Implies **-j**.
>
> +       -d, --debug
> +                 Print all logs available from libbpf, including debug-level
> +                 information.
> +
>  EXAMPLES
>  ========
>
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-perf.rst b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
> index 0c7576523a21..e252bd0bc434 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-perf.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
> @@ -53,6 +53,10 @@ OPTIONS
>         -p, --pretty
>                   Generate human-readable JSON output. Implies **-j**.
>
> +       -d, --debug
> +                 Print all logs available from libbpf, including debug-level
> +                 information.
> +
>  EXAMPLES
>  ========
>
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> index e8118544d118..9a92614569e6 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> @@ -174,6 +174,10 @@ OPTIONS
>                   Do not automatically attempt to mount any virtual file system
>                   (such as tracefs or BPF virtual file system) when necessary.
>
> +       -d, --debug
> +                 Print all logs available from libbpf, including debug-level
> +                 information.
> +
>  EXAMPLES
>  ========
>  **# bpftool prog show**
> diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
> index 3e562d7fd56f..43dba0717953 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool.rst
> @@ -66,6 +66,9 @@ OPTIONS
>                   Do not automatically attempt to mount any virtual file system
>                   (such as tracefs or BPF virtual file system) when necessary.
>
> +       -d, --debug
> +                 Print all logs available from libbpf, including debug-level
> +                 information.
>
>  SEE ALSO
>  ========
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 50e402a5a9c8..3a476e25d046 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -181,7 +181,7 @@ _bpftool()
>
>      # Deal with options
>      if [[ ${words[cword]} == -* ]]; then
> -        local c='--version --json --pretty --bpffs --mapcompat'
> +        local c='--version --json --pretty --bpffs --mapcompat --debug'
>          COMPREPLY=( $( compgen -W "$c" -- "$cur" ) )
>          return 0
>      fi
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 1ac1fc520e6a..d74293938a05 100644
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
> @@ -77,6 +78,13 @@ static int do_version(int argc, char **argv)
>         return 0;
>  }
>
> +static int __printf(2, 0)
> +print_all_levels(__maybe_unused enum libbpf_print_level level,
> +                const char *format, va_list args)
> +{
> +       return vfprintf(stderr, format, args);
> +}
> +
>  int cmd_select(const struct cmd *cmds, int argc, char **argv,
>                int (*help)(int argc, char **argv))
>  {
> @@ -317,6 +325,7 @@ int main(int argc, char **argv)
>                 { "bpffs",      no_argument,    NULL,   'f' },
>                 { "mapcompat",  no_argument,    NULL,   'm' },
>                 { "nomount",    no_argument,    NULL,   'n' },
> +               { "debug",      no_argument,    NULL,   'd' },
>                 { 0 }
>         };
>         int opt, ret;
> @@ -332,7 +341,7 @@ int main(int argc, char **argv)
>         hash_init(map_table.table);
>
>         opterr = 0;
> -       while ((opt = getopt_long(argc, argv, "Vhpjfmn",
> +       while ((opt = getopt_long(argc, argv, "Vhpjfmnd",
>                                   options, NULL)) >= 0) {
>                 switch (opt) {
>                 case 'V':
> @@ -362,6 +371,9 @@ int main(int argc, char **argv)
>                 case 'n':
>                         block_mount = true;
>                         break;
> +               case 'd':
> +                       libbpf_set_print(print_all_levels);
> +                       break;
>                 default:
>                         p_err("unrecognized option '%s'", argv[optind - 1]);
>                         if (json_output)
> --
> 2.17.1
>
