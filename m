Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD3CCEE94
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 23:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfJGVqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 17:46:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41946 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbfJGVqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 17:46:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so3176419pga.8
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 14:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1Fr1LtNudhGWlAd0MmD0Crrk5lYMUHIYaBuz3mFS0Ic=;
        b=tipHBqBd+/RexmtgwqY4+9fDFYbx0A3gV8HQS1uRuERAF8KFGLai/taK6yxuZlaUuV
         KeXIShmAft0ThjrakmVVgL1zOJwdAY0PSQI+pxMl18NTba9nb2qP5kXHIDIAsC5o/AHl
         PnAJqapAxzczWkVvTQeTPXfKsyJSHYqqbCwODD5zpSAExiMjZyTTHOBmrIA94LqsC0lD
         rj6utVdYzLRdKEAFxJ5X4yC3miRo9FOLLvH2Xb4auJWtdk8Hmhm0l3PNR6HrGIEE3BNL
         jtg61tYh1QMmGVukpiTdDsLbWbmtY+Nd//vmEeEJwj1g94t9wREOtbfqwyUVNgm4g8/I
         2yuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Fr1LtNudhGWlAd0MmD0Crrk5lYMUHIYaBuz3mFS0Ic=;
        b=ViFAB4ifv8Ej/J0Ie6nZ6CINz+1SzhaaAYiGCB81ZjN4SrvuwJllyMffozRf/dWjOE
         u9UOWo+i+ucNp0Up4pGHcRZp5x/CSam7fcnS/plHWd7OghGXDgoysSS2ZzV/KhnTjvHF
         nNQiK0pxkrktbecNyxoW83h0v4yNozD19PPzo63XrCystopGLM6K695140EEjvV6MeDV
         eeDpUzxN9oa7nQ/fB/tTZsYq1LNuXuUAig0HCuSdd1yo3GoR0zNQ9aKcdDVbknlGGDN0
         qB0zZAewgzNHwcpzWux+v9s4CNPEJK3miN80IGdDkx/S3/gCTrOiK9z4oQrFYY+xyAQn
         HuXQ==
X-Gm-Message-State: APjAAAUW0HlOaeus3k4+p9U1uoFwXhmGz7HNbkygtnE2FGMOjRvbNVg3
        Ae7aeZ5VUgGthRajGELCFTitQg==
X-Google-Smtp-Source: APXvYqzC1AQ9YEp6jePFfuWpPs7+wQ7RFQmx254SJ9DG+MDazHwKlfSaF3Nk6Hnh59gJEbl088w+Ow==
X-Received: by 2002:a17:90a:c255:: with SMTP id d21mr507413pjx.129.1570484811974;
        Mon, 07 Oct 2019 14:46:51 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id d10sm16978966pfh.8.2019.10.07.14.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 14:46:51 -0700 (PDT)
Date:   Mon, 7 Oct 2019 14:46:50 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, sdf@google.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpftool: fix bpftool build by switching to
 bpf_object__open_file()
Message-ID: <20191007214650.GC2096@mini-arch>
References: <20191007212237.1704211-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007212237.1704211-1-andriin@fb.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/07, Andrii Nakryiko wrote:
> As part of libbpf in 5e61f2707029 ("libbpf: stop enforcing kern_version,
> populate it for users") non-LIBBPF_API __bpf_object__open_xattr() API
> was removed from libbpf.h header. This broke bpftool, which relied on
> that function. This patch fixes the build by switching to newly added
> bpf_object__open_file() which provides the same capabilities, but is
> official and future-proof API.
> 
> Fixes: 5e61f2707029 ("libbpf: stop enforcing kern_version, populate it for users")
> Reported-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/bpf/bpftool/main.c |  4 ++--
>  tools/bpf/bpftool/main.h |  2 +-
>  tools/bpf/bpftool/prog.c | 22 ++++++++++++----------
>  3 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 93d008687020..4764581ff9ea 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -27,7 +27,7 @@ bool json_output;
>  bool show_pinned;
>  bool block_mount;
>  bool verifier_logs;
> -int bpf_flags;
> +bool relaxed_maps;
>  struct pinned_obj_table prog_table;
>  struct pinned_obj_table map_table;
>  
> @@ -396,7 +396,7 @@ int main(int argc, char **argv)
>  			show_pinned = true;
>  			break;
>  		case 'm':
> -			bpf_flags = MAPS_RELAX_COMPAT;
> +			relaxed_maps = true;
>  			break;
>  		case 'n':
>  			block_mount = true;
> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
> index af9ad56c303a..2899095f8254 100644
> --- a/tools/bpf/bpftool/main.h
> +++ b/tools/bpf/bpftool/main.h
> @@ -94,7 +94,7 @@ extern bool json_output;
>  extern bool show_pinned;
>  extern bool block_mount;
>  extern bool verifier_logs;
> -extern int bpf_flags;
> +extern bool relaxed_maps;
>  extern struct pinned_obj_table prog_table;
>  extern struct pinned_obj_table map_table;
>  
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 43fdbbfe41bb..8191cd595963 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1092,9 +1092,7 @@ static int do_run(int argc, char **argv)
>  static int load_with_options(int argc, char **argv, bool first_prog_only)
>  {
>  	struct bpf_object_load_attr load_attr = { 0 };
> -	struct bpf_object_open_attr open_attr = {
> -		.prog_type = BPF_PROG_TYPE_UNSPEC,
> -	};
> +	enum bpf_prog_type prog_type = BPF_PROG_TYPE_UNSPEC;
>  	enum bpf_attach_type expected_attach_type;
>  	struct map_replace *map_replace = NULL;
>  	struct bpf_program *prog = NULL, *pos;
> @@ -1105,11 +1103,16 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>  	const char *pinfile;
>  	unsigned int i, j;
>  	__u32 ifindex = 0;
> +	const char *file;
>  	int idx, err;
>  
> +	LIBBPF_OPTS(bpf_object_open_opts, open_opts,
> +		.relaxed_maps = relaxed_maps,
> +	);
> +
>  	if (!REQ_ARGS(2))
>  		return -1;
> -	open_attr.file = GET_ARG();
> +	file = GET_ARG();
>  	pinfile = GET_ARG();
>  
>  	while (argc) {
> @@ -1118,7 +1121,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>  
>  			NEXT_ARG();
>  
> -			if (open_attr.prog_type != BPF_PROG_TYPE_UNSPEC) {
> +			if (prog_type != BPF_PROG_TYPE_UNSPEC) {
>  				p_err("program type already specified");
>  				goto err_free_reuse_maps;
>  			}
> @@ -1135,8 +1138,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>  			strcat(type, *argv);
>  			strcat(type, "/");
>  
> -			err = libbpf_prog_type_by_name(type,
> -						       &open_attr.prog_type,
> +			err = libbpf_prog_type_by_name(type, &prog_type,
>  						       &expected_attach_type);
>  			free(type);
>  			if (err < 0)
> @@ -1224,16 +1226,16 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>  
>  	set_max_rlimit();
>  
> -	obj = __bpf_object__open_xattr(&open_attr, bpf_flags);
> +	obj = bpf_object__open_file(file, &open_opts);
>  	if (IS_ERR_OR_NULL(obj)) {
>  		p_err("failed to open object file");
>  		goto err_free_reuse_maps;
>  	}
>  
>  	bpf_object__for_each_program(pos, obj) {
> -		enum bpf_prog_type prog_type = open_attr.prog_type;
> +		enum bpf_prog_type prog_type = prog_type;
Are you sure it works that way?

$ cat tmp.c
#include <stdio.h>

int main()
{
	int x = 1;
	printf("outer x=%d\n", x);

	{
		int x = x;
		printf("inner x=%d\n", x);
	}

	return 0;
}

$ gcc tmp.c && ./a.out
outer x=1
inner x=0

Other than that:
Reviewed-by: Stanislav Fomichev <sdf@google.com>

>  
> -		if (open_attr.prog_type == BPF_PROG_TYPE_UNSPEC) {
> +		if (prog_type == BPF_PROG_TYPE_UNSPEC) {
>  			const char *sec_name = bpf_program__title(pos, false);
>  
>  			err = libbpf_prog_type_by_name(sec_name, &prog_type,
> -- 
> 2.17.1
> 
