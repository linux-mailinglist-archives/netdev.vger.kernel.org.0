Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0E5465267
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 17:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351417AbhLAQGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 11:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351330AbhLAQGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 11:06:34 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A4AC06174A;
        Wed,  1 Dec 2021 08:03:13 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id r130so25008331pfc.1;
        Wed, 01 Dec 2021 08:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P6jIP3T/88hcn+4uXsWHybVXUPopSAhJN5UnS1dO/gw=;
        b=YqhCgMqGGAoKeMbnI3JhHCwrCwNztDDwq0dloNgEJfqScbshgD99lN//qdQLoF5CWI
         DiPXmpGv8dU/Z5v003gLmrPGtN58HVvwBiD4yrNE9Gvcwz/FSTuC8I4h4MLMSBg9jEyG
         eHK/rKpJBB+8PDeMvLKL1ncl8KaL8HfwoXWhYeszYNzWCbj49prFTZn7yLPK0/ezUHQK
         JHoVvw0bvdf3BItAbYd7qEwM6bayMRNf9TBR9NyE3iZvAzI+ayVJeW+gBWWjueF+ndSS
         WClSs+QR5fpaYtbOYth6Xp159gD3qRU14EblzupnbexmzfiNLyGarogxPiTFUijueApY
         ZpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P6jIP3T/88hcn+4uXsWHybVXUPopSAhJN5UnS1dO/gw=;
        b=r/k8q9MM7lvXlWOzqI+rKfIkpKUuFe/58DnWGEPnUxBpNc97R7uFDc77RXnSeEV57I
         3R0nNLbU92QcroZIcZboSi+0fzNZn4QyUFvGpuSTthCG+wStHICl6fzLXeGLJHIeGxLL
         CRzlHVhhPcmz+dhQHwJ1h/DLGP8CUVes10byZYxGJn5iYDQH+eFIXKxHdDxiNnRSrtS4
         EYJLhxI+W6/XE3hH/oLRHJ9aZh0IYCAX9iFqBb+tQ6N6ed3wZjOG89LPWVQWbNVPd5NV
         SKXsHDqHr7NvHJlF0QzRzNpiPZtAXe4jnABqF3lH0nJrT5EQiacm1vIwSV2gvLwchxjL
         3Qpw==
X-Gm-Message-State: AOAM531StCLy/0nL6tttiSQbpBQJepj3hy8kRfY27oVS8WBGRgSSC6/D
        0ZMUoYqN6TLF5l4kfgLRNZA=
X-Google-Smtp-Source: ABdhPJwC6+GxXgRAk+qDIq+YZnUASxcFMCjjXfGGpNikC86I7TygW1AcsqcU0QsuiH/J7Xyk7ymQUA==
X-Received: by 2002:a63:8541:: with SMTP id u62mr5146418pgd.433.1638374592680;
        Wed, 01 Dec 2021 08:03:12 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:f:7fe9:3f1e:749e:5d26])
        by smtp.gmail.com with ESMTPSA id i193sm260316pfe.87.2021.12.01.08.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 08:03:12 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V3 5/5] hv_netvsc: Add Isolation VM support for netvsc driver
Date:   Wed,  1 Dec 2021 11:02:56 -0500
Message-Id: <20211201160257.1003912-6-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201160257.1003912-1-ltykernel@gmail.com>
References: <20211201160257.1003912-1-ltykernel@gmail.com>
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
bounce buffer dma adress will be returned. The swiotlb bounce buffer
has been masked to be visible to host during boot up.

rx/tx ring buffer is allocated via vzalloc() and they need to be
mapped into unencrypted address space(above vTOM) before sharing
with host and accessing. Add hv_map/unmap_memory() to map/umap rx
/tx ring buffer.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v2:
       * Add hv_map/unmap_memory() to map/umap rx/tx ring buffer.
---
 arch/x86/hyperv/ivm.c             |  28 ++++++
 drivers/hv/hv_common.c            |  11 +++
 drivers/net/hyperv/hyperv_net.h   |   5 ++
 drivers/net/hyperv/netvsc.c       | 136 +++++++++++++++++++++++++++++-
 drivers/net/hyperv/netvsc_drv.c   |   1 +
 drivers/net/hyperv/rndis_filter.c |   2 +
 include/asm-generic/mshyperv.h    |   2 +
 include/linux/hyperv.h            |   5 ++
 8 files changed, 187 insertions(+), 3 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 69c7a57f3307..9f78d8f67ea3 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -287,3 +287,31 @@ int hv_set_mem_host_visibility(unsigned long kbuffer, int pagecount, bool visibl
 	kfree(pfn_array);
 	return ret;
 }
+
+/*
+ * hv_map_memory - map memory to extra space in the AMD SEV-SNP Isolation VM.
+ */
+void *hv_map_memory(void *addr, unsigned long size)
+{
+	unsigned long *pfns = kcalloc(size / HV_HYP_PAGE_SIZE,
+				      sizeof(unsigned long), GFP_KERNEL);
+	void *vaddr;
+	int i;
+
+	if (!pfns)
+		return NULL;
+
+	for (i = 0; i < size / PAGE_SIZE; i++)
+		pfns[i] = virt_to_hvpfn(addr + i * PAGE_SIZE) +
+			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
+
+	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, PAGE_KERNEL_IO);
+	kfree(pfns);
+
+	return vaddr;
+}
+
+void hv_unmap_memory(void *addr)
+{
+	vunmap(addr);
+}
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 7be173a99f27..3c5cb1f70319 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -295,3 +295,14 @@ u64 __weak hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_s
 	return HV_STATUS_INVALID_PARAMETER;
 }
 EXPORT_SYMBOL_GPL(hv_ghcb_hypercall);
+
+void __weak *hv_map_memory(void *addr, unsigned long size)
+{
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(hv_map_memory);
+
+void __weak hv_unmap_memory(void *addr)
+{
+}
+EXPORT_SYMBOL_GPL(hv_unmap_memory);
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 315278a7cf88..cf69da0e296c 100644
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
+	void *recv_original_buf;
 	u32 recv_buf_size; /* allocated bytes */
 	struct vmbus_gpadl recv_buf_gpadl_handle;
 	u32 recv_section_cnt;
@@ -1082,6 +1084,7 @@ struct netvsc_device {
 
 	/* Send buffer allocated by us */
 	void *send_buf;
+	void *send_original_buf;
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
index 396bc1c204e6..b7ade735a806 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -153,8 +153,21 @@ static void free_netvsc_device(struct rcu_head *head)
 	int i;
 
 	kfree(nvdev->extension);
-	vfree(nvdev->recv_buf);
-	vfree(nvdev->send_buf);
+
+	if (nvdev->recv_original_buf) {
+		hv_unmap_memory(nvdev->recv_buf);
+		vfree(nvdev->recv_original_buf);
+	} else {
+		vfree(nvdev->recv_buf);
+	}
+
+	if (nvdev->send_original_buf) {
+		hv_unmap_memory(nvdev->send_buf);
+		vfree(nvdev->send_original_buf);
+	} else {
+		vfree(nvdev->send_buf);
+	}
+
 	kfree(nvdev->send_section_map);
 
 	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
@@ -338,6 +351,7 @@ static int netvsc_init_buf(struct hv_device *device,
 	unsigned int buf_size;
 	size_t map_words;
 	int i, ret = 0;
+	void *vaddr;
 
 	/* Get receive buffer area. */
 	buf_size = device_info->recv_sections * device_info->recv_section_size;
@@ -373,6 +387,17 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
+	if (hv_isolation_type_snp()) {
+		vaddr = hv_map_memory(net_device->recv_buf, buf_size);
+		if (!vaddr) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+
+		net_device->recv_original_buf = net_device->recv_buf;
+		net_device->recv_buf = vaddr;
+	}
+
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -476,6 +501,17 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
+	if (hv_isolation_type_snp()) {
+		vaddr = hv_map_memory(net_device->send_buf, buf_size);
+		if (!vaddr) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+
+		net_device->send_original_buf = net_device->send_buf;
+		net_device->send_buf = vaddr;
+	}
+
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -766,7 +802,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 
 	/* Notify the layer above us */
 	if (likely(skb)) {
-		const struct hv_netvsc_packet *packet
+		struct hv_netvsc_packet *packet
 			= (struct hv_netvsc_packet *)skb->cb;
 		u32 send_index = packet->send_buf_index;
 		struct netvsc_stats *tx_stats;
@@ -782,6 +818,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 		tx_stats->bytes += packet->total_bytes;
 		u64_stats_update_end(&tx_stats->syncp);
 
+		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
 		napi_consume_skb(skb, budget);
 	}
 
@@ -946,6 +983,88 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
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
+int netvsc_dma_map(struct hv_device *hv_dev,
+		   struct hv_netvsc_packet *packet,
+		   struct hv_page_buffer *pb)
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
+		/* pb[].offset and pb[].len are not changed during dma mapping
+		 * and so not reassign.
+		 */
+		packet->dma_range[i].dma = dma;
+		packet->dma_range[i].mapping_size = len;
+		pb[i].pfn = dma >> HV_HYP_PAGE_SHIFT;
+	}
+
+	return 0;
+}
+
 static inline int netvsc_send_pkt(
 	struct hv_device *device,
 	struct hv_netvsc_packet *packet,
@@ -986,14 +1105,24 @@ static inline int netvsc_send_pkt(
 
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
@@ -1001,6 +1130,7 @@ static inline int netvsc_send_pkt(
 				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	}
 
+exit:
 	if (ret == 0) {
 		atomic_inc_return(&nvchan->queue_sends);
 
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 7e66ae1d2a59..17958533bf30 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2512,6 +2512,7 @@ static int netvsc_probe(struct hv_device *dev,
 	net->netdev_ops = &device_ops;
 	net->ethtool_ops = &ethtool_ops;
 	SET_NETDEV_DEV(net, &dev->device);
+	dma_set_min_align_mask(&dev->device, HV_HYP_PAGE_SIZE - 1);
 
 	/* We always need headroom for rndis header */
 	net->needed_headroom = RNDIS_AND_PPI_SIZE;
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
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index 3e2248ac328e..94e73ba129c5 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -269,6 +269,8 @@ bool hv_isolation_type_snp(void);
 u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_size);
 void hyperv_cleanup(void);
 bool hv_query_ext_cap(u64 cap_query);
+void *hv_map_memory(void *addr, unsigned long size);
+void hv_unmap_memory(void *addr);
 #else /* CONFIG_HYPERV */
 static inline bool hv_is_hyperv_initialized(void) { return false; }
 static inline bool hv_is_hibernation_supported(void) { return false; }
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 74f5e92f91a0..b53cfc4163af 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1584,6 +1584,11 @@ struct hyperv_service_callback {
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

