Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4369569269D
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbjBJTh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbjBJThd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:37:33 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA9E241F1
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:10 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id u8so2623456ilq.13
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gFqLViUAvicBaML30+GgIh2uNTQQalfojC8+2330C8=;
        b=wZJa3tNNhExdAJdFTozT8pxDc/JhADm00Py6Uj4tZpuK9CYsHlUe4OwsFBK+jzdh8l
         lgl48YQh93F+8+7QZ9oWZus6QcUuv/y7eQUg2UNFtOnHJNFrkJg4S07oEdGEbEBOesct
         ih/tdj7+q1FhqI9CIIroLuuw8WAqbbgb69I9Znh8kp7r+yFLqLFRr5EfcQ19QfZDjakG
         4vm6PlV2mZwnJ/Tp9qFywysYffFksoQySteoSgx5tCzjDakIhWM7a8eRGqbXMiSj101p
         2asMRE3oTOUbtcuTsh7tlu8qD1S6C3U+vVk2okVNXR18emYXhJm6Q2zZEXZjEknJH66N
         1wwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5gFqLViUAvicBaML30+GgIh2uNTQQalfojC8+2330C8=;
        b=dr/SFs3tBpNHs9ZwQwa7KofOUrglS2OL2irK7HLs0tEhnQMaFx7iAn7AQMP1o2BD4O
         9xp4FPz8mf6e+JX/qxzPSnN9B/qBqVmQqJqtyrBtE7c/bMmy9QDqI1i5xSlg2Y3DEbDO
         ViHtViKg1GLk1nvZQxZntuYRvWOQuYj6zSvQ0o9RfIC28JpmAEn4pTfxI0HX0Mt+jmOo
         34ib9K6ppytWJ0xXii4qh8/7ESprSZF6plnoozMZcVXExZadgwtPmrLnFblHXY22gfgc
         /F+zpqvl/QuuMxl2Sx4eMrawhZwhuL3rL+KmoMXybBpdFUAOC7M7qdQ9WDWvcZQvrKWq
         hV2A==
X-Gm-Message-State: AO0yUKVs7haSg16+kmDee9jq18yVzZ2qAf8G4ASpVFDbtbnNcrHKQnOw
        gAyGDqFoZwyOr0zVKgbpw/RWfA==
X-Google-Smtp-Source: AK7set8O6Nw9Mx7+fh4xo9SLtO0BdLDEDMn8F6/LXMa63scvV0LLo6LSWKlLyLtC6kNEuSFvY0WPDQ==
X-Received: by 2002:a92:760d:0:b0:313:f9df:2f48 with SMTP id r13-20020a92760d000000b00313f9df2f48mr9194166ilc.32.1676057830064;
        Fri, 10 Feb 2023 11:37:10 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id 14-20020a056e020cae00b00304ae88ebebsm1530692ilg.88.2023.02.10.11.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:37:09 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] net: ipa: add "gsi_v3.5.1.c"
Date:   Fri, 10 Feb 2023 13:36:54 -0600
Message-Id: <20230210193655.460225-8-elder@linaro.org>
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

The next patch adds a GSI register field that is only valid starting
at IPA v3.5.1.  Create "gsi_v3.5.1.c" from "gsi_v3.1.c", changing
only the name of the public regs structure it defines.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile             |   2 +-
 drivers/net/ipa/gsi_reg.h            |   1 +
 drivers/net/ipa/reg/gsi_reg-v3.5.1.c | 183 +++++++++++++++++++++++++++
 3 files changed, 185 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v3.5.1.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index d87f2cfe08c61..3057b520fc796 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -5,7 +5,7 @@
 IPA_VERSIONS		:=	3.1 3.5.1 4.2 4.5 4.7 4.9 4.11
 
 # Some IPA versions can reuse another set of GSI register definitions.
-GSI_IPA_VERSIONS	:=	3.1
+GSI_IPA_VERSIONS	:=	3.1 3.5.1
 
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 8179b1f77bcd2..5faa1432c18ff 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -320,6 +320,7 @@ enum gsi_generic_ee_result {
 };
 
 extern const struct regs gsi_regs_v3_1;
+extern const struct regs gsi_regs_v3_5_1;
 
 /**
  * gsi_reg() - Return the structure describing a GSI register
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
new file mode 100644
index 0000000000000..97b37c3e9fec8
--- /dev/null
+++ b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2023 Linaro Ltd. */
+
+#include <linux/types.h>
+
+#include "../gsi.h"
+#include "../reg.h"
+#include "../gsi_reg.h"
+
+/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
+
+REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
+    0x0000c020 + 0x1000 * GSI_EE_AP);
+
+REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
+    0x0000c024 + 0x1000 * GSI_EE_AP);
+
+/* All other register offsets are relative to gsi->virt */
+
+REG_STRIDE(CH_C_CNTXT_0, ch_c_cntxt_0, 0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_CNTXT_1, ch_c_cntxt_1, 0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
+	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_1, ch_c_scratch_1,
+	   0x0001c064 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
+	   0x0001c068 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
+	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
+	   0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
+	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
+	   0x0001d008 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
+	   0x0001d00c + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
+	   0x0001d010 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
+	   0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
+	   0x0001d024 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_10, ev_ch_e_cntxt_10,
+	   0x0001d028 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_11, ev_ch_e_cntxt_11,
+	   0x0001d02c + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_12, ev_ch_e_cntxt_12,
+	   0x0001d030 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_13, ev_ch_e_cntxt_13,
+	   0x0001d034 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_SCRATCH_0, ev_ch_e_scratch_0,
+	   0x0001d048 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_SCRATCH_1, ev_ch_e_scratch_1,
+	   0x0001d04c + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
+	   0x0001e000 + 0x4000 * GSI_EE_AP, 0x08);
+
+REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
+	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
+
+REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x0001f088 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_CH_IRQ, cntxt_src_ch_irq, 0x0001f090 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_EV_CH_IRQ, cntxt_src_ev_ch_irq, 0x0001f094 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_CH_IRQ_MSK, cntxt_src_ch_irq_msk,
+    0x0001f098 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_EV_CH_IRQ_MSK, cntxt_src_ev_ch_irq_msk,
+    0x0001f09c + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_CH_IRQ_CLR, cntxt_src_ch_irq_clr,
+    0x0001f0a0 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_EV_CH_IRQ_CLR, cntxt_src_ev_ch_irq_clr,
+    0x0001f0a4 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_IEOB_IRQ, cntxt_src_ieob_irq, 0x0001f0b0 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_IEOB_IRQ_MSK, cntxt_src_ieob_irq_msk,
+    0x0001f0b8 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_IEOB_IRQ_CLR, cntxt_src_ieob_irq_clr,
+    0x0001f0c0 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GLOB_IRQ_STTS, cntxt_glob_irq_stts, 0x0001f100 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GLOB_IRQ_EN, cntxt_glob_irq_en, 0x0001f108 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GLOB_IRQ_CLR, cntxt_glob_irq_clr, 0x0001f110 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GSI_IRQ_STTS, cntxt_gsi_irq_stts, 0x0001f118 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+
+static const struct reg *reg_array[] = {
+	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
+	[INTER_EE_SRC_EV_CH_IRQ_MSK]	= &reg_inter_ee_src_ev_ch_irq_msk,
+	[CH_C_CNTXT_0]			= &reg_ch_c_cntxt_0,
+	[CH_C_CNTXT_1]			= &reg_ch_c_cntxt_1,
+	[CH_C_CNTXT_2]			= &reg_ch_c_cntxt_2,
+	[CH_C_CNTXT_3]			= &reg_ch_c_cntxt_3,
+	[CH_C_QOS]			= &reg_ch_c_qos,
+	[CH_C_SCRATCH_0]		= &reg_ch_c_scratch_0,
+	[CH_C_SCRATCH_1]		= &reg_ch_c_scratch_1,
+	[CH_C_SCRATCH_2]		= &reg_ch_c_scratch_2,
+	[CH_C_SCRATCH_3]		= &reg_ch_c_scratch_3,
+	[EV_CH_E_CNTXT_0]		= &reg_ev_ch_e_cntxt_0,
+	[EV_CH_E_CNTXT_1]		= &reg_ev_ch_e_cntxt_1,
+	[EV_CH_E_CNTXT_2]		= &reg_ev_ch_e_cntxt_2,
+	[EV_CH_E_CNTXT_3]		= &reg_ev_ch_e_cntxt_3,
+	[EV_CH_E_CNTXT_4]		= &reg_ev_ch_e_cntxt_4,
+	[EV_CH_E_CNTXT_8]		= &reg_ev_ch_e_cntxt_8,
+	[EV_CH_E_CNTXT_9]		= &reg_ev_ch_e_cntxt_9,
+	[EV_CH_E_CNTXT_10]		= &reg_ev_ch_e_cntxt_10,
+	[EV_CH_E_CNTXT_11]		= &reg_ev_ch_e_cntxt_11,
+	[EV_CH_E_CNTXT_12]		= &reg_ev_ch_e_cntxt_12,
+	[EV_CH_E_CNTXT_13]		= &reg_ev_ch_e_cntxt_13,
+	[EV_CH_E_SCRATCH_0]		= &reg_ev_ch_e_scratch_0,
+	[EV_CH_E_SCRATCH_1]		= &reg_ev_ch_e_scratch_1,
+	[CH_C_DOORBELL_0]		= &reg_ch_c_doorbell_0,
+	[EV_CH_E_DOORBELL_0]		= &reg_ev_ch_e_doorbell_0,
+	[CNTXT_TYPE_IRQ]		= &reg_cntxt_type_irq,
+	[CNTXT_TYPE_IRQ_MSK]		= &reg_cntxt_type_irq_msk,
+	[CNTXT_SRC_CH_IRQ]		= &reg_cntxt_src_ch_irq,
+	[CNTXT_SRC_EV_CH_IRQ]		= &reg_cntxt_src_ev_ch_irq,
+	[CNTXT_SRC_CH_IRQ_MSK]		= &reg_cntxt_src_ch_irq_msk,
+	[CNTXT_SRC_EV_CH_IRQ_MSK]	= &reg_cntxt_src_ev_ch_irq_msk,
+	[CNTXT_SRC_CH_IRQ_CLR]		= &reg_cntxt_src_ch_irq_clr,
+	[CNTXT_SRC_EV_CH_IRQ_CLR]	= &reg_cntxt_src_ev_ch_irq_clr,
+	[CNTXT_SRC_IEOB_IRQ]		= &reg_cntxt_src_ieob_irq,
+	[CNTXT_SRC_IEOB_IRQ_MSK]	= &reg_cntxt_src_ieob_irq_msk,
+	[CNTXT_SRC_IEOB_IRQ_CLR]	= &reg_cntxt_src_ieob_irq_clr,
+	[CNTXT_GLOB_IRQ_STTS]		= &reg_cntxt_glob_irq_stts,
+	[CNTXT_GLOB_IRQ_EN]		= &reg_cntxt_glob_irq_en,
+	[CNTXT_GLOB_IRQ_CLR]		= &reg_cntxt_glob_irq_clr,
+	[CNTXT_GSI_IRQ_STTS]		= &reg_cntxt_gsi_irq_stts,
+	[CNTXT_GSI_IRQ_EN]		= &reg_cntxt_gsi_irq_en,
+	[CNTXT_GSI_IRQ_CLR]		= &reg_cntxt_gsi_irq_clr,
+	[CNTXT_INTSET]			= &reg_cntxt_intset,
+	[CNTXT_SCRATCH_0]		= &reg_cntxt_scratch_0,
+};
+
+const struct regs gsi_regs_v3_5_1 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
+};
-- 
2.34.1

