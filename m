Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1D23EBE22
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbhHMWDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235211AbhHMWDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 18:03:08 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4C3C061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:41 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id h9so17686739ljq.8
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZXI2en2FpO56VmbTeLm1+JipCE8ULCAYjbhwip5qLZ0=;
        b=uwLJ1Rww/4GGWF+JXBqePCvIfwXYogT6ALqeIq1uMQx6LuEg02J7F6zL7ZgwaV6+kv
         qINkV3vVllpsUPs0J7AyE/8k6AuJn4C+nsoFF28mRg91+cGUGDc1oYacH0iOCTLRrd2T
         DGjEBtPmXkITKgx0ZEzR5u/WEeD+tx5OSIJ3THdwfAnTFqNVPC+UqfxubqQnATg6YjoV
         mGj7+Zk4giOSL32z4iSvK7fqOWE68gH4kThyl6OT2LlZCa4DLNNdkU13kDfflaPNCdBu
         IOGZTnepAUosWJmfru0+lkfm/L8RJ/9PfEYHx1ZfyooLLbymukvtCqLr9++M/IqmlBeo
         nfzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZXI2en2FpO56VmbTeLm1+JipCE8ULCAYjbhwip5qLZ0=;
        b=pF0urIFW5kv1iOqLnbEluEOU22ps89G5QoyDVg1GaVCKQ7eO70FV92Ky8OVBl0avQ6
         e4Z40Z97fRXMgHkNplUrswiJ3aIwxBaOW82MKb3RqAkYOiro8Bb51qVlIquHJtxtGWe0
         YByC/8NRoW96P0eyfOXPVVZVFrgXn1gUxmATGd6Fo1PzvpS35sbTq/nbXOYmcnKCrKV5
         DgzHXkU3kSAdHs9mqu2lTCubr4dnH17GUZow3H+NbwdnKbKFbgKd5gq+RrPfSTpP364v
         75SbGoBS5KnfGJElpp5J+nFo6mxhKpTNRKHtDHMA9xFE2BhHkT052ooD+Zo2ZvoMr5QX
         yxVQ==
X-Gm-Message-State: AOAM532X88R4f4AvsZI2BqSul+OP+t7DtX3W/oMC98XpxTxpDmSUO40U
        7ttrDHF0gpds82ZkGHZe2PVDxqRsn7xUyw==
X-Google-Smtp-Source: ABdhPJwlMh5JEqZBao6aoS4p6VtwPOmr1WNSawU8FScr8wQwX0kZHHSaGPgvO55zPIuyGtZbe7ayXw==
X-Received: by 2002:a05:651c:4d4:: with SMTP id e20mr3328842lji.130.1628892159509;
        Fri, 13 Aug 2021 15:02:39 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s17sm274912ljp.61.2021.08.13.15.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 15:02:39 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next 4/6 v2] ixp4xx_eth: Stop referring to GPIOs
Date:   Sat, 14 Aug 2021 00:00:09 +0200
Message-Id: <20210813220011.921211-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813220011.921211-1-linus.walleij@linaro.org>
References: <20210813220011.921211-1-linus.walleij@linaro.org>
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

