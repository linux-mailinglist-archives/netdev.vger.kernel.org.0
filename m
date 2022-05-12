Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1FE52532F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356835AbiELRFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356839AbiELRF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:05:29 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA159269EFD;
        Thu, 12 May 2022 10:05:26 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id p4so4906023qtq.12;
        Thu, 12 May 2022 10:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+6B2p5x2MsdiGQqOHTdj/jEV/QOhWbmjHIG+C1y2HyI=;
        b=HVddJcFC1vwFoH8Vz9W+YE8WP8SAZuUOcUt9Ej4BteJZh6FgiF99kmT/9ZYBL+usw1
         qiib83DDdL3aaBc1OxTZz+gS8aZ9qYwWiW1KNbxaKdkB/MXSUYFvxRPawj61yo1s/iC3
         sluENUT3lt3xWc2IrBI8zHt+VBLFlvb12a3nUADTZlDSRJXXpIwpjnuEx9z66IgpoB23
         7fTqwO+QNedSMl6lLYFToYW9czCtAvOVIw7VzkJV5AHxSgCJ7OZpc8q0QZRDPNx+6NOC
         nuDjbHKJID9PUeZ/iEIc4R6gYMsrYrahz6qxOI2IzDFXHNidQZvuYkxWCEdxdpHptsJK
         jKpA==
X-Gm-Message-State: AOAM5309LOmoBo9Dexjibc8PFz0yAGzNOXUne+5GZjtInjzPLxndkkib
        9LLu6Oz6e3dwBoJbYmRuwws=
X-Google-Smtp-Source: ABdhPJyerLlG0Vc9EMfOfjsIemvOVeJd5Nd6Zc4QkNV1NHFFQZtrSBUY2HOMiIDSb+A1DVnZY5rbVg==
X-Received: by 2002:ac8:5896:0:b0:2f3:d231:58a9 with SMTP id t22-20020ac85896000000b002f3d23158a9mr741939qta.131.1652375125492;
        Thu, 12 May 2022 10:05:25 -0700 (PDT)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-011.fbsv.net. [2a03:2880:20ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id t80-20020a374653000000b0069fc13ce231sm3183117qka.98.2022.05.12.10.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 10:05:25 -0700 (PDT)
Date:   Thu, 12 May 2022 10:05:22 -0700
From:   David Vernet <void@manifault.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] bpf: use 'error_xxx' tags in
 bpf_kprobe_multi_link_attach
Message-ID: <20220512170522.3e47hwj53plhr4qq@dev0025.ash9.facebook.com>
References: <20220512141710.116135-1-wanjiabing@vivo.com>
 <20220512141710.116135-2-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512141710.116135-2-wanjiabing@vivo.com>
User-Agent: NeoMutt/20211029
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 10:17:08PM +0800, Wan Jiabing wrote:
> Use 'error_addrs', 'error_cookies' and 'error_link' tags to make error
> handling more efficient.

Can you add a bit more context to this commit summary? The added goto
labels aren't what make the code more performant, it's the avoidance of
unnecessary free calls on NULL pointers that (supposedly) does.

> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  kernel/trace/bpf_trace.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 2eaac094caf8..3a8b69ef9a0d 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2467,20 +2467,20 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  	if (uaddrs) {
>  		if (copy_from_user(addrs, uaddrs, size)) {
>  			err = -EFAULT;
> -			goto error;
> +			goto error_addrs;
>  		}
>  	} else {
>  		struct user_syms us;
>  
>  		err = copy_user_syms(&us, usyms, cnt);
>  		if (err)
> -			goto error;
> +			goto error_addrs;
>  
>  		sort(us.syms, cnt, sizeof(*us.syms), symbols_cmp, NULL);
>  		err = ftrace_lookup_symbols(us.syms, cnt, addrs);
>  		free_user_syms(&us);
>  		if (err)
> -			goto error;
> +			goto error_addrs;
>  	}
>  
>  	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
> @@ -2488,18 +2488,18 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  		cookies = kvmalloc(size, GFP_KERNEL);
>  		if (!cookies) {
>  			err = -ENOMEM;
> -			goto error;
> +			goto error_addrs;
>  		}
>  		if (copy_from_user(cookies, ucookies, size)) {
>  			err = -EFAULT;
> -			goto error;
> +			goto error_cookies;
>  		}
>  	}
>  
>  	link = kzalloc(sizeof(*link), GFP_KERNEL);
>  	if (!link) {
>  		err = -ENOMEM;
> -		goto error;
> +		goto error_cookies;
>  	}
>  
>  	bpf_link_init(&link->link, BPF_LINK_TYPE_KPROBE_MULTI,
> @@ -2507,7 +2507,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  
>  	err = bpf_link_prime(&link->link, &link_primer);
>  	if (err)
> -		goto error;
> +		goto error_link;
>  
>  	if (flags & BPF_F_KPROBE_MULTI_RETURN)
>  		link->fp.exit_handler = kprobe_multi_link_handler;
> @@ -2539,10 +2539,12 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  
>  	return bpf_link_settle(&link_primer);
>  
> -error:
> +error_link:
>  	kfree(link);
> -	kvfree(addrs);
> +error_cookies:
>  	kvfree(cookies);
> +error_addrs:
> +	kvfree(addrs);
>  	return err;
>  }
>  #else /* !CONFIG_FPROBE */
> -- 
> 2.35.1
> 

Could you clarify what performance gains you observed from doing this? I
wouldn't have expected avoiding a couple of calls and NULL checks to have a
measurable impact on performance, and I'm wondering whether the complexity
from having multiple goto labels is really worth any supposed performance
gains.

Thanks,
David
