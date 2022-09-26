Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD505EB453
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiIZWMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiIZWLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:11:20 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7BA1F2F0
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:06 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id 138so6394043iou.9
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=bF9gQ7smtgZrwmAZmGYXvH76yJXdV8Ak0xbvhpnQr1E=;
        b=wWHNpoV0EIu7YkVyCIgBSgJuxIpa4EUUWh83QlTGMmBT7aR/NW5nfAxWzGCJ6bzg2M
         aKnLsGUamH/Hzc3WmLkYlvt7ezMxYmdiethFGjlegTGaRtbHX4S/LP5vI9qRMq01hEmM
         ekSrQhdeCfWoiYLrTe3naTnQi22UlLw+NARx4JzWgfOq7iNHmFB24gd5SdQnmEOl3UE5
         Jq+QqieYJyTdYKBh3wpJKcEOE3yunYoehCvj9agXpVn3GADHEN1wwIM6XskRgajPqTQ2
         Isnsz99lbKoKDJ6+GNJIAHFVKYw3XAhR0LiSyBGdHU6ecmt0qwSal8YUv1lNP6TA5Rjn
         IOcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bF9gQ7smtgZrwmAZmGYXvH76yJXdV8Ak0xbvhpnQr1E=;
        b=68q7Z8W0gO/PlQcHHfWy9dUkLNgYZKii1pkYx6iRZaIKtltQxlgJ8r/RCwi5+SN3IC
         OxzzjhEj+vCpcN9QN22T0xSnkm8PYs6ApCCIVpxe4lj7vRDpxvSRe4bzrfSpwdDvPh4P
         FIEceVB7RookwvWXubG83ts01nJH3W6Y+YsN+1tkzixpf9ZnfGFhemEuv16yJoN/IoUY
         D+smDf5UPUDWZWhDZwzsDbMe2ErAA8znIeK4ZlwxCnpQjfVpV8FOXjwfVwdUkliIJ2SB
         EwcvfgreM+E8uvu2ZNfWYGMGOG7LpZ4/hqPptAskOsM0fTxbS7a9c+e082ToGTmq2glN
         2ERA==
X-Gm-Message-State: ACrzQf3NwNEYR/ICqbVYiT7ptZJLCKt81q7O7xz2xqTsjjH5jkn8xRpA
        n/2mPFmj4h6dtfwbQ6cLyKWrxw==
X-Google-Smtp-Source: AMsMyM4wakVK+liGG7psA41dwk6AT+qoVgcaZW+xqYjZyc+sGCRtRjYwMmPh1L/IstoJLgcE9RKq/Q==
X-Received: by 2002:a02:290e:0:b0:35a:d680:7aad with SMTP id p14-20020a02290e000000b0035ad6807aadmr12434036jap.62.1664230205788;
        Mon, 26 Sep 2022 15:10:05 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:10:05 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 12/15] net: ipa: define resource group/type IPA register fields
Date:   Mon, 26 Sep 2022 17:09:28 -0500
Message-Id: <20220926220931.3261749-13-elder@linaro.org>
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

Define the fields for the {SRC,DST}_RSRC_GRP_{01,23,45,67}_RSRC_TYPE
IPA registers for all supported IPA versions.

Create enumerated types to identify fields for these IPA registers.
Use IPA_REG_STRIDE_FIELDS() to specify the field mask values defined
for these registers, for each supported version of IPA.

Use ipa_reg_encode() to build up the values to be written to these
registers.

Remove the definition of the no-longer-used *_FMASK symbols.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.h            |  10 ++-
 drivers/net/ipa/ipa_resource.c       |  53 +++++-------
 drivers/net/ipa/reg/ipa_reg-v3.1.c   | 120 +++++++++++++++++++++++----
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c |  60 ++++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.11.c  |  60 ++++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.2.c   |  60 ++++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.5.c   |  90 +++++++++++++++++---
 drivers/net/ipa/reg/ipa_reg-v4.9.c   |  60 ++++++++++++--
 8 files changed, 419 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index bdd085a1f31c9..0df61aaa8b819 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -363,10 +363,12 @@ enum ipa_pulse_gran {
 };
 
 /* {SRC,DST}_RSRC_GRP_{01,23,45,67}_RSRC_TYPE registers */
-#define X_MIN_LIM_FMASK				GENMASK(5, 0)
-#define X_MAX_LIM_FMASK				GENMASK(13, 8)
-#define Y_MIN_LIM_FMASK				GENMASK(21, 16)
-#define Y_MAX_LIM_FMASK				GENMASK(29, 24)
+enum ipa_reg_rsrc_grp_rsrc_type_field_id {
+	X_MIN_LIM,
+	X_MAX_LIM,
+	Y_MIN_LIM,
+	Y_MAX_LIM,
+};
 
 /* ENDP_INIT_CTRL register */
 /* Valid only for RX (IPA producer) endpoints (do not use for IPA v4.0+) */
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index bda2f87ca6dcf..5376b71f45984 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -69,20 +69,21 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 }
 
 static void
-ipa_resource_config_common(struct ipa *ipa, u32 offset,
+ipa_resource_config_common(struct ipa *ipa, u32 resource_type,
+			   const struct ipa_reg *reg,
 			   const struct ipa_resource_limits *xlimits,
 			   const struct ipa_resource_limits *ylimits)
 {
 	u32 val;
 
-	val = u32_encode_bits(xlimits->min, X_MIN_LIM_FMASK);
-	val |= u32_encode_bits(xlimits->max, X_MAX_LIM_FMASK);
+	val = ipa_reg_encode(reg, X_MIN_LIM, xlimits->min);
+	val |= ipa_reg_encode(reg, X_MAX_LIM, xlimits->max);
 	if (ylimits) {
-		val |= u32_encode_bits(ylimits->min, Y_MIN_LIM_FMASK);
-		val |= u32_encode_bits(ylimits->max, Y_MAX_LIM_FMASK);
+		val |= ipa_reg_encode(reg, Y_MIN_LIM, ylimits->min);
+		val |= ipa_reg_encode(reg, Y_MAX_LIM, ylimits->max);
 	}
 
-	iowrite32(val, ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, resource_type));
 }
 
 static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
@@ -92,38 +93,34 @@ static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
 	const struct ipa_resource_limits *ylimits;
 	const struct ipa_resource *resource;
 	const struct ipa_reg *reg;
-	u32 offset;
 
 	resource = &data->resource_src[resource_type];
 
 	reg = ipa_reg(ipa, SRC_RSRC_GRP_01_RSRC_TYPE);
-	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 1 ? NULL : &resource->limits[1];
-	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
-
+	ipa_resource_config_common(ipa, resource_type, reg,
+				   &resource->limits[0], ylimits);
 	if (group_count < 3)
 		return;
 
 	reg = ipa_reg(ipa, SRC_RSRC_GRP_23_RSRC_TYPE);
-	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 3 ? NULL : &resource->limits[3];
-	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
-
+	ipa_resource_config_common(ipa, resource_type, reg,
+				   &resource->limits[2], ylimits);
 	if (group_count < 5)
 		return;
 
 	reg = ipa_reg(ipa, SRC_RSRC_GRP_45_RSRC_TYPE);
-	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 5 ? NULL : &resource->limits[5];
-	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
-
+	ipa_resource_config_common(ipa, resource_type, reg,
+				   &resource->limits[4], ylimits);
 	if (group_count < 7)
 		return;
 
 	reg = ipa_reg(ipa, SRC_RSRC_GRP_67_RSRC_TYPE);
-	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 7 ? NULL : &resource->limits[7];
-	ipa_resource_config_common(ipa, offset, &resource->limits[6], ylimits);
+	ipa_resource_config_common(ipa, resource_type, reg,
+				   &resource->limits[6], ylimits);
 }
 
 static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
@@ -133,38 +130,34 @@ static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
 	const struct ipa_resource_limits *ylimits;
 	const struct ipa_resource *resource;
 	const struct ipa_reg *reg;
-	u32 offset;
 
 	resource = &data->resource_dst[resource_type];
 
 	reg = ipa_reg(ipa, DST_RSRC_GRP_01_RSRC_TYPE);
-	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 1 ? NULL : &resource->limits[1];
-	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
-
+	ipa_resource_config_common(ipa, resource_type, reg,
+				   &resource->limits[0], ylimits);
 	if (group_count < 3)
 		return;
 
 	reg = ipa_reg(ipa, DST_RSRC_GRP_23_RSRC_TYPE);
-	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 3 ? NULL : &resource->limits[3];
-	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
-
+	ipa_resource_config_common(ipa, resource_type, reg,
+				   &resource->limits[2], ylimits);
 	if (group_count < 5)
 		return;
 
 	reg = ipa_reg(ipa, DST_RSRC_GRP_45_RSRC_TYPE);
-	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 5 ? NULL : &resource->limits[5];
-	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
-
+	ipa_resource_config_common(ipa, resource_type, reg,
+				   &resource->limits[4], ylimits);
 	if (group_count < 7)
 		return;
 
 	reg = ipa_reg(ipa, DST_RSRC_GRP_67_RSRC_TYPE);
-	offset = ipa_reg_n_offset(reg, resource_type);
 	ylimits = group_count == 7 ? NULL : &resource->limits[7];
-	ipa_resource_config_common(ipa, offset, &resource->limits[6], ylimits);
+	ipa_resource_config_common(ipa, resource_type, reg,
+				   &resource->limits[6], ylimits);
 }
 
 /* Configure resources; there is no ipa_resource_deconfig() */
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index fb41fd2c2e691..67739c59c1987 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -126,29 +126,117 @@ static const u32 ipa_reg_counter_cfg_fmask[] = {
 
 IPA_REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-	       0x00000400, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-	       0x00000404, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		      0x00000400, 0x0020);
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
-	       0x00000408, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_67_RSRC_TYPE, src_rsrc_grp_67_rsrc_type,
-	       0x0000040c, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		      0x00000404, 0x0020);
 
-IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-	       0x00000500, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_45_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-	       0x00000504, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
+		      0x00000408, 0x0020);
 
-IPA_REG_STRIDE(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
-	       0x00000508, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_67_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(DST_RSRC_GRP_67_RSRC_TYPE, dst_rsrc_grp_67_rsrc_type,
-	       0x0000050c, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_67_RSRC_TYPE, src_rsrc_grp_67_rsrc_type,
+		      0x0000040c, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		      0x00000500, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		      0x00000504, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_45_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
+		      0x00000508, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_67_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_67_RSRC_TYPE, dst_rsrc_grp_67_rsrc_type,
+		      0x0000050c, 0x0020);
 
 IPA_REG_STRIDE(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index ce63f4a6cc9d8..3f491992c93f1 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -161,17 +161,61 @@ static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
 
 IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000220);
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-	       0x00000400, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-	       0x00000404, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		      0x00000400, 0x0020);
 
-IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-	       0x00000500, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-	       0x00000504, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		      0x00000404, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		      0x00000500, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		      0x00000504, 0x0020);
 
 IPA_REG_STRIDE(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index 77f4b14650ad4..7df6837a69328 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -218,17 +218,61 @@ static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
 
 IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-	       0x00000400, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-	       0x00000404, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		      0x00000400, 0x0020);
 
-IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-	       0x00000500, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-	       0x00000504, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		      0x00000404, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		      0x00000500, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		      0x00000504, 0x0020);
 
 IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index a9aca0ecff8ff..a680e131ea84f 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -192,17 +192,61 @@ static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
 
 IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-	       0x00000400, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-	       0x00000404, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		      0x00000400, 0x0020);
 
-IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-	       0x00000500, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-	       0x00000504, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		      0x00000404, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		      0x00000500, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		      0x00000504, 0x0020);
 
 IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index 9a93725b8efab..f43684f92fee9 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -210,23 +210,89 @@ static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
 
 IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-	       0x00000400, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-	       0x00000404, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		      0x00000400, 0x0020);
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
-	       0x00000408, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-	       0x00000500, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		      0x00000404, 0x0020);
 
-IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-	       0x00000504, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_45_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
-	       0x00000508, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
+		      0x00000408, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		      0x00000500, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		      0x00000504, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_45_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
+		      0x00000508, 0x0020);
 
 IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index 4e46466ffb47e..ab71c3195cc32 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -216,17 +216,61 @@ static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
 
 IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-	       0x00000400, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-	       0x00000404, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		      0x00000400, 0x0020);
 
-IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-	       0x00000500, 0x0020);
+static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-	       0x00000504, 0x0020);
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		      0x00000404, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		      0x00000500, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		      0x00000504, 0x0020);
 
 IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-- 
2.34.1

