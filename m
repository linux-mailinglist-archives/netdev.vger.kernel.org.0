Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E957A58E9E1
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 11:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiHJJnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 05:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiHJJnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 05:43:41 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2082.outbound.protection.outlook.com [40.107.21.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B5D5005F
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 02:43:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mnx+N5vi2rpiTY/OpGclXlvNb14Bc/F6DatjV2rwbQl2q2m5XXafFunkFj+SNr1GC1G78dgDQF+iz/5iGdwlJJdtOYivWjgpuxw6A5kEdF4CDJU2mfKUtnrQuE6mxWDQlFffv21xldK4V2jsOYCfZiOqkwFbUGQAAdaB5K12oNp1Sq02LmSJCPQt7cWqmiSeKJZPIX7UJvtaltv3NHcoYsWni0gcn+oHSYNvo7NT2N96KrTc00ecxeDd84WcBg87Q0ds/gHWGOvgXdmveeRXh0t7T+D2J9AySCAGMeTMOnPb/CQNVrT7BaWQIi7Ulkq3mOApQwfd6BFqZO22eOuKnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtBs/m/KNZngXmcFqUlVd6781VLBAfrkr/FL7BIArRQ=;
 b=k4VY3G5st81YisIGfA8qWKPYkziRub3nSMNNyjfAZXywgqmVm+XYCcTxd1GjvAnDoYtAHcccuZ9romXZowrbruOi65FhQyLqNK0daFQGTPZR+8NEizXl51smiLnUZkU7pLpmGepDKiyi7RtPiaZO6crxvsZliYYNAIf3ID4zBDdLBg26AffphaMe8H8V+DtUuK7D8RMuisXlQIsf10a1JHQzT01C4a22XxmI5PTe4zcZRBkW97zfsl8gCtB8GepAG12XrFZ/NqWO4WN1cutcUCWArsHUtYpXRJDXxcAXlinvdqm41cLNLevTJAchEOBXgYCesX4WMVc6PjW3c4w7eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtBs/m/KNZngXmcFqUlVd6781VLBAfrkr/FL7BIArRQ=;
 b=CBcoiKOug3gdEmlzo29QEumsSxYNCInV0tjZvIWuDZyMl/8tA8hDTj8rpfSt+nbjLHaj+Rqgk70rhuGPi3XiBz9Ftzzroucws6M4y9IIwJQ0aKGZZ+u0A3LDc2khY2rZditbfhGxqHnA4sYbCTDiYAlwyeImQxlX0h+BaqgLLeQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by HE1PR0401MB2666.eurprd04.prod.outlook.com (2603:10a6:3:86::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 09:43:36 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Wed, 10 Aug 2022
 09:43:36 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     xiaoning.wang@nxp.com
Subject: [PATCH net-next] net: phy: realtek: add support for RTL8821F(D)(I)-VD-CG
Date:   Thu, 11 Aug 2022 03:37:33 +1000
Message-Id: <20220810173733.795897-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0138.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::18) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f99dbace-fa6d-4d91-8ce5-08da7ab4cc15
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2666:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lAvyjoMgnJ5fvfQfuch90rDFR4ROBU/AutE9r4PlCWKJnpnJPbUgJ4H0h5qPAtEPAVSndKg0Eb3ooiSFX3hvB6e4lUg5SOKHdjIUkGHVXHQL2XQ5Yp6HuP4FXCyNWi44a0WTUOpk3J3P6XH6BzzMvuhOZpHmSvp9geIW7s+Fm86RY4yMOUCrKPKEz7beVuL9A+1uSWW0CbCttUIhhDilt+usEPn1tVfuf8O2GBfiG9ru/kbC90bMghKUhKObc+GxkUxv8we2S/cYDAr4TfBPBqQj7ssFZ3o5DDxDa8xYmzEPti/saywUqTJM4ncev2W87WStD9Rt3VsuUe0J7rlki0hjYn0VeZGJfagEreZSUdZEFC15fiBl090iEiB92/SIwZjsqAnNiKiOmU8me//vbe2Xf1CcJe+tC+pbzPToigp/9CcSzND6mkYyVHJnCNJ7tOu3fFxxLDqsRQjuCTNshia80aouDePoDaRiRb6kffp/sSBkDWOumKp2TN6tG9GfdKuXwizEjDGD/As01dinDCnNl/jHnpAdCvmHbS7zZRLOP5KJ5mz86gkaBfpiV40YvqLM3eeIQBm7RWb/Z278vMtS+acbnJtXnW6ou0nHXOOI1LenYy8dNM1Wb4bqDZyPUveL2gejY7sbzwyQLEva/NbT3Pg1IpreMdsO65XU8xpB0Jfr/8D/9+tsBVaDp3V66Dv4IAEi3rfl3iHJ1uohJE83mNsqcd8lsRI3HnAp9Wml081wO4c5QgZOPZ8OqH4ZdLHe67ZCn4iGnWkwu34XU2F7/cu9lJQRRlrn1tnKfck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(83380400001)(186003)(6512007)(9686003)(26005)(4326008)(316002)(1076003)(2616005)(66946007)(66556008)(66476007)(8676002)(36756003)(6666004)(478600001)(2906002)(41300700001)(6506007)(52116002)(38100700002)(8936002)(5660300002)(6486002)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JdjCv3jX9dJUetOJhV2nr57xyxbL79ez4Y4mG5oHjvRMFrL9kyGpX+w/y1wd?=
 =?us-ascii?Q?JAcv0BB5M1Gwvv+7fVjAm6SUPdhtdQxTOxWv6SYC8Z2kXv3h0BHWwnpJPBG6?=
 =?us-ascii?Q?jd5p638oN3dFMSReI0sFLEAMIuFzXkeB/IHndsJQIDLwQ36rSjUUTgtAldCw?=
 =?us-ascii?Q?W2aCSLDGMir0D6smTHwUyJBeibDl7HQitCD+k+n9sO8mt5yMZymYTmWEtM2T?=
 =?us-ascii?Q?Qp5STkUBmaCOCRv8zYbgi7FkQvlYbdWFzWEOho3E0wH4YCz0Ltx+bMHP5wAO?=
 =?us-ascii?Q?auARL9z7JuKpGFFwmxdwt7R6A7ct7+2INcWDQw8ilrEGpvGFtwcswzLKAVao?=
 =?us-ascii?Q?20GS6kxHlwei9bbzJJtDyNbZVRIwt6n9hXJGTK/22NvDjTracDnEkVyceJnN?=
 =?us-ascii?Q?zyfncrv5ZF2NdFf1qp/eHBFpUseZru/OLL+vmD604M0h8mLZcGSGauU1exUJ?=
 =?us-ascii?Q?N7TgIIOaubit/TWrigNnOnWWvCOEVyANp3EtdtcmGNS6sHuA7NtnvwH1S7K7?=
 =?us-ascii?Q?PmfThOrJu7nbxaXrHOHIQD8J0lxfI3eTMck2kYGd7/lCC/BmzjH6hOXWH+0X?=
 =?us-ascii?Q?dcvjPiP1q6uCO4yDuJxkPA/xXDts9BGDmtfl5w5zn4KMaDDeeJX7HeicSncJ?=
 =?us-ascii?Q?ec099cgi2MXnsRww/hs0otHbejxbKW/kjzomaL30kf0MgH93tKxKcKVdU6h2?=
 =?us-ascii?Q?tSYgGoTTyLK0/z3Z8ieLqdIbr73zjsoE6oJambKsee/YmSeFNpnMLWkYXAEV?=
 =?us-ascii?Q?0i/DueSTjFeXB1ZE9f4cyX0SdR1w4yq2cpgrRAcZANIEIjX2sSRXKGnj1PPa?=
 =?us-ascii?Q?l0Go6FRDvV0uXfd6ysoiRrywffQr4XJa5ZuyTFPSV2MENvn5LXABAPQGimoF?=
 =?us-ascii?Q?d6ixXPhPb7V3KxlMKh4WLYh+G0mHq8Is5StsAWDeztBW4ULsVv8mZ6WjD053?=
 =?us-ascii?Q?4NTUEYzxvyBFw1gFNlhEvIYjPSfbC7/+6ghLkWVfMB12YIa4vLc22BIpNybi?=
 =?us-ascii?Q?PvqcQvAEnsdSz2nJXOkBWXayo6Dd1PQkAsMvuKJ7AFB6yq8OIitTKxD8rIzd?=
 =?us-ascii?Q?EhZiJ9SqBdQnkCKk/s4DuWHwgDZjexgns9AgoJt2RoLqyfmZVXZm8A+ck+5P?=
 =?us-ascii?Q?TVTRE8wbfXXHsTYH1xOEzeg9R4OAhKFNNIPkamlK1rwaw6SRhe8a0mD8usUZ?=
 =?us-ascii?Q?bcepvqUjhJuGigpP15vBjk3dOr9eckq70hNW1pOJ7ErhAcJ6WdJmkeFYKIvB?=
 =?us-ascii?Q?Ue1i7nzJWGMdJiCO+Z1gkhYyjBw9t9U9Sc2vIPIoZJq3FWwLr71Wgv5SPb7a?=
 =?us-ascii?Q?RIPLGWCZFHR/W4eF58J1bXVtWUIyt1d03SfyC3DL7FXh8egNTPjUnOIKzma2?=
 =?us-ascii?Q?GZW0YtqeagJtQCWnwCFp055PN6h66WrALVaRBdWj/1+/6BvWge2n+wqGM3HE?=
 =?us-ascii?Q?/Bbfj2MobgkYI89C/Lk7g5+xiUzLssVMYMUGDDaXi0I8Wryarf6xR3kCeSR2?=
 =?us-ascii?Q?A58nM4kEC9kwDoEfvZ5MHtfBE0LWRmtuSKszdJUeGUynEQQ7OYEjbO6ElUHB?=
 =?us-ascii?Q?YtLnL7WLbN1Szi0Q6U+L1yYeBY5aRzTMTi5hSR64?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f99dbace-fa6d-4d91-8ce5-08da7ab4cc15
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 09:43:36.4731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pjsxfL85xUWHxHY3TMQwVMbEedPStQWnCDoaUh2bJzSldunxPpHlp6GckTWzjQtxZTSce3slxzJdbFQmF/4UAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2666
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Clark Wang <xiaoning.wang@nxp.com>

RTL8821F(D)(I)-VD-CG is the pin-to-pin upgrade chip from
RTL8821F(D)(I)-CG.

Add new PHY ID for this chip.
It does not support RTL8211F_PHYCR2 anymore, so remove the w/r operation
of this register.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
 drivers/net/phy/realtek.c | 48 +++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a5671ab896b3..bfde22dc85f5 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -70,6 +70,7 @@
 #define RTLGEN_SPEED_MASK			0x0630
 
 #define RTL_GENERIC_PHYID			0x001cc800
+#define RTL_8211FVD_PHYID			0x001cc878
 
 MODULE_DESCRIPTION("Realtek PHY driver");
 MODULE_AUTHOR("Johnson Leung");
@@ -80,6 +81,11 @@ struct rtl821x_priv {
 	u16 phycr2;
 };
 
+static bool is_rtl8211fvd(u32 phy_id)
+{
+	return phy_id == RTL_8211FVD_PHYID;
+}
+
 static int rtl821x_read_page(struct phy_device *phydev)
 {
 	return __phy_read(phydev, RTL821x_PAGE_SELECT);
@@ -94,6 +100,7 @@ static int rtl821x_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct rtl821x_priv *priv;
+	u32 phy_id = phydev->drv->phy_id;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -108,13 +115,15 @@ static int rtl821x_probe(struct phy_device *phydev)
 	if (of_property_read_bool(dev->of_node, "realtek,aldps-enable"))
 		priv->phycr1 |= RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF;
 
-	ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
-	if (ret < 0)
-		return ret;
+	if (!is_rtl8211fvd(phy_id)) {
+		ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
+		if (ret < 0)
+			return ret;
 
-	priv->phycr2 = ret & RTL8211F_CLKOUT_EN;
-	if (of_property_read_bool(dev->of_node, "realtek,clkout-disable"))
-		priv->phycr2 &= ~RTL8211F_CLKOUT_EN;
+		priv->phycr2 = ret & RTL8211F_CLKOUT_EN;
+		if (of_property_read_bool(dev->of_node, "realtek,clkout-disable"))
+			priv->phycr2 &= ~RTL8211F_CLKOUT_EN;
+	}
 
 	phydev->priv = priv;
 
@@ -333,6 +342,7 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 {
 	struct rtl821x_priv *priv = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
+	u32 phy_id = phydev->drv->phy_id;
 	u16 val_txdly, val_rxdly;
 	int ret;
 
@@ -400,12 +410,14 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 			val_rxdly ? "enabled" : "disabled");
 	}
 
-	ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
-			       RTL8211F_CLKOUT_EN, priv->phycr2);
-	if (ret < 0) {
-		dev_err(dev, "clkout configuration failed: %pe\n",
-			ERR_PTR(ret));
-		return ret;
+	if (!is_rtl8211fvd(phy_id)) {
+		ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
+				       RTL8211F_CLKOUT_EN, priv->phycr2);
+		if (ret < 0) {
+			dev_err(dev, "clkout configuration failed: %pe\n",
+				ERR_PTR(ret));
+			return ret;
+		}
 	}
 
 	return genphy_soft_reset(phydev);
@@ -923,6 +935,18 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+	}, {
+		PHY_ID_MATCH_EXACT(RTL_8211FVD_PHYID),
+		.name		= "RTL8211F-VD Gigabit Ethernet",
+		.probe		= rtl821x_probe,
+		.config_init	= &rtl8211f_config_init,
+		.read_status	= rtlgen_read_status,
+		.config_intr	= &rtl8211f_config_intr,
+		.handle_interrupt = rtl8211f_handle_interrupt,
+		.suspend	= genphy_suspend,
+		.resume		= rtl821x_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		.name		= "Generic FE-GE Realtek PHY",
 		.match_phy_device = rtlgen_match_phy_device,
-- 
2.25.1

