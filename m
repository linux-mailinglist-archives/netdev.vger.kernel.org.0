Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C28A3951A2
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 17:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhE3PIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 11:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhE3PIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 11:08:30 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F763C06174A;
        Sun, 30 May 2021 08:06:51 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t21so3947761plo.2;
        Sun, 30 May 2021 08:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EtCkaCE4/EzFHv3S6hPZuMsiJS31BeqUj9mfIppTr8A=;
        b=BCfbHHh7cyudMiVzOhaWtM71E5It7nVh3XODt6DlztlKwSR8hmKzGs/GHbE9k5ukZn
         cvwUBE5ZURUeWzebOEMn+N+iyqbQf4jk5jAG3OEblpaI62E5gwLiBEvwNG3m6sjyUZ/x
         hRItnVqfcYlZWv6o/PEot2mwHpeCnoNP0dA2FhRjTcNveOVwR98Xi7VhiU05+2rHeKsG
         dCGrpoRct9XXG+mj101SDS97GDP//b5DIZwBmvoBkTvUK4hiwfNAb8emrWGxAk2fR8HL
         u18x+mH2iH03GzLJkM+cxIuDbKfAhp1Vh6iQqsI/53FhLbFKbvqa90/OlAKUI3PIs6w5
         FTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EtCkaCE4/EzFHv3S6hPZuMsiJS31BeqUj9mfIppTr8A=;
        b=dS5n8JD0/dLDf4vsJkWTA8OlDkvyNA3moXLtDkHHqrGjnEem+rGzGOV3Qy7d900Tdt
         /65f+X6mzkxjzMR/RKXhD2fvjYVe92TOLEgSLt97+0RiDG8SvXEkQZwe8HC2HlKfu4Tq
         YDybXTbMwQyEkIKH2JxqPsjCfa5OXzmSKArENT8rCnYRfVYcDyc0eDqkX3R1uBHVVo6q
         i8xgq+iEZYm2XumkuPEbG03grJ8wqq6pBGC2tsdLostPyCaXYalBky8TsSVQ8tdTrPjp
         qGrcl2TK1PY5HBMAt1gJGbcxT7M1C749GlX903GtGiyxsPlg8aoHGUtNA6zMmyBIIWV4
         EqLA==
X-Gm-Message-State: AOAM533XqeWRqQV+G/dR4SjjWNAW0ibiSYow0GyX4LCcO2aE3laQwpyT
        e1HuVbHNFbI8zckohh/7fhU=
X-Google-Smtp-Source: ABdhPJxBmJKYzQHIxtFyRq8cxb9YKkXh8aR0S9biw6tunPzBCDJlQ572ZHUOD2JLd5vyGyCMqeAmvA==
X-Received: by 2002:a17:90b:400c:: with SMTP id ie12mr6846115pjb.107.1622387210845;
        Sun, 30 May 2021 08:06:50 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:9:dc2d:80ab:c3f3:1524])
        by smtp.gmail.com with ESMTPSA id b15sm8679688pfi.100.2021.05.30.08.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 08:06:50 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: [RFC PATCH V3 09/11] HV/IOMMU: Enable swiotlb bounce buffer for Isolation VM
Date:   Sun, 30 May 2021 11:06:26 -0400
Message-Id: <20210530150628.2063957-10-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210530150628.2063957-1-ltykernel@gmail.com>
References: <20210530150628.2063957-1-ltykernel@gmail.com>
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

ioremap_cache() can't use in the hyperv_iommu_swiotlb_init() which
is too early place and remap bounce buffer in the hyperv_iommu_swiotlb_
later_init().

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |  3 +-
 drivers/hv/vmbus_drv.c         |  3 ++
 drivers/iommu/hyperv-iommu.c   | 81 ++++++++++++++++++++++++++++++++++
 include/linux/hyperv.h         |  1 +
 4 files changed, 87 insertions(+), 1 deletion(-)

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
index 92cb3f7d21d9..5e3bb76d4dee 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -23,6 +23,7 @@
 #include <linux/cpu.h>
 #include <linux/sched/task_stack.h>
 
+#include <linux/dma-map-ops.h>
 #include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/ptrace.h>
@@ -2080,6 +2081,7 @@ struct hv_device *vmbus_device_create(const guid_t *type,
 	return child_device_obj;
 }
 
+static u64 vmbus_dma_mask = DMA_BIT_MASK(64);
 /*
  * vmbus_device_register - Register the child device
  */
@@ -2120,6 +2122,7 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	}
 	hv_debug_add_dev_dir(child_device_obj);
 
+	child_device_obj->device.dma_mask = &vmbus_dma_mask;
 	return 0;
 
 err_kset_unregister:
diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index e285a220c913..2604619c6fa3 100644
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
 
@@ -36,6 +44,8 @@
 static cpumask_t ioapic_max_cpumask = { CPU_BITS_NONE };
 static struct irq_domain *ioapic_ir_domain;
 
+static unsigned long hyperv_io_tlb_start, hyperv_io_tlb_size;
+
 static int hyperv_ir_set_affinity(struct irq_data *data,
 		const struct cpumask *mask, bool force)
 {
@@ -337,4 +347,75 @@ static const struct irq_domain_ops hyperv_root_ir_domain_ops = {
 	.free = hyperv_root_irq_remapping_free,
 };
 
+void __init hyperv_iommu_swiotlb_init(void)
+{
+	unsigned long bytes, io_tlb_nslabs;
+	void *vstart;
+
+	/* Allocate Hyper-V swiotlb  */
+	bytes = 200 * 1024 * 1024;
+	vstart = memblock_alloc_low(PAGE_ALIGN(bytes), PAGE_SIZE);
+	io_tlb_nslabs = bytes >> IO_TLB_SHIFT;
+	hyperv_io_tlb_size = bytes;
+
+	if (!vstart) {
+		pr_warn("Fail to allocate swiotlb.\n");
+		return;
+	}
+
+	hyperv_io_tlb_start = virt_to_phys(vstart);
+	if (!hyperv_io_tlb_start)
+		panic("%s: Failed to allocate %lu bytes align=0x%lx.\n",
+		      __func__, PAGE_ALIGN(bytes), PAGE_SIZE);
+
+	if (swiotlb_init_with_tbl(vstart, io_tlb_nslabs, 1))
+		panic("%s: Cannot allocate SWIOTLB buffer.\n", __func__);
+
+	swiotlb_set_max_segment(HV_HYP_PAGE_SIZE);
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
+		return 1;
+	}
+
+	return 0;
+}
+
+void __init hyperv_iommu_swiotlb_later_init(void)
+{
+	void *hyperv_io_tlb_remap;
+	int ret;
+
+	/* Mask bounce buffer visible to host and remap extra address. */
+	if (hv_isolation_type_snp()) {
+		ret = set_memory_decrypted((unsigned long)
+				phys_to_virt(hyperv_io_tlb_start),
+				HVPFN_UP(hyperv_io_tlb_size));
+		if (ret)
+			panic("%s: Fail to mark Hyper-v swiotlb buffer visible to host. err=%d\n",
+			      __func__, ret);
+
+		hyperv_io_tlb_remap = ioremap_cache(hyperv_io_tlb_start
+				+ ms_hyperv.shared_gpa_boundary,
+				hyperv_io_tlb_size);
+		if (!hyperv_io_tlb_remap)
+			panic("Fail to remap io tlb.\n");
+
+		memset(hyperv_io_tlb_remap, 0x00, hyperv_io_tlb_size);
+		swiotlb_set_bounce_remap(hyperv_io_tlb_remap);
+	}
+}
+
+IOMMU_INIT_FINISH(hyperv_swiotlb_detect,
+		  NULL, hyperv_iommu_swiotlb_init,
+		  hyperv_iommu_swiotlb_later_init);
+
 #endif
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 06eccaba10c5..babbe19f57e2 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1759,6 +1759,7 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
 int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
 				void (*block_invalidate)(void *context,
 							 u64 block_mask));
+int __init hyperv_swiotlb_detect(void);
 
 struct hyperv_pci_block_ops {
 	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
-- 
2.25.1

