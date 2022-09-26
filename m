Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3D05EB44A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiIZWL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiIZWLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:11:00 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F63192B9
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:01 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id y9so4252529ily.11
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=9ltEg+4e6UmlkMyLQCTId9vZnV4CkQbgU1Bl6c7x3pM=;
        b=NCwh75lxC49SrwR57mc9VDCHhVyGFb7O4usdvqjhUOqFfIkyCsDlyPm7J/9BVUJc7U
         dvp6NhkEB16/0I+ZL1LW8kLwTiH0N3XUSbJD9xPVloB2UUHA7g8rO2TCZREFguP7qRDI
         i/ryS8FcjDY9J2QEFfF54zBpjnfzaUciMULivqGNr2s9OTcdUs0tdYF1XuyopExq5hF5
         uI0WDf4NC1jaSYKlfu/QjuB8qym2L/QGP7GSAq0FN8xPLxuiAyhhilAuxNuek3VLVtuW
         F+pbDfYVyYWtpTWRvnhr2zWObRh1Yoay7P8ngrnJCSnwNd7IWY2uibCelc8ZtW7kFAJC
         e/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9ltEg+4e6UmlkMyLQCTId9vZnV4CkQbgU1Bl6c7x3pM=;
        b=3ZBIcESGONue+txp5Lat9DSzRC0hKp/eJSZiQS2gF4WSI3REZCdWvKT7UA9jQ2qGoh
         OvibVA+L5+wR1ttH2O0+dbakSwuVZw8OT2apjs712Jnvl54a5GV2w1rAFqCPVxJOgeux
         ccYNQzUbwidxyS1W+3lTu+I7m0vHuP1hnd1u9B/LZevOuexUpT7/PoT6TG5iFrYsREfl
         g3eFCf/XpKVhSppsU8ldcA6vrILdiRRx9rXRSdzT2sEi3YbJeg399UK6TGgaRnyiHk6L
         rjuyqMPIeg7ioZzEuPR33D2n18UMcvbZQjbn0yhtUlohns8/hd4IR1pfAcpkmpUEXWQx
         80Tw==
X-Gm-Message-State: ACrzQf0e4ZoW1+HLWp3HoOzD/yBYYvNAIlpioT7IoTjnMbmXXDOiedy4
        7hWtHlqkmWGMexYyUN/Q86SHlQ==
X-Google-Smtp-Source: AMsMyM65w6WZqHeiTBauQTAgeUf5HD9/22ObDilz6M952uz/FtYNTRH5W8kP/D/e7l8ssY9RqkQNJQ==
X-Received: by 2002:a05:6e02:1bcc:b0:2f7:2d36:36b1 with SMTP id x12-20020a056e021bcc00b002f72d3636b1mr8956877ilv.240.1664230199802;
        Mon, 26 Sep 2022 15:09:59 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:09:58 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/15] net: ipa: define some more IPA register fields
Date:   Mon, 26 Sep 2022 17:09:25 -0500
Message-Id: <20220926220931.3261749-10-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926220931.3261749-1-elder@linaro.org>
References: <20220926220931.3261749-1-elder@linaro.org>
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

Define the fields for the SHARED_MEM_SIZE, QSB_MAX_WRITES,
QSB_MAX_READS, FILT_ROUT_HASH_EN, and FILT_ROUT_HASH_FLUSH IPA
registers for all supported IPA versions.

Create enumerated types to identify fields for these registers.  Use
IPA_REG_FIELDS() to specify the field mask values defined for these
registers, for each supported version of IPA.

Use ipa_reg_bit() and ipa_reg_encode() to build up the values to be
written to these registers rather than using the *_FMASK
preprocessor symbols.

Remove the definition of the now unused *_FMASK symbols.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c           | 24 +++++++------
 drivers/net/ipa/ipa_mem.c            |  5 +--
 drivers/net/ipa/ipa_reg.h            | 33 +++++++++++-------
 drivers/net/ipa/ipa_table.c          |  6 ++--
 drivers/net/ipa/reg/ipa_reg-v3.1.c   | 48 +++++++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c | 48 +++++++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v4.11.c  | 51 +++++++++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v4.2.c   | 51 +++++++++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v4.5.c   | 51 +++++++++++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v4.9.c   | 51 +++++++++++++++++++++++++---
 10 files changed, 311 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index b73eb2d9dccef..771b5c378b306 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -293,26 +293,26 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 	/* Max outstanding write accesses for QSB masters */
 	reg = ipa_reg(ipa, QSB_MAX_WRITES);
 
-	val = u32_encode_bits(data0->max_writes, GEN_QMB_0_MAX_WRITES_FMASK);
+	val = ipa_reg_encode(reg, GEN_QMB_0_MAX_WRITES, data0->max_writes);
 	if (data->qsb_count > 1)
-		val |= u32_encode_bits(data1->max_writes,
-				       GEN_QMB_1_MAX_WRITES_FMASK);
+		val |= ipa_reg_encode(reg, GEN_QMB_1_MAX_WRITES,
+				      data1->max_writes);
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* Max outstanding read accesses for QSB masters */
 	reg = ipa_reg(ipa, QSB_MAX_READS);
 
-	val = u32_encode_bits(data0->max_reads, GEN_QMB_0_MAX_READS_FMASK);
+	val = ipa_reg_encode(reg, GEN_QMB_0_MAX_READS, data0->max_reads);
 	if (ipa->version >= IPA_VERSION_4_0)
-		val |= u32_encode_bits(data0->max_reads_beats,
-				       GEN_QMB_0_MAX_READS_BEATS_FMASK);
+		val |= ipa_reg_encode(reg, GEN_QMB_0_MAX_READS_BEATS,
+				      data0->max_reads_beats);
 	if (data->qsb_count > 1) {
-		val |= u32_encode_bits(data1->max_reads,
-				       GEN_QMB_1_MAX_READS_FMASK);
+		val = ipa_reg_encode(reg, GEN_QMB_1_MAX_READS,
+				     data1->max_reads);
 		if (ipa->version >= IPA_VERSION_4_0)
-			val |= u32_encode_bits(data1->max_reads_beats,
-					       GEN_QMB_1_MAX_READS_BEATS_FMASK);
+			val |= ipa_reg_encode(reg, GEN_QMB_1_MAX_READS_BEATS,
+					      data1->max_reads_beats);
 	}
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
@@ -419,6 +419,10 @@ static void ipa_hardware_config_hashing(struct ipa *ipa)
 
 	/* IPA v4.2 does not support hashed tables, so disable them */
 	reg = ipa_reg(ipa, FILT_ROUT_HASH_EN);
+
+	/* IPV6_ROUTER_HASH, IPV6_FILTER_HASH, IPV4_ROUTER_HASH,
+	 * IPV4_FILTER_HASH are all zero.
+	 */
 	iowrite32(0, ipa->reg_virt + ipa_reg_offset(reg));
 }
 
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index a5d94027cad10..0c22ea8d8ad06 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -322,9 +322,10 @@ int ipa_mem_config(struct ipa *ipa)
 	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
 
 	/* The fields in the register are in 8 byte units */
-	ipa->mem_offset = 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
+	ipa->mem_offset = 8 * ipa_reg_decode(reg, MEM_BADDR, val);
+
 	/* Make sure the end is within the region's mapped space */
-	mem_size = 8 * u32_get_bits(val, SHARED_MEM_SIZE_FMASK);
+	mem_size = 8 * ipa_reg_decode(reg, MEM_SIZE, val);
 
 	/* If the sizes don't match, issue a warning */
 	if (ipa->mem_offset + mem_size < ipa->mem_size) {
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 3de1c6ed9e854..9e6a74d1c810b 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -247,25 +247,32 @@ enum ipa_reg_route_field_id {
 };
 
 /* SHARED_MEM_SIZE register */
-#define SHARED_MEM_SIZE_FMASK			GENMASK(15, 0)
-#define SHARED_MEM_BADDR_FMASK			GENMASK(31, 16)
+enum ipa_reg_shared_mem_size_field_id {
+	MEM_SIZE,
+	MEM_BADDR,
+};
 
 /* QSB_MAX_WRITES register */
-#define GEN_QMB_0_MAX_WRITES_FMASK		GENMASK(3, 0)
-#define GEN_QMB_1_MAX_WRITES_FMASK		GENMASK(7, 4)
+enum ipa_reg_qsb_max_writes_field_id {
+	GEN_QMB_0_MAX_WRITES,
+	GEN_QMB_1_MAX_WRITES,
+};
 
 /* QSB_MAX_READS register */
-#define GEN_QMB_0_MAX_READS_FMASK		GENMASK(3, 0)
-#define GEN_QMB_1_MAX_READS_FMASK		GENMASK(7, 4)
-/* The next two fields are present for IPA v4.0+ */
-#define GEN_QMB_0_MAX_READS_BEATS_FMASK		GENMASK(23, 16)
-#define GEN_QMB_1_MAX_READS_BEATS_FMASK		GENMASK(31, 24)
+enum ipa_reg_qsb_max_reads_field_id {
+	GEN_QMB_0_MAX_READS,
+	GEN_QMB_1_MAX_READS,
+	GEN_QMB_0_MAX_READS_BEATS,			/* IPA v4.0+ */
+	GEN_QMB_1_MAX_READS_BEATS,			/* IPA v4.0+ */
+};
 
 /* FILT_ROUT_HASH_EN and FILT_ROUT_HASH_FLUSH registers */
-#define IPV6_ROUTER_HASH_FMASK			GENMASK(0, 0)
-#define IPV6_FILTER_HASH_FMASK			GENMASK(4, 4)
-#define IPV4_ROUTER_HASH_FMASK			GENMASK(8, 8)
-#define IPV4_FILTER_HASH_FMASK			GENMASK(12, 12)
+enum ipa_reg_rout_hash_field_id {
+	IPV6_ROUTER_HASH,
+	IPV6_FILTER_HASH,
+	IPV4_ROUTER_HASH,
+	IPV4_FILTER_HASH,
+};
 
 /* BCR register */
 enum ipa_bcr_compat {
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 04747e0842267..32873e6cb4ad1 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -401,8 +401,10 @@ int ipa_table_hash_flush(struct ipa *ipa)
 	reg = ipa_reg(ipa, FILT_ROUT_HASH_FLUSH);
 	offset = ipa_reg_offset(reg);
 
-	val = IPV4_FILTER_HASH_FMASK | IPV6_FILTER_HASH_FMASK;
-	val |= IPV6_ROUTER_HASH_FMASK | IPV4_ROUTER_HASH_FMASK;
+	val = ipa_reg_bit(reg, IPV6_ROUTER_HASH);
+	val |= ipa_reg_bit(reg, IPV6_FILTER_HASH);
+	val |= ipa_reg_bit(reg, IPV4_ROUTER_HASH);
+	val |= ipa_reg_bit(reg, IPV4_FILTER_HASH);
 
 	ipa_cmd_register_write_add(trans, offset, val, val, false);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index a09b61eee245b..fb45c94fc514b 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -54,15 +54,53 @@ static const u32 ipa_reg_route_fmask[] = {
 
 IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
-IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+static const u32 ipa_reg_shared_mem_size_fmask[] = {
+	[MEM_SIZE]					= GENMASK(15, 0),
+	[MEM_BADDR]					= GENMASK(31, 16),
+};
 
-IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
+						/* Bits 8-31 reserved */
+};
 
-IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x000008c);
+IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
+static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
+};
+
+IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x000008c);
+
+static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c);
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index 4333c11a7e3d5..4cfe203dd6207 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -59,15 +59,53 @@ static const u32 ipa_reg_route_fmask[] = {
 
 IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
-IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+static const u32 ipa_reg_shared_mem_size_fmask[] = {
+	[MEM_SIZE]					= GENMASK(15, 0),
+	[MEM_BADDR]					= GENMASK(31, 16),
+};
 
-IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
+						/* Bits 8-31 reserved */
+};
 
-IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x000008c);
+IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
+static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
+};
+
+IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x000008c);
+
+static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index 598cbdd67444e..3230a7b33d8be 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -88,15 +88,56 @@ static const u32 ipa_reg_route_fmask[] = {
 
 IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
-IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+static const u32 ipa_reg_shared_mem_size_fmask[] = {
+	[MEM_SIZE]					= GENMASK(15, 0),
+	[MEM_BADDR]					= GENMASK(31, 16),
+};
 
-IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
+						/* Bits 8-31 reserved */
+};
 
-IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
+						/* Bits 8-15 reserved */
+	[GEN_QMB_0_MAX_READS_BEATS]			= GENMASK(23, 16),
+	[GEN_QMB_1_MAX_READS_BEATS]			= GENMASK(31, 24),
+};
+
+IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+
+static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index dfcbd4b5a87a9..d4dd1081ff384 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -80,15 +80,56 @@ static const u32 ipa_reg_route_fmask[] = {
 
 IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
-IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+static const u32 ipa_reg_shared_mem_size_fmask[] = {
+	[MEM_SIZE]					= GENMASK(15, 0),
+	[MEM_BADDR]					= GENMASK(31, 16),
+};
 
-IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
+						/* Bits 8-31 reserved */
+};
 
-IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
+						/* Bits 8-15 reserved */
+	[GEN_QMB_0_MAX_READS_BEATS]			= GENMASK(23, 16),
+	[GEN_QMB_1_MAX_READS_BEATS]			= GENMASK(31, 24),
+};
+
+IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+
+static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index 2cc20fc2fcba7..9e669c08f06d9 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -82,15 +82,56 @@ static const u32 ipa_reg_route_fmask[] = {
 
 IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
-IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+static const u32 ipa_reg_shared_mem_size_fmask[] = {
+	[MEM_SIZE]					= GENMASK(15, 0),
+	[MEM_BADDR]					= GENMASK(31, 16),
+};
 
-IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
+						/* Bits 8-31 reserved */
+};
 
-IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
+						/* Bits 8-15 reserved */
+	[GEN_QMB_0_MAX_READS_BEATS]			= GENMASK(23, 16),
+	[GEN_QMB_1_MAX_READS_BEATS]			= GENMASK(31, 24),
+};
+
+IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+
+static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index 4e5f7acab1a32..ea8a597f37686 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -87,15 +87,56 @@ static const u32 ipa_reg_route_fmask[] = {
 
 IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
-IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+static const u32 ipa_reg_shared_mem_size_fmask[] = {
+	[MEM_SIZE]					= GENMASK(15, 0),
+	[MEM_BADDR]					= GENMASK(31, 16),
+};
 
-IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
+						/* Bits 8-31 reserved */
+};
 
-IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
+						/* Bits 8-15 reserved */
+	[GEN_QMB_0_MAX_READS_BEATS]			= GENMASK(23, 16),
+	[GEN_QMB_1_MAX_READS_BEATS]			= GENMASK(31, 24),
+};
+
+IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+
+static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
 IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
-- 
2.34.1

