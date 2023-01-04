Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D20165DB9F
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbjADRw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240042AbjADRws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:52:48 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B0033D6E
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:52:45 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id a9so7499273ilk.6
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 09:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=25pBUtrT1XiV3gX50trdZQF7DviwuSyPLPkde8po6zE=;
        b=QzGxU6DyX6RsSixFWY74idDrVdmgX5O5hTxK/7AVVmBGM8s0hr4iCZZLCcjXZoSEMo
         JWzBpHqdSe9BavTDo1C6VPwZBh4yd7D4SkIr78s8hd2a/rUmtt94bbBcBS0wh36WyGl4
         ehpgsPYz5KsFI1zy4JkyPAitdwH94bdRfNRVIoWNP/AghYb1vvAbIevXUkR05tl9LG0R
         ClHyTNVjC3SAHP4TXVib2rWVo2QIUsLINdy0w03Q137gUED3/pE++84/SC0dxTQL/wTJ
         tuMTKY1bb/g08dJk51Lm0QdF2Gh3dqeintbZS179zTj2AOjauGzYOQCJ6dn03yb5ujgc
         Y8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=25pBUtrT1XiV3gX50trdZQF7DviwuSyPLPkde8po6zE=;
        b=dHUZ8hq4jMHFFvcY4FBtnGCyndBPoMK1FeDQMmYUohLrYFu24Yed9rd4NlrQincPxM
         nRMX3VlDVwuKJvzyPcNzpI4Bwq/uAq6OTpG+zxVkw9R3oM9B5W1gbTzX1gHumU3ZR2Rz
         +Y4x582rT0S0TkXZAQDr+VMzjDYBmVL3BwAYgs6Xbi9zr+uLTMrI8QUmewpB0ViWmuuW
         pvlU55yvTPidtWcVgERZ8H1cBg7Nx1kDgq66HmWGWeycuJcKHaPlrkCB88FIEaKBElGC
         7Vh3TGykvmtHiweG39sIcjBT8Pb5q4vy4UhMNtaQ9WXPXtS1MZ6gPvEkWAN5Vj05Jt8N
         5ioA==
X-Gm-Message-State: AFqh2kqVPqSRsj3PH1v1ptSo0bt7e/zGTVgE5l/hbSJgWlMW9OCRFbe6
        vMyQencTeUCPwZBzWw2r6MkL/Q==
X-Google-Smtp-Source: AMrXdXscaRcNn1dXmwqBDLPOSnFWZCgr0sJ8XlokTYwH69p0B0Yzu99xwasjRP87mqb9n0TILekp1Q==
X-Received: by 2002:a92:d06:0:b0:30c:2bb4:a2dc with SMTP id 6-20020a920d06000000b0030c2bb4a2dcmr12940791iln.22.1672854764635;
        Wed, 04 Jan 2023 09:52:44 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id u3-20020a02cbc3000000b00375783003fcsm10872304jaq.136.2023.01.04.09.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:52:44 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/6] net: ipa: don't maintain IPA interrupt handler array
Date:   Wed,  4 Jan 2023 11:52:33 -0600
Message-Id: <20230104175233.2862874-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104175233.2862874-1-elder@linaro.org>
References: <20230104175233.2862874-1-elder@linaro.org>
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

We can call the two IPA interrupt handler functions directly;
there's no need to maintain the array of handler function pointers
any more.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.c | 46 ++++++++++++++-------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index f0a68b0a242c1..5f047b29e6ef0 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -30,54 +30,52 @@
 #include "ipa_uc.h"
 #include "ipa_interrupt.h"
 
-typedef void (*ipa_irq_handler_t)(struct ipa *ipa, enum ipa_irq_id irq_id);
-
 /**
  * struct ipa_interrupt - IPA interrupt information
  * @ipa:		IPA pointer
  * @irq:		Linux IRQ number used for IPA interrupts
  * @enabled:		Mask indicating which interrupts are enabled
- * @handler:		Array of handlers indexed by IPA interrupt ID
  */
 struct ipa_interrupt {
 	struct ipa *ipa;
 	u32 irq;
 	u32 enabled;
-	ipa_irq_handler_t handler[IPA_IRQ_COUNT];
 };
 
-/* Returns true if the interrupt type is associated with the microcontroller */
-static bool ipa_interrupt_uc(struct ipa_interrupt *interrupt, u32 irq_id)
-{
-	return irq_id == IPA_IRQ_UC_0 || irq_id == IPA_IRQ_UC_1;
-}
-
 /* Process a particular interrupt type that has been received */
 static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 irq_id)
 {
-	bool uc_irq = ipa_interrupt_uc(interrupt, irq_id);
 	struct ipa *ipa = interrupt->ipa;
 	const struct ipa_reg *reg;
 	u32 mask = BIT(irq_id);
 	u32 offset;
 
-	/* For microcontroller interrupts, clear the interrupt right away,
-	 * "to avoid clearing unhandled interrupts."
-	 */
 	reg = ipa_reg(ipa, IPA_IRQ_CLR);
 	offset = ipa_reg_offset(reg);
-	if (uc_irq)
+
+	switch (irq_id) {
+	case IPA_IRQ_UC_0:
+	case IPA_IRQ_UC_1:
+		/* For microcontroller interrupts, clear the interrupt right
+		 * away, "to avoid clearing unhandled interrupts."
+		 */
 		iowrite32(mask, ipa->reg_virt + offset);
+		ipa_uc_interrupt_handler(ipa, irq_id);
+		break;
 
-	if (irq_id < IPA_IRQ_COUNT && interrupt->handler[irq_id])
-		interrupt->handler[irq_id](interrupt->ipa, irq_id);
+	case IPA_IRQ_TX_SUSPEND:
+		/* Clearing the SUSPEND_TX interrupt also clears the
+		 * register that tells us which suspended endpoint(s)
+		 * caused the interrupt, so defer clearing until after
+		 * the handler has been called.
+		 */
+		ipa_power_suspend_handler(ipa, irq_id);
+		fallthrough;
 
-	/* Clearing the SUSPEND_TX interrupt also clears the register
-	 * that tells us which suspended endpoint(s) caused the interrupt,
-	 * so defer clearing until after the handler has been called.
-	 */
-	if (!uc_irq)
+	default:	/* Silently ignore (and clear) any other condition */
 		iowrite32(mask, ipa->reg_virt + offset);
+		break;
+	}
 }
 
 /* IPA IRQ handler is threaded */
@@ -268,10 +266,6 @@ struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa)
 		goto err_free_irq;
 	}
 
-	interrupt->handler[IPA_IRQ_UC_0] = ipa_uc_interrupt_handler;
-	interrupt->handler[IPA_IRQ_UC_1] = ipa_uc_interrupt_handler;
-	interrupt->handler[IPA_IRQ_TX_SUSPEND] = ipa_power_suspend_handler;
-
 	return interrupt;
 
 err_free_irq:
-- 
2.34.1

