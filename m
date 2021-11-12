Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC2F44ED00
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 20:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhKLTHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 14:07:06 -0500
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:63488
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229892AbhKLTHF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 14:07:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7X5yTfO9CPM83RqafDuubrpx7jZrjXhxNU8NnMgHp/qqfNzL+NSqY3F/4JxA707Dy7LTwaNB/7LWdWJBNEneVJR0ZPkLCf6rTBCuixVM3IlPpAg8keqceLnGaAc94Z1ElcMGfUmSAUfInQTamRUdV4e1ngv5vKbH74fuZ0kwT/ISN9rIMq5RWI7G7sVo8DaeNg8MjFSp8MXI5v6abXM3bp/ZeAhSp2kYA1L/yuxWy+ZeqTKcTgZcwJPVYGD3JqMmRc8t0Hl0akOIj7lRHaUkM67Wtn11DZvvBytnnAXxTWdFsa4zkhIwJ2vwtux7S3fFZkfFgfgrO+79QGOa85Vqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7E566uGlXubBGiWV1ryLLQn7o0wLS2NfUzn6gScyP4=;
 b=n8gM+aDpS7Ci+KA/keoZLC3j/Ip405pCwsHMF+jFd+GDmW962G6TlBtjobSFmAzkxiKmZj5PK2F3sivCaxD8NPSlxMD03XUqSRUjruZ3g8kLC5S4uAUoRWlHJdM50ZkD2fZ+fUU3eA/ZPhzlmeJEYlzvsjmhSQQ8p7v2slUC1hauTCOVXileDrVh/g3z9bR3X7fcBFaV2KTidT9ptPQaKkLc+6xX1ZC1nrh5fKqQSech33f/K8DuCPT/a7ZQnKqwF9TOoBEIUm/z5rohCoRg0W6cHW78bCauh0MWcSa5gMnxN2Ef5pyRlT5a2P5qexPehAhqtXOQaGnqqPoAr4W/oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7E566uGlXubBGiWV1ryLLQn7o0wLS2NfUzn6gScyP4=;
 b=hZyqFrq9kVaciM1SVIH604Qk5ZNCWED9D6wuYSN8BDKWvMlbXX9XF4radpvqh9m7yikV91JHq2nlOkg3Q4pbo4X2+VQd+NbLYbBafIo40+K40KZ99jLnZ7fUPqVRmG40SFjzJfYKwDSgYNmBIyxytYkD24n53KA6Me8L3zyDWXM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB6025.eurprd03.prod.outlook.com (2603:10a6:10:ed::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.22; Fri, 12 Nov
 2021 19:04:11 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4669.015; Fri, 12 Nov 2021
 19:04:11 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Parshuram Thombare <pthombar@cadence.com>,
        Antoine Tenart <atenart@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Milind Parab <mparab@cadence.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [net-next PATCH v6] net: macb: Fix several edge cases in validate
Date:   Fri, 12 Nov 2021 14:04:00 -0500
Message-Id: <20211112190400.1937855-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::18) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by BL1PR13CA0133.namprd13.prod.outlook.com (2603:10b6:208:2bb::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Fri, 12 Nov 2021 19:04:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c0308d6-ea71-459c-8550-08d9a60f3645
X-MS-TrafficTypeDiagnostic: DB8PR03MB6025:
X-Microsoft-Antispam-PRVS: <DB8PR03MB6025B3967C15ACDABE511C2E96959@DB8PR03MB6025.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pknF3AvoUVveOOGcGrhVLdRJxgbxYsW/rUjgk2cpUUhs3EiDn/1n70p4CZ4N13S2iXCfOHoPcrKZ6Fh48Tiu9wNPAR8l9pyk2NqRCihgf8UeJjhugGhb/61unTwngLCODrNZOKt1Qw7joNrA3oGBTtd0TIhE4bhzhqnSfSo4ZgEEF9QfBz1rfFLh7lSA/pXNuk17Urut+V4PZ+ct8hcrGNTF3g7vlhxcNsn3M1pIRT+0lMjLctCiVDsjJ5mTGeTnwz5qlvplbf4v2AUXqzamqH6kt+KFTGH/Ea977ceFHnb4ezHCq2ESN6Vq4b4YdHoynYU1RY04YY7vghF7O3onYz1U02LPfgnfqQLvlgSRUEubaKAO/bwIKcfBrpq5UeswDgt2WHaeQcAFY0WlzkF3rc0tT4j3TtOKcXHrwcTZrfQpNgBUgXQro6Rom8LuBVsP7yhS/cUMHQwoWaIpBdJPJbGPnj48n1g5H3kVTPp846ZTnJRdR4LKCqq4XgMsH75aVO0Zgksh7fZmABU/rpknDG/lC3SfhEUwka1/ukibCrhHiD4xCpTv3WUQSZYCsUVuUg4ARBj4OiHWRc/69j2YJ9/gq5nsI/a95cX4+KOLrnwnqwWlmBUdSibiv3mJhFeNOgo5fs7gKxhn/a5T9V4nUv2DXWfMSXgNLgcjKS0JObm7qy5EQJ111InjlcSz2qn+b9oqDG0i1xKj13gAK0Tvmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(86362001)(44832011)(38100700002)(186003)(52116002)(36756003)(6486002)(6506007)(15650500001)(6512007)(107886003)(2616005)(956004)(1076003)(26005)(66556008)(66476007)(316002)(110136005)(54906003)(4326008)(6666004)(508600001)(83380400001)(5660300002)(8676002)(66946007)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gj0bmO8nTOyvjnYtYBu45vSZasBH4fSphK5lVp+/EXcA41GlBzQU8dhzUtGT?=
 =?us-ascii?Q?OY7m/XYil5hXxKMAN3tAuDpBTnPw6f7lsfbudhD2OtYVY8XTXO/okl//9YGB?=
 =?us-ascii?Q?ANEOlqL4/1npmOUzDXzgdIBaDJftc7J5tcHv/a+rbprpMY5enaOK+CwNLBYD?=
 =?us-ascii?Q?hfPfpg4gpEjx1dS00Nn5vKpt7HGX6Wbut9nAPGaHE2p8c1TcakG0KLqw9Kuv?=
 =?us-ascii?Q?qk5mmTqKDYFX5dhX/WHcYjhcT5QiyJKhXw98iTb4ar/XCs52vl8ooMjcs2ks?=
 =?us-ascii?Q?QY1QAmd7mTNHFEqUuU+kXgmYfx0kz/QNUt/AVSGQsSyOUVz38NN6Xj3OVCCI?=
 =?us-ascii?Q?3kTNxkRNsOySg+wJyeO8i6k6B0DeqqI6RIk4yqKdMstZEsxgde/KFIwUIzWe?=
 =?us-ascii?Q?j9OJPsD2XDKmK0ArPHHRgFgIYKqi4btOT8M+4JwTBPBUWeu552c3K0f/7dDF?=
 =?us-ascii?Q?X6HjCf6/o28Qoajk1o0fkWaqv6gQ3HKuHRlA8+4TCTt46ORCFQzPNkBkDtB/?=
 =?us-ascii?Q?io6A0a2vVw275nK8P9bg0wDeHDU4YKl375CRREIbA3y6yauMkaFxQv/3JhtH?=
 =?us-ascii?Q?qceQQ5NmNnwnjsYr8PRAfCwXEIr3MUyD7eDlYDjNUwyH4I8YK/zm9xCHacgM?=
 =?us-ascii?Q?kSPXD3T0u7aVbxRHe/wD0JWRrPTtqsZNl+sh6ky1hcaYdaySMqX4iASnCVeF?=
 =?us-ascii?Q?1ku6rkSuE09XZU1kt6APHukAvFsiKSHogCN5eOiXa5Pd+d03guO+bxCVlT0N?=
 =?us-ascii?Q?maZEF/UBQGmMy22vANCPaYLJwNgwwDX/9htIGTQcx1QXVkf5hIJjjbhjRPhD?=
 =?us-ascii?Q?dx44D1LQdje3C34tOjDlWgWYs8KemJnGZA0+EizWum9qnw2Q4eWZjtfp+xTh?=
 =?us-ascii?Q?HIpcQ+p5Q4Sxnc1JkP/pE5v3qfPHEUaQduaq22m72N9TqTlWk250hKjqIeNy?=
 =?us-ascii?Q?7snQPrhc1eAOHSfsPNVBFCbptIZ1YcjDttjWacPl/2CSN8hzBXRWvk99Lget?=
 =?us-ascii?Q?eUbcKLoprow2WiSt922khfTzeIsxguYL+iKODG92qq/HDtihY8DmRnNb5xlz?=
 =?us-ascii?Q?iThKI3nq1Bh6z7fWHGkRZ2jAW0fJBBIcjjKww33p2cofp9qVPBnrcIwcdMZI?=
 =?us-ascii?Q?SOae6b6w337s5no0icCai9jKY3TNmAkVy33SEVkWXjYs9V+DbhBXM1HjvyWn?=
 =?us-ascii?Q?d+4Y1WxbEi2xT9HhEuAUfvBJzDtfY9Y0NsFafZftAx3u04Rn7/Hyi1gzzBDv?=
 =?us-ascii?Q?BPVvm/0eDZ86jHc5QZkxnOp+uyyb/KDCZOtuDV/bOpvwVkvXv0hnwj6Ry7LK?=
 =?us-ascii?Q?fX48ICnlPdL9nMu/oo8qD/qQfLxbTBBwU3atslQG9jJbmY6/r3jBPbMKFQuk?=
 =?us-ascii?Q?GM51+cL5j/FlT1MaXuEbQoMedzvGbl4xCbSeoqW76IE58frdwTLxPcpso+Cl?=
 =?us-ascii?Q?VT0mYvLdI95wR6RC6cwyWm5r3GZQr4wjYjI6+XUJB6a0z8ZsKbmjNwTv+RVL?=
 =?us-ascii?Q?nlHdJWHjQuxUfIWGecBnxkLKcL2YPqa4CJ+u+avVdDI8haTyNvVB6YUnEGSW?=
 =?us-ascii?Q?ZHqJughAd2l5ZUFLe+mvxpA+ZPayWRGywFetq6mR2Jf+928Dl50Ik0QGKrwC?=
 =?us-ascii?Q?rEM2JMu1M1Mo0Wxw4eTI4s4=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0308d6-ea71-459c-8550-08d9a60f3645
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 19:04:11.6054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vUvKrDmC131yX76htbkLWaImYVwQg888iCy+rWQF1lmbLutPLfrERI+Jph19GTNxIQMarZVO8YcyjnyyKM2oGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6025
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were several cases where validate() would return bogus supported
modes with unusual combinations of interfaces and capabilities. For
example, if state->interface was 10GBASER and the macb had HIGH_SPEED
and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
another case, SGMII could be enabled even if the mac was not a GEM
(despite this being checked for later on in mac_config()). These
inconsistencies make it difficult to refactor this function cleanly.

There is still the open question of what exactly the requirements for
SGMII and 10GBASER are, and what SGMII actually supports. If someone
from Cadence (or anyone else with access to the GEM/MACB datasheet)
could comment on this, it would be greatly appreciated. In particular,
what is supported by Cadence vs. vendor extension/limitation?

To address this, the current logic is split into three parts. First, we
determine what we support, then we eliminate unsupported interfaces, and
finally we set the appropriate link modes. There is still some cruft
related to NA, but this can be removed in a future patch.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v6:
- Fix condition for have_1g (thanks Parshuram)

Changes in v5:
- Refactor, taking into account Russell's suggestions

Changes in v4:
- Drop cleanup patch
- Refactor to just address logic issues

Changes in v3:
- Order bugfix patch first

Changes in v2:
- New

 drivers/net/ethernet/cadence/macb_main.c | 108 +++++++++++++++--------
 1 file changed, 71 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index ffce528aa00e..57c5f48d19a4 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -513,29 +513,47 @@ static void macb_validate(struct phylink_config *config,
 	struct net_device *ndev = to_net_dev(config->dev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct macb *bp = netdev_priv(ndev);
+	bool have_1g, have_sgmii, have_10g;
 
-	/* We only support MII, RMII, GMII, RGMII & SGMII. */
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_RMII &&
-	    state->interface != PHY_INTERFACE_MODE_GMII &&
-	    state->interface != PHY_INTERFACE_MODE_SGMII &&
-	    state->interface != PHY_INTERFACE_MODE_10GBASER &&
-	    !phy_interface_mode_is_rgmii(state->interface)) {
+	/* Determine what modes are supported */
+	if (macb_is_gem(bp) &&
+	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
+		have_1g = true;
+		if (bp->caps & MACB_CAPS_PCS)
+			have_sgmii = true;
+		if (bp->caps & MACB_CAPS_HIGH_SPEED)
+			have_10g = true;
+	}
+
+	/* Eliminate unsupported modes */
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_RMII:
+		break;
+
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		if (have_1g)
+			break;
 		linkmode_zero(supported);
 		return;
-	}
 
-	if (!macb_is_gem(bp) &&
-	    (state->interface == PHY_INTERFACE_MODE_GMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
+	case PHY_INTERFACE_MODE_SGMII:
+		if (have_sgmii)
+			break;
 		linkmode_zero(supported);
 		return;
-	}
 
-	if (state->interface == PHY_INTERFACE_MODE_10GBASER &&
-	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
-	      bp->caps & MACB_CAPS_PCS)) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		if (have_10g)
+			break;
+		fallthrough;
+
+	default:
 		linkmode_zero(supported);
 		return;
 	}
@@ -544,32 +562,48 @@ static void macb_validate(struct phylink_config *config,
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Asym_Pause);
 
-	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
-	    (state->interface == PHY_INTERFACE_MODE_NA ||
-	     state->interface == PHY_INTERFACE_MODE_10GBASER)) {
-		phylink_set_10g_modes(mask);
-		phylink_set(mask, 10000baseKR_Full);
+	/* And set the appropriate mask */
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_10GBASER:
+		if (have_10g) {
+			phylink_set_10g_modes(mask);
+			phylink_set(mask, 10000baseKR_Full);
+		}
 		if (state->interface != PHY_INTERFACE_MODE_NA)
-			goto out;
-	}
+			break;
+		fallthrough;
+
+	/* FIXME: Do we actually support 10/100 for SGMII? Half duplex? */
+	case PHY_INTERFACE_MODE_SGMII:
+		if (!have_sgmii && state->interface != PHY_INTERFACE_MODE_NA)
+			break;
+		fallthrough;
 
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		if (have_1g) {
+			phylink_set(mask, 1000baseT_Full);
+			phylink_set(mask, 1000baseX_Full);
 
-	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
-	    (state->interface == PHY_INTERFACE_MODE_NA ||
-	     state->interface == PHY_INTERFACE_MODE_GMII ||
-	     state->interface == PHY_INTERFACE_MODE_SGMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
+			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
+				phylink_set(mask, 1000baseT_Half);
+		} else if (state->interface != PHY_INTERFACE_MODE_NA) {
+			break;
+		}
+		fallthrough;
 
-		if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
-			phylink_set(mask, 1000baseT_Half);
+	default:
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		break;
 	}
-out:
+
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
 }
-- 
2.25.1

