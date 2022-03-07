Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556F34CEF63
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbiCGCNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbiCGCNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:24 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2099.outbound.protection.outlook.com [40.107.93.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AAD12ACA;
        Sun,  6 Mar 2022 18:12:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnzHehcmdC8U/zZTstQSuynN4gzvj62tk6BdHGryYVSmG8krXkC3Bx48GsBxQSTytrwMZE9Zm9x4hTUNZlgJ6iuhY7Wuui5bq1xWjYvSBNOIMDPxxps8RVR0qKVLNDtcnJHvfc2ePKckuHfuspq8U2PX8M0rLrc/VGMQDNHZMi2FCe64bM6OsdBOBVjC0dNJWLTlrnzKnsHDnv6AkomRi4IPGXNnXxh1dodCTUv0P2hwAAO+KWXtCHjVOEBBAy71pUGwLZ6RHGF1kg96DpRrKbEtVLMRWDEK6wda1AzO3rrX0KsyN5eN4/ktkPSXo+ocSzVmX6gUc1VoyLA5ijw8Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/K1s/Dm04W43wHJPNqg5IK7S3EBNyWBB4vfeO/rfC3A=;
 b=ETLURKINM5dROF7bVAITylzYAHrBFrXUc0xfYI1ta3E1go+XbsOmYAoqJouU9sC4cHirnAvOyXFolR6hj+/bENZv/0wyuUBMi8y/HJ3Rt+g8BU7C/hmQ/UlUhBEKSa45FgNtZLoJvhAtAW4lS+dmpf3cXSRurrbsE6I3biG7Pnph2jLZ7ZcBgaoiCrZYgAqN6rvr8PU3wqFCdUBRgY92jZ+oA358KRkgy9+6eCGBof+PgMBtbJ+jRqMh9k66qFItioPTpczR+LbxNeGA7znWEAOe1rHoTFdtxjjZNaNFZk4LOeOZYNoa5TybP/hBqQd3wT39y47+iyPXYyoOkj0dYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/K1s/Dm04W43wHJPNqg5IK7S3EBNyWBB4vfeO/rfC3A=;
 b=dnn3DxnaGrfwi9Q9M7uowsf3Bl18cnFcq81cbRoJmFIfSwSOMV8+9+qZ63Qnb2gvmbT76U878nL5JLlkMN72Npk9zznFY27FrVCiMFsCL9Gv1BlOWA9w1/oYKIEBQvgaK5uIl1ObfrsBtppuhy+WkKDxECzxv7YvyFkX0PvjfQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:26 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:26 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v7 net-next 03/13] net: mdio: mscc-miim: add local dev variable to cleanup probe function
Date:   Sun,  6 Mar 2022 18:11:58 -0800
Message-Id: <20220307021208.2406741-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307021208.2406741-1-colin.foster@in-advantage.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:303:85::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 765ae18e-23db-4662-41f4-08d9ffdfeca4
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4553938E68C4E34948F9509EA4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xxjI0uwCQwbH+6loqTAmTRcp5v7H058x2yRw2I83iQJtae3mha9cOmXFlW96Dj9hQ7eZn880LC2FUZ6AvHmwpVVfQOYU6DrPzn+8qhfPEJrDTsg2r/I568Eyi/CYcf3un8rfStebgPPv2d+X0mmU3cs6yH3U6s0v1MSjd0dH56Ini1Z6Zm0zs+Lty28M4kg/t29fJtAi1lA1y4sCunK/vTaCLjL8wt3oPMJ6tFn3wGMOYGVk3QPGklywr5Ad5Tqqk5a3dCbODndTzxWVQJnZ1duyKLK0ZlNPRHl/+ycnpbNTl8x+kAEJk1frGBbn+NQqmf66bZpnBpfytaq0tyfJD0nQGxx2+sOYli6wvZUsE4nDaX5woesnmCy1xHv3aE27Krgvx8WFungohEru7fsxlyH2k6mDoMxs/N1lL+LD3QelQDAdHoanBuCGFDCAmZAtikiR/EO28EpGIRMBk2Y8RpHlu0ko47lZhEd/ZqB9BStNbEm8UbvmG4CAmOvVr50jf/z5VkXSoAO9wgzZtR8/NkZtJr+06DJKsAVqY/OnXXisfda6J1Za1vdQ7Z/gj6O/mSIyugUjxmhrpYtlFNvprXtG0K3Fl4AqcvBN5ctyPWSxvhFpHIj9oTlkyYpMyicA0cT+ODF8vUCx/MZsKWSqSNUSI+XobiwUOo9HgJU/WsQXabhQsBY9ZgPYyT+3HSCkzupogFncF1Xmx66EwHXtLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(39830400003)(136003)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?68KpFdEOqHu6O3pEFNj+6pyzW/eHykfVOyhwdQSk/lVgtPOQWj+x5+5nufaA?=
 =?us-ascii?Q?jlF+3AgBaSEz/JiwW5LN+XduFzXh8JKZaajwiaQNQeUep7wRxul0v70nMQ8r?=
 =?us-ascii?Q?/sJmU0w0nQH8bJ+/fmr0l19mX3aegBU4tIL5mX8AO7kbV9srCYH0uRONQQUU?=
 =?us-ascii?Q?2OQ1EIHv3FhgnUdnow1MmRtbqjYC0h+wqm495AGYXkh37MdeRBMHV30Ke1uK?=
 =?us-ascii?Q?Eb9Cka6vz9T06M7o9S1MsQeok6gL0WIIPI1f8VjkKeF818cEkbatVn1z/boB?=
 =?us-ascii?Q?toND0WiNWelwGJzo38Wm6ejdruPEbVnQQYhXoWVtrshQSbIdmD31j2YaCqOo?=
 =?us-ascii?Q?fJJEE0b+JCWo8F9jY/Sci2okeVj8jfNRmGY+eJTjm6WALlZEBdAeEihcCdIl?=
 =?us-ascii?Q?hv0H6ZJe2r22vqTUdCsn8SarfTEFi3aS2ADrxnB82GshdcefEsui3lLaR8xa?=
 =?us-ascii?Q?rNuOuISKtkiOxic4e8+zHzfdslo9EttGPIciQMke/P29+Pkzolk9i1n385bo?=
 =?us-ascii?Q?1lHaUjDQ6OK4YK3Tl9kkJaWuWZbw9Kc9PjxuzBU4cHx/YnFG3At6NYLYpsUc?=
 =?us-ascii?Q?Plh6toYl0/03lFI3f+ZCH6v2xLicq2ilxehL4mMVbFG+q+1e5naDavdJdVoL?=
 =?us-ascii?Q?5Zn2JjnpNZnSLUdu/eo/3Qd60ovPg4iasIE/NkV+NIqQb8vBVKqv39guKM+8?=
 =?us-ascii?Q?KDgbvSSCyzA89j54clVrx5w21iVJlQCXvX6m+q6A7T+Lg71hkfV2R6toBKvf?=
 =?us-ascii?Q?0ZxeibAx7m396hfI4eYQVxYkdGlkhu7FvXeFVwZZqWk5uonI3yEpMPQD03la?=
 =?us-ascii?Q?+60e+Jf/fZFmhL3uSjSP5vHXhYmOw7gw/KF3YAdCSM+kNB87cCqk0Zjnk0XW?=
 =?us-ascii?Q?Aq4IyJBCWaB3uXOpL8zBBNsmtfWWAD0RLAlUypd+f081qDXsOaP5dbmRcux3?=
 =?us-ascii?Q?vjWW6N/X45JaHMyF5D3s4vZh7NDH4An6/a78Ez08FuFKV4KPETCCTTciEear?=
 =?us-ascii?Q?dUCBYra425vUpDtkd5NILRNh0BqEecposDTa/bPwYziE068m9gtmhj/SHuPy?=
 =?us-ascii?Q?GxtHkvUL6MbLMl4kvJvQYYOkfQp3yuAADmaQpIGgF/uCvl9YPZ1aZu0vJlil?=
 =?us-ascii?Q?eE4R21aYBpA+FgyQeSH0aSEM8u8sz6zIFOzu+xkJCENABEQ5tflfAQ+6vDyc?=
 =?us-ascii?Q?rOPT+uCXJyCmstx7md2hfg0raS33WRJAJmssk3/04ubc7A4NMBQYw65KBs2y?=
 =?us-ascii?Q?iyyYQNYh/yOWb3kfAlMewySe3BDvy1GyL41QMXf1ULwG57CWXo/fUMoyZ4eG?=
 =?us-ascii?Q?2hlDz8Thm4Xm+am+DNXiqmLoEgQTtumYxS1MPRWYK7+zmxMCXIRg1DBSPfhk?=
 =?us-ascii?Q?w2JKluoBDnrz4s8eealllw88Oeol746yqSk9u2xrPxeYRx9YoE/yJrPxJWS1?=
 =?us-ascii?Q?McvF2d5LR6+bG30pw0M1HsWhK83P/TcvkTvs+MHc4UG5mKbMTb5NBHnQJ8WF?=
 =?us-ascii?Q?sXbjhz+gLD3ynYm1p0pSecwb4LemVuYp/y+11MbgTHFE7h/628KFepFRC82y?=
 =?us-ascii?Q?XtiaWFk3lYFOZdQDX98jkeNM2ceSiP3YTGIGfhfOCGBREmlZ7ZDscya3EvsM?=
 =?us-ascii?Q?ROtutKlDUaRgVrIIXLXY0CMUOCIjWCUViVl29oy5u+ntYfTMQvM2pQTUGSQY?=
 =?us-ascii?Q?5dnHQQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 765ae18e-23db-4662-41f4-08d9ffdfeca4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:26.5269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: io9JRYeymQD3I9vkON7qql8QtV58FJGCAfN6qOsDz2IAT/ganyRwEI8mrcz8rcboPWXFkWRrQa3bALe/3cahOaCb7+JjY7WwqoCgXtLJbO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a local device *dev in order to not dereference the platform_device
several times throughout the probe function.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 7d2abaf2b2c9..6b14f3cf3891 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -220,6 +220,7 @@ EXPORT_SYMBOL(mscc_miim_setup);
 static int mscc_miim_probe(struct platform_device *pdev)
 {
 	struct regmap *mii_regmap, *phy_regmap = NULL;
+	struct device *dev = &pdev->dev;
 	void __iomem *regs, *phy_regs;
 	struct mscc_miim_dev *miim;
 	struct resource *res;
@@ -228,38 +229,37 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
 	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(regs)) {
-		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
+		dev_err(dev, "Unable to map MIIM registers\n");
 		return PTR_ERR(regs);
 	}
 
-	mii_regmap = devm_regmap_init_mmio(&pdev->dev, regs,
-					   &mscc_miim_regmap_config);
+	mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
 
 	if (IS_ERR(mii_regmap)) {
-		dev_err(&pdev->dev, "Unable to create MIIM regmap\n");
+		dev_err(dev, "Unable to create MIIM regmap\n");
 		return PTR_ERR(mii_regmap);
 	}
 
 	/* This resource is optional */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res) {
-		phy_regs = devm_ioremap_resource(&pdev->dev, res);
+		phy_regs = devm_ioremap_resource(dev, res);
 		if (IS_ERR(phy_regs)) {
-			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
+			dev_err(dev, "Unable to map internal phy registers\n");
 			return PTR_ERR(phy_regs);
 		}
 
-		phy_regmap = devm_regmap_init_mmio(&pdev->dev, phy_regs,
+		phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
 						   &mscc_miim_regmap_config);
 		if (IS_ERR(phy_regmap)) {
-			dev_err(&pdev->dev, "Unable to create phy register regmap\n");
+			dev_err(dev, "Unable to create phy register regmap\n");
 			return PTR_ERR(phy_regmap);
 		}
 	}
 
-	ret = mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0);
+	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Unable to setup the MDIO bus\n");
+		dev_err(dev, "Unable to setup the MDIO bus\n");
 		return ret;
 	}
 
@@ -267,9 +267,9 @@ static int mscc_miim_probe(struct platform_device *pdev)
 	miim->phy_regs = phy_regmap;
 	miim->phy_reset_offset = 0;
 
-	ret = of_mdiobus_register(bus, pdev->dev.of_node);
+	ret = of_mdiobus_register(bus, dev->of_node);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
+		dev_err(dev, "Cannot register MDIO bus (%d)\n", ret);
 		return ret;
 	}
 
-- 
2.25.1

