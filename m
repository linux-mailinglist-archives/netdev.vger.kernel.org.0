Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D41E194A26
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgCZVL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:11:59 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41549 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgCZVL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:11:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id z65so3413534pfz.8;
        Thu, 26 Mar 2020 14:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/MbI9Enj7bDwcEktjNRXIR4+Grk7lP0NhBMUlREhxKE=;
        b=sJ8j/pXW2UE6Ob/K+f3gRkzmpwsx6uV3Q/yl/tiomGsG1g8vEJiQpuz2uDDuLqgYvP
         EKtkPTir4CdcFcQ7YB5QWpxfIsyNhNJRREvaR8EMhvgr8ZCZzTRyCJDm3NbcwbJMW+bd
         Gzw8VSR8LUesdKChvySKIrsUn9SlvRgJxqZ/ObWb3Myw0mF9VM7UklYFX3Jnfg0PIplN
         /GMDLydYR+pnZ3zguOLK2sT6UEf1uLpTbLGnnEm+DTzCBSYHdRHbs0380PWZcWctsqaP
         2W6MGsF6Zz2mNwb0EbJXClwFxo6wP9YDnCiFvF0qxy2tLD1hZ74ZS8JsgJHsnfnGPR2f
         8Jhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/MbI9Enj7bDwcEktjNRXIR4+Grk7lP0NhBMUlREhxKE=;
        b=Xhp1oITravuGMAnuxEsRpppVUKoPKUgQd3uH5Vjt2uXOwc29yLcQNQju01KyhhNudO
         KS/s+D94DUE2WzC0GZQCzKva5YYFWhfJaubuFt9O3oRNNz69BxCjr4QhPlKvjNaRFzDw
         L+Twtc7sZAMOVSc/C5prLg5Csw9ZSdad3CGn0km5uBmk0u65BWSdosby4YDImfZdtZ4Y
         +WB5TagXlJ5fC/41Ro9Z143Otj2uRxi8ggcLXIlMOWEfYRa+wAHX4H+tu88UBgR2Y/iT
         ekRIOoe2jiEz/Mc7Fao7Ra03jofM3kD83twEhl9nL99kaFm0CIQGOAOli7Sou1E+iiBs
         Rr4g==
X-Gm-Message-State: ANhLgQ0sbgCaC0gJZ5WccMZp9hk+HSLB3toNTb9dUO8G38iJlGDfh7ro
        Su+4Cb4UAGBN/tdjgz4/hVE=
X-Google-Smtp-Source: ADFU+vsXzpMWeO11CdhVmSytoTOvr2PKKH0eqyakiDOJruPazpA/DV3y33y4IEonACC59nunyb/GqQ==
X-Received: by 2002:a65:5905:: with SMTP id f5mr9908390pgu.87.1585257115481;
        Thu, 26 Mar 2020 14:11:55 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c7d9])
        by smtp.gmail.com with ESMTPSA id c8sm2521516pfj.108.2020.03.26.14.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 14:11:54 -0700 (PDT)
Date:   Thu, 26 Mar 2020 14:11:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joe Stringer <joe@wand.net.nz>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, eric.dumazet@gmail.com, lmb@cloudflare.com,
        kafai@fb.com
Subject: Re: [PATCHv2 bpf-next 2/5] bpf: Prefetch established socket
 destinations
Message-ID: <20200326211152.gcpvezl3753wxljv@ast-mbp>
References: <20200325055745.10710-1-joe@wand.net.nz>
 <20200325055745.10710-3-joe@wand.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325055745.10710-3-joe@wand.net.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 10:57:42PM -0700, Joe Stringer wrote:
> Enhance the sk_assign logic to temporarily store the socket
> receive destination, to save the route lookup later on. The dst
> reference is kept alive by the caller's socket reference.
> 
> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> ---
> v2: Provide cookie to dst_check() for IPv6 case
> v1: Initial version
> ---
>  net/core/filter.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index f7f9b6631f75..0fada7fe9b75 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5876,6 +5876,21 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
>  	skb_orphan(skb);
>  	skb->sk = sk;
>  	skb->destructor = sock_pfree;
> +	if (sk_fullsock(sk)) {
> +		struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
> +		u32 cookie = 0;
> +
> +#if IS_ENABLED(CONFIG_IPV6)
> +		if (sk->sk_family == AF_INET6)
> +			cookie = inet6_sk(sk)->rx_dst_cookie;
> +#endif
> +		if (dst)
> +			dst = dst_check(dst, cookie);
> +		if (dst) {
> +			skb_dst_drop(skb);
> +			skb_dst_set_noref(skb, dst);
> +		}

I think the rest of the feedback for the patches can be addressed quickly and
overall the set is imo ready to land within this cycle. My only concern is
above dst_set().
Since it's an optimization may be drop this patch? we can land
the rest and this one can be introduced in the next cycle?
I'm happy to be convinced otherwise, but would like a better explanation
why it's safe to do so in this context.
