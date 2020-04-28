Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BA01BB9CD
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgD1J10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726477AbgD1J10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:27:26 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F1BC03C1AB
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:27:25 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i10so23775355wrv.10
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C9mY2tni0CusEWLBqmZ5bZpXGg0uRl8b2IcoSzKi05w=;
        b=XzYaKezKGgpCANw96d4cDLJVdQnl9aJlFLRiKNY8guiLz5fxKawTp/8LH7tpNNBmpY
         Ze13zIsCf6D7BBI5kk1fRpRStYmvufVBk0J+/9eSZrNUyL91kxbertwI5XA5jtJcT8yU
         XQEK452U4LLW9yBIpoSMXbqp+2CyaunBMoIB05/eHwMGNG/etUrqlEkbbMKHZe7TSVQG
         YDQb2y44vpB1BHArA19Du+XfhEkBD8UNJF4aeoK6exupcCcP87fDKgQYmWRRzSyH5dFI
         oQP08WoFA7JaTh7qw4LPCW1N5z+RwCQwjqitcRS0r9omZ+TXkxlalxoyiJyGi7Ow0g85
         JMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C9mY2tni0CusEWLBqmZ5bZpXGg0uRl8b2IcoSzKi05w=;
        b=UB6nzMbka8a0JZegNwLE1VqBtZKLZFRYdjWq4sAtHedGTmOibiPpMI7BkDVxjx/ng4
         3FysykeR/zhbKTQOoTq+KrXOBIWkboD8QmTFQl+bDDT+k4LrM+2meo9HV5nSO+3BMJ2E
         19z3dQteE69+o+52MHnKldrdd36+MbCOdqrHDn26IB8t8sr9hNpAqRbRRK9YVy3ngLEg
         xg02YJpik0uVYkllWPozCG9zQqjH632azLLyns1ZX+iDffqofYMQaXqacp/JWTGzjPUo
         iGDYnpuylA/Xph3OFLU+2PMvNrvQAnHnRsNQ7RDmy3Ao8y9B9+KeaduqsmnUI2u/gAhd
         9/Ug==
X-Gm-Message-State: AGi0PuaDhZXsGdpHvbYTwGaTo+qYlCjD2H3pKzgBno64lP0JBpziOrCI
        5zJ2mmLTcnrcsbBeMO6x/6NCjw==
X-Google-Smtp-Source: APiQypJccWmeHkE+NiGeb4DrWtW1qmsDZUt66NORsyJY0trTPEuaE8g4yiuYZXAnLwkT0zlBpiDHNQ==
X-Received: by 2002:adf:9441:: with SMTP id 59mr31608896wrq.211.1588066044471;
        Tue, 28 Apr 2020 02:27:24 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.137])
        by smtp.gmail.com with ESMTPSA id l4sm25179641wrv.60.2020.04.28.02.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 02:27:23 -0700 (PDT)
Subject: Re: [PATCH bpf-next v1 16/19] tools/bpftool: add bpf_iter support for
 bptool
To:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201253.2996156-1-yhs@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <05d9c82d-8cba-db77-02af-265e4d200946@isovalent.com>
Date:   Tue, 28 Apr 2020 10:27:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427201253.2996156-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-27 13:12 UTC-0700 ~ Yonghong Song <yhs@fb.com>
> Currently, only one command is supported
>   bpftool iter pin <bpf_prog.o> <path>
> 
> It will pin the trace/iter bpf program in
> the object file <bpf_prog.o> to the <path>
> where <path> should be on a bpffs mount.
> 
> For example,
>   $ bpftool iter pin ./bpf_iter_ipv6_route.o \
>     /sys/fs/bpf/my_route
> User can then do a `cat` to print out the results:
>   $ cat /sys/fs/bpf/my_route
>     fe800000000000000000000000000000 40 00000000000000000000000000000000 ...
>     00000000000000000000000000000000 00 00000000000000000000000000000000 ...
>     00000000000000000000000000000001 80 00000000000000000000000000000000 ...
>     fe800000000000008c0162fffebdfd57 80 00000000000000000000000000000000 ...
>     ff000000000000000000000000000000 08 00000000000000000000000000000000 ...
>     00000000000000000000000000000000 00 00000000000000000000000000000000 ...
> 
> The implementation for ipv6_route iterator is in one of subsequent
> patches.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  .../bpftool/Documentation/bpftool-iter.rst    | 71 ++++++++++++++++
>  tools/bpf/bpftool/bash-completion/bpftool     | 13 +++
>  tools/bpf/bpftool/iter.c                      | 84 +++++++++++++++++++
>  tools/bpf/bpftool/main.c                      |  3 +-
>  tools/bpf/bpftool/main.h                      |  1 +
>  5 files changed, 171 insertions(+), 1 deletion(-)
>  create mode 100644 tools/bpf/bpftool/Documentation/bpftool-iter.rst
>  create mode 100644 tools/bpf/bpftool/iter.c
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
> new file mode 100644
> index 000000000000..1997a6bac4a0
> --- /dev/null
> +++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
> @@ -0,0 +1,71 @@
> +============
> +bpftool-iter
> +============
> +-------------------------------------------------------------------------------
> +tool to create BPF iterators
> +-------------------------------------------------------------------------------
> +
> +:Manual section: 8
> +
> +SYNOPSIS
> +========
> +
> +	**bpftool** [*OPTIONS*] **iter** *COMMAND*
> +
> +	*COMMANDS* := { **pin** | **help** }
> +
> +STRUCT_OPS COMMANDS

s/STRUCT_OPS/ITER/

> +===================
> +
> +|	**bpftool** **iter pin** *OBJ* *PATH*
> +|	**bpftool** **struct_ops help**

s/struct_ops/iter/

> +|
> +|	*OBJ* := /a/file/of/bpf_iter_target.o
> +
> +
> +DESCRIPTION
> +===========
> +	**bpftool iter pin** *OBJ* *PATH*

Would be great to have a small blurb on what BPF iterators are and what
they can do. I'm afraid users reading this man page will have no idea
whatsoever.

> +		  Create a bpf iterator from *OBJ*, and pin it to
> +		  *PATH*. The *PATH* should be located in *bpffs* mount.

Can you keep the note that other pages have about the dot character
being forbidden in *PATH* basename, please?

> +
> +	**bpftool struct_ops help**

s/struct_ops/iter/

> +		  Print short help message.
> +
> +OPTIONS
> +=======
> +	-h, --help
> +		  Print short generic help message (similar to **bpftool help**).
> +
> +	-V, --version
> +		  Print version number (similar to **bpftool version**).
> +
> +	-d, --debug
> +		  Print all logs available, even debug-level information. This
> +		  includes logs from libbpf as well as from the verifier, when
> +		  attempting to load programs.> +
> +EXAMPLES
> +========
> +**# bpftool iter pin bpf_iter_netlink.o /sys/fs/bpf/my_netlink**
> +
> +::
> +
> +   Create a file-based bpf iterator from bpf_iter_netlink.o and pin it
> +   to /sys/fs/bpf/my_netlink
> +
> +
> +SEE ALSO
> +========
> +	**bpf**\ (2),
> +	**bpf-helpers**\ (7),
> +	**bpftool**\ (8),
> +	**bpftool-prog**\ (8),
> +	**bpftool-map**\ (8),
> +	**bpftool-cgroup**\ (8),
> +	**bpftool-feature**\ (8),
> +	**bpftool-net**\ (8),
> +	**bpftool-perf**\ (8),
> +	**bpftool-btf**\ (8)
> +	**bpftool-gen**\ (8)
> +	**bpftool-struct_ops**\ (8)
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 45ee99b159e2..17a81695da0f 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -604,6 +604,19 @@ _bpftool()
>                      ;;
>              esac
>              ;;
> +        iter)
> +            case $command in
> +                pin)
> +                    _filedir
> +                    return 0
> +                    ;;
> +                *)
> +                    [[ $prev == $object ]] && \
> +                        COMPREPLY=( $( compgen -W 'help' \
> +                            -- "$cur" ) )

You should probably offer "pin" here in addition to "help".

> +                    ;;
> +            esac
> +            ;;
>          map)
>              local MAP_TYPE='id pinned name'
>              case $command in
> diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
> new file mode 100644
> index 000000000000..db9fae6be716
> --- /dev/null
> +++ b/tools/bpf/bpftool/iter.c
> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +// Copyright (C) 2020 Facebook
> +
> +#define _GNU_SOURCE
> +#include <linux/err.h>
> +#include <bpf/libbpf.h>
> +
> +#include "main.h"
> +
> +static int do_pin(int argc, char **argv)
> +{
> +	const char *objfile, *path;
> +	struct bpf_program *prog;
> +	struct bpf_object *obj;
> +	struct bpf_link *link;
> +	int err;

Nit: initialise err t0 -1 do you don't have to set it three times below?

> +
> +	if (!REQ_ARGS(2))
> +		usage();
> +
> +	objfile = GET_ARG();
> +	path = GET_ARG();
> +
> +	obj = bpf_object__open(objfile);
> +	if (IS_ERR_OR_NULL(obj)) {
> +		p_err("can't open objfile %s", objfile);
> +		return -1;
> +	}
> +
> +	err = bpf_object__load(obj);
> +	if (err < 0) {
> +		err = -1;
> +		p_err("can't load objfile %s", objfile);
> +		goto close_obj;
> +	}
> +
> +	prog = bpf_program__next(NULL, obj);
> +	link = bpf_program__attach_iter(prog, NULL);
> +	if (IS_ERR(link)) {
> +		err = -1;
> +		p_err("attach_iter failed for program %s",
> +		      bpf_program__name(prog));
> +		goto close_obj;
> +	}
> +
> +	err = bpf_link__pin(link, path);

Try to mount bpffs before that if "-n" is not passed? You could even
call do_pin_any() from common.c by passing bpf_link__fd().

> +	if (err) {
> +		err = -1;
> +		p_err("pin_iter failed for program %s to path %s",
> +		      bpf_program__name(prog), path);
> +		goto close_link;
> +	}
> +
> +	err = 0;
> +
> +close_link:
> +	bpf_link__disconnect(link);
> +	bpf_link__destroy(link);
> +close_obj:
> +	bpf_object__close(obj);
> +	return err;
> +}
> +
> +static int do_help(int argc, char **argv)
> +{
> +	fprintf(stderr,
> +		"Usage: %s %s pin OBJ PATH\n"
> +		"       %s %s help\n"
> +		"\n",
> +		bin_name, argv[-2], bin_name, argv[-2]);
> +
> +	return 0;
> +}
> +
> +static const struct cmd cmds[] = {
> +	{ "help",	do_help },
> +	{ "pin",	do_pin },
> +	{ 0 }
> +};
> +
> +int do_iter(int argc, char **argv)
> +{
> +	return cmd_select(cmds, argc, argv, do_help);
> +}
> dif	"",
>  		bin_name, bin_name, bin_name);
> @@ -222,6 +222,7 @@ static const struct cmd cmds[] = {
>  	{ "btf",	do_btf },
>  	{ "gen",	do_gen },
>  	{ "struct_ops",	do_struct_ops },
> +	{ "iter",	do_iter },
>  	{ "version",	do_version },
>  	{ 0 }
>  };
> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
> index 86f14ce26fd7..2b5d4a616b48 100644
> --- a/tools/bpf/bpftool/main.h
> +++ b/tools/bpf/bpftool/main.h
> @@ -162,6 +162,7 @@ int do_feature(int argc, char **argv);
>  int do_btf(int argc, char **argv);
>  int do_gen(int argc, char **argv);
>  int do_struct_ops(int argc, char **argv);
> +int do_iter(int argc, char **argv);
>  
>  int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what);
>  int prog_parse_fd(int *argc, char ***argv);
> f --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 466c269eabdd..6805b77789cb 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -58,7 +58,7 @@ static int do_help(int argc, char **argv)
>  		"       %s batch file FILE\n"
>  		"       %s version\n"
>  		"\n"
> -		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf | gen | struct_ops }\n"
> +		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf | gen | struct_ops | iter }\n"
>  		"       " HELP_SPEC_OPTIONS "\n"
>  		"",
>  		bin_name, bin_name, bin_name);
> @@ -222,6 +222,7 @@ static const struct cmd cmds[] = {
>  	{ "btf",	do_btf },
>  	{ "gen",	do_gen },
>  	{ "struct_ops",	do_struct_ops },
> +	{ "iter",	do_iter },
>  	{ "version",	do_version },
>  	{ 0 }
>  };
> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
> index 86f14ce26fd7..2b5d4a616b48 100644
> --- a/tools/bpf/bpftool/main.h
> +++ b/tools/bpf/bpftool/main.h
> @@ -162,6 +162,7 @@ int do_feature(int argc, char **argv);
>  int do_btf(int argc, char **argv);
>  int do_gen(int argc, char **argv);
>  int do_struct_ops(int argc, char **argv);
> +int do_iter(int argc, char **argv);
>  
>  int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what);
>  int prog_parse_fd(int *argc, char ***argv);
> 

Have you considered simply adapting the more traditional workflow
"bpftool prog load && bpftool prog attach" so that it supports iterators
instead of adding a new command? It would:

- Avoid adding yet another bpftool command with a single subcommand

- Enable to reuse the code from prog load, in particular for map reuse
(I'm not sure how relevant maps are for iterators, but I wouldn't be
surprised if someone finds a use case at some point?)

- Avoid users naively trying to run "bpftool prog load && bpftool prog
attach <prog> iter" and not understanding why it fails

Quentin
