Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AF641123E
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbhITJxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:53:40 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:34025 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236564AbhITJxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:53:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131496; x=1663667496;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V0cRVTs8okspyQRslFZu0Mma4o7oiAMrkzAAMlvxVPM=;
  b=rf21rt38Wnuqvvov3xlpOJFV8cu21D05Vv/Uet/Yws7AI8Xd1O9KB2c3
   69u/6hF+jY0Ru07sdrC/OLGCgD2mn+rqq/onOtd9+p4U8l3FyR5Eh4bDa
   6V4qcLqFs6rqpN8iDzIAKK8jiEPjC6bTUCoQO6/oBz2ZS8skA/XgBBWtX
   6hsZzMMxUTFetn0/9R88JFyZeN4YSm/s+EPcD9fvzNd66iOQkuZP/ZjKA
   RYaiobMSwMkdHgNM5goA7NHF2rlp0AUmhfmyvJ4p8HPluTajMdYXmAWjb
   RG2WVpIQdUXb9Mo6FJPkDH1XjELxWFmr26qJBVqSe7BUKVWVFhxe9Xyp4
   g==;
IronPort-SDR: XN/p8TY7fE99+HQpujKoIm22iH0+Fx/3OaJVNsR9dx7iK9eXeYwObLGCXNEgkO/JYorAdxS0X8
 Doze4XnidpLfc4rgpuv0wAZW5NIqzVholGlE8SjYrzEdvaqtMkX12n5wsTmkLs6CpX7+bszQ8C
 GIg7HGyxtdw8yswSeebA0SkOeySJFKgz8PzB9Bsokth5b863i9/d3tlw6sFWnG2HEB/2cReJwf
 W4MquQUrM0xcZmOFkN+VnKm4JTf3okMXJoGj+o5SXRIPsXBy1EJLdsgpIk4pUJbh+NsoIP98/Q
 3JrbkpUS24n0beCgXOU1OXdD
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="136598682"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:34 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:31 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 07/12] power: reset: Add lan966x power reset driver
Date:   Mon, 20 Sep 2021 11:52:13 +0200
Message-ID: <20210920095218.1108151-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a driver for lan966x to allow a software reset.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/power/reset/Kconfig         |  6 ++
 drivers/power/reset/Makefile        |  1 +
 drivers/power/reset/lan966x-reset.c | 90 +++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+)
 create mode 100644 drivers/power/reset/lan966x-reset.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 4b563db3ab3e..755b60c143da 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -158,6 +158,12 @@ config POWER_RESET_PIIX4_POWEROFF
 	  southbridge SOff state is entered in response to a request to
 	  power off the system.
 
+config POWER_RESET_LAN966X
+	bool "Microchip Lan966x reset driver"
+	select MFD_SYSCON
+	help
+	  This driver supports restart for Microchip Lan966x.
+
 config POWER_RESET_LTC2952
 	bool "LTC2952 PowerPath power-off driver"
 	depends on OF_GPIO
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index f606a2f60539..0fbc817c4eb6 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_POWER_RESET_OXNAS) += oxnas-restart.o
 obj-$(CONFIG_POWER_RESET_QCOM_PON) += qcom-pon.o
 obj-$(CONFIG_POWER_RESET_OCELOT_RESET) += ocelot-reset.o
 obj-$(CONFIG_POWER_RESET_PIIX4_POWEROFF) += piix4-poweroff.o
+obj-$(CONFIG_POWER_RESET_LAN966X) += lan966x-reset.o
 obj-$(CONFIG_POWER_RESET_LTC2952) += ltc2952-poweroff.o
 obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
 obj-$(CONFIG_POWER_RESET_REGULATOR) += regulator-poweroff.o
diff --git a/drivers/power/reset/lan966x-reset.c b/drivers/power/reset/lan966x-reset.c
new file mode 100644
index 000000000000..612705b680fe
--- /dev/null
+++ b/drivers/power/reset/lan966x-reset.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * License: Dual MIT/GPL
+ * Copyright (c) 2020 Microchip Corporation
+ */
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/notifier.h>
+#include <linux/mfd/syscon.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+#include <linux/regmap.h>
+
+static const char *cpu_syscon = "microchip,lan966x-cpu-syscon";
+static const char *gcb_syscon = "microchip,lan966x-switch-syscon";
+
+struct lan966x_reset_context {
+	struct regmap *gcb_ctrl;
+	struct regmap *cpu_ctrl;
+	struct notifier_block restart_handler;
+};
+
+#define PROTECT_REG    0x88
+#define PROTECT_BIT    BIT(5)
+#define SOFT_RESET_REG 0x00
+#define SOFT_RESET_BIT BIT(1)
+
+static int lan966x_restart_handle(struct notifier_block *this,
+				  unsigned long mode, void *cmd)
+{
+	struct lan966x_reset_context *ctx = container_of(this, struct lan966x_reset_context,
+							restart_handler);
+
+	/* Make sure the core is not protected from reset */
+	regmap_update_bits(ctx->cpu_ctrl, PROTECT_REG, PROTECT_BIT, 0);
+
+	pr_emerg("Resetting SoC\n");
+
+	regmap_write(ctx->gcb_ctrl, SOFT_RESET_REG, SOFT_RESET_BIT);
+
+	pr_emerg("Unable to restart system\n");
+	return NOTIFY_DONE;
+}
+
+static int lan966x_reset_probe(struct platform_device *pdev)
+{
+	struct lan966x_reset_context *ctx;
+	struct device *dev = &pdev->dev;
+	int err;
+
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->gcb_ctrl = syscon_regmap_lookup_by_compatible(gcb_syscon);
+	if (IS_ERR(ctx->gcb_ctrl)) {
+		dev_err(dev, "No gcb_syscon map: %s\n", gcb_syscon);
+		return PTR_ERR(ctx->gcb_ctrl);
+	}
+
+	ctx->cpu_ctrl = syscon_regmap_lookup_by_compatible(cpu_syscon);
+	if (IS_ERR(ctx->cpu_ctrl)) {
+		dev_err(dev, "No cpu_syscon map: %s\n", cpu_syscon);
+		return PTR_ERR(ctx->cpu_ctrl);
+	}
+
+	ctx->restart_handler.notifier_call = lan966x_restart_handle;
+	ctx->restart_handler.priority = 192;
+	err = register_restart_handler(&ctx->restart_handler);
+	if (err)
+		dev_err(dev, "can't register restart notifier (err=%d)\n", err);
+
+	return err;
+}
+
+static const struct of_device_id lan966x_reset_of_match[] = {
+	{ .compatible = "microchip,lan966x-chip-reset", },
+	{ /*sentinel*/ }
+};
+
+static struct platform_driver lan966x_reset_driver = {
+	.probe = lan966x_reset_probe,
+	.driver = {
+		.name = "lan966x-chip-reset",
+		.of_match_table = lan966x_reset_of_match,
+	},
+};
+builtin_platform_driver(lan966x_reset_driver);
-- 
2.31.1

