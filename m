Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDBC26D0DF
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 03:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIQBxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 21:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgIQBw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 21:52:59 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAAAC061788;
        Wed, 16 Sep 2020 18:45:35 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kk9so396672pjb.2;
        Wed, 16 Sep 2020 18:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f1ujIlZfJx1MF5roPfS1vMusATPLX/OooYX91o74lxI=;
        b=gG1OJ4MOy/uMUTrIEqpo0VaA5mWsCZ+MfnJX+gJR2jlouI0SfqYPEcPgncwK58pSkZ
         EwBXeKjwGQjteix3bnp000a/Ndty/G0nOfMpzRCyGGueWrkb1/t0LdKlgkAvdXsPUhJP
         MXxW3yBw9qsV1P9qrhLGBheORNtlnsq/FGJOByEn8RX3dCzx7dm+D2fO/ZqjBMFEQ2pG
         umcEr82kbNgUk32p+vYhj5Tl6XOvmDPxygCrvh+vmv2AV3H+B5u6ic+yAHOAaisch9Xt
         E8nFHBS4b/uwZOQthe6dHyakdbgiJjpRdMg7XuRgS01/C+rfXXs3sacFk6Lhmfe6XtY9
         DRlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f1ujIlZfJx1MF5roPfS1vMusATPLX/OooYX91o74lxI=;
        b=b3OQTkmiOwQsFxNi1/8UlXeH1V8rTFcwy/RZT3v+csXJCkZGRJxHRe4DonFGzs33Lw
         c7uAJIoFRYGLeRmboECXafgsoC2OQloM9SfpK/hcqpcDJPkx72W+DTFFvYsB3R6f+q+7
         2q56ns28nkAzTmN2lGqK9dFqbAB1jTjKT8+/Tj04OYQKfTPLFFSGXElqY02Fq3TQmGCO
         8c3KCgQNCLxdM8h6yTNJH+qebruWXBcOYFpu70k/itIQJL1s5SE+2BbyeyKi9t/P6kNa
         mAr8ihAWs8bhkhbOXIWMPJB4wrzoUii17Ujb7NJ2vaF+PpOjQqjlmeCmlxDSU6QwkKsv
         4jkg==
X-Gm-Message-State: AOAM531+JfDlJtyCnBYULwY3kLJEeD8/3R46KnDuu4ONXau5lUUvKedy
        l3Q2811UKSZ0ak2J3NJS5HQ=
X-Google-Smtp-Source: ABdhPJyOJOcjcVegKHemb28vLWxRdmLtsPlAmSK5iclWaCMqhP7JMlrizxz2TlqcQRP51FYe86nnjg==
X-Received: by 2002:a17:90b:1050:: with SMTP id gq16mr6634564pjb.234.1600307135238;
        Wed, 16 Sep 2020 18:45:35 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:821d])
        by smtp.gmail.com with ESMTPSA id a13sm16600176pfi.139.2020.09.16.18.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 18:45:34 -0700 (PDT)
Date:   Wed, 16 Sep 2020 18:45:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix stat probe in d_path test
Message-ID: <20200917014531.lmpkorybofrggte4@ast-mbp.dhcp.thefacebook.com>
References: <20200916112416.2321204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916112416.2321204-1-jolsa@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 01:24:16PM +0200, Jiri Olsa wrote:
> Some kernels builds might inline vfs_getattr call within fstat
> syscall code path, so fentry/vfs_getattr trampoline is not called.
> 
> Alexei suggested [1] we should use security_inode_getattr instead,
> because it's less likely to get inlined.
> 
> Adding security_inode_getattr to the d_path allowed list and
> switching the stat trampoline to security_inode_getattr.
> 
> Adding flags that indicate trampolines were called and failing
> the test if any of them got missed, so it's easier to identify
> the issue next time.
> 
> [1] https://lore.kernel.org/bpf/CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com/
> Fixes: e4d1af4b16f8 ("selftests/bpf: Add test for d_path helper")
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/bpf_trace.c                        | 1 +
>  tools/testing/selftests/bpf/prog_tests/d_path.c | 6 ++++++
>  tools/testing/selftests/bpf/progs/test_d_path.c | 9 ++++++++-
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index b2a5380eb187..1001c053ebb3 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1122,6 +1122,7 @@ BTF_ID(func, vfs_truncate)
>  BTF_ID(func, vfs_fallocate)
>  BTF_ID(func, dentry_open)
>  BTF_ID(func, vfs_getattr)
> +BTF_ID(func, security_inode_getattr)
>  BTF_ID(func, filp_close)
>  BTF_SET_END(btf_allowlist_d_path)

I think it's concealing the problem instead of fixing it.
bpf is difficult to use for many reasons. Let's not make it harder.
The users will have a very hard time debugging why vfs_getattr bpf probe
is not called in all cases.
Let's replace:
vfs_truncate -> security_path_truncate
vfs_fallocate -> security_file_permission
vfs_getattr -> security_inode_getattr

For dentry_open also add security_file_open.
dentry_open and filp_close are in its own files,
so unlikely to be inlined.
Ideally resolve_btfids would parse dwarf info and check
whether any of the funcs in allowlist were inlined.
That would be more reliable, but not pretty to drag libdw
dependency into resolve_btfids.

>  
> diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
> index fc12e0d445ff..f507f1a6fa3a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/d_path.c
> +++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
> @@ -120,6 +120,12 @@ void test_d_path(void)
>  	if (err < 0)
>  		goto cleanup;
>  
> +	if (CHECK(!bss->called_stat || !bss->called_close,

+1 to KP's comment.

> +		  "check",
> +		  "failed to call trampolines called_stat %d, bss->called_close %d\n",
> +		   bss->called_stat, bss->called_close))
> +		goto cleanup;
