Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080D94D61DF
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348676AbiCKM4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbiCKM4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:56:08 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60079.outbound.protection.outlook.com [40.107.6.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A381BFDC9;
        Fri, 11 Mar 2022 04:55:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfRZhHwKXyMRi7JmCA96ZxJhaTwW0FL2lhDro2B0bsZwIPN7ZN/jLByuo03o5qSVeexkW6ObJI7y2/l3EkMgBiF2CliTUxIeNxZ2rs0TErCm3vXHqx+EcAWd0gjt1NYvEeEaa7CoCdxUw6OSkyGwYxQofg51jXpYcwshOk/6+s2kE7sU3FRURhMrlQOLIgihYpKGbA+Jv3ADbq7F7aWIQDRc3fTp7fJ8X+PQyyM1IpXr7SkejHbDnDZFeusbxhrEU6TWR9lqiqisWTgrIlPqWCMZ44uvk48KW24S848xhNu3C6d8MZasYbjvj0ZxAUMfJG0Uc3BikxcUfaqfuh7zEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sy1qeKM5QibFTp33iW9wjAlZaA5DqReD+tq+ADkxAtw=;
 b=JERDDygQVfQNxoxT6/8nlp+KZzNjc69O68iCPo6Yoa+b7Q3EP/jxQumqaEYzIW+xVd3+gckmG6i6dAPArXc+9EHF2wvlfJDNKjQU7I1t52dw9QxmsgTma9ZUUX8U4Xs/eWOvLNvhjR+3C+LkenH/1b/MmJWYE7Zer1gAcuYbKvDdUT23n7idwEAC2k/KFgpKT14cQIKe2LNBW8Xwd7VSW8L6GbG7bvHvOFA2kc/v4zBvniwHxBtO0lDDWQqLg9XawjaFAHOvSEXOI3vMoeICubENj1hmu5D7LOfYTYlwcTsZLlijgc4hALDBpizbekCew77dPkUobU7bnpE5vgbRgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sy1qeKM5QibFTp33iW9wjAlZaA5DqReD+tq+ADkxAtw=;
 b=H/PsufDcg3ttTddtubVqYYn68IRNk5EFCGj/D4YdSoYf+rQq8wE9QqveIOVu1lUWPsRz/yKCp/MdoAaVxOyIZaSIGdvNAvkf6P+VYnho0I9/vEm73XLXi+O+Nck9UJ/YLUapN0KVSasFbxVSRK0PmAFr34HG8Et7FXwZulHKNjs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM6PR0402MB3431.eurprd04.prod.outlook.com (2603:10a6:209:e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Fri, 11 Mar
 2022 12:55:01 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 12:55:01 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 1/8] phy: add support for the Layerscape SerDes 28G
Date:   Fri, 11 Mar 2022 14:54:30 +0200
Message-Id: <20220311125437.3854483-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
References: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0402CA0014.eurprd04.prod.outlook.com
 (2603:10a6:203:90::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a116a18-b5fa-4df7-a9f9-08da035e5a76
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3431:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB343108C220D21E74B1045803E00C9@AM6PR0402MB3431.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +n9TsJRXdlVlligsLqaD3vtaeAvfNes3Ug8uVPTV0bvH7z/aWhn2jnmK0eT/qxSB9vNy3E+2RDAHPhwe1Yffcwq/4rGg6pwvRQpyBwCTpkgd4//a70IlxLrWqRYKFvW4NKP2GcWztvYPw83o9/EEn93Rk+mayl03O4qB6754ayJxJ1nlqzexjUVRkCEHS+NQRzHJePaw6BaT9ydgT5yHfOHN7AgiMF7iyuPlQuuREtPoYIDBwxuUBGLyN4EXoaQg35YM1qMD22dyK6DgWnurf3kGxoXmUOKbwXqHex647142wndstdqivYgZaFRlpgDjK5PAdlxa60zO9pq4zaxTiNuRe7QwpjAF4hkTZ56dGkfUnvcJ3MWHUgNQtHmAPemSzag+vfD4DwgNdESpwob+PSnIOlVOQegEDmy5zphS2CGajYItSgQvgU4FdkfnIrI35UYtJ3VfcmTjtFYiMJyR8OB01sgfcWQZITwNSgQwSNuCRWIBgxouMaB1tp9mx2Uzy2hqW6Dx6tqG4RgoSEqH1W2UvKkhR/Io8PxWa9e+3G7Dxnndx2adeWz+80lWNeY897JkKQ/aUv1Hydrn2Fn9FsFUGuLOn2RDSUJlY7Ui/SyBSwhhj0FGGZI5KsJc5He4gTq8E7iUViR+eK0PPQRNRrn5zBc1yS7Jrb1wwj5XdieOlabEsVi94EH2mQ95oWSImTtFpypVWXMwFmXJjtmcrvxhgFPU7EOV29gXghYQLUie1PdKVrfFNW+jlpPnYhPTB1rw8vp5nC8VUFPenSB+tibUWiq0ScPCt+8jNBFeTFw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(66946007)(7416002)(966005)(5660300002)(6486002)(8936002)(44832011)(508600001)(66476007)(30864003)(66556008)(316002)(4326008)(83380400001)(1076003)(2616005)(6512007)(52116002)(6666004)(6506007)(2906002)(26005)(186003)(86362001)(36756003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RXzQAaekuq96r2N36tg1U9CwmP0DK0K68JzLQzWO8lnYf4jIqjrrpgloD753?=
 =?us-ascii?Q?sReT0yQlKr16iI7pR1cpC6CYN4fLzRdob71M9kX7HKECZuyiTOo5PETO3Rxo?=
 =?us-ascii?Q?V6XJ2jnu1HE5iCqmo2KWYoAV0jezqjj3FlBt4ZbR6Jf149mQInpSn/fES3G+?=
 =?us-ascii?Q?zkCZQ4cz415EKNRL0VvLJGYLXJSjvB2hA3LlNuvQgt37Rj8gz5tpHtKeQzzs?=
 =?us-ascii?Q?gvVWJyk+aAMwOiQHIvxyH9B4kWLarrqghLXyOTk5gMPYTbiORwbSm07254da?=
 =?us-ascii?Q?UB6eOiUC6aHpBFxMk3vGbsAefcf1vzf/CLZspf8QlgSKFaRK6S47/XgQhgjZ?=
 =?us-ascii?Q?i4/2snMy73xGpupcnJk0NoUVEeXaOdTqgSYQw/fvASZ8G9o4i9nqQyFAfI1s?=
 =?us-ascii?Q?kS1/mSov4Wo+Or/7oNaRub8IYkChXqARB32C+cgPQ8vs9FdHteO6q5SOIBf8?=
 =?us-ascii?Q?eoQcFX/8YMpbG+bYYuTNbg4027QIqLNL5UforoAEj3UaZkpySnuB+qAYKqal?=
 =?us-ascii?Q?72Ba+JkygcAdYRE1AfZLiL3BfWU2+FPNgmaWo+OUr3Mo901Mf9Ur1zEOl/ZL?=
 =?us-ascii?Q?fmyuGMdGQyT2yce2yuIx8xjNlfCbMdqs43XjUGI/dYOvIinnl+jV1pxCZoVY?=
 =?us-ascii?Q?Klm+j9g0IfuNcgmidiOAcjW76DQDzcMN99iXEcOQhbL5onLDJOUt+TThmyz5?=
 =?us-ascii?Q?Rj7jaFG/6p59mcBgbLCRG6q0OzLQ7atMNinNGI24kKaOrCFjU3ro0BVp9bvz?=
 =?us-ascii?Q?wI+J6HRhBWl62ggWz+lQGjsCljuTKYaNvEs2BFLoPOm1TVusLY1dVjHIz4l8?=
 =?us-ascii?Q?coR6IaVXEuPvBB1zGom9EXprJFjfyCEsC819Jk0JsogE4EcaQ8d6wDXNH58j?=
 =?us-ascii?Q?5q4lMVK4RbtErvRo90DJ0l/yLrMeB40ItvVZ7xRfL2XQzJsb+O1gMHUjAJie?=
 =?us-ascii?Q?1I1aPEVfqUVo8ow0oMkR2g4ZjqHBvNJzu3twAUP/6T8y74agepgnKQfWH1mh?=
 =?us-ascii?Q?YywX/nfKQDNnwdjQ4lzP5Pn+ao6eJ9p9+bpX8LkYXbOt22UmQbYI2uCZBLfO?=
 =?us-ascii?Q?v7BIApNlUh/PYku7/heFvDg/k4cw3dBGKmnYrd2TMZXO4k2M3Tz6DJYfbTJK?=
 =?us-ascii?Q?0bEp/52Iv8DDIpmTDsDlIwYb7kk2AiZSqlTN82v0x/cHPZlRtGO9PmeYcF4M?=
 =?us-ascii?Q?yl/1GBnrCGem10jrWW9R7wxWaUX9oeRFSUmHw1K9TYtZR7P9S4xiBXmTxgKT?=
 =?us-ascii?Q?HvEqmpKw0FXJazm7pbx7JyyYzM3oMmTJbfuMY+9Y8B8L87Jurh7BZ+ZoSF9B?=
 =?us-ascii?Q?5n6M9vyVarUwQXCKs8ZCuviV1+e2trFgwdHtWVAbbG8vgmpqPG3HFzWMPzwS?=
 =?us-ascii?Q?JpQbTv3n6bbmZS/JTuys3Bk1OFbYhVGICy5R62FhsFtVBY1dFpSwAWxZ+Abr?=
 =?us-ascii?Q?QPbfTIukDp2BGzEIjDYDXNCEWe8CeOzwX+97AEq2vt21XNGloeZ6B2roqRLe?=
 =?us-ascii?Q?7e6aHD/Owfx7VA+pCKJ9A1wpfpqIo3wZzm+Vl+CSjJGkQvHglfgXTOUlsl/J?=
 =?us-ascii?Q?CToMJJsJJsZQ6T3Yiu9/CZR8A3Fp8gnqyOnD1xbUtDP25ce/mNnRt+yg78Y/?=
 =?us-ascii?Q?RLdP7f3gOotNDjKv/pzt444=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a116a18-b5fa-4df7-a9f9-08da035e5a76
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:55:01.1193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JbRv8cyCAZzwv+6S1d9YXJESwg8KVJcP9mxIJ1CuMsQgH/x5bD0zrbnxgNOOM0ZK1v6msvwap2nZ/EMWyvWpCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3431
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new generic PHY driver to support the Lynx 28G SerDes
block found on some of the Layerscape SoCs such as LX2160A.
At the moment, only the following Ethernet protocols are supported:
SGMII/1000Base-X and 10GBaseR.

SerDes lanes which are not running an Ethernet protocol or a currently
supported Ethenet protocol will be left as it was configured through the
RCW (Reset Configuration Word) at boot time.

At probe time, the platform driver will read the current
configuration of both PLLs found on a SerDes block and will determine
what protocols are supported using that PLL.

For example, if a PLL is configured to generate a clock net (frate) of
5GHz the only protocols sustained by that PLL are SGMII/1000Base-X
(using a quarter of the full clock rate) and QSGMII using the full clock
net frequency on the lane.

On the .set_mode() callback, the PHY driver will first check if the
requested operating mode (protocol) is even supported by the current PLL
configuration and will error out if not.
Then, the lane is reconfigured to run on the requested protocol.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- 1/8: add MODULE_LICENSE
Changes in v3:
	- none
Changes in v4:
	- 1/8: remove the DT nodes parsing
	- 1/8: add an xlate function


 MAINTAINERS                              |   6 +
 drivers/phy/freescale/Kconfig            |  10 +
 drivers/phy/freescale/Makefile           |   1 +
 drivers/phy/freescale/phy-fsl-lynx-28g.c | 624 +++++++++++++++++++++++
 4 files changed, 641 insertions(+)
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-28g.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 76a79c258743..3e76c8cd8a3a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11336,6 +11336,12 @@ S:	Maintained
 W:	http://linux-test-project.github.io/
 T:	git git://github.com/linux-test-project/ltp.git
 
+LYNX 28G SERDES PHY DRIVER
+M:	Ioana Ciornei <ioana.ciornei@nxp.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/phy/freescale/phy-fsl-lynx-28g.c
+
 LYNX PCS MODULE
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 L:	netdev@vger.kernel.org
diff --git a/drivers/phy/freescale/Kconfig b/drivers/phy/freescale/Kconfig
index c3669c28ea9f..0e91cd99c36b 100644
--- a/drivers/phy/freescale/Kconfig
+++ b/drivers/phy/freescale/Kconfig
@@ -22,3 +22,13 @@ config PHY_FSL_IMX8M_PCIE
 	help
 	  Enable this to add support for the PCIE PHY as found on
 	  i.MX8M family of SOCs.
+
+config PHY_FSL_LYNX_28G
+	tristate "Freescale Layerscape Lynx 28G SerDes PHY support"
+	depends on OF
+	select GENERIC_PHY
+	help
+	  Enable this to add support for the Lynx SerDes 28G PHY as
+	  found on NXP's Layerscape platforms such as LX2160A.
+	  Used to change the protocol running on SerDes lanes at runtime.
+	  Only useful for a restricted set of Ethernet protocols.
diff --git a/drivers/phy/freescale/Makefile b/drivers/phy/freescale/Makefile
index 55d07c742ab0..3518d5dbe8a7 100644
--- a/drivers/phy/freescale/Makefile
+++ b/drivers/phy/freescale/Makefile
@@ -2,3 +2,4 @@
 obj-$(CONFIG_PHY_FSL_IMX8MQ_USB)	+= phy-fsl-imx8mq-usb.o
 obj-$(CONFIG_PHY_MIXEL_MIPI_DPHY)	+= phy-fsl-imx8-mipi-dphy.o
 obj-$(CONFIG_PHY_FSL_IMX8M_PCIE)	+= phy-fsl-imx8m-pcie.o
+obj-$(CONFIG_PHY_FSL_LYNX_28G)		+= phy-fsl-lynx-28g.o
diff --git a/drivers/phy/freescale/phy-fsl-lynx-28g.c b/drivers/phy/freescale/phy-fsl-lynx-28g.c
new file mode 100644
index 000000000000..a2b060e9e284
--- /dev/null
+++ b/drivers/phy/freescale/phy-fsl-lynx-28g.c
@@ -0,0 +1,624 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2021-2022 NXP. */
+
+#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <linux/workqueue.h>
+
+#define LYNX_28G_NUM_LANE			8
+#define LYNX_28G_NUM_PLL			2
+
+/* General registers per SerDes block */
+#define LYNX_28G_PCC8				0x10a0
+#define LYNX_28G_PCC8_SGMII			0x1
+#define LYNX_28G_PCC8_SGMII_DIS			0x0
+
+#define LYNX_28G_PCCC				0x10b0
+#define LYNX_28G_PCCC_10GBASER			0x9
+#define LYNX_28G_PCCC_USXGMII			0x1
+#define LYNX_28G_PCCC_SXGMII_DIS		0x0
+
+#define LYNX_28G_LNa_PCC_OFFSET(lane)		(4 * (LYNX_28G_NUM_LANE - (lane->id) - 1))
+
+/* Per PLL registers */
+#define LYNX_28G_PLLnRSTCTL(pll)		(0x400 + (pll) * 0x100 + 0x0)
+#define LYNX_28G_PLLnRSTCTL_DIS(rstctl)		(((rstctl) & BIT(24)) >> 24)
+#define LYNX_28G_PLLnRSTCTL_LOCK(rstctl)	(((rstctl) & BIT(23)) >> 23)
+
+#define LYNX_28G_PLLnCR0(pll)			(0x400 + (pll) * 0x100 + 0x4)
+#define LYNX_28G_PLLnCR0_REFCLK_SEL(cr0)	(((cr0) & GENMASK(20, 16)))
+#define LYNX_28G_PLLnCR0_REFCLK_SEL_100MHZ	0x0
+#define LYNX_28G_PLLnCR0_REFCLK_SEL_125MHZ	0x10000
+#define LYNX_28G_PLLnCR0_REFCLK_SEL_156MHZ	0x20000
+#define LYNX_28G_PLLnCR0_REFCLK_SEL_150MHZ	0x30000
+#define LYNX_28G_PLLnCR0_REFCLK_SEL_161MHZ	0x40000
+
+#define LYNX_28G_PLLnCR1(pll)			(0x400 + (pll) * 0x100 + 0x8)
+#define LYNX_28G_PLLnCR1_FRATE_SEL(cr1)		(((cr1) & GENMASK(28, 24)))
+#define LYNX_28G_PLLnCR1_FRATE_5G_10GVCO	0x0
+#define LYNX_28G_PLLnCR1_FRATE_5G_25GVCO	0x10000000
+#define LYNX_28G_PLLnCR1_FRATE_10G_20GVCO	0x6000000
+
+/* Per SerDes lane registers */
+/* Lane a General Control Register */
+#define LYNX_28G_LNaGCR0(lane)			(0x800 + (lane) * 0x100 + 0x0)
+#define LYNX_28G_LNaGCR0_PROTO_SEL_MSK		GENMASK(7, 3)
+#define LYNX_28G_LNaGCR0_PROTO_SEL_SGMII	0x8
+#define LYNX_28G_LNaGCR0_PROTO_SEL_XFI		0x50
+#define LYNX_28G_LNaGCR0_IF_WIDTH_MSK		GENMASK(2, 0)
+#define LYNX_28G_LNaGCR0_IF_WIDTH_10_BIT	0x0
+#define LYNX_28G_LNaGCR0_IF_WIDTH_20_BIT	0x2
+
+/* Lane a Tx Reset Control Register */
+#define LYNX_28G_LNaTRSTCTL(lane)		(0x800 + (lane) * 0x100 + 0x20)
+#define LYNX_28G_LNaTRSTCTL_HLT_REQ		BIT(27)
+#define LYNX_28G_LNaTRSTCTL_RST_DONE		BIT(30)
+#define LYNX_28G_LNaTRSTCTL_RST_REQ		BIT(31)
+
+/* Lane a Tx General Control Register */
+#define LYNX_28G_LNaTGCR0(lane)			(0x800 + (lane) * 0x100 + 0x24)
+#define LYNX_28G_LNaTGCR0_USE_PLLF		0x0
+#define LYNX_28G_LNaTGCR0_USE_PLLS		BIT(28)
+#define LYNX_28G_LNaTGCR0_USE_PLL_MSK		BIT(28)
+#define LYNX_28G_LNaTGCR0_N_RATE_FULL		0x0
+#define LYNX_28G_LNaTGCR0_N_RATE_HALF		0x1000000
+#define LYNX_28G_LNaTGCR0_N_RATE_QUARTER	0x2000000
+#define LYNX_28G_LNaTGCR0_N_RATE_MSK		GENMASK(26, 24)
+
+#define LYNX_28G_LNaTECR0(lane)			(0x800 + (lane) * 0x100 + 0x30)
+
+/* Lane a Rx Reset Control Register */
+#define LYNX_28G_LNaRRSTCTL(lane)		(0x800 + (lane) * 0x100 + 0x40)
+#define LYNX_28G_LNaRRSTCTL_HLT_REQ		BIT(27)
+#define LYNX_28G_LNaRRSTCTL_RST_DONE		BIT(30)
+#define LYNX_28G_LNaRRSTCTL_RST_REQ		BIT(31)
+#define LYNX_28G_LNaRRSTCTL_CDR_LOCK		BIT(12)
+
+/* Lane a Rx General Control Register */
+#define LYNX_28G_LNaRGCR0(lane)			(0x800 + (lane) * 0x100 + 0x44)
+#define LYNX_28G_LNaRGCR0_USE_PLLF		0x0
+#define LYNX_28G_LNaRGCR0_USE_PLLS		BIT(28)
+#define LYNX_28G_LNaRGCR0_USE_PLL_MSK		BIT(28)
+#define LYNX_28G_LNaRGCR0_N_RATE_MSK		GENMASK(26, 24)
+#define LYNX_28G_LNaRGCR0_N_RATE_FULL		0x0
+#define LYNX_28G_LNaRGCR0_N_RATE_HALF		0x1000000
+#define LYNX_28G_LNaRGCR0_N_RATE_QUARTER	0x2000000
+#define LYNX_28G_LNaRGCR0_N_RATE_MSK		GENMASK(26, 24)
+
+#define LYNX_28G_LNaRGCR1(lane)			(0x800 + (lane) * 0x100 + 0x48)
+
+#define LYNX_28G_LNaRECR0(lane)			(0x800 + (lane) * 0x100 + 0x50)
+#define LYNX_28G_LNaRECR1(lane)			(0x800 + (lane) * 0x100 + 0x54)
+#define LYNX_28G_LNaRECR2(lane)			(0x800 + (lane) * 0x100 + 0x58)
+
+#define LYNX_28G_LNaRSCCR0(lane)		(0x800 + (lane) * 0x100 + 0x74)
+
+#define LYNX_28G_LNaPSS(lane)			(0x1000 + (lane) * 0x4)
+#define LYNX_28G_LNaPSS_TYPE(pss)		(((pss) & GENMASK(30, 24)) >> 24)
+#define LYNX_28G_LNaPSS_TYPE_SGMII		0x4
+#define LYNX_28G_LNaPSS_TYPE_XFI		0x28
+
+#define LYNX_28G_SGMIIaCR1(lane)		(0x1804 + (lane) * 0x10)
+#define LYNX_28G_SGMIIaCR1_SGPCS_EN		BIT(11)
+#define LYNX_28G_SGMIIaCR1_SGPCS_DIS		0x0
+#define LYNX_28G_SGMIIaCR1_SGPCS_MSK		BIT(11)
+
+struct lynx_28g_priv;
+
+struct lynx_28g_pll {
+	struct lynx_28g_priv *priv;
+	u32 rstctl, cr0, cr1;
+	int id;
+	DECLARE_PHY_INTERFACE_MASK(supported);
+};
+
+struct lynx_28g_lane {
+	struct lynx_28g_priv *priv;
+	struct phy *phy;
+	bool powered_up;
+	bool init;
+	unsigned int id;
+	phy_interface_t interface;
+};
+
+struct lynx_28g_priv {
+	void __iomem *base;
+	struct device *dev;
+	struct lynx_28g_pll pll[LYNX_28G_NUM_PLL];
+	struct lynx_28g_lane lane[LYNX_28G_NUM_LANE];
+
+	struct delayed_work cdr_check;
+};
+
+static void lynx_28g_rmw(struct lynx_28g_priv *priv, unsigned long off,
+			 u32 val, u32 mask)
+{
+	void __iomem *reg = priv->base + off;
+	u32 orig, tmp;
+
+	orig = ioread32(reg);
+	tmp = orig & ~mask;
+	tmp |= val;
+	iowrite32(tmp, reg);
+}
+
+#define lynx_28g_lane_rmw(lane, reg, val, mask)	\
+	lynx_28g_rmw((lane)->priv, LYNX_28G_##reg(lane->id), \
+		     LYNX_28G_##reg##_##val, LYNX_28G_##reg##_##mask)
+#define lynx_28g_lane_read(lane, reg)			\
+	ioread32((lane)->priv->base + LYNX_28G_##reg((lane)->id))
+#define lynx_28g_pll_read(pll, reg)			\
+	ioread32((pll)->priv->base + LYNX_28G_##reg((pll)->id))
+
+static bool lynx_28g_supports_interface(struct lynx_28g_priv *priv, int intf)
+{
+	int i;
+
+	for (i = 0; i < LYNX_28G_NUM_PLL; i++) {
+		if (LYNX_28G_PLLnRSTCTL_DIS(priv->pll[i].rstctl))
+			continue;
+
+		if (test_bit(intf, priv->pll[i].supported))
+			return true;
+	}
+
+	return false;
+}
+
+static struct lynx_28g_pll *lynx_28g_pll_get(struct lynx_28g_priv *priv,
+					     phy_interface_t intf)
+{
+	struct lynx_28g_pll *pll;
+	int i;
+
+	for (i = 0; i < LYNX_28G_NUM_PLL; i++) {
+		pll = &priv->pll[i];
+
+		if (LYNX_28G_PLLnRSTCTL_DIS(pll->rstctl))
+			continue;
+
+		if (test_bit(intf, pll->supported))
+			return pll;
+	}
+
+	return NULL;
+}
+
+static void lynx_28g_lane_set_nrate(struct lynx_28g_lane *lane,
+				    struct lynx_28g_pll *pll,
+				    phy_interface_t intf)
+{
+	switch (LYNX_28G_PLLnCR1_FRATE_SEL(pll->cr1)) {
+	case LYNX_28G_PLLnCR1_FRATE_5G_10GVCO:
+	case LYNX_28G_PLLnCR1_FRATE_5G_25GVCO:
+		switch (intf) {
+		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_1000BASEX:
+			lynx_28g_lane_rmw(lane, LNaTGCR0, N_RATE_QUARTER, N_RATE_MSK);
+			lynx_28g_lane_rmw(lane, LNaRGCR0, N_RATE_QUARTER, N_RATE_MSK);
+			break;
+		default:
+			break;
+		}
+		break;
+	case LYNX_28G_PLLnCR1_FRATE_10G_20GVCO:
+		switch (intf) {
+		case PHY_INTERFACE_MODE_10GBASER:
+		case PHY_INTERFACE_MODE_USXGMII:
+			lynx_28g_lane_rmw(lane, LNaTGCR0, N_RATE_FULL, N_RATE_MSK);
+			lynx_28g_lane_rmw(lane, LNaRGCR0, N_RATE_FULL, N_RATE_MSK);
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void lynx_28g_lane_set_pll(struct lynx_28g_lane *lane,
+				  struct lynx_28g_pll *pll)
+{
+	if (pll->id == 0) {
+		lynx_28g_lane_rmw(lane, LNaTGCR0, USE_PLLF, USE_PLL_MSK);
+		lynx_28g_lane_rmw(lane, LNaRGCR0, USE_PLLF, USE_PLL_MSK);
+	} else {
+		lynx_28g_lane_rmw(lane, LNaTGCR0, USE_PLLS, USE_PLL_MSK);
+		lynx_28g_lane_rmw(lane, LNaRGCR0, USE_PLLS, USE_PLL_MSK);
+	}
+}
+
+static void lynx_28g_cleanup_lane(struct lynx_28g_lane *lane)
+{
+	u32 lane_offset = LYNX_28G_LNa_PCC_OFFSET(lane);
+	struct lynx_28g_priv *priv = lane->priv;
+
+	/* Cleanup the protocol configuration registers of the current protocol */
+	switch (lane->interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		lynx_28g_rmw(priv, LYNX_28G_PCCC,
+			     LYNX_28G_PCCC_SXGMII_DIS << lane_offset,
+			     GENMASK(3, 0) << lane_offset);
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		lynx_28g_rmw(priv, LYNX_28G_PCC8,
+			     LYNX_28G_PCC8_SGMII_DIS << lane_offset,
+			     GENMASK(3, 0) << lane_offset);
+		break;
+	default:
+		break;
+	}
+}
+
+static void lynx_28g_lane_set_sgmii(struct lynx_28g_lane *lane)
+{
+	u32 lane_offset = LYNX_28G_LNa_PCC_OFFSET(lane);
+	struct lynx_28g_priv *priv = lane->priv;
+	struct lynx_28g_pll *pll;
+
+	lynx_28g_cleanup_lane(lane);
+
+	/* Setup the lane to run in SGMII */
+	lynx_28g_rmw(priv, LYNX_28G_PCC8,
+		     LYNX_28G_PCC8_SGMII << lane_offset,
+		     GENMASK(3, 0) << lane_offset);
+
+	/* Setup the protocol select and SerDes parallel interface width */
+	lynx_28g_lane_rmw(lane, LNaGCR0, PROTO_SEL_SGMII, PROTO_SEL_MSK);
+	lynx_28g_lane_rmw(lane, LNaGCR0, IF_WIDTH_10_BIT, IF_WIDTH_MSK);
+
+	/* Switch to the PLL that works with this interface type */
+	pll = lynx_28g_pll_get(priv, PHY_INTERFACE_MODE_SGMII);
+	lynx_28g_lane_set_pll(lane, pll);
+
+	/* Choose the portion of clock net to be used on this lane */
+	lynx_28g_lane_set_nrate(lane, pll, PHY_INTERFACE_MODE_SGMII);
+
+	/* Enable the SGMII PCS */
+	lynx_28g_lane_rmw(lane, SGMIIaCR1, SGPCS_EN, SGPCS_MSK);
+
+	/* Configure the appropriate equalization parameters for the protocol */
+	iowrite32(0x00808006, priv->base + LYNX_28G_LNaTECR0(lane->id));
+	iowrite32(0x04310000, priv->base + LYNX_28G_LNaRGCR1(lane->id));
+	iowrite32(0x9f800000, priv->base + LYNX_28G_LNaRECR0(lane->id));
+	iowrite32(0x001f0000, priv->base + LYNX_28G_LNaRECR1(lane->id));
+	iowrite32(0x00000000, priv->base + LYNX_28G_LNaRECR2(lane->id));
+	iowrite32(0x00000000, priv->base + LYNX_28G_LNaRSCCR0(lane->id));
+}
+
+static void lynx_28g_lane_set_10gbaser(struct lynx_28g_lane *lane)
+{
+	u32 lane_offset = LYNX_28G_LNa_PCC_OFFSET(lane);
+	struct lynx_28g_priv *priv = lane->priv;
+	struct lynx_28g_pll *pll;
+
+	lynx_28g_cleanup_lane(lane);
+
+	/* Enable the SXGMII lane */
+	lynx_28g_rmw(priv, LYNX_28G_PCCC,
+		     LYNX_28G_PCCC_10GBASER << lane_offset,
+		     GENMASK(3, 0) << lane_offset);
+
+	/* Setup the protocol select and SerDes parallel interface width */
+	lynx_28g_lane_rmw(lane, LNaGCR0, PROTO_SEL_XFI, PROTO_SEL_MSK);
+	lynx_28g_lane_rmw(lane, LNaGCR0, IF_WIDTH_20_BIT, IF_WIDTH_MSK);
+
+	/* Switch to the PLL that works with this interface type */
+	pll = lynx_28g_pll_get(priv, PHY_INTERFACE_MODE_10GBASER);
+	lynx_28g_lane_set_pll(lane, pll);
+
+	/* Choose the portion of clock net to be used on this lane */
+	lynx_28g_lane_set_nrate(lane, pll, PHY_INTERFACE_MODE_10GBASER);
+
+	/* Disable the SGMII PCS */
+	lynx_28g_lane_rmw(lane, SGMIIaCR1, SGPCS_DIS, SGPCS_MSK);
+
+	/* Configure the appropriate equalization parameters for the protocol */
+	iowrite32(0x10808307, priv->base + LYNX_28G_LNaTECR0(lane->id));
+	iowrite32(0x10000000, priv->base + LYNX_28G_LNaRGCR1(lane->id));
+	iowrite32(0x00000000, priv->base + LYNX_28G_LNaRECR0(lane->id));
+	iowrite32(0x001f0000, priv->base + LYNX_28G_LNaRECR1(lane->id));
+	iowrite32(0x81000020, priv->base + LYNX_28G_LNaRECR2(lane->id));
+	iowrite32(0x00002000, priv->base + LYNX_28G_LNaRSCCR0(lane->id));
+}
+
+static int lynx_28g_power_off(struct phy *phy)
+{
+	struct lynx_28g_lane *lane = phy_get_drvdata(phy);
+	u32 trstctl, rrstctl;
+
+	if (!lane->powered_up)
+		return 0;
+
+	/* Issue a halt request */
+	lynx_28g_lane_rmw(lane, LNaTRSTCTL, HLT_REQ, HLT_REQ);
+	lynx_28g_lane_rmw(lane, LNaRRSTCTL, HLT_REQ, HLT_REQ);
+
+	/* Wait until the halting process is complete */
+	do {
+		trstctl = lynx_28g_lane_read(lane, LNaTRSTCTL);
+		rrstctl = lynx_28g_lane_read(lane, LNaRRSTCTL);
+	} while ((trstctl & LYNX_28G_LNaTRSTCTL_HLT_REQ) ||
+		 (rrstctl & LYNX_28G_LNaRRSTCTL_HLT_REQ));
+
+	lane->powered_up = false;
+
+	return 0;
+}
+
+static int lynx_28g_power_on(struct phy *phy)
+{
+	struct lynx_28g_lane *lane = phy_get_drvdata(phy);
+	u32 trstctl, rrstctl;
+
+	if (lane->powered_up)
+		return 0;
+
+	/* Issue a reset request on the lane */
+	lynx_28g_lane_rmw(lane, LNaTRSTCTL, RST_REQ, RST_REQ);
+	lynx_28g_lane_rmw(lane, LNaRRSTCTL, RST_REQ, RST_REQ);
+
+	/* Wait until the reset sequence is completed */
+	do {
+		trstctl = lynx_28g_lane_read(lane, LNaTRSTCTL);
+		rrstctl = lynx_28g_lane_read(lane, LNaRRSTCTL);
+	} while (!(trstctl & LYNX_28G_LNaTRSTCTL_RST_DONE) ||
+		 !(rrstctl & LYNX_28G_LNaRRSTCTL_RST_DONE));
+
+	lane->powered_up = true;
+
+	return 0;
+}
+
+static int lynx_28g_set_mode(struct phy *phy, enum phy_mode mode, int submode)
+{
+	struct lynx_28g_lane *lane = phy_get_drvdata(phy);
+	struct lynx_28g_priv *priv = lane->priv;
+	int powered_up = lane->powered_up;
+	int err = 0;
+
+	if (mode != PHY_MODE_ETHERNET)
+		return -EOPNOTSUPP;
+
+	if (lane->interface == PHY_INTERFACE_MODE_NA)
+		return -EOPNOTSUPP;
+
+	if (!lynx_28g_supports_interface(priv, submode))
+		return -EOPNOTSUPP;
+
+	/* If the lane is powered up, put the lane into the halt state while
+	 * the reconfiguration is being done.
+	 */
+	if (powered_up)
+		lynx_28g_power_off(phy);
+
+	switch (submode) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		lynx_28g_lane_set_sgmii(lane);
+		break;
+	case PHY_INTERFACE_MODE_10GBASER:
+		lynx_28g_lane_set_10gbaser(lane);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	lane->interface = submode;
+
+out:
+	/* Power up the lane if necessary */
+	if (powered_up)
+		lynx_28g_power_on(phy);
+
+	return err;
+}
+
+static int lynx_28g_validate(struct phy *phy, enum phy_mode mode, int submode,
+			     union phy_configure_opts *opts __always_unused)
+{
+	struct lynx_28g_lane *lane = phy_get_drvdata(phy);
+	struct lynx_28g_priv *priv = lane->priv;
+
+	if (mode != PHY_MODE_ETHERNET)
+		return -EOPNOTSUPP;
+
+	if (!lynx_28g_supports_interface(priv, submode))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int lynx_28g_init(struct phy *phy)
+{
+	struct lynx_28g_lane *lane = phy_get_drvdata(phy);
+
+	/* Mark the fact that the lane was init */
+	lane->init = true;
+
+	/* SerDes lanes are powered on at boot time.  Any lane that is managed
+	 * by this driver will get powered down at init time aka at dpaa2-eth
+	 * probe time.
+	 */
+	lane->powered_up = true;
+	lynx_28g_power_off(phy);
+
+	return 0;
+}
+
+static const struct phy_ops lynx_28g_ops = {
+	.init		= lynx_28g_init,
+	.power_on	= lynx_28g_power_on,
+	.power_off	= lynx_28g_power_off,
+	.set_mode	= lynx_28g_set_mode,
+	.validate	= lynx_28g_validate,
+	.owner		= THIS_MODULE,
+};
+
+static void lynx_28g_pll_read_configuration(struct lynx_28g_priv *priv)
+{
+	struct lynx_28g_pll *pll;
+	int i;
+
+	for (i = 0; i < LYNX_28G_NUM_PLL; i++) {
+		pll = &priv->pll[i];
+		pll->priv = priv;
+		pll->id = i;
+
+		pll->rstctl = lynx_28g_pll_read(pll, PLLnRSTCTL);
+		pll->cr0 = lynx_28g_pll_read(pll, PLLnCR0);
+		pll->cr1 = lynx_28g_pll_read(pll, PLLnCR1);
+
+		if (LYNX_28G_PLLnRSTCTL_DIS(pll->rstctl))
+			continue;
+
+		switch (LYNX_28G_PLLnCR1_FRATE_SEL(pll->cr1)) {
+		case LYNX_28G_PLLnCR1_FRATE_5G_10GVCO:
+		case LYNX_28G_PLLnCR1_FRATE_5G_25GVCO:
+			/* 5GHz clock net */
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX, pll->supported);
+			__set_bit(PHY_INTERFACE_MODE_SGMII, pll->supported);
+			break;
+		case LYNX_28G_PLLnCR1_FRATE_10G_20GVCO:
+			/* 10.3125GHz clock net */
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, pll->supported);
+			break;
+		default:
+			/* 6GHz, 12.890625GHz, 8GHz */
+			break;
+		}
+	}
+}
+
+#define work_to_lynx(w) container_of((w), struct lynx_28g_priv, cdr_check.work)
+
+static void lynx_28g_cdr_lock_check(struct work_struct *work)
+{
+	struct lynx_28g_priv *priv = work_to_lynx(work);
+	struct lynx_28g_lane *lane;
+	u32 rrstctl;
+	int i;
+
+	for (i = 0; i < LYNX_28G_NUM_LANE; i++) {
+		lane = &priv->lane[i];
+
+		if (!lane->init)
+			continue;
+
+		if (!lane->powered_up)
+			continue;
+
+		rrstctl = lynx_28g_lane_read(lane, LNaRRSTCTL);
+		if (!(rrstctl & LYNX_28G_LNaRRSTCTL_CDR_LOCK)) {
+			lynx_28g_lane_rmw(lane, LNaRRSTCTL, RST_REQ, RST_REQ);
+			do {
+				rrstctl = lynx_28g_lane_read(lane, LNaRRSTCTL);
+			} while (!(rrstctl & LYNX_28G_LNaRRSTCTL_RST_DONE));
+		}
+	}
+	queue_delayed_work(system_power_efficient_wq, &priv->cdr_check,
+			   msecs_to_jiffies(1000));
+}
+
+static void lynx_28g_lane_read_configuration(struct lynx_28g_lane *lane)
+{
+	u32 pss, protocol;
+
+	pss = lynx_28g_lane_read(lane, LNaPSS);
+	protocol = LYNX_28G_LNaPSS_TYPE(pss);
+	switch (protocol) {
+	case LYNX_28G_LNaPSS_TYPE_SGMII:
+		lane->interface = PHY_INTERFACE_MODE_SGMII;
+		break;
+	case LYNX_28G_LNaPSS_TYPE_XFI:
+		lane->interface = PHY_INTERFACE_MODE_10GBASER;
+		break;
+	default:
+		lane->interface = PHY_INTERFACE_MODE_NA;
+	}
+}
+
+static struct phy *lynx_28g_xlate(struct device *dev,
+				  struct of_phandle_args *args)
+{
+	struct lynx_28g_priv *priv = dev_get_drvdata(dev);
+	int idx = args->args[0];
+
+	if (WARN_ON(idx >= LYNX_28G_NUM_LANE))
+		return ERR_PTR(-EINVAL);
+
+	return priv->lane[idx].phy;
+}
+
+static int lynx_28g_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy_provider *provider;
+	struct lynx_28g_priv *priv;
+	int i;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	priv->dev = &pdev->dev;
+
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	lynx_28g_pll_read_configuration(priv);
+
+	for (i = 0; i < LYNX_28G_NUM_LANE; i++) {
+		struct lynx_28g_lane *lane = &priv->lane[i];
+		struct phy *phy;
+
+		memset(lane, 0, sizeof(*lane));
+
+		phy = devm_phy_create(&pdev->dev, NULL, &lynx_28g_ops);
+		if (IS_ERR(phy))
+			return PTR_ERR(phy);
+
+		lane->priv = priv;
+		lane->phy = phy;
+		lane->id = i;
+		phy_set_drvdata(phy, lane);
+		lynx_28g_lane_read_configuration(lane);
+	}
+
+	dev_set_drvdata(dev, priv);
+
+	INIT_DELAYED_WORK(&priv->cdr_check, lynx_28g_cdr_lock_check);
+
+	queue_delayed_work(system_power_efficient_wq, &priv->cdr_check,
+			   msecs_to_jiffies(1000));
+
+	dev_set_drvdata(&pdev->dev, priv);
+	provider = devm_of_phy_provider_register(&pdev->dev, lynx_28g_xlate);
+
+	return PTR_ERR_OR_ZERO(provider);
+}
+
+static const struct of_device_id lynx_28g_of_match_table[] = {
+	{ .compatible = "fsl,lynx-28g" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, lynx_28g_of_match_table);
+
+static struct platform_driver lynx_28g_driver = {
+	.probe	= lynx_28g_probe,
+	.driver	= {
+		.name = "lynx-28g",
+		.of_match_table = lynx_28g_of_match_table,
+	},
+};
+module_platform_driver(lynx_28g_driver);
+
+MODULE_AUTHOR("Ioana Ciornei <ioana.ciornei@nxp.com>");
+MODULE_DESCRIPTION("Lynx 28G SerDes PHY driver for Layerscape SoCs");
+MODULE_LICENSE("GPL v2");
-- 
2.33.1

