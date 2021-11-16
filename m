Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5580C4535FF
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238398AbhKPPmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238382AbhKPPmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 10:42:33 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF051C061746;
        Tue, 16 Nov 2021 07:39:35 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id r23so2082456pgu.13;
        Tue, 16 Nov 2021 07:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A871xRYimWpuymqSDqhiZkbRS8n6nHIMpIOunv30ysw=;
        b=MfZeD4SICRk2M6gRj1QxEYd4A8GvB/tRH7apw5VqkE/bVG+e8yrO8ijV4aIzjOYHCC
         lQaASY53qGtDAM8wVSmTdWy3cvr1fvftCXOr1EfkVi6q9+ynxxKdWVTFAB9VaO2TfYRR
         tfbCajFfMAXlVqh3Ee2e0v9R0QcUDnq2f75xm0EEX761w/daoZNmHuD6pTxtXrJk+zhI
         AuO4Y0S1MvttNc6duCjVc1isZ8WPRdME3vdYmZuaOWojOYPqotm4HvFO/DdtAUnehn/u
         imITBVFlmiur1TnzAUd4yqml2N6tmP0mPVoeHVKo0W1d72FZEHoNJmiMrsvCB8TvjN82
         hWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A871xRYimWpuymqSDqhiZkbRS8n6nHIMpIOunv30ysw=;
        b=aSn2xwg3LA+Rv8MC40aAEB3ucNN+0M4LUIXEzNKnuj9+h5C2YQGNcBa9Tg+ccOCD+y
         ay0yYHEoVygV1t7fUt/rDdEwHhUipCRjM2WeJoIyDpi3B3pk4MOVo8EEGJwI3E9DRP+u
         b2sBVplU5zHlJ4AvQETNy5AciagxouLDe86qQ+ZeQeCI0OyBXINhKzG5eVT924zgNePy
         d44JoGlDvBz2ECPZmzO5pwFj7KsMMYmRR1xYjQfLbkwKVj6l54hN11zbI/1weE0i5f7G
         3nXepVlQYuOxdWxzuZ8kBw91JhbIk8ULHOoQaXaHE80EVxIkhn441uv1UCNGwFxHhPC6
         37xQ==
X-Gm-Message-State: AOAM533kqvvG7b/uXwaRPQyDYCBtZHKDqUAPhC2eaoipAlVYCwX1mWgm
        ry6RyIk2zV405X3m2M6Y5wo=
X-Google-Smtp-Source: ABdhPJyHY3AIAxxj2PlCrLjDoT50XcH+uS0J9YrXheMYn9wWskO9/XhyBYsqQ+PUuD81c8+MSeo8ig==
X-Received: by 2002:a62:2503:0:b0:4a2:b772:25ac with SMTP id l3-20020a622503000000b004a2b77225acmr17439529pfl.53.1637077170490;
        Tue, 16 Nov 2021 07:39:30 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:3:57e4:b776:c854:76dd])
        by smtp.gmail.com with ESMTPSA id x64sm1981948pfd.151.2021.11.16.07.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 07:39:29 -0800 (PST)
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
Subject: [PATCH 1/5] x86/Swiotlb: Add Swiotlb bounce buffer remap function for HV IVM
Date:   Tue, 16 Nov 2021 10:39:19 -0500
Message-Id: <20211116153923.196763-2-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116153923.196763-1-ltykernel@gmail.com>
References: <20211116153923.196763-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
extra address space which is above shared_gpa_boundary (E.G 39 bit
address line) reported by Hyper-V CPUID ISOLATION_CONFIG. The access
physical address will be original physical address + shared_gpa_boundary.
The shared_gpa_boundary in the AMD SEV SNP spec is called virtual top of
memory(vTOM). Memory addresses below vTOM are automatically treated as
private while memory above vTOM is treated as shared.

Expose swiotlb_unencrypted_base for platforms to set unencrypted
memory base offset and platform calls swiotlb_update_mem_attributes()
to remap swiotlb mem to unencrypted address space. memremap() can
not be called in the early stage and so put remapping code into
swiotlb_update_mem_attributes(). Store remap address and use it to copy
data from/to swiotlb bounce buffer.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 include/linux/swiotlb.h |  6 ++++
 kernel/dma/swiotlb.c    | 75 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 73 insertions(+), 8 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 569272871375..09a140d617fa 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -73,6 +73,9 @@ extern enum swiotlb_force swiotlb_force;
  * @end:	The end address of the swiotlb memory pool. Used to do a quick
  *		range check to see if the memory was in fact allocated by this
  *		API.
+ * @vaddr:	The vaddr of the swiotlb memory pool. The swiotlb
+ *		memory pool may be remapped in the memory encrypted case and store
+ *		virtual address for bounce buffer operation.
  * @nslabs:	The number of IO TLB blocks (in groups of 64) between @start and
  *		@end. For default swiotlb, this is command line adjustable via
  *		setup_io_tlb_npages.
@@ -92,6 +95,7 @@ extern enum swiotlb_force swiotlb_force;
 struct io_tlb_mem {
 	phys_addr_t start;
 	phys_addr_t end;
+	void *vaddr;
 	unsigned long nslabs;
 	unsigned long used;
 	unsigned int index;
@@ -186,4 +190,6 @@ static inline bool is_swiotlb_for_alloc(struct device *dev)
 }
 #endif /* CONFIG_DMA_RESTRICTED_POOL */
 
+extern phys_addr_t swiotlb_unencrypted_base;
+
 #endif /* __LINUX_SWIOTLB_H */
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 8e840fbbed7c..4735c5e0f44d 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -50,6 +50,7 @@
 #include <asm/io.h>
 #include <asm/dma.h>
 
+#include <linux/io.h>
 #include <linux/init.h>
 #include <linux/memblock.h>
 #include <linux/iommu-helper.h>
@@ -72,6 +73,8 @@ enum swiotlb_force swiotlb_force;
 
 struct io_tlb_mem io_tlb_default_mem;
 
+phys_addr_t swiotlb_unencrypted_base;
+
 /*
  * Max segment that we can provide which (if pages are contingous) will
  * not be bounced (unless SWIOTLB_FORCE is set).
@@ -155,6 +158,31 @@ static inline unsigned long nr_slots(u64 val)
 	return DIV_ROUND_UP(val, IO_TLB_SIZE);
 }
 
+/*
+ * Remap swioltb memory in the unencrypted physical address space
+ * when swiotlb_unencrypted_base is set. (e.g. for Hyper-V AMD SEV-SNP
+ * Isolation VMs).
+ */
+void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
+{
+	void *vaddr;
+
+	if (swiotlb_unencrypted_base) {
+		phys_addr_t paddr = mem->start + swiotlb_unencrypted_base;
+
+		vaddr = memremap(paddr, bytes, MEMREMAP_WB);
+		if (!vaddr) {
+			pr_err("Failed to map the unencrypted memory %llx size %lx.\n",
+			       paddr, bytes);
+			return NULL;
+		}
+
+		return vaddr;
+	}
+
+	return phys_to_virt(mem->start);
+}
+
 /*
  * Early SWIOTLB allocation may be too early to allow an architecture to
  * perform the desired operations.  This function allows the architecture to
@@ -172,10 +200,17 @@ void __init swiotlb_update_mem_attributes(void)
 	vaddr = phys_to_virt(mem->start);
 	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
 	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
-	memset(vaddr, 0, bytes);
+
+	mem->vaddr = swiotlb_mem_remap(mem, bytes);
+	if (!mem->vaddr) {
+		pr_err("Fail to remap swiotlb mem.\n");
+		return;
+	}
+
+	memset(mem->vaddr, 0, bytes);
 }
 
-static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
+static int swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 				    unsigned long nslabs, bool late_alloc)
 {
 	void *vaddr = phys_to_virt(start);
@@ -196,13 +231,28 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
 		mem->slots[i].alloc_size = 0;
 	}
+
+	/*
+	 * With swiotlb_unencrypted_base setting, swiotlb bounce buffer will
+	 * be remapped in the swiotlb_update_mem_attributes() and return here
+	 * directly.
+	 */
+	if (swiotlb_unencrypted_base)
+		return 0;
+
+	if (set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT))
+		return -EFAULT;
+
 	memset(vaddr, 0, bytes);
+	mem->vaddr = vaddr;
+	return 0;
 }
 
 int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 {
 	struct io_tlb_mem *mem = &io_tlb_default_mem;
 	size_t alloc_size;
+	int ret;
 
 	if (swiotlb_force == SWIOTLB_NO_FORCE)
 		return 0;
@@ -217,7 +267,11 @@ int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 		panic("%s: Failed to allocate %zu bytes align=0x%lx\n",
 		      __func__, alloc_size, PAGE_SIZE);
 
-	swiotlb_init_io_tlb_mem(mem, __pa(tlb), nslabs, false);
+	ret = swiotlb_init_io_tlb_mem(mem, __pa(tlb), nslabs, false);
+	if (ret) {
+		memblock_free(mem->slots, alloc_size);
+		return ret;
+	}
 
 	if (verbose)
 		swiotlb_print_info();
@@ -304,7 +358,9 @@ int
 swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 {
 	struct io_tlb_mem *mem = &io_tlb_default_mem;
-	unsigned long bytes = nslabs << IO_TLB_SHIFT;
+	unsigned long order
+		= get_order(array_size(sizeof(*mem->slots), nslabs));
+	int ret;
 
 	if (swiotlb_force == SWIOTLB_NO_FORCE)
 		return 0;
@@ -314,12 +370,15 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 		return -ENOMEM;
 
 	mem->slots = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-		get_order(array_size(sizeof(*mem->slots), nslabs)));
+		order);
 	if (!mem->slots)
 		return -ENOMEM;
 
-	set_memory_decrypted((unsigned long)tlb, bytes >> PAGE_SHIFT);
-	swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
+	ret = swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
+	if (ret) {
+		free_pages((unsigned long)mem->slots, order);
+		return ret;
+	}
 
 	swiotlb_print_info();
 	swiotlb_set_max_segment(mem->nslabs << IO_TLB_SHIFT);
@@ -371,7 +430,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
 	unsigned long pfn = PFN_DOWN(orig_addr);
-	unsigned char *vaddr = phys_to_virt(tlb_addr);
+	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
 	unsigned int tlb_offset, orig_addr_offset;
 
 	if (orig_addr == INVALID_PHYS_ADDR)
-- 
2.25.1

