Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFDB4D3124
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiCIOjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbiCIOjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:39:22 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130073.outbound.protection.outlook.com [40.107.13.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0253512342A;
        Wed,  9 Mar 2022 06:38:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adOxkBnumYakr9J8unw0hbGLg/jJqbtimGTFYqlkIrR2qy4/hJ0nSd0M2qMf0PrRFa8laIHQcY8BNg75N05h63iXl9h05z5RBqO82rrAqh7HuJ2qRB6Rjfie1c7trFpsG1FbX+KxJRcT0I/MHRkBlAcEuyGsqRLQBKjvcEibAU29Igj2N2YNKZ36+WhGklgJPkvCg1FMPqFnLTFV6i6M+5tK5hJSJ+/CML8nh7Rlj93fu75JAX+pF+JInLvl82Rcf+MDunBjSdckzbL5frktHzj6Gv3saQu6M5FvzOypCpt7REEHE7453Os8CgxbxTKTx62Dtj5Tg+IyISEQqIT3XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GwNiG1olYgW/Ki2/dhWCLHUxbzFv+rw24W7B7k76T1k=;
 b=Yy2tVIXSj4GBVbtAzZLZAT2bb7n/JoI1TEBmhqWNg8C/6L7FdEL0iIWcPKfhGZfvkevDYGTHW4WgdbgWAms11MiM1or2UbkxBMaNUdFaornfo1EoimGZmT7XQtBC7CfPENb1FOS4adf543O8/VmYaWym7jA1Gk8glFbhy0vvp+gQiC2yGR2BH+60mtPEJZ1oTOBsTI0bnU673JE/1wgSDsa32Goj/fhq01wZmdj/7rEZf6d54ATZbUjjkHDF/MV4UvKGyKZnLKzapAljBjRE61pV3PHsOMHJs+3aN5DaqlBTFGY4gvo1405dzFhsrQzz0ENuuslxgdIbbUdsdpQmDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwNiG1olYgW/Ki2/dhWCLHUxbzFv+rw24W7B7k76T1k=;
 b=PyOX9OMQgGQZhfmRDrMQgAPJmHP7+1MNdBcpfIhcIoxzJXPiHok3EiHOWtjeTptA1qlJ9G1Il8/WL8xxjrX3MXBarosZRBPcTsBFeCvIk+pHtL4nhgQ1TtXiZlSi62zk5LrYlfE8LcbazCyyK62gW3zbS4b3mUAiEPNPRkilv3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB6223.eurprd04.prod.outlook.com (2603:10a6:803:fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 14:38:18 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 14:38:18 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/8] phy: add support for the Layerscape SerDes 28G
Date:   Wed,  9 Mar 2022 16:37:44 +0200
Message-Id: <20220309143751.3362678-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
References: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0187.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43c686c0-d37f-4155-bf26-08da01da7387
X-MS-TrafficTypeDiagnostic: VI1PR04MB6223:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB62235623F3127EC8165D2F43E00A9@VI1PR04MB6223.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Opvl/nW2VfGc2ph/CxVx9+15zVG/Feybeds+KdhfwiMKb5bzoQsAMhIjCprW5ilqr7HMgtobji/N7zTr91G9RXAidTD5mTVp9hiHWaEE0vM3SbXoloEvGFkEpIXnw4kWNMO1DreYXskKC6VtzsZUC5RBwlBYqXrbQut78/5DkoyO7/8M+pjDeGUxMsuKydXUY0lfdfwhpEatnGtMWMHU3LpTIBbzker86FV5LLBcARAansAQdl5pSBCGcqK/mATpDJH944w0rWfHncIWljb5qjdlDWFW4INXaXMN+PgoT1iFElUmyLJl6Yq+hxSfpXggyrgYDOAy5UKA4mkUEBIWJJJYUwsbji5CxiDriLtqeYGpIC+l/+VwUuEe93RanCGTo5VOLBuq9G3wVKH60f4pIzEXDnAV0aXA2oSCVdmCoJ/112La6Sp0fNArm9JGr0fYCnV//+fUvaF65NGcFr6SZDAouLRm5h2YvBYZOfXeBYxtr1vkTOEzb0CuZTh8eYTuVZUStgqeKPfyQ4F+P2GY3dVKI0zft5SkErcEe8XvkeU0jqeWLhoSVrV7JjY5AEkLyphU3bCa/2Dr575gLD9rDUCGpBhzFEWoxBL0LpC3cgx5lmrUfrOTbr+eKikmxCznMtntEALJq5qDSj6wXz3aluB4CJ/5rzBRfetuQVrBu0eQXFktCnMRnucpr4xz7BAOFoQ4kSi3KBIQpE8tvJTZE3zc2JK7bIqsyHulsLDE9ytayi85rCSPv6/RN6uc20rsConMnilNUCw4tk/wJs9+BXzqlivHVbq5XQk+1q8TtqA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6512007)(86362001)(44832011)(52116002)(36756003)(66476007)(66556008)(8936002)(66946007)(8676002)(26005)(5660300002)(498600001)(30864003)(2906002)(4326008)(6666004)(83380400001)(38350700002)(38100700002)(6486002)(966005)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y52h3Ddlzzl9ANREVGTYXf9/olD3QaRCYbdy90RjrMxSxGD4kTmDj8eUmZju?=
 =?us-ascii?Q?9+ZHE+XBWVRPsDg3xjFzVECkxIMQ8LKmW3u6niqyRVXHVFXrAiqX2+HJ2TUu?=
 =?us-ascii?Q?dd6UNjNi89zcMDoXeCpYQ/qUFTiImtrlCRAwLsJi/AvQ40y4u/yHYi4ceYK8?=
 =?us-ascii?Q?S3mvfcLPkU1eKLg26awh2perjNlXMu8NeBjaNtfSPjJn1Ed72ObS2ibeiNQH?=
 =?us-ascii?Q?BgpQTuv5tYxxJfu03I9KucWGxVxfEq7VkwZev90g1IwlCbmmF8hSIteZeD5h?=
 =?us-ascii?Q?hcnAAlIyEgF/PqjjZsntd9bz3c4+uzNLUXYrPqAqKIjyAig0XLnHPxfgM39M?=
 =?us-ascii?Q?zMuZdhq/o73J+TgEON5nXAeWHFlHdMnsPBzIl2s3Nc8OfX0aYQ4WeEqDI/Gv?=
 =?us-ascii?Q?Bl5q60f7/vy85CVoq26hLSRs/1BKqth5gmwK8AsFHVjDI3V+XM0nYXZpnvYx?=
 =?us-ascii?Q?hpan5Bh1VBno+F1YSIdczrTiFfnNbn1MTkDUEIOn5QFQRNjBPX5MlmSGsz+Q?=
 =?us-ascii?Q?rP/WsxLF2cw/84iY6WZUNnRPpz2PnBLwdRAtSmdM5pMLwmGWSIC1zzmG45Dn?=
 =?us-ascii?Q?5feVY0dPcFEyIFLkuiUhYT7lbGbZhlGIkA0L+2wX1JFeBMqw6DhDU5jv5urt?=
 =?us-ascii?Q?XkVOTRS9F3Etdnghkd7N/wZvYfk+pSs8G2oJv6z68AtcQ8qsTwtd9zHzMFgN?=
 =?us-ascii?Q?8OqM212K85DXFioPKCLHZDHtwynH+SuH4Jf7qF8QqlzOx+OAOyNwWGLu4/9p?=
 =?us-ascii?Q?hi6xgQjUmCXYdr5fxVgmuxpjxk6/1/4qkT7/InbyPRvNLSbwgAaMu4KMQI4T?=
 =?us-ascii?Q?5UzZCs6UR38iDMSZaGF3okJe3OtHdHLiUM37jQce0Bc41vvEEe+SuMfz6/5O?=
 =?us-ascii?Q?GIXLAWwyzm+ljWcn1/6KZVw1DhOzrgb5zSkbFu0AUL+gLXO9TRF8ev//DajJ?=
 =?us-ascii?Q?lrvTy+Ae8T+i+DJcufFWH8OPoNO0mD4qrcice2Wr1TboxWPKcviS0Czx4uKd?=
 =?us-ascii?Q?yjQfEdGMM+D0oKuBUsW4fOD5WjaHKgdOdH8rV+e6kDrboTqz+JfL4kW4CL9J?=
 =?us-ascii?Q?CMiUZlceOkZxHQHpd8E4LqVJViZ0ATHN3ySQG4rXUkQHqZi36fD/UD2qzK2/?=
 =?us-ascii?Q?gBzKyle+Y9TwvHkdBnJKILLafdYnYOxSjJfHmFd6ufV/OSrC0egMcfX7etVS?=
 =?us-ascii?Q?fjOWceqoU2fxirirNkE4RlfqCq12KlynAYi5O7ebUjhlA4ZjD2yP9cPhXphQ?=
 =?us-ascii?Q?thokPGHyIZGB18qa79CESs4mlwsd0O1x1W48umZSa8MREZQnme2quUvh0yOR?=
 =?us-ascii?Q?XNG8mJBBd0XeGYXLsdK4w7LA8HQz4OO5gGi4neqfruAZkh7mmTkUy31NpN71?=
 =?us-ascii?Q?kO81plWzLp4QwrPwXN7ovykGqo7A/ueHYexkW+9aFTDbOumCF6mtbYsnBGKh?=
 =?us-ascii?Q?8MjjQepsAkVrx0ky3InxKDUhnTkR/seMiEwEz5SGTMX4WUDaxkA7n5YWZVIi?=
 =?us-ascii?Q?ukdDk2iD2Y4vgh+TibC/L70A++zP9sivJLadr1EOm5zHzhKCTqkbwv9j+vm0?=
 =?us-ascii?Q?UANVqb6Iq6fChgsSLTYrMUsdbjV2N/J9U8nI89ZUKqqkXI5WdZKlR6o0fYGp?=
 =?us-ascii?Q?6sv+MWOGqdHqHot1rHXMeL4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c686c0-d37f-4155-bf26-08da01da7387
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 14:38:18.3351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z92YS5NRGl2BnTBOaB9AAl8tpYVjhhPnJn0bg+0NfUiCKhT6X2ts69pL4PciN3qcsuBuyvYwuXeenS/NET1cBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6223
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
 MAINTAINERS                              |   6 +
 drivers/phy/freescale/Kconfig            |  10 +
 drivers/phy/freescale/Makefile           |   1 +
 drivers/phy/freescale/phy-fsl-lynx-28g.c | 629 +++++++++++++++++++++++
 4 files changed, 646 insertions(+)
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-28g.c

diff --git a/MAINTAINERS b/MAINTAINERS
index cb75c5d6d78b..dd42305b050c 100644
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
index 000000000000..87350989a2b5
--- /dev/null
+++ b/drivers/phy/freescale/phy-fsl-lynx-28g.c
@@ -0,0 +1,629 @@
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
+
+	int num_lanes;
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
+	for (i = 0; i < priv->num_lanes; i++) {
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
+static int lynx_28g_probe(struct platform_device *pdev)
+{
+	struct phy_provider *provider;
+	struct lynx_28g_priv *priv;
+	struct device_node *child;
+	int err, i = 0;
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
+	for_each_available_child_of_node(pdev->dev.of_node, child) {
+		struct lynx_28g_lane *lane;
+		struct phy *phy;
+		u32 val;
+
+		err = of_property_read_u32(child, "reg", &val);
+		if (err < 0) {
+			dev_err(&pdev->dev, "missing 'reg' property (%d)\n", err);
+			continue;
+		}
+
+		if (val >= LYNX_28G_NUM_LANE) {
+			dev_err(&pdev->dev, "invalid 'reg' property\n");
+			continue;
+		}
+
+		lane = &priv->lane[i];
+		memset(lane, 0, sizeof(*lane));
+
+		phy = devm_phy_create(&pdev->dev, child, &lynx_28g_ops);
+		if (IS_ERR(phy)) {
+			of_node_put(child);
+			return PTR_ERR(phy);
+		}
+
+		lane->priv = priv;
+		lane->id = val;
+		phy_set_drvdata(phy, lane);
+		i++;
+
+		lynx_28g_lane_read_configuration(lane);
+	}
+
+	priv->num_lanes = i;
+
+	INIT_DELAYED_WORK(&priv->cdr_check, lynx_28g_cdr_lock_check);
+
+	queue_delayed_work(system_power_efficient_wq, &priv->cdr_check,
+			   msecs_to_jiffies(1000));
+
+	dev_set_drvdata(&pdev->dev, priv);
+	provider = devm_of_phy_provider_register(&pdev->dev,
+						 of_phy_simple_xlate);
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
-- 
2.33.1

