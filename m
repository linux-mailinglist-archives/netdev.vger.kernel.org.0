Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F343645360E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbhKPPmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbhKPPmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 10:42:36 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DEAC061746;
        Tue, 16 Nov 2021 07:39:39 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id iq11so16068308pjb.3;
        Tue, 16 Nov 2021 07:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JY7pElcL7BP9H4psSINWD9PF2/JWAEjs+L3UP6LQB6Q=;
        b=X5jEIEh0nBMNIVa+E56UAIT0Y6syTwfpUav9bEEARradq307nzQYexfIDfZLd+Apvu
         imiWZOxs8RxTLZR/6zFD+rWYiSpa2xUUKcc2poDDadZCwefV92sMUOyDBWVpYLT+qWmx
         ND4h43brV1jZBce9wabu7GdGYGb1qzwMHyK1Y6hdkSnIRvq+fiovugAjHAayJMTk9MoY
         qY260friOuGqQ18vWarOu+os+lAKNDZbwmsqfSGiefhC4azrSMXNUrMbDaCNif792DYg
         RyBgtYNyuii/23JH8mPU2LLSXT1uYtI5uXsjUVvBMeqYuP3hVvMLMeyXf5XL1gUviDca
         Vlig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JY7pElcL7BP9H4psSINWD9PF2/JWAEjs+L3UP6LQB6Q=;
        b=7yZRcO3tHPqjYdKrUblgj4yW6rU8Atvbz9RfBUav0wdQtF9Gt9XEq9F+zXNb2Y+G5G
         PB5327x/HninNVLC8WaTZCLE+6xK4aLJCli+2wFn9A9UuxMG8V4CRnjDW/dPUqvYemFf
         Jrh3852EKsFYyH5q2glucF2FEe2WlDHF3+w/7ABP3Od3sSvFbJA8tQvncLVlS42h6Pux
         1T8D9wVvcLKFjmCtab6DOjCzlcNl2Fvqggcuel7qKshFYFpqhFVGrn6vgASeZKAcO1x7
         KUDiEdkTuGhOeVTh4VrmjK1r5x2gdrKe30SepXN4lhLF/oPEDTydZcA1MeeoBm93Tp/J
         cwcw==
X-Gm-Message-State: AOAM533PtM02ySp7aE+ckMurBLVbTNWbAJB35PLSKXzN4KYrIiRAazA/
        sKx1811iY4IPWS6M1vzLN15WbSRxKEuXOQ==
X-Google-Smtp-Source: ABdhPJyrnTBpH6wm07HxI5D96I6vFFntDeVQDHLjseeuLAvO0SAM7oG/CailxbS1yK2b9roxkvzjHw==
X-Received: by 2002:a17:90b:380a:: with SMTP id mq10mr53365pjb.61.1637077178648;
        Tue, 16 Nov 2021 07:39:38 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:3:57e4:b776:c854:76dd])
        by smtp.gmail.com with ESMTPSA id x64sm1981948pfd.151.2021.11.16.07.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 07:39:38 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        thomas.lendacky@amd.com, dave.hansen@intel.com
Subject: [PATCH 4/5] net: netvsc: Add Isolation VM support for netvsc driver
Date:   Tue, 16 Nov 2021 10:39:22 -0500
Message-Id: <20211116153923.196763-5-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116153923.196763-1-ltykernel@gmail.com>
References: <20211116153923.196763-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

In Isolation VM, all shared memory with host needs to mark visible
to host via hvcall. vmbus_establish_gpadl() has already done it for
netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
pagebuffer() stills need to be handled. Use DMA API to map/umap
these memory during sending/receiving packet and Hyper-V swiotlb
bounce buffer dma address will be returned. The swiotlb bounce buffer
has been masked to be visible to host during boot up.

Allocate rx/tx ring buffer via dma_alloc_noncontiguous() in Isolation
VM. After calling vmbus_establish_gpadl() which marks these pages visible
to host, map these pages unencrypted addes space via dma_vmap_noncontiguous().

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h   |   5 +
 drivers/net/hyperv/netvsc.c       | 192 +++++++++++++++++++++++++++---
 drivers/net/hyperv/rndis_filter.c |   2 +
 include/linux/hyperv.h            |   6 +
 4 files changed, 190 insertions(+), 15 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 315278a7cf88..31c77a00d01e 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -164,6 +164,7 @@ struct hv_netvsc_packet {
 	u32 total_bytes;
 	u32 send_buf_index;
 	u32 total_data_buflen;
+	struct hv_dma_range *dma_range;
 };
 
 #define NETVSC_HASH_KEYLEN 40
@@ -1074,6 +1075,7 @@ struct netvsc_device {
 
 	/* Receive buffer allocated by us but manages by NetVSP */
 	void *recv_buf;
+	struct sg_table *recv_sgt;
 	u32 recv_buf_size; /* allocated bytes */
 	struct vmbus_gpadl recv_buf_gpadl_handle;
 	u32 recv_section_cnt;
@@ -1082,6 +1084,7 @@ struct netvsc_device {
 
 	/* Send buffer allocated by us */
 	void *send_buf;
+	struct sg_table *send_sgt;
 	u32 send_buf_size;
 	struct vmbus_gpadl send_buf_gpadl_handle;
 	u32 send_section_cnt;
@@ -1731,4 +1734,6 @@ struct rndis_message {
 #define RETRY_US_HI	10000
 #define RETRY_MAX	2000	/* >10 sec */
 
+void netvsc_dma_unmap(struct hv_device *hv_dev,
+		      struct hv_netvsc_packet *packet);
 #endif /* _HYPERV_NET_H */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 396bc1c204e6..9cdc71930830 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/rtnetlink.h>
 #include <linux/prefetch.h>
+#include <linux/gfp.h>
 
 #include <asm/sync_bitops.h>
 #include <asm/mshyperv.h>
@@ -146,15 +147,39 @@ static struct netvsc_device *alloc_net_device(void)
 	return net_device;
 }
 
+static struct hv_device *netvsc_channel_to_device(struct vmbus_channel *channel)
+{
+	struct vmbus_channel *primary = channel->primary_channel;
+
+	return primary ? primary->device_obj : channel->device_obj;
+}
+
 static void free_netvsc_device(struct rcu_head *head)
 {
 	struct netvsc_device *nvdev
 		= container_of(head, struct netvsc_device, rcu);
+	struct hv_device *dev =
+		netvsc_channel_to_device(nvdev->chan_table[0].channel);
 	int i;
 
 	kfree(nvdev->extension);
-	vfree(nvdev->recv_buf);
-	vfree(nvdev->send_buf);
+
+	if (nvdev->recv_sgt) {
+		dma_vunmap_noncontiguous(&dev->device, nvdev->recv_buf);
+		dma_free_noncontiguous(&dev->device, nvdev->recv_buf_size,
+				       nvdev->recv_sgt, DMA_FROM_DEVICE);
+	} else {
+		vfree(nvdev->recv_buf);
+	}
+
+	if (nvdev->send_sgt) {
+		dma_vunmap_noncontiguous(&dev->device, nvdev->send_buf);
+		dma_free_noncontiguous(&dev->device, nvdev->send_buf_size,
+				       nvdev->send_sgt, DMA_TO_DEVICE);
+	} else {
+		vfree(nvdev->send_buf);
+	}
+
 	kfree(nvdev->send_section_map);
 
 	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
@@ -348,7 +373,21 @@ static int netvsc_init_buf(struct hv_device *device,
 		buf_size = min_t(unsigned int, buf_size,
 				 NETVSC_RECEIVE_BUFFER_SIZE_LEGACY);
 
-	net_device->recv_buf = vzalloc(buf_size);
+	if (hv_isolation_type_snp()) {
+		net_device->recv_sgt =
+			dma_alloc_noncontiguous(&device->device, buf_size,
+						DMA_FROM_DEVICE, GFP_KERNEL, 0);
+		if (!net_device->recv_sgt) {
+			pr_err("Fail to allocate recv buffer buf_size %d.\n.", buf_size);
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+
+		net_device->recv_buf = (void *)net_device->recv_sgt->sgl->dma_address;
+	} else {
+		net_device->recv_buf = vzalloc(buf_size);
+	}
+
 	if (!net_device->recv_buf) {
 		netdev_err(ndev,
 			   "unable to allocate receive buffer of size %u\n",
@@ -357,8 +396,6 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
-	net_device->recv_buf_size = buf_size;
-
 	/*
 	 * Establish the gpadl handle for this buffer on this
 	 * channel.  Note: This call uses the vmbus connection rather
@@ -373,6 +410,19 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
+	if (net_device->recv_sgt) {
+		net_device->recv_buf =
+			dma_vmap_noncontiguous(&device->device, buf_size,
+					       net_device->recv_sgt);
+		if (!net_device->recv_buf) {
+			pr_err("Fail to vmap recv buffer.\n");
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+	}
+
+	net_device->recv_buf_size = buf_size;
+
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -454,14 +504,27 @@ static int netvsc_init_buf(struct hv_device *device,
 	buf_size = device_info->send_sections * device_info->send_section_size;
 	buf_size = round_up(buf_size, PAGE_SIZE);
 
-	net_device->send_buf = vzalloc(buf_size);
+	if (hv_isolation_type_snp()) {
+		net_device->send_sgt =
+			dma_alloc_noncontiguous(&device->device, buf_size,
+						DMA_TO_DEVICE, GFP_KERNEL, 0);
+		if (!net_device->send_sgt) {
+			pr_err("Fail to allocate send buffer buf_size %d.\n.", buf_size);
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+
+		net_device->send_buf = (void *)net_device->send_sgt->sgl->dma_address;
+	} else {
+		net_device->send_buf = vzalloc(buf_size);
+	}
+
 	if (!net_device->send_buf) {
 		netdev_err(ndev, "unable to allocate send buffer of size %u\n",
 			   buf_size);
 		ret = -ENOMEM;
 		goto cleanup;
 	}
-	net_device->send_buf_size = buf_size;
 
 	/* Establish the gpadl handle for this buffer on this
 	 * channel.  Note: This call uses the vmbus connection rather
@@ -476,6 +539,19 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
+	if (net_device->send_sgt) {
+		net_device->send_buf =
+			dma_vmap_noncontiguous(&device->device, buf_size,
+					       net_device->send_sgt);
+		if (!net_device->send_buf) {
+			pr_err("Fail to vmap send buffer.\n");
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+	}
+
+	net_device->send_buf_size = buf_size;
+
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -766,7 +842,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 
 	/* Notify the layer above us */
 	if (likely(skb)) {
-		const struct hv_netvsc_packet *packet
+		struct hv_netvsc_packet *packet
 			= (struct hv_netvsc_packet *)skb->cb;
 		u32 send_index = packet->send_buf_index;
 		struct netvsc_stats *tx_stats;
@@ -782,6 +858,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 		tx_stats->bytes += packet->total_bytes;
 		u64_stats_update_end(&tx_stats->syncp);
 
+		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
 		napi_consume_skb(skb, budget);
 	}
 
@@ -946,6 +1023,87 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
 		memset(dest, 0, padding);
 }
 
+void netvsc_dma_unmap(struct hv_device *hv_dev,
+		      struct hv_netvsc_packet *packet)
+{
+	u32 page_count = packet->cp_partial ?
+		packet->page_buf_cnt - packet->rmsg_pgcnt :
+		packet->page_buf_cnt;
+	int i;
+
+	if (!hv_is_isolation_supported())
+		return;
+
+	if (!packet->dma_range)
+		return;
+
+	for (i = 0; i < page_count; i++)
+		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
+				 packet->dma_range[i].mapping_size,
+				 DMA_TO_DEVICE);
+
+	kfree(packet->dma_range);
+}
+
+/* netvsc_dma_map - Map swiotlb bounce buffer with data page of
+ * packet sent by vmbus_sendpacket_pagebuffer() in the Isolation
+ * VM.
+ *
+ * In isolation VM, netvsc send buffer has been marked visible to
+ * host and so the data copied to send buffer doesn't need to use
+ * bounce buffer. The data pages handled by vmbus_sendpacket_pagebuffer()
+ * may not be copied to send buffer and so these pages need to be
+ * mapped with swiotlb bounce buffer. netvsc_dma_map() is to do
+ * that. The pfns in the struct hv_page_buffer need to be converted
+ * to bounce buffer's pfn. The loop here is necessary because the
+ * entries in the page buffer array are not necessarily full
+ * pages of data.  Each entry in the array has a separate offset and
+ * len that may be non-zero, even for entries in the middle of the
+ * array.  And the entries are not physically contiguous.  So each
+ * entry must be individually mapped rather than as a contiguous unit.
+ * So not use dma_map_sg() here.
+ */
+static int netvsc_dma_map(struct hv_device *hv_dev,
+			  struct hv_netvsc_packet *packet,
+			  struct hv_page_buffer *pb)
+{
+	u32 page_count =  packet->cp_partial ?
+		packet->page_buf_cnt - packet->rmsg_pgcnt :
+		packet->page_buf_cnt;
+	dma_addr_t dma;
+	int i;
+
+	if (!hv_is_isolation_supported())
+		return 0;
+
+	packet->dma_range = kcalloc(page_count,
+				    sizeof(*packet->dma_range),
+				    GFP_KERNEL);
+	if (!packet->dma_range)
+		return -ENOMEM;
+
+	for (i = 0; i < page_count; i++) {
+		char *src = phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
+					 + pb[i].offset);
+		u32 len = pb[i].len;
+
+		dma = dma_map_single(&hv_dev->device, src, len,
+				     DMA_TO_DEVICE);
+		if (dma_mapping_error(&hv_dev->device, dma)) {
+			kfree(packet->dma_range);
+			return -ENOMEM;
+		}
+
+		packet->dma_range[i].dma = dma;
+		packet->dma_range[i].mapping_size = len;
+		pb[i].pfn = dma >> HV_HYP_PAGE_SHIFT;
+		pb[i].offset = offset_in_hvpage(dma);
+		pb[i].len = len;
+	}
+
+	return 0;
+}
+
 static inline int netvsc_send_pkt(
 	struct hv_device *device,
 	struct hv_netvsc_packet *packet,
@@ -986,14 +1144,24 @@ static inline int netvsc_send_pkt(
 
 	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
 
+	packet->dma_range = NULL;
 	if (packet->page_buf_cnt) {
 		if (packet->cp_partial)
 			pb += packet->rmsg_pgcnt;
 
+		ret = netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
+		if (ret) {
+			ret = -EAGAIN;
+			goto exit;
+		}
+
 		ret = vmbus_sendpacket_pagebuffer(out_channel,
 						  pb, packet->page_buf_cnt,
 						  &nvmsg, sizeof(nvmsg),
 						  req_id);
+
+		if (ret)
+			netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
 	} else {
 		ret = vmbus_sendpacket(out_channel,
 				       &nvmsg, sizeof(nvmsg),
@@ -1001,6 +1169,7 @@ static inline int netvsc_send_pkt(
 				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	}
 
+exit:
 	if (ret == 0) {
 		atomic_inc_return(&nvchan->queue_sends);
 
@@ -1515,13 +1684,6 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
 	return 0;
 }
 
-static struct hv_device *netvsc_channel_to_device(struct vmbus_channel *channel)
-{
-	struct vmbus_channel *primary = channel->primary_channel;
-
-	return primary ? primary->device_obj : channel->device_obj;
-}
-
 /* Network processing softirq
  * Process data in incoming ring buffer from host
  * Stops when ring is empty or budget is met or exceeded.
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index f6c9c2a670f9..448fcc325ed7 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -361,6 +361,8 @@ static void rndis_filter_receive_response(struct net_device *ndev,
 			}
 		}
 
+		netvsc_dma_unmap(((struct net_device_context *)
+			netdev_priv(ndev))->device_ctx, &request->pkt);
 		complete(&request->wait_event);
 	} else {
 		netdev_err(ndev,
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 4d44fb3b3f1c..8882e46d1070 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/reciprocal_div.h>
 #include <asm/hyperv-tlfs.h>
+#include <linux/dma-map-ops.h>
 
 #define MAX_PAGE_BUFFER_COUNT				32
 #define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
@@ -1583,6 +1584,11 @@ struct hyperv_service_callback {
 	void (*callback)(void *context);
 };
 
+struct hv_dma_range {
+	dma_addr_t dma;
+	u32 mapping_size;
+};
+
 #define MAX_SRV_VER	0x7ffffff
 extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp, u8 *buf, u32 buflen,
 				const int *fw_version, int fw_vercnt,
-- 
2.25.1

