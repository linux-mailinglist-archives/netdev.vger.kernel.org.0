Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EA3468A06
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhLEIWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbhLEIVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:21:49 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1101C061751;
        Sun,  5 Dec 2021 00:18:22 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s137so7423213pgs.5;
        Sun, 05 Dec 2021 00:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HEtQ2VgG/AmO4M2o0U/qmYacDg8cWHw/nJTaFUeWEoM=;
        b=qVZeIp4wgKkg5FZMbPln6Q/k5s4EHMptgSE2q5o2Xt4yqRYPYjNg7ie0xdW0nU9pK3
         EUPzswRFN0nOeut8n+3r/e0zksf/HiSEBtBx9sn7LR7AgOoxN7xP6SbnHLmWjDcawUWf
         jivfnKtLrjpcSCl9pE113Any9Pq+pa4y9vDbCp+72hnYT17zr/DO7aqWlmnAZjsV9COL
         rKWIGdD84O/9Ch/nucGUpRkDiPhw6cJlPuNmBx1VMYhoKhOTKm0A7D6au5Eoumm4sqxd
         mpOLxi2IMNgtgXsv9pyUZ3m8W2OGNM46u91gZ5lcUWV/daJknoScyM1JyagbFjwbAtVK
         krGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HEtQ2VgG/AmO4M2o0U/qmYacDg8cWHw/nJTaFUeWEoM=;
        b=NpoQzROYwD9jygUlQ2T3MP/NCbzKwDsZfGi2GcTlcY4imBgZwovR4a5ZPloo+UBKKT
         7jLMGqAPP+qAVExmqw9iEulbOvIfr2K5nXaPVUvhsIGZwvVYW/LIaFtL3P87H7J09Rfh
         5Sj6wJ6FzBVIOnX2yCSE0Xc+g4EfC4yNZoXZQDxyqrMZZaBBLVn+ClboM8bdRXvmXIyB
         qRwgQXXb1h05Qa0T6CN65EgC0ymH9VnRRGh01BCYgSxMspe3ykexfc2EkK8VXFVZ7CkY
         jhr1kbD0WtUIWL3tyKZ1SiBDYvykgGlLzk8Hd2TC58+/P/wlbTTpKScJ8iE38U9tkCb4
         +Vrw==
X-Gm-Message-State: AOAM533PeWgm5wAcJI+IzPgDOCwjFb17M7vJlGJJIydW+JYWBBdigqmS
        WBpdd3yAnFoqIPlDxBhujwU=
X-Google-Smtp-Source: ABdhPJxDrjBlMEFOekoi/ebwbSRvDUyUkIlPU98qCt8JNd3nV7P8t6G2JhmCP59zVAcQ4e+N2RRH4w==
X-Received: by 2002:a05:6a00:a94:b0:44c:ecb2:6018 with SMTP id b20-20020a056a000a9400b0044cecb26018mr29289107pfl.57.1638692302327;
        Sun, 05 Dec 2021 00:18:22 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:7:87aa:e334:f070:ebca])
        by smtp.gmail.com with ESMTPSA id s8sm6439905pgl.77.2021.12.05.00.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 00:18:22 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V4 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for Isolation VM
Date:   Sun,  5 Dec 2021 03:18:11 -0500
Message-Id: <20211205081815.129276-4-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205081815.129276-1-ltykernel@gmail.com>
References: <20211205081815.129276-1-ltykernel@gmail.com>
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

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v3:
	* Add comment in pci-swiotlb-xen.c to explain why add
	  dependency between hyperv_swiotlb_detect() and pci_
	  xen_swiotlb_detect().
	* Return directly when fails to allocate Hyper-V swiotlb
	  buffer in the hyperv_iommu_swiotlb_init().
---
 arch/x86/xen/pci-swiotlb-xen.c | 12 ++++++-
 drivers/hv/vmbus_drv.c         |  3 ++
 drivers/iommu/hyperv-iommu.c   | 58 ++++++++++++++++++++++++++++++++++
 include/linux/hyperv.h         |  8 +++++
 4 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index 46df59aeaa06..8e2ee3ce6374 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -4,6 +4,7 @@
 
 #include <linux/dma-map-ops.h>
 #include <linux/pci.h>
+#include <linux/hyperv.h>
 #include <xen/swiotlb-xen.h>
 
 #include <asm/xen/hypervisor.h>
@@ -90,7 +91,16 @@ int pci_xen_swiotlb_init_late(void)
 }
 EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
 
+/*
+ * Hyper-V initalizes swiotlb bounce buffer and default swiotlb
+ * needs to be disabled. pci_swiotlb_detect_override() and
+ * pci_swiotlb_detect_4gb() enable the default one. To override
+ * the setting, hyperv_swiotlb_detect() needs to run before
+ * these detect functions which depends on the pci_xen_swiotlb_
+ * init(). Make pci_xen_swiotlb_init() depends on the hyperv_swiotlb
+ * _detect() to keep the order.
+ */
 IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
-		  NULL,
+		  hyperv_swiotlb_detect,
 		  pci_xen_swiotlb_init,
 		  NULL);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 392c1ac4f819..0a64ccfafb8b 100644
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
@@ -2118,6 +2120,7 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	}
 	hv_debug_add_dev_dir(child_device_obj);
 
+	child_device_obj->device.dma_mask = &vmbus_dma_mask;
 	return 0;
 
 err_kset_unregister:
diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index e285a220c913..44ba24d9e06c 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -13,14 +13,20 @@
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
+#include <linux/dma-direct.h>
 
 #include "irq_remapping.h"
 
@@ -337,4 +343,56 @@ static const struct irq_domain_ops hyperv_root_ir_domain_ops = {
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
+	if (!hyperv_io_tlb_start) {
+		pr_warn("Fail to allocate Hyper-V swiotlb buffer.\n");
+		return;
+	}
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
 #endif
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index b823311eac79..1f037e114dc8 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1726,6 +1726,14 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
 int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
 				void (*block_invalidate)(void *context,
 							 u64 block_mask));
+#if IS_ENABLED(CONFIG_HYPERV)
+int __init hyperv_swiotlb_detect(void);
+#else
+static inline int __init hyperv_swiotlb_detect(void)
+{
+	return 0;
+}
+#endif
 
 struct hyperv_pci_block_ops {
 	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
-- 
2.25.1

