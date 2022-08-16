Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA2E595B3F
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 14:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbiHPMGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 08:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbiHPMFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 08:05:55 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140089.outbound.protection.outlook.com [40.107.14.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2376391
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 04:55:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CU4KCXZEIaqA+cjf+rWrjL2KQ2sUGNqJ54qaIzMAtVIshApD4OiCLXyq9tQdAv95O7cAn3D3tlvlSofBgoKW51ohQkguZZmtZD2JoT7XdivoKMA8JeozOYHeaHE94tcMy/wm/tqhaBmIsbRYFuzgV4+qEDft+E5+n3EcHS9yAzCKdybHlre79m08D2uk5aGfFkLvkPhdcopGCEolHel/d6VVRhsXpl6NGg0ujZrVFgxIagH8FkoUmzKQNnoZSA4IIj0dNBUvDovaYGZEDx+KLzACUZz6gXeLS1IwtzD2guThFloBg9eSrR1UZ7HQ7qdOga+ocJgZ0jy34piW2sN13Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUoJRjnehEDGGEAYaUOKR1vlLjacuk3kEschBPcJlFw=;
 b=EAmxj5nU/HBkfN7I21ib7H3KXe9mQcetsbdgk3MkbS0JuwngL76SEtyEnm0XeRsgSx+YhpO6zVMlUMXnl62QuPVaUlizDAZSg+7TNKYc3sDKhe+N1qhRRfF9A7OE3E6N/T85lojUL5f3ExYQWEaSyomc/8kpCPXkIQ5lP+D3s58i7/2mCR9KHcHy72ZoZ7sspYfjbaCJiA594/RkZbe5cneQmJvaMCutDpnuyMLB50PY66IkJDZKVv/dAi2foY2qFWfRsCMkAqvafbi4GjdTY5Uwq7SXZ4NVQuAMioOZ4Ed1WlbLbMFp2ItfSSvle6zbzG5pQtvYhszcKETvbNKqlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUoJRjnehEDGGEAYaUOKR1vlLjacuk3kEschBPcJlFw=;
 b=N+U9HqHkfNqpTVwsRbQerIxfTlJyNjYLxqH7Pa59g764WsCRtSwnDnfFO5rNkvPVUHV04UJMA9aKP3Zl9SFfVRKbeQbge5PslKSyc6xMb0VHxsixQL8agP8znZ+4Okb8dp7oTWwO8hV7/FgX19XLotUAJJ1uhfeaT13XWc2UHSo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM6PR04MB6005.eurprd04.prod.outlook.com (2603:10a6:20b:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 11:55:28 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Tue, 16 Aug 2022
 11:55:28 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     xiaoning.wang@nxp.com
Subject: [PATCH V2 net-next] net: phy: realtek: add support for RTL8221F(D)(I)-VD-CG
Date:   Wed, 17 Aug 2022 05:48:59 +1000
Message-Id: <20220816194859.2369-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0111.apcprd02.prod.outlook.com
 (2603:1096:4:92::27) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2422692-2752-45eb-bbdd-08da7f7e3659
X-MS-TrafficTypeDiagnostic: AM6PR04MB6005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ocrX0puHls7qABoVmX/gawXOzJY7XuhPtF0fHSRWR8CF7dYRRVeYKEhGC2XSy1COBXxBq9n83Tm9of4R1Dq1IkLSNoArUx4dqxSXvlDl5wF42G2Elba7tapx+lVYxpmfVCvCrYMVBDW82GfMcenjfam3Inodv+NopLiz6f4Q9QDkQNP9hlvz6NdZTfNZJ5nOjZLwoWC/g3Yy/f5gGF1dJdBrs4J6r9nCgLg2RLumN22bmQg/wWzoj6qbmOdVhKceDr9NCO6+DDGrq/Q0eKvcVkGlK/IqnqDHAjOfufoDVViQVUAWi6fGIPrB5rYBd1atY25tzbdxUfR2c74JD03YBH0Jy2jn6W7oy3kCrN+ID1P13SuVPY6DCsB5qumcYuWqtfRCwikchQMdpdtvM83J/92vNmcVog4zxrKyriZNNy/oNMEGNENJnUycKkEsuOXK1GAUV0bbVmGfGUlnv7pMRPKxK+/HeK/ldKByKfxnc2H4K6TKTvzSfAcgGeC3WYzHdzI1rvfWot2dvaQeJVcSrs/EVOuv+iQrK2iehm/hOSGDGeorFXHGjXHCYDyWbdhFJvpYebnxcaHpv+wRmuCazhQO8unphwa2oqsQJaSG3vz+ovZ5ocima0IRQ1dLU67oUyIv5jRt5U8wWKtpGI7ZfkOY5YFngYuFWfzEvve1KNtXW1WrJv3rd5WnWPHJzLGRugqeCJHaaa4xcp/X3zPYkBn/QgDJOixLomhsymiWRpKR94w/S4NHqXwbrT7whue6QDqprqFEZxnuDWyIS0ktRxhHFlJ9hsUW/WX+CKctgDs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(186003)(38100700002)(36756003)(26005)(38350700002)(86362001)(52116002)(6666004)(6506007)(9686003)(1076003)(6512007)(2616005)(4326008)(83380400001)(41300700001)(478600001)(6486002)(66946007)(5660300002)(316002)(2906002)(66556008)(8676002)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fJjj+jk3cgStffwButS3cvaLwGGKJ+iS7Yd6ayDDmrrf4QrR0R9CZUJrOAAD?=
 =?us-ascii?Q?q4SbbqZezudBEH9/lcxk/Dsyf/2Smzz8p2EykPr2IvshLmbdXjDh/X6eMeNO?=
 =?us-ascii?Q?rakde+1dbQowr95KgMRXBrxd7ujGUtV9usKOit3bjzjbvFSRU55NWE5QzMDb?=
 =?us-ascii?Q?XRLCAA6P/RpMzsgcb9CCsL7O638sYs5i8XrW6CdhckFhf2F0+6hhYzKK+i7D?=
 =?us-ascii?Q?AzW9HqK/Cwwewq0SoMFr1COLao5NFg9NcjIijLUa7zs0A968dnTz2HphdX4B?=
 =?us-ascii?Q?N+XWxyEyemVnYIxmsi36rQtVLIRoZa9v/ZER6BgzCtobTaM2gOPazPaEb5+2?=
 =?us-ascii?Q?keiY1IVPHOhIASjC/ylZVa6dbu7i2osPBt5KCdSaXFWCMsA6B+pEvowusOMH?=
 =?us-ascii?Q?Kc2kSQU8pBueD/YcEbaysDXiCtLyhxPbZMbnGzHz1DNtjYsjEkYzfJ7PD4BV?=
 =?us-ascii?Q?Rk2H/WiURuwTQix7ATJQ5sZvkZ5DvzOUUSxqj5WbiVbbZhKsjv3GfePcY7pz?=
 =?us-ascii?Q?dLcJtRk5WYMQcy95zJu8hFurk1SrRj0GmQSNKTa3ic9A8R8RLoxC8Akn8z9E?=
 =?us-ascii?Q?+I90M3R20RB6fRPRb9qZTrvEV7nxe/Aodl8EN5gk2fF5bn8DforamgLmlQ3c?=
 =?us-ascii?Q?QhzTYmLRuLo5pXRj6Y7w+jqhQP0DnLm+mgLV+ASAeLTxbjefa+uu38cNBuQo?=
 =?us-ascii?Q?JEvCphPeymn8GTBqIhCk6VmUGru0rgeIL84EMTn8oP8F6P/S/Z4RYEH4eukf?=
 =?us-ascii?Q?2m2TeaMnljRmJlvLzBUAPzhyOXYWLmsxe1IZeNFNNWcprDPh2h+rXGwerXoT?=
 =?us-ascii?Q?Fq3eCum14ymzIsqu5We53lZvxILu9fkUb1qAgGm1iPlGxOoNwkCG7iYsxlW4?=
 =?us-ascii?Q?gXll7Or9UTbeNTHhrTOUkX7dSelO4AxX7xjBKeAdTBawe5TwlHyAoCtm8Doi?=
 =?us-ascii?Q?+m2dj1+MXgJgHMdO58PoCKqs0wL8wqOhWEg+dZenHTOZVTNpTROf4e1tq6L5?=
 =?us-ascii?Q?VUTVtgMp7tDm5DcJuZbmHYPCmMMuHNSEVWnFZ1OjMTJR+rzkXQmnezNIIpZH?=
 =?us-ascii?Q?lL/67/2TuodfOMTZXNd/9PlgATEbZb8gE+Qo1KC8U/SJDJ/6Ip0uPwcHkfZy?=
 =?us-ascii?Q?l7Aa38Fe9pnXiPQIT1oopVtvtX8Ud4NGCMJZElLsvSTtQ3L/feiGMoME1X7j?=
 =?us-ascii?Q?ozK/shc9FOeR2iaazn17gvfsExejrztZYCU5Q54dvrPXj9KQC+BfbsO6V57Z?=
 =?us-ascii?Q?68TL+dVwOzRpm1sakYfBR26890av7UYoaDUd7zE351efnmZOFcGJMlIRA9UD?=
 =?us-ascii?Q?ueaS+0WkhKL0RiXLnGGLnAK8nlB2N2udBjzuoZom45OJX8pVAcMZYRt3+6qi?=
 =?us-ascii?Q?g+NtS9H1Z9ofVIJihRWTVIjVBVZpax+7GxsH2ApKZQnVUxMN+UtROfxOonfU?=
 =?us-ascii?Q?FzodFHdrDg5r9Gp63b0XTHdwXLYA4LWqSkyrEoSIYhn1Y9ICrUVCzWsz4SiC?=
 =?us-ascii?Q?DHACHsnoEK0YopQmJYyWpP0YGaqcAmpsRd50v43wFLdAS0YusBLTbOxRX7wa?=
 =?us-ascii?Q?hMd0IeE//mEAIygOCtJ12GAI6V6OfeUNIPzcVUZU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2422692-2752-45eb-bbdd-08da7f7e3659
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 11:55:28.3459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDVBxlMIUBfRiEvUHyN7vmjQcymXA8Z7jZJaMRXXdxkUBzhT1oJFSiLS7VYedlvj+xoZTXHOeLqCZGDnORKciA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6005
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

RTL8221F(D)(I)-VD-CG is the pin-to-pin upgrade chip from
RTL8221F(D)(I)-CG.

Add new PHY ID for this chip.
It does not support RTL8211F_PHYCR2 anymore, so remove the w/r operation
of this register.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
1. Commit message changed, RTL8221 instead of RTL8821.
2. Add has_phycr2 to struct rtl821x_priv.
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

