Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E15E598959
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344964AbiHRQq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344978AbiHRQqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:52 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5656C57B7;
        Thu, 18 Aug 2022 09:46:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q51r1Hi4W1oIOErTUPRNgIUfr+YMkta7XtbAlhCLoJ9RXZFBj56YBQo81Oo0oSw7g/8d5pyAMQi10j6hARcpcwp7b1pDGrMW3TVsIiNJ1oHM8cMAYmaR1k32qmmcuoYxA9Nqc3ZcFeP02Uew5ZTuNqy2EEOSS8yLszvd+1ic5szGu6u3f+taC/5OuAmmcZXzIzjU1M8enIzs952Km08fxTQp3WJg+M9iPyyqR085VcnNaZTSHZeZQ4B6sYPfgU+4okdhAxxZlMl/pDMVq22HUjAT/UYHwNt8EGMJ2Hk4SFFpXY8P+yJEcs09xos0Hd0JTbztM4E4c+9E8FNVxatk0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NsV7YGT9vGnTEtFTU15G2k9BWfNRzFNNm89ghHTwVzc=;
 b=StEYJHbre8s3B59PurtNajP/c0/Eq7ay8dkc6eK27Me9J9q+vHnKSLVzNUfYR32zz5Khhlvq4oKb4+7TMg1t7nRAy69mL1wIM+EnBWkEdnlGmgm2D4G/b10XvNhPICvxsyAupc3CklndyZcXFDI6LyRRBa94Pgbvm5dJS3+HVnDuL+OqfkWsT3UN2hVVLWkne/ZiKPf+8pvp0O2hu8dtmm+FC1HP/nea4j8knHL7rvTP6/0pxAtTXbXHjZ1zus+Um8eA7h9+SnCIu0BU4nCzcain4yyPfLA89EFRirglUqUoIw9CiZZfDcD+VHi6QwpmYNN4XJ+BgepYNr1MYCOrgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NsV7YGT9vGnTEtFTU15G2k9BWfNRzFNNm89ghHTwVzc=;
 b=PPS0PK4RP6u7eGCoLBTg4GLFWUfO4tvFkF0IzjEeTZXmuvfKWmJ2dZ5m6DOcW9oqHuLvvfnzxqsvsRCJHVOsxRITOI9WtUE6oY2l7Zvr7ZnvpCMCHt1yHHq53cZczyh2PsRM81XuTMSg9lMskNtEUl+9NriBDeX1DgieqoV7rLaPld5UR18Y515ewGjbA+GU+BUptYDsRv3oVaCVPoglaU7uhAfhhung+sNJ1dUMFHEnf4CRLZ+KcUBXZslpRiXMxrF4B9EfRm7B3pUGdv4OpS55pk9vw5BNLHJj1Ub3xkZcfQ10tdxfrC6lsleRCB0jjswl48+hgXlMliO6TYQ+NQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:44 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:44 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 10/10] net: phy: aquantia: Add support for rate adaptation
Date:   Thu, 18 Aug 2022 12:46:16 -0400
Message-Id: <20220818164616.2064242-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818164616.2064242-1-sean.anderson@seco.com>
References: <20220818164616.2064242-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b9c7228-41d3-4724-fd48-08da81393bcc
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LNAdMpmBX6hCTpm5Uo7dezcXMdZ/l/mHbAf11kALSSd8Idv2JPa3lPiX7EsdNV/sxl8xMJlVIHT7dgfl6xJD5AGtfpbiD23D0UxF5knDaV08fiyjguY8ZvAMxSjqv5Ous5SIWJu0j6kdotY/nkle69r7i0+P80YDNUr2MKREms9RxJjt9o0s6RXXNe3SOsiLA0+VuqsUYYudiUVwU1cM38a3mGLsCmaWFOb009zdCUhtCuwrvrDZJCHsTXZbM2GX47IzU1utxuqYu1ASqWPki0SA5fGtT0JS7JTRd07aU5RFBpW33l5FUrpId0WLetqR41RwP7WbcMt+XAJNpMoocnhb5NK28fGzqQjjtBgmGVeU8+dwHUrZ4tqkgeUDj1YRHjVGsgctX7bLwGBlXR2lH3JyJdke/X2U0zjykR+Ph9M+QGiVPBLtDu0hswThTbrJnOEMba4+58DQBGX979/LqPH4WpGJZDIWhGSSfA85+U6q+/3Ok8Wh/B1wbbFy7CtE6cJTbXz0pPLCeBlP0S2sQR+swu8dqPg2wmqFO5gZpoY+x8deMVi1VOOrUnY+baIODMS/n6CducRlvEW7Y9zYWfqiqoGuEoyKngVSfGANu8Qeick8CTEBafEkgOufTxXWLnauB3qVwS+RnVYwIDjdedaAGNUOsnYCumYfZNNZqca2em/RQnWuKHRQqgSOpzt7IgdSw5D7eE6fK9LX4frfnLkgMOYlAyodczHxBU2Cpvx4F2uGBP6O990kWM5afxlOBESvhuQXURBfCajEr719ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(66476007)(66946007)(478600001)(66556008)(6486002)(8676002)(2906002)(41300700001)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Icr2wjw9R/9aOw0w5KIl/wVXFJACpu/loe8nxlAXPPhN23gBInjGf7Mx9g2?=
 =?us-ascii?Q?WVDx/OumbwCO4/SvFEb0Wo+3zJW0FR4UzyF+sLGO4eofgnyic/wOyXqGXT9W?=
 =?us-ascii?Q?brUEVq1kiqK6mBJOhDvz2X2ZRWlkwG1V1bkgAroali6xVlbgzukoyppegSKN?=
 =?us-ascii?Q?Fz3NKINghsaRQCIZb/rhCwzT9kSjPFZ1TCuNCtW7qKxnBJpoRWgwoj3+IkbF?=
 =?us-ascii?Q?QvKkTk99ViyemUCHy93BH+tG34D6zOUIaYDIdgW+WCr1jizzsx25Y3LX1Las?=
 =?us-ascii?Q?Z3IRXbYUhBAS9FO0UA2c6Xno8mTjHj+WmXs/w5Nwbtf4eX7e8frW8x0wK9ek?=
 =?us-ascii?Q?LVA1aBCWO3U4mKPOs3hy++zcsJp+okDG77libgzVnvtig2l117H0k89peh5X?=
 =?us-ascii?Q?bLVMxNtQ9BJ4BNk+6UXWJX8rzjvOfWMsMneKRKSYqgOpn6gdgWwnTVDhJkp+?=
 =?us-ascii?Q?hOe6aS6ItshC8nNXj5mZ046GSspV4yl2L0izhRclXS3s4bkFnx5p5FgQy3u8?=
 =?us-ascii?Q?yhNBxedrbiwvPQwv1QKKnf0aHzcC/CmtUma8hNeUR5rPLr5dpdU7MLirwol1?=
 =?us-ascii?Q?SEM26t2LzTv3L6TP3Ol/2Fj9CPoCmNj+DchfFHPQ8jJ40EH4hW0CR70VhFbj?=
 =?us-ascii?Q?N5prQlDQgTm2FLuo18/T0l1JZHQe5QPFLComEk3oy32tkyAEx3OuI9k3EkBe?=
 =?us-ascii?Q?8omfs/hDRYMEvS75WCptgC4I7HwWmNyGw74xTxQVYqcQoNAjy0xnxd2kpT94?=
 =?us-ascii?Q?fWuOD4edTNaijaWGJvnJ3/sdUh5fgHoYhmiIRz8HERSZb70ofPWGEOh/tDYa?=
 =?us-ascii?Q?NIbcsvGRh9wO8o5Mch3sMf3HvsyFbO6Zh69bk6EHtx5Ap8MeCNrkXwbQpNdI?=
 =?us-ascii?Q?mUgh0zr4z2DMGck04VG5yK5ULKVr+TBRABmSLhkF9yhYfSZpCK4RwSy83o3m?=
 =?us-ascii?Q?pamMxfb2s8R+UIHF3p3pGvBNpmQDp+6CbNmnPEaxe+S1lYIRcIF/3CXzQMWk?=
 =?us-ascii?Q?HxSHvwldh2fY1Vv2R4E7Xb0iv/PeLQxBsrQSNQdyc1/qu4Ez/2lq9Z/84rRk?=
 =?us-ascii?Q?ZcpXAoie3WimjMcJtRuN9sU7gbMw1GOL4kL3nbc/c4DEvpvK19UfI+ICEioO?=
 =?us-ascii?Q?jXXTd0laKlunJDBVthA/a8lVRuwdvP4SYVx/i8o19gFS46tpHubBOAgT6dUL?=
 =?us-ascii?Q?G0/54DCZQi8FDri9u40elhhYealzNLvBHMk/RApGYAq7nhMDDIjQM7mnSvce?=
 =?us-ascii?Q?8sFhet4AarTxLFcJazE+jwLNIkulB66RHK9x7xKXlpw6hERIjNMsqER47ITJ?=
 =?us-ascii?Q?D09iu0eyCp2Jf+1SkIYrQnbJfhsKvmoBbqPpCGUo2eNHJVxsiV5U7BA26J8A?=
 =?us-ascii?Q?x0bvzOIswtmX9Kkdu+Rf3XmnxTLFCsRBntpyhoR8GR0sEd4XgZcHRt5GiXrh?=
 =?us-ascii?Q?pOJyGUQCO/k9h5hknMzzsskKtjxgcLoBjjJs7jo0ULrptMj+p8+xm3ACvo5j?=
 =?us-ascii?Q?PvBVgFm5Y3H8rTr5RX1+An1TSplx7WKbcpCp2QTc2MBVsO9pO0xbiKR6LCWI?=
 =?us-ascii?Q?UoI9dRuXTz4pfnnMXp+iel8/H2PeKpywDrOSbc9r1YXT4e/4tf0vFGmcre+w?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9c7228-41d3-4724-fd48-08da81393bcc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:44.4161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KABeZjWI9Tqeq6fQJVt91S83pdbwULsjA5s3Y+O4gvgrCVyfw5wpy1JyfuHJRdnt8q47jkv9aEm79m3Sw1jSdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

