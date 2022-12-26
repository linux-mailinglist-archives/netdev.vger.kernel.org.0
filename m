Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1154C65661E
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 00:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbiLZXjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 18:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbiLZXjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 18:39:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30878317
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 15:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672097911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ezEM/TKhEZZEiA0qvJ103L6FIDKOFYr7NEo4WCCY3ZI=;
        b=d15TV1CZsQW0FLIM61cYRBQQtheP5QSmKgzF0vM5N9wa2MWJQwZD07KIyw9mYRcGowlXgx
        FxmeQ1qTr+XWhY1wCSgyhSpq8iRx/sggkuKSLZ8wz9GdnQDRuKS1WrNM7dJ2l+KddriLev
        eKQa7O7V1/2sIxKeacW05p6rmkVhMSM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-110-4gQZ5UnrPYiMbBzW92aovA-1; Mon, 26 Dec 2022 18:38:29 -0500
X-MC-Unique: 4gQZ5UnrPYiMbBzW92aovA-1
Received: by mail-ej1-f72.google.com with SMTP id qb2-20020a1709077e8200b00842b790008fso8146504ejc.21
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 15:38:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezEM/TKhEZZEiA0qvJ103L6FIDKOFYr7NEo4WCCY3ZI=;
        b=YtpT9ZF9pnNFV3aE0dzeG/bdJDLD8aLHcq4oUzt11//R/YueI3RaBe6QVn8EXFZrgo
         iHV3OIY+llpbBog+CBlb5nqLBeKli+kzgBdabExUQI4CH3x/Xq+uIgfDK4v0Zu7bitj9
         nBSGuT/97bVDelP2ccDXyb0TKdW5PUrLzOD9iMlNFcVeVSns4shVkcIkoRb0cxmCoEIZ
         BJG5JsmOvukRr7kXmVLnvWTvTZQYARYf+w5B8Bo1oJMi0fQO5rboY/kJjqSteJZGEqv3
         HjcQSTAock3vdEX21wZ1C9OZe8ZUILvGFFCtoNC4OGnBZjza+cUyJQPNGlAj5N78FHeE
         rZAw==
X-Gm-Message-State: AFqh2kpwlC96odKWHHsOzu8mGVCniRp5mRcAnqZvu1+4efBqf0kQLb29
        F3mIUShZlq2mM2Co3SkoIlqhXqlNtuuxJPR8AVuVftjKRtJk8wJl15V0CTjaF/WdWn7INFK4Y1N
        Ol/DmdmwardAPjwxn
X-Received: by 2002:a17:906:184a:b0:78d:f456:1ed0 with SMTP id w10-20020a170906184a00b0078df4561ed0mr21402803eje.33.1672097908811;
        Mon, 26 Dec 2022 15:38:28 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtbl7ganWCzrQFMRWt4QOxuXB0jibHQVxPMd+xdjGiQv6CVnMTaniUeiSPcYYhXQnXClNYHAA==
X-Received: by 2002:a17:906:184a:b0:78d:f456:1ed0 with SMTP id w10-20020a170906184a00b0078df4561ed0mr21402774eje.33.1672097908469;
        Mon, 26 Dec 2022 15:38:28 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id s10-20020a1709064d8a00b007815ca7ae57sm5362124eju.212.2022.12.26.15.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 15:38:28 -0800 (PST)
Date:   Mon, 26 Dec 2022 18:38:24 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Message-ID: <20221226183705-mutt-send-email-mst@kernel.org>
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-4-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226074908.8154-4-jasowang@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 03:49:07PM +0800, Jason Wang wrote:
> This patch introduces a per virtqueue waitqueue to allow driver to
> sleep and wait for more used. Two new helpers are introduced to allow
> driver to sleep and wake up.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes since V1:
> - check virtqueue_is_broken() as well
> - use more_used() instead of virtqueue_get_buf() to allow caller to
>   get buffers afterwards
> ---
>  drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
>  include/linux/virtio.h       |  3 +++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 5cfb2fa8abee..9c83eb945493 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -13,6 +13,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/kmsan.h>
>  #include <linux/spinlock.h>
> +#include <linux/wait.h>
>  #include <xen/xen.h>
>  
>  #ifdef DEBUG
> @@ -60,6 +61,7 @@
>  			"%s:"fmt, (_vq)->vq.name, ##args);	\
>  		/* Pairs with READ_ONCE() in virtqueue_is_broken(). */ \
>  		WRITE_ONCE((_vq)->broken, true);		       \
> +		wake_up_interruptible(&(_vq)->wq);		       \
>  	} while (0)
>  #define START_USE(vq)
>  #define END_USE(vq)
> @@ -203,6 +205,9 @@ struct vring_virtqueue {
>  	/* DMA, allocation, and size information */
>  	bool we_own_ring;
>  
> +	/* Wait for buffer to be used */
> +	wait_queue_head_t wq;
> +
>  #ifdef DEBUG
>  	/* They're supposed to lock for us. */
>  	unsigned int in_use;
> @@ -2024,6 +2029,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
>  	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>  		vq->weak_barriers = false;
>  
> +	init_waitqueue_head(&vq->wq);
> +
>  	err = vring_alloc_state_extra_packed(&vring_packed);
>  	if (err)
>  		goto err_state_extra;
> @@ -2517,6 +2524,8 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
>  	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>  		vq->weak_barriers = false;
>  
> +	init_waitqueue_head(&vq->wq);
> +
>  	err = vring_alloc_state_extra_split(vring_split);
>  	if (err) {
>  		kfree(vq);
> @@ -2654,6 +2663,8 @@ static void vring_free(struct virtqueue *_vq)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
>  
> +	wake_up_interruptible(&vq->wq);
> +
>  	if (vq->we_own_ring) {
>  		if (vq->packed_ring) {
>  			vring_free_queue(vq->vq.vdev,
> @@ -2863,4 +2874,22 @@ const struct vring *virtqueue_get_vring(struct virtqueue *vq)
>  }
>  EXPORT_SYMBOL_GPL(virtqueue_get_vring);
>  
> +int virtqueue_wait_for_used(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	/* TODO: Tweak the timeout. */
> +	return wait_event_interruptible_timeout(vq->wq,
> +	       virtqueue_is_broken(_vq) || more_used(vq), HZ);

BTW undocumented that you also make it interruptible.
So if we get an interrupt then this will fail.
But device is still going and will later use the buffers.

Same for timeout really.



> +}
> +EXPORT_SYMBOL_GPL(virtqueue_wait_for_used);
> +
> +void virtqueue_wake_up(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	wake_up_interruptible(&vq->wq);
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_wake_up);
> +
>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index dcab9c7e8784..2eb62c774895 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -72,6 +72,9 @@ void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
>  void *virtqueue_get_buf_ctx(struct virtqueue *vq, unsigned int *len,
>  			    void **ctx);
>  
> +int virtqueue_wait_for_used(struct virtqueue *vq);
> +void virtqueue_wake_up(struct virtqueue *vq);
> +
>  void virtqueue_disable_cb(struct virtqueue *vq);
>  
>  bool virtqueue_enable_cb(struct virtqueue *vq);
> -- 
> 2.25.1

