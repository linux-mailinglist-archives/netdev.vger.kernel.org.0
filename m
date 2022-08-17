Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F905966D1
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 03:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbiHQBgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 21:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238243AbiHQBgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 21:36:09 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2087.outbound.protection.outlook.com [40.107.21.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D216494EC0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 18:36:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N24C0p9W4RyMquAjW+VJtCiRPDn0Y89Asl/8ZiqD2EU/HM5mw2Vqc5aR1nkb4VI5GRefcUlY3P2/CHBqO2xqPYUKaA9BneGp4wNCcIqbKI7XrlHPZ2JmO8sV8ReAy5IQFKviMIByMZ07W2PvSFEkNXSSjt+kdPBjddWmbg5ZkHrxvIIQS8GFtF8FCAvSjdMJo63jGcHLghXS+BuaANqxJmRZYUyNSd7mS+AMQeBBGGvWvhXl/Ib8MHkYkbkBOj+PkQQjSQ7aqOSR4StmXuVQZ4tx56/LO+BGTKNPr0UMSB24uRht9iojcqAZ8gx69PWritQte90HL/8gUKDhWeVT9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EddYXmpLiMVmYRWpO3miwl6V5YmvNebT34II9DhIRik=;
 b=oa95kZ9IfwCl/wFJOWwWjbfiwmufcQ0lSLm4A2mwX1VhjsIUZSBSN03K9zxW5dnFuO4gWaWRQrn6PqrP0P/NofhE3JrlrJnTeXgcYRZKjUOa2bLgy7ayixMUb9UgfBABxmbbM7kkBs0zi/MUkNljmW+xX0dYKXuzaAt9oYrIcuLVZfSKTVf85F4MrIlWewmeOUH46/Of6PNsP7FO+rPWT2pC60A4yc+klhWKQBI1YDk9aimwso90pzgqSX8U2ALV6cBWriaePBxZUxdvBwidmlrtAcxRtVKGixxngcPvOi6ak6oF85/9N2R8+ihKyC3X9Zu58UebpGSazAO/1CyYtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EddYXmpLiMVmYRWpO3miwl6V5YmvNebT34II9DhIRik=;
 b=sarf0eYrc7eI7ubZe0OMqyKISdQuczktWCoxYuZEod6rbOwUjpPqdNWgCEotGszm7U83um4bYstGj6/4ZFqgwqxxudePc5h9IRQWiRMBpaQst67BT33Y0FdzA0Zns6ZDs1Fw0w95j0kHjou3CMlIUt5kcw80cCnBqnpPkaKOg8c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by PR3PR04MB7434.eurprd04.prod.outlook.com (2603:10a6:102:8e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 01:36:06 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Wed, 17 Aug 2022
 01:36:06 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     xiaoning.wang@nxp.com
Subject: [PATCH V3 net-next] net: phy: realtek: add support for RTL8211F(D)(I)-VD-CG
Date:   Wed, 17 Aug 2022 09:36:18 +0800
Message-Id: <20220817013618.6803-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 953ca136-980d-41fb-b3c9-08da7ff0da5c
X-MS-TrafficTypeDiagnostic: PR3PR04MB7434:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vE8+AwvcFxbiAUMZBEWemCh2DYUqPBb2PsURfKrUExXO9td8QRMX2bkQ0c2CTycAhpFdaVo3b73hvrBLe2MCU+Ql4V9WCEkeZnQw+4x/dyrqSfSdiAWJNxkjkWeloHZt2xylphzc88huLK+4kxn+msM9YK9gK5IkAq83xMLmZAHNlsfde/hpDTIkNMcOzh8FSjMx9szVRQSEkOehJ43mXrVP16Q+Uyw+bhh3srcbvNCIueLqX3ddq9irAFg/VkmeAw7GyT0mfmrN77c8fydaWyxzYHmNQydT08OyhsO4fRMhtqlMPdMP5kRCtmg7etVVNp63EjBa5c7BCe4zi1OPb/OV5NQehSzcDred02R+8uQ74NmoGtL6BZ2R/1kGCJnV4GCy4MTPwttHBtG/LRvGgCijZAXmbJqeY4I4FHBXaZwWtWULG6RrF3oz/J3x2lDmKphcdta6Y8EI6A/pBZxSld0m/p3kfkR8vB4jqUEcPwS1GQ0i7WKnBneTAWeMo3kzKwE3Cxj3QuFpxBwbmnTsBXkW4jqzaFUyTJTF57Edt3rb7PicbZ9zFzNlKDNj7D9Sz13pkyQKDwPUuWHvnOotLuFOOKrvQVU6hZZO7k/CqpEcz9vemw1vAIOgrDRg0cMaohUq3S2VgOPb+4NVQQ38KcetWCoFBlNRq/fJJMAf6oriIPHHDGNnmnms8de4VnfwjWSNsBIBIZAVezD2fv9EALtbD5pdIZsTRqA+ZfuDRcYOoC8eLH60QNn/Kt/Wh3vLVHku3M80NBgnwnzwmix4JTbXBHUNHlGxV4kkYcpJGKA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(41300700001)(52116002)(83380400001)(316002)(9686003)(5660300002)(26005)(2616005)(1076003)(6666004)(186003)(6512007)(6506007)(6486002)(36756003)(478600001)(66476007)(8676002)(66556008)(66946007)(4326008)(38350700002)(86362001)(2906002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2zCyDahgeS/IS0F0975r3rag+z4hhlBooGfNqMSY4fk2UhjTZRUVRcPC1EsS?=
 =?us-ascii?Q?AANXnSni2Ux1Qc1vXN0pi9PpcUsYSSOCSl7eAZsAnUbUqlfA4t3D+eNTFnIk?=
 =?us-ascii?Q?MtgnuvbXrrrBnouXp8jfC/MMPsm73oZrFF5gQg8rNmmQ1LrE+E6rHhb16lNa?=
 =?us-ascii?Q?A8QeZXokrgpRf/DugDij3u3No+F1CRxIDMoPqB9fHOzXKmp7xwfzQW/HEF6d?=
 =?us-ascii?Q?he14ykk3ZPfUsS/Xl3zD63ASDPGVQJNLiqlzXzNUAZTKYI4P8A8xhDRRyzco?=
 =?us-ascii?Q?VQx6PPg8OtQ8OKAk76M3R1lFornKEylV7Y8KmmGE/owK8Mx1RGcW2PcbP39o?=
 =?us-ascii?Q?/8N1yjvvYiaAWy768C5i0MeXb+hJJD+bDDrZ2xaMw1sxMgGU0nwOfAOSRwp/?=
 =?us-ascii?Q?I3BQF8HFbgwLxmxb/eeXC7umjCy/56lQTeoEhXikohPYyJidXOFat+jogdxj?=
 =?us-ascii?Q?3K2xIUc8Q7VHYwuOvmh9blND2vrzWmTBU1niuNK8emBrsVt8tt6QaA71ATUS?=
 =?us-ascii?Q?MmD5QghjE+lGpkVnzUG3E3e9cn11bDWcXtQR3KH+oSldx85MSXyGcTYoL7/S?=
 =?us-ascii?Q?xckZuIgrX7TkWCtgeVh0qeNun8KbyPWxy7KbzeSixskgADredYRsRX20uYFg?=
 =?us-ascii?Q?2pKV2qQy/gfrjMI/0cXOqz3iKMwk84vAuIw0EEigMSG7QWRIw2yMkPISVQdT?=
 =?us-ascii?Q?biDqip1Kkr1wHw7XO2t10r4XDi3tIzF5Pj3Wko+lux6qPHFK84EHiPnUA2Sw?=
 =?us-ascii?Q?RIzo6sxSK9mHQGeVsyF6EUjAy+zbUG5nB8Vg/VD2Q4eVXgboCWzc1sIifqqt?=
 =?us-ascii?Q?xr6nnXsmI0tOP9f1LdsBcTwEbEgMyfuT9ZCRamds/aU3luPNDxc/5PnT9gHZ?=
 =?us-ascii?Q?mYavCLbH6lCUqzsvwrZEVcQR/wnTBgXUZUt1x3NwcWZ1ijHrzsV8Quy8027B?=
 =?us-ascii?Q?vC9UYySQ50NJ7uonhIH2t2VYmxsZxeeYKdkxCRB34A9Zts3KwVx5SeVCHv+k?=
 =?us-ascii?Q?bdGDxK3/cuyoktYdfvLe8AD/NyQFbR+VaOqGLwAMMhHQj9MLj29sWd/RuesN?=
 =?us-ascii?Q?rYySG1Q/uPw/ETb8xWDzG12xCqiUNwuoSF160N3u6q9ofYUU+6j8R13MPYYA?=
 =?us-ascii?Q?z1TSIkpPmaJ4ga4W9t9v6SyXW3oyz9J2eb7L//oPA+SuiNykQOW/EnbebjDw?=
 =?us-ascii?Q?G3U7yagYf77sczwkTw411i/zJyvuwd25/ojy7WkQE63BG6WmGihOeXZaJe43?=
 =?us-ascii?Q?VkIf1MLML80rqKctnk4w5xXsT0p0Rg9eFhcx7Ycvbxv3kpTG1JbQc1YmSCiL?=
 =?us-ascii?Q?VHLLkS+bnU6wsfoVq0j7ySoW5hXAGTBQ3+O6Ko/BcO5H2LQcxoLeqt13G8ZN?=
 =?us-ascii?Q?btGG/Vo8YOmvxG3KzrOeSVS1cEv9VWm5eVSjkR2iDfoQI57Xaa+si0nrc9ZJ?=
 =?us-ascii?Q?CUIdtyKFM6hBxSeaSThfaBxZeLaWUn47aMl9K7+n1zwsw6IORdFhgvZ7shp+?=
 =?us-ascii?Q?pQQX+GlIYWT5lEGUNnSe+uvRV/KKW29ByAWNyGaMptbAC2wSeGsJB5jemFDH?=
 =?us-ascii?Q?WLuCoq7Q8kLi9wHPHVLJ66Toeef/l5iOK4q3foos?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 953ca136-980d-41fb-b3c9-08da7ff0da5c
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 01:36:06.2181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HIsQez6kdCHkt5NFA8pcB9vADi5VF912IKisrmACIgDzlP/58v3UwSgQzgJUDfSauHCB3EUABkEky7dMKgai7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7434
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Clark Wang <xiaoning.wang@nxp.com>

RTL8211F(D)(I)-VD-CG is the pin-to-pin upgrade chip from
RTL8211F(D)(I)-CG.

Add new PHY ID for this chip.
It does not support RTL8211F_PHYCR2 anymore, so remove the w/r operation
of this register.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
1. Commit message changed, RTL8221 instead of RTL8821.
2. Add has_phycr2 to struct rtl821x_priv.
V3 change:
There is a typo, actually the phy chip is RTL8211, So I correct it in
the coommit message and subject.
---
 drivers/net/phy/realtek.c | 44 ++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a5671ab896b3..3d99fd6664d7 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -70,6 +70,7 @@
 #define RTLGEN_SPEED_MASK			0x0630
 
 #define RTL_GENERIC_PHYID			0x001cc800
+#define RTL_8211FVD_PHYID			0x001cc878
 
 MODULE_DESCRIPTION("Realtek PHY driver");
 MODULE_AUTHOR("Johnson Leung");
@@ -78,6 +79,7 @@ MODULE_LICENSE("GPL");
 struct rtl821x_priv {
 	u16 phycr1;
 	u16 phycr2;
+	bool has_phycr2;
 };
 
 static int rtl821x_read_page(struct phy_device *phydev)
@@ -94,6 +96,7 @@ static int rtl821x_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct rtl821x_priv *priv;
+	u32 phy_id = phydev->drv->phy_id;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -108,13 +111,16 @@ static int rtl821x_probe(struct phy_device *phydev)
 	if (of_property_read_bool(dev->of_node, "realtek,aldps-enable"))
 		priv->phycr1 |= RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF;
 
-	ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
-	if (ret < 0)
-		return ret;
+	priv->has_phycr2 = !(phy_id == RTL_8211FVD_PHYID);
+	if (priv->has_phycr2) {
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
 
@@ -400,12 +406,14 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 			val_rxdly ? "enabled" : "disabled");
 	}
 
-	ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
-			       RTL8211F_CLKOUT_EN, priv->phycr2);
-	if (ret < 0) {
-		dev_err(dev, "clkout configuration failed: %pe\n",
-			ERR_PTR(ret));
-		return ret;
+	if (priv->has_phycr2) {
+		ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
+				       RTL8211F_CLKOUT_EN, priv->phycr2);
+		if (ret < 0) {
+			dev_err(dev, "clkout configuration failed: %pe\n",
+				ERR_PTR(ret));
+			return ret;
+		}
 	}
 
 	return genphy_soft_reset(phydev);
@@ -923,6 +931,18 @@ static struct phy_driver realtek_drvs[] = {
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

