Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056A3576958
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiGOWBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiGOWBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:04 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A30B8BA9B;
        Fri, 15 Jul 2022 15:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bk4U1QvUIZvnEDOzMcds6sXSjVvsQJuZPrZzWerilzufdkHrGlxPkZhUptivw468zklyE5mqbpMacdocLY5yTwbhPUPaBFy2RjuRLyCMXXTZp/+yZYf0hph6ooB2/fNBcvCVW2DLGg9LqLsePJLPVzojVAm8qLevGoh1CE1cIZWfqdBDCf2Fp4Klb7PQx1DFdHjXs7QqcoeoIZgLtQ/qJ9DvDg79jHfmydwYe9TLi/pv1popvLTT4cEDYYXuyjD/e7dlvvuQDlm1PlysCazAKHKku7WiAd+MCkYbsoalFUnLCT09S6rSg2oVfAtoAS1+PXEa3ZVY6r59kIMIF25Urw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8S5vkHCVHFaGXHiSxQF0e0KS1/gsy/16H/z6qRK3mM=;
 b=Fag0cLLHQcQYwju/wkp84bxUg8o5BhJEFbpgGZ2ZgxBm7vbl+3x8bkVgE6dRoZI4AxoIE5rtLtJ/LaPgYfLJ2fMl5s30/hRxXqJTUlhSoevsonOIi+8ticubuTAnAu6eP1dfjwH6IY9vJ0DNXeRLMuCYm9jHEPFYxoO5cH8RYgrJhz9XCmfmQ6lD2eVPsJGTDs4IqRRE2cJmLLoz6IbwJjlE2/p1HJ4eStYhYBHKqLJwdf9flvfcf1zrNIIwxpft/6niWboimC+HpriyzV2u0/IAh3k/I7j6NBVvws2DAEiBNN2FbzCuL8ZB0U/JOeZpa4qLkGJ+uKDtgixHAAIiOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8S5vkHCVHFaGXHiSxQF0e0KS1/gsy/16H/z6qRK3mM=;
 b=TyWnnxCkcbaqc789oWLz1gsMbBJm0+2epen7gHonxtqdN29+4QW846NTjwyT4AxXYcU+qYrJe0Bmp+rftDkXWA1fpqvB/cjgDc4s2sYMSxcUYZYZDWT+1f2BOYdsWRBY+vf2b0LPHOKnzXoB//rkZvAVnxhPsQ3/x61ORcAM+Mqksx+pB8cZJMvKwYhs5cvlr+MhY5xthq318j+ZdZ6NimLDgmMLpypxrI7xtmYKkBV0kU3h+M+Xq9ZfPIMC68AHKrEAiD2ZfN1bEZwlbH0OM2YOWYMCX7dME2/rPjHBpi8rwpsCJPlrB3SIiu31aO8FhVZ/sRPAQrtrijyTnKJ0vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBBPR03MB5302.eurprd03.prod.outlook.com (2603:10a6:10:f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 22:00:34 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:34 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 09/47] net: phylink: Adjust advertisement based on rate adaptation
Date:   Fri, 15 Jul 2022 17:59:16 -0400
Message-Id: <20220715215954.1449214-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 645de9af-2dac-43aa-7cce-08da66ad7115
X-MS-TrafficTypeDiagnostic: DBBPR03MB5302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v3FzSN3JvqrBx0LzcJthB1/qHKUpMT8A6nzKGXdHuSLkIUkvCO4lebuNEqXpRg3ab2D5ev607YDIFtmE7Yw/zQw2Od2ydk3ZrKTVlavdKo88ywU9fhtQHzA31B+BI8tDnq1S06BNf4CSvxEFZzHfQl7Rq53eT+xjChN5xYm9knH3kbLr7o11rC8mB6SLS8IOYFJnRSJU7JRPBkkAfJa2pPlRWIuMmiV2GjXmWThXghLr+Rl++lzmZhpBtDRiZFFiTTq2+8mBBQ9ZuygI9HtQiDda+DeXF4+K2lcSGmCfgqiQuJ0hACTNHbROrw7HDcQSPiYxjQWJwZTOAetx8tU4Mo2yR8MyLfqGmD+l3wq/KRWYjrlY6wYzgd6Zyb86m/nQRSGGW54aS2eJqqe5Meq3vfeFpm67k9sRudnAxsEv4f7wRMYMsJ7LTEqvUxIExZaVVn+lHz6VOHqjReVuqaFf+esKwFMsq7zoUqwwNb4BtOOCRXfgtfj1XgRC6P720FhatAQ6ESEHWwCdb2fSVG4Y1Dg3rss/Uez4Y8oX5RG4jjKGc5Y8PB3A4Ol5aj5nzHSMutBGXhSVhy9L7hYpErpi3ASOh/DBQmbh+UblJz2YDvQd9KOl8rVK1zOWtWTIG9kZHWqlf5GhTzSGGF3nOWDz/S1UUDEmsbQ0c8inLGr6jPPA68l27IiL5KYr6Ssq8hBLGjGu7KeGf8kslJnM80Mh6B30+2reqwlREX1v2PYJqFujzoAW8/r5PDck/466ZwI1L5JzRJ2il2yZivtcl1EiamsI7PIg2zT32xec3ydc7i8puJlFE1kdszaw5L9vqY5o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(136003)(39850400004)(346002)(478600001)(66556008)(41300700001)(66476007)(52116002)(6506007)(6486002)(6512007)(26005)(8676002)(6666004)(54906003)(86362001)(66946007)(316002)(8936002)(4326008)(83380400001)(38350700002)(2616005)(1076003)(186003)(7416002)(36756003)(110136005)(38100700002)(2906002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CjRl3b7uWQUcHAetC38hyD5KFLyj5AKY+KyzJIO06vA3C257CbfuGO2sYdjV?=
 =?us-ascii?Q?1grvzd2jFOZAGrYTkKsbixBGohJFyHk8y6PBs4X7gNrhPxh/47CTUOLdLhun?=
 =?us-ascii?Q?4V7QQwjI3IwtL5HKZYW3qtDh9DvdEdNxakO3K81++aOFPZoqT/9JRvmxYLLP?=
 =?us-ascii?Q?dr8k0Q9ETHVDAKflTgcWpF564afwuhsptAAIa5h1+ujvm616OuG130URiHqx?=
 =?us-ascii?Q?XmQa0+4m+hLgmp+zQcFc5YKNaH6xRowyYlZBu6T14SJUhsNKQ4X+Jsd0lj1s?=
 =?us-ascii?Q?mDt8I5v/x617Z3DRIRPUpU/7fBj2yaWCoxowhbG8N36/YEeOfwpi+hp/80od?=
 =?us-ascii?Q?FESDyRI9cAxwscRw5H5xOdAuIetfXu6f6IPnWgc/nGBJ5EEqUFgwPMvuaXA+?=
 =?us-ascii?Q?/7N64lr5iWYgUcgRw4Rj6W1XGcL+OQb3E+gdtOgg1hT5RGYSwrCtGJFw/UBA?=
 =?us-ascii?Q?VMehVKire9rLmw6X1NSqBGHNE6Jo9Hn2FYDNI4Y8F974jG9mzs5zYIEDkzj2?=
 =?us-ascii?Q?eHy3A3XzCgpWxEqybsw2eHfxrAyDRHf2VW4bLx+1NZIVfDjtYR/LI6Easaju?=
 =?us-ascii?Q?LzhRjIogdYvyj2sJHYp8UUUsZFKYByBzb3QkyxybWAQDaaOa0ClAXIn7LXaS?=
 =?us-ascii?Q?cHUuoidLcXY8pGOYgtQaznQ7WKNMCteklSQVs8Ge6H1h4xBmLZsmOkgLJhix?=
 =?us-ascii?Q?NHK18V0WN8/jJIjalHwxIVp4vk8VX8t/bRtSNubefDuTjzHLSDCEk85BFgsb?=
 =?us-ascii?Q?UphZ9b8o129QPv10aFwpRCths5fYbpEIPUZkdBN+I6VdejkRbvKUp0QKNrFj?=
 =?us-ascii?Q?p6bIBkiuD1VG6laShdjTw0/2/C4tDsU5ynp1khUNR7vLqWMNhEajta+laFiw?=
 =?us-ascii?Q?CMIRgyvUjjGfnx7yl05KDpBhGyn2ckAyqh1fYvx5nyXP/9p4SOPUy9EhQtAf?=
 =?us-ascii?Q?GiJ2Oo1yJB+gRNnmXxBy+9dJm5rWc3L8e5RZEdz/PxdMca9l7UIHDidVy70G?=
 =?us-ascii?Q?vxfEktGoLgw9fAsvUEDI5jYihEkhmwj7EXzsoI/54AWIXT0v/PLcGwej7zZK?=
 =?us-ascii?Q?lJeomxItOm+pgJHCv8OS/oVUf2OsR6TxPsZnZyCyP+gkNcb4/eMHMpy2gAP5?=
 =?us-ascii?Q?/73XCB99qzfL3AN5iN54cumwagryOAixmuCNq7F5JcWDs2FWVBRsrRRYFVwH?=
 =?us-ascii?Q?NBPnA4P0l6eNE28ZulrP/eKmb1gR3MasV+1E661iIAuUMVcu+07eOUGp41XJ?=
 =?us-ascii?Q?v/8bengdVW+axtlPsqC2RMoqP+L6nVvXOYAmIEVEy4hDPsqOTiuXjR536IzK?=
 =?us-ascii?Q?xXTKozrKH+SFUoV8kfWVQXQ4IzYY2sFeeKQzmY/zZWLqhvKIcP6PeOF7JZFZ?=
 =?us-ascii?Q?YS3KkjkZXtkdH5uzDpo0sizPBgLixqpWmplnnLCqzs1ZjwIJTs4+7swNG/TV?=
 =?us-ascii?Q?di9n8/m8m/ZLa6ZPJD7SChN8PajZE36nm+wbqLejD2lAcLi7XxGBsUtM+oFW?=
 =?us-ascii?Q?R9GIdDJnAEvnOfJIlK6KCMxH0pLwzh9owmT5AC/iCEX3wrbViDu0zkvF0dmd?=
 =?us-ascii?Q?XvVyvfTZsIKS9PSyACwuTIk18GmYxqU31AzOspBBrND1JSJ+c/8X9ArSzMt/?=
 =?us-ascii?Q?qw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 645de9af-2dac-43aa-7cce-08da66ad7115
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:34.0205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9QTpK5MDKwQkWM6SP0nGI7mwL/7D5QPVyplcbprzPBf+VyiUlRUpmA2IQXmXG9vdO4k8oBOI0f9niPrj1rDiBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for adjusting the advertisement for pause-based rate
adaptation. This may result in a lossy link, since the final link settings
are not adjusted. Asymmetric pause support is necessary. It would be
possible for a MAC supporting only symmetric pause to use pause-based rate
adaptation, but only if pause reception was enabled as well.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 drivers/net/phy/phylink.c | 41 ++++++++++++++++++++++++++++++++++++---
 include/linux/phylink.h   |  6 +++++-
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a952cdc7c96e..7fa21941878e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -370,13 +370,15 @@ static int phy_interface_speed(phy_interface_t interface, int link_speed)
  * @linkmodes: ethtool linkmode mask (must be already initialised)
  * @interface: phy interface mode defined by &typedef phy_interface_t
  * @mac_capabilities: bitmask of MAC capabilities
+ * @rate_adaptation: type of rate adaptation being performed
  *
  * Set all possible pause, speed and duplex linkmodes in @linkmodes that
  * are supported by the @interface mode and @mac_capabilities. @linkmodes
  * must have been initialised previously.
  */
 void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
-			   unsigned long mac_capabilities)
+			   unsigned long mac_capabilities,
+			   enum rate_adaptation rate_adaptation)
 {
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 
@@ -451,7 +453,38 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 		break;
 	}
 
-	phylink_caps_to_linkmodes(linkmodes, caps & mac_capabilities);
+	caps = caps & mac_capabilities;
+
+	switch (rate_adaptation) {
+	case RATE_ADAPT_NONE:
+		break;
+	case RATE_ADAPT_PAUSE: {
+		unsigned long adapted_caps;
+
+		/* The mac must support pause for this */
+		if (!(caps & MAC_ASYM_PAUSE))
+			goto open_loop;
+
+		/* Can't adapt if there's nothing slower */
+		if (__fls(caps) <= __fls(MAC_10))
+			break;
+
+		adapted_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
+		/* We can't use pause frames in half-duplex mode */
+		adapted_caps &= ~(MAC_1000HD | MAC_100HD | MAC_10HD);
+		caps |= adapted_caps;
+		break;
+	}
+	case RATE_ADAPT_CRS:
+		/* TODO */
+		break;
+	case RATE_ADAPT_OPEN_LOOP:
+open_loop:
+		/* TODO */
+		break;
+	}
+
+	phylink_caps_to_linkmodes(linkmodes, caps);
 }
 EXPORT_SYMBOL_GPL(phylink_get_linkmodes);
 
@@ -473,7 +506,8 @@ void phylink_generic_validate(struct phylink_config *config,
 
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
-	phylink_get_linkmodes(mask, state->interface, config->mac_capabilities);
+	phylink_get_linkmodes(mask, state->interface, config->mac_capabilities,
+			      state->rate_adaptation);
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
@@ -1462,6 +1496,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		config.interface = PHY_INTERFACE_MODE_NA;
 	else
 		config.interface = interface;
+	config.rate_adaptation = phy_get_rate_adaptation(phy, config.interface);
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 30e3fbe19fb4..f990f8eab655 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -65,6 +65,8 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
  * @link: true if the link is up.
  * @an_enabled: true if autonegotiation is enabled/desired.
  * @an_complete: true if autonegotiation has completed.
+ * @rate_adaptation: method of throttling @interface_speed to @speed, one of
+ *   RATE_ADAPT_* constants.
  */
 struct phylink_link_state {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
@@ -74,6 +76,7 @@ struct phylink_link_state {
 	int link_speed;
 	int duplex;
 	int pause;
+	enum rate_adaptation rate_adaptation;
 	unsigned int link:1;
 	unsigned int an_enabled:1;
 	unsigned int an_complete:1;
@@ -523,7 +526,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 #endif
 
 void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
-			   unsigned long mac_capabilities);
+			   unsigned long mac_capabilities,
+			   enum rate_adaptation rate_adaptation);
 void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
-- 
2.35.1.1320.gc452695387.dirty

