Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCF6529DA1
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbiEQJNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243998AbiEQJMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:12:54 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D528639E;
        Tue, 17 May 2022 02:12:52 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id s3so6369794edr.9;
        Tue, 17 May 2022 02:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=krprm27rZ7iPBdo6XYTUP4wdNhee1KynZMic612/ZrY=;
        b=MWAeWZpS8cfoTVdcyZxBXKRbq7drUp8r9kHb7b8Im/3e4UoBgtoo9MLHBTJyUT/H/9
         pJVQL2yCClxYbt2qEEzyUXy1MZWg9mGuYzuaSSekxV8fQ5DcSXqt083A19IjKwOjPUFn
         FhgVsAlsr6PqRsL8VjYnpET7JZZLQZCpTUjralaXzutM2Ohy5XkHp+/nqC4n9YBZnuiL
         aKBtoA4BaRqGch9/Cu+DTAfs3ExXjMSuYxfNusMwx2u+KZVHP7DVP2+flqzJTXw+LUzt
         NE7bIlcZAZ79obRDAtqBW+3s7GVzDWzztrghd6tLsFSP4foAu6Xoa4miXuPqcLnBJkTE
         jPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=krprm27rZ7iPBdo6XYTUP4wdNhee1KynZMic612/ZrY=;
        b=vkfe/fyJVmiDWAjhkvi1SOz01L3e0O9Pie7GmzLHolKvNI0/jd30PlP4Ryf/le43f+
         xfQDoBkiygrSJpJxUmjEloSl+lcBqlEei7QxhnLq8U5JaWirR8r+R8m04huR+wAbnOjv
         0UECsHLXoUuProoNwrzXm7aXzviTOttF4r0tOzYFuMal42deUwSha/QwChvpIATs9ZpC
         ywhy/sWe7D49aemIvLXZJjsfgFvvmmWDdadrBsDviEbCIIp8fTXbf1Ll+ZHHCMqspyB7
         i2t8FHeOJIuYP5rgEHO/8CD3fQcen1K5M6x3v8YqRfFo7JAIxJ0Jy1ij74sTxEGLsrs0
         ss6g==
X-Gm-Message-State: AOAM531IGt1mCxiA+JjPcJdS3OF/RnsGtKfHynCW67uCvZ0L9bfdg7z7
        PuU8f0FWrJUaZvuv7mKdprs=
X-Google-Smtp-Source: ABdhPJwpThp1cKc/xIOSk/nz0wlLVUBEBQQL/OCVjwBPraumJ6Qa7ntNAQY89o0CHuAKvaio9H8Dpw==
X-Received: by 2002:a05:6402:1941:b0:413:2555:53e3 with SMTP id f1-20020a056402194100b00413255553e3mr18035453edz.164.1652778770555;
        Tue, 17 May 2022 02:12:50 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id g25-20020a056402115900b0042aaacd4edasm3844208edw.26.2022.05.17.02.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 02:12:50 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 17 May 2022 11:12:47 +0200
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
Subject: Re: [PATCH bpf-next v3 2/4] bpf_trace: support 32-bit kernels in
 bpf_kprobe_multi_link_attach
Message-ID: <YoNnD1K/v6sF5YiV@krava>
References: <cover.1652772731.git.esyr@redhat.com>
 <525b99881dc144b986e381eb23b12617a311f243.1652772731.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525b99881dc144b986e381eb23b12617a311f243.1652772731.git.esyr@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 09:36:26AM +0200, Eugene Syromiatnikov wrote:
> It seems that there is no reason not to support 32-bit architectures;
> doing so requires a bit of rework with respect to cookies handling,
> however, as the current code implicitly assumes
> that sizeof(long) == sizeof(u64).
> 
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>  kernel/trace/bpf_trace.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 9c041be..a93a54f 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2435,16 +2435,12 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  	struct bpf_link_primer link_primer;
>  	void __user *ucookies;
>  	unsigned long *addrs;
> -	u32 flags, cnt, size;
> +	u32 flags, cnt, size, cookies_size;
>  	void __user *uaddrs;
>  	u64 *cookies = NULL;
>  	void __user *usyms;
>  	int err;
>  
> -	/* no support for 32bit archs yet */
> -	if (sizeof(u64) != sizeof(void *))
> -		return -EOPNOTSUPP;
> -
>  	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
>  		return -EINVAL;
>  
> @@ -2454,6 +2450,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  
>  	uaddrs = u64_to_user_ptr(attr->link_create.kprobe_multi.addrs);
>  	usyms = u64_to_user_ptr(attr->link_create.kprobe_multi.syms);
> +	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
>  	if (!!uaddrs == !!usyms)
>  		return -EINVAL;
>  
> @@ -2461,8 +2458,11 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  	if (!cnt)
>  		return -EINVAL;
>  
> -	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
> +	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size) ||
> +	    (ucookies &&
> +	     check_mul_overflow(cnt, (u32)sizeof(*cookies), &cookies_size))) {
>  		return -EOVERFLOW;
> +	}
>  	addrs = kvmalloc(size, GFP_KERNEL);
>  	if (!addrs)
>  		return -ENOMEM;
> @@ -2486,14 +2486,13 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  			goto error;
>  	}
>  
> -	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
>  	if (ucookies) {

could we check all that in here? so the ucookies checks are on the
one place.. also you would not need cookies_size

jirka

> -		cookies = kvmalloc(size, GFP_KERNEL);
> +		cookies = kvmalloc(cookies_size, GFP_KERNEL);
>  		if (!cookies) {
>  			err = -ENOMEM;
>  			goto error;
>  		}
> -		if (copy_from_user(cookies, ucookies, size)) {
> +		if (copy_from_user(cookies, ucookies, cookies_size)) {
>  			err = -EFAULT;
>  			goto error;
>  		}
> -- 
> 2.1.4
> 
