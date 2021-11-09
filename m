Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F027F44AE7C
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 14:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbhKINMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 08:12:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhKINMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 08:12:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636463389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0pR6oq3vT3vwnTXHtlErwifuLR4RuIkSa1CtAJsG3Qo=;
        b=YuF0O7/Ckal/Q9Svm1XlHvYbtMd4z5J7QIrzrW/4Xr9uzP2T5GgwQJ1WoYLak2Vl3cc4Ac
        /IGttLDCbBCY0A3s7KYWGoEw0pz4RsI94KcdnutizFR8Q6HDsrpMImNSnOyljOA7kKMB8O
        IkUsaJBE/FWNfl6+hM/ZUhEHmyzKVNQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-z_qmhn81M4SXHuGiGFFIOQ-1; Tue, 09 Nov 2021 08:09:47 -0500
X-MC-Unique: z_qmhn81M4SXHuGiGFFIOQ-1
Received: by mail-ed1-f69.google.com with SMTP id q6-20020a056402518600b003e28d92bb85so17821865edd.7
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 05:09:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0pR6oq3vT3vwnTXHtlErwifuLR4RuIkSa1CtAJsG3Qo=;
        b=yBv+hU4m+noN3uTJu/PYFbG/hE0ghPKhnKvEaWtW3nVGZGpAh5qYDTkPLEOoVOwaPE
         NGRubmJM/7esxCVvK4CQVuCgKyYBMxGhmXRB3jcJePXSZX6cOAokTbC/+oCRE/cEQi3E
         /4vRi9YpApvW4TqySsJRWUtDhCoOcoiMHiLvYjcx1WZU+n5mgc+5FUhavZY0QM9bsDwx
         0XHdHOdckvgxJ3nLdSjq5O+hqNJ8iCJxoVtgGhkMOWbKMcKGvP44qo89epZetjtZCBJZ
         whT+TSuXWr9G9pslXX/EyldVWV9ecidAfwBokgani4GmXTEyBQFpiPX8nvl86ohYHFFC
         2P0Q==
X-Gm-Message-State: AOAM531OYOUgbKiNvz32fEC4qnBpkc14/ppwoXAQmxCdvCHglxKPJX+Y
        xq/8cmH0107+FyAti6LiAvYLWRlETBoVWhmSaKc3bq05RdP6snbs6WrRQ1F2uqFPM4bFferb29/
        Rfu5nNr1kAK+onOZM
X-Received: by 2002:a17:907:3f19:: with SMTP id hq25mr9195129ejc.225.1636463386534;
        Tue, 09 Nov 2021 05:09:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxjcFu94OBKSEzutUdQPjYHYex4E5Ay0XPzDVhUPaxlzaWJf7jve61Rks0sYCBxy5xt2KJJAA==
X-Received: by 2002:a17:907:3f19:: with SMTP id hq25mr9195096ejc.225.1636463386281;
        Tue, 09 Nov 2021 05:09:46 -0800 (PST)
Received: from redhat.com ([2.55.133.41])
        by smtp.gmail.com with ESMTPSA id i5sm3437839ejw.121.2021.11.09.05.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 05:09:45 -0800 (PST)
Date:   Tue, 9 Nov 2021 08:09:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v4 1/3] virtio: cache indirect desc for split
Message-ID: <20211109080333-mutt-send-email-mst@kernel.org>
References: <20211108114951.92862-1-xuanzhuo@linux.alibaba.com>
 <20211108114951.92862-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108114951.92862-2-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 07:49:49PM +0800, Xuan Zhuo wrote:
> In the case of using indirect, indirect desc must be allocated and
> released each time, which increases a lot of cpu overhead.
> 
> Here, a cache is added for indirect. If the number of indirect desc to be
> applied for is less than desc_cache_thr, the desc array with
> the size of desc_cache_thr is fixed and cached for reuse.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio_ring.c | 126 ++++++++++++++++++++++++++++++++---
>  include/linux/virtio.h       |  17 +++++
>  2 files changed, 135 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index dd95dfd85e98..a4a91c497a83 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -85,6 +85,19 @@ struct vring_desc_extra {
>  	u16 next;			/* The next desc state in a list. */
>  };
>  
> +struct vring_desc_cache {
> +	/* desc cache chain */
> +	struct list_head list;
> +
> +	void *array;
> +
> +	/* desc cache threshold
> +	 *    0   - disable desc cache
> +	 *    > 0 - enable desc cache. As the threshold of the desc cache.
> +	 */
> +	u32 threshold;
> +};
> +
>  struct vring_virtqueue {
>  	struct virtqueue vq;
>  
> @@ -117,6 +130,8 @@ struct vring_virtqueue {
>  	/* Hint for event idx: already triggered no need to disable. */
>  	bool event_triggered;
>  
> +	struct vring_desc_cache desc_cache;
> +
>  	union {
>  		/* Available for split ring */
>  		struct {
> @@ -423,7 +438,50 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
>  	return extra[i].next;
>  }
>  
> -static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
> +static void desc_cache_init(struct vring_virtqueue *vq)
> +{
> +	vq->desc_cache.array = NULL;
> +	vq->desc_cache.threshold = 0;
> +	INIT_LIST_HEAD(&vq->desc_cache.list);
> +}
> +
> +static void desc_cache_free(struct vring_virtqueue *vq)
> +{
> +	kfree(vq->desc_cache.array);
> +}
> +
> +static void __desc_cache_put(struct vring_virtqueue *vq,
> +			     struct list_head *node, int n)
> +{
> +	if (n <= vq->desc_cache.threshold)
> +		list_add(node, &vq->desc_cache.list);
> +	else
> +		kfree(node);
> +}
> +
> +#define desc_cache_put(vq, desc, n) \
> +	__desc_cache_put(vq, (struct list_head *)desc, n)
> +
> +static void *desc_cache_get(struct vring_virtqueue *vq,
> +			    int size, int n, gfp_t gfp)
> +{
> +	struct list_head *node;
> +
> +	if (n > vq->desc_cache.threshold)
> +		return kmalloc_array(n, size, gfp);
> +
> +	node = vq->desc_cache.list.next;
> +	list_del(node);
> +	return node;
> +}
> +
> +#define _desc_cache_get(vq, n, gfp, tp) \
> +	((tp *)desc_cache_get(vq, (sizeof(tp)), n, gfp))
> +
> +#define desc_cache_get_split(vq, n, gfp) \
> +	_desc_cache_get(vq, n, gfp, struct vring_desc)
> +
> +static struct vring_desc *alloc_indirect_split(struct vring_virtqueue *vq,
>  					       unsigned int total_sg,
>  					       gfp_t gfp)
>  {
> @@ -437,12 +495,12 @@ static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
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
> @@ -508,7 +566,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>  	head = vq->free_head;
>  
>  	if (virtqueue_use_indirect(_vq, total_sg))
> -		desc = alloc_indirect_split(_vq, total_sg, gfp);
> +		desc = alloc_indirect_split(vq, total_sg, gfp);
>  	else {
>  		desc = NULL;
>  		WARN_ON_ONCE(total_sg > vq->split.vring.num && !vq->indirect);
> @@ -652,7 +710,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>  	}
>  
>  	if (indirect)
> -		kfree(desc);
> +		desc_cache_put(vq, desc, total_sg);
>  
>  	END_USE(vq);
>  	return -ENOMEM;
> @@ -717,7 +775,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  	if (vq->indirect) {
>  		struct vring_desc *indir_desc =
>  				vq->split.desc_state[head].indir_desc;
> -		u32 len;
> +		u32 len, n;
>  
>  		/* Free the indirect table, if any, now that it's unmapped. */
>  		if (!indir_desc)
> @@ -729,10 +787,12 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
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
> @@ -2200,6 +2260,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>  		!context;
>  	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
>  
> +	desc_cache_init(vq);
> +
>  	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>  		vq->weak_barriers = false;
>  
> @@ -2329,6 +2391,7 @@ void vring_del_virtqueue(struct virtqueue *_vq)
>  	if (!vq->packed_ring) {
>  		kfree(vq->split.desc_state);
>  		kfree(vq->split.desc_extra);
> +		desc_cache_free(vq);
>  	}
>  	kfree(vq);
>  }
> @@ -2445,6 +2508,53 @@ dma_addr_t virtqueue_get_used_addr(struct virtqueue *_vq)
>  }
>  EXPORT_SYMBOL_GPL(virtqueue_get_used_addr);
>  
> +int virtqueue_set_desc_cache(struct virtqueue *_vq, u32 threshold)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +	struct list_head *node;
> +	int size, num, i;
> +
> +	BUILD_BUG_ON(sizeof(struct list_head) > sizeof(struct vring_desc));
> +	BUILD_BUG_ON(sizeof(struct list_head) > sizeof(struct vring_packed_desc));
> +
> +	BUG_ON(!vq->we_own_ring);
> +
> +	if (!vq->indirect)
> +		return 0;
> +
> +	vq->desc_cache.threshold = threshold;
> +
> +	if (!threshold)
> +		return 0;
> +
> +	if (vq->packed_ring) {
> +		size = sizeof(struct vring_packed_desc);
> +		num = vq->packed.vring.num;
> +	} else {
> +		size = sizeof(struct vring_desc);
> +		num = vq->split.vring.num;
> +	}
> +
> +	size = size * vq->desc_cache.threshold;

just use two variables pls so it's clear which size is where.

> +
> +	vq->desc_cache.array = kmalloc_array(num, size, GFP_KERNEL);

might be quite big. the point of indirect is so it can be
allocated in chunks...

also this allocates from numa node on which driver is loaded,
likely not the correct one to use for the VQ.
how about addressing this e.g. by dropping the cache
if we cross numa nodes?


> +	if (!vq->desc_cache.array) {
> +		vq->desc_cache.threshold = 0;
> +		dev_warn(&vq->vq.vdev->dev,
> +			 "queue[%d] alloc desc cache fail. turn off it.\n",
> +			 vq->vq.index);
> +		return -1;

should be some errno, don't come up with your own return codes.

> +	}
> +
> +	for (i = 0; i < num; ++i) {
> +		node = vq->desc_cache.array + (i * size);
> +		list_add(node, &vq->desc_cache.list);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_set_desc_cache);
> +
>  /* Only available for split ring */
>  const struct vring *virtqueue_get_vring(struct virtqueue *vq)
>  {
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 41edbc01ffa4..e24b2e90dd42 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -89,6 +89,23 @@ dma_addr_t virtqueue_get_desc_addr(struct virtqueue *vq);
>  dma_addr_t virtqueue_get_avail_addr(struct virtqueue *vq);
>  dma_addr_t virtqueue_get_used_addr(struct virtqueue *vq);
>  
> +/**
> + * virtqueue_set_desc_cache - set virtio ring desc cache threshold
> + *
> + * virtio will allocate ring.num desc arrays of size threshold in advance. If
> + * total_sg exceeds the threshold, use kmalloc/kfree allocation indirect desc,
> + * if total_sg is less than or equal to the threshold, use these pre-allocated
> + * desc arrays.
> + *
> + * This function must be called immediately after find_vqs and before device
> + * ready.
> + *
> + * @threshold:
> + *    0   - disable desc cache
> + *    > 0 - enable desc cache. As the threshold of the desc cache.

still not descriptive at all.

why do devices even care? is not the issue with a large
threshold its memory consumption?


> + */
> +int virtqueue_set_desc_cache(struct virtqueue *_vq, u32 threshold);

document return code too.

> +
>  /**
>   * virtio_device - representation of a device using virtio
>   * @index: unique position on the virtio bus
> -- 
> 2.31.0

