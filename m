Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AF1659E0C
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 00:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbiL3XWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 18:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbiL3XWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 18:22:38 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8508B1D0F5
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 15:22:36 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id g2so8900493ila.4
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 15:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4WtVwRcqcCUgmYfEzecLg1NkgyQK2BLzDcfIQJWkbQ=;
        b=yR2Hc5lazanlE/E/Zka7pU/a8AlDQgQOVymRxPsg72chP1ZPDjKfOTjM5yKOkLxvhH
         en/BWfpXJlC28tVJVnALRUO41fMi820pw1D4OY39x1ufyYa4TAKCYZNYcBxkSSZOpkfD
         6QEofGFYQP/RFvfNsLitODzGh1PsEyZioSapKhGNOo3yuG9M+8KN4BOKftQq6CiVRCLp
         mSpxVl4NTxurXxAD481XSHegiipvU7eV0g3B1DcswDVder8H2GZNlBgAjnNz7x5Wcnw1
         Gct/bp4+98R9qJm9xuTdAfihtCYhWsJZmfJu1PN+iDJvPEt/AlOQxHeOS+zEiW8hBIlY
         C/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K4WtVwRcqcCUgmYfEzecLg1NkgyQK2BLzDcfIQJWkbQ=;
        b=ONhzox93tLMuUczWKEY+k1E9Vt+kfyw8Wjsg14V+rEdOUBPAinK8FDkSdQaIWZKMW4
         YRL1oUEafVXMlJ1pGr/9TXv4Oogvem9BzCWKztEW+zygH6rjioYp4a3V1KBHftw/tsgJ
         JBGWhvgoyuDFAb/a0ehogcJ4KddqEBeCnZbwPdLiPcU7vWDuk7sJGraw6UiO9Y+JW0Iw
         H26YUDjH0IT7nlLmwOVET7sut7CpIWYwmF16j1qTPK2FPYqe/J+LieMzbBFK3aFj7QKk
         SDxnBQm/YEybpka0nU6aOi1wVeS2IsUnsuufRzVdt5B6GoabGMfNnRsbWnX1B9Z2trxO
         mWKg==
X-Gm-Message-State: AFqh2kpd+a2TpNyWXqR2kabcekcuz4KsWrnPmTxSoeFxbPn6gxSCynv6
        vlFCRWSu8Y3OF3l3Q9vY8jh8Dg==
X-Google-Smtp-Source: AMrXdXsLV4A+gBum9yoI2gfwK4bHonG4xj06Cnj1QR3kD6dP36KOnLkE8QQH4bBdvz7UV/z0kvfZoQ==
X-Received: by 2002:a05:6e02:1ba1:b0:302:c07e:49f8 with SMTP id n1-20020a056e021ba100b00302c07e49f8mr39063946ili.32.1672442555862;
        Fri, 30 Dec 2022 15:22:35 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co18-20020a0566383e1200b0038a53fb3911sm7170558jab.97.2022.12.30.15.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 15:22:35 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: introduce ipa_interrupt_enable()
Date:   Fri, 30 Dec 2022 17:22:26 -0600
Message-Id: <20221230232230.2348757-3-elder@linaro.org>
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

Create new function ipa_interrupt_enable() to encapsulate enabling
one of the IPA interrupt types.  Introduce ipa_interrupt_disable()
to reverse that operation.  Add a helper function to factor out the
common register update used by both.

Use these in ipa_interrupt_add() and ipa_interrupt_remove().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.c | 41 ++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index a49f66efacb87..7b7388c14806f 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -127,6 +127,29 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void ipa_interrupt_enabled_update(struct ipa *ipa)
+{
+	const struct ipa_reg *reg = ipa_reg(ipa, IPA_IRQ_EN);
+
+	iowrite32(ipa->interrupt->enabled, ipa->reg_virt + ipa_reg_offset(reg));
+}
+
+/* Enable an IPA interrupt type */
+static void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
+{
+	/* Update the IPA interrupt mask to enable it */
+	ipa->interrupt->enabled |= BIT(ipa_irq);
+	ipa_interrupt_enabled_update(ipa);
+}
+
+/* Disable an IPA interrupt type */
+static void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
+{
+	/* Update the IPA interrupt mask to disable it */
+	ipa->interrupt->enabled &= ~BIT(ipa_irq);
+	ipa_interrupt_enabled_update(ipa);
+}
+
 /* Common function used to enable/disable TX_SUSPEND for an endpoint */
 static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 					  u32 endpoint_id, bool enable)
@@ -205,36 +228,22 @@ void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt)
 void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 		       enum ipa_irq_id ipa_irq, ipa_irq_handler_t handler)
 {
-	struct ipa *ipa = interrupt->ipa;
-	const struct ipa_reg *reg;
-
 	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
 		return;
 
 	interrupt->handler[ipa_irq] = handler;
 
-	/* Update the IPA interrupt mask to enable it */
-	interrupt->enabled |= BIT(ipa_irq);
-
-	reg = ipa_reg(ipa, IPA_IRQ_EN);
-	iowrite32(interrupt->enabled, ipa->reg_virt + ipa_reg_offset(reg));
+	ipa_interrupt_enable(interrupt->ipa, ipa_irq);
 }
 
 /* Remove the handler for an IPA interrupt type */
 void
 ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 {
-	struct ipa *ipa = interrupt->ipa;
-	const struct ipa_reg *reg;
-
 	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
 		return;
 
-	/* Update the IPA interrupt mask to disable it */
-	interrupt->enabled &= ~BIT(ipa_irq);
-
-	reg = ipa_reg(ipa, IPA_IRQ_EN);
-	iowrite32(interrupt->enabled, ipa->reg_virt + ipa_reg_offset(reg));
+	ipa_interrupt_disable(interrupt->ipa, ipa_irq);
 
 	interrupt->handler[ipa_irq] = NULL;
 }
-- 
2.34.1

