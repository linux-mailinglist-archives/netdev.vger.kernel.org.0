Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365B351E0B8
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444087AbiEFVKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358746AbiEFVKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:10:34 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7406EC7C
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 14:06:50 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so11832649pjb.5
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 14:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=coTvZIUv4dZyUUzlr20LuUwIrnLYAjDeVuyK78f4y1E=;
        b=I4BGJ8NRMg2K0xi8Py7Kl9/ZeJXat2KH2ilJEBHetgxR5evYcboIYAmaRhQoVr+Cde
         mKQ/jnPQdCl4oRhae90qwn7tPgXhBX2W1rvqulEPbEq8mnOD7cYypVock1GBFP2Rx4pI
         nyitDkfjxK4N9x7n+h69vEnTreBx/2F+9Hfe0RIoGI5/pnbo5YQwPKYSpZV1QF18Am7F
         CBfnySOAgKvpRGvC5ANZEzNACsm7qKznhJH3Dy+k8++Sx57n7wIAkOXuVdbk4eChmpQN
         D7GPPpFkHAEW4qeERLPKCwxgNzDft0x9Kma81gAhRQ/aAkRpW3k1/3Jt0CScVNeUZsAT
         pPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=coTvZIUv4dZyUUzlr20LuUwIrnLYAjDeVuyK78f4y1E=;
        b=V4iEab5+j7DYNeXBr6fK5jCwYBXT51+2O/o8OO69iJ3Tzfj1bpBw7XLSfwtgFu4aLu
         vGGhSJJXkU6ppPEV1a3WvRS82IZnmspJMikD1GeU9QyUXlfCiqzrB1vOs3rGJaV/wuWh
         xNIlqehQHotht/PKWHiJvMcXajE3P+Vcz99ksyVi1N9YbXXwZbiKAvDhHa6C8KhzC43s
         3pHcuHCelCVwdPM8f2LdMq/PUpI0So0wEhZH1/XYnZ2g6sx0UvixTYnI9/o3tmpUAcDh
         gHqyGU7c/hBYYooUVDoSZUtQMdACWv0dd4Gs5Pn5UFtKoFuyxGrgk3jVt5LFxhoOqvpR
         Xd/g==
X-Gm-Message-State: AOAM531jLntm5cKn40A2NGe3fvX+I6zjo1FmztLqMAZ6sp3s845R429G
        Xs7/W2PYpqM1pvXWrytUgsA=
X-Google-Smtp-Source: ABdhPJyigKdgema/jPUWB9MKJgY9/ZZIDGrBe3d/Fk6Csr2nXQ+FHiSiQzleFP9sBZlr9xw/p25gAg==
X-Received: by 2002:a17:902:d4c2:b0:15e:aa9c:dbad with SMTP id o2-20020a170902d4c200b0015eaa9cdbadmr5637894plg.5.1651871210252;
        Fri, 06 May 2022 14:06:50 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.39.30])
        by smtp.googlemail.com with ESMTPSA id 4-20020a620604000000b0050dc76281d5sm3881662pfg.175.2022.05.06.14.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 14:06:49 -0700 (PDT)
Message-ID: <b75489431902bd73fcefd4da2e81e39eec8cc667.camel@gmail.com>
Subject: Re: [PATCH v4 net-next 07/12] ipv6: add IFLA_GRO_IPV6_MAX_SIZE
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Fri, 06 May 2022 14:06:47 -0700
In-Reply-To: <20220506153048.3695721-8-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
         <20220506153048.3695721-8-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-3.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-05-06 at 08:30 -0700, Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> Enable GRO to have IPv6 specific limit for max packet size.
> 
> This patch introduces new dev->gro_ipv6_max_size
> that is modifiable through ip link.
> 
> ip link set dev eth0 gro_ipv6_max_size 185000
> 
> Note that this value is only considered if bigger than
> gro_max_size, and for non encapsulated TCP/ipv6 packets.
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

This is another spot where it doesn't make much sense to me to add yet
another control. Instead it would make much more sense to simply remove
the cap from the existing control and simply add a check that caps the
non-IPv6 protocols at GRO_MAX_SIZE.

> ---
>  include/linux/netdevice.h          |  3 +++
>  include/uapi/linux/if_link.h       |  1 +
>  net/core/dev.c                     |  1 +
>  net/core/gro.c                     | 20 ++++++++++++++++++--
>  net/core/rtnetlink.c               | 22 ++++++++++++++++++++++
>  tools/include/uapi/linux/if_link.h |  1 +
>  6 files changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 47f413dac12e901700045f4b73d47ecdca0f4f3c..df12c9843d94cb847e0ce5ba1b3b36bde7d476ed 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1962,6 +1962,8 @@ enum netdev_ml_priv_type {
>   *			keep a list of interfaces to be deleted.
>   *	@gro_max_size:	Maximum size of aggregated packet in generic
>   *			receive offload (GRO)
> + *	@gro_ipv6_max_size:	Maximum size of aggregated packet in generic
> + *				receive offload (GRO), for IPv6
>   *
>   *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
>   *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
> @@ -2154,6 +2156,7 @@ struct net_device {
>  	int			napi_defer_hard_irqs;
>  #define GRO_MAX_SIZE		65536
>  	unsigned int		gro_max_size;
> +	unsigned int		gro_ipv6_max_size;
>  	rx_handler_func_t __rcu	*rx_handler;
>  	void __rcu		*rx_handler_data;
>  
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index aa05fc9cc23f4ccf92f4cbba57f43472749cd42a..9ece3a391105c171057cc491c1458ee8a45e07e0 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -371,6 +371,7 @@ enum {
>  	IFLA_TSO_MAX_SIZE,
>  	IFLA_TSO_MAX_SEGS,
>  	IFLA_GSO_IPV6_MAX_SIZE,
> +	IFLA_GRO_IPV6_MAX_SIZE,
>  
>  	__IFLA_MAX
>  };
> diff --git a/net/core/dev.c b/net/core/dev.c
> index aa8757215b2a9f14683f95086732668eb99a875b..582b7fe052a6fb06437f95bd6a451b79e188cc57 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10608,6 +10608,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>  	dev->tso_max_size = TSO_LEGACY_MAX_SIZE;
>  	dev->tso_max_segs = TSO_MAX_SEGS;
>  	dev->gso_ipv6_max_size = GSO_MAX_SIZE;
> +	dev->gro_ipv6_max_size = GRO_MAX_SIZE;
>  
>  	dev->upper_level = 1;
>  	dev->lower_level = 1;
> diff --git a/net/core/gro.c b/net/core/gro.c
> index 78110edf5d4b36d2fa6f8a2676096efe0112aa0e..8b35403dd7e909a8d7df591d952a4600c13f360b 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -161,11 +161,27 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>  	unsigned int new_truesize;
>  	struct sk_buff *lp;
>  
> +	if (unlikely(NAPI_GRO_CB(skb)->flush))
> +		return -E2BIG;
> +
>  	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
>  	gro_max_size = READ_ONCE(p->dev->gro_max_size);
>  
> -	if (unlikely(p->len + len >= gro_max_size || NAPI_GRO_CB(skb)->flush))
> -		return -E2BIG;

So if we just overwrite the existing gro_max_size we could skip the
changes above and all the extra netlink overhead.

> +	if (unlikely(p->len + len >= gro_max_size)) {
> +		/* pairs with WRITE_ONCE() in netif_set_gro_ipv6_max_size() */
> +		unsigned int gro6_max_size = READ_ONCE(p->dev->gro_ipv6_max_size);
> +
> +		if (gro6_max_size > gro_max_size &&
> +		    p->protocol == htons(ETH_P_IPV6) &&
> +		    skb_headroom(p) >= sizeof(struct hop_jumbo_hdr) &&
> +		    ipv6_hdr(p)->nexthdr == IPPROTO_TCP &&
> +		    !p->encapsulation)
> +			gro_max_size = gro6_max_size;
> +
> +		if (p->len + len >= gro_max_size)
> +			return -E2BIG;
> +	}
> +

Instead all we would need to do is add an extra section here along the
lines of:
	if (p->len + len > GRO_MAX_SIZE &&
	    (p->protocol != htons(ETH_P_IPV6) ||
	     skb_headroom(p) < sizeof(struct hop_jumbo_hdr) ||
	     ipv6_hdr(p)->nexthdr != IPPROTO_TCP ||
	     p->encapsulation)
		return -E2BIG;


