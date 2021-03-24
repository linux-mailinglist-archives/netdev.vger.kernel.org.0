Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA853346E9E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhCXBWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbhCXBWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:22:40 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A763DC061763;
        Tue, 23 Mar 2021 18:22:40 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l1so13524487pgb.5;
        Tue, 23 Mar 2021 18:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ADszsJaW4d0lhPtJTdxVvedwy5zTVymuRYgLJjqUZYs=;
        b=sNpJYd+vI5TDLCjPigF1d04oHMmyaRf5MORj9VcyYMFLmVZs0i/5Y+JIbP9rvprNFf
         tbj+BX0Qq2YJoZ4HPf8eeyT9+hRGInQZyUFilGygIr30kg6hqqDlFXxTr0lCj42KJtd7
         /gHPb/J5zDP4EsSLpEuk95VtG0q3IdIN4AXV0XlXKycwJk1sjP+rjwwqmVx+9TI0SkaF
         ylYMCz9maoias7TQvUr/MtldcxnMHmsHilxrJg555nF78qRWlpGsVoDCgcpRESGi9khu
         s4qlksVY7G6UcetrHWf5ZwD7iJZc0eeYv7Ew2uVPLJ29Hx+KOYvITBWODUG4IH8faf33
         QbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ADszsJaW4d0lhPtJTdxVvedwy5zTVymuRYgLJjqUZYs=;
        b=r+La5UkU8mKs22DZsGBIAozQmqikLPZXFPYy4BBX+0dwKAXOQN3YLwjom1DZeCshIy
         CwTebGi0Y+Scv5ymBtORH0dU769ANgEwjjEThuve9D2hJ/JQyz3v3LQ6N9rPQkydlP2q
         dk8iqIs4CAx+I1tZvJ64pekxu6w3yBeN4mtY7/oeoljl9cl1d0x5wt/T9+ZBMywaLKR/
         oTnNn9hrMM/0U4tqjVQwo6WBUuUq409jsU446zRgFGakcpxBH4cNEjFlNOssCQXM2NbE
         IHQ8rmoWiJnVVrsrC85qMYtO1+vl72Wmb6qEuirRGGLGkUzQnHPzTHBZcxU/1qbUou9Y
         T3Tg==
X-Gm-Message-State: AOAM533PAOYMVu1LLpyq/q8XHaZgsfyr+o5ylKQUHAvsC54YwBZkvVjV
        KBLzUzTkRrWhxa9Zvs27GS8=
X-Google-Smtp-Source: ABdhPJz6NsxW1Ed0pTj3gqatCldwJ6Zts1dE8DTzvjPPAfghQYbQ7fpJHt0DQ7GRLTmDSqdIu/wyeA==
X-Received: by 2002:a65:6559:: with SMTP id a25mr880957pgw.106.1616548960119;
        Tue, 23 Mar 2021 18:22:40 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:7d9f])
        by smtp.gmail.com with ESMTPSA id f15sm366495pgg.84.2021.03.23.18.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:22:39 -0700 (PDT)
Date:   Tue, 23 Mar 2021 18:22:37 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf] bpf: Take module reference for ip in module code
Message-ID: <20210324012237.65pf4s52oqlicea3@ast-mbp>
References: <20210323211533.1931242-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323211533.1931242-1-jolsa@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 10:15:33PM +0100, Jiri Olsa wrote:
> Currently module can be unloaded even if there's a trampoline
> register in it. It's easily reproduced by running in parallel:
> 
>   # while :; do ./test_progs -t module_attach; done
>   # while :; do ./test_progs -t fentry_test; done
> 
> Taking the module reference in case the trampoline's ip is
> within the module code. Releasing it when the trampoline's
> ip is unregistered.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/trampoline.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 1f3a4be4b175..f6cb179842b2 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -87,6 +87,27 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>  	return tr;
>  }
>  
> +static struct module *ip_module_get(unsigned long ip)
> +{
> +	struct module *mod;
> +	int err = 0;
> +
> +	preempt_disable();
> +	mod = __module_text_address(ip);
> +	if (mod && !try_module_get(mod))
> +		err = -ENOENT;
> +	preempt_enable();
> +	return err ? ERR_PTR(err) : mod;
> +}
> +
> +static void ip_module_put(unsigned long ip)
> +{
> +	struct module *mod = __module_text_address(ip);

Conceptually looks correct, but how did you test it?!
Just doing your reproducer:
while :; do ./test_progs -t module_attach; done & while :; do ./test_progs -t fentry_test; done

I immediately hit:
[   19.461162] WARNING: CPU: 1 PID: 232 at kernel/module.c:264 module_assert_mutex_or_preempt+0x2e/0x40
[   19.477126] Call Trace:
[   19.477464]  __module_address+0x28/0xf0
[   19.477865]  ? __bpf_trace_bpf_testmod_test_write_bare+0x10/0x10 [bpf_testmod]
[   19.478711]  __module_text_address+0xe/0x60
[   19.479156]  bpf_trampoline_update+0x2ff/0x470

Which points to an obvious bug above.

How did you debug it to this module going away issue?
Why does test_progs -t fentry_test help to repro?
Or does it?
It doesn't touch anything in modules.

> +
> +	if (mod)
> +		module_put(mod);
