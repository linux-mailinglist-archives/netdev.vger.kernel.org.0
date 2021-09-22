Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88127414FA8
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbhIVSQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:16:51 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:48961
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236988AbhIVSQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:16:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3Ga4IaMk4ABmBs7Q+PvRWiWmD00DmZKpYDL7cL0GlDswy9SSHpbX1aSBGrA/IffycljXfKtZZzi4qGXrf4Rg1ugW74U4uxiQVO2kc6JEfliKFxccXxruLR/gBaQAKbsUu2vk87Bqf2LdYlwwbw6NpU2zhnn2lFCLDTGfzVxln8KHQtuZ7TiczBeYXEsAiRSBCM5lxPdWO2xUwPINBRircpqV+wmAt4zAGKInlHEJoyKA4V6sqVC7JZLN9RGBF/XGHhnKPz7GEaAQ8SCuafAroVf2Jq1gf2BbyMoJrJLPYU/CTCJtE99FtZ0Mcb3vvLAK31dEN3VuawLS3N7y37D7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nDfaBrfJdyRocSwlG59gcx2FstDBY7/J6QZTPCD5/Mc=;
 b=lrNJ9cvJY3Y7it0Re5lZvezqAqJB8Wcq0A+UNw/e4+FgFOTGuKb4Nhewm2lCYIlq4nDmvgiGvPFeWeM3yc2frGxeQ1HHFeDOq552AdfJZqzgDcDPqhZLAGd/KFGMekWtIhCENsEf8SKbYZnY3rDKSkz09vOgPcI1u6FsCHOuvlqtikv/SRI/kvAd0RWvA04yHwCjJPzKpCSygIxyjP2dsbj14JyRK3USPKc/Crop78LXa1bumHhtXjk2dVOlL/JGbUtWtqFYMz0rJy3HxLaHm5VH9oU7/LuLhdAgZwGHl+os4sXMyaWr3qR9kRsPFG81D5Y44g8amDhZtboP6OG8Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDfaBrfJdyRocSwlG59gcx2FstDBY7/J6QZTPCD5/Mc=;
 b=gKBVRDbX7Xgiahk6biIKNZJ9DKuE/FDZO7ZparRF1AARQg7ZQP0kmnUQP+fjzErANj8j3yQB62G2eBSqW4tIK6stu//bJAlEQyYcf9GBIzzROMqE4HJjxIc6fh/Xpr10CmRVik8ZhIUsx/Ycd600De6PZAY18A+a+yRKX9PCUyo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 18:15:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 18:15:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [RFC PATCH v3 net-next 1/6] net: phylink: pass the phy argument to phylink_sfp_config
Date:   Wed, 22 Sep 2021 21:14:41 +0300
Message-Id: <20210922181446.2677089-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
References: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2PR09CA0001.eurprd09.prod.outlook.com
 (2603:10a6:101:16::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by PR2PR09CA0001.eurprd09.prod.outlook.com (2603:10a6:101:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 18:15:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb84b08c-11e7-4bb6-c58e-08d97df4ed81
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471DB0588D460233E3CD093E0A29@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V7xbtkJAJsgCUFA2tkXx2RgJoDMrsbX3jJ/vIQA71PuiDZgodwwi26sMy3fo3sjrDzP1KTGT0nwIDes1R1sNcwuBEMGCyoB+TT4W1XpB3rixP4JcMmNGKy8Vsr+rxhtu1ORLF7TvxmWGyGOBzs+raL/BA41KAmCheVnqtl0FwU3emoHvdu3h1yGrdfeLdZ3R1IBH5HZUW0p+Rc++uDxwbnN0PUVC/mWAMH3f87oowXkablWElfVyO2zj6zGy5AS4cicKqOf46j+yXYoX166TsmLalnYAsTfeAOysrwmOpXnfVBy/KCrcOOFnfxMXIxfPVysWszIDjVeeYjalaKfLYwOHWE9+LYpEUtmyV4eXfTSXnwda7ygz6ksICcVccSYd/X0YuOIisnWHz8D1AmbeMyWf0PeJmoaX1FHf7FbCUXy8oMcgkm6sh4WENZf//NUAns5ajFG0scw3AkOoO5blDQrCUongC2in0lq6L4U7vFBSlAoit3IU8d04znWk2MiqJwzc2BDotH0LnrZWciB+f4Lg1lFV/icxBz+sFqOt55af9DImxgAEeK/F5nJTwCCjvcvVdU+MtXTZuFnj9y55ZhU0Y5xpGeImvzUsTBCjKIDsCcDvRCw+eJm+qKsOK8sn9XRoruT/4TEP7nnUazpW9yh/oicUe6gnmOVe+yeHqecS1d9j/hsiQw75YCw7AQWgjf2A8kHyOjo8W2Y2kDuXZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(66946007)(66556008)(26005)(38100700002)(2616005)(6512007)(2906002)(508600001)(83380400001)(66476007)(38350700002)(8936002)(6666004)(7416002)(8676002)(1076003)(54906003)(6486002)(52116002)(6916009)(44832011)(6506007)(316002)(86362001)(36756003)(956004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jm5nbMydphMOszKxYhPTv0EWpxWnfrBqPQogOAjrI6V7yaifFPG+L+Ncl0Z/?=
 =?us-ascii?Q?nrgnzNv9Z1hpRPreVIjRxO/NCDNtWrur3ucX93Ii61unGc9vT6I5IOJHP3KN?=
 =?us-ascii?Q?a3td/RQYMF6+TVHH1q+pKABkA6FX3ERqTD0v+SBDynU89t0xUD9Bx1l+6oq3?=
 =?us-ascii?Q?V3k1/yv26E2/42QlQZeBTLzKFuWNdn6xYAKuNh9cB+MUrn7rPrPmvpS9awSd?=
 =?us-ascii?Q?bCcfpPbMyO7OI3kBde++SyR3ulMDuEFSVRUUzCwDGX+QrD7Jbc13d4mQCk6I?=
 =?us-ascii?Q?cEo7kJnSq/yYlAIK+CQS8hO7Mh7Dyx/g1SqN0GhR4KxPugnITLJg3w+wt6rZ?=
 =?us-ascii?Q?IqRptNS/dupTqpx+RJbG2xIykDRleGxx5rEYkXkFjFXtHJ53iuBJ+BJMb3Au?=
 =?us-ascii?Q?6au6HeZSoG/fGPRWYXNCd32VQvTgcQXHBFGSQONBkIDHgRLGVwy4r0CP1R+k?=
 =?us-ascii?Q?C63Cx+tzsTC6NT+z2LnJtP/wvr9Ravo6fVYMvwsI9iPbkhXWyL+iS1xR/06T?=
 =?us-ascii?Q?7ibG8eZMulq5iVpL0QsU+wvu/1E2hlLsUkg+mjODm+jj2OyZ4Hn9uMPmbmnj?=
 =?us-ascii?Q?SzjkEFL9jYQrN78ir5qX9A+2P4k6+VOxeETbEbhYwOz79HDdSA0gswOxGDEw?=
 =?us-ascii?Q?ShPAPLrWUd1GPotfYSqmqHKso0PMMOotnwPD/tzPtg66VCbeeM9PS3dCF5et?=
 =?us-ascii?Q?Tdkcj9fMBost+zjTwwKywMHPGuGpG2MlelwLmYxb0WnPuFYtz2tuIUylLYx8?=
 =?us-ascii?Q?H8Pvf2TBTrQROdbbqXaaMmyY7+U4p0/BS+qa5FLO60mwyKq+XIz1BWNZ6owF?=
 =?us-ascii?Q?FwbLlZy1E0e3oczC8LzK+YFepCfBNdlQpNSOoaNNLw0BeIHj5QhQoo1PPZ1i?=
 =?us-ascii?Q?/ajN34OvFJmxVBG7cf9I3BeTImRww061sdbdAUaqjsHTjlyM8J9CjWbB8GPc?=
 =?us-ascii?Q?30BWLkN18pHwA1/zpgfdyhgr9Mq6qcS/XGiy6Ygd0/PF9/JVWRiwXznkZAwZ?=
 =?us-ascii?Q?NoRmUcFm3fneiarkBCQ7TM0mDpNtlVvJv5wefV0jBhJhfOFb1CuafD+rspk9?=
 =?us-ascii?Q?WyV8jaMDrcGQ5p+OVGkqQJUBNoASWltDIZlPaKGWCHOiReEUHeqopusd1O4m?=
 =?us-ascii?Q?zhCWy/DjQXmU0Fj/la1tn2dTQyIOiUdCFf0GToL3jouAX++iDEeK93AFzOFC?=
 =?us-ascii?Q?ROUVWF6YPMNrlyvoIJvNppQX33KFDt8J7yhER8k9GIdRI4FDJvbbcRH64wP5?=
 =?us-ascii?Q?eWUG/fncLzjoL+rk9GIIbV2Z7YlCa0wuH4b0OGXeDFz6nwZXzdw8lLuZRrWO?=
 =?us-ascii?Q?AW6KKpdoc2+ZaQUnqx2lNWUc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb84b08c-11e7-4bb6-c58e-08d97df4ed81
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 18:15:16.1571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIxP9lqplWGA8twCrJA5tjAwZn79XVX97DItu2mISosvQ1EIgYpgNs+7d710Al50rfHmZ51V7YI2MWM55Er7Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Problem statement: I would like to move the phy_no_inband() check inside
phylink_sfp_config(), right _after_ the PHY mode was determined by
sfp_select_interface(). But phylink_sfp_config() does not take the "phy"
as argument, only one of its callers (phylink_sfp_connect_phy) does.

phylink_sfp_config is called from:

- phylink_sfp_module_insert, if we know that the SFP module may not have
  a PHY
- phylink_sfp_module_start, if the SFP module may have a PHY but it is
  not available here (otherwise the "if (pl->phydev)" check right above
  would have triggered)
- phylink_sfp_connect_phy, which by definition has a PHY

So of all 3 callers, 2 are certain there is no PHY at that particular
moment, and 1 is certain there is one.

After further analysis, the "mode" is assumed to be MLO_AN_INBAND unless
there is a PHY, and that PHY has broken inband capabilities. So if we
pass the PHY pointer (be it NULL), we can drop the "mode" argument and
deduce it locally.

To avoid a forward-declaration, this change also moves phylink_phy_no_inband
above phylink_sfp_config.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phylink.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5a58c77d0002..fd02ec265a39 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2146,6 +2146,15 @@ int phylink_speed_up(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_speed_up);
 
+/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
+ * or 802.3z control word, so inband will not work.
+ */
+static bool phylink_phy_no_inband(struct phy_device *phy)
+{
+	return phy->is_c45 &&
+		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
+}
+
 static void phylink_sfp_attach(void *upstream, struct sfp_bus *bus)
 {
 	struct phylink *pl = upstream;
@@ -2160,7 +2169,7 @@ static void phylink_sfp_detach(void *upstream, struct sfp_bus *bus)
 	pl->netdev->sfp_bus = NULL;
 }
 
-static int phylink_sfp_config(struct phylink *pl, u8 mode,
+static int phylink_sfp_config(struct phylink *pl, struct phy_device *phy,
 			      const unsigned long *supported,
 			      const unsigned long *advertising)
 {
@@ -2168,6 +2177,7 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
 	struct phylink_link_state config;
 	phy_interface_t iface;
+	unsigned int mode;
 	bool changed;
 	int ret;
 
@@ -2197,6 +2207,11 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 		return -EINVAL;
 	}
 
+	if (phy && phylink_phy_no_inband(phy))
+		mode = MLO_AN_PHY;
+	else
+		mode = MLO_AN_INBAND;
+
 	config.interface = iface;
 	linkmode_copy(support1, support);
 	ret = phylink_validate(pl, support1, &config);
@@ -2261,7 +2276,7 @@ static int phylink_sfp_module_insert(void *upstream,
 	if (pl->sfp_may_have_phy)
 		return 0;
 
-	return phylink_sfp_config(pl, MLO_AN_INBAND, support, support);
+	return phylink_sfp_config(pl, NULL, support, support);
 }
 
 static int phylink_sfp_module_start(void *upstream)
@@ -2280,8 +2295,7 @@ static int phylink_sfp_module_start(void *upstream)
 	if (!pl->sfp_may_have_phy)
 		return 0;
 
-	return phylink_sfp_config(pl, MLO_AN_INBAND,
-				  pl->sfp_support, pl->sfp_support);
+	return phylink_sfp_config(pl, NULL, pl->sfp_support, pl->sfp_support);
 }
 
 static void phylink_sfp_module_stop(void *upstream)
@@ -2312,20 +2326,10 @@ static void phylink_sfp_link_up(void *upstream)
 	phylink_run_resolve(pl);
 }
 
-/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
- * or 802.3z control word, so inband will not work.
- */
-static bool phylink_phy_no_inband(struct phy_device *phy)
-{
-	return phy->is_c45 &&
-		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
-}
-
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
 	phy_interface_t interface;
-	u8 mode;
 	int ret;
 
 	/*
@@ -2337,13 +2341,8 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	 */
 	phy_support_asym_pause(phy);
 
-	if (phylink_phy_no_inband(phy))
-		mode = MLO_AN_PHY;
-	else
-		mode = MLO_AN_INBAND;
-
 	/* Do the initial configuration */
-	ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
+	ret = phylink_sfp_config(pl, phy, phy->supported, phy->advertising);
 	if (ret < 0)
 		return ret;
 
-- 
2.25.1

