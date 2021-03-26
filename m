Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A08C34AB09
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhCZPMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhCZPL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:11:28 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29361C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:28 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id k25so5721559iob.6
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CI0IEbIt6ADsRK1kKMJEBC+VlvOpAHtt8wXdX5zUKRQ=;
        b=e0J7xi787wtjkUZFZF7HeTkFylJT66bACTOOdgcHsY9zlcA59eTomwnpSXVC87TYPF
         FYs4YtFpTrdUu9Kpga6/SG+fe6CwqIfLVg/7l9yV/nYykhF2PorfJKugYojfokCmmynQ
         blrkDPgVeNWuKeMThD23KL7XGl8i/pksR16wTQWzKUGQlhyigM29DwJgfrzqlUYP/dIQ
         c2ikb29GXCrU/h1qRnnBKbnNoL9nAOzDC6fqATxgDHGAgNm4JRgdVAt92/xHLzjKmrWU
         7SOhBeckkWD3zrWVgNdR/h1j7MMUyRbRxakuoQgr3lZ46o4lUGPJOGvizxHx4k8keMok
         l8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CI0IEbIt6ADsRK1kKMJEBC+VlvOpAHtt8wXdX5zUKRQ=;
        b=LhzTOBeSHyrAXg0ku2nW7RORpvM1BBy0DsTuZSGfyulSVHeleO/Gj/eQobNEuBFxl2
         iEjuyZ+5yU13ZGXAoYrx/OkHi2pb6fjjDTkphz1MkYBLJesyVE3ru01N7jysmErokRBM
         OLDSUC6XxZyoGRF4JuLwsPAQFoC7FIiUKq3PVl9x8H1tGSyBkOGcpQeewbvU0FClWcvT
         brZ5XswmstAy4ydZvRDgCjKTwG5WnwYqpgSg1cypRKFl8lc7dF3covd0G0stO0SYa2Ez
         GBd6NaKfcMS5W3ZfiffaQ0cgqu7qvZ56LKA22zwaZst+E7fCibEhaKuaVDpUW7vaqRzB
         kWRg==
X-Gm-Message-State: AOAM533cGCGg3UTG2j67gMios7Po8awAxZCmQN56Ci8CgJOvp2UO5xKw
        FiAU91Q3rVszQ4RRSFHVK14ThA==
X-Google-Smtp-Source: ABdhPJzn71gsLIQdpfMojfT5LicZxzpkY/PXSDvCuLTQi2zYPMC8bFiRX4GzeFRsO7Er8XlpLXupsQ==
X-Received: by 2002:a5d:9e18:: with SMTP id h24mr10696270ioh.80.1616771487495;
        Fri, 26 Mar 2021 08:11:27 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j17sm4537706iok.37.2021.03.26.08.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:11:27 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/12] net: ipa: introduce ipa_resource.c
Date:   Fri, 26 Mar 2021 10:11:11 -0500
Message-Id: <20210326151122.3121383-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
References: <20210326151122.3121383-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the IPA resource-related code into a new source file,
"ipa_resource.c", and matching header file "ipa_resource.h".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile       |   2 +-
 drivers/net/ipa/ipa_main.c     | 148 +-----------------------
 drivers/net/ipa/ipa_reg.h      |  42 -------
 drivers/net/ipa/ipa_resource.c | 204 +++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_resource.h |  27 +++++
 5 files changed, 234 insertions(+), 189 deletions(-)
 create mode 100644 drivers/net/ipa/ipa_resource.c
 create mode 100644 drivers/net/ipa/ipa_resource.h

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index afe5df1e6eeee..14a7d8429baa2 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -7,6 +7,6 @@ ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
 				ipa_table.o ipa_interrupt.o gsi.o gsi_trans.o \
 				ipa_gsi.o ipa_smp2p.o ipa_uc.o \
 				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
-				ipa_qmi.o ipa_qmi_msg.o
+				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o
 
 ipa-y			+=	ipa_data-sdm845.o ipa_data-sc7180.o
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index f071e90de5409..e18029152d780 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -22,6 +22,7 @@
 #include "ipa_clock.h"
 #include "ipa_data.h"
 #include "ipa_endpoint.h"
+#include "ipa_resource.h"
 #include "ipa_cmd.h"
 #include "ipa_reg.h"
 #include "ipa_mem.h"
@@ -452,151 +453,6 @@ static void ipa_hardware_deconfig(struct ipa *ipa)
 	ipa_hardware_dcd_deconfig(ipa);
 }
 
-#ifdef IPA_VALIDATION
-
-static bool ipa_resource_limits_valid(struct ipa *ipa,
-				      const struct ipa_resource_data *data)
-{
-	u32 group_count;
-	u32 i;
-	u32 j;
-
-	/* We program at most 6 source or destination resource group limits */
-	BUILD_BUG_ON(IPA_RESOURCE_GROUP_SRC_MAX > 6);
-
-	group_count = ipa_resource_group_src_count(ipa->version);
-	if (!group_count || group_count > IPA_RESOURCE_GROUP_SRC_MAX)
-		return false;
-
-	/* Return an error if a non-zero resource limit is specified
-	 * for a resource group not supported by hardware.
-	 */
-	for (i = 0; i < data->resource_src_count; i++) {
-		const struct ipa_resource_src *resource;
-
-		resource = &data->resource_src[i];
-		for (j = group_count; j < IPA_RESOURCE_GROUP_SRC_MAX; j++)
-			if (resource->limits[j].min || resource->limits[j].max)
-				return false;
-	}
-
-	group_count = ipa_resource_group_dst_count(ipa->version);
-	if (!group_count || group_count > IPA_RESOURCE_GROUP_DST_MAX)
-		return false;
-
-	for (i = 0; i < data->resource_dst_count; i++) {
-		const struct ipa_resource_dst *resource;
-
-		resource = &data->resource_dst[i];
-		for (j = group_count; j < IPA_RESOURCE_GROUP_DST_MAX; j++)
-			if (resource->limits[j].min || resource->limits[j].max)
-				return false;
-	}
-
-	return true;
-}
-
-#else /* !IPA_VALIDATION */
-
-static bool ipa_resource_limits_valid(struct ipa *ipa,
-				      const struct ipa_resource_data *data)
-{
-	return true;
-}
-
-#endif /* !IPA_VALIDATION */
-
-static void
-ipa_resource_config_common(struct ipa *ipa, u32 offset,
-			   const struct ipa_resource_limits *xlimits,
-			   const struct ipa_resource_limits *ylimits)
-{
-	u32 val;
-
-	val = u32_encode_bits(xlimits->min, X_MIN_LIM_FMASK);
-	val |= u32_encode_bits(xlimits->max, X_MAX_LIM_FMASK);
-	if (ylimits) {
-		val |= u32_encode_bits(ylimits->min, Y_MIN_LIM_FMASK);
-		val |= u32_encode_bits(ylimits->max, Y_MAX_LIM_FMASK);
-	}
-
-	iowrite32(val, ipa->reg_virt + offset);
-}
-
-static void ipa_resource_config_src(struct ipa *ipa,
-				    const struct ipa_resource_src *resource)
-{
-	u32 group_count = ipa_resource_group_src_count(ipa->version);
-	const struct ipa_resource_limits *ylimits;
-	u32 offset;
-
-	offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
-	ylimits = group_count == 1 ? NULL : &resource->limits[1];
-	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
-
-	if (group_count < 2)
-		return;
-
-	offset = IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
-	ylimits = group_count == 3 ? NULL : &resource->limits[3];
-	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
-
-	if (group_count < 4)
-		return;
-
-	offset = IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource->type);
-	ylimits = group_count == 5 ? NULL : &resource->limits[5];
-	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
-}
-
-static void ipa_resource_config_dst(struct ipa *ipa,
-				    const struct ipa_resource_dst *resource)
-{
-	u32 group_count = ipa_resource_group_dst_count(ipa->version);
-	const struct ipa_resource_limits *ylimits;
-	u32 offset;
-
-	offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
-	ylimits = group_count == 1 ? NULL : &resource->limits[1];
-	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
-
-	if (group_count < 2)
-		return;
-
-	offset = IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
-	ylimits = group_count == 3 ? NULL : &resource->limits[3];
-	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
-
-	if (group_count < 4)
-		return;
-
-	offset = IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource->type);
-	ylimits = group_count == 5 ? NULL : &resource->limits[5];
-	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
-}
-
-static int
-ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
-{
-	u32 i;
-
-	if (!ipa_resource_limits_valid(ipa, data))
-		return -EINVAL;
-
-	for (i = 0; i < data->resource_src_count; i++)
-		ipa_resource_config_src(ipa, &data->resource_src[i]);
-
-	for (i = 0; i < data->resource_dst_count; i++)
-		ipa_resource_config_dst(ipa, &data->resource_dst[i]);
-
-	return 0;
-}
-
-static void ipa_resource_deconfig(struct ipa *ipa)
-{
-	/* Nothing to do */
-}
-
 /**
  * ipa_config() - Configure IPA hardware
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 8820e08d2535e..9c798cef7b2e2 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -346,48 +346,6 @@ enum ipa_pulse_gran {
 	IPA_GRAN_655350_US			= 0x7,
 };
 
-/* # IPA source resource groups available based on version */
-static inline u32 ipa_resource_group_src_count(enum ipa_version version)
-{
-	switch (version) {
-	case IPA_VERSION_3_5_1:
-	case IPA_VERSION_4_0:
-	case IPA_VERSION_4_1:
-		return 4;
-
-	case IPA_VERSION_4_2:
-		return 1;
-
-	case IPA_VERSION_4_5:
-		return 5;
-
-	default:
-		return 0;
-	}
-}
-
-/* # IPA destination resource groups available based on version */
-static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
-{
-	switch (version) {
-	case IPA_VERSION_3_5_1:
-		return 3;
-
-	case IPA_VERSION_4_0:
-	case IPA_VERSION_4_1:
-		return 4;
-
-	case IPA_VERSION_4_2:
-		return 1;
-
-	case IPA_VERSION_4_5:
-		return 5;
-
-	default:
-		return 0;
-	}
-}
-
 /* Not all of the following are present (depends on IPA version) */
 #define IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000400 + 0x0020 * (rt))
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
new file mode 100644
index 0000000000000..2f0f2dca36785
--- /dev/null
+++ b/drivers/net/ipa/ipa_resource.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2021 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+#include "ipa.h"
+#include "ipa_data.h"
+#include "ipa_reg.h"
+#include "ipa_resource.h"
+
+/**
+ * DOC: IPA Resources
+ *
+ * The IPA manages a set of resources internally for various purposes.
+ * A given IPA version has a fixed number of resource types, and a fixed
+ * total number of resources of each type.  "Source" resource types
+ * are separate from "destination" resource types.
+ *
+ * Each version of IPA also has some number of resource groups.  Each
+ * endpoint is assigned to a resource group, and all endpoints in the
+ * same group share pools of each type of resource.  A subset of the
+ * total resources of each type is assigned for use by each group.
+ */
+
+/* # IPA source resource groups available based on version */
+static u32 ipa_resource_group_src_count(enum ipa_version version)
+{
+	switch (version) {
+	case IPA_VERSION_3_5_1:
+	case IPA_VERSION_4_0:
+	case IPA_VERSION_4_1:
+		return 4;
+
+	case IPA_VERSION_4_2:
+		return 1;
+
+	case IPA_VERSION_4_5:
+		return 5;
+
+	default:
+		return 0;
+	}
+}
+
+/* # IPA destination resource groups available based on version */
+static u32 ipa_resource_group_dst_count(enum ipa_version version)
+{
+	switch (version) {
+	case IPA_VERSION_3_5_1:
+		return 3;
+
+	case IPA_VERSION_4_0:
+	case IPA_VERSION_4_1:
+		return 4;
+
+	case IPA_VERSION_4_2:
+		return 1;
+
+	case IPA_VERSION_4_5:
+		return 5;
+
+	default:
+		return 0;
+	}
+}
+
+static bool ipa_resource_limits_valid(struct ipa *ipa,
+				      const struct ipa_resource_data *data)
+{
+#ifdef IPA_VALIDATION
+	u32 group_count;
+	u32 i;
+	u32 j;
+
+	/* We program at most 6 source or destination resource group limits */
+	BUILD_BUG_ON(IPA_RESOURCE_GROUP_SRC_MAX > 6);
+
+	group_count = ipa_resource_group_src_count(ipa->version);
+	if (!group_count || group_count > IPA_RESOURCE_GROUP_SRC_MAX)
+		return false;
+
+	/* Return an error if a non-zero resource limit is specified
+	 * for a resource group not supported by hardware.
+	 */
+	for (i = 0; i < data->resource_src_count; i++) {
+		const struct ipa_resource_src *resource;
+
+		resource = &data->resource_src[i];
+		for (j = group_count; j < IPA_RESOURCE_GROUP_SRC_MAX; j++)
+			if (resource->limits[j].min || resource->limits[j].max)
+				return false;
+	}
+
+	group_count = ipa_resource_group_dst_count(ipa->version);
+	if (!group_count || group_count > IPA_RESOURCE_GROUP_DST_MAX)
+		return false;
+
+	for (i = 0; i < data->resource_dst_count; i++) {
+		const struct ipa_resource_dst *resource;
+
+		resource = &data->resource_dst[i];
+		for (j = group_count; j < IPA_RESOURCE_GROUP_DST_MAX; j++)
+			if (resource->limits[j].min || resource->limits[j].max)
+				return false;
+	}
+#endif /* !IPA_VALIDATION */
+	return true;
+}
+
+static void
+ipa_resource_config_common(struct ipa *ipa, u32 offset,
+			   const struct ipa_resource_limits *xlimits,
+			   const struct ipa_resource_limits *ylimits)
+{
+	u32 val;
+
+	val = u32_encode_bits(xlimits->min, X_MIN_LIM_FMASK);
+	val |= u32_encode_bits(xlimits->max, X_MAX_LIM_FMASK);
+	if (ylimits) {
+		val |= u32_encode_bits(ylimits->min, Y_MIN_LIM_FMASK);
+		val |= u32_encode_bits(ylimits->max, Y_MAX_LIM_FMASK);
+	}
+
+	iowrite32(val, ipa->reg_virt + offset);
+}
+
+static void ipa_resource_config_src(struct ipa *ipa,
+				    const struct ipa_resource_src *resource)
+{
+	u32 group_count = ipa_resource_group_src_count(ipa->version);
+	const struct ipa_resource_limits *ylimits;
+	u32 offset;
+
+	offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 1 ? NULL : &resource->limits[1];
+	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
+
+	if (group_count < 2)
+		return;
+
+	offset = IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 3 ? NULL : &resource->limits[3];
+	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
+
+	if (group_count < 4)
+		return;
+
+	offset = IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 5 ? NULL : &resource->limits[5];
+	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
+}
+
+static void ipa_resource_config_dst(struct ipa *ipa,
+				    const struct ipa_resource_dst *resource)
+{
+	u32 group_count = ipa_resource_group_dst_count(ipa->version);
+	const struct ipa_resource_limits *ylimits;
+	u32 offset;
+
+	offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 1 ? NULL : &resource->limits[1];
+	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
+
+	if (group_count < 2)
+		return;
+
+	offset = IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 3 ? NULL : &resource->limits[3];
+	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
+
+	if (group_count < 4)
+		return;
+
+	offset = IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 5 ? NULL : &resource->limits[5];
+	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
+}
+
+/* Configure resources */
+int ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
+{
+	u32 i;
+
+	if (!ipa_resource_limits_valid(ipa, data))
+		return -EINVAL;
+
+	for (i = 0; i < data->resource_src_count; i++)
+		ipa_resource_config_src(ipa, &data->resource_src[i]);
+
+	for (i = 0; i < data->resource_dst_count; i++)
+		ipa_resource_config_dst(ipa, &data->resource_dst[i]);
+
+	return 0;
+}
+
+/* Inverse of ipa_resource_config() */
+void ipa_resource_deconfig(struct ipa *ipa)
+{
+	/* Nothing to do */
+}
diff --git a/drivers/net/ipa/ipa_resource.h b/drivers/net/ipa/ipa_resource.h
new file mode 100644
index 0000000000000..9f74036fb95c5
--- /dev/null
+++ b/drivers/net/ipa/ipa_resource.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2021 Linaro Ltd.
+ */
+#ifndef _IPA_RESOURCE_H_
+#define _IPA_RESOURCE_H_
+
+struct ipa;
+struct ipa_resource_data;
+
+/**
+ * ipa_resource_config() - Configure resources
+ * @ipa:	IPA pointer
+ * @data:	IPA resource configuration data
+ *
+ * Return:	true if all regions are valid, false otherwise
+ */
+int ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data);
+
+/**
+ * ipa_resource_deconfig() - Inverse of ipa_resource_config()
+ * @ipa:	IPA pointer
+ */
+void ipa_resource_deconfig(struct ipa *ipa);
+
+#endif /* _IPA_RESOURCE_H_ */
-- 
2.27.0

