Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2C71F4F7B
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 09:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgFJHri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 03:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgFJHrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 03:47:36 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8186EC03E96F
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:47:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a45so1869704pje.1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j0l5m+TkhIbHssxUHNdbOXyWREI7WDwMdOHBW8DfxuY=;
        b=Jc9rHwljfT71s/9i0z9uDLSP3HTlTPJzFA5A5EC8gzBVw0+fibexV8BFLBct6lA24V
         gQLilKWQYHHyxgA84oN3H/uDzsIuVrPxS7sV7x83MCvSh8p1z8JcnwXU7SQgBpUn+rJM
         H/jQ1txWUMUsXpTTdyRWZvPIANNutMwgHyDGfMV4ncSi6fzozrwhpS9husX+9dLlFdcc
         mZIIJgtfE4kpOy6BI0ypx7JjrfHP2jka5NlUbjW897U6Iln7QkXJ8FKrng1BJQh6kNae
         4EqHeALUaBfgza5OthMyweta1VoOWDN0rvsKYB2BMKdWLfxuD06ZJB9utmBc9xZXoL3y
         Q3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j0l5m+TkhIbHssxUHNdbOXyWREI7WDwMdOHBW8DfxuY=;
        b=XZQt0rX93eQPcfR6kwp3Y2dDpos5wXwok/fngFXmohghKUKx67tAiYLiqY3bPEwnB1
         VJkW5ajNZtFbVIj8OY7d75cezKj/SEy+RYBPHkMbGuQxMb35E7sS0uxdxso6PX2Nrohg
         NfeD/YYwM3UwfrktSNYmj72qACTdZ4Bq2odNjk3E/rYlsaZ7X8amCCsJ9Kc+wm9gri8o
         wBK8Z5rhr+cKtpXORlD3n7hMcg1Pi/N4YdVoQTwk4IEhevufcjPQ+FIbCCeRijYI+GGW
         sSLp5/iFftulW9E/qs27IJjI2vJ5wfDLeBR1PQQU3yRQmDrp27un4/bKtbolIO1qDGDh
         d05A==
X-Gm-Message-State: AOAM533JE9AhvXJuEvSaULarfUGWVB/j31X1lkhKohdOq5NLG97ko69i
        PGRVkZtiIm8Bv4xclYVqdl13
X-Google-Smtp-Source: ABdhPJx6/fNl0MWUrXpUFw2pMZUYW+fhs77FqzqCcyhD4ojuJDyezm8UHO32YEdXI2rhUHlSe9j+cw==
X-Received: by 2002:a17:902:d70a:: with SMTP id w10mr1985841ply.256.1591775255289;
        Wed, 10 Jun 2020 00:47:35 -0700 (PDT)
Received: from Mani-XPS-13-9360.localdomain ([2409:4072:630f:1dba:c41:a14e:6586:388a])
        by smtp.gmail.com with ESMTPSA id u1sm10075040pgf.28.2020.06.10.00.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 00:47:34 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     wg@grandegger.com, mkl@pengutronix.de, robh+dt@kernel.org
Cc:     kernel@martin.sperl.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [RESEND PATCH 2/6] can: mcp25xxfd: Add Microchip MCP25XXFD CAN-FD driver infrastructure
Date:   Wed, 10 Jun 2020 13:17:07 +0530
Message-Id: <20200610074711.10969-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200610074711.10969-1-manivannan.sadhasivam@linaro.org>
References: <20200610074711.10969-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Sperl <kernel@martin.sperl.org>

This commit adds basic driver support for the Microchip MCP25XXFD
CAN-FD controller series. This driver currently supports MCP2517FD as the
target controller.

The MCP2517FD is capable of transmitting and receiving standard data
frames, extended data frames, remote frames and Can-FD frames.
The MCP2517FD interfaces with the host over SPI.

This commit provides basic driver functionality such as setting up clocks,
regulators and the infrastructure for the CAN.

Datasheet:
* http://ww1.microchip.com/downloads/en/DeviceDoc/20005688A.pdf
Reference manual:
* http://ww1.microchip.com/downloads/en/DeviceDoc/20005678A.pdf
Errata:
* http://ww1.microchip.com/downloads/en/DeviceDoc/MCP2517FD-Silicon-Errata-and-Data-Sheet-Clarification-DS80000792A.pdf

Signed-off-by: Martin Sperl <kernel@martin.sperl.org>
[mani: trimmed the gpio part and done some cleanups]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/net/can/spi/Kconfig                   |   2 +
 drivers/net/can/spi/Makefile                  |   2 +
 drivers/net/can/spi/mcp25xxfd/Kconfig         |   5 +
 drivers/net/can/spi/mcp25xxfd/Makefile        |   7 +
 .../net/can/spi/mcp25xxfd/mcp25xxfd_base.c    | 171 +++++
 .../net/can/spi/mcp25xxfd/mcp25xxfd_base.h    |  14 +
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.c | 141 ++++
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.h |  16 +
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_cmd.c | 226 ++++++
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_cmd.h |  84 +++
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_crc.c |  31 +
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_crc.h |  15 +
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_ecc.c |  74 ++
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_ecc.h |  16 +
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_int.c |  59 ++
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_int.h |  15 +
 .../net/can/spi/mcp25xxfd/mcp25xxfd_priv.h    |  48 ++
 .../net/can/spi/mcp25xxfd/mcp25xxfd_regs.h    | 656 ++++++++++++++++++
 18 files changed, 1582 insertions(+)
 create mode 100644 drivers/net/can/spi/mcp25xxfd/Kconfig
 create mode 100644 drivers/net/can/spi/mcp25xxfd/Makefile
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_base.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_base.h
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.h
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_cmd.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_cmd.h
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_crc.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_crc.h
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_ecc.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_ecc.h
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_int.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_int.h
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_priv.h
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_regs.h

diff --git a/drivers/net/can/spi/Kconfig b/drivers/net/can/spi/Kconfig
index 1c50788055cb..d4b68eb5d386 100644
--- a/drivers/net/can/spi/Kconfig
+++ b/drivers/net/can/spi/Kconfig
@@ -15,4 +15,6 @@ config CAN_MCP251X
 	  Driver for the Microchip MCP251x and MCP25625 SPI CAN
 	  controllers.
 
+source "drivers/net/can/spi/mcp25xxfd/Kconfig"
+
 endmenu
diff --git a/drivers/net/can/spi/Makefile b/drivers/net/can/spi/Makefile
index f115b2c46623..f56514541ce4 100644
--- a/drivers/net/can/spi/Makefile
+++ b/drivers/net/can/spi/Makefile
@@ -6,3 +6,5 @@
 
 obj-$(CONFIG_CAN_HI311X)	+= hi311x.o
 obj-$(CONFIG_CAN_MCP251X)	+= mcp251x.o
+
+obj-y                           += mcp25xxfd/
diff --git a/drivers/net/can/spi/mcp25xxfd/Kconfig b/drivers/net/can/spi/mcp25xxfd/Kconfig
new file mode 100644
index 000000000000..f720f1377612
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/Kconfig
@@ -0,0 +1,5 @@
+config CAN_MCP25XXFD
+	tristate "Microchip MCP25xxFD SPI CAN controllers"
+	depends on HAS_DMA
+	help
+	  Driver for the Microchip MCP25XXFD SPI FD-CAN controller family.
diff --git a/drivers/net/can/spi/mcp25xxfd/Makefile b/drivers/net/can/spi/mcp25xxfd/Makefile
new file mode 100644
index 000000000000..d8fdb76a9578
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_CAN_MCP25XXFD)	+= mcp25xxfd.o
+mcp25xxfd-objs                  := mcp25xxfd_base.o
+mcp25xxfd-objs                  += mcp25xxfd_can.o
+mcp25xxfd-objs                  += mcp25xxfd_cmd.o
+mcp25xxfd-objs                  += mcp25xxfd_crc.o
+mcp25xxfd-objs                  += mcp25xxfd_ecc.o
+mcp25xxfd-objs                  += mcp25xxfd_int.o
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_base.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_base.c
new file mode 100644
index 000000000000..4be456df0998
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_base.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "mcp25xxfd_base.h"
+#include "mcp25xxfd_can.h"
+#include "mcp25xxfd_cmd.h"
+#include "mcp25xxfd_ecc.h"
+#include "mcp25xxfd_int.h"
+#include "mcp25xxfd_priv.h"
+
+int mcp25xxfd_base_power_enable(struct regulator *reg, int enable)
+{
+	if (enable)
+		return regulator_enable(reg);
+	else
+		return regulator_disable(reg);
+}
+
+static const struct of_device_id mcp25xxfd_of_match[] = {
+	{
+		.compatible	= "microchip,mcp2517fd",
+		.data		= (void *)CAN_MCP2517FD,
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(of, mcp25xxfd_of_match);
+
+static int mcp25xxfd_base_probe(struct spi_device *spi)
+{
+	const struct of_device_id *of_id =
+		of_match_device(mcp25xxfd_of_match, &spi->dev);
+	struct mcp25xxfd_priv *priv;
+	struct clk *clk;
+	enum mcp25xxfd_model model;
+	u32 freq;
+	int ret;
+
+	/* Check whether valid IRQ line is defined or not */
+	if (spi->irq <= 0) {
+		dev_err(&spi->dev, "no valid irq line defined: irq = %i\n",
+			spi->irq);
+		return -EINVAL;
+	}
+
+	priv = devm_kzalloc(&spi->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	spi_set_drvdata(spi, priv);
+	priv->spi = spi;
+
+	/* Assign device name */
+	snprintf(priv->device_name, sizeof(priv->device_name),
+		 DEVICE_NAME "-%s", dev_name(&priv->spi->dev));
+
+	/* assign model from of or driver_data */
+	if (of_id)
+		model = (enum mcp25xxfd_model)of_id->data;
+	else
+		model = spi_get_device_id(spi)->driver_data;
+
+	clk = devm_clk_get(&spi->dev, NULL);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		goto out_free;
+	}
+
+	freq = clk_get_rate(clk);
+	if (!(freq == CLOCK_4_MHZ || freq == CLOCK_10_MHZ ||
+	      freq == CLOCK_40_MHZ)) {
+		ret = -ERANGE;
+		goto out_free;
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (ret)
+		goto out_free;
+
+	priv->clk = clk;
+	priv->clock_freq = freq;
+
+	/* Configure the SPI bus */
+	spi->bits_per_word = 8;
+
+	/* The frequency of SCK has to be less than or equal to half the
+	 * frequency of SYSCLK.
+	 */
+	spi->max_speed_hz = freq / 2;
+	ret = spi_setup(spi);
+	if (ret)
+		goto out_clk;
+
+	priv->power = devm_regulator_get(&spi->dev, "vdd");
+	if (IS_ERR(priv->power)) {
+		if (PTR_ERR(priv->power) != -EPROBE_DEFER)
+			dev_err(&spi->dev, "failed to get vdd\n");
+		ret = PTR_ERR(priv->power);
+		goto out_clk;
+	}
+
+	ret = mcp25xxfd_base_power_enable(priv->power, 1);
+	if (ret)
+		goto out_clk;
+
+	/* disable interrupts */
+	ret = mcp25xxfd_int_enable(priv, false);
+	if (ret)
+		goto out_power;
+
+	/* setup ECC for SRAM */
+	ret = mcp25xxfd_ecc_enable(priv);
+	if (ret)
+		goto out_power;
+
+	dev_info(&spi->dev,
+		 "MCP%04x successfully initialized.\n", model);
+	return 0;
+
+out_power:
+	mcp25xxfd_base_power_enable(priv->power, 0);
+out_clk:
+	clk_disable_unprepare(clk);
+out_free:
+	dev_err(&spi->dev, "Probe failed, err=%d\n", -ret);
+	return ret;
+}
+
+static int mcp25xxfd_base_remove(struct spi_device *spi)
+{
+	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
+
+	mcp25xxfd_base_power_enable(priv->power, 0);
+	clk_disable_unprepare(priv->clk);
+
+	return 0;
+}
+
+static const struct spi_device_id mcp25xxfd_id_table[] = {
+	{
+		.name		= "mcp2517fd",
+		.driver_data	= (kernel_ulong_t)CAN_MCP2517FD,
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, mcp25xxfd_id_table);
+
+static struct spi_driver mcp25xxfd_can_driver = {
+	.driver = {
+		.name = DEVICE_NAME,
+		.of_match_table = mcp25xxfd_of_match,
+	},
+	.id_table = mcp25xxfd_id_table,
+	.probe = mcp25xxfd_base_probe,
+	.remove = mcp25xxfd_base_remove,
+};
+module_spi_driver(mcp25xxfd_can_driver);
+
+MODULE_AUTHOR("Martin Sperl <kernel@martin.sperl.org>");
+MODULE_DESCRIPTION("Microchip 25XXFD CAN driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_base.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_base.h
new file mode 100644
index 000000000000..4559ac60645c
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_base.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+#ifndef __MCP25XXFD_BASE_H
+#define __MCP25XXFD_BASE_H
+
+#include <linux/regulator/consumer.h>
+
+int mcp25xxfd_base_power_enable(struct regulator *reg, int enable);
+
+#endif /* __MCP25XXFD_BASE_H */
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.c
new file mode 100644
index 000000000000..41a5ab508582
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+
+#include "mcp25xxfd_can.h"
+#include "mcp25xxfd_cmd.h"
+#include "mcp25xxfd_priv.h"
+#include "mcp25xxfd_regs.h"
+
+int mcp25xxfd_can_get_mode(struct mcp25xxfd_priv *priv, u32 *reg)
+{
+	int ret;
+
+	ret = mcp25xxfd_cmd_read(priv->spi, MCP25XXFD_CAN_CON, reg);
+	if (ret)
+		return ret;
+
+	return FIELD_GET(MCP25XXFD_CAN_CON_OPMOD_MASK, *reg);
+}
+
+static int mcp25xxfd_can_switch_mode(struct mcp25xxfd_priv *priv,
+				     u32 *reg, int mode)
+{
+	int ret, i;
+
+	ret = mcp25xxfd_can_get_mode(priv, reg);
+	if (ret < 0)
+		return ret;
+
+	/* Compute the effective mode in osc*/
+	*reg &= ~(MCP25XXFD_CAN_CON_REQOP_MASK |
+		  MCP25XXFD_CAN_CON_OPMOD_MASK);
+	*reg |= FIELD_PREP(MCP25XXFD_CAN_CON_REQOP_MASK, mode) |
+		FIELD_PREP(MCP25XXFD_CAN_CON_OPMOD_MASK, mode);
+
+	/* Request the mode switch */
+	ret = mcp25xxfd_cmd_write(priv->spi, MCP25XXFD_CAN_CON, *reg);
+	if (ret)
+		return ret;
+
+	/* Wait for 256 rounds to stabilize. This is essentially > 12ms
+	 * at 1MHz
+	 */
+	for (i = 0; i < 256; i++) {
+		/* get the mode */
+		ret = mcp25xxfd_can_get_mode(priv, reg);
+		if (ret < 0)
+			return ret;
+		/* check that we have reached our mode */
+		if (ret == mode)
+			return 0;
+	}
+
+	dev_err(&priv->spi->dev, "Failed to switch to mode %u in time\n",
+		mode);
+
+	return -ETIMEDOUT;
+}
+
+static int mcp25xxfd_can_probe_modeswitch(struct mcp25xxfd_priv *priv)
+{
+	u32 mode_data;
+	int ret;
+
+	/* We should be in config mode now, so move to INT_LOOPBACK */
+	ret = mcp25xxfd_can_switch_mode(priv, &mode_data,
+					MCP25XXFD_CAN_CON_MODE_INT_LOOPBACK);
+	if (ret) {
+		dev_err(&priv->spi->dev,
+			"Failed to switch into loopback mode\n");
+		return ret;
+	}
+
+	/* Switch back into config mode */
+	ret = mcp25xxfd_can_switch_mode(priv, &mode_data,
+					MCP25XXFD_CAN_CON_MODE_CONFIG);
+	if (ret) {
+		dev_err(&priv->spi->dev,
+			"Failed to switch back to config mode\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+int mcp25xxfd_can_probe(struct mcp25xxfd_priv *priv)
+{
+	struct spi_device *spi = priv->spi;
+	u32 mode_data;
+	int mode, ret;
+
+	/* For sanity check read TXQCON register. The TXEN bit should always
+	 * be read as 1.
+	 */
+	ret = mcp25xxfd_cmd_read(spi, MCP25XXFD_CAN_TXQCON, &mode_data);
+	if (ret)
+		return ret;
+
+	if ((mode_data & MCP25XXFD_CAN_TXQCON_TXEN) == 0) {
+		dev_err(&spi->dev, "TXQCON does not have TXEN bit set");
+		return -EINVAL;
+	}
+
+	/* Try to get the current mode */
+	mode = mcp25xxfd_can_get_mode(priv, &mode_data);
+	if (mode < 0)
+		return mode;
+
+	/* SPI-reset should have moved us into config mode. But then the
+	 * documentation says that SPI-reset may only work reliably when already
+	 * in config mode. So if we are in config mode then everything is fine
+	 * and we check that a mode switch works properly.
+	 */
+	if (mode == MCP25XXFD_CAN_CON_MODE_CONFIG)
+		return mcp25xxfd_can_probe_modeswitch(priv);
+
+	/* Any other mode is unexpected */
+	dev_err(&spi->dev,
+		"Found controller in unexpected mode: %d\n", mode);
+
+	/* Once again try to move to config mode. If this fails, we'll
+	 * bail out.
+	 */
+	ret = mcp25xxfd_can_switch_mode(priv, &mode_data,
+					MCP25XXFD_CAN_CON_MODE_CONFIG);
+	if (ret) {
+		dev_err(&priv->spi->dev,
+			"Unable to switch to config mode\n");
+		return -EINVAL;
+	}
+
+	/* Finally check if modeswitch is really working */
+	return mcp25xxfd_can_probe_modeswitch(priv);
+}
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.h
new file mode 100644
index 000000000000..f54c716735fb
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#ifndef __MCP25XXFD_CAN_H
+#define __MCP25XXFD_CAN_H
+
+#include "mcp25xxfd_priv.h"
+
+/* probe the can controller */
+int mcp25xxfd_can_probe(struct mcp25xxfd_priv *priv);
+
+#endif /* __MCP25XXFD_CAN_H */
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_cmd.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_cmd.c
new file mode 100644
index 000000000000..24d01e6f59d4
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_cmd.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+
+#include "mcp25xxfd_cmd.h"
+#include "mcp25xxfd_priv.h"
+
+static int mcp25xxfd_cmd_sync_write(struct spi_device *spi,
+				    const void *tx_buf,
+				    unsigned int tx_len)
+{
+	struct spi_transfer xfer;
+
+	memset(&xfer, 0, sizeof(xfer));
+	xfer.tx_buf = tx_buf;
+	xfer.len = tx_len;
+
+	return spi_sync_transfer(spi, &xfer, 1);
+}
+
+static int mcp25xxfd_cmd_write_then_read(struct spi_device *spi,
+					 const void *tx_buf,
+					 unsigned int tx_len,
+					 void *rx_buf,
+					 unsigned int rx_len)
+{
+	struct spi_transfer xfer[2];
+	u8 *spi_tx, *spi_rx;
+	int xfers;
+	int ret;
+
+	spi_tx = kzalloc(tx_len + rx_len, GFP_KERNEL);
+	if (!spi_tx)
+		return -ENOMEM;
+
+	spi_rx = spi_tx + tx_len;
+	memset(xfer, 0, sizeof(xfer));
+
+	/* Special handling for half-duplex */
+	if (spi->master->flags & SPI_MASTER_HALF_DUPLEX) {
+		xfers = 2;
+		xfer[0].tx_buf = spi_tx;
+		xfer[0].len = tx_len;
+		/* Offset for rx_buf needs to get aligned */
+		xfer[1].rx_buf = spi_rx + tx_len;
+		xfer[1].len = rx_len;
+	} else {
+		xfers = 1;
+		xfer[0].len = tx_len + rx_len;
+		xfer[0].tx_buf = spi_tx;
+		xfer[0].rx_buf = spi_rx;
+	}
+
+	memcpy(spi_tx, tx_buf, tx_len);
+	ret = spi_sync_transfer(spi, xfer, xfers);
+	if (ret)
+		goto out;
+
+	memcpy(rx_buf, xfer[0].rx_buf + tx_len, rx_len);
+
+out:
+	kfree(spi_tx);
+
+	return ret;
+}
+
+static int mcp25xxfd_cmd_write_then_write(struct spi_device *spi,
+					  const void *tx_buf,
+					  unsigned int tx_len,
+					  const void *tx2_buf,
+					  unsigned int tx2_len)
+{
+	struct spi_transfer xfer;
+	u8 *spi_tx;
+	int ret;
+
+	spi_tx = kzalloc(tx_len + tx2_len, GFP_KERNEL);
+	if (!spi_tx)
+		return -ENOMEM;
+
+	memset(&xfer, 0, sizeof(xfer));
+	xfer.len = tx_len + tx2_len;
+	xfer.tx_buf = spi_tx;
+
+	memcpy(spi_tx, tx_buf, tx_len);
+	memcpy(spi_tx + tx_len, tx2_buf, tx2_len);
+
+	ret = spi_sync_transfer(spi, &xfer, 1);
+	kfree(spi_tx);
+
+	return ret;
+}
+
+/* Read multiple bytes from registers */
+int mcp25xxfd_cmd_read_multi(struct spi_device *spi, u32 reg,
+			     void *data, int n)
+{
+	u8 cmd[2];
+	int ret;
+
+	mcp25xxfd_cmd_calc(MCP25XXFD_INSTRUCTION_READ, reg, cmd);
+
+	ret = mcp25xxfd_cmd_write_then_read(spi, &cmd, 2, data, n);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+int mcp25xxfd_cmd_read_mask(struct spi_device *spi, u32 reg,
+			    u32 *data, u32 mask)
+{
+	int first_byte, last_byte, len_byte;
+	int ret;
+
+	/* Make sure at least one bit is set */
+	if (!mask)
+		return -EINVAL;
+
+	/* Calculate first and last byte used */
+	first_byte = mcp25xxfd_cmd_first_byte(mask);
+	last_byte = mcp25xxfd_cmd_last_byte(mask);
+	len_byte = last_byte - first_byte + 1;
+
+	*data = 0;
+	ret = mcp25xxfd_cmd_read_multi(spi, reg + first_byte,
+				       ((void *)data + first_byte), len_byte);
+	if (ret)
+		return ret;
+
+	mcp25xxfd_cmd_convert_to_cpu(data, 1);
+
+	return 0;
+}
+
+/* Write multiple bytes to registers */
+int mcp25xxfd_cmd_write_multi(struct spi_device *spi, u32 reg,
+			      void *data, int n)
+{
+	int ret;
+	u8 cmd[2];
+
+	mcp25xxfd_cmd_calc(MCP25XXFD_INSTRUCTION_WRITE, reg, cmd);
+
+	ret = mcp25xxfd_cmd_write_then_write(spi, &cmd, 2, data, n);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+int mcp25xxfd_cmd_write_mask(struct spi_device *spi, u32 reg,
+			     u32 data, u32 mask)
+{
+	int first_byte, last_byte, len_byte;
+	u8 cmd[2];
+
+	/* Make sure at least one bit is set */
+	if (!mask)
+		return -EINVAL;
+
+	/* calculate first and last byte used */
+	first_byte = mcp25xxfd_cmd_first_byte(mask);
+	last_byte = mcp25xxfd_cmd_last_byte(mask);
+	len_byte = last_byte - first_byte + 1;
+
+	mcp25xxfd_cmd_calc(MCP25XXFD_INSTRUCTION_WRITE,
+			   reg + first_byte, cmd);
+
+	mcp25xxfd_cmd_convert_from_cpu(&data, 1);
+
+	return mcp25xxfd_cmd_write_then_write(spi,
+					      cmd, sizeof(cmd),
+					      ((void *)&data + first_byte),
+					      len_byte);
+}
+
+int mcp25xxfd_cmd_write_regs(struct spi_device *spi, u32 reg,
+			     u32 *data, u32 bytes)
+{
+	int ret;
+
+	mcp25xxfd_cmd_convert_from_cpu(data, bytes / sizeof(bytes));
+
+	ret = mcp25xxfd_cmd_write_multi(spi, reg, data, bytes);
+
+	mcp25xxfd_cmd_convert_to_cpu(data, bytes / sizeof(bytes));
+
+	return ret;
+}
+
+int mcp25xxfd_cmd_read_regs(struct spi_device *spi, u32 reg,
+			    u32 *data, u32 bytes)
+{
+	int ret;
+
+	ret = mcp25xxfd_cmd_read_multi(spi, reg, data, bytes);
+
+	mcp25xxfd_cmd_convert_to_cpu((u32 *)data, bytes / sizeof(bytes));
+
+	return ret;
+}
+
+int mcp25xxfd_cmd_reset(struct spi_device *spi)
+{
+	u8 *cmd;
+	int ret;
+
+	cmd = kzalloc(2, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	mcp25xxfd_cmd_calc(MCP25XXFD_INSTRUCTION_RESET, 0, cmd);
+
+	ret = mcp25xxfd_cmd_sync_write(spi, cmd, 2);
+
+	kfree(cmd);
+
+	return ret;
+}
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_cmd.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_cmd.h
new file mode 100644
index 000000000000..a61815f97bf6
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_cmd.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#ifndef __MCP25XXFD_CMD_H
+#define __MCP25XXFD_CMD_H
+
+#include <linux/byteorder/generic.h>
+#include <linux/spi/spi.h>
+
+/* SPI commands */
+#define MCP25XXFD_INSTRUCTION_RESET		0x0000
+#define MCP25XXFD_INSTRUCTION_READ		0x3000
+#define MCP25XXFD_INSTRUCTION_WRITE		0x2000
+#define MCP25XXFD_INSTRUCTION_READ_CRC		0xB000
+#define MCP25XXFD_INSTRUCTION_WRITE_CRC		0xA000
+#define MCP25XXFD_INSTRUCTION_WRITE_SAVE	0xC000
+
+#define MCP25XXFD_ADDRESS_MASK			0x0fff
+
+static inline void mcp25xxfd_cmd_convert_to_cpu(u32 *data, int n)
+{
+	le32_to_cpu_array(data, n);
+}
+
+static inline void mcp25xxfd_cmd_convert_from_cpu(u32 *data, int n)
+{
+	cpu_to_le32_array(data, n);
+}
+
+static inline void mcp25xxfd_cmd_calc(u16 cmd, u16 addr, u8 *data)
+{
+	cmd = cmd | (addr & MCP25XXFD_ADDRESS_MASK);
+
+	data[0] = (cmd >> 8) & 0xff;
+	data[1] = (cmd >> 0) & 0xff;
+}
+
+static inline int mcp25xxfd_cmd_first_byte(u32 mask)
+{
+	return (mask & 0x0000ffff) ?
+		((mask & 0x000000ff) ? 0 : 1) :
+		((mask & 0x00ff0000) ? 2 : 3);
+}
+
+static inline int mcp25xxfd_cmd_last_byte(u32 mask)
+{
+	return (mask & 0xffff0000) ?
+		((mask & 0xff000000) ? 3 : 2) :
+		((mask & 0x0000ff00) ? 1 : 0);
+}
+
+int mcp25xxfd_cmd_read_multi(struct spi_device *spi, u32 reg,
+			     void *data, int n);
+int mcp25xxfd_cmd_read_mask(struct spi_device *spi, u32 reg,
+			    u32 *data, u32 mask);
+static inline int mcp25xxfd_cmd_read(struct spi_device *spi, u32 reg,
+				     u32 *data)
+{
+	return mcp25xxfd_cmd_read_mask(spi, reg, data, -1);
+}
+
+int mcp25xxfd_cmd_read_regs(struct spi_device *spi, u32 reg,
+			    u32 *data, u32 bytes);
+
+int mcp25xxfd_cmd_write_multi(struct spi_device *spi, u32 reg,
+			      void *data, int n);
+int mcp25xxfd_cmd_write_mask(struct spi_device *spi, u32 reg,
+			     u32 data, u32 mask);
+static inline int mcp25xxfd_cmd_write(struct spi_device *spi, u32 reg,
+				      u32 data)
+{
+	return mcp25xxfd_cmd_write_mask(spi, reg, data, -1);
+}
+
+int mcp25xxfd_cmd_write_regs(struct spi_device *spi, u32 reg,
+			     u32 *data, u32 bytes);
+
+int mcp25xxfd_cmd_reset(struct spi_device *spi);
+
+#endif /* __MCP25XXFD_CMD_H */
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_crc.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_crc.c
new file mode 100644
index 000000000000..b893d8009448
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_crc.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+#include "mcp25xxfd_cmd.h"
+#include "mcp25xxfd_crc.h"
+#include "mcp25xxfd_regs.h"
+#include "mcp25xxfd_priv.h"
+
+int mcp25xxfd_crc_enable_int(struct mcp25xxfd_priv *priv, bool enable)
+{
+	u32 mask = MCP25XXFD_CRC_CRCERRIE | MCP25XXFD_CRC_FERRIE;
+
+	priv->regs.crc &= ~mask;
+	priv->regs.crc |= enable ? mask : 0;
+
+	return mcp25xxfd_cmd_write_mask(priv->spi, MCP25XXFD_CRC,
+					priv->regs.crc, mask);
+}
+
+int mcp25xxfd_crc_clear_int(struct mcp25xxfd_priv *priv)
+{
+	return mcp25xxfd_cmd_write_mask(priv->spi, MCP25XXFD_CRC, 0,
+					MCP25XXFD_CRC_CRCERRIF |
+					MCP25XXFD_CRC_FERRIF);
+}
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_crc.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_crc.h
new file mode 100644
index 000000000000..6e42fe0fad0f
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_crc.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+#ifndef __MCP25XXFD_CRC_H
+#define __MCP25XXFD_CRC_H
+
+#include "mcp25xxfd_priv.h"
+
+int mcp25xxfd_crc_enable_int(struct mcp25xxfd_priv *priv, bool enable);
+int mcp25xxfd_crc_clear_int(struct mcp25xxfd_priv *priv);
+
+#endif /* __MCP25XXFD_CRC_H */
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_ecc.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_ecc.c
new file mode 100644
index 000000000000..56e2c4fbf52d
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_ecc.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+#include "mcp25xxfd_cmd.h"
+#include "mcp25xxfd_ecc.h"
+#include "mcp25xxfd_priv.h"
+#include "mcp25xxfd_regs.h"
+
+int mcp25xxfd_ecc_clear_int(struct mcp25xxfd_priv *priv)
+{
+	u32 val, addr;
+	int ret;
+
+	/* First report the error address */
+	ret = mcp25xxfd_cmd_read(priv->spi, MCP25XXFD_ECCSTAT, &val);
+	if (ret)
+		return ret;
+
+	/* If no flags are set then nothing to do */
+	if (!(val & (MCP25XXFD_ECCSTAT_SECIF | MCP25XXFD_ECCSTAT_DEDIF)))
+		return 0;
+
+	addr = (val & MCP25XXFD_ECCSTAT_ERRADDR_MASK) >>
+		MCP25XXFD_ECCSTAT_ERRADDR_SHIFT;
+
+	dev_err_ratelimited(&priv->spi->dev, "ECC %s bit error at %03x\n",
+			    (val & MCP25XXFD_ECCSTAT_DEDIF) ?
+			    "double" : "single",
+			    addr);
+
+	/* Clear the error */
+	return mcp25xxfd_cmd_write_mask(priv->spi, MCP25XXFD_ECCSTAT, 0,
+					MCP25XXFD_ECCSTAT_SECIF |
+					MCP25XXFD_ECCSTAT_DEDIF);
+}
+
+int mcp25xxfd_ecc_enable_int(struct mcp25xxfd_priv *priv, bool enable)
+{
+	u32 mask = MCP25XXFD_ECCCON_SECIE | MCP25XXFD_ECCCON_DEDIE;
+
+	priv->regs.ecccon &= ~mask;
+	priv->regs.ecccon |= MCP25XXFD_ECCCON_ECCEN | (enable ? mask : 0);
+
+	return mcp25xxfd_cmd_write_mask(priv->spi, MCP25XXFD_ECCCON,
+					priv->regs.ecccon,
+					MCP25XXFD_ECCCON_ECCEN | mask);
+}
+
+int mcp25xxfd_ecc_enable(struct mcp25xxfd_priv *priv)
+{
+	u8 buffer[256];
+	int i, ret;
+
+	ret = mcp25xxfd_ecc_enable_int(priv, false);
+	if (ret)
+		return ret;
+
+	memset(buffer, 0, sizeof(buffer));
+	for (i = 0; i < MCP25XXFD_SRAM_SIZE; i += sizeof(buffer)) {
+		ret = mcp25xxfd_cmd_write_multi(priv->spi,
+						MCP25XXFD_SRAM_ADDR(i),
+						buffer, sizeof(buffer));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_ecc.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_ecc.h
new file mode 100644
index 000000000000..117f58c65a46
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_ecc.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+#ifndef __MCP25XXFD_ECC_H
+#define __MCP25XXFD_ECC_H
+
+#include "mcp25xxfd_priv.h"
+
+int mcp25xxfd_ecc_clear_int(struct mcp25xxfd_priv *priv);
+int mcp25xxfd_ecc_enable_int(struct mcp25xxfd_priv *priv, bool enable);
+int mcp25xxfd_ecc_enable(struct mcp25xxfd_priv *priv);
+
+#endif /* __MCP25XXFD_ECC_H */
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_int.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_int.c
new file mode 100644
index 000000000000..5e274d452646
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_int.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+
+#include "mcp25xxfd_crc.h"
+#include "mcp25xxfd_ecc.h"
+#include "mcp25xxfd_int.h"
+#include "mcp25xxfd_priv.h"
+
+int mcp25xxfd_int_clear(struct mcp25xxfd_priv *priv)
+{
+	int ret;
+
+	ret = mcp25xxfd_ecc_clear_int(priv);
+	if (ret)
+		return ret;
+
+	return mcp25xxfd_crc_clear_int(priv);
+}
+
+int mcp25xxfd_int_enable(struct mcp25xxfd_priv *priv, bool enable)
+{
+	int ret;
+
+	/* If we enable interrupts, then clear interrupt first */
+	if (enable) {
+		ret = mcp25xxfd_int_clear(priv);
+		if (ret)
+			return ret;
+	}
+
+	ret = mcp25xxfd_crc_enable_int(priv, enable);
+	if (ret)
+		return ret;
+
+	ret = mcp25xxfd_ecc_enable(priv);
+	if (ret)
+		goto out_crc;
+
+	ret = mcp25xxfd_ecc_enable_int(priv, enable);
+	if (ret)
+		goto out_crc;
+
+	/* If we disable interrupts, then clear interrupt flags last */
+	if (!enable)
+		mcp25xxfd_int_clear(priv);
+
+	return 0;
+
+out_crc:
+	mcp25xxfd_crc_enable_int(priv, false);
+	return ret;
+}
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_int.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_int.h
new file mode 100644
index 000000000000..4daf0182d1af
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_int.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+#ifndef __MCP25XXFD_INT_H
+#define __MCP25XXFD_INT_H
+
+#include "mcp25xxfd_priv.h"
+
+int mcp25xxfd_int_clear(struct mcp25xxfd_priv *priv);
+int mcp25xxfd_int_enable(struct mcp25xxfd_priv *priv, bool enable);
+
+#endif /* __MCP25XXFD_INT_H */
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_priv.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_priv.h
new file mode 100644
index 000000000000..8bc7a599224c
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_priv.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#ifndef __MCP25XXFD_PRIV_H
+#define __MCP25XXFD_PRIV_H
+
+#include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+#include <linux/spi/spi.h>
+
+#include "mcp25xxfd_regs.h"
+
+#define DEVICE_NAME "mcp25xxfd"
+#define CLOCK_4_MHZ 4000000
+#define CLOCK_10_MHZ 10000000
+#define CLOCK_40_MHZ 40000000
+
+enum mcp25xxfd_model {
+	CAN_MCP2517FD	= 0x2517,
+};
+
+struct mcp25xxfd_priv {
+	struct spi_device *spi;
+	struct clk *clk;
+
+	/* actual model of the mcp25xxfd */
+	enum mcp25xxfd_model model;
+
+	/* full device name used for interrupts */
+	char device_name[32];
+
+	int clock_freq;
+	struct regulator *power;
+
+	/* configuration registers */
+	struct {
+		u32 osc;
+		u32 iocon;
+		u32 crc;
+		u32 ecccon;
+	} regs;
+};
+
+#endif /* __MCP25XXFD_PRIV_H */
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_regs.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_regs.h
new file mode 100644
index 000000000000..b500cb46b9a4
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_regs.h
@@ -0,0 +1,656 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#ifndef __MCP25XXFD_REGS_H
+#define __MCP25XXFD_REGS_H
+
+#include <linux/bitops.h>
+
+/* some constants derived from the datasheets */
+#define MCP25XXFD_OST_DELAY_MS		3
+#define MCP25XXFD_MIN_CLOCK_FREQUENCY	1000000
+#define MCP25XXFD_MAX_CLOCK_FREQUENCY	40000000
+#define MCP25XXFD_PLL_MULTIPLIER	10
+#define MCP25XXFD_AUTO_PLL_MAX_CLOCK_FREQUENCY				\
+	(MCP25XXFD_MAX_CLOCK_FREQUENCY / MCP25XXFD_PLL_MULTIPLIER)
+#define MCP25XXFD_SCLK_DIVIDER		2
+
+/* GPIO, clock, ecc related register definitions of Controller itself */
+#define MCP25XXFD_SFR_BASE(x)			(0xE00 + (x))
+#define MCP25XXFD_OSC				MCP25XXFD_SFR_BASE(0x00)
+#  define MCP25XXFD_OSC_PLLEN			BIT(0)
+#  define MCP25XXFD_OSC_OSCDIS			BIT(2)
+#  define MCP25XXFD_OSC_SCLKDIV			BIT(4)
+#  define MCP25XXFD_OSC_CLKODIV_BITS		2
+#  define MCP25XXFD_OSC_CLKODIV_SHIFT		5
+#  define MCP25XXFD_OSC_CLKODIV_MASK					\
+	GENMASK(MCP25XXFD_OSC_CLKODIV_SHIFT				\
+		+ MCP25XXFD_OSC_CLKODIV_BITS - 1,			\
+		MCP25XXFD_OSC_CLKODIV_SHIFT)
+#  define MCP25XXFD_OSC_CLKODIV_10		3
+#  define MCP25XXFD_OSC_CLKODIV_4		2
+#  define MCP25XXFD_OSC_CLKODIV_2		1
+#  define MCP25XXFD_OSC_CLKODIV_1		0
+#  define MCP25XXFD_OSC_PLLRDY			BIT(8)
+#  define MCP25XXFD_OSC_OSCRDY			BIT(10)
+#  define MCP25XXFD_OSC_SCLKRDY			BIT(12)
+#define MCP25XXFD_IOCON				MCP25XXFD_SFR_BASE(0x04)
+#  define MCP25XXFD_IOCON_TRIS0			BIT(0)
+#  define MCP25XXFD_IOCON_TRIS1			BIT(1)
+#  define MCP25XXFD_IOCON_XSTBYEN		BIT(6)
+#  define MCP25XXFD_IOCON_LAT0			BIT(8)
+#  define MCP25XXFD_IOCON_LAT1			BIT(9)
+#  define MCP25XXFD_IOCON_GPIO0			BIT(16)
+#  define MCP25XXFD_IOCON_GPIO1			BIT(17)
+#  define MCP25XXFD_IOCON_PM0			BIT(24)
+#  define MCP25XXFD_IOCON_PM1			BIT(25)
+#  define MCP25XXFD_IOCON_TXCANOD		BIT(28)
+#  define MCP25XXFD_IOCON_SOF			BIT(29)
+#  define MCP25XXFD_IOCON_INTOD			BIT(30)
+#define MCP25XXFD_CRC				MCP25XXFD_SFR_BASE(0x08)
+#  define MCP25XXFD_CRC_MASK			GENMASK(15, 0)
+#  define MCP25XXFD_CRC_CRCERRIE		BIT(16)
+#  define MCP25XXFD_CRC_FERRIE			BIT(17)
+#  define MCP25XXFD_CRC_CRCERRIF		BIT(24)
+#  define MCP25XXFD_CRC_FERRIF			BIT(25)
+#define MCP25XXFD_ECCCON			MCP25XXFD_SFR_BASE(0x0C)
+#  define MCP25XXFD_ECCCON_ECCEN		BIT(0)
+#  define MCP25XXFD_ECCCON_SECIE		BIT(1)
+#  define MCP25XXFD_ECCCON_DEDIE		BIT(2)
+#  define MCP25XXFD_ECCCON_PARITY_BITS		6
+#  define MCP25XXFD_ECCCON_PARITY_SHIFT		8
+#  define MCP25XXFD_ECCCON_PARITY_MASK					\
+	GENMASK(MCP25XXFD_ECCCON_PARITY_SHIFT				\
+		+ MCP25XXFD_ECCCON_PARITY_BITS - 1,			\
+		MCP25XXFD_ECCCON_PARITY_SHIFT)
+#define MCP25XXFD_ECCSTAT			MCP25XXFD_SFR_BASE(0x10)
+#  define MCP25XXFD_ECCSTAT_SECIF		BIT(1)
+#  define MCP25XXFD_ECCSTAT_DEDIF		BIT(2)
+#  define MCP25XXFD_ECCSTAT_ERRADDR_SHIFT	8
+#  define MCP25XXFD_ECCSTAT_ERRADDR_MASK				\
+	GENMASK(MCP25XXFD_ECCSTAT_ERRADDR_SHIFT + 11,			\
+		MCP25XXFD_ECCSTAT_ERRADDR_SHIFT)
+
+/* CAN related register definitions of Controller CAN block */
+#define MCP25XXFD_CAN_SFR_BASE(x)		(0x000 + (x))
+#define MCP25XXFD_CAN_CON						\
+	MCP25XXFD_CAN_SFR_BASE(0x00)
+#  define MCP25XXFD_CAN_CON_DNCNT_BITS		5
+#  define MCP25XXFD_CAN_CON_DNCNT_SHIFT		0
+#  define MCP25XXFD_CAN_CON_DNCNT_MASK					\
+	GENMASK(MCP25XXFD_CAN_CON_DNCNT_SHIFT +				\
+		MCP25XXFD_CAN_CON_DNCNT_BITS - 1,			\
+		MCP25XXFD_CAN_CON_DNCNT_SHIFT)
+#  define MCP25XXFD_CAN_CON_ISOCRCEN		BIT(5)
+#  define MCP25XXFD_CAN_CON_PXEDIS		BIT(6)
+#  define MCP25XXFD_CAN_CON_WAKFIL		BIT(8)
+#  define MCP25XXFD_CAN_CON_WFT_BITS		2
+#  define MCP25XXFD_CAN_CON_WFT_SHIFT		9
+#  define MCP25XXFD_CAN_CON_WFT_MASK					\
+	GENMASK(MCP25XXFD_CAN_CON_WFT_SHIFT +				\
+		MCP25XXFD_CAN_CON_WFT_BITS - 1,				\
+		MCP25XXFD_CAN_CON_WFT_SHIFT)
+#  define MCP25XXFD_CAN_CON_BUSY		BIT(11)
+#  define MCP25XXFD_CAN_CON_BRSDIS		BIT(12)
+#  define MCP25XXFD_CAN_CON_RTXAT		BIT(16)
+#  define MCP25XXFD_CAN_CON_ESIGM		BIT(17)
+#  define MCP25XXFD_CAN_CON_SERR2LOM		BIT(18)
+#  define MCP25XXFD_CAN_CON_STEF		BIT(19)
+#  define MCP25XXFD_CAN_CON_TXQEN		BIT(20)
+#  define MCP25XXFD_CAN_CON_OPMODE_BITS		3
+#  define MCP25XXFD_CAN_CON_OPMOD_SHIFT		21
+#  define MCP25XXFD_CAN_CON_OPMOD_MASK					\
+	GENMASK(MCP25XXFD_CAN_CON_OPMOD_SHIFT +				\
+		MCP25XXFD_CAN_CON_OPMODE_BITS - 1,			\
+		MCP25XXFD_CAN_CON_OPMOD_SHIFT)
+#  define MCP25XXFD_CAN_CON_REQOP_BITS		3
+#  define MCP25XXFD_CAN_CON_REQOP_SHIFT		24
+#  define MCP25XXFD_CAN_CON_REQOP_MASK					\
+	GENMASK(MCP25XXFD_CAN_CON_REQOP_SHIFT +				\
+		MCP25XXFD_CAN_CON_REQOP_BITS - 1,			\
+		MCP25XXFD_CAN_CON_REQOP_SHIFT)
+#    define MCP25XXFD_CAN_CON_MODE_MIXED	0
+#    define MCP25XXFD_CAN_CON_MODE_SLEEP	1
+#    define MCP25XXFD_CAN_CON_MODE_INT_LOOPBACK	2
+#    define MCP25XXFD_CAN_CON_MODE_LISTENONLY	3
+#    define MCP25XXFD_CAN_CON_MODE_CONFIG	4
+#    define MCP25XXFD_CAN_CON_MODE_EXT_LOOPBACK	5
+#    define MCP25XXFD_CAN_CON_MODE_CAN2_0	6
+#    define MCP25XXFD_CAN_CON_MODE_RESTRICTED	7
+#  define MCP25XXFD_CAN_CON_ABAT		BIT(27)
+#  define MCP25XXFD_CAN_CON_TXBWS_BITS		3
+#  define MCP25XXFD_CAN_CON_TXBWS_SHIFT		28
+#  define MCP25XXFD_CAN_CON_TXBWS_MASK					\
+	GENMASK(MCP25XXFD_CAN_CON_TXBWS_SHIFT +				\
+		MCP25XXFD_CAN_CON_TXBWS_BITS - 1,			\
+		MCP25XXFD_CAN_CON_TXBWS_SHIFT)
+#  define MCP25XXFD_CAN_CON_DEFAULT					\
+	(MCP25XXFD_CAN_CON_ISOCRCEN |					\
+	 MCP25XXFD_CAN_CON_PXEDIS |					\
+	 MCP25XXFD_CAN_CON_WAKFIL |					\
+	 (3 << MCP25XXFD_CAN_CON_WFT_SHIFT) |				\
+	 MCP25XXFD_CAN_CON_STEF |					\
+	 MCP25XXFD_CAN_CON_TXQEN |					\
+	 (MCP25XXFD_CAN_CON_MODE_CONFIG << MCP25XXFD_CAN_CON_OPMOD_SHIFT) | \
+	 (MCP25XXFD_CAN_CON_MODE_CONFIG << MCP25XXFD_CAN_CON_REQOP_SHIFT))
+#  define MCP25XXFD_CAN_CON_DEFAULT_MASK				\
+	(MCP25XXFD_CAN_CON_DNCNT_MASK |					\
+	 MCP25XXFD_CAN_CON_ISOCRCEN |					\
+	 MCP25XXFD_CAN_CON_PXEDIS |					\
+	 MCP25XXFD_CAN_CON_WAKFIL |					\
+	 MCP25XXFD_CAN_CON_WFT_MASK |					\
+	 MCP25XXFD_CAN_CON_BRSDIS |					\
+	 MCP25XXFD_CAN_CON_RTXAT |					\
+	 MCP25XXFD_CAN_CON_ESIGM |					\
+	 MCP25XXFD_CAN_CON_SERR2LOM |					\
+	 MCP25XXFD_CAN_CON_STEF |					\
+	 MCP25XXFD_CAN_CON_TXQEN |					\
+	 MCP25XXFD_CAN_CON_OPMOD_MASK |					\
+	 MCP25XXFD_CAN_CON_REQOP_MASK |					\
+	 MCP25XXFD_CAN_CON_ABAT |					\
+	 MCP25XXFD_CAN_CON_TXBWS_MASK)
+#define MCP25XXFD_CAN_NBTCFG			MCP25XXFD_CAN_SFR_BASE(0x04)
+#  define MCP25XXFD_CAN_NBTCFG_SJW_BITS		7
+#  define MCP25XXFD_CAN_NBTCFG_SJW_SHIFT	0
+#  define MCP25XXFD_CAN_NBTCFG_SJW_MASK					\
+	GENMASK(MCP25XXFD_CAN_NBTCFG_SJW_SHIFT +			\
+		MCP25XXFD_CAN_NBTCFG_SJW_BITS - 1,			\
+		MCP25XXFD_CAN_NBTCFG_SJW_SHIFT)
+#  define MCP25XXFD_CAN_NBTCFG_TSEG2_BITS	7
+#  define MCP25XXFD_CAN_NBTCFG_TSEG2_SHIFT	8
+#  define MCP25XXFD_CAN_NBTCFG_TSEG2_MASK				\
+	GENMASK(MCP25XXFD_CAN_NBTCFG_TSEG2_SHIFT +			\
+		MCP25XXFD_CAN_NBTCFG_TSEG2_BITS - 1,			\
+		MCP25XXFD_CAN_NBTCFG_TSEG2_SHIFT)
+#  define MCP25XXFD_CAN_NBTCFG_TSEG1_BITS	8
+#  define MCP25XXFD_CAN_NBTCFG_TSEG1_SHIFT	16
+#  define MCP25XXFD_CAN_NBTCFG_TSEG1_MASK				\
+	GENMASK(MCP25XXFD_CAN_NBTCFG_TSEG1_SHIFT +			\
+		MCP25XXFD_CAN_NBTCFG_TSEG1_BITS - 1,			\
+		MCP25XXFD_CAN_NBTCFG_TSEG1_SHIFT)
+#  define MCP25XXFD_CAN_NBTCFG_BRP_BITS		8
+#  define MCP25XXFD_CAN_NBTCFG_BRP_SHIFT	24
+#  define MCP25XXFD_CAN_NBTCFG_BRP_MASK					\
+	GENMASK(MCP25XXFD_CAN_NBTCFG_BRP_SHIFT +			\
+		MCP25XXFD_CAN_NBTCFG_BRP_BITS - 1,			\
+		MCP25XXFD_CAN_NBTCFG_BRP_SHIFT)
+#define MCP25XXFD_CAN_DBTCFG			MCP25XXFD_CAN_SFR_BASE(0x08)
+#  define MCP25XXFD_CAN_DBTCFG_SJW_BITS		4
+#  define MCP25XXFD_CAN_DBTCFG_SJW_SHIFT	0
+#  define MCP25XXFD_CAN_DBTCFG_SJW_MASK					\
+	GENMASK(MCP25XXFD_CAN_DBTCFG_SJW_SHIFT +			\
+		MCP25XXFD_CAN_DBTCFG_SJW_BITS - 1,			\
+		MCP25XXFD_CAN_DBTCFG_SJW_SHIFT)
+#  define MCP25XXFD_CAN_DBTCFG_TSEG2_BITS	4
+#  define MCP25XXFD_CAN_DBTCFG_TSEG2_SHIFT	8
+#  define MCP25XXFD_CAN_DBTCFG_TSEG2_MASK				\
+	GENMASK(MCP25XXFD_CAN_DBTCFG_TSEG2_SHIFT +			\
+		MCP25XXFD_CAN_DBTCFG_TSEG2_BITS - 1,			\
+		MCP25XXFD_CAN_DBTCFG_TSEG2_SHIFT)
+#  define MCP25XXFD_CAN_DBTCFG_TSEG1_BITS	5
+#  define MCP25XXFD_CAN_DBTCFG_TSEG1_SHIFT	16
+#  define MCP25XXFD_CAN_DBTCFG_TSEG1_MASK				\
+	GENMASK(MCP25XXFD_CAN_DBTCFG_TSEG1_SHIFT +			\
+		MCP25XXFD_CAN_DBTCFG_TSEG1_BITS - 1,			\
+		MCP25XXFD_CAN_DBTCFG_TSEG1_SHIFT)
+#  define MCP25XXFD_CAN_DBTCFG_BRP_BITS		8
+#  define MCP25XXFD_CAN_DBTCFG_BRP_SHIFT	24
+#  define MCP25XXFD_CAN_DBTCFG_BRP_MASK					\
+	GENMASK(MCP25XXFD_CAN_DBTCFG_BRP_SHIFT +			\
+		MCP25XXFD_CAN_DBTCFG_BRP_BITS - 1,			\
+		MCP25XXFD_CAN_DBTCFG_BRP_SHIFT)
+#define MCP25XXFD_CAN_TDC			MCP25XXFD_CAN_SFR_BASE(0x0C)
+#  define MCP25XXFD_CAN_TDC_TDCV_BITS		5
+#  define MCP25XXFD_CAN_TDC_TDCV_SHIFT		0
+#  define MCP25XXFD_CAN_TDC_TDCV_MASK					\
+	GENMASK(MCP25XXFD_CAN_TDC_TDCV_SHIFT +				\
+		MCP25XXFD_CAN_TDC_TDCV_BITS - 1,			\
+		MCP25XXFD_CAN_TDC_TDCV_SHIFT)
+#  define MCP25XXFD_CAN_TDC_TDCO_BITS		5
+#  define MCP25XXFD_CAN_TDC_TDCO_SHIFT		8
+#  define MCP25XXFD_CAN_TDC_TDCO_MASK					\
+	GENMASK(MCP25XXFD_CAN_TDC_TDCO_SHIFT +				\
+		MCP25XXFD_CAN_TDC_TDCO_BITS - 1,			\
+		MCP25XXFD_CAN_TDC_TDCO_SHIFT)
+#  define MCP25XXFD_CAN_TDC_TDCMOD_BITS		2
+#  define MCP25XXFD_CAN_TDC_TDCMOD_SHIFT	16
+#  define MCP25XXFD_CAN_TDC_TDCMOD_MASK					\
+	GENMASK(MCP25XXFD_CAN_TDC_TDCMOD_SHIFT +			\
+		MCP25XXFD_CAN_TDC_TDCMOD_BITS - 1,			\
+		MCP25XXFD_CAN_TDC_TDCMOD_SHIFT)
+#  define MCP25XXFD_CAN_TDC_TDCMOD_DISABLED	0
+#  define MCP25XXFD_CAN_TDC_TDCMOD_MANUAL	1
+#  define MCP25XXFD_CAN_TDC_TDCMOD_AUTO		2
+#  define MCP25XXFD_CAN_TDC_SID11EN		BIT(24)
+#  define MCP25XXFD_CAN_TDC_EDGFLTEN		BIT(25)
+#define MCP25XXFD_CAN_TBC			MCP25XXFD_CAN_SFR_BASE(0x10)
+#define MCP25XXFD_CAN_TSCON			MCP25XXFD_CAN_SFR_BASE(0x14)
+#  define MCP25XXFD_CAN_TSCON_TBCPRE_BITS	10
+#  define MCP25XXFD_CAN_TSCON_TBCPRE_SHIFT	0
+#  define MCP25XXFD_CAN_TSCON_TBCPRE_MASK				\
+	GENMASK(MCP25XXFD_CAN_TSCON_TBCPRE_SHIFT +			\
+		MCP25XXFD_CAN_TSCON_TBCPRE_BITS - 1,			\
+		MCP25XXFD_CAN_TSCON_TBCPRE_SHIFT)
+#  define MCP25XXFD_CAN_TSCON_TBCEN		BIT(16)
+#  define MCP25XXFD_CAN_TSCON_TSEOF		BIT(17)
+#  define MCP25XXFD_CAN_TSCON_TSRES		BIT(18)
+#define MCP25XXFD_CAN_VEC			MCP25XXFD_CAN_SFR_BASE(0x18)
+#  define MCP25XXFD_CAN_VEC_ICODE_BITS		7
+#  define MCP25XXFD_CAN_VEC_ICODE_SHIFT		0
+#  define MCP25XXFD_CAN_VEC_ICODE_MASK					\
+	GENMASK(MCP25XXFD_CAN_VEC_ICODE_SHIFT +				\
+		MCP25XXFD_CAN_VEC_ICODE_BITS - 1,			\
+		MCP25XXFD_CAN_VEC_ICODE_SHIFT)
+#  define MCP25XXFD_CAN_VEC_FILHIT_BITS		5
+#  define MCP25XXFD_CAN_VEC_FILHIT_SHIFT	8
+#  define MCP25XXFD_CAN_VEC_FILHIT_MASK					\
+	GENMASK(MCP25XXFD_CAN_VEC_FILHIT_SHIFT +			\
+		MCP25XXFD_CAN_VEC_FILHIT_BITS - 1,			\
+		MCP25XXFD_CAN_VEC_FILHIT_SHIFT)
+#  define MCP25XXFD_CAN_VEC_TXCODE_BITS		7
+#  define MCP25XXFD_CAN_VEC_TXCODE_SHIFT	16
+#  define MCP25XXFD_CAN_VEC_TXCODE_MASK					\
+	GENMASK(MCP25XXFD_CAN_VEC_TXCODE_SHIFT +			\
+		MCP25XXFD_CAN_VEC_TXCODE_BITS - 1,			\
+		MCP25XXFD_CAN_VEC_TXCODE_SHIFT)
+#  define MCP25XXFD_CAN_VEC_RXCODE_BITS		7
+#  define MCP25XXFD_CAN_VEC_RXCODE_SHIFT	24
+#  define MCP25XXFD_CAN_VEC_RXCODE_MASK					\
+	GENMASK(MCP25XXFD_CAN_VEC_RXCODE_SHIFT +			\
+		MCP25XXFD_CAN_VEC_RXCODE_BITS - 1,			\
+		MCP25XXFD_CAN_VEC_RXCODE_SHIFT)
+#define MCP25XXFD_CAN_INT			MCP25XXFD_CAN_SFR_BASE(0x1C)
+#  define MCP25XXFD_CAN_INT_IF_SHIFT		0
+#  define MCP25XXFD_CAN_INT_TXIF		BIT(0)
+#  define MCP25XXFD_CAN_INT_RXIF		BIT(1)
+#  define MCP25XXFD_CAN_INT_TBCIF		BIT(2)
+#  define MCP25XXFD_CAN_INT_MODIF		BIT(3)
+#  define MCP25XXFD_CAN_INT_TEFIF		BIT(4)
+#  define MCP25XXFD_CAN_INT_ECCIF		BIT(8)
+#  define MCP25XXFD_CAN_INT_SPICRCIF		BIT(9)
+#  define MCP25XXFD_CAN_INT_TXATIF		BIT(10)
+#  define MCP25XXFD_CAN_INT_RXOVIF		BIT(11)
+#  define MCP25XXFD_CAN_INT_SERRIF		BIT(12)
+#  define MCP25XXFD_CAN_INT_CERRIF		BIT(13)
+#  define MCP25XXFD_CAN_INT_WAKIF		BIT(14)
+#  define MCP25XXFD_CAN_INT_IVMIF		BIT(15)
+#  define MCP25XXFD_CAN_INT_IF_MASK					\
+	(MCP25XXFD_CAN_INT_TXIF |					\
+	 MCP25XXFD_CAN_INT_RXIF |					\
+	 MCP25XXFD_CAN_INT_TBCIF |					\
+	 MCP25XXFD_CAN_INT_MODIF |					\
+	 MCP25XXFD_CAN_INT_TEFIF |					\
+	 MCP25XXFD_CAN_INT_ECCIF |					\
+	 MCP25XXFD_CAN_INT_SPICRCIF |					\
+	 MCP25XXFD_CAN_INT_TXATIF |					\
+	 MCP25XXFD_CAN_INT_RXOVIF |					\
+	 MCP25XXFD_CAN_INT_CERRIF |					\
+	 MCP25XXFD_CAN_INT_SERRIF |					\
+	 MCP25XXFD_CAN_INT_WAKIF |					\
+	 MCP25XXFD_CAN_INT_IVMIF)
+#  define MCP25XXFD_CAN_INT_IF_CLEAR_MASK				\
+	(MCP25XXFD_CAN_INT_TBCIF  |					\
+	 MCP25XXFD_CAN_INT_MODIF  |					\
+	 MCP25XXFD_CAN_INT_CERRIF |					\
+	 MCP25XXFD_CAN_INT_SERRIF |					\
+	 MCP25XXFD_CAN_INT_WAKIF |					\
+	 MCP25XXFD_CAN_INT_IVMIF)
+#  define MCP25XXFD_CAN_INT_IE_SHIFT		16
+#  define MCP25XXFD_CAN_INT_TXIE					\
+	(MCP25XXFD_CAN_INT_TXIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_RXIE					\
+	(MCP25XXFD_CAN_INT_RXIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_TBCIE					\
+	(MCP25XXFD_CAN_INT_TBCIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_MODIE					\
+	(MCP25XXFD_CAN_INT_MODIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_TEFIE					\
+	(MCP25XXFD_CAN_INT_TEFIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_ECCIE					\
+	(MCP25XXFD_CAN_INT_ECCIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_SPICRCIE					\
+	(MCP25XXFD_CAN_INT_SPICRCIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_TXATIE					\
+	(MCP25XXFD_CAN_INT_TXATIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_RXOVIE					\
+	(MCP25XXFD_CAN_INT_RXOVIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_CERRIE					\
+	(MCP25XXFD_CAN_INT_CERRIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_SERRIE					\
+	(MCP25XXFD_CAN_INT_SERRIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_WAKIE					\
+	(MCP25XXFD_CAN_INT_WAKIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_IVMIE					\
+	(MCP25XXFD_CAN_INT_IVMIF << MCP25XXFD_CAN_INT_IE_SHIFT)
+#  define MCP25XXFD_CAN_INT_IE_MASK					\
+	(MCP25XXFD_CAN_INT_TXIE |					\
+	 MCP25XXFD_CAN_INT_RXIE |					\
+	 MCP25XXFD_CAN_INT_TBCIE |					\
+	 MCP25XXFD_CAN_INT_MODIE |					\
+	 MCP25XXFD_CAN_INT_TEFIE |					\
+	 MCP25XXFD_CAN_INT_ECCIE |					\
+	 MCP25XXFD_CAN_INT_SPICRCIE |					\
+	 MCP25XXFD_CAN_INT_TXATIE |					\
+	 MCP25XXFD_CAN_INT_RXOVIE |					\
+	 MCP25XXFD_CAN_INT_CERRIE |					\
+	 MCP25XXFD_CAN_INT_SERRIE |					\
+	 MCP25XXFD_CAN_INT_WAKIE |					\
+	 MCP25XXFD_CAN_INT_IVMIE)
+#define MCP25XXFD_CAN_RXIF			MCP25XXFD_CAN_SFR_BASE(0x20)
+#define MCP25XXFD_CAN_TXIF			MCP25XXFD_CAN_SFR_BASE(0x24)
+#define MCP25XXFD_CAN_RXOVIF			MCP25XXFD_CAN_SFR_BASE(0x28)
+#define MCP25XXFD_CAN_TXATIF			MCP25XXFD_CAN_SFR_BASE(0x2C)
+#define MCP25XXFD_CAN_TXREQ			MCP25XXFD_CAN_SFR_BASE(0x30)
+#define MCP25XXFD_CAN_TREC			MCP25XXFD_CAN_SFR_BASE(0x34)
+#  define MCP25XXFD_CAN_TREC_REC_BITS		8
+#  define MCP25XXFD_CAN_TREC_REC_SHIFT		0
+#  define MCP25XXFD_CAN_TREC_REC_MASK					\
+	GENMASK(MCP25XXFD_CAN_TREC_REC_SHIFT +				\
+		MCP25XXFD_CAN_TREC_REC_BITS - 1,			\
+		MCP25XXFD_CAN_TREC_REC_SHIFT)
+#  define MCP25XXFD_CAN_TREC_TEC_BITS		8
+#  define MCP25XXFD_CAN_TREC_TEC_SHIFT		8
+#  define MCP25XXFD_CAN_TREC_TEC_MASK					\
+	GENMASK(MCP25XXFD_CAN_TREC_TEC_SHIFT +				\
+		MCP25XXFD_CAN_TREC_TEC_BITS - 1,			\
+		MCP25XXFD_CAN_TREC_TEC_SHIFT)
+#  define MCP25XXFD_CAN_TREC_EWARN		BIT(16)
+#  define MCP25XXFD_CAN_TREC_RXWARN		BIT(17)
+#  define MCP25XXFD_CAN_TREC_TXWARN		BIT(18)
+#  define MCP25XXFD_CAN_TREC_RXBP		BIT(19)
+#  define MCP25XXFD_CAN_TREC_TXBP		BIT(20)
+#  define MCP25XXFD_CAN_TREC_TXBO		BIT(21)
+#define MCP25XXFD_CAN_BDIAG0			MCP25XXFD_CAN_SFR_BASE(0x38)
+#  define MCP25XXFD_CAN_BDIAG0_NRERRCNT_BITS	8
+#  define MCP25XXFD_CAN_BDIAG0_NRERRCNT_SHIFT	0
+#  define MCP25XXFD_CAN_BDIAG0_NRERRCNT_MASK				\
+	GENMASK(MCP25XXFD_CAN_BDIAG0_NRERRCNT_SHIFT +			\
+		MCP25XXFD_CAN_BDIAG0_NRERRCNT_BITS - 1,			\
+		MCP25XXFD_CAN_BDIAG0_NRERRCNT_SHIFT)
+#  define MCP25XXFD_CAN_BDIAG0_NTERRCNT_BITS	8
+#  define MCP25XXFD_CAN_BDIAG0_NTERRCNT_SHIFT	8
+#  define MCP25XXFD_CAN_BDIAG0_NTERRCNT_MASK				\
+	GENMASK(MCP25XXFD_CAN_BDIAG0_NTERRCNT_SHIFT +			\
+		MCP25XXFD_CAN_BDIAG0_NTERRCNT_BITS - 1,			\
+		MCP25XXFD_CAN_BDIAG0_NTERRCNT_SHIFT)
+#  define MCP25XXFD_CAN_BDIAG0_DRERRCNT_BITS	8
+#  define MCP25XXFD_CAN_BDIAG0_DRERRCNT_SHIFT	16
+#  define MCP25XXFD_CAN_BDIAG0_DRERRCNT_MASK				\
+	GENMASK(MCP25XXFD_CAN_BDIAG0_DRERRCNT_SHIFT +			\
+		MCP25XXFD_CAN_BDIAG0_DRERRCNT_BITS - 1,			\
+		MCP25XXFD_CAN_BDIAG0_DRERRCNT_SHIFT)
+#  define MCP25XXFD_CAN_BDIAG0_DTERRCNT_BITS	8
+#  define MCP25XXFD_CAN_BDIAG0_DTERRCNT_SHIFT	24
+#  define MCP25XXFD_CAN_BDIAG0_DTERRCNT_MASK				\
+	GENMASK(MCP25XXFD_CAN_BDIAG0_DTERRCNT_SHIFT +			\
+		MCP25XXFD_CAN_BDIAG0_DTERRCNT_BITS - 1,			\
+		MCP25XXFD_CAN_BDIAG0_DTERRCNT_SHIFT)
+#define MCP25XXFD_CAN_BDIAG1			MCP25XXFD_CAN_SFR_BASE(0x3C)
+#  define MCP25XXFD_CAN_BDIAG1_EFMSGCNT_BITS	16
+#  define MCP25XXFD_CAN_BDIAG1_EFMSGCNT_SHIFT	0
+#  define MCP25XXFD_CAN_BDIAG1_EFMSGCNT_MASK				\
+	GENMASK(MCP25XXFD_CAN_BDIAG1_EFMSGCNT_SHIFT +			\
+		MCP25XXFD_CAN_BDIAG1_EFMSGCNT_BITS - 1,			\
+		MCP25XXFD_CAN_BDIAG1_EFMSGCNT_SHIFT)
+#  define MCP25XXFD_CAN_BDIAG1_NBIT0ERR		BIT(16)
+#  define MCP25XXFD_CAN_BDIAG1_NBIT1ERR		BIT(17)
+#  define MCP25XXFD_CAN_BDIAG1_NACKERR		BIT(18)
+#  define MCP25XXFD_CAN_BDIAG1_NSTUFERR		BIT(19)
+#  define MCP25XXFD_CAN_BDIAG1_NFORMERR		BIT(20)
+#  define MCP25XXFD_CAN_BDIAG1_NCRCERR		BIT(21)
+#  define MCP25XXFD_CAN_BDIAG1_TXBOERR		BIT(23)
+#  define MCP25XXFD_CAN_BDIAG1_DBIT0ERR		BIT(24)
+#  define MCP25XXFD_CAN_BDIAG1_DBIT1ERR		BIT(25)
+#  define MCP25XXFD_CAN_BDIAG1_DFORMERR		BIT(27)
+#  define MCP25XXFD_CAN_BDIAG1_DSTUFERR		BIT(28)
+#  define MCP25XXFD_CAN_BDIAG1_DCRCERR		BIT(29)
+#  define MCP25XXFD_CAN_BDIAG1_ESI		BIT(30)
+#  define MCP25XXFD_CAN_BDIAG1_DLCMM		BIT(31)
+#define MCP25XXFD_CAN_TEFCON			MCP25XXFD_CAN_SFR_BASE(0x40)
+#  define MCP25XXFD_CAN_TEFCON_TEFNEIE		BIT(0)
+#  define MCP25XXFD_CAN_TEFCON_TEFHIE		BIT(1)
+#  define MCP25XXFD_CAN_TEFCON_TEFFIE		BIT(2)
+#  define MCP25XXFD_CAN_TEFCON_TEFOVIE		BIT(3)
+#  define MCP25XXFD_CAN_TEFCON_TEFTSEN		BIT(5)
+#  define MCP25XXFD_CAN_TEFCON_UINC		BIT(8)
+#  define MCP25XXFD_CAN_TEFCON_FRESET		BIT(10)
+#  define MCP25XXFD_CAN_TEFCON_FSIZE_BITS	5
+#  define MCP25XXFD_CAN_TEFCON_FSIZE_SHIFT	24
+#  define MCP25XXFD_CAN_TEFCON_FSIZE_MASK				\
+	GENMASK(MCP25XXFD_CAN_TEFCON_FSIZE_SHIFT +			\
+		MCP25XXFD_CAN_TEFCON_FSIZE_BITS - 1,			\
+		MCP25XXFD_CAN_TEFCON_FSIZE_SHIFT)
+#define MCP25XXFD_CAN_TEFSTA			MCP25XXFD_CAN_SFR_BASE(0x44)
+#  define MCP25XXFD_CAN_TEFSTA_TEFNEIF		BIT(0)
+#  define MCP25XXFD_CAN_TEFSTA_TEFHIF		BIT(1)
+#  define MCP25XXFD_CAN_TEFSTA_TEFFIF		BIT(2)
+#  define MCP25XXFD_CAN_TEFSTA_TEVOVIF		BIT(3)
+#define MCP25XXFD_CAN_TEFUA			MCP25XXFD_CAN_SFR_BASE(0x48)
+#define MCP25XXFD_CAN_RESERVED			MCP25XXFD_CAN_SFR_BASE(0x4C)
+#define MCP25XXFD_CAN_TXQCON			MCP25XXFD_CAN_SFR_BASE(0x50)
+#  define MCP25XXFD_CAN_TXQCON_TXQNIE		BIT(0)
+#  define MCP25XXFD_CAN_TXQCON_TXQEIE		BIT(2)
+#  define MCP25XXFD_CAN_TXQCON_TXATIE		BIT(4)
+#  define MCP25XXFD_CAN_TXQCON_TXEN		BIT(7)
+#  define MCP25XXFD_CAN_TXQCON_UINC		BIT(8)
+#  define MCP25XXFD_CAN_TXQCON_TXREQ		BIT(9)
+#  define MCP25XXFD_CAN_TXQCON_FRESET		BIT(10)
+#  define MCP25XXFD_CAN_TXQCON_TXPRI_BITS	5
+#  define MCP25XXFD_CAN_TXQCON_TXPRI_SHIFT	16
+#  define MCP25XXFD_CAN_TXQCON_TXPRI_MASK				\
+	GENMASK(MCP25XXFD_CAN_TXQCON_TXPRI_SHIFT +			\
+		MCP25XXFD_CAN_TXQCON_TXPRI_BITS - 1,			\
+		MCP25XXFD_CAN_TXQCON_TXPRI_SHIFT)
+#  define MCP25XXFD_CAN_TXQCON_TXAT_BITS	2
+#  define MCP25XXFD_CAN_TXQCON_TXAT_SHIFT	21
+#  define MCP25XXFD_CAN_TXQCON_TXAT_MASK				\
+	GENMASK(MCP25XXFD_CAN_TXQCON_TXAT_SHIFT +			\
+		#MCP25XXFD_CAN_TXQCON_TXAT_BITS - 1,			\
+		MCP25XXFD_CAN_TXQCON_TXAT_SHIFT)
+#  define MCP25XXFD_CAN_TXQCON_FSIZE_BITS	5
+#  define MCP25XXFD_CAN_TXQCON_FSIZE_SHIFT	24
+#  define MCP25XXFD_CAN_TXQCON_FSIZE_MASK				\
+	GENMASK(MCP25XXFD_CAN_TXQCON_FSIZE_SHIFT +			\
+		MCP25XXFD_CAN_TXQCON_FSIZE_BITS - 1,			\
+		MCP25XXFD_CAN_TXQCON_FSIZE_SHIFT)
+#  define MCP25XXFD_CAN_TXQCON_PLSIZE_BITS	3
+#  define MCP25XXFD_CAN_TXQCON_PLSIZE_SHIFT	29
+#  define MCP25XXFD_CAN_TXQCON_PLSIZE_MASK				\
+	GENMASK(MCP25XXFD_CAN_TXQCON_PLSIZE_SHIFT +			\
+		MCP25XXFD_CAN_TXQCON_PLSIZE_BITS - 1,			\
+		MCP25XXFD_CAN_TXQCON_PLSIZE_SHIFT)
+#    define MCP25XXFD_CAN_TXQCON_PLSIZE_8	0
+#    define MCP25XXFD_CAN_TXQCON_PLSIZE_12	1
+#    define MCP25XXFD_CAN_TXQCON_PLSIZE_16	2
+#    define MCP25XXFD_CAN_TXQCON_PLSIZE_20	3
+#    define MCP25XXFD_CAN_TXQCON_PLSIZE_24	4
+#    define MCP25XXFD_CAN_TXQCON_PLSIZE_32	5
+#    define MCP25XXFD_CAN_TXQCON_PLSIZE_48	6
+#    define MCP25XXFD_CAN_TXQCON_PLSIZE_64	7
+
+#define MCP25XXFD_CAN_TXQSTA			MCP25XXFD_CAN_SFR_BASE(0x54)
+#  define MCP25XXFD_CAN_TXQSTA_TXQNIF		BIT(0)
+#  define MCP25XXFD_CAN_TXQSTA_TXQEIF		BIT(2)
+#  define MCP25XXFD_CAN_TXQSTA_TXATIF		BIT(4)
+#  define MCP25XXFD_CAN_TXQSTA_TXERR		BIT(5)
+#  define MCP25XXFD_CAN_TXQSTA_TXLARB		BIT(6)
+#  define MCP25XXFD_CAN_TXQSTA_TXABT		BIT(7)
+#  define MCP25XXFD_CAN_TXQSTA_TXQCI_BITS	5
+#  define MCP25XXFD_CAN_TXQSTA_TXQCI_SHIFT	8
+#  define MCP25XXFD_CAN_TXQSTA_TXQCI_MASK				\
+	GENMASK(MCP25XXFD_CAN_TXQSTA_TXQCI_SHIFT +			\
+		MCP25XXFD_CAN_TXQSTA_TXQCI_BITS - 1,			\
+		MCP25XXFD_CAN_TXQSTA_TXQCI_SHIFT)
+
+#define MCP25XXFD_CAN_TXQUA			MCP25XXFD_CAN_SFR_BASE(0x58)
+#define MCP25XXFD_CAN_FIFOCON(x)					\
+	MCP25XXFD_CAN_SFR_BASE(0x5C + 12 * ((x) - 1))
+#define MCP25XXFD_CAN_FIFOCON_TFNRFNIE		BIT(0)
+#define MCP25XXFD_CAN_FIFOCON_TFHRFHIE		BIT(1)
+#define MCP25XXFD_CAN_FIFOCON_TFERFFIE		BIT(2)
+#define MCP25XXFD_CAN_FIFOCON_RXOVIE		BIT(3)
+#define MCP25XXFD_CAN_FIFOCON_TXATIE		BIT(4)
+#define MCP25XXFD_CAN_FIFOCON_RXTSEN		BIT(5)
+#define MCP25XXFD_CAN_FIFOCON_RTREN		BIT(6)
+#define MCP25XXFD_CAN_FIFOCON_TXEN		BIT(7)
+#define MCP25XXFD_CAN_FIFOCON_UINC		BIT(8)
+#define MCP25XXFD_CAN_FIFOCON_TXREQ		BIT(9)
+#define MCP25XXFD_CAN_FIFOCON_FRESET		BIT(10)
+#  define MCP25XXFD_CAN_FIFOCON_TXPRI_BITS	5
+#  define MCP25XXFD_CAN_FIFOCON_TXPRI_SHIFT	16
+#  define MCP25XXFD_CAN_FIFOCON_TXPRI_MASK				\
+	GENMASK(MCP25XXFD_CAN_FIFOCON_TXPRI_SHIFT +			\
+		MCP25XXFD_CAN_FIFOCON_TXPRI_BITS - 1,			\
+		MCP25XXFD_CAN_FIFOCON_TXPRI_SHIFT)
+#  define MCP25XXFD_CAN_FIFOCON_TXAT_BITS	2
+#  define MCP25XXFD_CAN_FIFOCON_TXAT_SHIFT	21
+#  define MCP25XXFD_CAN_FIFOCON_TXAT_MASK				\
+	GENMASK(MCP25XXFD_CAN_FIFOCON_TXAT_SHIFT +			\
+		MCP25XXFD_CAN_FIFOCON_TXAT_BITS - 1,			\
+		MCP25XXFD_CAN_FIFOCON_TXAT_SHIFT)
+#  define MCP25XXFD_CAN_FIFOCON_TXAT_ONE_SHOT	0
+#  define MCP25XXFD_CAN_FIFOCON_TXAT_THREE_SHOT	1
+#  define MCP25XXFD_CAN_FIFOCON_TXAT_UNLIMITED	2
+#  define MCP25XXFD_CAN_FIFOCON_FSIZE_BITS	5
+#  define MCP25XXFD_CAN_FIFOCON_FSIZE_SHIFT	24
+#  define MCP25XXFD_CAN_FIFOCON_FSIZE_MASK				\
+	GENMASK(MCP25XXFD_CAN_FIFOCON_FSIZE_SHIFT +			\
+		MCP25XXFD_CAN_FIFOCON_FSIZE_BITS - 1,			\
+		MCP25XXFD_CAN_FIFOCON_FSIZE_SHIFT)
+#  define MCP25XXFD_CAN_FIFOCON_PLSIZE_BITS	3
+#  define MCP25XXFD_CAN_FIFOCON_PLSIZE_SHIFT	29
+#  define MCP25XXFD_CAN_FIFOCON_PLSIZE_MASK				\
+	GENMASK(MCP25XXFD_CAN_FIFOCON_PLSIZE_SHIFT +			\
+		MCP25XXFD_CAN_FIFOCON_PLSIZE_BITS - 1,			\
+		MCP25XXFD_CAN_FIFOCON_PLSIZE_SHIFT)
+#define MCP25XXFD_CAN_FIFOSTA(x)					\
+	MCP25XXFD_CAN_SFR_BASE(0x60 + 12 * ((x) - 1))
+#  define MCP25XXFD_CAN_FIFOSTA_TFNRFNIF	BIT(0)
+#  define MCP25XXFD_CAN_FIFOSTA_TFHRFHIF	BIT(1)
+#  define MCP25XXFD_CAN_FIFOSTA_TFERFFIF	BIT(2)
+#  define MCP25XXFD_CAN_FIFOSTA_RXOVIF		BIT(3)
+#  define MCP25XXFD_CAN_FIFOSTA_TXATIF		BIT(4)
+#  define MCP25XXFD_CAN_FIFOSTA_TXERR		BIT(5)
+#  define MCP25XXFD_CAN_FIFOSTA_TXLARB		BIT(6)
+#  define MCP25XXFD_CAN_FIFOSTA_TXABT		BIT(7)
+#  define MCP25XXFD_CAN_FIFOSTA_FIFOCI_BITS	5
+#  define MCP25XXFD_CAN_FIFOSTA_FIFOCI_SHIFT	8
+#  define MCP25XXFD_CAN_FIFOSTA_FIFOCI_MASK				\
+	GENMASK(MCP25XXFD_CAN_FIFOSTA_FIFOCI_SHIFT +			\
+		MCP25XXFD_CAN_FIFOSTA_FIFOCI_BITS - 1,			\
+		MCP25XXFD_CAN_FIFOSTA_FIFOCI_SHIFT)
+#define MCP25XXFD_CAN_FIFOUA(x)						\
+	MCP25XXFD_CAN_SFR_BASE(0x64 + 12 * ((x) - 1))
+#define MCP25XXFD_CAN_FLTCON(x)						\
+	MCP25XXFD_CAN_SFR_BASE(0x1D0 + ((x) & 0x1c))
+#  define MCP25XXFD_CAN_FILCON_SHIFT(x)		(((x) & 3) * 8)
+#  define MCP25XXFD_CAN_FILCON_BITS(x)		MCP25XXFD_CAN_FILCON_BITS_
+#  define MCP25XXFD_CAN_FILCON_BITS_		4
+	/* avoid macro reuse warning, so do not use GENMASK as above */
+#  define MCP25XXFD_CAN_FILCON_MASK(x)					\
+	(GENMASK(MCP25XXFD_CAN_FILCON_BITS_ - 1, 0) <<			\
+	 MCP25XXFD_CAN_FILCON_SHIFT(x))
+#  define MCP25XXFD_CAN_FIFOCON_FLTEN(x)				\
+	BIT(7 + MCP25XXFD_CAN_FILCON_SHIFT(x))
+#define MCP25XXFD_CAN_FLTOBJ(x)						\
+	MCP25XXFD_CAN_SFR_BASE(0x1F0 + 8 * (x))
+#  define MCP25XXFD_CAN_FILOBJ_SID_BITS		11
+#  define MCP25XXFD_CAN_FILOBJ_SID_SHIFT	0
+#  define MCP25XXFD_CAN_FILOBJ_SID_MASK					\
+	GENMASK(MCP25XXFD_CAN_FILOBJ_SID_SHIFT +			\
+		MCP25XXFD_CAN_FILOBJ_SID_BITS - 1,			\
+		MCP25XXFD_CAN_FILOBJ_SID_SHIFT)
+#  define MCP25XXFD_CAN_FILOBJ_EID_BITS		18
+#  define MCP25XXFD_CAN_FILOBJ_EID_SHIFT	12
+#  define MCP25XXFD_CAN_FILOBJ_EID_MASK					\
+	GENMASK(MCP25XXFD_CAN_FILOBJ_EID_SHIFT +			\
+		MCP25XXFD_CAN_FILOBJ_EID_BITS - 1,			\
+		MCP25XXFD_CAN_FILOBJ_EID_SHIFT)
+#  define MCP25XXFD_CAN_FILOBJ_SID11		BIT(29)
+#  define MCP25XXFD_CAN_FILOBJ_EXIDE		BIT(30)
+#define MCP25XXFD_CAN_FLTMASK(x)					\
+	MCP25XXFD_CAN_SFR_BASE(0x1F4 + 8 * (x))
+#  define MCP25XXFD_CAN_FILMASK_MSID_BITS	11
+#  define MCP25XXFD_CAN_FILMASK_MSID_SHIFT	0
+#  define MCP25XXFD_CAN_FILMASK_MSID_MASK				\
+	GENMASK(MCP25XXFD_CAN_FILMASK_MSID_SHIFT +			\
+		MCP25XXFD_CAN_FILMASK_MSID_BITS - 1,			\
+		MCP25XXFD_CAN_FILMASK_MSID_SHIFT)
+#  define MCP25XXFD_CAN_FILMASK_MEID_BITS	18
+#  define MCP25XXFD_CAN_FILMASK_MEID_SHIFT	12
+#  define MCP25XXFD_CAN_FILMASK_MEID_MASK				\
+	GENMASK(MCP25XXFD_CAN_FILMASK_MEID_SHIFT +			\
+		MCP25XXFD_CAN_FILMASK_MEID_BITS - 1,			\
+		MCP25XXFD_CAN_FILMASK_MEID_SHIFT)
+#  define MCP25XXFD_CAN_FILMASK_MSID11		BIT(29)
+#  define MCP25XXFD_CAN_FILMASK_MIDE		BIT(30)
+
+/* the FIFO Objects in SRAM */
+#define MCP25XXFD_SRAM_SIZE 2048
+#define MCP25XXFD_SRAM_ADDR(x) (0x400 + (x))
+
+/* memory structure in sram for tx fifos */
+struct mcp25xxfd_can_obj_tx {
+	u32 id;
+	u32 flags;
+	u8 data[];
+};
+
+/* memory structure in sram for rx fifos */
+struct mcp25xxfd_can_obj_rx {
+	u32 id;
+	u32 flags;
+	u32 ts;
+	u8 data[];
+};
+
+/* memory structure in sram for tef fifos */
+struct mcp25xxfd_can_obj_tef {
+	u32 id;
+	u32 flags;
+	u32 ts;
+};
+
+#define MCP25XXFD_CAN_OBJ_ID_SID_BITS		11
+#define MCP25XXFD_CAN_OBJ_ID_SID_SHIFT		0
+#define MCP25XXFD_CAN_OBJ_ID_SID_MASK					\
+	GENMASK(MCP25XXFD_CAN_OBJ_ID_SID_SHIFT +			\
+		MCP25XXFD_CAN_OBJ_ID_SID_BITS - 1,			\
+		MCP25XXFD_CAN_OBJ_ID_SID_SHIFT)
+#define MCP25XXFD_CAN_OBJ_ID_EID_BITS		18
+#define MCP25XXFD_CAN_OBJ_ID_EID_SHIFT		11
+#define MCP25XXFD_CAN_OBJ_ID_EID_MASK					\
+	GENMASK(MCP25XXFD_CAN_OBJ_ID_EID_SHIFT +			\
+		MCP25XXFD_CAN_OBJ_ID_EID_BITS - 1,			\
+		MCP25XXFD_CAN_OBJ_ID_EID_SHIFT)
+#define MCP25XXFD_CAN_OBJ_ID_SID_BIT11		BIT(29)
+
+#define MCP25XXFD_CAN_OBJ_FLAGS_DLC_BITS	4
+#define MCP25XXFD_CAN_OBJ_FLAGS_DLC_SHIFT	0
+#define MCP25XXFD_CAN_OBJ_FLAGS_DLC_MASK				\
+	GENMASK(MCP25XXFD_CAN_OBJ_FLAGS_DLC_SHIFT +			\
+		MCP25XXFD_CAN_OBJ_FLAGS_DLC_BITS - 1,			\
+		MCP25XXFD_CAN_OBJ_FLAGS_DLC_SHIFT)
+#define MCP25XXFD_CAN_OBJ_FLAGS_IDE		BIT(4)
+#define MCP25XXFD_CAN_OBJ_FLAGS_RTR		BIT(5)
+#define MCP25XXFD_CAN_OBJ_FLAGS_BRS		BIT(6)
+#define MCP25XXFD_CAN_OBJ_FLAGS_FDF		BIT(7)
+#define MCP25XXFD_CAN_OBJ_FLAGS_ESI		BIT(8)
+#define MCP25XXFD_CAN_OBJ_FLAGS_SEQ_BITS	7
+#define MCP25XXFD_CAN_OBJ_FLAGS_SEQ_SHIFT	9
+#define MCP25XXFD_CAN_OBJ_FLAGS_SEQ_MASK				\
+	GENMASK(MCP25XXFD_CAN_OBJ_FLAGS_SEQ_SHIFT +			\
+		MCP25XXFD_CAN_OBJ_FLAGS_SEQ_BITS - 1,			\
+		MCP25XXFD_CAN_OBJ_FLAGS_SEQ_SHIFT)
+#define MCP25XXFD_CAN_OBJ_FLAGS_FILHIT_BITS	11
+#define MCP25XXFD_CAN_OBJ_FLAGS_FILHIT_SHIFT	5
+#define MCP25XXFD_CAN_OBJ_FLAGS_FILHIT_MASK				\
+	GENMASK(MCP25XXFD_CAN_FLAGS_FILHIT_SHIFT +			\
+		MCP25XXFD_CAN_FLAGS_FILHIT_BITS - 1,			\
+		MCP25XXFD_CAN_FLAGS_FILHIT_SHIFT)
+
+#endif /* __MCP25XXFD_REGS_H */
-- 
2.17.1

