Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D632B553E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgKPXi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731011AbgKPXi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:26 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C315AC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:25 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id x18so2999245ilq.4
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+a92BdPcdOW6ZEBWomMuo161Yv3UZyOeUdVhPXxuGgE=;
        b=Kg1Z1l2LEWb2jyJBsr3KuOFnKE7ZpYYl6wc0nGKgTlfHepy+RBtS41/8hBtyybg7JI
         wEnyzaH7UnAIhFtVhzxChKxHb3EfbwPpuvyQgCEuRV+8Pb2+Ks4d2lOh3h79cxvPs0jW
         lJgy0o5izDRN8orFc59jkbnXEGzxg55+LT/Yw/enf0SF3aV8/gJSx1Y2Uh9KMNtpwuoU
         TaTDsqXYnFQaQOZWvg81WRHbfhrAU/rl8+knF1MOYSTkXz3X7aug6f4jmM4cILm3ahGt
         ArnLPhTAn7KFNQ8sVeuYBWZtw5k+AH+KLcMIu0k7h8J6uLuQr0YY1/N9wB7iPfEPiPp/
         S7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+a92BdPcdOW6ZEBWomMuo161Yv3UZyOeUdVhPXxuGgE=;
        b=nzIviHWznkqZY89O+xrMzoB14jWOExlWWA6pO4mkXT8LODcvO+5kSyfRxsCVshGwsC
         SP9cDxUzVc4V7xAWoNuDVwnVs6SPqgF94ZLcIk3iqoG+0kWFtxC3AshRsZruckqMwKIB
         Uzo9RwiCqLFZZ7UJVmoEgAi5PfcxxZMdCnZBw/cJyga2EPoWkNp3QMJr9sTKLYu/nPHJ
         +aL/fYyLM1Irx8x5aqGZWeJyJ9cQ+qm/BKwcVf6tpsXo1d5z4H79l5xY1U5tRjO0/eER
         ovJyc0Dr0tTDRPBi/fLrgH4/ktPhBF+66Yukkl3rjJ3E+IumX2xoCRdcCKCU7D5VT+pc
         +1jg==
X-Gm-Message-State: AOAM532cjisVDOmxIXSHd9gHTyD0VoPv4L1clMA/UZ5hpa/7sua0SpN3
        RMshksuKwRJvTlDC7wqiemlbsQ==
X-Google-Smtp-Source: ABdhPJxG8/uyJV6OpWnxv2FwjfZd7ysTyqZsFjsEGoqJ4X5XWszrfpbjz9/o435U5BT2dIUNPaBW5w==
X-Received: by 2002:a92:844b:: with SMTP id l72mr9682333ild.244.1605569905098;
        Mon, 16 Nov 2020 15:38:25 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm10180099ill.22.2020.11.16.15.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:38:24 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/11] net: ipa: rearrange a few IPA register definitions
Date:   Mon, 16 Nov 2020 17:38:03 -0600
Message-Id: <20201116233805.13775-10-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116233805.13775-1-elder@linaro.org>
References: <20201116233805.13775-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move a few things around in "ipa_reg.h":
  - Move the definition of ipa_reg_state_aggr_active_offset() down
    a bit in the file so definitions are ordered by offset (for
    the lowest supported IPA version) like all other definitions.
  - Move the definition TIMER_FREQUENCY to be immediately above
    the definition of ipa_aggr_granularity_val() where it's used.
  - Move each register field value enumerated type definition to
    immediately follow the definitions of the register and field
    it is associated with.
No code functionality is modified by this patch.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.h | 147 +++++++++++++++++++-------------------
 1 file changed, 74 insertions(+), 73 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 08473e513477f..94b54b2f660f6 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -145,15 +145,6 @@ struct ipa;
 #define GEN_QMB_0_MAX_READS_BEATS_FMASK		GENMASK(23, 16)
 #define GEN_QMB_1_MAX_READS_BEATS_FMASK		GENMASK(31, 24)
 
-/* ipa->available defines the valid bits in the STATE_AGGR_ACTIVE register */
-static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
-{
-	if (version == IPA_VERSION_3_5_1)
-		return 0x0000010c;
-
-	return 0x000000b4;
-}
-
 static inline u32 ipa_reg_filt_rout_hash_en_offset(enum ipa_version version)
 {
 	if (version == IPA_VERSION_3_5_1)
@@ -176,6 +167,15 @@ static inline u32 ipa_reg_filt_rout_hash_flush_offset(enum ipa_version version)
 #define IPV4_ROUTER_HASH_FMASK			GENMASK(8, 8)
 #define IPV4_FILTER_HASH_FMASK			GENMASK(12, 12)
 
+/* ipa->available defines the valid bits in the STATE_AGGR_ACTIVE register */
+static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
+{
+	if (version == IPA_VERSION_3_5_1)
+		return 0x0000010c;
+
+	return 0x000000b4;
+}
+
 #define IPA_REG_BCR_OFFSET				0x000001d0
 /* The next two fields are not present for IPA v4.2 */
 #define BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK		GENMASK(0, 0)
@@ -216,14 +216,15 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
 /* ipa->available defines the valid bits in the AGGR_FORCE_CLOSE register */
 #define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
 
-/* The internal inactivity timer clock is used for the aggregation timer */
-#define TIMER_FREQUENCY	32000	/* 32 KHz inactivity timer clock */
-
 #define IPA_REG_COUNTER_CFG_OFFSET			0x000001f0
 #define AGGR_GRANULARITY_FMASK			GENMASK(8, 4)
+
+/* The internal inactivity timer clock is used for the aggregation timer */
+#define TIMER_FREQUENCY	32000		/* 32 KHz inactivity timer clock */
+
 /* Compute the value to use in the AGGR_GRANULARITY field representing the
  * given number of microseconds.  The value is one less than the number of
- * timer ticks in the requested period.  Zero not a valid granularity value.
+ * timer ticks in the requested period.  0 not a valid granularity value.
  */
 static inline u32 ipa_aggr_granularity_val(u32 usec)
 {
@@ -332,6 +333,14 @@ static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
 #define CS_METADATA_HDR_OFFSET_FMASK		GENMASK(6, 3)
 #define CS_GEN_QMB_MASTER_SEL_FMASK		GENMASK(8, 8)
 
+/** enum ipa_cs_offload_en - checksum offload field in ENDP_INIT_CFG_N */
+enum ipa_cs_offload_en {
+	IPA_CS_OFFLOAD_NONE		= 0x0,
+	IPA_CS_OFFLOAD_UL		= 0x1,
+	IPA_CS_OFFLOAD_DL		= 0x2,
+	IPA_CS_RSVD			= 0x3,
+};
+
 #define IPA_REG_ENDP_INIT_HDR_N_OFFSET(ep) \
 					(0x00000810 + 0x0070 * (ep))
 #define HDR_LEN_FMASK				GENMASK(5, 0)
@@ -367,6 +376,14 @@ static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
 #define PAD_EN_FMASK				GENMASK(29, 29)
 #define HDR_FTCH_DISABLE_FMASK			GENMASK(30, 30)
 
+/** enum ipa_mode - mode field in ENDP_INIT_MODE_N */
+enum ipa_mode {
+	IPA_BASIC			= 0x0,
+	IPA_ENABLE_FRAMING_HDLC		= 0x1,
+	IPA_ENABLE_DEFRAMING_HDLC	= 0x2,
+	IPA_DMA				= 0x3,
+};
+
 #define IPA_REG_ENDP_INIT_AGGR_N_OFFSET(ep) \
 					(0x00000824 +  0x0070 * (ep))
 #define AGGR_EN_FMASK				GENMASK(1, 0)
@@ -378,6 +395,24 @@ static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
 #define AGGR_FORCE_CLOSE_FMASK			GENMASK(22, 22)
 #define AGGR_HARD_BYTE_LIMIT_ENABLE_FMASK	GENMASK(24, 24)
 
+/** enum ipa_aggr_en - aggregation enable field in ENDP_INIT_AGGR_N */
+enum ipa_aggr_en {
+	IPA_BYPASS_AGGR			= 0x0,
+	IPA_ENABLE_AGGR			= 0x1,
+	IPA_ENABLE_DEAGGR		= 0x2,
+};
+
+/** enum ipa_aggr_type - aggregation type field in ENDP_INIT_AGGR_N */
+enum ipa_aggr_type {
+	IPA_MBIM_16			= 0x0,
+	IPA_HDLC			= 0x1,
+	IPA_TLP				= 0x2,
+	IPA_RNDIS			= 0x3,
+	IPA_GENERIC			= 0x4,
+	IPA_COALESCE			= 0x5,
+	IPA_QCMAP			= 0x6,
+};
+
 /* Valid only for RX (IPA producer) endpoints */
 #define IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(rxep) \
 					(0x0000082c +  0x0070 * (rxep))
@@ -419,6 +454,32 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 #define HPS_REP_SEQ_TYPE_FMASK			GENMASK(11, 8)
 #define DPS_REP_SEQ_TYPE_FMASK			GENMASK(15, 12)
 
+/**
+ * enum ipa_seq_type - HPS and DPS sequencer type fields in ENDP_INIT_SEQ_N
+ * @IPA_SEQ_DMA_ONLY:		only DMA is performed
+ * @IPA_SEQ_PKT_PROCESS_NO_DEC_UCP:
+ *	packet processing + no decipher + microcontroller (Ethernet Bridging)
+ * @IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP:
+ *	second packet processing pass + no decipher + microcontroller
+ * @IPA_SEQ_DMA_DEC:		DMA + cipher/decipher
+ * @IPA_SEQ_DMA_COMP_DECOMP:	DMA + compression/decompression
+ * @IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP:
+ *	packet processing + no decipher + no uCP + HPS REP DMA parser
+ * @IPA_SEQ_INVALID:		invalid sequencer type
+ *
+ * The values defined here are broken into 4-bit nibbles that are written
+ * into fields of the INIT_SEQ_N endpoint registers.
+ */
+enum ipa_seq_type {
+	IPA_SEQ_DMA_ONLY			= 0x0000,
+	IPA_SEQ_PKT_PROCESS_NO_DEC_UCP		= 0x0002,
+	IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP	= 0x0004,
+	IPA_SEQ_DMA_DEC				= 0x0011,
+	IPA_SEQ_DMA_COMP_DECOMP			= 0x0020,
+	IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP	= 0x0806,
+	IPA_SEQ_INVALID				= 0xffff,
+};
+
 #define IPA_REG_ENDP_STATUS_N_OFFSET(ep) \
 					(0x00000840 + 0x0070 * (ep))
 #define STATUS_EN_FMASK				GENMASK(0, 0)
@@ -486,66 +547,6 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 #define IPA_REG_IRQ_SUSPEND_CLR_EE_N_OFFSET(ee) \
 					(0x00003038 + 0x1000 * (ee))
 
-/** enum ipa_cs_offload_en - checksum offload field in ENDP_INIT_CFG_N */
-enum ipa_cs_offload_en {
-	IPA_CS_OFFLOAD_NONE		= 0x0,
-	IPA_CS_OFFLOAD_UL		= 0x1,
-	IPA_CS_OFFLOAD_DL		= 0x2,
-	IPA_CS_RSVD			= 0x3,
-};
-
-/** enum ipa_aggr_en - aggregation enable field in ENDP_INIT_AGGR_N */
-enum ipa_aggr_en {
-	IPA_BYPASS_AGGR			= 0x0,
-	IPA_ENABLE_AGGR			= 0x1,
-	IPA_ENABLE_DEAGGR		= 0x2,
-};
-
-/** enum ipa_aggr_type - aggregation type field in in_ENDP_INIT_AGGR_N */
-enum ipa_aggr_type {
-	IPA_MBIM_16			= 0x0,
-	IPA_HDLC			= 0x1,
-	IPA_TLP				= 0x2,
-	IPA_RNDIS			= 0x3,
-	IPA_GENERIC			= 0x4,
-	IPA_COALESCE			= 0x5,
-	IPA_QCMAP			= 0x6,
-};
-
-/** enum ipa_mode - mode field in ENDP_INIT_MODE_N */
-enum ipa_mode {
-	IPA_BASIC			= 0x0,
-	IPA_ENABLE_FRAMING_HDLC		= 0x1,
-	IPA_ENABLE_DEFRAMING_HDLC	= 0x2,
-	IPA_DMA				= 0x3,
-};
-
-/**
- * enum ipa_seq_type - HPS and DPS sequencer type fields in in ENDP_INIT_SEQ_N
- * @IPA_SEQ_DMA_ONLY:		only DMA is performed
- * @IPA_SEQ_PKT_PROCESS_NO_DEC_UCP:
- *	packet processing + no decipher + microcontroller (Ethernet Bridging)
- * @IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP:
- *	second packet processing pass + no decipher + microcontroller
- * @IPA_SEQ_DMA_DEC:		DMA + cipher/decipher
- * @IPA_SEQ_DMA_COMP_DECOMP:	DMA + compression/decompression
- * @IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP:
- *	packet processing + no decipher + no uCP + HPS REP DMA parser
- * @IPA_SEQ_INVALID:		invalid sequencer type
- *
- * The values defined here are broken into 4-bit nibbles that are written
- * into fields of the INIT_SEQ_N endpoint registers.
- */
-enum ipa_seq_type {
-	IPA_SEQ_DMA_ONLY			= 0x0000,
-	IPA_SEQ_PKT_PROCESS_NO_DEC_UCP		= 0x0002,
-	IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP	= 0x0004,
-	IPA_SEQ_DMA_DEC				= 0x0011,
-	IPA_SEQ_DMA_COMP_DECOMP			= 0x0020,
-	IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP	= 0x0806,
-	IPA_SEQ_INVALID				= 0xffff,
-};
-
 int ipa_reg_init(struct ipa *ipa);
 void ipa_reg_exit(struct ipa *ipa);
 
-- 
2.20.1

