Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD49C62EEC8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 08:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241091AbiKRH7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 02:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241314AbiKRH6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 02:58:42 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2064.outbound.protection.outlook.com [40.107.96.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D518CB9D;
        Thu, 17 Nov 2022 23:58:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDhz+xBFZz84hcfKcsPnYM/KeIJlGKg0zQWcNVoK73IsH1nLaejFY79/SQHm6FunbYIXQSLD1pbSoi50idYaGimYXYlUg/ajfNt8zwKk2lbNk1Fo4dpspMHPxhamX7NlMX/LCaJEJHtAqnUlW9RfeV9OY6iRpMc+h+0TvpG/3AoYgdzoAdqiRf98QdaV865+UGl5P0JD2arcdp//jGnDlmYdgfb8WR4a+1m0FK32qVVwQxolPL6J5h8PXCxnLvgH41O7wZfQ2V+jqwULyB443la25VZnCADaYuSvOAbOVlnXzDCBVjTjrB26ayTpechn+A5wIflZLxbofGD3qMkQ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRpUU83Kqy8q+7WE6i2SWs3a2MA6tqITpYQI42FJ1YM=;
 b=LKbnCHWid/SMFAjrbCXRXgEiZyZJxYm95mxv/34OnyTHQNXXppWkcBq4vajuAaI935tJs6OyrB87cCpXJGyFi06C0bqeVd74Ai9VebVmmaDbQ1iawt/Cjnuag+awyYZzRtS7GF1PjXByz2e1UnXEjuKdx8UEyEsYFh5fzwfBTfBvkBH44QQEMrHQ45HIftL6L6r2uXtoJW5XzMaVqTfqePsTek+F9tc5GTwoNVxQCns+oruLYpyHG2mD7hKXZkydWHIn8QxEJv0W17w+dtza7hJMg8EvQ6pyc0xTn8PgZtZawW6lw+QMLqgJUKzJFV1fKqiYTtWZZPXyhhwZGwMe5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRpUU83Kqy8q+7WE6i2SWs3a2MA6tqITpYQI42FJ1YM=;
 b=O/78dz6yi8vMqamH9JW8djdHj97JhiTURnC9fLij1+Oax5rgXS1i+EL6Yy/ckpqX/xWVFWO6i/dzQebYIBCzC6OM6UTr7/w/8GVI6N9xbm/UEHsvR4ikSDPKlqaQgoeNba5kzrlqaXenbHcg8w2Jy28taMIx4DcSOvnhKYCVZjo2pIxS6uk8NhLxw6ok3dwDDhU/3JBKlj04Z1UaPOKuZBe1KwtZHR7C03RUQDf0AsCAfeldmkvxf3puux6MdAl105dtmrfSkG+pNMkz30FtxqXLDxzNPyvBOKoCs6/BMB5uBpxIXbF0yLxi7z0OIYgepVrxXM1nT3ntv2mzXyePRw==
Received: from DM6PR04CA0006.namprd04.prod.outlook.com (2603:10b6:5:334::11)
 by SA0PR12MB7075.namprd12.prod.outlook.com (2603:10b6:806:2d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Fri, 18 Nov
 2022 07:58:19 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::6) by DM6PR04CA0006.outlook.office365.com
 (2603:10b6:5:334::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20 via Frontend
 Transport; Fri, 18 Nov 2022 07:58:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Fri, 18 Nov 2022 07:58:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 17 Nov
 2022 23:58:11 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 17 Nov 2022 23:58:10 -0800
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Thu, 17 Nov 2022 23:58:06 -0800
From:   Revanth Kumar Uppala <ruppala@nvidia.com>
To:     <f.fainelli@gmail.com>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
        <jonathanh@nvidia.com>, <kuba@kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <olteanv@gmail.com>, <pabeni@redhat.com>,
        <thierry.reding@gmail.com>, <vbhadram@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Revanth Kumar Uppala <ruppala@nvidia.com>
Subject: [PATCH 2/2] net: stmmac: tegra: Add MGBE support
Date:   Fri, 18 Nov 2022 13:27:44 +0530
Message-ID: <20221118075744.49442-2-ruppala@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118075744.49442-1-ruppala@nvidia.com>
References: <20221118075744.49442-1-ruppala@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT066:EE_|SA0PR12MB7075:EE_
X-MS-Office365-Filtering-Correlation-Id: 588b6cf4-c284-4628-a173-08dac93aa821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UW7BUV4YGq/SMUnUxeKN7CphZhQhZsH1voJo/uUZiMd3Vcvp7OOz9wsx5YQeinCQBwCfYgD18qWZol0U8NeYloY+j+Ssl0343eOEXmcQhYz2raMXtWpIl7fHVgl2ZA9Flg4nsgXGK3Ec9kpyQah1tQxemaUEtZlyc9BEepGJnemq9s3AAKbyUy/PiSNxADbC+bAm5zELIMmTUim3phzzuLDNKtz7ny9z2T1wWjD1L44dKvN2cyyk1G5LUm8lzgTYFLneMNUsxKBOU3GD6YY/ZlrG3XW5HzjCh2/cHamuVjQdzkT7TJHCIOVharQPJ3K0ZZtnbtJNFenS9+9rFxt4rlH9hf1QfSdLnTPTpwUvEMuodKw8aDqc6epPynV9QqM4i5Y+w2vH8oRLF/v+TXvtOy4W9VG7UqMw2AR/Rz4hITNGY0G4RSYd/DFnzHxZaU5FrR7+yrulsRkNttRGeY+j/9c1RuMdk9+C1l4UbXGgoFofmInpvMpq2IUyzKE7aVKZSPRCcsxt7GzHAoeROQZ67XuxLw3uAj8adb/vl2iPqP6YKWYiLWHsKeZ7Xs0huXNoF7rqLUcnYcr/o5t4ZlZIVjtw6UQYCKvHPkjPBmiXf5LyZyZr4uwBmHbKtZIaxbg7lCI1CFJLSIIbS7FwA6rRfly/4p6nl/mI1XNI3o1Jl+jtfCE7dTj2bWtaoYm5OKMcQxJibQNaQXODl4YnA6q9rA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199015)(40470700004)(36840700001)(46966006)(2906002)(30864003)(82740400003)(40480700001)(5660300002)(8936002)(7416002)(82310400005)(1076003)(186003)(426003)(2616005)(86362001)(47076005)(336012)(70206006)(36756003)(107886003)(41300700001)(70586007)(8676002)(36860700001)(4326008)(478600001)(40140700001)(7636003)(356005)(83380400001)(7696005)(6666004)(40460700003)(316002)(26005)(54906003)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 07:58:19.1002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 588b6cf4-c284-4628-a173-08dac93aa821
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7075
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhadram Varka <vbhadram@nvidia.com>

Add support for the Multi-Gigabit Ethernet (MGBE/XPCS) IP found on
NVIDIA Tegra234 SoCs.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Co-developed-by: Revanth Kumar Uppala <ruppala@nvidia.com>
Signed-off-by: Revanth Kumar Uppala <ruppala@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   6 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 387 ++++++++++++++++++
 3 files changed, 394 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 31ff35174034..e9f61bdaf7c4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -235,6 +235,12 @@ config DWMAC_INTEL_PLAT
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
index 000000000000..9fcaecbae4ad
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
@@ -0,0 +1,387 @@
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
+static int __maybe_unused tegra_mgbe_suspend(struct device *dev)
+{
+	struct tegra_mgbe *mgbe = get_stmmac_bsp_priv(dev);
+	int err;
+
+	err = stmmac_suspend(dev);
+	if (err)
+		return err;
+
+	clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+
+	return reset_control_assert(mgbe->rst_mac);
+}
+
+static int __maybe_unused tegra_mgbe_resume(struct device *dev)
+{
+	struct tegra_mgbe *mgbe = get_stmmac_bsp_priv(dev);
+	u32 value;
+	int err;
+
+	err = clk_bulk_prepare_enable(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+	if (err < 0)
+		return err;
+
+	err = reset_control_deassert(mgbe->rst_mac);
+	if (err < 0)
+		return err;
+
+	/* Enable common interrupt at wrapper level */
+	writel(MAC_SBD_INTR, mgbe->regs + MGBE_WRAP_COMMON_INTR_ENABLE);
+
+	/* Program SID */
+	writel(MGBE_SID, mgbe->hv + MGBE_WRAP_AXI_ASID0_CTRL);
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
+	if (err < 0) {
+		dev_err(mgbe->dev, "timeout waiting for TX lane to become enabled\n");
+		clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+		return err;
+	}
+
+	err = stmmac_resume(dev);
+	if (err < 0)
+		clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
+
+	return err;
+}
+
+static int mgbe_uphy_lane_bringup_serdes_up(struct net_device *ndev, void *mgbe_data)
+{
+	struct tegra_mgbe *mgbe = (struct tegra_mgbe *)mgbe_data;
+	u32 value;
+	int err;
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
+	if (err < 0) {
+		dev_err(mgbe->dev, "timeout waiting for RX calibration to become enabled\n");
+		return err;
+	}
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
+	err = readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_IRQ_STATUS, value,
+				 value & XPCS_WRAP_IRQ_STATUS_PCS_LINK_STS,
+				 500, 500 * 2000);
+	if (err < 0) {
+		dev_err(mgbe->dev, "timeout waiting for link to become ready\n");
+		return err;
+	}
+
+	/* clear status */
+	writel(value, mgbe->xpcs + XPCS_WRAP_IRQ_STATUS);
+
+	return 0;
+}
+
+static void mgbe_uphy_lane_bringup_serdes_down(struct net_device *ndev, void *mgbe_data)
+{
+	struct tegra_mgbe *mgbe = (struct tegra_mgbe *)mgbe_data;
+	u32 value;
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_SW_OVRD;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_DATA_EN;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_SLEEP;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_AUX_RX_IDDQ;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_IDDQ;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+}
+
+static int tegra_mgbe_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat;
+	struct stmmac_resources res;
+	struct tegra_mgbe *mgbe;
+	int irq, err, i;
+	u32 value;
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
+	if (IS_ERR(mgbe->rst_mac)) {
+		err = PTR_ERR(mgbe->rst_mac);
+		goto disable_clks;
+	}
+
+	err = reset_control_assert(mgbe->rst_mac);
+	if (err < 0)
+		goto disable_clks;
+
+	usleep_range(2000, 4000);
+
+	err = reset_control_deassert(mgbe->rst_mac);
+	if (err < 0)
+		goto disable_clks;
+
+	/* Perform PCS reset */
+	mgbe->rst_pcs = devm_reset_control_get(&pdev->dev, "pcs");
+	if (IS_ERR(mgbe->rst_pcs)) {
+		err = PTR_ERR(mgbe->rst_pcs);
+		goto disable_clks;
+	}
+
+	err = reset_control_assert(mgbe->rst_pcs);
+	if (err < 0)
+		goto disable_clks;
+
+	usleep_range(2000, 4000);
+
+	err = reset_control_deassert(mgbe->rst_pcs);
+	if (err < 0)
+		goto disable_clks;
+
+	plat = stmmac_probe_config_dt(pdev, res.mac);
+	if (IS_ERR(plat)) {
+		err = PTR_ERR(plat);
+		goto disable_clks;
+	}
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
+	if (err < 0) {
+		dev_err(mgbe->dev, "timeout waiting for TX lane to become enabled\n");
+		goto remove;
+	}
+
+	plat->serdes_powerup = mgbe_uphy_lane_bringup_serdes_up;
+	plat->serdes_powerdown = mgbe_uphy_lane_bringup_serdes_down;
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
+	plat->serdes_up_after_phy_linkup = 1;
+
+	err = stmmac_dvr_probe(&pdev->dev, plat, &res);
+	if (err < 0)
+		goto remove;
+
+	return 0;
+
+disable_clks:
+	clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
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
+static SIMPLE_DEV_PM_OPS(tegra_mgbe_pm_ops, tegra_mgbe_suspend, tegra_mgbe_resume);
+
+static struct platform_driver tegra_mgbe_driver = {
+	.probe = tegra_mgbe_probe,
+	.remove = tegra_mgbe_remove,
+	.driver = {
+		.name = "tegra-mgbe",
+		.pm		= &tegra_mgbe_pm_ops,
+		.of_match_table = tegra_mgbe_match,
+	},
+};
+module_platform_driver(tegra_mgbe_driver);
+
+MODULE_AUTHOR("Thierry Reding <treding@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA Tegra MGBE driver");
+MODULE_LICENSE("GPL");
-- 
2.25.1

