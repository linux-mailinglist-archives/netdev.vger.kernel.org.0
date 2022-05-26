Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2E9534EBF
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242513AbiEZMB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238595AbiEZMBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:01:21 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4506A13F58;
        Thu, 26 May 2022 05:01:20 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id i1so1255306plg.7;
        Thu, 26 May 2022 05:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=llU3KuLScL36j/qfF0yMfK2H7onIq45eIkuWwZeaf1M=;
        b=TENe2WjuFNHgLCi7bN1bsNg8qRWszxGGqpwzeL8vDgaK4LdRf3KrWK5a06AS/YipXR
         RTBfPt1K2apJU/J2RlnyW/v6ApcvyemaCcNjp8wFMLTetdrp9NdC2F7esgWmm/gtVODc
         LtSmkrIr1krrvlHknq2OzPOlQpcmpwtKt0zdS30FdClJ4nCVQJQlJvZDgw59gD/1ey0/
         Gg9QpnufvconYfOw27ArRonRicOI9E8AN4EUcqLZfp9cMsGLCrWKx1X/hDeNJpw6wxBK
         18VObXxHPNZ4XvHT82LfFzie2h1GTzyrXDAT/GB75UW440SNl7tvVio4b54MBvFdgJBb
         G5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=llU3KuLScL36j/qfF0yMfK2H7onIq45eIkuWwZeaf1M=;
        b=nZUzzuvK5XGcpKf7s/Wiun8WQ3FNVA6e96Mso8wuQ9hDCDifpEThSLfH+394lbqZkc
         cN358igPNeFjO9QXycFbE6fmmF3elZRvvMMl079Kdb1rmirc8WvSkIySb3dZ7mPIMek7
         BCaCHz83Xfz1WNsLFd6WIDTcTl+Qf0fE3/Uwerl0pFT7MfOts1xp9ZWV+1nUfB/loDst
         bRwq9hBvW8eHVqImyJp0WLHpcn9HcP2crHMv2XZSSymMVUyugE3mOEkf1/HCPZLVMaez
         eu/BCH4atIwOsArRSzBCMsSbN0jtdHN9zWp53TsdjGlUGtvmhvh4KyrrrQfu+t9fyQNx
         JoHQ==
X-Gm-Message-State: AOAM532tsDPAw98dRvNtgjW9Q80ammyPnLYYshsUm+pcoYddoNEBCj6q
        J1OytxjsMly341sly5Tqi38=
X-Google-Smtp-Source: ABdhPJx2nCbXug27Q54ozesPg5QXJyJ6L4SG9evwPc6UTmRpte/tbGu84UTUTzwl0ekU98B7uYxlRA==
X-Received: by 2002:a17:90b:1e0e:b0:1e0:17fb:6405 with SMTP id pg14-20020a17090b1e0e00b001e017fb6405mr2293220pjb.191.1653566479736;
        Thu, 26 May 2022 05:01:19 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:1:45c7:d5e2:7b45:3336])
        by smtp.gmail.com with ESMTPSA id bi7-20020a170902bf0700b0015e8d4eb282sm1328190plb.204.2022.05.26.05.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 05:01:19 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        parri.andrea@gmail.com, thomas.lendacky@amd.com,
        andi.kleen@intel.com, kirill.shutemov@intel.com
Subject: [RFC PATCH V3 1/2] swiotlb: Add Child IO TLB mem support
Date:   Thu, 26 May 2022 08:01:11 -0400
Message-Id: <20220526120113.971512-2-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220526120113.971512-1-ltykernel@gmail.com>
References: <20220526120113.971512-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Traditionally swiotlb was not performance critical because it was only
used for slow devices. But in some setups, like TDX/SEV confidential
guests, all IO has to go through swiotlb. Currently swiotlb only has a
single lock. Under high IO load with multiple CPUs this can lead to
significant lock contention on the swiotlb lock.

This patch adds child IO TLB mem support to resolve spinlock overhead
among device's queues. Each device may allocate IO tlb mem and setup
child IO TLB mem according to queue number. Swiotlb code allocates
bounce buffer among child IO tlb mem iterately.

Introduce IO TLB Block unit(2MB) concepts to allocate big bounce buffer
from default pool for devices. IO TLB segment(256k) is too small for
device bounce buffer.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 include/linux/swiotlb.h |  38 +++++
 kernel/dma/swiotlb.c    | 304 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 329 insertions(+), 13 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 7ed35dd3de6e..a48a9d64e3c3 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -31,6 +31,14 @@ struct scatterlist;
 #define IO_TLB_SHIFT 11
 #define IO_TLB_SIZE (1 << IO_TLB_SHIFT)
 
+/*
+ * IO TLB BLOCK UNIT as device bounce buffer allocation unit.
+ * This allows device allocates bounce buffer from default io
+ * tlb pool.
+ */
+#define IO_TLB_BLOCKSIZE   (8 * IO_TLB_SEGSIZE)
+#define IO_TLB_BLOCK_UNIT  (IO_TLB_BLOCKSIZE << IO_TLB_SHIFT)
+
 /* default to 64MB */
 #define IO_TLB_DEFAULT_SIZE (64UL<<20)
 
@@ -89,6 +97,11 @@ extern enum swiotlb_force swiotlb_force;
  * @late_alloc:	%true if allocated using the page allocator
  * @force_bounce: %true if swiotlb bouncing is forced
  * @for_alloc:  %true if the pool is used for memory allocation
+ * @num_child:  The child io tlb mem number in the pool.
+ * @child_nslot:The number of IO TLB slot in the child IO TLB mem.
+ * @child_nblock:The number of IO TLB block in the child IO TLB mem.
+ * @child_start:The child index to start searching in the next round.
+ * @block_start:The block index to start searching in the next round.
  */
 struct io_tlb_mem {
 	phys_addr_t start;
@@ -102,6 +115,16 @@ struct io_tlb_mem {
 	bool late_alloc;
 	bool force_bounce;
 	bool for_alloc;
+	unsigned int num_child;
+	unsigned int child_nslot;
+	unsigned int child_nblock;
+	unsigned int child_start;
+	unsigned int block_index;
+	struct io_tlb_mem *child;
+	struct io_tlb_mem *parent;
+	struct io_tlb_block {
+		unsigned int list;
+	} *block;
 	struct io_tlb_slot {
 		phys_addr_t orig_addr;
 		size_t alloc_size;
@@ -130,6 +153,10 @@ unsigned int swiotlb_max_segment(void);
 size_t swiotlb_max_mapping_size(struct device *dev);
 bool is_swiotlb_active(struct device *dev);
 void __init swiotlb_adjust_size(unsigned long size);
+int swiotlb_device_allocate(struct device *dev,
+			    unsigned int area_num,
+			    unsigned long size);
+void swiotlb_device_free(struct device *dev);
 #else
 static inline void swiotlb_init(bool addressing_limited, unsigned int flags)
 {
@@ -162,6 +189,17 @@ static inline bool is_swiotlb_active(struct device *dev)
 static inline void swiotlb_adjust_size(unsigned long size)
 {
 }
+
+void swiotlb_device_free(struct device *dev)
+{
+}
+
+int swiotlb_device_allocate(struct device *dev,
+			    unsigned int area_num,
+			    unsigned long size)
+{
+	return -ENOMEM;
+}
 #endif /* CONFIG_SWIOTLB */
 
 extern void swiotlb_print_info(void);
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index e2ef0864eb1e..7ca22a5a1886 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -195,7 +195,8 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 				    unsigned long nslabs, bool late_alloc)
 {
 	void *vaddr = phys_to_virt(start);
-	unsigned long bytes = nslabs << IO_TLB_SHIFT, i;
+	unsigned long bytes = nslabs << IO_TLB_SHIFT, i, j;
+	unsigned int block_num = nslabs / IO_TLB_BLOCKSIZE;
 
 	mem->nslabs = nslabs;
 	mem->start = start;
@@ -207,7 +208,36 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 		mem->force_bounce = true;
 
 	spin_lock_init(&mem->lock);
-	for (i = 0; i < mem->nslabs; i++) {
+
+	if (mem->num_child) {
+		mem->child_nslot = nslabs / mem->num_child;
+		mem->child_nblock = block_num / mem->num_child;
+		mem->child_start = 0;
+
+		/*
+		 * Initialize child IO TLB mem, divide IO TLB pool
+		 * into child number. Reuse parent mem->slot in the
+		 * child mem->slot.
+		 */
+		for (i = 0; i < mem->num_child; i++) {
+			mem->child[i].slots = mem->slots + i * mem->child_nslot;
+			mem->child[i].block = mem->block + i * mem->child_nblock;
+			mem->child[i].num_child = 0;
+
+			swiotlb_init_io_tlb_mem(&mem->child[i],
+				start + ((i * mem->child_nslot) << IO_TLB_SHIFT),
+				mem->child_nslot, late_alloc);
+		}
+
+		return;
+	}
+
+	for (i = 0, j = 0; i < mem->nslabs; i++) {
+		if (!(i % IO_TLB_BLOCKSIZE)) {
+			mem->block[j].list = block_num--;
+			j++;
+		}
+
 		mem->slots[i].list = IO_TLB_SEGSIZE - io_tlb_offset(i);
 		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
 		mem->slots[i].alloc_size = 0;
@@ -272,6 +302,13 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 		panic("%s: Failed to allocate %zu bytes align=0x%lx\n",
 		      __func__, alloc_size, PAGE_SIZE);
 
+	mem->num_child = 0;
+	mem->block = memblock_alloc(sizeof(struct io_tlb_block) *
+				    (default_nslabs / IO_TLB_BLOCKSIZE),
+				     SMP_CACHE_BYTES);
+	if (!mem->block)
+		panic("%s: Failed to allocate mem->block.\n", __func__);
+
 	swiotlb_init_io_tlb_mem(mem, __pa(tlb), default_nslabs, false);
 	mem->force_bounce = flags & SWIOTLB_FORCE;
 
@@ -296,7 +333,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 	unsigned long nslabs = ALIGN(size >> IO_TLB_SHIFT, IO_TLB_SEGSIZE);
 	unsigned long bytes;
 	unsigned char *vstart = NULL;
-	unsigned int order;
+	unsigned int order, block_order;
 	int rc = 0;
 
 	if (swiotlb_force_disable)
@@ -334,18 +371,29 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		goto retry;
 	}
 
+	block_order = get_order(array_size(sizeof(*mem->block),
+		nslabs / IO_TLB_BLOCKSIZE));
+	mem->block = (struct io_tlb_block *)
+		__get_free_pages(GFP_KERNEL | __GFP_ZERO, block_order);
+	if (!mem->block)
+		goto error_block;
+
 	mem->slots = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 		get_order(array_size(sizeof(*mem->slots), nslabs)));
-	if (!mem->slots) {
-		free_pages((unsigned long)vstart, order);
-		return -ENOMEM;
-	}
+	if (!mem->slots)
+		goto error_slots;
 
 	set_memory_decrypted((unsigned long)vstart, bytes >> PAGE_SHIFT);
 	swiotlb_init_io_tlb_mem(mem, virt_to_phys(vstart), nslabs, true);
 
 	swiotlb_print_info();
 	return 0;
+
+error_slots:
+	free_pages((unsigned long)mem->block, block_order);
+error_block:
+	free_pages((unsigned long)vstart, order);
+	return -ENOMEM;
 }
 
 void __init swiotlb_exit(void)
@@ -353,6 +401,7 @@ void __init swiotlb_exit(void)
 	struct io_tlb_mem *mem = &io_tlb_default_mem;
 	unsigned long tbl_vaddr;
 	size_t tbl_size, slots_size;
+	unsigned int block_array_size, block_order;
 
 	if (swiotlb_force_bounce)
 		return;
@@ -364,12 +413,16 @@ void __init swiotlb_exit(void)
 	tbl_vaddr = (unsigned long)phys_to_virt(mem->start);
 	tbl_size = PAGE_ALIGN(mem->end - mem->start);
 	slots_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), mem->nslabs));
+	block_array_size = array_size(sizeof(*mem->block), mem->nslabs / IO_TLB_BLOCKSIZE);
 
 	set_memory_encrypted(tbl_vaddr, tbl_size >> PAGE_SHIFT);
 	if (mem->late_alloc) {
+		block_order = get_order(block_array_size);
+		free_pages((unsigned long)mem->block, block_order);
 		free_pages(tbl_vaddr, get_order(tbl_size));
 		free_pages((unsigned long)mem->slots, get_order(slots_size));
 	} else {
+		memblock_free_late(__pa(mem->block), block_array_size);
 		memblock_free_late(mem->start, tbl_size);
 		memblock_free_late(__pa(mem->slots), slots_size);
 	}
@@ -483,10 +536,11 @@ static unsigned int wrap_index(struct io_tlb_mem *mem, unsigned int index)
  * Find a suitable number of IO TLB entries size that will fit this request and
  * allocate a buffer from that IO TLB pool.
  */
-static int swiotlb_find_slots(struct device *dev, phys_addr_t orig_addr,
-			      size_t alloc_size, unsigned int alloc_align_mask)
+static int swiotlb_do_find_slots(struct io_tlb_mem *mem,
+				 struct device *dev, phys_addr_t orig_addr,
+				 size_t alloc_size,
+				 unsigned int alloc_align_mask)
 {
-	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 	unsigned long boundary_mask = dma_get_seg_boundary(dev);
 	dma_addr_t tbl_dma_addr =
 		phys_to_dma_unencrypted(dev, mem->start) & boundary_mask;
@@ -546,6 +600,9 @@ static int swiotlb_find_slots(struct device *dev, phys_addr_t orig_addr,
 		mem->slots[i].list = 0;
 		mem->slots[i].alloc_size =
 			alloc_size - (offset + ((i - index) << IO_TLB_SHIFT));
+
+		if (!(index % IO_TLB_BLOCKSIZE))
+			mem->block[index / IO_TLB_BLOCKSIZE].list = 0;
 	}
 	for (i = index - 1;
 	     io_tlb_offset(i) != IO_TLB_SEGSIZE - 1 &&
@@ -565,6 +622,47 @@ static int swiotlb_find_slots(struct device *dev, phys_addr_t orig_addr,
 	return index;
 }
 
+static int swiotlb_find_slots(struct device *dev, phys_addr_t orig_addr,
+			      size_t alloc_size, unsigned int alloc_align_mask)
+{
+	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
+	struct io_tlb_mem *target_mem = mem;
+	int start = 0, i = 0, index;
+
+	if (mem->num_child) {
+		i = start = mem->child_start;
+		mem->child_start = (mem->child_start + 1) % mem->num_child;
+
+		target_mem = mem->child;
+	}
+
+	do {
+		index = swiotlb_do_find_slots(target_mem + i, dev, orig_addr,
+					      alloc_size, alloc_align_mask);
+		if (index >= 0)
+			return i * mem->child_nslot + index;
+		if (++i >= mem->num_child)
+			i = 0;
+	} while (i != start);
+
+	return -1;
+}
+
+static unsigned long mem_used(struct io_tlb_mem *mem)
+{
+	int i;
+	unsigned long used = 0;
+
+	if (mem->num_child) {
+		for (i = 0; i < mem->num_child; i++)
+			used += mem->child[i].used;
+	} else {
+		used = mem->used;
+	}
+
+	return used;
+}
+
 phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 		size_t mapping_size, size_t alloc_size,
 		unsigned int alloc_align_mask, enum dma_data_direction dir,
@@ -594,7 +692,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 		if (!(attrs & DMA_ATTR_NO_WARN))
 			dev_warn_ratelimited(dev,
 	"swiotlb buffer is full (sz: %zd bytes), total %lu (slots), used %lu (slots)\n",
-				 alloc_size, mem->nslabs, mem->used);
+				     alloc_size, mem->nslabs, mem_used(mem));
 		return (phys_addr_t)DMA_MAPPING_ERROR;
 	}
 
@@ -617,9 +715,9 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 	return tlb_addr;
 }
 
-static void swiotlb_release_slots(struct device *dev, phys_addr_t tlb_addr)
+static void swiotlb_do_release_slots(struct io_tlb_mem *mem,
+				     struct device *dev, phys_addr_t tlb_addr)
 {
-	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 	unsigned long flags;
 	unsigned int offset = swiotlb_align_offset(dev, tlb_addr);
 	int index = (tlb_addr - offset - mem->start) >> IO_TLB_SHIFT;
@@ -660,6 +758,20 @@ static void swiotlb_release_slots(struct device *dev, phys_addr_t tlb_addr)
 	spin_unlock_irqrestore(&mem->lock, flags);
 }
 
+static void swiotlb_release_slots(struct device *dev, phys_addr_t tlb_addr)
+{
+	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
+	int index, offset;
+
+	if (mem->num_child) {
+		offset = swiotlb_align_offset(dev, tlb_addr);
+		index = (tlb_addr - offset - mem->start) >> IO_TLB_SHIFT;
+		mem = &mem->child[index / mem->child_nslot];
+	}
+
+	swiotlb_do_release_slots(mem, dev, tlb_addr);
+}
+
 /*
  * tlb_addr is the physical address of the bounce buffer to unmap.
  */
@@ -762,6 +874,172 @@ static int __init __maybe_unused swiotlb_create_default_debugfs(void)
 late_initcall(swiotlb_create_default_debugfs);
 #endif
 
+static void swiotlb_do_free_block(struct io_tlb_mem *mem,
+		phys_addr_t start, unsigned int block_num)
+{
+
+	unsigned int start_slot = (start - mem->start) >> IO_TLB_SHIFT;
+	unsigned int block_index = start_slot / IO_TLB_BLOCKSIZE;
+	unsigned int mem_block_num = mem->nslabs / IO_TLB_BLOCKSIZE;
+	unsigned int nslot;
+	unsigned long flags;
+	int count, i, num, j;
+
+	spin_lock_irqsave(&mem->lock, flags);
+	if (block_index + block_num < mem_block_num)
+		count = mem->block[block_index + mem_block_num].list;
+	else
+		count = 0;
+
+	for (i = block_index + block_num; i >= block_index; i--) {
+		mem->block[i].list = ++count;
+
+		for (j = 0; j < IO_TLB_BLOCKSIZE; j++) {
+			nslot = i * IO_TLB_BLOCKSIZE + j;
+			mem->slots[nslot].list = IO_TLB_SEGSIZE - io_tlb_offset(i);
+			mem->slots[nslot].orig_addr = INVALID_PHYS_ADDR;
+			mem->slots[nslot].alloc_size = 0;
+		}
+	}
+
+	for (i = block_index - 1, num = block_index % mem_block_num;
+	    i < num && mem->block[i].list; i--)
+		mem->block[i].list = ++count;
+
+	spin_unlock_irqrestore(&mem->lock, flags);
+}
+
+static void swiotlb_free_block(struct io_tlb_mem *mem,
+			       phys_addr_t start, unsigned int block_num)
+{
+	unsigned int slot_index, child_index;
+
+	if (mem->num_child) {
+		slot_index = (start - mem->start) >> IO_TLB_SHIFT;
+		child_index = slot_index / mem->child_nslot;
+
+		swiotlb_do_free_block(&mem->child[child_index],
+				      start, block_num);
+	} else {
+		swiotlb_do_free_block(mem, start, block_num);
+	}
+}
+
+void swiotlb_device_free(struct device *dev)
+{
+	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
+	struct io_tlb_mem *parent_mem = dev->dma_io_tlb_mem->parent;
+
+	swiotlb_free_block(parent_mem, mem->start, mem->nslabs / IO_TLB_BLOCKSIZE);
+}
+
+
+static struct page *swiotlb_alloc_block(struct io_tlb_mem *mem, unsigned int block_num)
+{
+	unsigned int mem_block_num = mem->nslabs /  IO_TLB_BLOCKSIZE;
+	unsigned int block_index, nslot;
+	phys_addr_t tlb_addr;
+	unsigned long flags;
+	int i, j;
+
+	if (!mem || !mem->block)
+		return NULL;
+
+	spin_lock_irqsave(&mem->lock, flags);
+
+	/* Todo: Search more blocks via wrapping block array. */
+	for (block_index = mem->block_index;
+	     block_index < mem_block_num; block_index++)
+		if (mem->block[block_index].list > block_num)
+			break;
+
+	if (block_index == mem_block_num) {
+		spin_unlock_irqrestore(&mem->lock, flags);
+		return NULL;
+	}
+
+	/* Update block and slot list. */
+	for (i = block_index; i < block_index + block_num; i++) {
+		mem->block[i].list = 0;
+
+		for (j = 0; j < IO_TLB_BLOCKSIZE; j++) {
+			nslot = i * IO_TLB_BLOCKSIZE + j;
+			mem->slots[nslot].list = 0;
+			mem->slots[nslot].alloc_size = IO_TLB_SIZE;
+		}
+	}
+
+	mem->index = nslot + 1;
+	mem->block_index += block_num;
+	mem->used += block_num * IO_TLB_BLOCKSIZE;
+	spin_unlock_irqrestore(&mem->lock, flags);
+
+	tlb_addr = slot_addr(mem->start, block_index * IO_TLB_BLOCKSIZE);
+	return pfn_to_page(PFN_DOWN(tlb_addr));
+}
+
+/*
+ * swiotlb_device_allocate - Allocate bounce buffer fo device from
+ * default io tlb pool. The allocation size should be aligned with
+ * IO_TLB_BLOCK_UNIT.
+ */
+int swiotlb_device_allocate(struct device *dev,
+			    unsigned int queue_num,
+			    unsigned long size)
+{
+	struct io_tlb_mem *mem, *parent_mem = dev->dma_io_tlb_mem;
+	unsigned long nslabs = ALIGN(size >> IO_TLB_SHIFT, IO_TLB_BLOCKSIZE);
+	struct page *page;
+	int ret = -ENOMEM;
+
+	page = swiotlb_alloc_block(parent_mem, nslabs / IO_TLB_BLOCKSIZE);
+	if (!page)
+		return -ENOMEM;
+
+	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+	if (!mem)
+		goto error_mem;
+
+	mem->slots = kzalloc(array_size(sizeof(*mem->slots), nslabs),
+			     GFP_KERNEL);
+	if (!mem->slots)
+		goto error_slots;
+
+	mem->block = kcalloc(nslabs / IO_TLB_BLOCKSIZE,
+				sizeof(struct io_tlb_block),
+				GFP_KERNEL);
+	if (!mem->block)
+		goto error_block;
+
+	mem->num_child = queue_num;
+	mem->child = kcalloc(queue_num,
+				sizeof(struct io_tlb_mem),
+				GFP_KERNEL);
+	if (!mem->child)
+		goto error_child;
+
+
+	swiotlb_init_io_tlb_mem(mem, page_to_phys(page), nslabs, true);
+	mem->force_bounce = true;
+	mem->for_alloc = true;
+
+	mem->vaddr = parent_mem->vaddr + page_to_phys(page) -  parent_mem->start;
+	dev->dma_io_tlb_mem->parent = parent_mem;
+	dev->dma_io_tlb_mem = mem;
+	return 0;
+
+error_child:
+	kfree(mem->block);
+error_block:
+	kfree(mem->slots);
+error_slots:
+	kfree(mem);
+error_mem:
+	swiotlb_free_block(mem, page_to_phys(page), nslabs / IO_TLB_BLOCKSIZE);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(swiotlb_device_allocate);
+
 #ifdef CONFIG_DMA_RESTRICTED_POOL
 
 struct page *swiotlb_alloc(struct device *dev, size_t size)
-- 
2.25.1

