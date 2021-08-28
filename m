Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E07D3FA6F8
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 19:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhH1RTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 13:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhH1RS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 13:18:58 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E20C0613D9
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 10:18:07 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id h1so17442226ljl.9
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 10:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZXI2en2FpO56VmbTeLm1+JipCE8ULCAYjbhwip5qLZ0=;
        b=hvWE2eXExRvPfs7okKuf18YhH/yeTHDrP0yKn3lNm/w+5+sUDpMVoKON2Gd4Nl9dzt
         antEJyF5qB2Pj/Jmu9wQbHIAgVt/NDfs7dTHY7ghZ5mvUbi5uSjvPIRk3trNrxoozfhF
         GjiXm0oc+1lRyaXCfVOX/enoCNponcZVRRCErDJcnyAJ+gYQaA+AQ3DiHarg1gFcVUab
         oK3IaWBqjrJ8UKT7MfmTMYlTnVX5AA36MZPXRi5atQYKHoXwFoTEOpUq3nhBSkNW+75b
         bMGdW8pn5N3p+fT6iOHLA/w8PUSMGbN9kWUzRf3hQdvlC4apy5TPL6ib0wCm9o6f/TxP
         yGYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZXI2en2FpO56VmbTeLm1+JipCE8ULCAYjbhwip5qLZ0=;
        b=ZZ3EAAQ66WnqVhHfpRU7VHXhzTxuETkMBpLBBuLzX8lnaaxQACKWUnY2vWo/kp9rV/
         iItwLsCx8DrooiISKPCaqMKH2GH50oA3B+XQNs7Z8XFQ3cThdxrn5JgQPO5weHByTgYv
         0iWDfIiGZTCslzbDo9j837l8C9YQXEs/TjGIlYp9PS1BqGmY/KC4tGPQys9bzxXzvxbU
         oDvOg8TtsfdkkO9MGSvlIfcpDrDEwlp4WeXw1fAUIEgnUoRYrSWvcn/oMCyNAghSqsIt
         FFRi6PtdUNNzYFEkh7zckBunkDjdtzHmutcBhJKLsIt7fN8pMKhfQK4DWooHsCkdB/EQ
         KYUg==
X-Gm-Message-State: AOAM532+ZThwNfhXF88qkFSm4BiFDaekrgYTJf5vhHLQUqJnRi4g+jgU
        DBjLB9f7pSAF4ZS7UW7O0nXCWHJYVGhQ4g==
X-Google-Smtp-Source: ABdhPJwAy/1JHB0hi5rrNcH+rcpqpxqH0/u2hlxKxQ49hnnmsXVO3XGCTLu+I6rcheIFMlmQ1S7ZpA==
X-Received: by 2002:a2e:99c8:: with SMTP id l8mr13133242ljj.178.1630171086161;
        Sat, 28 Aug 2021 10:18:06 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p1sm202195lfo.255.2021.08.28.10.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 10:18:05 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next 3/5 v3] ixp4xx_eth: Stop referring to GPIOs
Date:   Sat, 28 Aug 2021 19:15:46 +0200
Message-Id: <20210828171548.143057-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828171548.143057-1-linus.walleij@linaro.org>
References: <20210828171548.143057-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is being passed interrupts, then looking up the
same interrupts as GPIOs a second time to convert them into
interrupts and set properties on them.

This is pointless: the GPIO and irqchip APIs of a GPIO chip
are orthogonal. Just request the interrupts and be done
with it, drop reliance on any GPIO functions or definitions.

Use devres-managed functions and add a small devress quirk
to unregister the clock as well and we can rely on devres
to handle all the resources and cut down a bunch of
boilerplate in the process.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 84 ++++++++----------------
 1 file changed, 28 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 466f233edd21..c7ff150bf23f 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -7,7 +7,6 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <linux/gpio.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -23,8 +22,6 @@
 
 #define DRIVER		"ptp_ixp46x"
 #define N_EXT_TS	2
-#define MASTER_GPIO	8
-#define SLAVE_GPIO	7
 
 struct ixp_clock {
 	struct ixp46x_ts_regs *regs;
@@ -245,38 +242,6 @@ static const struct ptp_clock_info ptp_ixp_caps = {
 
 static struct ixp_clock ixp_clock;
 
-static int setup_interrupt(int gpio)
-{
-	int irq;
-	int err;
-
-	err = gpio_request(gpio, "ixp4-ptp");
-	if (err)
-		return err;
-
-	err = gpio_direction_input(gpio);
-	if (err)
-		return err;
-
-	irq = gpio_to_irq(gpio);
-	if (irq < 0)
-		return irq;
-
-	err = irq_set_irq_type(irq, IRQF_TRIGGER_FALLING);
-	if (err) {
-		pr_err("cannot set trigger type for irq %d\n", irq);
-		return err;
-	}
-
-	err = request_irq(irq, isr, 0, DRIVER, &ixp_clock);
-	if (err) {
-		pr_err("request_irq failed for irq %d\n", irq);
-		return err;
-	}
-
-	return irq;
-}
-
 int ixp46x_ptp_find(struct ixp46x_ts_regs *__iomem *regs, int *phc_index)
 {
 	*regs = ixp_clock.regs;
@@ -289,18 +254,20 @@ int ixp46x_ptp_find(struct ixp46x_ts_regs *__iomem *regs, int *phc_index)
 }
 EXPORT_SYMBOL_GPL(ixp46x_ptp_find);
 
-static int ptp_ixp_remove(struct platform_device *pdev)
+/* Called from the registered devm action */
+static void ptp_ixp_unregister_action(void *d)
 {
-	free_irq(ixp_clock.master_irq, &ixp_clock);
-	free_irq(ixp_clock.slave_irq, &ixp_clock);
-	ptp_clock_unregister(ixp_clock.ptp_clock);
-	ixp_clock.ptp_clock = NULL;
+	struct ptp_clock *ptp_clock = d;
 
-	return 0;
+	ptp_clock_unregister(ptp_clock);
+	ixp_clock.ptp_clock = NULL;
 }
 
 static int ptp_ixp_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
+	int ret;
+
 	ixp_clock.regs = devm_platform_ioremap_resource(pdev, 0);
 	ixp_clock.master_irq = platform_get_irq(pdev, 0);
 	ixp_clock.slave_irq = platform_get_irq(pdev, 1);
@@ -315,34 +282,39 @@ static int ptp_ixp_probe(struct platform_device *pdev)
 	if (IS_ERR(ixp_clock.ptp_clock))
 		return PTR_ERR(ixp_clock.ptp_clock);
 
+	ret = devm_add_action_or_reset(dev, ptp_ixp_unregister_action,
+				       ixp_clock.ptp_clock);
+	if (ret) {
+		dev_err(dev, "failed to install clock removal handler\n");
+		return ret;
+	}
+
 	__raw_writel(DEFAULT_ADDEND, &ixp_clock.regs->addend);
 	__raw_writel(1, &ixp_clock.regs->trgt_lo);
 	__raw_writel(0, &ixp_clock.regs->trgt_hi);
 	__raw_writel(TTIPEND, &ixp_clock.regs->event);
 
-	if (ixp_clock.master_irq != setup_interrupt(MASTER_GPIO)) {
-		pr_err("failed to setup gpio %d as irq\n", MASTER_GPIO);
-		goto no_master;
-	}
-	if (ixp_clock.slave_irq != setup_interrupt(SLAVE_GPIO)) {
-		pr_err("failed to setup gpio %d as irq\n", SLAVE_GPIO);
-		goto no_slave;
-	}
+	ret = devm_request_irq(dev, ixp_clock.master_irq, isr,
+			       0, DRIVER, &ixp_clock);
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "request_irq failed for irq %d\n",
+				     ixp_clock.master_irq);
+
+	ret = devm_request_irq(dev, ixp_clock.slave_irq, isr,
+			       0, DRIVER, &ixp_clock);
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "request_irq failed for irq %d\n",
+				     ixp_clock.slave_irq);
 
 	return 0;
-no_slave:
-	free_irq(ixp_clock.master_irq, &ixp_clock);
-no_master:
-	ptp_clock_unregister(ixp_clock.ptp_clock);
-	ixp_clock.ptp_clock = NULL;
-	return -ENODEV;
 }
 
 static struct platform_driver ptp_ixp_driver = {
 	.driver.name = "ptp-ixp46x",
 	.driver.suppress_bind_attrs = true,
 	.probe = ptp_ixp_probe,
-	.remove = ptp_ixp_remove,
 };
 module_platform_driver(ptp_ixp_driver);
 
-- 
2.31.1

