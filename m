Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306C4692695
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbjBJTho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbjBJThX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:37:23 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF706CC41
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:07 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id c15so1028404ils.12
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXz1nGRX3fEoQfmsB6d63yoIph1WlWOs3nnR8GzaSU8=;
        b=Md415yPrGMZU8JlquKg85VwUw9PGclD2APwO1uGAO5xhxChgeX+ViZLdYLiSv1V3IG
         CrhtZNGkBfjyXpdZ/l7nk0Lya82fXc2lQqApnrPiiQPZgCsBoxXe8ocLOjQ7bM+hLHcl
         mWpH48IYfzvCSwWlBH/EZMo23f6Du2ygjSrKbglMOpz/1bMnrH52nHPYocqrtJTmmJip
         96ODB5m2ne2KN1eXyMVJZ9y89BdpYevKex7Qy6BJONKQEcMe7+tA6MWNV6DgrRq/cKvm
         aTsZzGvuwTRmPQd/BxlhwDlbYJSPY6UpLUk/jCH7krALBnhzGU1hl5nI7svcgZ9ELsyE
         ZOXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PXz1nGRX3fEoQfmsB6d63yoIph1WlWOs3nnR8GzaSU8=;
        b=XI3Ug//VZ6mfPKOW/QYD2PjALBv48LmlAYFKkzumoCgLeJxSySSvZdps1hfVf52Sjt
         URGOrAZTO+8CJrq1D6tEh2St20bGpzQEK4504yzgrUvRa+V1EpGNTX4sVordUJOVZ2eQ
         4/4KU1bYCIgE3q5QPoeJdQqtNu5/k8SrmI4BDXQtvspZ05i+HzZiMKWyT0tvh2kUQVU4
         tHWnXcDsf4Ocddsh1b9Tq0OKGnrAWCJ4yzzdLrdWjLUqJ82P5ukLFsDd33BBCTXnFPcq
         0cT5mG2gQk9kpzZJsaWmm4iqnXeocd9CleIhs8ZG+e1jsNrrIa3wlxpBE30jjKTgbSfE
         8eRw==
X-Gm-Message-State: AO0yUKVUPNWIAVdQJ0za09yBJuS0O9B2NGKi8uMfhy0bjKiHZ7dRjLza
        3zrG5/dcZs5dn1t8OV1f2XkiQw==
X-Google-Smtp-Source: AK7set9qNY5E5Tf6hg4BwTXOYqqABQ9Gmla+pz/JtZiJI9tXnaF/bNFOfPBoxZCnHqL9b7XwLwJfhw==
X-Received: by 2002:a05:6e02:1b06:b0:313:dffd:6268 with SMTP id i6-20020a056e021b0600b00313dffd6268mr17195759ilv.30.1676057827117;
        Fri, 10 Feb 2023 11:37:07 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id 14-20020a056e020cae00b00304ae88ebebsm1530692ilg.88.2023.02.10.11.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:37:06 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/8] net: ipa: define IPA v3.1 GSI event ring register offsets
Date:   Fri, 10 Feb 2023 13:36:52 -0600
Message-Id: <20230210193655.460225-6-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210193655.460225-1-elder@linaro.org>
References: <20230210193655.460225-1-elder@linaro.org>
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

Add definitions of the offsets and strides for registers whose
offset depends on an event ring ID, and use gsi_reg() and its
returned value to determine offsets for these registers.  Get
rid of the corresponding GSI_EV_CH_E_*_OFFSET() macros.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c              | 45 +++++++++++++++++-------
 drivers/net/ipa/gsi_reg.h          | 42 ++--------------------
 drivers/net/ipa/reg/gsi_reg-v3.1.c | 56 ++++++++++++++++++++++++++++++
 3 files changed, 90 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index a41e8418b62ae..72da50ae3596a 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -392,9 +392,10 @@ static bool gsi_command(struct gsi *gsi, u32 reg, u32 val)
 static enum gsi_evt_ring_state
 gsi_evt_ring_state(struct gsi *gsi, u32 evt_ring_id)
 {
+	const struct reg *reg = gsi_reg(gsi, EV_CH_E_CNTXT_0);
 	u32 val;
 
-	val = ioread32(gsi->virt + GSI_EV_CH_E_CNTXT_0_OFFSET(evt_ring_id));
+	val = ioread32(gsi->virt + reg_n_offset(reg, evt_ring_id));
 
 	return u32_get_bits(val, EV_CHSTATE_FMASK);
 }
@@ -690,6 +691,7 @@ static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
  */
 static void gsi_evt_ring_doorbell(struct gsi *gsi, u32 evt_ring_id, u32 index)
 {
+	const struct reg *reg = gsi_reg(gsi, EV_CH_E_DOORBELL_0);
 	struct gsi_ring *ring = &gsi->evt_ring[evt_ring_id].ring;
 	u32 val;
 
@@ -697,7 +699,7 @@ static void gsi_evt_ring_doorbell(struct gsi *gsi, u32 evt_ring_id, u32 index)
 
 	/* Note: index *must* be used modulo the ring count here */
 	val = gsi_ring_addr(ring, (index - 1) % ring->count);
-	iowrite32(val, gsi->virt + GSI_EV_CH_E_DOORBELL_0_OFFSET(evt_ring_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, evt_ring_id));
 }
 
 /* Program an event ring for use */
@@ -705,41 +707,56 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 {
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 	struct gsi_ring *ring = &evt_ring->ring;
+	const struct reg *reg;
 	size_t size;
 	u32 val;
 
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_0);
 	/* We program all event rings as GPI type/protocol */
 	val = u32_encode_bits(GSI_CHANNEL_TYPE_GPI, EV_CHTYPE_FMASK);
 	val |= EV_INTYPE_FMASK;
 	val |= u32_encode_bits(GSI_RING_ELEMENT_SIZE, EV_ELEMENT_SIZE_FMASK);
-	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_0_OFFSET(evt_ring_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_1);
 	size = ring->count * GSI_RING_ELEMENT_SIZE;
 	val = ev_ch_e_cntxt_1_length_encode(gsi->version, size);
-	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_1_OFFSET(evt_ring_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
 	/* The context 2 and 3 registers store the low-order and
 	 * high-order 32 bits of the address of the event ring,
 	 * respectively.
 	 */
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_2);
 	val = lower_32_bits(ring->addr);
-	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_2_OFFSET(evt_ring_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, evt_ring_id));
+
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_3);
 	val = upper_32_bits(ring->addr);
-	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_3_OFFSET(evt_ring_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
 	/* Enable interrupt moderation by setting the moderation delay */
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_8);
 	val = u32_encode_bits(GSI_EVT_RING_INT_MODT, MODT_FMASK);
 	val |= u32_encode_bits(1, MODC_FMASK);	/* comes from channel */
-	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_8_OFFSET(evt_ring_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
 	/* No MSI write data, and MSI address high and low address is 0 */
-	iowrite32(0, gsi->virt + GSI_EV_CH_E_CNTXT_9_OFFSET(evt_ring_id));
-	iowrite32(0, gsi->virt + GSI_EV_CH_E_CNTXT_10_OFFSET(evt_ring_id));
-	iowrite32(0, gsi->virt + GSI_EV_CH_E_CNTXT_11_OFFSET(evt_ring_id));
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_9);
+	iowrite32(0, gsi->virt + reg_n_offset(reg, evt_ring_id));
+
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_10);
+	iowrite32(0, gsi->virt + reg_n_offset(reg, evt_ring_id));
+
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_11);
+	iowrite32(0, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
 	/* We don't need to get event read pointer updates */
-	iowrite32(0, gsi->virt + GSI_EV_CH_E_CNTXT_12_OFFSET(evt_ring_id));
-	iowrite32(0, gsi->virt + GSI_EV_CH_E_CNTXT_13_OFFSET(evt_ring_id));
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_12);
+	iowrite32(0, gsi->virt + reg_n_offset(reg, evt_ring_id));
+
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_13);
+	iowrite32(0, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
 	/* Finally, tell the hardware our "last processed" event (arbitrary) */
 	gsi_evt_ring_doorbell(gsi, evt_ring_id, ring->index);
@@ -1538,6 +1555,7 @@ void gsi_channel_update(struct gsi_channel *channel)
 	struct gsi_evt_ring *evt_ring;
 	struct gsi_trans *trans;
 	struct gsi_ring *ring;
+	const struct reg *reg;
 	u32 offset;
 	u32 index;
 
@@ -1547,7 +1565,8 @@ void gsi_channel_update(struct gsi_channel *channel)
 	/* See if there's anything new to process; if not, we're done.  Note
 	 * that index always refers to an entry *within* the event ring.
 	 */
-	offset = GSI_EV_CH_E_CNTXT_4_OFFSET(evt_ring_id);
+	reg = gsi_reg(gsi, EV_CH_E_CNTXT_4);
+	offset = reg_n_offset(reg, evt_ring_id);
 	index = gsi_ring_index(ring, ioread32(gsi->virt + offset));
 	if (index == ring->index % ring->count)
 		return;
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 9faa0b2fefa55..cd0c8011ec3ed 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -150,8 +150,7 @@ enum gsi_prefetch_mode {
 	GSI_FREE_PREFETCH			= 0x3,
 };
 
-#define GSI_EV_CH_E_CNTXT_0_OFFSET(ev) \
-			(0x0001d000 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
+/* EV_CH_E_CNTXT_0 register */
 /* enum gsi_channel_type defines EV_CHTYPE field values in EV_CH_E_CNTXT_0 */
 #define EV_CHTYPE_FMASK			GENMASK(3, 0)
 #define EV_EE_FMASK			GENMASK(7, 4)
@@ -160,48 +159,11 @@ enum gsi_prefetch_mode {
 #define EV_CHSTATE_FMASK		GENMASK(23, 20)
 #define EV_ELEMENT_SIZE_FMASK		GENMASK(31, 24)
 
-#define GSI_EV_CH_E_CNTXT_1_OFFSET(ev) \
-			(0x0001d004 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_CNTXT_2_OFFSET(ev) \
-			(0x0001d008 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_CNTXT_3_OFFSET(ev) \
-			(0x0001d00c + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_CNTXT_4_OFFSET(ev) \
-			(0x0001d010 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_CNTXT_8_OFFSET(ev) \
-			(0x0001d020 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
+/* EV_CH_E_CNTXT_8 register */
 #define MODT_FMASK			GENMASK(15, 0)
 #define MODC_FMASK			GENMASK(23, 16)
 #define MOD_CNT_FMASK			GENMASK(31, 24)
 
-#define GSI_EV_CH_E_CNTXT_9_OFFSET(ev) \
-			(0x0001d024 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_CNTXT_10_OFFSET(ev) \
-			(0x0001d028 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_CNTXT_11_OFFSET(ev) \
-			(0x0001d02c + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_CNTXT_12_OFFSET(ev) \
-			(0x0001d030 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_CNTXT_13_OFFSET(ev) \
-			(0x0001d034 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_SCRATCH_0_OFFSET(ev) \
-			(0x0001d048 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_SCRATCH_1_OFFSET(ev) \
-			(0x0001d04c + 0x4000 * GSI_EE_AP + 0x80 * (ev))
-
-#define GSI_EV_CH_E_DOORBELL_0_OFFSET(ev) \
-			(0x0001e100 + 0x4000 * GSI_EE_AP + 0x08 * (ev))
-
 #define GSI_GSI_STATUS_OFFSET \
 			(0x0001f000 + 0x4000 * GSI_EE_AP)
 #define ENABLED_FMASK			GENMASK(0, 0)
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
index 86e4e05341543..ced42235b19df 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -30,9 +30,51 @@ REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
 REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
 	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
 
+REG_STRIDE(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
+	   0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
+	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
+	   0x0001d008 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
+	   0x0001d00c + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
+	   0x0001d010 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
+	   0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
+	   0x0001d024 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_10, ev_ch_e_cntxt_10,
+	   0x0001d028 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_11, ev_ch_e_cntxt_11,
+	   0x0001d02c + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_12, ev_ch_e_cntxt_12,
+	   0x0001d030 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_CNTXT_13, ev_ch_e_cntxt_13,
+	   0x0001d034 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_SCRATCH_0, ev_ch_e_scratch_0,
+	   0x0001d048 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(EV_CH_E_SCRATCH_1, ev_ch_e_scratch_1,
+	   0x0001d04c + 0x4000 * GSI_EE_AP, 0x80);
+
 REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 	   0x0001e000 + 0x4000 * GSI_EE_AP, 0x08);
 
+REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
+	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
+
 static const struct reg *reg_array[] = {
 	[CH_C_CNTXT_0]			= &reg_ch_c_cntxt_0,
 	[CH_C_CNTXT_1]			= &reg_ch_c_cntxt_1,
@@ -43,7 +85,21 @@ static const struct reg *reg_array[] = {
 	[CH_C_SCRATCH_1]		= &reg_ch_c_scratch_1,
 	[CH_C_SCRATCH_2]		= &reg_ch_c_scratch_2,
 	[CH_C_SCRATCH_3]		= &reg_ch_c_scratch_3,
+	[EV_CH_E_CNTXT_0]		= &reg_ev_ch_e_cntxt_0,
+	[EV_CH_E_CNTXT_1]		= &reg_ev_ch_e_cntxt_1,
+	[EV_CH_E_CNTXT_2]		= &reg_ev_ch_e_cntxt_2,
+	[EV_CH_E_CNTXT_3]		= &reg_ev_ch_e_cntxt_3,
+	[EV_CH_E_CNTXT_4]		= &reg_ev_ch_e_cntxt_4,
+	[EV_CH_E_CNTXT_8]		= &reg_ev_ch_e_cntxt_8,
+	[EV_CH_E_CNTXT_9]		= &reg_ev_ch_e_cntxt_9,
+	[EV_CH_E_CNTXT_10]		= &reg_ev_ch_e_cntxt_10,
+	[EV_CH_E_CNTXT_11]		= &reg_ev_ch_e_cntxt_11,
+	[EV_CH_E_CNTXT_12]		= &reg_ev_ch_e_cntxt_12,
+	[EV_CH_E_CNTXT_13]		= &reg_ev_ch_e_cntxt_13,
+	[EV_CH_E_SCRATCH_0]		= &reg_ev_ch_e_scratch_0,
+	[EV_CH_E_SCRATCH_1]		= &reg_ev_ch_e_scratch_1,
 	[CH_C_DOORBELL_0]		= &reg_ch_c_doorbell_0,
+	[EV_CH_E_DOORBELL_0]		= &reg_ev_ch_e_doorbell_0,
 };
 
 const struct regs gsi_regs_v3_1 = {
-- 
2.34.1

