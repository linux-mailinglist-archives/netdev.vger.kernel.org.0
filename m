Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B5D3EE189
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbhHQAz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbhHQAzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:55:49 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A56C0613A4
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:16 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id c12so17068083ljr.5
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FRhJlspuhr5Q3RAjzuhd5WsagmM/XJE9SdkaJUDZM6w=;
        b=fdUyAwxHnLCAtikwBEBM1kQZ/KTdfUZVby/xjvc0oz84sCO1fRXVf8wMYh0eDH46MI
         hnLfx+VkmOKDWTc6caj3PmQd5iIsTOfxfdUsNln2QzfCr2IC0iyZxukbeOtMVYoMejZb
         pJQJbad63VL5V6LPBtmgYAuJgUv4wQILf5v3mUlkY5pVKc9GqRGAmJNwvRRfA6ZgDOtn
         uPDaK9T8DWuCu/HDbIVmpZcnkvfEBjBzlqVXs9Xk5oskdhSrGyBCHi03nTIP7P3MZwsq
         3uQ4yzmHwAKjCjJc0+PLzQ0bycu7LESwTyjYfSgFx4ZZWMVx242Zdy6A2KeejIKHMd0n
         dDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FRhJlspuhr5Q3RAjzuhd5WsagmM/XJE9SdkaJUDZM6w=;
        b=RincMasFBtZW0W/eBjwHz3KGPPAc/UTJeI9DfQfp9br0mNPPZ7Oy6Cmll5iu4abzuk
         kxsUBjbZaYF1UnT3KuR/GV46mZRIGzAwGwRW2OCxp398mCEGYIEtOMxmu4X8k6CSTFc7
         2yOqi9Fj6dbTd9L0LlwQl0iNgTnpD/zY0NPXb1MmGzTD5aeALAjEfq13nBfHOaZxF2tj
         0fvRrYhirNFnGbcWPhnYVbgQ/NBgeclA1T1ZKs+ffPUTsE94J+V7gICxlIvc8T6hr45/
         dwOB8sy3NSQ3ibijQaTWeb58nv2mbSwNsXUgyRsalUSOCjpRY0byRGBdAuFPw/CiDF5B
         cVEg==
X-Gm-Message-State: AOAM533+aPt2oQzT3rC9y7mkXV8+41YV/R2wSvCXojMjCbVfx5S6UfE6
        Ng1efCUfhHFpq81SLkYjAmJ7LA==
X-Google-Smtp-Source: ABdhPJxTs5QoxsKt8CoEGoLxj8Tx7EmN2XLBfvYLdBTJTU9Eg6vdu8tTkPjB9z2/Vf6240S1i/Rvmg==
X-Received: by 2002:a2e:a225:: with SMTP id i5mr803806ljm.64.1629161714891;
        Mon, 16 Aug 2021 17:55:14 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id z6sm40719lfb.251.2021.08.16.17.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 17:55:14 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH 02/15] pwrseq: port MMC's pwrseq drivers to new pwrseq subsystem
Date:   Tue, 17 Aug 2021 03:54:54 +0300
Message-Id: <20210817005507.1507580-3-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port MMC's all pwrseq drivers to new pwrseq subsystem.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 .../pwrseq}/mmc-pwrseq-emmc.yaml              |   0
 .../pwrseq}/mmc-pwrseq-sd8787.yaml            |   0
 .../pwrseq}/mmc-pwrseq-simple.yaml            |   0
 drivers/mmc/core/Kconfig                      |  32 ----
 drivers/mmc/core/Makefile                     |   3 -
 drivers/mmc/core/pwrseq_emmc.c                | 120 -------------
 drivers/mmc/core/pwrseq_sd8787.c              | 107 ------------
 drivers/mmc/core/pwrseq_simple.c              | 164 ------------------
 drivers/power/pwrseq/Kconfig                  |  32 ++++
 drivers/power/pwrseq/Makefile                 |   4 +
 drivers/power/pwrseq/pwrseq_emmc.c            | 118 +++++++++++++
 drivers/power/pwrseq/pwrseq_sd8787.c          |  97 +++++++++++
 drivers/power/pwrseq/pwrseq_simple.c          | 160 +++++++++++++++++
 13 files changed, 411 insertions(+), 426 deletions(-)
 rename Documentation/devicetree/bindings/{mmc => power/pwrseq}/mmc-pwrseq-emmc.yaml (100%)
 rename Documentation/devicetree/bindings/{mmc => power/pwrseq}/mmc-pwrseq-sd8787.yaml (100%)
 rename Documentation/devicetree/bindings/{mmc => power/pwrseq}/mmc-pwrseq-simple.yaml (100%)
 delete mode 100644 drivers/mmc/core/pwrseq_emmc.c
 delete mode 100644 drivers/mmc/core/pwrseq_sd8787.c
 delete mode 100644 drivers/mmc/core/pwrseq_simple.c
 create mode 100644 drivers/power/pwrseq/pwrseq_emmc.c
 create mode 100644 drivers/power/pwrseq/pwrseq_sd8787.c
 create mode 100644 drivers/power/pwrseq/pwrseq_simple.c

diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml b/Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-emmc.yaml
similarity index 100%
rename from Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml
rename to Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-emmc.yaml
diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml b/Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-sd8787.yaml
similarity index 100%
rename from Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml
rename to Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-sd8787.yaml
diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml b/Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-simple.yaml
similarity index 100%
rename from Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
rename to Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-simple.yaml
diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index ae8b69aee619..cf7df64ce009 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -2,38 +2,6 @@
 #
 # MMC core configuration
 #
-config PWRSEQ_EMMC
-	tristate "HW reset support for eMMC"
-	default y
-	depends on OF
-	help
-	  This selects Hardware reset support aka pwrseq-emmc for eMMC
-	  devices. By default this option is set to y.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called pwrseq_emmc.
-
-config PWRSEQ_SD8787
-	tristate "HW reset support for SD8787 BT + Wifi module"
-	depends on OF && (MWIFIEX || BT_MRVL_SDIO || LIBERTAS_SDIO)
-	help
-	  This selects hardware reset support for the SD8787 BT + Wifi
-	  module. By default this option is set to n.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called pwrseq_sd8787.
-
-config PWRSEQ_SIMPLE
-	tristate "Simple HW reset support for MMC"
-	default y
-	depends on OF
-	help
-	  This selects simple hardware reset support aka pwrseq-simple for MMC
-	  devices. By default this option is set to y.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called pwrseq_simple.
-
 config MMC_BLOCK
 	tristate "MMC block device driver"
 	depends on BLOCK
diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
index 6a907736cd7a..322eb69bd00e 100644
--- a/drivers/mmc/core/Makefile
+++ b/drivers/mmc/core/Makefile
@@ -10,9 +10,6 @@ mmc_core-y			:= core.o bus.o host.o \
 				   sdio_cis.o sdio_io.o sdio_irq.o \
 				   slot-gpio.o regulator.o
 mmc_core-$(CONFIG_OF)		+= pwrseq.o
-obj-$(CONFIG_PWRSEQ_SIMPLE)	+= pwrseq_simple.o
-obj-$(CONFIG_PWRSEQ_SD8787)	+= pwrseq_sd8787.o
-obj-$(CONFIG_PWRSEQ_EMMC)	+= pwrseq_emmc.o
 mmc_core-$(CONFIG_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_MMC_BLOCK)		+= mmc_block.o
 mmc_block-objs			:= block.o queue.o
diff --git a/drivers/mmc/core/pwrseq_emmc.c b/drivers/mmc/core/pwrseq_emmc.c
deleted file mode 100644
index f6dde9edd7a3..000000000000
--- a/drivers/mmc/core/pwrseq_emmc.c
+++ /dev/null
@@ -1,120 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2015, Samsung Electronics Co., Ltd.
- *
- * Author: Marek Szyprowski <m.szyprowski@samsung.com>
- *
- * Simple eMMC hardware reset provider
- */
-#include <linux/delay.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/gpio/consumer.h>
-#include <linux/reboot.h>
-
-#include <linux/mmc/host.h>
-
-#include "pwrseq.h"
-
-struct mmc_pwrseq_emmc {
-	struct mmc_pwrseq pwrseq;
-	struct notifier_block reset_nb;
-	struct gpio_desc *reset_gpio;
-};
-
-#define to_pwrseq_emmc(p) container_of(p, struct mmc_pwrseq_emmc, pwrseq)
-
-static void mmc_pwrseq_emmc_reset(struct mmc_host *host)
-{
-	struct mmc_pwrseq_emmc *pwrseq =  to_pwrseq_emmc(host->pwrseq);
-
-	gpiod_set_value_cansleep(pwrseq->reset_gpio, 1);
-	udelay(1);
-	gpiod_set_value_cansleep(pwrseq->reset_gpio, 0);
-	udelay(200);
-}
-
-static int mmc_pwrseq_emmc_reset_nb(struct notifier_block *this,
-				    unsigned long mode, void *cmd)
-{
-	struct mmc_pwrseq_emmc *pwrseq = container_of(this,
-					struct mmc_pwrseq_emmc, reset_nb);
-	gpiod_set_value(pwrseq->reset_gpio, 1);
-	udelay(1);
-	gpiod_set_value(pwrseq->reset_gpio, 0);
-	udelay(200);
-
-	return NOTIFY_DONE;
-}
-
-static const struct mmc_pwrseq_ops mmc_pwrseq_emmc_ops = {
-	.reset = mmc_pwrseq_emmc_reset,
-};
-
-static int mmc_pwrseq_emmc_probe(struct platform_device *pdev)
-{
-	struct mmc_pwrseq_emmc *pwrseq;
-	struct device *dev = &pdev->dev;
-
-	pwrseq = devm_kzalloc(dev, sizeof(*pwrseq), GFP_KERNEL);
-	if (!pwrseq)
-		return -ENOMEM;
-
-	pwrseq->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
-	if (IS_ERR(pwrseq->reset_gpio))
-		return PTR_ERR(pwrseq->reset_gpio);
-
-	if (!gpiod_cansleep(pwrseq->reset_gpio)) {
-		/*
-		 * register reset handler to ensure emmc reset also from
-		 * emergency_reboot(), priority 255 is the highest priority
-		 * so it will be executed before any system reboot handler.
-		 */
-		pwrseq->reset_nb.notifier_call = mmc_pwrseq_emmc_reset_nb;
-		pwrseq->reset_nb.priority = 255;
-		register_restart_handler(&pwrseq->reset_nb);
-	} else {
-		dev_notice(dev, "EMMC reset pin tied to a sleepy GPIO driver; reset on emergency-reboot disabled\n");
-	}
-
-	pwrseq->pwrseq.ops = &mmc_pwrseq_emmc_ops;
-	pwrseq->pwrseq.dev = dev;
-	pwrseq->pwrseq.owner = THIS_MODULE;
-	platform_set_drvdata(pdev, pwrseq);
-
-	return mmc_pwrseq_register(&pwrseq->pwrseq);
-}
-
-static int mmc_pwrseq_emmc_remove(struct platform_device *pdev)
-{
-	struct mmc_pwrseq_emmc *pwrseq = platform_get_drvdata(pdev);
-
-	unregister_restart_handler(&pwrseq->reset_nb);
-	mmc_pwrseq_unregister(&pwrseq->pwrseq);
-
-	return 0;
-}
-
-static const struct of_device_id mmc_pwrseq_emmc_of_match[] = {
-	{ .compatible = "mmc-pwrseq-emmc",},
-	{/* sentinel */},
-};
-
-MODULE_DEVICE_TABLE(of, mmc_pwrseq_emmc_of_match);
-
-static struct platform_driver mmc_pwrseq_emmc_driver = {
-	.probe = mmc_pwrseq_emmc_probe,
-	.remove = mmc_pwrseq_emmc_remove,
-	.driver = {
-		.name = "pwrseq_emmc",
-		.of_match_table = mmc_pwrseq_emmc_of_match,
-	},
-};
-
-module_platform_driver(mmc_pwrseq_emmc_driver);
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/core/pwrseq_sd8787.c b/drivers/mmc/core/pwrseq_sd8787.c
deleted file mode 100644
index 68a826f1c0a1..000000000000
--- a/drivers/mmc/core/pwrseq_sd8787.c
+++ /dev/null
@@ -1,107 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * pwrseq_sd8787.c - power sequence support for Marvell SD8787 BT + Wifi chip
- *
- * Copyright (C) 2016 Matt Ranostay <matt@ranostay.consulting>
- *
- * Based on the original work pwrseq_simple.c
- *  Copyright (C) 2014 Linaro Ltd
- *  Author: Ulf Hansson <ulf.hansson@linaro.org>
- */
-
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/gpio/consumer.h>
-
-#include <linux/mmc/host.h>
-
-#include "pwrseq.h"
-
-struct mmc_pwrseq_sd8787 {
-	struct mmc_pwrseq pwrseq;
-	struct gpio_desc *reset_gpio;
-	struct gpio_desc *pwrdn_gpio;
-};
-
-#define to_pwrseq_sd8787(p) container_of(p, struct mmc_pwrseq_sd8787, pwrseq)
-
-static void mmc_pwrseq_sd8787_pre_power_on(struct mmc_host *host)
-{
-	struct mmc_pwrseq_sd8787 *pwrseq = to_pwrseq_sd8787(host->pwrseq);
-
-	gpiod_set_value_cansleep(pwrseq->reset_gpio, 1);
-
-	msleep(300);
-	gpiod_set_value_cansleep(pwrseq->pwrdn_gpio, 1);
-}
-
-static void mmc_pwrseq_sd8787_power_off(struct mmc_host *host)
-{
-	struct mmc_pwrseq_sd8787 *pwrseq = to_pwrseq_sd8787(host->pwrseq);
-
-	gpiod_set_value_cansleep(pwrseq->pwrdn_gpio, 0);
-	gpiod_set_value_cansleep(pwrseq->reset_gpio, 0);
-}
-
-static const struct mmc_pwrseq_ops mmc_pwrseq_sd8787_ops = {
-	.pre_power_on = mmc_pwrseq_sd8787_pre_power_on,
-	.power_off = mmc_pwrseq_sd8787_power_off,
-};
-
-static const struct of_device_id mmc_pwrseq_sd8787_of_match[] = {
-	{ .compatible = "mmc-pwrseq-sd8787",},
-	{/* sentinel */},
-};
-MODULE_DEVICE_TABLE(of, mmc_pwrseq_sd8787_of_match);
-
-static int mmc_pwrseq_sd8787_probe(struct platform_device *pdev)
-{
-	struct mmc_pwrseq_sd8787 *pwrseq;
-	struct device *dev = &pdev->dev;
-
-	pwrseq = devm_kzalloc(dev, sizeof(*pwrseq), GFP_KERNEL);
-	if (!pwrseq)
-		return -ENOMEM;
-
-	pwrseq->pwrdn_gpio = devm_gpiod_get(dev, "powerdown", GPIOD_OUT_LOW);
-	if (IS_ERR(pwrseq->pwrdn_gpio))
-		return PTR_ERR(pwrseq->pwrdn_gpio);
-
-	pwrseq->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
-	if (IS_ERR(pwrseq->reset_gpio))
-		return PTR_ERR(pwrseq->reset_gpio);
-
-	pwrseq->pwrseq.dev = dev;
-	pwrseq->pwrseq.ops = &mmc_pwrseq_sd8787_ops;
-	pwrseq->pwrseq.owner = THIS_MODULE;
-	platform_set_drvdata(pdev, pwrseq);
-
-	return mmc_pwrseq_register(&pwrseq->pwrseq);
-}
-
-static int mmc_pwrseq_sd8787_remove(struct platform_device *pdev)
-{
-	struct mmc_pwrseq_sd8787 *pwrseq = platform_get_drvdata(pdev);
-
-	mmc_pwrseq_unregister(&pwrseq->pwrseq);
-
-	return 0;
-}
-
-static struct platform_driver mmc_pwrseq_sd8787_driver = {
-	.probe = mmc_pwrseq_sd8787_probe,
-	.remove = mmc_pwrseq_sd8787_remove,
-	.driver = {
-		.name = "pwrseq_sd8787",
-		.of_match_table = mmc_pwrseq_sd8787_of_match,
-	},
-};
-
-module_platform_driver(mmc_pwrseq_sd8787_driver);
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/core/pwrseq_simple.c b/drivers/mmc/core/pwrseq_simple.c
deleted file mode 100644
index ea4d3670560e..000000000000
--- a/drivers/mmc/core/pwrseq_simple.c
+++ /dev/null
@@ -1,164 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- *  Copyright (C) 2014 Linaro Ltd
- *
- * Author: Ulf Hansson <ulf.hansson@linaro.org>
- *
- *  Simple MMC power sequence management
- */
-#include <linux/clk.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/gpio/consumer.h>
-#include <linux/delay.h>
-#include <linux/property.h>
-
-#include <linux/mmc/host.h>
-
-#include "pwrseq.h"
-
-struct mmc_pwrseq_simple {
-	struct mmc_pwrseq pwrseq;
-	bool clk_enabled;
-	u32 post_power_on_delay_ms;
-	u32 power_off_delay_us;
-	struct clk *ext_clk;
-	struct gpio_descs *reset_gpios;
-};
-
-#define to_pwrseq_simple(p) container_of(p, struct mmc_pwrseq_simple, pwrseq)
-
-static void mmc_pwrseq_simple_set_gpios_value(struct mmc_pwrseq_simple *pwrseq,
-					      int value)
-{
-	struct gpio_descs *reset_gpios = pwrseq->reset_gpios;
-
-	if (!IS_ERR(reset_gpios)) {
-		unsigned long *values;
-		int nvalues = reset_gpios->ndescs;
-
-		values = bitmap_alloc(nvalues, GFP_KERNEL);
-		if (!values)
-			return;
-
-		if (value)
-			bitmap_fill(values, nvalues);
-		else
-			bitmap_zero(values, nvalues);
-
-		gpiod_set_array_value_cansleep(nvalues, reset_gpios->desc,
-					       reset_gpios->info, values);
-
-		kfree(values);
-	}
-}
-
-static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
-{
-	struct mmc_pwrseq_simple *pwrseq = to_pwrseq_simple(host->pwrseq);
-
-	if (!IS_ERR(pwrseq->ext_clk) && !pwrseq->clk_enabled) {
-		clk_prepare_enable(pwrseq->ext_clk);
-		pwrseq->clk_enabled = true;
-	}
-
-	mmc_pwrseq_simple_set_gpios_value(pwrseq, 1);
-}
-
-static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
-{
-	struct mmc_pwrseq_simple *pwrseq = to_pwrseq_simple(host->pwrseq);
-
-	mmc_pwrseq_simple_set_gpios_value(pwrseq, 0);
-
-	if (pwrseq->post_power_on_delay_ms)
-		msleep(pwrseq->post_power_on_delay_ms);
-}
-
-static void mmc_pwrseq_simple_power_off(struct mmc_host *host)
-{
-	struct mmc_pwrseq_simple *pwrseq = to_pwrseq_simple(host->pwrseq);
-
-	mmc_pwrseq_simple_set_gpios_value(pwrseq, 1);
-
-	if (pwrseq->power_off_delay_us)
-		usleep_range(pwrseq->power_off_delay_us,
-			2 * pwrseq->power_off_delay_us);
-
-	if (!IS_ERR(pwrseq->ext_clk) && pwrseq->clk_enabled) {
-		clk_disable_unprepare(pwrseq->ext_clk);
-		pwrseq->clk_enabled = false;
-	}
-}
-
-static const struct mmc_pwrseq_ops mmc_pwrseq_simple_ops = {
-	.pre_power_on = mmc_pwrseq_simple_pre_power_on,
-	.post_power_on = mmc_pwrseq_simple_post_power_on,
-	.power_off = mmc_pwrseq_simple_power_off,
-};
-
-static const struct of_device_id mmc_pwrseq_simple_of_match[] = {
-	{ .compatible = "mmc-pwrseq-simple",},
-	{/* sentinel */},
-};
-MODULE_DEVICE_TABLE(of, mmc_pwrseq_simple_of_match);
-
-static int mmc_pwrseq_simple_probe(struct platform_device *pdev)
-{
-	struct mmc_pwrseq_simple *pwrseq;
-	struct device *dev = &pdev->dev;
-
-	pwrseq = devm_kzalloc(dev, sizeof(*pwrseq), GFP_KERNEL);
-	if (!pwrseq)
-		return -ENOMEM;
-
-	pwrseq->ext_clk = devm_clk_get(dev, "ext_clock");
-	if (IS_ERR(pwrseq->ext_clk) && PTR_ERR(pwrseq->ext_clk) != -ENOENT)
-		return PTR_ERR(pwrseq->ext_clk);
-
-	pwrseq->reset_gpios = devm_gpiod_get_array(dev, "reset",
-							GPIOD_OUT_HIGH);
-	if (IS_ERR(pwrseq->reset_gpios) &&
-	    PTR_ERR(pwrseq->reset_gpios) != -ENOENT &&
-	    PTR_ERR(pwrseq->reset_gpios) != -ENOSYS) {
-		return PTR_ERR(pwrseq->reset_gpios);
-	}
-
-	device_property_read_u32(dev, "post-power-on-delay-ms",
-				 &pwrseq->post_power_on_delay_ms);
-	device_property_read_u32(dev, "power-off-delay-us",
-				 &pwrseq->power_off_delay_us);
-
-	pwrseq->pwrseq.dev = dev;
-	pwrseq->pwrseq.ops = &mmc_pwrseq_simple_ops;
-	pwrseq->pwrseq.owner = THIS_MODULE;
-	platform_set_drvdata(pdev, pwrseq);
-
-	return mmc_pwrseq_register(&pwrseq->pwrseq);
-}
-
-static int mmc_pwrseq_simple_remove(struct platform_device *pdev)
-{
-	struct mmc_pwrseq_simple *pwrseq = platform_get_drvdata(pdev);
-
-	mmc_pwrseq_unregister(&pwrseq->pwrseq);
-
-	return 0;
-}
-
-static struct platform_driver mmc_pwrseq_simple_driver = {
-	.probe = mmc_pwrseq_simple_probe,
-	.remove = mmc_pwrseq_simple_remove,
-	.driver = {
-		.name = "pwrseq_simple",
-		.of_match_table = mmc_pwrseq_simple_of_match,
-	},
-};
-
-module_platform_driver(mmc_pwrseq_simple_driver);
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/power/pwrseq/Kconfig b/drivers/power/pwrseq/Kconfig
index 8904ec9ed541..36339a456b03 100644
--- a/drivers/power/pwrseq/Kconfig
+++ b/drivers/power/pwrseq/Kconfig
@@ -8,4 +8,36 @@ menuconfig PWRSEQ
 
 if PWRSEQ
 
+config PWRSEQ_EMMC
+	tristate "HW reset support for eMMC"
+	default y
+	depends on OF
+	help
+	  This selects Hardware reset support aka pwrseq-emmc for eMMC
+	  devices. By default this option is set to y.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called pwrseq_emmc.
+
+config PWRSEQ_SD8787
+	tristate "HW reset support for SD8787 BT + Wifi module"
+	depends on OF
+	help
+	  This selects hardware reset support for the SD8787 BT + Wifi
+	  module. By default this option is set to n.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called pwrseq_sd8787.
+
+config PWRSEQ_SIMPLE
+	tristate "Simple HW reset support"
+	default y
+	depends on OF
+	help
+	  This selects simple hardware reset support aka pwrseq-simple.
+	  By default this option is set to y.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called pwrseq_simple.
+
 endif
diff --git a/drivers/power/pwrseq/Makefile b/drivers/power/pwrseq/Makefile
index 108429ff6445..6f359d228843 100644
--- a/drivers/power/pwrseq/Makefile
+++ b/drivers/power/pwrseq/Makefile
@@ -4,3 +4,7 @@
 #
 
 obj-$(CONFIG_PWRSEQ) += core.o
+
+obj-$(CONFIG_PWRSEQ_EMMC)	+= pwrseq_emmc.o
+obj-$(CONFIG_PWRSEQ_SD8787)	+= pwrseq_sd8787.o
+obj-$(CONFIG_PWRSEQ_SIMPLE)	+= pwrseq_simple.o
diff --git a/drivers/power/pwrseq/pwrseq_emmc.c b/drivers/power/pwrseq/pwrseq_emmc.c
new file mode 100644
index 000000000000..a56969e18b1a
--- /dev/null
+++ b/drivers/power/pwrseq/pwrseq_emmc.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015, Samsung Electronics Co., Ltd.
+ *
+ * Author: Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * Simple eMMC hardware reset provider
+ */
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/gpio/consumer.h>
+#include <linux/reboot.h>
+#include <linux/pwrseq/driver.h>
+
+struct pwrseq_emmc {
+	struct notifier_block reset_nb;
+	struct gpio_desc *reset_gpio;
+};
+
+static void pwrseq_ereset(struct pwrseq *pwrseq)
+{
+	struct pwrseq_emmc *pwrseq_emmc = pwrseq_get_data(pwrseq);
+
+	gpiod_set_value_cansleep(pwrseq_emmc->reset_gpio, 1);
+	udelay(1);
+	gpiod_set_value_cansleep(pwrseq_emmc->reset_gpio, 0);
+	udelay(200);
+}
+
+static int pwrseq_ereset_nb(struct notifier_block *this,
+				    unsigned long mode, void *cmd)
+{
+	struct pwrseq_emmc *pwrseq_emmc = container_of(this,
+					struct pwrseq_emmc, reset_nb);
+	gpiod_set_value(pwrseq_emmc->reset_gpio, 1);
+	udelay(1);
+	gpiod_set_value(pwrseq_emmc->reset_gpio, 0);
+	udelay(200);
+
+	return NOTIFY_DONE;
+}
+
+static const struct pwrseq_ops pwrseq_eops = {
+	.reset = pwrseq_ereset,
+};
+
+static int pwrseq_eprobe(struct platform_device *pdev)
+{
+	struct pwrseq_emmc *pwrseq_emmc;
+	struct pwrseq *pwrseq;
+	struct pwrseq_provider *provider;
+	struct device *dev = &pdev->dev;
+
+	pwrseq_emmc = devm_kzalloc(dev, sizeof(*pwrseq_emmc), GFP_KERNEL);
+	if (!pwrseq_emmc)
+		return -ENOMEM;
+
+	pwrseq_emmc->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	if (IS_ERR(pwrseq_emmc->reset_gpio))
+		return PTR_ERR(pwrseq_emmc->reset_gpio);
+
+	if (!gpiod_cansleep(pwrseq_emmc->reset_gpio)) {
+		/*
+		 * register reset handler to ensure emmc reset also from
+		 * emergency_reboot(), priority 255 is the highest priority
+		 * so it will be executed before any system reboot handler.
+		 */
+		pwrseq_emmc->reset_nb.notifier_call = pwrseq_ereset_nb;
+		pwrseq_emmc->reset_nb.priority = 255;
+		register_restart_handler(&pwrseq_emmc->reset_nb);
+	} else {
+		dev_notice(dev, "EMMC reset pin tied to a sleepy GPIO driver; reset on emergency-reboot disabled\n");
+	}
+
+	platform_set_drvdata(pdev, pwrseq_emmc);
+
+	pwrseq = devm_pwrseq_create(dev, &pwrseq_eops, pwrseq_emmc);
+	if (IS_ERR(pwrseq))
+		return PTR_ERR(pwrseq);
+
+	provider = devm_of_pwrseq_provider_register(dev, of_pwrseq_xlate_single, pwrseq);
+
+	return PTR_ERR_OR_ZERO(provider);
+}
+
+static int pwrseq_eremove(struct platform_device *pdev)
+{
+	struct pwrseq_emmc *pwrseq_emmc = platform_get_drvdata(pdev);
+
+	unregister_restart_handler(&pwrseq_emmc->reset_nb);
+
+	return 0;
+}
+
+static const struct of_device_id pwrseq_eof_match[] = {
+	{ .compatible = "mmc-pwrseq-emmc",},
+	{/* sentinel */},
+};
+
+MODULE_DEVICE_TABLE(of, pwrseq_eof_match);
+
+static struct platform_driver pwrseq_edriver = {
+	.probe = pwrseq_eprobe,
+	.remove = pwrseq_eremove,
+	.driver = {
+		.name = "pwrseq_emmc",
+		.of_match_table = pwrseq_eof_match,
+	},
+};
+
+module_platform_driver(pwrseq_edriver);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/power/pwrseq/pwrseq_sd8787.c b/drivers/power/pwrseq/pwrseq_sd8787.c
new file mode 100644
index 000000000000..7759097dd4d6
--- /dev/null
+++ b/drivers/power/pwrseq/pwrseq_sd8787.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * pwrseq_sd8787.c - power sequence support for Marvell SD8787 BT + Wifi chip
+ *
+ * Copyright (C) 2016 Matt Ranostay <matt@ranostay.consulting>
+ *
+ * Based on the original work pwrseq_sd8787.c
+ *  Copyright (C) 2014 Linaro Ltd
+ *  Author: Ulf Hansson <ulf.hansson@linaro.org>
+ */
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/gpio/consumer.h>
+
+#include <linux/pwrseq/driver.h>
+
+struct pwrseq_sd8787 {
+	struct gpio_desc *reset_gpio;
+	struct gpio_desc *pwrdn_gpio;
+};
+
+static int pwrseq_sd8787_pre_power_on(struct pwrseq *pwrseq)
+{
+	struct pwrseq_sd8787 *pwrseq_sd8787 = pwrseq_get_data(pwrseq);
+
+	gpiod_set_value_cansleep(pwrseq_sd8787->reset_gpio, 1);
+
+	msleep(300);
+	gpiod_set_value_cansleep(pwrseq_sd8787->pwrdn_gpio, 1);
+
+	return 0;
+}
+
+static void pwrseq_sd8787_power_off(struct pwrseq *pwrseq)
+{
+	struct pwrseq_sd8787 *pwrseq_sd8787 = pwrseq_get_data(pwrseq);
+
+	gpiod_set_value_cansleep(pwrseq_sd8787->pwrdn_gpio, 0);
+	gpiod_set_value_cansleep(pwrseq_sd8787->reset_gpio, 0);
+}
+
+static const struct pwrseq_ops pwrseq_sd8787_ops = {
+	.pre_power_on = pwrseq_sd8787_pre_power_on,
+	.power_off = pwrseq_sd8787_power_off,
+};
+
+static const struct of_device_id pwrseq_sd8787_of_match[] = {
+	{ .compatible = "mmc-pwrseq-sd8787",},
+	{/* sentinel */},
+};
+MODULE_DEVICE_TABLE(of, pwrseq_sd8787_of_match);
+
+static int pwrseq_sd8787_probe(struct platform_device *pdev)
+{
+	struct pwrseq_sd8787 *pwrseq_sd8787;
+	struct pwrseq *pwrseq;
+	struct pwrseq_provider *provider;
+	struct device *dev = &pdev->dev;
+
+	pwrseq_sd8787 = devm_kzalloc(dev, sizeof(*pwrseq_sd8787), GFP_KERNEL);
+	if (!pwrseq_sd8787)
+		return -ENOMEM;
+
+	pwrseq_sd8787->pwrdn_gpio = devm_gpiod_get(dev, "powerdown", GPIOD_OUT_LOW);
+	if (IS_ERR(pwrseq_sd8787->pwrdn_gpio))
+		return PTR_ERR(pwrseq_sd8787->pwrdn_gpio);
+
+	pwrseq_sd8787->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	if (IS_ERR(pwrseq_sd8787->reset_gpio))
+		return PTR_ERR(pwrseq_sd8787->reset_gpio);
+
+	pwrseq = devm_pwrseq_create(dev, &pwrseq_sd8787_ops, pwrseq_sd8787);
+	if (IS_ERR(pwrseq))
+		return PTR_ERR(pwrseq);
+
+	provider = devm_of_pwrseq_provider_register(dev, of_pwrseq_xlate_single, pwrseq);
+
+	return PTR_ERR_OR_ZERO(provider);
+}
+
+static struct platform_driver pwrseq_sd8787_driver = {
+	.probe = pwrseq_sd8787_probe,
+	.driver = {
+		.name = "pwrseq_sd8787",
+		.of_match_table = pwrseq_sd8787_of_match,
+	},
+};
+
+module_platform_driver(pwrseq_sd8787_driver);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/power/pwrseq/pwrseq_simple.c b/drivers/power/pwrseq/pwrseq_simple.c
new file mode 100644
index 000000000000..f8d6e6e077df
--- /dev/null
+++ b/drivers/power/pwrseq/pwrseq_simple.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  Copyright (C) 2014 Linaro Ltd
+ *
+ * Author: Ulf Hansson <ulf.hansson@linaro.org>
+ *
+ *  Simple MMC power sequence management
+ */
+#include <linux/clk.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/gpio/consumer.h>
+#include <linux/delay.h>
+#include <linux/property.h>
+#include <linux/pwrseq/driver.h>
+
+struct pwrseq_simple {
+	bool clk_enabled;
+	u32 post_power_on_delay_ms;
+	u32 power_off_delay_us;
+	struct clk *ext_clk;
+	struct gpio_descs *reset_gpios;
+};
+
+static int pwrseq_simple_set_gpios_value(struct pwrseq_simple *pwrseq_simple,
+					 int value)
+{
+	struct gpio_descs *reset_gpios = pwrseq_simple->reset_gpios;
+	unsigned long *values;
+	int nvalues;
+	int ret;
+
+	if (IS_ERR(reset_gpios))
+		return PTR_ERR(reset_gpios);
+
+	nvalues = reset_gpios->ndescs;
+
+	values = bitmap_alloc(nvalues, GFP_KERNEL);
+	if (!values)
+		return -ENOMEM;
+
+	if (value)
+		bitmap_fill(values, nvalues);
+	else
+		bitmap_zero(values, nvalues);
+
+	ret = gpiod_set_array_value_cansleep(nvalues, reset_gpios->desc,
+				       reset_gpios->info, values);
+	kfree(values);
+
+	return ret;
+}
+
+static int pwrseq_simple_pre_power_on(struct pwrseq *pwrseq)
+{
+	struct pwrseq_simple *pwrseq_simple = pwrseq_get_data(pwrseq);
+
+	if (!IS_ERR(pwrseq_simple->ext_clk) && !pwrseq_simple->clk_enabled) {
+		clk_prepare_enable(pwrseq_simple->ext_clk);
+		pwrseq_simple->clk_enabled = true;
+	}
+
+	return pwrseq_simple_set_gpios_value(pwrseq_simple, 1);
+}
+
+static int pwrseq_simple_power_on(struct pwrseq *pwrseq)
+{
+	struct pwrseq_simple *pwrseq_simple = pwrseq_get_data(pwrseq);
+	int ret;
+
+	ret = pwrseq_simple_set_gpios_value(pwrseq_simple, 0);
+	if (ret)
+		return ret;
+
+	if (pwrseq_simple->post_power_on_delay_ms)
+		msleep(pwrseq_simple->post_power_on_delay_ms);
+
+	return 0;
+}
+
+static void pwrseq_simple_power_off(struct pwrseq *pwrseq)
+{
+	struct pwrseq_simple *pwrseq_simple = pwrseq_get_data(pwrseq);
+
+	pwrseq_simple_set_gpios_value(pwrseq_simple, 1);
+
+	if (pwrseq_simple->power_off_delay_us)
+		usleep_range(pwrseq_simple->power_off_delay_us,
+			2 * pwrseq_simple->power_off_delay_us);
+
+	if (!IS_ERR(pwrseq_simple->ext_clk) && pwrseq_simple->clk_enabled) {
+		clk_disable_unprepare(pwrseq_simple->ext_clk);
+		pwrseq_simple->clk_enabled = false;
+	}
+}
+
+static const struct pwrseq_ops pwrseq_simple_ops = {
+	.pre_power_on = pwrseq_simple_pre_power_on,
+	.power_on = pwrseq_simple_power_on,
+	.power_off = pwrseq_simple_power_off,
+};
+
+static const struct of_device_id pwrseq_simple_of_match[] = {
+	{ .compatible = "mmc-pwrseq-simple",}, /* MMC-specific compatible */
+	{/* sentinel */},
+};
+MODULE_DEVICE_TABLE(of, pwrseq_simple_of_match);
+
+static int pwrseq_simple_probe(struct platform_device *pdev)
+{
+	struct pwrseq_simple *pwrseq_simple;
+	struct pwrseq *pwrseq;
+	struct pwrseq_provider *provider;
+	struct device *dev = &pdev->dev;
+
+	pwrseq_simple = devm_kzalloc(dev, sizeof(*pwrseq_simple), GFP_KERNEL);
+	if (!pwrseq_simple)
+		return -ENOMEM;
+
+	pwrseq_simple->ext_clk = devm_clk_get(dev, "ext_clock");
+	if (IS_ERR(pwrseq_simple->ext_clk) && PTR_ERR(pwrseq_simple->ext_clk) != -ENOENT)
+		return PTR_ERR(pwrseq_simple->ext_clk);
+
+	pwrseq_simple->reset_gpios = devm_gpiod_get_array(dev, "reset",
+							GPIOD_OUT_HIGH);
+	if (IS_ERR(pwrseq_simple->reset_gpios) &&
+	    PTR_ERR(pwrseq_simple->reset_gpios) != -ENOENT &&
+	    PTR_ERR(pwrseq_simple->reset_gpios) != -ENOSYS) {
+		return PTR_ERR(pwrseq_simple->reset_gpios);
+	}
+
+	device_property_read_u32(dev, "post-power-on-delay-ms",
+				 &pwrseq_simple->post_power_on_delay_ms);
+	device_property_read_u32(dev, "power-off-delay-us",
+				 &pwrseq_simple->power_off_delay_us);
+
+	pwrseq = devm_pwrseq_create(dev, &pwrseq_simple_ops, pwrseq_simple);
+	if (IS_ERR(pwrseq))
+		return PTR_ERR(pwrseq);
+
+	provider = devm_of_pwrseq_provider_register(dev, of_pwrseq_xlate_single, pwrseq);
+
+	return PTR_ERR_OR_ZERO(provider);
+}
+
+static struct platform_driver pwrseq_simple_driver = {
+	.probe = pwrseq_simple_probe,
+	.driver = {
+		.name = "pwrseq_simple",
+		.of_match_table = pwrseq_simple_of_match,
+	},
+};
+
+module_platform_driver(pwrseq_simple_driver);
+MODULE_LICENSE("GPL v2");
-- 
2.30.2

