Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82FE857AAA6
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbiGSXvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239844AbiGSXvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:51:21 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0E061D8C;
        Tue, 19 Jul 2022 16:50:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMh9H/UU47odcuOJzAZtFG1OCnxrkzWymGcesS2UzM4DxK5U0XjLsaxcej0I/unRVdXrGGLXuvL4k3UEKphxQXBPz+x8oFLpBSs1J89v4SFqClojKc+dLAMsoxugrioPOTblk+1Ee+637ATlQGmuLwqFBnY3io0PoFQzQZUAWDGq7efSyLgmCcdlkcrRYtQgoHu+uXqh8XI5N/UkD9bR3gXmgGp1ksSmMtpr5DEWhUeDszkPl1Jza0cEFaWBczU/p6GVgfWPushzZsOhELUJal2PKYTU4X1dNKOoMPNhC6H+/4+DgK6WxfCSIw5E5d7wiZtUA8Xeal6ytcwpiG3kcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvunlWU2KE9Mn2hRVJ2Xi1ezKFam+0gIWSW3QXPlWHE=;
 b=HzVQO5tFG88YKj+h73k1Tkpv709s+zjaGUeDDFpjTELNUywBkwl1FtUcVKwF9t2ct31BuoxuNznDsyT//ItWtdDwrdqCQeliNDrdj48L6/rKgD54enyxA3BrxiIL6QZqDv0II3X6TF3TXxcp0x2szfcd5knBdpbuegd2O2UTvJHF0rR/3PBeSBAJxLYwwskL03yLlmzWbCMvktHMbOJIcsoe7TO0fbJ/6k6neYzF70dXRRyunnXc+Rtki3+q+OMEIBuI407xGUXcofUOlD6ZVVSXivDyLohwzxJPFBpJI0icbGW6POHKH87NADiFbQv26k1crzVf8sIUfhAnfQgAuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvunlWU2KE9Mn2hRVJ2Xi1ezKFam+0gIWSW3QXPlWHE=;
 b=NCmZWv6dhBocIf+IQ+Yfk9U+qXCxSnSU71A9OzSJ64HSAnQKaAxSc6yFKj8Poh4QYkhQxTXXRtfkDVbKeMDG6eiUu/3+9GPOGKXlhZz2q6jXebfUCKfOI1aT4qfM4spod8XWWCpkWVgruPGtIqoDW/RgZyxU0rbpU3GhUymwfWxDs9M5P69v+8kLrDgtKSZEHrWhAANWMQQmbwyqQAVuGN3JBzP4gHEdZovaag5Rxxx21BXceAZtOstkgea9W0oAp2WOqJIg0NEJYTnHv1jQazCjGfZXhN8vkE2EUssYBAhzj19zBAVzy/NEsb8Sse3qAFRaSWPzqfqcrHZIXpbSrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:32 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:32 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 06/11] net: phylink: Support differing link/interface speed/duplex
Date:   Tue, 19 Jul 2022 19:49:56 -0400
Message-Id: <20220719235002.1944800-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220719235002.1944800-1-sean.anderson@seco.com>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fb7843e-45fb-4bd7-f5a1-08da69e177c8
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UOz5YPtWlOOiubzPVPDfXh2YeL+JlLT2suM07pkoyUfREN6SaeHHulhLuJ1ytqTd2eg800P5wj+seybu6Ia4miAc19bdZA+rQJ/eZChv8aa85f3rrODqe6+mYNJf986qnkWbJVeClJnzF7vX5L93GSFjvqmGgR8lRQEPOkEwFDNIFOdTUB48HI8zfoudlCAQ3hNRP/C38eEePE3Ym9utb95Rffzx+X1gjGNsRCGfFwwYu61xlQt4w4TycqrybvoYUsnCYutYI0R1B7mbObHUS0KVUDbgxoMKscrAMvcG4SeIq0H+DVfWlv1OkzqWHAn3TT0/LUYQMxGctfa+FA7uUUhXBPK3zqto8iUEUz0YKF0i7FvKTosFjtMf5jtwjvEfO5y/PTawXackH3epJIAPEgjbsINO7HpI+olnvDOMKy2paXxfOMTSyOOW8VMeCPGX0q+3LYuFOzc33m/xBQw66BPtgTP2QWKy924o3YpOFmvLcEM6PDFC0kl2UF7MfTl1BxyV+2BJOQ0Or7GiPL9M0sNGWWD45CbAhxUb+KTihjls4WxoQ3cBbQGe2Agg2dInd+VYm3VYASd1Bm9xDXKjiiyKXKIb4iMApIj27wdoSR3soed+VlDdmOLewC2OSPDJhTKL+cMW3mjF+6Bqe67HbyfdkRqWbICmF+M9TIf5tUR8ujbZ/ICGG7knocRXJpGkRgiVH/IkXRbKb6oIuWW6ApI1MLV39nN4sngehyEHmap3FCjCXSrI/caHYkIHcyl29p9YW/cUsrw2vBjsq4lWxtzpsiedcUPsRBftaUziN5MxwDlsh09Fe5ncwpOnKIwzwAPZMz9fZkl9zuZQy3rW8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(107886003)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(30864003)(38100700002)(6486002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LzmLu36Tl8PwQF0BMgwEAIkgzKQwkA7IBxhGC0tG9NwmFp28BHUQCOuQKatd?=
 =?us-ascii?Q?y+bgdbbBk3NU6i65jZ1CUUtsSZBAxHsY8yuoeB5Ed/vJmc53dwGBXBxSXdAj?=
 =?us-ascii?Q?QJV2je7k1x14erh2XrfF0UJXR7IdR8XsG/sImXbbTJKtpaWxYrGoYDxBMs17?=
 =?us-ascii?Q?hwrQBcmaQXX3AR3rO5VNMaEnRSg/YzDQOcVmdHRIag8VWLxJ6CYWMMPr1CrD?=
 =?us-ascii?Q?pgdmBvOq1raL2wyW8K+rj7VYDv0p77xbjagHYNxX3L0SntVx7DeZYP2zjH2j?=
 =?us-ascii?Q?V207yHxLMdTa215LBnR57yfol41yzfErHdAM5HVeIOsEqftrLUIlfSqjQGG8?=
 =?us-ascii?Q?a1cfyS5ihoqqxwBvZkUD5ED6afrfGvWtfAHuBNYNm7qcNtTkIRqpTtErUuFK?=
 =?us-ascii?Q?FhIAPoRnguO8OZo/u3amrCkT/daL9+eMiPdX9IIibZkgNxgIAecGAL1w3Yyc?=
 =?us-ascii?Q?3QL/wa3ZM3tzc0U+mWtdqg01sXjwane3OmNU8Vnw7cC3BX03xQYcgpZYveu2?=
 =?us-ascii?Q?hisP+timnAx2BsQvJqGjNZ4soeel+m45vCJA4CTeAgvc2JGPxa1TY5A2fL/K?=
 =?us-ascii?Q?Xwu2sInVG+pCVwIqZIa5dSOgOwzg0boJlXSrgMPz1t9rxNeK77LqPRnP42Y1?=
 =?us-ascii?Q?AwH07biBYpB/4siI3ae1msuxCROZKzdQKgEzUo+FbkSi7c4ovndIb0U0pLRf?=
 =?us-ascii?Q?Kq5uRqYnbLjOrGS7zdwO/JUeJjpj0t6CaHXnX/SYMGvo4mpBWfG4dV/trfsh?=
 =?us-ascii?Q?rqBON1k/U/KHmaWlMeznnbeDtomE4b+NtHQ5ap0M4qhPcEvqUSuwzQfhkQRc?=
 =?us-ascii?Q?okccw31ogylluUHY1gmPlSE2lZUcCPBLYuvUN49qmZtsKpzxa3Fhapr26FTt?=
 =?us-ascii?Q?nqPCxyk0fERoWzMylyD6gcFuOmhtF5YVbv/xwaIOJwNhyJObo6Xxn9D/KPSV?=
 =?us-ascii?Q?Nl87/Xxt5kDS+5l1zfh5P/M79rDhiP0F7n2EJfqJ0N1mDXgI1/1hBHWdVqYx?=
 =?us-ascii?Q?1fUybCMxH8+OgPrc4hMK4OIGNwWtAEmAo3azdKqmOzU8K7emtMg1ykjlgvmr?=
 =?us-ascii?Q?HGpn4VRcD1rkRAehz/LiQlcIwznb6ydXaAM7SphqPJSalncJRUJPhGn8YLlZ?=
 =?us-ascii?Q?X0hR6rQSBiQatwJ70Xj+m0BjCQeNEGXJWKtLX9HMmtZtCyq4ijkYjzMc/7pb?=
 =?us-ascii?Q?EwShpIRaJ5cZnyJRWoquBzxy5rKk5zStWtu3vfBHA1IoI69kM1k7OiarzoNA?=
 =?us-ascii?Q?0IO8AnbpVHNhC5VeIfs9h5SWph2tmDh2GHAuKxj6ly1xwgOyD1iWx4sh7RX7?=
 =?us-ascii?Q?+i+QGW18B2sE4XlNQcg22fXktkEptlLQ+EqlbkPwZY++20sVzREPem6zqa76?=
 =?us-ascii?Q?ttCOPjTPDmiK0fOdWiHkV0lvg52YYvw/6saph/XlwcMckdAPsyKmOPrMXWse?=
 =?us-ascii?Q?papKGtNKGmsiro1YS6Qd/svVo14q5Ubnabqi5Ux0FdLlCxFQZOHKBzzitSdh?=
 =?us-ascii?Q?V/C5J65k1pqHEt1vVEpo1OEdHuryOLjhkPrIhUcTLifwdU5U2UaDJwO7soWe?=
 =?us-ascii?Q?JYKAH+eRlByb6bKj3/vIZY3P97ZvVFh1A9+GKl76MEg14wK47l6J4IKWnRu/?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb7843e-45fb-4bd7-f5a1-08da69e177c8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:32.6125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VqJ8rschuGQjJwNVQepVXeqttDfJ/60SkxCIW7iEQ7w9vxWlLpdWVV08uRO8ZgM5685Qi7WkipPzWmRPe0H+/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4811
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for cases when the link speed or duplex differs from
the speed or duplex of the phy interface mode. Such cases can occur when
some kind of rate adaptation is occurring.

The following terms are used within this and the following patches. I
do not believe the meaning of these terms are uncommon or surprising,
but for maximum clarity I would like to be explicit:

- Phy interface mode: the protocol used to communicate between the MAC
  or PCS (if used) and the phy. If no phy is in use, this is the same as
  the link mode. Each phy interface mode supported by Linux is a member
  of phy_interface_t.
- Link mode: the protocol used to communicate between the local phy (or
  PCS) and the remote phy (or PCS) over the physical medium. Each link
  mode supported by Linux is a member of ethtool_link_mode_bit_indices.
- Phy interface mode speed: the speed of unidirectional data transfer
  over a phy interface mode, including encoding overhead, but excluding
  protocol and flow-control overhead. The speed of a phy interface mode
  may vary. For example, SGMII may have a speed of 10, 100, or 1000
  Mbit/s.
- Link mode speed: similarly, the speed of unidirectional data transfer
  over a physical medium, including overhead, but excluding protocol and
  flow-control overhead. The speed of a link mode is usually fixed, but
  some exceptional link modes (such as 2BASE-TL) may vary their speed
  depending on the medium characteristics.

Before this patch, phylink assumed that the link mode speed was the same
as the phy interface mode speed. This is typically the case; however,
some phys have the ability to adapt between differing link mode and phy
interface mode speeds. To support these phys, this patch removes this
assumption, and adds a separate variable for link speed. Additionally,
to support rate adaptation, a MAC may need to have a certain duplex
(such as half or full). This may be different from the link's duplex. To
keep track of this distunction, this patch adds another variable to
track link duplex.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Support keeping track of link duplex
- Rewrite commit message for clarity
- Expand documentation of (link_)?(speed|duplex)
- Fix handling of speed/duplex gotten from MAC drivers

 drivers/net/phy/phylink.c | 112 ++++++++++++++++++++++++++------------
 include/linux/phylink.h   |  14 ++++-
 2 files changed, 88 insertions(+), 38 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 68a58ab6a8ed..da0623d94a64 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -155,6 +155,23 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
+/**
+ * phylink_state_fill_speed_duplex() - Update a state's interface speed and duplex
+ * @state: A link state
+ *
+ * Update the .speed and .duplex members of @state. We can determine them based
+ * on the .link_speed and .link_duplex. This function should be called whenever
+ * .link_speed and .link_duplex are updated.  For example, userspace deals with
+ * link speed and duplex, and not the interface speed and duplex. Similarly,
+ * phys deal with link speed and duplex and only implicitly the interface speed
+ * and duplex.
+ */
+static void phylink_state_fill_speed_duplex(struct phylink_link_state *state)
+{
+	state->speed = state->link_speed;
+	state->duplex = state->link_duplex;
+}
+
 /**
  * phylink_caps_to_linkmodes() - Convert capabilities to ethtool link modes
  * @linkmodes: ethtool linkmode mask (must be already initialised)
@@ -524,11 +541,11 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 	if (fixed_node) {
 		ret = fwnode_property_read_u32(fixed_node, "speed", &speed);
 
-		pl->link_config.speed = speed;
-		pl->link_config.duplex = DUPLEX_HALF;
+		pl->link_config.link_speed = speed;
+		pl->link_config.link_duplex = DUPLEX_HALF;
 
 		if (fwnode_property_read_bool(fixed_node, "full-duplex"))
-			pl->link_config.duplex = DUPLEX_FULL;
+			pl->link_config.link_duplex = DUPLEX_FULL;
 
 		/* We treat the "pause" and "asym-pause" terminology as
 		 * defining the link partner's ability.
@@ -566,9 +583,9 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 		ret = fwnode_property_read_u32_array(fwnode, "fixed-link",
 						     prop, ARRAY_SIZE(prop));
 		if (!ret) {
-			pl->link_config.duplex = prop[1] ?
+			pl->link_config.link_duplex = prop[1] ?
 						DUPLEX_FULL : DUPLEX_HALF;
-			pl->link_config.speed = prop[2];
+			pl->link_config.link_speed = prop[2];
 			if (prop[3])
 				__set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
 					  pl->link_config.lp_advertising);
@@ -578,16 +595,18 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 		}
 	}
 
-	if (pl->link_config.speed > SPEED_1000 &&
-	    pl->link_config.duplex != DUPLEX_FULL)
+	if (pl->link_config.link_speed > SPEED_1000 &&
+	    pl->link_config.link_duplex != DUPLEX_FULL)
 		phylink_warn(pl, "fixed link specifies half duplex for %dMbps link?\n",
-			     pl->link_config.speed);
+			     pl->link_config.link_speed);
 
+	phylink_state_fill_speed_duplex(&pl->link_config);
 	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	linkmode_copy(pl->link_config.advertising, pl->supported);
 	phylink_validate(pl, pl->supported, &pl->link_config);
 
-	s = phy_lookup_setting(pl->link_config.speed, pl->link_config.duplex,
+	s = phy_lookup_setting(pl->link_config.link_speed,
+			       pl->link_config.link_duplex,
 			       pl->supported, true);
 	linkmode_zero(pl->supported);
 	phylink_set(pl->supported, MII);
@@ -599,8 +618,8 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 		__set_bit(s->bit, pl->link_config.lp_advertising);
 	} else {
 		phylink_warn(pl, "fixed link %s duplex %dMbps not recognised\n",
-			     pl->link_config.duplex == DUPLEX_FULL ? "full" : "half",
-			     pl->link_config.speed);
+			     pl->link_config.link_duplex == DUPLEX_FULL ? "full" : "half",
+			     pl->link_config.link_speed);
 	}
 
 	linkmode_and(pl->link_config.advertising, pl->link_config.advertising,
@@ -757,7 +776,7 @@ static void phylink_resolve_flow(struct phylink_link_state *state)
 	bool tx_pause, rx_pause;
 
 	state->pause = MLO_PAUSE_NONE;
-	if (state->duplex == DUPLEX_FULL) {
+	if (state->link_duplex == DUPLEX_FULL) {
 		linkmode_resolve_pause(state->advertising,
 				       state->lp_advertising,
 				       &tx_pause, &rx_pause);
@@ -925,12 +944,16 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	linkmode_zero(state->lp_advertising);
 	state->interface = pl->link_config.interface;
 	state->an_enabled = pl->link_config.an_enabled;
-	if  (state->an_enabled) {
+	if (state->an_enabled) {
+		state->link_speed = SPEED_UNKNOWN;
+		state->link_duplex = DUPLEX_UNKNOWN;
 		state->speed = SPEED_UNKNOWN;
 		state->duplex = DUPLEX_UNKNOWN;
 		state->pause = MLO_PAUSE_NONE;
 	} else {
-		state->speed =  pl->link_config.speed;
+		state->link_speed = pl->link_config.link_speed;
+		state->link_duplex = pl->link_config.link_duplex;
+		state->speed = pl->link_config.speed;
 		state->duplex = pl->link_config.duplex;
 		state->pause = pl->link_config.pause;
 	}
@@ -944,6 +967,9 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 		pl->mac_ops->mac_pcs_get_state(pl->config, state);
 	else
 		state->link = 0;
+
+	state->link_speed = state->speed;
+	state->link_duplex = state->duplex;
 }
 
 /* The fixed state is... fixed except for the link state,
@@ -953,10 +979,17 @@ static void phylink_get_fixed_state(struct phylink *pl,
 				    struct phylink_link_state *state)
 {
 	*state = pl->link_config;
-	if (pl->config->get_fixed_state)
+	if (pl->config->get_fixed_state) {
 		pl->config->get_fixed_state(pl->config, state);
-	else if (pl->link_gpio)
+		/* FIXME: these should not be updated, but
+		 * bcm_sf2_sw_fixed_state does it anyway
+		 */
+		state->link_speed = state->speed;
+		state->link_duplex = state->duplex;
+		phylink_state_fill_speed_duplex(state);
+	} else if (pl->link_gpio) {
 		state->link = !!gpiod_get_value_cansleep(pl->link_gpio);
+	}
 
 	phylink_resolve_flow(state);
 }
@@ -1027,8 +1060,8 @@ static void phylink_link_up(struct phylink *pl,
 
 	phylink_info(pl,
 		     "Link is Up - %s/%s - flow control %s\n",
-		     phy_speed_to_str(link_state.speed),
-		     phy_duplex_to_str(link_state.duplex),
+		     phy_speed_to_str(link_state.link_speed),
+		     phy_duplex_to_str(link_state.link_duplex),
 		     phylink_pause_to_str(link_state.pause));
 }
 
@@ -1279,8 +1312,9 @@ struct phylink *phylink_create(struct phylink_config *config,
 		pl->link_port = PORT_MII;
 	pl->link_config.interface = iface;
 	pl->link_config.pause = MLO_PAUSE_AN;
-	pl->link_config.speed = SPEED_UNKNOWN;
-	pl->link_config.duplex = DUPLEX_UNKNOWN;
+	pl->link_config.link_speed = SPEED_UNKNOWN;
+	pl->link_config.link_duplex = DUPLEX_UNKNOWN;
+	phylink_state_fill_speed_duplex(&pl->link_config);
 	pl->link_config.an_enabled = true;
 	pl->mac_ops = mac_ops;
 	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
@@ -1344,8 +1378,8 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	phy_get_pause(phydev, &tx_pause, &rx_pause);
 
 	mutex_lock(&pl->state_mutex);
-	pl->phy_state.speed = phydev->speed;
-	pl->phy_state.duplex = phydev->duplex;
+	pl->phy_state.link_speed = phydev->speed;
+	pl->phy_state.link_duplex = phydev->duplex;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
 		pl->phy_state.pause |= MLO_PAUSE_TX;
@@ -1353,6 +1387,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 		pl->phy_state.pause |= MLO_PAUSE_RX;
 	pl->phy_state.interface = phydev->interface;
 	pl->phy_state.link = up;
+	phylink_state_fill_speed_duplex(&pl->phy_state);
 	mutex_unlock(&pl->state_mutex);
 
 	phylink_run_resolve(pl);
@@ -1422,8 +1457,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	pl->phydev = phy;
 	pl->phy_state.interface = interface;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
-	pl->phy_state.speed = SPEED_UNKNOWN;
-	pl->phy_state.duplex = DUPLEX_UNKNOWN;
+	pl->phy_state.link_speed = SPEED_UNKNOWN;
+	pl->phy_state.link_duplex = DUPLEX_UNKNOWN;
+	phylink_state_fill_speed_duplex(&pl->phy_state);
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
 
@@ -1866,8 +1902,8 @@ static void phylink_get_ksettings(const struct phylink_link_state *state,
 {
 	phylink_merge_link_mode(kset->link_modes.advertising, state->advertising);
 	linkmode_copy(kset->link_modes.lp_advertising, state->lp_advertising);
-	kset->base.speed = state->speed;
-	kset->base.duplex = state->duplex;
+	kset->base.speed = state->link_speed;
+	kset->base.duplex = state->link_duplex;
 	kset->base.autoneg = state->an_enabled ? AUTONEG_ENABLE :
 				AUTONEG_DISABLE;
 }
@@ -1983,14 +2019,14 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		 * If the link parameters match, accept them but do nothing.
 		 */
 		if (pl->cur_link_an_mode == MLO_AN_FIXED) {
-			if (s->speed != pl->link_config.speed ||
-			    s->duplex != pl->link_config.duplex)
+			if (s->speed != pl->link_config.link_speed ||
+			    s->duplex != pl->link_config.link_duplex)
 				return -EINVAL;
 			return 0;
 		}
 
-		config.speed = s->speed;
-		config.duplex = s->duplex;
+		config.link_speed = s->speed;
+		config.link_duplex = s->duplex;
 		break;
 
 	case AUTONEG_ENABLE:
@@ -2005,8 +2041,8 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 			return 0;
 		}
 
-		config.speed = SPEED_UNKNOWN;
-		config.duplex = DUPLEX_UNKNOWN;
+		config.link_speed = SPEED_UNKNOWN;
+		config.link_duplex = DUPLEX_UNKNOWN;
 		break;
 
 	default:
@@ -2036,6 +2072,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		}
 
 		/* Revalidate with the selected interface */
+		phylink_state_fill_speed_duplex(&config);
 		linkmode_copy(support, pl->supported);
 		if (phylink_validate(pl, support, &config)) {
 			phylink_err(pl, "validation of %s/%s with support %*pb failed\n",
@@ -2046,6 +2083,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		}
 	} else {
 		/* Validate without changing the current supported mask. */
+		phylink_state_fill_speed_duplex(&config);
 		linkmode_copy(support, pl->supported);
 		if (phylink_validate(pl, support, &config))
 			return -EINVAL;
@@ -2056,9 +2094,10 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		return -EINVAL;
 
 	mutex_lock(&pl->state_mutex);
-	pl->link_config.speed = config.speed;
-	pl->link_config.duplex = config.duplex;
+	pl->link_config.link_speed = config.link_speed;
+	pl->link_config.link_duplex = config.link_duplex;
 	pl->link_config.an_enabled = config.an_enabled;
+	phylink_state_fill_speed_duplex(&pl->link_config);
 
 	if (pl->link_config.interface != config.interface) {
 		/* The interface changed, e.g. 1000base-X <-> 2500base-X */
@@ -2597,10 +2636,11 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	memset(&config, 0, sizeof(config));
 	linkmode_copy(config.advertising, advertising);
 	config.interface = PHY_INTERFACE_MODE_NA;
-	config.speed = SPEED_UNKNOWN;
-	config.duplex = DUPLEX_UNKNOWN;
+	config.link_speed = SPEED_UNKNOWN;
+	config.link_duplex = DUPLEX_UNKNOWN;
 	config.pause = MLO_PAUSE_AN;
 	config.an_enabled = pl->link_config.an_enabled;
+	phylink_state_fill_speed_duplex(&config);
 
 	/* Ignore errors if we're expecting a PHY to attach later */
 	ret = phylink_validate(pl, support, &config);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 5008ec3dcade..ab5edc1e5330 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -56,8 +56,16 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
  * @lp_advertising: ethtool bitmask containing link partner advertised link
  *   modes
  * @interface: link &typedef phy_interface_t mode
- * @speed: link speed, one of the SPEED_* constants.
- * @duplex: link duplex mode, one of DUPLEX_* constants.
+ * @speed: interface speed, one of the SPEED_* constants. This is the speed of
+ *   the host-side interface to the phy. If @rate_adaptation is being
+ *   performed, this will be different from @link_speed.
+ * @link_speed: link speed, one of the SPEED_* constants. This is the speed of
+ *   the line-side interface to the link partner.
+ * @duplex: interface duplex mode, one of DUPLEX_* constants. This is the
+ *   duplex of then host-side interface to the phy. If @rate_adaptation is
+ *   being performed, this may be different from @link_duplex.
+ * @link_duplex: link duplex, one of the DUPLEX_* constants. This is the duplex
+ *   of the line-side interface to the link partner.
  * @pause: link pause state, described by MLO_PAUSE_* constants.
  * @link: true if the link is up.
  * @an_enabled: true if autonegotiation is enabled/desired.
@@ -68,7 +76,9 @@ struct phylink_link_state {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	phy_interface_t interface;
 	int speed;
+	int link_speed;
 	int duplex;
+	int link_duplex;
 	int pause;
 	unsigned int link:1;
 	unsigned int an_enabled:1;
-- 
2.35.1.1320.gc452695387.dirty

