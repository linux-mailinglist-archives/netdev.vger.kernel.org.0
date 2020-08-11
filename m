Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB0B24198D
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 12:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgHKKTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 06:19:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52564 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728460AbgHKKTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 06:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597141155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=09X4aaxeRy7786K3aAn8lJF+mFrpfZwelgc9Rj/h/cA=;
        b=NBMQuLS65Cg9V1bbk0ufvytORPHchSc3UClslg+fx8XvLyiPn8icchz+FKvhOSB0zCaPAU
        oxFpA9gfw8TX/LiCGr+skDB0Lnvta2O2H3Gfm1Ujd9j7lpovHtJg8IO+EphOAhi0IoENUI
        08epfi8ifVjiT9VTfGJAIuxBqD/jbhM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-YHEwUAFYOa-b_gAS6eLqHg-1; Tue, 11 Aug 2020 06:19:12 -0400
X-MC-Unique: YHEwUAFYOa-b_gAS6eLqHg-1
Received: by mail-wm1-f70.google.com with SMTP id a5so683276wmj.5
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 03:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=09X4aaxeRy7786K3aAn8lJF+mFrpfZwelgc9Rj/h/cA=;
        b=Qiz8OGV30AYBQTblisUIq+R6H9HvXVmVNiM8zMDTNdb0hfSf7+Ux7HHPf+A58d4Zez
         4vcH7Pskui+azVQ8RyWOhLIhfqZiJNrtDfAEs3egOr0f1x0hTvBm1+N4oDFwCg3lwe3g
         w2xJYpd+lCv0wVhsg++XLtu0Z1SHni4Arc3R1LVVT4GQtyPc2dNmGef51omYNsBCxXSH
         F3lARZUiLGhaBlHFd4c6lSKqKCAQdE6LSGZZNl2mzv6y9mm29tZvdwM7EhA4svMI4poc
         Skio1E/9asRktserLUoQOkd7+SgLLMcPsFtv4jbRaM6rhl8A0BUmr0kg+V8I373daGEY
         +FrQ==
X-Gm-Message-State: AOAM531zPIT80zI6ijxtiKjnNW5ZnlmM9BdQ1ZgsbUT/p59r+0ZyXZvk
        dDFCcdIsEmQQh0WDUP9UiCpoRT0JeADfRpQHIb7cXUlosdBQVfH/MBRCKrySkHU9ruJViOmopAz
        IWYniQE8VJy+QkTWl
X-Received: by 2002:a5d:5588:: with SMTP id i8mr28830881wrv.177.1597141151479;
        Tue, 11 Aug 2020 03:19:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpVw0KHTkWj9zAvvQ6fy1E+bZP88HTv291tUDUPRHDJbOscx/iYuJW4Tswm9/demRPo6L7cQ==
X-Received: by 2002:a5d:5588:: with SMTP id i8mr28830856wrv.177.1597141151241;
        Tue, 11 Aug 2020 03:19:11 -0700 (PDT)
Received: from redhat.com (bzq-79-180-0-181.red.bezeqint.net. [79.180.0.181])
        by smtp.gmail.com with ESMTPSA id b11sm17091195wrq.32.2020.08.11.03.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 03:19:10 -0700 (PDT)
Date:   Tue, 11 Aug 2020 06:19:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eli@mellanox.com, lulu@redhat.com
Subject: Re: [PATCH] vhost: vdpa: remove per device feature whitelist
Message-ID: <20200811061840-mutt-send-email-mst@kernel.org>
References: <20200720085043.16485-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720085043.16485-1-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 04:50:43PM +0800, Jason Wang wrote:
> We used to have a per device feature whitelist to filter out the
> unsupported virtio features. But this seems unnecessary since:
> 
> - the main idea behind feature whitelist is to block control vq
>   feature until we finalize the control virtqueue API. But the current
>   vhost-vDPA uAPI is sufficient to support control virtqueue. For
>   device that has hardware control virtqueue, the vDPA device driver
>   can just setup the hardware virtqueue and let userspace to use
>   hardware virtqueue directly. For device that doesn't have a control
>   virtqueue, the vDPA device driver need to use e.g vringh to emulate
>   a software control virtqueue.
> - we don't do it in virtio-vDPA driver
> 
> So remove this limitation.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>


Thinking about it, should we block some bits?
E.g. access_platform?
they depend on qemu not vdpa ...

> ---
>  drivers/vhost/vdpa.c | 37 -------------------------------------
>  1 file changed, 37 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 77a0c9fb6cc3..f7f6ddd681ce 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -26,35 +26,6 @@
>  
>  #include "vhost.h"
>  
> -enum {
> -	VHOST_VDPA_FEATURES =
> -		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> -		(1ULL << VIRTIO_F_ANY_LAYOUT) |
> -		(1ULL << VIRTIO_F_VERSION_1) |
> -		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
> -		(1ULL << VIRTIO_F_RING_PACKED) |
> -		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
> -		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> -		(1ULL << VIRTIO_RING_F_EVENT_IDX),
> -
> -	VHOST_VDPA_NET_FEATURES = VHOST_VDPA_FEATURES |
> -		(1ULL << VIRTIO_NET_F_CSUM) |
> -		(1ULL << VIRTIO_NET_F_GUEST_CSUM) |
> -		(1ULL << VIRTIO_NET_F_MTU) |
> -		(1ULL << VIRTIO_NET_F_MAC) |
> -		(1ULL << VIRTIO_NET_F_GUEST_TSO4) |
> -		(1ULL << VIRTIO_NET_F_GUEST_TSO6) |
> -		(1ULL << VIRTIO_NET_F_GUEST_ECN) |
> -		(1ULL << VIRTIO_NET_F_GUEST_UFO) |
> -		(1ULL << VIRTIO_NET_F_HOST_TSO4) |
> -		(1ULL << VIRTIO_NET_F_HOST_TSO6) |
> -		(1ULL << VIRTIO_NET_F_HOST_ECN) |
> -		(1ULL << VIRTIO_NET_F_HOST_UFO) |
> -		(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> -		(1ULL << VIRTIO_NET_F_STATUS) |
> -		(1ULL << VIRTIO_NET_F_SPEED_DUPLEX),
> -};
> -
>  /* Currently, only network backend w/o multiqueue is supported. */
>  #define VHOST_VDPA_VQ_MAX	2
>  
> @@ -79,10 +50,6 @@ static DEFINE_IDA(vhost_vdpa_ida);
>  
>  static dev_t vhost_vdpa_major;
>  
> -static const u64 vhost_vdpa_features[] = {
> -	[VIRTIO_ID_NET] = VHOST_VDPA_NET_FEATURES,
> -};
> -
>  static void handle_vq_kick(struct vhost_work *work)
>  {
>  	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> @@ -255,7 +222,6 @@ static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
>  	u64 features;
>  
>  	features = ops->get_features(vdpa);
> -	features &= vhost_vdpa_features[v->virtio_id];
>  
>  	if (copy_to_user(featurep, &features, sizeof(features)))
>  		return -EFAULT;
> @@ -279,9 +245,6 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
>  	if (copy_from_user(&features, featurep, sizeof(features)))
>  		return -EFAULT;
>  
> -	if (features & ~vhost_vdpa_features[v->virtio_id])
> -		return -EINVAL;
> -
>  	if (ops->set_features(vdpa, features))
>  		return -EINVAL;
>  
> -- 
> 2.20.1

