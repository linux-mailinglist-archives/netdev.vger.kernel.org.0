Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAA76B5105
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 20:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCJThS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 14:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCJThQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 14:37:16 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90591386BC
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 11:37:13 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id x10so3534361ill.12
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 11:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678477033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kkQNZSVw4zaUCq2kXc+Mhax587+Y+BrA04ZpcIG6rQ8=;
        b=HzF+Qsmo+dptbO7HKZ+r7jv16Sgh8w7wUx8SbU5zPGakKhdKBKvpD9ubnc3ZRejLqN
         ie1Zbuose3sW8cQ1gvR2QQkc+IOOQN2PfS+KvNM3T3ipvsCOMTf+W4JNsDocOWXteLpx
         npJSWmWlYFuV7Aio86eY06LmUwo1ULjY3VnrXtDoMh1WbYukYeYunkH1tqaB/8OET9Y2
         xIxSnP4Cs8Z7xwIsAm+6rK729TcT+6eMcUDz3CSE6fxNVen4ARm5iGL2yxQyoebMTvPa
         4tyMXz82flRKF7PJw0nNopq2/dDqEBprUVtvcgL88+5BwbqFCI8RK5vy2V/eAMFEDziZ
         5aVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678477033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkQNZSVw4zaUCq2kXc+Mhax587+Y+BrA04ZpcIG6rQ8=;
        b=Nh6lct3Q0/XoJdJrzkxm17xYaKSa+/fJ2uf9WDVt4wTFgC6XuAnF6IS9DlY+9WoerY
         ZAUnE4uYIgg+TZ5EBB5olrVmBNg/YbqiFX7VcKmz8j0i9jDrMDlFsIrdrk7bAfamvJv5
         JEkxf9bAC2aCgQhMr0B6lANvd9EpgBdNe5dwH+LjtLEzNpTr73GML3lM8xGA+jXVTWux
         FPSbAITdA6OQMP82/OUo9hFYES1WLOr0acE5qua6faQ9/LV/kjjbdB/fdOiHpMJhVFqd
         FlHpooryidGxoOVJfb22nHpAN4agaaaUdf6DBG4FYUc/V0Vr3gVMymtuJfirhVGcH8HY
         hIhA==
X-Gm-Message-State: AO0yUKWxVNTWpCr9kidh1cp7La3dqbD0NDZpSrcmZmi0dkFAyPC+jqq9
        n3OTL+LZKb40dUvZmCUfjeyfvg==
X-Google-Smtp-Source: AK7set/QHFffJOgeie30HMbd1yx9a/blJ9mvDsqKiBlnsU3sP5BnhIIV73dJdbxHmlzZgR4GhOZAjQ==
X-Received: by 2002:a05:6e02:1010:b0:316:fcbe:628f with SMTP id n16-20020a056e02101000b00316fcbe628fmr17077839ilj.26.1678477032715;
        Fri, 10 Mar 2023 11:37:12 -0800 (PST)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id k15-20020a02cb4f000000b00374bf3b62a0sm208209jap.99.2023.03.10.11.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 11:37:12 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     luca.weiss@fairphone.com, dmitry.baryshkov@linaro.org,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: ipa: fix a surprising number of bad offsets
Date:   Fri, 10 Mar 2023 13:37:09 -0600
Message-Id: <20230310193709.1477102-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent commit eliminated a hack that adjusted the offset used for
many GSI registers.  It became possible because we now specify all
GSI register offsets explicitly for every version of IPA.

Unfortunately, a large number of register offsets were *not* updated
as they should have been in that commit.  For IPA v4.5+, the offset
for every GSI register *except* the two inter-EE interrupt masking
registers were supposed to have been reduced by 0xd000.

Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> # SM8350-HDK
Fixes: 59b12b1d27f3f ("net: ipa: kill gsi->virt_raw")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/reg/gsi_reg-v4.5.c | 56 +++++++++++++++---------------
 drivers/net/ipa/reg/gsi_reg-v4.9.c | 44 +++++++++++------------
 2 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ipa/reg/gsi_reg-v4.5.c b/drivers/net/ipa/reg/gsi_reg-v4.5.c
index 648b51b88d4e8..2900e5c3ff888 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.5.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.5.c
@@ -137,17 +137,17 @@ REG_STRIDE(EV_CH_E_SCRATCH_1, ev_ch_e_scratch_1,
 	   0x0001004c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
-	   0x0001e000 + 0x4000 * GSI_EE_AP, 0x08);
+	   0x00011000 + 0x4000 * GSI_EE_AP, 0x08);
 
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
-	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
+	   0x00011100 + 0x4000 * GSI_EE_AP, 0x08);
 
 static const u32 reg_gsi_status_fmask[] = {
 	[ENABLED]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GSI_STATUS, gsi_status, 0x00012000 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ch_cmd_fmask[] = {
 	[CH_CHID]					= GENMASK(7, 0),
@@ -155,7 +155,7 @@ static const u32 reg_ch_cmd_fmask[] = {
 	[CH_OPCODE]					= GENMASK(31, 24),
 };
 
-REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CH_CMD, ch_cmd, 0x00012008 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ev_ch_cmd_fmask[] = {
 	[EV_CHID]					= GENMASK(7, 0),
@@ -163,7 +163,7 @@ static const u32 reg_ev_ch_cmd_fmask[] = {
 	[EV_OPCODE]					= GENMASK(31, 24),
 };
 
-REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x00012010 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_generic_cmd_fmask[] = {
 	[GENERIC_OPCODE]				= GENMASK(4, 0),
@@ -172,7 +172,7 @@ static const u32 reg_generic_cmd_fmask[] = {
 						/* Bits 14-31 reserved */
 };
 
-REG_FIELDS(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GENERIC_CMD, generic_cmd, 0x00012018 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_hw_param_2_fmask[] = {
 	[IRAM_SIZE]					= GENMASK(2, 0),
@@ -188,58 +188,58 @@ static const u32 reg_hw_param_2_fmask[] = {
 	[GSI_USE_INTER_EE]				= BIT(31),
 };
 
-REG_FIELDS(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(HW_PARAM_2, hw_param_2, 0x00012040 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x00012080 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x0001f088 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x00012088 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_SRC_CH_IRQ, cntxt_src_ch_irq, 0x0001f090 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_SRC_CH_IRQ, cntxt_src_ch_irq, 0x00012090 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_SRC_EV_CH_IRQ, cntxt_src_ev_ch_irq, 0x0001f094 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_SRC_EV_CH_IRQ, cntxt_src_ev_ch_irq, 0x00012094 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_CH_IRQ_MSK, cntxt_src_ch_irq_msk,
-    0x0001f098 + 0x4000 * GSI_EE_AP);
+    0x00012098 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_EV_CH_IRQ_MSK, cntxt_src_ev_ch_irq_msk,
-    0x0001f09c + 0x4000 * GSI_EE_AP);
+    0x0001209c + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_CH_IRQ_CLR, cntxt_src_ch_irq_clr,
-    0x0001f0a0 + 0x4000 * GSI_EE_AP);
+    0x000120a0 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_EV_CH_IRQ_CLR, cntxt_src_ev_ch_irq_clr,
-    0x0001f0a4 + 0x4000 * GSI_EE_AP);
+    0x000120a4 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_SRC_IEOB_IRQ, cntxt_src_ieob_irq, 0x0001f0b0 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_SRC_IEOB_IRQ, cntxt_src_ieob_irq, 0x000120b0 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_IEOB_IRQ_MSK, cntxt_src_ieob_irq_msk,
-    0x0001f0b8 + 0x4000 * GSI_EE_AP);
+    0x000120b8 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_IEOB_IRQ_CLR, cntxt_src_ieob_irq_clr,
-    0x0001f0c0 + 0x4000 * GSI_EE_AP);
+    0x000120c0 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GLOB_IRQ_STTS, cntxt_glob_irq_stts, 0x0001f100 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GLOB_IRQ_STTS, cntxt_glob_irq_stts, 0x00012100 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GLOB_IRQ_EN, cntxt_glob_irq_en, 0x0001f108 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GLOB_IRQ_EN, cntxt_glob_irq_en, 0x00012108 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GLOB_IRQ_CLR, cntxt_glob_irq_clr, 0x0001f110 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GLOB_IRQ_CLR, cntxt_glob_irq_clr, 0x00012110 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GSI_IRQ_STTS, cntxt_gsi_irq_stts, 0x0001f118 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GSI_IRQ_STTS, cntxt_gsi_irq_stts, 0x00012118 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x00012120 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x00012128 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_cntxt_intset_fmask[] = {
 	[INTYPE]					= BIT(0)
 						/* Bits 1-31 reserved */
 };
 
-REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x00012180 + 0x4000 * GSI_EE_AP);
 
-REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(ERROR_LOG, error_log, 0x00012200 + 0x4000 * GSI_EE_AP);
 
-REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
+REG(ERROR_LOG_CLR, error_log_clr, 0x00012210 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_cntxt_scratch_0_fmask[] = {
 	[INTER_EE_RESULT]				= GENMASK(2, 0),
@@ -248,7 +248,7 @@ static const u32 reg_cntxt_scratch_0_fmask[] = {
 						/* Bits 8-31 reserved */
 };
 
-REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x00012400 + 0x4000 * GSI_EE_AP);
 
 static const struct reg *reg_array[] = {
 	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.9.c b/drivers/net/ipa/reg/gsi_reg-v4.9.c
index 4bf45d264d6b9..8b5d95425a766 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.9.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.9.c
@@ -27,7 +27,7 @@ static const u32 reg_ch_c_cntxt_0_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
-		  0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x0000f000 + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ch_c_cntxt_1_fmask[] = {
 	[CH_R_LENGTH]					= GENMASK(19, 0),
@@ -35,11 +35,11 @@ static const u32 reg_ch_c_cntxt_1_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
-		  0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x0000f004 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0000f008 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0000f00c + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ch_c_qos_fmask[] = {
 	[WRR_WEIGHT]					= GENMASK(3, 0),
@@ -53,7 +53,7 @@ static const u32 reg_ch_c_qos_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0000f05c + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_error_log_fmask[] = {
 	[ERR_ARG3]					= GENMASK(3, 0),
@@ -67,16 +67,16 @@ static const u32 reg_error_log_fmask[] = {
 };
 
 REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
-	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f060 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_SCRATCH_1, ch_c_scratch_1,
-	   0x0001c064 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f064 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
-	   0x0001c068 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f068 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
-	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f06c + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 	[EV_CHTYPE]					= GENMASK(3, 0),
@@ -89,23 +89,23 @@ static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
-		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x00010000 + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ev_ch_e_cntxt_1_fmask[] = {
 	[R_LENGTH]					= GENMASK(15, 0),
 };
 
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
-		  0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x00010004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
-	   0x0001d008 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010008 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
-	   0x0001d00c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0001000c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
-	   0x0001d010 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010010 + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
 	[EV_MODT]					= GENMASK(15, 0),
@@ -114,28 +114,28 @@ static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
-		  0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x00010020 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
-	   0x0001d024 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010024 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_10, ev_ch_e_cntxt_10,
-	   0x0001d028 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010028 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_11, ev_ch_e_cntxt_11,
-	   0x0001d02c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0001002c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_12, ev_ch_e_cntxt_12,
-	   0x0001d030 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010030 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_13, ev_ch_e_cntxt_13,
-	   0x0001d034 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010034 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_SCRATCH_0, ev_ch_e_scratch_0,
-	   0x0001d048 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010048 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_SCRATCH_1, ev_ch_e_scratch_1,
-	   0x0001d04c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0001004c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 	   0x00011000 + 0x4000 * GSI_EE_AP, 0x08);
-- 
2.34.1

