Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610694A8296
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 11:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbiBCKpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 05:45:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47862 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231520AbiBCKpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 05:45:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643885103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wBFbqeA8wZVoaw3AhOQkcommuu2XKb8bOpX8+ULZXkQ=;
        b=BZMW64uo4h5Qw/bTYhw1IbToC2oJ+HaZhBzLPfjHOuXLdufg/yCthWGLUhMHCnCDFuhsh0
        f9bBaJRcJGTVl+koTMTrwVHscOULBwCZ4MFDsaZ12mZlXmsLyzG8K2uEsbo/zyhSf1+kwB
        6SFPYXGWDGuhgP+r0pxEQnSNnuaFxPk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-C0Zvahc1PuuEUDGbkbqAFQ-1; Thu, 03 Feb 2022 05:45:02 -0500
X-MC-Unique: C0Zvahc1PuuEUDGbkbqAFQ-1
Received: by mail-wm1-f71.google.com with SMTP id m189-20020a1c26c6000000b003508ba87dfbso592321wmm.7
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 02:45:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=wBFbqeA8wZVoaw3AhOQkcommuu2XKb8bOpX8+ULZXkQ=;
        b=zTcNreV2VLdrcR1C1El0BkZiL43a25nE6fhFiVPzpViVE7SSjM3XK+i6eglznGHv80
         UrOk/LzUdsp8jSkZT6lZ43yv6LouLRkC6vPgGJ8hnIqLYVQMPjs+9DLgkSb3gyEFq+2F
         CX12hhfLuE0kBNeIYs4xL1R57Kjw5rPxIn474sL/yOrLLX44WtLaeszzj+xYcbG5uWQR
         DgFVtDcuqCivyJpsv0aYBO4j8c3PVdMXu6XLtEB9jY2we1TJbh2tnMt+PXwJTqKDQfG2
         UcrtpPhQISLVbK2Q3QUX2LPsgNRqBRA5nzRFYsWPeQoRLAtQpbC2YJ9eSEcmuGT8ojk1
         zdTw==
X-Gm-Message-State: AOAM531e71bNnHivcL6/eMxNxcpSewAwRRlBUa1Z6i0HyFe334YtufLc
        aeDdx5SQI2wDn93XI/nLj/sW3UB6tH9vCEtyYIpQRXNtsxzPOHsqk4QQkroDTF6INmo7Q5sZ2I1
        aQ/FE1O6pjIkJE5vM
X-Received: by 2002:a05:600c:48a:: with SMTP id d10mr9864644wme.100.1643885101114;
        Thu, 03 Feb 2022 02:45:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfjdj8joFpcxj/yN+Ao7pGhbW6cXE1N8UQMGVTdBeQV45AgCeDw6UyGhkkUUj8JsSH+r/Dyw==
X-Received: by 2002:a05:600c:48a:: with SMTP id d10mr9864620wme.100.1643885100812;
        Thu, 03 Feb 2022 02:45:00 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id f13sm20934169wri.44.2022.02.03.02.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 02:45:00 -0800 (PST)
Message-ID: <366ea56787986da19724bb6d52a6e6145f2132ba.camel@redhat.com>
Subject: Re: [PATCH net-next 07/15] ipv6: add GRO_IPV6_MAX_SIZE
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Date:   Thu, 03 Feb 2022 11:44:59 +0100
In-Reply-To: <20220203015140.3022854-8-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
         <20220203015140.3022854-8-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> From: "Signed-off-by: Coco Li" <lixiaoyan@google.com>
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
> ---
>  include/linux/netdevice.h          | 10 ++++++++++
>  include/uapi/linux/if_link.h       |  1 +
>  net/core/dev.c                     |  1 +
>  net/core/gro.c                     | 20 ++++++++++++++++++--
>  net/core/rtnetlink.c               | 15 +++++++++++++++
>  tools/include/uapi/linux/if_link.h |  1 +
>  6 files changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 2a563869ba44f7d48095d36b1395e3fbd8cfff87..a3a61cffd953add6f272a53f551a49a47d200c68 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1944,6 +1944,8 @@ enum netdev_ml_priv_type {
>   *			keep a list of interfaces to be deleted.
>   *	@gro_max_size:	Maximum size of aggregated packet in generic
>   *			receive offload (GRO)
> + *	@gro_ipv6_max_size:	Maximum size of aggregated packet in generic
> + *				receive offload (GRO), for IPv6
>   *
>   *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
>   *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
> @@ -2137,6 +2139,7 @@ struct net_device {
>  	int			napi_defer_hard_irqs;
>  #define GRO_MAX_SIZE		65536
>  	unsigned int		gro_max_size;
> +	unsigned int		gro_ipv6_max_size;
>  	rx_handler_func_t __rcu	*rx_handler;
>  	void __rcu		*rx_handler_data;
>  
> @@ -4840,6 +4843,13 @@ static inline void netif_set_gso_ipv6_max_size(struct net_device *dev,
>  	WRITE_ONCE(dev->gso_ipv6_max_size, size);
>  }
>  
> +static inline void netif_set_gro_ipv6_max_size(struct net_device *dev,
> +					       unsigned int size)
> +{
> +	/* This pairs with the READ_ONCE() in skb_gro_receive() */
> +	WRITE_ONCE(dev->gro_ipv6_max_size, size);
> +}
> +
>  static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
>  					int pulled_hlen, u16 mac_offset,
>  					int mac_len)
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 024b3bd0467e1360917001dba6bcfd1f30391894..48fe85bed4a629df0dd7cc0ee3a5139370e2c94d 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -350,6 +350,7 @@ enum {
>  	IFLA_GRO_MAX_SIZE,
>  	IFLA_TSO_IPV6_MAX_SIZE,
>  	IFLA_GSO_IPV6_MAX_SIZE,
> +	IFLA_GRO_IPV6_MAX_SIZE,
>  
>  	__IFLA_MAX
>  };
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 53c947e6fdb7c47e6cc92fd4e38b71e9b90d921c..e7df5c3f53d6e96d01ff06d081cef77d0c6d9d29 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10190,6 +10190,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>  	dev->gro_max_size = GRO_MAX_SIZE;
>  	dev->tso_ipv6_max_size = GSO_MAX_SIZE;
>  	dev->gso_ipv6_max_size = GSO_MAX_SIZE;
> +	dev->gro_ipv6_max_size = GRO_MAX_SIZE;
>  
>  	dev->upper_level = 1;
>  	dev->lower_level = 1;
> diff --git a/net/core/gro.c b/net/core/gro.c
> index a11b286d149593827f1990fb8d06b0295fa72189..005a05468418f0373264e8019384e2daa13176eb 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -136,11 +136,27 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
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
>  
>  	lp = NAPI_GRO_CB(p)->last;
>  	pinfo = skb_shinfo(lp);

If I read correctly, a big GRO packet could be forwarded and/or
redirected to an egress device not supporting LSOv2 or with a lower
tso_ipv6_max_size. Don't we need to update netif_needs_gso() to take
care of such scenario? 
AFAICS we are not enforcing gso_max_size, so I'm wondering if that is
really a problem?!?

Thanks!

Paolo

