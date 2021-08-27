Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAD43F9DEC
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245626AbhH0RXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237065AbhH0RWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:22:39 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38FBC06179A;
        Fri, 27 Aug 2021 10:21:49 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q68so6469531pga.9;
        Fri, 27 Aug 2021 10:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f/xiBxoq9p910rq4iCCIXN3piXXicO8x7yFYnpejeEk=;
        b=Ju+1YsPkg+UbMh1or5AIAI/ZvTETioYtgUuZZBnkEMEAY4wG/GpaOnM5lRpCuVEexe
         tumb++OLULd903N2hp7Qy2sLv493o0sqM1ciJZGGmOTkFHwpc0J/Yi0A4EFKybLEXp6A
         jHk4b+zO0G8lnOcidl94Qugbz4vzXgvdD20Gf0+Za3mE4U4VRUylL95yNp387frjeho3
         Tydc+sAk2HjHyRM2/aBSNofuAZ7hYsTRhM8t4bBXBsNP8Ghfc2Eobpq+STxZiiZ5Bjmz
         KaaohXKSjVg3XUlnBIKCvvdh/pNN14L9P6XuRbik+Tc9GG6lDQBqK96lrzNtAflEBlew
         xsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/xiBxoq9p910rq4iCCIXN3piXXicO8x7yFYnpejeEk=;
        b=N4sUDAiC4RKmgyHynwmknu/8bKBAqi71XE8wYe0kMmx/h/dTqhtCijmtEHcLMuPUlA
         vTSSStUTmS3g7jQw1LJBL/Zho2ssQac8YqmDv9YGmX/RV+O4fFUAaEWOKGLvnvyJfZqN
         PF+dBS04jAFm/a99MRALL+jwWWI9RXnLjzYOVeMsfAtczhwARryzVqYa4qLLhI24/wz4
         u424+RmwTDc5As7NzKm1y1UYSuK0ws/ASYWA1bP+8QB4+CAgGeC9Hl+rz+JnA3DZZttS
         oqEb5A6F9XNIpywULStgvo9SshmlTKzQ2cw4dvnNj1hUTBIo7VWnUsvCNwEStOpF+YiS
         7owA==
X-Gm-Message-State: AOAM5333QWAalq93HWEEK1fjLeXA6S9ZSn7WQLNaSRGkw99qdXrdr73C
        Wb7t9+z1j3ibLYuO6U71ToI=
X-Google-Smtp-Source: ABdhPJzpavlzdHZS1F6vdwwwOqwaFBPaG/YJGq0r0zJwRIjYidAu7mB3ClbmW59sMbVlOn28t15kbQ==
X-Received: by 2002:a63:4f51:: with SMTP id p17mr8806904pgl.29.1630084909372;
        Fri, 27 Aug 2021 10:21:49 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:36:ef50:8fcd:44d1:eb17])
        by smtp.gmail.com with ESMTPSA id f5sm7155015pjo.23.2021.08.27.10.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 10:21:48 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        arnd@arndb.de, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V4 11/13] hyperv/IOMMU: Enable swiotlb bounce buffer for Isolation VM
Date:   Fri, 27 Aug 2021 13:21:09 -0400
Message-Id: <20210827172114.414281-12-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827172114.414281-1-ltykernel@gmail.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

hyperv Isolation VM requires bounce buffer support to copy
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
Change since v3:
       * Get hyperv bounce bufffer size via default swiotlb
       bounce buffer size function and keep default size as
       same as the one in the AMD SEV VM.
---
 arch/x86/hyperv/ivm.c           | 28 +++++++++++++++
 arch/x86/include/asm/mshyperv.h |  2 ++
 arch/x86/mm/mem_encrypt.c       |  3 +-
 arch/x86/xen/pci-swiotlb-xen.c  |  3 +-
 drivers/hv/vmbus_drv.c          |  3 ++
 drivers/iommu/hyperv-iommu.c    | 61 +++++++++++++++++++++++++++++++++
 include/linux/hyperv.h          |  1 +
 7 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index e761c67e2218..84563b3c9f3a 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -294,3 +294,31 @@ int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool visible)
 
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
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index b77f4caee3ee..627fcf8d443c 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -252,6 +252,8 @@ int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
 int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
 			   enum hv_mem_host_visibility visibility);
 int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool visible);
+void *hv_map_memory(void *addr, unsigned long size);
+void hv_unmap_memory(void *addr);
 void hv_sint_wrmsrl_ghcb(u64 msr, u64 value);
 void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value);
 void hv_signal_eom_ghcb(void);
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index ff08dc463634..e2db0b8ed938 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -30,6 +30,7 @@
 #include <asm/processor-flags.h>
 #include <asm/msr.h>
 #include <asm/cmdline.h>
+#include <asm/mshyperv.h>
 
 #include "mm_internal.h"
 
@@ -202,7 +203,7 @@ void __init sev_setup_arch(void)
 	phys_addr_t total_mem = memblock_phys_mem_size();
 	unsigned long size;
 
-	if (!sev_active())
+	if (!sev_active() && !hv_is_isolation_supported())
 		return;
 
 	/*
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
index e285a220c913..899563551574 100644
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
@@ -337,4 +348,54 @@ static const struct irq_domain_ops hyperv_root_ir_domain_ops = {
 	.free = hyperv_root_irq_remapping_free,
 };
 
+void __init hyperv_iommu_swiotlb_init(void)
+{
+	/*
+	 * Allocate Hyper-V swiotlb bounce buffer at early place
+	 * to reserve large contiguous memory.
+	 */
+	hyperv_io_tlb_size = swiotlb_size_or_default();
+	hyperv_io_tlb_start = memblock_alloc(
+		hyperv_io_tlb_size, HV_HYP_PAGE_SIZE);
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
index 757e09606fd3..724a735d722a 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1739,6 +1739,7 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
 int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
 				void (*block_invalidate)(void *context,
 							 u64 block_mask));
+int __init hyperv_swiotlb_detect(void);
 
 struct hyperv_pci_block_ops {
 	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
-- 
2.25.1

