Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB32423699
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbhJFD5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237297AbhJFD4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 23:56:07 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD267C061766
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 20:54:15 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id m3so4627936lfu.2
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 20:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rbD+BS0NcNaczpvYu66j0XoKIa1SV+z+K/gWdXPxBUk=;
        b=KykwizkLmvDe9V3ztSXHrMUbEtG+5O9apjwceX15mSAxfOGddjZBn9DvzqFQm8al+v
         EAnxZ4OCvL47ljwDebZl06eRDP+igYzAFrsJJ+opFdIsw1yb/jto3oBjuKWhwchmzFZk
         mzy0kAh+LD6tz+hN8sGOY125bt6SsnhGXQMAcV3SbFx/KPE+6HAg9GcKn4rXy+OHW9a9
         EJqd/8q7d+PsNvrrx65/+T9ur6agPadWkmCQTbQ3U/B/stGNNXhj/8ogUfAi8CGTLy7Q
         Pzj9M/b0zsb5GzGml+qQ1rPPUbEVQyDD+9ZVBLd8fsMeGmeWr/I8emBgFrsG/NavD70P
         tDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rbD+BS0NcNaczpvYu66j0XoKIa1SV+z+K/gWdXPxBUk=;
        b=q4VPJWtbedO7uGqlfHFY3hch5aVCyDAXdLNKMsDMGmU3+p29clpBcjMGTzm7klRfr/
         dZ2zDBTz27gLpTo0DlHxBuJwCB++JOvgwJZNHtNdmT2rbKFfcV94qrclRNprd4kpsFK2
         XfE+5iQgJcpCE4k38iyPXZbz9csp8npjrRCzHfy/9XOuDT68puEtGd+pb0U9PheJ4w0S
         1hSYzxyye+UhJvGA1UJTh0KCY5vc0Mw6YsoT5HNgDfaWoSaF6rE6n9jlJdpCUfKvtw/C
         GDrBbowzvXpfqGgYJ3kHm6OQ22Ywy5tp9ta7MFGgxhK75FeyAaQpyQ+A0dqS/2WOsDFZ
         wNAw==
X-Gm-Message-State: AOAM532OsWIzn4DRKlpmKNruwX00rl6r8B/Ta98oruZIB0DFCCxu1sBc
        Q2KeQiLUEK6j6xR3415TOzjg3g==
X-Google-Smtp-Source: ABdhPJyHOYUrhGd9ENG3ERRSBh4fXx2/aUNfIRp3OWEd/bpQIfbGu6lhQiSaVH9XY6NpQ7K+CSnSLg==
X-Received: by 2002:a05:6512:ea2:: with SMTP id bi34mr6935938lfb.638.1633492453860;
        Tue, 05 Oct 2021 20:54:13 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id s4sm2142967lfd.103.2021.10.05.20.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 20:54:13 -0700 (PDT)
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
Subject: [PATCH v1 03/15] pwrseq: port MMC's pwrseq drivers to new pwrseq subsystem
Date:   Wed,  6 Oct 2021 06:53:55 +0300
Message-Id: <20211006035407.1147909-4-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port MMC's all pwrseq drivers to new pwrseq subsystem.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 .../pwrseq}/mmc-pwrseq-emmc.yaml              |   6 +-
 .../pwrseq}/mmc-pwrseq-sd8787.yaml            |   6 +-
 .../pwrseq}/mmc-pwrseq-simple.yaml            |   6 +-
 drivers/mmc/core/Kconfig                      |  32 ----
 drivers/mmc/core/Makefile                     |   3 -
 drivers/mmc/core/pwrseq_emmc.c                | 120 -------------
 drivers/mmc/core/pwrseq_sd8787.c              | 117 -------------
 drivers/mmc/core/pwrseq_simple.c              | 164 ------------------
 drivers/power/pwrseq/Kconfig                  |  32 ++++
 drivers/power/pwrseq/Makefile                 |   4 +
 drivers/power/pwrseq/pwrseq_emmc.c            | 121 +++++++++++++
 drivers/power/pwrseq/pwrseq_sd8787.c          | 108 ++++++++++++
 drivers/power/pwrseq/pwrseq_simple.c          | 162 +++++++++++++++++
 include/linux/pwrseq/driver.h                 |   4 +-
 14 files changed, 444 insertions(+), 441 deletions(-)
 rename Documentation/devicetree/bindings/{mmc => power/pwrseq}/mmc-pwrseq-emmc.yaml (91%)
 rename Documentation/devicetree/bindings/{mmc => power/pwrseq}/mmc-pwrseq-sd8787.yaml (86%)
 rename Documentation/devicetree/bindings/{mmc => power/pwrseq}/mmc-pwrseq-simple.yaml (92%)
 delete mode 100644 drivers/mmc/core/pwrseq_emmc.c
 delete mode 100644 drivers/mmc/core/pwrseq_sd8787.c
 delete mode 100644 drivers/mmc/core/pwrseq_simple.c
 create mode 100644 drivers/power/pwrseq/pwrseq_emmc.c
 create mode 100644 drivers/power/pwrseq/pwrseq_sd8787.c
 create mode 100644 drivers/power/pwrseq/pwrseq_simple.c

diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml b/Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-emmc.yaml
similarity index 91%
rename from Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml
rename to Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-emmc.yaml
index 1fc7e620f328..a5e14e4a19b3 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.yaml
+++ b/Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-emmc.yaml
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/mmc/mmc-pwrseq-emmc.yaml#
+$id: http://devicetree.org/schemas/power/pwrseq/mmc-pwrseq-emmc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Simple eMMC hardware reset provider binding
@@ -32,6 +32,9 @@ properties:
       reset procedure as described in Jedec 4.4 specification, the
       gpio line should be defined as GPIO_ACTIVE_LOW.
 
+  "#pwrseq-cells":
+    const: 0
+
 required:
   - compatible
   - reset-gpios
@@ -43,6 +46,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     sdhci0_pwrseq {
       compatible = "mmc-pwrseq-emmc";
+      #pwrseq-cells = <0>;
       reset-gpios = <&gpio1 12 GPIO_ACTIVE_LOW>;
     };
 ...
diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml b/Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-sd8787.yaml
similarity index 86%
rename from Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml
rename to Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-sd8787.yaml
index 9e2396751030..7876be05573d 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.yaml
+++ b/Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-sd8787.yaml
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/mmc/mmc-pwrseq-sd8787.yaml#
+$id: http://devicetree.org/schemas/power/pwrseq/mmc-pwrseq-sd8787.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Marvell SD8787 power sequence provider binding
@@ -25,6 +25,9 @@ properties:
     description:
       contains a reset GPIO specifier with the default active state
 
+  "#pwrseq-cells":
+    const: 0
+
 required:
   - compatible
   - powerdown-gpios
@@ -37,6 +40,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     wifi_pwrseq: wifi_pwrseq {
       compatible = "mmc-pwrseq-sd8787";
+      #pwrseq-cells = <0>;
       powerdown-gpios = <&twl_gpio 0 GPIO_ACTIVE_LOW>;
       reset-gpios = <&twl_gpio 1 GPIO_ACTIVE_LOW>;
     };
diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml b/Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-simple.yaml
similarity index 92%
rename from Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
rename to Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-simple.yaml
index 226fb191913d..3eff40fd347e 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
+++ b/Documentation/devicetree/bindings/power/pwrseq/mmc-pwrseq-simple.yaml
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/mmc/mmc-pwrseq-simple.yaml#
+$id: http://devicetree.org/schemas/power/pwrseq/mmc-pwrseq-simple.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Simple MMC power sequence provider binding
@@ -47,6 +47,9 @@ properties:
       Delay in us after asserting the reset-gpios (if any)
       during power off of the card.
 
+  "#pwrseq-cells":
+    const: 0
+
 required:
   - compatible
 
@@ -57,6 +60,7 @@ examples:
     #include <dt-bindings/gpio/gpio.h>
     sdhci0_pwrseq {
       compatible = "mmc-pwrseq-simple";
+      #pwrseq-cells = <0>;
       reset-gpios = <&gpio1 12 GPIO_ACTIVE_LOW>;
       clocks = <&clk_32768_ck>;
       clock-names = "ext_clock";
diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index 6f25c34e4fec..cf7df64ce009 100644
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
-	depends on OF && (MWIFIEX || BT_MRVL_SDIO || LIBERTAS_SDIO || WILC1000_SDIO)
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
index 2e120ad83020..000000000000
--- a/drivers/mmc/core/pwrseq_sd8787.c
+++ /dev/null
@@ -1,117 +0,0 @@
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
-#include <linux/of.h>
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
-	u32 reset_pwrdwn_delay_ms;
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
-	msleep(pwrseq->reset_pwrdwn_delay_ms);
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
-static const u32 sd8787_delay_ms = 300;
-static const u32 wilc1000_delay_ms = 5;
-
-static const struct of_device_id mmc_pwrseq_sd8787_of_match[] = {
-	{ .compatible = "mmc-pwrseq-sd8787", .data = &sd8787_delay_ms },
-	{ .compatible = "mmc-pwrseq-wilc1000", .data = &wilc1000_delay_ms },
-	{/* sentinel */},
-};
-MODULE_DEVICE_TABLE(of, mmc_pwrseq_sd8787_of_match);
-
-static int mmc_pwrseq_sd8787_probe(struct platform_device *pdev)
-{
-	struct mmc_pwrseq_sd8787 *pwrseq;
-	struct device *dev = &pdev->dev;
-	const struct of_device_id *match;
-
-	pwrseq = devm_kzalloc(dev, sizeof(*pwrseq), GFP_KERNEL);
-	if (!pwrseq)
-		return -ENOMEM;
-
-	match = of_match_node(mmc_pwrseq_sd8787_of_match, pdev->dev.of_node);
-	pwrseq->reset_pwrdwn_delay_ms = *(u32 *)match->data;
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
index dab8f4d860fe..1985f13d9193 100644
--- a/drivers/power/pwrseq/Kconfig
+++ b/drivers/power/pwrseq/Kconfig
@@ -11,4 +11,36 @@ menuconfig PWRSEQ
 
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
index 000000000000..954bbb44979d
--- /dev/null
+++ b/drivers/power/pwrseq/pwrseq_emmc.c
@@ -0,0 +1,121 @@
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
+#include <linux/mod_devicetable.h>
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
+	struct pwrseq_emmc *pwrseq_emmc = pwrseq_get_drvdata(pwrseq);
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
+	pwrseq = devm_pwrseq_create(dev, &pwrseq_eops);
+	if (IS_ERR(pwrseq))
+		return PTR_ERR(pwrseq);
+
+	pwrseq_set_drvdata(pwrseq, pwrseq_emmc);
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
index 000000000000..aeb80327f40d
--- /dev/null
+++ b/drivers/power/pwrseq/pwrseq_sd8787.c
@@ -0,0 +1,108 @@
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
+#include <linux/mod_devicetable.h>
+#include <linux/of_device.h>
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
+	u32 reset_pwrdwn_delay_ms;
+};
+
+static int pwrseq_sd8787_pre_power_on(struct pwrseq *pwrseq)
+{
+	struct pwrseq_sd8787 *pwrseq_sd8787 = pwrseq_get_drvdata(pwrseq);
+
+	gpiod_set_value_cansleep(pwrseq_sd8787->reset_gpio, 1);
+
+	msleep(pwrseq_sd8787->reset_pwrdwn_delay_ms);
+	gpiod_set_value_cansleep(pwrseq_sd8787->pwrdn_gpio, 1);
+
+	return 0;
+}
+
+static void pwrseq_sd8787_power_off(struct pwrseq *pwrseq)
+{
+	struct pwrseq_sd8787 *pwrseq_sd8787 = pwrseq_get_drvdata(pwrseq);
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
+static const u32 sd8787_delay_ms = 300;
+static const u32 wilc1000_delay_ms = 5;
+
+static const struct of_device_id pwrseq_sd8787_of_match[] = {
+	{ .compatible = "mmc-pwrseq-sd8787", .data = &sd8787_delay_ms },
+	{ .compatible = "mmc-pwrseq-wilc1000", .data = &wilc1000_delay_ms },
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
+	pwrseq_sd8787->reset_pwrdwn_delay_ms = *(u32 *)of_device_get_match_data(dev);
+
+	pwrseq_sd8787->pwrdn_gpio = devm_gpiod_get(dev, "powerdown", GPIOD_OUT_LOW);
+	if (IS_ERR(pwrseq_sd8787->pwrdn_gpio))
+		return PTR_ERR(pwrseq_sd8787->pwrdn_gpio);
+
+	pwrseq_sd8787->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	if (IS_ERR(pwrseq_sd8787->reset_gpio))
+		return PTR_ERR(pwrseq_sd8787->reset_gpio);
+
+	pwrseq = devm_pwrseq_create(dev, &pwrseq_sd8787_ops);
+	if (IS_ERR(pwrseq))
+		return PTR_ERR(pwrseq);
+
+	pwrseq_set_drvdata(pwrseq, pwrseq_sd8787);
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
index 000000000000..4889fd5a11e0
--- /dev/null
+++ b/drivers/power/pwrseq/pwrseq_simple.c
@@ -0,0 +1,162 @@
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
+	struct pwrseq_simple *pwrseq_simple = pwrseq_get_drvdata(pwrseq);
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
+	struct pwrseq_simple *pwrseq_simple = pwrseq_get_drvdata(pwrseq);
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
+	struct pwrseq_simple *pwrseq_simple = pwrseq_get_drvdata(pwrseq);
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
+	pwrseq = devm_pwrseq_create(dev, &pwrseq_simple_ops);
+	if (IS_ERR(pwrseq))
+		return PTR_ERR(pwrseq);
+
+	pwrseq_set_drvdata(pwrseq, pwrseq_simple);
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
diff --git a/include/linux/pwrseq/driver.h b/include/linux/pwrseq/driver.h
index bdb8a25a8504..0ca1d0311ab6 100644
--- a/include/linux/pwrseq/driver.h
+++ b/include/linux/pwrseq/driver.h
@@ -57,7 +57,7 @@ struct pwrseq *__devm_pwrseq_create(struct device *dev, struct module *owner, co
  *
  * Return: created instance or the wrapped error code.
  */
-#define pwrseq_create(dev, ops, data) __pwrseq_create((dev), THIS_MODULE, (ops))
+#define pwrseq_create(dev, ops) __pwrseq_create((dev), THIS_MODULE, (ops))
 
 /**
  * devm_pwrseq_create() - devres-managed version of pwrseq_create
@@ -71,7 +71,7 @@ struct pwrseq *__devm_pwrseq_create(struct device *dev, struct module *owner, co
  *
  * Return: created instance or the wrapped error code.
  */
-#define devm_pwrseq_create(dev, ops, data) __devm_pwrseq_create((dev), THIS_MODULE, (ops))
+#define devm_pwrseq_create(dev, ops) __devm_pwrseq_create((dev), THIS_MODULE, (ops))
 
 void pwrseq_destroy(struct pwrseq *pwrseq);
 
-- 
2.33.0

