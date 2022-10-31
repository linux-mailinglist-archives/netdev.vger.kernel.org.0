Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE9761335E
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiJaKMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiJaKME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:12:04 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150078.outbound.protection.outlook.com [40.107.15.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4318DDF73;
        Mon, 31 Oct 2022 03:12:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIsAba7f+peiSF4qb4pMWazwuBrVq35QWV86qgX0YwTKoU01ZHglOrT32lFRxrgIO+hTXdcZpo0BGo8O6fJI4rmESWQ9JiZGUDCPHNe89ycd79oZ2IeOUkvspi4JmzYz/QuMV4QVsPneVv4xyoS01P9JGe6qp6jqbv9YCUVNBbnmU1PanUEM+XvgFhaHYFPBcjxUvjKM7cubPU8nl9zRugcYIzZJfi7zfHboCRt436OWw0tJ7Vdgk8DYsH9yNY+pnyBfXxe0wLGezxoRzMMk8V2rPy6+RCY1Eclp/TTh4LSEMF8yxuSASBlPxq4T1hdUCDNawlE914OaIWRjpLGVvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UnfYte2gvmB1y7XDCul4zj5O3mcpawDQk382U11ZO4Y=;
 b=JQ5VEUOLJuHFi/XEMxi8NStp/RCEjkKlOai7vYYrj7p68uvCOscQd+8i63UjruyUif2z5/2f0AvYEp/+mVO89JK/zZsIMKOhrMtfs22kbfCLleu6KPbVuEfwjs5quTFhnBDikQtMxTVSA8WnRmk9OgMzd1L8cXKwlX0mSFIaIDnByDe6ba6iwUgOLB/YmIWSxDr8oE1HmBTd9Nc/LreiyFurFjjtkA5iR4AaM4xv6S6adFwPDO1nGSICYuEuyFH4Jd8/ar+ciLa//kDiCrT6oCsGzGS3vfv0QhT7m4SJaCrKAYv5a/LailfF4up3b1C6O8oooxVD4KAHTK/9IPUzXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnfYte2gvmB1y7XDCul4zj5O3mcpawDQk382U11ZO4Y=;
 b=jjqNEe+NjCClqnz8EU5vkJoxfn2GAa5A+jT4MArd8rVBSqCpabMyazG5PXXuxKhv/UCbroWhYiMMgR5k7L9ijZSstpv1HKkxVQvz04HZDqerK1FdjRJhffoCnmE2I9bKPplOy+jU0Mdzvv5BowTVjRN9JdgmVlSUoKzpnZqS4KKCD5dTy6mwImmyBkTDXXr08P56w5ucwJXteDJ/RLmi/FJ4Nd/xppruaGgC8NYW2O5UCMd1TyMSeGQmHUkLAp7bYMKrPCVXmyDOZYUYzOGP8zLlwriSocE/n7pjZ/OxfjbxJAzjsTYrVtPAa1jTjEM5Ir5wQYEJORGNeCsFuPTOLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by DB9PR04MB8411.eurprd04.prod.outlook.com (2603:10a6:10:24c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 31 Oct
 2022 10:11:58 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963%7]) with mapi id 15.20.5746.028; Mon, 31 Oct 2022
 10:11:58 +0000
From:   Chester Lin <clin@suse.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     Chester Lin <clin@suse.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jan Petrous <jan.petrous@nxp.com>,
        Ondrej Spacek <ondrej.spacek@nxp.com>,
        Ghennadi Procopciuc <Ghennadi.Procopciuc@nxp.com>,
        Andra-Teodora Ilie <andra.ilie@nxp.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH 5/5] net: stmmac: Add NXP S32 SoC family support
Date:   Mon, 31 Oct 2022 18:10:52 +0800
Message-Id: <20221031101052.14956-6-clin@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031101052.14956-1-clin@suse.com>
References: <20221031101052.14956-1-clin@suse.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0214.jpnprd01.prod.outlook.com
 (2603:1096:404:29::34) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|DB9PR04MB8411:EE_
X-MS-Office365-Filtering-Correlation-Id: f21a4201-7814-463e-a7de-08dabb28587f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4KOi3BcKoxCVWeFnqgNF44J/BdOSeNulCMmC8u9yI4qAFHocuOnBMihON3bH/zx8JmLyv7fu2dhN8J+dXc8AnKDQKNPWEzYfH1uSkgx/XxCFk/IvJ4Lzyl1newGTV9pOzmfOxEblmAigp/RJTV3WpQvEvRQEainjrbKyMjfkvJ1G1FypQywqVerFGkfYDjeB3OKHMY/azBzIa0mHMNt3iGH6Q9fFKIgrYKysRwHGJqS1pm4L5+GJzYJID9hIVJRK0aNLxryxCkNaubBrdHtag5AM1RxJ6TfXVfiB7W3WOidgd4lACNwPULwrDGqQKZeDnJBMxQFEqvG/QaWFJHpFe25QyTNPowO/26hmcYNZRw3vNDkW5E+UEFCePFZn3z2nUphnkWqj8tf2XEsEHZfKrqergIvIYjWW125GQjNOchjDEMQJsSZTIMZwzdznJVQrKLpG8bVnVxmU2QY5weDjfhMTHIB12u6mM6pOygo9AkJWGUCBe8pGjwK0EhsnMHYv9c8bGosnTs7caj637O+Kvvl3MCuGw60fk+5nFeitP1AKBjA+N//ctWgcQd0uaPqZVAAlQF70u2zZu9+i+vvP1CseHNJgcSsCyGwt6rjpK47UkBWXYFvoemNGE4MipqBkcIkNhQEuzSaF4ZJ7MNMV7ekygJs2K0hjZlJz+yWz8axwWlRfK7HcIhLBHsew3QYKoUEjK78prpLFvPtHOSKDfNy3j3COUkYo+QQTH2ysMBo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(54906003)(110136005)(38100700002)(966005)(186003)(5660300002)(26005)(4326008)(66556008)(66476007)(8936002)(6506007)(86362001)(6512007)(316002)(107886003)(6486002)(6666004)(2616005)(41300700001)(478600001)(83380400001)(1076003)(36756003)(8676002)(66946007)(30864003)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GV/IJbqFPCD5uEhShBlmLvMQPbIbO9/LmAk1CWY/qMaXF/HRbUddKkaSfUFb?=
 =?us-ascii?Q?4pM27v+hFJ86zJ1tTPU+osBJ4sjCCE9eijhIxRLS9wiFMw3XtSa34ybb27YG?=
 =?us-ascii?Q?4LefjciMGI7cQQ75t0VrKbDZvmNzhvA5X2b+cKEDzaX+MNPEzuSkxIeF3pyH?=
 =?us-ascii?Q?TT/eyUVJ4+At1jelGBCSDmzKFBeZ1KCz7Nc5V8DphfDlrVKF1gfuo7NwmZhz?=
 =?us-ascii?Q?WyW6S5TLFQdd2VEb2tjJ5+y5Hvt4uQPmWZ3MOgpJCL7fE8Ou/w48HhT9a+f8?=
 =?us-ascii?Q?87xYZh+VAvd6Z92EK8q97j4U2QRaxBRRkTdX7oIf16D2hxccQQ7fgRpnNSC0?=
 =?us-ascii?Q?0ZqWj9DVEQmc2VAe7X/r9W6rNx5Y0Sh1ie8eVFs/GxNKGVZjZw0Tss4BVfPB?=
 =?us-ascii?Q?O+PMUjkyHAIqGdsbIvyMxAOzGNrcMezbA1GfViNHCT+0WGZBFwdxDCWwdqxj?=
 =?us-ascii?Q?7Taso9QgKD09Qso3fdSr/s5JjT7lPYpRqsr9r9cTRRdIT6hebGLEjtPwxbWX?=
 =?us-ascii?Q?jH64gKJxw2CYsUk/pkPZ4j9PXGNP3s9g5C969ZbO1kcfTTH3ogFiQzQPgIuy?=
 =?us-ascii?Q?zUZLkPOvP0UhN3wl0bZyFkMebY2eD9o+ap1AFksuZePkBwc/YHyJdZm98eQh?=
 =?us-ascii?Q?o2Vd1TAA94sY5lMXVh7Fb64CWpgzxw0ABuEHev5zi/Zb6IQ4C1GM8YBqZgSP?=
 =?us-ascii?Q?9TrBXuldw8JLw4FlVITSuYsc1A1nVF/s6s827Tp64dGrbBIeCe4IlBGuxiic?=
 =?us-ascii?Q?ou5XUT4A0DNdTjsUH6t+aDjC7VCZKAKwuyt0wMFRgmfUM3Fqs/bcOzfamQlx?=
 =?us-ascii?Q?a1ixtk724ezDZ2QIhEjHWAJ677eyVW96mEx3OpE0R46eIyJr5iUf/ybVFZNG?=
 =?us-ascii?Q?gaYUpsTKr/gUiJ/BVymlKD4DEydXNMI65nEUb6Cu+Wtx381gYy9AEDX4X+8+?=
 =?us-ascii?Q?/C35w87ViZZeL2XsObSL3V9VXnmUkFmRL2YLsJ22CPOwb4Xz+f1p+3HBAkq5?=
 =?us-ascii?Q?oluAIj6w+3HbUpWL808B6UobpEdeNtAJG5ZJubVfxbRNQm9Lk6Jt2jXoLRsn?=
 =?us-ascii?Q?5RrYggLSfh9l4TmI8Xj4eyZfxE32lCwfiMHHRpGlrjyMPdVNzqgVSg6Gmhc8?=
 =?us-ascii?Q?wDoDBv5wAa/Kp4K8kP7xebS7C19GBCTToqb9+e5B4NLxgJMht5vdB51bt1rw?=
 =?us-ascii?Q?jLpIKTM5HW5dS7+CT3G+IGP39+1cHiRBnRCAOAQPScFRPQLtRTzUaFtTNHEJ?=
 =?us-ascii?Q?0RxZCQobLk6DsozKMo4O/w5CVusvMLHq64+5LQ5WP8rbotvlsOz7GPK6UJj3?=
 =?us-ascii?Q?C1yRF9/ZCEa9zciL1eR9kygGRKFrOvIYEOawcAwwRDU2F0vNKTEkWFhwqXJu?=
 =?us-ascii?Q?1OWVwpS/TosBUuypZs3OBXgoS0dyB3xGxHfT2gaV/cZpW81iqmN6xT/qIv+F?=
 =?us-ascii?Q?wkLGj0A2ahRdqZjJiSyJ1uBsttqVywves6KSwE1xN3ihZaQBff25HfB4NqqF?=
 =?us-ascii?Q?UtK7+8ZacchNr+Dbv4D5whi2BDX424tNLbp3iHYMr5H3s2euwhHRWtZy7oqZ?=
 =?us-ascii?Q?TKZZOO8GRj3ccpYLzIE=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21a4201-7814-463e-a7de-08dabb28587f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 10:11:58.7630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyYcgJ+0VLA/yNlw7ck2xs2zr89XLviWEOJaqVJPW0a312F3t1zqPhrqO5ak1tPs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8411
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add GMAC support for NXP S32 SoC family. This driver is mainly based on
NXP's downstream implementation on CodeAurora[1].

[1] https://source.codeaurora.org/external/autobsps32/linux/tree/drivers/net/ethernet/stmicro/stmmac?h=bsp34.0-5.10.120-rt

Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
Signed-off-by: Ghennadi Procopciuc <Ghennadi.Procopciuc@nxp.com>
Signed-off-by: Andra-Teodora Ilie <andra.ilie@nxp.com>
Signed-off-by: Chester Lin <clin@suse.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  13 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-s32cc.c | 318 ++++++++++++++++++
 3 files changed, 332 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-s32cc.c

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 31ff35174034..dd3fb5e462b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -153,6 +153,19 @@ config DWMAC_ROCKCHIP
 	  This selects the Rockchip RK3288 SoC glue layer support for
 	  the stmmac device driver.
 
+config DWMAC_S32CC
+	tristate "NXP S32 series GMAC support"
+	default ARCH_S32
+	depends on OF && (ARCH_S32 || COMPILE_TEST)
+	select MFD_SYSCON
+	select PHYLINK
+	help
+	  Support for ethernet controller on NXP S32 series SOCs.
+
+	  This selects NXP SoC glue layer support for the stmmac
+	  device driver. This driver is used for the S32 series
+	  SOCs GMAC ethernet controller.
+
 config DWMAC_SOCFPGA
 	tristate "SOCFPGA dwmac support"
 	default ARCH_INTEL_SOCFPGA
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index d4e12e9ace4f..ec92cc2becd7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_DWMAC_INTEL_PLAT)	+= dwmac-intel-plat.o
 obj-$(CONFIG_DWMAC_GENERIC)	+= dwmac-generic.o
 obj-$(CONFIG_DWMAC_IMX8)	+= dwmac-imx.o
 obj-$(CONFIG_DWMAC_VISCONTI)	+= dwmac-visconti.o
+obj-$(CONFIG_DWMAC_S32CC)	+= dwmac-s32cc.o
 stmmac-platform-objs:= stmmac_platform.o
 dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-s32cc.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-s32cc.c
new file mode 100644
index 000000000000..ac274cdfbe22
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-s32cc.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * DWMAC Specific Glue layer for NXP S32 Common Chassis
+ *
+ * Copyright (C) 2019-2022 NXP
+ * Copyright (C) 2022 SUSE LLC
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/ethtool.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_net.h>
+#include <linux/of_address.h>
+#include <linux/stmmac.h>
+
+#include "stmmac_platform.h"
+
+#define GMAC_TX_RATE_125M	125000000	/* 125MHz */
+#define GMAC_TX_RATE_25M	25000000	/* 25MHz */
+#define GMAC_TX_RATE_2M5	2500000		/* 2.5MHz */
+
+/* S32 SRC register for phyif selection */
+#define PHY_INTF_SEL_MII        0x00
+#define PHY_INTF_SEL_SGMII      0x01
+#define PHY_INTF_SEL_RGMII      0x02
+#define PHY_INTF_SEL_RMII       0x08
+
+/* AXI4 ACE control settings */
+#define ACE_DOMAIN_SIGNAL	0x2
+#define ACE_CACHE_SIGNAL	0xf
+#define ACE_CONTROL_SIGNALS	((ACE_DOMAIN_SIGNAL << 4) | ACE_CACHE_SIGNAL)
+#define ACE_PROTECTION		0x2
+
+struct s32cc_priv_data {
+	void __iomem *ctrl_sts;
+	struct device *dev;
+	phy_interface_t intf_mode;
+	struct clk *tx_clk;
+	struct clk *rx_clk;
+};
+
+static int s32cc_gmac_init(struct platform_device *pdev, void *priv)
+{
+	struct s32cc_priv_data *gmac = priv;
+	u32 intf_sel;
+	int ret;
+
+	if (gmac->tx_clk) {
+		ret = clk_prepare_enable(gmac->tx_clk);
+		if (ret) {
+			dev_err(&pdev->dev, "Can't set tx clock\n");
+			return ret;
+		}
+	}
+
+	if (gmac->rx_clk) {
+		ret = clk_prepare_enable(gmac->rx_clk);
+		if (ret) {
+			dev_err(&pdev->dev, "Can't set rx clock\n");
+			return ret;
+		}
+	}
+
+	/* set interface mode */
+	if (gmac->ctrl_sts) {
+		switch (gmac->intf_mode) {
+		default:
+			dev_info(&pdev->dev, "unsupported mode %u, set the default phy mode.\n",
+				 gmac->intf_mode);
+			fallthrough;
+		case PHY_INTERFACE_MODE_SGMII:
+			dev_info(&pdev->dev, "phy mode set to SGMII\n");
+			intf_sel = PHY_INTF_SEL_SGMII;
+			break;
+		case PHY_INTERFACE_MODE_RGMII:
+		case PHY_INTERFACE_MODE_RGMII_ID:
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+			dev_info(&pdev->dev, "phy mode set to RGMII\n");
+			intf_sel = PHY_INTF_SEL_RGMII;
+			break;
+		case PHY_INTERFACE_MODE_RMII:
+			dev_info(&pdev->dev, "phy mode set to RMII\n");
+			intf_sel = PHY_INTF_SEL_RMII;
+			break;
+		case PHY_INTERFACE_MODE_MII:
+			dev_info(&pdev->dev, "phy mode set to MII\n");
+			intf_sel = PHY_INTF_SEL_MII;
+			break;
+		}
+
+		writel(intf_sel, gmac->ctrl_sts);
+	}
+
+	return 0;
+}
+
+static void s32cc_gmac_exit(struct platform_device *pdev, void *priv)
+{
+	struct s32cc_priv_data *gmac = priv;
+
+	if (gmac->tx_clk)
+		clk_disable_unprepare(gmac->tx_clk);
+
+	if (gmac->rx_clk)
+		clk_disable_unprepare(gmac->rx_clk);
+}
+
+static void s32cc_fix_speed(void *priv, unsigned int speed)
+{
+	struct s32cc_priv_data *gmac = priv;
+
+	if (!gmac->tx_clk || !gmac->rx_clk)
+		return;
+
+	/* SGMII mode doesn't support the clock reconfiguration */
+	if (gmac->intf_mode == PHY_INTERFACE_MODE_SGMII)
+		return;
+
+	switch (speed) {
+	case SPEED_1000:
+		dev_info(gmac->dev, "Set TX clock to 125M\n");
+		clk_set_rate(gmac->tx_clk, GMAC_TX_RATE_125M);
+		break;
+	case SPEED_100:
+		dev_info(gmac->dev, "Set TX clock to 25M\n");
+		clk_set_rate(gmac->tx_clk, GMAC_TX_RATE_25M);
+		break;
+	case SPEED_10:
+		dev_info(gmac->dev, "Set TX clock to 2.5M\n");
+		clk_set_rate(gmac->tx_clk, GMAC_TX_RATE_2M5);
+		break;
+	default:
+		dev_err(gmac->dev, "Unsupported/Invalid speed: %d\n", speed);
+		return;
+	}
+}
+
+static int s32cc_config_cache_coherency(struct platform_device *pdev,
+					struct plat_stmmacenet_data *plat_dat)
+{
+	plat_dat->axi4_ace_ctrl =
+		devm_kzalloc(&pdev->dev,
+			     sizeof(struct stmmac_axi4_ace_ctrl),
+			     GFP_KERNEL);
+
+	if (!plat_dat->axi4_ace_ctrl) {
+		dev_info(&pdev->dev, "Fail to allocate axi4_ace_ctrl\n");
+		return -ENOMEM;
+	}
+
+	plat_dat->axi4_ace_ctrl->tx_ar_reg = (ACE_CONTROL_SIGNALS << 16)
+		| (ACE_CONTROL_SIGNALS << 8) | ACE_CONTROL_SIGNALS;
+
+	plat_dat->axi4_ace_ctrl->rx_aw_reg = (ACE_CONTROL_SIGNALS << 24)
+		| (ACE_CONTROL_SIGNALS << 16) | (ACE_CONTROL_SIGNALS << 8)
+		| ACE_CONTROL_SIGNALS;
+
+	plat_dat->axi4_ace_ctrl->txrx_awar_reg = (ACE_PROTECTION << 20)
+		| (ACE_PROTECTION << 16) | (ACE_CONTROL_SIGNALS << 8)
+		| ACE_CONTROL_SIGNALS;
+
+	return 0;
+}
+
+static int s32cc_dwmac_probe(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat_dat;
+	struct stmmac_resources stmmac_res;
+	struct s32cc_priv_data *gmac;
+	struct resource *res;
+	const char *tx_clk, *rx_clk;
+	int ret;
+
+	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
+	if (ret)
+		return ret;
+
+	gmac = devm_kzalloc(&pdev->dev, sizeof(*gmac), GFP_KERNEL);
+	if (!gmac)
+		return PTR_ERR(gmac);
+
+	gmac->dev = &pdev->dev;
+
+	/* S32G control reg */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	gmac->ctrl_sts = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR_OR_NULL(gmac->ctrl_sts)) {
+		dev_err(&pdev->dev, "S32CC config region is missing\n");
+		return PTR_ERR(gmac->ctrl_sts);
+	}
+
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	if (IS_ERR(plat_dat))
+		return PTR_ERR(plat_dat);
+
+	plat_dat->bsp_priv = gmac;
+
+	switch (plat_dat->phy_interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+		tx_clk = "tx_sgmii";
+		rx_clk = "rx_sgmii";
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		tx_clk = "tx_rgmii";
+		rx_clk = "rx_rgmii";
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		tx_clk = "tx_rmii";
+		rx_clk = "rx_rmii";
+		break;
+	case PHY_INTERFACE_MODE_MII:
+		tx_clk = "tx_mii";
+		rx_clk = "rx_mii";
+		break;
+	default:
+		dev_err(&pdev->dev, "Not supported phy interface mode: [%s]\n",
+			phy_modes(plat_dat->phy_interface));
+		return -EINVAL;
+	};
+
+	gmac->intf_mode = plat_dat->phy_interface;
+
+	/* DMA cache coherency settings */
+	if (of_dma_is_coherent(pdev->dev.of_node)) {
+		ret = s32cc_config_cache_coherency(pdev, plat_dat);
+		if (ret)
+			goto err_remove_config_dt;
+	}
+
+	/* tx clock */
+	gmac->tx_clk = devm_clk_get(&pdev->dev, tx_clk);
+	if (IS_ERR(gmac->tx_clk)) {
+		dev_info(&pdev->dev, "tx clock not found\n");
+		gmac->tx_clk = NULL;
+	}
+
+	/* rx clock */
+	gmac->rx_clk = devm_clk_get(&pdev->dev, rx_clk);
+	if (IS_ERR(gmac->rx_clk)) {
+		dev_info(&pdev->dev, "rx clock not found\n");
+		gmac->rx_clk = NULL;
+	}
+
+	ret = s32cc_gmac_init(pdev, gmac);
+	if (ret)
+		goto err_remove_config_dt;
+
+	/* core feature set */
+	plat_dat->has_gmac4 = true;
+	plat_dat->pmt = 1;
+
+	plat_dat->init = s32cc_gmac_init;
+	plat_dat->exit = s32cc_gmac_exit;
+	plat_dat->fix_mac_speed = s32cc_fix_speed;
+
+	/* safety feature config */
+	plat_dat->safety_feat_cfg =
+		devm_kzalloc(&pdev->dev, sizeof(*plat_dat->safety_feat_cfg),
+			     GFP_KERNEL);
+
+	if (!plat_dat->safety_feat_cfg) {
+		dev_info(&pdev->dev, "allocate safety_feat_cfg failed\n");
+		goto err_gmac_exit;
+	}
+
+	plat_dat->safety_feat_cfg->tsoee = 1;
+	plat_dat->safety_feat_cfg->mrxpee = 1;
+	plat_dat->safety_feat_cfg->mestee = 1;
+	plat_dat->safety_feat_cfg->mrxee = 1;
+	plat_dat->safety_feat_cfg->mtxee = 1;
+	plat_dat->safety_feat_cfg->epsi = 1;
+	plat_dat->safety_feat_cfg->edpp = 1;
+	plat_dat->safety_feat_cfg->prtyen = 1;
+	plat_dat->safety_feat_cfg->tmouten = 1;
+
+	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	if (ret)
+		goto err_gmac_exit;
+
+	return 0;
+
+err_gmac_exit:
+	s32cc_gmac_exit(pdev, plat_dat->bsp_priv);
+err_remove_config_dt:
+	stmmac_remove_config_dt(pdev, plat_dat);
+	return ret;
+}
+
+static const struct of_device_id s32_dwmac_match[] = {
+	{ .compatible = "nxp,s32cc-dwmac" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, s32_dwmac_match);
+
+static struct platform_driver s32_dwmac_driver = {
+	.probe  = s32cc_dwmac_probe,
+	.remove = stmmac_pltfr_remove,
+	.driver = {
+		.name           = "s32cc-dwmac",
+		.pm		= &stmmac_pltfr_pm_ops,
+		.of_match_table = s32_dwmac_match,
+	},
+};
+module_platform_driver(s32_dwmac_driver);
+
+MODULE_AUTHOR("Jan Petrous <jan.petrous@nxp.com>");
+MODULE_DESCRIPTION("NXP S32 common chassis GMAC driver");
+MODULE_LICENSE("GPL v2");
-- 
2.37.3

