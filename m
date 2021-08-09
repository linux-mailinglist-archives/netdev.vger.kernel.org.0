Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06733E4B9E
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbhHIR6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbhHIR5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:57:17 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EBCC0617BC;
        Mon,  9 Aug 2021 10:56:51 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id a20so17373704plm.0;
        Mon, 09 Aug 2021 10:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wE1oyJvMZrxsK10mJTBwWYCUb1GB6i5zG9Yu/v/zgdM=;
        b=AR4iP5ZYBtCq95LlWtYYCyS910itq7pZDn/QCC4MRpb0ABoxb3+fdeU/8WwTtjQf5T
         wt6+yYw0C62DDMzkEhJ9TDNdHBUTRApK+U+iZJFsySVBxYlvJdujXMreaUZpdeFbAf4U
         vcTLAkPbqvTQqsnFJFAZNUdAmNtsbeiS2AvHxvoHY2vX7tqjY8VLvRu69UVWkdW6uPQm
         r6s0/vu2Yk4blkUZaI2VpcM4gDNFSYqRbOR/JAU6+351oCLyhaCizCEZRRrgZUN6m1Z1
         2B1uH9soEdbo/8BjQeOdRlT9ADfhGl+oSC9LxDUyE/wPt7X/V+eJurB8URppuSrIeyYy
         4zIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wE1oyJvMZrxsK10mJTBwWYCUb1GB6i5zG9Yu/v/zgdM=;
        b=OFg6uCtV4i69BWmC7WYVdIFXzFNPvBZ3nv17oseOpNd9s2Zmbs9lKB7QvjDaA7BOZA
         JAqFPgde+EQHl5neEOk4gWwUIx0pZdogYpYkEfHElfXZqKjJ4sBgBAdLi9WSFHFDI4Wh
         U1Ol3tbLn1SoHWLfiU4jMNG6LVVl8XivJNKw8VqAeCe1vVSQt70NRfmuI8tFM1OrlIcy
         FkP5AIU76b5EAAD96ZXsdoJQhkl7obccYn3cFThd4XC25paeQHbZJ8NpqiG+L9SiK8HX
         xlChh4h8PoadUobyKj+d/3PPAdHtGns77YAuNYR7F2bCO8iJNHhx6DGkrXCe2Ffv2pde
         q7WA==
X-Gm-Message-State: AOAM532QyuYgeuJ4CV8i6WUEjqV2a3XK+6EicY3cfFU9NvGjKig9rspL
        wU3+qxN9pFyz0lSk2B7pCI8=
X-Google-Smtp-Source: ABdhPJy2FZfXH3NbVL2EBYwcf8LiETMKocZ9CFOcqjbqCapsAKuw9uzjOCEJ0P+M1z5RyBMo3xqDGw==
X-Received: by 2002:aa7:838a:0:b029:3b7:31a5:649c with SMTP id u10-20020aa7838a0000b02903b731a5649cmr19142980pfm.44.1628531811197;
        Mon, 09 Aug 2021 10:56:51 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:2:106e:6ed1:5da1:2ac4])
        by smtp.gmail.com with ESMTPSA id x14sm20589708pfa.127.2021.08.09.10.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 10:56:50 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V3 11/13] HV/IOMMU: Enable swiotlb bounce buffer for Isolation VM
Date:   Mon,  9 Aug 2021 13:56:15 -0400
Message-Id: <20210809175620.720923-12-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809175620.720923-1-ltykernel@gmail.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V Isolation VM requires bounce buffer support to copy
data from/to encrypted memory and so enable swiotlb force
mode to use swiotlb bounce buffer for DMA transaction.

In Isolation VM with AMD SEV, the bounce buffer needs to be
accessed via extra address space which is above shared_gpa_boundary
(E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.
The access physical address will be original physical address +
shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
spec is called virtual top of memory(vTOM). Memory addresses below
vTOM are automatically treated as private while memory above
vTOM is treated as shared.

Swiotlb bounce buffer code calls dma_map_decrypted()
to mark bounce buffer visible to host and map it in extra
address space. Populate dma memory decrypted ops with hv
map/unmap function.

Hyper-V initalizes swiotlb bounce buffer and default swiotlb
needs to be disabled. pci_swiotlb_detect_override() and
pci_swiotlb_detect_4gb() enable the default one. To override
the setting, hyperv_swiotlb_detect() needs to run before
these detect functions which depends on the pci_xen_swiotlb_
init(). Make pci_xen_swiotlb_init() depends on the hyperv_swiotlb
_detect() to keep the order.

The map function vmap_pfn() can't work in the early place
hyperv_iommu_swiotlb_init() and so initialize swiotlb bounce
buffer in the hyperv_iommu_swiotlb_later_init().

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/ivm.c           | 28 ++++++++++++++
 arch/x86/include/asm/mshyperv.h |  2 +
 arch/x86/xen/pci-swiotlb-xen.c  |  3 +-
 drivers/hv/vmbus_drv.c          |  3 ++
 drivers/iommu/hyperv-iommu.c    | 65 +++++++++++++++++++++++++++++++++
 include/linux/hyperv.h          |  1 +
 6 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index c13ec5560d73..0f05e4d6fc62 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -265,3 +265,31 @@ int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool visible)
 
 	return __hv_set_mem_host_visibility((void *)addr, numpages, visibility);
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
+	for (i = 0; i < size / HV_HYP_PAGE_SIZE; i++)
+		pfns[i] = virt_to_hvpfn(addr + i * HV_HYP_PAGE_SIZE) +
+			(ms_hyperv.shared_gpa_boundary >> HV_HYP_PAGE_SHIFT);
+
+	vaddr = vmap_pfn(pfns, size / HV_HYP_PAGE_SIZE,	PAGE_KERNEL_IO);
+	kfree(pfns);
+
+	return vaddr;
+}
+
+void hv_unmap_memory(void *addr)
+{
+	vunmap(addr);
+}
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index a30c60f189a3..b247739f57ac 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -250,6 +250,8 @@ int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
 int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
 			   enum hv_mem_host_visibility visibility);
 int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool visible);
+void *hv_map_memory(void *addr, unsigned long size);
+void hv_unmap_memory(void *addr);
 void hv_sint_wrmsrl_ghcb(u64 msr, u64 value);
 void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value);
 void hv_signal_eom_ghcb(void);
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index 54f9aa7e8457..43bd031aa332 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -4,6 +4,7 @@
 
 #include <linux/dma-map-ops.h>
 #include <linux/pci.h>
+#include <linux/hyperv.h>
 #include <xen/swiotlb-xen.h>
 
 #include <asm/xen/hypervisor.h>
@@ -91,6 +92,6 @@ int pci_xen_swiotlb_init_late(void)
 EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
 
 IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
-		  NULL,
+		  hyperv_swiotlb_detect,
 		  pci_xen_swiotlb_init,
 		  NULL);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 57bbbaa4e8f7..f068e22a5636 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -23,6 +23,7 @@
 #include <linux/cpu.h>
 #include <linux/sched/task_stack.h>
 
+#include <linux/dma-map-ops.h>
 #include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/panic_notifier.h>
@@ -2081,6 +2082,7 @@ struct hv_device *vmbus_device_create(const guid_t *type,
 	return child_device_obj;
 }
 
+static u64 vmbus_dma_mask = DMA_BIT_MASK(64);
 /*
  * vmbus_device_register - Register the child device
  */
@@ -2121,6 +2123,7 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	}
 	hv_debug_add_dev_dir(child_device_obj);
 
+	child_device_obj->device.dma_mask = &vmbus_dma_mask;
 	return 0;
 
 err_kset_unregister:
diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index e285a220c913..01e874b3b43a 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -13,14 +13,22 @@
 #include <linux/irq.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
+#include <linux/hyperv.h>
+#include <linux/io.h>
 
 #include <asm/apic.h>
 #include <asm/cpu.h>
 #include <asm/hw_irq.h>
 #include <asm/io_apic.h>
+#include <asm/iommu.h>
+#include <asm/iommu_table.h>
 #include <asm/irq_remapping.h>
 #include <asm/hypervisor.h>
 #include <asm/mshyperv.h>
+#include <asm/swiotlb.h>
+#include <linux/dma-map-ops.h>
+#include <linux/dma-direct.h>
+#include <linux/set_memory.h>
 
 #include "irq_remapping.h"
 
@@ -36,6 +44,9 @@
 static cpumask_t ioapic_max_cpumask = { CPU_BITS_NONE };
 static struct irq_domain *ioapic_ir_domain;
 
+static unsigned long hyperv_io_tlb_size;
+static void *hyperv_io_tlb_start;
+
 static int hyperv_ir_set_affinity(struct irq_data *data,
 		const struct cpumask *mask, bool force)
 {
@@ -337,4 +348,58 @@ static const struct irq_domain_ops hyperv_root_ir_domain_ops = {
 	.free = hyperv_root_irq_remapping_free,
 };
 
+void __init hyperv_iommu_swiotlb_init(void)
+{
+	unsigned long bytes;
+
+	/*
+	 * Allocate Hyper-V swiotlb bounce buffer at early place
+	 * to reserve large contiguous memory.
+	 */
+	hyperv_io_tlb_size = 256 * 1024 * 1024;
+	hyperv_io_tlb_start =
+			memblock_alloc_low(
+				  PAGE_ALIGN(hyperv_io_tlb_size),
+				  HV_HYP_PAGE_SIZE);
+
+	if (!hyperv_io_tlb_start) {
+		pr_warn("Fail to allocate Hyper-V swiotlb buffer.\n");
+		return;
+	}
+}
+
+int __init hyperv_swiotlb_detect(void)
+{
+	if (hypervisor_is_type(X86_HYPER_MS_HYPERV)
+	    && hv_is_isolation_supported()) {
+		/*
+		 * Enable swiotlb force mode in Isolation VM to
+		 * use swiotlb bounce buffer for dma transaction.
+		 */
+		swiotlb_force = SWIOTLB_FORCE;
+
+		dma_memory_generic_decrypted_ops.map = hv_map_memory;
+		dma_memory_generic_decrypted_ops.unmap = hv_unmap_memory;
+		return 1;
+	}
+
+	return 0;
+}
+
+void __init hyperv_iommu_swiotlb_later_init(void)
+{
+	/*
+	 * Swiotlb bounce buffer needs to be mapped in extra address
+	 * space. Map function doesn't work in the early place and so
+	 * call swiotlb_late_init_with_tbl() here.
+	 */
+	if (swiotlb_late_init_with_tbl(hyperv_io_tlb_start,
+				       hyperv_io_tlb_size >> IO_TLB_SHIFT))
+		panic("Fail to initialize hyperv swiotlb.\n");
+}
+
+IOMMU_INIT_FINISH(hyperv_swiotlb_detect,
+		  NULL, hyperv_iommu_swiotlb_init,
+		  hyperv_iommu_swiotlb_later_init);
+
 #endif
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 90b542597143..83fa567ad594 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1744,6 +1744,7 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
 int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
 				void (*block_invalidate)(void *context,
 							 u64 block_mask));
+int __init hyperv_swiotlb_detect(void);
 
 struct hyperv_pci_block_ops {
 	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
-- 
2.25.1

