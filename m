Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50553E0802
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 20:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240558AbhHDSqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 14:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbhHDSqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 14:46:02 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C246C0613D5;
        Wed,  4 Aug 2021 11:45:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a8so4332077pjk.4;
        Wed, 04 Aug 2021 11:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fRYEBTeqaJZ2nuhpRxylpNXV0HYL+RYR+rak5A96Ekw=;
        b=HTvCf728VbK4Su+bqKQH5oArAC9CXG5wpGLFMSbncBntCgAQZWEvfSseixDyYpT0AX
         k9LEBLAGDciL3AkfAFjP2TMACFh9KnhSAvgcNxNSbCla6/IOSYzNFr/e7x8x1dA8GKM1
         syxdGLXhzA7Yrkb5n60T/FhE0Ane5iRjsMioCojKjFQvuLjDHt/kh4Ojc+dT+/hZ62hQ
         eajl/gHvZ4PkjPMxeIMhGfhbbVS0oRkzVNysDwpDt55LL/DMHpDe8IHdrR6x1E046GaX
         csC0M9+AoIdiTpE1PkZmn5vuYvjCxfjcjVChflIVOTKbc5qRk+l2hywKeYO/CovBlFqm
         Ha8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fRYEBTeqaJZ2nuhpRxylpNXV0HYL+RYR+rak5A96Ekw=;
        b=emIBmm/nUVchBNhh2oXk4Ohr7GGUHBX5NQuZ65uyPoKfSTlocdr8B0jN16VS+Y2wqP
         HIIlq9zdSCkel4RhLTx45I+VxsZQU4qh7PSWtiavyXb12SZ9gZFbmOfgRvzyPSvPRuuj
         YknSGK9hl7skEh943KIaW5QGnkMKcRhmrzXsx4/dJvvpS4ReWKAB/4qw2BVqs0mf8Cjx
         KG3kQBXi9CwxsSqYv8XegI/+XDZvcSp2YO2qE+oHf88M09unDpLN0hptbu1JN9pAY1cM
         f9LT71D9A69zIS1ZIFqrqA1uLyQBTNnfIWwlu16u5BVuIaBUlEp0epeGRpjRpsaJnxLm
         wKog==
X-Gm-Message-State: AOAM533yL2KpDcVwHuuWSk1SnIIezg5ulsHVaHt+rmNCrEaiVu1AkEco
        YiDaLQA1kaDRAG1K20lCD38=
X-Google-Smtp-Source: ABdhPJwzrx3Ky34YWQf0IrpQZJYUXOTY9aTHTgMpl2ZF/5vkCRfVy6oUSbAdimtL8DDIxrPWPusxTg==
X-Received: by 2002:a17:90a:2fc2:: with SMTP id n2mr513781pjm.112.1628102748897;
        Wed, 04 Aug 2021 11:45:48 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:f:1947:6842:b8a8:6f83])
        by smtp.gmail.com with ESMTPSA id f5sm3325647pjo.23.2021.08.04.11.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 11:45:48 -0700 (PDT)
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
        Tianyu.Lan@microsoft.com, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com, pgonda@google.com,
        david@redhat.com, krish.sadhukhan@oracle.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, xen-devel@lists.xenproject.org,
        martin.b.radev@gmail.com, ardb@kernel.org, rientjes@google.com,
        tj@kernel.org, keescook@chromium.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com
Subject: [PATCH V2 10/14] DMA: Add dma_map_decrypted/dma_unmap_encrypted() function
Date:   Wed,  4 Aug 2021 14:45:06 -0400
Message-Id: <20210804184513.512888-11-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804184513.512888-1-ltykernel@gmail.com>
References: <20210804184513.512888-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

In Hyper-V Isolation VM with AMD SEV, swiotlb boucne buffer
needs to be mapped into address space above vTOM and so
introduce dma_map_decrypted/dma_unmap_encrypted() to map/unmap
bounce buffer memory. The platform can populate man/unmap callback
in the dma memory decrypted ops.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 include/linux/dma-map-ops.h |  9 +++++++++
 kernel/dma/mapping.c        | 22 ++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 0d53a96a3d64..01d60a024e45 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -71,6 +71,11 @@ struct dma_map_ops {
 	unsigned long (*get_merge_boundary)(struct device *dev);
 };
 
+struct dma_memory_decrypted_ops {
+	void *(*map)(void *addr, unsigned long size);
+	void (*unmap)(void *addr);
+};
+
 #ifdef CONFIG_DMA_OPS
 #include <asm/dma-mapping.h>
 
@@ -374,6 +379,10 @@ static inline void debug_dma_dump_mappings(struct device *dev)
 }
 #endif /* CONFIG_DMA_API_DEBUG */
 
+void *dma_map_decrypted(void *addr, unsigned long size);
+int dma_unmap_decrypted(void *addr, unsigned long size);
+
 extern const struct dma_map_ops dma_dummy_ops;
+extern struct dma_memory_decrypted_ops dma_memory_generic_decrypted_ops;
 
 #endif /* _LINUX_DMA_MAP_OPS_H */
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 2b06a809d0b9..6fb150dc1750 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -13,11 +13,13 @@
 #include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <asm/set_memory.h>
 #include "debug.h"
 #include "direct.h"
 
 bool dma_default_coherent;
 
+struct dma_memory_decrypted_ops dma_memory_generic_decrypted_ops;
 /*
  * Managed DMA API
  */
@@ -736,3 +738,23 @@ unsigned long dma_get_merge_boundary(struct device *dev)
 	return ops->get_merge_boundary(dev);
 }
 EXPORT_SYMBOL_GPL(dma_get_merge_boundary);
+
+void *dma_map_decrypted(void *addr, unsigned long size)
+{
+	if (set_memory_decrypted((unsigned long)addr,
+				 size / PAGE_SIZE))
+		return NULL;
+
+	if (dma_memory_generic_decrypted_ops.map)
+		return dma_memory_generic_decrypted_ops.map(addr, size);
+	else
+		return addr;
+}
+
+int dma_unmap_encrypted(void *addr, unsigned long size)
+{
+	if (dma_memory_generic_decrypted_ops.unmap)
+		dma_memory_generic_decrypted_ops.unmap(addr);
+
+	return set_memory_encrypted((unsigned long)addr, size / PAGE_SIZE);
+}
-- 
2.25.1

