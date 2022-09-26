Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BD35EB448
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiIZWL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiIZWKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:10:30 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE28C178BB
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:58 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id e205so6426797iof.1
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=C2gb1B9FHUedWkXgAzd3HnMqDwOYfTwGy3MrzoL8/ZE=;
        b=JS9wXbdOcInLfO4K4sMWsIPk5AwiLAE9sqHncLsKa+nQ7lvXU0S4gN+57IiIaDqTol
         HSjEccXhDAo7OlrgFbLYxY/nD6mah4fBTaJv0e6byQmF+mAebkjRiTJv2mYPHJYFOlfo
         CgEDzjhc2tzw+Ere/rSaAnk0KDvEJ3J2qjXMrTnGHEUYLtJEbL3ZCJ+mQH9VIMYTsLIN
         +yHBJwZkFC2J8F0Bd1/hrB1IZzFzzyWIlPiS7sbD3/+OfNcpgC2xP9hrJqyYiSzovsho
         dV+npuX/LsVPLwENuLIZHMPZfqEo0MEaT6+qnbQ2d8LQoxjalAjweMqrqP4U4TlSUzTV
         cStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=C2gb1B9FHUedWkXgAzd3HnMqDwOYfTwGy3MrzoL8/ZE=;
        b=IwlBfvIPulcmTXep6C2Z/LjJm7CcmHv/3rzRUKYBRavk4ZTnJjPH3sSLlHRpODXy1Y
         qRqlz+X1bYw3u2oLyZu8+PsU9NDRMECWGPZqw3PgbaCbt+s0KUtVwqYuiHGHtvItofK1
         qrpPZy5TDh6aySP5Z148ezJUjQ90szUqr3YKG+a0UYtJOoTf1usr5ErK6rPmVsmZjYZS
         hHSl/wXyGtsW7/TaYC3yIRcmQmeAsgVamuJGgXBe/fwTfOXJbqerQ1MdwW22bliqNNZy
         MEcgnfApdVXyJlkC2jOv5mJRaPrVma2fCU8gJ3RpI/oNw0RT8JQReIP7kbCmnY0b+Hwd
         JMbQ==
X-Gm-Message-State: ACrzQf2kQNDnzcEw1779QbujmpvnS4qQsV2H7k/UDwq1astZZq/fgemv
        e3K43KXhgCm7sw9niyHnBhIDrg==
X-Google-Smtp-Source: AMsMyM775ReOMg7ZBDfy/fgbr7lkMFLUBpaA+q3E3/johXpih7/1fXcVGXd68sSy9anLkpQWrNtKEA==
X-Received: by 2002:a6b:8e92:0:b0:6a4:4799:3c80 with SMTP id q140-20020a6b8e92000000b006a447993c80mr6386229iod.93.1664230197799;
        Mon, 26 Sep 2022 15:09:57 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:09:56 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/15] net: ipa: define CLKON_CFG and ROUTE IPA register fields
Date:   Mon, 26 Sep 2022 17:09:24 -0500
Message-Id: <20220926220931.3261749-9-elder@linaro.org>
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

Create the ipa_reg_clkon_cfg_field_id enumerated type, which
identifies the fields for the CLKON_CFG IPA register.  Add "CLKON_"
to a few short names to try to avoid name conflicts.  Create the
ipa_reg_route_field_id enumerated type, which identifies the fields
for the ROUTE IPA register.

Use IPA_REG_FIELDS() to specify the field mask values defined for
these registers, for each supported version of IPA.

Use ipa_reg_bit() and ipa_reg_encode() to build up the values to be
written to these registers rather than using the *_FMASK
preprocessor symbols.

Remove the definition of the now unused *_FMASK symbols.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c       | 10 ++--
 drivers/net/ipa/ipa_main.c           | 12 ++--
 drivers/net/ipa/ipa_reg.h            | 86 ++++++++++++++--------------
 drivers/net/ipa/reg/ipa_reg-v3.1.c   | 36 +++++++++++-
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c | 41 ++++++++++++-
 drivers/net/ipa/reg/ipa_reg-v4.11.c  | 50 +++++++++++++++-
 drivers/net/ipa/reg/ipa_reg-v4.2.c   | 49 +++++++++++++++-
 drivers/net/ipa/reg/ipa_reg-v4.5.c   | 50 +++++++++++++++-
 drivers/net/ipa/reg/ipa_reg-v4.9.c   | 50 +++++++++++++++-
 9 files changed, 319 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 9dc63bc7d57f9..0409f19166b30 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1473,11 +1473,11 @@ void ipa_endpoint_default_route_set(struct ipa *ipa, u32 endpoint_id)
 
 	reg = ipa_reg(ipa, ROUTE);
 	/* ROUTE_DIS is 0 */
-	val = u32_encode_bits(endpoint_id, ROUTE_DEF_PIPE_FMASK);
-	val |= ROUTE_DEF_HDR_TABLE_FMASK;
-	val |= u32_encode_bits(0, ROUTE_DEF_HDR_OFST_FMASK);
-	val |= u32_encode_bits(endpoint_id, ROUTE_FRAG_DEF_PIPE_FMASK);
-	val |= ROUTE_DEF_RETAIN_HDR_FMASK;
+	val = ipa_reg_encode(reg, ROUTE_DEF_PIPE, endpoint_id);
+	val |= ipa_reg_bit(reg, ROUTE_DEF_HDR_TABLE);
+	/* ROUTE_DEF_HDR_OFST is 0 */
+	val |= ipa_reg_encode(reg, ROUTE_FRAG_DEF_PIPE, endpoint_id);
+	val |= ipa_reg_bit(reg, ROUTE_DEF_RETAIN_HDR);
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 9e8f18ca20e2d..b73eb2d9dccef 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -233,10 +233,14 @@ static void ipa_hardware_config_clkon(struct ipa *ipa)
 
 	/* Implement some hardware workarounds */
 	reg = ipa_reg(ipa, CLKON_CFG);
-	if (version == IPA_VERSION_3_1)
-		val = MISC_FMASK;	/* Disable MISC clock gating */
-	else	/* Enable open global clocks in the CLKON configuration */
-		val = GLOBAL_FMASK | GLOBAL_2X_CLK_FMASK;	/* IPA v4.0+ */
+	if (version == IPA_VERSION_3_1) {
+		/* Disable MISC clock gating */
+		val = ipa_reg_bit(reg, CLKON_MISC);
+	} else {	/* IPA v4.0+ */
+		/* Enable open global clocks in the CLKON configuration */
+		val = ipa_reg_bit(reg, CLKON_GLOBAL);
+		val |= ipa_reg_bit(reg, GLOBAL_2X_CLK);
+	}
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 }
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index f07a2b3dafa53..3de1c6ed9e854 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -201,52 +201,50 @@ enum ipa_reg_comp_cfg_field_id {
 };
 
 /* CLKON_CFG register */
-#define RX_FMASK				GENMASK(0, 0)
-#define PROC_FMASK				GENMASK(1, 1)
-#define TX_WRAPPER_FMASK			GENMASK(2, 2)
-#define MISC_FMASK				GENMASK(3, 3)
-#define RAM_ARB_FMASK				GENMASK(4, 4)
-#define FTCH_HPS_FMASK				GENMASK(5, 5)
-#define FTCH_DPS_FMASK				GENMASK(6, 6)
-#define HPS_FMASK				GENMASK(7, 7)
-#define DPS_FMASK				GENMASK(8, 8)
-#define RX_HPS_CMDQS_FMASK			GENMASK(9, 9)
-#define HPS_DPS_CMDQS_FMASK			GENMASK(10, 10)
-#define DPS_TX_CMDQS_FMASK			GENMASK(11, 11)
-#define RSRC_MNGR_FMASK				GENMASK(12, 12)
-#define CTX_HANDLER_FMASK			GENMASK(13, 13)
-#define ACK_MNGR_FMASK				GENMASK(14, 14)
-#define D_DCPH_FMASK				GENMASK(15, 15)
-#define H_DCPH_FMASK				GENMASK(16, 16)
-/* The next field is not present for IPA v4.5+ */
-#define DCMP_FMASK				GENMASK(17, 17)
-/* The next three fields are present for IPA v3.5+ */
-#define NTF_TX_CMDQS_FMASK			GENMASK(18, 18)
-#define TX_0_FMASK				GENMASK(19, 19)
-#define TX_1_FMASK				GENMASK(20, 20)
-/* The next field is present for IPA v3.5.1+ */
-#define FNR_FMASK				GENMASK(21, 21)
-/* The next eight fields are present for IPA v4.0+ */
-#define QSB2AXI_CMDQ_L_FMASK			GENMASK(22, 22)
-#define AGGR_WRAPPER_FMASK			GENMASK(23, 23)
-#define RAM_SLAVEWAY_FMASK			GENMASK(24, 24)
-#define QMB_FMASK				GENMASK(25, 25)
-#define WEIGHT_ARB_FMASK			GENMASK(26, 26)
-#define GSI_IF_FMASK				GENMASK(27, 27)
-#define GLOBAL_FMASK				GENMASK(28, 28)
-#define GLOBAL_2X_CLK_FMASK			GENMASK(29, 29)
-/* The next field is present for IPA v4.5+ */
-#define DPL_FIFO_FMASK				GENMASK(30, 30)
-/* The next field is present for IPA v4.7+ */
-#define DRBIP_FMASK				GENMASK(31, 31)
+enum ipa_reg_clkon_cfg_field_id {
+	CLKON_RX,
+	CLKON_PROC,
+	TX_WRAPPER,
+	CLKON_MISC,
+	RAM_ARB,
+	FTCH_HPS,
+	FTCH_DPS,
+	CLKON_HPS,
+	CLKON_DPS,
+	RX_HPS_CMDQS,
+	HPS_DPS_CMDQS,
+	DPS_TX_CMDQS,
+	RSRC_MNGR,
+	CTX_HANDLER,
+	ACK_MNGR,
+	D_DCPH,
+	H_DCPH,
+	CLKON_DCMP,					/* IPA v4.5+ */
+	NTF_TX_CMDQS,					/* IPA v3.5+ */
+	CLKON_TX_0,					/* IPA v3.5+ */
+	CLKON_TX_1,					/* IPA v3.5+ */
+	CLKON_FNR,					/* IPA v3.5.1+ */
+	QSB2AXI_CMDQ_L,					/* IPA v4.0+ */
+	AGGR_WRAPPER,					/* IPA v4.0+ */
+	RAM_SLAVEWAY,					/* IPA v4.0+ */
+	CLKON_QMB,					/* IPA v4.0+ */
+	WEIGHT_ARB,					/* IPA v4.0+ */
+	GSI_IF,						/* IPA v4.0+ */
+	CLKON_GLOBAL,					/* IPA v4.0+ */
+	GLOBAL_2X_CLK,					/* IPA v4.0+ */
+	DPL_FIFO,					/* IPA v4.5+ */
+	DRBIP,						/* IPA v4.7+ */
+};
 
 /* ROUTE register */
-#define ROUTE_DIS_FMASK				GENMASK(0, 0)
-#define ROUTE_DEF_PIPE_FMASK			GENMASK(5, 1)
-#define ROUTE_DEF_HDR_TABLE_FMASK		GENMASK(6, 6)
-#define ROUTE_DEF_HDR_OFST_FMASK		GENMASK(16, 7)
-#define ROUTE_FRAG_DEF_PIPE_FMASK		GENMASK(21, 17)
-#define ROUTE_DEF_RETAIN_HDR_FMASK		GENMASK(24, 24)
+enum ipa_reg_route_field_id {
+	ROUTE_DIS,
+	ROUTE_DEF_PIPE,
+	ROUTE_DEF_HDR_TABLE,
+	ROUTE_DEF_HDR_OFST,
+	ROUTE_FRAG_DEF_PIPE,
+	ROUTE_DEF_RETAIN_HDR,
+};
 
 /* SHARED_MEM_SIZE register */
 #define SHARED_MEM_SIZE_FMASK			GENMASK(15, 0)
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index f81d911e4b102..a09b61eee245b 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -18,9 +18,41 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 
 IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+static const u32 ipa_reg_clkon_cfg_fmask[] = {
+	[CLKON_RX]					= BIT(0),
+	[CLKON_PROC]					= BIT(1),
+	[TX_WRAPPER]					= BIT(2),
+	[CLKON_MISC]					= BIT(3),
+	[RAM_ARB]					= BIT(4),
+	[FTCH_HPS]					= BIT(5),
+	[FTCH_DPS]					= BIT(6),
+	[CLKON_HPS]					= BIT(7),
+	[CLKON_DPS]					= BIT(8),
+	[RX_HPS_CMDQS]					= BIT(9),
+	[HPS_DPS_CMDQS]					= BIT(10),
+	[DPS_TX_CMDQS]					= BIT(11),
+	[RSRC_MNGR]					= BIT(12),
+	[CTX_HANDLER]					= BIT(13),
+	[ACK_MNGR]					= BIT(14),
+	[D_DCPH]					= BIT(15),
+	[H_DCPH]					= BIT(16),
+						/* Bits 17-31 reserved */
+};
 
-IPA_REG(ROUTE, route, 0x00000048);
+IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+
+static const u32 ipa_reg_route_fmask[] = {
+	[ROUTE_DIS]					= BIT(0),
+	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
+	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
+	[ROUTE_DEF_HDR_OFST]				= GENMASK(16, 7),
+	[ROUTE_FRAG_DEF_PIPE]				= GENMASK(21, 17),
+						/* Bits 22-23 reserved */
+	[ROUTE_DEF_RETAIN_HDR]				= BIT(24),
+						/* Bits 25-31 reserved */
+};
+
+IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
 IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index c975f5a7ba8b9..4333c11a7e3d5 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -18,9 +18,46 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 
 IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+static const u32 ipa_reg_clkon_cfg_fmask[] = {
+	[CLKON_RX]					= BIT(0),
+	[CLKON_PROC]					= BIT(1),
+	[TX_WRAPPER]					= BIT(2),
+	[CLKON_MISC]					= BIT(3),
+	[RAM_ARB]					= BIT(4),
+	[FTCH_HPS]					= BIT(5),
+	[FTCH_DPS]					= BIT(6),
+	[CLKON_HPS]					= BIT(7),
+	[CLKON_DPS]					= BIT(8),
+	[RX_HPS_CMDQS]					= BIT(9),
+	[HPS_DPS_CMDQS]					= BIT(10),
+	[DPS_TX_CMDQS]					= BIT(11),
+	[RSRC_MNGR]					= BIT(12),
+	[CTX_HANDLER]					= BIT(13),
+	[ACK_MNGR]					= BIT(14),
+	[D_DCPH]					= BIT(15),
+	[H_DCPH]					= BIT(16),
+						/* Bit 17 reserved */
+	[NTF_TX_CMDQS]					= BIT(18),
+	[CLKON_TX_0]					= BIT(19),
+	[CLKON_TX_1]					= BIT(20),
+	[CLKON_FNR]					= BIT(21),
+						/* Bits 22-31 reserved */
+};
 
-IPA_REG(ROUTE, route, 0x00000048);
+IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+
+static const u32 ipa_reg_route_fmask[] = {
+	[ROUTE_DIS]					= BIT(0),
+	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
+	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
+	[ROUTE_DEF_HDR_OFST]				= GENMASK(16, 7),
+	[ROUTE_FRAG_DEF_PIPE]				= GENMASK(21, 17),
+						/* Bits 22-23 reserved */
+	[ROUTE_DEF_RETAIN_HDR]				= BIT(24),
+						/* Bits 25-31 reserved */
+};
+
+IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
 IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index 708f52d836372..598cbdd67444e 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -38,9 +38,55 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 
 IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+static const u32 ipa_reg_clkon_cfg_fmask[] = {
+	[CLKON_RX]					= BIT(0),
+	[CLKON_PROC]					= BIT(1),
+	[TX_WRAPPER]					= BIT(2),
+	[CLKON_MISC]					= BIT(3),
+	[RAM_ARB]					= BIT(4),
+	[FTCH_HPS]					= BIT(5),
+	[FTCH_DPS]					= BIT(6),
+	[CLKON_HPS]					= BIT(7),
+	[CLKON_DPS]					= BIT(8),
+	[RX_HPS_CMDQS]					= BIT(9),
+	[HPS_DPS_CMDQS]					= BIT(10),
+	[DPS_TX_CMDQS]					= BIT(11),
+	[RSRC_MNGR]					= BIT(12),
+	[CTX_HANDLER]					= BIT(13),
+	[ACK_MNGR]					= BIT(14),
+	[D_DCPH]					= BIT(15),
+	[H_DCPH]					= BIT(16),
+						/* Bit 17 reserved */
+	[NTF_TX_CMDQS]					= BIT(18),
+	[CLKON_TX_0]					= BIT(19),
+	[CLKON_TX_1]					= BIT(20),
+	[CLKON_FNR]					= BIT(21),
+	[QSB2AXI_CMDQ_L]				= BIT(22),
+	[AGGR_WRAPPER]					= BIT(23),
+	[RAM_SLAVEWAY]					= BIT(24),
+	[CLKON_QMB]					= BIT(25),
+	[WEIGHT_ARB]					= BIT(26),
+	[GSI_IF]					= BIT(27),
+	[CLKON_GLOBAL]					= BIT(28),
+	[GLOBAL_2X_CLK]					= BIT(29),
+	[DPL_FIFO]					= BIT(30),
+	[DRBIP]						= BIT(31),
+};
 
-IPA_REG(ROUTE, route, 0x00000048);
+IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+
+static const u32 ipa_reg_route_fmask[] = {
+	[ROUTE_DIS]					= BIT(0),
+	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
+	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
+	[ROUTE_DEF_HDR_OFST]				= GENMASK(16, 7),
+	[ROUTE_FRAG_DEF_PIPE]				= GENMASK(21, 17),
+						/* Bits 22-23 reserved */
+	[ROUTE_DEF_RETAIN_HDR]				= BIT(24),
+						/* Bits 25-31 reserved */
+};
+
+IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
 IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index 07d7dc94b18b8..dfcbd4b5a87a9 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -31,9 +31,54 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 
 IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+static const u32 ipa_reg_clkon_cfg_fmask[] = {
+	[CLKON_RX]					= BIT(0),
+	[CLKON_PROC]					= BIT(1),
+	[TX_WRAPPER]					= BIT(2),
+	[CLKON_MISC]					= BIT(3),
+	[RAM_ARB]					= BIT(4),
+	[FTCH_HPS]					= BIT(5),
+	[FTCH_DPS]					= BIT(6),
+	[CLKON_HPS]					= BIT(7),
+	[CLKON_DPS]					= BIT(8),
+	[RX_HPS_CMDQS]					= BIT(9),
+	[HPS_DPS_CMDQS]					= BIT(10),
+	[DPS_TX_CMDQS]					= BIT(11),
+	[RSRC_MNGR]					= BIT(12),
+	[CTX_HANDLER]					= BIT(13),
+	[ACK_MNGR]					= BIT(14),
+	[D_DCPH]					= BIT(15),
+	[H_DCPH]					= BIT(16),
+						/* Bit 17 reserved */
+	[NTF_TX_CMDQS]					= BIT(18),
+	[CLKON_TX_0]					= BIT(19),
+	[CLKON_TX_1]					= BIT(20),
+	[CLKON_FNR]					= BIT(21),
+	[QSB2AXI_CMDQ_L]				= BIT(22),
+	[AGGR_WRAPPER]					= BIT(23),
+	[RAM_SLAVEWAY]					= BIT(24),
+	[CLKON_QMB]					= BIT(25),
+	[WEIGHT_ARB]					= BIT(26),
+	[GSI_IF]					= BIT(27),
+	[CLKON_GLOBAL]					= BIT(28),
+	[GLOBAL_2X_CLK]					= BIT(29),
+						/* Bits 30-31 reserved */
+};
 
-IPA_REG(ROUTE, route, 0x00000048);
+IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+
+static const u32 ipa_reg_route_fmask[] = {
+	[ROUTE_DIS]					= BIT(0),
+	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
+	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
+	[ROUTE_DEF_HDR_OFST]				= GENMASK(16, 7),
+	[ROUTE_FRAG_DEF_PIPE]				= GENMASK(21, 17),
+						/* Bits 22-23 reserved */
+	[ROUTE_DEF_RETAIN_HDR]				= BIT(24),
+						/* Bits 25-31 reserved */
+};
+
+IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
 IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index 166b4f1fc2e18..2cc20fc2fcba7 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -32,9 +32,55 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 
 IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+static const u32 ipa_reg_clkon_cfg_fmask[] = {
+	[CLKON_RX]					= BIT(0),
+	[CLKON_PROC]					= BIT(1),
+	[TX_WRAPPER]					= BIT(2),
+	[CLKON_MISC]					= BIT(3),
+	[RAM_ARB]					= BIT(4),
+	[FTCH_HPS]					= BIT(5),
+	[FTCH_DPS]					= BIT(6),
+	[CLKON_HPS]					= BIT(7),
+	[CLKON_DPS]					= BIT(8),
+	[RX_HPS_CMDQS]					= BIT(9),
+	[HPS_DPS_CMDQS]					= BIT(10),
+	[DPS_TX_CMDQS]					= BIT(11),
+	[RSRC_MNGR]					= BIT(12),
+	[CTX_HANDLER]					= BIT(13),
+	[ACK_MNGR]					= BIT(14),
+	[D_DCPH]					= BIT(15),
+	[H_DCPH]					= BIT(16),
+	[CLKON_DCMP]					= BIT(17),
+	[NTF_TX_CMDQS]					= BIT(18),
+	[CLKON_TX_0]					= BIT(19),
+	[CLKON_TX_1]					= BIT(20),
+	[CLKON_FNR]					= BIT(21),
+	[QSB2AXI_CMDQ_L]				= BIT(22),
+	[AGGR_WRAPPER]					= BIT(23),
+	[RAM_SLAVEWAY]					= BIT(24),
+	[CLKON_QMB]					= BIT(25),
+	[WEIGHT_ARB]					= BIT(26),
+	[GSI_IF]					= BIT(27),
+	[CLKON_GLOBAL]					= BIT(28),
+	[GLOBAL_2X_CLK]					= BIT(29),
+	[DPL_FIFO]					= BIT(30),
+						/* Bit 31 reserved */
+};
 
-IPA_REG(ROUTE, route, 0x00000048);
+IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+
+static const u32 ipa_reg_route_fmask[] = {
+	[ROUTE_DIS]					= BIT(0),
+	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
+	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
+	[ROUTE_DEF_HDR_OFST]				= GENMASK(16, 7),
+	[ROUTE_FRAG_DEF_PIPE]				= GENMASK(21, 17),
+						/* Bits 22-23 reserved */
+	[ROUTE_DEF_RETAIN_HDR]				= BIT(24),
+						/* Bits 25-31 reserved */
+};
+
+IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
 IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index 7691b37b72d58..4e5f7acab1a32 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -37,9 +37,55 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 
 IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+static const u32 ipa_reg_clkon_cfg_fmask[] = {
+	[CLKON_RX]					= BIT(0),
+	[CLKON_PROC]					= BIT(1),
+	[TX_WRAPPER]					= BIT(2),
+	[CLKON_MISC]					= BIT(3),
+	[RAM_ARB]					= BIT(4),
+	[FTCH_HPS]					= BIT(5),
+	[FTCH_DPS]					= BIT(6),
+	[CLKON_HPS]					= BIT(7),
+	[CLKON_DPS]					= BIT(8),
+	[RX_HPS_CMDQS]					= BIT(9),
+	[HPS_DPS_CMDQS]					= BIT(10),
+	[DPS_TX_CMDQS]					= BIT(11),
+	[RSRC_MNGR]					= BIT(12),
+	[CTX_HANDLER]					= BIT(13),
+	[ACK_MNGR]					= BIT(14),
+	[D_DCPH]					= BIT(15),
+	[H_DCPH]					= BIT(16),
+	[CLKON_DCMP]					= BIT(17),
+	[NTF_TX_CMDQS]					= BIT(18),
+	[CLKON_TX_0]					= BIT(19),
+	[CLKON_TX_1]					= BIT(20),
+	[CLKON_FNR]					= BIT(21),
+	[QSB2AXI_CMDQ_L]				= BIT(22),
+	[AGGR_WRAPPER]					= BIT(23),
+	[RAM_SLAVEWAY]					= BIT(24),
+	[CLKON_QMB]					= BIT(25),
+	[WEIGHT_ARB]					= BIT(26),
+	[GSI_IF]					= BIT(27),
+	[CLKON_GLOBAL]					= BIT(28),
+	[GLOBAL_2X_CLK]					= BIT(29),
+	[DPL_FIFO]					= BIT(30),
+	[DRBIP]						= BIT(31),
+};
 
-IPA_REG(ROUTE, route, 0x00000048);
+IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+
+static const u32 ipa_reg_route_fmask[] = {
+	[ROUTE_DIS]					= BIT(0),
+	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
+	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
+	[ROUTE_DEF_HDR_OFST]				= GENMASK(16, 7),
+	[ROUTE_FRAG_DEF_PIPE]				= GENMASK(21, 17),
+						/* Bits 22-23 reserved */
+	[ROUTE_DEF_RETAIN_HDR]				= BIT(24),
+						/* Bits 25-31 reserved */
+};
+
+IPA_REG_FIELDS(ROUTE, route, 0x00000048);
 
 IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-- 
2.34.1

