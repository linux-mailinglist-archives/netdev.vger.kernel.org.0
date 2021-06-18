Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A273AC11E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 04:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhFRC4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 22:56:19 -0400
Received: from mail.loongson.cn ([114.242.206.163]:39854 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232072AbhFRC4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 22:56:13 -0400
Received: from localhost.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxv0CzCsxgVnITAA--.632S2;
        Fri, 18 Jun 2021 10:53:41 +0800 (CST)
From:   Qing Zhang <zhangqing@loongson.cn>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Huacai Chen <chenhc@lemote.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 1/4] stmmac: pci: Add dwmac support for Loongson
Date:   Fri, 18 Jun 2021 10:53:34 +0800
Message-Id: <20210618025337.5705-1-zhangqing@loongson.cn>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Dxv0CzCsxgVnITAA--.632S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuFW3Cry3Ar18CF45XF1rXrb_yoW3XFWDpa
        1fAas0gr97Xr4xGws5Ar4DJF98uayav3y0g3yIkwna9FZYyrWqqwn5KFWYyF97CrWkWw1a
        qF4jkF48uF4DJa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvGb7Iv0xC_tr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4j6F
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kI
        c2xKxwCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjxUcD73DUUUU
X-CM-SenderInfo: x2kd0wptlqwqxorr0wxvrqhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This GMAC module is integrated into the Loongson-2K SoC and the LS7A
bridge chip.

Signed-off-by: Qing Zhang <zhangqing@loongson.cn>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   9 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-loongson.c  | 218 ++++++++++++++++++
 3 files changed, 228 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 7737e4d0bb9e..0fc4532a2caa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -238,6 +238,15 @@ config DWMAC_INTEL
 	  This selects the Intel platform specific bus support for the
 	  stmmac driver. This driver is used for Intel Quark/EHL/TGL.
 
+config DWMAC_LOONGSON
+	tristate "Loongson PCI DWMAC support"
+	default MACH_LOONGSON64
+	depends on STMMAC_ETH && PCI
+	depends on COMMON_CLK
+	help
+	  This selects the LOONGSON PCI bus support for the stmmac driver,
+	  Support for ethernet controller on Loongson-2K1000 SoC and LS7A1000 bridge.
+
 config STMMAC_PCI
 	tristate "STMMAC PCI bus support"
 	depends on STMMAC_ETH && PCI
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index f2e478b884b0..56d0d536859c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -36,4 +36,5 @@ dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
 
 obj-$(CONFIG_STMMAC_PCI)	+= stmmac-pci.o
 obj-$(CONFIG_DWMAC_INTEL)	+= dwmac-intel.o
+obj-$(CONFIG_DWMAC_LOONGSON)	+= dwmac-loongson.o
 stmmac-pci-objs:= stmmac_pci.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
new file mode 100644
index 000000000000..8cd4e2e8ec40
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -0,0 +1,218 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Loongson Corporation
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/pci.h>
+#include <linux/dmi.h>
+#include <linux/device.h>
+#include <linux/of_irq.h>
+#include "stmmac.h"
+
+static int loongson_default_data(struct plat_stmmacenet_data *plat)
+{
+	plat->clk_csr = 2;	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
+	plat->has_gmac = 1;
+	plat->force_sf_dma_mode = 1;
+
+	/* Set default value for multicast hash bins */
+	plat->multicast_filter_bins = HASH_TABLE_SIZE;
+
+	/* Set default value for unicast filter entries */
+	plat->unicast_filter_entries = 1;
+
+	/* Set the maxmtu to a default of JUMBO_LEN */
+	plat->maxmtu = JUMBO_LEN;
+
+	/* Set default number of RX and TX queues to use */
+	plat->tx_queues_to_use = 1;
+	plat->rx_queues_to_use = 1;
+
+	/* Disable Priority config by default */
+	plat->tx_queues_cfg[0].use_prio = false;
+	plat->rx_queues_cfg[0].use_prio = false;
+
+	/* Disable RX queues routing by default */
+	plat->rx_queues_cfg[0].pkt_route = 0x0;
+
+	/* Default to phy auto-detection */
+	plat->phy_addr = -1;
+
+	plat->dma_cfg->pbl = 32;
+	plat->dma_cfg->pblx8 = true;
+
+	plat->multicast_filter_bins = 256;
+	return 0;
+}
+
+static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct plat_stmmacenet_data *plat;
+	struct stmmac_resources res;
+	int ret, i, mdio;
+	struct device_node *np;
+
+	np = dev_of_node(&pdev->dev);
+
+	if (!np) {
+		pr_info("dwmac_loongson_pci: No OF node\n");
+		return -ENODEV;
+	}
+
+	if (!of_device_is_compatible(np, "loongson, pci-gmac")) {
+		pr_info("dwmac_loongson_pci: Incompatible OF node\n");
+		return -ENODEV;
+	}
+
+	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
+	if (!plat)
+		return -ENOMEM;
+
+	if (plat->mdio_node) {
+		dev_err(&pdev->dev, "Found MDIO subnode\n");
+		mdio = true;
+	}
+
+	if (mdio) {
+		plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
+						   sizeof(*plat->mdio_bus_data),
+						   GFP_KERNEL);
+		if (!plat->mdio_bus_data)
+			return -ENOMEM;
+		plat->mdio_bus_data->needs_reset = true;
+	}
+
+	plat->dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*plat->dma_cfg), GFP_KERNEL);
+	if (!plat->dma_cfg)
+		return -ENOMEM;
+
+	/* Enable pci device */
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n", __func__);
+		return ret;
+	}
+
+	/* Get the base address of device */
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		if (pci_resource_len(pdev, i) == 0)
+			continue;
+		ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
+		if (ret)
+			return ret;
+		break;
+	}
+
+	plat->bus_id = of_alias_get_id(np, "ethernet");
+	if (plat->bus_id < 0)
+		plat->bus_id = pci_dev_id(pdev);
+
+	plat->phy_interface = device_get_phy_mode(&pdev->dev);
+	if (plat->phy_interface < 0)
+		dev_err(&pdev->dev, "phy_mode not found\n");
+
+	plat->interface = PHY_INTERFACE_MODE_GMII;
+
+	pci_set_master(pdev);
+
+	loongson_default_data(plat);
+	pci_enable_msi(pdev);
+	memset(&res, 0, sizeof(res));
+	res.addr = pcim_iomap_table(pdev)[0];
+
+	res.irq = of_irq_get_byname(np, "macirq");
+	if (res.irq < 0) {
+		dev_err(&pdev->dev, "IRQ macirq not found\n");
+		ret = -ENODEV;
+	}
+
+	res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
+	if (res.wol_irq < 0) {
+		dev_info(&pdev->dev, "IRQ eth_wake_irq not found, using macirq\n");
+		res.wol_irq = res.irq;
+	}
+
+	res.lpi_irq = of_irq_get_byname(np, "eth_lpi");
+	if (res.lpi_irq < 0) {
+		dev_err(&pdev->dev, "IRQ eth_lpi not found\n");
+		ret = -ENODEV;
+	}
+
+	return stmmac_dvr_probe(&pdev->dev, plat, &res);
+}
+
+static void loongson_dwmac_remove(struct pci_dev *pdev)
+{
+	int i;
+
+	stmmac_dvr_remove(&pdev->dev);
+
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		if (pci_resource_len(pdev, i) == 0)
+			continue;
+		pcim_iounmap_regions(pdev, BIT(i));
+		break;
+	}
+
+	pci_disable_device(pdev);
+}
+
+static int __maybe_unused loongson_dwmac_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	int ret;
+
+	ret = stmmac_suspend(dev);
+	if (ret)
+		return ret;
+
+	ret = pci_save_state(pdev);
+	if (ret)
+		return ret;
+
+	pci_disable_device(pdev);
+	pci_wake_from_d3(pdev, true);
+	return 0;
+}
+
+static int __maybe_unused loongson_dwmac_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	int ret;
+
+	pci_restore_state(pdev);
+	pci_set_power_state(pdev, PCI_D0);
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	pci_set_master(pdev);
+
+	return stmmac_resume(dev);
+}
+
+static SIMPLE_DEV_PM_OPS(loongson_dwmac_pm_ops, loongson_dwmac_suspend,
+			 loongson_dwmac_resume);
+
+static const struct pci_device_id loongson_dwmac_id_table[] = {
+	{ PCI_VDEVICE(LOONGSON, 0x7a03) },
+	{}
+};
+MODULE_DEVICE_TABLE(pci, loongson_dwmac_id_table);
+
+struct pci_driver loongson_dwmac_driver = {
+	.name = "dwmac-loongson-pci",
+	.id_table = loongson_dwmac_id_table,
+	.probe = loongson_dwmac_probe,
+	.remove = loongson_dwmac_remove,
+	.driver = {
+		.pm = &loongson_dwmac_pm_ops,
+	},
+};
+
+module_pci_driver(loongson_dwmac_driver);
+
+MODULE_DESCRIPTION("Loongson DWMAC PCI driver");
+MODULE_AUTHOR("Qing Zhang <zhangqing@loongson.cn>");
+MODULE_LICENSE("GPL v2");
-- 
2.31.0

