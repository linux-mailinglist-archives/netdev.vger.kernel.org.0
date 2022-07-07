Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB452569C16
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbiGGHs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbiGGHsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:48:41 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6DB32076;
        Thu,  7 Jul 2022 00:48:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id o4so25097382wrh.3;
        Thu, 07 Jul 2022 00:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f9nLTCidfnrhmXifqG1XQtiik+IMQK61AWbNeVnQJug=;
        b=COxPdk+QiA9hqXD15/35Y59dlziEZHl9Mel3By4DMFp9kA1AKLdKLEcuc0JwbADkBd
         DxoNwH+VmpZiHB3eTHCc7jK3eCDwhfD7SGJe5AMhVR5VfdcmmTSxaOhUbm/1daU2HMxo
         LG+8gS9SlS9/mNIWuLgQoyOMsIEACvzJA6axCHh6pAemRoozwT0abNGr18UHeYdMeaZT
         epkd60xBCwdBmKxvYD9cDuGKnxoztdWXFECWt8ZW8IS30m68XXmCpRTCvSMNVjInSWul
         CBSGWzhBttew5ehOCgk/5Gf0Fl5zIiU8ggoUXsmoX1fVr7Nv9S0+hhtWoZkKXWLSjae0
         HnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f9nLTCidfnrhmXifqG1XQtiik+IMQK61AWbNeVnQJug=;
        b=IMWwOevvWoSVl8ogrH2UAd15Rlq9lwawLSCPo1MA1ngNnAU9SzavJGI6lRUJVMVpk8
         33F4n1BZVU0REBuDt6wy31he4PeFtmfVAoe4mjNqr7wYS37RPO3Z5rs0enYKm9SUpJVG
         mG04+3nvn2G818IIU1cH3Bup147q87HU/sromDstYRpevzcg95uw9CfKMAFlQUTTGyT8
         TiDFZsWLOYBnOitlMLHnKPSpgv4GiwuGj8C/IzjQ4Gb0OjDzykl86ZFhwRGR4s0g7dFP
         SAcqFz5KVDTG9s85fzKVOdPjy+Qa2InLK1KST+/sH02RgZnWiIjXsHXhnu8K2Vv3lbyg
         l6pg==
X-Gm-Message-State: AJIora+Empb964tL78dAqGOB6ORTppWKcU32dLtVpnMRL5WoQo70It9F
        iTtLqeaziZBE0BHVD8v0PiE=
X-Google-Smtp-Source: AGRyM1umeORrvq7hOAosAYPuDdg+MWwN3qIG30DhfJC6NU5Xxf/xoytLKFkKU3ZG6wIk8Vd07u+gFA==
X-Received: by 2002:a5d:5747:0:b0:21d:65e9:be07 with SMTP id q7-20020a5d5747000000b0021d65e9be07mr21879807wrw.215.1657180115009;
        Thu, 07 Jul 2022 00:48:35 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id b15-20020adff90f000000b0021b90cc66a1sm37586100wrr.2.2022.07.07.00.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:48:34 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v4 9/9] stmmac: tegra: Add MGBE support
Date:   Thu,  7 Jul 2022 09:48:18 +0200
Message-Id: <20220707074818.1481776-10-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707074818.1481776-1-thierry.reding@gmail.com>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhadram Varka <vbhadram@nvidia.com>

Add support for the Multi-Gigabit Ethernet (MGBE/XPCS) IP found on
NVIDIA Tegra234 SoCs.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Note that this doesn't have any dependencies on any of the patches
earlier in the series, so this can be applied independently.

 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   6 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 290 ++++++++++++++++++
 3 files changed, 297 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 929cfc22cd0c..47af5a59ce88 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -232,6 +232,12 @@ config DWMAC_INTEL_PLAT
 	  the stmmac device driver. This driver is used for the Intel Keem Bay
 	  SoC.
 
+config DWMAC_TEGRA
+	tristate "NVIDIA Tegra MGBE support"
+	depends on ARCH_TEGRA || COMPILE_TEST
+	help
+	  Support for the MGBE controller found on Tegra SoCs.
+
 config DWMAC_VISCONTI
 	tristate "Toshiba Visconti DWMAC support"
 	default ARCH_VISCONTI
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index d4e12e9ace4f..057e4bab5c08 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_DWMAC_DWC_QOS_ETH)	+= dwmac-dwc-qos-eth.o
 obj-$(CONFIG_DWMAC_INTEL_PLAT)	+= dwmac-intel-plat.o
 obj-$(CONFIG_DWMAC_GENERIC)	+= dwmac-generic.o
 obj-$(CONFIG_DWMAC_IMX8)	+= dwmac-imx.o
+obj-$(CONFIG_DWMAC_TEGRA)	+= dwmac-tegra.o
 obj-$(CONFIG_DWMAC_VISCONTI)	+= dwmac-visconti.o
 stmmac-platform-objs:= stmmac_platform.o
 dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
new file mode 100644
index 000000000000..bb4b540820fa
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/platform_device.h>
+#include <linux/of_device.h>
+#include <linux/module.h>
+#include <linux/stmmac.h>
+#include <linux/clk.h>
+
+#include "stmmac_platform.h"
+
+static const char *const mgbe_clks[] = {
+	"rx-pcs", "tx", "tx-pcs", "mac-divider", "mac", "mgbe", "ptp-ref", "mac"
+};
+
+struct tegra_mgbe {
+	struct device *dev;
+
+	struct clk_bulk_data *clks;
+
+	struct reset_control *rst_mac;
+	struct reset_control *rst_pcs;
+
+	void __iomem *hv;
+	void __iomem *regs;
+	void __iomem *xpcs;
+
+	struct mii_bus *mii;
+};
+
+#define XPCS_WRAP_UPHY_RX_CONTROL 0x801c
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_SW_OVRD BIT(31)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_PCS_PHY_RDY BIT(10)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET BIT(9)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN BIT(8)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_SLEEP (BIT(7) | BIT(6))
+#define XPCS_WRAP_UPHY_RX_CONTROL_AUX_RX_IDDQ BIT(5)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_IDDQ BIT(4)
+#define XPCS_WRAP_UPHY_RX_CONTROL_RX_DATA_EN BIT(0)
+#define XPCS_WRAP_UPHY_HW_INIT_CTRL 0x8020
+#define XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN BIT(0)
+#define XPCS_WRAP_UPHY_HW_INIT_CTRL_RX_EN BIT(2)
+#define XPCS_WRAP_UPHY_STATUS 0x8044
+#define XPCS_WRAP_UPHY_STATUS_TX_P_UP BIT(0)
+#define XPCS_WRAP_IRQ_STATUS 0x8050
+#define XPCS_WRAP_IRQ_STATUS_PCS_LINK_STS BIT(6)
+
+#define XPCS_REG_ADDR_SHIFT 10
+#define XPCS_REG_ADDR_MASK 0x1fff
+#define XPCS_ADDR 0x3fc
+
+#define MGBE_WRAP_COMMON_INTR_ENABLE	0x8704
+#define MAC_SBD_INTR			BIT(2)
+#define MGBE_WRAP_AXI_ASID0_CTRL	0x8400
+#define MGBE_SID			0x6
+
+static void mgbe_uphy_lane_bringup(struct tegra_mgbe *mgbe)
+{
+	unsigned int retry = 300;
+	u32 value;
+	int err;
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_STATUS);
+	if ((value & XPCS_WRAP_UPHY_STATUS_TX_P_UP) == 0) {
+		value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL);
+		value |= XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN;
+		writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL);
+	}
+
+	err = readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL, value,
+				 (value & XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN) == 0,
+				 500, 500 * 2000);
+	if (err < 0)
+		dev_err(mgbe->dev, "timeout waiting for TX lane to become enabled\n");
+
+	usleep_range(10000, 20000);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_SW_OVRD;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_IDDQ;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_AUX_RX_IDDQ;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_SLEEP;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	err = readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL, value,
+				 (value & XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN) == 0,
+				 1000, 1000 * 2000);
+	if (err < 0)
+		dev_err(mgbe->dev, "timeout waiting for RX calibration to become enabled\n");
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_DATA_EN;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_PCS_PHY_RDY;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	while (--retry) {
+		err = readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_IRQ_STATUS, value,
+					 value & XPCS_WRAP_IRQ_STATUS_PCS_LINK_STS,
+					 500, 500 * 2000);
+		if (err < 0) {
+			dev_err(mgbe->dev, "timeout waiting for link to become ready\n");
+			usleep_range(10000, 20000);
+			continue;
+		}
+		break;
+	}
+
+	/* clear status */
+	writel(value, mgbe->xpcs + XPCS_WRAP_IRQ_STATUS);
+}
+
+static int tegra_mgbe_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat;
+	struct stmmac_resources res;
+	struct tegra_mgbe *mgbe;
+	int irq, err, i;
+
+	mgbe = devm_kzalloc(&pdev->dev, sizeof(*mgbe), GFP_KERNEL);
+	if (!mgbe)
+		return -ENOMEM;
+
+	mgbe->dev = &pdev->dev;
+
+	memset(&res, 0, sizeof(res));
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	mgbe->hv = devm_platform_ioremap_resource_byname(pdev, "hypervisor");
+	if (IS_ERR(mgbe->hv))
+		return PTR_ERR(mgbe->hv);
+
+	mgbe->regs = devm_platform_ioremap_resource_byname(pdev, "mac");
+	if (IS_ERR(mgbe->regs))
+		return PTR_ERR(mgbe->regs);
+
+	mgbe->xpcs = devm_platform_ioremap_resource_byname(pdev, "xpcs");
+	if (IS_ERR(mgbe->xpcs))
+		return PTR_ERR(mgbe->xpcs);
+
+	res.addr = mgbe->regs;
+	res.irq = irq;
+
+	mgbe->clks = devm_kzalloc(&pdev->dev, sizeof(*mgbe->clks), GFP_KERNEL);
+	if (!mgbe->clks)
+		return -ENOMEM;
+
+	for (i = 0; i <  ARRAY_SIZE(mgbe_clks); i++)
+		mgbe->clks[i].id = mgbe_clks[i];
+
+	err = devm_clk_bulk_get(mgbe->dev, ARRAY_SIZE(mgbe_clks), mgbe->clks);
+	if (err < 0)
+		return err;
+
+	err = clk_bulk_prepare_enable(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+	if (err < 0)
+		return err;
+
+	/* Perform MAC reset */
+	mgbe->rst_mac = devm_reset_control_get(&pdev->dev, "mac");
+	if (IS_ERR(mgbe->rst_mac))
+		return PTR_ERR(mgbe->rst_mac);
+
+	err = reset_control_assert(mgbe->rst_mac);
+	if (err < 0)
+		return err;
+
+	usleep_range(2000, 4000);
+
+	err = reset_control_deassert(mgbe->rst_mac);
+	if (err < 0)
+		return err;
+
+	/* Perform PCS reset */
+	mgbe->rst_pcs = devm_reset_control_get(&pdev->dev, "pcs");
+	if (IS_ERR(mgbe->rst_pcs))
+		return PTR_ERR(mgbe->rst_pcs);
+
+	err = reset_control_assert(mgbe->rst_pcs);
+	if (err < 0)
+		return err;
+
+	usleep_range(2000, 4000);
+
+	err = reset_control_deassert(mgbe->rst_pcs);
+	if (err < 0)
+		return err;
+
+	plat = stmmac_probe_config_dt(pdev, res.mac);
+	if (IS_ERR(plat))
+		return PTR_ERR(plat);
+
+	plat->has_xgmac = 1;
+	plat->tso_en = 1;
+	plat->pmt = 1;
+	plat->bsp_priv = mgbe;
+
+	if (!plat->mdio_node)
+		plat->mdio_node = of_get_child_by_name(pdev->dev.of_node, "mdio");
+
+	if (!plat->mdio_bus_data) {
+		plat->mdio_bus_data = devm_kzalloc(&pdev->dev, sizeof(*plat->mdio_bus_data),
+						   GFP_KERNEL);
+		if (!plat->mdio_bus_data) {
+			err = -ENOMEM;
+			goto remove;
+		}
+	}
+
+	plat->mdio_bus_data->needs_reset = true;
+
+	mgbe_uphy_lane_bringup(mgbe);
+
+	/* Tx FIFO Size - 128KB */
+	plat->tx_fifo_size = 131072;
+	/* Rx FIFO Size - 192KB */
+	plat->rx_fifo_size = 196608;
+
+	/* Enable common interrupt at wrapper level */
+	writel(MAC_SBD_INTR, mgbe->regs + MGBE_WRAP_COMMON_INTR_ENABLE);
+
+	/* Program SID */
+	writel(MGBE_SID, mgbe->hv + MGBE_WRAP_AXI_ASID0_CTRL);
+
+	err = stmmac_dvr_probe(&pdev->dev, plat, &res);
+	if (err < 0)
+		goto remove;
+
+	return 0;
+
+remove:
+	stmmac_remove_config_dt(pdev, plat);
+	return err;
+}
+
+static int tegra_mgbe_remove(struct platform_device *pdev)
+{
+	struct tegra_mgbe *mgbe = get_stmmac_bsp_priv(&pdev->dev);
+
+	clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+
+	stmmac_pltfr_remove(pdev);
+
+	return 0;
+}
+
+static const struct of_device_id tegra_mgbe_match[] = {
+	{ .compatible = "nvidia,tegra234-mgbe", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, tegra_mgbe_match);
+
+static struct platform_driver tegra_mgbe_driver = {
+	.probe = tegra_mgbe_probe,
+	.remove = tegra_mgbe_remove,
+	.driver = {
+		.name = "tegra-mgbe",
+		.pm		= &stmmac_pltfr_pm_ops,
+		.of_match_table = tegra_mgbe_match,
+	},
+};
+module_platform_driver(tegra_mgbe_driver);
+
+MODULE_AUTHOR("Thierry Reding <treding@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA Tegra MGBE driver");
+MODULE_LICENSE("GPL");
-- 
2.36.1

