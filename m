Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF81F68F93A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 21:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjBHU5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 15:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjBHU5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 15:57:34 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6744672E
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 12:57:26 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id m15so21003ilh.9
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 12:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRmfaCLrsw5OuU6uWFqXW1UTeq3Z7ZlzNhHojgtAQJc=;
        b=WE9PW+CwtdKrJLY45JgGd7WmjKjjfDDcgkYRY8YXKk51EgdNl2zDKFMYcJc60dm9Gi
         0CSxsy6CQQsFMPAjNA0TM02b5vmxmbkHG0HCYeIxnjbSzU5jWa9tKYx8aAyvjW0nlzb+
         w2GL2sgoIBgCNDugevZiIT7DmbEcob4I74XpTxwkFliZU5WlA2PzHpnvW3YwKXkvKS0b
         7x8pOA3fe4h0XcYbevdyzGK778vrhCwnBCBuO3ZuP2hmGFAFxHT8/LxKvlcFsc5HYZLG
         Jak4VRH9gDE13x6P1xnnHOeVFrXGuXFgNxSHzjQ9Jdd7jeviGpTAhU0YfM/T0ktwzfBP
         4/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xRmfaCLrsw5OuU6uWFqXW1UTeq3Z7ZlzNhHojgtAQJc=;
        b=p7R8tjXlTBSv93v5/6q7JUhhZfWFpr6WuIRuKjfXNxXn/7WhmXAaIAMja08FtCokmi
         QR5GnwX7Dc0t8FnDMTUHqOu3CSv0QBJ4PWGTkyqHqAJc2No+IzRbE5S65BS0Dn95FHsW
         ELiQcKgNVpeQvW2wOybtYL4FdnnTpR91Ar9qqzrsmro6ZB+WCt1oCZKRpghb5En6yH3c
         UDVPHn7ioaQ6/CivysY698npKOTEc1GUAf8Uff2Phcugl4prxia+VtaYtsCDYEthP4Ne
         /OHPEibb1OSwlKS35GNdJcF0g5FdpFy/RECcmBn1slrh1VCu/eGdy25bfhnaLgJFAUT3
         PmZQ==
X-Gm-Message-State: AO0yUKUGhPYmybh8cd7XIe6Gqzqi5gA/Tw9Yrdi+04J9GoOlNXbE/SO5
        O/10uoE8ZKqmsRQUt07qS6HYzQ==
X-Google-Smtp-Source: AK7set9CVQ1eQDKl7ISqjKO4ko3+hazkCmlg7SGpogIsjyHFdLcvhJFkTtH8vDbfwnvBBatlj2L4Mw==
X-Received: by 2002:a05:6e02:34a1:b0:313:f28f:b8ba with SMTP id bp33-20020a056e0234a100b00313f28fb8bamr3010221ilb.3.1675889845971;
        Wed, 08 Feb 2023 12:57:25 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id r6-20020a922a06000000b0031093e9c7fasm5236704ile.85.2023.02.08.12.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 12:57:24 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/9] net: ipa: use bitmasks for GSI IRQ values
Date:   Wed,  8 Feb 2023 14:56:49 -0600
Message-Id: <20230208205653.177700-6-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230208205653.177700-1-elder@linaro.org>
References: <20230208205653.177700-1-elder@linaro.org>
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

There are seven GSI interrupt types that can be signaled by a single
GSI IRQ.  These are represented in a bitmask, and the gsi_irq_type_id
enumerated type defines what each bit position represents.

Similarly, the global and general GSI interrupt types each has a set
of conditions it signals, and both types have an enumerated type
that defines which bit that represents each condition.

When used, these enumerated values are passed as an argument to BIT()
in *all* cases.  So clean up the code a little bit by defining the
enumerated type values as one-bit masks rather than bit positions.

Rename gsi_general_id to be gsi_general_irq_id for consistency.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 38 ++++++++++++++--------------
 drivers/net/ipa/gsi_reg.h | 52 +++++++++++++++++++++++++--------------
 2 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index f1a3938294866..da90785e8df52 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -191,12 +191,12 @@ static void gsi_irq_type_update(struct gsi *gsi, u32 val)
 
 static void gsi_irq_type_enable(struct gsi *gsi, enum gsi_irq_type_id type_id)
 {
-	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | BIT(type_id));
+	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | type_id);
 }
 
 static void gsi_irq_type_disable(struct gsi *gsi, enum gsi_irq_type_id type_id)
 {
-	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap & ~BIT(type_id));
+	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap & ~type_id);
 }
 
 /* Event ring commands are performed one at a time.  Their completion
@@ -292,19 +292,19 @@ static void gsi_irq_enable(struct gsi *gsi)
 	/* Global interrupts include hardware error reports.  Enable
 	 * that so we can at least report the error should it occur.
 	 */
-	iowrite32(BIT(ERROR_INT), gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
-	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | BIT(GSI_GLOB_EE));
+	iowrite32(ERROR_INT, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | GSI_GLOB_EE);
 
 	/* General GSI interrupts are reported to all EEs; if they occur
 	 * they are unrecoverable (without reset).  A breakpoint interrupt
 	 * also exists, but we don't support that.  We want to be notified
 	 * of errors so we can report them, even if they can't be handled.
 	 */
-	val = BIT(BUS_ERROR);
-	val |= BIT(CMD_FIFO_OVRFLOW);
-	val |= BIT(MCS_STACK_OVRFLOW);
+	val = BUS_ERROR;
+	val |= CMD_FIFO_OVRFLOW;
+	val |= MCS_STACK_OVRFLOW;
 	iowrite32(val, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
-	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | BIT(GSI_GENERAL));
+	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | GSI_GENERAL);
 }
 
 /* Disable all GSI interrupt types */
@@ -1195,15 +1195,15 @@ static void gsi_isr_glob_ee(struct gsi *gsi)
 
 	val = ioread32(gsi->virt + GSI_CNTXT_GLOB_IRQ_STTS_OFFSET);
 
-	if (val & BIT(ERROR_INT))
+	if (val & ERROR_INT)
 		gsi_isr_glob_err(gsi);
 
 	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_CLR_OFFSET);
 
-	val &= ~BIT(ERROR_INT);
+	val &= ~ERROR_INT;
 
-	if (val & BIT(GP_INT1)) {
-		val ^= BIT(GP_INT1);
+	if (val & GP_INT1) {
+		val ^= GP_INT1;
 		gsi_isr_gp_int1(gsi);
 	}
 
@@ -1264,19 +1264,19 @@ static irqreturn_t gsi_isr(int irq, void *dev_id)
 			intr_mask ^= gsi_intr;
 
 			switch (gsi_intr) {
-			case BIT(GSI_CH_CTRL):
+			case GSI_CH_CTRL:
 				gsi_isr_chan_ctrl(gsi);
 				break;
-			case BIT(GSI_EV_CTRL):
+			case GSI_EV_CTRL:
 				gsi_isr_evt_ctrl(gsi);
 				break;
-			case BIT(GSI_GLOB_EE):
+			case GSI_GLOB_EE:
 				gsi_isr_glob_ee(gsi);
 				break;
-			case BIT(GSI_IEOB):
+			case GSI_IEOB:
 				gsi_isr_ieob(gsi);
 				break;
-			case BIT(GSI_GENERAL):
+			case GSI_GENERAL:
 				gsi_isr_general(gsi);
 				break;
 			default:
@@ -1654,7 +1654,7 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	 * channel), and only from this function.  So we enable the GP_INT1
 	 * IRQ type here, and disable it again after the command completes.
 	 */
-	val = BIT(ERROR_INT) | BIT(GP_INT1);
+	val = ERROR_INT | GP_INT1;
 	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 
 	/* First zero the result code field */
@@ -1672,7 +1672,7 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	timeout = !gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val);
 
 	/* Disable the GP_INT1 IRQ type again */
-	iowrite32(BIT(ERROR_INT), gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	iowrite32(ERROR_INT, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 
 	if (!timeout)
 		return gsi->result;
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index e65f2f055cfff..6af70b0b3a6a5 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -299,15 +299,25 @@ enum gsi_iram_size {
 #define GSI_CNTXT_TYPE_IRQ_MSK_OFFSET \
 			(0x0001f088 + 0x4000 * GSI_EE_AP)
 
-/* Values here are bit positions in the TYPE_IRQ and TYPE_IRQ_MSK registers */
+/**
+ * enum gsi_irq_type_id: GSI IRQ types
+ * @GSI_CH_CTRL:		Channel allocation, deallocation, etc.
+ * @GSI_EV_CTRL:		Event ring allocation, deallocation, etc.
+ * @GSI_GLOB_EE:		Global/general event
+ * @GSI_IEOB:			Transfer (TRE) completion
+ * @GSI_INTER_EE_CH_CTRL:	Remote-issued stop/reset (unused)
+ * @GSI_INTER_EE_EV_CTRL:	Remote-issued event reset (unused)
+ * @GSI_GENERAL:		General hardware event (bus error, etc.)
+ */
 enum gsi_irq_type_id {
-	GSI_CH_CTRL		= 0x0,	/* channel allocation, etc.  */
-	GSI_EV_CTRL		= 0x1,	/* event ring allocation, etc. */
-	GSI_GLOB_EE		= 0x2,	/* global/general event */
-	GSI_IEOB		= 0x3,	/* TRE completion */
-	GSI_INTER_EE_CH_CTRL	= 0x4,	/* remote-issued stop/reset (unused) */
-	GSI_INTER_EE_EV_CTRL	= 0x5,	/* remote-issued event reset (unused) */
-	GSI_GENERAL		= 0x6,	/* general-purpose event */
+	GSI_CH_CTRL				= BIT(0),
+	GSI_EV_CTRL				= BIT(1),
+	GSI_GLOB_EE				= BIT(2),
+	GSI_IEOB				= BIT(3),
+	GSI_INTER_EE_CH_CTRL			= BIT(4),
+	GSI_INTER_EE_EV_CTRL			= BIT(5),
+	GSI_GENERAL				= BIT(6),
+	/* IRQ types 7-31 (and their bit values) are reserved */
 };
 
 #define GSI_CNTXT_SRC_CH_IRQ_OFFSET \
@@ -343,12 +353,14 @@ enum gsi_irq_type_id {
 			(0x0001f108 + 0x4000 * GSI_EE_AP)
 #define GSI_CNTXT_GLOB_IRQ_CLR_OFFSET \
 			(0x0001f110 + 0x4000 * GSI_EE_AP)
-/* Values here are bit positions in the GLOB_IRQ_* registers */
+
+/** enum gsi_global_irq_id: Global GSI interrupt events */
 enum gsi_global_irq_id {
-	ERROR_INT				= 0x0,
-	GP_INT1					= 0x1,
-	GP_INT2					= 0x2,
-	GP_INT3					= 0x3,
+	ERROR_INT				= BIT(0),
+	GP_INT1					= BIT(1),
+	GP_INT2					= BIT(2),
+	GP_INT3					= BIT(3),
+	/* Global IRQ types 4-31 (and their bit values) are reserved */
 };
 
 #define GSI_CNTXT_GSI_IRQ_STTS_OFFSET \
@@ -357,12 +369,14 @@ enum gsi_global_irq_id {
 			(0x0001f120 + 0x4000 * GSI_EE_AP)
 #define GSI_CNTXT_GSI_IRQ_CLR_OFFSET \
 			(0x0001f128 + 0x4000 * GSI_EE_AP)
-/* Values here are bit positions in the (general) GSI_IRQ_* registers */
-enum gsi_general_id {
-	BREAK_POINT				= 0x0,
-	BUS_ERROR				= 0x1,
-	CMD_FIFO_OVRFLOW			= 0x2,
-	MCS_STACK_OVRFLOW			= 0x3,
+
+/** enum gsi_general_irq_id: GSI general IRQ conditions */
+enum gsi_general_irq_id {
+	BREAK_POINT				= BIT(0),
+	BUS_ERROR				= BIT(1),
+	CMD_FIFO_OVRFLOW			= BIT(2),
+	MCS_STACK_OVRFLOW			= BIT(3),
+	/* General IRQ types 4-31 (and their bit values) are reserved */
 };
 
 #define GSI_CNTXT_INTSET_OFFSET \
-- 
2.34.1

