Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD1F5EB442
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiIZWLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiIZWKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:10:11 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E41B13E3B
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:57 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id r5so2831131ilm.10
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=QHIX1k78+wjcmpcIoXIShS8xRt38JwWHsXJObGdk37E=;
        b=CL7DGu0/j1EUIC4rqx4kZ3RTLz/u40J1XGgtVvX32bYSUz+g0hr5guXZRu8sHANTRq
         KcocGW7eUX5NLLOHw9JI0G1jHe5vedJp0mJPkZr2gptqNRcM+QkNZiRKrfMfN9JEjvpU
         qTYfCGrSnlAzcbQqkw2Hz3wrlPdtSug8zhPnLfXIzMhlluuWLLkYoc5XSjzzGeM1dlF/
         xpNf5SAbZlLrqWs9tmm4TWKzVX2sIWUDuZj6JQO9TlJoaTZXgkS0IDoJt1AgIrzdellR
         wgcCVUHtMHcXZIQRvGayYNcbw9onv0uxDyAMabcH19eP7hJuqR6KBXT+dQGd8eeO1Rot
         vgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=QHIX1k78+wjcmpcIoXIShS8xRt38JwWHsXJObGdk37E=;
        b=Nj46NGAJozPRAz6c5gKdj8AlECpWsHdQ5nwsYrsiUsFoUa1VlRc9fO74SJpf8gPT4O
         S4fGPvo29qfJ4TURerjTlmtoD4Y6/qm6D5KnFgqqBqKLs5khsRRRQ0F/hyMNdlRzOex2
         6bhTcm4mniS5ucJsWXMr8xde4fqwfgh7BY/On13lDuIR9rT2pYFYRPyRWHvzmLoW86WC
         nWl4mR/UuWv+NfTUTF9p8AUCrHjbx3YwJJyy0fvakYyneixLliL3iAhK4mrIHIIHYuHk
         MwXJUhuLv47KBR3fkojz/SurxOJtpyuLCjNVXzXuZqRBZHuJHKsKF6zv5VhJsZ5c5PRj
         BSag==
X-Gm-Message-State: ACrzQf0YexZzNC21jaWcgbg6WkzuMjUEdDjTak33iYeyVPIdQ9UzKvu4
        lEb/KokzWviFUL28aPGI+ItLsA==
X-Google-Smtp-Source: AMsMyM7cmDhm8bNzkRpTBM+ecWIDXqxbOD2rnIlK9tR812se6IXoUqthRpgAv/jzcSX+e/UKAtPNkg==
X-Received: by 2002:a05:6e02:1522:b0:2f5:d59c:8639 with SMTP id i2-20020a056e02152200b002f5d59c8639mr11091249ilu.311.1664230196100;
        Mon, 26 Sep 2022 15:09:56 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:09:55 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/15] net: ipa: define COMP_CFG IPA register fields
Date:   Mon, 26 Sep 2022 17:09:23 -0500
Message-Id: <20220926220931.3261749-8-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926220931.3261749-1-elder@linaro.org>
References: <20220926220931.3261749-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create the ipa_reg_comp_cfg_field_id enumerated type, which
identifies the fields for the COMP_CFG IPA register.

Use IPA_REG_FIELDS() to specify the field mask values defined for
this register, for each supported version of IPA.

Use ipa_reg_bit() to build up the value to be written to this
register rather than using the *_FMASK preprocessor symbols.

Remove the definition of the *_FMASK symbols, along with the inline
functions that were used to encode certain fields whose position
and/or width within the register was dependent on IPA version.

Take this opportunity to represent all one-bit fields using BIT(x)
rather than GENMASK(x, x).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c           | 14 ++---
 drivers/net/ipa/ipa_reg.h            | 84 +++++++++-------------------
 drivers/net/ipa/reg/ipa_reg-v3.1.c   | 11 +++-
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c | 11 +++-
 drivers/net/ipa/reg/ipa_reg-v4.11.c  | 31 +++++++++-
 drivers/net/ipa/reg/ipa_reg-v4.2.c   | 24 +++++++-
 drivers/net/ipa/reg/ipa_reg-v4.5.c   | 25 ++++++++-
 drivers/net/ipa/reg/ipa_reg-v4.9.c   | 30 +++++++++-
 8 files changed, 160 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 37c8666528548..9e8f18ca20e2d 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -257,17 +257,17 @@ static void ipa_hardware_config_comp(struct ipa *ipa)
 	val = ioread32(ipa->reg_virt + offset);
 
 	if (ipa->version == IPA_VERSION_4_0) {
-		val &= ~IPA_QMB_SELECT_CONS_EN_FMASK;
-		val &= ~IPA_QMB_SELECT_PROD_EN_FMASK;
-		val &= ~IPA_QMB_SELECT_GLOBAL_EN_FMASK;
+		val &= ~ipa_reg_bit(reg, IPA_QMB_SELECT_CONS_EN);
+		val &= ~ipa_reg_bit(reg, IPA_QMB_SELECT_PROD_EN);
+		val &= ~ipa_reg_bit(reg, IPA_QMB_SELECT_GLOBAL_EN);
 	} else if (ipa->version < IPA_VERSION_4_5) {
-		val |= GSI_MULTI_AXI_MASTERS_DIS_FMASK;
+		val |= ipa_reg_bit(reg, GSI_MULTI_AXI_MASTERS_DIS);
 	} else {
-		/* For IPA v4.5 IPA_FULL_FLUSH_WAIT_RSC_CLOSE_EN is 0 */
+		/* For IPA v4.5 FULL_FLUSH_WAIT_RS_CLOSURE_EN is 0 */
 	}
 
-	val |= GSI_MULTI_INORDER_RD_DIS_FMASK;
-	val |= GSI_MULTI_INORDER_WR_DIS_FMASK;
+	val |= ipa_reg_bit(reg, GSI_MULTI_INORDER_RD_DIS);
+	val |= ipa_reg_bit(reg, GSI_MULTI_INORDER_WR_DIS);
 
 	iowrite32(val, ipa->reg_virt + offset);
 }
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index a616b0c3d59a6..f07a2b3dafa53 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -172,63 +172,33 @@ struct ipa_regs {
 };
 
 /* COMP_CFG register */
-/* The next field is not supported for IPA v4.0+, not present for IPA v4.5+ */
-#define ENABLE_FMASK				GENMASK(0, 0)
-/* The next field is present for IPA v4.7+ */
-#define RAM_ARB_PRI_CLIENT_SAMP_FIX_DIS_FMASK	GENMASK(0, 0)
-#define GSI_SNOC_BYPASS_DIS_FMASK		GENMASK(1, 1)
-#define GEN_QMB_0_SNOC_BYPASS_DIS_FMASK		GENMASK(2, 2)
-#define GEN_QMB_1_SNOC_BYPASS_DIS_FMASK		GENMASK(3, 3)
-/* The next field is not present for IPA v4.5+ */
-#define IPA_DCMP_FAST_CLK_EN_FMASK		GENMASK(4, 4)
-/* The next twelve fields are present for IPA v4.0+ */
-#define IPA_QMB_SELECT_CONS_EN_FMASK		GENMASK(5, 5)
-#define IPA_QMB_SELECT_PROD_EN_FMASK		GENMASK(6, 6)
-#define GSI_MULTI_INORDER_RD_DIS_FMASK		GENMASK(7, 7)
-#define GSI_MULTI_INORDER_WR_DIS_FMASK		GENMASK(8, 8)
-#define GEN_QMB_0_MULTI_INORDER_RD_DIS_FMASK	GENMASK(9, 9)
-#define GEN_QMB_1_MULTI_INORDER_RD_DIS_FMASK	GENMASK(10, 10)
-#define GEN_QMB_0_MULTI_INORDER_WR_DIS_FMASK	GENMASK(11, 11)
-#define GEN_QMB_1_MULTI_INORDER_WR_DIS_FMASK	GENMASK(12, 12)
-#define GEN_QMB_0_SNOC_CNOC_LOOP_PROT_DIS_FMASK	GENMASK(13, 13)
-#define GSI_SNOC_CNOC_LOOP_PROT_DISABLE_FMASK	GENMASK(14, 14)
-#define GSI_MULTI_AXI_MASTERS_DIS_FMASK		GENMASK(15, 15)
-#define IPA_QMB_SELECT_GLOBAL_EN_FMASK		GENMASK(16, 16)
-/* The next five fields are present for IPA v4.9+ */
-#define QMB_RAM_RD_CACHE_DISABLE_FMASK		GENMASK(19, 19)
-#define GENQMB_AOOOWR_FMASK			GENMASK(20, 20)
-#define IF_OUT_OF_BUF_STOP_RESET_MASK_EN_FMASK	GENMASK(21, 21)
-#define GEN_QMB_1_DYNAMIC_ASIZE_FMASK		GENMASK(30, 30)
-#define GEN_QMB_0_DYNAMIC_ASIZE_FMASK		GENMASK(31, 31)
-
-/* Encoded value for COMP_CFG register ATOMIC_FETCHER_ARB_LOCK_DIS field */
-static inline u32 arbitration_lock_disable_encoded(enum ipa_version version,
-						   u32 mask)
-{
-	WARN_ON(version < IPA_VERSION_4_0);
-
-	if (version < IPA_VERSION_4_9)
-		return u32_encode_bits(mask, GENMASK(20, 17));
-
-	if (version == IPA_VERSION_4_9)
-		return u32_encode_bits(mask, GENMASK(24, 22));
-
-	return u32_encode_bits(mask, GENMASK(23, 22));
-}
-
-/* Encoded value for COMP_CFG register FULL_FLUSH_WAIT_RS_CLOSURE_EN field */
-static inline u32 full_flush_rsc_closure_en_encoded(enum ipa_version version,
-						    bool enable)
-{
-	u32 val = enable ? 1 : 0;
-
-	WARN_ON(version < IPA_VERSION_4_5);
-
-	if (version == IPA_VERSION_4_5 || version == IPA_VERSION_4_7)
-		return u32_encode_bits(val, GENMASK(21, 21));
-
-	return u32_encode_bits(val, GENMASK(17, 17));
-}
+enum ipa_reg_comp_cfg_field_id {
+	COMP_CFG_ENABLE,				/* Not IPA v4.0+ */
+	RAM_ARB_PRI_CLIENT_SAMP_FIX_DIS,		/* IPA v4.7+ */
+	GSI_SNOC_BYPASS_DIS,
+	GEN_QMB_0_SNOC_BYPASS_DIS,
+	GEN_QMB_1_SNOC_BYPASS_DIS,
+	IPA_DCMP_FAST_CLK_EN,				/* Not IPA v4.5+ */
+	IPA_QMB_SELECT_CONS_EN,				/* IPA v4.0+ */
+	IPA_QMB_SELECT_PROD_EN,				/* IPA v4.0+ */
+	GSI_MULTI_INORDER_RD_DIS,			/* IPA v4.0+ */
+	GSI_MULTI_INORDER_WR_DIS,			/* IPA v4.0+ */
+	GEN_QMB_0_MULTI_INORDER_RD_DIS,			/* IPA v4.0+ */
+	GEN_QMB_1_MULTI_INORDER_RD_DIS,			/* IPA v4.0+ */
+	GEN_QMB_0_MULTI_INORDER_WR_DIS,			/* IPA v4.0+ */
+	GEN_QMB_1_MULTI_INORDER_WR_DIS,			/* IPA v4.0+ */
+	GEN_QMB_0_SNOC_CNOC_LOOP_PROT_DIS,		/* IPA v4.0+ */
+	GSI_SNOC_CNOC_LOOP_PROT_DISABLE,		/* IPA v4.0+ */
+	GSI_MULTI_AXI_MASTERS_DIS,			/* IPA v4.0+ */
+	IPA_QMB_SELECT_GLOBAL_EN,			/* IPA v4.0+ */
+	QMB_RAM_RD_CACHE_DISABLE,			/* IPA v4.9+ */
+	GENQMB_AOOOWR,					/* IPA v4.9+ */
+	IF_OUT_OF_BUF_STOP_RESET_MASK_EN,		/* IPA v4.9+ */
+	GEN_QMB_1_DYNAMIC_ASIZE,			/* IPA v4.9+ */
+	GEN_QMB_0_DYNAMIC_ASIZE,			/* IPA v4.9+ */
+	ATOMIC_FETCHER_ARB_LOCK_DIS,			/* IPA v4.0+ */
+	FULL_FLUSH_WAIT_RS_CLOSURE_EN,			/* IPA v4.5+ */
+};
 
 /* CLKON_CFG register */
 #define RX_FMASK				GENMASK(0, 0)
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index 026bef9630d7c..f81d911e4b102 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -7,7 +7,16 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+static const u32 ipa_reg_comp_cfg_fmask[] = {
+	[COMP_CFG_ENABLE]				= BIT(0),
+	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
+	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
+	[GEN_QMB_1_SNOC_BYPASS_DIS]			= BIT(3),
+	[IPA_DCMP_FAST_CLK_EN]				= BIT(4),
+						/* Bits 5-31 reserved */
+};
+
+IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
 IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index 9cea2a71d4b45..c975f5a7ba8b9 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -7,7 +7,16 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+static const u32 ipa_reg_comp_cfg_fmask[] = {
+	[COMP_CFG_ENABLE]				= BIT(0),
+	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
+	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
+	[GEN_QMB_1_SNOC_BYPASS_DIS]			= BIT(3),
+	[IPA_DCMP_FAST_CLK_EN]				= BIT(4),
+						/* Bits 5-31 reserved */
+};
+
+IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
 IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index 99b41e665ff52..708f52d836372 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -7,7 +7,36 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+static const u32 ipa_reg_comp_cfg_fmask[] = {
+	[RAM_ARB_PRI_CLIENT_SAMP_FIX_DIS]		= BIT(0),
+	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
+	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
+	[GEN_QMB_1_SNOC_BYPASS_DIS]			= BIT(3),
+						/* Bit 4 reserved */
+	[IPA_QMB_SELECT_CONS_EN]			= BIT(5),
+	[IPA_QMB_SELECT_PROD_EN]			= BIT(6),
+	[GSI_MULTI_INORDER_RD_DIS]			= BIT(7),
+	[GSI_MULTI_INORDER_WR_DIS]			= BIT(8),
+	[GEN_QMB_0_MULTI_INORDER_RD_DIS]		= BIT(9),
+	[GEN_QMB_1_MULTI_INORDER_RD_DIS]		= BIT(10),
+	[GEN_QMB_0_MULTI_INORDER_WR_DIS]		= BIT(11),
+	[GEN_QMB_1_MULTI_INORDER_WR_DIS]		= BIT(12),
+	[GEN_QMB_0_SNOC_CNOC_LOOP_PROT_DIS]		= BIT(13),
+	[GSI_SNOC_CNOC_LOOP_PROT_DISABLE]		= BIT(14),
+	[GSI_MULTI_AXI_MASTERS_DIS]			= BIT(15),
+	[IPA_QMB_SELECT_GLOBAL_EN]			= BIT(16),
+	[FULL_FLUSH_WAIT_RS_CLOSURE_EN]			= BIT(17),
+						/* Bit 18 reserved */
+	[QMB_RAM_RD_CACHE_DISABLE]			= BIT(19),
+	[GENQMB_AOOOWR]					= BIT(20),
+	[IF_OUT_OF_BUF_STOP_RESET_MASK_EN]		= BIT(21),
+	[ATOMIC_FETCHER_ARB_LOCK_DIS]			= GENMASK(23, 22),
+						/* Bits 24-29 reserved */
+	[GEN_QMB_1_DYNAMIC_ASIZE]			= BIT(30),
+	[GEN_QMB_0_DYNAMIC_ASIZE]			= BIT(31),
+};
+
+IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
 IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index e485e4b6eeabd..07d7dc94b18b8 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -7,7 +7,29 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+static const u32 ipa_reg_comp_cfg_fmask[] = {
+						/* Bit 0 reserved */
+	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
+	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
+	[GEN_QMB_1_SNOC_BYPASS_DIS]			= BIT(3),
+	[IPA_DCMP_FAST_CLK_EN]				= BIT(4),
+	[IPA_QMB_SELECT_CONS_EN]			= BIT(5),
+	[IPA_QMB_SELECT_PROD_EN]			= BIT(6),
+	[GSI_MULTI_INORDER_RD_DIS]			= BIT(7),
+	[GSI_MULTI_INORDER_WR_DIS]			= BIT(8),
+	[GEN_QMB_0_MULTI_INORDER_RD_DIS]		= BIT(9),
+	[GEN_QMB_1_MULTI_INORDER_RD_DIS]		= BIT(10),
+	[GEN_QMB_0_MULTI_INORDER_WR_DIS]		= BIT(11),
+	[GEN_QMB_1_MULTI_INORDER_WR_DIS]		= BIT(12),
+	[GEN_QMB_0_SNOC_CNOC_LOOP_PROT_DIS]		= BIT(13),
+	[GSI_SNOC_CNOC_LOOP_PROT_DISABLE]		= BIT(14),
+	[GSI_MULTI_AXI_MASTERS_DIS]			= BIT(15),
+	[IPA_QMB_SELECT_GLOBAL_EN]			= BIT(16),
+	[ATOMIC_FETCHER_ARB_LOCK_DIS]			= GENMASK(20, 17),
+						/* Bits 21-31 reserved */
+};
+
+IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
 IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index 433cf75757868..166b4f1fc2e18 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -7,7 +7,30 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+static const u32 ipa_reg_comp_cfg_fmask[] = {
+						/* Bit 0 reserved */
+	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
+	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
+	[GEN_QMB_1_SNOC_BYPASS_DIS]			= BIT(3),
+						/* Bit 4 reserved */
+	[IPA_QMB_SELECT_CONS_EN]			= BIT(5),
+	[IPA_QMB_SELECT_PROD_EN]			= BIT(6),
+	[GSI_MULTI_INORDER_RD_DIS]			= BIT(7),
+	[GSI_MULTI_INORDER_WR_DIS]			= BIT(8),
+	[GEN_QMB_0_MULTI_INORDER_RD_DIS]		= BIT(9),
+	[GEN_QMB_1_MULTI_INORDER_RD_DIS]		= BIT(10),
+	[GEN_QMB_0_MULTI_INORDER_WR_DIS]		= BIT(11),
+	[GEN_QMB_1_MULTI_INORDER_WR_DIS]		= BIT(12),
+	[GEN_QMB_0_SNOC_CNOC_LOOP_PROT_DIS]		= BIT(13),
+	[GSI_SNOC_CNOC_LOOP_PROT_DISABLE]		= BIT(14),
+	[GSI_MULTI_AXI_MASTERS_DIS]			= BIT(15),
+	[IPA_QMB_SELECT_GLOBAL_EN]			= BIT(16),
+	[ATOMIC_FETCHER_ARB_LOCK_DIS]			= GENMASK(20, 17),
+	[FULL_FLUSH_WAIT_RS_CLOSURE_EN]			= BIT(21),
+						/* Bits 22-31 reserved */
+};
+
+IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
 IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
 
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index 56379a3d25755..7691b37b72d58 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -7,7 +7,35 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+static const u32 ipa_reg_comp_cfg_fmask[] = {
+	[RAM_ARB_PRI_CLIENT_SAMP_FIX_DIS]		= BIT(0),
+	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
+	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
+	[GEN_QMB_1_SNOC_BYPASS_DIS]			= BIT(3),
+						/* Bit 4 reserved */
+	[IPA_QMB_SELECT_CONS_EN]			= BIT(5),
+	[IPA_QMB_SELECT_PROD_EN]			= BIT(6),
+	[GSI_MULTI_INORDER_RD_DIS]			= BIT(7),
+	[GSI_MULTI_INORDER_WR_DIS]			= BIT(8),
+	[GEN_QMB_0_MULTI_INORDER_RD_DIS]		= BIT(9),
+	[GEN_QMB_1_MULTI_INORDER_RD_DIS]		= BIT(10),
+	[GEN_QMB_0_MULTI_INORDER_WR_DIS]		= BIT(11),
+	[GEN_QMB_1_MULTI_INORDER_WR_DIS]		= BIT(12),
+	[GEN_QMB_0_SNOC_CNOC_LOOP_PROT_DIS]		= BIT(13),
+	[GSI_SNOC_CNOC_LOOP_PROT_DISABLE]		= BIT(14),
+	[GSI_MULTI_AXI_MASTERS_DIS]			= BIT(15),
+	[IPA_QMB_SELECT_GLOBAL_EN]			= BIT(16),
+	[FULL_FLUSH_WAIT_RS_CLOSURE_EN]			= BIT(17),
+	[QMB_RAM_RD_CACHE_DISABLE]			= BIT(19),
+	[GENQMB_AOOOWR]					= BIT(20),
+	[IF_OUT_OF_BUF_STOP_RESET_MASK_EN]		= BIT(21),
+	[ATOMIC_FETCHER_ARB_LOCK_DIS]			= GENMASK(24, 22),
+						/* Bits 25-29 reserved */
+	[GEN_QMB_1_DYNAMIC_ASIZE]			= BIT(30),
+	[GEN_QMB_0_DYNAMIC_ASIZE]			= BIT(31),
+};
+
+IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
 IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
 
-- 
2.34.1

