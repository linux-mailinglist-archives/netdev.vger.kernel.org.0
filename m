Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAAC162E9FA
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiKRACk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbiKRACf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:02:35 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80055.outbound.protection.outlook.com [40.107.8.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A0170A3D
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:02:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDrno0dViFrOievCkPeeui891zrcyKIDOYu62ZJaevM5B0zRL25+qbDeJ75KGYjAdGazEU0nCwzR7J7kW9aBhc/mJysY4p8F/p60oOignn4yjB1ANMTfShC39ZOqRNg71AO/X3olWEod1VFh9PCTLOl758ic1nMo5HNIurikxp8hhY1GThgRbM+gYegu6HMkPKV9H32P6YKpiwhNMkqK2LALHtC54Qe/KMIjhVGPL6UYCeMDOS7ETaAWUMobfYWhdVRiC/a2RuqxnZNdmq8qOeMktNP3xJ580eldV8Q1Xd0sJbJTNXlRfdm1rpVbUi7gG52CsQNZe+pTtQFcJ0I5nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kipTAyY2yTKAxDyz93sKuyP8zYe29Z4rE2FHylNMarA=;
 b=EFg3QL8Bs+151hYEVW4hE+VAMfMEQKU6u+lIJ4hqR6mFnprASAwfPNbodU12r/VAiOV/cTZYaiVXgg95kK3y37D3fzqsWhccpTwUFQ+u6Q5uLFZbUTfbnJL5UjJRRjX8OREFpcVVBM1bZd3pFf8hkiOpmd6cMz5iGaxIEOuDvXHSNI3QjOa1pfcJI5WuisAXiFpNVxw4JHEAwEjJt3iqpMlYTjkunLKNGlH2w+V6vaZsvKb3QkcrLnZRFi7LAjY5z0zdiTNoE8Tsy7INXkOOq9DwioW6dnJUw8A0kd0dKturUthx8EWWkLuUUQEHA4IbdQ3tC4zf3oS6CfxCfTbaJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kipTAyY2yTKAxDyz93sKuyP8zYe29Z4rE2FHylNMarA=;
 b=hksyEOa9ikvLuQ3vTmSZEWetNu4ifUzrKK58OdwICb8mTHVvM0Viw2mOJMwFgI+w75A64a5IZylD3yNgmi8i7W9pH9Q5ctuXkAt9jOu/sA4tJlaegLm+zE+a598QzyLR3/QIhinzgiv2pGoubo2ELTAT5PfCHg4Z+wyTjvDl39A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8542.eurprd04.prod.outlook.com (2603:10a6:102:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 18 Nov
 2022 00:02:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 00:02:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: [PATCH v4 net-next 6/8] net: phy: mscc: configure in-band auto-negotiation for VSC8514
Date:   Fri, 18 Nov 2022 02:01:22 +0200
Message-Id: <20221118000124.2754581-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::16)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 226176f5-30dd-46f3-d71d-08dac8f825ad
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FP2mYW7OxRnU5vsAcBUBXkIGavxpbjy/PxWaL9L8nf78Hg4X83SARhjlWrEPnWVaWpYYXD1WWsXJX6uM9nEYXMnbyiihX9wrzAv/HXNmn+mjKkkhByvSOh5wsnke2T8voO9cWyjpDTlGWV/6uTxzkikkT63KQEw+GuXUzPZ9nTWbu+j4i9RkZn5cr7KbPtSwo/ErumhIHHGaVTXAyNy5ulgNxLI06HSaolKd6OOZzI9Y+wthpQiyaPhRUJSNyC89sG6vO3C9pJy06vUjbBxl0cpZgfMFV/rSfR+qV1pNOtKbov/99JYQNmLrZS2HJmlhEa1eybSha3Ki4SATe0BvReP5Qb0jcOU4r4xF73AuZzCLqNFvRdlAle8Z2aDG2nBb4DqXxxh8+crKG2m/zTcy6kxxMVjV5Rv6XCGLmRF0/eRqX0TQxnj96SS1CLk5d3gPNHJyGwgruub8tkZYE7za39UGGSpn1nue8E5agvG3sZ8n0QUMtCsRhQPa+Mgt48TQK3zYBpzeSTjwdUhUoM4kcskPaX4p4PnnH8SlrctOyamJR8/8j/AYJ/Cfe624YdeCDIPYARYz3RxUIuqY5CN+fFmU34PxxQmS+7bFTsL52wS7d33BUslenbENdCdWLJqctLeKsTvXIiZHICnz+wEOnM/LUBQMIaniKwJebQfSApstM9C8XOko2YNJUou53WtG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199015)(478600001)(26005)(41300700001)(6506007)(6666004)(36756003)(8676002)(52116002)(6486002)(4326008)(38100700002)(44832011)(7416002)(8936002)(2616005)(66946007)(66556008)(38350700002)(6512007)(66476007)(186003)(316002)(1076003)(2906002)(54906003)(6916009)(86362001)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NjJbk3Z6T+0X8x7vmq8mgRPRMJwJyhy5T3ZfcGlVIeCV6QmhxNaHjdmEL+HB?=
 =?us-ascii?Q?sQWi2N68HKeb4+QTCEESSA9dBguqC2w5h4/7uBKAH7dTmbul/84j4Z7T/3vp?=
 =?us-ascii?Q?5J5snPxlOIg0RqaK9tTJ6k34l9Ar03c+Zo0rTmwhLU6ONUFH9+BsHgOt2qFU?=
 =?us-ascii?Q?QgGwh4X/JkxKsw0xg6BIc693YttWj/DP1lrO0UcdmEyYUp+gr7xtn7QJbhWa?=
 =?us-ascii?Q?SpyfQniAOXqOJli8EsiEgjZqbjhIBY57K0sUxVoTI7zV3uM132HWJz0o+/Xc?=
 =?us-ascii?Q?19Dlv8bSr+IOQtcovZj4GExOpcu+NSkHBwE2SwH+ykWF2ofjkkqsPZn74/D5?=
 =?us-ascii?Q?s53c0K/L/76OH6Cl2nLBoBJH/j11NA4TQxFbmpjGnRo4y8M3GDiftO8mt3sm?=
 =?us-ascii?Q?jxozAt8BisfgZLxH8iUJdCJ05/XE4cf7Z9KJjPNrgI6spCHLmBxHH+6zP5z3?=
 =?us-ascii?Q?2ZFqr2TtQkuNqPNvZENs9CIdgDYV1T2PC5Lc1N1/KBbRHesE2OS0ijKbID8L?=
 =?us-ascii?Q?+kUL3vGUPprJmk6yXvjOZGV9JS8N0sfnyQKuPjUGLahA/kqxS2AMKkQRTcuf?=
 =?us-ascii?Q?GiI2DIOcbfHeXIzCiGBSNBeIdRo+oRHYo6aETyAwP/kLOlQ+J9jK3B380zmq?=
 =?us-ascii?Q?5mfaNqplydl6HU7vctMyn96uLXMAPPNyqPDVCicEAYikX336T6c7Jsk0fiuP?=
 =?us-ascii?Q?6niJo1qszCdS7ylygUFXcESkIOOhx1ac1DxaPSw4EqL8Qg0ltGqUW6lNCKN0?=
 =?us-ascii?Q?fgQGHReH+4M5/RhklN3PrXsbHq0PaUc3atjbY98EM+yGAGv0v16irubUMDL+?=
 =?us-ascii?Q?ogmz3eCl5NPG9drK1pw7d6kLomTrdSSXkDY+Kgak4MNDYIvKFpZoDhCYMple?=
 =?us-ascii?Q?F/AXePjZGeKdBCdsdE/rSdAue8+esyKlRllj/2Eat1nbDJM1acVQouRiiOjW?=
 =?us-ascii?Q?2mUz5PCt0KLmIJKsltwobMaeYNtWvMsa2NpXxd6e0s3D+8RKWN/jbBTxKOzQ?=
 =?us-ascii?Q?8Zr0vnMJX4iW4DAO3xfhbrZyiJY18YeuwI5HawK8AOVetdFPfh5a/o9r1vdL?=
 =?us-ascii?Q?gBsstXI1vc6BuHSxP0baVIX4+pRn/9MvszYOUnLrJSWVsMLsc5fSkC3SZK9X?=
 =?us-ascii?Q?AvCjaDK0uSKOokYE6nhUm3T2CmZ9Fh+ZmbJd43Eu8LrxiefJw2Dh5ephcoHN?=
 =?us-ascii?Q?anZHkt48F9K0sqNpcL03l9xqMLEwkALqHt1f5rr/ndQSnNl4dTAqdzO+GBYF?=
 =?us-ascii?Q?Il1RinWzzZXcQxj/3H1eLUYTgzTA7CvVdcZUez4Vl8DbwJ8A5Jj/gLMI4Q/1?=
 =?us-ascii?Q?ZymwJV4RCu2tLIwio8ltXIfSkiW4ME0e3l9iReolaJOTKg977vNsitLzJrzd?=
 =?us-ascii?Q?b+hY4smeVxNiX5aupG/nS9zPaXn8AWIxxqiu9F+aY+ML9wsGzYrc4UPQaNiH?=
 =?us-ascii?Q?QpivAd/qYBXoYQ1fEnGNLushf4KeB1duW/VDltj3FVw8PylVRkQxs6dgzv3U?=
 =?us-ascii?Q?Y6hxo3R5S2yduj8UGan6p97E32fbGRkN5Dr5LqWXnXTuMsP7blpH9un+A/La?=
 =?us-ascii?Q?xXg4cuF8e3OjJcKZuevFWOa5PUhoDS1w5NoQ9tWTFt+i7+lqjHk7usf22wH8?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 226176f5-30dd-46f3-d71d-08dac8f825ad
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 00:02:13.7972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IzXw1/ruFzjTB5fgCrdJov2nTFTuutEeH3FZKtn6UNYPaHvMa77uDtsTwjvdY3it5eWMEveONzq6lSmxw+D6nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the in-band validation and configuration knobs for the VSC8514 quad
PHY. Supporting both ON and OFF means that the mode which gets used in
the end depends squarely on device tree, and the PHY adapts to that.

Tested with QSGMII in-band AN both on and off on NXP LS1028A-RDB and
T1040-RDB.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: s/inband_aneg/an_inband/

 drivers/net/phy/mscc/mscc.h      |  2 ++
 drivers/net/phy/mscc/mscc_main.c | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index a50235fdf7d9..366db1425561 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -195,6 +195,8 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
 
 /* Extended Page 3 Registers */
+#define MSCC_PHY_SERDES_PCS_CTRL	  16
+#define MSCC_PHY_SERDES_ANEG		  BIT(7)
 #define MSCC_PHY_SERDES_TX_VALID_CNT	  21
 #define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
 #define MSCC_PHY_SERDES_RX_VALID_CNT	  28
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 8a13b1ad9a33..f136782fd995 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2189,6 +2189,25 @@ static int vsc85xx_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static int vsc8514_validate_an_inband(struct phy_device *phydev,
+				      phy_interface_t interface)
+{
+	return PHY_AN_INBAND_OFF | PHY_AN_INBAND_ON;
+}
+
+static int vsc8514_config_an_inband(struct phy_device *phydev,
+				    phy_interface_t interface, bool enabled)
+{
+	int reg_val = 0;
+
+	if (enabled)
+		reg_val = MSCC_PHY_SERDES_ANEG;
+
+	return phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
+				MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
+				reg_val);
+}
+
 static int vsc8514_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
@@ -2395,6 +2414,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.validate_an_inband = vsc8514_validate_an_inband,
+	.config_an_inband = vsc8514_config_an_inband,
 },
 {
 	.phy_id		= PHY_ID_VSC8530,
-- 
2.34.1

