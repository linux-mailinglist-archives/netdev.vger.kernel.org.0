Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B1445A5DE
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbhKWOkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 09:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbhKWOkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 09:40:08 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A29C06173E;
        Tue, 23 Nov 2021 06:37:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id np3so16766163pjb.4;
        Tue, 23 Nov 2021 06:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AdBAxc/3LXP8YWhzmIb2SnuIKCxbwTfsQGFXzfobc4o=;
        b=XnUoHbWpSwYk5kFBJ/DiTYTTNinPEcFFxNehQ/NE8dCnkpc+sk9KROtwTTPo5AZUlD
         KGFX0XE5xcl5jyD2u8K/drsQWazKXhDlRTGeS7gqiKSeUp2UwrolTFVy1IM6bHyhszQ1
         9OeS/NTKP70Q3dmlOpA8Dqdb6TH6OnBcSQJSIq5PmKRbi4w0P70ZukJtymjsVmLzpzLO
         xMQ96t6PnqCt8wqpzN4kjOaDyWHsDCGbfc2/0HWq0LkxTp9bAjMbQmC1GTD8Lp6yCwpV
         Ud7gCs4BiwxJmizIddhvqn9IqPDPFDNh1/UEqHeit1jWOhPoS5bGB/SxVaovdMIjM7OO
         ySSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AdBAxc/3LXP8YWhzmIb2SnuIKCxbwTfsQGFXzfobc4o=;
        b=x17C1iqIBlRTDQCgfKH6T8qc4JA7bw2Im4EewvI1s5CjzAVwyLNqPWwl/ZKHmm782z
         JTGWQE8ERBids/Ugh09nowpFEQBdg8BuwRJfDLBBBc3gglqhiX54zSRNDWRG0pBHqEbq
         4zKpA3i6kNIYxy2eGqtry573rqVWX14Zh9ctn+PtwWA4w7tfFNQ3XYzB/hjKiDEnb1nu
         vUGVyCaD++m/jUXDKqPprhIBw/jHqGIZtyCF9lgOotELPNwEfruYaf9hJJjOMfR5o+ru
         6ouj32wqYFqXT8SsaOsqNH6u/Vuxw9lmGBQe6HAVOeEKQyWVBtDe89V0zRvTTpcPd+NA
         pnqQ==
X-Gm-Message-State: AOAM530oBlpSmQsvNNGayj5HaqTCCs7U+eIbbc21/3W1o2LB3XWb5ob3
        WrvzvS3HOKZm2iDP6FxIcNI=
X-Google-Smtp-Source: ABdhPJxMfWW29WaiL3j7bKuP57MP7f389+tDMfhLQdJn1uZ+fZJgqSGVd07YIzZXQYtpg2/rCt6SHA==
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr3423978pjb.93.1637678219409;
        Tue, 23 Nov 2021 06:36:59 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:1:af65:c3d4:6df:5a8b])
        by smtp.gmail.com with ESMTPSA id j13sm11926127pfc.151.2021.11.23.06.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 06:36:59 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        xen-devel@lists.xenproject.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V2 4/6] hyperv/IOMMU: Enable swiotlb bounce buffer for Isolation VM
Date:   Tue, 23 Nov 2021 09:30:35 -0500
Message-Id: <20211123143039.331929-5-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211123143039.331929-1-ltykernel@gmail.com>
References: <20211123143039.331929-1-ltykernel@gmail.com>
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

Hyper-V initalizes swiotlb bounce buffer and default swiotlb
needs to be disabled. pci_swiotlb_detect_override() and
pci_swiotlb_detect_4gb() enable the default one. To override
the setting, hyperv_swiotlb_detect() needs to run before
these detect functions which depends on the pci_xen_swiotlb_
init(). Make pci_xen_swiotlb_init() depends on the hyperv_swiotlb
_detect() to keep the order.

Swiotlb bounce buffer code calls set_memory_decrypted()
to mark bounce buffer visible to host and map it in extra
address space via memremap. Populate the shared_gpa_boundary
(vTOM) via swiotlb_unencrypted_base variable.

The map function memremap() can't work in the early place
hyperv_iommu_swiotlb_init() and so call swiotlb_update_mem_attributes()
in the hyperv_iommu_swiotlb_later_init().

Add Hyper-V dma ops and provide alloc/free and vmap/vunmap noncontiguous
callback to handle request of  allocating and mapping noncontiguous dma
memory in vmbus device driver. Netvsc driver will use this. Set dma_ops_
bypass flag for hv device to use dma direct functions during mapping/unmapping
dma page.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v1:
	* Remove hv isolation check in the sev_setup_arch()

 arch/x86/mm/mem_encrypt.c      |   1 +
 arch/x86/xen/pci-swiotlb-xen.c |   3 +-
 drivers/hv/Kconfig             |   1 +
 drivers/hv/vmbus_drv.c         |   6 ++
 drivers/iommu/hyperv-iommu.c   | 164 +++++++++++++++++++++++++++++++++
 include/linux/hyperv.h         |  10 ++
 6 files changed, 184 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 35487305d8af..e48c73b3dd41 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -31,6 +31,7 @@
 #include <asm/processor-flags.h>
 #include <asm/msr.h>
 #include <asm/cmdline.h>
+#include <asm/mshyperv.h>
 
 #include "mm_internal.h"
 
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index 46df59aeaa06..30fd0600b008 100644
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
diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index dd12af20e467..d43b4cd88f57 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -9,6 +9,7 @@ config HYPERV
 	select PARAVIRT
 	select X86_HV_CALLBACK_VECTOR if X86
 	select VMAP_PFN
+	select DMA_OPS_BYPASS
 	help
 	  Select this option to run Linux as a Hyper-V client operating
 	  system.
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 392c1ac4f819..32dc193e31cd 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -33,6 +33,7 @@
 #include <linux/random.h>
 #include <linux/kernel.h>
 #include <linux/syscore_ops.h>
+#include <linux/dma-map-ops.h>
 #include <clocksource/hyperv_timer.h>
 #include "hyperv_vmbus.h"
 
@@ -2078,6 +2079,7 @@ struct hv_device *vmbus_device_create(const guid_t *type,
 	return child_device_obj;
 }
 
+static u64 vmbus_dma_mask = DMA_BIT_MASK(64);
 /*
  * vmbus_device_register - Register the child device
  */
@@ -2118,6 +2120,10 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	}
 	hv_debug_add_dev_dir(child_device_obj);
 
+	child_device_obj->device.dma_ops_bypass = true;
+	child_device_obj->device.dma_ops = &hyperv_iommu_dma_ops;
+	child_device_obj->device.dma_mask = &vmbus_dma_mask;
+	child_device_obj->device.dma_parms = &child_device_obj->dma_parms;
 	return 0;
 
 err_kset_unregister:
diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index e285a220c913..ebcb628e7e8f 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -13,14 +13,21 @@
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
 
 #include "irq_remapping.h"
 
@@ -337,4 +344,161 @@ static const struct irq_domain_ops hyperv_root_ir_domain_ops = {
 	.free = hyperv_root_irq_remapping_free,
 };
 
+static void __init hyperv_iommu_swiotlb_init(void)
+{
+	unsigned long hyperv_io_tlb_size;
+	void *hyperv_io_tlb_start;
+
+	/*
+	 * Allocate Hyper-V swiotlb bounce buffer at early place
+	 * to reserve large contiguous memory.
+	 */
+	hyperv_io_tlb_size = swiotlb_size_or_default();
+	hyperv_io_tlb_start = memblock_alloc(hyperv_io_tlb_size, PAGE_SIZE);
+
+	if (!hyperv_io_tlb_start)
+		pr_warn("Fail to allocate Hyper-V swiotlb buffer.\n");
+
+	swiotlb_init_with_tbl(hyperv_io_tlb_start,
+			      hyperv_io_tlb_size >> IO_TLB_SHIFT, true);
+}
+
+int __init hyperv_swiotlb_detect(void)
+{
+	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
+		return 0;
+
+	if (!hv_is_isolation_supported())
+		return 0;
+
+	/*
+	 * Enable swiotlb force mode in Isolation VM to
+	 * use swiotlb bounce buffer for dma transaction.
+	 */
+	if (hv_isolation_type_snp())
+		swiotlb_unencrypted_base = ms_hyperv.shared_gpa_boundary;
+	swiotlb_force = SWIOTLB_FORCE;
+	return 1;
+}
+
+static void __init hyperv_iommu_swiotlb_later_init(void)
+{
+	/*
+	 * Swiotlb bounce buffer needs to be mapped in extra address
+	 * space. Map function doesn't work in the early place and so
+	 * call swiotlb_update_mem_attributes() here.
+	 */
+	swiotlb_update_mem_attributes();
+}
+
+IOMMU_INIT_FINISH(hyperv_swiotlb_detect,
+		  NULL, hyperv_iommu_swiotlb_init,
+		  hyperv_iommu_swiotlb_later_init);
+
+static struct sg_table *hyperv_dma_alloc_noncontiguous(struct device *dev,
+		size_t size, enum dma_data_direction dir, gfp_t gfp,
+		unsigned long attrs)
+{
+	struct dma_sgt_handle *sh;
+	struct page **pages;
+	int num_pages = size >> PAGE_SHIFT;
+	void *vaddr, *ptr;
+	int rc, i;
+
+	if (!hv_isolation_type_snp())
+		return NULL;
+
+	sh = kmalloc(sizeof(*sh), gfp);
+	if (!sh)
+		return NULL;
+
+	vaddr = vmalloc(size);
+	if (!vaddr)
+		goto free_sgt;
+
+	pages = kvmalloc_array(num_pages, sizeof(struct page *),
+				    GFP_KERNEL | __GFP_ZERO);
+	if (!pages)
+		goto free_mem;
+
+	for (i = 0, ptr = vaddr; i < num_pages; ++i, ptr += PAGE_SIZE)
+		pages[i] = vmalloc_to_page(ptr);
+
+	rc = sg_alloc_table_from_pages(&sh->sgt, pages, num_pages, 0, size, GFP_KERNEL);
+	if (rc)
+		goto free_pages;
+
+	sh->sgt.sgl->dma_address = (dma_addr_t)vaddr;
+	sh->sgt.sgl->dma_length = size;
+	sh->pages = pages;
+
+	return &sh->sgt;
+
+free_pages:
+	kvfree(pages);
+free_mem:
+	vfree(vaddr);
+free_sgt:
+	kfree(sh);
+	return NULL;
+}
+
+static void hyperv_dma_free_noncontiguous(struct device *dev, size_t size,
+		struct sg_table *sgt, enum dma_data_direction dir)
+{
+	struct dma_sgt_handle *sh = sgt_handle(sgt);
+
+	if (!hv_isolation_type_snp())
+		return;
+
+	vfree((void *)sh->sgt.sgl->dma_address);
+	sg_free_table(&sh->sgt);
+	kvfree(sh->pages);
+	kfree(sh);
+}
+
+static void *hyperv_dma_vmap_noncontiguous(struct device *dev, size_t size,
+			struct sg_table *sgt)
+{
+	int pg_count = size >> PAGE_SHIFT;
+	unsigned long *pfns;
+	struct page **pages = sgt_handle(sgt)->pages;
+	void *vaddr = NULL;
+	int i;
+
+	if (!hv_isolation_type_snp())
+		return NULL;
+
+	if (!pages)
+		return NULL;
+
+	pfns = kcalloc(pg_count, sizeof(*pfns), GFP_KERNEL);
+	if (!pfns)
+		return NULL;
+
+	for (i = 0; i < pg_count; i++)
+		pfns[i] = page_to_pfn(pages[i]) +
+			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
+
+	vaddr = vmap_pfn(pfns, pg_count, PAGE_KERNEL);
+	kfree(pfns);
+	return vaddr;
+
+}
+
+static void hyperv_dma_vunmap_noncontiguous(struct device *dev, void *addr)
+{
+	if (!hv_isolation_type_snp())
+		return;
+	vunmap(addr);
+}
+
+const struct dma_map_ops hyperv_iommu_dma_ops = {
+		.alloc_noncontiguous = hyperv_dma_alloc_noncontiguous,
+		.free_noncontiguous = hyperv_dma_free_noncontiguous,
+		.vmap_noncontiguous = hyperv_dma_vmap_noncontiguous,
+		.vunmap_noncontiguous = hyperv_dma_vunmap_noncontiguous,
+};
+EXPORT_SYMBOL_GPL(hyperv_iommu_dma_ops);
+
 #endif
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index b823311eac79..4d44fb3b3f1c 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1726,6 +1726,16 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
 int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
 				void (*block_invalidate)(void *context,
 							 u64 block_mask));
+#ifdef CONFIG_HYPERV
+int __init hyperv_swiotlb_detect(void);
+#else
+static inline int __init hyperv_swiotlb_detect(void)
+{
+	return 0;
+}
+#endif
+
+extern const struct dma_map_ops hyperv_iommu_dma_ops;
 
 struct hyperv_pci_block_ops {
 	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
-- 
2.25.1

