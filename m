Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201CB5A0A96
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 09:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiHYHpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 03:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238468AbiHYHpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 03:45:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5371C237F8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661413497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zWHJOua38RJS2VpD323EH8m9oocDDSERK05+Run3Kgw=;
        b=Cn4a36+pAlLqtFvozHucJSfObtk/j6MgF5jPPgiZ1FLg+zLrx59SPHbSc+UerGE6E8VYKJ
        eqvza90QBqIzYOC9WA8V6QQEzGjtuoYS/6i6Utwk2GDJIhni/DRuFc4Hd6Z+AmTPjMB1C6
        7hcS8/auePgW1ialHfEI6mmpRq0lHQE=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-540-eS46v98jNbGY3pTOgMf0qA-1; Thu, 25 Aug 2022 03:44:56 -0400
X-MC-Unique: eS46v98jNbGY3pTOgMf0qA-1
Received: by mail-pf1-f199.google.com with SMTP id x25-20020aa79199000000b005358eeebf49so8683245pfa.17
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:44:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=zWHJOua38RJS2VpD323EH8m9oocDDSERK05+Run3Kgw=;
        b=kOy2g+0FawO/jI8wGqXdppBinDzcwecylMNawXJxdCF+HwsrSRUCBxvabt1ZY6enSX
         TcZygL5dIpS5qXhi/f2cqyWY/ZxmaiQhIcHjFyZkOUQDwdxl52opSGbdIx0WwgEyyPdy
         WCeDQrNuSm7Kap89u0pjcs/S48bIs+G6gOFYTmcRqXRGiX76YBCwTuDOxr+wm7yYjK4+
         1svkyruIemkHOXdy+VFVH6USD2zuw5PcIkSLQbPdCOPFobMt15GiCYNzFsrmhiqojVG+
         aqYwFYUDyvSkizMoMhJKdefpIZ2XRjmTL791DPUypPJp4CEpB3TftTw1IE17sCKa9MZh
         lBPA==
X-Gm-Message-State: ACgBeo3wBN9LNaQ8OyB0+coGqwBguV0azbmHbPnzV0FaBUzIFnecMhLV
        Noiykn43s52EnnhQD3efWhUD0OVDYSTQkySHbxtjY/4zHBiyOBDdstlToHcVZVCpC3KiEVdu1CW
        Tglr4YEwITYPZxnXN
X-Received: by 2002:a65:6949:0:b0:41c:cb9d:3d1f with SMTP id w9-20020a656949000000b0041ccb9d3d1fmr2255951pgq.334.1661413494953;
        Thu, 25 Aug 2022 00:44:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR75sNLCKhijU2tO7/6br2jUgmaSbR8Md7x1+OjmLVGn+Q+XRO2Hc97nH7XGtW3SfJCxbzuBEQ==
X-Received: by 2002:a65:6949:0:b0:41c:cb9d:3d1f with SMTP id w9-20020a656949000000b0041ccb9d3d1fmr2255934pgq.334.1661413494644;
        Thu, 25 Aug 2022 00:44:54 -0700 (PDT)
Received: from [10.72.12.107] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z24-20020aa79f98000000b0053627e0e860sm11687572pfr.27.2022.08.25.00.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 00:44:54 -0700 (PDT)
Message-ID: <ebf4b376-6a5c-3cfa-38ab-1559ace13b27@redhat.com>
Date:   Thu, 25 Aug 2022 15:44:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC v2 6/7] virtio: in order support for virtio_ring
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
 <20220817135718.2553-7-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220817135718.2553-7-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/8/17 21:57, Guo Zhi 写道:
> If in order feature negotiated, we can skip the used ring to get
> buffer's desc id sequentially.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/virtio/virtio_ring.c | 53 ++++++++++++++++++++++++++++++------
>   1 file changed, 45 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 1c1b3fa376a2..143184ebb5a1 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -144,6 +144,9 @@ struct vring_virtqueue {
>   			/* DMA address and size information */
>   			dma_addr_t queue_dma_addr;
>   			size_t queue_size_in_bytes;
> +
> +			/* In order feature batch begin here */


We need tweak the comment, it's not easy for me to understand the 
meaning here.


> +			u16 next_desc_begin;
>   		} split;
>   
>   		/* Available for packed ring */
> @@ -702,8 +705,13 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>   	}
>   
>   	vring_unmap_one_split(vq, i);
> -	vq->split.desc_extra[i].next = vq->free_head;
> -	vq->free_head = head;
> +	/* In order feature use desc in order,
> +	 * that means, the next desc will always be free
> +	 */


Maybe we should add something like "The descriptors are prepared in order".


> +	if (!virtio_has_feature(vq->vq.vdev, VIRTIO_F_IN_ORDER)) {
> +		vq->split.desc_extra[i].next = vq->free_head;
> +		vq->free_head = head;
> +	}
>   
>   	/* Plus final descriptor */
>   	vq->vq.num_free++;
> @@ -745,7 +753,7 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
>   {
>   	struct vring_virtqueue *vq = to_vvq(_vq);
>   	void *ret;
> -	unsigned int i;
> +	unsigned int i, j;
>   	u16 last_used;
>   
>   	START_USE(vq);
> @@ -764,11 +772,38 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
>   	/* Only get used array entries after they have been exposed by host. */
>   	virtio_rmb(vq->weak_barriers);
>   
> -	last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
> -	i = virtio32_to_cpu(_vq->vdev,
> -			vq->split.vring.used->ring[last_used].id);
> -	*len = virtio32_to_cpu(_vq->vdev,
> -			vq->split.vring.used->ring[last_used].len);
> +	if (virtio_has_feature(_vq->vdev, VIRTIO_F_IN_ORDER)) {
> +		/* Skip used ring and get used desc in order*/
> +		i = vq->split.next_desc_begin;
> +		j = i;
> +		/* Indirect only takes one descriptor in descriptor table */
> +		while (!vq->indirect && (vq->split.desc_extra[j].flags & VRING_DESC_F_NEXT))
> +			j = (j + 1) % vq->split.vring.num;


Let's move the expensive mod outside the loop. Or it's split so we can 
use and here actually since the size is guaranteed to be power of the 
two? Another question, is it better to store the next_desc in e.g 
desc_extra?

And this seems very expensive if the device doesn't do the batching 
(which is not mandatory).


> +		/* move to next */
> +		j = (j + 1) % vq->split.vring.num;
> +		/* Next buffer will use this descriptor in order */
> +		vq->split.next_desc_begin = j;
> +		if (!vq->indirect) {
> +			*len = vq->split.desc_extra[i].len;
> +		} else {
> +			struct vring_desc *indir_desc =
> +				vq->split.desc_state[i].indir_desc;
> +			u32 indir_num = vq->split.desc_extra[i].len, buffer_len = 0;
> +
> +			if (indir_desc) {
> +				for (j = 0; j < indir_num / sizeof(struct vring_desc); j++)
> +					buffer_len += indir_desc[j].len;


So I think we need to finalize this, then we can have much more stress 
on the cache:

https://lkml.org/lkml/2021/10/26/1300

It was reverted since it's too aggressive, we should instead:

1) do the validation only for morden device

2) fail only when we enable the validation via (e.g a module parameter).

Thanks


> +			}
> +
> +			*len = buffer_len;
> +		}
> +	} else {
> +		last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
> +		i = virtio32_to_cpu(_vq->vdev,
> +				    vq->split.vring.used->ring[last_used].id);
> +		*len = virtio32_to_cpu(_vq->vdev,
> +				       vq->split.vring.used->ring[last_used].len);
> +	}
>   
>   	if (unlikely(i >= vq->split.vring.num)) {
>   		BAD_RING(vq, "id %u out of range\n", i);
> @@ -2236,6 +2271,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	vq->split.avail_flags_shadow = 0;
>   	vq->split.avail_idx_shadow = 0;
>   
> +	vq->split.next_desc_begin = 0;
> +
>   	/* No callback?  Tell other side not to bother us. */
>   	if (!callback) {
>   		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;

