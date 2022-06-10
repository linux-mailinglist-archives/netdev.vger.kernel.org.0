Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80359546BFD
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350254AbiFJR5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349601AbiFJR5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:57:15 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C8A7890F;
        Fri, 10 Jun 2022 10:57:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvI3dZT8pGq9dzifhxpoKeTvZw3Jkl2NcqCHqaKksgs/MCc/dDD83/aMWRDNNK7iCL03iWHfNQ6tvXg4/yVCWWoaS9hAnGlox5wvyQmCkA+rNMYb2Hi5SP2r4YCt78+C0Zz2+ECkze1kGynTTZ4w5G2Xfnt7J+C5x5TrK6U5m029yD66DqZtenNFOGoUWf9dh/wtm6yYdGWmqH6cDuM3kTdccWrMt7kmE7M7iebOp8w51oNkLu2op9kUo0wmdyOMyQYKcKZKALxtD29JyUmThtpI7bTFVKWkFvBKTGJeCHOYyJUs07WuieaV83HRW1w54BQcpKRMlZyNHrA+6h88QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e34s1zcWVZ7Jns/59LxiobrgeUjv+/YLeiuNdoxRi/o=;
 b=iXp5wy739kRbtmSo2WSGU+Oz7chLU+8H9ig7UJ9uBnMJR74UX/VV6G+2ochIY32NpsrG/UvSsTSUDv2rqZi945CaFlrvplhXQHz6kb27o0U0Bc1+wivlqkbVBQC5sRcDd4KUEFysVGC+fYj5+CGD5jihKHkAd8gN6FiYCrCk8qKeBFbn5BoetAm7QMt4L7JmceVG0QhAiZMv5bmcs8V6Ey6oYtf37+5Hka8EoTuxg2PHROjXd934hayxHyBSuboCZlb4DKMslc9Cz/tf0QcVgvBGFgTEqPXhUD1Ut4o/zvhoan+9xlxEHHgEs8Mg2kjHgfx0AGFL8UoDo9p7qc/AYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e34s1zcWVZ7Jns/59LxiobrgeUjv+/YLeiuNdoxRi/o=;
 b=kukaOP6BeZV/rIGOVcQHW25g/v4rGSONA+sZR3yCFtK5O0kbdoRNJX9zrZVhJK9Go0+oz6obKmsWdSHE4v97ghp6aXwms+ALx9Scp/tPrzaF20AF9lo+CkqzSzHVquGV4ruYBoPkmQk51gh2SWMpgZH6mSSDBYCGep5wuxktGZA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3356.namprd10.prod.outlook.com
 (2603:10b6:5:1a9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Fri, 10 Jun
 2022 17:57:07 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 17:57:07 +0000
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
Subject: [PATCH v9 net-next 2/7] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Fri, 10 Jun 2022 10:56:50 -0700
Message-Id: <20220610175655.776153-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610175655.776153-1-colin.foster@in-advantage.com>
References: <20220610175655.776153-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0070.namprd19.prod.outlook.com
 (2603:10b6:300:94::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2470f541-d1a1-4cd9-25c4-08da4b0aa222
X-MS-TrafficTypeDiagnostic: DM6PR10MB3356:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3356EF2C3BA532BB500F7345A4A69@DM6PR10MB3356.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IaoFepCuhMwSoX8AWIJAFzAlttPcByPHyraEbFxMr3uNt1D7WHxMBANN9qoGXcldc3/CoyA8oef+gGwuigdjLIa5bhTq6u3PbfmbsJTCBDd/NZJ8pR1bGq5BYaVhG7e6bWc8VwJhiNybekgp4TjKuXSCpaBJBnLElLl1ip/eP2NSGDPmpJ9GO/r09Ne0MEg20r4e+ZfWU+tlZnPlFx+fyqUgacjwQNTcoouHUdFi6T+FYUYB5gwU1LMky47fucLih0KyIuhbOmr1MPaCeQc17DSGklOM45ZKB/OZz3IeNcpUnnzFjKbcC+NyMXpB4KxgD3eaxJshbuWgQJcBc8LX4wgkoKv3zou+cqqLoRfyeF8qAsBCDgXjuxaqtx+TcoCTyKDozVS+UWnZEU0150V1wLt7a4dKn+lRMpYx8AmZzu8vUW4yImMwLqJXFEx2klyswA6vQx6mepWXcZhnpOevrNj7mtodxJZHPb5ZNxNjlftwHO7uNG0s3daKyCsE/uakHQO6ND7RXRP5lNe9MdyjDCMFjpiV9/DSfMMdBp0GpdsJO/AQUYM5S1VA3p6iV63YpZ4f3Ae859vVGz7CT0cJx6E0eZJTdqVuZZkkHtkqn/OftKsS9z1Vod1InuXALNwBWhYoTyPLxCxeKBvt4e6htIWogblqVNa1w5xn43VV3P5wz4+tkD0cRTaD5meYREq0PUItvsNXaEgiyVOsgGS15g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(396003)(136003)(39830400003)(1076003)(54906003)(316002)(4326008)(52116002)(8676002)(2616005)(86362001)(508600001)(6512007)(26005)(6506007)(6666004)(41300700001)(6486002)(186003)(83380400001)(2906002)(38350700002)(44832011)(8936002)(36756003)(38100700002)(66556008)(66946007)(66476007)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cv1p41x+uM//VTSOZEuM0Gwwa2qIYetBl9itSFzWXA2qfJNcauH/fOIjC+PZ?=
 =?us-ascii?Q?d/GFZqL4E/pK6IwhemR0NYsnAJNJQKcv22yGvu5T8uRwi7rr6+mJpz6DXz3o?=
 =?us-ascii?Q?7eoGrbP2G7zmu97H2mExqXaegXU8R8DLBN7geWhP0K9BTgD9R6IhNfptTD92?=
 =?us-ascii?Q?rA4tT0pCJJ8OspBVrmXqn7X5t70pdC1iY3pWMH8D4Hneb7N6bUt1I/aDnV2A?=
 =?us-ascii?Q?HV+9CQUzTjOic4RbsGIK8//9zrvjA6UlxT8OG3BrF8EDIB/H7BFzPS3Z0Syr?=
 =?us-ascii?Q?uDVum8ttu3cu7F7FmRwoorPBv7ekeqrG+LS1iXzFyJM5aZ/iMJow15Bjth2h?=
 =?us-ascii?Q?QOChPZ7NiA30LJ6o1kNklfOd2JAGueeJF/OPiO5p9UBy3aWoDgkQ852LjT/X?=
 =?us-ascii?Q?K5aznbFfozklxZ7gd48MEfHADKfvbjfZaCACiFd5Rc89PYQvD5QfcyVYXLDT?=
 =?us-ascii?Q?UbyZ5arPWAahvtclUNFzKCVA4mBz3IhzLyE9pxOhBSUfbFWCg969IeR3FAz6?=
 =?us-ascii?Q?f/3V+zo4TXVzbKfkxyun7akIfJ2IXQzo8G6G2xVkCAyr3Ew9IEO4FMpSZs2r?=
 =?us-ascii?Q?yT9psJCaZrccik5vcikgjJpKTBECHuJyWnqJU2FBYtR+bfslKm0nPmVg54qC?=
 =?us-ascii?Q?/H7P5ARWVF8hmivQxQEZUX3UFtPv41iZ2Bh2d0JOfp/SZMGRjF2Onen5LF1f?=
 =?us-ascii?Q?UPO4BHB3oIeXEpY8zdCWa7+KeezZAf719g4eZgMoxGsA04R1zlMI/TMFm3s4?=
 =?us-ascii?Q?HvD8Z4PJ8sqQz03H6cvcLvrmzYfpl3m3E1q+E3nRZHWBAuMvmbenQZRe5OPI?=
 =?us-ascii?Q?KkUPTNYeXoqKpcUF5tSIATuMssd3orTKFibJQoLs6pFJ9HOKzdb7SySqj1pw?=
 =?us-ascii?Q?MdZoqgqMr16PKdPlpFtyRjBPsVpIdVJhA5bU72Af0jceNeB55LBv1obkXV3a?=
 =?us-ascii?Q?kZywryffAVEobUDSA0g4dt2jNAtW3GRzpWK+soASfnbw+D6tVzqB8tXURlf/?=
 =?us-ascii?Q?gKcE6JZc4idw8jIFuWqky6LBlqj1tJrwOXMytwChbqnoeYwB56Ix40FrHOXK?=
 =?us-ascii?Q?TkQ0y1oU/dvzBA8H0QaXzTZGkgqENkmKGmpvmNRTrvzN+shL1SeGeg0AbKMx?=
 =?us-ascii?Q?q3sb7I6mfy6Kt5UZvPY8aFSTHr5m54k6UqrW+1vYajkxK86D+JdUBM08kton?=
 =?us-ascii?Q?LcSxTloDkVNyORViqsrXFYCC5H+WYVcjyWmwQ6dWz+Fh/E3h6czfQ/Ixbstp?=
 =?us-ascii?Q?DHq9qEZOH8GLl9WpYV29OLBZ8U8kwO+1Pw9LS+3EffgT0MM/kDdex9ZYS2qH?=
 =?us-ascii?Q?NvzFLfsK2ZbQvN6ucNMntB1Sffu7avGI1begY2UlKCuHc2iP7ZUPVHLLeXg/?=
 =?us-ascii?Q?yXmjBM1TZBhscQz6nNweCLK48CVjsVFqdjdq73dPNXNmnM71OBbm97PQsUxV?=
 =?us-ascii?Q?lJWygAgIVMbhSEP1DYCpyr8+HgYENL4JMTioUeYngdL2q5pVMvBvGB+Gpodn?=
 =?us-ascii?Q?xqE1rWj7vROLLKSGu0l8a4ZpQuyI+rRNFWNsb2cOaFu37u29US2qXIilmK+W?=
 =?us-ascii?Q?hdCk169YnwixuHheaTpJtlZKkkZFhsTcRWqym2chqLJU1yHcNqRZ1cdR/qQX?=
 =?us-ascii?Q?PxM5bUmvZGKDUFiGs4Fnqw+8UnsVNi4Imn1ZtsIt8Rh9n/N0UlRQNA/OY1yT?=
 =?us-ascii?Q?cQ3wgpuZ+RlKShggDtOZfRbb4GFm5/XBzlErN9++x8yXO7LovWu/uQ4pxWyZ?=
 =?us-ascii?Q?fWVZDbnDnsqh4lHtzNFCx6/F6F9ES8Y7A5vvn0Z3gXu8XvKF1oT2?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2470f541-d1a1-4cd9-25c4-08da4b0aa222
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:57:07.1218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4927oz8y/doqkA1Qv9Ls85hhw/jWi0cBii387Fe6sp7o2tof1smNILAIXXTjOv8ps3+LMLSCr13K/he8iw5SNt9sGG2ePnrisksnpRAlfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3356
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
 1 file changed, 8 insertions(+), 19 deletions(-)

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
-- 
2.25.1

