Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1100659E14
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 00:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbiL3XWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 18:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiL3XWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 18:22:39 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA2F1D0DD
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 15:22:37 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id d10so12068015ilc.12
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 15:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLNS1jPjRsNhBYA/KqVgb16Kll0yMpBx8G2zVP5MVaM=;
        b=RY25bn771moxhyGB8j59tS5rFfUKBjbENFEaSk/EJZimcttEKzdxemHNjZ1wIr++Tv
         emzvzcg5ketdJl8xF4h76GWBR7GvYN+5mevSo7xqUwTaHWrIQOrd0FxsqCQK2W+8Efxi
         uulwSJd78bpwzh4/BPcJAheCv4IMuZJYyi7ElysidEut68388vUVoHnH7wHK4Pz/MJeK
         eq0AHEQ9/f5Hm7P5XLfjGiWWgl4U3Jazs0Hy2+8bc7BWhYtOEu0WGY8onmOfivGa0XTN
         1S01iJ8qzUyBqxz/X8wuOIBVdnL+xaP+47vq20/oF5BPydJLBZbIGAQQClGmYJARpvnD
         cIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jLNS1jPjRsNhBYA/KqVgb16Kll0yMpBx8G2zVP5MVaM=;
        b=FVqWdbn3SabYpvPQcdicMtAne1l1FaRYJU/Tt4sqcWNDxACHsWXjRj2SBCfkfwaGBF
         QsanE5fOY5KPxHbAtrBNtNCyygUVN+BuZGzaC5Ho3a533NqbMEuyrdex5RXh23s6G00K
         TOFEYNMQ5EKPybvLeXClrXFT+l/8/BD+4YDUvzj5SvnVCM+xYWI75YWVbmwZcDiDsQFg
         otD92iWvFTfIMUqbN+1EigYWrEr3G0O7s4dpNNpYGPVJBBB78O7cuHB5M5YZPxQXefIE
         FNx70VShUc/w1lfD4q5VSAeTcV3qp1QS6q684ywE8yvGt+uTrOlI7N/MndtvGXLs7Rnr
         95mw==
X-Gm-Message-State: AFqh2kqAlM+ZMFRaWCBxWf3KYkTHc/9H6Kz3GfxdzfRBGsSJK/57YWgD
        26EW/RANWzWkZWTPHPA96Pe3Mw==
X-Google-Smtp-Source: AMrXdXtg3zmJHOHKF5bOxIIvWLS1v7cSxzS+mNeBrzTt4gXtqrZzaKq55DZIR7sjGl+6NUlpvrg9Dg==
X-Received: by 2002:a92:d28c:0:b0:305:e0e1:56c5 with SMTP id p12-20020a92d28c000000b00305e0e156c5mr23058394ilp.19.1672442557115;
        Fri, 30 Dec 2022 15:22:37 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co18-20020a0566383e1200b0038a53fb3911sm7170558jab.97.2022.12.30.15.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 15:22:36 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: enable IPA interrupt handlers separate from registration
Date:   Fri, 30 Dec 2022 17:22:27 -0600
Message-Id: <20221230232230.2348757-4-elder@linaro.org>
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

Expose ipa_interrupt_enable() and have functions that register
IPA interrupt handlers enable them directly, rather than having the
registration process do that.  Do the same for disabling IPA
interrupt handlers.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.c |  8 ++------
 drivers/net/ipa/ipa_interrupt.h | 14 ++++++++++++++
 drivers/net/ipa/ipa_power.c     |  6 +++++-
 drivers/net/ipa/ipa_uc.c        |  4 ++++
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 7b7388c14806f..87f4b94d02a3f 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -135,7 +135,7 @@ static void ipa_interrupt_enabled_update(struct ipa *ipa)
 }
 
 /* Enable an IPA interrupt type */
-static void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
+void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
 {
 	/* Update the IPA interrupt mask to enable it */
 	ipa->interrupt->enabled |= BIT(ipa_irq);
@@ -143,7 +143,7 @@ static void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
 }
 
 /* Disable an IPA interrupt type */
-static void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
+void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
 {
 	/* Update the IPA interrupt mask to disable it */
 	ipa->interrupt->enabled &= ~BIT(ipa_irq);
@@ -232,8 +232,6 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 		return;
 
 	interrupt->handler[ipa_irq] = handler;
-
-	ipa_interrupt_enable(interrupt->ipa, ipa_irq);
 }
 
 /* Remove the handler for an IPA interrupt type */
@@ -243,8 +241,6 @@ ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
 		return;
 
-	ipa_interrupt_disable(interrupt->ipa, ipa_irq);
-
 	interrupt->handler[ipa_irq] = NULL;
 }
 
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index f31fd9965fdc6..5f7d2e90ea337 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -85,6 +85,20 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt);
  */
 void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
 
+/**
+ * ipa_interrupt_enable() - Enable an IPA interrupt type
+ * @ipa:	IPA pointer
+ * @ipa_irq:	IPA interrupt ID
+ */
+void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq);
+
+/**
+ * ipa_interrupt_disable() - Disable an IPA interrupt type
+ * @ipa:	IPA pointer
+ * @ipa_irq:	IPA interrupt ID
+ */
+void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq);
+
 /**
  * ipa_interrupt_config() - Configure the IPA interrupt framework
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index 8420f93128a26..9148d606d5fc2 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -337,10 +337,13 @@ int ipa_power_setup(struct ipa *ipa)
 
 	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_TX_SUSPEND,
 			  ipa_suspend_handler);
+	ipa_interrupt_enable(ipa, IPA_IRQ_TX_SUSPEND);
 
 	ret = device_init_wakeup(&ipa->pdev->dev, true);
-	if (ret)
+	if (ret) {
+		ipa_interrupt_disable(ipa, IPA_IRQ_TX_SUSPEND);
 		ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
+	}
 
 	return ret;
 }
@@ -348,6 +351,7 @@ int ipa_power_setup(struct ipa *ipa)
 void ipa_power_teardown(struct ipa *ipa)
 {
 	(void)device_init_wakeup(&ipa->pdev->dev, false);
+	ipa_interrupt_disable(ipa, IPA_IRQ_TX_SUSPEND);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
 }
 
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 0a890b44c09e1..af541758d047f 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -187,7 +187,9 @@ void ipa_uc_config(struct ipa *ipa)
 	ipa->uc_powered = false;
 	ipa->uc_loaded = false;
 	ipa_interrupt_add(interrupt, IPA_IRQ_UC_0, ipa_uc_interrupt_handler);
+	ipa_interrupt_enable(ipa, IPA_IRQ_UC_0);
 	ipa_interrupt_add(interrupt, IPA_IRQ_UC_1, ipa_uc_interrupt_handler);
+	ipa_interrupt_enable(ipa, IPA_IRQ_UC_1);
 }
 
 /* Inverse of ipa_uc_config() */
@@ -195,7 +197,9 @@ void ipa_uc_deconfig(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 
+	ipa_interrupt_disable(ipa, IPA_IRQ_UC_1);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
+	ipa_interrupt_disable(ipa, IPA_IRQ_UC_0);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
 	if (ipa->uc_loaded)
 		ipa_power_retention(ipa, false);
-- 
2.34.1

