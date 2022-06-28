Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0359155CF14
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244974AbiF1ITu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243943AbiF1IS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:57 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A384FB64;
        Tue, 28 Jun 2022 01:17:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZaD4LLei/0y/cpvKANnrTnF9rH+ACl3XgnCbDCxgC4HkCr9OxsbIldOc4Za10qUAOCcs5KtyML5Q15fWI2CVybNF1NGUi+fnHWBX1uMDo2w+KnNC+7LdyK3sbn2ZQC6otT23RVobybdAQAR9pHadIdm/a8FmRwHpAZkMjiKqRRbZWFOejC4MKs80wRn69crdlh3KvgLEB3eQhYQFQzAluff6QUZLjWIpgvqOAkR4iNYGhnc46O44eRA/zSdzXC4g4zaQTwM1wnf0K70l9O2xKeG4qX1Ms58udp/vQL6VkLNOcHHevf2Bvtd3tYBGMYHpvSKsQh7+tdOGRW8b0wI1Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHD7icKesZTmeejaNQRsR0ROYggUF+B8IFljBCWZSok=;
 b=Nw/6QEL2i15EzHYuZ871TwCKqXyXPuRg8Riokz4Y+GS+xsHpZR5a3ipsfw7NjhNQK6RFvGYbdMAOiTT0alzZIZ2GEfEOKcqRLAjFckMyF8C0Ub3kAscRqYMXe5+VW+ug2ZQfOBZeA51WD9VUr0B+XWg2GQU4yTFQA6tMmWsqTHsQXF0IyABLp0S++zuctzoaOxpRJuanrQ/YAQHjowkHRuL19g70tEXY9DZs6oEmc6FjQNNiH9tsOmk4oPloLo5huy96Qzd6g27blXR11NbGzqtTqri2ICmlwhBaw8rizO9sGDM3/RYQnt+mS+uKsy78+RfgGwvroow516S5PrvLvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHD7icKesZTmeejaNQRsR0ROYggUF+B8IFljBCWZSok=;
 b=JnunMKZJpsX62fpaEpU+gr7zAYyYRc8VLPACyqlab/SSQbDG3c7uPR8jIoGdjQqD2LULqAiGhVvlf9knBT+gFhSjmzRhnnZH8+33Ae2q0dSTp4xhtGBUBh/u40d4l06lP9biMNViKDjktkeDZ30nSTqvI/bxOM06bdiIhGk3D20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 08:17:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 08:17:27 +0000
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
Subject: [PATCH v11 net-next 2/9] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Tue, 28 Jun 2022 01:17:02 -0700
Message-Id: <20220628081709.829811-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628081709.829811-1-colin.foster@in-advantage.com>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e443d807-66c2-4454-d0e6-08da58dea2e2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wklP25KU0GrKjXSiVwtmjnOWm148uVMY5gcbYZ+sd4i2EifjSc5L9zXuq8V/LRybCV9RZGiYZDfFqqsuIDQAS4dp54hFPcNYoPi+Etx9sjugFO17SlkbsEklqc8+nLm4NjLqnnkfWalx4xOmclqjOAIsu/2y0PWE7ENuuHWkOBj2ZRJw4uuxzGd8LbyY43pg4yMZVAP8cXW3CaQl4SDWryj47qocodYx0lZmjrWbr/Ik1n8Mua0F3ExRGCNyu2rkQF5y95pRidS1/b6FvQqcTK8F89r8PGTCi0uCuhTxvvrEPXl0TEEj/hh6D+PAkcsQmxPsiteE2z5BcUkAWQO1ZHvfvPezLynEsF7vu8m/Tmg6YENMdShB8YpEN14gVl+uWz9SGQ2SXSXlB+QyBgU/Xg/4aNIiKhrmy3pRCNXPWQDxOftClEVvfDxWY72/wuOVwJ2paalzeVtqIc+6EBcnUoVhb8ZAoamUNSDW3P7AVwjO5NXcVuFv4DIFiaInPa3o4Neph2v9rX970Mg5MC/+R5IANd4QBEYgewqr8grK7jQSQ/al54nR3BqpyLdXoLxh4qzzEVPbW9ZM9j4LS4UkAeWZWbBRFS17NBXfeYfJQmbBuGoH7zM+waiSSejFZyNn2vJC71fbBZ4nJCBlUim1XWfqFb+lezz9Vk8lEP3IoCbifJw2jlp8Yjb2CXmEi2mcdWFYAdzBtxy7NC4MqdDEVkg3Ih/beDWYNA/gCOv8K3XkaOOp4g+Gg+kKQDCU22GA1eNl9vfApbMHvNJNvy+wIRLQepvf0HizTRIf2qEUJnA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39840400004)(376002)(136003)(36756003)(38100700002)(6512007)(6666004)(41300700001)(38350700002)(44832011)(478600001)(8676002)(4326008)(2616005)(66946007)(66556008)(66476007)(6506007)(2906002)(54906003)(86362001)(1076003)(6486002)(8936002)(186003)(5660300002)(7416002)(316002)(83380400001)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dn9odIACSp/y4Eo+7ImUkSNopd6Tjg+88HMkd3BxUyD6iQQd8CMZP1nc7bpw?=
 =?us-ascii?Q?/s43Gwrd1mDCO6gRp33i+eTOmb2dVjWc6GOAwRtSkerbr1LAO58pJtn2UXJg?=
 =?us-ascii?Q?Tl54fOp/MVLCmvpl39f8vlC1F9lCMy8+5Yz1id/jrZDD7wVp2dik2zz5Qax3?=
 =?us-ascii?Q?seFbzbDHPY/7WapF/LZRByXqkiKzQx/2f/Dy9m60IMQPS9D9lLb1UrYaRgLv?=
 =?us-ascii?Q?vwKCTwQSrG0TQL3bAtlTux/6QPNbdOB1wwcBJdWwvVWJEQgFnaN0cO9Rdl1l?=
 =?us-ascii?Q?/MSNdlm60dK3HNhYGl+sThfbD49gxdY6Dn4Af7wYrpL2txzgfLXeHVbjXgIl?=
 =?us-ascii?Q?a0j0mhEjFXt6bbfTpOLEYK/NUzvNCWtf/qepjjWBF0SoYePjEW1krJMqoyo6?=
 =?us-ascii?Q?Jp73i7zIDriI19LBLIoaTq22b1ko0pppdMAUmzjzZs64L5w2LTc7vHOprt2x?=
 =?us-ascii?Q?JH4oJ7OYyuh3J9vmR870gg77TB8iHeJCdNPPLzXkKJ26dwT+rBb7xiok7r0C?=
 =?us-ascii?Q?l03Mgsf+SxRgiky5hHotBDPpl4Pc0J9xeL976DCZQVDNaTn4+oCWngQ7LCha?=
 =?us-ascii?Q?h0pQjpNu4FvZ0lYQHSR6fGnWgtA1VN4ppSdbOytol/PiBlPfLHTr7n2pPVUs?=
 =?us-ascii?Q?hJyoq2yXjsETveensP6MYk/N6Iphes5RPFc6wwjvXlzcEVCTQO3zQXzeG000?=
 =?us-ascii?Q?sjJp7Mh6/vqqF4rL+RbARXSQygDJLXcKRmt3ldlmchnj5h80+AZz0YKxyO9J?=
 =?us-ascii?Q?zBLo0lFdelThnMQV4VMzOdprRYNLypFNzhhPziX+roFpcbED4H1WeLb4Xb/K?=
 =?us-ascii?Q?a+n9tF08cAo0W1qUh9eAemlDu0Bi0yevrWRu9O+RGuQFpZl0Q6n6nG0QDY/d?=
 =?us-ascii?Q?K0HLWhoks+z+1GQw5zbJFCNuiQZxYC83d13iPuHVO+j9yTUD00B9ASY1V0zt?=
 =?us-ascii?Q?Kl3m8k2FCORmVYQH7eazWmamNZ/c0j5ZvhBA/d51jVni0L+0bIrsesQ16xPu?=
 =?us-ascii?Q?/yjhEGxhQCmog1iFBnatUpUanmuOL7XBMdtu8gOYyci1izMJc0+lY6NomITP?=
 =?us-ascii?Q?esWnfYoWQ0pd7UY0myJhiFYYVbnuklOPWZR3SPL2h0kJcB8AD+kGYaTxdRL4?=
 =?us-ascii?Q?WjZMmOT+ihLX2CSKK8XBsIzFHcaP9PBrZO7/lamuJazl90VCpvIegfLE06Ig?=
 =?us-ascii?Q?wqoEMDrre1mioCR/zLIU5O9QOAnXJU368u6OYYt6hl1tohm4/+1TmI3C+sSE?=
 =?us-ascii?Q?uVUC1HbJqzhDa52rF1qVLxQFKPn61shdz7SiDuR13mUf/Veo3dThpwPcBoIP?=
 =?us-ascii?Q?4xGYmhi628h+kZ2thKgx9b814rpB163JJRDsvwg0eY0mLUYIdpEGg01hOvo8?=
 =?us-ascii?Q?Txy5XWKPist/nr55SkGpPlvDbRO9MNUsVJ2BSn2Z1BbLTwlW6iZ05qIrfIB/?=
 =?us-ascii?Q?PV+IK0yflAa8AvF9JQtpvJsDK4bItcp16ugb9qGhuBYkJLewVgW8fe9s43DZ?=
 =?us-ascii?Q?1TeQaJGdw7sbs4HMmCdjDuYYDAlrM2kw+zi1bB45sIhITVu6by1yN9fy3hh0?=
 =?us-ascii?Q?Fvr+rtxtd2IePE6awhJY0V+lEDTCgoh38qd32YqIQlqJYWv9sYgVsMvSNRwQ?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e443d807-66c2-4454-d0e6-08da58dea2e2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 08:17:26.6978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRejwLOtKKaWgRl4Jc5L3cEr4d2WGbjPyOkIGL0LJFn4c6W9LhFk1SGlaHFIiuOkZAx4/5+Pz4BXf98Ievxz2t/+DuCF9dI1yPL1nVqt68k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
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
 drivers/net/mdio/mdio-mscc-miim.c | 35 +++++++++++--------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 08541007b18a..157c0b196eab 100644
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
@@ -270,40 +271,27 @@ static int mscc_miim_clk_set(struct mii_bus *bus)
 
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
+	mii_regmap = ocelot_platform_init_regmap_from_resource(pdev, 0,
+						  &mscc_miim_regmap_config);
 	if (IS_ERR(mii_regmap)) {
 		dev_err(dev, "Unable to create MIIM regmap\n");
 		return PTR_ERR(mii_regmap);
 	}
 
-	/* This resource is optional */
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
+	/* This resource is optional, so ENOENT can be ignored */
+	phy_regmap = ocelot_platform_init_regmap_from_resource(pdev, 1,
+						  &mscc_miim_phy_regmap_config);
+	if (IS_ERR(phy_regmap)) {
+		if (phy_regmap == ERR_PTR(-ENOENT)) {
+			phy_regmap = NULL;
+		} else {
 			dev_err(dev, "Unable to create phy register regmap\n");
 			return PTR_ERR(phy_regmap);
 		}
@@ -404,3 +392,4 @@ module_platform_driver(mscc_miim_driver);
 MODULE_DESCRIPTION("Microsemi MIIM driver");
 MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@bootlin.com>");
 MODULE_LICENSE("Dual MIT/GPL");
+MODULE_IMPORT_NS(MFD_OCELOT);
-- 
2.25.1

