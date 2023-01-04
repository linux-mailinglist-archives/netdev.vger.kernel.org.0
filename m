Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84F665DB97
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239932AbjADRwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbjADRwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:52:45 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DFB33D51
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:52:40 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p66so18408145iof.1
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 09:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4WtVwRcqcCUgmYfEzecLg1NkgyQK2BLzDcfIQJWkbQ=;
        b=h8gnm6sju51pnbVTrHG7dJ3fS0YGSSBjHduqzBKj7naghh/yHwuLG/OcorWd/hg/iI
         zAzVEhRojnlDUzHZgLq6J9qqivIm6QBOBR2H/lpci2TcI6u/7iU625Pm1MfE9dkYTCl3
         uleCDGWgBPyI4lW1Pc7dnmz1iLic/ZgoSOLJXzIAUaflXCi7Yxhzx7YLEoy56lyEPM4L
         Oi7FYL6Ph8n/LTSjOMqXUj/GKxtoIH+1y9qO2LVYUj6D3Ot047MhzjGumq0HD50Md2m3
         7sXd5nI9UfyxTfMYOVLIOz/+B9XxqeOoaDWjCOECf1PSZG1bcgKDN+ToSpZJ4i4/zNh+
         wZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K4WtVwRcqcCUgmYfEzecLg1NkgyQK2BLzDcfIQJWkbQ=;
        b=FxcIvQ5/hk5kQuYFwcSwHNFwoqoQ5AWMeYE1pcLI9+GJA2FsqP/yqOC6cpRd20d+tY
         07qQnHyYbOSGHi8Pxc02fHQ05FWkoPbQRgw9rL79iT7ggJIP9M03qXUNi7cu+6WZ2Q05
         st6t3TO1zHrHZXaCQKfBZZ7o3JqCM7cW5sAUEA8Zi8sf2TW3ZcAMoLfUqiJYorPRgd5y
         FwtKqDpicyjIZh3Wvn4tJBdbR5nVp2wTWhZA/ybv0ecrtBNqhGvxZ76X3ZD5I8flh5sA
         9fZ6pBOqnV/SmmvkhqCkIQpb8WbQ7ynlxNQuon6iE+tClClcv3UhnvbnKAhXiiX0EF1q
         bqxg==
X-Gm-Message-State: AFqh2kp9XmAZ4mPG9Cdecsofl+cX1atJ/5ueCumz3x84mlOA/xa8aD8J
        4NFHy8sCVrirucqTjQQlogZDfw==
X-Google-Smtp-Source: AMrXdXsnEVsfLtfJQKG0qG3L9mvNdiI6gL1E8qt+Cxi9rD5msU3bhUQQ2dX6QVIHyuhPhwPCBpcQsA==
X-Received: by 2002:a5e:a519:0:b0:6dc:30bd:ed81 with SMTP id 25-20020a5ea519000000b006dc30bded81mr31254368iog.20.1672854759828;
        Wed, 04 Jan 2023 09:52:39 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id u3-20020a02cbc3000000b00375783003fcsm10872304jaq.136.2023.01.04.09.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:52:39 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/6] net: ipa: introduce ipa_interrupt_enable()
Date:   Wed,  4 Jan 2023 11:52:29 -0600
Message-Id: <20230104175233.2862874-3-elder@linaro.org>
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

