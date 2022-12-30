Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3E7659E1C
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 00:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbiL3XXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 18:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbiL3XWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 18:22:47 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B601DDD3
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 15:22:41 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id o13so12077520ilc.7
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 15:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=25pBUtrT1XiV3gX50trdZQF7DviwuSyPLPkde8po6zE=;
        b=E0JZ88iBO8dIMiyDZgV2f3Ta5893v6HdzLJZvj4IHdoC0mPBYmxK78JT5vpGFuNGGQ
         KxcLb1saMJG5Yb71HlwJydIyn97Y9Fa5iEuXnCxJqMRhABAjmdlWAuZzbPxjDrNRzRa1
         TLqKgpHkN1RuuDNEM4Mi0OrOf82ZAtEzo0rh55XmdRTig47EV0u5F7l4Dxs5jd3H51vq
         y23M5KWwvN2LjG+UwfFyhVtV94qfPNQ1Ts7+eTA3Q81Oz/CTqYhn9GHVV1dfmIaIMGQe
         iQTipTj53kOAa0Eeqbl7zqr+OmZq3+J2dtxPT8vnGUYwEsWdZ74mgs+y9nXCa0COfVak
         6S5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=25pBUtrT1XiV3gX50trdZQF7DviwuSyPLPkde8po6zE=;
        b=4Lw+qiy/fMLcnIXFKfwAsclHyb9kyJWK+u15Rl6LIor25OaV9te38sFF7XwSxB3Qia
         lH4/wuK/3Vi8NLSdjvSz74dusd8VKN9Cp+lsWtNhk2lhxQBzP3gaN0mV1RU3Pcnx1YEV
         9M3QazVZtKySemKs8UazKo0XbVrVhYyiiuT+vqb1CFgDyZZeqUo/o50k/cPbbcckOyZ6
         hI0a838WZW18riIwGeEAb/1UPTzM9dPqTaxRXWMR6L9DF1RsuUkh8ZDlILStsp87bwm5
         UOLpoNt5vXGaKoSpfDfzwHhzwiEauiLpAQv77Xp/gG03N+h+lIo8N5Gv5/WgwMVbFluo
         mwIQ==
X-Gm-Message-State: AFqh2krI/6gPYZLRUAPE760BCmBNymhz5QQGar0mwCUdviOeA7aQYQ1w
        iyDegvowSLS1DwUU0rh4f+GS8Q==
X-Google-Smtp-Source: AMrXdXuTHFAs3nyjnITnt9LaOIbfJafXJakYiMb2bBzFUekT87v98SPg+IhTDRV1fZNx3B95QA+mdQ==
X-Received: by 2002:a92:cc8b:0:b0:304:bf1c:559a with SMTP id x11-20020a92cc8b000000b00304bf1c559amr22444308ilo.11.1672442560471;
        Fri, 30 Dec 2022 15:22:40 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co18-20020a0566383e1200b0038a53fb3911sm7170558jab.97.2022.12.30.15.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 15:22:40 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: don't maintain IPA interrupt handler array
Date:   Fri, 30 Dec 2022 17:22:30 -0600
Message-Id: <20221230232230.2348757-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221230232230.2348757-1-elder@linaro.org>
References: <20221230232230.2348757-1-elder@linaro.org>
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

