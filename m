Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327CB396FD7
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 11:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhFAJGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:06:33 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:14338
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233471AbhFAJGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 05:06:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J60N58cssqRoqzFlCTcR8z0ZMDZ2g0B0m/uQuqtoyK3B+X79F+J+9qVNqNZSTEJsvveJ+87XAogO1yCxA8Yn3oAFAXPQHVT3I8cdWk9j9oyGNZW+6Jd6bvHrl9TtBB99fOZlJnmGa8SjAWyDkx5gacFiw27pBvjqtRQN+VbU2XG8WwlF2Te0AoboRU6U1mjJPPYKgbd5Ycw7Ck10vUtWeNXe/S0P1bHPcrjgNd9m8ktFlofUEa4fx5ULXbpT95jAwIcRKBONcUqO3dP5dM3qhWSwBGHkuwqibwXe6hPpemRZRik84mSWIvvBbOncMZevS+QgXMYTZMUPfnXPG68G3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ON6dpJK41vOHU8NGiLseCfVJlUhKCk3AlgZE0tkPxwY=;
 b=bcTUWFAJUyQoaa2yUri0oQkbFroz6x9vnUUTR3QRFVAGe7vKhLzEexJehrPk6kYFnudW5mxaRN1cmLQRbK8wYZHU0p5fwpTw5+NSp/71MHesN9l0XLptf0gZAD/I7uTBV7RNNhoJNaUQhVdf4xrbLkmjDoF/B7qU0vRl48bABQs9BrgZA5czBhPM52VJYaRBaKYAvyRti0cfomWXJyK31+xW6IY2+VAi0V0Iz7wmQiOBWLX7PR2thLqZmN+PTtpILj3ediIL4Wq5RTamBH9G5ttNlysTi+nBomKJcefeQc5Z1H8PvISualLkfu2w59SfoNiqZzQGqpRsMP/5CckZyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ON6dpJK41vOHU8NGiLseCfVJlUhKCk3AlgZE0tkPxwY=;
 b=l4kwJbKw3J5cTDltq5SJiGujdmP1+nvZEvCQEtSpgAhAIbRrHWYi9HE+ihtaIWrEOyHVOXQ11dwDTimyqxuwO+hEkUBfUgcjgr5bn54uycWBFCJnKXDauhuDLm11iBPnFk/T/vRlD3M8CpxN2zao4DiLfyxBeDD02oO0+JL1Bic=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Tue, 1 Jun
 2021 09:04:47 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 09:04:47 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: phy: realtek: add dt property to disable CLKOUT clock
Date:   Tue,  1 Jun 2021 17:04:06 +0800
Message-Id: <20210601090408.22025-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 09:04:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2479ff7-ea76-4c03-57ef-08d924dc4e07
X-MS-TrafficTypeDiagnostic: DB8PR04MB6795:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB679512C663B9AE88F0E6A679E63E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/4j6A4BfL7Tw4+0KC9TbxGyE30yrC5XEfmOzlvx+r9HMuRUCp2B8Ud/GDlqMsK4Bv4YW6J9eFDwywCwVKMvoDfgjkBvUbKgfLky15XthWFWaCGtzp/fe8/JY1sL8VHqM9+wZLa5Rt/hVytzYWLn9OBejQtcrCu98wCR2pEqjenG3Uml81faU2td8/1JUifZ9S3Y3nRvQX++w+pRfRfBXhP63fBGc5gU5jAc8mNbEgazaxoIm2U3NCXFJQCF4Jgf1g5xnGnCqLc+LTt4r+mbB2/YA5Pn+qYuVQCATgZw76cpa7Y0dhQQeOihf5RfFata10q5ktWS2jk9af/XbWxEaxMEyRUt4UjgD7qsi6+iXomo/s3Hjq2l7w6lF8S/Uw1survkYqxKPXYgJZB65E2sBDgJu2TGY9Ci8JgO6+Ta6Y4QixEvpVuFLW8P39PodthpYuikFFeclaubp90LqOh5LgEGL5rNpuyyR0muGGOoQhB0xdUc6Rw3z1K1WI5Rw+W2cbqpMqCNAt6d1847HM/aFpk/w45h6g7B7PnHCJzy9HeUfxDLO95DZswJJ3+G4es2tL1Uc+Z+thdPqCXfk2/Xez5S82yWjpLuREWxOAx68kVgPhddPOa4vhxQK49wfGSU8WuIZ8wMDjIEG+r/gDDk2EyhC6/ZAABId5PM9SK+yDdphQoi6c16aBo7WCFjUVw9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(66946007)(38350700002)(8936002)(478600001)(6666004)(36756003)(2616005)(52116002)(6506007)(2906002)(316002)(86362001)(16526019)(6486002)(186003)(956004)(38100700002)(5660300002)(6512007)(83380400001)(26005)(1076003)(66556008)(7416002)(8676002)(4326008)(66476007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dgolh76/4oeI86TcCl/xCNJZHQxyYq1ngtwB3n7Ucuun+D89ZzRR8dTFAb3H?=
 =?us-ascii?Q?2ZvsJ9v/1jOY50yYwiUTTweqof1vMAHsvWmoIoBGtdImwkjMRHMcG828Bv7j?=
 =?us-ascii?Q?VhBV5gs22k2s+vaE289BewvGI2JpWx5Hyf9hpFYkiSekYAeFP/V3CULE6YI8?=
 =?us-ascii?Q?/rP//OTj/zJME0yc+m0GrFwWCZYAfpEURSlR+AEb6It4hrOVSwyn+vdItFOL?=
 =?us-ascii?Q?TlcdaCrR15RWfsFkPzgRP7cd7TG6D5jcdQG9TDq/NWjFNYmERN11uzeP817R?=
 =?us-ascii?Q?emzWeuANPkEOQ3mHZ7wpr6sBuHqx88bA9Ei0VNYBHpeXiwEot39KeMt+1kBp?=
 =?us-ascii?Q?w6PcAcCukeE90aMtTjm6vmKpWJLEQZ1ANnEAn8K0y2ighsM9/8AwVBRo+bb5?=
 =?us-ascii?Q?miXu58ooiYsEiHwn1YYCd/nn4u1cs9vuP8Ji65P69LpM0dEsNXf4NGY1hHcq?=
 =?us-ascii?Q?aHGZfVizvlcotArD/aDOhNJbddM9mBlquA27Ywv4PhYdPko3NA76zilLv+Pr?=
 =?us-ascii?Q?yr4RsIYk9q1atnlNxeYb/Tnh2gEZuyfzVZOVLtE0RvjT+fZlN0Z7pPb/hXaL?=
 =?us-ascii?Q?ye5tu61TtvlOafYDzJxfnLuX8z7I6SxujMqTmj7CQdfXAJnHG1SM7nkoCzuh?=
 =?us-ascii?Q?pNBMihltpXP0h9JRjPKgBlBx4C511eoIQrOMUFxMRJswLwiRjfr2jti4X2ZC?=
 =?us-ascii?Q?xy+XY5dUi/ZP4/UhZG7RebeR1/4h/dRsLoAAr72WGr4Bq3YJi6uLrrRjweYa?=
 =?us-ascii?Q?Vy2ODDwucOKV2ctodJygCnCvIdQkvk3brRPysmDCj95UUovKfKF3uhdlb0Wc?=
 =?us-ascii?Q?xoTPxkZag/QMzmUpjsEu/P/JexKSYjPHuKqUKq7uYt8hW+0h24Ea7mqbpQgL?=
 =?us-ascii?Q?2sHH9bvcPQe3eivmsmAQTrS+kOqt8i1xQ3N9v63ixXaZwZlLhTS8lb7nfIHU?=
 =?us-ascii?Q?7FLq8rsfCPWckpDaOeW7hNFutLgFYfB1v0SOTTDO5eo5rlw0k1GQZTwcGiDP?=
 =?us-ascii?Q?A4LvCxpTkWAyHx40KPgmDY+GGifiYuJov8YqmcII7wSDaMnNBaxyxgUE2aA/?=
 =?us-ascii?Q?Bx9yNDEtVSQcPNQffS0pb10pFqpL2zRRM5c6KU9HZwjnoYId1/uVknMgKPUb?=
 =?us-ascii?Q?ZmkE/9FfbNxS8Uj7Vw8J+9BgUfVrwLKDT2Pqd2fP+YK2hBKxV9gxJVKya6Gi?=
 =?us-ascii?Q?jgVjNp0uPZXbhZSbnD68CCkRncGz/+lery2TzuI8JjZnTPiwKvI/T2jk9ORF?=
 =?us-ascii?Q?eSUA4qC3LKY+Av05MOhnscd8v6GH+Wlz5NSEPUYP4ZJAS+XTE8uaRc3uKE59?=
 =?us-ascii?Q?IiZKppTQkaEj1kUI19tEtyZh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2479ff7-ea76-4c03-57ef-08d924dc4e07
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 09:04:47.1927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MTeOzaHRAGCCViVVSPWDPKgcXsTPkN/LjwPZUTl+s0VVVXC1sqGUp5B22cbRMVJYVsGsKzmYCvwjWsQripvqgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add "rtl821x,clkout-disable" property for user to disable CLKOUT clock
to save PHY power.

Per RTL8211F guide, a PHY reset should be issued after setting these
bits in PHYCR2 register. After this patch, CLKOUT clock output to be
disabled.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/phy/realtek.c | 48 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 821e85a97367..4219c23ff2b0 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -8,6 +8,7 @@
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
  */
 #include <linux/bitops.h>
+#include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -27,6 +28,7 @@
 #define RTL821x_PAGE_SELECT			0x1f
 
 #define RTL8211F_PHYCR1				0x18
+#define RTL8211F_PHYCR2				0x19
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
@@ -40,6 +42,8 @@
 #define RTL8211E_TX_DELAY			BIT(12)
 #define RTL8211E_RX_DELAY			BIT(11)
 
+#define RTL8211F_CLKOUT_EN			BIT(0)
+
 #define RTL8201F_ISR				0x1e
 #define RTL8201F_ISR_ANERR			BIT(15)
 #define RTL8201F_ISR_DUPLEX			BIT(13)
@@ -67,10 +71,17 @@
 
 #define RTL_GENERIC_PHYID			0x001cc800
 
+/* quirks for realtek phy */
+#define RTL821X_CLKOUT_DISABLE_FEATURE		BIT(0)
+
 MODULE_DESCRIPTION("Realtek PHY driver");
 MODULE_AUTHOR("Johnson Leung");
 MODULE_LICENSE("GPL");
 
+struct rtl821x_priv {
+	u32 quirks;
+};
+
 static int rtl821x_read_page(struct phy_device *phydev)
 {
 	return __phy_read(phydev, RTL821x_PAGE_SELECT);
@@ -81,6 +92,23 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
 	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
 }
 
+static int rtl821x_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct rtl821x_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	if (of_property_read_bool(dev->of_node, "rtl821x,clkout-disable"))
+		priv->quirks |= RTL821X_CLKOUT_DISABLE_FEATURE;
+
+	phydev->priv = priv;
+
+	return 0;
+}
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -291,6 +319,7 @@ static int rtl8211c_config_init(struct phy_device *phydev)
 
 static int rtl8211f_config_init(struct phy_device *phydev)
 {
+	struct rtl821x_priv *priv = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
 	u16 val_txdly, val_rxdly;
 	u16 val;
@@ -354,7 +383,23 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 			val_rxdly ? "enabled" : "disabled");
 	}
 
-	return 0;
+	if (priv->quirks & RTL821X_CLKOUT_DISABLE_FEATURE) {
+		ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
+				       RTL8211F_CLKOUT_EN, 0);
+		if (ret < 0) {
+			dev_err(&phydev->mdio.dev, "clkout disable failed\n");
+			return ret;
+		}
+	} else {
+		ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
+				       RTL8211F_CLKOUT_EN, RTL8211F_CLKOUT_EN);
+		if (ret < 0) {
+			dev_err(&phydev->mdio.dev, "clkout enable failed\n");
+			return ret;
+		}
+	}
+
+	return genphy_soft_reset(phydev);
 }
 
 static int rtl8211e_config_init(struct phy_device *phydev)
@@ -847,6 +892,7 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc916),
 		.name		= "RTL8211F Gigabit Ethernet",
+		.probe		= rtl821x_probe,
 		.config_init	= &rtl8211f_config_init,
 		.read_status	= rtlgen_read_status,
 		.config_intr	= &rtl8211f_config_intr,
-- 
2.17.1

