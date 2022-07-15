Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1A757695C
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiGOWCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiGOWBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:16 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50063.outbound.protection.outlook.com [40.107.5.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31128BAA2;
        Fri, 15 Jul 2022 15:00:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+whvttEnfaYbZaOyzuobw6cS0ScGbZkqRK+Qa4v0V2klq1pyxDmurpy0Bhh3CpegZS2rPSFD5tA6t5ZgfCF4l0iSnWAd6hVw7x0QEuRPboCrnso31fNyq6K+GJfMYfm+/oNDc5jmNCW4gQHoFb0MKFnpWrUKy27DnZo4jEf1mxFCgLN0jKVb2KJzHBEW0/hGH4iYGCTFxefbUiUayi1/A6So2h6trwWI9Ev9Kulky0yZtCpLlvrSsmHWSwfag9h0WNxcvDsjzYjNsXarVrEFSfai68o6pVUe6jxLM9WMBFFdA9gfvHR6ENLXp6vY2JqZoWq2vUBtFot+zOJo8lQ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALy1Mp8Kayet9h3WO5ALQ+i8lgiqf6yX3kfdI7pNkVM=;
 b=mU1yJaFM0SI8Nrw/w2AJij79OYjrK4D2a2Z0+vj9sozwGr1cfENOvwcwR4btFKn6S91GVmbfWC7AjUdc5LJGDfAkoMUZZR3qRvscexvfUSVNcSxq3tLDS0aFgiDe44q7AucxvVV6uxCDUGQeRvILyVYzIR9V28okocKb47YshXoZGhkWD2bK2xecuVOwzVNU7hfmFI74D3pw70wN0tvmSvQRzMYr585VX0V04iXskuLE7PmuC257gMZYiLz3fWRMk0aGcv2fziyEqDOIzfaHyzC2iKYaw7T6nPDoKtjR4FpkxumcV+Cr9HWQGXzydID4CpJpQoRzjtMs1ZS41WJFvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALy1Mp8Kayet9h3WO5ALQ+i8lgiqf6yX3kfdI7pNkVM=;
 b=zTVZAGxfgekrftN8Y4QkJXXOn4aid/Zfr9a1+D2rz99aRY84M3mVnqV0UDXkGPtbr33HSJnqclwzSUmdZhGJXVw1Gn6/yJkd/rFYCetTQYv7aAIlYV+FvxLCf6M+3VQ+z1OlIWbbezwK6PQfljfaoGBc7vEgR+Gdgwhn3tyXm1u2yz0KYyOd3dzYk8MmBrhywlIGyBm22RM6XcBESPbWn6e+XVofmzlN/+VM/ecZ5UmGsW0BsDJRToRnNPWVIJNWmd4fpEYQuTXjtI69B9EyKAUD0682L9UR+GDgBa4T6EPpoee+ZTjc5TtOnhqbsMwM8ycPVuEuAidUFzEDiFthUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DU0PR03MB8598.eurprd03.prod.outlook.com (2603:10a6:10:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 22:00:41 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:41 +0000
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
Subject: [PATCH net-next v3 12/47] net: phy: aquantia: Add support for AQR115
Date:   Fri, 15 Jul 2022 17:59:19 -0400
Message-Id: <20220715215954.1449214-13-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 790f4b5e-80f6-4374-9feb-08da66ad7573
X-MS-TrafficTypeDiagnostic: DU0PR03MB8598:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2pLrehLdgPvopI7ozN3gHWmfycUZyjEExrlrNmP6FQtxZ3c36hrmy/Fh/Qg+t4w4DvolcpVRozENzaw54F6v2dRdZcyZEd2cq0q9G4U9F5gUaQ0QTpjcdbFhRBTp2FuS4hOcAJcKMtB0yIn2cMVXUd2KPVlySDUZXb9cQ2BnBAsBwlZ2QAcerb52ANSNbH8DqARHNA1M4aqfL8t1blatuNMgM8m9yN2t89uBIEfJapvhxzfggmITsLt2bx4OLQd70e2xh+yTKtdqkHitkrsbG0DwG8/r2nCNubdMllYow2JyAQ/xhN0rspLQNQBao+eJAbv0UExYk+tceagvMPb79b6wWLjiU6UJomdT+XaMZ7rK+o9hICVUQsNSuXC9/6hX/fyi4z5uCq8T+YlesFwOaIapHO6Rxt477EuL3l2wqx1hNBXOjuTRTggOchqo8Wb+oywmPKkZT9habXWTmK+8fM8EmDmqmGTPDr9H0tWjT3rG7iNHXIk+sNtBVgt+/d/DiPz4P3kmyao5hzrgVdKAHtVrrNR8haERgPKU9LfU+XWQQ4ExDnSw10IGvRzLV7HKc5Z3iDzc7MGGgczujqcwtgFWafdCveZ5rga/vZYFquI9tEZqAQM+ojB14n+f67QLDeW8+uLNskFTAzJLb7kSyIuu30DQa8qlO5x8IIMaPSjsbtkGLEUwI4xKgRQE3iPt8cMbXFcOSYPxDCG6oZi05E1y8x9vRk9K/Bgtc9v+2XO0/mxbl2z/4GziztzpCwnKsoJMQZgH02+u6MsH5l9mT9WL5S+NcNDjdAzehTgLxkPl7Ioo8V8rpVYgYDE/1EHF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(376002)(346002)(396003)(5660300002)(8936002)(44832011)(7416002)(2906002)(54906003)(66556008)(4326008)(8676002)(66476007)(66946007)(110136005)(86362001)(316002)(186003)(2616005)(26005)(38350700002)(52116002)(36756003)(6666004)(41300700001)(478600001)(6486002)(1076003)(6506007)(83380400001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ElS4Ew3G/40Tl9xpIwmUIZV5BEGAbk4jXzOD+ETn7ACm9XoaZRrDsrDyfpzG?=
 =?us-ascii?Q?Ja+htZWHyCbUEWoFfIsta62iINM7wS0djJlFusuQqxcgiWtvEKIMn08GXTX4?=
 =?us-ascii?Q?OLzlB+i/yQdQYnDvwZkd5WI+8keMKfUErMg8xM74wMRjBkiUqzfgWf/FsCp0?=
 =?us-ascii?Q?FMFC8IGAzIMcUQorwi2rSWtlBqSdDWHzu576/CYd104cZHG7XcM64Try63Gf?=
 =?us-ascii?Q?m4Ays71FohrCO1zHnwvqKkM4jAflCmMjnFVNmA/0BeJmjK/S13cKV8otc5Wf?=
 =?us-ascii?Q?MiktYZ/uwAs6VsocD2RS0nyB5tb52JO4Xr4cMUmkSNTOnOK3za+Y8UVEDG23?=
 =?us-ascii?Q?1PnqGcraTmWC67+H4kHs4qA99/qEOPr3U3qIOTo+PlsMKgbovKugbaS9Vl2F?=
 =?us-ascii?Q?rqWwGvm3p7EPe1Mzahi+Ey1NAkwrOMGrEyK4QyCwj4qgC7+cVLIDQxyWf5KT?=
 =?us-ascii?Q?aaIEuRal2XYwgpqJOrED1CzscyndSrypUeRB5KDXh0ybsIrUZmkToSql/1gT?=
 =?us-ascii?Q?e9cI/nxsJWkz5cs2ZVGkYKj6tRE5BE1nuj3y1flLMwAIB/L25/hgODx4BHry?=
 =?us-ascii?Q?uWuc+9WdZ9ZNzauWr5VnbvHuwUKY59U2j49bKVYVW34kM5QW8PWF9WIQK7Ux?=
 =?us-ascii?Q?e8ojtUB+9jKKCq9dmYBi8dkhnJ3/buibQIaQ50W83T2WLE4u1QVhOsjaUgi6?=
 =?us-ascii?Q?ADaa3EIj99jREXsDvHXtPJicEFaT8sGVbuIfibAggvxnu1LRxlVAzTz7XUxl?=
 =?us-ascii?Q?mrEMkEouA3tgxpNlKJfD6TQffBADFanAjFokCchgTFsbD4K80/Fh7EHNY7Ac?=
 =?us-ascii?Q?qjBdDjExKzqk0clLmDeVQs3ejfAT1UxklG0F71enxczswB8aqXs2Uu4r/+8S?=
 =?us-ascii?Q?YNVrtknD5DW24PJdeHqzvcAKZOeXp+HDU6r6ueX0qDV3ge0tRzek3w1obPN0?=
 =?us-ascii?Q?QbhZ4+9BlYuzUJSVglDYlKguGlgMIa0xdSIGijh/o50jMMkwKpH+LrZU/3v3?=
 =?us-ascii?Q?aLntivoH70HXhg4cY7pCXfv55rm1bWvVkdU6+3lz4W217j2aiRenV47jpgie?=
 =?us-ascii?Q?WNLmf+7bvxClUpdrcML25iDPgAA260WQ6d2/E1vnp3dp90HSGf4uR03wcAq2?=
 =?us-ascii?Q?5co7dizGNL1ll5okn36Gi3/+Q4JlyqzT7I6QFQe+5x4ThwNopKc5TLmi9tQM?=
 =?us-ascii?Q?5xBC0WvX1XKNiH7MeQ8vnXptkVjB6W8cs220ZFl+8ga3CieTVq3DKaDiu7Ww?=
 =?us-ascii?Q?eCL2t2zjjZX/WXMvJ3RyvKdCspmRhBOLCN7lIac/EsfprM++irgcurz7SNaC?=
 =?us-ascii?Q?08ALO8IQlwXiORaYeXEvQrQIzhoFfsdTyF4tdMhgNk4B7SC1hCunGNjeknxe?=
 =?us-ascii?Q?JP70Vg8R7ZaW8m5RYiqonGk3bW0yG9T6rbv/2+eMBXhXWheoV2KBsP4ucoSi?=
 =?us-ascii?Q?SBjcOv8+uPfAg528IoGpkgIweUh5DRM+ikCcSkD3xlY1Tvb7EROYt4eSw2cL?=
 =?us-ascii?Q?2pUYOLUrPLWEK4P31FDzZy/mLzr2WzP4TEc3Qqco+S8Tl/S1jkG44JcIkJUS?=
 =?us-ascii?Q?ih+K9e5hvF2stEZgNYWuT+UjoUlbpPiyNF3l+JkAR7EYVQALo1mQ5SwIPmkt?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790f4b5e-80f6-4374-9feb-08da66ad7573
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:41.3171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9eGMRjd6PbrEeicipkCs5W16HANeRvKPNoAdgXJQjwyKMeis0bwOC+DYdpogCiVBKF7wluldZf/srCp2urvFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8598
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the AQR115 (which I have on my LS1046A RDB). I had a
quick look over the registers, and it seems to be compatible with the
AQR107. I couldn't find this oui anywhere, but that's what I have on my
board. It's possible that NXP used a substitute here; I can't confirm
the part number since there is a heatsink on top of the phy.

To avoid breaking <10G ethernet on the LS1046ARDB, we must add this
vendor id as an exception to dpaa_phy_init. This will be removed once
the DPAA driver is converted to phylink.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  6 +++++-
 drivers/net/phy/aquantia_main.c               | 20 +++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 45634579adb6..a770bab4d1ed 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2886,6 +2886,7 @@ static void dpaa_adjust_link(struct net_device *net_dev)
 
 /* The Aquantia PHYs are capable of performing rate adaptation */
 #define PHY_VEND_AQUANTIA	0x03a1b400
+#define PHY_VEND_AQUANTIA2	0x31c31c00
 
 static int dpaa_phy_init(struct net_device *net_dev)
 {
@@ -2893,6 +2894,7 @@ static int dpaa_phy_init(struct net_device *net_dev)
 	struct mac_device *mac_dev;
 	struct phy_device *phy_dev;
 	struct dpaa_priv *priv;
+	u32 phy_vendor;
 
 	priv = netdev_priv(net_dev);
 	mac_dev = priv->mac_dev;
@@ -2905,9 +2907,11 @@ static int dpaa_phy_init(struct net_device *net_dev)
 		return -ENODEV;
 	}
 
+	phy_vendor = phy_dev->drv->phy_id & GENMASK(31, 10);
 	/* Unless the PHY is capable of rate adaptation */
 	if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
-	    ((phy_dev->drv->phy_id & GENMASK(31, 10)) != PHY_VEND_AQUANTIA)) {
+	    (phy_vendor != PHY_VEND_AQUANTIA &&
+	     phy_vendor != PHY_VEND_AQUANTIA2)) {
 		/* remove any features not supported by the controller */
 		ethtool_convert_legacy_u32_to_link_mode(mask,
 							mac_dev->if_support);
diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 8b7a46db30e0..f9e2d20d0ec5 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -21,6 +21,7 @@
 #define PHY_ID_AQR106	0x03a1b4d0
 #define PHY_ID_AQR107	0x03a1b4e0
 #define PHY_ID_AQCS109	0x03a1b5c2
+#define PHY_ID_AQR115	0x31c31c12
 #define PHY_ID_AQR405	0x03a1b4b0
 #define PHY_ID_AQR113C	0x31c31c12
 
@@ -672,6 +673,24 @@ static struct phy_driver aqr_driver[] = {
 	.get_stats	= aqr107_get_stats,
 	.link_change_notify = aqr107_link_change_notify,
 },
+{
+	PHY_ID_MATCH_MODEL(PHY_ID_AQR115),
+	.name		= "Aquantia AQR115",
+	.probe		= aqr107_probe,
+	.config_init	= aqr107_config_init,
+	.config_aneg    = aqr_config_aneg,
+	.config_intr	= aqr_config_intr,
+	.handle_interrupt = aqr_handle_interrupt,
+	.read_status	= aqr107_read_status,
+	.get_tunable    = aqr107_get_tunable,
+	.set_tunable    = aqr107_set_tunable,
+	.suspend	= aqr107_suspend,
+	.resume		= aqr107_resume,
+	.get_sset_count	= aqr107_get_sset_count,
+	.get_strings	= aqr107_get_strings,
+	.get_stats	= aqr107_get_stats,
+	.link_change_notify = aqr107_link_change_notify,
+},
 {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQCS109),
 	.name		= "Aquantia AQCS109",
@@ -726,6 +745,7 @@ static struct mdio_device_id __maybe_unused aqr_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR105) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR106) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR107) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR115) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQCS109) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR405) },
 	{ PHY_ID_MATCH_MODEL(PHY_ID_AQR113C) },
-- 
2.35.1.1320.gc452695387.dirty

