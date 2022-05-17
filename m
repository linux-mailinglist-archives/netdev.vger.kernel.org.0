Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23EA529D98
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242195AbiEQJMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236928AbiEQJMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:12:40 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6E83057B;
        Tue, 17 May 2022 02:12:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dk23so33408865ejb.8;
        Tue, 17 May 2022 02:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BgDU9fhsQSG+UfnfYe18eXVUWeFGjRtFkW3QUNM2fOY=;
        b=dguU8/P7nfzqHVCkIZrjMnamO9AalalQQpGrXwoRfTvufVscFRjDtp5DvjoPZ/uwpf
         Yj8nH/V0sPei8GfdEnedeCeLfh7gYGJ8ghSMxDtVBXp5RD+WnUQvO1D0B0xC9/Th9MXY
         yFn8UG4SW49GOSVSzl2jhVqjLSzwxikAcMbikqSWsQPqd/Cm4x4Fn86hvCY++CZRLmcM
         pxRUfUTSfbHirhWHZCeKmWlkMD5pS8pVjFC8VVSzVaNQ80+LW1MKZ1gBHgYg03f1y3dU
         FPfhM4saA7a3wXTMbumzr72ypZXG0bnI0Mmj5c4w+B84Xnx3Q4bubZUISS5gtbcMql5e
         3/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BgDU9fhsQSG+UfnfYe18eXVUWeFGjRtFkW3QUNM2fOY=;
        b=fH8+jDnteQIKjTeFmnibA/+aC62srAHzXEU/GXukU8VPNAC8QzrvWutNRj1As+v17J
         XJpScZCkssuXY0IMztYYnPnJJBD7OaO4ZfemhK3qpjYgViE5BG+5Hp6KQNuyNGU5yzrc
         oHM+ZoS7kF3X2JIswH5sSc84HMKHIAVvwkb6+exllIvVdlgoLtFV/30Gh38yAFcqBvPl
         1CgkeV14NYcmfMpJ/4kWiz7fNaxoXPVY5SjJ/2fgzQ4dfPzwHDvSwr9TmDIXguDvLZkt
         VDV+HZTouNMfOEPPmUAif8Zu0KIwAKN1h70i/P8CEg8HZzUwLr/DFrXha5ZnWi6ZeGHi
         LYZg==
X-Gm-Message-State: AOAM531LGfIferzZgTyg96rz8hCkVASq0ONLaCG7hTamve5KBUK1bGPW
        oSWF7Rvrgoh04KdJL3WOUOc=
X-Google-Smtp-Source: ABdhPJxKUMYwTEXN3NpfSfOr/9/MQXA3sElAQirl1mIYM14YxBChhAMaXIh1pSAVBPw+HDbRGkzuhg==
X-Received: by 2002:a17:906:8585:b0:6f3:99f0:d061 with SMTP id v5-20020a170906858500b006f399f0d061mr18421335ejx.436.1652778756914;
        Tue, 17 May 2022 02:12:36 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id x12-20020aa7cd8c000000b0042aa08c7799sm4589479edv.62.2022.05.17.02.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 02:12:36 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 17 May 2022 11:12:34 +0200
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 4/4] bpf_trace: pass array of u64 values in
 kprobe_multi.addrs
Message-ID: <YoNnAgDsIWef82is@krava>
References: <cover.1652772731.git.esyr@redhat.com>
 <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 09:36:47AM +0200, Eugene Syromiatnikov wrote:
> With the interface as defined, it is impossible to pass 64-bit kernel
> addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
> which severly limits the useability of the interface, change the ABI
> to accept an array of u64 values instead of (kernel? user?) longs.
> Interestingly, the rest of the libbpf infrastructure uses 64-bit values
> for kallsyms addresses already, so this patch also eliminates
> the sym_addr cast in tools/lib/bpf/libbpf.c:resolve_kprobe_multi_cb().

so the problem is when we have 32bit user sace on 64bit kernel right?

I think we should keep addrs as longs in uapi and have kernel to figure out
if it needs to read u32 or u64, like you did for symbols in previous patch

we'll need to fix also bpf_kprobe_multi_cookie_swap because it assumes
64bit user space pointers

would be gret if we could have selftest for this

thanks,
jirka

> 
> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Fixes: 5117c26e877352bc ("libbpf: Add bpf_link_create support for multi kprobes")
> Fixes: ddc6b04989eb0993 ("libbpf: Add bpf_program__attach_kprobe_multi_opts function")
> Fixes: f7a11eeccb111854 ("selftests/bpf: Add kprobe_multi attach test")
> Fixes: 9271a0c7ae7a9147 ("selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts")
> Fixes: 2c6401c966ae1fbe ("selftests/bpf: Add kprobe_multi bpf_cookie test")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>  kernel/trace/bpf_trace.c                           | 25 ++++++++++++++++++----
>  tools/lib/bpf/bpf.h                                |  2 +-
>  tools/lib/bpf/libbpf.c                             |  8 +++----
>  tools/lib/bpf/libbpf.h                             |  2 +-
>  .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  2 +-
>  .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  8 +++----
>  6 files changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 9d3028a..30a15b3 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2454,7 +2454,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  	void __user *ucookies;
>  	unsigned long *addrs;
>  	u32 flags, cnt, size, cookies_size;
> -	void __user *uaddrs;
> +	u64 __user *uaddrs;
>  	u64 *cookies = NULL;
>  	void __user *usyms;
>  	int err;
> @@ -2486,9 +2486,26 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  		return -ENOMEM;
>  
>  	if (uaddrs) {
> -		if (copy_from_user(addrs, uaddrs, size)) {
> -			err = -EFAULT;
> -			goto error;
> +		if (sizeof(*addrs) == sizeof(*uaddrs)) {
> +			if (copy_from_user(addrs, uaddrs, size)) {
> +				err = -EFAULT;
> +				goto error;
> +			}
> +		} else {
> +			u32 i;
> +			u64 addr;
> +
> +			for (i = 0; i < cnt; i++) {
> +				if (get_user(addr, uaddrs + i)) {
> +					err = -EFAULT;
> +					goto error;
> +				}
> +				if (addr > ULONG_MAX) {
> +					err = -EINVAL;
> +					goto error;
> +				}
> +				addrs[i] = addr;
> +			}
>  		}
>  	} else {
>  		struct user_syms us;
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 2e0d373..da9c6037 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -418,7 +418,7 @@ struct bpf_link_create_opts {
>  			__u32 flags;
>  			__u32 cnt;
>  			const char **syms;
> -			const unsigned long *addrs;
> +			const __u64 *addrs;
>  			const __u64 *cookies;
>  		} kprobe_multi;
>  		struct {
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ef7f302..35fa9c5 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10737,7 +10737,7 @@ static bool glob_match(const char *str, const char *pat)
>  
>  struct kprobe_multi_resolve {
>  	const char *pattern;
> -	unsigned long *addrs;
> +	__u64 *addrs;
>  	size_t cap;
>  	size_t cnt;
>  };
> @@ -10752,12 +10752,12 @@ resolve_kprobe_multi_cb(unsigned long long sym_addr, char sym_type,
>  	if (!glob_match(sym_name, res->pattern))
>  		return 0;
>  
> -	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(unsigned long),
> +	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(__u64),
>  				res->cnt + 1);
>  	if (err)
>  		return err;
>  
> -	res->addrs[res->cnt++] = (unsigned long) sym_addr;
> +	res->addrs[res->cnt++] = sym_addr;
>  	return 0;
>  }
>  
> @@ -10772,7 +10772,7 @@ bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
>  	};
>  	struct bpf_link *link = NULL;
>  	char errmsg[STRERR_BUFSIZE];
> -	const unsigned long *addrs;
> +	const __u64 *addrs;
>  	int err, link_fd, prog_fd;
>  	const __u64 *cookies;
>  	const char **syms;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 9e9a3fd..76e171d 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -489,7 +489,7 @@ struct bpf_kprobe_multi_opts {
>  	/* array of function symbols to attach */
>  	const char **syms;
>  	/* array of function addresses to attach */
> -	const unsigned long *addrs;
> +	const __u64 *addrs;
>  	/* array of user-provided values fetchable through bpf_get_attach_cookie */
>  	const __u64 *cookies;
>  	/* number of elements in syms/addrs/cookies arrays */
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> index 83ef55e3..e843840 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> @@ -140,7 +140,7 @@ static void kprobe_multi_link_api_subtest(void)
>  	cookies[6] = 7;
>  	cookies[7] = 8;
>  
> -	opts.kprobe_multi.addrs = (const unsigned long *) &addrs;
> +	opts.kprobe_multi.addrs = (const __u64 *) &addrs;
>  	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
>  	opts.kprobe_multi.cookies = (const __u64 *) &cookies;
>  	prog_fd = bpf_program__fd(skel->progs.test_kprobe);
> diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> index 586dc52..7646112 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> @@ -108,7 +108,7 @@ static void test_link_api_addrs(void)
>  	GET_ADDR("bpf_fentry_test7", addrs[6]);
>  	GET_ADDR("bpf_fentry_test8", addrs[7]);
>  
> -	opts.kprobe_multi.addrs = (const unsigned long*) addrs;
> +	opts.kprobe_multi.addrs = (const __u64 *) addrs;
>  	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
>  	test_link_api(&opts);
>  }
> @@ -186,7 +186,7 @@ static void test_attach_api_addrs(void)
>  	GET_ADDR("bpf_fentry_test7", addrs[6]);
>  	GET_ADDR("bpf_fentry_test8", addrs[7]);
>  
> -	opts.addrs = (const unsigned long *) addrs;
> +	opts.addrs = (const __u64 *) addrs;
>  	opts.cnt = ARRAY_SIZE(addrs);
>  	test_attach_api(NULL, &opts);
>  }
> @@ -244,7 +244,7 @@ static void test_attach_api_fails(void)
>  		goto cleanup;
>  
>  	/* fail_2 - both addrs and syms set */
> -	opts.addrs = (const unsigned long *) addrs;
> +	opts.addrs = (const __u64 *) addrs;
>  	opts.syms = syms;
>  	opts.cnt = ARRAY_SIZE(syms);
>  	opts.cookies = NULL;
> @@ -258,7 +258,7 @@ static void test_attach_api_fails(void)
>  		goto cleanup;
>  
>  	/* fail_3 - pattern and addrs set */
> -	opts.addrs = (const unsigned long *) addrs;
> +	opts.addrs = (const __u64 *) addrs;
>  	opts.syms = NULL;
>  	opts.cnt = ARRAY_SIZE(syms);
>  	opts.cookies = NULL;
> -- 
> 2.1.4
> 
