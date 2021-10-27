Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C11243CD95
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242801AbhJ0Pde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:33:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242798AbhJ0Pdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635348668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NlA3nQ1QJzVNgnX+dWY9bZTNzaWdxEwvFkBavyJU+R8=;
        b=Mt4pHa1lvmKIJsNI079UNC8Ef68dxGt/L0TseyC0Kgf2SkvLZbUBK7lwKVxu6n5IN5t0UW
        pjPNmILp9zn8A4EoQMSgmc0XBV3f7qfavzYO5DSFUmTrH7d5Fhw8NG14LJvd59l0DLYsEn
        rSjwNt6G0m7DaYR5qr3hkkkIWQX3srw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-YHRgTFSmPmqUtUcRM4S6jA-1; Wed, 27 Oct 2021 11:31:05 -0400
X-MC-Unique: YHRgTFSmPmqUtUcRM4S6jA-1
Received: by mail-wr1-f72.google.com with SMTP id u15-20020a5d514f000000b001687ebddea3so801420wrt.8
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 08:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NlA3nQ1QJzVNgnX+dWY9bZTNzaWdxEwvFkBavyJU+R8=;
        b=nQHCDE8Ao9QXEDYIsGuQ0kfsSn71WYWT2CoJHj1gqc4HnQcTLGohxmP7rr0RqkQ06T
         /S+NI38lFpJii9XXx1Oz2TYb914jXE8HbnBo5QLyYJyapMjxVWEkCboIuerah1STMPJW
         QxMy4+fvMmquVMI1WQK/KxyyfQHiDpix2Fl+zlEh8OQ0LzWIrVJWziYt2eFHTXF/jFs+
         ELMtsu9888UTi7jx1Q4QzN34jhoFsYWq39rQLzx7onSvd6wEPIllEOPTsJrDCXW87R1K
         qy65nxMqfOzPjctiChVhq5791aAJz8iWo30NUdZSoEozYEMTd8ffzyGKUfSl2mzcNEGF
         m5AA==
X-Gm-Message-State: AOAM532q3M2FU/GlPXeZolXb9SqWyl/HAPO7kLLMbg2BWyMEb1d7+tDt
        XLmwesVJ/OYVUfdKWPP22wjYt6KDzLJtedPgKAefoLZ4OVIeFOZFekjt4NY30/e5yckrFevN9v6
        CVU7TaA/m3ij+Sh+8
X-Received: by 2002:a5d:6441:: with SMTP id d1mr36123794wrw.208.1635348664576;
        Wed, 27 Oct 2021 08:31:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwja2+cAsX5qhyqxBAK7VZupFPj2JJ88axvhWNqQ4Jrw2r9FC4mm7+Txvs4mKv41SaXVzhbog==
X-Received: by 2002:a5d:6441:: with SMTP id d1mr36123776wrw.208.1635348664436;
        Wed, 27 Oct 2021 08:31:04 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:a543:72f:c4d1:8911:6346])
        by smtp.gmail.com with ESMTPSA id n11sm198454wrs.14.2021.10.27.08.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 08:31:03 -0700 (PDT)
Date:   Wed, 27 Oct 2021 11:30:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2] net: virtio: use eth_hw_addr_set()
Message-ID: <20211027113033-mutt-send-email-mst@kernel.org>
References: <20211027152012.3393077-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027152012.3393077-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 08:20:12AM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.
> 
> Even though the current code uses dev->addr_len the we can switch
> to eth_hw_addr_set() instead of dev_addr_set(). The netdev is
> always allocated by alloc_etherdev_mq() and there are at least two
> places which assume Ethernet address:
>  - the line below calling eth_hw_addr_random()
>  - virtnet_set_mac_address() -> eth_commit_mac_addr_change()
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> v2: - actually switch to eth_hw_addr_set() not dev_addr_set()
>     - resize the buffer to ETH_ALEN
>     - pass ETH_ALEN instead of dev->dev_addr to virtio_cread_bytes()
> 
> CC: mst@redhat.com
> CC: jasowang@redhat.com
> CC: virtualization@lists.linux-foundation.org
> ---
>  drivers/net/virtio_net.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c501b5974aee..cc79343cd220 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	dev->max_mtu = MAX_MTU;
>  
>  	/* Configuration may specify what MAC to use.  Otherwise random. */
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> +		u8 addr[ETH_ALEN];
> +
>  		virtio_cread_bytes(vdev,
>  				   offsetof(struct virtio_net_config, mac),
> -				   dev->dev_addr, dev->addr_len);
> -	else
> +				   addr, ETH_ALEN);
> +		eth_hw_addr_set(dev, addr);
> +	} else {
>  		eth_hw_addr_random(dev);
> +	}
>  
>  	/* Set up our device-specific information */
>  	vi = netdev_priv(dev);
> -- 
> 2.31.1

