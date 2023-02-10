Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A57969268C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbjBJThT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbjBJThN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:37:13 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D6D61D0D
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:03 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id m15so2631094ilh.9
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q71kN7DKuvE5v7PX+0KQ0YA3932U6ixJa8pWY1BA5+0=;
        b=jB7lvO8z9a0JJ3/7NUYBFScQqTBsgmFRDII1bc8vlVZT0Z6MCF+iS83nZ5t75qXLx6
         q1+CWbtezq9tSvvDhe3F/400fkJ12cPQ+i84olM0eugRoUHyms+gj0yuv8Wf/L3N5iW4
         USnM7DCcOtG/eiOkQ1X5780rWJma0wPTSDx9YMWX7GoPm2sn00O/h0JOkA9Ji0+Qe8BD
         C7g1dcykaHPuXzBRyQ9OIR52UfC7pq3sRTufB+R/mtxUppYY811ZjAFZ1j+MgKcmeCzi
         dk5wB1lUVJZtGMRDCDSUWaeJm3DIEBzzzsGxJVTNLoh0VJhPAIpozDa7mFiKJzRrbkt+
         7XDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q71kN7DKuvE5v7PX+0KQ0YA3932U6ixJa8pWY1BA5+0=;
        b=s0g4Aav3uh1PyH/0KZtOTtpNVSZZcl3d0urKlVO+58L3Sr7JsgwGpDdSBfHVyILtrF
         J34QiluDK+hTOQQ+dYmIBaBEVoTWUOTikZp2wsfzzkNRVnCF4b41ur8szCsyBhNviqa6
         eVwoSDluZj6klqXWlpg9gypGa1pyNoA/1CYZW7SN+mE/vLx30n+gsRjnOyxl/ddEmXFG
         lREwWhPAyD+tPovkYY/sYRedbs8Rmuk8rDE5AZ84s8TisjH6Z+XsIGA2f0ow0RKgc9ON
         FGnd8ATsOFBw/vmfRbXkmIvUwxrfZ/Q2WVxYjNDcyTWK/v9WvwJP8B7FP6IZf82mNlh2
         6xFw==
X-Gm-Message-State: AO0yUKWdssw8wTVv24pV/JJhDiASVx927O5WWZrQ3C+jxHFqNoeNHuoM
        GlhTxhxNpIT9YYVbPE4ZSUjkuQ==
X-Google-Smtp-Source: AK7set/hISm5O0da5KI3k1dvKSNeBnsj5pfKVrNTR4V6mvw4B04G9QJpNRDdYrLHSkRdLwN4Bx5EWA==
X-Received: by 2002:a92:6d05:0:b0:314:1d62:25cc with SMTP id i5-20020a926d05000000b003141d6225ccmr2201115ilc.0.1676057822479;
        Fri, 10 Feb 2023 11:37:02 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id 14-20020a056e020cae00b00304ae88ebebsm1530692ilg.88.2023.02.10.11.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:37:02 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/8] net: ipa: introduce gsi_reg_init()
Date:   Fri, 10 Feb 2023 13:36:48 -0600
Message-Id: <20230210193655.460225-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210193655.460225-1-elder@linaro.org>
References: <20230210193655.460225-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new source file "gsi_reg.c", and in it, introduce a new
function to encapsulate initializing GSI registers, including
looking up and I/O mapping their memory.

Create gsi_reg_exit() as the inverse of the init function.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile  |  4 +--
 drivers/net/ipa/gsi.c     | 52 ++++++----------------------
 drivers/net/ipa/gsi_reg.c | 71 +++++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/gsi_reg.h | 35 ++++++++++---------
 4 files changed, 103 insertions(+), 59 deletions(-)
 create mode 100644 drivers/net/ipa/gsi_reg.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 8cdcaaf58ae34..166ef86f7ad3f 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -7,8 +7,8 @@ IPA_VERSIONS		:=	3.1 3.5.1 4.2 4.5 4.7 4.9 4.11
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
 ipa-y			:=	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o \
-				ipa_table.o ipa_interrupt.o gsi.o gsi_trans.o \
-				ipa_gsi.o ipa_smp2p.o ipa_uc.o \
+				ipa_table.o ipa_interrupt.o gsi.o gsi_reg.o \
+				gsi_trans.o ipa_gsi.o ipa_smp2p.o ipa_uc.o \
 				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o \
 				ipa_sysfs.o
diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 2cb1710f6ac3f..a000bef49f8e5 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2022 Linaro Ltd.
+ * Copyright (C) 2018-2023 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -2241,67 +2241,37 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 	     enum ipa_version version, u32 count,
 	     const struct ipa_gsi_endpoint_data *data)
 {
-	struct device *dev = &pdev->dev;
-	struct resource *res;
-	resource_size_t size;
-	u32 adjust;
 	int ret;
 
 	gsi_validate_build();
 
-	gsi->dev = dev;
+	gsi->dev = &pdev->dev;
 	gsi->version = version;
 
 	/* GSI uses NAPI on all channels.  Create a dummy network device
 	 * for the channel NAPI contexts to be associated with.
 	 */
 	init_dummy_netdev(&gsi->dummy_dev);
-
-	/* Get GSI memory range and map it */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsi");
-	if (!res) {
-		dev_err(dev, "DT error getting \"gsi\" memory property\n");
-		return -ENODEV;
-	}
-
-	size = resource_size(res);
-	if (res->start > U32_MAX || size > U32_MAX - res->start) {
-		dev_err(dev, "DT memory resource \"gsi\" out of range\n");
-		return -EINVAL;
-	}
-
-	/* Make sure we can make our pointer adjustment if necessary */
-	adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
-	if (res->start < adjust) {
-		dev_err(dev, "DT memory resource \"gsi\" too low (< %u)\n",
-			adjust);
-		return -EINVAL;
-	}
-
-	gsi->virt_raw = ioremap(res->start, size);
-	if (!gsi->virt_raw) {
-		dev_err(dev, "unable to remap \"gsi\" memory\n");
-		return -ENOMEM;
-	}
-	/* Most registers are accessed using an adjusted register range */
-	gsi->virt = gsi->virt_raw - adjust;
-
 	init_completion(&gsi->completion);
 
+	ret = gsi_reg_init(gsi, pdev);
+	if (ret)
+		return ret;
+
 	ret = gsi_irq_init(gsi, pdev);	/* No matching exit required */
 	if (ret)
-		goto err_iounmap;
+		goto err_reg_exit;
 
 	ret = gsi_channel_init(gsi, count, data);
 	if (ret)
-		goto err_iounmap;
+		goto err_reg_exit;
 
 	mutex_init(&gsi->mutex);
 
 	return 0;
 
-err_iounmap:
-	iounmap(gsi->virt_raw);
+err_reg_exit:
+	gsi_reg_exit(gsi);
 
 	return ret;
 }
@@ -2311,7 +2281,7 @@ void gsi_exit(struct gsi *gsi)
 {
 	mutex_destroy(&gsi->mutex);
 	gsi_channel_exit(gsi);
-	iounmap(gsi->virt_raw);
+	gsi_reg_exit(gsi);
 }
 
 /* The maximum number of outstanding TREs on a channel.  This limits
diff --git a/drivers/net/ipa/gsi_reg.c b/drivers/net/ipa/gsi_reg.c
new file mode 100644
index 0000000000000..48f81fc24f39d
--- /dev/null
+++ b/drivers/net/ipa/gsi_reg.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2023 Linaro Ltd. */
+
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+#include "gsi.h"
+#include "gsi_reg.h"
+
+/* GSI EE registers as a group are shifted downward by a fixed constant amount
+ * for IPA versions 4.5 and beyond.  This applies to all GSI registers we use
+ * *except* the ones that disable inter-EE interrupts for channels and event
+ * channels.
+ *
+ * The "raw" (not adjusted) GSI register range is mapped, and a pointer to
+ * the mapped range is held in gsi->virt_raw.  The inter-EE interrupt
+ * registers are accessed using that pointer.
+ *
+ * Most registers are accessed using gsi->virt, which is a copy of the "raw"
+ * pointer, adjusted downward by the fixed amount.
+ */
+#define GSI_EE_REG_ADJUST	0x0000d000			/* IPA v4.5+ */
+
+/* Sets gsi->virt_raw and gsi->virt, and I/O maps the "gsi" memory range */
+int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	resource_size_t size;
+	u32 adjust;
+
+	/* Get GSI memory range and map it */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsi");
+	if (!res) {
+		dev_err(dev, "DT error getting \"gsi\" memory property\n");
+		return -ENODEV;
+	}
+
+	size = resource_size(res);
+	if (res->start > U32_MAX || size > U32_MAX - res->start) {
+		dev_err(dev, "DT memory resource \"gsi\" out of range\n");
+		return -EINVAL;
+	}
+
+	/* Make sure we can make our pointer adjustment if necessary */
+	adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
+	if (res->start < adjust) {
+		dev_err(dev, "DT memory resource \"gsi\" too low (< %u)\n",
+			adjust);
+		return -EINVAL;
+	}
+
+	gsi->virt_raw = ioremap(res->start, size);
+	if (!gsi->virt_raw) {
+		dev_err(dev, "unable to remap \"gsi\" memory\n");
+		return -ENOMEM;
+	}
+	/* Most registers are accessed using an adjusted register range */
+	gsi->virt = gsi->virt_raw - adjust;
+
+	return 0;
+}
+
+/* Inverse of gsi_reg_init() */
+void gsi_reg_exit(struct gsi *gsi)
+{
+	gsi->virt = NULL;
+	iounmap(gsi->virt_raw);
+	gsi->virt_raw = NULL;
+}
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index d171f65d41983..60071b6a4d32e 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -1,12 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2022 Linaro Ltd.
+ * Copyright (C) 2018-2023 Linaro Ltd.
  */
 #ifndef _GSI_REG_H_
 #define _GSI_REG_H_
 
-/* === Only "gsi.c" should include this file === */
+/* === Only "gsi.c" and "gsi_reg.c" should include this file === */
 
 #include <linux/bits.h>
 
@@ -38,20 +38,6 @@
  * (though the actual limit is hardware-dependent).
  */
 
-/* GSI EE registers as a group are shifted downward by a fixed constant amount
- * for IPA versions 4.5 and beyond.  This applies to all GSI registers we use
- * *except* the ones that disable inter-EE interrupts for channels and event
- * channels.
- *
- * The "raw" (not adjusted) GSI register range is mapped, and a pointer to
- * the mapped range is held in gsi->virt_raw.  The inter-EE interrupt
- * registers are accessed using that pointer.
- *
- * Most registers are accessed using gsi->virt, which is a copy of the "raw"
- * pointer, adjusted downward by the fixed amount.
- */
-#define GSI_EE_REG_ADJUST			0x0000d000	/* IPA v4.5+ */
-
 /* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
 
 #define GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET \
@@ -400,4 +386,21 @@ enum gsi_generic_ee_result {
 	GENERIC_EE_NO_RESOURCES			= 0x7,
 };
 
+/**
+ * gsi_reg_init() - Perform GSI register initialization
+ * @gsi:	GSI pointer
+ * @pdev:	GSI (IPA) platform device
+ *
+ * Initialize GSI registers, including looking up and I/O mapping
+ * the "gsi" memory space.  This function sets gsi->virt_raw and
+ * gsi->virt.
+ */
+int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev);
+
+/**
+ * gsi_reg_exit() - Inverse of gsi_reg_init()
+ * @gsi:	GSI pointer
+ */
+void gsi_reg_exit(struct gsi *gsi);
+
 #endif	/* _GSI_REG_H_ */
-- 
2.34.1

