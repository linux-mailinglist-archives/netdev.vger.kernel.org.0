Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E814E5EB439
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiIZWKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiIZWJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:09:54 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1BFBF5D
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:50 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id a4so4251084ilj.8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=2sTobitwbIR/u39iA1fPRH28u3hQuttdGtXtWRyhs1A=;
        b=vSrUOQ0bP9l9KBYX+o9naNe1gJbui3U3fDO7bR+8LayZAdvDNUACaqt4nRIBqxAlGx
         9RLH53yFlLYp322+wTmlOy14UjXifxtOkUU771Kfq+4BAIL+l1cEKn8Pjjb6lHLfFRL+
         f5P+jFe1Sl8xKA/67RReTsv7bjyZsKeO1Om3GQvoVEfCEYS9+vrMIoBXkoRuraGEQ6PB
         MVv5kLD3sQA400n7IKtPG6tDXsykUFCdX3x5XwQ2hObtYvV0Hln+8V9mv+wcvieCpSBX
         ltftbtbWts7DVdgnjT3fzlPrr0PVQ9iuxfM56d3bFyXrdOwIy1gxQe9DkSs9safiwr9Q
         qqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=2sTobitwbIR/u39iA1fPRH28u3hQuttdGtXtWRyhs1A=;
        b=MYxRyCSm1qmxNZkaO98tml1NsSNKGVNc1zvfO8uSU7x+3aidVx8gyAkAZjsl3jWdeE
         vUW1Wt0molharS41MD+I3hmYHCM7xJ7C6hhWy0upMhq5d5a51Gq1iSke3QBtBQQ0MaGy
         B5Lx+stX6SkixuCTv+pm9TICYV0Ph4gwC7uSqTYALMHC1a6VIat6/giKUR8z7O1MXuiM
         SRoy2qkVDL0ifdMzX93Ff1PaCNvtOEHjdj+Th2CLnoGX8+Awx/SEI7zsGjvwkg5CNBtL
         murvXlBgAGmPUyY2gzvdqhRBvry55CKLwR9FOkT6wwZH6P2oJ4IZubofQ1XEC/M7JvZ7
         zY7A==
X-Gm-Message-State: ACrzQf2pKpJZ/J7UnOBlgRfq4nsWsBhSXXY4joDIfpf8TxmRVikySrO0
        yahJNzFqQ2OUty8HM8AWpZkjGw==
X-Google-Smtp-Source: AMsMyM6PFJ53b3/Y+06Iwf+DoMv5StTQ05qco+/Yplg8DI8IyM2TYc8dyTDw9uH9Lj1wIoiH1WAXQQ==
X-Received: by 2002:a05:6e02:156c:b0:2f5:b1bc:3a50 with SMTP id k12-20020a056e02156c00b002f5b1bc3a50mr11638731ilu.71.1664230190011;
        Mon, 26 Sep 2022 15:09:50 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:09:48 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/15] net: ipa: use ipa_reg[] array for register offsets
Date:   Mon, 26 Sep 2022 17:09:20 -0500
Message-Id: <20220926220931.3261749-5-elder@linaro.org>
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

Use the array of register descriptors assigned at initialization
time to determine the offset (and where used, stride) for IPA
registers.  Issue a warning if an offset is requested for a register
that's not valid for the current system.

Remove all IPE_REG_*_OFFSET macros, as well as inline static
functions that returned register offsets.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.c | 111 +---------------
 drivers/net/ipa/ipa_reg.h | 260 +++++---------------------------------
 2 files changed, 37 insertions(+), 334 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index 03bdccf6072da..67c01c6973ff8 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -70,117 +70,14 @@ static bool ipa_reg_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 /* Assumes the endpoint transfer direction is valid; 0 is a bad offset */
 u32 __ipa_reg_offset(struct ipa *ipa, enum ipa_reg_id reg_id, u32 n)
 {
-	enum ipa_version version;
+	const struct ipa_reg *reg;
 
-	if (!ipa_reg_valid(ipa, reg_id))
+	if (WARN_ON(!ipa_reg_valid(ipa, reg_id)))
 		return 0;
 
-	version = ipa->version;
+	reg = ipa->regs->reg[reg_id];
 
-	switch (reg_id) {
-	case COMP_CFG:
-		return IPA_REG_COMP_CFG_OFFSET;
-	case CLKON_CFG:
-		return IPA_REG_CLKON_CFG_OFFSET;
-	case ROUTE:
-		return IPA_REG_ROUTE_OFFSET;
-	case SHARED_MEM_SIZE:
-		return IPA_REG_SHARED_MEM_SIZE_OFFSET;
-	case QSB_MAX_WRITES:
-		return IPA_REG_QSB_MAX_WRITES_OFFSET;
-	case QSB_MAX_READS:
-		return IPA_REG_QSB_MAX_READS_OFFSET;
-	case FILT_ROUT_HASH_EN:
-		return ipa_reg_filt_rout_hash_en_offset(version);
-	case FILT_ROUT_HASH_FLUSH:
-		return ipa_reg_filt_rout_hash_flush_offset(version);
-	case STATE_AGGR_ACTIVE:
-		return ipa_reg_state_aggr_active_offset(version);
-	case IPA_BCR:
-		return IPA_REG_BCR_OFFSET;
-	case LOCAL_PKT_PROC_CNTXT:
-		return IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET;
-	case AGGR_FORCE_CLOSE:
-		return IPA_REG_AGGR_FORCE_CLOSE_OFFSET;
-	case COUNTER_CFG:
-		return IPA_REG_COUNTER_CFG_OFFSET;
-	case IPA_TX_CFG:
-		return IPA_REG_TX_CFG_OFFSET;
-	case FLAVOR_0:
-		return IPA_REG_FLAVOR_0_OFFSET;
-	case IDLE_INDICATION_CFG:
-		return ipa_reg_idle_indication_cfg_offset(version);
-	case QTIME_TIMESTAMP_CFG:
-		return IPA_REG_QTIME_TIMESTAMP_CFG_OFFSET;
-	case TIMERS_XO_CLK_DIV_CFG:
-		return IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET;
-	case TIMERS_PULSE_GRAN_CFG:
-		return IPA_REG_TIMERS_PULSE_GRAN_CFG_OFFSET;
-	case SRC_RSRC_GRP_01_RSRC_TYPE:
-		return IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(n);
-	case SRC_RSRC_GRP_23_RSRC_TYPE:
-		return IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(n);
-	case SRC_RSRC_GRP_45_RSRC_TYPE:
-		return IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(n);
-	case SRC_RSRC_GRP_67_RSRC_TYPE:
-		return IPA_REG_SRC_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(n);
-	case DST_RSRC_GRP_01_RSRC_TYPE:
-		return IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(n);
-	case DST_RSRC_GRP_23_RSRC_TYPE:
-		return IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(n);
-	case DST_RSRC_GRP_45_RSRC_TYPE:
-		return IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(n);
-	case DST_RSRC_GRP_67_RSRC_TYPE:
-		return IPA_REG_DST_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(n);
-	case ENDP_INIT_CTRL:
-		return IPA_REG_ENDP_INIT_CTRL_N_OFFSET(n);
-	case ENDP_INIT_CFG:
-		return IPA_REG_ENDP_INIT_CFG_N_OFFSET(n);
-	case ENDP_INIT_NAT:
-		return IPA_REG_ENDP_INIT_NAT_N_OFFSET(n);
-	case ENDP_INIT_HDR:
-		return IPA_REG_ENDP_INIT_HDR_N_OFFSET(n);
-	case ENDP_INIT_HDR_EXT:
-		return IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(n);
-	case ENDP_INIT_HDR_METADATA_MASK:
-		return IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(n);
-	case ENDP_INIT_MODE:
-		return IPA_REG_ENDP_INIT_MODE_N_OFFSET(n);
-	case ENDP_INIT_AGGR:
-		return IPA_REG_ENDP_INIT_AGGR_N_OFFSET(n);
-	case ENDP_INIT_HOL_BLOCK_EN:
-		return IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(n);
-	case ENDP_INIT_HOL_BLOCK_TIMER:
-		return IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(n);
-	case ENDP_INIT_DEAGGR:
-		return IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(n);
-	case ENDP_INIT_RSRC_GRP:
-		return IPA_REG_ENDP_INIT_RSRC_GRP_N_OFFSET(n);
-	case ENDP_INIT_SEQ:
-		return IPA_REG_ENDP_INIT_SEQ_N_OFFSET(n);
-	case ENDP_STATUS:
-		return IPA_REG_ENDP_STATUS_N_OFFSET(n);
-	case ENDP_FILTER_ROUTER_HSH_CFG:
-		return IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(n);
-	/* The IRQ registers below are only used for GSI_EE_AP */
-	case IPA_IRQ_STTS:
-		return ipa_reg_irq_stts_offset(version);
-	case IPA_IRQ_EN:
-		return ipa_reg_irq_en_offset(version);
-	case IPA_IRQ_CLR:
-		return ipa_reg_irq_clr_offset(version);
-	case IPA_IRQ_UC:
-		return ipa_reg_irq_uc_offset(version);
-	case IRQ_SUSPEND_INFO:
-		return ipa_reg_irq_suspend_info_offset(version);
-	case IRQ_SUSPEND_EN:
-		return ipa_reg_irq_suspend_en_offset(version);
-	case IRQ_SUSPEND_CLR:
-		return ipa_reg_irq_suspend_clr_offset(version);
-	default:
-		WARN(true, "bad register id %u???\n", reg_id);
-		return 0;
-	}
+	return reg->offset + n * reg->stride;
 }
 
 static const struct ipa_regs *ipa_regs(enum ipa_version version)
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 4508f317a7043..94c0e9f15e97b 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -155,7 +155,7 @@ struct ipa_regs {
 	const struct ipa_reg **reg;
 };
 
-#define IPA_REG_COMP_CFG_OFFSET				0x0000003c
+/* COMP_CFG register */
 /* The next field is not supported for IPA v4.0+, not present for IPA v4.5+ */
 #define ENABLE_FMASK				GENMASK(0, 0)
 /* The next field is present for IPA v4.7+ */
@@ -214,7 +214,7 @@ static inline u32 full_flush_rsc_closure_en_encoded(enum ipa_version version,
 	return u32_encode_bits(val, GENMASK(17, 17));
 }
 
-#define IPA_REG_CLKON_CFG_OFFSET			0x00000044
+/* CLKON_CFG register */
 #define RX_FMASK				GENMASK(0, 0)
 #define PROC_FMASK				GENMASK(1, 1)
 #define TX_WRAPPER_FMASK			GENMASK(2, 2)
@@ -254,7 +254,7 @@ static inline u32 full_flush_rsc_closure_en_encoded(enum ipa_version version,
 /* The next field is present for IPA v4.7+ */
 #define DRBIP_FMASK				GENMASK(31, 31)
 
-#define IPA_REG_ROUTE_OFFSET				0x00000048
+/* ROUTE register */
 #define ROUTE_DIS_FMASK				GENMASK(0, 0)
 #define ROUTE_DEF_PIPE_FMASK			GENMASK(5, 1)
 #define ROUTE_DEF_HDR_TABLE_FMASK		GENMASK(6, 6)
@@ -262,54 +262,28 @@ static inline u32 full_flush_rsc_closure_en_encoded(enum ipa_version version,
 #define ROUTE_FRAG_DEF_PIPE_FMASK		GENMASK(21, 17)
 #define ROUTE_DEF_RETAIN_HDR_FMASK		GENMASK(24, 24)
 
-#define IPA_REG_SHARED_MEM_SIZE_OFFSET			0x00000054
+/* SHARED_MEM_SIZE register */
 #define SHARED_MEM_SIZE_FMASK			GENMASK(15, 0)
 #define SHARED_MEM_BADDR_FMASK			GENMASK(31, 16)
 
-#define IPA_REG_QSB_MAX_WRITES_OFFSET			0x00000074
+/* QSB_MAX_WRITES register */
 #define GEN_QMB_0_MAX_WRITES_FMASK		GENMASK(3, 0)
 #define GEN_QMB_1_MAX_WRITES_FMASK		GENMASK(7, 4)
 
-#define IPA_REG_QSB_MAX_READS_OFFSET			0x00000078
+/* QSB_MAX_READS register */
 #define GEN_QMB_0_MAX_READS_FMASK		GENMASK(3, 0)
 #define GEN_QMB_1_MAX_READS_FMASK		GENMASK(7, 4)
 /* The next two fields are present for IPA v4.0+ */
 #define GEN_QMB_0_MAX_READS_BEATS_FMASK		GENMASK(23, 16)
 #define GEN_QMB_1_MAX_READS_BEATS_FMASK		GENMASK(31, 24)
 
-static inline u32 ipa_reg_filt_rout_hash_en_offset(enum ipa_version version)
-{
-	if (version < IPA_VERSION_4_0)
-		return 0x000008c;
-
-	return 0x0000148;
-}
-
-static inline u32 ipa_reg_filt_rout_hash_flush_offset(enum ipa_version version)
-{
-	if (version < IPA_VERSION_4_0)
-		return 0x0000090;
-
-	return 0x000014c;
-}
-
-/* The next four fields are used for the hash enable and flush registers */
+/* FILT_ROUT_HASH_EN and FILT_ROUT_HASH_FLUSH registers */
 #define IPV6_ROUTER_HASH_FMASK			GENMASK(0, 0)
 #define IPV6_FILTER_HASH_FMASK			GENMASK(4, 4)
 #define IPV4_ROUTER_HASH_FMASK			GENMASK(8, 8)
 #define IPV4_FILTER_HASH_FMASK			GENMASK(12, 12)
 
-/* ipa->available defines the valid bits in the STATE_AGGR_ACTIVE register */
-static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
-{
-	if (version < IPA_VERSION_4_0)
-		return 0x0000010c;
-
-	return 0x000000b4;
-}
-
-/* The next register is not present for IPA v4.5+ */
-#define IPA_REG_BCR_OFFSET				0x000001d0
+/* BCR register */
 enum ipa_bcr_compat {
 	BCR_CMDQ_L_LACK_ONE_ENTRY		= 0x0,	/* Not IPA v4.2+ */
 	BCR_TX_NOT_USING_BRESP			= 0x1,	/* Not IPA v4.2+ */
@@ -323,9 +297,7 @@ enum ipa_bcr_compat {
 	BCR_ROUTER_PREFETCH_EN			= 0x9,	/* IPA v3.5+ */
 };
 
-/* The value of the next register must be a multiple of 8 (bottom 3 bits 0) */
-#define IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET		0x000001e8
-
+/* LOCAL_PKT_PROC_CNTXT register */
 /* Encoded value for LOCAL_PKT_PROC_CNTXT register BASE_ADDR field */
 static inline u32 proc_cntxt_base_addr_encoded(enum ipa_version version,
 					       u32 addr)
@@ -336,17 +308,12 @@ static inline u32 proc_cntxt_base_addr_encoded(enum ipa_version version,
 	return u32_encode_bits(addr, GENMASK(17, 0));
 }
 
-/* ipa->available defines the valid bits in the AGGR_FORCE_CLOSE register */
-#define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
-
-/* The next register is not present for IPA v4.5+ */
-#define IPA_REG_COUNTER_CFG_OFFSET			0x000001f0
+/* COUNTER_CFG register */
 /* The next field is not present for IPA v3.5+ */
 #define EOT_COAL_GRANULARITY_FMASK		GENMASK(3, 0)
 #define AGGR_GRANULARITY_FMASK			GENMASK(8, 4)
 
-/* The next register is present for IPA v3.5+ */
-#define IPA_REG_TX_CFG_OFFSET				0x000001fc
+/* IPA_TX_CFG register */
 /* The next three fields are not present for IPA v4.0+ */
 #define TX0_PREFETCH_DISABLE_FMASK		GENMASK(0, 0)
 #define TX1_PREFETCH_DISABLE_FMASK		GENMASK(1, 1)
@@ -365,39 +332,27 @@ static inline u32 proc_cntxt_base_addr_encoded(enum ipa_version version,
 /* The next field is present for IPA v4.2 only */
 #define SSPND_PA_NO_BQ_STATE_FMASK		GENMASK(19, 19)
 
-/* The next register is present for IPA v3.5+ */
-#define IPA_REG_FLAVOR_0_OFFSET				0x00000210
+/* FLAVOR_0 register */
 #define IPA_MAX_PIPES_FMASK			GENMASK(3, 0)
 #define IPA_MAX_CONS_PIPES_FMASK		GENMASK(12, 8)
 #define IPA_MAX_PROD_PIPES_FMASK		GENMASK(20, 16)
 #define IPA_PROD_LOWEST_FMASK			GENMASK(27, 24)
 
-/* The next register is present for IPA v3.5+ */
-static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
-{
-	if (version >= IPA_VERSION_4_2)
-		return 0x00000240;
-
-	return 0x00000220;
-}
-
+/* IDLE_INDICATION_CFG register */
 #define ENTER_IDLE_DEBOUNCE_THRESH_FMASK	GENMASK(15, 0)
 #define CONST_NON_IDLE_ENABLE_FMASK		GENMASK(16, 16)
 
-/* The next register is present for IPA v4.5+ */
-#define IPA_REG_QTIME_TIMESTAMP_CFG_OFFSET		0x0000024c
+/* QTIME_TIMESTAMP_CFG register */
 #define DPL_TIMESTAMP_LSB_FMASK			GENMASK(4, 0)
 #define DPL_TIMESTAMP_SEL_FMASK			GENMASK(7, 7)
 #define TAG_TIMESTAMP_LSB_FMASK			GENMASK(12, 8)
 #define NAT_TIMESTAMP_LSB_FMASK			GENMASK(20, 16)
 
-/* The next register is present for IPA v4.5+ */
-#define IPA_REG_TIMERS_XO_CLK_DIV_CFG_OFFSET		0x00000250
+/* TIMERS_XO_CLK_DIV_CFG register */
 #define DIV_VALUE_FMASK				GENMASK(8, 0)
 #define DIV_ENABLE_FMASK			GENMASK(31, 31)
 
-/* The next register is present for IPA v4.5+ */
-#define IPA_REG_TIMERS_PULSE_GRAN_CFG_OFFSET		0x00000254
+/* TIMERS_PULSE_GRAN_CFG register */
 #define GRAN_0_FMASK				GENMASK(2, 0)
 #define GRAN_1_FMASK				GENMASK(5, 3)
 #define GRAN_2_FMASK				GENMASK(8, 6)
@@ -413,39 +368,19 @@ enum ipa_pulse_gran {
 	IPA_GRAN_655350_US			= 0x7,
 };
 
-/* Not all of the following are present (depends on IPA version) */
-#define IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(rt) \
-					(0x00000400 + 0x0020 * (rt))
-#define IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(rt) \
-					(0x00000404 + 0x0020 * (rt))
-#define IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
-					(0x00000408 + 0x0020 * (rt))
-#define IPA_REG_SRC_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(rt) \
-					(0x0000040c + 0x0020 * (rt))
-#define IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(rt) \
-					(0x00000500 + 0x0020 * (rt))
-#define IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(rt) \
-					(0x00000504 + 0x0020 * (rt))
-#define IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
-					(0x00000508 + 0x0020 * (rt))
-#define IPA_REG_DST_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(rt) \
-					(0x0000050c + 0x0020 * (rt))
-/* The next four fields are used for all resource group registers */
+/* {SRC,DST}_RSRC_GRP_{01,23,45,67}_RSRC_TYPE registers */
 #define X_MIN_LIM_FMASK				GENMASK(5, 0)
 #define X_MAX_LIM_FMASK				GENMASK(13, 8)
-/* The next two fields are not always present (if resource count is odd) */
 #define Y_MIN_LIM_FMASK				GENMASK(21, 16)
 #define Y_MAX_LIM_FMASK				GENMASK(29, 24)
 
-#define IPA_REG_ENDP_INIT_CTRL_N_OFFSET(ep) \
-					(0x00000800 + 0x0070 * (ep))
+/* ENDP_INIT_CTRL register */
 /* Valid only for RX (IPA producer) endpoints (do not use for IPA v4.0+) */
 #define ENDP_SUSPEND_FMASK			GENMASK(0, 0)
 /* Valid only for TX (IPA consumer) endpoints */
 #define ENDP_DELAY_FMASK			GENMASK(1, 1)
 
-#define IPA_REG_ENDP_INIT_CFG_N_OFFSET(ep) \
-					(0x00000808 + 0x0070 * (ep))
+/* ENDP_INIT_CFG register */
 #define FRAG_OFFLOAD_EN_FMASK			GENMASK(0, 0)
 #define CS_OFFLOAD_EN_FMASK			GENMASK(2, 1)
 #define CS_METADATA_HDR_OFFSET_FMASK		GENMASK(6, 3)
@@ -459,9 +394,7 @@ enum ipa_cs_offload_en {
 	IPA_CS_OFFLOAD_INLINE	/* TX and RX */	= 0x1,	/* IPA v4.5+ */
 };
 
-/* Valid only for TX (IPA consumer) endpoints */
-#define IPA_REG_ENDP_INIT_NAT_N_OFFSET(ep) \
-					(0x0000080c + 0x0070 * (ep))
+/* ENDP_INIT_NAT register */
 #define NAT_EN_FMASK				GENMASK(1, 0)
 
 /** enum ipa_nat_en - ENDP_INIT_NAT register NAT_EN field value */
@@ -471,8 +404,7 @@ enum ipa_nat_en {
 	IPA_NAT_DST				= 0x2,
 };
 
-#define IPA_REG_ENDP_INIT_HDR_N_OFFSET(ep) \
-					(0x00000810 + 0x0070 * (ep))
+/* ENDP_INIT_HDR register */
 #define HDR_LEN_FMASK				GENMASK(5, 0)
 #define HDR_OFST_METADATA_VALID_FMASK		GENMASK(6, 6)
 #define HDR_OFST_METADATA_FMASK			GENMASK(12, 7)
@@ -528,8 +460,7 @@ static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
 	return val;
 }
 
-#define IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(ep) \
-					(0x00000814 + 0x0070 * (ep))
+/* ENDP_INIT_HDR_EXT register */
 #define HDR_ENDIANNESS_FMASK			GENMASK(0, 0)
 #define HDR_TOTAL_LEN_OR_PAD_VALID_FMASK	GENMASK(1, 1)
 #define HDR_TOTAL_LEN_OR_PAD_FMASK		GENMASK(2, 2)
@@ -541,13 +472,7 @@ static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
 #define HDR_OFST_PKT_SIZE_MSB_FMASK		GENMASK(19, 18)
 #define HDR_ADDITIONAL_CONST_LEN_MSB_FMASK	GENMASK(21, 20)
 
-/* Valid only for RX (IPA producer) endpoints */
-#define IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(rxep) \
-					(0x00000818 + 0x0070 * (rxep))
-
-/* Valid only for TX (IPA consumer) endpoints */
-#define IPA_REG_ENDP_INIT_MODE_N_OFFSET(txep) \
-					(0x00000820 + 0x0070 * (txep))
+/* ENDP_INIT_MODE register */
 #define MODE_FMASK				GENMASK(2, 0)
 /* The next field is present for IPA v4.5+ */
 #define DCPH_ENABLE_FMASK			GENMASK(3, 3)
@@ -568,8 +493,7 @@ enum ipa_mode {
 	IPA_DMA					= 0x3,
 };
 
-#define IPA_REG_ENDP_INIT_AGGR_N_OFFSET(ep) \
-					(0x00000824 +  0x0070 * (ep))
+/* ENDP_INIT_AGGR register */
 #define AGGR_EN_FMASK				GENMASK(1, 0)
 #define AGGR_TYPE_FMASK				GENMASK(4, 2)
 
@@ -630,14 +554,10 @@ enum ipa_aggr_type {
 	IPA_QCMAP				= 0x6,
 };
 
-/* Valid only for RX (IPA producer) endpoints */
-#define IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(rxep) \
-					(0x0000082c +  0x0070 * (rxep))
+/* ENDP_INIT_HOL_BLOCK_EN register */
 #define HOL_BLOCK_EN_FMASK			GENMASK(0, 0)
 
-/* Valid only for RX (IPA producer) endpoints */
-#define IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(rxep) \
-					(0x00000830 +  0x0070 * (rxep))
+/* ENDP_INIT_HOL_BLOCK_TIMER register */
 /* The next two fields are present for IPA v4.2 only */
 #define BASE_VALUE_FMASK			GENMASK(4, 0)
 #define SCALE_FMASK				GENMASK(12, 8)
@@ -645,9 +565,7 @@ enum ipa_aggr_type {
 #define TIME_LIMIT_FMASK			GENMASK(4, 0)
 #define GRAN_SEL_FMASK				GENMASK(8, 8)
 
-/* Valid only for TX (IPA consumer) endpoints */
-#define IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(txep) \
-					(0x00000834 + 0x0070 * (txep))
+/* ENDP_INIT_DEAGGR register */
 #define DEAGGR_HDR_LEN_FMASK			GENMASK(5, 0)
 #define SYSPIPE_ERR_DETECTION_FMASK		GENMASK(6, 6)
 #define PACKET_OFFSET_VALID_FMASK		GENMASK(7, 7)
@@ -655,8 +573,7 @@ enum ipa_aggr_type {
 #define IGNORE_MIN_PKT_ERR_FMASK		GENMASK(14, 14)
 #define MAX_PACKET_LEN_FMASK			GENMASK(31, 16)
 
-#define IPA_REG_ENDP_INIT_RSRC_GRP_N_OFFSET(ep) \
-					(0x00000838 + 0x0070 * (ep))
+/* ENDP_INIT_RSRC_GRP register */
 /* Encoded value for ENDP_INIT_RSRC_GRP register RSRC_GRP field */
 static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 {
@@ -669,9 +586,7 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 	return u32_encode_bits(rsrc_grp, GENMASK(1, 0));
 }
 
-/* Valid only for TX (IPA consumer) endpoints */
-#define IPA_REG_ENDP_INIT_SEQ_N_OFFSET(txep) \
-					(0x0000083c + 0x0070 * (txep))
+/* ENDP_INIT_SEQ register */
 #define SEQ_TYPE_FMASK				GENMASK(7, 0)
 /* The next field must be zero for IPA v4.5+ */
 #define SEQ_REP_TYPE_FMASK			GENMASK(15, 8)
@@ -718,8 +633,7 @@ enum ipa_seq_rep_type {
 	IPA_SEQ_REP_DMA_PARSER			= 0x08,
 };
 
-#define IPA_REG_ENDP_STATUS_N_OFFSET(ep) \
-					(0x00000840 + 0x0070 * (ep))
+/* ENDP_STATUS register */
 #define STATUS_EN_FMASK				GENMASK(0, 0)
 #define STATUS_ENDP_FMASK			GENMASK(5, 1)
 /* The next field is not present for IPA v4.5+ */
@@ -727,9 +641,7 @@ enum ipa_seq_rep_type {
 /* The next field is present for IPA v4.0+ */
 #define STATUS_PKT_SUPPRESS_FMASK		GENMASK(9, 9)
 
-/* The next register is not present for IPA v4.2 (which no hashing support) */
-#define IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(er) \
-					(0x0000085c + 0x0070 * (er))
+/* ENDP_FILTER_ROUTER_HSH_CFG register */
 #define FILTER_HASH_MSK_SRC_ID_FMASK		GENMASK(0, 0)
 #define FILTER_HASH_MSK_SRC_IP_FMASK		GENMASK(1, 1)
 #define FILTER_HASH_MSK_DST_IP_FMASK		GENMASK(2, 2)
@@ -748,46 +660,7 @@ enum ipa_seq_rep_type {
 #define ROUTER_HASH_MSK_METADATA_FMASK		GENMASK(22, 22)
 #define IPA_REG_ENDP_ROUTER_HASH_MSK_ALL	GENMASK(22, 16)
 
-static inline u32 ipa_reg_irq_stts_ee_n_offset(enum ipa_version version,
-					       u32 ee)
-{
-	if (version < IPA_VERSION_4_9)
-		return 0x00003008 + 0x1000 * ee;
-
-	return 0x00004008 + 0x1000 * ee;
-}
-
-static inline u32 ipa_reg_irq_stts_offset(enum ipa_version version)
-{
-	return ipa_reg_irq_stts_ee_n_offset(version, GSI_EE_AP);
-}
-
-static inline u32 ipa_reg_irq_en_ee_n_offset(enum ipa_version version, u32 ee)
-{
-	if (version < IPA_VERSION_4_9)
-		return 0x0000300c + 0x1000 * ee;
-
-	return 0x0000400c + 0x1000 * ee;
-}
-
-static inline u32 ipa_reg_irq_en_offset(enum ipa_version version)
-{
-	return ipa_reg_irq_en_ee_n_offset(version, GSI_EE_AP);
-}
-
-static inline u32 ipa_reg_irq_clr_ee_n_offset(enum ipa_version version, u32 ee)
-{
-	if (version < IPA_VERSION_4_9)
-		return 0x00003010 + 0x1000 * ee;
-
-	return 0x00004010 + 0x1000 * ee;
-}
-
-static inline u32 ipa_reg_irq_clr_offset(enum ipa_version version)
-{
-	return ipa_reg_irq_clr_ee_n_offset(version, GSI_EE_AP);
-}
-
+/* IPA_IRQ_STTS, IPA_IRQ_EN, and IPA_IRQ_CLR registers */
 /**
  * enum ipa_irq_id - Bit positions representing type of IPA IRQ
  * @IPA_IRQ_UC_0:	Microcontroller event interrupt
@@ -863,76 +736,9 @@ enum ipa_irq_id {
 	IPA_IRQ_COUNT,				/* Last; not an id */
 };
 
-static inline u32 ipa_reg_irq_uc_ee_n_offset(enum ipa_version version, u32 ee)
-{
-	if (version < IPA_VERSION_4_9)
-		return 0x0000301c + 0x1000 * ee;
-
-	return 0x0000401c + 0x1000 * ee;
-}
-
-static inline u32 ipa_reg_irq_uc_offset(enum ipa_version version)
-{
-	return ipa_reg_irq_uc_ee_n_offset(version, GSI_EE_AP);
-}
-
+/* IPA_IRQ_UC register */
 #define UC_INTR_FMASK				GENMASK(0, 0)
 
-/* ipa->available defines the valid bits in the SUSPEND_INFO register */
-static inline u32
-ipa_reg_irq_suspend_info_ee_n_offset(enum ipa_version version, u32 ee)
-{
-	if (version == IPA_VERSION_3_0)
-		return 0x00003098 + 0x1000 * ee;
-
-	if (version < IPA_VERSION_4_9)
-		return 0x00003030 + 0x1000 * ee;
-
-	return 0x00004030 + 0x1000 * ee;
-}
-
-static inline u32
-ipa_reg_irq_suspend_info_offset(enum ipa_version version)
-{
-	return ipa_reg_irq_suspend_info_ee_n_offset(version, GSI_EE_AP);
-}
-
-/* ipa->available defines the valid bits in the SUSPEND_EN register */
-static inline u32
-ipa_reg_irq_suspend_en_ee_n_offset(enum ipa_version version, u32 ee)
-{
-	WARN_ON(version == IPA_VERSION_3_0);
-
-	if (version < IPA_VERSION_4_9)
-		return 0x00003034 + 0x1000 * ee;
-
-	return 0x00004034 + 0x1000 * ee;
-}
-
-static inline u32
-ipa_reg_irq_suspend_en_offset(enum ipa_version version)
-{
-	return ipa_reg_irq_suspend_en_ee_n_offset(version, GSI_EE_AP);
-}
-
-/* ipa->available defines the valid bits in the SUSPEND_CLR register */
-static inline u32
-ipa_reg_irq_suspend_clr_ee_n_offset(enum ipa_version version, u32 ee)
-{
-	WARN_ON(version == IPA_VERSION_3_0);
-
-	if (version < IPA_VERSION_4_9)
-		return 0x00003038 + 0x1000 * ee;
-
-	return 0x00004038 + 0x1000 * ee;
-}
-
-static inline u32
-ipa_reg_irq_suspend_clr_offset(enum ipa_version version)
-{
-	return ipa_reg_irq_suspend_clr_ee_n_offset(version, GSI_EE_AP);
-}
-
 extern const struct ipa_regs ipa_regs_v3_1;
 extern const struct ipa_regs ipa_regs_v3_5_1;
 extern const struct ipa_regs ipa_regs_v4_2;
-- 
2.34.1

