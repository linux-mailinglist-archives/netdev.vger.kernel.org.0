Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E395EB435
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiIZWKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbiIZWJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:09:54 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEADC5F78
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:48 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id g6so4254226ild.6
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=TlCLm9IbXDViuH+nB4uvOf6DBLsKKFDxpec8L7vwdXI=;
        b=hNDA1P3vFUvJzpSGmkTzl9bpjIAWgVZ6/4HFJ5c2snf/jOn+GC+okPqO1injKp4Sb1
         +avj1ZsfHadu6CskNFlKxASTddsrPkoeH0G3gSykpJ0IugL4jeR1Z0rge3LzEwZjz9Dn
         F4LYta1pYSOIV4F2qtaDQpgbXRoSJ2H29k0UAykaW2ys5ar5ZbvRZJdHFX1b51hWpCek
         jazD0WteAjRgE9A93IF2DHdzv03ScyhH0kDpqP7LuSfcllPFQ/eE41PvH9jU7bZQtECU
         +ccI211/jWsW+USAgjVEmcDDgeJOB/SEtzhm4khAZdad1qx3ITSwigv7Q3c60ktWjL1/
         JIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=TlCLm9IbXDViuH+nB4uvOf6DBLsKKFDxpec8L7vwdXI=;
        b=nHMuOZKeTfst6RaaqzNXobBsOTXkfhllyhKus3RngN75ECjAg55T8jwCJPxqw2S6nT
         Jq2luOp8rdQtOVnGk/3VDL6hvQUvZdWQnNYkHsmgX4DjfbO9vn3l3t0o1ujXe/scCgW1
         f4gCL5PmrD56tGN9BnjGB0FnnrMcKmWf9gayXqPICQ5HiH+r782S+I900vMGW+mFNZ3S
         aQXumb4sbrwlrQTVKg/vYA/mK3GVhUkb3zSCVjstBILsh1wARjmIgjGHzF36fc9VPBym
         ko4nnJ2De6V5A58k2vtoirg3TtxypvggwIsEFyw+65ZR5dVCGRcpE4jrjgjC8RNFP9rj
         AFcg==
X-Gm-Message-State: ACrzQf1Pcy9Xo7ZsDsA3wSk7jG6vtmNRdM50bKOVS9TGUdrm8Rm8xVqv
        Y6dRxc+4aHu4C5OMs+Q4CWg8WA==
X-Google-Smtp-Source: AMsMyM5rmVT/o3Qh5/+rTI5l1S4SmEVPiDZ6tnJWcE0oRlZ8lyBhf/JcAbNA/MT7fxEb1fdM/zKHXg==
X-Received: by 2002:a05:6e02:c84:b0:2f1:3e7d:8bf2 with SMTP id b4-20020a056e020c8400b002f13e7d8bf2mr11740070ile.272.1664230187657;
        Mon, 26 Sep 2022 15:09:47 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:09:46 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/15] net: ipa: add per-version IPA register definition files
Date:   Mon, 26 Sep 2022 17:09:19 -0500
Message-Id: <20220926220931.3261749-4-elder@linaro.org>
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

Create a new subdirectory "reg", which contains a register
definition file for each supported version of IPA.  Each register
definition contains the register's offset, and for parameterized
registers, the stride (distance between consecutive instances of the
register).  Finally, it includes an all-caps printable register name.

In these files, each IPA version defines an array of IPA register
definition pointers, with unsupported registers defined with a null
pointer.  The array is indexed by the ipa_reg_id enumerated type.

At initialization time, the appropriate register definition array to
use is selected based on the IPA version, and assigned to a new
"regs" field in the IPA structure.

Extend ipa_reg_valid() so it fails if a valid register is not
defined.

This patch simply puts this infrastructure in place; the next will
use it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile             |   2 +
 drivers/net/ipa/ipa.h                |   2 +
 drivers/net/ipa/ipa_reg.c            |  37 +++++-
 drivers/net/ipa/ipa_reg.h            |  44 +++++++
 drivers/net/ipa/reg/ipa_reg-v3.1.c   | 166 ++++++++++++++++++++++++++
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c | 159 +++++++++++++++++++++++++
 drivers/net/ipa/reg/ipa_reg-v4.11.c  | 159 +++++++++++++++++++++++++
 drivers/net/ipa/reg/ipa_reg-v4.2.c   | 152 ++++++++++++++++++++++++
 drivers/net/ipa/reg/ipa_reg-v4.5.c   | 167 +++++++++++++++++++++++++++
 drivers/net/ipa/reg/ipa_reg-v4.9.c   | 159 +++++++++++++++++++++++++
 10 files changed, 1044 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v3.1.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v3.5.1.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.11.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.2.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.5.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.9.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 8b2220eb6b92d..48255fc4b25c3 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -13,4 +13,6 @@ ipa-y			:=	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o \
 				ipa_sysfs.o
 
+ipa-y			+=	$(IPA_VERSIONS:%=reg/ipa_reg-v%.o)
+
 ipa-y			+=	$(IPA_VERSIONS:%=data/ipa_data-v%.o)
diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 4fc3c72359f5e..349643cf2b442 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -44,6 +44,7 @@ struct ipa_interrupt;
  * @uc_loaded:		true after microcontroller has reported it's ready
  * @reg_addr:		DMA address used for IPA register access
  * @reg_virt:		Virtual address used for IPA register access
+ * @regs:		IPA register definitions
  * @mem_addr:		DMA address of IPA-local memory space
  * @mem_virt:		Virtual address of IPA-local memory space
  * @mem_offset:		Offset from @mem_virt used for access to IPA memory
@@ -90,6 +91,7 @@ struct ipa {
 
 	dma_addr_t reg_addr;
 	void __iomem *reg_virt;
+	const struct ipa_regs *regs;
 
 	dma_addr_t mem_addr;
 	void *mem_virt;
diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index f6269dc66b9f4..03bdccf6072da 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -9,14 +9,14 @@
 #include "ipa.h"
 #include "ipa_reg.h"
 
-/* Is this register valid for the current IPA version? */
+/* Is this register valid and defined for the current IPA version? */
 static bool ipa_reg_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 {
 	enum ipa_version version = ipa->version;
 	bool valid;
 
 	/* Check for bogus (out of range) register IDs */
-	if ((u32)reg_id >= IPA_REG_ID_COUNT)
+	if ((u32)reg_id >= ipa->regs->reg_count)
 		return false;
 
 	switch (reg_id) {
@@ -62,7 +62,9 @@ static bool ipa_reg_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 		break;
 	}
 
-	return valid;
+	/* To be valid, it must be defined */
+
+	return valid && ipa->regs->reg[reg_id];
 }
 
 /* Assumes the endpoint transfer direction is valid; 0 is a bad offset */
@@ -181,11 +183,39 @@ u32 __ipa_reg_offset(struct ipa *ipa, enum ipa_reg_id reg_id, u32 n)
 	}
 }
 
+static const struct ipa_regs *ipa_regs(enum ipa_version version)
+{
+	switch (version) {
+	case IPA_VERSION_3_1:
+		return &ipa_regs_v3_1;
+	case IPA_VERSION_3_5_1:
+		return &ipa_regs_v3_5_1;
+	case IPA_VERSION_4_2:
+		return &ipa_regs_v4_2;
+	case IPA_VERSION_4_5:
+		return &ipa_regs_v4_5;
+	case IPA_VERSION_4_9:
+		return &ipa_regs_v4_9;
+	case IPA_VERSION_4_11:
+		return &ipa_regs_v4_11;
+	default:
+		return NULL;
+	}
+}
+
 int ipa_reg_init(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
+	const struct ipa_regs *regs;
 	struct resource *res;
 
+	regs = ipa_regs(ipa->version);
+	if (!regs)
+		return -EINVAL;
+
+	if (WARN_ON(regs->reg_count > IPA_REG_ID_COUNT))
+		return -EINVAL;
+
 	/* Setup IPA register memory  */
 	res = platform_get_resource_byname(ipa->pdev, IORESOURCE_MEM,
 					   "ipa-reg");
@@ -200,6 +230,7 @@ int ipa_reg_init(struct ipa *ipa)
 		return -ENOMEM;
 	}
 	ipa->reg_addr = res->start;
+	ipa->regs = regs;
 
 	return 0;
 }
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index a5433103fdd2f..4508f317a7043 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -7,6 +7,7 @@
 #define _IPA_REG_H_
 
 #include <linux/bitfield.h>
+#include <linux/bug.h>
 
 #include "ipa_version.h"
 
@@ -120,6 +121,40 @@ enum ipa_reg_id {
 	IPA_REG_ID_COUNT,				/* Last; not an ID */
 };
 
+/**
+ * struct ipa_reg - An IPA register descriptor
+ * @offset:	Register offset relative to base of the "ipa-reg" memory
+ * @stride:	Distance between two instances, if parameterized
+ * @name:	Upper-case name of the IPA register
+ */
+struct ipa_reg {
+	u32 offset;
+	u32 stride;
+	const char *name;
+};
+
+/* Helper macro for defining "simple" (non-parameterized) registers */
+#define IPA_REG(__NAME, __reg_id, __offset)				\
+	IPA_REG_STRIDE(__NAME, __reg_id, __offset, 0)
+
+/* Helper macro for defining parameterized registers, specifying stride */
+#define IPA_REG_STRIDE(__NAME, __reg_id, __offset, __stride)		\
+	static const struct ipa_reg ipa_reg_ ## __reg_id = {		\
+		.name	= #__NAME,					\
+		.offset	= __offset,					\
+		.stride	= __stride,					\
+	}
+
+/**
+ * struct ipa_regs - Description of registers supported by hardware
+ * @reg_count:	Number of registers in the @reg[] array
+ * @reg:		Array of register descriptors
+ */
+struct ipa_regs {
+	u32 reg_count;
+	const struct ipa_reg **reg;
+};
+
 #define IPA_REG_COMP_CFG_OFFSET				0x0000003c
 /* The next field is not supported for IPA v4.0+, not present for IPA v4.5+ */
 #define ENABLE_FMASK				GENMASK(0, 0)
@@ -898,8 +933,17 @@ ipa_reg_irq_suspend_clr_offset(enum ipa_version version)
 	return ipa_reg_irq_suspend_clr_ee_n_offset(version, GSI_EE_AP);
 }
 
+extern const struct ipa_regs ipa_regs_v3_1;
+extern const struct ipa_regs ipa_regs_v3_5_1;
+extern const struct ipa_regs ipa_regs_v4_2;
+extern const struct ipa_regs ipa_regs_v4_5;
+extern const struct ipa_regs ipa_regs_v4_9;
+extern const struct ipa_regs ipa_regs_v4_11;
+
 u32 __ipa_reg_offset(struct ipa *ipa, enum ipa_reg_id reg_id, u32 n);
 
+const struct ipa_reg *ipa_reg(struct ipa *ipa, enum ipa_reg_id reg_id);
+
 static inline u32 ipa_reg_offset(struct ipa *ipa, enum ipa_reg_id reg_id)
 {
 	return __ipa_reg_offset(ipa, reg_id, 0);
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
new file mode 100644
index 0000000000000..026bef9630d7c
--- /dev/null
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2022 Linaro Ltd. */
+
+#include <linux/types.h>
+
+#include "../ipa.h"
+#include "../ipa_reg.h"
+
+IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+
+IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+
+IPA_REG(ROUTE, route, 0x00000048);
+
+IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+
+IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+
+IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x000008c);
+
+IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c);
+
+IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
+
+/* Offset must be a multiple of 8 */
+IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+
+IPA_REG(COUNTER_CFG, counter_cfg, 0x000001f0);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+	       0x00000400, 0x0020);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+	       0x00000404, 0x0020);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
+	       0x00000408, 0x0020);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_67_RSRC_TYPE, src_rsrc_grp_67_rsrc_type,
+	       0x0000040c, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+	       0x00000500, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+	       0x00000504, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
+	       0x00000508, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_67_RSRC_TYPE, dst_rsrc_grp_67_rsrc_type,
+	       0x0000050c, 0x0020);
+
+IPA_REG_STRIDE(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	       0x00000818, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+	       0x0000082c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+	       0x00000830, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+IPA_REG_STRIDE(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+	       0x0000085c, 0x0070);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
+
+IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00003034 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00003038 + 0x1000 * GSI_EE_AP);
+
+static const struct ipa_reg *ipa_reg_array[] = {
+	[COMP_CFG]			= &ipa_reg_comp_cfg,
+	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
+	[ROUTE]				= &ipa_reg_route,
+	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
+	[IPA_BCR]			= &ipa_reg_ipa_bcr,
+	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
+	[COUNTER_CFG]			= &ipa_reg_counter_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
+	[SRC_RSRC_GRP_45_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_45_rsrc_type,
+	[SRC_RSRC_GRP_67_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_67_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_45_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_45_rsrc_type,
+	[DST_RSRC_GRP_67_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_67_rsrc_type,
+	[ENDP_INIT_CTRL]		= &ipa_reg_endp_init_ctrl,
+	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
+	[ENDP_STATUS]			= &ipa_reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+};
+
+const struct ipa_regs ipa_regs_v3_1 = {
+	.reg_count	= ARRAY_SIZE(ipa_reg_array),
+	.reg		= ipa_reg_array,
+};
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
new file mode 100644
index 0000000000000..9cea2a71d4b45
--- /dev/null
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -0,0 +1,159 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2022 Linaro Ltd. */
+
+#include <linux/types.h>
+
+#include "../ipa.h"
+#include "../ipa_reg.h"
+
+IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+
+IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+
+IPA_REG(ROUTE, route, 0x00000048);
+
+IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+
+IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+
+IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x000008c);
+
+IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c);
+
+IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
+
+/* Offset must be a multiple of 8 */
+IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+
+IPA_REG(COUNTER_CFG, counter_cfg, 0x000001f0);
+
+IPA_REG(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+
+IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
+
+IPA_REG(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000220);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+	       0x00000400, 0x0020);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+	       0x00000404, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+	       0x00000500, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+	       0x00000504, 0x0020);
+
+IPA_REG_STRIDE(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	       0x00000818, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+	       0x0000082c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+	       0x00000830, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+IPA_REG_STRIDE(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+	       0x0000085c, 0x0070);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
+
+IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00003034 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00003038 + 0x1000 * GSI_EE_AP);
+
+static const struct ipa_reg *ipa_reg_array[] = {
+	[COMP_CFG]			= &ipa_reg_comp_cfg,
+	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
+	[ROUTE]				= &ipa_reg_route,
+	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
+	[IPA_BCR]			= &ipa_reg_ipa_bcr,
+	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
+	[COUNTER_CFG]			= &ipa_reg_counter_cfg,
+	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &ipa_reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
+	[ENDP_INIT_CTRL]		= &ipa_reg_endp_init_ctrl,
+	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
+	[ENDP_STATUS]			= &ipa_reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+};
+
+const struct ipa_regs ipa_regs_v3_5_1 = {
+	.reg_count	= ARRAY_SIZE(ipa_reg_array),
+	.reg		= ipa_reg_array,
+};
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
new file mode 100644
index 0000000000000..99b41e665ff52
--- /dev/null
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -0,0 +1,159 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2022 Linaro Ltd. */
+
+#include <linux/types.h>
+
+#include "../ipa.h"
+#include "../ipa_reg.h"
+
+IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+
+IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+
+IPA_REG(ROUTE, route, 0x00000048);
+
+IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+
+IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+
+IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+
+IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
+
+/* Offset must be a multiple of 8 */
+IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+
+IPA_REG(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+
+IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
+
+IPA_REG(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+
+IPA_REG(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+
+IPA_REG(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+
+IPA_REG(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+	       0x00000400, 0x0020);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+	       0x00000404, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+	       0x00000500, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+	       0x00000504, 0x0020);
+
+IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	       0x00000818, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+	       0x0000082c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+	       0x00000830, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+IPA_REG_STRIDE(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+	       0x0000085c, 0x0070);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00004008 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000400c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00004010 + 0x1000 * GSI_EE_AP);
+
+IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00004030 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00004034 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00004038 + 0x1000 * GSI_EE_AP);
+
+static const struct ipa_reg *ipa_reg_array[] = {
+	[COMP_CFG]			= &ipa_reg_comp_cfg,
+	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
+	[ROUTE]				= &ipa_reg_route,
+	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
+	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
+	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &ipa_reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
+	[QTIME_TIMESTAMP_CFG]		= &ipa_reg_qtime_timestamp_cfg,
+	[TIMERS_XO_CLK_DIV_CFG]		= &ipa_reg_timers_xo_clk_div_cfg,
+	[TIMERS_PULSE_GRAN_CFG]		= &ipa_reg_timers_pulse_gran_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
+	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
+	[ENDP_STATUS]			= &ipa_reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+};
+
+const struct ipa_regs ipa_regs_v4_11 = {
+	.reg_count	= ARRAY_SIZE(ipa_reg_array),
+	.reg		= ipa_reg_array,
+};
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
new file mode 100644
index 0000000000000..e485e4b6eeabd
--- /dev/null
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2022 Linaro Ltd. */
+
+#include <linux/types.h>
+
+#include "../ipa.h"
+#include "../ipa_reg.h"
+
+IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+
+IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+
+IPA_REG(ROUTE, route, 0x00000048);
+
+IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+
+IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+
+IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+
+IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
+
+IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
+
+/* Offset must be a multiple of 8 */
+IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+
+IPA_REG(COUNTER_CFG, counter_cfg, 0x000001f0);
+
+IPA_REG(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+
+IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
+
+IPA_REG(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+	       0x00000400, 0x0020);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+	       0x00000404, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+	       0x00000500, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+	       0x00000504, 0x0020);
+
+IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	       0x00000818, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+	       0x0000082c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+	       0x00000830, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
+
+IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00003034 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00003038 + 0x1000 * GSI_EE_AP);
+
+static const struct ipa_reg *ipa_reg_array[] = {
+	[COMP_CFG]			= &ipa_reg_comp_cfg,
+	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
+	[ROUTE]				= &ipa_reg_route,
+	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
+	[IPA_BCR]			= &ipa_reg_ipa_bcr,
+	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
+	[COUNTER_CFG]			= &ipa_reg_counter_cfg,
+	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &ipa_reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
+	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
+	[ENDP_STATUS]			= &ipa_reg_endp_status,
+	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+};
+
+const struct ipa_regs ipa_regs_v4_2 = {
+	.reg_count	= ARRAY_SIZE(ipa_reg_array),
+	.reg		= ipa_reg_array,
+};
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
new file mode 100644
index 0000000000000..433cf75757868
--- /dev/null
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2022 Linaro Ltd. */
+
+#include <linux/types.h>
+
+#include "../ipa.h"
+#include "../ipa_reg.h"
+
+IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+
+IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+
+IPA_REG(ROUTE, route, 0x00000048);
+
+IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+
+IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+
+IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+
+IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
+
+/* Offset must be a multiple of 8 */
+IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+
+IPA_REG(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+
+IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
+
+IPA_REG(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+
+IPA_REG(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+
+IPA_REG(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+
+IPA_REG(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+	       0x00000400, 0x0020);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+	       0x00000404, 0x0020);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
+	       0x00000408, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+	       0x00000500, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+	       0x00000504, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
+	       0x00000508, 0x0020);
+
+IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	       0x00000818, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+	       0x0000082c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+	       0x00000830, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+IPA_REG_STRIDE(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+	       0x0000085c, 0x0070);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
+
+IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00003034 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00003038 + 0x1000 * GSI_EE_AP);
+
+static const struct ipa_reg *ipa_reg_array[] = {
+	[COMP_CFG]			= &ipa_reg_comp_cfg,
+	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
+	[ROUTE]				= &ipa_reg_route,
+	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
+	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
+	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &ipa_reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
+	[QTIME_TIMESTAMP_CFG]		= &ipa_reg_qtime_timestamp_cfg,
+	[TIMERS_XO_CLK_DIV_CFG]		= &ipa_reg_timers_xo_clk_div_cfg,
+	[TIMERS_PULSE_GRAN_CFG]		= &ipa_reg_timers_pulse_gran_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
+	[SRC_RSRC_GRP_45_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_45_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_45_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_45_rsrc_type,
+	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
+	[ENDP_STATUS]			= &ipa_reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+};
+
+const struct ipa_regs ipa_regs_v4_5 = {
+	.reg_count	= ARRAY_SIZE(ipa_reg_array),
+	.reg		= ipa_reg_array,
+};
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
new file mode 100644
index 0000000000000..56379a3d25755
--- /dev/null
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -0,0 +1,159 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2022 Linaro Ltd. */
+
+#include <linux/types.h>
+
+#include "../ipa.h"
+#include "../ipa_reg.h"
+
+IPA_REG(COMP_CFG, comp_cfg, 0x0000003c);
+
+IPA_REG(CLKON_CFG, clkon_cfg, 0x00000044);
+
+IPA_REG(ROUTE, route, 0x00000048);
+
+IPA_REG(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+
+IPA_REG(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+
+IPA_REG(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+IPA_REG(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+
+IPA_REG(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
+
+/* Offset must be a multiple of 8 */
+IPA_REG(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+
+IPA_REG(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+
+IPA_REG(FLAVOR_0, flavor_0, 0x00000210);
+
+IPA_REG(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+
+IPA_REG(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+
+IPA_REG(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+
+IPA_REG(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+	       0x00000400, 0x0020);
+
+IPA_REG_STRIDE(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+	       0x00000404, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+	       0x00000500, 0x0020);
+
+IPA_REG_STRIDE(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+	       0x00000504, 0x0020);
+
+IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	       0x00000818, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+	       0x0000082c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+	       0x00000830, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+IPA_REG_STRIDE(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+IPA_REG_STRIDE(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+	       0x0000085c, 0x0070);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00004008 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000400c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00004010 + 0x1000 * GSI_EE_AP);
+
+IPA_REG(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00004030 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00004034 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00004038 + 0x1000 * GSI_EE_AP);
+
+static const struct ipa_reg *ipa_reg_array[] = {
+	[COMP_CFG]			= &ipa_reg_comp_cfg,
+	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
+	[ROUTE]				= &ipa_reg_route,
+	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
+	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
+	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &ipa_reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
+	[QTIME_TIMESTAMP_CFG]		= &ipa_reg_qtime_timestamp_cfg,
+	[TIMERS_XO_CLK_DIV_CFG]		= &ipa_reg_timers_xo_clk_div_cfg,
+	[TIMERS_PULSE_GRAN_CFG]		= &ipa_reg_timers_pulse_gran_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
+	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
+	[ENDP_STATUS]			= &ipa_reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+};
+
+const struct ipa_regs ipa_regs_v4_9 = {
+	.reg_count	= ARRAY_SIZE(ipa_reg_array),
+	.reg		= ipa_reg_array,
+};
-- 
2.34.1

