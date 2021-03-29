Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E2A34D957
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhC2Uyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhC2UyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 16:54:17 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA50C061574;
        Mon, 29 Mar 2021 13:54:17 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id f19so14188300ion.3;
        Mon, 29 Mar 2021 13:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Vf66eL15U8njDI0wUbJwhopv7ffMWFCFjk1XaltSbtY=;
        b=m2zcF2/pc7LqNVitm4jzgxiWhPeMWbIAh1GgKn1wlziE+WqhReX5IuZNTNnmNgZPOo
         m4NxR7Q7o+MkVZvd9DORmcyNzU3e9bJ75yLLJNrfsaxOh3QV9BQxrZIU7Dhskyj535tu
         0D6M/NQSxSHlEOVirEH9A8WsZDqMnme6beZVCjGhWV48GLQaSC+NVnVqRWp40JZY/iC4
         rFpF2eJQOJadn83UTuwcHLMmKIHqzqX4+2sIxgV5/fzAFIcFqZlQwTxAwaA3Lp95Wlrk
         9hFw0bBvUXU453LLSnCXAk9joTsbprkd0Xr0epfrY16XNcja6NtJGe3LJN4YdjOYMBfA
         /UDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Vf66eL15U8njDI0wUbJwhopv7ffMWFCFjk1XaltSbtY=;
        b=Y6Xp2DsD+cgWjvr0+KI3BwgXabEFNFHrjgCbkJCfvwZ6RH03IUh0mab3WmJLgjL7lF
         33LPhXBEbqcL9DQ+GuV/c13y1EXaH7nNglqlvOmK40iR2Wyy64wAyrQRjegXLHnNVNVM
         cDbfsYkOEWBP2qKO4NFNtHdDmAlVMbf3yDy5Fi71CZQ6aZzJYVjxTd9IoUkjyOtBKa/g
         X0qse4aGz1JtbJk3o97fMUJjCKZIUdDZxyM5SGf4plibcadxvZmCUeYlfQa8XtEtvtaj
         UXvo0Mm5Ok5kXnihZktEHiVcBITGdh4cysvEhyj90fId8XUON2v03Axs3g2WkgoQF0Qr
         Bl1w==
X-Gm-Message-State: AOAM530ubHP1Bortdxf1XPIpfkV+xM6oTYuJ0HvRFZK4oAkibg0OZYAt
        Sy/3tL3w798e6Uh5ii2aqCM=
X-Google-Smtp-Source: ABdhPJwQMH5lghuDTbTORLJjfXZvLn0N8U56iu2fOChIIcXb2ASnF1Yia7Gf6MJ2eu4c2vCDn521KA==
X-Received: by 2002:a05:6602:1da:: with SMTP id w26mr1930846iot.170.1617051256978;
        Mon, 29 Mar 2021 13:54:16 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id b9sm10203942iof.54.2021.03.29.13.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 13:54:16 -0700 (PDT)
Date:   Mon, 29 Mar 2021 13:54:07 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60623e6fdd870_401fb20818@john-XPS-13-9370.notmuch>
In-Reply-To: <20210328202013.29223-10-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-10-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v7 09/13] udp: implement ->read_sock() for
 sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This is similar to tcp_read_sock(), except we do not need
> to worry about connections, we just need to retrieve skb
> from UDP receive queue.
> 
> Note, the return value of ->read_sock() is unused in
> sk_psock_verdict_data_ready().
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/net/udp.h   |  2 ++
>  net/ipv4/af_inet.c  |  1 +
>  net/ipv4/udp.c      | 35 +++++++++++++++++++++++++++++++++++
>  net/ipv6/af_inet6.c |  1 +
>  4 files changed, 39 insertions(+)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index df7cc1edc200..347b62a753c3 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -329,6 +329,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
>  			       struct sk_buff *skb);
>  struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
>  				 __be16 sport, __be16 dport);
> +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> +		  sk_read_actor_t recv_actor);
>  
>  /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
>   * possibly multiple cache miss on dequeue()
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 1355e6c0d567..f17870ee558b 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1070,6 +1070,7 @@ const struct proto_ops inet_dgram_ops = {
>  	.setsockopt	   = sock_common_setsockopt,
>  	.getsockopt	   = sock_common_getsockopt,
>  	.sendmsg	   = inet_sendmsg,
> +	.read_sock	   = udp_read_sock,
>  	.recvmsg	   = inet_recvmsg,
>  	.mmap		   = sock_no_mmap,
>  	.sendpage	   = inet_sendpage,
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 38952aaee3a1..04620e4d64ab 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1782,6 +1782,41 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
>  }
>  EXPORT_SYMBOL(__skb_recv_udp);
>  
> +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> +		  sk_read_actor_t recv_actor)
> +{
> +	int copied = 0;
> +
> +	while (1) {
> +		int offset = 0, err;

Should this be

 int offset = sk_peek_offset()?

MSG_PEEK should work from recv side, at least it does on TCP side. If
its handled in some following patch a comment would be nice. I was
just reading udp_recvmsg() so maybe its not needed.

> +		struct sk_buff *skb;
> +
> +		skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
> +		if (!skb)
> +			return err;
> +		if (offset < skb->len) {
> +			size_t len;
> +			int used;
> +
> +			len = skb->len - offset;
> +			used = recv_actor(desc, skb, offset, len);
> +			if (used <= 0) {
> +				if (!copied)
> +					copied = used;
> +				break;
> +			} else if (used <= len) {
> +				copied += used;
> +				offset += used;

The while loop is going to zero this? What are we trying to do
here with offset?

> +			}
> +		}
> +		if (!desc->count)
> +			break;
> +	}
> +
> +	return copied;
> +}
> +EXPORT_SYMBOL(udp_read_sock);
> +
>  /*
>   * 	This should be easy, if there is something there we
>   * 	return it, otherwise we block.
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index 802f5111805a..71de739b4a9e 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -714,6 +714,7 @@ const struct proto_ops inet6_dgram_ops = {
>  	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
>  	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
>  	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
> +	.read_sock	   = udp_read_sock,
>  	.mmap		   = sock_no_mmap,
>  	.sendpage	   = sock_no_sendpage,
>  	.set_peek_off	   = sk_set_peek_off,
> -- 
> 2.25.1
> 


