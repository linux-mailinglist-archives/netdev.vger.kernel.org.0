Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C470769269A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbjBJTh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjBJThc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:37:32 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A103D1EBE1
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:09 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id h29so820388ila.8
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjGjJiA6nCdDDHHXiPxnYCaHY1I0dLwG12HA7ZVvV3A=;
        b=NMOwCSjcechUKa99xWqbhfD5qlk5ndEVIjt2X+M60MAsqAgndHQADSRVHhyI3DNkPX
         p8UBJw9GvMa7b3TupeHmk761ghC5VfVOiyx2E9kC2L5jjV5hSAujrDOzmYdK3mhCuX8/
         bYXeuqrsJ4CnzVyzKJq783mZT86cjv/xzNgXs5DLA1t3aweVLI+ZMVwx055xDtYwBK/w
         P7Ibz1FBC0BG2uWW+9ImEgZiF3G+rXR67AlYwGak9GGsiICqTdw6JJcDnCvXxOKyPeyV
         ciMoCFqkxZct9qi9pCgUnHwGtxw4qKsJCvPojmNdXcappXEhG4yUtIRYri1lLH9igXWq
         ESGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FjGjJiA6nCdDDHHXiPxnYCaHY1I0dLwG12HA7ZVvV3A=;
        b=Va5oesGuNSukyaWL7AhV90fiFmy2zYKvGX3BOmOayl1Hn9qhsuvuOcPZcJXlt7xOzE
         CgSFEzlJH8D2KrLpVczH8Jae/W1/SOTtCeiK+QyMuFeeUuDGnoeHCnAcO2YjGtnDVpUe
         5vUEv0Eavm4wYiQkw11J3i4nbP23ev8efTS1JbRDJL9poM7Tb1nCmLxY0VFc2kV+duBb
         PAa01uaPgo/aUSQmBpFCdzEs/gfDFBWcu1iRMm2Kz3buVXXgqKB7aFMrBUPNg5mZ05zn
         xfpDzkkC8BFGQcn4tT70n4bNkF2RAkbLSBI3aZgF9X9j63nHqDQrQC/kzjrZuMm88VKE
         xgTw==
X-Gm-Message-State: AO0yUKWmnqd2MsVV2bRmht2jbsetTy0kSuKCNdBYxOGo/gZIGB8aY+3y
        sVRBMbo23S10qt8P/SZl6MAQRw==
X-Google-Smtp-Source: AK7set+CuWiFnTLNfao1v3d+1uJfnPswJDHkZU4w/AKUkRv8dfD54kdJKm4//JNWLiE2TVBYS0shig==
X-Received: by 2002:a05:6e02:1c89:b0:311:1137:178d with SMTP id w9-20020a056e021c8900b003111137178dmr16410633ill.13.1676057828903;
        Fri, 10 Feb 2023 11:37:08 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id 14-20020a056e020cae00b00304ae88ebebsm1530692ilg.88.2023.02.10.11.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:37:08 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/8] net: ipa: define IPA v3.1 GSI interrupt register offsets
Date:   Fri, 10 Feb 2023 13:36:53 -0600
Message-Id: <20230210193655.460225-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210193655.460225-1-elder@linaro.org>
References: <20230210193655.460225-1-elder@linaro.org>
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

Add definitions of the offsets for IRQ-related GSI registers.  Use
gsi_reg() rather than the corresponding GSI_CNTXT_*_OFFSET() macros
to get the offsets for these registers, and get rid of the macros.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c              | 160 +++++++++++++++++++++--------
 drivers/net/ipa/gsi_reg.h          |  62 +----------
 drivers/net/ipa/reg/gsi_reg-v3.1.c |  75 ++++++++++++++
 3 files changed, 195 insertions(+), 102 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 72da50ae3596a..ee8ca514eb533 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -221,8 +221,10 @@ static u32 ev_ch_e_cntxt_1_length_encode(enum ipa_version version, u32 length)
 /* Update the GSI IRQ type register with the cached value */
 static void gsi_irq_type_update(struct gsi *gsi, u32 val)
 {
+	const struct reg *reg = gsi_reg(gsi, CNTXT_TYPE_IRQ_MSK);
+
 	gsi->type_enabled_bitmap = val;
-	iowrite32(val, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
+	iowrite32(val, gsi->virt + reg_offset(reg));
 }
 
 static void gsi_irq_type_enable(struct gsi *gsi, enum gsi_irq_type_id type_id)
@@ -243,22 +245,29 @@ static void gsi_irq_type_disable(struct gsi *gsi, enum gsi_irq_type_id type_id)
 static void gsi_irq_ev_ctrl_enable(struct gsi *gsi, u32 evt_ring_id)
 {
 	u32 val = BIT(evt_ring_id);
+	const struct reg *reg;
 
 	/* There's a small chance that a previous command completed
 	 * after the interrupt was disabled, so make sure we have no
 	 * pending interrupts before we enable them.
 	 */
-	iowrite32(~0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_SRC_EV_CH_IRQ_CLR);
+	iowrite32(~0, gsi->virt + reg_offset(reg));
 
-	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_SRC_EV_CH_IRQ_MSK);
+	iowrite32(val, gsi->virt + reg_offset(reg));
 	gsi_irq_type_enable(gsi, GSI_EV_CTRL);
 }
 
 /* Disable event ring control interrupts */
 static void gsi_irq_ev_ctrl_disable(struct gsi *gsi)
 {
+	const struct reg *reg;
+
 	gsi_irq_type_disable(gsi, GSI_EV_CTRL);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
+
+	reg = gsi_reg(gsi, CNTXT_SRC_EV_CH_IRQ_MSK);
+	iowrite32(0, gsi->virt + reg_offset(reg));
 }
 
 /* Channel commands are performed one at a time.  Their completion is
@@ -269,32 +278,43 @@ static void gsi_irq_ev_ctrl_disable(struct gsi *gsi)
 static void gsi_irq_ch_ctrl_enable(struct gsi *gsi, u32 channel_id)
 {
 	u32 val = BIT(channel_id);
+	const struct reg *reg;
 
 	/* There's a small chance that a previous command completed
 	 * after the interrupt was disabled, so make sure we have no
 	 * pending interrupts before we enable them.
 	 */
-	iowrite32(~0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_CLR_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_SRC_CH_IRQ_CLR);
+	iowrite32(~0, gsi->virt + reg_offset(reg));
+
+	reg = gsi_reg(gsi, CNTXT_SRC_CH_IRQ_MSK);
+	iowrite32(val, gsi->virt + reg_offset(reg));
 
-	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
 	gsi_irq_type_enable(gsi, GSI_CH_CTRL);
 }
 
 /* Disable channel control interrupts */
 static void gsi_irq_ch_ctrl_disable(struct gsi *gsi)
 {
+	const struct reg *reg;
+
 	gsi_irq_type_disable(gsi, GSI_CH_CTRL);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
+
+	reg = gsi_reg(gsi, CNTXT_SRC_CH_IRQ_MSK);
+	iowrite32(0, gsi->virt + reg_offset(reg));
 }
 
 static void gsi_irq_ieob_enable_one(struct gsi *gsi, u32 evt_ring_id)
 {
 	bool enable_ieob = !gsi->ieob_enabled_bitmap;
+	const struct reg *reg;
 	u32 val;
 
 	gsi->ieob_enabled_bitmap |= BIT(evt_ring_id);
+
+	reg = gsi_reg(gsi, CNTXT_SRC_IEOB_IRQ_MSK);
 	val = gsi->ieob_enabled_bitmap;
-	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
+	iowrite32(val, gsi->virt + reg_offset(reg));
 
 	/* Enable the interrupt type if this is the first channel enabled */
 	if (enable_ieob)
@@ -303,6 +323,7 @@ static void gsi_irq_ieob_enable_one(struct gsi *gsi, u32 evt_ring_id)
 
 static void gsi_irq_ieob_disable(struct gsi *gsi, u32 event_mask)
 {
+	const struct reg *reg;
 	u32 val;
 
 	gsi->ieob_enabled_bitmap &= ~event_mask;
@@ -311,8 +332,9 @@ static void gsi_irq_ieob_disable(struct gsi *gsi, u32 event_mask)
 	if (!gsi->ieob_enabled_bitmap)
 		gsi_irq_type_disable(gsi, GSI_IEOB);
 
+	reg = gsi_reg(gsi, CNTXT_SRC_IEOB_IRQ_MSK);
 	val = gsi->ieob_enabled_bitmap;
-	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
+	iowrite32(val, gsi->virt + reg_offset(reg));
 }
 
 static void gsi_irq_ieob_disable_one(struct gsi *gsi, u32 evt_ring_id)
@@ -323,12 +345,15 @@ static void gsi_irq_ieob_disable_one(struct gsi *gsi, u32 evt_ring_id)
 /* Enable all GSI_interrupt types */
 static void gsi_irq_enable(struct gsi *gsi)
 {
+	const struct reg *reg;
 	u32 val;
 
 	/* Global interrupts include hardware error reports.  Enable
 	 * that so we can at least report the error should it occur.
 	 */
-	iowrite32(ERROR_INT, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_GLOB_IRQ_EN);
+	iowrite32(ERROR_INT, gsi->virt + reg_offset(reg));
+
 	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | GSI_GLOB_EE);
 
 	/* General GSI interrupts are reported to all EEs; if they occur
@@ -336,21 +361,28 @@ static void gsi_irq_enable(struct gsi *gsi)
 	 * also exists, but we don't support that.  We want to be notified
 	 * of errors so we can report them, even if they can't be handled.
 	 */
+	reg = gsi_reg(gsi, CNTXT_GSI_IRQ_EN);
 	val = BUS_ERROR;
 	val |= CMD_FIFO_OVRFLOW;
 	val |= MCS_STACK_OVRFLOW;
-	iowrite32(val, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
+	iowrite32(val, gsi->virt + reg_offset(reg));
+
 	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | GSI_GENERAL);
 }
 
 /* Disable all GSI interrupt types */
 static void gsi_irq_disable(struct gsi *gsi)
 {
+	const struct reg *reg;
+
 	gsi_irq_type_update(gsi, 0);
 
 	/* Clear the type-specific interrupt masks set by gsi_irq_enable() */
-	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_GSI_IRQ_EN);
+	iowrite32(0, gsi->virt + reg_offset(reg));
+
+	reg = gsi_reg(gsi, CNTXT_GLOB_IRQ_EN);
+	iowrite32(0, gsi->virt + reg_offset(reg));
 }
 
 /* Return the virtual address associated with a ring index */
@@ -1120,10 +1152,14 @@ static void gsi_trans_tx_completed(struct gsi_trans *trans)
 /* Channel control interrupt handler */
 static void gsi_isr_chan_ctrl(struct gsi *gsi)
 {
+	const struct reg *reg;
 	u32 channel_mask;
 
-	channel_mask = ioread32(gsi->virt + GSI_CNTXT_SRC_CH_IRQ_OFFSET);
-	iowrite32(channel_mask, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_CLR_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_SRC_CH_IRQ);
+	channel_mask = ioread32(gsi->virt + reg_offset(reg));
+
+	reg = gsi_reg(gsi, CNTXT_SRC_CH_IRQ_CLR);
+	iowrite32(channel_mask, gsi->virt + reg_offset(reg));
 
 	while (channel_mask) {
 		u32 channel_id = __ffs(channel_mask);
@@ -1137,10 +1173,14 @@ static void gsi_isr_chan_ctrl(struct gsi *gsi)
 /* Event ring control interrupt handler */
 static void gsi_isr_evt_ctrl(struct gsi *gsi)
 {
+	const struct reg *reg;
 	u32 event_mask;
 
-	event_mask = ioread32(gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_OFFSET);
-	iowrite32(event_mask, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_SRC_EV_CH_IRQ);
+	event_mask = ioread32(gsi->virt + reg_offset(reg));
+
+	reg = gsi_reg(gsi, CNTXT_SRC_EV_CH_IRQ_CLR);
+	iowrite32(event_mask, gsi->virt + reg_offset(reg));
 
 	while (event_mask) {
 		u32 evt_ring_id = __ffs(event_mask);
@@ -1215,6 +1255,7 @@ static void gsi_isr_glob_err(struct gsi *gsi)
 /* Generic EE interrupt handler */
 static void gsi_isr_gp_int1(struct gsi *gsi)
 {
+	const struct reg *reg;
 	u32 result;
 	u32 val;
 
@@ -1237,7 +1278,8 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 	 * In either case, we silently ignore a INCORRECT_CHANNEL_STATE
 	 * error if we receive it.
 	 */
-	val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_SCRATCH_0);
+	val = ioread32(gsi->virt + reg_offset(reg));
 	result = u32_get_bits(val, GENERIC_EE_RESULT_FMASK);
 
 	switch (result) {
@@ -1262,14 +1304,17 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 /* Inter-EE interrupt handler */
 static void gsi_isr_glob_ee(struct gsi *gsi)
 {
+	const struct reg *reg;
 	u32 val;
 
-	val = ioread32(gsi->virt + GSI_CNTXT_GLOB_IRQ_STTS_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_GLOB_IRQ_STTS);
+	val = ioread32(gsi->virt + reg_offset(reg));
 
 	if (val & ERROR_INT)
 		gsi_isr_glob_err(gsi);
 
-	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_CLR_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_GLOB_IRQ_CLR);
+	iowrite32(val, gsi->virt + reg_offset(reg));
 
 	val &= ~ERROR_INT;
 
@@ -1285,11 +1330,16 @@ static void gsi_isr_glob_ee(struct gsi *gsi)
 /* I/O completion interrupt event */
 static void gsi_isr_ieob(struct gsi *gsi)
 {
+	const struct reg *reg;
 	u32 event_mask;
 
-	event_mask = ioread32(gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_SRC_IEOB_IRQ);
+	event_mask = ioread32(gsi->virt + reg_offset(reg));
+
 	gsi_irq_ieob_disable(gsi, event_mask);
-	iowrite32(event_mask, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET);
+
+	reg = gsi_reg(gsi, CNTXT_SRC_IEOB_IRQ_CLR);
+	iowrite32(event_mask, gsi->virt + reg_offset(reg));
 
 	while (event_mask) {
 		u32 evt_ring_id = __ffs(event_mask);
@@ -1304,10 +1354,14 @@ static void gsi_isr_ieob(struct gsi *gsi)
 static void gsi_isr_general(struct gsi *gsi)
 {
 	struct device *dev = gsi->dev;
+	const struct reg *reg;
 	u32 val;
 
-	val = ioread32(gsi->virt + GSI_CNTXT_GSI_IRQ_STTS_OFFSET);
-	iowrite32(val, gsi->virt + GSI_CNTXT_GSI_IRQ_CLR_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_GSI_IRQ_STTS);
+	val = ioread32(gsi->virt + reg_offset(reg));
+
+	reg = gsi_reg(gsi, CNTXT_GSI_IRQ_CLR);
+	iowrite32(val, gsi->virt + reg_offset(reg));
 
 	dev_err(dev, "unexpected general interrupt 0x%08x\n", val);
 }
@@ -1323,17 +1377,25 @@ static void gsi_isr_general(struct gsi *gsi)
 static irqreturn_t gsi_isr(int irq, void *dev_id)
 {
 	struct gsi *gsi = dev_id;
+	const struct reg *reg;
 	u32 intr_mask;
 	u32 cnt = 0;
+	u32 offset;
+
+	reg = gsi_reg(gsi, CNTXT_TYPE_IRQ);
+	offset = reg_offset(reg);
 
 	/* enum gsi_irq_type_id defines GSI interrupt types */
-	while ((intr_mask = ioread32(gsi->virt + GSI_CNTXT_TYPE_IRQ_OFFSET))) {
+	while ((intr_mask = ioread32(gsi->virt + offset))) {
 		/* intr_mask contains bitmask of pending GSI interrupts */
 		do {
 			u32 gsi_intr = BIT(__ffs(intr_mask));
 
 			intr_mask ^= gsi_intr;
 
+			/* Note: the IRQ condition for each type is cleared
+			 * when the type-specific register is updated.
+			 */
 			switch (gsi_intr) {
 			case GSI_CH_CTRL:
 				gsi_isr_chan_ctrl(gsi);
@@ -1717,7 +1779,9 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 			       enum gsi_generic_cmd_opcode opcode,
 			       u8 params)
 {
+	const struct reg *reg;
 	bool timeout;
+	u32 offset;
 	u32 val;
 
 	/* The error global interrupt type is always enabled (until we tear
@@ -1729,13 +1793,17 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	 * channel), and only from this function.  So we enable the GP_INT1
 	 * IRQ type here, and disable it again after the command completes.
 	 */
+	reg = gsi_reg(gsi, CNTXT_GLOB_IRQ_EN);
 	val = ERROR_INT | GP_INT1;
-	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	iowrite32(val, gsi->virt + reg_offset(reg));
 
 	/* First zero the result code field */
-	val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_SCRATCH_0);
+	offset = reg_offset(reg);
+	val = ioread32(gsi->virt + offset);
+
 	val &= ~GENERIC_EE_RESULT_FMASK;
-	iowrite32(val, gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
+	iowrite32(val, gsi->virt + offset);
 
 	/* Now issue the command */
 	val = u32_encode_bits(opcode, GENERIC_OPCODE_FMASK);
@@ -1747,7 +1815,8 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	timeout = !gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val);
 
 	/* Disable the GP_INT1 IRQ type again */
-	iowrite32(ERROR_INT, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_GLOB_IRQ_EN);
+	iowrite32(ERROR_INT, gsi->virt + reg_offset(reg));
 
 	if (!timeout)
 		return gsi->result;
@@ -1904,32 +1973,41 @@ static void gsi_channel_teardown(struct gsi *gsi)
 /* Turn off all GSI interrupts initially */
 static int gsi_irq_setup(struct gsi *gsi)
 {
+	const struct reg *reg;
 	int ret;
 
 	/* Writing 1 indicates IRQ interrupts; 0 would be MSI */
-	iowrite32(1, gsi->virt + GSI_CNTXT_INTSET_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_INTSET);
+	iowrite32(1, gsi->virt + reg_offset(reg));
 
 	/* Disable all interrupt types */
 	gsi_irq_type_update(gsi, 0);
 
 	/* Clear all type-specific interrupt masks */
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_SRC_CH_IRQ_MSK);
+	iowrite32(0, gsi->virt + reg_offset(reg));
+
+	reg = gsi_reg(gsi, CNTXT_SRC_EV_CH_IRQ_MSK);
+	iowrite32(0, gsi->virt + reg_offset(reg));
+
+	reg = gsi_reg(gsi, CNTXT_GLOB_IRQ_EN);
+	iowrite32(0, gsi->virt + reg_offset(reg));
+
+	reg = gsi_reg(gsi, CNTXT_SRC_IEOB_IRQ_MSK);
+	iowrite32(0, gsi->virt + reg_offset(reg));
 
 	/* The inter-EE interrupts are not supported for IPA v3.0-v3.1 */
 	if (gsi->version > IPA_VERSION_3_1) {
-		u32 offset;
-
 		/* These registers are in the non-adjusted address range */
-		offset = GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET;
-		iowrite32(0, gsi->virt_raw + offset);
-		offset = GSI_INTER_EE_SRC_EV_CH_IRQ_MSK_OFFSET;
-		iowrite32(0, gsi->virt_raw + offset);
+		reg = gsi_reg(gsi, INTER_EE_SRC_CH_IRQ_MSK);
+		iowrite32(0, gsi->virt_raw + reg_offset(reg));
+
+		reg = gsi_reg(gsi, INTER_EE_SRC_EV_CH_IRQ_MSK);
+		iowrite32(0, gsi->virt_raw + reg_offset(reg));
 	}
 
-	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
+	reg = gsi_reg(gsi, CNTXT_GSI_IRQ_EN);
+	iowrite32(0, gsi->virt + reg_offset(reg));
 
 	ret = request_irq(gsi->irq, gsi_isr, 0, "gsi", gsi);
 	if (ret)
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index cd0c8011ec3ed..8179b1f77bcd2 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -95,16 +95,6 @@ enum gsi_reg_id {
 	GSI_REG_ID_COUNT,				/* Last; not an ID */
 };
 
-/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
-
-#define GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET \
-			(0x0000c020 + 0x1000 * GSI_EE_AP)
-
-#define GSI_INTER_EE_SRC_EV_CH_IRQ_MSK_OFFSET \
-			(0x0000c024 + 0x1000 * GSI_EE_AP)
-
-/* All other register offsets are relative to gsi->virt */
-
 /* CH_C_CNTXT_0 register */
 #define CHTYPE_PROTOCOL_FMASK		GENMASK(2, 0)
 #define CHTYPE_DIR_FMASK		GENMASK(3, 3)
@@ -240,12 +230,6 @@ enum gsi_iram_size {
 	IRAM_SIZE_FOUR_KB			= 0x5,
 };
 
-/* IRQ condition for each type is cleared by writing type-specific register */
-#define GSI_CNTXT_TYPE_IRQ_OFFSET \
-			(0x0001f080 + 0x4000 * GSI_EE_AP)
-#define GSI_CNTXT_TYPE_IRQ_MSK_OFFSET \
-			(0x0001f088 + 0x4000 * GSI_EE_AP)
-
 /**
  * enum gsi_irq_type_id: GSI IRQ types
  * @GSI_CH_CTRL:		Channel allocation, deallocation, etc.
@@ -267,40 +251,6 @@ enum gsi_irq_type_id {
 	/* IRQ types 7-31 (and their bit values) are reserved */
 };
 
-#define GSI_CNTXT_SRC_CH_IRQ_OFFSET \
-			(0x0001f090 + 0x4000 * GSI_EE_AP)
-
-#define GSI_CNTXT_SRC_EV_CH_IRQ_OFFSET \
-			(0x0001f094 + 0x4000 * GSI_EE_AP)
-
-#define GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET \
-			(0x0001f098 + 0x4000 * GSI_EE_AP)
-
-#define GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET \
-			(0x0001f09c + 0x4000 * GSI_EE_AP)
-
-#define GSI_CNTXT_SRC_CH_IRQ_CLR_OFFSET \
-			(0x0001f0a0 + 0x4000 * GSI_EE_AP)
-
-#define GSI_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET \
-			(0x0001f0a4 + 0x4000 * GSI_EE_AP)
-
-#define GSI_CNTXT_SRC_IEOB_IRQ_OFFSET \
-			(0x0001f0b0 + 0x4000 * GSI_EE_AP)
-
-#define GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET \
-			(0x0001f0b8 + 0x4000 * GSI_EE_AP)
-
-#define GSI_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET \
-			(0x0001f0c0 + 0x4000 * GSI_EE_AP)
-
-#define GSI_CNTXT_GLOB_IRQ_STTS_OFFSET \
-			(0x0001f100 + 0x4000 * GSI_EE_AP)
-#define GSI_CNTXT_GLOB_IRQ_EN_OFFSET \
-			(0x0001f108 + 0x4000 * GSI_EE_AP)
-#define GSI_CNTXT_GLOB_IRQ_CLR_OFFSET \
-			(0x0001f110 + 0x4000 * GSI_EE_AP)
-
 /** enum gsi_global_irq_id: Global GSI interrupt events */
 enum gsi_global_irq_id {
 	ERROR_INT				= BIT(0),
@@ -310,13 +260,6 @@ enum gsi_global_irq_id {
 	/* Global IRQ types 4-31 (and their bit values) are reserved */
 };
 
-#define GSI_CNTXT_GSI_IRQ_STTS_OFFSET \
-			(0x0001f118 + 0x4000 * GSI_EE_AP)
-#define GSI_CNTXT_GSI_IRQ_EN_OFFSET \
-			(0x0001f120 + 0x4000 * GSI_EE_AP)
-#define GSI_CNTXT_GSI_IRQ_CLR_OFFSET \
-			(0x0001f128 + 0x4000 * GSI_EE_AP)
-
 /** enum gsi_general_irq_id: GSI general IRQ conditions */
 enum gsi_general_irq_id {
 	BREAK_POINT				= BIT(0),
@@ -326,8 +269,7 @@ enum gsi_general_irq_id {
 	/* General IRQ types 4-31 (and their bit values) are reserved */
 };
 
-#define GSI_CNTXT_INTSET_OFFSET \
-			(0x0001f180 + 0x4000 * GSI_EE_AP)
+/* CNTXT_INTSET register */
 #define INTYPE_FMASK			GENMASK(0, 0)
 
 #define GSI_ERROR_LOG_OFFSET \
@@ -363,8 +305,6 @@ enum gsi_err_type {
 #define GSI_ERROR_LOG_CLR_OFFSET \
 			(0x0001f210 + 0x4000 * GSI_EE_AP)
 
-#define GSI_CNTXT_SCRATCH_0_OFFSET \
-			(0x0001f400 + 0x4000 * GSI_EE_AP)
 #define INTER_EE_RESULT_FMASK		GENMASK(2, 0)
 #define GENERIC_EE_RESULT_FMASK		GENMASK(7, 5)
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
index ced42235b19df..f7fe2308bdfe0 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -8,6 +8,16 @@
 #include "../reg.h"
 #include "../gsi_reg.h"
 
+/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
+
+REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
+    0x0000c020 + 0x1000 * GSI_EE_AP);
+
+REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
+    0x0000c024 + 0x1000 * GSI_EE_AP);
+
+/* All other register offsets are relative to gsi->virt */
+
 REG_STRIDE(CH_C_CNTXT_0, ch_c_cntxt_0, 0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_CNTXT_1, ch_c_cntxt_1, 0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
@@ -75,7 +85,53 @@ REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
 	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
 
+REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x0001f088 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_CH_IRQ, cntxt_src_ch_irq, 0x0001f090 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_EV_CH_IRQ, cntxt_src_ev_ch_irq, 0x0001f094 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_CH_IRQ_MSK, cntxt_src_ch_irq_msk,
+    0x0001f098 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_EV_CH_IRQ_MSK, cntxt_src_ev_ch_irq_msk,
+    0x0001f09c + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_CH_IRQ_CLR, cntxt_src_ch_irq_clr,
+    0x0001f0a0 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_EV_CH_IRQ_CLR, cntxt_src_ev_ch_irq_clr,
+    0x0001f0a4 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_IEOB_IRQ, cntxt_src_ieob_irq, 0x0001f0b0 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_IEOB_IRQ_MSK, cntxt_src_ieob_irq_msk,
+    0x0001f0b8 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SRC_IEOB_IRQ_CLR, cntxt_src_ieob_irq_clr,
+    0x0001f0c0 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GLOB_IRQ_STTS, cntxt_glob_irq_stts, 0x0001f100 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GLOB_IRQ_EN, cntxt_glob_irq_en, 0x0001f108 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GLOB_IRQ_CLR, cntxt_glob_irq_clr, 0x0001f110 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GSI_IRQ_STTS, cntxt_gsi_irq_stts, 0x0001f118 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+
+REG(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+
 static const struct reg *reg_array[] = {
+	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
+	[INTER_EE_SRC_EV_CH_IRQ_MSK]	= &reg_inter_ee_src_ev_ch_irq_msk,
 	[CH_C_CNTXT_0]			= &reg_ch_c_cntxt_0,
 	[CH_C_CNTXT_1]			= &reg_ch_c_cntxt_1,
 	[CH_C_CNTXT_2]			= &reg_ch_c_cntxt_2,
@@ -100,6 +156,25 @@ static const struct reg *reg_array[] = {
 	[EV_CH_E_SCRATCH_1]		= &reg_ev_ch_e_scratch_1,
 	[CH_C_DOORBELL_0]		= &reg_ch_c_doorbell_0,
 	[EV_CH_E_DOORBELL_0]		= &reg_ev_ch_e_doorbell_0,
+	[CNTXT_TYPE_IRQ]		= &reg_cntxt_type_irq,
+	[CNTXT_TYPE_IRQ_MSK]		= &reg_cntxt_type_irq_msk,
+	[CNTXT_SRC_CH_IRQ]		= &reg_cntxt_src_ch_irq,
+	[CNTXT_SRC_EV_CH_IRQ]		= &reg_cntxt_src_ev_ch_irq,
+	[CNTXT_SRC_CH_IRQ_MSK]		= &reg_cntxt_src_ch_irq_msk,
+	[CNTXT_SRC_EV_CH_IRQ_MSK]	= &reg_cntxt_src_ev_ch_irq_msk,
+	[CNTXT_SRC_CH_IRQ_CLR]		= &reg_cntxt_src_ch_irq_clr,
+	[CNTXT_SRC_EV_CH_IRQ_CLR]	= &reg_cntxt_src_ev_ch_irq_clr,
+	[CNTXT_SRC_IEOB_IRQ]		= &reg_cntxt_src_ieob_irq,
+	[CNTXT_SRC_IEOB_IRQ_MSK]	= &reg_cntxt_src_ieob_irq_msk,
+	[CNTXT_SRC_IEOB_IRQ_CLR]	= &reg_cntxt_src_ieob_irq_clr,
+	[CNTXT_GLOB_IRQ_STTS]		= &reg_cntxt_glob_irq_stts,
+	[CNTXT_GLOB_IRQ_EN]		= &reg_cntxt_glob_irq_en,
+	[CNTXT_GLOB_IRQ_CLR]		= &reg_cntxt_glob_irq_clr,
+	[CNTXT_GSI_IRQ_STTS]		= &reg_cntxt_gsi_irq_stts,
+	[CNTXT_GSI_IRQ_EN]		= &reg_cntxt_gsi_irq_en,
+	[CNTXT_GSI_IRQ_CLR]		= &reg_cntxt_gsi_irq_clr,
+	[CNTXT_INTSET]			= &reg_cntxt_intset,
+	[CNTXT_SCRATCH_0]		= &reg_cntxt_scratch_0,
 };
 
 const struct regs gsi_regs_v3_1 = {
-- 
2.34.1

