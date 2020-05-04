Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12791C4593
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732376AbgEDSPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730720AbgEDR7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:59:13 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2825FC0610D6
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:59:11 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id t8so99998qvw.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8gxTSUogDwuGLJulsmZ9RxF75CEfaqEdykWJgqsyHRs=;
        b=OwZdX3Txd5nO1MJ8o7w20jwhXHetRlVr8p7/VGHyslIBBaeEF7sceCz68NtQQ89+Cr
         lhXLQ5mfhmohwoD/EmcLUx/FSsIQx92OL9Q0kR759CbaR1Qu/MNxLsoFvCf1RVDU2sIh
         Ea41bkZzHr0bxJejmL2UG7CJbuQl1I8w6sC151Gp3UH6x/0eWdzf2KiRgq605Mhadk02
         cuHz1I4exDdbSCnE3WaRqVfblXSi96CdvH6UQrWRvIWgpr5IO9R8RQkbdTn8tvISXF1p
         djDHF99CDnVRCzcLY4wCMkKi53ywORMqvsouKLbEo4YZtgnvx1iI2JJgczPDS7AAVQnv
         4YAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8gxTSUogDwuGLJulsmZ9RxF75CEfaqEdykWJgqsyHRs=;
        b=JUHuYehUrquQMN5AP1v+b3vtzsyWR9uAX/e5DhTGX+ZOgMwdoS7bj7kcP73VQlubaQ
         KENNPUoRqwc9g2My9Zrp8Y57WVjehp8jUMUePIMZMvJVvannJOlcoOcDVAcNopDRPvyD
         d8sscVOn5h3+avQX3guTlin1tWpctEP74x2LI/4o66PVN0+RDlI/3gZbDxkSB8rLyr+G
         SNckKzFycC3OGO+GBgXkNdyHbWZEbhB3uRGfmOm+JUwqDzsR3R2ydQzD462U21sb7Pl+
         rhT1XzgY8N+wC4iSbFW1jZavH36bHJUt9zWkakoUWQF1P1qnMTx2gdfmMH0q8zrpIjft
         +Sbg==
X-Gm-Message-State: AGi0PuYdSV3wZW6VF+K+Qe+MRkKOUhVd60FgD0rNjmm79J/h5bWWHc3D
        Gu2D7BwjnDA5mOjMMhvbq3SxgA0DoI0=
X-Google-Smtp-Source: APiQypJJlTfHZSWjQgiuQR2FVZJgBO7pVAzG4ZkwpIMBMU8ZxPIJg4YBiCxzNzaXyVvJ3r0OQfOy0g==
X-Received: by 2002:ad4:5a06:: with SMTP id ei6mr329705qvb.70.1588615150228;
        Mon, 04 May 2020 10:59:10 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h19sm11271088qtk.78.2020.05.04.10.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 10:59:09 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/4] net: ipa: redefine struct ipa_mem_data
Date:   Mon,  4 May 2020 12:58:57 -0500
Message-Id: <20200504175859.22606-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504175859.22606-1-elder@linaro.org>
References: <20200504175859.22606-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ipa_mem_data structure type was never actually used.  Instead,
the IPA memory regions were defined using the ipa_mem structure.

Redefine struct ipa_mem_data so it encapsulates the array of IPA-local
memory region descriptors along with the count of entries in that
array.  Pass just an ipa_mem structure pointer to ipa_mem_init().

Rename the ipa_mem_data[] array ipa_mem_local_data[] to emphasize
that the memory regions it defines are IPA-local memory.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 10 +++++++---
 drivers/net/ipa/ipa_data-sdm845.c | 10 +++++++---
 drivers/net/ipa/ipa_data.h        | 13 +++++--------
 drivers/net/ipa/ipa_main.c        |  2 +-
 drivers/net/ipa/ipa_mem.c         |  9 +++++----
 drivers/net/ipa/ipa_mem.h         |  3 ++-
 6 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 042b5fc3c135..f97e7e4e61c1 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -193,7 +193,7 @@ static const struct ipa_resource_data ipa_resource_data = {
 };
 
 /* IPA-resident memory region configuration for the SC7180 SoC. */
-static const struct ipa_mem ipa_mem_data[] = {
+static const struct ipa_mem ipa_mem_local_data[] = {
 	[IPA_MEM_UC_SHARED] = {
 		.offset		= 0x0000,
 		.size		= 0x0080,
@@ -296,12 +296,16 @@ static const struct ipa_mem ipa_mem_data[] = {
 	},
 };
 
+static struct ipa_mem_data ipa_mem_data = {
+	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
+	.local		= ipa_mem_local_data,
+};
+
 /* Configuration data for the SC7180 SoC. */
 const struct ipa_data ipa_data_sc7180 = {
 	.version	= IPA_VERSION_4_2,
 	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
-	.mem_count	= ARRAY_SIZE(ipa_mem_data),
-	.mem_data	= ipa_mem_data,
+	.mem_data	= &ipa_mem_data,
 };
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 0d9c36e1e806..c55507e94559 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -235,7 +235,7 @@ static const struct ipa_resource_data ipa_resource_data = {
 };
 
 /* IPA-resident memory region configuration for the SDM845 SoC. */
-static const struct ipa_mem ipa_mem_data[] = {
+static const struct ipa_mem ipa_mem_local_data[] = {
 	[IPA_MEM_UC_SHARED] = {
 		.offset		= 0x0000,
 		.size		= 0x0080,
@@ -318,12 +318,16 @@ static const struct ipa_mem ipa_mem_data[] = {
 	},
 };
 
+static struct ipa_mem_data ipa_mem_data = {
+	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
+	.local		= ipa_mem_local_data,
+};
+
 /* Configuration data for the SDM845 SoC. */
 const struct ipa_data ipa_data_sdm845 = {
 	.version	= IPA_VERSION_3_5_1,
 	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
-	.mem_count	= ARRAY_SIZE(ipa_mem_data),
-	.mem_data	= ipa_mem_data,
+	.mem_data	= &ipa_mem_data,
 };
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 7110de2de817..51d8e5a6f23a 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -246,14 +246,12 @@ struct ipa_resource_data {
 
 /**
  * struct ipa_mem - IPA-local memory region description
- * @offset:		offset in IPA memory space to base of the region
- * @size:		size in bytes base of the region
- * @canary_count:	number of 32-bit "canary" values that precede region
+ * @local_count:	number of regions defined in the local[] array
+ * @local:		array of IPA-local memory region descriptors
  */
 struct ipa_mem_data {
-	u32 offset;
-	u16 size;
-	u16 canary_count;
+	u32 local_count;
+	const struct ipa_mem *local;
 };
 
 /**
@@ -270,8 +268,7 @@ struct ipa_data {
 	u32 endpoint_count;	/* # entries in endpoint_data[] */
 	const struct ipa_gsi_endpoint_data *endpoint_data;
 	const struct ipa_resource_data *resource_data;
-	u32 mem_count;		/* # entries in mem_data[] */
-	const struct ipa_mem *mem_data;
+	const struct ipa_mem_data *mem_data;
 };
 
 extern const struct ipa_data ipa_data_sdm845;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 28998dcce3d2..9295a9122e8e 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -778,7 +778,7 @@ static int ipa_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_kfree_ipa;
 
-	ret = ipa_mem_init(ipa, data->mem_count, data->mem_data);
+	ret = ipa_mem_init(ipa, data->mem_data);
 	if (ret)
 		goto err_reg_exit;
 
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 42d2c29d9f0c..fb4de2a12796 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -12,6 +12,7 @@
 
 #include "ipa.h"
 #include "ipa_reg.h"
+#include "ipa_data.h"
 #include "ipa_cmd.h"
 #include "ipa_mem.h"
 #include "ipa_data.h"
@@ -266,15 +267,15 @@ int ipa_mem_zero_modem(struct ipa *ipa)
 }
 
 /* Perform memory region-related initialization */
-int ipa_mem_init(struct ipa *ipa, u32 count, const struct ipa_mem *mem)
+int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 {
 	struct device *dev = &ipa->pdev->dev;
 	struct resource *res;
 	int ret;
 
-	if (count > IPA_MEM_COUNT) {
+	if (mem_data->local_count > IPA_MEM_COUNT) {
 		dev_err(dev, "to many memory regions (%u > %u)\n",
-			count, IPA_MEM_COUNT);
+			mem_data->local_count, IPA_MEM_COUNT);
 		return -EINVAL;
 	}
 
@@ -302,7 +303,7 @@ int ipa_mem_init(struct ipa *ipa, u32 count, const struct ipa_mem *mem)
 	ipa->mem_size = resource_size(res);
 
 	/* The ipa->mem[] array is indexed by enum ipa_mem_id values */
-	ipa->mem = mem;
+	ipa->mem = mem_data->local;
 
 	return 0;
 }
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
index 065cb499ebe5..f99180f84f0d 100644
--- a/drivers/net/ipa/ipa_mem.h
+++ b/drivers/net/ipa/ipa_mem.h
@@ -7,6 +7,7 @@
 #define _IPA_MEM_H_
 
 struct ipa;
+struct ipa_mem_data;
 
 /**
  * DOC: IPA Local Memory
@@ -84,7 +85,7 @@ void ipa_mem_teardown(struct ipa *ipa);
 
 int ipa_mem_zero_modem(struct ipa *ipa);
 
-int ipa_mem_init(struct ipa *ipa, u32 count, const struct ipa_mem *mem);
+int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data);
 void ipa_mem_exit(struct ipa *ipa);
 
 #endif /* _IPA_MEM_H_ */
-- 
2.20.1

