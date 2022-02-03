Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208ED4A80BD
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 09:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245587AbiBCI5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 03:57:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231890AbiBCI5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 03:57:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643878635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WOTRayCLtVWzycM1y6QihcwmBhq3lcQtiLDihDeAQkU=;
        b=iE8ZxEbBukXbpKCa9az6KRA6UdS+7nXR/BNyeSs6VDyxWImxyqybqXoHRUZ0S17JHkXmVd
        s47QbtQPOOW1PFkmYHKrBL+01/gvEMRbW5JZPgIiP78dhKkUdNrN14bUWITUNgKuQgt/HE
        LuCu/3NFlA7CPidwdzOcVoQfa6G6+m4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-ktQqSsBuMciQz-Fzgj_sYA-1; Thu, 03 Feb 2022 03:57:14 -0500
X-MC-Unique: ktQqSsBuMciQz-Fzgj_sYA-1
Received: by mail-wm1-f72.google.com with SMTP id o140-20020a1ca592000000b00350aef3949aso479786wme.5
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 00:57:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WOTRayCLtVWzycM1y6QihcwmBhq3lcQtiLDihDeAQkU=;
        b=zdMDRoMgWjjveBct9/rw/2KlZ1Szmea3nN34qNvBDHKg2EkfeELPNcQOJWgBr315vQ
         YHLHqryN6rma/p5Umo9FQ16P1UF2S82QTlH6OHlz6QJX98g3qyqlkd+AHxYWd+QT+PnI
         fSzb04fV9hG3wURDOOxsRr06E/cw+mYXCwmozfHuVZMuQkR2e/Ja7GKGjLU6/d1Npq0c
         fFWEI62tDbT22k4KjeuLTW3hUl+8sFQMf8AOeGs3CGb0b+SBhWxXUDOYahCTcr+ggcfJ
         vM20PrNuZN4IW9l48K4nfcLwrzADlyieTOOtg53czJi5dcK3OSScrNOY9NvpKmJBSJOP
         6yLQ==
X-Gm-Message-State: AOAM531YOuWmad/IyEBvgmsOHKKQ++yZwMnJD94aXEaWZlbx3fR8O4hv
        a5RbVkKzt8GY5J2S+wjLDJaG/Z3/5ZBYbSJBxXJ95l4Cm1mIsoJs0zpbnx4hR0wTICIoIL9+f4s
        HXgGxG3vNBRjvbs9u
X-Received: by 2002:a05:600c:48a:: with SMTP id d10mr9474256wme.100.1643878632975;
        Thu, 03 Feb 2022 00:57:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxiOEvw2Ej+xlWaz3QeHUe4Jmc4tcEW9BGiIJnbm0avxB5xo/ivaaMwYiroblLirDwxftw+9A==
X-Received: by 2002:a05:600c:48a:: with SMTP id d10mr9474236wme.100.1643878632755;
        Thu, 03 Feb 2022 00:57:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id l10sm19348971wrz.20.2022.02.03.00.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 00:57:12 -0800 (PST)
Message-ID: <90c19324a093536f1e0e2e3de3a36df4207a28d3.camel@redhat.com>
Subject: Re: [PATCH net-next 02/15] ipv6: add dev->gso_ipv6_max_size
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Date:   Thu, 03 Feb 2022 09:57:11 +0100
In-Reply-To: <20220203015140.3022854-3-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
         <20220203015140.3022854-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This enable TCP stack to build TSO packets bigger than
> 64KB if the driver is LSOv2 compatible.
> 
> This patch introduces new variable gso_ipv6_max_size
> that is modifiable through ip link.
> 
> ip link set dev eth0 gso_ipv6_max_size 185000
> 
> User input is capped by driver limit.
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/netdevice.h          | 12 ++++++++++++
>  include/uapi/linux/if_link.h       |  1 +
>  net/core/dev.c                     |  1 +
>  net/core/rtnetlink.c               | 15 +++++++++++++++
>  net/core/sock.c                    |  6 ++++++
>  tools/include/uapi/linux/if_link.h |  1 +
>  6 files changed, 36 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index b1f68df2b37bc4b623f61cc2c6f0c02ba2afbe02..2a563869ba44f7d48095d36b1395e3fbd8cfff87 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1949,6 +1949,7 @@ enum netdev_ml_priv_type {
>   *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
>   *	@watchdog_dev_tracker:	refcount tracker used by watchdog.
>   *	@tso_ipv6_max_size:	Maximum size of IPv6 TSO packets (driver/NIC limit)
> + *	@gso_ipv6_max_size:	Maximum size of IPv6 GSO packets (user/admin limit)
>   *
>   *	FIXME: cleanup struct net_device such that network protocol info
>   *	moves out.
> @@ -2284,6 +2285,7 @@ struct net_device {
>  	netdevice_tracker	linkwatch_dev_tracker;
>  	netdevice_tracker	watchdog_dev_tracker;
>  	unsigned int		tso_ipv6_max_size;
> +	unsigned int		gso_ipv6_max_size;
>  };
>  #define to_net_dev(d) container_of(d, struct net_device, dev)
>  
> @@ -4804,6 +4806,10 @@ static inline void netif_set_gso_max_size(struct net_device *dev,
>  {
>  	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
>  	WRITE_ONCE(dev->gso_max_size, size);
> +
> +	/* legacy drivers want to lower gso_max_size, regardless of family. */
> +	size = min(size, dev->gso_ipv6_max_size);
> +	WRITE_ONCE(dev->gso_ipv6_max_size, size);
>  }
>  
>  static inline void netif_set_gso_max_segs(struct net_device *dev,
> @@ -4827,6 +4833,12 @@ static inline void netif_set_tso_ipv6_max_size(struct net_device *dev,
>  	dev->tso_ipv6_max_size = size;
>  }
>  
> +static inline void netif_set_gso_ipv6_max_size(struct net_device *dev,
> +					       unsigned int size)
> +{
> +	size = min(size, dev->tso_ipv6_max_size);
> +	WRITE_ONCE(dev->gso_ipv6_max_size, size);

Dumb questions on my side: should the above be limited to
tso_ipv6_max_size ? or increasing gso_ipv6_max_size helps even if the
egress NIC does not support LSOv2?

Should gso_ipv6_max_size be capped to some reasonable value (well lower
than 4G), to avoid the stack building very complex skbs?

Thanks!

Paolo

