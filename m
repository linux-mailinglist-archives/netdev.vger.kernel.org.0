Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0A45BEFE3
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiITWNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiITWNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:13:04 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7437821A;
        Tue, 20 Sep 2022 15:13:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZF4AuA640KI7pBir4Qhar3k9hqry5eGAFVKz1oIaqbU+meEqvoB6YfmJ7s8ixNBKcTSJhzxMq2WLBE0C6Wo35EbvFjlnYno71hpLi/sut4Sma3Snqgq6faVsqFTgfP8HRoXCzsnqCLtdXk4j/sfH9QTsUushYtJTYBUfjX7RqcGVMalQjdNX+vleUnWUVfv0j2wIBk3tPbnSfRzd2GMMe2tvi/L9tJ+pLi2e0/YvrRSIo/kNJIAZLSy/Mtr2b+bJVCP+ExMw7KyMuS021ef/psKH5lVRI6ZL0dMtn6vwoFQGO68Iie29+6erqQIutngr9T672K9qxnx1kOiMiHk18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9895JIXESIDlhteTNyrchzjEQ0f6oR/6lCW/y3B86QE=;
 b=cyd5HjRj5GjCFmuDRbzuObQLFJc7OMimxtbZ0Y5LSExjDbNt407x2ksSVXmnxxrSY8AVASML4eKO1HDZByasn2Rxjx73TjK14xLNOnRGedQPibVdAKGuF4B2o5HwLv+XbEbg14VgxkhfKFelxP0ahPTyCF0ELKLaZdpRiIA3gIVOiOmcGe21PBuEZ/fVrF2/2/HGMhsiTbudj8z0KMdC06jZ93aHgtOzQdzx+zVx+2lR2b8JVWyxevSVpkdBRtNgZT8a55O+djxD0pQFHMc+Z/d2jOWGhvURXhe2raT98pn6LCzuZsPthtx3C7O/YnD5r9YGDsfRQjcP7oCU80SuQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9895JIXESIDlhteTNyrchzjEQ0f6oR/6lCW/y3B86QE=;
 b=RwVRffCDimiWVmw8FNa8sArXl4u6j7hH79DN1Q14Sw6Y8NZgxQkHTZL+5E7B56yGHXtNJgnKUE3OJfCvurLaqMx6Kq/W4xzNgod0rGCBzLaIXF2qRiV5Xv9QFQcZ/Gfc5Nzmxs6YkNtRKySA2eAFyxk7ZO2LEBSX24eiQMKwCccVznXrq2mJKamkjmO7YvI9/83m209l8gv9XRFAxL+5BxJGUowhoFzdD12AwsX1hwbQQE0d3jxJRfagUhM5R8adna21t2Iix7SOycYgwE5BmG24820CR2sKtwBF9flRKNM1vvYuW4kZAxIeRBEmAt7Q9Qgt+Xq3N8XXxE9muhHNZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8179.eurprd03.prod.outlook.com (2603:10a6:20b:4e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 22:12:55 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 22:12:55 +0000
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
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v6 6/8] net: phylink: Adjust advertisement based on rate matching
Date:   Tue, 20 Sep 2022 18:12:33 -0400
Message-Id: <20220920221235.1487501-7-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6cf2b51c-c3e7-4423-cd94-08da9b554479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5xCOGeLkS5Uu1i+JrOsily/uGXmtMH4vF3wHD5Wthv43wa283fOv6rfaEQNY0DkLMCaDWNiQEDHIMYyLo3b2VGZu0LbWZJznCu0tLza+uqFzCT4/U7lukxAnbDnu05AX/rabh2JoY9khC9P7/g5KenO3XxkG66+GCiiIH7vQiyR3A0Go5fsivrTg+SnmxkfcwBcvWtVe1HbUl1RWieMYE/oC96jlZYeh9kkrCIShbF5pWd4WN0O78lkwDv+fjc/oaOvCXjNIDnSZ0vMc6PF8yw8pL7UxE3+ZPJKpOMDncm3N8mAKmhvoglnLsluQ5cxyhxbAOYwgMDQAuQ9vQUuVDo4tA4Yo+ydjmEDSIsvxi6kG6bUSkf4dpuStnQ8TpBKV8sK0GIiLqqyatnqc60mA3cRFC4rrdFXG8nxg3zMIdft2jdYT62gL7ji8lgh3rz42Kjh2jR4KMf8clYAcKRFdb9JCW747DQtmQg7m5mF28WlSXU07rrgWholSS6hJ7tTmRdE/EDuar3NnKUnrLPx/xPXCo1k9eYqEESuOYxrJTyORwNiWYtb6/vsDd6rNBGXi8WJypsQWjkKuoOQjIvXJQ/eCf5pPXAQpFpHHprsRERFCcj8gHsu1KCZRnDPIq/SOWCX62FubDgvJLy9eq3n4lHNT/Ki6hYuOUK3VaPoEBD9w4vkN+AmuOTSH8ihGTvb12vZ2//UCDTGZQA7EHUAn9HOzlDauTTgGXVRth7O34wVyxipT8A/MjfonSgzFgsiGMVZIxJveG83mNQQR9Cbbng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(396003)(376002)(346002)(136003)(451199015)(7416002)(8676002)(186003)(478600001)(1076003)(66476007)(66556008)(66946007)(4326008)(5660300002)(2616005)(44832011)(86362001)(8936002)(83380400001)(6486002)(26005)(316002)(54906003)(2906002)(6512007)(36756003)(110136005)(6506007)(38350700002)(6666004)(107886003)(41300700001)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZHX+1zcaSnpHR4XleLsliIdV4YI3ekn/awmxBX//NR/MLeX/ywZiA76Ss371?=
 =?us-ascii?Q?qnEWUKS+xxW2zGxXnyJNFyGuhxZRtXYe6F3y09WE7R8OcUE/Umfh39ePzDSF?=
 =?us-ascii?Q?dJJqeMihC3WMFWUdx0IW3mCYPJuNaat+alPYNoSP0nME6acHxAlOIzQPS6JE?=
 =?us-ascii?Q?+k/FDqFl/RFpuHtdmHhRISReJ45A6TPGzQbNvBxmUg+HHCpVyGHqFS81Q+Xc?=
 =?us-ascii?Q?5478EdvVJBlMXveSWQY6EOcO7p7Wk8ViGUW+ZuFckSfc11QaKgUIUgoQDIFh?=
 =?us-ascii?Q?fddBH/oRTEa3dIIEzUZY9amncD+TTWn25YKVwrjVKfS6IRUotceYO1z0iDfu?=
 =?us-ascii?Q?VQ17qctHHDkF8kgKcfTdCdpiuOxDTpVU/ORRAtrtRG+lQjmxjMo+EWjWdwhy?=
 =?us-ascii?Q?u1yusOT3Sry8gnCKfiQ5eswvRWsg7tNe7XZ38+ECnsm23uaDgD9PuNfHnisi?=
 =?us-ascii?Q?sSrcgsQPzBNh2bV3IOGPucTRe1jEMxz0D1pTX7Z0JAivPBHIMQv3+kB3hkQz?=
 =?us-ascii?Q?lZhZ/zAvdC6sdLK6xAXtsCziQKFaLCTB1If0XhmyuuameMKYfYof8DG4fKIe?=
 =?us-ascii?Q?mKG8ZbbWbha0T8uM+Y1G+dwey/noZONzfx3ubeQjrp3zCsitJM4MH0H2VJoK?=
 =?us-ascii?Q?hSJiwbw4sScghmNssnmshIv7l/5m0GFX7Km4zbPv+By7HYwx9OlCs/YCh8q4?=
 =?us-ascii?Q?8KLLmk+/uzunP+vMuYoGaOtuAojoowJ4MKrqfJzEH3mYoeiM1JOPs1vkKCSi?=
 =?us-ascii?Q?VtOL/YbFE82S7BpAsulZNyXkgQVKlurX+219QA8RoEodbCiN5MhMdEeBDUWH?=
 =?us-ascii?Q?rRbSGNdKV/fz7GcpccZiPhTWqvF+8OGkhpnR6ALlo6S7rUkaCCGgdy3S8n7H?=
 =?us-ascii?Q?v/nBz1UU7hBSjHMM4O1dhY5xYhNPvC6di1hFLdtcy41xp9J7b5hwWhp5+ZUJ?=
 =?us-ascii?Q?8tuprkJ3SZh5vk0Xjelc9nGJiJOhSvyuxjVC4qhbYmHqWTDTj4Pyo0ZlISWr?=
 =?us-ascii?Q?MafR8qJ0QdllY9xrV2m9lN4jVtwgMFUwCG/LO/iIY4pa+ViA9CSU+Ha0Cmol?=
 =?us-ascii?Q?4cDDwWpQOE0eSR9G2fNVEjF9BzkKdetZqwjemmQX/iAJC5swvhz/fEc20XA7?=
 =?us-ascii?Q?wp81yApx17Qd740voiaXSfpho8w210OE4XfuYlAPPuU8DZU1n5cuENfZQAU1?=
 =?us-ascii?Q?pFaHHq3ZU2c5llvveB8aK3VjrOpx22cuFKqZxt/ACkkW3U6uHgcjxTmxmB9N?=
 =?us-ascii?Q?6CzyYyXSBRpcCA+7SF9UX1V1QfikJVe56/iWDtUDzgEU8/lS3vqarb/9maMR?=
 =?us-ascii?Q?CTm8qosLS6W1XOavBEzCBAylDsb6GAqnmqGTz/c9tZosbxDBO5F9ebVJe5/H?=
 =?us-ascii?Q?Y5iVZ3gtZzKqm9h7y6kt05taai03ccDtQnnnwQwul83kKeHBbAaR3on1Af6C?=
 =?us-ascii?Q?jGc+iqL7myBAFL1XlyduuUIBql0M7bJVlMk8aFMLMlFrG9RYd+Sm3oR9s8OP?=
 =?us-ascii?Q?gj03dwtz/xCkYT1/472ftXwLrBxcO2uMAFK7K6sQMFqa5HSV55Jb0MxU3pIc?=
 =?us-ascii?Q?fzuW2L2tEa1aDj2LyzeYiyyEvUr8E9h13ihI7yGfB/tUL2ajFDCwFNIVIqsh?=
 =?us-ascii?Q?Ew=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf2b51c-c3e7-4423-cd94-08da9b554479
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 22:12:55.0798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83u3Oy1LDWiJqQJRf4LpttNtCZYcNFR6VHhWe0ju+o9NXSRSqQX1uqpOLqg49iN4bymrMYFnu/G9QnpIUWLSOA==
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

This adds support for adjusting the advertisement for pause-based rate
matching. This may result in a lossy link, since the final link settings
are not adjusted. Asymmetric pause support is necessary. It would be
possible for a MAC supporting only symmetric pause to use pause-based rate
adaptation, but only if pause reception was enabled as well.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v6:
- Rename rate adaptation to rate matching

Changes in v5:
- Move phylink_cap_from_speed_duplex to this commit

Changes in v3:
- Add phylink_cap_from_speed_duplex to look up the mac capability
  corresponding to the interface's speed.
- Include RATE_ADAPT_CRS; it's a few lines and it doesn't hurt.

Changes in v2:
- Determine the interface speed and max mac speed directly instead of
  guessing based on the caps.

 drivers/net/phy/phylink.c | 106 ++++++++++++++++++++++++++++++++++++--
 include/linux/phylink.h   |   3 +-
 2 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 4576395aaeb0..d0af026c9afa 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -373,18 +373,70 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 }
 EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
 
+static struct {
+	unsigned long mask;
+	int speed;
+	unsigned int duplex;
+} phylink_caps_params[] = {
+	{ MAC_400000FD, SPEED_400000, DUPLEX_FULL },
+	{ MAC_200000FD, SPEED_200000, DUPLEX_FULL },
+	{ MAC_100000FD, SPEED_100000, DUPLEX_FULL },
+	{ MAC_56000FD,  SPEED_56000,  DUPLEX_FULL },
+	{ MAC_50000FD,  SPEED_50000,  DUPLEX_FULL },
+	{ MAC_40000FD,  SPEED_40000,  DUPLEX_FULL },
+	{ MAC_25000FD,  SPEED_25000,  DUPLEX_FULL },
+	{ MAC_20000FD,  SPEED_20000,  DUPLEX_FULL },
+	{ MAC_10000FD,  SPEED_10000,  DUPLEX_FULL },
+	{ MAC_5000FD,   SPEED_5000,   DUPLEX_FULL },
+	{ MAC_2500FD,   SPEED_2500,   DUPLEX_FULL },
+	{ MAC_1000FD,   SPEED_1000,   DUPLEX_FULL },
+	{ MAC_1000HD,   SPEED_1000,   DUPLEX_HALF },
+	{ MAC_100FD,    SPEED_100,    DUPLEX_FULL },
+	{ MAC_100HD,    SPEED_100,    DUPLEX_HALF },
+	{ MAC_10FD,     SPEED_10,     DUPLEX_FULL },
+	{ MAC_10HD,     SPEED_10,     DUPLEX_HALF },
+};
+
+/**
+ * phylink_cap_from_speed_duplex - Get mac capability from speed/duplex
+ * @speed: the speed to search for
+ * @duplex: the duplex to search for
+ *
+ * Find the mac capability for a given speed and duplex.
+ *
+ * Return: A mask with the mac capability patching @speed and @duplex, or 0 if
+ *         there were no matches.
+ */
+static unsigned long phylink_cap_from_speed_duplex(int speed,
+						   unsigned int duplex)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(phylink_caps_params); i++) {
+		if (speed == phylink_caps_params[i].speed &&
+		    duplex == phylink_caps_params[i].duplex)
+			return phylink_caps_params[i].mask;
+	}
+
+	return 0;
+}
+
 /**
  * phylink_get_capabilities() - get capabilities for a given MAC
  * @interface: phy interface mode defined by &typedef phy_interface_t
  * @mac_capabilities: bitmask of MAC capabilities
+ * @rate_matching: type of rate matching being performed
  *
  * Get the MAC capabilities that are supported by the @interface mode and
  * @mac_capabilities.
  */
 unsigned long phylink_get_capabilities(phy_interface_t interface,
-				       unsigned long mac_capabilities)
+				       unsigned long mac_capabilities,
+				       int rate_matching)
 {
+	int max_speed = phylink_interface_max_speed(interface);
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
+	unsigned long matched_caps = 0;
 
 	switch (interface) {
 	case PHY_INTERFACE_MODE_USXGMII:
@@ -458,7 +510,53 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
 		break;
 	}
 
-	return caps & mac_capabilities;
+	switch (rate_matching) {
+	case RATE_MATCH_OPEN_LOOP:
+		/* TODO */
+		fallthrough;
+	case RATE_MATCH_NONE:
+		matched_caps = 0;
+		break;
+	case RATE_MATCH_PAUSE: {
+		/* The MAC must support asymmetric pause towards the local
+		 * device for this. We could allow just symmetric pause, but
+		 * then we might have to renegotiate if the link partner
+		 * doesn't support pause. This is because there's no way to
+		 * accept pause frames without transmitting them if we only
+		 * support symmetric pause.
+		 */
+		if (!(mac_capabilities & MAC_SYM_PAUSE) ||
+		    !(mac_capabilities & MAC_ASYM_PAUSE))
+			break;
+
+		/* We can't adapt if the MAC doesn't support the interface's
+		 * max speed at full duplex.
+		 */
+		if (mac_capabilities &
+		    phylink_cap_from_speed_duplex(max_speed, DUPLEX_FULL)) {
+			/* Although a duplex-matching phy might exist, we
+			 * conservatively remove these modes because the MAC
+			 * will not be aware of the half-duplex nature of the
+			 * link.
+			 */
+			matched_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
+			matched_caps &= ~(MAC_1000HD | MAC_100HD | MAC_10HD);
+		}
+		break;
+	}
+	case RATE_MATCH_CRS:
+		/* The MAC must support half duplex at the interface's max
+		 * speed.
+		 */
+		if (mac_capabilities &
+		    phylink_cap_from_speed_duplex(max_speed, DUPLEX_HALF)) {
+			matched_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
+			matched_caps &= mac_capabilities;
+		}
+		break;
+	}
+
+	return (caps & mac_capabilities) | matched_caps;
 }
 EXPORT_SYMBOL_GPL(phylink_get_capabilities);
 
@@ -482,7 +580,8 @@ void phylink_generic_validate(struct phylink_config *config,
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	caps = phylink_get_capabilities(state->interface,
-					config->mac_capabilities);
+					config->mac_capabilities,
+					state->rate_matching);
 	phylink_caps_to_linkmodes(mask, caps);
 
 	linkmode_and(supported, supported, mask);
@@ -1512,6 +1611,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		config.interface = PHY_INTERFACE_MODE_NA;
 	else
 		config.interface = interface;
+	config.rate_matching = phy_get_rate_matching(phy, config.interface);
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 5c99c21e42b5..664dd409feb9 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -554,7 +554,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 
 void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
 unsigned long phylink_get_capabilities(phy_interface_t interface,
-				       unsigned long mac_capabilities);
+				       unsigned long mac_capabilities,
+				       int rate_matching);
 void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
-- 
2.35.1.1320.gc452695387.dirty

