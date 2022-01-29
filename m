Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DB04A3232
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 23:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353343AbiA2WCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 17:02:54 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:64192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353296AbiA2WCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 17:02:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoMLbdbj/VDNg26Fyz6aTKdTIwG6ll/7+3H69tFKLj7mYtRZyUV3TAWyqne6CI+tVBvfC/x7wcXDk5Ezv9OTzzWJwx6qVlr0HhyJVhR3G3BDYy3JeqQo7sw4ilW1e6BSzmCgsOl70sSGp4DbpuJi3CjmWAphwNF5tJzsbWHPz1JzvyDTfJq26IHHgJYvnhWhGAc1ViBQarS4Xm+9hnEuGZniD6o4ePVYeWMAd45AB35wnTEZ1bOgaqZyrwSGyTMg/bPY41qUDOOzNXeQarHyF9sDCouq6Qr4oQjDlZJN+MSMAptueqLaaV2cFfG11tSTxoxQqKMw9up5ycQY+/cFyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGjLq3EG71sKZWvK0rp311nuL7IZ6E59fNj0zW6os2s=;
 b=Bivitk8ISFo8EHP0DlzR7/O7TgZoZKAEzzT8NjeQIy07DCZV4fvJOjD52NBOdmxD8YHGoYHOk8J8+FPnPEJhelOplDjUI/qxe6EOmrXedr4lsr1Wx/qBklC1sMluELTte2GZcOFxJfUYc5Nd3mTi3V1BhsnKGJ4scFhIA/vJ5iU+JSEkAvUDqadDZje4Grua7BeFCIDjs13hhLhzei+War7GdpsuEf8/QKfg4swuzClS4Vpmp9YjKZ05/Z/7rtcdfuKAooz5j4iLdYsokdUJV4Nel+Zj7O4xMJyFMssvbEcoqxAFe9s1OhUlrKzeQfQaDZC50idPEXCdc0FKOtDA2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGjLq3EG71sKZWvK0rp311nuL7IZ6E59fNj0zW6os2s=;
 b=YDHCh6VKFPMvL8cXSp6av2HcSYsoLMLiE2Jn9ZsOA9+JTlfVzvnpgMKE8DDNup2PiMBcvi4c8szCQrD3Z/5S7gdUrH+kSGoMYDPLnmgMRfxY84eVgt5kEO+UtCW/YKlHfcEzMkBL7zKDdr1p9p7T6CIrAQah0uUgXrEgd41STjI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2968.namprd10.prod.outlook.com
 (2603:10b6:a03:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sat, 29 Jan
 2022 22:02:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 22:02:41 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
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
Subject: [RFC v6 net-next 3/9] net: mdio: mscc-miim: add local dev variable to cleanup probe function
Date:   Sat, 29 Jan 2022 14:02:15 -0800
Message-Id: <20220129220221.2823127-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220129220221.2823127-1-colin.foster@in-advantage.com>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0113.namprd15.prod.outlook.com
 (2603:10b6:101:21::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2da4c9f-a659-4668-e9ec-08d9e3731225
X-MS-TrafficTypeDiagnostic: BYAPR10MB2968:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2968DC881BC52CE9FBBC682CA4239@BYAPR10MB2968.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhHsWJcRbFYlQV+uraUNuECbl6wmh+nkprh3gzCTDI6cFFDPtJZ8glNBAFA4v9f1Z2tGmtxi5ikLUODkks+6mSK1b2ZhlaYDi3Y01xXNf7q2C3U5LGYl+rTrW77l8STYGO2E0MDYkXZ5uagZSHpO0wyNTDyfYEor6cJVcamZo3kdMjEwz759HRgWIacD87OVhhSbfMiFEj1AyL+Qsk2dfSZQpGyfJ0VP5bE7cd5XOb/aceQclC4jVHAeDax+4v8DN5fZA2sAfZyG2vzZvHNSmSOVtRi/i3/DoCzT8N5Do6I+plGOoQFux/VE0sTPq5W+ZuAaF1m7LgpMarQRSv1+ONstxtrHzKaxAU6QzFiXeUogidHKtCFweLbhPnX4og6VGYaRGujNK71AT8OwQYtKzhmZriR8ACdcOLZU7gtIIi+uvPPBJ3j81vb8GLXFgCP7SCtzTUO9MZRRF2RR35QDJ+Hx64nvl9lNQNn2bu4HA6OaKIXe7WAxGEh2OvvgFreB9kG/CYRcrtZDZ+7aLe4e6DGGVqI12DHMCHxZxrotuqE4uLJyjE2RxWhX/1LQyTTHJv/qR16SEtNM82PvBWy6Sn7bS4KcIfPAXliZxPLZHRtf2OcjEO3COE0Gf+v5NRRxCf8VxyXZze+M5EfivlEupqlaPKrR7J/frf/scDljAPKrVHvZ73ngL5vyKqYX7S+PvdhmppW4qQ0gdbEl9ryctw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(42606007)(396003)(39830400003)(366004)(186003)(508600001)(5660300002)(6486002)(1076003)(86362001)(66946007)(8676002)(66476007)(26005)(4326008)(66556008)(8936002)(7416002)(107886003)(6506007)(38350700002)(6512007)(2906002)(44832011)(6666004)(2616005)(52116002)(38100700002)(83380400001)(316002)(36756003)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rHT8vabJ+VlGaVcGuVhCOgNSHNW0kzhiKVUVHcogFb55gcCfpWIx5arCBIJM?=
 =?us-ascii?Q?GiGmMxlTLQclbUQtUPeVhvbEKHyilnhIBuNHvQyRaKDPqC4oRcYvi9PXMGxi?=
 =?us-ascii?Q?dkKE1EOQ54jc0/W2+mo/kbCB9PuigqW4ZuknP3laQ/TjHBoBwkH3gl8VyWj1?=
 =?us-ascii?Q?Q8FfYGbBxFDyVS5DKref8pckZssUl7hwRMrznaJLEpT0F8FDfSORC60lNxAu?=
 =?us-ascii?Q?QAA1H1IQmuW6Tj/5EDXzwLtuFQX3sKohEsL2bXRoX5E/fEPmVxqhqKBr1Jph?=
 =?us-ascii?Q?SkV/EvIeUgXE5Gqnkn0+MzLzjqdYA3vcLZJa38sD99pKRv7NoByB8VwJAk4j?=
 =?us-ascii?Q?XLWf6SmvpnNBrBmj776FwAyTi9czLJXHsWcKjbzGOHQ4OHYCvDR+qVTFig8v?=
 =?us-ascii?Q?6J7k89IDPYbqRdZVkPREK6cGt82fmmi2aCvQPHFI/sWyg8w6GLS+ItdL4DCB?=
 =?us-ascii?Q?ARF4yK55hN8CuKrF6Kievdi8+jNRkrNNVrLQ0K3vxflBkmt3LmuK4zxrwAec?=
 =?us-ascii?Q?2fweTrqE1xr4p4b3MOfHUpWzrz3GDFHBNnzXS3SAwA9ZUs/MhFMCPMQcz/nK?=
 =?us-ascii?Q?2tuE+7H1o77ksv8hItv9gWZKx6mfOMtXph16y9uNtBbA9yCGvWuDo84mKYgQ?=
 =?us-ascii?Q?/VcnKytw/f22orYCHjo5KzE6tQrn/mdqa5whj4KKgM+5wpxo9KEC47CksD5m?=
 =?us-ascii?Q?oju0vg99GU6jRPxhYr4bJ7gGEZRXlTFnGFPHR4Bg6DXPkKfyXouulgQ0l5ci?=
 =?us-ascii?Q?zY47sJXNwmGGnTOkfrYEoBACqMC3mL5+S4CwIFU8lacslpBhi5+g0uafKQYI?=
 =?us-ascii?Q?FxG1hI7Ow+te+dw8X/t2VLKQIgvOtVN+qgzInFuHdSIAN0are9K+gmxyXZ7B?=
 =?us-ascii?Q?fA8nrhRN7Cfa5SSyNAUCvcG6rYZajPZCSA38OGliOAsnHcYs03j25Fgjjs7I?=
 =?us-ascii?Q?4hNBcp9yvg+Pdj6LKLw4PXduwSUipM4qG0oF6k+yZtEHDo7T8+UU1lCi4frp?=
 =?us-ascii?Q?eHrTObMSxwIN2A9N+rG9ZgUSGfxdniuwGtpzva2ijTaQ4ZfhmSCkK4INa71M?=
 =?us-ascii?Q?6v8Uztv3b7vbO3QA73h7Q9WRnNECH0Pok9uXOb4VGj3qqOXQNOtC8Pkkmz86?=
 =?us-ascii?Q?pdrnCKIh6w+8KQlEspJ/FfYHCV9AmUigBa8ihBYdjheWawHdbowMqiP1FYdS?=
 =?us-ascii?Q?BLAOaDDLwZ9/YcPZSd7EiXe5xA085pg3VEuOX98/KXtide1UQgmq57tAxy8P?=
 =?us-ascii?Q?f2zX52Zz+iePDHTiYxnlkbq4WO+oK0DGN93c/sd7NW/HEAcaUtWgaRGh5h0l?=
 =?us-ascii?Q?CO7oIdzyUQ1siN6T65MNM+PcgfGasuBTXHimxfSaajiXDUR5sfP9wZl4wUXm?=
 =?us-ascii?Q?jTmlWGpSYdU7MXlrRsK7OSJDQTneOXrgJgWbRN5RDtTsGx75d1+4bA/xNiOZ?=
 =?us-ascii?Q?zAiMUEsLWvH+gcoWeLFHk4Pd/AxfBmN8vWtjG4nJrxliGDRci9aO8R+t34bq?=
 =?us-ascii?Q?ieNP1kIGUyP6mavLUXYK1x2GYfad2BC5H5PgKkTP4RQ3la5j+ti8Qf3z2YYA?=
 =?us-ascii?Q?dzsD9pl9qD0jhQpBHivlyIY4cqfnPXd4hWVpnaZpaR/wr61oQYJ53nROfzZv?=
 =?us-ascii?Q?jhmFY9E4+zzqVTwAgWVhyp7croXOkl76AQEmQZEn4vi05NmEghxIjVbdFlUL?=
 =?us-ascii?Q?JuKtxg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2da4c9f-a659-4668-e9ec-08d9e3731225
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 22:02:41.6104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyGDqQiBbKYwVer159VQTxlVxnDnNluoDqLeQ6bl3SpL9ZHLVKeABvj8x0iFnJP03VzT8WcdZcP+AfUTwnFUr+vTAC8NwW73leW/DsA2PzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a local device *dev in order to not dereference the platform_device
several times throughout the probe function.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
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

