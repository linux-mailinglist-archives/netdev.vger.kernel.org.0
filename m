Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A59868F941
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 21:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbjBHU6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 15:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbjBHU5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 15:57:40 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E504D43464
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 12:57:31 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id v15so19116ilc.10
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 12:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9XEgBgVBSmCDwKNMZcqN+uDYfmLEhy191Z/IC5efDw=;
        b=yBmVJ5Xqcep2et8WozeQi2TqbKIXCe0jzRueEKjPDQjEzy0DeK2dS/ghcvwl8E8rkF
         3EQoAHsODG4m/7Cq7PHQpywMRZvEeMzgrOorgmJCbMxTrTOeuNm8GEatTiqVXEHzCR8A
         Z628nXh7kZwbY/aAIOD4i9vLz4+KYuINmP4VtxvYs9A7+UJvGMrL5Wa0ZNwQfKYe96RL
         mT1TRnp98s69KcpEj9ngARwe4hXlH4UCsOKjHaddYN+SDL0VbjUDDc1vyy+acQumdoFE
         BTRJ8EhaeLP16t7xcu7AW9MPy/blRKBrrwTm+vp3xKP5CxokFk10EMyTnl6sDlgVGLSS
         6q5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z9XEgBgVBSmCDwKNMZcqN+uDYfmLEhy191Z/IC5efDw=;
        b=BPPzqrd3oNme7Uou7fERWaaT1ri+P8/R1Hw8luPNUSCxAVOnx8xnMgsRecxWfkBN2z
         IL/ixRN9hV080JYQmJ2QY1FpuZtfdolwKL8CFVHEqKqzNTtyi6QFne2whU7c9LF9DU8N
         8k6iQk46KEiPK7s7iCldbrFLUd+6mFJZAYB/FyY63T7kncyyhqHK4dhBxYC+dptQ6P+V
         kCaKMm7EqdUcPA/G04VnSwHS5+YUo3xMntnmom8DIyvPw1xgmyMK+G8iSeZBnXX3eklM
         TNzlhvsY8yOkCtDElYGFVs4PAYrPC0JQLeocI6pDLfFcafVwndHZAITte0q3Uismx27D
         DRkw==
X-Gm-Message-State: AO0yUKVfIWEzzMywKNRW7BlXkjFQMoPP4wLKybLNGRPfz0rc49coZFdW
        A293RKUd69ySX0rEsZEYM+Hl3w==
X-Google-Smtp-Source: AK7set+jTy/SVL2CrphX4SfAoCS1V6oT9/tzC7a8q0oXavyWPs7lob67rbLZXBl6eACkFZi4hZymsQ==
X-Received: by 2002:a92:9413:0:b0:304:d0b7:e362 with SMTP id c19-20020a929413000000b00304d0b7e362mr6480940ili.5.1675889851414;
        Wed, 08 Feb 2023 12:57:31 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id r6-20020a922a06000000b0031093e9c7fasm5236704ile.85.2023.02.08.12.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 12:57:31 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/9] net: ipa: generalize register offset functions
Date:   Wed,  8 Feb 2023 14:56:52 -0600
Message-Id: <20230208205653.177700-9-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230208205653.177700-1-elder@linaro.org>
References: <20230208205653.177700-1-elder@linaro.org>
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

Rename ipa_reg_offset() to be reg_offset() and move its definition
to "reg.h".  Rename ipa_reg_n_offset() to be reg_n_offset() also.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c       |  4 ++--
 drivers/net/ipa/ipa_endpoint.c  | 38 ++++++++++++++++-----------------
 drivers/net/ipa/ipa_interrupt.c | 17 +++++++--------
 drivers/net/ipa/ipa_main.c      | 28 +++++++++++++-----------
 drivers/net/ipa/ipa_mem.c       |  4 ++--
 drivers/net/ipa/ipa_reg.h       | 14 +-----------
 drivers/net/ipa/ipa_resource.c  |  2 +-
 drivers/net/ipa/ipa_table.c     | 13 +++++------
 drivers/net/ipa/ipa_uc.c        |  2 +-
 drivers/net/ipa/reg.h           | 12 +++++++++++
 10 files changed, 66 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index d03956854a9ac..f1419fbd776c3 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -300,7 +300,7 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 		else
 			reg = ipa_reg(ipa, FILT_ROUT_CACHE_FLUSH);
 
-		offset = ipa_reg_offset(reg);
+		offset = reg_offset(reg);
 		name = "filter/route hash flush";
 		if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
 			return false;
@@ -314,7 +314,7 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	 * fits in the register write command field(s) that must hold it.
 	 */
 	reg = ipa_reg(ipa, ENDP_STATUS);
-	offset = ipa_reg_n_offset(reg, IPA_ENDPOINT_COUNT - 1);
+	offset = reg_n_offset(reg, IPA_ENDPOINT_COUNT - 1);
 	name = "maximal endpoint status";
 	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
 		return false;
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 11e97dd80825c..b78503304883d 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -460,7 +460,7 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 		WARN_ON(ipa->version >= IPA_VERSION_4_0);
 
 	reg = ipa_reg(ipa, ENDP_INIT_CTRL);
-	offset = ipa_reg_n_offset(reg, endpoint->endpoint_id);
+	offset = reg_n_offset(reg, endpoint->endpoint_id);
 	val = ioread32(ipa->reg_virt + offset);
 
 	field_id = endpoint->toward_ipa ? ENDP_DELAY : ENDP_SUSPEND;
@@ -499,7 +499,7 @@ static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
 	WARN_ON(!test_bit(endpoint_id, ipa->available));
 
 	reg = ipa_reg(ipa, STATE_AGGR_ACTIVE);
-	val = ioread32(ipa->reg_virt + ipa_reg_n_offset(reg, unit));
+	val = ioread32(ipa->reg_virt + reg_n_offset(reg, unit));
 
 	return !!(val & BIT(endpoint_id % 32));
 }
@@ -515,7 +515,7 @@ static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
 	WARN_ON(!test_bit(endpoint_id, ipa->available));
 
 	reg = ipa_reg(ipa, AGGR_FORCE_CLOSE);
-	iowrite32(mask, ipa->reg_virt + ipa_reg_n_offset(reg, unit));
+	iowrite32(mask, ipa->reg_virt + reg_n_offset(reg, unit));
 }
 
 /**
@@ -622,7 +622,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 			continue;
 
 		reg = ipa_reg(ipa, ENDP_STATUS);
-		offset = ipa_reg_n_offset(reg, endpoint_id);
+		offset = reg_n_offset(reg, endpoint_id);
 
 		/* Value written is 0, and all bits are updated.  That
 		 * means status is disabled on the endpoint, and as a
@@ -674,7 +674,7 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 	val |= ipa_reg_encode(reg, CS_OFFLOAD_EN, enabled);
 	/* CS_GEN_QMB_MASTER_SEL is 0 */
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
 
 static void ipa_endpoint_init_nat(struct ipa_endpoint *endpoint)
@@ -690,7 +690,7 @@ static void ipa_endpoint_init_nat(struct ipa_endpoint *endpoint)
 	reg = ipa_reg(ipa, ENDP_INIT_NAT);
 	val = ipa_reg_encode(reg, NAT_EN, IPA_NAT_TYPE_BYPASS);
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
 
 static u32
@@ -820,7 +820,7 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 		/* HDR_METADATA_REG_VALID is 0 (TX only, version < v4.5) */
 	}
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
 
 static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
@@ -872,7 +872,7 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 		}
 	}
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
 
 static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
@@ -887,7 +887,7 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 		return;		/* Register not valid for TX endpoints */
 
 	reg = ipa_reg(ipa,  ENDP_INIT_HDR_METADATA_MASK);
-	offset = ipa_reg_n_offset(reg, endpoint_id);
+	offset = reg_n_offset(reg, endpoint_id);
 
 	/* Note that HDR_ENDIANNESS indicates big endian header fields */
 	if (endpoint->config.qmap)
@@ -918,7 +918,7 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	}
 	/* All other bits unspecified (and 0) */
 
-	offset = ipa_reg_n_offset(reg, endpoint->endpoint_id);
+	offset = reg_n_offset(reg, endpoint->endpoint_id);
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
@@ -1032,7 +1032,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 		/* other fields ignored */
 	}
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
 
 /* The head-of-line blocking timer is defined as a tick count.  For
@@ -1116,7 +1116,7 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 	reg = ipa_reg(ipa, ENDP_INIT_HOL_BLOCK_TIMER);
 	val = hol_block_timer_encode(ipa, reg, microseconds);
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
 
 static void
@@ -1129,7 +1129,7 @@ ipa_endpoint_init_hol_block_en(struct ipa_endpoint *endpoint, bool enable)
 	u32 val;
 
 	reg = ipa_reg(ipa, ENDP_INIT_HOL_BLOCK_EN);
-	offset = ipa_reg_n_offset(reg, endpoint_id);
+	offset = reg_n_offset(reg, endpoint_id);
 	val = enable ? ipa_reg_bit(reg, HOL_BLOCK_EN) : 0;
 
 	iowrite32(val, ipa->reg_virt + offset);
@@ -1183,7 +1183,7 @@ static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
 	/* PACKET_OFFSET_LOCATION is ignored (not valid) */
 	/* MAX_PACKET_LEN is 0 (not enforced) */
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
 
 static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
@@ -1197,7 +1197,7 @@ static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
 	reg = ipa_reg(ipa, ENDP_INIT_RSRC_GRP);
 	val = ipa_reg_encode(reg, ENDP_RSRC_GRP, resource_group);
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
 
 static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
@@ -1220,7 +1220,7 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 		val |= ipa_reg_encode(reg, SEQ_REP_TYPE,
 				      endpoint->config.tx.seq_rep_type);
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
 
 /**
@@ -1292,7 +1292,7 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 		/* STATUS_PKT_SUPPRESS_FMASK is 0 (not present for v4.0+) */
 	}
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, endpoint_id));
 }
 
 static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint,
@@ -1647,7 +1647,7 @@ void ipa_endpoint_default_route_set(struct ipa *ipa, u32 endpoint_id)
 	val |= ipa_reg_encode(reg, ROUTE_FRAG_DEF_PIPE, endpoint_id);
 	val |= ipa_reg_bit(reg, ROUTE_DEF_RETAIN_HDR);
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
 
 void ipa_endpoint_default_route_clear(struct ipa *ipa)
@@ -2019,7 +2019,7 @@ int ipa_endpoint_config(struct ipa *ipa)
 	 * the highest one doesn't exceed the number supported by software.
 	 */
 	reg = ipa_reg(ipa, FLAVOR_0);
-	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
+	val = ioread32(ipa->reg_virt + reg_offset(reg));
 
 	/* Our RX is an IPA producer; our TX is an IPA consumer. */
 	tx_count = ipa_reg_decode(reg, MAX_CONS_PIPES, val);
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index ac5944ae0d204..4bc05948f772d 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -52,7 +52,7 @@ static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 irq_id)
 	u32 offset;
 
 	reg = ipa_reg(ipa, IPA_IRQ_CLR);
-	offset = ipa_reg_offset(reg);
+	offset = reg_offset(reg);
 
 	switch (irq_id) {
 	case IPA_IRQ_UC_0:
@@ -102,7 +102,7 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	 * only the enabled ones.
 	 */
 	reg = ipa_reg(ipa, IPA_IRQ_STTS);
-	offset = ipa_reg_offset(reg);
+	offset = reg_offset(reg);
 	pending = ioread32(ipa->reg_virt + offset);
 	while ((mask = pending & enabled)) {
 		do {
@@ -120,8 +120,7 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 		dev_dbg(dev, "clearing disabled IPA interrupts 0x%08x\n",
 			pending);
 		reg = ipa_reg(ipa, IPA_IRQ_CLR);
-		offset = ipa_reg_offset(reg);
-		iowrite32(pending, ipa->reg_virt + offset);
+		iowrite32(pending, ipa->reg_virt + reg_offset(reg));
 	}
 out_power_put:
 	pm_runtime_mark_last_busy(dev);
@@ -134,7 +133,7 @@ static void ipa_interrupt_enabled_update(struct ipa *ipa)
 {
 	const struct reg *reg = ipa_reg(ipa, IPA_IRQ_EN);
 
-	iowrite32(ipa->interrupt->enabled, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(ipa->interrupt->enabled, ipa->reg_virt + reg_offset(reg));
 }
 
 /* Enable an IPA interrupt type */
@@ -181,7 +180,7 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 		return;
 
 	reg = ipa_reg(ipa, IRQ_SUSPEND_EN);
-	offset = ipa_reg_n_offset(reg, unit);
+	offset = reg_n_offset(reg, unit);
 	val = ioread32(ipa->reg_virt + offset);
 
 	if (enable)
@@ -219,14 +218,14 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
 		u32 val;
 
 		reg = ipa_reg(ipa, IRQ_SUSPEND_INFO);
-		val = ioread32(ipa->reg_virt + ipa_reg_n_offset(reg, unit));
+		val = ioread32(ipa->reg_virt + reg_n_offset(reg, unit));
 
 		/* SUSPEND interrupt status isn't cleared on IPA version 3.0 */
 		if (ipa->version == IPA_VERSION_3_0)
 			continue;
 
 		reg = ipa_reg(ipa, IRQ_SUSPEND_CLR);
-		iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, unit));
+		iowrite32(val, ipa->reg_virt + reg_n_offset(reg, unit));
 	}
 }
 
@@ -261,7 +260,7 @@ struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa)
 
 	/* Start with all IPA interrupts disabled */
 	reg = ipa_reg(ipa, IPA_IRQ_EN);
-	iowrite32(0, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(0, ipa->reg_virt + reg_offset(reg));
 
 	ret = request_threaded_irq(irq, NULL, ipa_isr_thread, IRQF_ONESHOT,
 				   "ipa", interrupt);
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 71cf51c9cc912..c74543db0afb1 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -212,7 +212,7 @@ ipa_hardware_config_bcr(struct ipa *ipa, const struct ipa_data *data)
 
 	reg = ipa_reg(ipa, IPA_BCR);
 	val = data->backward_compat;
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
 
 static void ipa_hardware_config_tx(struct ipa *ipa)
@@ -227,7 +227,7 @@ static void ipa_hardware_config_tx(struct ipa *ipa)
 
 	/* Disable PA mask to allow HOLB drop */
 	reg = ipa_reg(ipa, IPA_TX_CFG);
-	offset = ipa_reg_offset(reg);
+	offset = reg_offset(reg);
 
 	val = ioread32(ipa->reg_virt + offset);
 
@@ -259,7 +259,7 @@ static void ipa_hardware_config_clkon(struct ipa *ipa)
 		val |= ipa_reg_bit(reg, GLOBAL_2X_CLK);
 	}
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
 
 /* Configure bus access behavior for IPA components */
@@ -274,7 +274,8 @@ static void ipa_hardware_config_comp(struct ipa *ipa)
 		return;
 
 	reg = ipa_reg(ipa, COMP_CFG);
-	offset = ipa_reg_offset(reg);
+	offset = reg_offset(reg);
+
 	val = ioread32(ipa->reg_virt + offset);
 
 	if (ipa->version == IPA_VERSION_4_0) {
@@ -315,7 +316,7 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 		val |= ipa_reg_encode(reg, GEN_QMB_1_MAX_WRITES,
 				      data1->max_writes);
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 
 	/* Max outstanding read accesses for QSB masters */
 	reg = ipa_reg(ipa, QSB_MAX_READS);
@@ -332,7 +333,7 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 					      data1->max_reads_beats);
 	}
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
 
 /* The internal inactivity timer clock is used for the aggregation timer */
@@ -374,7 +375,7 @@ static void ipa_qtime_config(struct ipa *ipa)
 
 	/* Timer clock divider must be disabled when we change the rate */
 	reg = ipa_reg(ipa, TIMERS_XO_CLK_DIV_CFG);
-	iowrite32(0, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(0, ipa->reg_virt + reg_offset(reg));
 
 	reg = ipa_reg(ipa, QTIME_TIMESTAMP_CFG);
 	/* Set DPL time stamp resolution to use Qtime (instead of 1 msec) */
@@ -384,7 +385,7 @@ static void ipa_qtime_config(struct ipa *ipa)
 	val = ipa_reg_encode(reg, TAG_TIMESTAMP_LSB, TAG_TIMESTAMP_SHIFT);
 	val = ipa_reg_encode(reg, NAT_TIMESTAMP_LSB, NAT_TIMESTAMP_SHIFT);
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 
 	/* Set granularity of pulse generators used for other timers */
 	reg = ipa_reg(ipa, TIMERS_PULSE_GRAN_CFG);
@@ -397,11 +398,12 @@ static void ipa_qtime_config(struct ipa *ipa)
 		val |= ipa_reg_encode(reg, PULSE_GRAN_2, IPA_GRAN_1_MS);
 	}
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 
 	/* Actual divider is 1 more than value supplied here */
 	reg = ipa_reg(ipa, TIMERS_XO_CLK_DIV_CFG);
-	offset = ipa_reg_offset(reg);
+	offset = reg_offset(reg);
+
 	val = ipa_reg_encode(reg, DIV_VALUE, IPA_XO_CLOCK_DIVIDER - 1);
 
 	iowrite32(val, ipa->reg_virt + offset);
@@ -422,7 +424,7 @@ static void ipa_hardware_config_counter(struct ipa *ipa)
 	reg = ipa_reg(ipa, COUNTER_CFG);
 	/* If defined, EOT_COAL_GRANULARITY is 0 */
 	val = ipa_reg_encode(reg, AGGR_GRANULARITY, granularity);
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
 
 static void ipa_hardware_config_timing(struct ipa *ipa)
@@ -451,7 +453,7 @@ static void ipa_hardware_config_hashing(struct ipa *ipa)
 	/* IPV6_ROUTER_HASH, IPV6_FILTER_HASH, IPV4_ROUTER_HASH,
 	 * IPV4_FILTER_HASH are all zero.
 	 */
-	iowrite32(0, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(0, ipa->reg_virt + reg_offset(reg));
 }
 
 static void ipa_idle_indication_cfg(struct ipa *ipa,
@@ -470,7 +472,7 @@ static void ipa_idle_indication_cfg(struct ipa *ipa,
 	if (const_non_idle_enable)
 		val |= ipa_reg_bit(reg, CONST_NON_IDLE_ENABLE);
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
 
 /**
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index a6efeed253764..20241fac21be5 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -116,7 +116,7 @@ int ipa_mem_setup(struct ipa *ipa)
 
 	reg = ipa_reg(ipa, LOCAL_PKT_PROC_CNTXT);
 	val = ipa_reg_encode(reg, IPA_BASE_ADDR, offset);
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 
 	return 0;
 }
@@ -328,7 +328,7 @@ int ipa_mem_config(struct ipa *ipa)
 
 	/* Check the advertised location and size of the shared memory area */
 	reg = ipa_reg(ipa, SHARED_MEM_SIZE);
-	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
+	val = ioread32(ipa->reg_virt + reg_offset(reg));
 
 	/* The fields in the register are in 8 byte units */
 	ipa->mem_offset = 8 * ipa_reg_decode(reg, MEM_BADDR, val);
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 626a74930ff9b..e0f125d70ff27 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -36,7 +36,7 @@ struct ipa;
  * by register ID.  Each entry in the array specifies the base offset and
  * (for parameterized registers) a non-zero stride value.  Not all versions
  * of IPA define all registers.  The offset for a register is returned by
- * ipa_reg_offset() when the register's ipa_reg structure is supplied;
+ * reg_offset() when the register's ipa_reg structure is supplied;
  * zero is returned for an undefined register (this should never happen).
  *
  * Some registers encode multiple fields within them.  Each field in
@@ -700,18 +700,6 @@ static inline u32 ipa_reg_field_max(const struct reg *reg, u32 field_id)
 
 const struct reg *ipa_reg(struct ipa *ipa, enum ipa_reg_id reg_id);
 
-/* Returns 0 for NULL reg; warning will have already been issued */
-static inline u32 ipa_reg_offset(const struct reg *reg)
-{
-	return reg ? reg->offset : 0;
-}
-
-/* Returns 0 for NULL reg; warning will have already been issued */
-static inline u32 ipa_reg_n_offset(const struct reg *reg, u32 n)
-{
-	return reg ? reg->offset + n * reg->stride : 0;
-}
-
 int ipa_reg_init(struct ipa *ipa);
 void ipa_reg_exit(struct ipa *ipa);
 
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index 3778e7664f07c..b63f130350d59 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -83,7 +83,7 @@ ipa_resource_config_common(struct ipa *ipa, u32 resource_type,
 		val |= ipa_reg_encode(reg, Y_MAX_LIM, ylimits->max);
 	}
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, resource_type));
+	iowrite32(val, ipa->reg_virt + reg_n_offset(reg, resource_type));
 }
 
 static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 859286a66b0d1..54327c9f48275 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -347,7 +347,6 @@ int ipa_table_hash_flush(struct ipa *ipa)
 {
 	struct gsi_trans *trans;
 	const struct reg *reg;
-	u32 offset;
 	u32 val;
 
 	if (!ipa_table_hash_support(ipa))
@@ -361,7 +360,6 @@ int ipa_table_hash_flush(struct ipa *ipa)
 
 	if (ipa->version < IPA_VERSION_5_0) {
 		reg = ipa_reg(ipa, FILT_ROUT_HASH_FLUSH);
-		offset = ipa_reg_offset(reg);
 
 		val = ipa_reg_bit(reg, IPV6_ROUTER_HASH);
 		val |= ipa_reg_bit(reg, IPV6_FILTER_HASH);
@@ -369,14 +367,13 @@ int ipa_table_hash_flush(struct ipa *ipa)
 		val |= ipa_reg_bit(reg, IPV4_FILTER_HASH);
 	} else {
 		reg = ipa_reg(ipa, FILT_ROUT_CACHE_FLUSH);
-		offset = ipa_reg_offset(reg);
 
 		/* IPA v5.0+ uses a unified cache (both IPv4 and IPv6) */
 		val = ipa_reg_bit(reg, ROUTER_CACHE);
 		val |= ipa_reg_bit(reg, FILTER_CACHE);
 	}
 
-	ipa_cmd_register_write_add(trans, offset, val, val, false);
+	ipa_cmd_register_write_add(trans, reg_offset(reg), val, val, false);
 
 	gsi_trans_commit_wait(trans);
 
@@ -502,7 +499,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 	if (ipa->version < IPA_VERSION_5_0) {
 		reg = ipa_reg(ipa, ENDP_FILTER_ROUTER_HSH_CFG);
 
-		offset = ipa_reg_n_offset(reg, endpoint_id);
+		offset = reg_n_offset(reg, endpoint_id);
 		val = ioread32(endpoint->ipa->reg_virt + offset);
 
 		/* Zero all filter-related fields, preserving the rest */
@@ -510,7 +507,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 	} else {
 		/* IPA v5.0 separates filter and router cache configuration */
 		reg = ipa_reg(ipa, ENDP_FILTER_CACHE_CFG);
-		offset = ipa_reg_n_offset(reg, endpoint_id);
+		offset = reg_n_offset(reg, endpoint_id);
 
 		/* Zero all filter-related fields */
 		val = 0;
@@ -560,7 +557,7 @@ static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
 
 	if (ipa->version < IPA_VERSION_5_0) {
 		reg = ipa_reg(ipa, ENDP_FILTER_ROUTER_HSH_CFG);
-		offset = ipa_reg_n_offset(reg, route_id);
+		offset = reg_n_offset(reg, route_id);
 
 		val = ioread32(ipa->reg_virt + offset);
 
@@ -569,7 +566,7 @@ static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
 	} else {
 		/* IPA v5.0 separates filter and router cache configuration */
 		reg = ipa_reg(ipa, ENDP_ROUTER_CACHE_CFG);
-		offset = ipa_reg_n_offset(reg, route_id);
+		offset = reg_n_offset(reg, route_id);
 
 		/* Zero all route-related fields */
 		val = 0;
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 2d25fe0804b25..54ee0a106f35c 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -245,7 +245,7 @@ static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 	reg = ipa_reg(ipa, IPA_IRQ_UC);
 	val = ipa_reg_bit(reg, UC_INTR);
 
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 }
 
 /* Tell the microcontroller the AP is shutting down */
diff --git a/drivers/net/ipa/reg.h b/drivers/net/ipa/reg.h
index f0be664676d36..3c09e66b34a18 100644
--- a/drivers/net/ipa/reg.h
+++ b/drivers/net/ipa/reg.h
@@ -67,4 +67,16 @@ static inline const struct reg *reg(const struct regs *regs, u32 reg_id)
 	return regs->reg[reg_id];
 }
 
+/* Returns 0 for NULL reg; warning should have already been issued */
+static inline u32 reg_offset(const struct reg *reg)
+{
+	return reg ? reg->offset : 0;
+}
+
+/* Returns 0 for NULL reg; warning should have already been issued */
+static inline u32 reg_n_offset(const struct reg *reg, u32 n)
+{
+	return reg ? reg->offset + n * reg->stride : 0;
+}
+
 #endif /* _REG_H_ */
-- 
2.34.1

