Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FD25678B1
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiGEUsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiGEUsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:48:18 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2113.outbound.protection.outlook.com [40.107.92.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154991209E;
        Tue,  5 Jul 2022 13:48:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ja+viL62m7Zf7U/wguxGlIRIUPhC2Q22JeSQsh+Fj3mFBCqOgkBEsjb5bnEfBeNY2BG4BV7r//Gc/1wLTlTt2qxJWi5d8ttPaW+3DyY1e3+C9wA4E39sgtku6ZP8GaQ6tCPTxZC6wK8kYgpBT4MxO1MkOfytHDEZm9aYuxPZDkFwfKweuYa9K2G4OTiEFCRBFpJ1LG+p3El0swqVTxNz03OAOmruO8sX7WCyhzmK2SD4TqnO5n62Bcoo23u13SPeThMW1vCFnFkO3VZCMEGtlcZJBCGZJJq0NWDMSXlPDGh40I23zUcbZKhW1Q9jZnNL8cNdUGCBmMck5js+fnEL6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ll+F7wpfknxrO1MrYqXnjoKX+16S1j9J2FtyIEIKjus=;
 b=amWWduXAkPXqCFgv3pCA1nShGaXlvVZmGmEPIJ5mgBZsnF2ipZzi9fUXTaQjPTIwOqJJwUV2yhIz+vNVrp95ABwR18sIn1Uh2+031vqHfbJmOJiLLpWFfxDKr0fJxNBgpHJ68bYKLnW6FW7l7v52sVzVRkHFGEskX6b83X46GBcvHko4J6Tod5YIsaV5aRzPzTYDpBLC+OR+s7YnwwHLJp5DY3Ht84Uhnj8MRWbtpWbqOwnm5CVK9iqNwpIEp/81V3VCAyrBRgIkiG4ByxYFAWw8OPrM2ZrcQIQjmm5YlSHzgo/2qZEWLei7kNFRLqXyZwC4ggWb+50drq8Hk0a3ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ll+F7wpfknxrO1MrYqXnjoKX+16S1j9J2FtyIEIKjus=;
 b=0j5sfrjMPlOBHwPZr2IgjSPL2JkoZxvq6UTDLZRYWWw0gufx60AZZtFc20dX7JJUg2FOjAWWfNs5afsByoSO5vdtQ3NSEcXigoa5f5Ex4rqDEcZzPSk8IR9Szg+0DQCoWtS3g7+wA/37+pcOJgnScUwzQPOOCp2JdwLZiVPJwNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BL0PR10MB2898.namprd10.prod.outlook.com
 (2603:10b6:208:75::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 20:48:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 20:48:12 +0000
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
Subject: [PATCH v13 net-next 4/9] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Tue,  5 Jul 2022 13:47:38 -0700
Message-Id: <20220705204743.3224692-5-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 962b4700-d744-4b3e-36d3-08da5ec7ad40
X-MS-TrafficTypeDiagnostic: BL0PR10MB2898:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TNxJ4GHnZlIgi7XQTBUB2pvBNDtnpEQBPmTDOYpBthI1v0SQZbk6ywiU15E7tXt4jbRgARprfaFCBqYzvP9bFVQOZRFJngV6bmk3ppkNI00Nx0pQgy5NjSjoxx0qFkmPJwP7iunXB1+QDpognOx7u1fitZhDQWIzHXsCsh+dPXY1yDI5Ueo3sSSo3cHn7ucl/+JNWg1nTPSxvZlxrS5XWhqtlOYHZOjIkSbk+kO72Z579ApoK49Fj6IIyQdnsHtcjEQn/9a2HTbiZmpN3P0n1SoNvfNgNucUsZf+mkg6UNLf3XmswaTuQUv/Qq6TVsP8jS6unI+bd/eLlNg0S7IRTVxYlL+6hX2PWRvt07Qu92+AhFM3SaduO0OQxNMbdQGwCupYplClRNQaBY2Qf54HM/rQZDra73exY7BRDK/TQ1w4u/ndq7R7DE2PckjplyBvNXa3JhHusac+YFxnu2T4NtkpM5aAmPeVxPkzqU9SMmS6QzK3TMq6lioVkPNKYZhpM2YVzGQceS9IexEzntdXEMTATrrLwJTjM406ytwaF2p0kP/qrd3k+2cVkV52mWcL3L1mpOuBGN0Rra+gPhkT2zS85MDlH3nRKAvgw+dFyEoAWTYl18Kd4SIgkZHiPdRBtGYd0K1YcR9ZwtqhGC9p1SyYiCjUWZql7WYzy2p+BEqQIJoYiYZ7SE/iLc7NJmzRJ7057AzDlU96RtofflpOSjApZpxWW/JrmUAz0iLjlQGDJ9hkF1y5kY/zdUS0j7SLfKofjeqfYVA4Lb4T1xnLltdn2BYbvWmvsPx5Sx5e9v8I1/lsMZch9PEXx4bG1esv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(376002)(346002)(136003)(396003)(366004)(478600001)(38350700002)(66556008)(66476007)(8676002)(66946007)(4326008)(316002)(38100700002)(186003)(107886003)(2616005)(1076003)(6486002)(41300700001)(26005)(6506007)(6666004)(52116002)(6512007)(54906003)(83380400001)(5660300002)(86362001)(2906002)(44832011)(7416002)(36756003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hiNwDCglAn6VsBfidwirRNWisf9XkAfxJD2RVpfFmhs7zPsan1s3SSdceddX?=
 =?us-ascii?Q?THlHzx8+tkfU7vzhVU2N1pS9D4lSNfRzv4Pc/ByrAK5XFBf3uD1VCrWjaiOo?=
 =?us-ascii?Q?qSY2sNzldQtCOBTy/oRUja1V2KVMC4qbFlBHmSkchJICTQhgYEt9XWiq041f?=
 =?us-ascii?Q?qzCu5pa0xSMFYSjqSP+qPej1/JJdYSq4mdR41GkSGceDghR99U8iCCO3+fHt?=
 =?us-ascii?Q?AEyQ34bKn5q2WLbHNLxJso0rWLNngCR9ieq8O6eZWk4roS5UMen/bQrmrnsF?=
 =?us-ascii?Q?aiLZLFGPjUeDMvtZSsWhPlaBeit82YxnARwJ0ifmR22r1lFj2lTfa1MBS28Y?=
 =?us-ascii?Q?eRvfjLMup5FoTxjGOBEKAH1INmbUvkLbA1amAt0pkGaAhkpq8/GLgUjXSYfM?=
 =?us-ascii?Q?A+XDvFf287faZ+A/vaj9Z59+uB5+oaePc2TyNd0l7VVe1DRk+BB3BZhS0zPl?=
 =?us-ascii?Q?pjtkDbzlhNHaiN/y/nTLfEbGEGwBFfYtca8ZlSYnoywRgRjBHMUmmNYKd7FL?=
 =?us-ascii?Q?HejJD1k5fD4m/LrFSZB0b9WhHat6CWoO9XFoTgd9l4E5Ai45r0DVL9FI5TvQ?=
 =?us-ascii?Q?/VgnYTMwxtt5ydwKQEUsm/dIKma3b12Iu1HhhdwQv4GwCd3xwInGIl+hYMND?=
 =?us-ascii?Q?dHMha/mZrmciZLdy8dIeUYHCN3PTBpjf2R94mmg+IiHjzgBnQaWGpXo1x2y5?=
 =?us-ascii?Q?Hx6T4oX/wv36K38pBxdYoUT3YbmCa7ijJvo4mkOS36FpG8MGUWt24XHdmBrA?=
 =?us-ascii?Q?6f870A1r/EflZ1zfHewPitWjwXF8u6f+y/Xzk7SltunNB/fg6M1BmqDmNANg?=
 =?us-ascii?Q?Y8NIdXD0Q3JABjAPa4FAau/3ct4GsGm2L75ywUtuFGaQfFzvGvWWmXdPzp+6?=
 =?us-ascii?Q?fHpMu6DGKraI2AlLK9GLFBFzQmF9EqpPwuAt1KfZo/pFqjUggOJd8vLb0MT3?=
 =?us-ascii?Q?5oXqbSWKrgaqHLXwNPCLDshDmYCY35UAekszpci7H0HvF0ekDHXn9GuZHktm?=
 =?us-ascii?Q?vUSASEu8A9Du4PpBYLQyi6Pq/PCUjom3eust7cM8DH8P37liD4OvKa12czIr?=
 =?us-ascii?Q?gwBe3X0GMksAUNyb8duDZgv5YKa7X2JnSG5nNcvXBkJcBZYLl3IVcWXWSb7V?=
 =?us-ascii?Q?ft+BCuZQvua8MIL093vivUyycKuWVh8AU+xWBmfVhBjaXgljLNuVvHYe7HJa?=
 =?us-ascii?Q?czoWOJn+Mtu7rvoL55l9t2sixmJFhaWqvZYmSMxYdtQf7gD30+oldK87ktMf?=
 =?us-ascii?Q?hwcSGn7+EaM2C0HWBR2Sni+NcZG2m/GCClbPVHPGqHN9VT/hCdfD3t5tYzbO?=
 =?us-ascii?Q?/eCOhfZeoBRJ7P+VIJcT4ntUrLbXu+U+OSOi3GNnyCembdtS9IwI8RhPBm/f?=
 =?us-ascii?Q?G18z+WhinLGd3WmjbMKzQwSDhELlC4TA0IRJ/hSgWNcZDjD7dS5Ao23gUXHx?=
 =?us-ascii?Q?EuxnZ+g15UksCHw5wkJWVb7W4BV7EvV3B9VerUAIbcGBFBC7oC1qfBGKEsIY?=
 =?us-ascii?Q?ihYET1G/haU2pHzb/NC0yTNvPbsMmaROSxYgnzWfj4A4Opqxx79xTrTtLYsb?=
 =?us-ascii?Q?a9nC5CU4XhWZo1rDaWzrrHF+ZK5XmagH0JUnZT3MrxrShU3kQOmkypkXAyxO?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 962b4700-d744-4b3e-36d3-08da5ec7ad40
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 20:48:12.6390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AadtdEpgQzH9EyhiRrjv9RZ4NXfzhLniwoF3gppVn7wOWwMLVH6qKtl50kFN5DwBucMgF2XpHvQ3atsVBZSGUP9OneHaRWx9xSzzedrekhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2898
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that contain pinctrl logic, but can be
controlled externally. Specifically the VSC7511, 7512, 7513 and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-ocelot.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index d18047d2306d..80a3bba520cb 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -10,6 +10,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/mfd/ocelot.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -1918,7 +1919,6 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct ocelot_pinctrl *info;
 	struct reset_control *reset;
 	struct regmap *pincfg;
-	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
@@ -1938,20 +1938,14 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 				     "Failed to get reset\n");
 	reset_control_reset(reset);
 
-	base = devm_ioremap_resource(dev,
-			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
 	info->stride = 1 + (info->desc->npins - 1) / 32;
 
 	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
-	if (IS_ERR(info->map)) {
-		dev_err(dev, "Failed to create regmap\n");
-		return PTR_ERR(info->map);
-	}
+	info->map = ocelot_regmap_from_resource(pdev, 0, &regmap_config);
+	if (IS_ERR(info->map))
+		return dev_err_probe(dev, PTR_ERR(info->map),
+				     "Failed to create regmap\n");
 	dev_set_drvdata(dev, info->map);
 	info->dev = dev;
 
-- 
2.25.1

