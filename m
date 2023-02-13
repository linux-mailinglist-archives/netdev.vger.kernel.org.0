Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C6D694C72
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjBMQWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjBMQWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:22:39 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B259A1A664
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:36 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id v6so444407ilc.10
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ck+Fz4bxjvM7Rw9BBLCuLNuNUeduU8oplLg4oFI1lMA=;
        b=uMh/2y4cn/JvAr/6OE+omGGgwTMq+5ZgDNJKapY5vt5k/s569av9SwgRrgjgU1S4Zb
         3ohqe86YXtNokYot8HbcI11Cd+pArCg4bvGYegTRjPpFNuIiAxrPjhaDXXH4tKkVG4+i
         6/pwSsO+w2m0TCVXVpa0ZAPG/6WU+33hP6jdRrT7ay+EAp1DaRhnkzLVVU/g9bo+UH9X
         UFI+jMrXFrJdhZgUq7CtKSap6LFZ+gM4NYzmnYxVoMf8ndgiRYVpxdTk61W4NubUebGY
         qC0+eHjWT3f5v6dcTx7PTLyY4FGF1VNmv5zDHxNPWp6E8swh4+TMJmhEcBkn8x5SFa+M
         kSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ck+Fz4bxjvM7Rw9BBLCuLNuNUeduU8oplLg4oFI1lMA=;
        b=aN99wJGcXUAa0Yvw1mjEDSPdfKukcX3OlAUjpBW1xnN2wlcnoCpIQYMY4bPD/G35GV
         PePDWEoDuWiNMpxx/APC2SM4zfcE+iJ+/pFRJwDTZme7OOYv+L1UTKpogZwmTevRz1yQ
         fkVHeomLp0ZM4PZwLM0D91sUkPg6j0qs63dW1XbbB3JCmVy3FTAkqRUhMJhxeiw8g6+k
         wZm79Fs462HguGOwmcD5vfCGM6vjnrl7SXQSGYM9V1BqA7pgLBx9X1QfWpmZbyFyOHra
         cs6F4p05prbtPe97VJA/blbAt3SwicdJTq6hmF1l7QKKHo0ZETJP2kFY50NJNpVz5nCs
         yihw==
X-Gm-Message-State: AO0yUKXwFQqZ+O1be6K7TYmhOhJ9C/xZ6LpRjQPGpX6cYAu26PQZcTOn
        XJZgUTYD3un+lTt4LTNB7zndwg==
X-Google-Smtp-Source: AK7set+FhpuV4+RWPqdLs+lbyy3bMYVM8oXMc3gY3kZ73GYFS1bgZW3brAWNKwoczWm8zWBL4Nbd+A==
X-Received: by 2002:a05:6e02:2169:b0:313:bab3:2f3a with SMTP id s9-20020a056e02216900b00313bab32f3amr28291620ilv.22.1676305356008;
        Mon, 13 Feb 2023 08:22:36 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id x17-20020a92dc51000000b00313cbba0455sm1457831ilq.8.2023.02.13.08.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:22:35 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: define more fields for GSI registers
Date:   Mon, 13 Feb 2023 10:22:26 -0600
Message-Id: <20230213162229.604438-4-elder@linaro.org>
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

Beyond the CH_C_QOS register, two other registers whose offset is
related to channel number have fields within them.

Define the fields within the CH_C_CNTXT_0 GSI register, using an
enumerated type to identify the register's fields, and define an
array of field masks to use for that register's reg structure.

For the CH_C_CNTXT_1 GSI register, ch_c_cntxt_1_length_encode()
previously hid the difference in bit width in the channel ring
length field.  Instead, define a new field CH_R_LENGTH and encode
the ring size with reg_encode().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c                | 31 +++++++++-------------------
 drivers/net/ipa/gsi_reg.h            | 24 +++++++++++++--------
 drivers/net/ipa/reg/gsi_reg-v3.1.c   | 23 +++++++++++++++++++--
 drivers/net/ipa/reg/gsi_reg-v3.5.1.c | 23 +++++++++++++++++++--
 drivers/net/ipa/reg/gsi_reg-v4.0.c   | 23 +++++++++++++++++++--
 drivers/net/ipa/reg/gsi_reg-v4.5.c   | 23 +++++++++++++++++++--
 drivers/net/ipa/reg/gsi_reg-v4.9.c   | 23 +++++++++++++++++++--
 7 files changed, 130 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index cbf4b2d843acb..ff00c833043a9 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -164,9 +164,6 @@ static void gsi_validate_build(void)
 	 */
 	BUILD_BUG_ON(!is_power_of_2(GSI_RING_ELEMENT_SIZE));
 
-	/* The channel element size must fit in this field */
-	BUILD_BUG_ON(GSI_RING_ELEMENT_SIZE > field_max(ELEMENT_SIZE_FMASK));
-
 	/* The event ring element size must fit in this field */
 	BUILD_BUG_ON(GSI_RING_ELEMENT_SIZE > field_max(EV_ELEMENT_SIZE_FMASK));
 }
@@ -185,26 +182,18 @@ static bool gsi_channel_initialized(struct gsi_channel *channel)
 
 /* Encode the channel protocol for the CH_C_CNTXT_0 register */
 static u32 ch_c_cntxt_0_type_encode(enum ipa_version version,
+				    const struct reg *reg,
 				    enum gsi_channel_type type)
 {
 	u32 val;
 
-	val = u32_encode_bits(type, CHTYPE_PROTOCOL_FMASK);
+	val = reg_encode(reg, CHTYPE_PROTOCOL, type);
 	if (version < IPA_VERSION_4_5)
 		return val;
 
-	type >>= hweight32(CHTYPE_PROTOCOL_FMASK);
+	type >>= hweight32(reg_fmask(reg, CHTYPE_PROTOCOL));
 
-	return val | u32_encode_bits(type, CHTYPE_PROTOCOL_MSB_FMASK);
-}
-
-/* Encode a channel ring buffer length for the CH_C_CNTXT_1 register */
-static u32 ch_c_cntxt_1_length_encode(enum ipa_version version, u32 length)
-{
-	if (version < IPA_VERSION_4_9)
-		return u32_encode_bits(length, GENMASK(15, 0));
-
-	return u32_encode_bits(length, GENMASK(19, 0));
+	return val | reg_encode(reg, CHTYPE_PROTOCOL_MSB, type);
 }
 
 /* Encode the length of the event channel ring buffer for the
@@ -544,7 +533,7 @@ static enum gsi_channel_state gsi_channel_state(struct gsi_channel *channel)
 	reg = gsi_reg(gsi, CH_C_CNTXT_0);
 	val = ioread32(virt + reg_n_offset(reg, channel_id));
 
-	return u32_get_bits(val, CHSTATE_FMASK);
+	return reg_decode(reg, CHSTATE, val);
 }
 
 /* Issue a channel command and wait for it to complete */
@@ -862,15 +851,15 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	reg = gsi_reg(gsi, CH_C_CNTXT_0);
 
 	/* We program all channels as GPI type/protocol */
-	val = ch_c_cntxt_0_type_encode(gsi->version, GSI_CHANNEL_TYPE_GPI);
+	val = ch_c_cntxt_0_type_encode(gsi->version, reg, GSI_CHANNEL_TYPE_GPI);
 	if (channel->toward_ipa)
-		val |= CHTYPE_DIR_FMASK;
-	val |= u32_encode_bits(channel->evt_ring_id, ERINDEX_FMASK);
-	val |= u32_encode_bits(GSI_RING_ELEMENT_SIZE, ELEMENT_SIZE_FMASK);
+		val |= reg_bit(reg, CHTYPE_DIR);
+	val |= reg_encode(reg, ERINDEX, channel->evt_ring_id);
+	val |= reg_encode(reg, ELEMENT_SIZE, GSI_RING_ELEMENT_SIZE);
 	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 
 	reg = gsi_reg(gsi, CH_C_CNTXT_1);
-	val = ch_c_cntxt_1_length_encode(gsi->version, size);
+	val = reg_encode(reg, CH_R_LENGTH, size);
 	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 
 	/* The context 2 and 3 registers store the low-order and
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index f625afdfd6d9f..3f1a49a4f7c47 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -96,15 +96,16 @@ enum gsi_reg_id {
 };
 
 /* CH_C_CNTXT_0 register */
-#define CHTYPE_PROTOCOL_FMASK		GENMASK(2, 0)
-#define CHTYPE_DIR_FMASK		GENMASK(3, 3)
-#define EE_FMASK			GENMASK(7, 4)
-#define CHID_FMASK			GENMASK(12, 8)
-/* The next field is present for IPA v4.5 and above */
-#define CHTYPE_PROTOCOL_MSB_FMASK	GENMASK(13, 13)
-#define ERINDEX_FMASK			GENMASK(18, 14)
-#define CHSTATE_FMASK			GENMASK(23, 20)
-#define ELEMENT_SIZE_FMASK		GENMASK(31, 24)
+enum gsi_reg_ch_c_cntxt_0_field_id {
+	CHTYPE_PROTOCOL,
+	CHTYPE_DIR,
+	CH_EE,
+	CHID,
+	CHTYPE_PROTOCOL_MSB,				/* IPA v4.9+ */
+	ERINDEX,
+	CHSTATE,
+	ELEMENT_SIZE,
+};
 
 /** enum gsi_channel_type - CHTYPE_PROTOCOL field values in CH_C_CNTXT_0 */
 enum gsi_channel_type {
@@ -120,6 +121,11 @@ enum gsi_channel_type {
 	GSI_CHANNEL_TYPE_11AD			= 0x9,
 };
 
+/* CH_C_CNTXT_1 register */
+enum gsi_reg_ch_c_cntxt_1_field_id {
+	CH_R_LENGTH,
+};
+
 /* CH_C_QOS register */
 enum gsi_reg_ch_c_qos_field_id {
 	WRR_WEIGHT,
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
index 56cf487ae4fc6..4aa7a1c52cb35 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -18,9 +18,28 @@ REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
 
 /* All other register offsets are relative to gsi->virt */
 
-REG_STRIDE(CH_C_CNTXT_0, ch_c_cntxt_0, 0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ch_c_cntxt_0_fmask[] = {
+	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
+	[CHTYPE_DIR]					= BIT(3),
+	[CH_EE]						= GENMASK(7, 4),
+	[CHID]						= GENMASK(12, 8),
+						/* Bit 13 reserved */
+	[ERINDEX]					= GENMASK(18, 14),
+						/* Bit 19 reserved */
+	[CHSTATE]					= GENMASK(23, 20),
+	[ELEMENT_SIZE]					= GENMASK(31, 24),
+};
 
-REG_STRIDE(CH_C_CNTXT_1, ch_c_cntxt_1, 0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
+		  0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+
+static const u32 reg_ch_c_cntxt_1_fmask[] = {
+	[CH_R_LENGTH]					= GENMASK(15, 0),
+						/* Bits 16-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
+		  0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
index 866bae3ff530b..045061a870032 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
@@ -18,9 +18,28 @@ REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
 
 /* All other register offsets are relative to gsi->virt */
 
-REG_STRIDE(CH_C_CNTXT_0, ch_c_cntxt_0, 0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ch_c_cntxt_0_fmask[] = {
+	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
+	[CHTYPE_DIR]					= BIT(3),
+	[CH_EE]						= GENMASK(7, 4),
+	[CHID]						= GENMASK(12, 8),
+						/* Bit 13 reserved */
+	[ERINDEX]					= GENMASK(18, 14),
+						/* Bit 19 reserved */
+	[CHSTATE]					= GENMASK(23, 20),
+	[ELEMENT_SIZE]					= GENMASK(31, 24),
+};
 
-REG_STRIDE(CH_C_CNTXT_1, ch_c_cntxt_1, 0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
+		  0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+
+static const u32 reg_ch_c_cntxt_1_fmask[] = {
+	[CH_R_LENGTH]					= GENMASK(15, 0),
+						/* Bits 16-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
+		  0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.0.c b/drivers/net/ipa/reg/gsi_reg-v4.0.c
index 060876e4aab41..3374d4e9272d8 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.0.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.0.c
@@ -18,9 +18,28 @@ REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
 
 /* All other register offsets are relative to gsi->virt */
 
-REG_STRIDE(CH_C_CNTXT_0, ch_c_cntxt_0, 0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ch_c_cntxt_0_fmask[] = {
+	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
+	[CHTYPE_DIR]					= BIT(3),
+	[CH_EE]						= GENMASK(7, 4),
+	[CHID]						= GENMASK(12, 8),
+						/* Bit 13 reserved */
+	[ERINDEX]					= GENMASK(18, 14),
+						/* Bit 19 reserved */
+	[CHSTATE]					= GENMASK(23, 20),
+	[ELEMENT_SIZE]					= GENMASK(31, 24),
+};
 
-REG_STRIDE(CH_C_CNTXT_1, ch_c_cntxt_1, 0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
+		  0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+
+static const u32 reg_ch_c_cntxt_1_fmask[] = {
+	[CH_R_LENGTH]					= GENMASK(15, 0),
+						/* Bits 16-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
+		  0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.5.c b/drivers/net/ipa/reg/gsi_reg-v4.5.c
index 98121fd40fd8c..0502f3e635dab 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.5.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.5.c
@@ -18,9 +18,28 @@ REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
 
 /* All other register offsets are relative to gsi->virt */
 
-REG_STRIDE(CH_C_CNTXT_0, ch_c_cntxt_0, 0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
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
 
-REG_STRIDE(CH_C_CNTXT_1, ch_c_cntxt_1, 0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
+		  0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+
+static const u32 reg_ch_c_cntxt_1_fmask[] = {
+	[CH_R_LENGTH]					= GENMASK(15, 0),
+						/* Bits 16-31 reserved */
+};
+
+REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
+		  0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.9.c b/drivers/net/ipa/reg/gsi_reg-v4.9.c
index 72ff78863eaaf..2c61633fdb427 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.9.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.9.c
@@ -18,9 +18,28 @@ REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
 
 /* All other register offsets are relative to gsi->virt */
 
-REG_STRIDE(CH_C_CNTXT_0, ch_c_cntxt_0, 0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
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
 
-REG_STRIDE(CH_C_CNTXT_1, ch_c_cntxt_1, 0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
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
 
 REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
 
-- 
2.34.1

