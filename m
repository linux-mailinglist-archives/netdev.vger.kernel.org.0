Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AF33A28C4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 11:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFJJyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 05:54:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhFJJyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 05:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623318725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YoVNk4j9gtFSnQb0D1+J8+G6ag1xYY93rHbDDkf83Y8=;
        b=i++hZpXcnaHGgbkUS5mnUN9KSWZ33IxoBhg9I3i4t0SUDDy6FyG+nHkYPOLqfsmmgRlcUo
        5PX40xG44GpZLnvWlUsCRqhxgs949DsOUdR7F8ojuEo2zBZuR7eLwah6+s8VTCY0RG8mZy
        pXZsiQVAax+f2Lymp5OgeY60dhrHlWw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-mB1Q_Om1N6yxgSWqAB3ilg-1; Thu, 10 Jun 2021 05:52:05 -0400
X-MC-Unique: mB1Q_Om1N6yxgSWqAB3ilg-1
Received: by mail-wm1-f69.google.com with SMTP id v25-20020a1cf7190000b0290197a4be97b7so2845270wmh.9
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 02:52:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YoVNk4j9gtFSnQb0D1+J8+G6ag1xYY93rHbDDkf83Y8=;
        b=GLyEWBKahte1jEVfgz6i6Ipo45zeCzMD/vUSF9Z/ub+V45lr4y0KYbRNEl9HjJsew4
         uALy3VIJN65whLWz4bQgiorTwxzmFMG5A9VnN/EnHNY1WPGRzIs1CCj5LTTjRE4oa/sl
         h9SNKmcp5CSdUeBga5NdTqRKiyRedPDFvDVgu3B3i64/q33U6omH5kgPfno1k1AhdmJO
         0DVk2CtTdbn9QiB/mtHMTmC6Vk0bCKHHn9bwrWkB8rilKzXC+X4hkxZLWcZsYQJK4NW7
         gfiAhKMBbNBxqXDDUAbGFjmKmIYMiJZ0pNfcPKlbWfA8SBC9K14jVpFCpCnTTEiq4O3y
         p8eg==
X-Gm-Message-State: AOAM5318tQTlKlPjTBXKeMoETW1U0pwaTlAURDPuJd1peDREzxuzYrYH
        G5lz2GoDlKnV+Xt73kaaQxpRLOtPXUdYrn1d6zKYYt2Wzk2ZxvhR69FVHfW7b3vn5jAWuePEDn2
        UMkFpQLS7OTkBj9RT
X-Received: by 2002:a5d:6111:: with SMTP id v17mr4390240wrt.20.1623318724404;
        Thu, 10 Jun 2021 02:52:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJws7/mCqvX4+aPUx81hg5pKpa/fS4mRAQA+Xfvs2mECl/9+zJ/36DfVftBI3zRBfZ+Q7l7Vlw==
X-Received: by 2002:a5d:6111:: with SMTP id v17mr4390203wrt.20.1623318724162;
        Thu, 10 Jun 2021 02:52:04 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i2sm2324384wmo.40.2021.06.10.02.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 02:52:03 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, arnd@arndb.de, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Subject: Re: [RFC PATCH V3 10/11] HV/Netvsc: Add Isolation VM support for
 netvsc driver
In-Reply-To: <20210530150628.2063957-11-ltykernel@gmail.com>
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-11-ltykernel@gmail.com>
Date:   Thu, 10 Jun 2021 11:52:01 +0200
Message-ID: <874ke6yrlq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tianyu Lan <ltykernel@gmail.com> writes:

> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>
> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> pagebuffer() still need to handle. Use DMA API to map/umap these
> memory during sending/receiving packet and Hyper-V DMA ops callback
> will use swiotlb function to allocate bounce buffer and copy data
> from/to bounce buffer.
>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/net/hyperv/hyperv_net.h   |   6 ++
>  drivers/net/hyperv/netvsc.c       | 125 ++++++++++++++++++++++++++++--
>  drivers/net/hyperv/rndis_filter.c |   3 +
>  include/linux/hyperv.h            |   5 ++
>  4 files changed, 133 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
> index b11aa68b44ec..c2fbb9d4df2c 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -164,6 +164,7 @@ struct hv_netvsc_packet {
>  	u32 total_bytes;
>  	u32 send_buf_index;
>  	u32 total_data_buflen;
> +	struct hv_dma_range *dma_range;
>  };
>  
>  #define NETVSC_HASH_KEYLEN 40
> @@ -1074,6 +1075,7 @@ struct netvsc_device {
>  
>  	/* Receive buffer allocated by us but manages by NetVSP */
>  	void *recv_buf;
> +	void *recv_original_buf;
>  	u32 recv_buf_size; /* allocated bytes */
>  	u32 recv_buf_gpadl_handle;
>  	u32 recv_section_cnt;
> @@ -1082,6 +1084,8 @@ struct netvsc_device {
>  
>  	/* Send buffer allocated by us */
>  	void *send_buf;
> +	void *send_original_buf;
> +	u32 send_buf_size;
>  	u32 send_buf_gpadl_handle;
>  	u32 send_section_cnt;
>  	u32 send_section_size;
> @@ -1729,4 +1733,6 @@ struct rndis_message {
>  #define RETRY_US_HI	10000
>  #define RETRY_MAX	2000	/* >10 sec */
>  
> +void netvsc_dma_unmap(struct hv_device *hv_dev,
> +		      struct hv_netvsc_packet *packet);
>  #endif /* _HYPERV_NET_H */
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 7bd935412853..a01740c6c6b8 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -153,8 +153,21 @@ static void free_netvsc_device(struct rcu_head *head)
>  	int i;
>  
>  	kfree(nvdev->extension);
> -	vfree(nvdev->recv_buf);
> -	vfree(nvdev->send_buf);
> +
> +	if (nvdev->recv_original_buf) {
> +		vunmap(nvdev->recv_buf);
> +		vfree(nvdev->recv_original_buf);
> +	} else {
> +		vfree(nvdev->recv_buf);
> +	}
> +
> +	if (nvdev->send_original_buf) {
> +		vunmap(nvdev->send_buf);
> +		vfree(nvdev->send_original_buf);
> +	} else {
> +		vfree(nvdev->send_buf);
> +	}
> +
>  	kfree(nvdev->send_section_map);
>  
>  	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
> @@ -338,8 +351,10 @@ static int netvsc_init_buf(struct hv_device *device,
>  	struct net_device *ndev = hv_get_drvdata(device);
>  	struct nvsp_message *init_packet;
>  	unsigned int buf_size;
> +	unsigned long *pfns;
>  	size_t map_words;
>  	int i, ret = 0;
> +	void *vaddr;
>  
>  	/* Get receive buffer area. */
>  	buf_size = device_info->recv_sections * device_info->recv_section_size;
> @@ -375,6 +390,21 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>  
> +	if (hv_isolation_type_snp()) {
> +		pfns = kcalloc(buf_size / HV_HYP_PAGE_SIZE, sizeof(unsigned long),
> +			       GFP_KERNEL);
> +		for (i = 0; i < buf_size / HV_HYP_PAGE_SIZE; i++)
> +			pfns[i] = virt_to_hvpfn(net_device->recv_buf + i * HV_HYP_PAGE_SIZE) +
> +				(ms_hyperv.shared_gpa_boundary >> HV_HYP_PAGE_SHIFT);
> +
> +		vaddr = vmap_pfn(pfns, buf_size / HV_HYP_PAGE_SIZE, PAGE_KERNEL_IO);
> +		kfree(pfns);
> +		if (!vaddr)
> +			goto cleanup;
> +		net_device->recv_original_buf = net_device->recv_buf;
> +		net_device->recv_buf = vaddr;
> +	}
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet = &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -477,6 +507,23 @@ static int netvsc_init_buf(struct hv_device *device,
>  		goto cleanup;
>  	}
>  
> +	if (hv_isolation_type_snp()) {
> +		pfns = kcalloc(buf_size / HV_HYP_PAGE_SIZE, sizeof(unsigned long),
> +			       GFP_KERNEL);
> +
> +		for (i = 0; i < buf_size / HV_HYP_PAGE_SIZE; i++)
> +			pfns[i] = virt_to_hvpfn(net_device->send_buf + i * HV_HYP_PAGE_SIZE)
> +				+ (ms_hyperv.shared_gpa_boundary >> HV_HYP_PAGE_SHIFT);
> +
> +		vaddr = vmap_pfn(pfns, buf_size / HV_HYP_PAGE_SIZE, PAGE_KERNEL_IO);
> +		kfree(pfns);
> +		if (!vaddr)
> +			goto cleanup;
> +
> +		net_device->send_original_buf = net_device->send_buf;
> +		net_device->send_buf = vaddr;
> +	}
> +
>  	/* Notify the NetVsp of the gpadl handle */
>  	init_packet = &net_device->channel_init_pkt;
>  	memset(init_packet, 0, sizeof(struct nvsp_message));
> @@ -767,7 +814,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
>  
>  	/* Notify the layer above us */
>  	if (likely(skb)) {
> -		const struct hv_netvsc_packet *packet
> +		struct hv_netvsc_packet *packet
>  			= (struct hv_netvsc_packet *)skb->cb;
>  		u32 send_index = packet->send_buf_index;
>  		struct netvsc_stats *tx_stats;
> @@ -783,6 +830,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
>  		tx_stats->bytes += packet->total_bytes;
>  		u64_stats_update_end(&tx_stats->syncp);
>  
> +		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>  		napi_consume_skb(skb, budget);
>  	}
>  
> @@ -947,6 +995,63 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
>  		memset(dest, 0, padding);
>  }
>  
> +void netvsc_dma_unmap(struct hv_device *hv_dev,
> +		      struct hv_netvsc_packet *packet)
> +{
> +	u32 page_count = packet->cp_partial ?
> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
> +		packet->page_buf_cnt;
> +	int i;
> +
> +	if (!packet->dma_range)
> +		return;
> +
> +	for (i = 0; i < page_count; i++)
> +		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
> +				 packet->dma_range[i].mapping_size,
> +				 DMA_TO_DEVICE);
> +
> +	kfree(packet->dma_range);
> +}
> +
> +int netvsc_dma_map(struct hv_device *hv_dev,
> +		   struct hv_netvsc_packet *packet,
> +		   struct hv_page_buffer *pb)
> +{
> +	u32 page_count =  packet->cp_partial ?
> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
> +		packet->page_buf_cnt;
> +	dma_addr_t dma;
> +	int i;
> +
> +	packet->dma_range = kcalloc(page_count,
> +				    sizeof(*packet->dma_range),
> +				    GFP_KERNEL);
> +	if (!packet->dma_range)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < page_count; i++) {
> +		char *src = phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
> +					 + pb[i].offset);
> +		u32 len = pb[i].len;
> +
> +		dma = dma_map_single(&hv_dev->device, src, len,
> +				     DMA_TO_DEVICE);
> +		if (dma_mapping_error(&hv_dev->device, dma)) {
> +			kfree(packet->dma_range);
> +			return -ENOMEM;
> +		}
> +
> +		packet->dma_range[i].dma = dma;
> +		packet->dma_range[i].mapping_size = len;
> +		pb[i].pfn = dma >> HV_HYP_PAGE_SHIFT;
> +		pb[i].offset = offset_in_hvpage(dma);
> +		pb[i].len = len;
> +	}
> +
> +	return 0;
> +}
> +
>  static inline int netvsc_send_pkt(
>  	struct hv_device *device,
>  	struct hv_netvsc_packet *packet,
> @@ -987,14 +1092,22 @@ static inline int netvsc_send_pkt(
>  
>  	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
>  
> +	packet->dma_range = NULL;
>  	if (packet->page_buf_cnt) {
>  		if (packet->cp_partial)
>  			pb += packet->rmsg_pgcnt;
>  
> +		ret = netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
> +		if (ret)
> +			return ret;
> +
>  		ret = vmbus_sendpacket_pagebuffer(out_channel,
> -						  pb, packet->page_buf_cnt,
> -						  &nvmsg, sizeof(nvmsg),
> -						  req_id);
> +					  pb, packet->page_buf_cnt,
> +					  &nvmsg, sizeof(nvmsg),
> +					  req_id);

Nitpick: stray change? 

> +
> +		if (ret)
> +			netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>  	} else {
>  		ret = vmbus_sendpacket(out_channel,
>  				       &nvmsg, sizeof(nvmsg),
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
> index 983bf362466a..448c1ee39246 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -293,6 +293,8 @@ static void rndis_filter_receive_response(struct net_device *ndev,
>  	u32 *req_id = &resp->msg.init_complete.req_id;
>  	struct rndis_device *dev = nvdev->extension;
>  	struct rndis_request *request = NULL;
> +	struct hv_device *hv_dev = ((struct net_device_context *)
> +			netdev_priv(ndev))->device_ctx;
>  	bool found = false;
>  	unsigned long flags;
>  
> @@ -361,6 +363,7 @@ static void rndis_filter_receive_response(struct net_device *ndev,
>  			}
>  		}
>  
> +		netvsc_dma_unmap(hv_dev, &request->pkt);
>  		complete(&request->wait_event);
>  	} else {
>  		netdev_err(ndev,
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index babbe19f57e2..90abff664495 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1616,6 +1616,11 @@ struct hyperv_service_callback {
>  	void (*callback)(void *context);
>  };
>  
> +struct hv_dma_range {
> +	dma_addr_t dma;
> +	u32 mapping_size;
> +};
> +
>  #define MAX_SRV_VER	0x7ffffff
>  extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp, u8 *buf, u32 buflen,
>  				const int *fw_version, int fw_vercnt,

-- 
Vitaly

