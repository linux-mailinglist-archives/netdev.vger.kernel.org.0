Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A6C43A56C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbhJYVIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbhJYVIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 17:08:04 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FC1C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:05:42 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a26so1315209pfr.11
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dR1utTYiWfHcPNsh2WDM8zyub5cO2VGukNTJRM/t0Hk=;
        b=Qyvt6A8VRJrdZKPgMgdIpjDnYn9Cv55k+JiV+uxcSaqTrNbt4ld7HS/bob2DrTCkwm
         L+qI8Me7lX3sqO9/2CGTMvaLNVPJO731oN7jQuGzefr+bDNXT+/9GHPoQ54exOy6+t28
         AMlfOnG2blJhqfY/vd872xN1IDfYNAOgfgmGXSUd1bmJbYXr2ws5e3lyPq1P2UcRufkZ
         Qyd70DPD2SYkSKiZhTlQniATFz8Juhrc+45LvU3yLFxnDG0zc9Uap1kI36LxiMxn/mdX
         IMGuc1bCHBPOl1AurVYsujA3FjA4qRaArqEFgSmN3ng1oF9TuvMmeqak5A2VfRj2/ilW
         Ofow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dR1utTYiWfHcPNsh2WDM8zyub5cO2VGukNTJRM/t0Hk=;
        b=b/a2/UVBE0r87/pq2GkF1EV+EcUjY6F1yEMNFizQ1PCXRiAWQdqaiyfn9ox9WbriP7
         9Dqbkc7TZ0yomdMHXiZ4rNeVpMyM5DNd2Q3PM8SGc2YuotR+rnA9l9rYKZ3DJG27r1Us
         fnb+XZaE2SPrNNcCrGqWSNxN0joVF3UJ5Fr5XYu0N7+bZx9MF/bo+RsjQww2opJeqHOo
         WXS009MGykt8lgG+fvkvJqqPQS0qR5Nv7OfikBUjhQCF1OVezHYQsCVdSTbn621sqeFP
         faRtGGM+sI7oO2KkfkietwOvKvOLGmPOoWamz9KKSCzadFi1NeH5v7pUxNSx5qeArQln
         pLaQ==
X-Gm-Message-State: AOAM532jcW9N8dmowwBcHtwxHEulU66LYVs1bug9ALReCC77qkRuaYDT
        H0q3CYRjEc7piDuji3UihCM2qiEk/to=
X-Google-Smtp-Source: ABdhPJzKI7mFfMvEz0dp+09b6/tlo7xRy/TfvTXAg42B9KIPB/2zh26mCBSoJHZUpikTOjWWQfHqOg==
X-Received: by 2002:a62:5209:0:b0:44c:68a7:3a61 with SMTP id g9-20020a625209000000b0044c68a73a61mr21276322pfb.83.1635195941631;
        Mon, 25 Oct 2021 14:05:41 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:9cf1:268c:881a:90c3? ([2620:15c:2c1:200:9cf1:268c:881a:90c3])
        by smtp.gmail.com with ESMTPSA id z3sm744503pfj.116.2021.10.25.14.05.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 14:05:40 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/4] txhash: Add socket option to control TX
 hash rethink behavior
To:     Akhmat Karakotov <hmukos@yandex-team.ru>, netdev@vger.kernel.org
Cc:     tom@herbertland.com, mitradir@yandex-team.ru, zeil@yandex-team.ru
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211025203521.13507-3-hmukos@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f21dfe61-58e6-ba03-cc0a-b5d2fd0a88c6@gmail.com>
Date:   Mon, 25 Oct 2021 14:05:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025203521.13507-3-hmukos@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/25/21 1:35 PM, Akhmat Karakotov wrote:
> Add the SO_TXREHASH socket option to control hash rethink behavior per socket.
> When default mode is set, sockets disable rehash at initialization and use
> sysctl option when entering listen state. setsockopt() overrides default
> behavior.

What values are accepted, and what are their meaning ?

It seems weird to do anything in inet_csk_listen_start()


For sockets that have not used SO_TXREHASH
(this includes passive sockets where their parent did not use SO_TXREHASH),
the sysctl _current_ value should be used every time we consider a rehash.

> 
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>  arch/alpha/include/uapi/asm/socket.h  |  2 ++
>  arch/mips/include/uapi/asm/socket.h   |  2 ++
>  arch/parisc/include/uapi/asm/socket.h |  2 ++
>  arch/sparc/include/uapi/asm/socket.h  |  2 ++
>  include/net/sock.h                    | 12 +++---------
>  include/uapi/asm-generic/socket.h     |  2 ++
>  include/uapi/linux/socket.h           |  1 +
>  net/core/net_namespace.c              |  2 +-
>  net/core/sock.c                       | 13 +++++++++++++
>  net/ipv4/inet_connection_sock.c       |  3 +++
>  10 files changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index 1dd9baf4a6c2..e6b3f38f8c0e 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -131,6 +131,8 @@
>  
>  #define SO_BUF_LOCK		72
>  
> +#define SO_TXREHASH		73
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index 1eaf6a1ca561..2c8085ecde0a 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -142,6 +142,8 @@
>  
>  #define SO_BUF_LOCK		72
>  
> +#define SO_TXREHASH		73
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index 8baaad52d799..8bb78ed36e97 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -123,6 +123,8 @@
>  
>  #define SO_BUF_LOCK		0x4046
>  
> +#define SO_TXREHASH     	0x4047
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index e80ee8641ac3..cd43a690fbac 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -124,6 +124,8 @@
>  
>  #define SO_BUF_LOCK              0x0051
>  
> +#define SO_TXREHASH              0x0052
> +
>  #if !defined(__KERNEL__)
>  
>  
> diff --git a/include/net/sock.h b/include/net/sock.h
> index d8a73edb1629..ec4f736ad085 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -313,6 +313,7 @@ struct bpf_local_storage;
>    *	@sk_rcvtimeo: %SO_RCVTIMEO setting
>    *	@sk_sndtimeo: %SO_SNDTIMEO setting
>    *	@sk_txhash: computed flow hash for use on transmit
> +  *	@sk_txrehash: enable TX hash rethink
>    *	@sk_filter: socket filtering instructions
>    *	@sk_timer: sock cleanup timer
>    *	@sk_stamp: time stamp of last packet received
> @@ -462,6 +463,7 @@ struct sock {
>  	unsigned int		sk_gso_max_size;
>  	gfp_t			sk_allocation;
>  	__u32			sk_txhash;
> +	unsigned int		sk_txrehash;

Using 32bit for this socket option is too much.

>  
>  	/*
>  	 * Because of non atomicity rules, all
> @@ -1954,18 +1956,10 @@ static inline void sk_set_txhash(struct sock *sk)
>  
>  static inline bool sk_rethink_txhash(struct sock *sk)
>  {
> -	unsigned int rehash;
> -
> -	if (!sk->sk_txhash)
> -		return false;
> -
> -	rehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
> -
> -	if (rehash) {
> +	if (sk->sk_txhash && sk->sk_txrehash == SOCK_TXREHASH_ENABLED) {
>  		sk_set_txhash(sk);
>  		return true;
>  	}
> -
>  	return false;
>  }
>  
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index 1f0a2b4864e4..6c17e477ec9f 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -126,6 +126,8 @@
>  
>  #define SO_BUF_LOCK		72
>  
> +#define SO_TXREHASH		73
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
> diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
> index 0accd6102ece..75fab2ada8cf 100644
> --- a/include/uapi/linux/socket.h
> +++ b/include/uapi/linux/socket.h
> @@ -31,6 +31,7 @@ struct __kernel_sockaddr_storage {
>  
>  #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
>  
> +#define SOCK_TXREHASH_DEFAULT	-1

What is default ?



>  #define SOCK_TXREHASH_DISABLED	0
>  #define SOCK_TXREHASH_ENABLED	1
>  
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index 0d833b861f00..537a8532ff8a 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -360,7 +360,7 @@ static int __net_init net_defaults_init_net(struct net *net)
>  {
>  	net->core.sysctl_somaxconn = SOMAXCONN;
>  
> -	net->core.sysctl_txrehash = SOCK_TXREHASH_DISABLED;
> +	net->core.sysctl_txrehash = SOCK_TXREHASH_ENABLED;

This is very confusing.

>  
>  	return 0;
>  }
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 62627e868e03..ca349ca4c31d 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1367,6 +1367,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>  					  ~SOCK_BUF_LOCK_MASK);
>  		break;
>  
> +	case SO_TXREHASH:
> +		if (val < -1 || val > 1) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +		sk->sk_txrehash = val;
> +		break;
> +
>  	default:
>  		ret = -ENOPROTOOPT;
>  		break;
> @@ -1733,6 +1741,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
>  		v.val = sk->sk_userlocks & SOCK_BUF_LOCK_MASK;
>  		break;
>  
> +	case SO_TXREHASH:
> +		v.val = sk->sk_txrehash;
> +		break;
> +
>  	default:
>  		/* We implement the SO_SNDLOWAT etc to not be settable
>  		 * (1003.1g 7).
> @@ -3165,6 +3177,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
>  	sk->sk_pacing_rate = ~0UL;
>  	WRITE_ONCE(sk->sk_pacing_shift, 10);
>  	sk->sk_incoming_cpu = -1;
> +	sk->sk_txrehash = SOCK_TXREHASH_DEFAULT;
>  
>  	sk_rx_queue_clear(sk);
>  	/*
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index f25d02ad4a8a..0d477c816309 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1046,6 +1046,9 @@ int inet_csk_listen_start(struct sock *sk, int backlog)
>  	sk->sk_ack_backlog = 0;
>  	inet_csk_delack_init(sk);
>  
> +	if (sk->sk_txrehash == SOCK_TXREHASH_DEFAULT)
> +		sk->sk_txrehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
> +
>  	/* There is race window here: we announce ourselves listening,
>  	 * but this transition is still not validated by get_port().
>  	 * It is OK, because this socket enters to hash table only
> 
