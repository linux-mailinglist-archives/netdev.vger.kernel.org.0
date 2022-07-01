Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577495639E4
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbiGAT05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiGAT0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:34 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2120.outbound.protection.outlook.com [40.107.100.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B11443EB;
        Fri,  1 Jul 2022 12:26:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNBhkucqY2ipvV8N7s27a5WPwbTU+nGNcYI9fdvryIg8toagdPsT0ik40KUBV0ew7LMOfw6kmiixDFgHPKH310O723W4JSu8JiFGMlHd6KVj+CSS/AxJZj6paD1uV17aRaDW1DkqLc3LU98vH9MHTIRnxtTIizo2XzskAKV60VuJAylTyei0SV68N3mUXD0xqxj3eyRLBBGClCbMSiU7jmzhKjyLgMGSj3Md/MymKQj4Ga+aHp/L3whbqcgSANE6JFKZkHJmnYrtlU1oUowfKc1JbMeMiZUoQQm/Zsdzpg+cUg5QV04m8r0qWx/YQHw4cQEoDB5c2BiIPM83a4+pTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOcGSAkGUZLMtQI5ouwJ59oJTVFWTM6Cy9q248Qfxx8=;
 b=fs2eRRc26McHsPtA/9UROO/97Cf6TICaUjwox0/XwDGt9nPsy/J9tVjiFL3yQLZxvnX/ZnnU03w//+3QX8/55yTJilIOCRuE5i4UR9V/V1NkpmphCnot9gfWszR4E2LlizKymB5YjG/qbaQD7NaTRigHWzNpINGsTPlr1/cdKZurIn5VIAD3X9pG0kiZKRjnzMbt6wOeFk+2Vx+oH/QVZqanwT4aMw6wGQj/NjkTK2nokruNXpVOC3mDeI41zZXt9wX5Wgd+IUbK71qwUcrkdVBQKHkA0UHeJH1A2gktVglZgv2tEeUEcTkHklGvJQ57oRfvXZ/l28J8DOFxvWYoMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOcGSAkGUZLMtQI5ouwJ59oJTVFWTM6Cy9q248Qfxx8=;
 b=bubKyz58zKvgH9R4xCBxCqPvnXjRe4DM2Ba8C4R8y4H14lSasjLph8Egw9Uu+sdwARPYbFHiiarRzFEWwK6q11/fOofeH0pO6eiJ9m1gOUW/ApdDFu0nsuBqEiEVZlZWvIxVn1IjFnao5/+5B2Nb3wJi5VgE6vBflgehpEsyaWQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2230.namprd10.prod.outlook.com
 (2603:10b6:910:46::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 1 Jul
 2022 19:26:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 19:26:20 +0000
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
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: [PATCH v12 net-next 2/9] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Fri,  1 Jul 2022 12:26:02 -0700
Message-Id: <20220701192609.3970317-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220701192609.3970317-1-colin.foster@in-advantage.com>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1601CA0006.namprd16.prod.outlook.com
 (2603:10b6:300:da::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02eeb2a6-7620-4493-de2a-08da5b9793a0
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QY9TAonoMI57aifygxh663PCUwhW/O0hT9OreJ2hQESvnhy7ZVhZlbFDtOYyd+2unN1WdSfBXZBZweX2CGe3mU0LtYBcaeDiXLbPztxkFpXeDB+eaoA6rK/Sj2GI9xQXt3wotakyhVJkrSgDWoqv7hes71Zg0BuYMPRuzsGY3pIatEsojCS0DjxZJiB+vyoyPw/g1MUF105zcFp9K6GcfJU6sx4VyzNH274f+sXKo6uGxCgbTHRolWtp5fButX+7rmPZ0ocSqFjsmPp4wGjS0rBDX/0+53xJRgeqMY2JpqyHEcfPNxQsMgGhW2ksaUY3rWhJ3qLNoKot8sacLApzSh+bFo99z/ZmUpx0wTMCTcKz5c6qY1hWy759CSabwqp74yQYTsVlPHs8TJKneWiGISg1Fo/3eHs/JqvgoNP1AqQ8yy3CA3TnHvd8Y6bVOM000R9MQxb26wT+/5/PDZmwXnzVSANJjiEcFb4i06BkkKRctasQbA/vuyeDPASC3nbQ06FGOBhj4jGoVHmZ0ILYydEVBol2xkgbDfD4fLCufJ87Wvlw+GgTsB6r91l0dt0F3Mhv0MCz6eIjRIvzX6O/SKpa6mCQ/NSzQlt9/t3L3w5mg00Eb1euSO9YvRFgGeWFstMrkbf1KX6zqlngbOycDDe/VkrzSut46Yf705fZg2pX7nMU/DLy30hMNAWcTGhgITSj17jOlD1q9O6Yab8mpJV3EepIuuKg302VXYnneKUFLAifFXOuwEzbhjesBRe71xF6akQQCnls116bwzW4dj+ngociNPJwkMO5b7xid/HEumSBUlyDTRQWV4eQjsJa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39830400003)(376002)(136003)(396003)(66476007)(38350700002)(186003)(8676002)(8936002)(4326008)(86362001)(66946007)(1076003)(5660300002)(6666004)(38100700002)(107886003)(83380400001)(66556008)(7416002)(41300700001)(478600001)(316002)(36756003)(52116002)(44832011)(2906002)(6512007)(2616005)(6506007)(6486002)(26005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4tnNSElbuiF4KcJWrEqXK1Erex8/7VPVPiGfNKIKIC/qxGIIwHoYAbJSAzSi?=
 =?us-ascii?Q?vkJVlCGrgwigFkpoZcT7jdMOlmXhyYjFd/6rwmnMIEbTdlBPOy1CM6Pewyr1?=
 =?us-ascii?Q?W7RpUyXwbbzLVXI/jTWboaiDRS19zZHZt4D1qovl/jIMPQIZqATDQT1e8O/h?=
 =?us-ascii?Q?0FwU/fjS8KqNtvWXckJBfsF4RdGGSDI7+tLmAtkpcf6ZDuFIvbtg9fP4N7dS?=
 =?us-ascii?Q?lVvx0VHGxmHes1YAIimpdkZQznwN3tkFOg/yG/Fz1fOF7nLHQThkTVJdsnsn?=
 =?us-ascii?Q?W8BJId2dwmj0Humd43KwAA0GHO+3/E24pNxoAx0+Tuqgv3pQXbhFws3NrV8B?=
 =?us-ascii?Q?BCIWeTpZaAqIP367IWzrFc4p7nRz9udSE4OkZNExTDFd11fdazQA8fgx2M53?=
 =?us-ascii?Q?tXOZB64DCVUAf75N2jbqM9vWzKpj9R8fob1w2YEZfGHS2S17CNhlOJEBP5C/?=
 =?us-ascii?Q?Mfe/qg+9600ikkf56hLUtqNeruPfKMYzRvtghAxNERVOG3F1DmXygJUwcij4?=
 =?us-ascii?Q?pna48WA+a2NeHRDy2J41crqK+q3z99i2wHpNfMZ6kF/j3LLzy3JjrbINbjCM?=
 =?us-ascii?Q?SLnM5llGQD7SsXptD/7Y++JPfT6o//o61pi5qqauxAWtw9Bk34ApCWRJI83W?=
 =?us-ascii?Q?1ytw+bnsVGO5V5zYBEiMS/3cB/4toyL3PWv+UYRTB+FTCYOPzyf44M3S9rVR?=
 =?us-ascii?Q?ki1Cqhz/seSSXs/O7PAXhzHMcmyTn/citX/Bn/opznnb+eant6q6S9+FD4s3?=
 =?us-ascii?Q?PokhP7gM1uGtQjZNjEB+e7yr52fHuz0BKsDZoevdD1fKBNN5tcwygSAuqsE5?=
 =?us-ascii?Q?AedPc+R25Nx2RW6zygamL8SqyJv2y1AU1ZRw0gZMvdd3z6vNbTiBui+fFHuj?=
 =?us-ascii?Q?3U8VFyTFhpHJ2ZKMJSc+st06H4IPDoKBGHOXqQMFXB3btvNrr1r8Ai/ubFJI?=
 =?us-ascii?Q?sU2ALPxNSRVIPQIK/TpYnfAtBcDPMoEKBBAPAB+e8D8q4DE4zyA91ElBz7oX?=
 =?us-ascii?Q?gBpetiCzHTbVs21XgHggffBE+OJ1vtA3h6Cx9s5DEbJQ3LjNw734J5hRE1H7?=
 =?us-ascii?Q?ZbdtHeOv2BrcbQgRZVDBMadOKnDa8AJGvZHuTpMw3dT80nhdIRdJuGFW8lGH?=
 =?us-ascii?Q?QyTkiVIFd6TOUFiG/ZBOK3jbDmPuiU3Z+0YnkKfl6eXEE7PEJxf0LRXvVcHI?=
 =?us-ascii?Q?QcAP5HPDhscIQQs7PxDJkq24A96ijWJpQK9N6Mua/rpVMsN8tcI84G4rr+Gm?=
 =?us-ascii?Q?/xDvqdyONT+6FHQ0jPAoDOqLyGJI9g7KZi4WlhZd7eLXLTeqIh3MHfc2YDi7?=
 =?us-ascii?Q?MM7yT5KoxL+Xv30n1wtbRIWyfJaVuYqnkuhBG6r8vlcgZMY97+NoVLXCoKj9?=
 =?us-ascii?Q?jNiVBcEEvbhBB/NzTnmNcqbr1SOsVGP2jFKe24SGkFQMzk0ZCDiD6iRKHM0r?=
 =?us-ascii?Q?DyJegGF5aoJTr7kqVgpVC+Pgad5ZRfbEgg9qraLR3Np9Uywm+PcleuafMim3?=
 =?us-ascii?Q?lz3c4ue0wVaABl+M1PmVn5/f8WTLHxTtC3oj/xLp0OC1UbOZjWPM4ItBD3hv?=
 =?us-ascii?Q?GMZSFdj+TstlYPwxgy9aPxwdX/j07XAkl6c9SAHJwBE2QH+qHwcwLyIm7Lm9?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02eeb2a6-7620-4493-de2a-08da5b9793a0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 19:26:20.3204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0fRRjYzPAn7uamLqi3oG48ev0ixszY7kQldZndYgEKudM1MWHmTAaQXbkcCVEU2F4dAfWb36GtE3uqXFxF3mn5WtoifDjnpsWE0Zafx98sQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2230
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
 drivers/net/mdio/mdio-mscc-miim.c | 34 ++++++++-----------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 08541007b18a..c23a9fb5238c 100644
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
@@ -270,43 +271,26 @@ static int mscc_miim_clk_set(struct mii_bus *bus)
 
 static int mscc_miim_probe(struct platform_device *pdev)
 {
-	struct regmap *mii_regmap, *phy_regmap = NULL;
 	struct device_node *np = pdev->dev.of_node;
+	struct regmap *mii_regmap, *phy_regmap;
 	struct device *dev = &pdev->dev;
-	void __iomem *regs, *phy_regs;
 	struct mscc_miim_dev *miim;
-	struct resource *res;
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
+	mii_regmap = ocelot_regmap_from_resource(pdev, 0,
+						 &mscc_miim_regmap_config);
 	if (IS_ERR(mii_regmap)) {
 		dev_err(dev, "Unable to create MIIM regmap\n");
 		return PTR_ERR(mii_regmap);
 	}
 
 	/* This resource is optional */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res) {
-		phy_regs = devm_ioremap_resource(dev, res);
-		if (IS_ERR(phy_regs)) {
-			dev_err(dev, "Unable to map internal phy registers\n");
-			return PTR_ERR(phy_regs);
-		}
-
-		phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
-						   &mscc_miim_phy_regmap_config);
-		if (IS_ERR(phy_regmap)) {
-			dev_err(dev, "Unable to create phy register regmap\n");
-			return PTR_ERR(phy_regmap);
-		}
+	phy_regmap = ocelot_regmap_from_resource_optional(pdev, 1,
+						 &mscc_miim_phy_regmap_config);
+	if (IS_ERR(phy_regmap)) {
+		dev_err(dev, "Unable to create phy register regmap\n");
+		return PTR_ERR(phy_regmap);
 	}
 
 	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
-- 
2.25.1

