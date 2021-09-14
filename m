Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1751340AF64
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhINNmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhINNlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 09:41:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEB0C0613E9;
        Tue, 14 Sep 2021 06:39:54 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso2810178pjq.4;
        Tue, 14 Sep 2021 06:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LkmXj6KxjUvBaz8z0a8dNOFjY1uabCCopAH/jkVX7K0=;
        b=H0oAe82GjXdTdE+tPELa3975j1MGt/XfBwybJVWm9rXqcL3sZBlP4N3dVxqejuMmCR
         fTxH2exCC64AO/wTOZvdNd7kolrZ/irkjYbpTtFRFS52HpEJiYpKx7tvDB22KmzcCOv7
         c9DS1KJW86b06AqUV3XvHCJsPD24m0nR2St4Gm7JJGLUJisEPWa/XBbIzSmSmqfr13m7
         8k2iUw5lq4EvEwGop+B0nMUmtEgs3N2LwGcdbL1UtdAgaL9kn7ZyWDVSGWcSLQCnunTP
         f35mOoI/LXthKpV4WOGUGrXrLzkkUj0AyvgnRnOwf8rvVBG3C6mESM16QWBrymuP71V7
         1ddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LkmXj6KxjUvBaz8z0a8dNOFjY1uabCCopAH/jkVX7K0=;
        b=kkLFztWpROjBUfEV3KQb/pQVy6VjuZuBsg/UgdPVCqfTqLpCUDth0yXK9NBqZOphlm
         +a7e/LH0t1bfxAHMtnHimgvd6y+7D1UmKyRaV/jAVMsgZln1s97B3zzUcLvZ6nu6enDE
         r86A4yuOYvYk0EAQjVVSunslVs9CTQrh/iYxNX92kLCpZVPTbi42J988hHfa8rfAPe1G
         KKSB3sByrlLckX6hX0q7ShEKohM6xvqr/GWBksIhOpuiCyuM5LJOwJXtqpwN46o3bIwx
         8HUpWz/y8tYt0ND0sijnMQrZB7jkmoVx4YRIy/lehw/b2rKQTOrYR/YuBOigE88zp6bC
         e4sQ==
X-Gm-Message-State: AOAM531hq1CW5e1+xoHP4BYZy9iuTX/YB4IhT636Kc26LCEwlitgP/7J
        WP6EQOhT8TaZcS+wmxpErxA=
X-Google-Smtp-Source: ABdhPJzd50JbAXqZtpTD7xpue98Virh8fDhY7VdwfyRuohNOtMS2fLTQ6Ka6cqdkhWO9Ql38QPYNrQ==
X-Received: by 2002:a17:902:da89:b0:13b:7d3d:59e9 with SMTP id j9-20020a170902da8900b0013b7d3d59e9mr14413893plx.41.1631626794081;
        Tue, 14 Sep 2021 06:39:54 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:7:6ea2:a529:4af3:5057])
        by smtp.gmail.com with ESMTPSA id v13sm10461234pfm.16.2021.09.14.06.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:39:53 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, sfr@canb.auug.org.au, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, krish.sadhukhan@oracle.com,
        xen-devel@lists.xenproject.org, tj@kernel.org, rientjes@google.com,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for netvsc driver
Date:   Tue, 14 Sep 2021 09:39:13 -0400
Message-Id: <20210914133916.1440931-13-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914133916.1440931-1-ltykernel@gmail.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
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

Allocate rx/tx ring buffer via alloc_pages() in Isolation VM and map
these pages via vmap(). After calling vmbus_establish_gpadl() which
marks these pages visible to host, unmap these pages to release the
virtual address mapped with physical address below shared_gpa_boundary
and map them in the extra address space via vmap_pfn().

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v4:
	* Allocate rx/tx ring buffer via alloc_pages() in Isolation VM
	* Map pages after calling vmbus_establish_gpadl().
	* set dma_set_min_align_mask for netvsc driver.

Change since v3:
	* Add comment to explain why not to use dma_map_sg()
	* Fix some error handle.
---
 drivers/net/hyperv/hyperv_net.h   |   7 +
 drivers/net/hyperv/netvsc.c       | 287 +++++++++++++++++++++++++++++-
 drivers/net/hyperv/netvsc_drv.c   |   1 +
 drivers/net/hyperv/rndis_filter.c |   2 +
 include/linux/hyperv.h            |   5 +
 5 files changed, 296 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 315278a7cf88..87e8c74398a5 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -164,6 +164,7 @@ struct hv_netvsc_packet {
 	u32 total_bytes;
 	u32 send_buf_index;
 	u32 total_data_buflen;
+	struct hv_dma_range *dma_range;
 };
 
 #define NETVSC_HASH_KEYLEN 40
@@ -1074,6 +1075,8 @@ struct netvsc_device {
 
 	/* Receive buffer allocated by us but manages by NetVSP */
 	void *recv_buf;
+	struct page **recv_pages;
+	u32 recv_page_count;
 	u32 recv_buf_size; /* allocated bytes */
 	struct vmbus_gpadl recv_buf_gpadl_handle;
 	u32 recv_section_cnt;
@@ -1082,6 +1085,8 @@ struct netvsc_device {
 
 	/* Send buffer allocated by us */
 	void *send_buf;
+	struct page **send_pages;
+	u32 send_page_count;
 	u32 send_buf_size;
 	struct vmbus_gpadl send_buf_gpadl_handle;
 	u32 send_section_cnt;
@@ -1731,4 +1736,6 @@ struct rndis_message {
 #define RETRY_US_HI	10000
 #define RETRY_MAX	2000	/* >10 sec */
 
+void netvsc_dma_unmap(struct hv_device *hv_dev,
+		      struct hv_netvsc_packet *packet);
 #endif /* _HYPERV_NET_H */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 1f87e570ed2b..7d5254bf043e 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/rtnetlink.h>
 #include <linux/prefetch.h>
+#include <linux/gfp.h>
 
 #include <asm/sync_bitops.h>
 #include <asm/mshyperv.h>
@@ -150,11 +151,33 @@ static void free_netvsc_device(struct rcu_head *head)
 {
 	struct netvsc_device *nvdev
 		= container_of(head, struct netvsc_device, rcu);
+	unsigned int alloc_unit;
 	int i;
 
 	kfree(nvdev->extension);
-	vfree(nvdev->recv_buf);
-	vfree(nvdev->send_buf);
+
+	if (nvdev->recv_pages) {
+		alloc_unit = (nvdev->recv_buf_size /
+			nvdev->recv_page_count) >> PAGE_SHIFT;
+
+		vunmap(nvdev->recv_buf);
+		for (i = 0; i < nvdev->recv_page_count; i++)
+			__free_pages(nvdev->recv_pages[i], alloc_unit);
+	} else {
+		vfree(nvdev->recv_buf);
+	}
+
+	if (nvdev->send_pages) {
+		alloc_unit = (nvdev->send_buf_size /
+			nvdev->send_page_count) >> PAGE_SHIFT;
+
+		vunmap(nvdev->send_buf);
+		for (i = 0; i < nvdev->send_page_count; i++)
+			__free_pages(nvdev->send_pages[i], alloc_unit);
+	} else {
+		vfree(nvdev->send_buf);
+	}
+
 	kfree(nvdev->send_section_map);
 
 	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
@@ -330,6 +353,108 @@ int netvsc_alloc_recv_comp_ring(struct netvsc_device *net_device, u32 q_idx)
 	return nvchan->mrc.slots ? 0 : -ENOMEM;
 }
 
+void *netvsc_alloc_pages(struct page ***pages_array, unsigned int *array_len,
+			 unsigned long size)
+{
+	struct page *page, **pages, **vmap_pages;
+	unsigned long pg_count = size >> PAGE_SHIFT;
+	int alloc_unit = MAX_ORDER_NR_PAGES;
+	int i, j, vmap_page_index = 0;
+	void *vaddr;
+
+	if (pg_count < alloc_unit)
+		alloc_unit = 1;
+
+	/* vmap() accepts page array with PAGE_SIZE as unit while try to
+	 * allocate high order pages here in order to save page array space.
+	 * vmap_pages[] is used as input parameter of vmap(). pages[] is to
+	 * store allocated pages and map them later.
+	 */
+	vmap_pages = kmalloc_array(pg_count, sizeof(*vmap_pages), GFP_KERNEL);
+	if (!vmap_pages)
+		return NULL;
+
+retry:
+	*array_len = pg_count / alloc_unit;
+	pages = kmalloc_array(*array_len, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		goto cleanup;
+
+	for (i = 0; i < *array_len; i++) {
+		page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+				   get_order(alloc_unit << PAGE_SHIFT));
+		if (!page) {
+			/* Try allocating small pages if high order pages are not available. */
+			if (alloc_unit == 1) {
+				goto cleanup;
+			} else {
+				memset(vmap_pages, 0,
+				       sizeof(*vmap_pages) * vmap_page_index);
+				vmap_page_index = 0;
+
+				for (j = 0; j < i; j++)
+					__free_pages(pages[j], alloc_unit);
+
+				kfree(pages);
+				alloc_unit = 1;
+				goto retry;
+			}
+		}
+
+		pages[i] = page;
+		for (j = 0; j < alloc_unit; j++)
+			vmap_pages[vmap_page_index++] = page++;
+	}
+
+	vaddr = vmap(vmap_pages, vmap_page_index, VM_MAP, PAGE_KERNEL);
+	kfree(vmap_pages);
+
+	*pages_array = pages;
+	return vaddr;
+
+cleanup:
+	for (j = 0; j < i; j++)
+		__free_pages(pages[i], alloc_unit);
+
+	kfree(pages);
+	kfree(vmap_pages);
+	return NULL;
+}
+
+static void *netvsc_map_pages(struct page **pages, int count, int alloc_unit)
+{
+	int pg_count = count * alloc_unit;
+	struct page *page;
+	unsigned long *pfns;
+	int pfn_index = 0;
+	void *vaddr;
+	int i, j;
+
+	if (!pages)
+		return NULL;
+
+	pfns = kcalloc(pg_count, sizeof(*pfns), GFP_KERNEL);
+	if (!pfns)
+		return NULL;
+
+	for (i = 0; i < count; i++) {
+		page = pages[i];
+		if (!page) {
+			pr_warn("page is not available %d.\n", i);
+			return NULL;
+		}
+
+		for (j = 0; j < alloc_unit; j++) {
+			pfns[pfn_index++] = page_to_pfn(page++) +
+				(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
+		}
+	}
+
+	vaddr = vmap_pfn(pfns, pg_count, PAGE_KERNEL_IO);
+	kfree(pfns);
+	return vaddr;
+}
+
 static int netvsc_init_buf(struct hv_device *device,
 			   struct netvsc_device *net_device,
 			   const struct netvsc_device_info *device_info)
@@ -337,7 +462,7 @@ static int netvsc_init_buf(struct hv_device *device,
 	struct nvsp_1_message_send_receive_buffer_complete *resp;
 	struct net_device *ndev = hv_get_drvdata(device);
 	struct nvsp_message *init_packet;
-	unsigned int buf_size;
+	unsigned int buf_size, alloc_unit;
 	size_t map_words;
 	int i, ret = 0;
 
@@ -350,7 +475,14 @@ static int netvsc_init_buf(struct hv_device *device,
 		buf_size = min_t(unsigned int, buf_size,
 				 NETVSC_RECEIVE_BUFFER_SIZE_LEGACY);
 
-	net_device->recv_buf = vzalloc(buf_size);
+	if (hv_isolation_type_snp())
+		net_device->recv_buf =
+			netvsc_alloc_pages(&net_device->recv_pages,
+					   &net_device->recv_page_count,
+					   buf_size);
+	else
+		net_device->recv_buf = vzalloc(buf_size);
+
 	if (!net_device->recv_buf) {
 		netdev_err(ndev,
 			   "unable to allocate receive buffer of size %u\n",
@@ -375,6 +507,27 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
+	if (hv_isolation_type_snp()) {
+		alloc_unit = (buf_size / net_device->recv_page_count)
+				>> PAGE_SHIFT;
+
+		/* Unmap previous virtual address and map pages in the extra
+		 * address space(above shared gpa boundary) in Isolation VM.
+		 */
+		vunmap(net_device->recv_buf);
+		net_device->recv_buf =
+			netvsc_map_pages(net_device->recv_pages,
+					 net_device->recv_page_count,
+					 alloc_unit);
+		if (!net_device->recv_buf) {
+			netdev_err(ndev,
+				   "unable to allocate receive buffer of size %u\n",
+				   buf_size);
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+	}
+
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -456,13 +609,21 @@ static int netvsc_init_buf(struct hv_device *device,
 	buf_size = device_info->send_sections * device_info->send_section_size;
 	buf_size = round_up(buf_size, PAGE_SIZE);
 
-	net_device->send_buf = vzalloc(buf_size);
+	if (hv_isolation_type_snp())
+		net_device->send_buf =
+			netvsc_alloc_pages(&net_device->send_pages,
+					   &net_device->send_page_count,
+					   buf_size);
+	else
+		net_device->send_buf = vzalloc(buf_size);
+
 	if (!net_device->send_buf) {
 		netdev_err(ndev, "unable to allocate send buffer of size %u\n",
 			   buf_size);
 		ret = -ENOMEM;
 		goto cleanup;
 	}
+
 	net_device->send_buf_size = buf_size;
 
 	/* Establish the gpadl handle for this buffer on this
@@ -478,6 +639,27 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
+	if (hv_isolation_type_snp()) {
+		alloc_unit = (buf_size / net_device->send_page_count)
+				>> PAGE_SHIFT;
+
+		/* Unmap previous virtual address and map pages in the extra
+		 * address space(above shared gpa boundary) in Isolation VM.
+		 */
+		vunmap(net_device->send_buf);
+		net_device->send_buf =
+			netvsc_map_pages(net_device->send_pages,
+					 net_device->send_page_count,
+					 alloc_unit);
+		if (!net_device->send_buf) {
+			netdev_err(ndev,
+				   "unable to allocate receive buffer of size %u\n",
+				   buf_size);
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+	}
+
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -768,7 +950,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 
 	/* Notify the layer above us */
 	if (likely(skb)) {
-		const struct hv_netvsc_packet *packet
+		struct hv_netvsc_packet *packet
 			= (struct hv_netvsc_packet *)skb->cb;
 		u32 send_index = packet->send_buf_index;
 		struct netvsc_stats *tx_stats;
@@ -784,6 +966,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 		tx_stats->bytes += packet->total_bytes;
 		u64_stats_update_end(&tx_stats->syncp);
 
+		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
 		napi_consume_skb(skb, budget);
 	}
 
@@ -948,6 +1131,87 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
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
@@ -988,14 +1252,24 @@ static inline int netvsc_send_pkt(
 
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
@@ -1003,6 +1277,7 @@ static inline int netvsc_send_pkt(
 				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	}
 
+exit:
 	if (ret == 0) {
 		atomic_inc_return(&nvchan->queue_sends);
 
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 382bebc2420d..c3dc884b31e3 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2577,6 +2577,7 @@ static int netvsc_probe(struct hv_device *dev,
 	list_add(&net_device_ctx->list, &netvsc_dev_list);
 	rtnl_unlock();
 
+	dma_set_min_align_mask(&dev->device, HV_HYP_PAGE_SIZE - 1);
 	netvsc_devinfo_put(device_info);
 	return 0;
 
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
index c94c534a944e..81e58dd582dc 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1597,6 +1597,11 @@ struct hyperv_service_callback {
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

