Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2934D43A51E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhJYU5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhJYU5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:57:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1FEC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:54:57 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so434612pje.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fspy64a2vPgeqwTvVp5vyLZ5vW7hEONCiPfU3HeZppA=;
        b=e/OP8zgZqmQsGnckT2nhUwjQRmCk7ekd3IzPVQsugsGHPDJzEYHVh36KKYpa3m5vAO
         Lr1hxpna5dBMhIZcby7dYVGlNM0N/lVRafaUKwHXtKzHO4NWbcBHy2FJZL1zynt/5B7f
         bN8nIOfNle/+EUTO/J3o5NccQc5x/YxjSrhqSrL95+YVDDd2ujfJmP/g+p8FKt60+7GJ
         4Hgs1hDLdSajOvcZQQ8l4V1Y691G7W2Kk88prU2DykzYhWBw9JD+dEoQQyQ2oV6qyTti
         mfaHR7Og0hb8cOEW957BPExbE2jewyP88378EPAJUISeeXUe+lkcjlkFgNY7LtMwpg5z
         2NXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fspy64a2vPgeqwTvVp5vyLZ5vW7hEONCiPfU3HeZppA=;
        b=smwySePidlOPvsG6OAbUsb25bfh4ixF76HINvs+XIIpiZvtWum5Qhvhi3tZD6gisM8
         BiulNFRl8YM07gZhTAZb9JKu6cyQDAyA6Pnuk4dbpYGtBvCqhlRlzRZtqDvHeKSYKSJS
         aSHpQEltPZCsl5GV8yAR6ONpsZdjj9PCHGPYBnUKSckzOIl2TWLguvQHot3Oo1N88oPR
         2JLSqKtaMnoCnCUa9zMTsybfgDhFLfaKP4J9/zP38IW3kEa+PI0FrF3W4NGZXqZ2yqDc
         edhj+TfsjL/V3TquptWPVHvE8uwGY58fKXXKToCfbewiRV6gQ5bGcj2U1NwO3zpvQTFu
         7chQ==
X-Gm-Message-State: AOAM530cuVs5JRXqNdS7Uxs31mb60cC7LV84W13IZoSUjdiqzFJZ5DL/
        MXu6A3jF1cZtTP48L7z/+hvfxybDZ68=
X-Google-Smtp-Source: ABdhPJwxcPJatpTKMhAtMAtWaV06ROPfp/CJD9lrTlKBYA34+tAeO3n95fv5FesuSTMS35TZ1BaShg==
X-Received: by 2002:a17:902:c40f:b0:140:6774:9365 with SMTP id k15-20020a170902c40f00b0014067749365mr3515663plk.67.1635195297185;
        Mon, 25 Oct 2021 13:54:57 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:9cf1:268c:881a:90c3? ([2620:15c:2c1:200:9cf1:268c:881a:90c3])
        by smtp.gmail.com with ESMTPSA id rj6sm23792985pjb.30.2021.10.25.13.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 13:54:56 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/4] txhash: Make rethinking txhash behavior
 configurable via sysctl
To:     Akhmat Karakotov <hmukos@yandex-team.ru>, netdev@vger.kernel.org
Cc:     tom@herbertland.com, mitradir@yandex-team.ru, zeil@yandex-team.ru
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211025203521.13507-2-hmukos@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <af6dcf30-75d5-7b4a-66cd-837a703101b1@gmail.com>
Date:   Mon, 25 Oct 2021 13:54:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025203521.13507-2-hmukos@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/25/21 1:35 PM, Akhmat Karakotov wrote:
> Add a per ns sysctl that controls the txhash rethink behavior,
> sk_rethink_txhash. When enabled, the same behavior is retained, when
> disabled, rethink is not performed. Sysctl is disabled by default.
> 
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>  include/net/netns/core.h    |  2 ++
>  include/net/sock.h          | 34 +++++++++++++++++++++-------------
>  include/uapi/linux/socket.h |  3 +++
>  net/core/net_namespace.c    |  3 +++
>  net/core/sysctl_net_core.c  |  7 +++++++
>  5 files changed, 36 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/netns/core.h b/include/net/netns/core.h
> index 36c2d998a43c..177980b46ed7 100644
> --- a/include/net/netns/core.h
> +++ b/include/net/netns/core.h
> @@ -11,6 +11,8 @@ struct netns_core {
>  
>  	int	sysctl_somaxconn;
>  
> +	unsigned int sysctl_txrehash;

We have u8 sysctls, to keep this structure small.

> +
>  #ifdef CONFIG_PROC_FS
>  	int __percpu *sock_inuse;
>  	struct prot_inuse __percpu *prot_inuse;
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 66a9a90f9558..d8a73edb1629 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -577,6 +577,18 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
>  			   __tmp | SK_USER_DATA_NOCOPY);		\
>  })
>  
> +static inline
> +struct net *sock_net(const struct sock *sk)
> +{
> +	return read_pnet(&sk->sk_net);
> +}
> +
> +static inline
> +void sock_net_set(struct sock *sk, struct net *net)
> +{
> +	write_pnet(&sk->sk_net, net);
> +}
> +
>  /*
>   * SK_CAN_REUSE and SK_NO_REUSE on a socket mean that the socket is OK
>   * or not whether his port will be reused by someone else. SK_FORCE_REUSE
> @@ -1942,10 +1954,18 @@ static inline void sk_set_txhash(struct sock *sk)
>  
>  static inline bool sk_rethink_txhash(struct sock *sk)
>  {
> -	if (sk->sk_txhash) {
> +	unsigned int rehash;
> +
> +	if (!sk->sk_txhash)
> +		return false;
> +
> +	rehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
> +
> +	if (rehash) {
>  		sk_set_txhash(sk);
>  		return true;
>  	}
> +
>  	return false;
>  }
>  
> @@ -2596,18 +2616,6 @@ static inline void sk_eat_skb(struct sock *sk, struct sk_buff *skb)
>  	__kfree_skb(skb);
>  }
>  
> -static inline
> -struct net *sock_net(const struct sock *sk)
> -{
> -	return read_pnet(&sk->sk_net);
> -}
> -
> -static inline
> -void sock_net_set(struct sock *sk, struct net *net)
> -{
> -	write_pnet(&sk->sk_net, net);
> -}
> -
>  static inline bool
>  skb_sk_is_prefetched(struct sk_buff *skb)
>  {
> diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
> index eb0a9a5b6e71..0accd6102ece 100644
> --- a/include/uapi/linux/socket.h
> +++ b/include/uapi/linux/socket.h
> @@ -31,4 +31,7 @@ struct __kernel_sockaddr_storage {
>  
>  #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
>  
> +#define SOCK_TXREHASH_DISABLED	0
> +#define SOCK_TXREHASH_ENABLED	1
> +
>  #endif /* _UAPI_LINUX_SOCKET_H */
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index a448a9b5bb2d..0d833b861f00 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -359,6 +359,9 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
>  static int __net_init net_defaults_init_net(struct net *net)
>  {
>  	net->core.sysctl_somaxconn = SOMAXCONN;
> +
> +	net->core.sysctl_txrehash = SOCK_TXREHASH_DISABLED;
> +
>  	return 0;
>  }
>  
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index c8496c1142c9..34144abbb6a0 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -592,6 +592,13 @@ static struct ctl_table netns_core_table[] = {
>  		.extra1		= SYSCTL_ZERO,
>  		.proc_handler	= proc_dointvec_minmax
>  	},
> +	{
> +		.procname	= "txrehash",
> +		.data		= &init_net.core.sysctl_txrehash,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_do_intvec

   .maxlen = sizeof(u8),
   extra1 = SYSCTL_ZERO,
   extra2 = SYSCTL_ONE,
   .proc_handler = proc_dou8vec_minmax,
> +	},
>  	{ }
>  };
>  
> 
