Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED2158020E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiGYPjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbiGYPjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:39:09 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2061.outbound.protection.outlook.com [40.107.20.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F451BE80;
        Mon, 25 Jul 2022 08:38:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OM9g7MqiXxaFPkFGU3kX9+THqekF010JkXidmNmOw+C1wejgfkGuNv2Va/u4kyvCOguKdAQMPVgaCJY0N062T3wQr9aB3yOF14UGhissfO2YiiAwfOXANJvjsKnwb6T0eytgIGCVRQ+yiwBXTFcwyK4Fu7eAF1xSlyFA4kzCkn322Mem7Lw1nCB52Ius3NKFbeCtwTrfQerwfWXqLAQ3LQkrdwMtzm6oYoAMWW9Yt6A0SO8zHe1l85bSP2No0NU0IJfizImi/8R4cvTgE/b7bEZ81FAubOlwud2jTcf2xP1z/amVjqUHZsk/ltMY/QZwhOVD9PbCk2yid7fu4Zkxqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8dmbFeS7qHQByd8PwNUfP4tC7VGvms1wAH41egRCh0=;
 b=ev7GhjP/xrQJGGCeoiQQViRCTW3JiXjuM9p7ED8LIrm1SMCdrjYhKaFeoZN0GUpPHkquVgXXqZ69dJv/TA436VEfsB+6yBHXYaX6f101ik81tog3aOFHtbYDawr9fyD7X0Uqgvz2nWFjweuG/tn3RZRs+bmweBKjsplhDrqacPYSAhfxdhqVCL0WDFip0Foyj6zamHr5dPlrqxvKPK137EOuS3pIp9u5monVRoBt4cXbRiMuFx1L5ZiOd4f7ge3UxOzuBfUMbieQGRuyaMnr1ek1fWf8q5qRKhgadUTcMdEZtHi0ljoqY+XmaLSMyrXz9X/Ep2d2G/mb9T0xkolWRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8dmbFeS7qHQByd8PwNUfP4tC7VGvms1wAH41egRCh0=;
 b=PuKyAzLUgzr9yOJbCkmi6Lpe/IkSsxBJPUncOwsq0QowpxSLbmMyag7Yva6k9W4ML98ZytGygUirCMxtbxrtMccdjgYNvdV+nNXNLuEAAjNM/hZQPCMJrnBzcrmpRVgk+FkpX5CLUhGLHAdZV2MJLI/xeWWRpWd2xOyXaCksn53SSZ9fMLucw1HOnugulZwXrLTR9NMUVpOHAh3npOAJdadfjO6Fg1gUGbwfv8U2XLoRcy9HQqbMF/y+oNhxzwtnh4d7IifgrB6TNLtw4/X1ZlIBBNYMOnEgRmu7BvgjyAKH+JYhh4Ts0zeIFRyZHw6ebztMibT4vdBJ+wtRLSfCmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB6464.eurprd03.prod.outlook.com (2603:10a6:800:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:37:56 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:37:56 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v3 09/11] net: phylink: Adjust advertisement based on rate adaptation
Date:   Mon, 25 Jul 2022 11:37:27 -0400
Message-Id: <20220725153730.2604096-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725153730.2604096-1-sean.anderson@seco.com>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03f56b34-413a-4e2c-05be-08da6e53a593
X-MS-TrafficTypeDiagnostic: VI1PR03MB6464:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aQSAQB9CZBJSkt1ktkSFWRapU1N/ZL3OYaFgEgj4JxFXeyXpE7870Ibq1gFXz+k5xITxlczw3858wXUUqqbOxTkWIjvu3pwfuww+qtxKAm/Mw4KUoXELX5x1oHQ15bUZ+TLsjDx8Q8MocXJ4oxCYnS7Xg6LECyL7CmIvrRyUfsTtiue82zEhCf5qKJoRhlbA2J6/4aahzn1SA5Gr/44EOx33J6oYSymWFvYkmCEmTxFqnxy5+d17BNEqextrEtF7Y7OLqMVi/qOs2TFrfP3l4CJNukPaz4NWpOwyg2ktm1saO7Y6BUNwkYo4xc6+FrE5eq7lWnENpbuM+VnTNHnSX31nSFAmrjPiDRexw9xq3pacWZvqqNcanf4pW6vYxC1ivg8RyF5HWtmlklTihccp3HWiOvoXuekf1WOGj0OWErn+73XvnZeQm10/tukyedfDE8UA90A3UOz0LZMJgRgcSp01m7MWz+R3uPdphzDwwB81Kwzx8italWVZCmVxpOfcuDZ+qtv4/pEruo0uGbq9nbm8eDUF2RjkR2Bv5qi3+jhGqzRXA+Y1CBke+2jdH9+kZpAXfzkIId2X6yFus5ORKkZdRKR2edulSpjXYJWfZN3FNUfuAgvb1OM+3+yderZZwvHQUqIftVbX0IpHpSk3HsNfkd+0377muDv/jLSIaB7jpdSx4j9NxyWQu8RdFaJzVtoy3Dq9MkXQUKqbr6FalBXwAJSkFQroi0agWYrMp+MSeBqQd/qk2R6vfK4ZctiTE+cgpKZPA6YG130X4pwMopSFpmkz6qwfIUjSCppayv4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O5+65M6RZ7lMp5YdEO+E7w8ujV/WieCvEak28XS04DTq54h6X8rjGwiKPggp?=
 =?us-ascii?Q?bivh+kviEg8aGGubjM2KA9fUp2lapA7P7qx5RbY8pBEzUvZTtmN02Wnz+ZFR?=
 =?us-ascii?Q?XYH4tubljG5fqy5MPSIWP55ksERvJHeAfQU3+8QlTdbuO4QkyVwSgO2xLLcC?=
 =?us-ascii?Q?5dEOQE0wKmGZCEs15pCGI9k1Me7FzBHNYSVAohl/HA6Y1HFR+KiwiaBIdRd4?=
 =?us-ascii?Q?6cTRl0d3C3IZ70mImRC0UiMQzOYEv1lROgDDyn7woQsvO2soHcgMSqfBgfD0?=
 =?us-ascii?Q?NQN1RDBnOuMmkqTPKhUKS2oih24PVtHbwrhLlj2rC3Axz5AvtLh8Sd/8c/L0?=
 =?us-ascii?Q?6SDlv/g7yPHc+Yuggp5dv58k12nad2XHsvyFO3mprAA+lzEx0TxPBSb8dmcE?=
 =?us-ascii?Q?RbFk0ur1zouH3MeiO+A+/8htGEzSLIFYZfT1cUwgpjSxfoka2f3VCqq23z3m?=
 =?us-ascii?Q?PfOa1+3jwiyXcjRXFJn9h1YpplnIbhYU0OOuV93XLWEZm0Fm0Xzx2y08S/4P?=
 =?us-ascii?Q?tsCz/LFR1TvJGvRKJ5FOr6O9wqXHbjxDscH+a8gNwx9mD8NmfSCggIsjxYbN?=
 =?us-ascii?Q?Ie0IT2crAROWJysk3yyhaRlnBzWmUu3LDyd71Zz1JCq5grIEtXn2jTWBNryl?=
 =?us-ascii?Q?QlXkcr1gziYD67Dvcne8817cm5yQ8hdVQHYRdllmHBnv24S8bdfMj0f7r9ON?=
 =?us-ascii?Q?6SOGZUpDVmPjBUdxPn5eRXCcBtXqG0NEfxIZwF86pz56xo2Pea8hRjsYE2Hu?=
 =?us-ascii?Q?SpG61XnjymcWCSftd662z/SQAFbH9/MIBDpd21s4vRk4Yi9VqkRZpfnRBnKB?=
 =?us-ascii?Q?Yr+yPZyfXmRgyT4MykIXQMcCje4F2lLUMamXk86x8EQ4fjY9DRtuxN1zJ6Wm?=
 =?us-ascii?Q?9n1fcj/1i2dfi+6QolJa3mpwUepq/v/wjZC/R46f2YGUXgSjjx0pUSxHpW+Y?=
 =?us-ascii?Q?wEcHKINaIXg7IM4PD/S+51j6/OzYpaSBTlO7+sLCclDHfKl87SCbHYw3LOOe?=
 =?us-ascii?Q?Y2eIyqrm9wYSRJhQw75b1Y8AtX1a3afPFsZHAD8B/bsB+ak4pOCHE7lSg9tv?=
 =?us-ascii?Q?BDA//qc0PmQnYTeXJZrnXmB4YNQXRw967mywibJrGMvbeKCDr1azUCpCwxr6?=
 =?us-ascii?Q?S44s5yvyAJK7XG+0IZT26vJUDyq+YMVCdAL4t6CPb/LL100Ljv6V8rmzfW8c?=
 =?us-ascii?Q?DAIQP0cikxbf7dboVhKmPuGyJcAEZzhbKPxOY1zQ9eXRqxzCpmGMRMqdMkv+?=
 =?us-ascii?Q?/ymCcKXbiWi+7X/fYjPRqCybuAXX4yNb+mCajlK21/fNWCuTBKGEsmTV/s54?=
 =?us-ascii?Q?Y+dPmPukqd8gZuo8kP8CO8Zh77/drNUjHLHx/yzi2Nv3gG4zy8tWy3Au7j1H?=
 =?us-ascii?Q?bq47fl8Q3vGlOmmb8SI3qa24YK8TD6iV/+takoPpfnYUxuHp+oEUqIUj5/r9?=
 =?us-ascii?Q?SQYj+8ItmtmVtx4Svd2VU6mST3PuOosYN+qaxVuVAhnVVyXzb+0ShDd5N4We?=
 =?us-ascii?Q?2O+/9EzRfbEG2/Ex2pdsXfIj/VxXsN7mrPDp+MDkuM83rm06cgWakZJQHEoI?=
 =?us-ascii?Q?EfJuHrDKTsFWuA+yaPkD8pGU1lF23tLtG1wmOhFANV+MH/Tt68qM2hUzJhqM?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03f56b34-413a-4e2c-05be-08da6e53a593
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:37:56.6969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96GI1+5emyXb4riKBE+TMuQXabviHnzdL3dnSxNQWDHjzwZlm7qf/ywlgbicqOUVv15H6Pzy+Ysfu/jCGmI7Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6464
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
- Add phylink_cap_from_speed_duplex to look up the mac capability
  corresponding to the interface's speed.
- Include RATE_ADAPT_CRS; it's a few lines and it doesn't hurt.

Changes in v2:
- Determine the interface speed and max mac speed directly instead of
  guessing based on the caps.

 drivers/net/phy/phylink.c | 58 +++++++++++++++++++++++++++++++++++++--
 include/linux/phylink.h   |  3 +-
 2 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 27b60a89ddc6..0eaca6f34413 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -456,14 +456,18 @@ static unsigned long phylink_cap_from_speed_duplex(int speed,
  * phylink_get_capabilities() - get capabilities for a given MAC
  * @interface: phy interface mode defined by &typedef phy_interface_t
  * @mac_capabilities: bitmask of MAC capabilities
+ * @rate_adaptation: type of rate adaptation being performed
  *
  * Get the MAC capabilities that are supported by the @interface mode and
  * @mac_capabilities.
  */
 unsigned long phylink_get_capabilities(phy_interface_t interface,
-				       unsigned long mac_capabilities)
+				       unsigned long mac_capabilities,
+				       int rate_adaptation)
 {
+	int max_speed = phylink_interface_max_speed(interface);
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
+	unsigned long adapted_caps = 0;
 
 	switch (interface) {
 	case PHY_INTERFACE_MODE_USXGMII:
@@ -536,7 +540,53 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
 		break;
 	}
 
-	return caps & mac_capabilities;
+	switch (rate_adaptation) {
+	case RATE_ADAPT_OPEN_LOOP:
+		/* TODO */
+		fallthrough;
+	case RATE_ADAPT_NONE:
+		adapted_caps = 0;
+		break;
+	case RATE_ADAPT_PAUSE: {
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
+			/* Although a duplex-adapting phy might exist, we
+			 * conservatively remove these modes because the MAC
+			 * will not be aware of the half-duplex nature of the
+			 * link.
+			 */
+			adapted_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
+			adapted_caps &= ~(MAC_1000HD | MAC_100HD | MAC_10HD);
+		}
+		break;
+	}
+	case RATE_ADAPT_CRS:
+		/* The MAC must support half duplex at the interface's max
+		 * speed.
+		 */
+		if (mac_capabilities &
+		    phylink_cap_from_speed_duplex(max_speed, DUPLEX_HALF)) {
+			adapted_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
+			adapted_caps &= mac_capabilities;
+		}
+		break;
+	}
+
+	return (caps & mac_capabilities) | adapted_caps;
 }
 EXPORT_SYMBOL_GPL(phylink_get_capabilities);
 
@@ -560,7 +610,8 @@ void phylink_generic_validate(struct phylink_config *config,
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	caps = phylink_get_capabilities(state->interface,
-					config->mac_capabilities);
+					config->mac_capabilities,
+					state->rate_adaptation);
 	phylink_caps_to_linkmodes(mask, caps);
 
 	linkmode_and(supported, supported, mask);
@@ -1586,6 +1637,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		config.interface = PHY_INTERFACE_MODE_NA;
 	else
 		config.interface = interface;
+	config.rate_adaptation = phy_get_rate_adaptation(phy, config.interface);
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 192a18a8674a..265a344e1039 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -543,7 +543,8 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
 int phylink_caps_find_max_speed(unsigned long caps, int *speed,
 				unsigned int *duplex);
 unsigned long phylink_get_capabilities(phy_interface_t interface,
-				       unsigned long mac_capabilities);
+				       unsigned long mac_capabilities,
+				       int rate_adaptation);
 void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
-- 
2.35.1.1320.gc452695387.dirty

