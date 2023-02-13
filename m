Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1528E694C78
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjBMQXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjBMQWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:22:53 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CD41D915
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:40 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id v13so3839096iln.4
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T02k0sZvGTc2Ga3VgHJTCOmo+PnWR/qywvn7NZcCawI=;
        b=kILuKtT2z1D+vp+SYv2To3HxDijOJmfdgIccyz18Ks7pz42LjsJUZ+V5RKp58i0Cpo
         kW9nskmREzbNXkcd1S+044ViUglZZf2vMTUoiZT+Hps8/jgs1aUMrFHCKHiv/83Kn4l3
         ac2+UcADzKrjzKn+EWX1iLpL+vZn3fpI36YEN7inaIe8zIp0Aew4xP+f0wSSCWt/v2RJ
         7Thz4OmU+sgIOd08jRAciNQQp+MzzW6fIW0/rW9m/IMULSawcG6lVpmHvzYi8mBAh5A1
         PnaQtNx0dDOx4QFMD4tstqApm+BLACHjSY3JLLepy7wX3Az8jYKm3xjMrfR6NgiiJhsa
         /z4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T02k0sZvGTc2Ga3VgHJTCOmo+PnWR/qywvn7NZcCawI=;
        b=ZkDdnaJXNKBA1Px6+V23uYuqpNiSMWXI250W/E6ql4+qCOpqSm11zDQiWqrSSWw+CT
         QH7kVnXg/OmBoNw1OlM3ejfQ5s7C5o5SgMJJeHprrNKgVnG4THJMZ2IMOZSwFqsv+kAF
         CrDxpqEXI+fUUnygk02tQ9KVmIeLleKG2kud8V2o4LyNKetPiwgqKXwjkxzdqut3GFTf
         mRIvSYH1S8BurCEN2I9Xvk/951T+z07GY6PyEfrqyLMUEtmFDUU+R31LlzgyyIW8UoDP
         TY5J2VbbGN0hpW7R8hkX8SnJ/jdCr86KTU59uJum4+oh9oEz0aTlj9JhEQaMuL1leJ0C
         +dxQ==
X-Gm-Message-State: AO0yUKVkn6XyYW/Trl5gXQft6YQiUMVtfVzYuKpiG0kweqSulnSCi8TB
        uImWmkgMBzSiqemPI0EdvmRi6Q==
X-Google-Smtp-Source: AK7set8sKA/0lOYyOc9z/2rVfD0Ym3HegyR8rXO1P7W1fvHjsiQ8aYJn8T/BwHPXeFaqCFPHAI3GbQ==
X-Received: by 2002:a05:6e02:1d9b:b0:313:8ab0:1600 with SMTP id h27-20020a056e021d9b00b003138ab01600mr28032912ila.24.1676305359374;
        Mon, 13 Feb 2023 08:22:39 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id x17-20020a92dc51000000b00313cbba0455sm1457831ilq.8.2023.02.13.08.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:22:39 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: define fields for remaining GSI registers
Date:   Mon, 13 Feb 2023 10:22:29 -0600
Message-Id: <20230213162229.604438-7-elder@linaro.org>
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

Define field IDs for the remaining GSI registers, and populate the
register definition files accordingly.  Use the reg_*() functions to
access field values for those regiters, and get rid of the previous
field definition constants.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c                | 47 +++++++++--------
 drivers/net/ipa/gsi_reg.h            | 78 ++++++++++++++++------------
 drivers/net/ipa/reg/gsi_reg-v3.1.c   | 59 ++++++++++++++++++---
 drivers/net/ipa/reg/gsi_reg-v3.5.1.c | 70 ++++++++++++++++++++++---
 drivers/net/ipa/reg/gsi_reg-v4.0.c   | 74 +++++++++++++++++++++++---
 drivers/net/ipa/reg/gsi_reg-v4.11.c  | 76 ++++++++++++++++++++++++---
 drivers/net/ipa/reg/gsi_reg-v4.5.c   | 75 +++++++++++++++++++++++---
 drivers/net/ipa/reg/gsi_reg-v4.9.c   | 75 +++++++++++++++++++++++---
 8 files changed, 452 insertions(+), 102 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 7c4e458364236..f44d2d843de12 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -431,8 +431,8 @@ static void gsi_evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 	gsi_irq_ev_ctrl_enable(gsi, evt_ring_id);
 
 	reg = gsi_reg(gsi, EV_CH_CMD);
-	val = u32_encode_bits(evt_ring_id, EV_CHID_FMASK);
-	val |= u32_encode_bits(opcode, EV_OPCODE_FMASK);
+	val = reg_encode(reg, EV_CHID, evt_ring_id);
+	val |= reg_encode(reg, EV_OPCODE, opcode);
 
 	timeout = !gsi_command(gsi, reg_offset(reg), val);
 
@@ -548,8 +548,8 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 	gsi_irq_ch_ctrl_enable(gsi, channel_id);
 
 	reg = gsi_reg(gsi, CH_CMD);
-	val = u32_encode_bits(channel_id, CH_CHID_FMASK);
-	val |= u32_encode_bits(opcode, CH_OPCODE_FMASK);
+	val = reg_encode(reg, CH_CHID, channel_id);
+	val |= reg_encode(reg, CH_OPCODE, opcode);
 
 	timeout = !gsi_command(gsi, reg_offset(reg), val);
 
@@ -1220,28 +1220,29 @@ gsi_isr_glob_evt_err(struct gsi *gsi, u32 err_ee, u32 evt_ring_id, u32 code)
 /* Global error interrupt handler */
 static void gsi_isr_glob_err(struct gsi *gsi)
 {
+	const struct reg *log_reg;
+	const struct reg *clr_reg;
 	enum gsi_err_type type;
 	enum gsi_err_code code;
-	const struct reg *reg;
 	u32 offset;
 	u32 which;
 	u32 val;
 	u32 ee;
 
 	/* Get the logged error, then reinitialize the log */
-	reg = gsi_reg(gsi, ERROR_LOG);
-	offset = reg_offset(reg);
+	log_reg = gsi_reg(gsi, ERROR_LOG);
+	offset = reg_offset(log_reg);
 	val = ioread32(gsi->virt + offset);
 	iowrite32(0, gsi->virt + offset);
 
-	reg = gsi_reg(gsi, ERROR_LOG_CLR);
-	iowrite32(~0, gsi->virt + reg_offset(reg));
+	clr_reg = gsi_reg(gsi, ERROR_LOG_CLR);
+	iowrite32(~0, gsi->virt + reg_offset(clr_reg));
 
 	/* Parse the error value */
-	ee = u32_get_bits(val, ERR_EE_FMASK);
-	type = u32_get_bits(val, ERR_TYPE_FMASK);
-	which = u32_get_bits(val, ERR_VIRT_IDX_FMASK);
-	code = u32_get_bits(val, ERR_CODE_FMASK);
+	ee = reg_decode(log_reg, ERR_EE, val);
+	type = reg_decode(log_reg, ERR_TYPE, val);
+	which = reg_decode(log_reg, ERR_VIRT_IDX, val);
+	code = reg_decode(log_reg, ERR_CODE, val);
 
 	if (type == GSI_ERR_TYPE_CHAN)
 		gsi_isr_glob_chan_err(gsi, ee, which, code);
@@ -1279,7 +1280,7 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 	 */
 	reg = gsi_reg(gsi, CNTXT_SCRATCH_0);
 	val = ioread32(gsi->virt + reg_offset(reg));
-	result = u32_get_bits(val, GENERIC_EE_RESULT_FMASK);
+	result = reg_decode(reg, GENERIC_EE_RESULT, val);
 
 	switch (result) {
 	case GENERIC_EE_SUCCESS:
@@ -1801,16 +1802,16 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	offset = reg_offset(reg);
 	val = ioread32(gsi->virt + offset);
 
-	val &= ~GENERIC_EE_RESULT_FMASK;
+	val &= ~reg_fmask(reg, GENERIC_EE_RESULT);
 	iowrite32(val, gsi->virt + offset);
 
 	/* Now issue the command */
 	reg = gsi_reg(gsi, GENERIC_CMD);
-	val = u32_encode_bits(opcode, GENERIC_OPCODE_FMASK);
-	val |= u32_encode_bits(channel_id, GENERIC_CHID_FMASK);
-	val |= u32_encode_bits(GSI_EE_MODEM, GENERIC_EE_FMASK);
+	val = reg_encode(reg, GENERIC_OPCODE, opcode);
+	val |= reg_encode(reg, GENERIC_CHID, channel_id);
+	val |= reg_encode(reg, GENERIC_EE, GSI_EE_MODEM);
 	if (gsi->version >= IPA_VERSION_4_11)
-		val |= u32_encode_bits(params, GENERIC_PARAMS_FMASK);
+		val |= reg_encode(reg, GENERIC_PARAMS, params);
 
 	timeout = !gsi_command(gsi, reg_offset(reg), val);
 
@@ -1978,7 +1979,7 @@ static int gsi_irq_setup(struct gsi *gsi)
 
 	/* Writing 1 indicates IRQ interrupts; 0 would be MSI */
 	reg = gsi_reg(gsi, CNTXT_INTSET);
-	iowrite32(1, gsi->virt + reg_offset(reg));
+	iowrite32(reg_bit(reg, INTYPE), gsi->virt + reg_offset(reg));
 
 	/* Disable all interrupt types */
 	gsi_irq_type_update(gsi, 0);
@@ -2040,7 +2041,7 @@ static int gsi_ring_setup(struct gsi *gsi)
 	reg = gsi_reg(gsi, HW_PARAM_2);
 	val = ioread32(gsi->virt + reg_offset(reg));
 
-	count = u32_get_bits(val, NUM_CH_PER_EE_FMASK);
+	count = reg_decode(reg, NUM_CH_PER_EE, val);
 	if (!count) {
 		dev_err(dev, "GSI reports zero channels supported\n");
 		return -EINVAL;
@@ -2052,7 +2053,7 @@ static int gsi_ring_setup(struct gsi *gsi)
 	}
 	gsi->channel_count = count;
 
-	count = u32_get_bits(val, NUM_EV_PER_EE_FMASK);
+	count = reg_decode(reg, NUM_EV_PER_EE, val);
 	if (!count) {
 		dev_err(dev, "GSI reports zero event rings supported\n");
 		return -EINVAL;
@@ -2078,7 +2079,7 @@ int gsi_setup(struct gsi *gsi)
 	/* Here is where we first touch the GSI hardware */
 	reg = gsi_reg(gsi, GSI_STATUS);
 	val = ioread32(gsi->virt + reg_offset(reg));
-	if (!(val & ENABLED_FMASK)) {
+	if (!(val & reg_bit(reg, ENABLED))) {
 		dev_err(gsi->dev, "GSI has not been enabled\n");
 		return -EIO;
 	}
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 780eac742a9d8..5eda4def7ac40 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -163,11 +163,15 @@ enum gsi_reg_ch_c_ev_ch_e_cntxt_8_field_id {
 };
 
 /* GSI_STATUS register */
-#define ENABLED_FMASK			GENMASK(0, 0)
+enum gsi_reg_gsi_status_field_id {
+	ENABLED,
+};
 
 /* CH_CMD register */
-#define CH_CHID_FMASK			GENMASK(7, 0)
-#define CH_OPCODE_FMASK			GENMASK(31, 24)
+enum gsi_reg_gsi_ch_cmd_field_id {
+	CH_CHID,
+	CH_OPCODE,
+};
 
 /** enum gsi_ch_cmd_opcode - CH_OPCODE field values in CH_CMD */
 enum gsi_ch_cmd_opcode {
@@ -180,8 +184,10 @@ enum gsi_ch_cmd_opcode {
 };
 
 /* EV_CH_CMD register */
-#define EV_CHID_FMASK			GENMASK(7, 0)
-#define EV_OPCODE_FMASK			GENMASK(31, 24)
+enum gsi_ev_ch_cmd_field_id {
+	EV_CHID,
+	EV_OPCODE,
+};
 
 /** enum gsi_evt_cmd_opcode - EV_OPCODE field values in EV_CH_CMD */
 enum gsi_evt_cmd_opcode {
@@ -191,10 +197,12 @@ enum gsi_evt_cmd_opcode {
 };
 
 /* GENERIC_CMD register */
-#define GENERIC_OPCODE_FMASK		GENMASK(4, 0)
-#define GENERIC_CHID_FMASK		GENMASK(9, 5)
-#define GENERIC_EE_FMASK		GENMASK(13, 10)
-#define GENERIC_PARAMS_FMASK		GENMASK(31, 24)	/* IPA v4.11+ */
+enum gsi_generic_cmd_field_id {
+	GENERIC_OPCODE,
+	GENERIC_CHID,
+	GENERIC_EE,
+	GENERIC_PARAMS,					/* IPA v4.11+ */
+};
 
 /** enum gsi_generic_cmd_opcode - GENERIC_OPCODE field values in GENERIC_CMD */
 enum gsi_generic_cmd_opcode {
@@ -206,19 +214,19 @@ enum gsi_generic_cmd_opcode {
 };
 
 /* HW_PARAM_2 register */				/* IPA v3.5.1+ */
-#define IRAM_SIZE_FMASK			GENMASK(2, 0)
-#define NUM_CH_PER_EE_FMASK		GENMASK(7, 3)
-#define NUM_EV_PER_EE_FMASK		GENMASK(12, 8)
-#define GSI_CH_PEND_TRANSLATE_FMASK	GENMASK(13, 13)
-#define GSI_CH_FULL_LOGIC_FMASK		GENMASK(14, 14)
-/* Fields below are present for IPA v4.0 and above */
-#define GSI_USE_SDMA_FMASK		GENMASK(15, 15)
-#define GSI_SDMA_N_INT_FMASK		GENMASK(18, 16)
-#define GSI_SDMA_MAX_BURST_FMASK	GENMASK(26, 19)
-#define GSI_SDMA_N_IOVEC_FMASK		GENMASK(29, 27)
-/* Fields below are present for IPA v4.2 and above */
-#define GSI_USE_RD_WR_ENG_FMASK		GENMASK(30, 30)
-#define GSI_USE_INTER_EE_FMASK		GENMASK(31, 31)
+enum gsi_hw_param_2_field_id {
+	IRAM_SIZE,
+	NUM_CH_PER_EE,
+	NUM_EV_PER_EE,
+	GSI_CH_PEND_TRANSLATE,
+	GSI_CH_FULL_LOGIC,
+	GSI_USE_SDMA,					/* IPA v4.0+ */
+	GSI_SDMA_N_INT,					/* IPA v4.0+ */
+	GSI_SDMA_MAX_BURST,				/* IPA v4.0+ */
+	GSI_SDMA_N_IOVEC,				/* IPA v4.0+ */
+	GSI_USE_RD_WR_ENG,				/* IPA v4.2+ */
+	GSI_USE_INTER_EE,				/* IPA v4.2+ */
+};
 
 /** enum gsi_iram_size - IRAM_SIZE field values in HW_PARAM_2 */
 enum gsi_iram_size {
@@ -272,16 +280,20 @@ enum gsi_general_irq_id {
 };
 
 /* CNTXT_INTSET register */
-#define INTYPE_FMASK			GENMASK(0, 0)
+enum gsi_cntxt_intset_field_id {
+	INTYPE,
+};
 
 /* ERROR_LOG register */
-#define ERR_ARG3_FMASK			GENMASK(3, 0)
-#define ERR_ARG2_FMASK			GENMASK(7, 4)
-#define ERR_ARG1_FMASK			GENMASK(11, 8)
-#define ERR_CODE_FMASK			GENMASK(15, 12)
-#define ERR_VIRT_IDX_FMASK		GENMASK(23, 19)
-#define ERR_TYPE_FMASK			GENMASK(27, 24)
-#define ERR_EE_FMASK			GENMASK(31, 28)
+enum gsi_error_log_field_id {
+	ERR_ARG3,
+	ERR_ARG2,
+	ERR_ARG1,
+	ERR_CODE,
+	ERR_VIRT_IDX,
+	ERR_TYPE,
+	ERR_EE,
+};
 
 /** enum gsi_err_code - ERR_CODE field values in EE_ERR_LOG */
 enum gsi_err_code {
@@ -303,8 +315,10 @@ enum gsi_err_type {
 };
 
 /* CNTXT_SCRATCH_0 register */
-#define INTER_EE_RESULT_FMASK		GENMASK(2, 0)
-#define GENERIC_EE_RESULT_FMASK		GENMASK(7, 5)
+enum gsi_cntxt_scratch_0_field_id {
+	INTER_EE_RESULT,
+	GENERIC_EE_RESULT,
+};
 
 /** enum gsi_generic_ee_result - GENERIC_EE_RESULT field values in SCRATCH_0 */
 enum gsi_generic_ee_result {
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
index 36595b21dff7b..651c8a7ed6116 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -55,7 +55,18 @@ static const u32 reg_ch_c_qos_fmask[] = {
 
 REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
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
+REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
 REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
 
@@ -132,13 +143,35 @@ REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
 	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
 
-REG(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+static const u32 reg_gsi_status_fmask[] = {
+	[ENABLED]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
 
-REG(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
 
-REG(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ch_cmd_fmask[] = {
+	[CH_CHID]					= GENMASK(7, 0),
+	[CH_OPCODE]					= GENMASK(31, 24),
+};
 
-REG(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_ev_ch_cmd_fmask[] = {
+	[EV_CHID]					= GENMASK(7, 0),
+	[EV_OPCODE]					= GENMASK(31, 24),
+};
+
+REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_generic_cmd_fmask[] = {
+	[GENERIC_OPCODE]				= GENMASK(4, 0),
+	[GENERIC_CHID]					= GENMASK(9, 5),
+	[GENERIC_EE]					= GENMASK(13, 10),
+						/* Bits 14-31 reserved */
+};
+
+REG_FIELDS(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
 
@@ -180,9 +213,21 @@ REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+static const u32 reg_cntxt_intset_fmask[] = {
+	[INTYPE]					= BIT(0)
+						/* Bits 1-31 reserved */
+};
 
-REG(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_cntxt_scratch_0_fmask[] = {
+	[INTER_EE_RESULT]				= GENMASK(2, 0),
+						/* Bits 3-4 reserved */
+	[GENERIC_EE_RESULT]				= GENMASK(7, 5),
+						/* Bits 8-31 reserved */
+};
+
+REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
 
 static const struct reg *reg_array[] = {
 	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
index a30bfbfa6c1fd..0b39f8374ec17 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
@@ -55,7 +55,18 @@ static const u32 reg_ch_c_qos_fmask[] = {
 
 REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
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
+REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
 REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
 
@@ -132,15 +143,46 @@ REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
 	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
 
-REG(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+static const u32 reg_gsi_status_fmask[] = {
+	[ENABLED]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
 
-REG(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
 
-REG(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ch_cmd_fmask[] = {
+	[CH_CHID]					= GENMASK(7, 0),
+	[CH_OPCODE]					= GENMASK(31, 24),
+};
 
-REG(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
 
-REG(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ev_ch_cmd_fmask[] = {
+	[EV_CHID]					= GENMASK(7, 0),
+	[EV_OPCODE]					= GENMASK(31, 24),
+};
+
+REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_generic_cmd_fmask[] = {
+	[GENERIC_OPCODE]				= GENMASK(4, 0),
+	[GENERIC_CHID]					= GENMASK(9, 5),
+	[GENERIC_EE]					= GENMASK(13, 10),
+						/* Bits 14-31 reserved */
+};
+
+REG_FIELDS(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_hw_param_2_fmask[] = {
+	[IRAM_SIZE]					= GENMASK(2, 0),
+	[NUM_CH_PER_EE]					= GENMASK(7, 3),
+	[NUM_EV_PER_EE]					= GENMASK(12, 8),
+	[GSI_CH_PEND_TRANSLATE]				= BIT(13),
+	[GSI_CH_FULL_LOGIC]				= BIT(14),
+						/* Bits 15-31 reserved */
+};
+
+REG_FIELDS(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
 
@@ -182,9 +224,21 @@ REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+static const u32 reg_cntxt_intset_fmask[] = {
+	[INTYPE]					= BIT(0)
+						/* Bits 1-31 reserved */
+};
 
-REG(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_cntxt_scratch_0_fmask[] = {
+	[INTER_EE_RESULT]				= GENMASK(2, 0),
+						/* Bits 3-4 reserved */
+	[GENERIC_EE_RESULT]				= GENMASK(7, 5),
+						/* Bits 8-31 reserved */
+};
+
+REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
 
 static const struct reg *reg_array[] = {
 	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.0.c b/drivers/net/ipa/reg/gsi_reg-v4.0.c
index c0042fb9e760f..5a979ef4caad3 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.0.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.0.c
@@ -56,7 +56,18 @@ static const u32 reg_ch_c_qos_fmask[] = {
 
 REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
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
+REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
 REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
 
@@ -133,15 +144,50 @@ REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
 	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
 
-REG(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+static const u32 reg_gsi_status_fmask[] = {
+	[ENABLED]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
 
-REG(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
 
-REG(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ch_cmd_fmask[] = {
+	[CH_CHID]					= GENMASK(7, 0),
+	[CH_OPCODE]					= GENMASK(31, 24),
+};
 
-REG(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
 
-REG(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ev_ch_cmd_fmask[] = {
+	[EV_CHID]					= GENMASK(7, 0),
+	[EV_OPCODE]					= GENMASK(31, 24),
+};
+
+REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_generic_cmd_fmask[] = {
+	[GENERIC_OPCODE]				= GENMASK(4, 0),
+	[GENERIC_CHID]					= GENMASK(9, 5),
+	[GENERIC_EE]					= GENMASK(13, 10),
+						/* Bits 14-31 reserved */
+};
+
+REG_FIELDS(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_hw_param_2_fmask[] = {
+	[IRAM_SIZE]					= GENMASK(2, 0),
+	[NUM_CH_PER_EE]					= GENMASK(7, 3),
+	[NUM_EV_PER_EE]					= GENMASK(12, 8),
+	[GSI_CH_PEND_TRANSLATE]				= BIT(13),
+	[GSI_CH_FULL_LOGIC]				= BIT(14),
+	[GSI_USE_SDMA]					= BIT(15),
+	[GSI_SDMA_N_INT]				= GENMASK(18, 16),
+	[GSI_SDMA_MAX_BURST]				= GENMASK(26, 19),
+	[GSI_SDMA_N_IOVEC]				= GENMASK(29, 27),
+						/* Bits 30-31 reserved */
+};
+
+REG_FIELDS(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
 
@@ -183,9 +229,21 @@ REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+static const u32 reg_cntxt_intset_fmask[] = {
+	[INTYPE]					= BIT(0)
+						/* Bits 1-31 reserved */
+};
 
-REG(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_cntxt_scratch_0_fmask[] = {
+	[INTER_EE_RESULT]				= GENMASK(2, 0),
+						/* Bits 3-4 reserved */
+	[GENERIC_EE_RESULT]				= GENMASK(7, 5),
+						/* Bits 8-31 reserved */
+};
+
+REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
 
 static const struct reg *reg_array[] = {
 	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.11.c b/drivers/net/ipa/reg/gsi_reg-v4.11.c
index 4d8c4a9c9deb2..d975973306598 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.11.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.11.c
@@ -59,7 +59,18 @@ static const u32 reg_ch_c_qos_fmask[] = {
 
 REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
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
+REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
 REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
 
@@ -136,15 +147,52 @@ REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
 	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
 
-REG(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+static const u32 reg_gsi_status_fmask[] = {
+	[ENABLED]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
 
-REG(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
 
-REG(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ch_cmd_fmask[] = {
+	[CH_CHID]					= GENMASK(7, 0),
+	[CH_OPCODE]					= GENMASK(31, 24),
+};
 
-REG(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
 
-REG(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ev_ch_cmd_fmask[] = {
+	[EV_CHID]					= GENMASK(7, 0),
+	[EV_OPCODE]					= GENMASK(31, 24),
+};
+
+REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_generic_cmd_fmask[] = {
+	[GENERIC_OPCODE]				= GENMASK(4, 0),
+	[GENERIC_CHID]					= GENMASK(9, 5),
+	[GENERIC_EE]					= GENMASK(13, 10),
+						/* Bits 14-23 reserved */
+	[GENERIC_PARAMS]				= GENMASK(31, 24),
+};
+
+REG_FIELDS(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_hw_param_2_fmask[] = {
+	[IRAM_SIZE]					= GENMASK(2, 0),
+	[NUM_CH_PER_EE]					= GENMASK(7, 3),
+	[NUM_EV_PER_EE]					= GENMASK(12, 8),
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
+REG_FIELDS(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
 
@@ -186,9 +234,21 @@ REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+static const u32 reg_cntxt_intset_fmask[] = {
+	[INTYPE]					= BIT(0)
+						/* Bits 1-31 reserved */
+};
 
-REG(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_cntxt_scratch_0_fmask[] = {
+	[INTER_EE_RESULT]				= GENMASK(2, 0),
+						/* Bits 3-4 reserved */
+	[GENERIC_EE_RESULT]				= GENMASK(7, 5),
+						/* Bits 8-31 reserved */
+};
+
+REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
 
 static const struct reg *reg_array[] = {
 	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.5.c b/drivers/net/ipa/reg/gsi_reg-v4.5.c
index ace13fb2d5d2b..13c66b29840ee 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.5.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.5.c
@@ -58,7 +58,18 @@ static const u32 reg_ch_c_qos_fmask[] = {
 
 REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
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
+REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
 REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
 
@@ -135,15 +146,51 @@ REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
 	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
 
-REG(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+static const u32 reg_gsi_status_fmask[] = {
+	[ENABLED]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
 
-REG(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
 
-REG(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ch_cmd_fmask[] = {
+	[CH_CHID]					= GENMASK(7, 0),
+	[CH_OPCODE]					= GENMASK(31, 24),
+};
 
-REG(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
 
-REG(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ev_ch_cmd_fmask[] = {
+	[EV_CHID]					= GENMASK(7, 0),
+	[EV_OPCODE]					= GENMASK(31, 24),
+};
+
+REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_generic_cmd_fmask[] = {
+	[GENERIC_OPCODE]				= GENMASK(4, 0),
+	[GENERIC_CHID]					= GENMASK(9, 5),
+	[GENERIC_EE]					= GENMASK(13, 10),
+						/* Bits 14-31 reserved */
+};
+
+REG_FIELDS(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_hw_param_2_fmask[] = {
+	[IRAM_SIZE]					= GENMASK(2, 0),
+	[NUM_CH_PER_EE]					= GENMASK(7, 3),
+	[NUM_EV_PER_EE]					= GENMASK(12, 8),
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
+REG_FIELDS(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
 
@@ -185,9 +232,21 @@ REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+static const u32 reg_cntxt_intset_fmask[] = {
+	[INTYPE]					= BIT(0)
+						/* Bits 1-31 reserved */
+};
 
-REG(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_cntxt_scratch_0_fmask[] = {
+	[INTER_EE_RESULT]				= GENMASK(2, 0),
+						/* Bits 3-4 reserved */
+	[GENERIC_EE_RESULT]				= GENMASK(7, 5),
+						/* Bits 8-31 reserved */
+};
+
+REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
 
 static const struct reg *reg_array[] = {
 	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.9.c b/drivers/net/ipa/reg/gsi_reg-v4.9.c
index 5d6670993fa83..a7d5732b72e90 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.9.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.9.c
@@ -59,7 +59,18 @@ static const u32 reg_ch_c_qos_fmask[] = {
 
 REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
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
+REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
 
 REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
 
@@ -136,15 +147,51 @@ REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
 	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
 
-REG(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+static const u32 reg_gsi_status_fmask[] = {
+	[ENABLED]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
 
-REG(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
 
-REG(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ch_cmd_fmask[] = {
+	[CH_CHID]					= GENMASK(7, 0),
+	[CH_OPCODE]					= GENMASK(31, 24),
+};
 
-REG(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
 
-REG(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
+static const u32 reg_ev_ch_cmd_fmask[] = {
+	[EV_CHID]					= GENMASK(7, 0),
+	[EV_OPCODE]					= GENMASK(31, 24),
+};
+
+REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_generic_cmd_fmask[] = {
+	[GENERIC_OPCODE]				= GENMASK(4, 0),
+	[GENERIC_CHID]					= GENMASK(9, 5),
+	[GENERIC_EE]					= GENMASK(13, 10),
+						/* Bits 14-31 reserved */
+};
+
+REG_FIELDS(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_hw_param_2_fmask[] = {
+	[IRAM_SIZE]					= GENMASK(2, 0),
+	[NUM_CH_PER_EE]					= GENMASK(7, 3),
+	[NUM_EV_PER_EE]					= GENMASK(12, 8),
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
+REG_FIELDS(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
 
@@ -186,9 +233,21 @@ REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+static const u32 reg_cntxt_intset_fmask[] = {
+	[INTYPE]					= BIT(0)
+						/* Bits 1-31 reserved */
+};
 
-REG(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+
+static const u32 reg_cntxt_scratch_0_fmask[] = {
+	[INTER_EE_RESULT]				= GENMASK(2, 0),
+						/* Bits 3-4 reserved */
+	[GENERIC_EE_RESULT]				= GENMASK(7, 5),
+						/* Bits 8-31 reserved */
+};
+
+REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
 
 static const struct reg *reg_array[] = {
 	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
-- 
2.34.1

