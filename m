Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF284FA01B
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239516AbiDHX2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238498AbiDHX2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:28:19 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C490939806;
        Fri,  8 Apr 2022 16:26:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 125so8988363pgc.11;
        Fri, 08 Apr 2022 16:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bAn4o9K7th6YNdjZZg5AiEUK5FCDSAqo7SuixrDUegY=;
        b=kF3rv9X6MlF+qIl1N2j+adVo4f7+BCYIDJb16YzNVUAFPfnzWZRjNLG5GHnXfaKV5a
         rDE3Rmff0JZz/JEZToF0z5OO9SZMX+XTlKsTo07Tujct+1YVoKDh2Yb+zyWGuOGdLoK/
         acUuYxdFx6/hF1jQ5lWsLc1xedwWmIC8dbjclo5TFihND4eel0U61tE444aQ+Xeiet7U
         oc6HPxPrSqLqplXVqW+5T9ZKTQNBkPMBsQPdyeklJlxAveiShut0mqhrp2cE2b+QcfPP
         Px4w2ekfQ31jM43YPBTs/RJAzpROvS2asJoymER9byzTygmAd23sBCE9fvx+VQCr0kST
         Lx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bAn4o9K7th6YNdjZZg5AiEUK5FCDSAqo7SuixrDUegY=;
        b=kFfkVsQuQb4DlNCaVUvcBMI6yKud8hUTdKY5z8wN6jhlR0kZCayRXPIInm686BNhEc
         1GvGWvDstRpR4dYOYHuLUjZnglX8PweN+EDIQSlqzkUyB7f0tpQ+WhUUcyzeasjXJxCy
         xJnkjU8TY83fRspsFhaPVX2yzsIfj9TTms4bJSgSKggK/SjnHVdnaWUk6keXIjWVJpNm
         YZu7eFdmRAq4so9pH2CXQtTmCHlhfriTUldI7uAquvBr3KtKFNk2XEhO+4epzfMA7adN
         Qf8T3AnX8bsoti/0GfqF8Sm+uqIo94p98CFyONnVqr1wbe45n86HwZLWgiI4DDnldNzz
         rfZw==
X-Gm-Message-State: AOAM531tE3AgnDA1WyI6W0gOXMr2TCpubKcr73q4Y0CRokbSlhV8Sscr
        7UCOFkrIHRmIcVHF46ubOR0knmcr3w4=
X-Google-Smtp-Source: ABdhPJwyXjc1Y+e5Ukw9aUInFSD53R83gWEYSJ1K/EMEyoQ4NNWONXQaDFlJO2IAbjSE1DTITduebw==
X-Received: by 2002:a63:6c4a:0:b0:398:604b:7263 with SMTP id h71-20020a636c4a000000b00398604b7263mr17516083pgc.545.1649460374155;
        Fri, 08 Apr 2022 16:26:14 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::5:4c4c])
        by smtp.gmail.com with ESMTPSA id e10-20020a17090a630a00b001c685cfd9d1sm12779494pjj.20.2022.04.08.16.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 16:26:13 -0700 (PDT)
Date:   Fri, 8 Apr 2022 16:26:10 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 3/4] bpf: Resolve symbols with
 kallsyms_lookup_names for kprobe multi link
Message-ID: <20220408232610.nwtcuectacpwh6rk@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220407125224.310255-4-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407125224.310255-4-jolsa@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 02:52:23PM +0200, Jiri Olsa wrote:
> Using kallsyms_lookup_names function to speed up symbols lookup in
> kprobe multi link attachment and replacing with it the current
> kprobe_multi_resolve_syms function.
> 
> This speeds up bpftrace kprobe attachment:
> 
>   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
>   ...
>   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> 
> After:
> 
>   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
>   ...
>   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/trace/bpf_trace.c | 123 +++++++++++++++++++++++----------------
>  1 file changed, 73 insertions(+), 50 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index b26f3da943de..2602957225ba 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2226,6 +2226,72 @@ struct bpf_kprobe_multi_run_ctx {
>  	unsigned long entry_ip;
>  };
>  
> +struct user_syms {
> +	const char **syms;
> +	char *buf;
> +};
> +
> +static int copy_user_syms(struct user_syms *us, void __user *usyms, u32 cnt)
> +{
> +	const char __user **usyms_copy = NULL;
> +	const char **syms = NULL;
> +	char *buf = NULL, *p;
> +	int err = -EFAULT;
> +	unsigned int i;
> +	size_t size;
> +
> +	size = cnt * sizeof(*usyms_copy);
> +
> +	usyms_copy = kvmalloc(size, GFP_KERNEL);
> +	if (!usyms_copy)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(usyms_copy, usyms, size))
> +		goto error;
> +
> +	err = -ENOMEM;
> +	syms = kvmalloc(size, GFP_KERNEL);
> +	if (!syms)
> +		goto error;
> +
> +	/* TODO this potentially allocates lot of memory (~6MB in my tests
> +	 * with attaching ~40k functions). I haven't seen this to fail yet,
> +	 * but it could be changed to allocate memory gradually if needed.
> +	 */

Why would 6MB kvmalloc fail?
If we don't have such memory the kernel will be ooming soon anyway.
I don't think we'll see this kvmalloc triggering oom in practice.
The verifier allocates a lot more memory to check large programs.

imo this approach is fine. It's simple.
Trying to do gradual alloc with realloc would be just guessing.

Another option would be to ask user space (libbpf) to do the sort.
There are pros and cons.
This vmalloc+sort is slightly better imo.

> +	size = cnt * KSYM_NAME_LEN;
> +	buf = kvmalloc(size, GFP_KERNEL);
> +	if (!buf)
> +		goto error;
> +
> +	for (p = buf, i = 0; i < cnt; i++) {
> +		err = strncpy_from_user(p, usyms_copy[i], KSYM_NAME_LEN);
> +		if (err == KSYM_NAME_LEN)
> +			err = -E2BIG;
> +		if (err < 0)
> +			goto error;
> +		syms[i] = p;
> +		p += err + 1;
> +	}
> +
> +	err = 0;
> +	us->syms = syms;
> +	us->buf = buf;
> +
> +error:
> +	kvfree(usyms_copy);
> +	if (err) {
> +		kvfree(syms);
> +		kvfree(buf);
> +	}
> +	return err;
> +}
> +
> +static void free_user_syms(struct user_syms *us)
> +{
> +	kvfree(us->syms);
> +	kvfree(us->buf);
> +}
> +
>  static void bpf_kprobe_multi_link_release(struct bpf_link *link)
>  {
>  	struct bpf_kprobe_multi_link *kmulti_link;
> @@ -2346,55 +2412,6 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
>  	kprobe_multi_link_prog_run(link, entry_ip, regs);
>  }
>  
> -static int
> -kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
> -			  unsigned long *addrs)
> -{
> -	unsigned long addr, size;
> -	const char __user **syms;
> -	int err = -ENOMEM;
> -	unsigned int i;
> -	char *func;
> -
> -	size = cnt * sizeof(*syms);
> -	syms = kvzalloc(size, GFP_KERNEL);
> -	if (!syms)
> -		return -ENOMEM;
> -
> -	func = kmalloc(KSYM_NAME_LEN, GFP_KERNEL);
> -	if (!func)
> -		goto error;
> -
> -	if (copy_from_user(syms, usyms, size)) {
> -		err = -EFAULT;
> -		goto error;
> -	}
> -
> -	for (i = 0; i < cnt; i++) {
> -		err = strncpy_from_user(func, syms[i], KSYM_NAME_LEN);
> -		if (err == KSYM_NAME_LEN)
> -			err = -E2BIG;
> -		if (err < 0)
> -			goto error;
> -		err = -EINVAL;
> -		addr = kallsyms_lookup_name(func);
> -		if (!addr)
> -			goto error;
> -		if (!kallsyms_lookup_size_offset(addr, &size, NULL))
> -			goto error;
> -		addr = ftrace_location_range(addr, addr + size - 1);
> -		if (!addr)
> -			goto error;
> -		addrs[i] = addr;
> -	}
> -
> -	err = 0;
> -error:
> -	kvfree(syms);
> -	kfree(func);
> -	return err;
> -}
> -
>  int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>  {
>  	struct bpf_kprobe_multi_link *link = NULL;
> @@ -2438,7 +2455,13 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  			goto error;
>  		}
>  	} else {
> -		err = kprobe_multi_resolve_syms(usyms, cnt, addrs);
> +		struct user_syms us;
> +
> +		err = copy_user_syms(&us, usyms, cnt);
> +		if (err)
> +			goto error;
> +		err = kallsyms_lookup_names(us.syms, cnt, addrs);
> +		free_user_syms(&us);
>  		if (err)
>  			goto error;
>  	}
> -- 
> 2.35.1
> 
