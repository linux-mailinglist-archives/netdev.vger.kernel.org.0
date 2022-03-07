Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C2C4D0AE2
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343724AbiCGWTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343718AbiCGWS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:18:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57B0347AC4
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 14:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646691482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iFnTaI43lavXr0zuCkHA2ZcyUcWqspn6tFseaLpKUCE=;
        b=jI8rsE0dVuztYUBZAiGb5jX/970D2Suda8Kbc61nYw0E1b0x48ZU1qNALumJsnUs6lsZXI
        1lyu4wncOQX0ONy1nyD7MWdBJ5beNoSXcU0HZ130PuGdyDbaJqp+CUh8rGqb7kNS2xVkK9
        hXiTluGMcZSEILW+S3qMFuz1mvE1zsk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-nF5SytlBOGeW30AibMi9tQ-1; Mon, 07 Mar 2022 17:18:01 -0500
X-MC-Unique: nF5SytlBOGeW30AibMi9tQ-1
Received: by mail-ed1-f71.google.com with SMTP id e10-20020a056402190a00b00410f20467abso9414175edz.14
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 14:18:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iFnTaI43lavXr0zuCkHA2ZcyUcWqspn6tFseaLpKUCE=;
        b=1reQfDsbAsiFp27qzicuUxPu7t/fOssOedw/1ecyC994EKW7+ZzEr/RUf6yoDwi9FS
         eOAW8au3KSDTZJaSa5QpaLPl6mPdJoTylx9D8w7P3lLsU2R2ssDW2baihtoYiFPlgaeH
         JoWhO/hpnri016EbfTrXTY3AjbT3rGXZXgHVADX38I91amxJQ8tdVU0SZk7SWZgkOVMo
         EUA9ZdZ74SHBv+0KpHQlIsvvYf66WLD39WcKp46QvsLqvDvw+8Gk0JbhEsaCHcqOot1d
         Y8YIGUyVwSEEgQTjd+BchrIxH68X/0vwmRYxKMdjZX+YSsmZs+kk2n28Bug6Q/kf0bDq
         T+zQ==
X-Gm-Message-State: AOAM530dnckM0WALXEHGfFd6vun7iNwoaB/vj1KG6OHAqTsZ6Fsd0T1/
        SzZqhdMWQTAETdAuDypaG2VJHRDaXufgw15sBJzDDhRkYENKERBofgtpsv/64YsSTdHAKDDjsSf
        jhIehmdIlFNk/Kj3H
X-Received: by 2002:a17:907:3e9a:b0:6db:b5e:676c with SMTP id hs26-20020a1709073e9a00b006db0b5e676cmr8489736ejc.314.1646691479810;
        Mon, 07 Mar 2022 14:17:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDeGEIDmtuFmkZLr82drLK9sutEnJoYFwl22WhDCUdWElmN9EcTUW1/sSRnLfyl48w2KixZw==
X-Received: by 2002:a17:907:3e9a:b0:6db:b5e:676c with SMTP id hs26-20020a1709073e9a00b006db0b5e676cmr8489720ejc.314.1646691479562;
        Mon, 07 Mar 2022 14:17:59 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b00410bf015567sm6554353edt.92.2022.03.07.14.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:17:58 -0800 (PST)
Date:   Mon, 7 Mar 2022 17:17:51 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v6 06/26] virtio_ring: packed: extrace the logic of
 creating vring
Message-ID: <20220307171629-mutt-send-email-mst@kernel.org>
References: <20220224081102.80224-1-xuanzhuo@linux.alibaba.com>
 <20220224081102.80224-7-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224081102.80224-7-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 04:10:42PM +0800, Xuan Zhuo wrote:
> Separate the logic of packed to create vring queue.
> 
> For the convenience of passing parameters, add a structure
> vring_packed.
> 
> This feature is required for subsequent virtuqueue reset vring.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Subject has a typo.
Besides:

> ---
>  drivers/virtio/virtio_ring.c | 121 ++++++++++++++++++++++++++---------
>  1 file changed, 92 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index dc6313b79305..41864c5e665f 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -92,6 +92,18 @@ struct vring_split {
>  	struct vring vring;
>  };
>  
> +struct vring_packed {
> +	u32 num;
> +	struct vring_packed_desc *ring;
> +	struct vring_packed_desc_event *driver;
> +	struct vring_packed_desc_event *device;
> +	dma_addr_t ring_dma_addr;
> +	dma_addr_t driver_event_dma_addr;
> +	dma_addr_t device_event_dma_addr;
> +	size_t ring_size_in_bytes;
> +	size_t event_size_in_bytes;
> +};
> +
>  struct vring_virtqueue {
>  	struct virtqueue vq;
>  
> @@ -1683,45 +1695,101 @@ static struct vring_desc_extra *vring_alloc_desc_extra(struct vring_virtqueue *v
>  	return desc_extra;
>  }
>  
> -static struct virtqueue *vring_create_virtqueue_packed(
> -	unsigned int index,
> -	unsigned int num,
> -	unsigned int vring_align,
> -	struct virtio_device *vdev,
> -	bool weak_barriers,
> -	bool may_reduce_num,
> -	bool context,
> -	bool (*notify)(struct virtqueue *),
> -	void (*callback)(struct virtqueue *),
> -	const char *name)
> +static void vring_free_vring_packed(struct vring_packed *vring,
> +				    struct virtio_device *vdev)
> +{
> +	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
> +	struct vring_packed_desc_event *driver, *device;
> +	size_t ring_size_in_bytes, event_size_in_bytes;
> +	struct vring_packed_desc *ring;
> +
> +	ring                  = vring->ring;
> +	driver                = vring->driver;
> +	device                = vring->device;
> +	ring_dma_addr         = vring->ring_size_in_bytes;
> +	event_size_in_bytes   = vring->event_size_in_bytes;
> +	ring_dma_addr         = vring->ring_dma_addr;
> +	driver_event_dma_addr = vring->driver_event_dma_addr;
> +	device_event_dma_addr = vring->device_event_dma_addr;
> +
> +	if (device)
> +		vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
> +
> +	if (driver)
> +		vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dma_addr);
> +
> +	if (ring)
> +		vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);

ring_size_in_bytes is uninitialized here.

Which begs the question how was this tested patchset generally and
this patch in particular.
Please add note on tested configurations and tests run to the patchset.

> +}
> +
> +static int vring_create_vring_packed(struct vring_packed *vring,
> +				    struct virtio_device *vdev,
> +				    u32 num)
>  {
> -	struct vring_virtqueue *vq;
>  	struct vring_packed_desc *ring;
>  	struct vring_packed_desc_event *driver, *device;
>  	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
>  	size_t ring_size_in_bytes, event_size_in_bytes;
>  
> +	memset(vring, 0, sizeof(*vring));
> +
>  	ring_size_in_bytes = num * sizeof(struct vring_packed_desc);
>  
>  	ring = vring_alloc_queue(vdev, ring_size_in_bytes,
>  				 &ring_dma_addr,
>  				 GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
>  	if (!ring)
> -		goto err_ring;
> +		goto err;
> +
> +	vring->num = num;
> +	vring->ring = ring;
> +	vring->ring_size_in_bytes = ring_size_in_bytes;
> +	vring->ring_dma_addr = ring_dma_addr;
>  
>  	event_size_in_bytes = sizeof(struct vring_packed_desc_event);
> +	vring->event_size_in_bytes = event_size_in_bytes;
>  
>  	driver = vring_alloc_queue(vdev, event_size_in_bytes,
>  				   &driver_event_dma_addr,
>  				   GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
>  	if (!driver)
> -		goto err_driver;
> +		goto err;
> +
> +	vring->driver = driver;
> +	vring->driver_event_dma_addr = driver_event_dma_addr;
>  
>  	device = vring_alloc_queue(vdev, event_size_in_bytes,
>  				   &device_event_dma_addr,
>  				   GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
>  	if (!device)
> -		goto err_device;
> +		goto err;
> +
> +	vring->device = device;
> +	vring->device_event_dma_addr = device_event_dma_addr;
> +	return 0;
> +
> +err:
> +	vring_free_vring_packed(vring, vdev);
> +	return -ENOMEM;
> +}
> +
> +static struct virtqueue *vring_create_virtqueue_packed(
> +	unsigned int index,
> +	unsigned int num,
> +	unsigned int vring_align,
> +	struct virtio_device *vdev,
> +	bool weak_barriers,
> +	bool may_reduce_num,
> +	bool context,
> +	bool (*notify)(struct virtqueue *),
> +	void (*callback)(struct virtqueue *),
> +	const char *name)
> +{
> +	struct vring_virtqueue *vq;
> +	struct vring_packed vring;
> +
> +	if (vring_create_vring_packed(&vring, vdev, num))
> +		goto err_vq;
>  
>  	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
>  	if (!vq)
> @@ -1753,17 +1821,17 @@ static struct virtqueue *vring_create_virtqueue_packed(
>  	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>  		vq->weak_barriers = false;
>  
> -	vq->packed.ring_dma_addr = ring_dma_addr;
> -	vq->packed.driver_event_dma_addr = driver_event_dma_addr;
> -	vq->packed.device_event_dma_addr = device_event_dma_addr;
> +	vq->packed.ring_dma_addr = vring.ring_dma_addr;
> +	vq->packed.driver_event_dma_addr = vring.driver_event_dma_addr;
> +	vq->packed.device_event_dma_addr = vring.device_event_dma_addr;
>  
> -	vq->packed.ring_size_in_bytes = ring_size_in_bytes;
> -	vq->packed.event_size_in_bytes = event_size_in_bytes;
> +	vq->packed.ring_size_in_bytes = vring.ring_size_in_bytes;
> +	vq->packed.event_size_in_bytes = vring.event_size_in_bytes;
>  
>  	vq->packed.vring.num = num;
> -	vq->packed.vring.desc = ring;
> -	vq->packed.vring.driver = driver;
> -	vq->packed.vring.device = device;
> +	vq->packed.vring.desc = vring.ring;
> +	vq->packed.vring.driver = vring.driver;
> +	vq->packed.vring.device = vring.device;
>  
>  	vq->packed.next_avail_idx = 0;
>  	vq->packed.avail_wrap_counter = 1;
> @@ -1804,12 +1872,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>  err_desc_state:
>  	kfree(vq);
>  err_vq:
> -	vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
> -err_device:
> -	vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dma_addr);
> -err_driver:
> -	vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
> -err_ring:
> +	vring_free_vring_packed(&vring, vdev);
>  	return NULL;
>  }
>  
> -- 
> 2.31.0

