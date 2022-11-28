Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0928F63A0F5
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 06:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiK1FvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 00:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiK1Fui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 00:50:38 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2067.outbound.protection.outlook.com [40.107.6.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BCA13F00;
        Sun, 27 Nov 2022 21:50:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANqB6awXbcNsJi7WC6LznCuyz0c11856jgbyUrAERF+fiPw0gvUiwAKkDgx4psKAvSIQUrlakq7k39qbBWq0EnbJ/z77U8KNPEhRDn91kEFQZFMFKPhGntIkkgtudg8cGmbt2YH3LwYF71DHxXFNicnJS7dQyJW4EgceFS0ltFh2EsnQAcp+yLsvIi0BrZZ+2ylXz3jzd4KPEK2Y1nXoBcHMNpwxn2pl3aPb1PjVBoiq0FwS1t+KypqBlYp2gY9juMtJtW2j+2kXmmZLFFma6dvx5FlRVemb5bqr9Ni9mVzTmrzN1V8U/J8Dzt/t5v0p2mW7nI9tBeriOLHxyESTag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGPle65F4eGot3cm24FaNKKKmcM/ky2wkXXe/DFPcIE=;
 b=BAAY1sXlvXOotCFMmojIN6YtnYZuJlrTjr6CV2HZqDMhHzaCANRTQHfUwG5azV9XfHOaYBF8Bg+kARmtom7EBH8QnSh2ACZ/dIInOXLXDJ8byJgo61K1bMmoWP8j8OAEzMfjnT4DyuFiKqWEa/9waXQv7T0MWCjpcQJl76DYq/C2g5IArT8A99ScAGu2F4oxcniwtVlVjLvNX7VqthHUINwQUxXMz0sVwG5+76sLNE07T+lBPLM1JIA7zFlCHWJ2wqqw0pUCsCEc11QdgYaU598s+RSHmBi1NzJ7UOb9kzscqzok6Z7scAUwqBfpvNpb9a96hAxCbI+TmRSE0eFPNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGPle65F4eGot3cm24FaNKKKmcM/ky2wkXXe/DFPcIE=;
 b=zdzJ3P0nJ6CcrC2X2gc7/81T+yNCfx2vmaN+3xBmYYkg+M6KIsw8VkL35gCt06zNzmVLjkCa5hlpc8TEUA3an+A0HLu6Z/ky+b616nFCNfMrkTfNU70IGpfWxEmq537mqWsCLoFcIYdAcUF3ayTAMtPJXNVgYeJb6uw/3R+ddNfwijqiGcZOc3rRXjl+Wflwp1m8hYbievty7W7v0QcWR59c9GmBWlfxjgw+PMzMzNFfVSU0QQv9hFSqG3FTwtooNNUp6MhhwJ7hIODU/1WZQwy6+PVXInFFpk/RGCFFE44uWSkwfQvxka0Oc1IPnQnUKVjnUr0+S/G1izVBpv7JLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by DB9PR04MB8478.eurprd04.prod.outlook.com (2603:10a6:10:2c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Mon, 28 Nov
 2022 05:50:19 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 05:50:19 +0000
From:   Chester Lin <clin@suse.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>
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
Subject: [PATCH v2 5/5] net: stmmac: Add NXP S32 SoC family support
Date:   Mon, 28 Nov 2022 13:49:20 +0800
Message-Id: <20221128054920.2113-6-clin@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221128054920.2113-1-clin@suse.com>
References: <20221128054920.2113-1-clin@suse.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0138.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::13) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|DB9PR04MB8478:EE_
X-MS-Office365-Filtering-Correlation-Id: c1eb77fa-d20e-4953-ae41-08dad1046e5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQ6R05rV5NODy8CsJBO9X0HJC/wrYAgk8+gZ68e7TvAKSXeTAN7HuXmxdDoNj3GRAO00UkwcMfNwNaJ4lTYK1XPdv5sNRhvNJdLWZWw7H2ISzJ6WnhKwdcFyg41VXxHySxjHq+tcQ8stpD7faOaHABDxnY3/0PpIJFiWiTlyEJ9ePtX+4UWu7ED6pRd6qt67hPEKb80BK/oL+RzqY+2GWXMwVMtjUQ7W65A9p4SkULC6jjGs08m27mlTMzYlStiUMOrrh44t91yYbJQ9TOsu8IH35yfWUyKtZGZXok1x+y3kb32jBCBHSDL6JfV8KbucFF2f/dor5kLg8BVj+5hS2SeobQ77PBEwgxV7tFrxMinoumF1e3pKAefXgBfFc09C7O5SF2Nnc8rwguwHVbUqv29XjoJOl2ve7JSSscFnSkuTnBKd6Jpfy9HwLYUBjOMx3MxFW5u1nlGA5PreevOkT1WBgc7/8e7MM9oRsD4MG7Aa20h88CUV0YAzuqWRO6TGBSX5ERg6tizVj7BMFMb1sQqn+Ny6kXQXE7AX6MQi8a48/n8qnqzvcsZVr+Q3kINXE8nu7ok4gP/ID5BQbeBHbiOeJt1zK+hLdfoBYkDd/onqQK+P/F810oU4Wk2jHODJbvFLIltkhdPEnPvtu5IK0feEUm00QrLc+YEKmpikeGc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199015)(107886003)(2906002)(186003)(6486002)(966005)(6506007)(36756003)(478600001)(6666004)(6512007)(1076003)(38100700002)(86362001)(83380400001)(2616005)(41300700001)(30864003)(66556008)(66476007)(8676002)(66946007)(5660300002)(4326008)(7416002)(8936002)(54906003)(316002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kFJWNbMbkdIGVV5HjZB2HeO6SVmTwHyjnNK1ujPUymyt9Z8nR3204opL5Mwt?=
 =?us-ascii?Q?XF1izgeZPiYQSw4U5sO3QU8RxpsKvQlP0+F6pEObzzM7R3w2BsBiOrTHidnW?=
 =?us-ascii?Q?Xrrcp3mIlnEpz6Y59JPmzE0FeImEhVIpCY91wGMvVo9xqW2jCtkANpoKRgDT?=
 =?us-ascii?Q?/eERcgDdt1QW5eonD0hTc5NsLSbhdUcM5FGwhKYux2bKqpGKS12DAmvibb7o?=
 =?us-ascii?Q?+ycBYkN8QWbvcVZleZFlRJF20HZWkU9nVqrtgwWE8BNZogqXd/wGD7Sm+ckj?=
 =?us-ascii?Q?gj33rSI/jGGo1uGbLEtKZ4d1U4mJP5Syfz/luy2BUUgTcU2WqfUx5y56fJ0J?=
 =?us-ascii?Q?ADl+1IvidkRjnENj3PsUtWYd+CvGveE4+Rd7pBCvHktL0kbJJmS52zpZWmFw?=
 =?us-ascii?Q?YafVTfPK8DeP3rbiJIQ/RKE9MSgzOuyc1/lbVRapoi2kgAKKq49MuMoqCyVY?=
 =?us-ascii?Q?Lwxsw26dth8ujwDZjRaH3aV0cEZAJyGqga3ZLNzZob/jccuNkGolPD1uVnsR?=
 =?us-ascii?Q?+yajP5OGG1vjQpoPuiQXFQDO8tb4/vqMcG0SqIJLhnJmyTDwxNj11JOIF2t4?=
 =?us-ascii?Q?lNOlxCXsRi1PHia/BlADiPcURm0uUlW5EbbmHAlr/gq+y6YwtEbTGaP8X5ux?=
 =?us-ascii?Q?3Qkut94BMGCp+3UzbFnFQKPy9xsuMutBa0nc1ijnoVaURfXshjY/vpv6CmP4?=
 =?us-ascii?Q?JNzeyg8tTU6WmMOeCppDuzexy/YtEXvbUqQlX4wzYalhSlJCyfLh3Z9bNxSF?=
 =?us-ascii?Q?px9mRuITEtQb/1WUUA/7SweoBv5YBp+sWKMj6MjqLOsmdWl8OoUO7nyAEk6Z?=
 =?us-ascii?Q?xJwu2Qx3+exYNq8gtW++KrtpwraQj+vGLrT/Iy3HLRzrQTIbcKdCk8CQ5oRu?=
 =?us-ascii?Q?QmGSUSd8ykVBPjSiSuPx41HM+zDZl2CMovWnN7Y4GktGZqSz23SlSY93BVTW?=
 =?us-ascii?Q?Q+PEzpFk7sAJH7Q49Q7mUSSqqr08uLgUkLUzXwmjBTBHt7hnrxcYB5iyqFxG?=
 =?us-ascii?Q?GnVVnN9w9U5Iw179Ev5Bn94MxbXUX8ogFZBra8ODSsrqO5NNBNWfVH1F9TBD?=
 =?us-ascii?Q?Y+QNU7NTNKhIrcdPjW4Q4A+F+M5Hf8arLnKw625SYgAxNJFS2a8uhJeS1aCh?=
 =?us-ascii?Q?05cQ+9t3qVswpJroFwDuC0BFpi0fwD4yHXEqcPLpaQsGxoxiuKOSMrEh3TsX?=
 =?us-ascii?Q?ugtNh/2ZYeo9DR5RrLe5sNiELuNtUW3rTYVSQ79vuAmJH6ZTfqzYiZaDjqPC?=
 =?us-ascii?Q?drAnsaJO/NX4HZUc7sE5yCfU04T5SqIUuzLo9LdCf4MH+dWTxm18CEVVtU39?=
 =?us-ascii?Q?cIZzUpPXeOOKd59OgvzN3lP4wWtjtYPMO9kdYugL9zbwVC0QJSsUuCwTnado?=
 =?us-ascii?Q?uuKu9rL1yCWhXi2vdn1hjD0G8rMZJYSlzh9fijVpCVOMnvFoOif9vymtIC5I?=
 =?us-ascii?Q?5kK+qmDXMsBEh0TJqXfNvui7LmzIIykET+Sj2ERQZkhenfxHisUzQT9QF3bH?=
 =?us-ascii?Q?AVllcfo2Nk0cAKfJ5YmQ2pBYLEWJDc3bDujDe3IOYeiP3SAOWaCi/U8UQdFN?=
 =?us-ascii?Q?F/vKZvtt1LEM+5G4aH4f6cnxujZU/jUFPUsJoA657gi1vD/+iGp19pnDt8LQ?=
 =?us-ascii?Q?pz8/xhADvPvR1LaS9wHL3zB0M7qkfWjP1+lsARa/ek2V?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1eb77fa-d20e-4953-ae41-08dad1046e5d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 05:50:18.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NxwCAgGLDzX3Z400xpFb/bQlVa/jD/8JvsGP8b/2vLZmMJVi8NLe9qnC8j7PcSEI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8478
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

Changes in v2:
- Replace clock names tx_sgmii/rx_sgmii with tx_pcs/rx_pcs.
- Adjust error handlings while calling devm_clk_get().
- Remove redundant dev_info messages.
- Remove unnecessary if conditions.
- Fix the copyright format suggested by NXP.

 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  13 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-s32cc.c | 304 ++++++++++++++++++
 3 files changed, 318 insertions(+)
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
index 000000000000..92a132ad985a
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-s32cc.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * DWMAC Specific Glue layer for NXP S32 Common Chassis
+ *
+ * Copyright 2019-2022 NXP
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
+	ret = clk_prepare_enable(gmac->tx_clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't enable tx clock\n");
+		return ret;
+	}
+
+	ret = clk_prepare_enable(gmac->rx_clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't enable rx clock\n");
+		return ret;
+	}
+
+	/* set interface mode */
+	switch (gmac->intf_mode) {
+	case PHY_INTERFACE_MODE_SGMII:
+		intf_sel = PHY_INTF_SEL_SGMII;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		intf_sel = PHY_INTF_SEL_RGMII;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		intf_sel = PHY_INTF_SEL_RMII;
+		break;
+	case PHY_INTERFACE_MODE_MII:
+		intf_sel = PHY_INTF_SEL_MII;
+		break;
+	default:
+		dev_err(&pdev->dev, "Unsupported PHY interface: %s\n",
+			phy_modes(gmac->intf_mode));
+		return -EINVAL;
+	}
+
+	writel(intf_sel, gmac->ctrl_sts);
+
+	dev_dbg(&pdev->dev, "PHY mode set to %s\n", phy_modes(gmac->intf_mode));
+
+	return 0;
+}
+
+static void s32cc_gmac_exit(struct platform_device *pdev, void *priv)
+{
+	struct s32cc_priv_data *gmac = priv;
+
+	clk_disable_unprepare(gmac->tx_clk);
+	clk_disable_unprepare(gmac->rx_clk);
+}
+
+static void s32cc_fix_speed(void *priv, unsigned int speed)
+{
+	struct s32cc_priv_data *gmac = priv;
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
+	if (!plat_dat->axi4_ace_ctrl)
+		return -ENOMEM;
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
+		tx_clk = "tx_pcs";
+		rx_clk = "rx_pcs";
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
+		dev_err(&pdev->dev, "Get TX clock failed\n");
+		ret = PTR_ERR(gmac->tx_clk);
+		goto err_remove_config_dt;
+	}
+
+	/* rx clock */
+	gmac->rx_clk = devm_clk_get(&pdev->dev, rx_clk);
+	if (IS_ERR(gmac->rx_clk)) {
+		dev_err(&pdev->dev, "Get RX clock failed\n");
+		ret = PTR_ERR(gmac->rx_clk);
+		goto err_remove_config_dt;
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
+		dev_err(&pdev->dev, "Allocate safety_feat_cfg failed\n");
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

