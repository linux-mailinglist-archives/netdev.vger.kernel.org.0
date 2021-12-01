Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3D7465262
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 17:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351325AbhLAQGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 11:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351289AbhLAQG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 11:06:29 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE7EC061574;
        Wed,  1 Dec 2021 08:03:08 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id nn15-20020a17090b38cf00b001ac7dd5d40cso1981297pjb.3;
        Wed, 01 Dec 2021 08:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4faqUlJ+SZYnP9uFrNO41NoVrlsOh4d1PwMWVTDsii0=;
        b=EoEQhzYXyn/Uz+fYQL6+D8YgSqQQiHPwqGQJ6GM45qZKsFpcjhevIa8L/pl+sFAUkL
         6ilR5PMAfTa4GsQKH9BkVavcBWMKa3q095ZfyfDYU37jcqq/AZk4p28bXA3B30TG4Cep
         dbFjMch18yARC14F1a6g7hBovcdUv7sIZFsG7SgWxaROgr88xIIAt+ZoyIpLMF1rhMBD
         PTZFK0k8zcIn+A3NBF41yakdEyzg6WDCLGa3pEQwZyig4H4B9ik8x0c7UoU5nNLaGNYT
         FXj+LDj5JrE+2yeyXT9DMjB46S8nDNWguqmxDY7hZisVft7Wg4WHe66j7swhVwm+GYDc
         x0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4faqUlJ+SZYnP9uFrNO41NoVrlsOh4d1PwMWVTDsii0=;
        b=mII4P8b1V7NXiK/ULMoEMw21MOzvRWYJUpGTLmPItv/rtyp+JibLfv9zG9LPpzc3wD
         0GwVXOyKrFJ7Z22AN1KZ3/H1WJBbvIlupkM10t7TomoNpR7fg3/GP6HBkoZ4KvZdT3jz
         p8FL4eN15J8/XHYi9FcM9e1I8Wz/18f4H0ML2W8PZps6/IYJDI8Y5dM1TYH/g+eWgNho
         A/jdDrCx7Ys52tNH3aFpniLbsLxuk77zAsSkq3VWUjkwIx0ndqTYTGtOnamDEbGQfV9U
         ++KzeyOiZ207xZ3YOBZpfpERDiVBGDSGPVSdDebwgb35uPCpH+KG/UiMSany2BqxhwRU
         cOkg==
X-Gm-Message-State: AOAM531HYLVV57GkDNa295Q43MBqCk3pTREa3qBFRfnDfXwE9Tl1L39W
        cupFpf98FYRKBtFcJPrbyWc=
X-Google-Smtp-Source: ABdhPJy1JxfjA/xzL4ufAFR3Zv/5zOIXPmdOHVJwpGxXD0b7sbTpoBxYwO/zTP0eS3+GqwpjJnNX9w==
X-Received: by 2002:a17:902:e5c9:b0:142:53c4:478d with SMTP id u9-20020a170902e5c900b0014253c4478dmr8110755plf.33.1638374585940;
        Wed, 01 Dec 2021 08:03:05 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:f:7fe9:3f1e:749e:5d26])
        by smtp.gmail.com with ESMTPSA id i193sm260316pfe.87.2021.12.01.08.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 08:03:05 -0800 (PST)
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
Subject: [PATCH V3 1/5] Swiotlb: Add Swiotlb bounce buffer remap function for HV IVM
Date:   Wed,  1 Dec 2021 11:02:52 -0500
Message-Id: <20211201160257.1003912-2-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201160257.1003912-1-ltykernel@gmail.com>
References: <20211201160257.1003912-1-ltykernel@gmail.com>
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
Change since v2:
	* Leave mem->vaddr with phys_to_virt(mem->start) when fail
	  to remap swiotlb memory.

Change since v1:
	* Rework comment in the swiotlb_init_io_tlb_mem()
	* Make swiotlb_init_io_tlb_mem() back to return void.
---
 include/linux/swiotlb.h |  6 ++++++
 kernel/dma/swiotlb.c    | 47 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 569272871375..f6c3638255d5 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -73,6 +73,9 @@ extern enum swiotlb_force swiotlb_force;
  * @end:	The end address of the swiotlb memory pool. Used to do a quick
  *		range check to see if the memory was in fact allocated by this
  *		API.
+ * @vaddr:	The vaddr of the swiotlb memory pool. The swiotlb memory pool
+ *		may be remapped in the memory encrypted case and store virtual
+ *		address for bounce buffer operation.
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
index 8e840fbbed7c..adb9d06af5c8 100644
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
@@ -155,6 +158,27 @@ static inline unsigned long nr_slots(u64 val)
 	return DIV_ROUND_UP(val, IO_TLB_SIZE);
 }
 
+/*
+ * Remap swioltb memory in the unencrypted physical address space
+ * when swiotlb_unencrypted_base is set. (e.g. for Hyper-V AMD SEV-SNP
+ * Isolation VMs).
+ */
+void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
+{
+	void *vaddr = NULL;
+
+	if (swiotlb_unencrypted_base) {
+		phys_addr_t paddr = mem->start + swiotlb_unencrypted_base;
+
+		vaddr = memremap(paddr, bytes, MEMREMAP_WB);
+		if (!vaddr)
+			pr_err("Failed to map the unencrypted memory %llx size %lx.\n",
+			       paddr, bytes);
+	}
+
+	return vaddr;
+}
+
 /*
  * Early SWIOTLB allocation may be too early to allow an architecture to
  * perform the desired operations.  This function allows the architecture to
@@ -172,7 +196,12 @@ void __init swiotlb_update_mem_attributes(void)
 	vaddr = phys_to_virt(mem->start);
 	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
 	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
-	memset(vaddr, 0, bytes);
+
+	mem->vaddr = swiotlb_mem_remap(mem, bytes);
+	if (!mem->vaddr)
+		mem->vaddr = vaddr;
+
+	memset(mem->vaddr, 0, bytes);
 }
 
 static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
@@ -196,7 +225,18 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
 		mem->slots[i].alloc_size = 0;
 	}
+
+	/*
+	 * If swiotlb_unencrypted_base is set, the bounce buffer memory will
+	 * be remapped and cleared in swiotlb_update_mem_attributes.
+	 */
+	if (swiotlb_unencrypted_base)
+		return;
+
+	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
 	memset(vaddr, 0, bytes);
+	mem->vaddr = vaddr;
+	return;
 }
 
 int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
@@ -318,7 +358,6 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 	if (!mem->slots)
 		return -ENOMEM;
 
-	set_memory_decrypted((unsigned long)tlb, bytes >> PAGE_SHIFT);
 	swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
 
 	swiotlb_print_info();
@@ -371,7 +410,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
 	unsigned long pfn = PFN_DOWN(orig_addr);
-	unsigned char *vaddr = phys_to_virt(tlb_addr);
+	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
 	unsigned int tlb_offset, orig_addr_offset;
 
 	if (orig_addr == INVALID_PHYS_ADDR)
@@ -806,8 +845,6 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 			return -ENOMEM;
 		}
 
-		set_memory_decrypted((unsigned long)phys_to_virt(rmem->base),
-				     rmem->size >> PAGE_SHIFT);
 		swiotlb_init_io_tlb_mem(mem, rmem->base, nslabs, false);
 		mem->force_bounce = true;
 		mem->for_alloc = true;
-- 
2.25.1

