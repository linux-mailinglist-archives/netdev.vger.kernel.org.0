Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B703B5678A3
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiGEUsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiGEUsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:48:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2113.outbound.protection.outlook.com [40.107.92.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6029CE0E0;
        Tue,  5 Jul 2022 13:48:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8J2U7AjDNXpKMlXqYpxuW800S8qbfLNxbcPfimlUFinaBVB4NbPlSituMLXJjOxjkcU1fE8nVkegEi06o8+4LOJXHVy14hHRvZGjPvff954LofEcd3hubQ2G1VG5/YTOvOIGnPyJN5CyavJ0B4a2pkFkSPXEr37CKK0nYkGxwghe09CzaIKNppnA4jM9kx79cKvO91JK/T4YVM1/gknbuBvm6aMz3nU8YPj0t3Dmu8GmBweFGySdnLwL892H1HpffnYaR++yOcpoF2vMg7Vc4eWFBQ7MhLTj8cKKeR6A/0De5NrvuRSgjxKgBrIe/a2AK33k0w7mqLXQD3r3yMEyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwid5gbAmrVLO1DsOBJPrp/TZJ4S/RFMHJKxGCpjVi0=;
 b=bvVQtb/oNm6zBlMod9woa7fPcOkbOFJfFpOG+pZ7xQDk+KmUzNb3UhDxwnJfrwSjQHAiRE0QPH9sgjHdoFEb1BxdGqdzN41NZ6CVd6Ev6zfGeAqXNXABLkwoVj/tDuEAX0sEkU+1OUlJiKaX0vCSWpmOxiD3Vg+M2Du+r+InKMUwc0CJU+xCluOgXhrmbuq93PFf7WY/+LMhVO7djKAyUuW/wsR3u8uwjDPZN3eTZGgbIn9BEgrU/WcoPd+V2XUptdewiVY2GgxRy4KzQOl31SLnrmysLvJDJaTPLEGGuCTwSTsKM5B1/FGGBrWX9n/0xRu/D9INq7Pl4NBxquhR0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwid5gbAmrVLO1DsOBJPrp/TZJ4S/RFMHJKxGCpjVi0=;
 b=fpCx0FiPMuJUM3cXmY7+m9WJfMKUBIgnpb66JoSPK8jLAjmY668LtKSE6IAf9bl856NaTTUHmL8p/ujbSB5Ek9HgHByvLBGinqsgyzup/b0Jldam9G8cAjgv31u6O/glYPmGeeu81RUCZ0RQYNvGIJbDjvOiBZ2swpgyHdMLyQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BL0PR10MB2898.namprd10.prod.outlook.com
 (2603:10b6:208:75::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 20:48:11 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 20:48:11 +0000
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
Subject: [PATCH v13 net-next 2/9] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Tue,  5 Jul 2022 13:47:36 -0700
Message-Id: <20220705204743.3224692-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220705204743.3224692-1-colin.foster@in-advantage.com>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:302:1::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7c81cee-c9ad-46e2-a700-08da5ec7ac69
X-MS-TrafficTypeDiagnostic: BL0PR10MB2898:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sB4T2SbMofxxuWHfd890qmyPjAYcZ/lvT40tAcaUoMQ41C1Dhfa2y2w8vzKeksHMSFX/ieFil2rvcpKEqsTpZdnAs9Qq0yqdrjv1FS3yvO5QJ4CDTPt93ZmmkA+ugkcHF0yOajDDjblvGtZ/v3Ia9VKyTweobvpe/0cJ7yOEHh6Xi5dm7hNUUoGr75Fx9/an2tDC7mLWBZahTP2j4LmVVnbaq5W5sGHdiDMbWwoOJFGkIs27QtiaJrqHycA2evbAZsy55q7c2l8MX/+arPQV4Yrgw/z78d9zYwvVYcW86x+FK13Sn6uvpYITglsiRBiPQ+uXMRFeNowOeAsRA90ydJoGtgi6jCRHgGhhuF5Ef1f7dmUKe4p3RLIDxtzTDgB2OdFociItwvkSiBt2BDGtcXp32ei/nPzRZ8isFt8/1b743PudsrmTapaD6LlsZe7YpaRqzuh3HVWoltaQQtinopnYdMVNfZNrE3zRlj2IHbrhS+xA6SCLyXzGVzTot0S6NijJ8gNb/TQDMj7AIWSQdeqSOXj9/hJkwHSIZHriZCUIBSrACwGULm2uc7/OX6mCBnTqAT2HX4LNzdaB04Ri19yWYz20RG5p16nG9oyRboSdil9L28Ci8bvHObAMaHqiY3VVHkpD+DVM4RpuNkd0xiLGPCfS+AuwxNWffi+AJMfwP/muDL/QPp2o7uskG0Gu9ZnLbKeZyVtWXvlP1kL+I0tAeCQjVz034w/77nMx8DvH9eItpBYLRyuAzwF9DMMBAcrOHVOFe5YHUvVbxDqfL8sgnqHo/rGunsI2Ah+/Agx4R3QW0bbm5s3579PSj2a7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(376002)(346002)(136003)(396003)(366004)(478600001)(38350700002)(66556008)(66476007)(8676002)(66946007)(4326008)(316002)(38100700002)(186003)(107886003)(2616005)(1076003)(6486002)(41300700001)(26005)(6506007)(6666004)(52116002)(6512007)(54906003)(83380400001)(5660300002)(86362001)(2906002)(44832011)(7416002)(36756003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l1QVqBQUX6ImZz470NPXtULX1CfjOeeW0+APouiNDaJGh/6TKN/1NVy7bAHr?=
 =?us-ascii?Q?oJjmNOQa1bY+5BTjQ96onx6qBtF1xxxAw1kmyoljGmD7qFUSr+7VGCAhlucu?=
 =?us-ascii?Q?OxGEjMu7h+uP37OSMeFFwlmu/sHWGzRI9I7ZBP7I5z6QhPqHnSCEkV2varXz?=
 =?us-ascii?Q?/GBKkDuUnnb6y6LvbPSGUYa12mjYp6ch9GPuDJZHyKftJWw6j6mbr5LS6iks?=
 =?us-ascii?Q?OhVtOeNrYzGoQBJy3+/tFbOwJSOAV+LFCiL44ijcV/VN55BdfTOjYCgD3yTP?=
 =?us-ascii?Q?GPBXxBOe5B93jnYcn433NQKQVUmgWdkAOlKQQfOWYgX5uo/HhuUkVE4Tn76J?=
 =?us-ascii?Q?tjdnhtwqLI6GWppisFYx/WB+P/IjZAA+DcxggXHuL2ams08b8kEWKEH+H27r?=
 =?us-ascii?Q?PfNv21b/c8g8erVFXbkygqVqC19EM9tplCqEOEuRB0npRMs8UwNWQX7YuT8a?=
 =?us-ascii?Q?/LG1sW9eiqhOOQ15Orv8M96X0egjvGQgPKYXQhTaInEfDIDhyu5lzKIr6Rv/?=
 =?us-ascii?Q?yZ5g8XcJ2fOzoykC4S0MrzOSBhpAcgk6bGC1tTwrO4fpG/h99r0n0R7NfysM?=
 =?us-ascii?Q?dp4gTLoUdcGEdEGUrMJKUXU8cC97Zwtj2w/Jg0Hj4uruRfWbHR/C5DbO5fBP?=
 =?us-ascii?Q?X+Hfaon4U3oRil50cheKoL0tFt6GEZMS//FYYReabsmf4rBlRHioc+qj0iqr?=
 =?us-ascii?Q?6frBJ4xj2vhvA+qPbn2lxdTM/Ovd/i1hesYzrACCl3PZaymxJhCE3+3aobZu?=
 =?us-ascii?Q?/A7Dv/ekc5DM83mlb0SGc2aI79/HfUU4KV2fXbl7nL/s2MQSuJLWAiYpjY5Q?=
 =?us-ascii?Q?9z79pyhrtGaFMoiPG6sBq2Dgq1eT9F6WmFHFnPAmpPMytNECi1Ns00PVM+6a?=
 =?us-ascii?Q?aX/EVRsfpRzlzkw86zF/1ZQhgc8yZCkjRswFLDnTKivq2XhhmiRSp5vlMrdn?=
 =?us-ascii?Q?hSTPWMr8I2YWoQtNAeQ2u4dJA+9dnaXTJOFcFX8irBSNfRKzqfbwWLj848mR?=
 =?us-ascii?Q?P7tDCxUekcdTkXsMW9S0nUfssH2bXNaPLZDPblVn58S0EuWdDutg+yEIzZUQ?=
 =?us-ascii?Q?0ZR2V8Zl7vzwO3svDp/dJkzOoQtd2jIhnPJe+lkZnPyst0jnHk38vyBJhh0i?=
 =?us-ascii?Q?y0TGs4Q7+WKgjqnMCg7d6swOfzT7i98w93UFDQl6m9JAlnAxW4IaxjOZRcL2?=
 =?us-ascii?Q?XVNY8wyKsa6YQS214P7NiJxiS8CdBVcxk/VDHmN3EB8Y/yss64+616FVpiav?=
 =?us-ascii?Q?eXXjPk0Vq5+AFX3PDZ/qoNxFw8ZxbRMuWKBHCQczeI2SDHaOUM9oZc4dSg10?=
 =?us-ascii?Q?Ct4vQ2Q+pE6hr0JtMi1miZv0o8bUeV5bGaHvrpR7Z5fy6LyfZxPACRwrqBDB?=
 =?us-ascii?Q?NRJRi89KXoSJasQopQCuEmQl9p+XDI/DC+DZyb9LMBjLMHmXzcMEsTdz7rlU?=
 =?us-ascii?Q?RRcGsSqUnnbqFufwSfcgJLCK09ZZXpDwR7ePDych+Ql4IkrqcLdEmQ4xizpT?=
 =?us-ascii?Q?kD4EZK+XxwNwnWsa5zH/aNj64pD0gopbC1Qc9ZDfv0ALZoBXgVPBWImAFStT?=
 =?us-ascii?Q?G3hkXPHii4x/meACNaomadRO3JYLWD+sgLd2ZxP7YACR3NUtq1QX/JmsWtGd?=
 =?us-ascii?Q?7Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c81cee-c9ad-46e2-a700-08da5ec7ac69
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 20:48:11.2954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IwIoEmYw//RYOPKQ9oGgMC8ZIi25Knr13iitT2KwFFQxrgYVgKIvkv6tNwLRKOPJT81Y4J8r+Dvq1YFT7gg1kgpYrTeXMmjlvtTH5gA2l9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2898
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
 drivers/net/mdio/mdio-mscc-miim.c | 42 +++++++++----------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 08541007b18a..51f68daac152 100644
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
@@ -270,44 +271,25 @@ static int mscc_miim_clk_set(struct mii_bus *bus)
 
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
-	if (IS_ERR(mii_regmap)) {
-		dev_err(dev, "Unable to create MIIM regmap\n");
-		return PTR_ERR(mii_regmap);
-	}
+	mii_regmap = ocelot_regmap_from_resource(pdev, 0,
+						 &mscc_miim_regmap_config);
+	if (IS_ERR(mii_regmap))
+		return dev_err_probe(dev, PTR_ERR(mii_regmap),
+				     "Unable to create MIIM regmap\n");
 
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
-	}
+	phy_regmap = ocelot_regmap_from_resource_optional(pdev, 1,
+						 &mscc_miim_phy_regmap_config);
+	if (IS_ERR(phy_regmap))
+		return dev_err_probe(dev, PTR_ERR(phy_regmap),
+				     "Unable to create phy register regmap\n");
 
 	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
 	if (ret < 0) {
-- 
2.25.1

