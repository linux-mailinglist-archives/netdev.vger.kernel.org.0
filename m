Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F7343CF76
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbhJ0RJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:09:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53746 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230193AbhJ0RJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635354447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Iy1QPbl+NGI8VooDFKsLzDrkTxssdpglKNEQwF6yv28=;
        b=LXdgo6hpVQ3ZU/fHvpdjYTd6PWC7t+jjCcipmvQoZbBGukcBwHBqcQpsgyFeWQjQ5yuNkM
        usqn1pQxSWalJUFb/gsWHa38pZDAIK1C3NnAQOgqw3adfRTDJMcQiuw3F3rnMotZCk7Tl/
        HjfJR6lxGpqtGKzFRdSxe+UHDlHjxeY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534--uspDaQfPYGywFubYshvmg-1; Wed, 27 Oct 2021 13:07:26 -0400
X-MC-Unique: -uspDaQfPYGywFubYshvmg-1
Received: by mail-wm1-f70.google.com with SMTP id y65-20020a1c7d44000000b0032cd2b01225so730312wmc.0
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:07:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iy1QPbl+NGI8VooDFKsLzDrkTxssdpglKNEQwF6yv28=;
        b=DzaFFdTbzbyYAL1c4cfGen3G9VOqME1vOMPj+loaxuhxfikk+6z2jYI7Oe0pgZCBA7
         01TbXcZKHah5cx30/nR2IRaEP8mus9c4FzrgV3Ilg2EFeg+p8VSKTihpJ+6dGMMXea98
         oQPh4j2MQ0pcfYWdHk38zUVrmcUAC+rV8JfrtE7Ns/Wut8QBCTexC4amxinG8LAXxh9p
         sP+o30NWNG9fbVqxYq08oWkV2nmCvzawJ/WNRyqzmh/SGZ3mufatoiGP2+MF71tjLVPg
         xJ4nYQ+s1TtqXo8awmw1gvix5kE/0/TtLn96tQff9czTyNKPQk4ncOWLjLifXPU+HyQr
         uagw==
X-Gm-Message-State: AOAM533AqwyrgV8ELHpGSPcT+6IBbf1mQJ3+wKHlX5JMmTNNZwc5i1jX
        s/P/d+3EhZfd/ZD8raznR9l3MI1ZEkkhpLTpB0TqP8uYyD515rQH9SwMnypgDSFxuN/ENTCeJ1c
        P5L2gAN2AXDbAReLz
X-Received: by 2002:a1c:1d87:: with SMTP id d129mr6614298wmd.176.1635354445270;
        Wed, 27 Oct 2021 10:07:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxa7Q9RTjp2LDf1h+ESMQUn04bOSV913AYFeCXIIHWMw7nfUWMBBhkJYmr1cJGSWGvUAG8oig==
X-Received: by 2002:a1c:1d87:: with SMTP id d129mr6614284wmd.176.1635354445094;
        Wed, 27 Oct 2021 10:07:25 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:a543:72f:c4d1:8911:6346])
        by smtp.gmail.com with ESMTPSA id l11sm407024wrt.49.2021.10.27.10.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 10:07:24 -0700 (PDT)
Date:   Wed, 27 Oct 2021 13:07:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/3] virtio: cache indirect desc for split
Message-ID: <20211027130429-mutt-send-email-mst@kernel.org>
References: <20211027061913.76276-1-xuanzhuo@linux.alibaba.com>
 <20211027061913.76276-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027061913.76276-2-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 02:19:11PM +0800, Xuan Zhuo wrote:
> In the case of using indirect, indirect desc must be allocated and
> released each time, which increases a lot of cpu overhead.
> 
> Here, a cache is added for indirect. If the number of indirect desc to be
> applied for is less than VIRT_QUEUE_CACHE_DESC_NUM, the desc array with
> the size of VIRT_QUEUE_CACHE_DESC_NUM is fixed and cached for reuse.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio.c      |  6 ++++
>  drivers/virtio/virtio_ring.c | 63 ++++++++++++++++++++++++++++++------
>  include/linux/virtio.h       | 10 ++++++
>  3 files changed, 70 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 0a5b54034d4b..04bcb74e5b9a 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -431,6 +431,12 @@ bool is_virtio_device(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(is_virtio_device);
>  
> +void virtio_use_desc_cache(struct virtio_device *dev, bool val)
> +{
> +	dev->desc_cache = val;
> +}
> +EXPORT_SYMBOL_GPL(virtio_use_desc_cache);
> +
>  void unregister_virtio_device(struct virtio_device *dev)
>  {
>  	int index = dev->index; /* save for after device release */
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index dd95dfd85e98..0b9a8544b0e8 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -117,6 +117,10 @@ struct vring_virtqueue {
>  	/* Hint for event idx: already triggered no need to disable. */
>  	bool event_triggered;
>  
> +	/* Is indirect cache used? */
> +	bool use_desc_cache;
> +	void *desc_cache_chain;
> +
>  	union {
>  		/* Available for split ring */
>  		struct {
> @@ -423,12 +427,47 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
>  	return extra[i].next;
>  }
>  
> -static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
> +#define VIRT_QUEUE_CACHE_DESC_NUM 4
> +
> +static void desc_cache_chain_free_split(void *chain)
> +{
> +	struct vring_desc *desc;
> +
> +	while (chain) {
> +		desc = chain;
> +		chain = (void *)desc->addr;
> +		kfree(desc);
> +	}
> +}
> +
> +static void desc_cache_put_split(struct vring_virtqueue *vq,
> +				 struct vring_desc *desc, int n)
> +{
> +	if (vq->use_desc_cache && n <= VIRT_QUEUE_CACHE_DESC_NUM) {
> +		desc->addr = (u64)vq->desc_cache_chain;
> +		vq->desc_cache_chain = desc;
> +	} else {
> +		kfree(desc);
> +	}
> +}
> +


So I have a question here. What happens if we just do:

if (n <= VIRT_QUEUE_CACHE_DESC_NUM) {
	return kmem_cache_alloc(VIRT_QUEUE_CACHE_DESC_NUM * sizeof desc, gfp)
} else {
	return kmalloc_arrat(n, sizeof desc, gfp)
}

A small change and won't we reap most performance benefits?

-- 
MST

