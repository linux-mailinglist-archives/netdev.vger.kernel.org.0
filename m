Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB655EB44E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiIZWLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiIZWLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:11:02 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19B61D0C8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:02 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id j7so4263016ilu.7
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8wPVAadQ0pci3GMsOdT0rwlBmpgyI8ND1YHQ8kWBKW4=;
        b=irh0qJA6wqjnwSIjBlNjDxH7DR6b2HQgAq/zi6MuJXFSPK+QRGpfaoQO8+PfgjXk+U
         n6PrrsiXEa//MFFEYsxfAxB19D9lVDqXuqF14GmI/CsBZvjEAGYqYlj/efMdgNI2Ergf
         +Zb31LXqvwoUXwIjBYO9jLTGRjRKAR51U3v9g8vEy8Q/LH4Vnk/JHFtlURZ2cf4F1AsZ
         hnB674xsoXBOTJoLyYhX6EUz/0/ro7btr1iFTs3rEORPh1enqmzlfhxYZ3T/iqh/Q6xk
         sUXczhB0eEfG3tTjUSXy2ILtoO+ZrAQ26WKv+5Y5wqmq3biSmBM/VQ1arD3sFko+i24s
         nMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8wPVAadQ0pci3GMsOdT0rwlBmpgyI8ND1YHQ8kWBKW4=;
        b=EkX9q/PynxJNrXbcdbLCh6y2cqx8CW6pstnEhBpSUFnv0ekHi5GxtRUAfNA5phD9hn
         JZ1MYROoaoaQxRVjZpYBdJETLAC3Rl1qengaWcfcPNGfOmwgjGuu69G6V7m+VBZOyRst
         CMD4oYj9KQYSecJcUqX3Z5pwTUmEwKR5H+cTeiG4jtfSI8gFa2nXeoyjjx16n10uZ/ka
         u7EhjdNjcLqUxiuYnxgPchifFBkmzExECF27tjLdDBSCI4rF8yAXs1CDZe0TiFbjI4sH
         TptDWmwPhm6s0I/xQQ7alebyR9VyCPITLwSzPkkYHrHtiw6CJrYIP2izBDnoWe9vJKFb
         ZUhQ==
X-Gm-Message-State: ACrzQf0jeZ4cope8LBO97gJPUR4NiXx+fE4DQb9U7h/MUiGxBoBMLhS9
        Qyj42GnU5U3XszNxmm1qvFD0jA==
X-Google-Smtp-Source: AMsMyM7SZnAoFJ5PgCriMXeXRXqJp1v6371S2yoirq3doMmf2eCCjjmnkFyKTlWRYBtb6SYocaxH7Q==
X-Received: by 2002:a05:6e02:1d02:b0:2f1:6fb4:26b6 with SMTP id i2-20020a056e021d0200b002f16fb426b6mr11026090ila.49.1664230201702;
        Mon, 26 Sep 2022 15:10:01 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:10:00 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/15] net: ipa: define more IPA register fields
Date:   Mon, 26 Sep 2022 17:09:26 -0500
Message-Id: <20220926220931.3261749-11-elder@linaro.org>
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

Define the fields for the LOCAL_PKT_PROC_CNTXT, COUNTER_CFG, and
IPA_TX_CFG IPA registers for all supported IPA versions.

Create enumerated types to identify fields for these IPA registers.
Use IPA_REG_FIELDS() to specify the field mask values defined for
these registers, for each supported version of IPA.

Use ipa_reg_bit() and ipa_reg_encode() to build up the values to be
written to these registers.  Remove the definition of the *_FMASK
symbols as well as proc_cntxt_base_addr_encoded(), because they are
no longer needed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c           |  7 ++--
 drivers/net/ipa/ipa_mem.c            |  2 +-
 drivers/net/ipa/ipa_reg.h            | 50 ++++++++++++----------------
 drivers/net/ipa/reg/ipa_reg-v3.1.c   | 15 +++++++--
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c | 24 +++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.11.c  | 22 ++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.2.c   | 31 +++++++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.5.c   | 21 ++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.9.c   | 22 ++++++++++--
 9 files changed, 146 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 771b5c378b306..23ab566b71dde 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -214,7 +214,7 @@ static void ipa_hardware_config_tx(struct ipa *ipa)
 
 	val = ioread32(ipa->reg_virt + offset);
 
-	val &= ~PA_MASK_EN_FMASK;
+	val &= ~ipa_reg_bit(reg, PA_MASK_EN);
 
 	iowrite32(val, ipa->reg_virt + offset);
 }
@@ -398,7 +398,8 @@ static void ipa_hardware_config_counter(struct ipa *ipa)
 	u32 val;
 
 	reg = ipa_reg(ipa, COUNTER_CFG);
-	val = u32_encode_bits(granularity, AGGR_GRANULARITY_FMASK);
+	/* If defined, EOT_COAL_GRANULARITY is 0 */
+	val = ipa_reg_encode(reg, AGGR_GRANULARITY, granularity);
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
@@ -690,8 +691,6 @@ static void ipa_validate_build(void)
 
 	/* Aggregation granularity value can't be 0, and must fit */
 	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
-	BUILD_BUG_ON(ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY) >
-			field_max(AGGR_GRANULARITY_FMASK));
 }
 
 /**
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 0c22ea8d8ad06..9abf473be1dd0 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -115,7 +115,7 @@ int ipa_mem_setup(struct ipa *ipa)
 	offset = ipa->mem_offset + mem->offset;
 
 	reg = ipa_reg(ipa, LOCAL_PKT_PROC_CNTXT);
-	val = proc_cntxt_base_addr_encoded(ipa->version, offset);
+	val = ipa_reg_encode(reg, IPA_BASE_ADDR, offset);
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 
 	return 0;
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 9e6a74d1c810b..841a693a2c387 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -289,39 +289,31 @@ enum ipa_bcr_compat {
 };
 
 /* LOCAL_PKT_PROC_CNTXT register */
-/* Encoded value for LOCAL_PKT_PROC_CNTXT register BASE_ADDR field */
-static inline u32 proc_cntxt_base_addr_encoded(enum ipa_version version,
-					       u32 addr)
-{
-	if (version < IPA_VERSION_4_5)
-		return u32_encode_bits(addr, GENMASK(16, 0));
-
-	return u32_encode_bits(addr, GENMASK(17, 0));
-}
+enum ipa_reg_local_pkt_proc_cntxt_field_id {
+	IPA_BASE_ADDR,
+};
 
 /* COUNTER_CFG register */
-/* The next field is not present for IPA v3.5+ */
-#define EOT_COAL_GRANULARITY_FMASK		GENMASK(3, 0)
-#define AGGR_GRANULARITY_FMASK			GENMASK(8, 4)
+enum ipa_reg_counter_cfg_field_id {
+	EOT_COAL_GRANULARITY,				/* Not v3.5+ */
+	AGGR_GRANULARITY,
+};
 
 /* IPA_TX_CFG register */
-/* The next three fields are not present for IPA v4.0+ */
-#define TX0_PREFETCH_DISABLE_FMASK		GENMASK(0, 0)
-#define TX1_PREFETCH_DISABLE_FMASK		GENMASK(1, 1)
-#define PREFETCH_ALMOST_EMPTY_SIZE_FMASK	GENMASK(4, 2)
-/* The next six fields are present for IPA v4.0+ */
-#define PREFETCH_ALMOST_EMPTY_SIZE_TX0_FMASK	GENMASK(5, 2)
-#define DMAW_SCND_OUTSD_PRED_THRESHOLD_FMASK	GENMASK(9, 6)
-#define DMAW_SCND_OUTSD_PRED_EN_FMASK		GENMASK(10, 10)
-#define DMAW_MAX_BEATS_256_DIS_FMASK		GENMASK(11, 11)
-#define PA_MASK_EN_FMASK			GENMASK(12, 12)
-#define PREFETCH_ALMOST_EMPTY_SIZE_TX1_FMASK	GENMASK(16, 13)
-/* The next field is present for IPA v4.5+ */
-#define DUAL_TX_ENABLE_FMASK			GENMASK(17, 17)
-/* The next field is present for IPA v4.2+, but not IPA v4.5 */
-#define SSPND_PA_NO_START_STATE_FMASK		GENMASK(18, 18)
-/* The next field is present for IPA v4.2 only */
-#define SSPND_PA_NO_BQ_STATE_FMASK		GENMASK(19, 19)
+enum ipa_reg_ipa_tx_cfg_field_id {
+	TX0_PREFETCH_DISABLE,				/* Not v4.0+ */
+	TX1_PREFETCH_DISABLE,				/* Not v4.0+ */
+	PREFETCH_ALMOST_EMPTY_SIZE,			/* Not v4.0+ */
+	PREFETCH_ALMOST_EMPTY_SIZE_TX0,			/* v4.0+ */
+	DMAW_SCND_OUTSD_PRED_THRESHOLD,			/* v4.0+ */
+	DMAW_SCND_OUTSD_PRED_EN,			/* v4.0+ */
+	DMAW_MAX_BEATS_256_DIS,				/* v4.0+ */
+	PA_MASK_EN,					/* v4.0+ */
+	PREFETCH_ALMOST_EMPTY_SIZE_TX1,			/* v4.0+ */
+	DUAL_TX_ENABLE,					/* v4.5+ */
+	SSPND_PA_NO_START_STATE,			/* v4,2+, not v4.5 */
+	SSPND_PA_NO_BQ_STATE,				/* v4.2 only */
+};
 
 /* FLAVOR_0 register */
 #define IPA_MAX_PIPES_FMASK			GENMASK(3, 0)
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index fb45c94fc514b..fb41fd2c2e691 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -107,13 +107,24 @@ IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c);
 
 IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
 
+static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+	[IPA_BASE_ADDR]					= GENMASK(16, 0),
+						/* Bits 17-31 reserved */
+};
+
 /* Offset must be a multiple of 8 */
-IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
 
-IPA_REG(COUNTER_CFG, counter_cfg, 0x000001f0);
+static const u32 ipa_reg_counter_cfg_fmask[] = {
+	[EOT_COAL_GRANULARITY]				= GENMASK(3, 0),
+	[AGGR_GRANULARITY]				= GENMASK(8, 4),
+						/* Bits 5-31 reserved */
+};
+
+IPA_REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
 
 IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
 	       0x00000400, 0x0020);
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index 4cfe203dd6207..8b7c0e7c26dbf 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -112,15 +112,33 @@ IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c);
 
 IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
 
+static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+	[IPA_BASE_ADDR]					= GENMASK(16, 0),
+						/* Bits 17-31 reserved */
+};
+
 /* Offset must be a multiple of 8 */
-IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
 
-IPA_REG(COUNTER_CFG, counter_cfg, 0x000001f0);
+static const u32 ipa_reg_counter_cfg_fmask[] = {
+						/* Bits 0-3 reserved */
+	[AGGR_GRANULARITY]				= GENMASK(8, 4),
+						/* Bits 5-31 reserved */
+};
 
-IPA_REG(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+IPA_REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
+
+static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+	[TX0_PREFETCH_DISABLE]				= BIT(0),
+	[TX1_PREFETCH_DISABLE]				= BIT(1),
+	[PREFETCH_ALMOST_EMPTY_SIZE]			= GENMASK(4, 2),
+						/* Bits 5-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
 IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index 3230a7b33d8be..d9b1113035577 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -142,13 +142,31 @@ IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 /* Valid bits defined by ipa->available */
 IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
 
+static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+	[IPA_BASE_ADDR]					= GENMASK(17, 0),
+						/* Bits 18-31 reserved */
+};
+
 /* Offset must be a multiple of 8 */
-IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
 
-IPA_REG(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+						/* Bits 0-1 reserved */
+	[PREFETCH_ALMOST_EMPTY_SIZE_TX0]		= GENMASK(5, 2),
+	[DMAW_SCND_OUTSD_PRED_THRESHOLD]		= GENMASK(9, 6),
+	[DMAW_SCND_OUTSD_PRED_EN]			= BIT(10),
+	[DMAW_MAX_BEATS_256_DIS]			= BIT(11),
+	[PA_MASK_EN]					= BIT(12),
+	[PREFETCH_ALMOST_EMPTY_SIZE_TX1]		= GENMASK(16, 13),
+	[DUAL_TX_ENABLE]				= BIT(17),
+	[SSPND_PA_NO_START_STATE]			= BIT(18),
+						/* Bits 19-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
 IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index d4dd1081ff384..ddd8bac2c3e0d 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -136,15 +136,40 @@ IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
 
 IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
 
+static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+	[IPA_BASE_ADDR]					= GENMASK(16, 0),
+						/* Bits 17-31 reserved */
+};
+
 /* Offset must be a multiple of 8 */
-IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
 
-IPA_REG(COUNTER_CFG, counter_cfg, 0x000001f0);
+static const u32 ipa_reg_counter_cfg_fmask[] = {
+						/* Bits 0-3 reserved */
+	[AGGR_GRANULARITY]				= GENMASK(8, 4),
+						/* Bits 9-31 reserved */
+};
 
-IPA_REG(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+IPA_REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
+
+static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+						/* Bits 0-1 reserved */
+	[PREFETCH_ALMOST_EMPTY_SIZE_TX0]		= GENMASK(5, 2),
+	[DMAW_SCND_OUTSD_PRED_THRESHOLD]		= GENMASK(9, 6),
+	[DMAW_SCND_OUTSD_PRED_EN]			= BIT(10),
+	[DMAW_MAX_BEATS_256_DIS]			= BIT(11),
+	[PA_MASK_EN]					= BIT(12),
+	[PREFETCH_ALMOST_EMPTY_SIZE_TX1]		= GENMASK(16, 13),
+						/* Bit 17 reserved */
+	[SSPND_PA_NO_START_STATE]			= BIT(18),
+	[SSPND_PA_NO_BQ_STATE]				= BIT(19),
+						/* Bits 20-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
 IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index 9e669c08f06d9..a08e0bb6b5167 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -136,13 +136,30 @@ IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 /* Valid bits defined by ipa->available */
 IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
 
+static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+	[IPA_BASE_ADDR]					= GENMASK(17, 0),
+						/* Bits 18-31 reserved */
+};
+
 /* Offset must be a multiple of 8 */
-IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
 
-IPA_REG(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+						/* Bits 0-1 reserved */
+	[PREFETCH_ALMOST_EMPTY_SIZE_TX0]		= GENMASK(5, 2),
+	[DMAW_SCND_OUTSD_PRED_THRESHOLD]		= GENMASK(9, 6),
+	[DMAW_SCND_OUTSD_PRED_EN]			= BIT(10),
+	[DMAW_MAX_BEATS_256_DIS]			= BIT(11),
+	[PA_MASK_EN]					= BIT(12),
+	[PREFETCH_ALMOST_EMPTY_SIZE_TX1]		= GENMASK(16, 13),
+	[DUAL_TX_ENABLE]				= BIT(17),
+						/* Bits 18-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
 IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index ea8a597f37686..1561e9716f86b 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -141,13 +141,31 @@ IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 /* Valid bits defined by ipa->available */
 IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
 
+static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+	[IPA_BASE_ADDR]					= GENMASK(17, 0),
+						/* Bits 18-31 reserved */
+};
+
 /* Offset must be a multiple of 8 */
-IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
 
-IPA_REG(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+						/* Bits 0-1 reserved */
+	[PREFETCH_ALMOST_EMPTY_SIZE_TX0]		= GENMASK(5, 2),
+	[DMAW_SCND_OUTSD_PRED_THRESHOLD]		= GENMASK(9, 6),
+	[DMAW_SCND_OUTSD_PRED_EN]			= BIT(10),
+	[DMAW_MAX_BEATS_256_DIS]			= BIT(11),
+	[PA_MASK_EN]					= BIT(12),
+	[PREFETCH_ALMOST_EMPTY_SIZE_TX1]		= GENMASK(16, 13),
+	[DUAL_TX_ENABLE]				= BIT(17),
+	[SSPND_PA_NO_START_STATE]			= BIT(18),
+						/* Bits 19-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
 IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
 
-- 
2.34.1

