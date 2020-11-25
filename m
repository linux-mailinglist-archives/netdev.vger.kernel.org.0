Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E3B2C493F
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgKYUpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730315AbgKYUpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 15:45:31 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BA2C0617A7
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:31 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id j23so3461313iog.6
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7W4Hfj48QORt9DT/Mlo5jKfxl+azWhnxx3x7FeknXPA=;
        b=Oa3UO47uGKMJpNRpNQg9z+P67uHj7fSzm+twSBtR5KYw4B8KCojmqubhMqVx2zWufB
         HioVqvLu7jRauZ62xdWaE6uBgpM9kWxv2phnt0gbq7GLn/Vlo5fvkllyljLG3wP4ZYy2
         35T7nwvvP8kGQVa+KA5T2wNYFhnkSmoa8Ms0ch0yzDBCg8vRYJT+qagirOHQhQ9n9BR8
         6QjcWK7R5sIeEgU9lME15VXN8JU1NfzLfYHqeqDlbCqyxP9lFKaJWZlqPkFbV9ARDBf7
         /AsC6YHHqkL2VIxkYtZ27vPcBqmemixheHx0pVBGamom0O5n+xnZFHWRWjgLJlKvNAiC
         e+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7W4Hfj48QORt9DT/Mlo5jKfxl+azWhnxx3x7FeknXPA=;
        b=rOk1/FpJpLgRoqMB5gccoYpq2dOm5cNwWmutdOgc6pBjum73Y9j8aOnRsMiKJGeveW
         F1ar2PZKJdYk4SfgqBcocuUsUI9PxszLwRcIjkv6cUUwCqhByKooj6nXTtmqJ+tfUfCm
         7n2MGNiHR9Gq57qDNMZKUtXpEjCHTeesJW++QxSJb2oIWXPa2ThmghivknzANk2o6hZA
         OBLoez4GVIcUinACiY0p24leILcE+nKqHXtWQWJL+78nq/WKFBqepxAPaPIT+KIb05Qa
         B4YWR4qu9RGhiVwjFkIm6m47huy5yGRj1C6RCL4UCysuYzUq6P4RSzaprnOA2naw+YGw
         g/mg==
X-Gm-Message-State: AOAM532doccVuDMUAxqWTDCvZsjp2S/cmORQBKMfscGDvXc7/+2O8ZVf
        nGCa8l7xf3y30IWkwKfVkQHfjA==
X-Google-Smtp-Source: ABdhPJzNbXzQ2FdtTSWDFffyBpHGrf3WF5R8+y+9RL+FWJbSq8oKbVYK0MDcHVTyZXLQ6h95lOXXqQ==
X-Received: by 2002:a02:70ce:: with SMTP id f197mr347jac.120.1606337130996;
        Wed, 25 Nov 2020 12:45:30 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n10sm1462225iom.36.2020.11.25.12.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:45:30 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: update IPA registers for IPA v4.5
Date:   Wed, 25 Nov 2020 14:45:18 -0600
Message-Id: <20201125204522.5884-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125204522.5884-1-elder@linaro.org>
References: <20201125204522.5884-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update "ipa_reg.h" so that register definitions support IPA hardware
version 4.5, in addition to versions 3.5.1 through v4.2.  Most of
the register definitions are the same, but in some cases fields are
added, changed, or eliminated.

Updates for a few IPA v4.5 registers are more complex, and adding
those definition will be deferred to separate patches.  This patch
only updates the register offset and field definitions, and adds
informational comments.

The only code change avoids accessing the backward compatibility
register for IPA version 4.5 in ipa_hardware_config().  Other IPA
v4.5-specific code changes will come later.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c    | 15 +++++++++------
 drivers/net/ipa/ipa_reg.h     | 36 +++++++++++++++++++++++++++++++++--
 drivers/net/ipa/ipa_version.h |  1 +
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index e9bd0d72f2db1..7cd7f6cc05b3c 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -310,14 +310,17 @@ static void ipa_hardware_dcd_deconfig(struct ipa *ipa)
  */
 static void ipa_hardware_config(struct ipa *ipa)
 {
+	enum ipa_version version = ipa->version;
 	u32 granularity;
 	u32 val;
 
-	/* Fill in backward-compatibility register, based on version */
-	val = ipa_reg_bcr_val(ipa->version);
-	iowrite32(val, ipa->reg_virt + IPA_REG_BCR_OFFSET);
+	/* IPA v4.5 has no backward compatibility register */
+	if (version < IPA_VERSION_4_5) {
+		val = ipa_reg_bcr_val(version);
+		iowrite32(val, ipa->reg_virt + IPA_REG_BCR_OFFSET);
+	}
 
-	if (ipa->version != IPA_VERSION_3_5_1) {
+	if (version != IPA_VERSION_3_5_1) {
 		/* Enable open global clocks (hardware workaround) */
 		val = GLOBAL_FMASK;
 		val |= GLOBAL_2X_CLK_FMASK;
@@ -340,8 +343,8 @@ static void ipa_hardware_config(struct ipa *ipa)
 	iowrite32(val, ipa->reg_virt + IPA_REG_COUNTER_CFG_OFFSET);
 
 	/* IPA v4.2 does not support hashed tables, so disable them */
-	if (ipa->version == IPA_VERSION_4_2) {
-		u32 offset = ipa_reg_filt_rout_hash_en_offset(ipa->version);
+	if (version == IPA_VERSION_4_2) {
+		u32 offset = ipa_reg_filt_rout_hash_en_offset(version);
 
 		iowrite32(0, ipa->reg_virt + offset);
 	}
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index d02e7ecc6fc01..f6ac9884fd326 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -65,12 +65,13 @@ struct ipa;
  * of valid bits for the register.
  */
 
-/* The next field is not supported for IPA v4.1 */
 #define IPA_REG_COMP_CFG_OFFSET				0x0000003c
+/* The next field is not supported for IPA v4.1 */
 #define ENABLE_FMASK				GENMASK(0, 0)
 #define GSI_SNOC_BYPASS_DIS_FMASK		GENMASK(1, 1)
 #define GEN_QMB_0_SNOC_BYPASS_DIS_FMASK		GENMASK(2, 2)
 #define GEN_QMB_1_SNOC_BYPASS_DIS_FMASK		GENMASK(3, 3)
+/* The next field is not present for IPA v4.5 */
 #define IPA_DCMP_FAST_CLK_EN_FMASK		GENMASK(4, 4)
 /* The remaining fields are not present for IPA v3.5.1 */
 #define IPA_QMB_SELECT_CONS_EN_FMASK		GENMASK(5, 5)
@@ -86,6 +87,8 @@ struct ipa;
 #define GSI_MULTI_AXI_MASTERS_DIS_FMASK		GENMASK(15, 15)
 #define IPA_QMB_SELECT_GLOBAL_EN_FMASK		GENMASK(16, 16)
 #define IPA_ATOMIC_FETCHER_ARB_LOCK_DIS_FMASK	GENMASK(20, 17)
+/* The next field is present for IPA v4.5 */
+#define IPA_FULL_FLUSH_WAIT_RSC_CLOSE_EN_FMASK	GENMASK(21, 21)
 
 #define IPA_REG_CLKON_CFG_OFFSET			0x00000044
 #define RX_FMASK				GENMASK(0, 0)
@@ -105,6 +108,7 @@ struct ipa;
 #define ACK_MNGR_FMASK				GENMASK(14, 14)
 #define D_DCPH_FMASK				GENMASK(15, 15)
 #define H_DCPH_FMASK				GENMASK(16, 16)
+/* The next field is not present for IPA v4.5 */
 #define DCMP_FMASK				GENMASK(17, 17)
 #define NTF_TX_CMDQS_FMASK			GENMASK(18, 18)
 #define TX_0_FMASK				GENMASK(19, 19)
@@ -119,6 +123,8 @@ struct ipa;
 #define GSI_IF_FMASK				GENMASK(27, 27)
 #define GLOBAL_FMASK				GENMASK(28, 28)
 #define GLOBAL_2X_CLK_FMASK			GENMASK(29, 29)
+/* The next field is present for IPA v4.5 */
+#define DPL_FIFO_FMASK				GENMASK(30, 30)
 
 #define IPA_REG_ROUTE_OFFSET				0x00000048
 #define ROUTE_DIS_FMASK				GENMASK(0, 0)
@@ -174,6 +180,7 @@ static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
 	return 0x000000b4;
 }
 
+/* The next register is not present for IPA v4.5 */
 #define IPA_REG_BCR_OFFSET				0x000001d0
 /* The next two fields are not present for IPA v4.2 */
 #define BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK		GENMASK(0, 0)
@@ -205,6 +212,8 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
 			BCR_HOLB_DROP_L2_IRQ_FMASK |
 			BCR_DUAL_TX_FMASK;
 
+	/* assert(version != IPA_VERSION_4_5); */
+
 	return 0x00000000;
 }
 
@@ -241,6 +250,8 @@ static inline u32 ipa_aggr_granularity_val(u32 usec)
 #define DMAW_MAX_BEATS_256_DIS_FMASK		GENMASK(11, 11)
 #define PA_MASK_EN_FMASK			GENMASK(12, 12)
 #define PREFETCH_ALMOST_EMPTY_SIZE_TX1_FMASK	GENMASK(16, 13)
+/* The next field is present for IPA v4.5 */
+#define DUAL_TX_ENABLE_FMASK			GENMASK(17, 17)
 /* The next two fields are present for IPA v4.2 only */
 #define SSPND_PA_NO_START_STATE_FMASK		GENMASK(18, 18)
 #define SSPND_PA_NO_BQ_STATE_FMASK		GENMASK(19, 19)
@@ -253,7 +264,7 @@ static inline u32 ipa_aggr_granularity_val(u32 usec)
 
 static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 {
-	if (version == IPA_VERSION_4_2)
+	if (version >= IPA_VERSION_4_2)
 		return 0x00000240;
 
 	return 0x00000220;
@@ -303,12 +314,14 @@ static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
 					(0x00000400 + 0x0020 * (rt))
 #define IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000404 + 0x0020 * (rt))
+/* The next register is only present for IPA v4.5 */
 #define IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000408 + 0x0020 * (rt))
 #define IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000500 + 0x0020 * (rt))
 #define IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000504 + 0x0020 * (rt))
+/* The next register is only present for IPA v4.5 */
 #define IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000508 + 0x0020 * (rt))
 /* The next four fields are used for all resource group registers */
@@ -348,7 +361,11 @@ enum ipa_cs_offload_en {
 #define HDR_OFST_PKT_SIZE_FMASK			GENMASK(25, 20)
 #define HDR_A5_MUX_FMASK			GENMASK(26, 26)
 #define HDR_LEN_INC_DEAGG_HDR_FMASK		GENMASK(27, 27)
+/* The next field is not present for IPA v4.5 */
 #define HDR_METADATA_REG_VALID_FMASK		GENMASK(28, 28)
+/* The next two fields are present for IPA v4.5 */
+#define HDR_LEN_MSB_FMASK			GENMASK(29, 28)
+#define HDR_OFST_METADATA_MSB_FMASK		GENMASK(31, 30)
 
 #define IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(ep) \
 					(0x00000814 + 0x0070 * (ep))
@@ -358,6 +375,10 @@ enum ipa_cs_offload_en {
 #define HDR_PAYLOAD_LEN_INC_PADDING_FMASK	GENMASK(3, 3)
 #define HDR_TOTAL_LEN_OR_PAD_OFFSET_FMASK	GENMASK(9, 4)
 #define HDR_PAD_TO_ALIGNMENT_FMASK		GENMASK(13, 10)
+/* The next three fields are present for IPA v4.5 */
+#define HDR_TOTAL_LEN_OR_PAD_OFFSET_MSB_FMASK	GENMASK(17, 16)
+#define HDR_OFST_PKT_SIZE_MSB_FMASK		GENMASK(19, 18)
+#define HDR_ADDITIONAL_CONST_LEN_MSB_FMASK	GENMASK(21, 20)
 
 /* Valid only for RX (IPA producer) endpoints */
 #define IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(rxep) \
@@ -367,10 +388,13 @@ enum ipa_cs_offload_en {
 #define IPA_REG_ENDP_INIT_MODE_N_OFFSET(txep) \
 					(0x00000820 + 0x0070 * (txep))
 #define MODE_FMASK				GENMASK(2, 0)
+/* The next field is present for IPA v4.5 */
+#define DCPH_ENABLE_FMASK			GENMASK(3, 3)
 #define DEST_PIPE_INDEX_FMASK			GENMASK(8, 4)
 #define BYTE_THRESHOLD_FMASK			GENMASK(27, 12)
 #define PIPE_REPLICATION_EN_FMASK		GENMASK(28, 28)
 #define PAD_EN_FMASK				GENMASK(29, 29)
+/* The next register is not present for IPA v4.5 */
 #define HDR_FTCH_DISABLE_FMASK			GENMASK(30, 30)
 
 /** enum ipa_mode - mode field in ENDP_INIT_MODE_N */
@@ -421,6 +445,9 @@ enum ipa_aggr_type {
 /* The next two fields are present for IPA v4.2 only */
 #define BASE_VALUE_FMASK			GENMASK(4, 0)
 #define SCALE_FMASK				GENMASK(12, 8)
+/* The next two fields are present for IPA v4.5 */
+#define TIME_LIMIT_FMASK			GENMASK(4, 0)
+#define GRAN_SEL_FMASK				GENMASK(8, 8)
 
 /* Valid only for TX (IPA consumer) endpoints */
 #define IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(txep) \
@@ -440,6 +467,8 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 	switch (version) {
 	case IPA_VERSION_4_2:
 		return u32_encode_bits(rsrc_grp, GENMASK(0, 0));
+	case IPA_VERSION_4_5:
+		return u32_encode_bits(rsrc_grp, GENMASK(2, 0));
 	default:
 		return u32_encode_bits(rsrc_grp, GENMASK(1, 0));
 	}
@@ -476,6 +505,7 @@ enum ipa_seq_type {
 					(0x00000840 + 0x0070 * (ep))
 #define STATUS_EN_FMASK				GENMASK(0, 0)
 #define STATUS_ENDP_FMASK			GENMASK(5, 1)
+/* The next field is not present for IPA v4.5 */
 #define STATUS_LOCATION_FMASK			GENMASK(8, 8)
 /* The next field is not present for IPA v3.5.1 */
 #define STATUS_PKT_SUPPRESS_FMASK		GENMASK(9, 9)
@@ -550,6 +580,8 @@ enum ipa_irq_id {
 	IPA_IRQ_GSI_EE				= 0x17,
 	IPA_IRQ_GSI_IPA_IF_TLV_RCVD		= 0x18,
 	IPA_IRQ_GSI_UC				= 0x19,
+	/* The next bit is present for IPA v4.5 */
+	IPA_IRQ_TLV_LEN_MIN_DSM			= 0x1a,
 	IPA_IRQ_COUNT,				/* Last; not an id */
 };
 
diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
index 85449df0f5124..2944e2a890231 100644
--- a/drivers/net/ipa/ipa_version.h
+++ b/drivers/net/ipa/ipa_version.h
@@ -18,6 +18,7 @@ enum ipa_version {
 	IPA_VERSION_4_0,	/* GSI version 2.0 */
 	IPA_VERSION_4_1,	/* GSI version 2.1 */
 	IPA_VERSION_4_2,	/* GSI version 2.2 */
+	IPA_VERSION_4_5,	/* GSI version 2.5 */
 };
 
 #endif /* _IPA_VERSION_H_ */
-- 
2.20.1

