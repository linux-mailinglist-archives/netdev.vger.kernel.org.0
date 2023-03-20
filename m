Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536156C2293
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjCTUZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjCTUZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:25:00 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D670C7A94
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 13:24:55 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id t9so14714323qtx.8
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 13:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679343894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V2JlaX3bX0PbxWEwzGQZ6oyBc9CWX24Y9BuBSfB7Vlg=;
        b=Q/3P4glKnA3tvaHPOqkO77aVe+2cvgU2gs0HBjQCO9YORAsY+WR8es+24QbnzKwRaU
         fjXRXIlbpWFwaDaUZMWZ7E5OOpl9QTViKguGrfEZYrtw/XnO3Nw2aJkTyagw+S08YY9C
         lgLqDEFm1h8iNS9jFezw/O9F0u3YaSuKEEz5IIi5vJ35b1NfMI2hnKTETpQVZinUShRx
         IUsXLEmIvzu8gkVCcBauNKhGpi1ouJvjnWurnl0ueYTa2ToCL17a8xub7gcdhkNlmr9N
         2hgwlBMflK4ENNzN97/ZEdbeeUNNEP3VPoyUR0QKjvJB08kQyp0XcvUCDY4i555x/ucF
         pmHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679343894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V2JlaX3bX0PbxWEwzGQZ6oyBc9CWX24Y9BuBSfB7Vlg=;
        b=gEEVcNKySSnvY8GTbIFIkSjcj8iGgxN5S4mo8ocaamuvp9B1dGz3Ts8KLqRChx2oUZ
         dctWZMYX/tRJMlSmTQbIH4onUzIy0vuvXNDvt4URHKUiqpBBTAi1Hp5hK9uTCRMwrK8z
         o2jzpcbrweo+hlk9OKsJc0mOlA4yyt/6M67Qmxb/8SpK118onwjYSdzF28uOEqrpEwWS
         UrHve57/AK45t4olAiQk2kS4uClsQqTtdD8fxqbTyjjI1NWHCaEMpxIoPdPs9G7qY+8x
         3xRXfQm7HS/19JI3VJ3OKMpQyEcP1Qf+iAWUGDMTHnbwbT2JSBv7AGBg/FPYQZZwWdXU
         5CQQ==
X-Gm-Message-State: AO0yUKWx7FtMlx7mkpiRv8MSQp7D6DpsLharqZpkls0P424CR5AIEBMF
        uOtPmEyPJLtvgr1QCZExomjMow==
X-Google-Smtp-Source: AK7set/SAAOYAOO+xOvdkG+53owH/b184P5FG6BmSiKffJmVpAbZk1xu37dUlWGzBiuYEZjgnR1DIg==
X-Received: by 2002:ac8:5cce:0:b0:3bd:fd:f984 with SMTP id s14-20020ac85cce000000b003bd00fdf984mr1030706qta.2.1679343894499;
        Mon, 20 Mar 2023 13:24:54 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id d184-20020a3768c1000000b0074688c36facsm2568371qkc.56.2023.03.20.13.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 13:24:54 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: ipa: add IPA v5.0 GSI register definitions
Date:   Mon, 20 Mar 2023 15:24:46 -0500
Message-Id: <20230320202447.2048016-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230320202447.2048016-1-elder@linaro.org>
References: <20230320202447.2048016-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the definitions of GSI register offsets and fields for IPA v5.0.
These are used for the SDX65 SoC.  Increase the maximum channel and
event ring counts supported by the driver, so those implemented by
the SDX65 are supported.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile           |   2 +-
 drivers/net/ipa/gsi.h              |   4 +-
 drivers/net/ipa/gsi_reg.c          |   3 +
 drivers/net/ipa/gsi_reg.h          |   1 +
 drivers/net/ipa/reg/gsi_reg-v5.0.c | 317 +++++++++++++++++++++++++++++
 5 files changed, 324 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v5.0.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 1458f9129e4b1..a878096ed1252 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -5,7 +5,7 @@
 IPA_VERSIONS		:=	3.1 3.5.1 4.2 4.5 4.7 4.9 4.11 5.0
 
 # Some IPA versions can reuse another set of GSI register definitions.
-GSI_IPA_VERSIONS	:=	3.1 3.5.1 4.0 4.5 4.9 4.11
+GSI_IPA_VERSIONS	:=	3.1 3.5.1 4.0 4.5 4.9 4.11 5.0
 
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 50bc80cb167c3..42063b227c185 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -16,8 +16,8 @@
 #include "ipa_version.h"
 
 /* Maximum number of channels and event rings supported by the driver */
-#define GSI_CHANNEL_COUNT_MAX	23
-#define GSI_EVT_RING_COUNT_MAX	24
+#define GSI_CHANNEL_COUNT_MAX	28
+#define GSI_EVT_RING_COUNT_MAX	28
 
 /* Maximum TLV FIFO size for a channel; 64 here is arbitrary (and high) */
 #define GSI_TLV_MAX		64
diff --git a/drivers/net/ipa/gsi_reg.c b/drivers/net/ipa/gsi_reg.c
index 1651fbad4bd54..c5458e28b12f2 100644
--- a/drivers/net/ipa/gsi_reg.c
+++ b/drivers/net/ipa/gsi_reg.c
@@ -109,6 +109,9 @@ static const struct regs *gsi_regs(struct gsi *gsi)
 	case IPA_VERSION_4_11:
 		return &gsi_regs_v4_11;
 
+	case IPA_VERSION_5_0:
+		return &gsi_regs_v5_0;
+
 	default:
 		return NULL;
 	}
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 48fde65fa2e8a..cf046567f3fe6 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -355,6 +355,7 @@ extern const struct regs gsi_regs_v4_0;
 extern const struct regs gsi_regs_v4_5;
 extern const struct regs gsi_regs_v4_9;
 extern const struct regs gsi_regs_v4_11;
+extern const struct regs gsi_regs_v5_0;
 
 /**
  * gsi_reg() - Return the structure describing a GSI register
diff --git a/drivers/net/ipa/reg/gsi_reg-v5.0.c b/drivers/net/ipa/reg/gsi_reg-v5.0.c
new file mode 100644
index 0000000000000..d7b81a36d673b
--- /dev/null
+++ b/drivers/net/ipa/reg/gsi_reg-v5.0.c
@@ -0,0 +1,317 @@
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
+REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
+    0x0000c01c + 0x1000 * GSI_EE_AP);
+
+REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
+    0x0000c028 + 0x1000 * GSI_EE_AP);
+
+static const u32 reg_ch_c_cntxt_0_fmask[] = {
+	[CHTYPE_PROTOCOL]				= GENMASK(6, 0),
+	[CHTYPE_DIR]					= BIT(7),
+	[CH_EE]						= GENMASK(11, 8),
+	[CHID]						= GENMASK(19, 12),
+	[CHSTATE]					= GENMASK(23, 20),
+	[ELEMENT_SIZE]					= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
+		  0x00014000 + 0x12000 * GSI_EE_AP, 0x80);
+
+static const u32 reg_ch_c_cntxt_1_fmask[] = {
+	[CH_R_LENGTH]					= GENMASK(23, 0),
+	[ERINDEX]					= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
+		  0x00014004 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x00014008 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001400c + 0x12000 * GSI_EE_AP, 0x80);
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
+	[LOW_LATENCY_EN]				= BIT(25),
+						/* Bits 26-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x00014048 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
+	   0x0001404c + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_1, ch_c_scratch_1,
+	   0x00014050 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
+	   0x00014054 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
+	   0x00014058 + 0x12000 * GSI_EE_AP, 0x80);
+
+static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
+	[EV_CHTYPE]					= GENMASK(6, 0),
+	[EV_INTYPE]					= BIT(7),
+	[EV_EVCHID]					= GENMASK(15, 8),
+	[EV_EE]						= GENMASK(19, 16),
+	[EV_CHSTATE]					= GENMASK(23, 20),
+	[EV_ELEMENT_SIZE]				= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
+		  0x0001c000 + 0x12000 * GSI_EE_AP, 0x80);
+
+static const u32 reg_ev_ch_e_cntxt_1_fmask[] = {
+	[R_LENGTH]					= GENMASK(19, 0),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
+		  0x0001c004 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
+	   0x0001c008 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
+	   0x0001c00c + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
+	   0x0001c010 + 0x12000 * GSI_EE_AP, 0x80);
+
+static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
+	[EV_MODT]					= GENMASK(15, 0),
+	[EV_MODC]					= GENMASK(23, 16),
+	[EV_MOD_CNT]					= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
+		  0x0001c020 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
+	   0x0001c024 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_10, ev_ch_e_cntxt_10,
+	   0x0001c028 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_11, ev_ch_e_cntxt_11,
+	   0x0001c02c + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_12, ev_ch_e_cntxt_12,
+	   0x0001c030 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_13, ev_ch_e_cntxt_13,
+	   0x0001c034 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_SCRATCH_0, ev_ch_e_scratch_0,
+	   0x0001c048 + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_SCRATCH_1, ev_ch_e_scratch_1,
+	   0x0001c04c + 0x12000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
+	   0x00024000 + 0x12000 * GSI_EE_AP, 0x08);
+
+REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
+	   0x00024800 + 0x12000 * GSI_EE_AP, 0x08);
+
+static const u32 reg_gsi_status_fmask[] = {
+	[ENABLED]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+REG_FIELDS(GSI_STATUS, gsi_status, 0x00025000 + 0x12000 * GSI_EE_AP);
+
+static const u32 reg_ch_cmd_fmask[] = {
+	[CH_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
+	[CH_OPCODE]					= GENMASK(31, 24),
+};
+
+REG_FIELDS(CH_CMD, ch_cmd, 0x00025008 + 0x12000 * GSI_EE_AP);
+
+static const u32 reg_ev_ch_cmd_fmask[] = {
+	[EV_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
+	[EV_OPCODE]					= GENMASK(31, 24),
+};
+
+REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x00025010 + 0x12000 * GSI_EE_AP);
+
+static const u32 reg_generic_cmd_fmask[] = {
+	[GENERIC_OPCODE]				= GENMASK(4, 0),
+	[GENERIC_CHID]					= GENMASK(9, 5),
+	[GENERIC_EE]					= GENMASK(13, 10),
+						/* Bits 14-31 reserved */
+};
+
+REG_FIELDS(GENERIC_CMD, generic_cmd, 0x00025018 + 0x12000 * GSI_EE_AP);
+
+static const u32 reg_hw_param_2_fmask[] = {
+	[NUM_CH_PER_EE]					= GENMASK(7, 0),
+	[IRAM_SIZE]					= GENMASK(12, 8),
+	[GSI_CH_PEND_TRANSLATE]				= BIT(13),
+	[GSI_CH_FULL_LOGIC]				= BIT(14),
+	[GSI_USE_SDMA]					= BIT(15),
+	[GSI_SDMA_N_INT]				= GENMASK(18, 16),
+	[GSI_SDMA_MAX_BURST]				= GENMASK(26, 19),
+	[GSI_SDMA_N_IOVEC]				= GENMASK(29, 27),
+	[GSI_USE_RD_WR_ENG]				= BIT(30),
+	[GSI_USE_INTER_EE]				= BIT(31),
+};
+
+REG_FIELDS(HW_PARAM_2, hw_param_2, 0x00025040 + 0x12000 * GSI_EE_AP);
+
+static const u32 reg_hw_param_4_fmask[] = {
+	[EV_PER_EE]					= GENMASK(7, 0),
+	[IRAM_PROTOCOL_COUNT]				= GENMASK(15, 8),
+						/* Bits 16-31 reserved */
+};
+
+REG_FIELDS(HW_PARAM_4, hw_param_4, 0x00025050 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x00025080 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x00025088 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_CH_IRQ, cntxt_src_ch_irq, 0x00025090 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_CH_IRQ_MSK, cntxt_src_ch_irq_msk,
+    0x00025094 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_CH_IRQ_CLR, cntxt_src_ch_irq_clr,
+    0x00025098 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_EV_CH_IRQ, cntxt_src_ev_ch_irq, 0x0002509c + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_EV_CH_IRQ_MSK, cntxt_src_ev_ch_irq_msk,
+    0x000250a0 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_EV_CH_IRQ_CLR, cntxt_src_ev_ch_irq_clr,
+    0x000250a4 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_IEOB_IRQ, cntxt_src_ieob_irq, 0x000250a8 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_IEOB_IRQ_MSK, cntxt_src_ieob_irq_msk,
+    0x000250ac + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_IEOB_IRQ_CLR, cntxt_src_ieob_irq_clr,
+    0x000250b0 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_GLOB_IRQ_STTS, cntxt_glob_irq_stts, 0x00025200 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_GLOB_IRQ_EN, cntxt_glob_irq_en, 0x00025204 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_GLOB_IRQ_CLR, cntxt_glob_irq_clr, 0x00025208 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_GSI_IRQ_STTS, cntxt_gsi_irq_stts, 0x0002520c + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x00025210 + 0x12000 * GSI_EE_AP);
+
+REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x00025214 + 0x12000 * GSI_EE_AP);
+
+static const u32 reg_cntxt_intset_fmask[] = {
+	[INTYPE]					= BIT(0)
+						/* Bits 1-31 reserved */
+};
+
+REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x00025220 + 0x12000 * GSI_EE_AP);
+
+static const u32 reg_error_log_fmask[] = {
+	[ERR_ARG3]					= GENMASK(3, 0),
+	[ERR_ARG2]					= GENMASK(7, 4),
+	[ERR_ARG1]					= GENMASK(11, 8),
+	[ERR_CODE]					= GENMASK(15, 12),
+						/* Bits 16-18 reserved */
+	[ERR_VIRT_IDX]					= GENMASK(23, 19),
+	[ERR_TYPE]					= GENMASK(27, 24),
+	[ERR_EE]					= GENMASK(31, 28),
+};
+
+REG_FIELDS(ERROR_LOG, error_log, 0x00025240 + 0x12000 * GSI_EE_AP);
+
+REG(ERROR_LOG_CLR, error_log_clr, 0x00025244 + 0x12000 * GSI_EE_AP);
+
+static const u32 reg_cntxt_scratch_0_fmask[] = {
+	[INTER_EE_RESULT]				= GENMASK(2, 0),
+						/* Bits 3-4 reserved */
+	[GENERIC_EE_RESULT]				= GENMASK(7, 5),
+						/* Bits 8-31 reserved */
+};
+
+REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x00025400 + 0x12000 * GSI_EE_AP);
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
+	[HW_PARAM_4]			= &reg_hw_param_4,
+	[CNTXT_TYPE_IRQ]		= &reg_cntxt_type_irq,
+	[CNTXT_TYPE_IRQ_MSK]		= &reg_cntxt_type_irq_msk,
+	[CNTXT_SRC_CH_IRQ]		= &reg_cntxt_src_ch_irq,
+	[CNTXT_SRC_CH_IRQ_MSK]		= &reg_cntxt_src_ch_irq_msk,
+	[CNTXT_SRC_CH_IRQ_CLR]		= &reg_cntxt_src_ch_irq_clr,
+	[CNTXT_SRC_EV_CH_IRQ]		= &reg_cntxt_src_ev_ch_irq,
+	[CNTXT_SRC_EV_CH_IRQ_MSK]	= &reg_cntxt_src_ev_ch_irq_msk,
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
+const struct regs gsi_regs_v5_0 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
+};
-- 
2.34.1

