Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0DC43C3D0
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbhJ0HZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:25:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231641AbhJ0HZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635319405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kKwjUWtGswnRMdQI3v9sQff+PJbuXRHpBkdFH8zvQS8=;
        b=F6zvHl4lCvoz6Gg8+aGK338TZUWYRBv+T3VLq4xaKeLvrwpXiekgZ62dgXmrOW9tEMCGpP
        4R7CNJ3hjHFWO64lLBWw1IItkCfHaptcc9QJhX+au7Xnni6dUv4h52L6L/lyvrwlqz+yKW
        5w9r57+jLKeVFLF+QpXtFQwTfoZAKGw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-9op2gUYCPLKLR0-5ynMO-g-1; Wed, 27 Oct 2021 03:23:23 -0400
X-MC-Unique: 9op2gUYCPLKLR0-5ynMO-g-1
Received: by mail-wm1-f70.google.com with SMTP id b81-20020a1c8054000000b0032c9d428b7fso870138wmd.3
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 00:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kKwjUWtGswnRMdQI3v9sQff+PJbuXRHpBkdFH8zvQS8=;
        b=MY2YpqwC0WUwlrlzMw8qWyMvmUfuPnIBv8upPNZ/79zkobBH6Xp1NljpNzat9+uEBH
         9eV0xwg4QYSmZR2ba1eBMXPttKcjXBY7+8Tel3U0lo0e6ZKaPuHxjfQnYFyqXKckHMEP
         F28Ah4ubQbv4pjuYPpU12f4zjISS/+h84HpvKMCGraTOO/a3LLdr2jsFpYqQ2q4ql7os
         CE8Je4rluyndsn7Bx3CPOhc3ykScZNIMdePCbkiVuAR1thDO+x4NjiNHDcBeczIC3PQ1
         yeB8Hu0s08G1aHP0P7+6gVmwzYOrdUrvo8IgyxVXxXDoU9u+elP4PEuWqXVSEwGPMAVO
         3VVQ==
X-Gm-Message-State: AOAM530thsULhIwZVlV5x2TZzsbOjiuTR0FhZNCB0ReDqvDs2k3yVwJK
        7G4CjBIZNxKsP6JwaqwxXx7hdgQZzrCbkv+v/htp77ClgueIVywMHxh3c9TZ7ZfUPD9f5fzbhai
        3GFoYVdLfgjgWl8XG
X-Received: by 2002:adf:f28f:: with SMTP id k15mr4931503wro.86.1635319402507;
        Wed, 27 Oct 2021 00:23:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaV9JBTSXjkf98o2dkjaFTK9GIFBtEjH9xoFyu0KuDhxjriNpKUFW0HQUW6QxBma8zwjt32Q==
X-Received: by 2002:adf:f28f:: with SMTP id k15mr4931493wro.86.1635319402370;
        Wed, 27 Oct 2021 00:23:22 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:a543:72f:c4d1:8911:6346])
        by smtp.gmail.com with ESMTPSA id t12sm2683586wmq.44.2021.10.27.00.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 00:23:21 -0700 (PDT)
Date:   Wed, 27 Oct 2021 03:23:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next] net: virtio: use eth_hw_addr_set()
Message-ID: <20211027032113-mutt-send-email-mst@kernel.org>
References: <20211026175634.3198477-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026175634.3198477-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 10:56:34AM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> CC: mst@redhat.com
> CC: jasowang@redhat.com
> CC: virtualization@lists.linux-foundation.org
> ---
>  drivers/net/virtio_net.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c501b5974aee..b7f35aff8e82 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	dev->max_mtu = MAX_MTU;
>  
>  	/* Configuration may specify what MAC to use.  Otherwise random. */
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> +		u8 addr[MAX_ADDR_LEN];
> +
>  		virtio_cread_bytes(vdev,
>  				   offsetof(struct virtio_net_config, mac),
> -				   dev->dev_addr, dev->addr_len);
> -	else
> +				   addr, dev->addr_len);

Maybe BUG_ON(dev->addr_len > sizeof addr);

here just to make sure we don't overflow addr silently?


> +		dev_addr_set(dev, addr);
> +	} else {
>  		eth_hw_addr_random(dev);
> +	}
>  
>  	/* Set up our device-specific information */
>  	vi = netdev_priv(dev);
> -- 
> 2.31.1

