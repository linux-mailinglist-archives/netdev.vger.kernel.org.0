Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3D345A5D6
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhKWOkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 09:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238252AbhKWOkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 09:40:05 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A479C061714;
        Tue, 23 Nov 2021 06:36:57 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id o14so17235037plg.5;
        Tue, 23 Nov 2021 06:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QpP/dVmOy5UI+0bbwin5PnSriAWO01VAYDyEmLKe5Fk=;
        b=Tns3ImBlGwbXQEnuXBDpy3hfX/I57KzAQqzM3rfc/vmFboVTSl/I6VWtckE0lrNt9f
         9o0hG/IsvIqRXsVDJbm9KcQ491JrNXQNp5gLdD/ePiEHl32ytjY9MFvU/nXa0CKrfIL9
         NhvqWfjcpDbShn56ZLrJVZd0maDUipkSoZtT8lZpz0DsD5IlZB4rsMuH6DkT7kLsWa2T
         qnZHRJS1wKCoPc+cxZhcwYsqCV4QcXrRxBLsG67ibI0aEf+xl101z94jp0ZDHru7b+mC
         LjCXAjCKBarnhztxXaod+KRBPc77VtIyPBL3hDRuKpWjn9GSug0LMVfy7qo5aZN7XV/W
         bC3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QpP/dVmOy5UI+0bbwin5PnSriAWO01VAYDyEmLKe5Fk=;
        b=Ysa5oRXHLTnHGhwRiLibmGvzOjkFceaH9TahBeCOxhdtEQBTQXKYVxzm88N6+rQHvA
         j3hN7YeuMT+qpe0FhQr1RHmUHvpg16PIKdS09AK8j8lroL702WVkU4nQHvVGDvz17B9t
         4FUTOsImgBWf0aUkwvjo1nVrNUR54+Q4DZ1Ei3KeDWS8b1H7x2CRvxpaXL1KE9elhNT2
         phKqz38uGED5gWO2/WX0bADtk1sbjOPKUk+Awm2x45SqE1OIxdxqHQdGGr4r+useuh+M
         Ej2X8ezK3NayDMHFHC9uFdpKB/cQJ/oV1t4yTld79hx/Pm3cUG9Zt4qTDuER/jdviPgw
         4yGw==
X-Gm-Message-State: AOAM530c7a/eIznUqdydwS/xnXU+GbGnejhJbD310qYF475AVNlP3/sE
        7m5nOnh3vQjLc2Ir7LvogKU=
X-Google-Smtp-Source: ABdhPJwD/E686Op6vkRlhXfD+ipZl5W4QS/7JsYfB5j69XU4jttPeJXYmrrgxGuPk3lE+qDj7Iz0QA==
X-Received: by 2002:a17:90a:7086:: with SMTP id g6mr3595594pjk.34.1637678217055;
        Tue, 23 Nov 2021 06:36:57 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:1:af65:c3d4:6df:5a8b])
        by smtp.gmail.com with ESMTPSA id j13sm11926127pfc.151.2021.11.23.06.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 06:36:56 -0800 (PST)
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
Subject: [PATCH V2 2/6] dma-mapping: Add vmap/vunmap_noncontiguous() callback in dma ops
Date:   Tue, 23 Nov 2021 09:30:33 -0500
Message-Id: <20211123143039.331929-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211123143039.331929-1-ltykernel@gmail.com>
References: <20211123143039.331929-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V netvsc driver needs to allocate noncontiguous DMA memory and
remap it into unencrypted address space before sharing with host. Add
vmap/vunmap_noncontiguous() callback and handle the remap in the Hyper-V
dma ops callback.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 include/linux/dma-map-ops.h |  3 +++
 kernel/dma/mapping.c        | 18 ++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 0d5b06b3a4a6..f7b9958ca20a 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -27,6 +27,9 @@ struct dma_map_ops {
 			unsigned long attrs);
 	void (*free_noncontiguous)(struct device *dev, size_t size,
 			struct sg_table *sgt, enum dma_data_direction dir);
+	void *(*vmap_noncontiguous)(struct device *dev, size_t size,
+			struct sg_table *sgt);
+	void (*vunmap_noncontiguous)(struct device *dev, void *addr);
 	int (*mmap)(struct device *, struct vm_area_struct *,
 			void *, dma_addr_t, size_t, unsigned long attrs);
 
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 9478eccd1c8e..7fd751d866cc 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -674,8 +674,14 @@ void *dma_vmap_noncontiguous(struct device *dev, size_t size,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	if (ops && ops->alloc_noncontiguous)
-		return vmap(sgt_handle(sgt)->pages, count, VM_MAP, PAGE_KERNEL);
+	if (ops) {
+		if (ops->vmap_noncontiguous)
+			return ops->vmap_noncontiguous(dev, size, sgt);
+		else if (ops->alloc_noncontiguous)
+			return vmap(sgt_handle(sgt)->pages, count, VM_MAP,
+				    PAGE_KERNEL);
+	}
+
 	return page_address(sg_page(sgt->sgl));
 }
 EXPORT_SYMBOL_GPL(dma_vmap_noncontiguous);
@@ -684,8 +690,12 @@ void dma_vunmap_noncontiguous(struct device *dev, void *vaddr)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
-	if (ops && ops->alloc_noncontiguous)
-		vunmap(vaddr);
+	if (ops) {
+		if (ops->vunmap_noncontiguous)
+			ops->vunmap_noncontiguous(dev, vaddr);
+		else if (ops->alloc_noncontiguous)
+			vunmap(vaddr);
+	}
 }
 EXPORT_SYMBOL_GPL(dma_vunmap_noncontiguous);
 
-- 
2.25.1

