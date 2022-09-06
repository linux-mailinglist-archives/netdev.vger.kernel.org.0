Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441FF5AF0CA
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbiIFQmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiIFQlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:41:05 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60081.outbound.protection.outlook.com [40.107.6.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20651758E;
        Tue,  6 Sep 2022 09:19:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8eAusa6+8ogAFLEsv5Cx4t+u5cH23ZXr6lgNRFd/+AuGxr/5tzI0WiOYJvaaBXJ5FjC5sOBQzODK5wpUYqa5cghtQJHW/IQ7n+LpPGeLEBzh0AIgMpJ030EjBZiWbKZzbIjcOHqAEJE4WwsMC0sHH2QRQrLx9smemnoNl4L4f1iYXWUsoYwmfnyhYKnJNLEQlLRs1orZ68klUGlpwdqxot6CIEkrlq3C6FCda07z7/bPQthI9NLsYQa9Yce/zRrvGxflDaZ8DtB1EdnzCMMInEHgQvSSUsEmHEuCPAA/uVLl9Su26TkVV+/NtLT1qZUcYrCgh+Kj1eHSxRB+3qnQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NsV7YGT9vGnTEtFTU15G2k9BWfNRzFNNm89ghHTwVzc=;
 b=QiAffapZikW7L6fYrZmH9Frw4qiWqwQ8MgkCGD7xWYaiP/QbdBIuDlpI6NmzKbZWBwBpj1kfQg+QPRFirNYBdpECdWDSrGTX2NEcNRD64glJCAUTo1fKRL2gDHjo0qaiyi+Agc6sSem009ZfyMQg0A+iEhU9aQ4mVJF9oafD2UV+dlfwm5Qw4X2fm+VuhOIofi75OSNKM5T8uYChnRDFT/ADXuxASKOXPbn0F3WGChLtx6vsqeZAG+Vn06eheM3QivJ7keg+EEb1XVcBoiz4KRycLmXrMbX5e3BfkYIwCr9p1R9TY5ha+tYlufr+NFK5bzg7aBCyFLstfqvc7+CRIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NsV7YGT9vGnTEtFTU15G2k9BWfNRzFNNm89ghHTwVzc=;
 b=lV9LP7mOJOoQKbyAGs+EhbgEKFG9/csTJ7EHMrxsMy96hlMMZ0bEpPDrmgcV5mmcINv/4XK0fy5sSVh1zEV14SSACIfikg9fT5utbzKR0fBfNYyCsBNUPdDCqhLe5JpBDWDCJEUOgyI/+Nd4EnTDbPpmgxZ/qCWy4AG/k7IHOfYiV4SoXXW0b2deK1e6B5fX7mNPCvJTDNwyYTyizoVByJ7/m4eGDVv4IwDrZRpYizynsKn0y+2uBDQN5s3RusP0PIV7NFahIGfrPDIEpJqHfKM+2xlwLi6RBtkLokqd/eTIU33kgyQfSIcczbt+OCEQrhdI9N4KP7NYN+XroOCYMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VE1PR03MB5664.eurprd03.prod.outlook.com (2603:10a6:803:11d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Tue, 6 Sep
 2022 16:19:19 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:19:19 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 8/8] net: phy: aquantia: Add support for rate adaptation
Date:   Tue,  6 Sep 2022 12:18:52 -0400
Message-Id: <20220906161852.1538270-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220906161852.1538270-1-sean.anderson@seco.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d1a6a4a-df2b-4df4-75d3-08da90238b23
X-MS-TrafficTypeDiagnostic: VE1PR03MB5664:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bu1Bd+tn0qdA7MRBrW9WkEEzWklEYzpSXwtIwPcXEqHVMmgDifkw1DIAts5cvijzMMTOW/8GicLFJ41UBUfD86z9C7sVKQj6rvCncYuUdy6iOwPILzKzZbhOwj1qz5u4Cw9ebOPm4MNHMn2c6RUZkuraS3onesepu+HNr6UcbR010R0qupTkz4I+kTvqT18/q6pqz0C3OPJw3FwXaY9CWm6MOo08kBwSNTVJ0Za8OWwp8lfHWfg3/9hedhrwAR6Yk6c0jayJxdCJnCM3kB2rww5wFqCAuOhPwX9nw6ZpRc3giYjPrktrxxkncQKiAUmHQH1pGNuMG01Hur+RxPMnmzh8LcWUQc33uoDs1fETI6hJH7T5dWWUCKPRy6raOHnf8pu3ZHuTbsXAEYSAE8eEE9dis543AKre0KxhL7L1M2EunyYLel1tw8xIIKakx2kIEfzH50WFuoOwAoiIb9ikqkZrEGlkol63AL2BOq03RcT/ECe4MHtSlMG9KVP1gIgXCqR7FcEDTckF6XFbhQvSms02ZufoCwayG7mrWApG/F42Zw1JAQL3PQpXOriX8I85SkLdb2JH1NnyR/nNQpXlxaK8eBZKt3VQPd8b1gwFCE9jMg/L807Pbv+OmwzEvuDzdo4Khg6VX6+TKiEBTq4ciH8fZmlqo8Sn6VAKI7AD48iz+aSxonVVMZGhwI1kMEd0nlpWdL/UKv7YQW4Vo3FQRK8FEmup+IkTy8vkpExXrS/+eJ+NuMYsT6WJluv6Lu0lJ0i78EmZZKD2iEDvQ0DkUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39850400004)(346002)(366004)(396003)(6666004)(26005)(6512007)(6506007)(41300700001)(2906002)(38350700002)(83380400001)(478600001)(38100700002)(6486002)(36756003)(4326008)(7416002)(66556008)(66946007)(110136005)(54906003)(316002)(5660300002)(44832011)(8676002)(66476007)(86362001)(8936002)(186003)(52116002)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FGVsqDtKQhSFiKsWNwXv6pPjwWpgduA48FFZsmhS/g58SiZwROLq2YCAjl+s?=
 =?us-ascii?Q?mHvanSvs2aYk7GxZIauVk77NQBKYq6er3SLjw9j4qEHQYkAdfEvNopAlRtzu?=
 =?us-ascii?Q?/6LroXkj2bwaa3apJA8NkEWTZv1MiJGQK44009esOi6z6DJprWCd0v/cxUBG?=
 =?us-ascii?Q?vnayGCMa3i6uYT/+2j6q+yLlWPTzIhZBUZG7NTnJlq8UvoyTEDlizXXDqw+A?=
 =?us-ascii?Q?OKv1qP1DI3YsHDzAYhV7s4lQACeTakEF4kp2/g+wZZGPs/2jWIky3bNHAWUc?=
 =?us-ascii?Q?jsbULAxkPh0qyA+PpZDoqvI4GMNooTa/ayZipbis8OvyJdOpgaIx0KbdHLyA?=
 =?us-ascii?Q?LZJ0JMK2CUMtM/x0/asUxq8GZtUc9j3pgOxfq9t4gbwVmEq9ncQ/Z/agNJGZ?=
 =?us-ascii?Q?CaYX7V+w9Y2TPz3pBICVZuS44RP2UQtnCpqJNOwYaloIAk79O1UWZG9yWKWn?=
 =?us-ascii?Q?LGdLVUlvEg2OyeVreuJPxDpR+7NiWXhoUNXL29IHHZVyNrz6IwC080kHXB9X?=
 =?us-ascii?Q?0rRI7CyvxJOX4tx0JVg/weRYWfOokDUi5wiSq6uLIu3c4PJdI8NTvXiURs+C?=
 =?us-ascii?Q?C+vqCn9dZbvcWCyQB9MIdc6Co8wNR0E6zA2mLuWdTYyjifmGIt0un2j85Pjw?=
 =?us-ascii?Q?/g9Ct1Bt5jsTrJyZAVUkP57j6R8qIIAQJbq6qKcYuKPodHReEDb+4eJRyTBG?=
 =?us-ascii?Q?7j+f1mPtnWFCuL+72B7fmIm9Tr7KWLnRRyN1q/YqMujbcbVAX6CWrBDNiU8L?=
 =?us-ascii?Q?SbqQbgXOOk5n5doaR9UmcxlewKUaoG2UFDQZ20NItXFHB0nQdgZiW1TfGjES?=
 =?us-ascii?Q?ydwMsTQs8ZAJYenHK4BOQT0hDrITObn9TE6wVxF9m4ugDA5bOCBhWYyKBnTn?=
 =?us-ascii?Q?0ZQGoNh9ARsb4S1hXOvF9dgr5xBrjce2dbt9drT5Qb9uXwwfPct/O0E085vH?=
 =?us-ascii?Q?Pj8JTxbh4W92TUJiTT1DTs5/2yWBXPXV6A0YyxAQPaB+G5sQZ7GYcqTmJtxk?=
 =?us-ascii?Q?7Xc4gCOzOyCIOJUc0urSn5AgXJgf7LTKkgOXGTuRAkKUQFazBVCS86y4pY9Q?=
 =?us-ascii?Q?ThiNvZ6fSyWql1TP9wEQce45u8JESn1ZhdhgKS3Ct932GYMpRlriwF6BjpyB?=
 =?us-ascii?Q?PrIJUgWPQqhOWJpLFfzvMn2jLqDSnIJNrLCWo+/i+kok/eWz7D9cDMtIkTXM?=
 =?us-ascii?Q?r1qvsegfWyaPzbLcuuZ0xuT4xPG2lPuaMiULjFPpF+NqUzvgfpg31PxDCkyv?=
 =?us-ascii?Q?TVHqJmWgkYAvgPZgjIi7q3Qxm6w77QSDBtwV53iE9A5jxYnJJnSQp6cJfzKt?=
 =?us-ascii?Q?GVwCF1ctINBpTeq8waPCQFYnssQrld1dx8odHzp+GxkVLpdiYh+tVSAUorYR?=
 =?us-ascii?Q?89Sby/WYlyHCjtu/CYBEn+qZR/mxrwZSCkgoRjd5CQE8DIfWGIGoEywNGCRW?=
 =?us-ascii?Q?GLYie8Ga9RX/iWmOBBN9tCVr7g/KhVDKybJr8q7XCoA2wu3tzI6Mef6wa+Ex?=
 =?us-ascii?Q?h4mjft7VlL9lnQTGXaRYKv66spCPnKOJjea58JXjadpHTnBtYfqrMnb/bJBW?=
 =?us-ascii?Q?pBCWEQmPoCinJdndszUCfqSTnIFYnZpc8XqBpIw8luyXxyoY9z72xIYMoEOB?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1a6a4a-df2b-4df4-75d3-08da90238b23
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:19:15.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3FJ+8TbRKB+X9/Ng8GrdVJcWeJ90MluNF7uFcfs0vo7qfK/0wZtD0hmxh1wm8TXELvT08QBEbm1UCvoRPDwSPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR03MB5664
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for rate adaptation for phys similar to the AQR107. We
assume that all phys using aqr107_read_status support rate adaptation.
However, it could be possible to determine support based on the firmware
revision if there are phys discovered which do not support rate adaptation.
However, as rate adaptation is advertised in the datasheets for these phys,
I suspect it is supported most boards.

Despite the name, the "config" registers are updated with the current rate
adaptation method (if any). Because they appear to be updated
automatically, I don't know if these registers can be used to disable rate
adaptation.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v2)

Changes in v2:
- Add comments clarifying the register defines
- Reorder variables in aqr107_read_rate

 drivers/net/phy/aquantia_main.c | 51 ++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index b3a5db487e52..dd73891cf68a 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -94,6 +94,19 @@
 #define VEND1_GLOBAL_FW_ID_MAJOR		GENMASK(15, 8)
 #define VEND1_GLOBAL_FW_ID_MINOR		GENMASK(7, 0)
 
+/* The following registers all have similar layouts; first the registers... */
+#define VEND1_GLOBAL_CFG_10M			0x0310
+#define VEND1_GLOBAL_CFG_100M			0x031b
+#define VEND1_GLOBAL_CFG_1G			0x031c
+#define VEND1_GLOBAL_CFG_2_5G			0x031d
+#define VEND1_GLOBAL_CFG_5G			0x031e
+#define VEND1_GLOBAL_CFG_10G			0x031f
+/* ...and now the fields */
+#define VEND1_GLOBAL_CFG_RATE_ADAPT		GENMASK(8, 7)
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
+#define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
+
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
 #define VEND1_GLOBAL_RSVD_STAT1_PROV_ID		GENMASK(3, 0)
@@ -338,40 +351,57 @@ static int aqr_read_status(struct phy_device *phydev)
 
 static int aqr107_read_rate(struct phy_device *phydev)
 {
+	u32 config_reg;
 	int val;
 
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_STATUS1);
 	if (val < 0)
 		return val;
 
+	if (val & MDIO_AN_TX_VEND_STATUS1_FULL_DUPLEX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
 	switch (FIELD_GET(MDIO_AN_TX_VEND_STATUS1_RATE_MASK, val)) {
 	case MDIO_AN_TX_VEND_STATUS1_10BASET:
 		phydev->speed = SPEED_10;
+		config_reg = VEND1_GLOBAL_CFG_10M;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_100BASETX:
 		phydev->speed = SPEED_100;
+		config_reg = VEND1_GLOBAL_CFG_100M;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_1000BASET:
 		phydev->speed = SPEED_1000;
+		config_reg = VEND1_GLOBAL_CFG_1G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_2500BASET:
 		phydev->speed = SPEED_2500;
+		config_reg = VEND1_GLOBAL_CFG_2_5G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_5000BASET:
 		phydev->speed = SPEED_5000;
+		config_reg = VEND1_GLOBAL_CFG_5G;
 		break;
 	case MDIO_AN_TX_VEND_STATUS1_10GBASET:
 		phydev->speed = SPEED_10000;
+		config_reg = VEND1_GLOBAL_CFG_10G;
 		break;
 	default:
 		phydev->speed = SPEED_UNKNOWN;
-		break;
+		return 0;
 	}
 
-	if (val & MDIO_AN_TX_VEND_STATUS1_FULL_DUPLEX)
-		phydev->duplex = DUPLEX_FULL;
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, config_reg);
+	if (val < 0)
+		return val;
+
+	if (FIELD_GET(VEND1_GLOBAL_CFG_RATE_ADAPT, val) ==
+	    VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE)
+		phydev->rate_adaptation = RATE_ADAPT_PAUSE;
 	else
-		phydev->duplex = DUPLEX_HALF;
+		phydev->rate_adaptation = RATE_ADAPT_NONE;
 
 	return 0;
 }
@@ -612,6 +642,16 @@ static void aqr107_link_change_notify(struct phy_device *phydev)
 		phydev_info(phydev, "Aquantia 1000Base-T2 mode active\n");
 }
 
+static int aqr107_get_rate_adaptation(struct phy_device *phydev,
+				      phy_interface_t iface)
+{
+	if (iface == PHY_INTERFACE_MODE_10GBASER ||
+	    iface == PHY_INTERFACE_MODE_2500BASEX ||
+	    iface == PHY_INTERFACE_MODE_NA)
+		return RATE_ADAPT_PAUSE;
+	return RATE_ADAPT_NONE;
+}
+
 static int aqr107_suspend(struct phy_device *phydev)
 {
 	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
@@ -673,6 +713,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR107),
 	.name		= "Aquantia AQR107",
 	.probe		= aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init	= aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
@@ -691,6 +732,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQCS109),
 	.name		= "Aquantia AQCS109",
 	.probe		= aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init	= aqcs109_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
@@ -717,6 +759,7 @@ static struct phy_driver aqr_driver[] = {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR113C),
 	.name           = "Aquantia AQR113C",
 	.probe          = aqr107_probe,
+	.get_rate_adaptation = aqr107_get_rate_adaptation,
 	.config_init    = aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr    = aqr_config_intr,
-- 
2.35.1.1320.gc452695387.dirty

