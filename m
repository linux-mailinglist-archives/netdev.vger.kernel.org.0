Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59953BEB7D
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhGGPuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhGGPtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:49:51 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E8BC0613E5;
        Wed,  7 Jul 2021 08:47:07 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 37so2708796pgq.0;
        Wed, 07 Jul 2021 08:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uSViD25AWGJ6J+QgAwUoKBubGeqJPy/dkYcV0Fzox+c=;
        b=cQcYT5XSBLbRJRDUNa0e5CgSigjoy2I5REnIiUUUqfnwYfNGPXXLVSum+8IzUodfaP
         NTItaqDrZixn5v3ga9DqqV+CMjZrPq+hOq0qzW+JzdevrlfXgqEqK2Ehmyky0HMcgFP3
         fBUAJnZALGSD2lwUXPo1oB7+tjhYoonkMW4pDlMoiGMuEP1yUjVan+9lRbSkG9DNhWQV
         dWxY/vIo+6ak/OXzqcOGKv7Ch8+RaNsC9N5387m4YR1JdwzUEvcBUBdz3axjyvNLlHdK
         q4JRQ6k96Mk9DN+/RNIoDW1vtP7bBHzLBDQcvP33UQJ6r+BeKTe/eU2ca43MQb/lQL6x
         TM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uSViD25AWGJ6J+QgAwUoKBubGeqJPy/dkYcV0Fzox+c=;
        b=WVwb91fdN1ZepVoZtiYN3rj/BE2uwIs6ZsJFOCYFkBpgV1Ax2mmm52gnttUzGRGN6R
         kwZpYeMlCXeus4tU91PUnWVFvmu5WVff028xz4syGF5UFTs2upre0mxgLrKL0gB+Y0V3
         Puw2o8tmEK2h62jDkQv5HMvj+40UIfxq62SDUgLHdEdmjLO+qDeO8A097ycZs0HAes3T
         c4RsFwavXNTKP+oTTZ2hHNdB4oMI1Iwpsaw6YbflJY9Ugf25U51HMdLOg/lvaDUfqrHc
         /wYbPe15HWHOOhLek3F/3IuckJTM6RgQVTgT66AFKyZH16sfGIRcNFv8qPRi9hQWf8pD
         Qbrg==
X-Gm-Message-State: AOAM532+TzX9In9Nzylzetj/QewBjFQxlqoumVnGENrlPyFLW4f0o1gG
        gFkwTJAaEANPdc/elNAoCNQ=
X-Google-Smtp-Source: ABdhPJy7eYx9Hj+tY38P1ebQQq0y3i61YfxbRUD8cqpY0wJNgpDT6hIlSZDAU9aZE7BllJmWIxymNA==
X-Received: by 2002:a63:ed12:: with SMTP id d18mr26142030pgi.12.1625672827391;
        Wed, 07 Jul 2021 08:47:07 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:38:6b47:cf3e:bbf2:d229])
        by smtp.gmail.com with ESMTPSA id q18sm23093560pgj.8.2021.07.07.08.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:47:07 -0700 (PDT)
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
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        rppt@kernel.org, Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        ardb@kernel.org, robh@kernel.org, nramas@linux.microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com, david@redhat.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        xen-devel@lists.xenproject.org, keescook@chromium.org,
        rientjes@google.com, hannes@cmpxchg.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, anparri@microsoft.com
Subject: [Resend RFC PATCH V4 10/13] HV/IOMMU: Enable swiotlb bounce buffer for Isolation VM
Date:   Wed,  7 Jul 2021 11:46:24 -0400
Message-Id: <20210707154629.3977369-11-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707154629.3977369-1-ltykernel@gmail.com>
References: <20210707154629.3977369-1-ltykernel@gmail.com>
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

Swiotlb bounce buffer code calls set_memory_decrypted_map()
to mark bounce buffer visible to host and map it in extra
address space.

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
 arch/x86/xen/pci-swiotlb-xen.c |  3 +-
 drivers/hv/vmbus_drv.c         |  3 ++
 drivers/iommu/hyperv-iommu.c   | 62 ++++++++++++++++++++++++++++++++++
 include/linux/hyperv.h         |  1 +
 4 files changed, 68 insertions(+), 1 deletion(-)

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
index e285a220c913..d7ea8e05b991 100644
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
@@ -337,4 +347,56 @@ static const struct irq_domain_ops hyperv_root_ir_domain_ops = {
 	.free = hyperv_root_irq_remapping_free,
 };
 
+void __init hyperv_iommu_swiotlb_init(void)
+{
+	unsigned long bytes;
+	void *vstart;
+
+	/*
+	 * Allocate Hyper-V swiotlb bounce buffer at early place
+	 * to reserve large contiguous memory.
+	 */
+	hyperv_io_tlb_size = 200 * 1024 * 1024;
+	hyperv_io_tlb_start = memblock_alloc_low(PAGE_ALIGN(hyperv_io_tlb_size),
+						 HV_HYP_PAGE_SIZE);
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
+	/*
+	 * Swiotlb bounce buffer needs to be mapped in extra address
+	 * space. Map function doesn't work in the early place and so
+	 * call swiotlb_late_init_with_tbl() here.
+	 */
+	swiotlb_late_init_with_tbl(hyperv_io_tlb_start,
+				   hyperv_io_tlb_size >> IO_TLB_SHIFT);
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

