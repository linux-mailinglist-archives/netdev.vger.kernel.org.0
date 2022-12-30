Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77291659E10
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 00:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbiL3XWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 18:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235718AbiL3XWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 18:22:39 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92F01D0E9
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 15:22:38 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id d123so11809146iof.6
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 15:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/QwLXlyTB2wFg+f6fFku0I75a5v4iUbGFGBGgx1ehZU=;
        b=Hm/2P/6UQt95HbAVFv1sCJXkTom3AbsammWHPMUG40G54OIgo/cqYR6oXISj+b4q/E
         LEllnhOipFjtKw3vVMwA/4UWuq/QgXonkOyHF3CXsO7uhj/QqZCllWF+gvdQPKJsfaWQ
         Ftv7BtQ/D/RTcpVQNciTyc+OrXwPNNAR/rjh7eT0rHOXkDJAlEoj5AkHU3+nezzWhKYU
         +7NyRTcDqLVgWJNkJCvO+ZB7VQ/E3SIkIwF6SKy8YY3Ac74iyZbBQ2Wlaw2g1os9JCg/
         I8j+ZGuCigaCvXArs9FOCSL9nG9Axldnblge5aDsL2b/ZW+b0Iodq4Q0mAmnMtnzArS2
         8EQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/QwLXlyTB2wFg+f6fFku0I75a5v4iUbGFGBGgx1ehZU=;
        b=DzbvpMDOs1v0g+7eK+wCBKm/Z+AQaT9f8WRyplzgJh1d3CNkP7EFBsCuK1ShHRYf3y
         YZp6uv8ILmyJTO74QSNB340rIDvgucALwFD0Kas3jjQkCHhhgqn3wPEtQKcYmkwk1Zgk
         RXRafXsDSzl1wb4ls432HI4GWxgg1dYdw6ldMB5GbqgB0HJzLhQi1yuSkDkpcRPKbHua
         Oidgw98kLxXZ5RqUbTP1sPuz0o/0dKJ7YvLs2NMCrbYVuHnL9WqtVDvNONfUnfnZb6WI
         GrK+9+lLMJAifn49NaKYs04j0L3UX0KElmC04pgnHTx3cV/aTaI5pAYvbbSGYGUuZW3z
         WexA==
X-Gm-Message-State: AFqh2kq5VTXPYAZQSY1shWuPWSg5W8QTw3Nro/QTUJ7RC6gVRyjXkxmC
        z+f2RZ22alpZ4uZjWRZ0Dty2Tg==
X-Google-Smtp-Source: AMrXdXu+YeBztMH+Q3qXIzekNBvvKfknXvWCruTAa/AdlVS1m4dMccVfiveGyeTatllaczAPr2zQKQ==
X-Received: by 2002:a5d:8b11:0:b0:6df:de92:91ab with SMTP id k17-20020a5d8b11000000b006dfde9291abmr22002441ion.10.1672442558277;
        Fri, 30 Dec 2022 15:22:38 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co18-20020a0566383e1200b0038a53fb3911sm7170558jab.97.2022.12.30.15.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 15:22:38 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: register IPA interrupt handlers directly
Date:   Fri, 30 Dec 2022 17:22:28 -0600
Message-Id: <20221230232230.2348757-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221230232230.2348757-1-elder@linaro.org>
References: <20221230232230.2348757-1-elder@linaro.org>
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

Declare the microcontroller IPA interrupt handler publicly, and
assign it directly in ipa_interrupt_config().  Make the SUSPEND IPA
interrupt handler public, and rename it ipa_power_suspend_handler().
Assign it directly in ipa_interrupt_config() as well.

This makes it unnecessary to do this in ipa_interrupt_add().  Make
similar changes for removing IPA interrupt handlers.

The next two patches will finish the cleanup, removing the
add/remove functions and the handler array entirely.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.c | 16 ++++++++--------
 drivers/net/ipa/ipa_power.c     | 14 ++------------
 drivers/net/ipa/ipa_power.h     | 12 ++++++++++++
 drivers/net/ipa/ipa_uc.c        |  2 +-
 drivers/net/ipa/ipa_uc.h        |  8 ++++++++
 5 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 87f4b94d02a3f..f32ac40a79372 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -26,6 +26,8 @@
 #include "ipa.h"
 #include "ipa_reg.h"
 #include "ipa_endpoint.h"
+#include "ipa_power.h"
+#include "ipa_uc.h"
 #include "ipa_interrupt.h"
 
 /**
@@ -228,20 +230,14 @@ void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt)
 void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 		       enum ipa_irq_id ipa_irq, ipa_irq_handler_t handler)
 {
-	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
-		return;
-
-	interrupt->handler[ipa_irq] = handler;
+	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
 }
 
 /* Remove the handler for an IPA interrupt type */
 void
 ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 {
-	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
-		return;
-
-	interrupt->handler[ipa_irq] = NULL;
+	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
 }
 
 /* Configure the IPA interrupt framework */
@@ -284,6 +280,10 @@ struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa)
 		goto err_free_irq;
 	}
 
+	interrupt->handler[IPA_IRQ_UC_0] = ipa_uc_interrupt_handler;
+	interrupt->handler[IPA_IRQ_UC_1] = ipa_uc_interrupt_handler;
+	interrupt->handler[IPA_IRQ_TX_SUSPEND] = ipa_power_suspend_handler;
+
 	return interrupt;
 
 err_free_irq:
diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index 9148d606d5fc2..4198f8e97e40b 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -202,17 +202,7 @@ u32 ipa_core_clock_rate(struct ipa *ipa)
 	return ipa->power ? (u32)clk_get_rate(ipa->power->core) : 0;
 }
 
-/**
- * ipa_suspend_handler() - Handle the suspend IPA interrupt
- * @ipa:	IPA pointer
- * @irq_id:	IPA interrupt type (unused)
- *
- * If an RX endpoint is suspended, and the IPA has a packet destined for
- * that endpoint, the IPA generates a SUSPEND interrupt to inform the AP
- * that it should resume the endpoint.  If we get one of these interrupts
- * we just wake up the system.
- */
-static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
+void ipa_power_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 {
 	/* To handle an IPA interrupt we will have resumed the hardware
 	 * just to handle the interrupt, so we're done.  If we are in a
@@ -336,7 +326,7 @@ int ipa_power_setup(struct ipa *ipa)
 	int ret;
 
 	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_TX_SUSPEND,
-			  ipa_suspend_handler);
+			  ipa_power_suspend_handler);
 	ipa_interrupt_enable(ipa, IPA_IRQ_TX_SUSPEND);
 
 	ret = device_init_wakeup(&ipa->pdev->dev, true);
diff --git a/drivers/net/ipa/ipa_power.h b/drivers/net/ipa/ipa_power.h
index 896f052e51a1c..3a4c59ea1222b 100644
--- a/drivers/net/ipa/ipa_power.h
+++ b/drivers/net/ipa/ipa_power.h
@@ -10,6 +10,7 @@ struct device;
 
 struct ipa;
 struct ipa_power_data;
+enum ipa_irq_id;
 
 /* IPA device power management function block */
 extern const struct dev_pm_ops ipa_pm_ops;
@@ -47,6 +48,17 @@ void ipa_power_modem_queue_active(struct ipa *ipa);
  */
 void ipa_power_retention(struct ipa *ipa, bool enable);
 
+/**
+ * ipa_power_suspend_handler() - Handler for SUSPEND IPA interrupts
+ * @ipa:	IPA pointer
+ * @irq_id:	IPA interrupt ID (unused)
+ *
+ * If an RX endpoint is suspended, and the IPA has a packet destined for
+ * that endpoint, the IPA generates a SUSPEND interrupt to inform the AP
+ * that it should resume the endpoint.
+ */
+void ipa_power_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id);
+
 /**
  * ipa_power_setup() - Set up IPA power management
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index af541758d047f..6b7d289cfaffa 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -170,7 +170,7 @@ static void ipa_uc_response_hdlr(struct ipa *ipa)
 	}
 }
 
-static void ipa_uc_interrupt_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
+void ipa_uc_interrupt_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 {
 	/* Silently ignore anything unrecognized */
 	if (irq_id == IPA_IRQ_UC_0)
diff --git a/drivers/net/ipa/ipa_uc.h b/drivers/net/ipa/ipa_uc.h
index 8514096e6f36f..85aa0df818c23 100644
--- a/drivers/net/ipa/ipa_uc.h
+++ b/drivers/net/ipa/ipa_uc.h
@@ -7,6 +7,14 @@
 #define _IPA_UC_H_
 
 struct ipa;
+enum ipa_irq_id;
+
+/**
+ * ipa_uc_interrupt_handler() - Handler for microcontroller IPA interrupts
+ * @ipa:	IPA pointer
+ * @irq_id:	IPA interrupt ID
+ */
+void ipa_uc_interrupt_handler(struct ipa *ipa, enum ipa_irq_id irq_id);
 
 /**
  * ipa_uc_config() - Configure the IPA microcontroller subsystem
-- 
2.34.1

