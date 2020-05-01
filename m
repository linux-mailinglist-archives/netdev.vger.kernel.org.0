Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98771C1FF3
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgEAVqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgEAVqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 17:46:37 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2FBC08ED7D
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 14:46:37 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l78so10639924qke.7
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 14:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+uxv+I2/FTJBYBAjECwblv3RDhMku6JWKomQ4Y91nmM=;
        b=H9yanSPsA+U88jyPGN8QJqxFiCaATOffIamOYA9dkOpALy1hywuSZ/TWenPYX8PMNM
         anb/N3lQdk9pZpqEFzxvnRQposoGWTNe67oqlD2iSdC+6gT5Ai5oIfDu499JZ2xx4gJ2
         8nEC/w4qflEzXH2gXnCDZlT8x+T9o8Wm+bh1B4Gi6z2PXKFd645NV8U2jr1SBvcT+Syr
         qgfhJbEVZuEJ0crACS3qw4GXlbnzfp87n1Et9LCoNqbDKdeQi/860Z4b5b8TEHNut7Hs
         oqS7hcuM+ZvTlm7P0vnVfvsby1IK9P5izSHs1fwJ4lDGKQ+TWOC7VXgBkpxF4kTMIMQ3
         BOLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+uxv+I2/FTJBYBAjECwblv3RDhMku6JWKomQ4Y91nmM=;
        b=fP0m0hchiiJ42HXOVDN7ifQ6D2X/cVjacIMobAZy+aBD9uaSLeqnVoNn2fbmDBLzLq
         ztQpxF/3AClrdCwx/Jf0aeeDaHtNG6v6J+DUCMWNOoc01a+fsoPIoneD2tl3LtMWJSmu
         swjGOrQXq9Wv33f0jcM2ggbTloPyX6Lu/0CHYyJtb5hqYMQHN6RxOFCpJOfJqHUDJrdM
         C9fbE67xU3+kWgCKXYj0dtfvD6t700KgJTmqUkggi4Vl0YtBL5jReJinLddDN8PkpXiA
         zncWmlh3H6DT7qWXtSy1M9yw0chNrKmTzO5mKwneth2EKP7kVFUixVHl5bRMV78qYP3p
         Ijxw==
X-Gm-Message-State: AGi0Pub1DQTtBTVKv/+/iGFXbD6in0Zeodutavg+Y5J1BmWuidrpQybd
        Ps+O8+yyrLfDA8IJ9urJ2bsUig==
X-Google-Smtp-Source: APiQypIEH50rTxi7c1REIzQ2SLaIQV+QqAPGJNKDWYIxjk6iX1MKO2VQNt4z85V+Pgl+EVP6OFQfRQ==
X-Received: by 2002:ae9:edce:: with SMTP id c197mr5807335qkg.454.1588369596430;
        Fri, 01 May 2020 14:46:36 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z18sm3470982qti.47.2020.05.01.14.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 14:46:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: ipa: define SMEM memory region for IPA
Date:   Fri,  1 May 2020 16:46:25 -0500
Message-Id: <20200501214625.31539-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200501214625.31539-1-elder@linaro.org>
References: <20200501214625.31539-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arrange to use an item from SMEM memory for IPA.  SMEM item number
497 is designated to be used by the IPA.  Specify the item ID and
size of the region in platform configuration data.  Allocate and get
a pointer to this region from ipa_mem_init().  The memory must be
mapped for access through an SMMU.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h             |   5 ++
 drivers/net/ipa/ipa_data-sc7180.c |   2 +
 drivers/net/ipa/ipa_data-sdm845.c |   2 +
 drivers/net/ipa/ipa_data.h        |   4 ++
 drivers/net/ipa/ipa_mem.c         | 116 ++++++++++++++++++++++++++++++
 5 files changed, 129 insertions(+)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 32f6dfafdb05..b10a85392952 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -49,6 +49,8 @@ struct ipa_interrupt;
  * @mem:		Array of IPA-local memory region descriptors
  * @imem_iova:		I/O virtual address of IPA region in IMEM
  * @imem_size;		Size of IMEM region
+ * @smem_iova:		I/O virtual address of IPA region in SMEM
+ * @smem_size;		Size of SMEM region
  * @zero_addr:		DMA address of preallocated zero-filled memory
  * @zero_virt:		Virtual address of preallocated zero-filled memory
  * @zero_size:		Size (bytes) of preallocated zero-filled memory
@@ -93,6 +95,9 @@ struct ipa {
 	unsigned long imem_iova;
 	size_t imem_size;
 
+	unsigned long smem_iova;
+	size_t smem_size;
+
 	dma_addr_t zero_addr;
 	void *zero_virt;
 	size_t zero_size;
diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index e9007d151c68..43faa35ae726 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -301,6 +301,8 @@ static struct ipa_mem_data ipa_mem_data = {
 	.local		= ipa_mem_local_data,
 	.imem_addr	= 0x146a8000,
 	.imem_size	= 0x00002000,
+	.smem_id	= 497,
+	.smem_size	= 0x00002000,
 };
 
 /* Configuration data for the SC7180 SoC. */
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index c0e207085550..f7ba85717edf 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -323,6 +323,8 @@ static struct ipa_mem_data ipa_mem_data = {
 	.local		= ipa_mem_local_data,
 	.imem_addr	= 0x146bd000,
 	.imem_size	= 0x00002000,
+	.smem_id	= 497,
+	.smem_size	= 0x00002000,
 };
 
 /* Configuration data for the SDM845 SoC. */
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 69957af56ccd..16dfd74717b1 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -250,12 +250,16 @@ struct ipa_resource_data {
  * @local:		array of IPA-local memory region descriptors
  * @imem_addr:		physical address of IPA region within IMEM
  * @imem_size:		size in bytes of IPA IMEM region
+ * @smem_id:		item identifier for IPA region within SMEM memory
+ * @imem_size:		size in bytes of the IPA SMEM region
  */
 struct ipa_mem_data {
 	u32 local_count;
 	const struct ipa_mem *local;
 	u32 imem_addr;
 	u32 imem_size;
+	u32 smem_id;
+	u32 smem_size;
 };
 
 /**
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 3c0916597fe1..aa8f6b0f3d50 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -10,6 +10,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/iommu.h>
 #include <linux/io.h>
+#include <linux/soc/qcom/smem.h>
 
 #include "ipa.h"
 #include "ipa_reg.h"
@@ -23,6 +24,9 @@
 /* "Canary" value placed between memory regions to detect overflow */
 #define IPA_MEM_CANARY_VAL		cpu_to_le32(0xdeadbeef)
 
+/* SMEM host id representing the modem. */
+#define QCOM_SMEM_HOST_MODEM	1
+
 /* Add an immediate command to a transaction that zeroes a memory region */
 static void
 ipa_mem_zero_region_add(struct gsi_trans *trans, const struct ipa_mem *mem)
@@ -340,6 +344,111 @@ static void ipa_imem_exit(struct ipa *ipa)
 	ipa->imem_iova = 0;
 }
 
+/**
+ * ipa_smem_init() - Initialize SMEM memory used by the IPA
+ * @ipa:	IPA pointer
+ * @item:	Item ID of SMEM memory
+ * @size:	Size (bytes) of SMEM memory region
+ *
+ * SMEM is a managed block of shared DRAM, from which numbered "items"
+ * can be allocated.  One item is designated for use by the IPA.
+ *
+ * The modem accesses SMEM memory directly, but the IPA accesses it
+ * via the IOMMU, using the AP's credentials.
+ *
+ * If size provided is non-zero, we allocate it and map it for
+ * access through the IOMMU.
+ *
+ * Note: @size and the item address are is not guaranteed to be page-aligned.
+ */
+static int ipa_smem_init(struct ipa *ipa, u32 item, size_t size)
+{
+	struct device *dev = &ipa->pdev->dev;
+	struct iommu_domain *domain;
+	unsigned long iova;
+	phys_addr_t phys;
+	phys_addr_t addr;
+	size_t actual;
+	void *virt;
+	int ret;
+
+	if (!size)
+		return 0;	/* SMEM memory not used */
+
+	/* SMEM is memory shared between the AP and another system entity
+	 * (in this case, the modem).  An allocation from SMEM is persistent
+	 * until the AP reboots; there is no way to free an allocated SMEM
+	 * region.  Allocation only reserves the space; to use it you need
+	 * to "get" a pointer it (this implies no reference counting).
+	 * The item might have already been allocated, in which case we
+	 * use it unless the size isn't what we expect.
+	 */
+	ret = qcom_smem_alloc(QCOM_SMEM_HOST_MODEM, item, size);
+	if (ret && ret != -EEXIST) {
+		dev_err(dev, "error %d allocating size %zu SMEM item %u\n",
+			ret, size, item);
+		return ret;
+	}
+
+	/* Now get the address of the SMEM memory region */
+	virt = qcom_smem_get(QCOM_SMEM_HOST_MODEM, item, &actual);
+	if (IS_ERR(virt)) {
+		ret = PTR_ERR(virt);
+		dev_err(dev, "error %d getting SMEM item %u\n", ret, item);
+		return ret;
+	}
+
+	/* In case the region was already allocated, verify the size */
+	if (ret && actual != size) {
+		dev_err(dev, "SMEM item %u has size %zu, expected %zu\n",
+			item, actual, size);
+		return -EINVAL;
+	}
+
+	domain = iommu_get_domain_for_dev(dev);
+	if (!domain) {
+		dev_err(dev, "no IOMMU domain found for SMEM\n");
+		return -EINVAL;
+	}
+
+	/* Align the address down and the size up to a page boundary */
+	addr = qcom_smem_virt_to_phys(virt) & PAGE_MASK;
+	phys = addr & PAGE_MASK;
+	size = PAGE_ALIGN(size + addr - phys);
+	iova = phys;	/* We just want a direct mapping */
+
+	ret = iommu_map(domain, iova, phys, size, IOMMU_READ | IOMMU_WRITE);
+	if (ret)
+		return ret;
+
+	ipa->smem_iova = iova;
+	ipa->smem_size = size;
+
+	return 0;
+}
+
+static void ipa_smem_exit(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+	struct iommu_domain *domain;
+
+	domain = iommu_get_domain_for_dev(dev);
+	if (domain) {
+		size_t size;
+
+		size = iommu_unmap(domain, ipa->smem_iova, ipa->smem_size);
+		if (size != ipa->smem_size)
+			dev_warn(dev, "unmapped %zu SMEM bytes, expected %lu\n",
+				 size, ipa->smem_size);
+
+	} else {
+		dev_err(dev, "couldn't get IPA IOMMU domain for SMEM\n");
+	}
+
+	ipa->smem_size = 0;
+	ipa->smem_iova = 0;
+}
+
 /* Perform memory region-related initialization */
 int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 {
@@ -383,8 +492,14 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	if (ret)
 		goto err_unmap;
 
+	ret = ipa_smem_init(ipa, mem_data->smem_id, mem_data->smem_size);
+	if (ret)
+		goto err_imem_exit;
+
 	return 0;
 
+err_imem_exit:
+	ipa_imem_exit(ipa);
 err_unmap:
 	memunmap(ipa->mem_virt);
 
@@ -394,6 +509,7 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 /* Inverse of ipa_mem_init() */
 void ipa_mem_exit(struct ipa *ipa)
 {
+	ipa_smem_exit(ipa);
 	ipa_imem_exit(ipa);
 	memunmap(ipa->mem_virt);
 }
-- 
2.20.1

