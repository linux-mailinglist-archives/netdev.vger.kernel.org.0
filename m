Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DFF5EB45C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiIZWMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiIZWLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:11:52 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB3033A28
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:13 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id g8so6459655iob.0
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Uj9uiO0EqCh1vDGY/tRQRfi57lIykBVMF+MseJ731Ps=;
        b=moHpX3BAQtLsvOwDSLI/tccfJ2TjjtaRHvq4GacLnghgOC8J4BtFmPFo1keu5u/U2F
         47W2QMgHvI/DlZDI2PXVR8mcjUSgtPw+ZtgpSpYevWepNx6L82jevb7Ak4bwN6Xug/fq
         czxSC13EPH3OvWTEIFCj+1YtUewaOMBQj1y2rRCe/nUN0nW6d0p+1Z7MqjKJwEUXhSTY
         bfp1SXJG68IjkoL5vMarJk26KkCGR+G5b92HvCCsD7bdX4qYH6Bj3iCWXqYrMka7I60H
         bulQJT0mx++8PjnZCYBFJur6IMG8VSeG5PVuWm5NIboF+m4oc//m4ZoiB1s8hHlErOFa
         XsJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Uj9uiO0EqCh1vDGY/tRQRfi57lIykBVMF+MseJ731Ps=;
        b=LHB1c93R4JXROYUAtggtYoLSHkhUw+4xGqvvkIVHnNy2UgL200R5YbvuTZlw8pFDMf
         R5Ubromzc+o36BjKTHnNif0NqDaeYUZ30pyu4A3FhlzD0B92DU2P73o1Wk96fAA9YVJ8
         W0sBaCBBeDcK4nAS73RGSnqEeIEFYKwGB2sv+Oi12bz4g/T4zi3MloX8Jw0H4fTs3nmW
         V4kZlXQxz/QUwmWjeOtrrkNTEE7z/MN+FHOdHky1dd+ttyCCWjxAeOc12WFbNcQKBJaf
         RX39HYvn4m60knRnCOj2xvyYcXVDjgkISZpveQE0e5UMG2Ig8QspWuTz+aMiX/2AecGU
         eQdg==
X-Gm-Message-State: ACrzQf38vqzepDDWipIFdwGtgxnT/QNNaw99/Nkg/WdRA5DdzyBoSTY1
        7QT2KmLZfzmXM0/4VbQRdqEO5A==
X-Google-Smtp-Source: AMsMyM4UbM6SHjwnwYX1eiMA2N6UFdUy/GSvIYR7mf2fG+8akt0B/2bVDQjkJoVoVsSVC/nQib4IKw==
X-Received: by 2002:a05:6638:2392:b0:35a:6ba9:7424 with SMTP id q18-20020a056638239200b0035a6ba97424mr12583245jat.93.1664230212862;
        Mon, 26 Sep 2022 15:10:12 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:10:11 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 15/15] net: ipa: define remaining IPA register fields
Date:   Mon, 26 Sep 2022 17:09:31 -0500
Message-Id: <20220926220931.3261749-16-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926220931.3261749-1-elder@linaro.org>
References: <20220926220931.3261749-1-elder@linaro.org>
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

Define the fields for the ENDP_INIT_DEAGGR, ENDP_INIT_RSRC_GRP,
ENDP_INIT_SEQ, ENDP_STATUS, and ENDP_FILTER_ROUTER_HSH_CFG, and
IPA_IRQ_UC IPA registers for all supported IPA versions.

Create enumerated types to identify fields for these IPA registers.
Use IPA_REG_FIELDS() and IPA_REG_STRIDE_FIELDS() to specify the
field mask values defined for these registers, for each supported
version of IPA.

Use ipa_reg_encode() and ipa_reg_bit() to build up the values to be
written to these registers, remove an inline function and all the
*_FMASK symbols that are now no longer used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c       | 21 +++----
 drivers/net/ipa/ipa_reg.h            | 85 ++++++++++++++--------------
 drivers/net/ipa/ipa_table.c          |  6 +-
 drivers/net/ipa/ipa_uc.c             |  2 +-
 drivers/net/ipa/reg/ipa_reg-v3.1.c   | 70 ++++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c | 70 ++++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v4.11.c  | 69 +++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v4.2.c   | 46 +++++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.5.c   | 69 +++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v4.9.c   | 69 +++++++++++++++++++---
 10 files changed, 410 insertions(+), 97 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index f92964bea83d4..0da02d8d238d1 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1044,13 +1044,14 @@ static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
 
 static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
 {
+	u32 resource_group = endpoint->config.resource_group;
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
 	const struct ipa_reg *reg;
 	u32 val;
 
 	reg = ipa_reg(ipa, ENDP_INIT_RSRC_GRP);
-	val = rsrc_grp_encoded(ipa->version, endpoint->config.resource_group);
+	val = ipa_reg_encode(reg, ENDP_RSRC_GRP, resource_group);
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
@@ -1060,7 +1061,7 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
 	const struct ipa_reg *reg;
-	u32 val = 0;
+	u32 val;
 
 	if (!endpoint->toward_ipa)
 		return;		/* Register not valid for RX endpoints */
@@ -1068,12 +1069,12 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 	reg = ipa_reg(ipa, ENDP_INIT_SEQ);
 
 	/* Low-order byte configures primary packet processing */
-	val |= u32_encode_bits(endpoint->config.tx.seq_type, SEQ_TYPE_FMASK);
+	val = ipa_reg_encode(reg, SEQ_TYPE, endpoint->config.tx.seq_type);
 
 	/* Second byte (if supported) configures replicated packet processing */
 	if (ipa->version < IPA_VERSION_4_5)
-		val |= u32_encode_bits(endpoint->config.tx.seq_rep_type,
-				       SEQ_REP_TYPE_FMASK);
+		val |= ipa_reg_encode(reg, SEQ_REP_TYPE,
+				      endpoint->config.tx.seq_rep_type);
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
@@ -1130,7 +1131,7 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 
 	reg = ipa_reg(ipa, ENDP_STATUS);
 	if (endpoint->config.status_enable) {
-		val |= STATUS_EN_FMASK;
+		val |= ipa_reg_bit(reg, STATUS_EN);
 		if (endpoint->toward_ipa) {
 			enum ipa_endpoint_name name;
 			u32 status_endpoint_id;
@@ -1138,13 +1139,13 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 			name = endpoint->config.tx.status_endpoint;
 			status_endpoint_id = ipa->name_map[name]->endpoint_id;
 
-			val |= u32_encode_bits(status_endpoint_id,
-					       STATUS_ENDP_FMASK);
+			val |= ipa_reg_encode(reg, STATUS_ENDP,
+					      status_endpoint_id);
 		}
 		/* STATUS_LOCATION is 0, meaning status element precedes
-		 * packet (not present for IPA v4.5)
+		 * packet (not present for IPA v4.5+)
 		 */
-		/* STATUS_PKT_SUPPRESS_FMASK is 0 (not present for v3.5.1) */
+		/* STATUS_PKT_SUPPRESS_FMASK is 0 (not present for v4.0+) */
 	}
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index d4120eeb58cf3..f81381891a2e4 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -497,30 +497,25 @@ enum ipa_reg_endp_init_hol_block_timer_field_id {
 };
 
 /* ENDP_INIT_DEAGGR register */
-#define DEAGGR_HDR_LEN_FMASK			GENMASK(5, 0)
-#define SYSPIPE_ERR_DETECTION_FMASK		GENMASK(6, 6)
-#define PACKET_OFFSET_VALID_FMASK		GENMASK(7, 7)
-#define PACKET_OFFSET_LOCATION_FMASK		GENMASK(13, 8)
-#define IGNORE_MIN_PKT_ERR_FMASK		GENMASK(14, 14)
-#define MAX_PACKET_LEN_FMASK			GENMASK(31, 16)
+enum ipa_reg_endp_deaggr_field_id {
+	DEAGGR_HDR_LEN,
+	SYSPIPE_ERR_DETECTION,
+	PACKET_OFFSET_VALID,
+	PACKET_OFFSET_LOCATION,
+	IGNORE_MIN_PKT_ERR,
+	MAX_PACKET_LEN,
+};
 
 /* ENDP_INIT_RSRC_GRP register */
-/* Encoded value for ENDP_INIT_RSRC_GRP register RSRC_GRP field */
-static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
-{
-	if (version < IPA_VERSION_3_5 || version == IPA_VERSION_4_5)
-		return u32_encode_bits(rsrc_grp, GENMASK(2, 0));
-
-	if (version == IPA_VERSION_4_2 || version == IPA_VERSION_4_7)
-		return u32_encode_bits(rsrc_grp, GENMASK(0, 0));
-
-	return u32_encode_bits(rsrc_grp, GENMASK(1, 0));
-}
+enum ipa_reg_endp_init_rsrc_grp_field_id {
+	ENDP_RSRC_GRP,
+};
 
 /* ENDP_INIT_SEQ register */
-#define SEQ_TYPE_FMASK				GENMASK(7, 0)
-/* The next field must be zero for IPA v4.5+ */
-#define SEQ_REP_TYPE_FMASK			GENMASK(15, 8)
+enum ipa_reg_endp_init_seq_field_id {
+	SEQ_TYPE,
+	SEQ_REP_TYPE,					/* Not v4.5+ */
+};
 
 /**
  * enum ipa_seq_type - HPS and DPS sequencer type
@@ -565,31 +560,33 @@ enum ipa_seq_rep_type {
 };
 
 /* ENDP_STATUS register */
-#define STATUS_EN_FMASK				GENMASK(0, 0)
-#define STATUS_ENDP_FMASK			GENMASK(5, 1)
-/* The next field is not present for IPA v4.5+ */
-#define STATUS_LOCATION_FMASK			GENMASK(8, 8)
-/* The next field is present for IPA v4.0+ */
-#define STATUS_PKT_SUPPRESS_FMASK		GENMASK(9, 9)
+enum ipa_reg_endp_status_field_id {
+	STATUS_EN,
+	STATUS_ENDP,
+	STATUS_LOCATION,				/* Not v4.5+ */
+	STATUS_PKT_SUPPRESS,				/* v4.0+ */
+};
 
 /* ENDP_FILTER_ROUTER_HSH_CFG register */
-#define FILTER_HASH_MSK_SRC_ID_FMASK		GENMASK(0, 0)
-#define FILTER_HASH_MSK_SRC_IP_FMASK		GENMASK(1, 1)
-#define FILTER_HASH_MSK_DST_IP_FMASK		GENMASK(2, 2)
-#define FILTER_HASH_MSK_SRC_PORT_FMASK		GENMASK(3, 3)
-#define FILTER_HASH_MSK_DST_PORT_FMASK		GENMASK(4, 4)
-#define FILTER_HASH_MSK_PROTOCOL_FMASK		GENMASK(5, 5)
-#define FILTER_HASH_MSK_METADATA_FMASK		GENMASK(6, 6)
-#define IPA_REG_ENDP_FILTER_HASH_MSK_ALL	GENMASK(6, 0)
+enum ipa_reg_endp_filter_router_hsh_cfg_field_id {
+	FILTER_HASH_MSK_SRC_ID,
+	FILTER_HASH_MSK_SRC_IP,
+	FILTER_HASH_MSK_DST_IP,
+	FILTER_HASH_MSK_SRC_PORT,
+	FILTER_HASH_MSK_DST_PORT,
+	FILTER_HASH_MSK_PROTOCOL,
+	FILTER_HASH_MSK_METADATA,
+	FILTER_HASH_MSK_ALL,		/* Bitwise OR of the above 6 fields */
 
-#define ROUTER_HASH_MSK_SRC_ID_FMASK		GENMASK(16, 16)
-#define ROUTER_HASH_MSK_SRC_IP_FMASK		GENMASK(17, 17)
-#define ROUTER_HASH_MSK_DST_IP_FMASK		GENMASK(18, 18)
-#define ROUTER_HASH_MSK_SRC_PORT_FMASK		GENMASK(19, 19)
-#define ROUTER_HASH_MSK_DST_PORT_FMASK		GENMASK(20, 20)
-#define ROUTER_HASH_MSK_PROTOCOL_FMASK		GENMASK(21, 21)
-#define ROUTER_HASH_MSK_METADATA_FMASK		GENMASK(22, 22)
-#define IPA_REG_ENDP_ROUTER_HASH_MSK_ALL	GENMASK(22, 16)
+	ROUTER_HASH_MSK_SRC_ID,
+	ROUTER_HASH_MSK_SRC_IP,
+	ROUTER_HASH_MSK_DST_IP,
+	ROUTER_HASH_MSK_SRC_PORT,
+	ROUTER_HASH_MSK_DST_PORT,
+	ROUTER_HASH_MSK_PROTOCOL,
+	ROUTER_HASH_MSK_METADATA,
+	ROUTER_HASH_MSK_ALL,		/* Bitwise OR of the above 6 fields */
+};
 
 /* IPA_IRQ_STTS, IPA_IRQ_EN, and IPA_IRQ_CLR registers */
 /**
@@ -668,7 +665,9 @@ enum ipa_irq_id {
 };
 
 /* IPA_IRQ_UC register */
-#define UC_INTR_FMASK				GENMASK(0, 0)
+enum ipa_reg_ipa_irq_uc_field_id {
+	UC_INTR,
+};
 
 extern const struct ipa_regs ipa_regs_v3_1;
 extern const struct ipa_regs ipa_regs_v3_5_1;
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 32873e6cb4ad1..02cab1b59f21a 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -528,12 +528,12 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 	u32 val;
 
 	reg = ipa_reg(ipa, ENDP_FILTER_ROUTER_HSH_CFG);
+
 	offset = ipa_reg_n_offset(reg, endpoint_id);
-
 	val = ioread32(endpoint->ipa->reg_virt + offset);
 
 	/* Zero all filter-related fields, preserving the rest */
-	val &= ~IPA_REG_ENDP_FILTER_HASH_MSK_ALL;
+	val &= ~ipa_reg_fmask(reg, FILTER_HASH_MSK_ALL);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
@@ -584,7 +584,7 @@ static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
 	val = ioread32(ipa->reg_virt + offset);
 
 	/* Zero all route-related fields, preserving the rest */
-	val &= ~IPA_REG_ENDP_ROUTER_HASH_MSK_ALL;
+	val &= ~ipa_reg_fmask(reg, ROUTER_HASH_MSK_ALL);
 
 	iowrite32(val, ipa->reg_virt + offset);
 }
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 35aa12fac22f7..cf21f1a87a880 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -234,7 +234,7 @@ static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 
 	/* Use an interrupt to tell the microcontroller the command is ready */
 	reg = ipa_reg(ipa, IPA_IRQ_UC);
-	val = u32_encode_bits(1, UC_INTR_FMASK);
+	val = ipa_reg_bit(reg, UC_INTR);
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index 7fd231807f37d..116b27717e3d7 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -339,16 +339,67 @@ static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
 IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
 		      0x00000830, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
+	[SYSPIPE_ERR_DETECTION]				= BIT(6),
+	[PACKET_OFFSET_VALID]				= BIT(7),
+	[PACKET_OFFSET_LOCATION]			= GENMASK(13, 8),
+	[IGNORE_MIN_PKT_ERR]				= BIT(14),
+						/* Bit 15 reserved */
+	[MAX_PACKET_LEN]				= GENMASK(31, 16),
+};
 
-IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+	[ENDP_RSRC_GRP]					= GENMASK(2, 0),
+						/* Bits 3-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
+		      0x00000838, 0x0070);
 
-IPA_REG_STRIDE(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-	       0x0000085c, 0x0070);
+static const u32 ipa_reg_endp_init_seq_fmask[] = {
+	[SEQ_TYPE]					= GENMASK(7, 0),
+	[SEQ_REP_TYPE]					= GENMASK(15, 8),
+						/* Bits 16-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+static const u32 ipa_reg_endp_status_fmask[] = {
+	[STATUS_EN]					= BIT(0),
+	[STATUS_ENDP]					= GENMASK(5, 1),
+						/* Bits 6-7 reserved */
+	[STATUS_LOCATION]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
+	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
+	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
+	[FILTER_HASH_MSK_SRC_PORT]			= BIT(3),
+	[FILTER_HASH_MSK_DST_PORT]			= BIT(4),
+	[FILTER_HASH_MSK_PROTOCOL]			= BIT(5),
+	[FILTER_HASH_MSK_METADATA]			= BIT(6),
+	[FILTER_HASH_MSK_ALL]				= GENMASK(6, 0),
+						/* Bits 7-15 reserved */
+	[ROUTER_HASH_MSK_SRC_ID]			= BIT(16),
+	[ROUTER_HASH_MSK_SRC_IP]			= BIT(17),
+	[ROUTER_HASH_MSK_DST_IP]			= BIT(18),
+	[ROUTER_HASH_MSK_SRC_PORT]			= BIT(19),
+	[ROUTER_HASH_MSK_DST_PORT]			= BIT(20),
+	[ROUTER_HASH_MSK_PROTOCOL]			= BIT(21),
+	[ROUTER_HASH_MSK_METADATA]			= BIT(22),
+	[ROUTER_HASH_MSK_ALL]				= GENMASK(22, 16),
+						/* Bits 23-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		      0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
@@ -359,7 +410,12 @@ IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
 
-IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+	[UC_INTR]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index c48958c7bb737..6e2f939b18f19 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -318,16 +318,67 @@ static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
 IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
 		      0x00000830, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
+	[SYSPIPE_ERR_DETECTION]				= BIT(6),
+	[PACKET_OFFSET_VALID]				= BIT(7),
+	[PACKET_OFFSET_LOCATION]			= GENMASK(13, 8),
+	[IGNORE_MIN_PKT_ERR]				= BIT(14),
+						/* Bit 15 reserved */
+	[MAX_PACKET_LEN]				= GENMASK(31, 16),
+};
 
-IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+	[ENDP_RSRC_GRP]					= GENMASK(1, 0),
+						/* Bits 2-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
+		      0x00000838, 0x0070);
 
-IPA_REG_STRIDE(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-	       0x0000085c, 0x0070);
+static const u32 ipa_reg_endp_init_seq_fmask[] = {
+	[SEQ_TYPE]					= GENMASK(7, 0),
+	[SEQ_REP_TYPE]					= GENMASK(15, 8),
+						/* Bits 16-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+static const u32 ipa_reg_endp_status_fmask[] = {
+	[STATUS_EN]					= BIT(0),
+	[STATUS_ENDP]					= GENMASK(5, 1),
+						/* Bits 6-7 reserved */
+	[STATUS_LOCATION]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
+	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
+	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
+	[FILTER_HASH_MSK_SRC_PORT]			= BIT(3),
+	[FILTER_HASH_MSK_DST_PORT]			= BIT(4),
+	[FILTER_HASH_MSK_PROTOCOL]			= BIT(5),
+	[FILTER_HASH_MSK_METADATA]			= BIT(6),
+	[FILTER_HASH_MSK_ALL]				= GENMASK(6, 0),
+						/* Bits 7-15 reserved */
+	[ROUTER_HASH_MSK_SRC_ID]			= BIT(16),
+	[ROUTER_HASH_MSK_SRC_IP]			= BIT(17),
+	[ROUTER_HASH_MSK_DST_IP]			= BIT(18),
+	[ROUTER_HASH_MSK_SRC_PORT]			= BIT(19),
+	[ROUTER_HASH_MSK_DST_PORT]			= BIT(20),
+	[ROUTER_HASH_MSK_PROTOCOL]			= BIT(21),
+	[ROUTER_HASH_MSK_METADATA]			= BIT(22),
+	[ROUTER_HASH_MSK_ALL]				= GENMASK(22, 16),
+						/* Bits 23-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		      0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
@@ -338,7 +389,12 @@ IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
 
-IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+	[UC_INTR]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index fc1bb039e9ed9..8fd36569bb9f8 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -375,16 +375,66 @@ static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
 IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
 		      0x00000830, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
+	[SYSPIPE_ERR_DETECTION]				= BIT(6),
+	[PACKET_OFFSET_VALID]				= BIT(7),
+	[PACKET_OFFSET_LOCATION]			= GENMASK(13, 8),
+	[IGNORE_MIN_PKT_ERR]				= BIT(14),
+						/* Bit 15 reserved */
+	[MAX_PACKET_LEN]				= GENMASK(31, 16),
+};
 
-IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+	[ENDP_RSRC_GRP]					= GENMASK(1, 0),
+						/* Bits 2-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
+		      0x00000838, 0x0070);
 
-IPA_REG_STRIDE(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-	       0x0000085c, 0x0070);
+static const u32 ipa_reg_endp_init_seq_fmask[] = {
+	[SEQ_TYPE]					= GENMASK(7, 0),
+						/* Bits 8-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+static const u32 ipa_reg_endp_status_fmask[] = {
+	[STATUS_EN]					= BIT(0),
+	[STATUS_ENDP]					= GENMASK(5, 1),
+						/* Bits 6-8 reserved */
+	[STATUS_PKT_SUPPRESS]				= BIT(9),
+						/* Bits 10-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
+	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
+	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
+	[FILTER_HASH_MSK_SRC_PORT]			= BIT(3),
+	[FILTER_HASH_MSK_DST_PORT]			= BIT(4),
+	[FILTER_HASH_MSK_PROTOCOL]			= BIT(5),
+	[FILTER_HASH_MSK_METADATA]			= BIT(6),
+	[FILTER_HASH_MSK_ALL]				= GENMASK(6, 0),
+						/* Bits 7-15 reserved */
+	[ROUTER_HASH_MSK_SRC_ID]			= BIT(16),
+	[ROUTER_HASH_MSK_SRC_IP]			= BIT(17),
+	[ROUTER_HASH_MSK_DST_IP]			= BIT(18),
+	[ROUTER_HASH_MSK_SRC_PORT]			= BIT(19),
+	[ROUTER_HASH_MSK_DST_PORT]			= BIT(20),
+	[ROUTER_HASH_MSK_PROTOCOL]			= BIT(21),
+	[ROUTER_HASH_MSK_METADATA]			= BIT(22),
+	[ROUTER_HASH_MSK_ALL]				= GENMASK(22, 16),
+						/* Bits 23-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		      0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00004008 + 0x1000 * GSI_EE_AP);
@@ -395,7 +445,12 @@ IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000400c + 0x1000 * GSI_EE_AP);
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00004010 + 0x1000 * GSI_EE_AP);
 
-IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
+static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+	[UC_INTR]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00004030 + 0x1000 * GSI_EE_AP);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index b6f59c4afdf96..f8e78e1907c83 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -343,13 +343,44 @@ static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
 IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
 		      0x00000830, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
+	[SYSPIPE_ERR_DETECTION]				= BIT(6),
+	[PACKET_OFFSET_VALID]				= BIT(7),
+	[PACKET_OFFSET_LOCATION]			= GENMASK(13, 8),
+	[IGNORE_MIN_PKT_ERR]				= BIT(14),
+						/* Bit 15 reserved */
+	[MAX_PACKET_LEN]				= GENMASK(31, 16),
+};
 
-IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+	[ENDP_RSRC_GRP]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
+		      0x00000838, 0x0070);
+
+static const u32 ipa_reg_endp_init_seq_fmask[] = {
+	[SEQ_TYPE]					= GENMASK(7, 0),
+	[SEQ_REP_TYPE]					= GENMASK(15, 8),
+						/* Bits 16-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+static const u32 ipa_reg_endp_status_fmask[] = {
+	[STATUS_EN]					= BIT(0),
+	[STATUS_ENDP]					= GENMASK(5, 1),
+						/* Bits 6-7 reserved */
+	[STATUS_LOCATION]				= BIT(8),
+	[STATUS_PKT_SUPPRESS]				= BIT(9),
+						/* Bits 10-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
@@ -360,7 +391,12 @@ IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
 
-IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+	[UC_INTR]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index 6db5ec500aedc..d32b805abb11a 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -394,16 +394,66 @@ static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
 IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
 		      0x00000830, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
+	[SYSPIPE_ERR_DETECTION]				= BIT(6),
+	[PACKET_OFFSET_VALID]				= BIT(7),
+	[PACKET_OFFSET_LOCATION]			= GENMASK(13, 8),
+	[IGNORE_MIN_PKT_ERR]				= BIT(14),
+						/* Bit 15 reserved */
+	[MAX_PACKET_LEN]				= GENMASK(31, 16),
+};
 
-IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+	[ENDP_RSRC_GRP]					= GENMASK(2, 0),
+						/* Bits 3-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
+		      0x00000838, 0x0070);
 
-IPA_REG_STRIDE(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-	       0x0000085c, 0x0070);
+static const u32 ipa_reg_endp_init_seq_fmask[] = {
+	[SEQ_TYPE]					= GENMASK(7, 0),
+						/* Bits 8-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+static const u32 ipa_reg_endp_status_fmask[] = {
+	[STATUS_EN]					= BIT(0),
+	[STATUS_ENDP]					= GENMASK(5, 1),
+						/* Bits 6-8 reserved */
+	[STATUS_PKT_SUPPRESS]				= BIT(9),
+						/* Bits 10-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
+	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
+	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
+	[FILTER_HASH_MSK_SRC_PORT]			= BIT(3),
+	[FILTER_HASH_MSK_DST_PORT]			= BIT(4),
+	[FILTER_HASH_MSK_PROTOCOL]			= BIT(5),
+	[FILTER_HASH_MSK_METADATA]			= BIT(6),
+	[FILTER_HASH_MSK_ALL]				= GENMASK(6, 0),
+						/* Bits 7-15 reserved */
+	[ROUTER_HASH_MSK_SRC_ID]			= BIT(16),
+	[ROUTER_HASH_MSK_SRC_IP]			= BIT(17),
+	[ROUTER_HASH_MSK_DST_IP]			= BIT(18),
+	[ROUTER_HASH_MSK_SRC_PORT]			= BIT(19),
+	[ROUTER_HASH_MSK_DST_PORT]			= BIT(20),
+	[ROUTER_HASH_MSK_PROTOCOL]			= BIT(21),
+	[ROUTER_HASH_MSK_METADATA]			= BIT(22),
+	[ROUTER_HASH_MSK_ALL]				= GENMASK(22, 16),
+						/* Bits 23-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		      0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
@@ -414,7 +464,12 @@ IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
 
-IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+	[UC_INTR]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index 37dc9292b88c3..eabbc5451937b 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -372,16 +372,66 @@ static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
 IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
 		      0x00000830, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
+	[SYSPIPE_ERR_DETECTION]				= BIT(6),
+	[PACKET_OFFSET_VALID]				= BIT(7),
+	[PACKET_OFFSET_LOCATION]			= GENMASK(13, 8),
+	[IGNORE_MIN_PKT_ERR]				= BIT(14),
+						/* Bit 15 reserved */
+	[MAX_PACKET_LEN]				= GENMASK(31, 16),
+};
 
-IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+	[ENDP_RSRC_GRP]					= GENMASK(1, 0),
+						/* Bits 2-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
+		      0x00000838, 0x0070);
 
-IPA_REG_STRIDE(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-	       0x0000085c, 0x0070);
+static const u32 ipa_reg_endp_init_seq_fmask[] = {
+	[SEQ_TYPE]					= GENMASK(7, 0),
+						/* Bits 8-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+static const u32 ipa_reg_endp_status_fmask[] = {
+	[STATUS_EN]					= BIT(0),
+	[STATUS_ENDP]					= GENMASK(5, 1),
+						/* Bits 6-8 reserved */
+	[STATUS_PKT_SUPPRESS]				= BIT(9),
+						/* Bits 10-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
+	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
+	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
+	[FILTER_HASH_MSK_SRC_PORT]			= BIT(3),
+	[FILTER_HASH_MSK_DST_PORT]			= BIT(4),
+	[FILTER_HASH_MSK_PROTOCOL]			= BIT(5),
+	[FILTER_HASH_MSK_METADATA]			= BIT(6),
+	[FILTER_HASH_MSK_ALL]				= GENMASK(6, 0),
+						/* Bits 7-15 reserved */
+	[ROUTER_HASH_MSK_SRC_ID]			= BIT(16),
+	[ROUTER_HASH_MSK_SRC_IP]			= BIT(17),
+	[ROUTER_HASH_MSK_DST_IP]			= BIT(18),
+	[ROUTER_HASH_MSK_SRC_PORT]			= BIT(19),
+	[ROUTER_HASH_MSK_DST_PORT]			= BIT(20),
+	[ROUTER_HASH_MSK_PROTOCOL]			= BIT(21),
+	[ROUTER_HASH_MSK_METADATA]			= BIT(22),
+	[ROUTER_HASH_MSK_ALL]				= GENMASK(22, 16),
+						/* Bits 23-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		      0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00004008 + 0x1000 * GSI_EE_AP);
@@ -392,7 +442,12 @@ IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000400c + 0x1000 * GSI_EE_AP);
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
 IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00004010 + 0x1000 * GSI_EE_AP);
 
-IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
+static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+	[UC_INTR]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00004030 + 0x1000 * GSI_EE_AP);
-- 
2.34.1

