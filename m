Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF644AB586
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 08:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbiBGHF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 02:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239236AbiBGG5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 01:57:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 867B3C043181
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 22:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644217042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4lYVzkeryUlUmjK5RxgbHqZ2ZtXn/ee2U4ikT2iY1Vc=;
        b=RLH93PggH4/GercIStJtiPVUVuJQLAeSKmWDjIeTcyU/3+cAiNqZalCC1gIy4uXrOFXwbC
        VyIH8EBY8kcaOlKqfINBAMB+ps0u6mO/rtgaX3GuouRRrUlr31O+OXuyVJe8NZ28/GHQQL
        eNM+znXKj3f+l4K6DeISRR2plKkOJLM=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-I1ERf4U0PXaOgFXc9s5tXg-1; Mon, 07 Feb 2022 01:57:21 -0500
X-MC-Unique: I1ERf4U0PXaOgFXc9s5tXg-1
Received: by mail-pf1-f199.google.com with SMTP id o194-20020a62cdcb000000b004c9d2b4bfd8so6728521pfg.7
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 22:57:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4lYVzkeryUlUmjK5RxgbHqZ2ZtXn/ee2U4ikT2iY1Vc=;
        b=VN+oLjtPx++zSSIJ5rxDPFxTdcgIzRJ3YNsHWMsp4sdlWAChXT0uHwRzrvcVK8t/+d
         1QOygn2KUGUqMjPBxvPwMmdOPtmZKxYwrbaZzKVhKH76Ze9+vRuJAdQjcbjMKjTYFQrH
         Gi/k3uxwP7T6BGs1WatslfvgEeU/jX276tQSgAG6oWpIf54PTEbGsSS7wWWx1hWQ90aj
         Bhuy3dEDs4WoTXGcTH6yZP3yqT2LK0yVwQFvRuwzpafXmgDx8MYXvjn4wiX2lzynTTBE
         j+U7fL/OD3ReEmTtOYisi/c/2uEw7KNTGc+Ue2tY1AbyIWvJtI7JQ4CptZrJV/1Q9moU
         RO/w==
X-Gm-Message-State: AOAM531Q0/1CgUDlXctDGvxsUtZwc9XjXUa7RRgoxuuMUwWO++IFyz7M
        nsYCQ68I5Gn0UYgCt59uA3wBTdAnfcauHcl9/FVoyQWC3XBxZlbN6AxboGmCbaWRQRAEu4e12ZC
        SLipK1eyN8V7ZK8oR
X-Received: by 2002:a17:90b:b0d:: with SMTP id bf13mr16655831pjb.31.1644217039415;
        Sun, 06 Feb 2022 22:57:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyD4Pm33HXprCnq59NkE1AJ59D3k03PMV7S5/zx1dISq6SIjxiMR4jgDjJ5+6UGP4Su0UcVOQ==
X-Received: by 2002:a17:90b:b0d:: with SMTP id bf13mr16655807pjb.31.1644217039135;
        Sun, 06 Feb 2022 22:57:19 -0800 (PST)
Received: from [10.72.13.253] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q8sm11438362pfl.143.2022.02.06.22.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 22:57:18 -0800 (PST)
Message-ID: <0908a9f6-562d-fab5-39c3-2f0125acc80e@redhat.com>
Date:   Mon, 7 Feb 2022 14:57:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 13/17] virtio_pci: queue_reset: support
 VIRTIO_F_RING_RESET
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
 <20220126073533.44994-14-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220126073533.44994-14-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/26 下午3:35, Xuan Zhuo 写道:
> This patch implements virtio pci support for QUEUE RESET.
>
> Performing reset on a queue is divided into two steps:
>
> 1. reset_vq: reset one vq
> 2. enable_reset_vq: re-enable the reset queue
>
> In the first step, these tasks will be completed:
>     1. notify the hardware queue to reset
>     2. recycle the buffer from vq
>     3. release the ring of the vq
>
> The process of enable reset vq:
>      vp_modern_enable_reset_vq()
>      vp_enable_reset_vq()
>      __vp_setup_vq()
>      setup_vq()
>      vring_setup_virtqueue()
>
> In this process, we added two parameters, vq and num, and finally passed
> them to vring_setup_virtqueue().  And reuse the original info and vq.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_pci_common.c |  36 +++++++----
>   drivers/virtio/virtio_pci_common.h |   5 ++
>   drivers/virtio/virtio_pci_modern.c | 100 +++++++++++++++++++++++++++++
>   3 files changed, 128 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index c02936d29a31..ad21638fbf66 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -205,23 +205,28 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
>   	return err;
>   }
>   
> -static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
> -				     void (*callback)(struct virtqueue *vq),
> -				     const char *name,
> -				     bool ctx,
> -				     u16 msix_vec, u16 num)
> +struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
> +			      void (*callback)(struct virtqueue *vq),
> +			      const char *name,
> +			      bool ctx,
> +			      u16 msix_vec, u16 num)
>   {
>   	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> -	struct virtio_pci_vq_info *info = kmalloc(sizeof *info, GFP_KERNEL);
> +	struct virtio_pci_vq_info *info;
>   	struct virtqueue *vq;
>   	unsigned long flags;
>   
> -	/* fill out our structure that represents an active queue */
> -	if (!info)
> -		return ERR_PTR(-ENOMEM);
> +	info = vp_dev->vqs[index];
> +	if (!info) {
> +		info = kzalloc(sizeof *info, GFP_KERNEL);
> +
> +		/* fill out our structure that represents an active queue */
> +		if (!info)
> +			return ERR_PTR(-ENOMEM);
> +	}
>   
>   	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
> -			      msix_vec, NULL, num);
> +			      msix_vec, info->vq, num);
>   	if (IS_ERR(vq))
>   		goto out_info;
>   
> @@ -238,6 +243,9 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
>   	return vq;
>   
>   out_info:
> +	if (info->vq && info->vq->reset)
> +		return vq;
> +
>   	kfree(info);
>   	return vq;
>   }
> @@ -248,9 +256,11 @@ static void vp_del_vq(struct virtqueue *vq)
>   	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
>   	unsigned long flags;
>   
> -	spin_lock_irqsave(&vp_dev->lock, flags);
> -	list_del(&info->node);
> -	spin_unlock_irqrestore(&vp_dev->lock, flags);
> +	if (!vq->reset) {
> +		spin_lock_irqsave(&vp_dev->lock, flags);
> +		list_del(&info->node);
> +		spin_unlock_irqrestore(&vp_dev->lock, flags);
> +	}
>   
>   	vp_dev->del_vq(info);
>   	kfree(info);
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index 65db92245e41..c1d15f7c0be4 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -119,6 +119,11 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>   		struct virtqueue *vqs[], vq_callback_t *callbacks[],
>   		const char * const names[], const bool *ctx,
>   		struct irq_affinity *desc);
> +struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
> +			      void (*callback)(struct virtqueue *vq),
> +			      const char *name,
> +			      bool ctx,
> +			      u16 msix_vec, u16 num);
>   const char *vp_bus_name(struct virtio_device *vdev);
>   
>   /* Setup the affinity for a virtqueue:
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 2ce58de549de..6789411169e4 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
>   	if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
>   			pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV))
>   		__virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
> +
> +	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
> +		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
>   }
>   
>   /* virtio config->finalize_features() implementation */
> @@ -176,6 +179,94 @@ static void vp_reset(struct virtio_device *vdev)
>   	vp_disable_cbs(vdev);
>   }
>   
> +static int vp_modern_reset_vq(struct virtio_reset_vq *param)
> +{
> +	struct virtio_pci_device *vp_dev = to_vp_device(param->vdev);
> +	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +	struct virtio_pci_vq_info *info;
> +	u16 msix_vec, queue_index;
> +	unsigned long flags;
> +	void *buf;
> +
> +	if (!virtio_has_feature(param->vdev, VIRTIO_F_RING_RESET))
> +		return -ENOENT;
> +
> +	queue_index = param->queue_index;
> +
> +	vp_modern_set_queue_reset(mdev, queue_index);
> +
> +	/* After write 1 to queue reset, the driver MUST wait for a read of
> +	 * queue reset to return 1.
> +	 */
> +	while (vp_modern_get_queue_reset(mdev, queue_index) != 1)
> +		msleep(1);


Is this better to move this logic into vp_modern_set_queue_reset()?


> +
> +	info = vp_dev->vqs[queue_index];
> +	msix_vec = info->msix_vector;
> +
> +	/* Disable VQ callback. */
> +	if (vp_dev->per_vq_vectors && msix_vec != VIRTIO_MSI_NO_VECTOR)
> +		disable_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec));


How about the INTX case where irq is shared? I guess we need to disable 
and enable the irq as well.


> +
> +	while ((buf = virtqueue_detach_unused_buf(info->vq)) != NULL)
> +		param->free_unused_cb(param, buf);


Any reason that we can't leave this logic to driver? (Or is there any 
operations that must be done before the following operations?)


> +
> +	/* delete vq */
> +	spin_lock_irqsave(&vp_dev->lock, flags);
> +	list_del(&info->node);
> +	spin_unlock_irqrestore(&vp_dev->lock, flags);
> +
> +	INIT_LIST_HEAD(&info->node);
> +
> +	if (vp_dev->msix_enabled)
> +		vp_modern_queue_vector(mdev, info->vq->index,
> +				       VIRTIO_MSI_NO_VECTOR);


I wonder if this is a must.


> +
> +	if (!mdev->notify_base)
> +		pci_iounmap(mdev->pci_dev,
> +			    (void __force __iomem *)info->vq->priv);


Is this a must? what happens if we simply don't do this?


> +
> +	vring_reset_virtqueue(info->vq);
> +
> +	return 0;
> +}
> +
> +static struct virtqueue *vp_modern_enable_reset_vq(struct virtio_reset_vq *param)
> +{
> +	struct virtio_pci_device *vp_dev = to_vp_device(param->vdev);
> +	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +	struct virtio_pci_vq_info *info;
> +	u16 msix_vec, queue_index;
> +	struct virtqueue *vq;
> +
> +	if (!virtio_has_feature(param->vdev, VIRTIO_F_RING_RESET))
> +		return ERR_PTR(-ENOENT);
> +
> +	queue_index = param->queue_index;
> +
> +	info = vp_dev->vqs[queue_index];
> +
> +	if (!info->vq->reset)
> +		return ERR_PTR(-EPERM);
> +
> +	/* check queue reset status */
> +	if (vp_modern_get_queue_reset(mdev, queue_index) != 1)
> +		return ERR_PTR(-EBUSY);
> +
> +	vq = vp_setup_vq(param->vdev, queue_index, param->callback, param->name,
> +			 param->ctx, info->msix_vector, param->ring_num);
> +	if (IS_ERR(vq))
> +		return vq;
> +
> +	vp_modern_set_queue_enable(&vp_dev->mdev, vq->index, true);
> +
> +	msix_vec = vp_dev->vqs[queue_index]->msix_vector;
> +	if (vp_dev->per_vq_vectors && msix_vec != VIRTIO_MSI_NO_VECTOR)
> +		enable_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec));


How about the INT-X case?

Thanks


> +
> +	return vq;
> +}
> +
>   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
>   {
>   	return vp_modern_config_vector(&vp_dev->mdev, vector);
> @@ -284,6 +375,11 @@ static void del_vq(struct virtio_pci_vq_info *info)
>   	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
>   	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>   
> +	if (vq->reset) {
> +		vring_del_virtqueue(vq);
> +		return;
> +	}
> +
>   	if (vp_dev->msix_enabled)
>   		vp_modern_queue_vector(mdev, vq->index,
>   				       VIRTIO_MSI_NO_VECTOR);
> @@ -403,6 +499,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>   	.set_vq_affinity = vp_set_vq_affinity,
>   	.get_vq_affinity = vp_get_vq_affinity,
>   	.get_shm_region  = vp_get_shm_region,
> +	.reset_vq	 = vp_modern_reset_vq,
> +	.enable_reset_vq = vp_modern_enable_reset_vq,
>   };
>   
>   static const struct virtio_config_ops virtio_pci_config_ops = {
> @@ -421,6 +519,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
>   	.set_vq_affinity = vp_set_vq_affinity,
>   	.get_vq_affinity = vp_get_vq_affinity,
>   	.get_shm_region  = vp_get_shm_region,
> +	.reset_vq	 = vp_modern_reset_vq,
> +	.enable_reset_vq = vp_modern_enable_reset_vq,
>   };
>   
>   /* the PCI probing function */

