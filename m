Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B3355745F
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiFWHrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiFWHrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:47:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F296246C92;
        Thu, 23 Jun 2022 00:47:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKKxpE2LKHPNBoj0HLTvHbjrULsdV8cGrGaXJHbQDKmburaqC6VK7h0WkefYjF+g5wry9U9UxEILMoI7TU8gwld78XXjN2sV6HCyz797oXA3bDLBqLmTXKfH58JLKozmdpvSw80I/Ty4+h0zi+fx6cLVtEmKUUDjmdzdRj45B6aHrw+U9v5Jlh7DSxLr/54DdK6GfKoBVN6neQ9lD4LygpRe24jNrQ5WHLXVmQkTHfeIuMGlJbaQsE1RZaBGrUK5tNZhlUdnfgztBU9qpkYqKAKb8liUmtyEHll71itjthiIV41Bjg6paIkVpbP9/fj8oQ6WcEiJeUBLHxx4eEYlCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R4uK5/mo1zem+K0b6wqnj/En2CaldzOFW+sbuNzMhUs=;
 b=h9egcCkJ3RMrm5LSVX++RcpNbEE7QqhCpfws2/5GUJiFaGVdH+TooOhhTikYuHRZwWPEVRaGMq/mfv3kSjxRpWZfY8gq7qAgKWJgCsG42D6J9WmxidMhK9uOvTVDOEprqr8kYn7hjP05ZMUz+alIEb4IBP5VbJVa7Z1F4CL7pBnOe5LvIARGgqAsvoTd72lwm+jZjmaahR63TG/yCh/34vMGmMP+LC1+8bd6XjxB5mNBXRW+0nHK5ARfDyKrki75QgXCXaGY7oVGHBg2NiRGuOeG7Na2kc+6REYEN3+qAyfX7YvouJD1HgJxyHbtBnfh3QrMSdMuvRuFZwutg0VnNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4uK5/mo1zem+K0b6wqnj/En2CaldzOFW+sbuNzMhUs=;
 b=I8jbv9EJtETadWY6z/LOJm3KsZT4OtKKoI2VuZ0ugwSPsvNECoP0o7mygp3j+BAuJBAPGe5kJGkeVR6wUVbvWIoUovm6DLIaeomSRIzMdX08XKm68CHgdipduYiACz9rFKWHtzkkZnRFoM4LFOsbi2NreeIVhnmC5tDW6WTuBq6qPdYe8RXFUuu1luKgeg5gMBsArOqXnALeyyFVHEkRRKbHHNAsL6gOyY3SBedlkUkH5lnfv8hFkeShlzxffRk10Bt6//5SESa2jrOu3vjOkiXigD2c4FRid7vuRaPxuNN8chx457gIzNvKTkJJZhbvUaWcs9kHk6lGK8y8zBbQNw==
Received: from DM6PR14CA0062.namprd14.prod.outlook.com (2603:10b6:5:18f::39)
 by DM6PR12MB2732.namprd12.prod.outlook.com (2603:10b6:5:4a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Thu, 23 Jun
 2022 07:47:08 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::93) by DM6PR14CA0062.outlook.office365.com
 (2603:10b6:5:18f::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Thu, 23 Jun 2022 07:47:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 07:47:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 07:47:08 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 00:47:07 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.26 via
 Frontend Transport; Thu, 23 Jun 2022 00:47:04 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        Bhadram Varka <vbhadram@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH net-next v1 8/9] stmmac: tegra: Add MGBE support
Date:   Thu, 23 Jun 2022 13:16:14 +0530
Message-ID: <20220623074615.56418-8-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623074615.56418-1-vbhadram@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70a158c6-6c37-4702-cdd5-08da54ec935d
X-MS-TrafficTypeDiagnostic: DM6PR12MB2732:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB273208E290B0EE6F8F048BEEAFB59@DM6PR12MB2732.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vyNCI+TILYQg13BWMEyL2ozg2v01VCGEXKgz2efOv4dIUoSwUDqEj6hXTGpFjbVN+wuaw5DkHqhFWKQ+57t24wYtehg9UIUkRzKH55m7atzVgVATqATx6ph5jajm9hEKoDwfLOROUlv4mftPB7fyJ+mps1UJGZ6lZ9Y2MtS19GiXHmRXF3BD+A+xNI/lsuTxRWqKaQKd7jDpHlhoR+39tGVlkJrVERynytbjic53eAb90D8Et5hnK+pZEe6Zse1DVcToCwLU3q3hvjVmHVE5sH2afe9PrGzwvRH4Mljyf/IYO8Fk/4qtvarQDMIRwOitMMDDZXCFKmPwuDgpw1srx6VdH2U06Jmuihmss5zCA55CmEtwhEOb1yWOBuESccFOIBsW8IwQV3PDdEa4xutNuJNVV9TXFV9p7VI/6D0UJ4KwtRxOTqY9RPcyulyiBILqP7jy7zJEr0t1E6DrK4+p3hhsfFJzCh3NmS4JevY0KdzginyjSnf9L9Si+WDLU3fLSGwm+HwMT2Fnj4ii1aeOWW6kvXNNVQaH4dnkOdPshmXmDiMevTjkw2t3fCgU/FnPFBmn/sLSwYK5hzpDjq1FwXsnXB1ntbc8k8PyXcrSlPmuTCCncvlJf0YYnjRwETLqah9768OnrGzP/djlA3RKSXX6MY3hhyTopATkz0ORdYOl+lvqdMq5LCrTbeOhremNLtnuRGQE65YCANLauYqNAHhN2MDUtlqhfQfnv6cQ0GBtKvJOWoGttZrUZkpZ3L/OH0lMhUemoFTbBVAmQQT5vGeaZF7UUUGrUEqUTGs6i+0=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(36840700001)(40470700004)(46966006)(41300700001)(7696005)(2616005)(82310400005)(5660300002)(30864003)(26005)(40140700001)(2906002)(478600001)(8936002)(36860700001)(356005)(36756003)(47076005)(81166007)(70206006)(1076003)(107886003)(186003)(40480700001)(86362001)(336012)(426003)(82740400003)(40460700003)(316002)(70586007)(6666004)(4326008)(8676002)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:47:08.6041
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a158c6-6c37-4702-cdd5-08da54ec935d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2732
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MGBE/XPCS IP support which founds on Tegra234 SoCs.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   6 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 294 ++++++++++++++++++
 3 files changed, 301 insertions(+)
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
index 000000000000..641b8773428a
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
@@ -0,0 +1,294 @@
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
+	if (err < 0) {
+		dev_err(mgbe->dev, "timeout waiting for TX lane to become enabled\n");
+	}
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
+	if (err < 0) {
+		dev_err(mgbe->dev, "timeout waiting for RX calibration to become enabled\n");
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
+	if (!plat->mdio_node) {
+		plat->mdio_node = of_get_child_by_name(pdev->dev.of_node, "mdio");
+	}
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
2.17.1

