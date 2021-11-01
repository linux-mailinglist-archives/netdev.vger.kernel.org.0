Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDCD441D1A
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 16:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhKAPHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 11:07:30 -0400
Received: from mail-eopbgr50089.outbound.protection.outlook.com ([40.107.5.89]:48899
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229826AbhKAPH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 11:07:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Irb0Lsg7LgDh1lWfBrkWn5s3GcfyyrYqg95mdKGsDO9IPLFp6inVp0szERPjBNsqDY1C5XdZ8ZvPnjIwyPDFmoz7ehs/9T8OESVrZXJG/hrlzxV1o80wWenibDxEwwYZp/H4hiyNjssJREDupavRdiHQeYJInjh+TYPcNa6b8crdjHM9DT7W2tYgernfNPfYIXFPzRtiLf3U8F6RSPMWijG2ApUsdyp3aWQj2919CXCVKMd38u2NPqnEgXO04mNFIBZSRXAz3h0tkuN0t/ZHxNvjFnN/e5PR8qb1p1WStl3AnoAhTE15nNZ4On/9pP4LsFQZOlQ9iBfeDGB3Q1wvCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gk3mWfDczhQE3uG1i9P+LJZcQrs3t3FQ0WDU4CiB77Q=;
 b=b5NIzh/pTwQJWsKTct+xc6qgvQTyAwvpIFXM/NoBvlEUkeD6VYxAFtdQ/XT8vxpU4uvpF7oIBdUMRwNAW3GpwQL7UG5Zn7t0n6KHtGXQYjaF1DgZ0Qe2OpzdzLpVeuNSfNVE3oIc3wMhiI56ZT9iEaMNsr7wJ9jHmsEMIJYD9an8yq8PXYr47o9EqcNPz2Zs0WCjmp/PzXM9n/ajcve/KyREtc091wI2Km1M1B6mzASIkU/CQrHYm0rtzPtxdz5aLO1lWmfOxTIHbGxjSwNxahQH4rOZfUT4YNRm2hoXqXWp9CkEOxkLVcG4QqlptY9LN5L1p///v09p0X7KFtJQXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gk3mWfDczhQE3uG1i9P+LJZcQrs3t3FQ0WDU4CiB77Q=;
 b=nc+HQ4urBXSCP/weGkRcsp1sIJvLLDzFt3f6136oR271mSD5G3wH4u6E+vX8QphFQ8j4O4ynl9ZNVxKRZTOQTDVXv4XWLxNNsW88OYnSWZZ6qoC3afssMQjxZlBpCIdYVGOAeFHg4ottprcLTctV6I3pS5QxO3fnG098x8B+rmk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4987.eurprd03.prod.outlook.com (2603:10a6:10:7c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Mon, 1 Nov
 2021 15:04:52 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 15:04:51 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Milind Parab <mparab@cadence.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Parshuram Thombare <pthombar@cadence.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [net-next PATCH v5] net: macb: Fix several edge cases in validate
Date:   Mon,  1 Nov 2021 11:04:22 -0400
Message-Id: <20211101150422.2811030-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0105.namprd03.prod.outlook.com
 (2603:10b6:208:32a::20) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by BLAPR03CA0105.namprd03.prod.outlook.com (2603:10b6:208:32a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 15:04:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58b0f5a8-e05e-494f-849c-08d99d48f48d
X-MS-TrafficTypeDiagnostic: DB7PR03MB4987:
X-Microsoft-Antispam-PRVS: <DB7PR03MB4987A0AD7EA69FA438C4ECEB968A9@DB7PR03MB4987.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ivCUe7Bz6ZDHnhLG23eMNbwsPv3IkL3BkiR6Aq5snc6ddugfpTHN5AKNKr1WMqdHh/tQuFrXprovUzet6dd1H2Nbmtx01EXazxv2tvmS7BZt25k6E8eUPPuoeu3W77Jd7SUlJW2ANmmTey6mr+78KtmG+DyC2p2e1YzfXndKYNXyV98i5FFZzjLqlV/bKHokAto/Psn7L/Jt5oJDQCam/pEApxjPi6r5A0bFMLQ592B6PB6nOuBM7HAejFX29Lruo3jjbmWInW1WC9+TVhClvU3JiVEpR7mxhdCo+qtPiJ8uGQJIKqXe5fRpFB7q5xX9ra/RFe8aSmhjdfILMEax6uYaFvpY7IZkbRmqvsqlDA2pHxMzTCD1UnFmykBg/+9IFebW3UuSzKGR4wQPzRqJoQWdvpOb3aarPl8sg1BQ9dci7VagE6Rt4ZM9NVL+XWLrMNmgRpfa2lbgZAmhTY5UjlNgbGcMxb1skQ8Ygy8Az0BkUCYzkmT0Yi1jFZWjRyzug47toHeEZY7HGbNNZsVI82r7+86Gc4PZu39hwAUj0fSU/XswVHWJ1vL5NlNOAfJC9iNs6RkvgVzAsoqQ70zjOSxitTdY5rADdenbBmrKmSy7DqaBztkjqFynXqktmjrrK3YeXNtdtZgz9ogJLq5uFgY500ER7KNL9rKXldVkdODy3tYggc0iFAMr2Q7Zq2yjDkPnQdlHTQz56jChbNjw8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(66556008)(83380400001)(6506007)(36756003)(15650500001)(86362001)(508600001)(8676002)(6512007)(2906002)(26005)(38100700002)(52116002)(66476007)(54906003)(956004)(2616005)(8936002)(44832011)(6486002)(107886003)(186003)(5660300002)(4326008)(6666004)(66946007)(1076003)(110136005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vw6TpbNRAgBbuekojYvmmEhIi8mVykgg8AE/7QY3FFzVPDQMDcsFazZiXcWk?=
 =?us-ascii?Q?TjzLQlGYSKZdjjjsT48R6vi3vly8XuHvL9RZvSFkHNlRDJOtuhPGS/naSJ2L?=
 =?us-ascii?Q?FbalhpDuh7wYJWUnK1PmL/U7L7zkTErygnMnTiGbEXvMkdDBkrD8vK0rfqqT?=
 =?us-ascii?Q?aBbomGlQNbtBuRqs0Tvp6mt9ZJWdP+eS7iaTSHHNjVFZ99LwHFiuJB2uaJr+?=
 =?us-ascii?Q?YhYVePq0hMp2bLRKupTdYgeBJ3WCnfoUK2tkcLKhl6BbpHNkiWr144ZoAPf/?=
 =?us-ascii?Q?X16JTnEPPSDnd8kwWiB+T2Ri6g0glNSE8JSEdkbJftnFSjMmDI8CeaVTMhmi?=
 =?us-ascii?Q?Pg9TedUGQLNZrl+7O8RSmsUa7KRtc8rUpCMq4NvTgMVvjCSaE+CzvzjeQ301?=
 =?us-ascii?Q?TexGo9Qp1ufSl4UqMyErwPT9CvMAySKUKjVjxj9uqXnK05awFtk2psvEQk+B?=
 =?us-ascii?Q?gAYkKsDbj2WkoyQ+BU9V7sBi6P/cf+Pi0NzjoqS2wRN4YyX2Vd9l9Watp4XU?=
 =?us-ascii?Q?TXYXgYT9WjxR/2npPUynC68aqPThnKZvLnXmxYcmttG3GU75s+7JEltMrV/g?=
 =?us-ascii?Q?QuxkJ/hijbkXfIjRKP1SfsnmW3eWYp9ZJQF5DRD5xv38wkOrh7vK3qCLLQr9?=
 =?us-ascii?Q?E7AnBNz/za/DJ1AS4eXNC+lcNX8WMS3SpviOYrohPx9f0pFv0+rM4z2vYOoy?=
 =?us-ascii?Q?g4xuU9qH9G3K/Vx+5VhOdCGSoDeS8S6GGo3FLOoSXzVgv6NkRN5N5IRsGcjH?=
 =?us-ascii?Q?jNimdkEwZiOA3UpaVkhgy9Gd/UiZPXrKVBxLWm59E7WurcP0mqKgFyWxCIvW?=
 =?us-ascii?Q?D8YzWqUl2RJU+QSTN/QgNdEKQiSEXPny9NUR9vUVIYz1HoBkrVItzK8qNATU?=
 =?us-ascii?Q?KQ6Eqf1LvfVmF4Bm3G24iudiaHLx5AX09WfYEEFXjwu4SHGNy3UoTTuEazcP?=
 =?us-ascii?Q?Mun4Y3p/+UP7gCYvbwKwTHhvQ38RsY791tUEvOCF4fQoaWD0shPqtl+TkFMa?=
 =?us-ascii?Q?zyJJsZWb9DL3tdBoKnOF7AHdNZ4t6dRS/KAWzWxWKAZAYssD/+oloerEua7Q?=
 =?us-ascii?Q?mw5t0ZjSszKB5+o89R5UMxLSPeqb4zibY5iAaLViuAqwCnAOMcBpzjXYU70r?=
 =?us-ascii?Q?Nsy5+Z87tBsVQr29sUm0OJcuOD/MwgvDDZ1HKmB3t498/bSLhyDXrmBPh4n1?=
 =?us-ascii?Q?44gJdw/9FmrKqB841/vsJfg6RfLEe/oyxymAEpjASkgyzmM3JoEpcBSKD2l3?=
 =?us-ascii?Q?8r4A27NFc5z1E/PWzEc489XOB3q9bbfVTVxNfV3AfcnE/o3hNYZkDBq57NcI?=
 =?us-ascii?Q?ovTdmcBjfC7gNIKiyjT5Yj80TKhpqFIEtVE7+WkXpa64cLhukoWVdoOrhRmq?=
 =?us-ascii?Q?lnC6Ls/x4ixOpA4mh1Fy5euG/wBXypL/+A780euSjt6vpOIW/qfGBeWWL7k0?=
 =?us-ascii?Q?dsVHERAGcySqA9xvN4Joj/cYW9MWuS475EFXUHKr9sWqSsJsSo/0yeW5sAy2?=
 =?us-ascii?Q?7Z594KrAyNtu0eJCGwJaZ/rdF4y3nnFXSp0jlGYJlwXSTKrji51H2EyHmnqx?=
 =?us-ascii?Q?PqV50lmRlBefJyz40q2iG4OzoviUSeqEH7hEzXtkUd1V5RcjoCFKx0jLJyYi?=
 =?us-ascii?Q?4jj+E91Ku6mByjLTOkdHgcQ=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b0f5a8-e05e-494f-849c-08d99d48f48d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 15:04:51.6796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edxRDakycZchIsBWo/dHO3HGJdKCVME+vCNVjulo2XWFmK+2fydvEBSkLgvM8ZNjA25W3ZAqPDQzlm8AJSlIBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4987
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
index 309371abfe23..cb436f758bfa 100644
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
+	if (!macb_is_gem(bp) ||
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

