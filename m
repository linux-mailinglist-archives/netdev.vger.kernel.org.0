Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B286D32A367
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382148AbhCBI42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:56:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345001AbhCBGw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614667856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pw0+OpAgN2cuqHokScOT5T0Eyke5jNWE452MsWUrx9k=;
        b=EpCnJRNeiXNbguN5amAqhrMxdrd16M6SektMiCg6ZHX6/jVbR2vG5hEdK7x3mRxAfKfXvG
        UgvlpldDwqFyUcy0cOv0Rw6ZSPoSYjJkOIJnUJf4D6rZjr4ierhOiyOnKvRnXfxf1UZiFF
        AFjlyumFh676BDPDtOD20Ne35S8mPwA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-iDdTdt3lNCipFcnOqlRw-g-1; Tue, 02 Mar 2021 01:50:52 -0500
X-MC-Unique: iDdTdt3lNCipFcnOqlRw-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48CC8193578B;
        Tue,  2 Mar 2021 06:50:50 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-133.pek2.redhat.com [10.72.12.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D86105D766;
        Tue,  2 Mar 2021 06:50:38 +0000 (UTC)
Subject: Re: [RFC v4 04/11] vdpa: Add an opaque pointer for
 vdpa_config_ops.dma_map()
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-5-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <977e44fe-63ec-a695-11a5-d7c584124294@redhat.com>
Date:   Tue, 2 Mar 2021 14:50:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210223115048.435-5-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 7:50 下午, Xie Yongji wrote:
> Add an opaque pointer for DMA mapping.
>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/vdpa_sim/vdpa_sim.c | 6 +++---
>   drivers/vhost/vdpa.c             | 2 +-
>   include/linux/vdpa.h             | 2 +-
>   3 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index d5942842432d..5cfc262ce055 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -512,14 +512,14 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
>   }
>   
>   static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
> -			   u64 pa, u32 perm)
> +			   u64 pa, u32 perm, void *opaque)
>   {
>   	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>   	int ret;
>   
>   	spin_lock(&vdpasim->iommu_lock);
> -	ret = vhost_iotlb_add_range(vdpasim->iommu, iova, iova + size - 1, pa,
> -				    perm);
> +	ret = vhost_iotlb_add_range_ctx(vdpasim->iommu, iova, iova + size - 1,
> +					pa, perm, opaque);
>   	spin_unlock(&vdpasim->iommu_lock);
>   
>   	return ret;
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 5500e3bf05c1..70857fe3263c 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -544,7 +544,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>   		return r;
>   
>   	if (ops->dma_map) {
> -		r = ops->dma_map(vdpa, iova, size, pa, perm);
> +		r = ops->dma_map(vdpa, iova, size, pa, perm, NULL);
>   	} else if (ops->set_map) {
>   		if (!v->in_batch)
>   			r = ops->set_map(vdpa, dev->iotlb);
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 4ab5494503a8..93dca2c328ae 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -241,7 +241,7 @@ struct vdpa_config_ops {
>   	/* DMA ops */
>   	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
>   	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
> -		       u64 pa, u32 perm);
> +		       u64 pa, u32 perm, void *opaque);
>   	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
>   
>   	/* Free device resources */

