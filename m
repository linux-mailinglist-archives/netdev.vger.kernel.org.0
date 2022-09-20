Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE565BEFEC
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiITWNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiITWND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:13:03 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34A878233;
        Tue, 20 Sep 2022 15:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8m6Vt3hKmPFeuXlwspo3zKNdVbSseYHxuZNKiKNkBGLJceFp5yF5Gxs/dxJ66fv2mhiljcihBKvEALvvVXqYDAdeowZUYmqQISFgissCzdY1gN8vUdA0gn5AfIeIOBzYvoOeX3FxJzQh7aFHw+n+akawo9/iTLDZoJmDnkkYzTg9COjBT4yUej7SczTDEjSM12XRXgrg+6a/g7MrLsifrVIwzHy/FuJZY75XRQeBFAGzlBb+c7c2DQ+jrj65UzOC1MVzje+CIJx/GCHgDqPgNCFYlYcWa4WhhvyFnTTEbHWTF4X6F7ve0BssCGOuVKBr3CtOUuy07VvQuHkXfhAHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJxMvkQ9hIoBvFna+ofuSFcQfePiG1W7265Nn/3taas=;
 b=NdDVdiDgJmIkDsyn2DQUYm7uQcijV9Jrz9uDJ6+NYYETps2jcOO7I/TpcTA6gO/w75iVFsdz8HSTJJMDzkuhYUaaTBB52aWJz+sjsnbZ5VMHn5HEn2HM8TRTyNqLPI7HXHm9eDRM1yG/FA9AwcHEsOt9vdg+vLlBX8+ghYyqC3LtFnYzW3nBTICT+obXDy0ECovZBW4Z2fM501L6W8an9wYZJfCOqMmqj+LiJ0fXiVvirl7pHeFjCx910636MkwwedRro0hCxzx7fC2lbiXDNs/ij2ZM/mSOWVjXUsDm9ZAlL/RJtK+o1I4ZN9STSd0/5+6sRk5Z9/LgsZ32SFnkZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJxMvkQ9hIoBvFna+ofuSFcQfePiG1W7265Nn/3taas=;
 b=X6bWniUZNG8FlNilKbykbJAFx0SwgE2vwN1NlZF60RJnnQ3hHYcW5U1YhSVAoGuDxTe0hSZ670/VF+CNGakS6aqIxRNpTmTKogtAHXgvHhbFmRemY+YFS1iKHLtFqsHuekyVFatdewLR+hMwp+eINt23KtQ/2CmvtRT3GNbBGxlkjZ7U+MK6HkiGDQvcJqGc8IORBlv+LpzLeDQ+g606VbPA9jlvJp/uEEaHK6ZKmVf1MgtdaQeMsGitpgoTosKnEF6/DEOuUBiZJZ9NIClUW4YO4W48OhjpAfUg8+zvNWYqrYMkKbf/s/gWT4ztmiLrh+pRfmiIeMJo07b6IW4e1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8179.eurprd03.prod.outlook.com (2603:10a6:20b:4e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 22:12:53 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 22:12:53 +0000
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
Subject: [PATCH net-next v6 5/8] net: phylink: Adjust link settings based on rate matching
Date:   Tue, 20 Sep 2022 18:12:32 -0400
Message-Id: <20220920221235.1487501-6-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: bd703b46-8d2e-4851-9ff4-08da9b5543a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tilVrqIHDs/HjRIBDETQloJkJODSEd04bbeMyhuKn0cFI5eCKmyiuupN9UtuSNmKyR6UfuedcRGlGPYes4asvSsZrlhjk7SiehzGYZOWNX9sBbowNhVsRPlRS1aFskURqFAshPQiqoPJ5SJs9vkp8Wd3PrIcgxLYHg3QApVPPGkNykY6vgkwSXcmRvy8NdUuyJF4b6ePgVrrW4Zg364ka8X9VKqwfqitAKCZ3ho7zYYrz72vRTrXpY2W5aw0O5GrbRXJx1w6nu86Yetxb67Vf7rv8ZPD0zadTufcWT0gsrihOefuE0dAMPTWSW0w3t0NXCojw58RjeDHPmAdxvroqo36Bxyqi+JbsSem8ihhQbHTLIzatj8TSvUsrGVPDyiwMfQRIcq5VJAsGzglI6qyffBUdqJzMrmKmKa5xb/5+hvAWfN6K23u2DAMenTzRdkSzc5xFJZezLU7zEstK3es2A7NnvxX5Dqmjgp8jhYktolF9WLR4GG+tUQiC2rUqfxTt5VX2ZqDHonPPACLlf0Y5ZQ+1iwZDB81NlR1cBaAwpOPIdKh06WHp3ZTLl4w3o69zKGnCybEg2qwbbxNgVv1iNtLx+HTYxIv1IRfsSGs4eb63gmmV72oWRhOvJT0qFzpNc3ydrjnkSNMyzO7T4/H/S4YIqtUbUzhIa0tsvxsNWlesyMUwkCrdbI0iPH+NnjYYXDyc7xN52wG+oLmDsFTvvs/gHXhiMab1keyaEmNbk/Mr4lpV0KBb/9oSBvYLc67wDKLmdrm2qK2DYwk+ee9ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(396003)(376002)(346002)(136003)(84040400005)(451199015)(7416002)(8676002)(186003)(478600001)(1076003)(66476007)(66556008)(66946007)(4326008)(5660300002)(2616005)(44832011)(86362001)(8936002)(83380400001)(6486002)(26005)(316002)(54906003)(2906002)(6512007)(36756003)(110136005)(6506007)(38350700002)(6666004)(107886003)(41300700001)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?irsz6bnEdtuNoMBrHurQ+isAx7+hYJMRLffBK8RClbqd1nv76wP4Zt361QKf?=
 =?us-ascii?Q?EPBSWh84WCwu34yRZgeb/t2StBluXsk6i3U/ds2LgJgv7w6g8v9byQzE/dUu?=
 =?us-ascii?Q?lndFJVhTlNdf5s3CXxVChGVTp3vZmGlyfPTrs1RSumI3xj/+Z3r3YWSu4PFA?=
 =?us-ascii?Q?e8gPKZVq/HMtGUjt7CV7mfF9JB99eNcr97o0NCJzVUaafObMrZ+oHLj9l10n?=
 =?us-ascii?Q?lmq8y52EsBWC+LnXidARDDGl7EVjXsem5CphoCXsL3jDbIr+ubCpPioDC4Ss?=
 =?us-ascii?Q?/pgi9c+rSX8+fjS0THRcDLIrF0iU6byZ8FsDqvu8AyhZG8zhNKzsF2aC/Rt3?=
 =?us-ascii?Q?FPPVnoO2irf8rkkLorKD/2BPMHsAep4R26POYF3T2bgpqXmiBdfOGDainOmo?=
 =?us-ascii?Q?Ul8J5SOa1KE65XQJ922vHDIFgOq/3+SnXrPW3iWQqdToRfCznHHzZQ0x/3fz?=
 =?us-ascii?Q?SOpJvjDdUYVEEveb8ZMAIsF37k4zMOr2lq3ngm8NHRdMv1zwaKHCF9tUOo12?=
 =?us-ascii?Q?3EUof6391eUi7WKM9CG9m3q1Gmphzh2N8uEaUZgSVLd4+DRPNKYFCTNbeYlp?=
 =?us-ascii?Q?3BmKQHUWQW12HaraTSrLNVEBiYuQw5MCPBKvy3k7U/10wbpGgh4XvpIga6fO?=
 =?us-ascii?Q?PzqqI5T2wDdoXcPqsE/K/qPfLha/3NUzOkuk5tK5tHy9PH+jH6RwAYSIgWMK?=
 =?us-ascii?Q?WtABBwFjV11+tsNL3E5fG+HnzIEXd/Li4kiiHn1N+N/FQz9HTMzJ+FBkDxcc?=
 =?us-ascii?Q?By7xdjCN7duBgDxT4sKUjhDVZyhb/nLwwXyTSvLzXzL15SUeMJNZhwsfG3A6?=
 =?us-ascii?Q?xU5ZsAeXy/eWPhvdXakJYS55rHTqG1QaEVFfhVUt8OWzN2x2R1PHqwb4CbNz?=
 =?us-ascii?Q?+mmqlnRrI6FG8dakoqcc6M21tLTQ3DE2vPrYeNQ9lhfl/akSHJcEVR5e2s52?=
 =?us-ascii?Q?fUeqjBdY4QK5JxDaGx9v+FSyN1sOHJGlNlyKdr0AQ4pEKODdc2M1b4YEzeFO?=
 =?us-ascii?Q?WM8JNhQNmcktavhFORndfCcUJ0gr92Upl5c/1lUFw9ZbNoO4DdFN3VjgFwrh?=
 =?us-ascii?Q?RT4eAYSfq+mddgVyMBMczaCGbvQrgTUdTCFPEZolvA9PxFnpTYb/+ZO9Gd/t?=
 =?us-ascii?Q?jE/Q6AlpyXTR8A/Qt82p0In50rBH0xlcc9/qmngwoEuxDnMSlLEQbIyMoWDl?=
 =?us-ascii?Q?p8JMWD7FlfwnbKv/cAYakJIgWKjBh/N3IVzxjxfzRuMHI0SMyg0ZfaXVfnCH?=
 =?us-ascii?Q?ukLlXRno6+7ez+Eni6H2z8nAeDPvc6mVAVbPjOJGr0477BVdSzwB1xyiuy8s?=
 =?us-ascii?Q?zTI5ttZzTjlqwY4ix+0ZPBwP0/SDdn4UmTUldwJv2mj7DKpwUCUT8aifn9rL?=
 =?us-ascii?Q?ZlZf+Nohr0wm1XpsWmv3NtpGMS1ZtLrxSnuqS3couZ00sE+h4lsTN5Fo65Dn?=
 =?us-ascii?Q?9mJY7tucfa7x9rxvBI5htPWJuOVxpj4uCmeitQI050/tcV7lRpvtgRrZdkO8?=
 =?us-ascii?Q?+s4387SsntMTZFCOYrRHm2jtQJxg3q2OcXCyfloMt03Z3zaJsGwf6KTJ76nf?=
 =?us-ascii?Q?Ihmd7pO7DNqntpyfkq/DDm1n3hxehnLzbYwHIr0INwJoNyz/cZoGos01DINK?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd703b46-8d2e-4851-9ff4-08da9b5543a5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 22:12:53.6737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P88eS/jRf80XM3HQalydOnVSo24i0QPfvuwG5j+fHTmlTbmzPYc0l10nXpfCHIOsjEAqhYc8Xxd4QphPPR/C+w==
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

If the phy is configured to use pause-based rate matching, ensure that
the link is full duplex with pause frame reception enabled. As
suggested, if pause-based rate matching is enabled by the phy, then
pause reception is unconditionally enabled.

The interface duplex is determined based on the rate matching type.
When rate matching is enabled, so is the speed. We assume the maximum
interface speed is used. This is only relevant for MLO_AN_PHY. For
MLO_AN_INBAND, the MAC/PCS's view of the interface speed will be used.

Although there are no RATE_ADAPT_CRS phys in-tree, it has been added for
comparison (and the implementation is quite simple).

Co-developed-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
Russell, I need your SoB as well as RB, since you wrote some of this.

Changes in v6:
- Don't announce that we've enabled pause frames for rate adaptation
- Rename rate adaptation to rate matching

Changes in v4:
- Remove phylink_interface_max_speed, which was accidentally added

Changes in v3:
- Modify link settings directly in phylink_link_up, instead of doing
  things more indirectly via link_*.

Changes in v2:
- Always use the rate adaptation setting to determine the interface
  speed/duplex (instead of sometimes using the interface mode).
- Use the phy's rate adaptation setting to determine whether to use its
  link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.

 drivers/net/phy/phylink.c | 135 ++++++++++++++++++++++++++++++++++----
 include/linux/phylink.h   |   5 ++
 2 files changed, 128 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7f0c49c2b09d..4576395aaeb0 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -155,6 +155,75 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
+/**
+ * phylink_interface_max_speed() - get the maximum speed of a phy interface
+ * @interface: phy interface mode defined by &typedef phy_interface_t
+ *
+ * Determine the maximum speed of a phy interface. This is intended to help
+ * determine the correct speed to pass to the MAC when the phy is performing
+ * rate matching.
+ *
+ * Return: The maximum speed of @interface
+ */
+static int phylink_interface_max_speed(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_100BASEX:
+	case PHY_INTERFACE_MODE_REVRMII:
+	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_SMII:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_MII:
+		return SPEED_100;
+
+	case PHY_INTERFACE_MODE_TBI:
+	case PHY_INTERFACE_MODE_MOCA:
+	case PHY_INTERFACE_MODE_RTBI:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_1000BASEKX:
+	case PHY_INTERFACE_MODE_TRGMII:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_GMII:
+		return SPEED_1000;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return SPEED_2500;
+
+	case PHY_INTERFACE_MODE_5GBASER:
+		return SPEED_5000;
+
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
+		return SPEED_10000;
+
+	case PHY_INTERFACE_MODE_25GBASER:
+		return SPEED_25000;
+
+	case PHY_INTERFACE_MODE_XLGMII:
+		return SPEED_40000;
+
+	case PHY_INTERFACE_MODE_INTERNAL:
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_MAX:
+		/* No idea! Garbage in, unknown out */
+		return SPEED_UNKNOWN;
+	}
+
+	/* If we get here, someone forgot to add an interface mode above */
+	WARN_ON_ONCE(1);
+	return SPEED_UNKNOWN;
+}
+
 /**
  * phylink_caps_to_linkmodes() - Convert capabilities to ethtool link modes
  * @linkmodes: ethtool linkmode mask (must be already initialised)
@@ -791,11 +860,12 @@ static void phylink_mac_config(struct phylink *pl,
 			       const struct phylink_link_state *state)
 {
 	phylink_dbg(pl,
-		    "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
+		    "%s: mode=%s/%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
 		    __func__, phylink_an_mode_str(pl->cur_link_an_mode),
 		    phy_modes(state->interface),
 		    phy_speed_to_str(state->speed),
 		    phy_duplex_to_str(state->duplex),
+		    phy_rate_matching_to_str(state->rate_matching),
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
 		    state->pause, state->link, state->an_enabled);
 
@@ -932,7 +1002,8 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	linkmode_zero(state->lp_advertising);
 	state->interface = pl->link_config.interface;
 	state->an_enabled = pl->link_config.an_enabled;
-	if  (state->an_enabled) {
+	state->rate_matching = pl->link_config.rate_matching;
+	if (state->an_enabled) {
 		state->speed = SPEED_UNKNOWN;
 		state->duplex = DUPLEX_UNKNOWN;
 		state->pause = MLO_PAUSE_NONE;
@@ -1015,19 +1086,43 @@ static void phylink_link_up(struct phylink *pl,
 			    struct phylink_link_state link_state)
 {
 	struct net_device *ndev = pl->netdev;
+	int speed, duplex;
+	bool rx_pause;
+
+	speed = link_state.speed;
+	duplex = link_state.duplex;
+	rx_pause = !!(link_state.pause & MLO_PAUSE_RX);
+
+	switch (link_state.rate_matching) {
+	case RATE_MATCH_PAUSE:
+		/* The PHY is doing rate matchion from the media rate (in
+		 * the link_state) to the interface speed, and will send
+		 * pause frames to the MAC to limit its transmission speed.
+		 */
+		speed = phylink_interface_max_speed(link_state.interface);
+		duplex = DUPLEX_FULL;
+		rx_pause = true;
+		break;
+
+	case RATE_MATCH_CRS:
+		/* The PHY is doing rate matchion from the media rate (in
+		 * the link_state) to the interface speed, and will cause
+		 * collisions to the MAC to limit its transmission speed.
+		 */
+		speed = phylink_interface_max_speed(link_state.interface);
+		duplex = DUPLEX_HALF;
+		break;
+	}
 
 	pl->cur_interface = link_state.interface;
 
 	if (pl->pcs && pl->pcs->ops->pcs_link_up)
 		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
-					 pl->cur_interface,
-					 link_state.speed, link_state.duplex);
+					  pl->cur_interface, speed, duplex);
 
-	pl->mac_ops->mac_link_up(pl->config, pl->phydev,
-				 pl->cur_link_an_mode, pl->cur_interface,
-				 link_state.speed, link_state.duplex,
-				 !!(link_state.pause & MLO_PAUSE_TX),
-				 !!(link_state.pause & MLO_PAUSE_RX));
+	pl->mac_ops->mac_link_up(pl->config, pl->phydev, pl->cur_link_an_mode,
+				 pl->cur_interface, speed, duplex,
+				 !!(link_state.pause & MLO_PAUSE_TX), rx_pause);
 
 	if (ndev)
 		netif_carrier_on(ndev);
@@ -1119,6 +1214,17 @@ static void phylink_resolve(struct work_struct *w)
 				}
 				link_state.interface = pl->phy_state.interface;
 
+				/* If we are doing rate matching, then the
+				 * link speed/duplex comes from the PHY
+				 */
+				if (pl->phy_state.rate_matching) {
+					link_state.rate_matching =
+						pl->phy_state.rate_matching;
+					link_state.speed = pl->phy_state.speed;
+					link_state.duplex =
+						pl->phy_state.duplex;
+				}
+
 				/* If we have a PHY, we need to update with
 				 * the PHY flow control bits.
 				 */
@@ -1353,6 +1459,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	mutex_lock(&pl->state_mutex);
 	pl->phy_state.speed = phydev->speed;
 	pl->phy_state.duplex = phydev->duplex;
+	pl->phy_state.rate_matching = phydev->rate_matching;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
 		pl->phy_state.pause |= MLO_PAUSE_TX;
@@ -1364,10 +1471,11 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 
 	phylink_run_resolve(pl);
 
-	phylink_dbg(pl, "phy link %s %s/%s/%s/%s\n", up ? "up" : "down",
+	phylink_dbg(pl, "phy link %s %s/%s/%s/%s/%s\n", up ? "up" : "down",
 		    phy_modes(phydev->interface),
 		    phy_speed_to_str(phydev->speed),
 		    phy_duplex_to_str(phydev->duplex),
+		    phy_rate_matching_to_str(phydev->rate_matching),
 		    phylink_pause_to_str(pl->phy_state.pause));
 }
 
@@ -1431,6 +1539,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	pl->phy_state.speed = SPEED_UNKNOWN;
 	pl->phy_state.duplex = DUPLEX_UNKNOWN;
+	pl->phy_state.rate_matching = RATE_MATCH_NONE;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
 
@@ -1873,8 +1982,10 @@ static void phylink_get_ksettings(const struct phylink_link_state *state,
 {
 	phylink_merge_link_mode(kset->link_modes.advertising, state->advertising);
 	linkmode_copy(kset->link_modes.lp_advertising, state->lp_advertising);
-	kset->base.speed = state->speed;
-	kset->base.duplex = state->duplex;
+	if (kset->base.rate_matching == RATE_MATCH_NONE) {
+		kset->base.speed = state->speed;
+		kset->base.duplex = state->duplex;
+	}
 	kset->base.autoneg = state->an_enabled ? AUTONEG_ENABLE :
 				AUTONEG_DISABLE;
 }
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index cc039ae7e80c..5c99c21e42b5 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -88,6 +88,10 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
  * @speed: link speed, one of the SPEED_* constants.
  * @duplex: link duplex mode, one of DUPLEX_* constants.
  * @pause: link pause state, described by MLO_PAUSE_* constants.
+ * @rate_matching: rate matching being performed, one of the RATE_MATCH_*
+ *   constants. If rate matching is taking place, then the speed/duplex of
+ *   the medium link mode (@speed and @duplex) and the speed/duplex of the phy
+ *   interface mode (@interface) are different.
  * @link: true if the link is up.
  * @an_enabled: true if autonegotiation is enabled/desired.
  * @an_complete: true if autonegotiation has completed.
@@ -99,6 +103,7 @@ struct phylink_link_state {
 	int speed;
 	int duplex;
 	int pause;
+	int rate_matching;
 	unsigned int link:1;
 	unsigned int an_enabled:1;
 	unsigned int an_complete:1;
-- 
2.35.1.1320.gc452695387.dirty

