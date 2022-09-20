Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE9D5BEFDB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiITWNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiITWNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:13:04 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC7878220;
        Tue, 20 Sep 2022 15:13:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPKyje60+nnAHkxkMJ7+Do/AdFXa7mLcB4RXxNccwBzv9KFzv8bttQYwGvsxwA+s1zUUKhGoCEkLcgfU2FV++PbKLU4UXL9zV1d5bKFEmV0MHuD6VZv1tMNQ6PAMYC64KrSnAG+YWwUWxLjohKSa4sREPMUUnhj2/wxO2Er8VjuDciZ05WWF7huAUzxQIhIdH/c3z7kv36kyA8Y16SkgPIabXez4CG0WuUS3yW925YEcgw+fNL9Ylk9XV2RlOGeYwyO2K8hZxTxq+rlRhLsOKL7wX1xTZXgROsImpk83QffoCicUFAkH6KY3kmSK++DYy3q3yYtJS6+m4iNorXV2NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msiT+UkpoCrjHVQp2GSjV0d6CwJSb1xGjry1C/EbVZU=;
 b=JJMAwYo52hSWtNDPkoR+s2/w6TMclZEN2pGORJc9T2l8wchiHHnCeQwtyu2NnGTrwsuE297246It01HihzyIxGv1MVX3GeN+EYH0n6KPwxu1oiAXfpFsaqHt9zDt0tu7WXH8Vl85KL0o2MZ0iH527B8Z9d6h57JCTuiTbzstygHMeUvxIVQnGLEJSmYFQVF+rhLE8bmapJBiwigvuUC2TvR9U1KqWROr/l/owuibOenm3ob9ArSfQ0yI6YbDRZUHmTyccrVgj8fpe5PYOZDeAzpFnhKmC0eeuqndjRuF1OUUUIDCctnLl+Iq5xOXqnOdhbJTRq91OEc/vbCxgDAZdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msiT+UkpoCrjHVQp2GSjV0d6CwJSb1xGjry1C/EbVZU=;
 b=0xxGXEVW4z2ke+RE0CpHWOyocfBdxV7dDB1aa8rsqTDWz/GyBmtn/RULGaiP4rW/1803+5l/idaoItTSenEUkgEQHr4mfEEPr/VGy5jR24Ji5E3ouBMSqNeK6Kk2FXtO78m7INoG7sDMmut1yAacP4u6c1iL89iswWjy7tBjM1MXKwgTZrfVJ9kIJiDrVhKtukS5uVVF7I7U3yH91EmYAUhGKUc1+CxRF5HDmbLHOBNrJ32yfdKxGbDl8XcPwV6JeA9e+z/Zp42vEiYrwt5AjcBdtiJS4Yj0Dzbgs4L5U0JB8GbkdpqBEqHyEhTnCRAWmWOrmoBOZV1joRAYj9Hbiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8179.eurprd03.prod.outlook.com (2603:10a6:20b:4e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 22:12:56 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 22:12:56 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v6 7/8] net: phy: aquantia: Add some additional phy interfaces
Date:   Tue, 20 Sep 2022 18:12:34 -0400
Message-Id: <20220920221235.1487501-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220920221235.1487501-1-sean.anderson@seco.com>
References: <20220920221235.1487501-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0038.prod.exchangelabs.com (2603:10b6:208:23f::7)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS4PR03MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 11a322be-d729-4736-d248-08da9b554565
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUAxC918XZIzs95g356UbrZ8kGnG8gzghYcqzfAtSji8tjFiO97y2sI7aDtCSfFZVdfwBkBDylFcsjWlT+fwaRb0fAeKMh11P+dngM/ECe1cPjx6YbQB8sPjhsgP+XfzHUgndprybCzc3jEkyCaGkqFntMP7DmHvuUIHa8GlDiQ7EkKAOnVH7pAWI3jFfd5xYr4CpyuLUZCwP61B6HzjTyaB3qKGv1pT9I8VuTdlDOSoC2c0PTeV/k8UC59UjJNnTCFfpjWBgCehb0na4rQuBrI/+d7nXRWWer7wonIi/BBmLSPKfCGSnhMHtyJPZMAKHM0nxy7Pr9UYlT0EeUucpgennBv3Nta4yBKd+Ud2OEsRPnG2QrYRw8EbdH+HtNUmdxM2pG290iYXS5gnXCnoesw0dDpgr6mW87ZNFUQHfCh7L/i5aDWf54KWhw4J6IQJIGqbbRa+jpvCcNjNHqkQtUHaSKiJdUyddf234vMRmxB4TXUeiP2ajDYRu31+bFsoiPKqLkfAjf4Awua/B+BLopMnC6jLfGNhfCC/JeRlxYcvIY3rZpAoX6zhMMDa6cohfWDW9zp7w/duZIMtuL9Iwls4+laFZoQ0ujaEjHu3E6qlzKDDMWUAdJYSz6m47Te80U97BoJORfHxd1JRhZPITE3UwI7k8jxG+VKHXJ4eyy4PxPZQLRj7ojbnVBz3hsjeelyKGinKy22T+l/pnFOpMEWZ4anKwbiFxNbWRdu5Y46scXqkDky8s+bhK/HSxoibGbPeSLgmPhY6F0k59aIpsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(396003)(376002)(346002)(136003)(451199015)(7416002)(8676002)(186003)(478600001)(1076003)(66476007)(66556008)(66946007)(4326008)(5660300002)(2616005)(44832011)(86362001)(8936002)(83380400001)(6486002)(26005)(316002)(54906003)(2906002)(6512007)(36756003)(110136005)(6506007)(38350700002)(6666004)(41300700001)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yfSwIPht9BEis1Azh5NPHr4D/9NYP6KTaCDnw4qzn5fmn7p6fMocFIqRBPOe?=
 =?us-ascii?Q?zDuaY9BiT+J+jT1Rl+m8Oy24c8Wzi8bbr6S6zYfEa0s1U2bC96dmxNjkDGRr?=
 =?us-ascii?Q?kz9IevlcS840SRBBXwG4A62qLJ33wugzQP+92LPGeC/fZfUO93W53xxdcQoj?=
 =?us-ascii?Q?WeWdLs1xllla8jvBh1KDNu/Pd7ZOhdNMFH/F14go1UJzXU9lE4BsxUNrktr8?=
 =?us-ascii?Q?6v836m1x7lpczw7pD3scAYTyzPBUSY19Hrt1Zjyu1rxoHWdEcxcuuBtGKc4s?=
 =?us-ascii?Q?tO7BrLQZ+vZZNbqY1aMRfcZ60/NrnlQaX9HktXhFYxYhCL+dRRGZCRThH9se?=
 =?us-ascii?Q?uQFbpb96GM/EDW6VhaofR3kSMkX2YaaeVYDrNa1LG/oMWh1lYkFJXDwccY8M?=
 =?us-ascii?Q?Xo6Rn9OEnWMtCa2t+izr3xYui3utL6iwy0ATApUyRDxg9r7zdpx8aSscxKt5?=
 =?us-ascii?Q?pJ/rDTOWLBDT2QRuZH3giVqxR/EmA4NLmj7uMLV6ToR9n/oCvXz3n3cm8va0?=
 =?us-ascii?Q?FEi2I9Nwo+fgIbPtZhRdaDO1uAIl6US43IuGeeyt0t1Dy2xGFznQI8sg6bZC?=
 =?us-ascii?Q?Vi3RW3+3aJp7ouD25rIpar8Q21WDEfp/19llCjg5ndhQdWAPXvzXvaBpYzOJ?=
 =?us-ascii?Q?lSeVxfmjbuDCaJ61dWviYzLYkFrPqrV5FiwNEX19i77u0cldnSF3fhXd4VsV?=
 =?us-ascii?Q?AKdf1pZizaQwfeHo9E1Qg+2Fzz1V86vm3BI/zsvpKw5dwmysEuu3/nJ0kkDW?=
 =?us-ascii?Q?ctGVnrYVWdftT9qq548bjr1wnmgl/JZTSBk+b0iS5Bqri/BIZL+yKVKjV/Bc?=
 =?us-ascii?Q?k0FaPCpd4YTCII432yJFH+3IfEXbtF3Sc3uz6G6DyogTCc44Itg00EboM0BF?=
 =?us-ascii?Q?YGKpKQYvnhuiT/Ezu7IDoWb/gpsc4WURNoGdIPlnxscsyjSHRYZ13IUQcpTq?=
 =?us-ascii?Q?vC380PYwaeYDmsjIsZKOQmguPtFdWTXHr7IPKE5Mc4LTKuDrsfb9WpW2Fung?=
 =?us-ascii?Q?mQ/Iohfi+xNoEzdKmTrBujQNr/zrotSLwOiL12Nno+99fjtjadLFVwVU/4IG?=
 =?us-ascii?Q?uVEOnvOpB2e2gI41tGLzkb3D9wmzww4VXT7lYsziZVL4ovM+H+apjaVG8UB+?=
 =?us-ascii?Q?+NQEY531RUWT1BIcjGDLh/Aj6auBRiYnKQ8WffuX32f6MRDWfOLtFnp59U1X?=
 =?us-ascii?Q?b2hpqgJuUS47K6tItoFVBAYC+qLSHmXGIUBWH4POQ2YRlivuec/iMFbJkc4Q?=
 =?us-ascii?Q?x62Aj3Zz3uuulwkTFpKT9MEP4on+Acl7FRcjpZyXyyG2YFQJCpqGOyt+RQHU?=
 =?us-ascii?Q?ngQqdGUWWbLXRIYsONKvBq7gv84Ha3Mon54l60EK+uEDCi9eqgnsq2Xwq0bX?=
 =?us-ascii?Q?9u2miQhuDWibz+JYpYVHS0lgcMulvZJNWxC2T2iyPpQ9/zE+QcuzIIekiy6J?=
 =?us-ascii?Q?PN7F8HCgvjv4yyNxImwLP2QkQVAEoimMAcmbB3SbVCMLXUcLIQPYXYKN0KZS?=
 =?us-ascii?Q?zvrCF/+Sr65b3i6vEvSFTk5UOazum09sG07ho1ULbInWqlqQkwyUKkRRgOU5?=
 =?us-ascii?Q?3VumV0oP3qthRYHb+8Os0sh9wHTq/nvMx+Cyx335dlkhEogjhSdrfCDrKoW6?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11a322be-d729-4736-d248-08da9b554565
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 22:12:56.6110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UdDilI8oT08mR66fsbPeByyRd7KVaBw8C5LGz3NZKUbNxIGxPLALD5gu5YvRP7I6O8I1R39EzH+BlmtWnkDa5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are documented in the AQR115 register reference. I haven't tested
them, but perhaps they'll be useful to someone.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---

(no changes since v3)

Changes in v3:
- Move unused defines to next commit (where they will be used)

 drivers/net/phy/aquantia_main.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 8b7a46db30e0..b3a5db487e52 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -27,9 +27,12 @@
 #define MDIO_PHYXS_VEND_IF_STATUS		0xe812
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_MASK	GENMASK(7, 3)
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR	0
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_KX	1
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI	2
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII	3
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_XAUI	4
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII	6
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_RXAUI	7
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_OCSGMII	10
 
 #define MDIO_AN_VEND_PROV			0xc400
@@ -392,15 +395,24 @@ static int aqr107_read_status(struct phy_device *phydev)
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR:
 		phydev->interface = PHY_INTERFACE_MODE_10GKR;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_KX:
+		phydev->interface = PHY_INTERFACE_MODE_1000BASEKX;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI:
 		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
 		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII:
 		phydev->interface = PHY_INTERFACE_MODE_USXGMII;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XAUI:
+		phydev->interface = PHY_INTERFACE_MODE_XAUI;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII:
 		phydev->interface = PHY_INTERFACE_MODE_SGMII;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_RXAUI:
+		phydev->interface = PHY_INTERFACE_MODE_RXAUI;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_OCSGMII:
 		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
 		break;
@@ -513,11 +525,14 @@ static int aqr107_config_init(struct phy_device *phydev)
 
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_1000BASEKX &&
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
 	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_USXGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_10GKR &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
+	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
+	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
+	    phydev->interface != PHY_INTERFACE_MODE_RXAUI)
 		return -ENODEV;
 
 	WARN(phydev->interface == PHY_INTERFACE_MODE_XGMII,
-- 
2.35.1.1320.gc452695387.dirty

