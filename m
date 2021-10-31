Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6983440EE4
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 15:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhJaOsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 10:48:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhJaOsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 10:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635691581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rq0X8V8MWJs5shRIzXsnMCP9VrwCGeQ+1+dswwtKpho=;
        b=Jh5NbYoA4kyc1ssNQIvQwdEhoWqi8HkeagBSMpC3hJ0IOxHzF8Pp+InH7r1Q6KPoZgEz0p
        +nV+y06wSxZ4Rh8r5VWEkyNIBSUn2Q49wwzvsQqCgVettuh912fkwZM38u3AwD43xnxOTo
        A9kkvlhjaHN1vBlim0wOTIQXodO3wfY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-PS5kTzsNMFe5wW-eGjTENw-1; Sun, 31 Oct 2021 10:46:20 -0400
X-MC-Unique: PS5kTzsNMFe5wW-eGjTENw-1
Received: by mail-wm1-f70.google.com with SMTP id a186-20020a1c7fc3000000b00332f1a308e7so429163wmd.3
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 07:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rq0X8V8MWJs5shRIzXsnMCP9VrwCGeQ+1+dswwtKpho=;
        b=0gVum/bc6bWrkxMAbHIm5pHfuOl2cK3Ku+hQ4+gw2K39pjEKOpyUgfN0WXJ4jpxPBD
         fTVK/M4sFQAek0m2S/pSms38sTYCY+kpman6qhzWCEP7xC5uPOeZtFAbzpS45xkNbkqX
         2sHEdOO9PaTSOapclWFQIQUbhSx6nH69Y622JKwsvMm5DsL7s4dK4eJsfRgNWAUHlYoM
         k1Bf4sv/gbogCcxJqfQbUpYbHMz9WpAPQTYlwnyOeq+Je3IUoBfEuu25ohYrgzYqDtvq
         a2HsSxwc5ILzKUHikiJhHsoGIWEk2g3Nk7Qo0ASxwYtis6ZdoRbOW5BGtgPrdBNYKs/F
         LH4g==
X-Gm-Message-State: AOAM532XIRx67QRpN2BvWjcOWHrKDV6WphPAIUyrwZJQqD+v9WzfdNZO
        4wPKC6ou/ufztSN/05mBY4cXVOprcrPSDEiuUvwp/2OW5hk+2nzOlnPHAFwngNWAiDADt/P5ZAW
        LJxfxBmL0qbcuaoya
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr14447291wrq.354.1635691578880;
        Sun, 31 Oct 2021 07:46:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNW5BMvqYJSwWOrWqsdmGINH6TmxHhfLuxvbRjmfkFm9OfpIDeST3V2IiHP44/RvQQmJQrCw==
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr14447261wrq.354.1635691578584;
        Sun, 31 Oct 2021 07:46:18 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:6500:1024:cbd2:401c:e583])
        by smtp.gmail.com with ESMTPSA id l11sm10869108wrt.49.2021.10.31.07.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 07:46:17 -0700 (PDT)
Date:   Sun, 31 Oct 2021 10:46:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 1/3] virtio: cache indirect desc for split
Message-ID: <20211031033157-mutt-send-email-mst@kernel.org>
References: <20211028104919.3393-1-xuanzhuo@linux.alibaba.com>
 <20211028104919.3393-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028104919.3393-2-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 06:49:17PM +0800, Xuan Zhuo wrote:
> In the case of using indirect, indirect desc must be allocated and
> released each time, which increases a lot of cpu overhead.
> 
> Here, a cache is added for indirect. If the number of indirect desc to be
> applied for is less than VIRT_QUEUE_CACHE_DESC_NUM, the desc array with
> the size of VIRT_QUEUE_CACHE_DESC_NUM is fixed and cached for reuse.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

What bothers me here is what happens if cache gets
filled on one numa node, then used on another?


> ---
>  drivers/virtio/virtio.c      |  6 +++
>  drivers/virtio/virtio_ring.c | 77 ++++++++++++++++++++++++++++++++----
>  include/linux/virtio.h       | 14 +++++++
>  3 files changed, 89 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 0a5b54034d4b..1047149ac2a4 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -431,6 +431,12 @@ bool is_virtio_device(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(is_virtio_device);
>  
> +void virtio_set_desc_cache(struct virtio_device *dev, u32 thr)
> +{
> +	dev->desc_cache_thr = thr;
> +}
> +EXPORT_SYMBOL_GPL(virtio_set_desc_cache);
> +
>  void unregister_virtio_device(struct virtio_device *dev)
>  {
>  	int index = dev->index; /* save for after device release */
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index dd95dfd85e98..0ebcd4f12d3b 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -117,6 +117,15 @@ struct vring_virtqueue {
>  	/* Hint for event idx: already triggered no need to disable. */
>  	bool event_triggered;
>  
> +	/* desc cache threshold
> +	 *    0   - disable desc cache
> +	 *    > 0 - enable desc cache. As the threshold of the desc cache.
> +	 */
> +	u32 desc_cache_thr;

not really descriptive. also pls eschew abbreviation.

> +
> +	/* desc cache chain */
> +	struct list_head desc_cache;

hmm this puts extra pressure on cache. you never need to drop
things in the middle. llist_head would be better I
think ... no?


> +
>  	union {
>  		/* Available for split ring */
>  		struct {
> @@ -423,7 +432,53 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
>  	return extra[i].next;
>  }
>  
> -static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
> +static void desc_cache_free(struct list_head *head)
> +{
> +	struct list_head *n, *pos;
> +
> +	BUILD_BUG_ON(sizeof(struct list_head) > sizeof(struct vring_desc));
> +	BUILD_BUG_ON(sizeof(struct list_head) > sizeof(struct vring_packed_desc));
> +
> +	list_for_each_prev_safe(pos, n, head)
> +		kfree(pos);
> +}
> +
> +static void __desc_cache_put(struct vring_virtqueue *vq,
> +			     struct list_head *node, int n)
> +{
> +	if (n <= vq->desc_cache_thr)
> +		list_add(node, &vq->desc_cache);
> +	else
> +		kfree(node);

this bothers me. Do we really need a full VQ's worth of
indirect descriptors? Can't we set a limit on how many
are used?


> +}
> +
> +#define desc_cache_put(vq, desc, n) \
> +	__desc_cache_put(vq, (struct list_head *)desc, n)

replace with an inline function pls. in fact we dont need
__desc_cache_put at all.


> +
> +static void *desc_cache_get(struct vring_virtqueue *vq,
> +			    int size, int n, gfp_t gfp)
> +{
> +	struct list_head *node;
> +
> +	if (n > vq->desc_cache_thr)
> +		return kmalloc_array(n, size, gfp);
> +
> +	if (!list_empty(&vq->desc_cache)) {
> +		node = vq->desc_cache.next;
> +		list_del(node);
> +		return node;
> +	}
> +
> +	return kmalloc_array(vq->desc_cache_thr, size, gfp);
> +}
> +
> +#define _desc_cache_get(vq, n, gfp, tp) \
> +	((tp *)desc_cache_get(vq, (sizeof(tp)), n, gfp))
> +
> +#define desc_cache_get_split(vq, n, gfp) \
> +	_desc_cache_get(vq, n, gfp, struct vring_desc)
> +

same thing here.

> +static struct vring_desc *alloc_indirect_split(struct vring_virtqueue *vq,
>  					       unsigned int total_sg,
>  					       gfp_t gfp)
>  {
> @@ -437,12 +492,12 @@ static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
>  	 */
>  	gfp &= ~__GFP_HIGHMEM;
>  
> -	desc = kmalloc_array(total_sg, sizeof(struct vring_desc), gfp);
> +	desc = desc_cache_get_split(vq, total_sg, gfp);
>  	if (!desc)
>  		return NULL;
>  
>  	for (i = 0; i < total_sg; i++)
> -		desc[i].next = cpu_to_virtio16(_vq->vdev, i + 1);
> +		desc[i].next = cpu_to_virtio16(vq->vq.vdev, i + 1);
>  	return desc;
>  }
>  
> @@ -508,7 +563,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>  	head = vq->free_head;
>  
>  	if (virtqueue_use_indirect(_vq, total_sg))
> -		desc = alloc_indirect_split(_vq, total_sg, gfp);
> +		desc = alloc_indirect_split(vq, total_sg, gfp);
>  	else {
>  		desc = NULL;
>  		WARN_ON_ONCE(total_sg > vq->split.vring.num && !vq->indirect);
> @@ -652,7 +707,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>  	}
>  
>  	if (indirect)
> -		kfree(desc);
> +		desc_cache_put(vq, desc, total_sg);
>  
>  	END_USE(vq);
>  	return -ENOMEM;
> @@ -717,7 +772,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  	if (vq->indirect) {
>  		struct vring_desc *indir_desc =
>  				vq->split.desc_state[head].indir_desc;
> -		u32 len;
> +		u32 len, n;
>  
>  		/* Free the indirect table, if any, now that it's unmapped. */
>  		if (!indir_desc)
> @@ -729,10 +784,12 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  				VRING_DESC_F_INDIRECT));
>  		BUG_ON(len == 0 || len % sizeof(struct vring_desc));
>  
> -		for (j = 0; j < len / sizeof(struct vring_desc); j++)
> +		n = len / sizeof(struct vring_desc);
> +
> +		for (j = 0; j < n; j++)
>  			vring_unmap_one_split_indirect(vq, &indir_desc[j]);
>  
> -		kfree(indir_desc);
> +		desc_cache_put(vq, indir_desc, n);
>  		vq->split.desc_state[head].indir_desc = NULL;
>  	} else if (ctx) {
>  		*ctx = vq->split.desc_state[head].indir_desc;
> @@ -2199,6 +2256,9 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>  		!context;
>  	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> +	vq->desc_cache_thr = vdev->desc_cache_thr;
> +
> +	INIT_LIST_HEAD(&vq->desc_cache);
>  
>  	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>  		vq->weak_barriers = false;

So e.g. for rx, we are wasting memory since indirect isn't used.


> @@ -2329,6 +2389,7 @@ void vring_del_virtqueue(struct virtqueue *_vq)
>  	if (!vq->packed_ring) {
>  		kfree(vq->split.desc_state);
>  		kfree(vq->split.desc_extra);
> +		desc_cache_free(&vq->desc_cache);
>  	}
>  	kfree(vq);
>  }
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 41edbc01ffa4..bda6f9853e97 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -118,6 +118,7 @@ struct virtio_device {
>  	struct list_head vqs;
>  	u64 features;
>  	void *priv;
> +	u32 desc_cache_thr;
>  };
>  
>  static inline struct virtio_device *dev_to_virtio(struct device *_dev)
> @@ -130,6 +131,19 @@ int register_virtio_device(struct virtio_device *dev);
>  void unregister_virtio_device(struct virtio_device *dev);
>  bool is_virtio_device(struct device *dev);
>  
> +/**
> + * virtio_set_desc_cache - set virtio ring desc cache threshold
> + *
> + * virtio will cache the allocated indirect desc.
> + *
> + * This function must be called before find_vqs.
> + *
> + * @thr:
> + *    0   - disable desc cache
> + *    > 0 - enable desc cache. As the threshold of the desc cache.
> + */
> +void virtio_set_desc_cache(struct virtio_device *dev, u32 thr);
> +
>  void virtio_break_device(struct virtio_device *dev);
>  
>  void virtio_config_changed(struct virtio_device *dev);
> -- 
> 2.31.0

