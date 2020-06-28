Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2525820C673
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 08:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgF1GVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 02:21:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49682 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725957AbgF1GVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 02:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593325271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXEDHyjjxb2rXqbcuhJROWnkr8If4Nsba+ifr6k/PsA=;
        b=QUyJ5URs9CfrVN8vbK/UWDLqjqwE1r9gb136lj6zeYCDh5xYCI1jinZwJBUwX1Jr3phRju
        55k5PR2vgWG0eHMCtkpU+NRhuUri3C9P5OkUUDQ4Uq/n5y37kRy0l2CxTFkUt/bWtweYiA
        r6WAXoK4ET5jJonZf/M1ayK1EmIYF64=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-inwYdt1qNTuKEJE-ZQKttw-1; Sun, 28 Jun 2020 02:21:04 -0400
X-MC-Unique: inwYdt1qNTuKEJE-ZQKttw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10F4880183C;
        Sun, 28 Jun 2020 06:21:03 +0000 (UTC)
Received: from [10.72.13.164] (ovpn-13-164.pek2.redhat.com [10.72.13.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 029C35D9DD;
        Sun, 28 Jun 2020 06:20:47 +0000 (UTC)
Subject: Re: [PATCH] virtio: VIRTIO_F_IOMMU_PLATFORM ->
 VIRTIO_F_ACCESS_PLATFORM
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        David Hildenbrand <david@redhat.com>,
        linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200624222540.584772-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <98668518-8641-38f9-6f38-af1a2a75b9d8@redhat.com>
Date:   Sun, 28 Jun 2020 14:20:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200624222540.584772-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/25 上午6:25, Michael S. Tsirkin wrote:
> Rename the bit to match latest virtio spec.
> Add a compat macro to avoid breaking existing userspace.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   arch/um/drivers/virtio_uml.c       |  2 +-
>   drivers/vdpa/ifcvf/ifcvf_base.h    |  2 +-
>   drivers/vdpa/vdpa_sim/vdpa_sim.c   |  4 ++--
>   drivers/vhost/net.c                |  4 ++--
>   drivers/vhost/vdpa.c               |  2 +-
>   drivers/virtio/virtio_balloon.c    |  2 +-
>   drivers/virtio/virtio_ring.c       |  2 +-
>   include/linux/virtio_config.h      |  2 +-
>   include/uapi/linux/virtio_config.h | 10 +++++++---
>   tools/virtio/linux/virtio_config.h |  2 +-
>   10 files changed, 18 insertions(+), 14 deletions(-)
>
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index 351aee52aca6..a6c4bb6c2c01 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -385,7 +385,7 @@ static irqreturn_t vu_req_interrupt(int irq, void *data)
>   		}
>   		break;
>   	case VHOST_USER_SLAVE_IOTLB_MSG:
> -		/* not supported - VIRTIO_F_IOMMU_PLATFORM */
> +		/* not supported - VIRTIO_F_ACCESS_PLATFORM */
>   	case VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG:
>   		/* not supported - VHOST_USER_PROTOCOL_F_HOST_NOTIFIER */
>   	default:
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index f4554412e607..24af422b5a3e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -29,7 +29,7 @@
>   		 (1ULL << VIRTIO_F_VERSION_1)			| \
>   		 (1ULL << VIRTIO_NET_F_STATUS)			| \
>   		 (1ULL << VIRTIO_F_ORDER_PLATFORM)		| \
> -		 (1ULL << VIRTIO_F_IOMMU_PLATFORM)		| \
> +		 (1ULL << VIRTIO_F_ACCESS_PLATFORM)		| \
>   		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
>   
>   /* Only one queue pair for now. */
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index c7334cc65bb2..a9bc5e0fb353 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -55,7 +55,7 @@ struct vdpasim_virtqueue {
>   
>   static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
>   			      (1ULL << VIRTIO_F_VERSION_1)  |
> -			      (1ULL << VIRTIO_F_IOMMU_PLATFORM);
> +			      (1ULL << VIRTIO_F_ACCESS_PLATFORM);
>   
>   /* State of each vdpasim device */
>   struct vdpasim {
> @@ -450,7 +450,7 @@ static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
>   	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>   
>   	/* DMA mapping must be done by driver */
> -	if (!(features & (1ULL << VIRTIO_F_IOMMU_PLATFORM)))
> +	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
>   		return -EINVAL;
>   
>   	vdpasim->features = features & vdpasim_features;
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index e992decfec53..8e0921d3805d 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -73,7 +73,7 @@ enum {
>   	VHOST_NET_FEATURES = VHOST_FEATURES |
>   			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
>   			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> -			 (1ULL << VIRTIO_F_IOMMU_PLATFORM)
> +			 (1ULL << VIRTIO_F_ACCESS_PLATFORM)
>   };
>   
>   enum {
> @@ -1653,7 +1653,7 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
>   	    !vhost_log_access_ok(&n->dev))
>   		goto out_unlock;
>   
> -	if ((features & (1ULL << VIRTIO_F_IOMMU_PLATFORM))) {
> +	if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
>   		if (vhost_init_device_iotlb(&n->dev, true))
>   			goto out_unlock;
>   	}
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index a54b60d6623f..18869a35d408 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -31,7 +31,7 @@ enum {
>   		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
>   		(1ULL << VIRTIO_F_ANY_LAYOUT) |
>   		(1ULL << VIRTIO_F_VERSION_1) |
> -		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
> +		(1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>   		(1ULL << VIRTIO_F_RING_PACKED) |
>   		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
>   		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 1f157d2f4952..fc7301406540 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -1120,7 +1120,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
>   	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
>   		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
>   
> -	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);
> +	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
>   	return 0;
>   }
>   
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 58b96baa8d48..a1a5c2a91426 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2225,7 +2225,7 @@ void vring_transport_features(struct virtio_device *vdev)
>   			break;
>   		case VIRTIO_F_VERSION_1:
>   			break;
> -		case VIRTIO_F_IOMMU_PLATFORM:
> +		case VIRTIO_F_ACCESS_PLATFORM:
>   			break;
>   		case VIRTIO_F_RING_PACKED:
>   			break;
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index bb4cc4910750..f2cc2a0df174 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -171,7 +171,7 @@ static inline bool virtio_has_iommu_quirk(const struct virtio_device *vdev)
>   	 * Note the reverse polarity of the quirk feature (compared to most
>   	 * other features), this is for compatibility with legacy systems.
>   	 */
> -	return !virtio_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM);
> +	return !virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM);
>   }
>   
>   static inline
> diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> index ff8e7dc9d4dd..b5eda06f0d57 100644
> --- a/include/uapi/linux/virtio_config.h
> +++ b/include/uapi/linux/virtio_config.h
> @@ -67,13 +67,17 @@
>   #define VIRTIO_F_VERSION_1		32
>   
>   /*
> - * If clear - device has the IOMMU bypass quirk feature.
> - * If set - use platform tools to detect the IOMMU.
> + * If clear - device has the platform DMA (e.g. IOMMU) bypass quirk feature.
> + * If set - use platform DMA tools to access the memory.
>    *
>    * Note the reverse polarity (compared to most other features),
>    * this is for compatibility with legacy systems.
>    */
> -#define VIRTIO_F_IOMMU_PLATFORM		33
> +#define VIRTIO_F_ACCESS_PLATFORM	33
> +#ifndef __KERNEL__
> +/* Legacy name for VIRTIO_F_ACCESS_PLATFORM (for compatibility with old userspace) */
> +#define VIRTIO_F_IOMMU_PLATFORM		VIRTIO_F_ACCESS_PLATFORM
> +#endif /* __KERNEL__ */
>   
>   /* This feature indicates support for the packed virtqueue layout. */
>   #define VIRTIO_F_RING_PACKED		34
> diff --git a/tools/virtio/linux/virtio_config.h b/tools/virtio/linux/virtio_config.h
> index dbf14c1e2188..f99ae42668e0 100644
> --- a/tools/virtio/linux/virtio_config.h
> +++ b/tools/virtio/linux/virtio_config.h
> @@ -51,7 +51,7 @@ static inline bool virtio_has_iommu_quirk(const struct virtio_device *vdev)
>   	 * Note the reverse polarity of the quirk feature (compared to most
>   	 * other features), this is for compatibility with legacy systems.
>   	 */
> -	return !virtio_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM);
> +	return !virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM);
>   }
>   
>   static inline bool virtio_is_little_endian(struct virtio_device *vdev)


Acked-by: Jason Wang <jasowang@redhat.com>


