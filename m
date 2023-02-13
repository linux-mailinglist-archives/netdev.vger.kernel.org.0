Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B49F694C7D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjBMQXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjBMQWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:22:53 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04541B555
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:38 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id c15so3785598ils.12
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbAc8V3D9G2gOR+NVFLxST849jyAcs8dA4gnH7zC/KA=;
        b=ZRKQpo/BITl1oxumSh5ufpeakiRg3KKb3jsW0reaAHziog5hXALb8DEfPr9BmLA0mE
         dXHx/Kkd9d8YD324m2uMxDFA711mC6D+9qpZwNNW+UmB7AzRuRBGkij1dMF5QbX7UY5l
         MVy9FqWHw/ZwBx/2RZqXA9k2IoyATfTMn0kOpyUtJGeubwix4tLo3EGX7jep+vVe8YHW
         8uRPNpDsMRUCD6QO5OEyDW7QrzqNqqL58cYjF7DjLQrYumRwIYjnpahHmDZkF4ctLW9v
         OAWKn1t8ZqMXJZ8XwyC58kz27cIXvk/G9lwUH38aRjzhHov1SMxJwh8+92gVnnAvWpuE
         4GJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CbAc8V3D9G2gOR+NVFLxST849jyAcs8dA4gnH7zC/KA=;
        b=dyreLwP77GS2Dsv/nf/IHuyNYmZHh7O5LbSl24xAcrMYWf02np+RuNyUzFC1m9e3kz
         WDXdfc2N1Kyd4Igxte5EnINk4RZmamd77P7bqwCFCjCQ32z9f+LowfSTF1GjJ/52rDLM
         sXFoK0DgarUhEKT28f7IO0lncgfIbyaSM8nKWkn1DYNi9sgkIArx0TUmE8RYfT/Qu5Ek
         Vzwvg0mVXWQ9/7wjaEvPmwFlwEvBvtqFDM6Dsm8GnLdBDSIc/4iL0+rXrZtf1pc/7HXM
         rXXUY3+bjiTvKwNkVhlKMAzc+P4SZw7lVvB2Aaj5csH0BeFnxgqJqjWfUN59UIaEcE6l
         kTOg==
X-Gm-Message-State: AO0yUKVqKlJO08uQCBaaxpuf5YKa5Pri9aZAF3LZCfxiY5ZZJn2TULPW
        OLcylqVyubKcsVxslwO0FtdZqA==
X-Google-Smtp-Source: AK7set99LV69owAiwB3BIXH+Y0bXCopqBHqg8XhPS2vp41SwmRjdEEzdEKoITNrdcbVvXb4RnnWl2g==
X-Received: by 2002:a05:6e02:1a42:b0:313:d4c5:3060 with SMTP id u2-20020a056e021a4200b00313d4c53060mr28227924ilv.12.1676305358249;
        Mon, 13 Feb 2023 08:22:38 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id x17-20020a92dc51000000b00313cbba0455sm1457831ilq.8.2023.02.13.08.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:22:37 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: add "gsi_v4.11.c"
Date:   Mon, 13 Feb 2023 10:22:28 -0600
Message-Id: <20230213162229.604438-6-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213162229.604438-1-elder@linaro.org>
References: <20230213162229.604438-1-elder@linaro.org>
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
at IPA v4.11.  Create "gsi_v4.11.c" from "gsi_v4.9.c", changing only
the name of the public regs structure it defines.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile            |   2 +-
 drivers/net/ipa/gsi_reg.c           |   4 +-
 drivers/net/ipa/gsi_reg.h           |   1 +
 drivers/net/ipa/reg/gsi_reg-v4.11.c | 251 ++++++++++++++++++++++++++++
 4 files changed, 256 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v4.11.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 210160ceb9cd8..cba199422f471 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -5,7 +5,7 @@
 IPA_VERSIONS		:=	3.1 3.5.1 4.2 4.5 4.7 4.9 4.11
 
 # Some IPA versions can reuse another set of GSI register definitions.
-GSI_IPA_VERSIONS	:=	3.1 3.5.1 4.0 4.5 4.9
+GSI_IPA_VERSIONS	:=	3.1 3.5.1 4.0 4.5 4.9 4.11
 
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
diff --git a/drivers/net/ipa/gsi_reg.c b/drivers/net/ipa/gsi_reg.c
index 281668d35d246..0bb70a7ef4e65 100644
--- a/drivers/net/ipa/gsi_reg.c
+++ b/drivers/net/ipa/gsi_reg.c
@@ -111,9 +111,11 @@ static const struct regs *gsi_regs(struct gsi *gsi)
 		return &gsi_regs_v4_5;
 
 	case IPA_VERSION_4_9:
-	case IPA_VERSION_4_11:
 		return &gsi_regs_v4_9;
 
+	case IPA_VERSION_4_11:
+		return &gsi_regs_v4_11;
+
 	default:
 		return NULL;
 	}
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index acd06a0de93b3..780eac742a9d8 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -322,6 +322,7 @@ extern const struct regs gsi_regs_v3_5_1;
 extern const struct regs gsi_regs_v4_0;
 extern const struct regs gsi_regs_v4_5;
 extern const struct regs gsi_regs_v4_9;
+extern const struct regs gsi_regs_v4_11;
 
 /**
  * gsi_reg() - Return the structure describing a GSI register
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.11.c b/drivers/net/ipa/reg/gsi_reg-v4.11.c
new file mode 100644
index 0000000000000..4d8c4a9c9deb2
--- /dev/null
+++ b/drivers/net/ipa/reg/gsi_reg-v4.11.c
@@ -0,0 +1,251 @@
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
+static const u32 reg_ch_c_cntxt_0_fmask[] = {
+	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
+	[CHTYPE_DIR]					= BIT(3),
+	[CH_EE]						= GENMASK(7, 4),
+	[CHID]						= GENMASK(12, 8),
+	[CHTYPE_PROTOCOL_MSB]				= BIT(13),
+	[ERINDEX]					= GENMASK(18, 14),
+						/* Bit 19 reserved */
+	[CHSTATE]					= GENMASK(23, 20),
+	[ELEMENT_SIZE]					= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
+		  0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+
+static const u32 reg_ch_c_cntxt_1_fmask[] = {
+	[CH_R_LENGTH]					= GENMASK(19, 0),
+						/* Bits 20-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
+		  0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
+
+static const u32 reg_ch_c_qos_fmask[] = {
+	[WRR_WEIGHT]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_PREFETCH]					= BIT(8),
+	[USE_DB_ENG]					= BIT(9),
+	[PREFETCH_MODE]					= GENMASK(13, 10),
+						/* Bits 14-15 reserved */
+	[EMPTY_LVL_THRSHOLD]				= GENMASK(23, 16),
+	[DB_IN_BYTES]					= BIT(24),
+						/* Bits 25-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+
+REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
+
+REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
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
+static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
+	[EV_CHTYPE]					= GENMASK(3, 0),
+	[EV_EE]						= GENMASK(7, 4),
+	[EV_EVCHID]					= GENMASK(15, 8),
+	[EV_INTYPE]					= BIT(16),
+						/* Bits 17-19 reserved */
+	[EV_CHSTATE]					= GENMASK(23, 20),
+	[EV_ELEMENT_SIZE]				= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
+		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
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
+static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
+	[EV_MODT]					= GENMASK(15, 0),
+	[EV_MODC]					= GENMASK(23, 16),
+	[EV_MOD_CNT]					= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
+		  0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
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
+REG(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+
+REG(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+
+REG(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+
+REG(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+
+REG(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
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
+	[GSI_STATUS]			= &reg_gsi_status,
+	[CH_CMD]			= &reg_ch_cmd,
+	[EV_CH_CMD]			= &reg_ev_ch_cmd,
+	[GENERIC_CMD]			= &reg_generic_cmd,
+	[HW_PARAM_2]			= &reg_hw_param_2,
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
+	[ERROR_LOG]			= &reg_error_log,
+	[ERROR_LOG_CLR]			= &reg_error_log_clr,
+	[CNTXT_SCRATCH_0]		= &reg_cntxt_scratch_0,
+};
+
+const struct regs gsi_regs_v4_11 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
+};
-- 
2.34.1

