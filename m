Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF54535299C
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 12:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhDBKQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 06:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBKQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 06:16:40 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DCDC0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 03:16:39 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x7so4320943wrw.10
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 03:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=r3nLh/oR75ohYBkJhQ6AjBcGBnjjpOyH6oMJC7oKGXs=;
        b=yEM4ILac4ta+l36Bgz/XfR4V2uBuvts8deQvlo84DyuwaZqTUKa5Y+bdeB4kca8F4T
         NPZOib6hDPr/2ndYNIlhuW26ZnwmDT1evfxmDRPlwm1lrNzYBuKK/4oCAaMHhNOnJxZO
         pGx/mTfunGwlqfCCl4y5PkWkhf0yGSJ4OAHM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=r3nLh/oR75ohYBkJhQ6AjBcGBnjjpOyH6oMJC7oKGXs=;
        b=sKFGL34HohlOXtaFnRBPRNp4zY7VOuRNtp/k3v62W2IP5oGwwb8Mgswebpo4b+Q4g5
         X9+7w3V4m5q46M97JJd3K1Yot6rT8amPEOfTWcAgyJGUyv76znxMK87W6j9jyUa3tFmD
         zrn4IdxJm5K9/3pdZ1WlTS5vaK/vku9nRhZW4fsAio/CgVgBBehmEtjHWngfb1qXpCSS
         yO3ldY1dJWEoSAD6WAn3II8bk5qr1m48ZNGcTlf3ASf2RnFhHBIlPMmzX1Shu/O1idsv
         DpoPTSPuAQRDJVJli9350zQI261wT0pstNOgk6+tza6XnjStdyoFLs+veaOLVazHTlHQ
         JQhw==
X-Gm-Message-State: AOAM533BvsVckP4MktMdRbYKPyLg0WvRmH7QcjjoUXHgZLSf7DIjwokR
        beUlHka94zijK5xqmGJDNZEsxQ==
X-Google-Smtp-Source: ABdhPJwl1fJ2BYQy5idx/Pjh78XsaPD8or7dl+hRV203NiBd56UH5TdUVsNiKQGMy0/L66lhrPvXjg==
X-Received: by 2002:a5d:6a87:: with SMTP id s7mr14480472wru.312.1617358598213;
        Fri, 02 Apr 2021 03:16:38 -0700 (PDT)
Received: from cloudflare.com (83.5.248.223.ipv4.supernova.orange.pl. [83.5.248.223])
        by smtp.gmail.com with ESMTPSA id o2sm11648692wmc.23.2021.04.02.03.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 03:16:37 -0700 (PDT)
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-11-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next v8 10/16] sock: introduce
 sk->sk_prot->psock_update_sk_prot()
In-reply-to: <20210331023237.41094-11-xiyou.wangcong@gmail.com>
Date:   Fri, 02 Apr 2021 12:16:36 +0200
Message-ID: <87sg492dq3.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 04:32 AM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Currently sockmap calls into each protocol to update the struct
> proto and replace it. This certainly won't work when the protocol
> is implemented as a module, for example, AF_UNIX.
>
> Introduce a new ops sk->sk_prot->psock_update_sk_prot(), so each
> protocol can implement its own way to replace the struct proto.
> This also helps get rid of symbol dependencies on CONFIG_INET.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

[...]

> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 4a0478b17243..38952aaee3a1 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2849,6 +2849,9 @@ struct proto udp_prot = {
>  	.unhash			= udp_lib_unhash,
>  	.rehash			= udp_v4_rehash,
>  	.get_port		= udp_v4_get_port,
> +#ifdef CONFIG_BPF_SYSCALL
> +	.psock_update_sk_prot	= udp_bpf_update_proto,
> +#endif
>  	.memory_allocated	= &udp_memory_allocated,
>  	.sysctl_mem		= sysctl_udp_mem,
>  	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_udp_wmem_min),
> diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
> index 7a94791efc1a..6001f93cd3a0 100644
> --- a/net/ipv4/udp_bpf.c
> +++ b/net/ipv4/udp_bpf.c
> @@ -41,12 +41,23 @@ static int __init udp_bpf_v4_build_proto(void)
>  }
>  core_initcall(udp_bpf_v4_build_proto);
>
> -struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
> +int udp_bpf_update_proto(struct sock *sk, bool restore)
>  {
>  	int family = sk->sk_family == AF_INET ? UDP_BPF_IPV4 : UDP_BPF_IPV6;
> +	struct sk_psock *psock = sk_psock(sk);
> +
> +	if (restore) {
> +		sk->sk_write_space = psock->saved_write_space;
> +		/* Pairs with lockless read in sk_clone_lock() */

Just to clarify. UDP sockets don't get cloned, so the above comment
apply.

> +		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
> +		return 0;
> +	}
>
>  	if (sk->sk_family == AF_INET6)
>  		udp_bpf_check_v6_needs_rebuild(psock->sk_proto);
>
> -	return &udp_bpf_prots[family];
> +	/* Pairs with lockless read in sk_clone_lock() */
> +	WRITE_ONCE(sk->sk_prot, &udp_bpf_prots[family]);
> +	return 0;
>  }
> +EXPORT_SYMBOL_GPL(udp_bpf_update_proto);

[...]
