Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA67042172B
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhJDTSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:18:18 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:3542
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238892AbhJDTRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:17:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X05O5LrFPJP6ul+v3NJvdkPae1YaVnbpMbyHCgNworyabA45wtt5vn1/9sf8Jc5Yi6GotqPL152vrBAnGJFsJeIfgoGqLF/Kq079ga0mTpNPZGXMB3Kff3uJYGxKRs+z6hEvwUW7r9Y2axJkx2X0DqkUhVRoBv/4UDSZ1iLyZO1i0vBHic+qzeKgMGKMimdbAyLt3KMSNyI0bK8nSdnvcYRkgi4BU6tvyF64SCRDQgfxFd+hzn2Rl5bBwcVB/TkmaRU/GwjGjgqTSBDocJmRxomRE1HP/eH/QhQ4R+WuDV32R6b3+0GQl/Xpx9xYYF1THidM2pciTRncjhDxiKic/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dbm4/gf8fjTyn1w5yeJgzTRX9XqtUglzxN5ttU8NXAE=;
 b=K4ZREWkCKh1p6CzmLp2JNIb3DzEnY9qmZtrB5VU2l0KIh4aXCgQrHqUJt4uo7TgS+pwH64dg6tz8II1ruynPEylOiHEzpctOqFFiYo/sy8aShlGDHDT3e0Uz+k43E98oX25LyIcXV2WZyp0Q1BaZrMre3pJ3h8HdNJ1fTW0Z9QjmBfgjvgBbxoIakpGJyVdClF7AwJhIFFPuMJGICgPsTM6pzvnvBytWUFrf2iyUxPJne8zSEUspNcZuztud0ofHvdr1JhEbejVgv/pbG0wEwO/DirKKMnYjNFJtMHnljG7F9ngtxaiKjxMwOWZ70xLBF3UlVwCSxWZ2i836c20Cfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dbm4/gf8fjTyn1w5yeJgzTRX9XqtUglzxN5ttU8NXAE=;
 b=CUWewRaQiXMUeXJgJ7aeNYfUKcT6Sc2iBy+8WRkxDqN8jdlMd74A0xME7Oz+tXRxi1yXyEmMUCKAcMnxq0PlDGCoxHkEKXkLM6MtiVYG4AfCvSq+AHQoex7G2IUUHjSyy9UJ4YEk3uuPAVs8MSwhYaCi06ygidtkCD/OvSvWWGU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:15:59 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:15:59 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [RFC net-next PATCH 08/16] net: macb: Clean up macb_validate
Date:   Mon,  4 Oct 2021 15:15:19 -0400
Message-Id: <20211004191527.1610759-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:15:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e02bd6a3-185a-4542-9656-08d9876b65ff
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB743431A1D2B3359EDCDC164A96AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qP8ANFVVpw+6V7Omo11hiEQHZjn20pRStG/JSZ/qCv1TCa/PkuVh1BzSusrUtizCvJfRAZE4nr4a1zDAg48MMKdpgKyPDJRpuOZHJHaOlCLuQK5BkZUebz2UL7AulHJTT23ulvSJpbjuEu5cIPJtROTfiCIe6ziKuvCCA0u2lB/ZuSnzaNvA5vJgsGvVrPTLHD6QzWNNUXCGla0TEgweDObJQpSf7nPiZd59TqLdgfdsxsq6ToAGl9c5Ll2BSwb+HlZhUdAGdq7+JntfNvB1drg9o+KirpMLBKyfP9fIS5pYYXrgerNCEYu6UDnB+dozf3cL8iEBixk/zUFXFiVnqIKhdK0S/C2yeCqRIH+17mdLVtvKjgqvUHPH0o2ALZABzvhNFKLogETcu6+mfR0qzbYHpecDjNLYk0HFLTGKN9E/x9PbyvYbg+kOrxoy+IJeE+JA2/PZ+2Busz/4liJXQnMYHtxLpF6yYbLdFIL3DI0x67LC2OoQMiqXeLetoYhsFmeB/zFpvSwIPB08Nm1ub+ztjQbjd8vuyTkxR3J7THHoPNnjrp0VPefIjYOWjru0BG0Rstve8B5JVIjn2FBucJm9awzpkprJwjkDMti/K5U1ar5XKF06y4b4Cy97HunLo7QmAFcYmHfN5Yt/bnEUdTZP3tLm5+no7M3HW7t2pmS9M6MvIWIlblTVdyaJJPhbdhz8Rvx7mysXNkt+3d5EqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(2616005)(54906003)(26005)(6666004)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ebg7k1uEQi/JojvSj7NfJf7YXJfEld9A1zaZiBQ9cwTL3HyejQwfOAnV29Bv?=
 =?us-ascii?Q?qWLs80ADiAnpeEa04bV6Q4GlTe2N8uJV2/0S/Blbd0kGt+alDycLkiP8aH0V?=
 =?us-ascii?Q?qkAyu3yfu1op3ziS6PC9ApVmfmP5/6aJ+vMS6wT9rAVpMfyWUTZFBqub+Ad7?=
 =?us-ascii?Q?DPEwUx3Itmh+wG6CSAnA6MT/XdUKpsJyv/QHRKGWtoe2ksOSWc9MsSefVJu3?=
 =?us-ascii?Q?aHfC5282vQzznbnx47kHRul6vtfJzz4iHYBqEdfTFqdCCRHJsnxY2y9qwlX0?=
 =?us-ascii?Q?zA0qxqbdV76DUrI5HlRUcdY3OqvN0hqRtXbJjEgDmjA0xQ85Gwh+UmnD2aAD?=
 =?us-ascii?Q?DnyG89vQ8XIPeK4YlvaB73aG+xTiZquDBd2zy999LHoTWCe/h9fsyh3M8Tr8?=
 =?us-ascii?Q?oPPRJg9db54vmtqkAPD4+L3fXm2dkU34JatgjFereVA2N0fNsMW78C3LtbjY?=
 =?us-ascii?Q?gyovHcxOF0/tIaVYL/Fv6H16qkcywdWuHArM68Qniye6vbftAmCyjWCspSQs?=
 =?us-ascii?Q?ZfC2QHc5vN0F7LU8WMSSkB94IUJkLMtaHrmmi+JhRJzY8g+NHqAtEyomCWo6?=
 =?us-ascii?Q?mgjddZE379soi+3yKnvDcDe0ithoxgP5l0WdjYzJoAh19IVikYjETAvstXzT?=
 =?us-ascii?Q?jMtK79Gbg4N7cc4zEXIOBlA45ojQ7CJRaIx+CPC0hzCCjb7LnrSApBF49PAT?=
 =?us-ascii?Q?gWrE9ff0hir2so71AMXF/O2wipgfX435cHlvy18iOGeBVL0cAThTqxFbF0zP?=
 =?us-ascii?Q?LGdNiWr5xJ31Fwajb6IbbfEfQ4EWUc/tZ0Qaa2zYlOUrEl7PEp9/Cjn/Zj6/?=
 =?us-ascii?Q?jySJ0tA5Cu/SmTkdaa3A2f96ef7cG3Kh4DGvqyklUHf/1vfJtV7Vw3PenxBf?=
 =?us-ascii?Q?hO8fvg8+iQvUIsftEGF3Qq/HtxaxO8AGl+UzQX2oVrYI1TN0Qsn9AKfKGqZa?=
 =?us-ascii?Q?eCrqeyYDRqr9ECo22ZKQrjhY4Fpe6UbFkKHFd/fn2F0/rMdSGdmNKVBEA34j?=
 =?us-ascii?Q?Cc+jATth9am4nVkoNRhnu4o4hLGM7SP08fFIdMBvQvJTtwummssy3EO0/caF?=
 =?us-ascii?Q?CdRkqY6dBbcngOYrYsAFl/T5sxxu+LSkLOyk+JXk5tvkpimHUPCTxPQRaMkU?=
 =?us-ascii?Q?t/RTNhmbwpm/yh7DYL0wVFBUEF74a5/JAmaX6qVloOc1oWtNL8q4GAuXRo8Z?=
 =?us-ascii?Q?dcio9oaBFyaPsHRlpcE7rsPISHthVOFX0aavvfg+qglzKL3jk1YBex7OXmn/?=
 =?us-ascii?Q?/hGA3+jrD084rqAiNo61u2eSldqB8y77dpUOX+UHvyzC7DHy3XEojRt+hhGg?=
 =?us-ascii?Q?1z32mr+nRvPYh87pJ2s2qu/l?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e02bd6a3-185a-4542-9656-08d9876b65ff
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:15:59.3168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EJO9pfe0W0l+OFOxXDeHwU9dRkQKCCKx3ABvgttz1pgRCk3j9TwyLg3udIMX8hCOT0zR+/P4wK6x6lESbKmqmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the number of interfaces grows, the number of if statements grows
ever more unweildy. Clean everything up a bit by using a switch
statement. No functional change intended.

While we're on the subject, could someone clarify the relationship
between the various speed capabilities? What's the difference between
MACB_CAPS_GIGABIT_MODE_AVAILABLE, MACB_CAPS_HIGH_SPEED, MACB_CAPS_PCS,
and macb_is_gem()? Would there ever be a GEM without GIGABIT_MODE?
HIGH_SPEED without PCS? Why doesn't SGMII care if we're a gem (I think
this one is a bug, because it cares later on)?

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/cadence/macb_main.c | 99 +++++++++++-------------
 1 file changed, 45 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e2730b3e1a57..18afa544b623 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -510,32 +510,55 @@ static void macb_validate(struct phylink_config *config,
 			  unsigned long *supported,
 			  struct phylink_link_state *state)
 {
+	bool one = state->interface == PHY_INTERFACE_MODE_NA;
 	struct net_device *ndev = to_net_dev(config->dev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct macb *bp = netdev_priv(ndev);
 
-	/* We only support MII, RMII, GMII, RGMII & SGMII. */
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_RMII &&
-	    state->interface != PHY_INTERFACE_MODE_GMII &&
-	    state->interface != PHY_INTERFACE_MODE_SGMII &&
-	    state->interface != PHY_INTERFACE_MODE_10GBASER &&
-	    !phy_interface_mode_is_rgmii(state->interface)) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return;
-	}
-
-	if (!macb_is_gem(bp) &&
-	    (state->interface == PHY_INTERFACE_MODE_GMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return;
-	}
-
-	if (state->interface == PHY_INTERFACE_MODE_10GBASER &&
-	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
-	      bp->caps & MACB_CAPS_PCS)) {
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_10GBASER:
+		if (bp->caps & MACB_CAPS_HIGH_SPEED &&
+		    bp->caps & MACB_CAPS_PCS &&
+		    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+			phylink_set(mask, 10000baseCR_Full);
+			phylink_set(mask, 10000baseER_Full);
+			phylink_set(mask, 10000baseKR_Full);
+			phylink_set(mask, 10000baseLR_Full);
+			phylink_set(mask, 10000baseLRM_Full);
+			phylink_set(mask, 10000baseSR_Full);
+			phylink_set(mask, 10000baseT_Full);
+		} else if (one) {
+			goto none;
+		}
+		if (one)
+			break;
+		fallthrough;
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		if (!macb_is_gem(bp) && one)
+			goto none;
+		fallthrough;
+	case PHY_INTERFACE_MODE_SGMII:
+		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+			phylink_set(mask, 1000baseT_Full);
+			phylink_set(mask, 1000baseX_Full);
+			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
+				phylink_set(mask, 1000baseT_Half);
+		}
+		fallthrough;
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_RMII:
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		break;
+	none:
+	default:
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 		return;
 	}
@@ -543,38 +566,6 @@ static void macb_validate(struct phylink_config *config,
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Asym_Pause);
-
-	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
-	    (state->interface == PHY_INTERFACE_MODE_NA ||
-	     state->interface == PHY_INTERFACE_MODE_10GBASER)) {
-		phylink_set(mask, 10000baseCR_Full);
-		phylink_set(mask, 10000baseER_Full);
-		phylink_set(mask, 10000baseKR_Full);
-		phylink_set(mask, 10000baseLR_Full);
-		phylink_set(mask, 10000baseLRM_Full);
-		phylink_set(mask, 10000baseSR_Full);
-		phylink_set(mask, 10000baseT_Full);
-		if (state->interface != PHY_INTERFACE_MODE_NA)
-			goto out;
-	}
-
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-
-	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
-	    (state->interface == PHY_INTERFACE_MODE_NA ||
-	     state->interface == PHY_INTERFACE_MODE_GMII ||
-	     state->interface == PHY_INTERFACE_MODE_SGMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-
-		if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
-			phylink_set(mask, 1000baseT_Half);
-	}
-out:
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-- 
2.25.1

