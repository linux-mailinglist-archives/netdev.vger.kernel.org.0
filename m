Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C39F485D20
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343731AbiAFA1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343702AbiAFA1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:27:07 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B35C0611FD
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 16:27:07 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id y9so826307pgr.11
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 16:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bluerivertech.com; s=google;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=J4DVZfSEHc+5lwv7xu8XA+IYBgCz30iR8NpK/PggUiU=;
        b=e/KtI/dthbUT5strgq7i/oCnNUR28WLY2PI6kprFOLnhJG0NYtSAOhzL9t91+q7vtO
         X/6XBbmb/ml4JI05ax97C/zI+KfHaJ1ussMxSNVouHCoe2rWo98A0mHTFgB0s1c7GJK5
         nEa1sSwZGkz1D4KMMUrXZ6beNqj9+UXrg2ybSmZLSQ3xED743VQNR3V85kAeGs7xxGJO
         xlwxxbtaYiXPhWfVh3DKRMhKH0tOSzlysypPv+1xqD9sOl1VhGtDL84GNShHXJZqMr6c
         8+y+BGPLF/LMZhofq/qlOb3OVPQzBjufdkanTTcmm6FVNCDREx4H/tjp2ObMhU3CNqtw
         YgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=J4DVZfSEHc+5lwv7xu8XA+IYBgCz30iR8NpK/PggUiU=;
        b=WCPP2px+L/PAGc9jzei4+4znfVAGGiBYRCyQ7S5AAPZ3bgtelCQMK4aI5+TfUkdAmM
         abcSO63mVcU9A89+QnDlTVC+0LzgwwmED8lOVA219LKq8JnLY38udU4U3FuUdIWsN5pc
         zZxczinn/6mHhItAcd4EzEWWZB9acFY9ecDMijhKJ+wWbFA5ZVi69U5/3INHIDU1wgFF
         Ztqq14z1osqab1plrFUi3k33p81zvERhIYIWTXvqmFL4FNW7S9gzuCzl8j4UUi8q+qZe
         jIESrFg0QO06f4sIXS0kbQ1IR5RVg7J7C1pF09VZODGv4zO0yN6fR066MVjQNCvB8+tV
         8Wzg==
X-Gm-Message-State: AOAM5314CuzskXD4wB3dpuDUaKqqpk6BhFrrHLrrf2XaFU3tlM/YOQ6B
        SZ4VuBrpWGg5j9Cyx6g8wIenLA==
X-Google-Smtp-Source: ABdhPJw7FJNHh3B4AmQureIxpKhsaNHdS5jphlEqWHnuN8cumYwSsJ9KI2AN2uFHmZoSc77wMfZyAA==
X-Received: by 2002:a65:6853:: with SMTP id q19mr50700441pgt.612.1641428826848;
        Wed, 05 Jan 2022 16:27:06 -0800 (PST)
Received: from localhost.localdomain (c-73-231-33-37.hsd1.ca.comcast.net. [73.231.33.37])
        by smtp.gmail.com with ESMTPSA id c9sm230622pfc.61.2022.01.05.16.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 16:27:06 -0800 (PST)
From:   Brian Silverman <brian.silverman@bluerivertech.com>
Cc:     Brian Silverman <bsilver16384@gmail.com>,
        Brian Silverman <brian.silverman@bluerivertech.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-can@vger.kernel.org (open list:CAN NETWORK DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-tegra@vger.kernel.org (open list:TEGRA ARCHITECTURE SUPPORT)
Subject: [RFC PATCH] can: m_can: Add driver for M_CAN hardware in NVIDIA devices
Date:   Wed,  5 Jan 2022 16:25:09 -0800
Message-Id: <20220106002514.24589-1-brian.silverman@bluerivertech.com>
X-Mailer: git-send-email 2.20.1
Reply-To: Brian Silverman <bsilver16384@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a M_TTCAN with some NVIDIA-specific glue logic and clocks. The
existing m_can driver works with it after handling the glue logic.

The code is a combination of pieces from m_can_platform and NVIDIA's
driver [1].

[1] https://github.com/hartkopp/nvidia-t18x-can/blob/master/r32.2.1/nvidia/drivers/net/can/mttcan/hal/m_ttcan.c

Signed-off-by: Brian Silverman <brian.silverman@bluerivertech.com>
---
I ran into bugs with the error handling in NVIDIA's m_ttcan driver, so I
switched to m_can which has been much better. I'm looking for feedback
on whether I should ensure rebasing hasn't broken anything, write up DT
documentation, and submit this patch for real. The driver works great,
but I've got some questions about submitting it.

question: This has liberal copying of GPL code from NVIDIA's
non-upstreamed m_ttcan driver. Is that OK?

corollary: I don't know what any of this glue logic does. I do know the
device doesn't work without it. I can't find any documentation of what
these addresses do.

question: There is some duplication between this and m_can_platform. It
doesn't seem too bad to me, but is this the preferred way to do it or is
there another alternative?

question: Do new DT bindings need to be in the YAML format, or is the
.txt one OK?

 drivers/net/can/m_can/Kconfig       |  10 +
 drivers/net/can/m_can/Makefile      |   1 +
 drivers/net/can/m_can/m_can_tegra.c | 362 ++++++++++++++++++++++++++++
 3 files changed, 373 insertions(+)
 create mode 100644 drivers/net/can/m_can/m_can_tegra.c

diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index 45ad1b3f0cd0..00e042cb7d33 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -22,6 +22,16 @@ config CAN_M_CAN_PLATFORM
 	  This support is for devices that have the Bosch M_CAN controller
 	  IP embedded into the device and the IP is IO Mapped to the processor.
 
+config CAN_M_CAN_TEGRA
+	tristate "Bosch M_CAN support for io-mapped devices on NVIDIA Tegra"
+	depends on HAS_IOMEM
+	---help---
+	  Say Y here if you want support for IO Mapped Bosch M_CAN controller,
+	  with additional NVIDIA Tegra-specific glue logic.
+	  This support is for Tegra devices that have the Bosch M_CAN/M_TTCAN
+		controller IP embedded into the device and the IP is IO Mapped to the
+		processor.
+
 config CAN_M_CAN_TCAN4X5X
 	depends on SPI
 	select REGMAP_SPI
diff --git a/drivers/net/can/m_can/Makefile b/drivers/net/can/m_can/Makefile
index d717bbc9e033..36360c1c5eca 100644
--- a/drivers/net/can/m_can/Makefile
+++ b/drivers/net/can/m_can/Makefile
@@ -6,6 +6,7 @@
 obj-$(CONFIG_CAN_M_CAN) += m_can.o
 obj-$(CONFIG_CAN_M_CAN_PCI) += m_can_pci.o
 obj-$(CONFIG_CAN_M_CAN_PLATFORM) += m_can_platform.o
+obj-$(CONFIG_CAN_M_CAN_TEGRA) += m_can_tegra.o
 obj-$(CONFIG_CAN_M_CAN_TCAN4X5X) += tcan4x5x.o
 
 tcan4x5x-objs :=
diff --git a/drivers/net/can/m_can/m_can_tegra.c b/drivers/net/can/m_can/m_can_tegra.c
new file mode 100644
index 000000000000..3739b92b4540
--- /dev/null
+++ b/drivers/net/can/m_can/m_can_tegra.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: GPL-2.0
+// IOMapped CAN bus driver for Bosch M_CAN controller on NVIDIA Tegra
+
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+
+#include "m_can.h"
+
+struct m_can_tegra_priv {
+	struct m_can_classdev cdev;
+
+	void __iomem *base;
+	void __iomem *mram_base;
+	void __iomem *glue_base;
+	// cclk is core_clk if it exists, otherwise can_clk.
+	struct clk *core_clk, *can_clk, *pll_clk;
+};
+
+static inline struct m_can_tegra_priv *cdev_to_priv(struct m_can_classdev *cdev)
+{
+	return container_of(cdev, struct m_can_tegra_priv, cdev);
+}
+
+static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
+{
+	struct m_can_tegra_priv *priv = cdev_to_priv(cdev);
+
+	return readl(priv->base + reg);
+}
+
+static u32 iomap_read_fifo(struct m_can_classdev *cdev, int offset)
+{
+	struct m_can_tegra_priv *priv = cdev_to_priv(cdev);
+
+	return readl(priv->mram_base + offset);
+}
+
+static u32 iomap_read_glue(struct m_can_classdev *cdev, int reg)
+{
+	struct m_can_tegra_priv *priv = cdev_to_priv(cdev);
+
+	return readl(priv->glue_base + reg);
+}
+
+static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
+{
+	struct m_can_tegra_priv *priv = cdev_to_priv(cdev);
+
+	writel(val, priv->base + reg);
+
+	return 0;
+}
+
+static int iomap_write_fifo(struct m_can_classdev *cdev, int offset, int val)
+{
+	struct m_can_tegra_priv *priv = cdev_to_priv(cdev);
+
+	writel(val, priv->mram_base + offset);
+
+	return 0;
+}
+
+static int iomap_write_glue(struct m_can_classdev *cdev, int reg, int val)
+{
+	struct m_can_tegra_priv *priv = cdev_to_priv(cdev);
+
+	writel(val, priv->glue_base + reg);
+
+	return 0;
+}
+
+static struct m_can_ops m_can_tegra_ops = {
+	.read_reg = iomap_read_reg,
+	.write_reg = iomap_write_reg,
+	.write_fifo = iomap_write_fifo,
+	.read_fifo = iomap_read_fifo,
+};
+
+/* Glue logic apperature */
+#define ADDR_M_TTCAN_IR          0x00
+#define ADDR_M_TTCAN_TTIR        0x04
+#define ADDR_M_TTCAN_TXBRP       0x08
+#define ADDR_M_TTCAN_FD_DATA     0x0C
+#define ADDR_M_TTCAN_STATUS_REG  0x10
+#define ADDR_M_TTCAN_CNTRL_REG   0x14
+#define ADDR_M_TTCAN_DMA_INTF0   0x18
+#define ADDR_M_TTCAN_CLK_STOP    0x1C
+#define ADDR_M_TTCAN_HSM_MASK0   0x20
+#define ADDR_M_TTCAN_HSM_MASK1   0x24
+#define ADDR_M_TTCAN_EXT_SYC_SLT 0x28
+#define ADDR_M_TTCAN_HSM_SW_OVRD 0x2C
+#define ADDR_M_TTCAN_TIME_STAMP  0x30
+
+#define M_TTCAN_CNTRL_REG_COK           (1<<3)
+#define M_TTCAN_TIME_STAMP_OFFSET_SEL   4
+
+static void tegra_can_set_ok(struct m_can_classdev *cdev)
+{
+	u32 val;
+
+	val = iomap_read_glue(cdev, ADDR_M_TTCAN_CNTRL_REG);
+	val |= M_TTCAN_CNTRL_REG_COK;
+	iomap_write_glue(cdev, ADDR_M_TTCAN_CNTRL_REG, val);
+}
+
+
+static int m_can_tegra_probe(struct platform_device *pdev)
+{
+	struct m_can_classdev *mcan_class;
+	struct m_can_tegra_priv *priv;
+	struct resource *res;
+	void __iomem *addr;
+	void __iomem *mram_addr;
+	void __iomem *glue_addr;
+	struct reset_control *rstc;
+	struct clk *host_clk = NULL, *can_clk = NULL, *core_clk = NULL, *pclk = NULL;
+	int irq, ret = 0;
+	u32 rate;
+	unsigned long new_rate;
+
+	mcan_class = m_can_class_allocate_dev(&pdev->dev,
+					      sizeof(struct m_can_tegra_priv));
+	if (!mcan_class)
+		return -ENOMEM;
+
+	priv = cdev_to_priv(mcan_class);
+
+	host_clk = devm_clk_get(&pdev->dev, "can_host");
+	if (IS_ERR(host_clk)) {
+		ret = PTR_ERR(host_clk);
+		goto probe_fail;
+	}
+	can_clk = devm_clk_get(&pdev->dev, "can");
+	if (IS_ERR(can_clk)) {
+		ret = PTR_ERR(can_clk);
+		goto probe_fail;
+	}
+
+	core_clk = devm_clk_get(&pdev->dev, "can_core");
+	if (IS_ERR(core_clk)) {
+		core_clk = NULL;
+	}
+
+	pclk = clk_get(&pdev->dev, "pll");
+	if (IS_ERR(pclk)) {
+		ret = PTR_ERR(pclk);
+		goto probe_fail;
+	}
+
+	ret = clk_set_parent(can_clk, pclk);
+	if (ret) {
+		goto probe_fail;
+	}
+
+	ret = fwnode_property_read_u32(dev_fwnode(&pdev->dev), "can-clk-rate", &rate);
+	if (ret) {
+		goto probe_fail;
+	}
+
+	new_rate = clk_round_rate(can_clk, rate);
+	if (!new_rate)
+		dev_warn(&pdev->dev, "incorrect CAN clock rate\n");
+
+	ret = clk_set_rate(can_clk, new_rate > 0 ? new_rate : rate);
+	if (ret) {
+		goto probe_fail;
+	}
+
+	ret = clk_set_rate(host_clk, new_rate > 0 ? new_rate : rate);
+	if (ret) {
+		goto probe_fail;
+	}
+
+	if (core_clk) {
+		ret = fwnode_property_read_u32(dev_fwnode(&pdev->dev), "core-clk-rate", &rate);
+		if (ret) {
+			goto probe_fail;
+		}
+		new_rate = clk_round_rate(core_clk, rate);
+		if (!new_rate)
+			dev_warn(&pdev->dev, "incorrect CAN_CORE clock rate\n");
+
+		ret = clk_set_rate(core_clk, new_rate > 0 ? new_rate : rate);
+		if (ret) {
+			goto probe_fail;
+		}
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "m_can");
+	addr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(addr)) {
+		ret = PTR_ERR(addr);
+		goto probe_fail;
+	}
+
+	irq = platform_get_irq_byname(pdev, "int0");
+	if (irq < 0) {
+		ret = -ENODEV;
+		goto probe_fail;
+	}
+
+	/* message ram could be shared */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
+	mram_addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!mram_addr) {
+		ret = -ENOMEM;
+		goto probe_fail;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "glue_regs");
+	glue_addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!glue_addr) {
+		ret = -ENOMEM;
+		goto probe_fail;
+	}
+
+	rstc = devm_reset_control_get(&pdev->dev, "can");
+	if (IS_ERR(rstc)) {
+		ret = PTR_ERR(rstc);
+		goto probe_fail;
+	}
+	reset_control_reset(rstc);
+
+	priv->can_clk = can_clk;
+	mcan_class->hclk = host_clk;
+
+	if (core_clk) {
+		mcan_class->cclk = core_clk;
+	} else {
+		mcan_class->cclk = can_clk;
+	}
+	priv->core_clk = core_clk;
+
+	priv->base = addr;
+	priv->mram_base = mram_addr;
+	priv->glue_base = glue_addr;
+
+	mcan_class->net->irq = irq;
+	mcan_class->pm_clock_support = 1;
+	mcan_class->can.clock.freq = clk_get_rate(mcan_class->cclk);
+	mcan_class->dev = &pdev->dev;
+
+	mcan_class->ops = &m_can_tegra_ops;
+
+	mcan_class->is_peripheral = false;
+
+	platform_set_drvdata(pdev, mcan_class);
+
+	pm_runtime_enable(mcan_class->dev);
+
+	ret = pm_runtime_get_sync(mcan_class->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(mcan_class->dev);
+		goto out_runtime_disable;
+	}
+	tegra_can_set_ok(mcan_class);
+	m_can_init_ram(mcan_class);
+	pm_runtime_put_sync(mcan_class->dev);
+
+	ret = m_can_class_register(mcan_class);
+	if (ret)
+		goto out_runtime_disable;
+
+	return ret;
+
+out_runtime_disable:
+	pm_runtime_disable(mcan_class->dev);
+probe_fail:
+	m_can_class_free_dev(mcan_class->net);
+	return ret;
+}
+
+static __maybe_unused int m_can_suspend(struct device *dev)
+{
+	return m_can_class_suspend(dev);
+}
+
+static __maybe_unused int m_can_resume(struct device *dev)
+{
+	return m_can_class_resume(dev);
+}
+
+static int m_can_tegra_remove(struct platform_device *pdev)
+{
+	struct m_can_tegra_priv *priv = platform_get_drvdata(pdev);
+	struct m_can_classdev *mcan_class = &priv->cdev;
+
+	m_can_class_unregister(mcan_class);
+
+	m_can_class_free_dev(mcan_class->net);
+
+	return 0;
+}
+
+static int __maybe_unused m_can_runtime_suspend(struct device *dev)
+{
+	struct m_can_tegra_priv *priv = dev_get_drvdata(dev);
+	struct m_can_classdev *mcan_class = &priv->cdev;
+
+	if (priv->core_clk)
+		clk_disable_unprepare(priv->core_clk);
+
+	clk_disable_unprepare(mcan_class->hclk);
+	clk_disable_unprepare(priv->can_clk);
+
+	return 0;
+}
+
+static int __maybe_unused m_can_runtime_resume(struct device *dev)
+{
+	struct m_can_tegra_priv *priv = dev_get_drvdata(dev);
+	struct m_can_classdev *mcan_class = &priv->cdev;
+	int err;
+
+	err = clk_prepare_enable(priv->can_clk);
+	if (err) {
+		return err;
+	}
+
+	err = clk_prepare_enable(mcan_class->hclk);
+	if (err) {
+		clk_disable_unprepare(priv->can_clk);
+	}
+
+	if (priv->core_clk) {
+		err = clk_prepare_enable(priv->core_clk);
+		if (err) {
+			clk_disable_unprepare(mcan_class->hclk);
+			clk_disable_unprepare(priv->can_clk);
+		}
+	}
+
+	return err;
+}
+
+static const struct dev_pm_ops m_can_pmops = {
+	SET_RUNTIME_PM_OPS(m_can_runtime_suspend,
+			   m_can_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(m_can_suspend, m_can_resume)
+};
+
+static const struct of_device_id m_can_of_table[] = {
+	{ .compatible = "nvidia,tegra194-m_can", .data = NULL },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, m_can_of_table);
+
+static struct platform_driver m_can_tegra_driver = {
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.of_match_table = m_can_of_table,
+		.pm     = &m_can_pmops,
+	},
+	.probe = m_can_tegra_probe,
+	.remove = m_can_tegra_remove,
+};
+
+module_platform_driver(m_can_tegra_driver);
+
+MODULE_AUTHOR("Brian Silverman <brian.silverman@bluerivertech.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("M_CAN driver for IO Mapped Bosch controllers on NVIDIA Tegra");
-- 
2.20.1

