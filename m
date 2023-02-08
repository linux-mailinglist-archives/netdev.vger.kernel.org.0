Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975CB68F93C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 21:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjBHU5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 15:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjBHU5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 15:57:35 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B5B4743E
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 12:57:29 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id b9so14186ilh.12
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 12:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHw8LxyktGvBBZjQe2AWErj6jl2jKiX9HLPr6DFe5P0=;
        b=o7n/r0ZHdjBBS06spubMIYAJs+CaIpplF/t0KbnlavcCL9Zcpud7z0t5gNHLoHt9Lq
         PbW9eFx5S6k41WLdeH0ZysR8vg86OM2y4FdMniZpm32Mi/TkTv6j3IL09Mryi6vdTzD/
         SSELAnrjeHjbgWSt8RyUDlXcObrA1vQc7GAx1PNyvcYadWuM+aXS2KHeNeXmfn8wtDT3
         8jizkOtbKrRwlkMbwZXsFfxb7DFGhxUqqZrZMw8uD38Ffgj6M5EZlU5spz8+jgH6Nphj
         kZ/SGqrLA3HsTiUNcPaY66oZiJca7iFxqtf3E6Zotpb56bVSusdafdd9KEyQsNNbF1hV
         /euA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gHw8LxyktGvBBZjQe2AWErj6jl2jKiX9HLPr6DFe5P0=;
        b=sG1mcZolit/n3p03+qvq3pbXkbMlDivC3ZAMvyu+5t6gNuoHHPJAI5Dj36TPJBlDNG
         FXw8mxYqBop3mUgN4IxlAtJ+ED3Vjcc7ZP4dEzWB9ucqBL/TjwmEQllSfea/4jCXOAnj
         ZqRt2g8xNhKibI3YRDZUTpJob0nfPO3hS3TwUtlVOIUkaznNUq+HZeSQVAMCFWYKY8gh
         SEw+3ZQyJldaiMw4ugiEnQ6L3RtqgsYS/Hgyrd4p8J7lx/oN+IWOD7Wqjg1S9HPGgQg4
         X21eVRIpS0z3hsb4dBS3f6CmtxRomAxTOQ0DAtN5iYC76/y/w0DkvKT8Gcopc73x2Im9
         VorQ==
X-Gm-Message-State: AO0yUKXQ8qydpUf81TiNmDTdChCiOwstNIXgKxcAjyHiuY2VspIodovf
        j7vg59K0YY3o9hTZRidL3MdGew==
X-Google-Smtp-Source: AK7set+XQhGk1Xitosl00wavwT8EruyjYkQ391dhi0+SMcAHVHvENfO37iMn6oU6y94SNMr9OsX+Fg==
X-Received: by 2002:a05:6e02:1bab:b0:313:8e80:a4e0 with SMTP id n11-20020a056e021bab00b003138e80a4e0mr9724034ili.23.1675889848632;
        Wed, 08 Feb 2023 12:57:28 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id r6-20020a922a06000000b0031093e9c7fasm5236704ile.85.2023.02.08.12.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 12:57:26 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/9] net: ipa: GSI register cleanup
Date:   Wed,  8 Feb 2023 14:56:50 -0600
Message-Id: <20230208205653.177700-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230208205653.177700-1-elder@linaro.org>
References: <20230208205653.177700-1-elder@linaro.org>
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

Move some static inline function definitions out of "gsi_reg.h" and
into "gsi.c", which is the only place they're used.  Rename them so
their names identify the register they're associated with.

Move the gsi_channel_type enumerated type definition below the
offset and field definitions for the CH_C_CNTXT_0 register where
it's used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 41 +++++++++++++++++++++++++---
 drivers/net/ipa/gsi_reg.h | 56 +++++++++------------------------------
 2 files changed, 50 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index da90785e8df52..2cb1710f6ac3f 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -182,6 +182,41 @@ static bool gsi_channel_initialized(struct gsi_channel *channel)
 	return !!channel->gsi;
 }
 
+/* Encode the channel protocol for the CH_C_CNTXT_0 register */
+static u32 ch_c_cntxt_0_type_encode(enum ipa_version version,
+				    enum gsi_channel_type type)
+{
+	u32 val;
+
+	val = u32_encode_bits(type, CHTYPE_PROTOCOL_FMASK);
+	if (version < IPA_VERSION_4_5)
+		return val;
+
+	type >>= hweight32(CHTYPE_PROTOCOL_FMASK);
+
+	return val | u32_encode_bits(type, CHTYPE_PROTOCOL_MSB_FMASK);
+}
+
+/* Encode a channel ring buffer length for the CH_C_CNTXT_1 register */
+static u32 ch_c_cntxt_1_length_encode(enum ipa_version version, u32 length)
+{
+	if (version < IPA_VERSION_4_9)
+		return u32_encode_bits(length, GENMASK(15, 0));
+
+	return u32_encode_bits(length, GENMASK(19, 0));
+}
+
+/* Encode the length of the event channel ring buffer for the
+ * EV_CH_E_CNTXT_1 register.
+ */
+static u32 ev_ch_e_cntxt_1_length_encode(enum ipa_version version, u32 length)
+{
+	if (version < IPA_VERSION_4_9)
+		return u32_encode_bits(length, GENMASK(15, 0));
+
+	return u32_encode_bits(length, GENMASK(19, 0));
+}
+
 /* Update the GSI IRQ type register with the cached value */
 static void gsi_irq_type_update(struct gsi *gsi, u32 val)
 {
@@ -676,7 +711,7 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_0_OFFSET(evt_ring_id));
 
 	size = ring->count * GSI_RING_ELEMENT_SIZE;
-	val = ev_r_length_encoded(gsi->version, size);
+	val = ev_ch_e_cntxt_1_length_encode(gsi->version, size);
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_1_OFFSET(evt_ring_id));
 
 	/* The context 2 and 3 registers store the low-order and
@@ -765,14 +800,14 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	u32 val;
 
 	/* We program all channels as GPI type/protocol */
-	val = chtype_protocol_encoded(gsi->version, GSI_CHANNEL_TYPE_GPI);
+	val = ch_c_cntxt_0_type_encode(gsi->version, GSI_CHANNEL_TYPE_GPI);
 	if (channel->toward_ipa)
 		val |= CHTYPE_DIR_FMASK;
 	val |= u32_encode_bits(channel->evt_ring_id, ERINDEX_FMASK);
 	val |= u32_encode_bits(GSI_RING_ELEMENT_SIZE, ELEMENT_SIZE_FMASK);
 	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_0_OFFSET(channel_id));
 
-	val = r_length_encoded(gsi->version, size);
+	val = ch_c_cntxt_1_length_encode(gsi->version, size);
 	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_1_OFFSET(channel_id));
 
 	/* The context 2 and 3 registers store the low-order and
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 6af70b0b3a6a5..d171f65d41983 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -62,6 +62,18 @@
 
 /* All other register offsets are relative to gsi->virt */
 
+#define GSI_CH_C_CNTXT_0_OFFSET(ch) \
+			(0x0001c000 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
+#define CHTYPE_PROTOCOL_FMASK		GENMASK(2, 0)
+#define CHTYPE_DIR_FMASK		GENMASK(3, 3)
+#define EE_FMASK			GENMASK(7, 4)
+#define CHID_FMASK			GENMASK(12, 8)
+/* The next field is present for IPA v4.5 and above */
+#define CHTYPE_PROTOCOL_MSB_FMASK	GENMASK(13, 13)
+#define ERINDEX_FMASK			GENMASK(18, 14)
+#define CHSTATE_FMASK			GENMASK(23, 20)
+#define ELEMENT_SIZE_FMASK		GENMASK(31, 24)
+
 /** enum gsi_channel_type - CHTYPE_PROTOCOL field values in CH_C_CNTXT_0 */
 enum gsi_channel_type {
 	GSI_CHANNEL_TYPE_MHI			= 0x0,
@@ -76,46 +88,9 @@ enum gsi_channel_type {
 	GSI_CHANNEL_TYPE_11AD			= 0x9,
 };
 
-#define GSI_CH_C_CNTXT_0_OFFSET(ch) \
-			(0x0001c000 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
-#define CHTYPE_PROTOCOL_FMASK		GENMASK(2, 0)
-#define CHTYPE_DIR_FMASK		GENMASK(3, 3)
-#define EE_FMASK			GENMASK(7, 4)
-#define CHID_FMASK			GENMASK(12, 8)
-/* The next field is present for IPA v4.5 and above */
-#define CHTYPE_PROTOCOL_MSB_FMASK	GENMASK(13, 13)
-#define ERINDEX_FMASK			GENMASK(18, 14)
-#define CHSTATE_FMASK			GENMASK(23, 20)
-#define ELEMENT_SIZE_FMASK		GENMASK(31, 24)
-
-/* Encoded value for CH_C_CNTXT_0 register channel protocol fields */
-static inline u32
-chtype_protocol_encoded(enum ipa_version version, enum gsi_channel_type type)
-{
-	u32 val;
-
-	val = u32_encode_bits(type, CHTYPE_PROTOCOL_FMASK);
-	if (version < IPA_VERSION_4_5)
-		return val;
-
-	/* Encode upper bit(s) as well */
-	type >>= hweight32(CHTYPE_PROTOCOL_FMASK);
-	val |= u32_encode_bits(type, CHTYPE_PROTOCOL_MSB_FMASK);
-
-	return val;
-}
-
 #define GSI_CH_C_CNTXT_1_OFFSET(ch) \
 			(0x0001c004 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 
-/* Encoded value for CH_C_CNTXT_1 register R_LENGTH field */
-static inline u32 r_length_encoded(enum ipa_version version, u32 length)
-{
-	if (version < IPA_VERSION_4_9)
-		return u32_encode_bits(length, GENMASK(15, 0));
-	return u32_encode_bits(length, GENMASK(19, 0));
-}
-
 #define GSI_CH_C_CNTXT_2_OFFSET(ch) \
 			(0x0001c008 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 
@@ -167,13 +142,6 @@ enum gsi_prefetch_mode {
 
 #define GSI_EV_CH_E_CNTXT_1_OFFSET(ev) \
 			(0x0001d004 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-/* Encoded value for EV_CH_C_CNTXT_1 register EV_R_LENGTH field */
-static inline u32 ev_r_length_encoded(enum ipa_version version, u32 length)
-{
-	if (version < IPA_VERSION_4_9)
-		return u32_encode_bits(length, GENMASK(15, 0));
-	return u32_encode_bits(length, GENMASK(19, 0));
-}
 
 #define GSI_EV_CH_E_CNTXT_2_OFFSET(ev) \
 			(0x0001d008 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-- 
2.34.1

