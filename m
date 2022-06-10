Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AEF546E56
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350731AbiFJUZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350706AbiFJUYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:24:30 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E66530A45A;
        Fri, 10 Jun 2022 13:23:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoYFdk/O9ccSoTWM3FxoxS6xji+zXKF+F4GJzEc+FaXXeAf+ZdL2TNAdUO554QPXOKU8rL1Bhc3R8Hk20y6+GCLpL/O08s0JNRraF+fYoDK0sXEQhkuOBMAx6hUR4ZlAtpSIz/ZLSb1a8GZwnFC2x1PsQ7y70mHD8RTltgZ4XhJspusYUKjl1Rw0g8U7mvxNL5Bl2Zzm4/T739TU2dfi6hqK7fYhIF+KuxmWic1RRunhRe2QPItlP6lUMZ1nMcaq5v24cC/Lv0Qc1/G2mZmDKo3k59+d3uIOZw8ZwMELFs+FRQopZvz/aQQBVjLktZ00s77MjOLmG57nmIGFXQTVXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1S5ylTNgu22/DjmUQDnVJgFf9sfgio6PxASxNsJ2J0=;
 b=hy/FxnalC8W6RhJ8gwhmBORDX0/Gc5JewGWUhyzbqB7B+rVjqiw/tyfL9xkUN9tgq/p/VhYSrvEJAJ/ampkXk8GQatHRfRQXhSDyVyIofYpS8ceM51/qF32EO6GdnZFY6SudNx1tlyI6x/TGiKxYby787dSLYQ6TNkax0bQ4jQ0tPl+PYFwsB/0esVyCy1qZor2uplQgvPmmq7sJF8i0Gx7IqZaRrFSFUkjQXaZX5fALKfwTVol3TWNa7g3wB/5oq5/tXjSEa9NlY0r9Yvv+jMJJwR1q+dUJs3RyZnE0vWTb+nRHQeyR8gPZnERt/kBvlqCwyrrEcMZWhL1p/ITXUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1S5ylTNgu22/DjmUQDnVJgFf9sfgio6PxASxNsJ2J0=;
 b=jiqmnOtn1ImxosllMdIg5f3wb7h151xOYUG9K6JFfmJObBAmzYKP9NYJ1sYucWcq/11OcZY8kenUYGljP5jmovFOzjBW/g5nCSFXqCFGYZ1Ffv8FkQSeWA3Pjj5jD0L8Fb+XsEa+vbfjlN1tyXpAYy5NW+PM1TcFVCYWX5NTIls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1629.namprd10.prod.outlook.com
 (2603:10b6:301:9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 20:23:46 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 20:23:46 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v10 net-next 2/7] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Fri, 10 Jun 2022 13:23:25 -0700
Message-Id: <20220610202330.799510-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610202330.799510-1-colin.foster@in-advantage.com>
References: <20220610202330.799510-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0246.namprd04.prod.outlook.com
 (2603:10b6:303:88::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89e10663-40fa-4d98-80fa-08da4b1f1f1e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1629:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB162986BEC3A4F88B71B13A98A4A69@MWHPR10MB1629.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YhGCsM40uNuRfDJiOLdyHKzgOSNaiV2ImclJTblFEcIIS5HWiWVO7Z1w4+FnA+QfY+av6CF4yTywOZI188QzZHznaLEimK0mqokmDFC3zuOb/Tme7hz9DJSoQdvH3kaL8oMZeBw+z+8hwy1xwcGVS0dlEYt2O0tBdwNzp+TPRgbioSl3kn9rbbjq8zGosCK206pq+5pcj51h2hVVa7Kr8DyB8SIgP7mh63PLuGGsjcubQQO+gbVjC981UkYWukErgoYxiDAocgrGk9NjfgyVZt2xGreSRiAe1DuYhG2zGir6kECCQXZ2NVzTphVvZhMw+i2fHqVH1p81Ij0CDudjZWYdPEIGOtFKgs8VlKcEuxEc6C2D+HIfTod+7dHRh0xCiRqzPaB5yBfuuZucALchx+iwPAB4i9VIOP1R8KGKLze/eRtOJ5vqwxjMSHSwSeFCgoDGN0iqaYFznFl8gEe+FMZYFffl05yJ2Ru5UKOMp2Hzvwug+kjM1odZZ6Yo0R+4djhh28Y55xswZiQfJpAg3Tahv++0zqDiBpS3cwT0rVByPKqE1u8W1exK9i2G51or4vt4W9zsAnMQwJLV5LP394dt/xoG3jH9BUHEd6KRahm0lQm9cX45Di9rTxd2PXOq5pxb9D5N3PxG4dzrlWbQYlndo6MK0ldc3djMb3BD3rnxLV1l2xarFNcb5Em1mvMoZCysgXoHRyT+Bj8a1nBP/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39830400003)(396003)(366004)(346002)(316002)(83380400001)(2616005)(2906002)(1076003)(6486002)(54906003)(8936002)(36756003)(6666004)(52116002)(6512007)(6506007)(26005)(186003)(41300700001)(86362001)(44832011)(66556008)(66476007)(38100700002)(38350700002)(5660300002)(4326008)(7416002)(8676002)(508600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZQ4x9L0yROMU0cC0yGq0dE4gHB0UNMLAWjD4tUIr3nXULlXJdyqGtRrzSqP2?=
 =?us-ascii?Q?5wJN8PspVupsaEvTAydxuYXUhFqCWskvqfnqAuMP9rZoJplqeCJygIkscxIA?=
 =?us-ascii?Q?UrWk08u9T9cw+jDg7wGS1IaMReAIS3UpGZRBgybP1OwoCxCQSlLKsXEI+XKD?=
 =?us-ascii?Q?o1tHKeCJ/+2lWgVDxjcLXDOM7XfAvB9ZqsRJHXtiAuT0oUdFy7nNjzPqhz41?=
 =?us-ascii?Q?9TSquxbjsBrGotW2G7gyiQ0LBOavSjY2eykjZ7TUvNptUoZZkBjtLwgxZ+Rg?=
 =?us-ascii?Q?8xAvesz3HrhHD1LBd6WE7crxQODTOVBZDBbq7jCUUxY+7/yXmuYwFaQU9TwJ?=
 =?us-ascii?Q?kSo/tsUC4i/a6HnXdrqWJ/Xjk54GUaoJvHvmJul1RbDW38TB2RqzvKRck+PI?=
 =?us-ascii?Q?jnJBrrWe7/bcbGWS2bCRWOYuFHM9fBBwEAtTM6piKJeeJ3gCPfrGNNIdaPkU?=
 =?us-ascii?Q?Pv9bQXjS30jfYkait7f2jHOAEkVFDSOFM8ZnQEaxq661ni/ZVI3bsg5HHO/u?=
 =?us-ascii?Q?voYSgg0h9FE9EXP+mVRpm5wXPywyjFXRSuXBIn84jWkPpNmE2u+cDyxReQRJ?=
 =?us-ascii?Q?SJiC3J1o3cIrz3o90rVh3ciC9gR9SdIxWoTFaqxlY7AmNrckeHlrtnon4INe?=
 =?us-ascii?Q?ytRQ1vTAEM9A4jYkz1L1RqaKe28CystmwAmTbc+H8x8inrPteBfjt/IWNuA3?=
 =?us-ascii?Q?cgfnWldsI7x0mG79szGAP1DTleNjVGhWTFEiTpKY6NA+fxI8xmBSum2iHHLC?=
 =?us-ascii?Q?ne1pStjrbpWfI2CAH1e3I/UG3zyVibWnLxQSoVoLYHWa+vbE6f+G6GW5zTZn?=
 =?us-ascii?Q?lijqhHVMWsjdRBgiwxcX0f85aeY8vq657HkUWRSdbA+/E4TbC/eN4qftOYAW?=
 =?us-ascii?Q?KAdNM73yKLz/l48ikWjuAbmwuHbnXzS9kJRwlnXvmtavHRiXk5/yXlCpHaYP?=
 =?us-ascii?Q?19Drr+jSP10Ep/Ttfy1+atWDoqM0K1mSFPrh3VR9O4K/Q18DN4UlO+/+fLkg?=
 =?us-ascii?Q?Di8MpotIo/kOUKr20uv0TyG23OwwcESm224O/n/rYyKSQzg4n9WopDtP6P2w?=
 =?us-ascii?Q?xIBGicJqJnS4BHwLTK5a49kknVqddJWqnVW23eZ47Ne/JksOpmk5JjM6/1jt?=
 =?us-ascii?Q?aDGCT0zs3e4tq4e3naUXSDvkeli+u4VxAwg91bdc1nmDQIB4fV8Vaie1b0sO?=
 =?us-ascii?Q?FqDwjCpYuSt7mQzQll1VF354wD1FK4h2GQtDatkCqlujek0UiFsGB4+oh+6p?=
 =?us-ascii?Q?+Ogvr4lJ6HtrBPh2IRCBiwx0OLbJVby1fgZH4NCpKKLsP4SVwd2R1yhOvryO?=
 =?us-ascii?Q?5kq3HY+X3NA8i+TYfKmos9FgIeBsJ24koz7JUcp1onc6FHD/+3tEho6tezdZ?=
 =?us-ascii?Q?mdwyNR6Gj6GtTThoQwtr4z+EXe2CqMp27zwLNnZnRmW3xla3J0SFpYFu5gkU?=
 =?us-ascii?Q?GMtaypfhu5bE102Yfhy5dXyhc3V0kzvK7CyjhjuzyRpALOwIBMOxAtLXs/FI?=
 =?us-ascii?Q?tEvaNh4g0i/BZaLq7Sj/ZvjFADf/NuxRPBHVIZW+TwguhZ4Osnrlv7gnTPx5?=
 =?us-ascii?Q?UpNI2xq8/zC16h4xdcP1FUEjF24HjMVOZTwpNCkXtbzrwoAYKNaxYypkFG1T?=
 =?us-ascii?Q?EBWqWghqCKh5Jq5faGyMe51XRoe048LDmqMhbctv4VXr/gNyqSxpUCGYWyjb?=
 =?us-ascii?Q?pKEdcPp3HCWjOAwePBD+wtllZBJDbGqllcHK54obOD5WSz4rHQ8tJp9hGczK?=
 =?us-ascii?Q?9y+SiDb0PxCaL9ohoycq+VgvG6uhoJTUBT836hhfYS/ii6CzBjLG?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e10663-40fa-4d98-80fa-08da4b1f1f1e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 20:23:46.6383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4TgNi6axHUkrTbxqr1TPBgFfPePk4RbE3tV4+Ymv213kNavdHpIrbf3DmmTrJ1NK4MgQPdDV29LBvlvlC0YVLF2dKIz2AYV5z4/101IeWv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1629
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that contain the logic for this bus, but are
controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 27 ++++++++-------------------
 include/linux/mfd/ocelot.h        |  2 +-
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 08541007b18a..cd89a313cf82 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -12,6 +12,7 @@
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/mdio/mdio-mscc-miim.h>
+#include <linux/mfd/ocelot.h>
 #include <linux/module.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
@@ -270,43 +271,31 @@ static int mscc_miim_clk_set(struct mii_bus *bus)
 
 static int mscc_miim_probe(struct platform_device *pdev)
 {
-	struct regmap *mii_regmap, *phy_regmap = NULL;
 	struct device_node *np = pdev->dev.of_node;
+	struct regmap *mii_regmap, *phy_regmap;
 	struct device *dev = &pdev->dev;
-	void __iomem *regs, *phy_regs;
 	struct mscc_miim_dev *miim;
 	struct resource *res;
 	struct mii_bus *bus;
 	int ret;
 
-	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-	if (IS_ERR(regs)) {
-		dev_err(dev, "Unable to map MIIM registers\n");
-		return PTR_ERR(regs);
-	}
-
-	mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
-
+	ocelot_platform_init_regmap_from_resource(pdev, 0, &mii_regmap, NULL,
+						  &mscc_miim_regmap_config);
 	if (IS_ERR(mii_regmap)) {
 		dev_err(dev, "Unable to create MIIM regmap\n");
 		return PTR_ERR(mii_regmap);
 	}
 
 	/* This resource is optional */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	ocelot_platform_init_regmap_from_resource(pdev, 1, &phy_regmap, &res,
+						  &mscc_miim_phy_regmap_config);
 	if (res) {
-		phy_regs = devm_ioremap_resource(dev, res);
-		if (IS_ERR(phy_regs)) {
-			dev_err(dev, "Unable to map internal phy registers\n");
-			return PTR_ERR(phy_regs);
-		}
-
-		phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
-						   &mscc_miim_phy_regmap_config);
 		if (IS_ERR(phy_regmap)) {
 			dev_err(dev, "Unable to create phy register regmap\n");
 			return PTR_ERR(phy_regmap);
 		}
+	} else {
+		phy_regmap = NULL;
 	}
 
 	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
index 40e775f1143f..effa4cc0fc43 100644
--- a/include/linux/mfd/ocelot.h
+++ b/include/linux/mfd/ocelot.h
@@ -10,7 +10,7 @@ ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
 					  unsigned int index,
 					  struct regmap **map,
 					  struct resource **res,
-					  const struct regmap_config *config);
+					  const struct regmap_config *config)
 {
 	u32 __iomem *regs =
 		devm_platform_get_and_ioremap_resource(pdev, index, res);
-- 
2.25.1

