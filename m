Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4DC3FB950
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbhH3PyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:54:06 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:46753
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237543AbhH3PyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 11:54:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhMugo1Vi5WKhw6Hj7gRbXqoQb27rV4H4otA0lOMRadRqE4dCmPNxdQLp8Ly7dCjqTNYb8xhEXzLr5u2qHwe8PZb1C72C1d9pcEW7lYCGuB63ynyNZ4H9kwUjIq4laHxjON4P52T3XUvRWsAwdre8Q3pQR70/FnyYLfR3Wpjfn0BdXExVnimKfLcWNRjm+UOLHet8tbhpdbHpYHWjx4mvULhBtz2blGczzDmZTmMn7AlEogThp+ksey14P+JNPVVp/WhTXp0LAcyLM9nkXqY9AHO7UCFuLeVrcoJgG1SzyJqLaFuMV5Yw+HgPkDMHq7MMKn51qN3JNEIskzwN/M2lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JsyINqOQIdPE7/gW+VhmduzS/K1sAWaGSjm9T15Nb4=;
 b=GJUS2puxkzxfTGgKtrxMCqYCUsRyo5JG7kPK2TkI2yPC9xsUq9YgWXwcuCK5ONpgVMvHkJsfsFhHr9QM23UTcNWIr3HPtX4Wplalz6rqMQL+tIBZTr1uQ8o+M5iqwLK76b8qzHeWO+VNEuDvd/j8IoOE8oasTSqXlV4zcuaMCWL8LERiMwdHxNJ34/TXFS37ZnYbx53CnqmwkY/fcA3E3cnpqiMUxDwdUhmxYbzWuI4X/AvJJcWXZdA2lX/FlwlArhGPW1ySL+gxcgXRHwF1Iu7QTdR2dCzfK30YCj6gPd7aWVgbKjWNZffnshDfhFEhkjEqmHS8bw93dj6+ThiX2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JsyINqOQIdPE7/gW+VhmduzS/K1sAWaGSjm9T15Nb4=;
 b=MP7C++d2qy6pz2HDnb1ygTe7WgTKWiGbsM2OIbgfN5eM3U/g2FTdf8SD6ZrdnDPtsqH97PYHUE7NgKSGWMgcyQClP17Ej4hf4XFUWxlRTasoYA5jSI1IrihJeTT47y/4ivoc/Q6BOcP9fNFWhse1ZSWonjDW1w4EXoBM3G0d7vU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Mon, 30 Aug
 2021 15:53:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 15:53:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC PATCH v2 net-next 1/5] net: phylink: pass the phy argument to phylink_sfp_config
Date:   Mon, 30 Aug 2021 18:52:46 +0300
Message-Id: <20210830155250.4029923-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 15:53:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d26e78a6-e148-488b-8cfe-08d96bce430a
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB491057F39B3AC16B9A4753D6E0CB9@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0s88fJL4EItNYYhQBJLZtAsONzsXDEIM9TKf3W8sfz/F8uyiDAXwfQAx2yPn9KImAzDinamfnnDihkKMSFHWqRxqXc2GgmkBFASYew4W5Q7skFSx841QckaSDbSsOicqNYElkjDuLwlqlMRYnoEsXKsJAJoGXWOctq3DBWNCiP3Hpd0Ss9crzJfqxWYrz3XxMsQUmEwFjLw+jJ81Jl/gHY5q6Ntunc6EZFIJh6xmaALbKCRBN88Nd6rZrrt2zcylz/I0Kc8T9EUCfcUMm4Gs632ao6nJMkpuO2+2NKDTPF28oEOQzrKE3e+Rfeyf+D6BVkFAIeJcuDbR8Rm/y9O6h5unRWlqfjnu64+fzQzZ6h5l22fRjYqV2IlHtuYc+ML30Ht/tEX9mH5JasLBOvoUDZrgXtC5d0HTcp8YiJkeGmPT4TVeJxcI2jjESnXpfg8p/zdKjyaYoTKw7l1grDUSSoHrvA4RgyMWjfaggNOpU0XAl22wvyBG9FDSUphXeloLMyAsOXSzIH8RZ8/zrYUxUxypazvwjP7zo2y3B3OqO2tpR8JNIvmTEVq7tQ81H5HSIoex3XubFHPgu/1g9KxIwKXcCz9Xheppsl+enury3Zroq8yxv8l1MIVlnhktejtWZfQGsdPWHW1dmFfPb/kuvzHAz8QN/QGQ7bOYNb/szxv2c2XFPBADYfx4MGjfu2X5wx+uYxtmL/3dYFGuoG53A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(5660300002)(186003)(6512007)(86362001)(36756003)(7416002)(2616005)(956004)(1076003)(6916009)(66946007)(8936002)(6506007)(2906002)(6486002)(8676002)(66476007)(66556008)(6666004)(38100700002)(54906003)(38350700002)(4326008)(83380400001)(26005)(44832011)(316002)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i0237qWbvSI4HXUqWQhuDXAyBrjhr4gj/aKBS8wxdAsJvQwMRP9A/flHm8b1?=
 =?us-ascii?Q?X5jBamAQ6bQwqxa5Bz6uddZeKk5+0+qcz9yMzDel66i2PCJBfnSKQ7DT3OYU?=
 =?us-ascii?Q?8Z4RHEAfIUA7n2Tja08YGqKGq7Sre5j6SNJw2SkVaoYV8YRf2iE5bttoYeQC?=
 =?us-ascii?Q?yHADPte2TrAnsBYzzZ2a9yEOZC7jZwSGyX+UgUP3UU1MIzrHz6n3MdAKOUY1?=
 =?us-ascii?Q?kBxYuIloBAVbJBD2EIpvNleLSA4iDXgqmA77j16O+bl+fQZ9/DpC0nWZX170?=
 =?us-ascii?Q?kIUURoZsQC8mcyJljCApJgtM3urFk6ZuVKklgOshq5EKW1wEm9sxAmbXvG24?=
 =?us-ascii?Q?zkzGwOsnNob/mXnNAdrHTopNp8ug3ABaibHyeNgErsGuxJmbUrnLVnKWktaK?=
 =?us-ascii?Q?mx9h/6zgwE+Jx9ywlPRaZBtto1IPxf17Bp+hprwZiuc3TtMd+YTe+PBrMB1G?=
 =?us-ascii?Q?/FQwIRh+UF66u3/leccnh52BbxgBLSGv9w11yP8cGfSJ853jQ1vBfWxilwJP?=
 =?us-ascii?Q?z1Nzrrs1l9m7p3CCoNonJFXKLN/HwzjBNXUS5nfYk05GD5ZPGIDD6/kFrhjD?=
 =?us-ascii?Q?En3DiEO9445regDlcgtmFm5DlraHKKvT44+9QQdkmGDUHDyxXlVe4jrbmFDi?=
 =?us-ascii?Q?eSUsdt/hp6ss2JlluUX8L0eN8AfHf29G1H9dHtGmuZsZEBfXPYSM9bSKVouW?=
 =?us-ascii?Q?BXTiz9GSbHiXNZZ0WhLdDfsBe/2rVWu3xjmdiblBb4p5LSNXlbHdRTyuO7a1?=
 =?us-ascii?Q?Wm1iiKSIIfhjjVof3cqKUP9v3eVCcXkZkukViaZNgY0d7T5BA2cf5cTTch6T?=
 =?us-ascii?Q?UavInNhXkKYqWmkhTTf+TyYbN8Pv0FquaEKva2zMqoML7hafbOVTIPIauCG6?=
 =?us-ascii?Q?T6bqQ28bFt4y81YccvSow0YASXxJIWkciChfBzxp8QvlU7SPtrhgMYyLh0qR?=
 =?us-ascii?Q?ybx4H5vX2ClcRNCvObXTQyxj/+s4r7LYOnXhoKxXX99A3pj2+pnhDzOrZizy?=
 =?us-ascii?Q?u8QXLV7k6Czv4hPz8fBOmJuVfz5PpmRyy4ncqCawetRsrG8CP7Dp2LdM4tb/?=
 =?us-ascii?Q?tXZVNfH5+V5ixGAXNidfdxnXc/K5/EHzLXWJLYiUD61KxH+PVtCEc5E/YLzu?=
 =?us-ascii?Q?9P0ZrIfB1N5OYErPG1aJWEi2UbVyLQrBpRy9GLDZUaNziLgvCrHAt0lPJLQ2?=
 =?us-ascii?Q?5LfxitSKxsxPCXpyvIo4a/Oy1b76xFBmyVW2pGmAV0orE2cJAjLAOF6LTSO9?=
 =?us-ascii?Q?1uEgJBOTIT/09aRGhWRKPGc4ZKg/kqKxBrsDkCL2S80oYmRjEWfz2oq/7TA5?=
 =?us-ascii?Q?JtQ2o+7+qu2GO4XtkWy8AU0p?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d26e78a6-e148-488b-8cfe-08d96bce430a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 15:53:08.4064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: alBKByfui5lsD/XxTla/by4U8ePYt9EQ+yggPNrY4JfYWtlPX2aoDOABEmnSR/65+HvfWC6W8SLdkeEsTdopuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
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
index 2cdf9f989dec..28edb3665ee9 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2035,6 +2035,15 @@ int phylink_speed_up(struct phylink *pl)
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
@@ -2049,7 +2058,7 @@ static void phylink_sfp_detach(void *upstream, struct sfp_bus *bus)
 	pl->netdev->sfp_bus = NULL;
 }
 
-static int phylink_sfp_config(struct phylink *pl, u8 mode,
+static int phylink_sfp_config(struct phylink *pl, struct phy_device *phy,
 			      const unsigned long *supported,
 			      const unsigned long *advertising)
 {
@@ -2057,6 +2066,7 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
 	struct phylink_link_state config;
 	phy_interface_t iface;
+	unsigned int mode;
 	bool changed;
 	int ret;
 
@@ -2086,6 +2096,11 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
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
@@ -2148,7 +2163,7 @@ static int phylink_sfp_module_insert(void *upstream,
 	if (pl->sfp_may_have_phy)
 		return 0;
 
-	return phylink_sfp_config(pl, MLO_AN_INBAND, support, support);
+	return phylink_sfp_config(pl, NULL, support, support);
 }
 
 static int phylink_sfp_module_start(void *upstream)
@@ -2167,8 +2182,7 @@ static int phylink_sfp_module_start(void *upstream)
 	if (!pl->sfp_may_have_phy)
 		return 0;
 
-	return phylink_sfp_config(pl, MLO_AN_INBAND,
-				  pl->sfp_support, pl->sfp_support);
+	return phylink_sfp_config(pl, NULL, pl->sfp_support, pl->sfp_support);
 }
 
 static void phylink_sfp_module_stop(void *upstream)
@@ -2199,20 +2213,10 @@ static void phylink_sfp_link_up(void *upstream)
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
@@ -2224,13 +2228,8 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
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

