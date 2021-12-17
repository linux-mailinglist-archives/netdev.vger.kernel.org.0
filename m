Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05114478328
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 03:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhLQC3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 21:29:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbhLQC3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 21:29:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639708189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K2fGADr55yXo7f7TjPfBWN4ATcJQItvux9KNUU3Ewj8=;
        b=asdN2kIyLFIe0sod0L8KkFDrMBOvD0V2Jgbh4nxGpe1Df72E+gfwuSvIrXkd7vjjXiiplg
        Ss9GAN/f3TiYFur/9F28UKDt7OxexzP1SZK6visw/1Q1RmPcJue0WiLreIgiECaDrDF/HA
        8e/Ko0RjRaX5eExI+r2wbLYxJDJwEi0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-GM6NW1fYNVGVyC4vR0EVyw-1; Thu, 16 Dec 2021 21:29:48 -0500
X-MC-Unique: GM6NW1fYNVGVyC4vR0EVyw-1
Received: by mail-qt1-f200.google.com with SMTP id l15-20020a05622a050f00b002c09d62865fso1192983qtx.4
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 18:29:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K2fGADr55yXo7f7TjPfBWN4ATcJQItvux9KNUU3Ewj8=;
        b=TUf6tDDLgH3ZnHx7MJOoQSoGyGrELrx394s9APhqcVI2TimYvpK+/wSofFoF8SfphI
         CaoihtYHLU6c8Zvl3sO00XeZB/Mj7hikz93wISrhMsUwwo2c1D/CPxCyi1c0aNKFKqVR
         DycajcANTxStB8FKc7YhAqtqoY4obv8waO/gGRghFeJ62LN8E2Hyvf+G2Oa2qgK10TiI
         QQEslYB/uATqK3gd+iJw0LD0Gz5eK6DDbs/XnfV7KJRzth5tTEKpv8T64u+57zubQdDI
         GGiBmREHbE/bTwl/6B3u+WPd9xAKbR3rcirWMYySRFOf+7GD8MpnWOGfaDgP0pRGnJYc
         059A==
X-Gm-Message-State: AOAM533Nm5HECU4g+Vx3/lgwUW4p1TYjKWwTs08OfnnNAoId/RKwlEDE
        GKD5leGIHCRZrnb8dQvPz96asIndRZXvcNM+JI7BDZyXlpuJAOq98bj+utAtLoSnkJmso4R12Wl
        zLc1QNZCsJu9GAUIj
X-Received: by 2002:ac8:5ccf:: with SMTP id s15mr772339qta.220.1639708187982;
        Thu, 16 Dec 2021 18:29:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyMiKUVxl4KMXbc95JFbcbDFOJQ+Z1UW+VAOiOB0714eV8fHUjPqfoJk+BVD648zdC5x4IOQ==
X-Received: by 2002:ac8:5ccf:: with SMTP id s15mr772329qta.220.1639708187672;
        Thu, 16 Dec 2021 18:29:47 -0800 (PST)
Received: from [10.0.0.96] ([24.225.241.171])
        by smtp.gmail.com with ESMTPSA id v1sm5958888qtw.65.2021.12.16.18.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 18:29:47 -0800 (PST)
Message-ID: <72c76cf5-b6c2-44a6-865c-deaf7cebf956@redhat.com>
Date:   Thu, 16 Dec 2021 21:33:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next] net: add net device refcount tracker to struct
 packet_type
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ying Xue <ying.xue@windriver.com>
References: <20211214150933.242895-1-eric.dumazet@gmail.com>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <20211214150933.242895-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/21 10:09, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>
> Most notable changes are in af_packet, tipc ones are trivial.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> ---
>   include/linux/netdevice.h |  1 +
>   net/packet/af_packet.c    | 14 +++++++++++---
>   net/tipc/bearer.c         |  4 ++--
>   3 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 235d5d082f1a446c8d898ffcc5b1983df7c04f35..0ed0a6f0d69d3565c1db9203040838801cd71e99 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2533,6 +2533,7 @@ struct packet_type {
>   	__be16			type;	/* This is really htons(ether_type). */
>   	bool			ignore_outgoing;
>   	struct net_device	*dev;	/* NULL is wildcarded here	     */
> +	netdevice_tracker	dev_tracker;
>   	int			(*func) (struct sk_buff *,
>   					 struct net_device *,
>   					 struct packet_type *,
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index a1ffdb48cc474dcf91bddfd1ab96386a89c20375..71854a16afbbc1c06005e48a65cdb7007d61b019 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -3109,7 +3109,7 @@ static int packet_release(struct socket *sock)
>   	packet_cached_dev_reset(po);
>   
>   	if (po->prot_hook.dev) {
> -		dev_put(po->prot_hook.dev);
> +		dev_put_track(po->prot_hook.dev, &po->prot_hook.dev_tracker);
>   		po->prot_hook.dev = NULL;
>   	}
>   	spin_unlock(&po->bind_lock);
> @@ -3217,18 +3217,25 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
>   		WRITE_ONCE(po->num, proto);
>   		po->prot_hook.type = proto;
>   
> +		dev_put_track(dev_curr, &po->prot_hook.dev_tracker);
> +		dev_curr = NULL;
> +
>   		if (unlikely(unlisted)) {
>   			dev_put(dev);
>   			po->prot_hook.dev = NULL;
>   			WRITE_ONCE(po->ifindex, -1);
>   			packet_cached_dev_reset(po);
>   		} else {
> +			if (dev)
> +				netdev_tracker_alloc(dev,
> +						     &po->prot_hook.dev_tracker,
> +						     GFP_ATOMIC);
>   			po->prot_hook.dev = dev;
>   			WRITE_ONCE(po->ifindex, dev ? dev->ifindex : 0);
>   			packet_cached_dev_assign(po, dev);
>   		}
>   	}
> -	dev_put(dev_curr);
> +	dev_put_track(dev_curr, &po->prot_hook.dev_tracker);
>   
>   	if (proto == 0 || !need_rehook)
>   		goto out_unlock;
> @@ -4138,7 +4145,8 @@ static int packet_notifier(struct notifier_block *this,
>   				if (msg == NETDEV_UNREGISTER) {
>   					packet_cached_dev_reset(po);
>   					WRITE_ONCE(po->ifindex, -1);
> -					dev_put(po->prot_hook.dev);
> +					dev_put_track(po->prot_hook.dev,
> +						      &po->prot_hook.dev_tracker);
>   					po->prot_hook.dev = NULL;
>   				}
>   				spin_unlock(&po->bind_lock);
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index 60bc74b76adc5909fdb5294f205229682a09d031..473a790f58943537896c16c72b60061b5ffe6840 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -787,7 +787,7 @@ int tipc_attach_loopback(struct net *net)
>   	if (!dev)
>   		return -ENODEV;
>   
> -	dev_hold(dev);
> +	dev_hold_track(dev, &tn->loopback_pt.dev_tracker, GFP_KERNEL);
>   	tn->loopback_pt.dev = dev;
>   	tn->loopback_pt.type = htons(ETH_P_TIPC);
>   	tn->loopback_pt.func = tipc_loopback_rcv_pkt;
> @@ -800,7 +800,7 @@ void tipc_detach_loopback(struct net *net)
>   	struct tipc_net *tn = tipc_net(net);
>   
>   	dev_remove_pack(&tn->loopback_pt);
> -	dev_put(net->loopback_dev);
> +	dev_put_track(net->loopback_dev, &tn->loopback_pt.dev_tracker);
>   }
>   
>   /* Caller should hold rtnl_lock to protect the bearer */
Acked-by: Jon Maloy <jmaloy@redhat.com>

