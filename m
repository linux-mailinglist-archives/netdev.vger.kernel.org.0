Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B689465DB9A
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240065AbjADRwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbjADRwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:52:46 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47083B91E
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:52:42 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id q190so18379072iod.10
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 09:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/QwLXlyTB2wFg+f6fFku0I75a5v4iUbGFGBGgx1ehZU=;
        b=xrrxam0XOk7hykrPjRzHHIp0hv6JZmzE2vflvDLE1rjC6SR7Wt19lnE4BCK2OSlqF7
         FRRdK76E2Ii6nVseaiIZ+AuHjnIfYccAj3WkNKPF4YWT0BEXaW0Y7PyRcOY5mYlGSKfJ
         H/cKOaqSxbOuLTratRvGFMmNa/+5p9Rbyu5Zg7Qarg7t2kDj2GxaxIgttXGOKAM5Un8y
         XOzE2XY5ss+E0FmBt1s7i4yju0XWtUdfd9Lshzaq8OUJR9n/dL0I/z/UM5u4PIwGajmq
         zfZtkvxuA8HHCCp85HCAeGovfy4g7Ank4ZULfl52A/yaMzIQN0L7nmJLZABfrvIt6Riw
         BlRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/QwLXlyTB2wFg+f6fFku0I75a5v4iUbGFGBGgx1ehZU=;
        b=51PLou6JGQVfAv9roAG27ORPuAfNXBHEFEDSIdvqBGeVE+yu6b01EloHp/fEOdpDXg
         e6pQZFKHh6Uu973Yo0AcncQEDpfSqCjKQj3439qpoP+YHf6hqbxFTpphdWY0j+INjxpD
         58lMdWBtOADWG7jN+TcOCU0tmz7Ht/SLfQmUBmjuM8ZnZKcnA4s/6TGcCdCgB+2hsL0R
         cJ0Y1OcCf7Gx81muuRq9975ffyfczm/dU/y6AdjnLI6ou2JWhdEgDPpv6SQeYPcUES6q
         qJEHV8OyAz89MrMs1Z0q/xUEWait4Ha9uT99xYTybCrIcWL6tsJxrYOUYUa4FifHcrta
         cKkA==
X-Gm-Message-State: AFqh2ko93itrv5GIWqWqVE3Cp3fAvMlEijevV5x91bbupx9BYJjoINBp
        bkigFXxKywUBaRwaY2aYUGdRBw==
X-Google-Smtp-Source: AMrXdXsF0KjwJAjuFHYt1tKUJCY6v+AKlNMWeSb48Vf9ENncmKYYEKlkP7MQF87qH7eaHsv1VXPy1g==
X-Received: by 2002:a6b:f70e:0:b0:6e5:d22f:8566 with SMTP id k14-20020a6bf70e000000b006e5d22f8566mr43880789iog.14.1672854762126;
        Wed, 04 Jan 2023 09:52:42 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id u3-20020a02cbc3000000b00375783003fcsm10872304jaq.136.2023.01.04.09.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:52:41 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/6] net: ipa: register IPA interrupt handlers directly
Date:   Wed,  4 Jan 2023 11:52:31 -0600
Message-Id: <20230104175233.2862874-5-elder@linaro.org>
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

