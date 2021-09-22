Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65153414FAA
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbhIVSQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:16:54 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:48961
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237033AbhIVSQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:16:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHct/9yRiNtepWgl0mhCd8gbWzF0YTsGfzvVoWbZTD/FzsjwMS18LohHCBnVKkiJ1gltTkporyNJElkc1KWGEQvz8sqBdPLtAOQ44hXAqjtazPxSIHqOzO/H+OJ2GKURPFAWL7YL3NQ2Yay/4ELcf4HGgrM26rmj3vLsvr6/TK9to5NEs41zRbenvKx1OD9OtGD1EYeTrOaYbZJgPf3vmzp8roeApX71VjoshTw/dwlyDtyLief2LNMjLxoIXzPiK/2qw8TLtPl/9oul1L2gzSiIdYSGOAWJQehL5oucJM5wCCTekCTJ49GIeXqjN6sEhsZP5opTe3dteVGWysnR/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IUUv7w8y4VrxEAl5p0iX7ca9gpCocEW4pl4IMYu23SM=;
 b=UbUPJ3oonhAK6PIR5O8CHQPNPGAr8jRUI7kV/1wnmH7As4lNQ4o5eO/k/I4oP33PVPhlSbJ8OWUy0vrLO9EvzHltkn38aXZ4h5dSuQMThMDe3gPzQPIVQGeputun+WPfn+GHeYDozljLP7XToYi1EcnqFAjzzU5JkWqagxAWALYGnbQrpGl3UfmMR+G9DLVZwtx2xNbUBxo9tvAAOdz4WGZpA1PBC1REEDBdu8ozcBmp0UIp6fMgDAcVd1g1SxOmwGZ/eb4kHgB6WkoKpBz0LU+WNeA41j2KClI5q67FHiRyiKKJBubhOujvOua9+2HlwG9RKhVratJA6ua7Cdc44g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUUv7w8y4VrxEAl5p0iX7ca9gpCocEW4pl4IMYu23SM=;
 b=GN9cPO5UZ3HyHm5ZqlAEL0JVGpMqDIyrAJA+ZKJnSPTVhrXXC7ykPReXF3kcK+Z1jsmT4pgC6PluxCYN4Bp8qHQuxJbQ0CNI0qOkpJWyrobAYbfssp+l5HzweieG5MN7ODaaf57/EIpo3gV0lxX6ANTKZfGGiBMMR9T3op4HhMs=
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
 18:15:18 +0000
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
Subject: [RFC PATCH v3 net-next 2/6] net: phylink: introduce a generic method for querying PHY in-band autoneg capability
Date:   Wed, 22 Sep 2021 21:14:42 +0300
Message-Id: <20210922181446.2677089-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.53.217) by PR2PR09CA0001.eurprd09.prod.outlook.com (2603:10a6:101:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 18:15:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bdba0b1-2638-4628-830e-08d97df4ee4d
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471B8F0188A068FC1C5EDF9E0A29@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYVDTKpWi9Uku1f4oFi2nRNhLsw8LlCrZd6hDGTBfs00dH/fDijt2tYJTfLElzBVYXs1fhz8D1ABoHzf2x5I7pBEelL665SlzEI1qIYXtVlixUVTWlLLio76lCQ9jT02SDaVSkysMs4bM1kcIlE8s1eCqH6uug/EHru/YCX9XuaJr9EBtxlmvIR31C5j2jibbqUM7l9N7JsbrHSUJ0jD1CWjALbxCjFNCdLLuFp+LY7ixYtc1NiQBM2OS9NejJJm83hdgdtTxNnV1JXgiJeLvVUJ1wYDf/8LYG91dKLqmx/lXWCNmAMhlYiWdPB2p6cAvQihcXUA/Bir3OuMdxcc5HzFC19o+Qm/wFc94ho1uNGjbuH0vU8QXmN6+Z2S/1STP+r10PNb0ebUOrO9n/i9owtjuri8iuZvGdQLHL9nli9tFgXczhk36c58inenHs0QO0rrG1KjPa5l0aFIO92BTZAAAF9gdmo9wGo/z1QrLa2VE5+yyGjM5Cv5VuDWAgHKgH4rZm99p/rCzkvM2+y7RzBFpUYolAySO6qqKcBaCcaaTHWMqe7Wxo9ZAVLYLWYOnRMxBirAGqWFI6LjIHcLHmypAFF+GAco4PfRvMw+QgE3jSFKbtVzGP4pOGiJUxvrY4a/7YC7E/kna2TQzS902wTpDFwzeudgGubM0WaK7dEDPPjnpqR+SWhIQFd3TKNOLSlIzYklioeBw+iwU4lTaNzFDqFRPNqdAQhE/KmS0Z8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(66946007)(66556008)(26005)(38100700002)(2616005)(6512007)(2906002)(508600001)(83380400001)(66476007)(38350700002)(8936002)(6666004)(7416002)(8676002)(1076003)(54906003)(6486002)(52116002)(6916009)(44832011)(6506007)(316002)(86362001)(36756003)(956004)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bt8fsdr+yYcxXr8O4Wv88uTPs8qye1SJ0WnXd+LLZQ2i24XXAm4jXD8kxn3L?=
 =?us-ascii?Q?gM2pduoLCZ9DI8QRBbu4c9C3p0CmstIGUsVlRG640Q+zVYxf3nZtHPEvqP2u?=
 =?us-ascii?Q?PcSpBwLeb8wgFvPL5QS/A7nS0ctTwvRIlbFCauacKW9XjTiWsefa5kTrEe84?=
 =?us-ascii?Q?AQ7m/uiF3xMXIYuQUAycNEd0DBQTho4RFQbz5kD4wPNRRWaf/s2H8+vLkYBN?=
 =?us-ascii?Q?89uAcWs+aqql+YziZc4yTs5dZQfzFXVnsTHniAuNFhykYf1eSbDX424dBWSC?=
 =?us-ascii?Q?ZZWeopmJ+GSZq9YFH6uyY++2us8p0mHSjiqvQ/4hIK5w1+XqqhIcce+LAwlF?=
 =?us-ascii?Q?D5h/J6ViCjK23Ew9zz4gNxzBNHAqRGfR9931Ip1BoamfZQnYUeGUkJsYWGpx?=
 =?us-ascii?Q?lhw35xNv9MEYgVyS3++RK4tw6KmuOgWfAo14oZIVutFaQFRFsFwi3GYs1yD0?=
 =?us-ascii?Q?HRofAe1jxXRFF17Cguds1ozCtXDItfACkeblVKchfo9uZc3KavjUmxoT1Ykj?=
 =?us-ascii?Q?5pQ0LW9RZJ2I1f2FafV49pUIRKP59aS46Fep/syffl91n/hVeXSwU7IKzpvu?=
 =?us-ascii?Q?qPU4w4b7wR0adBIdsp3+wZomU38R+2pbNPjBmoU2xywybmjXkXx/Bfk1Pjcm?=
 =?us-ascii?Q?HMR6/JH0l4iv8XUAMb2869FiFKE6+uraYJda8kxuBuHQFzTrekpujy97MtD1?=
 =?us-ascii?Q?bx9GdOSNYotuqF5gRquUwand8sbiK9TQgZViABUYmaUK0NxxtJj2/HZVmR1m?=
 =?us-ascii?Q?tuk3XWB+pFiuFXliWy4DUktqm99yAu/PppzD42Lor48fTQeM+ineP3Po8GbV?=
 =?us-ascii?Q?mBYzFr/cXdFRQgwGZH0m7jQpJEKKhpkdH5QhRmgBGdk80Udhr4Bv7bVPvfu6?=
 =?us-ascii?Q?yI/XGRYDchGEmpD1E6UKxp6f7nW141e95Qe6ZOc2HBIRlKK6ve08Cv/TiwB+?=
 =?us-ascii?Q?axzFi8XD2qoMbP2PCca99PWNsBKXsoIxRHSgB3UbGHc6WUW4Mel0Ju0kmMGE?=
 =?us-ascii?Q?GkY3tHIv065fyrijsmlUNBVXMM1bvAS9U9nODzejwFaxapRnsYfsNPxQa72W?=
 =?us-ascii?Q?ZiJUI/XQQa2IjuUUm/vag/yIO6dcFE84LAQjy39hCoUkddKqgobxO5isgT6I?=
 =?us-ascii?Q?/q2t3R66q1um8iQgioeBkZDa9ToXnKCNRd0ayoz3s/EbNbqTYYR6kdR13bRb?=
 =?us-ascii?Q?xlurJ9qwgmUNDjl8ms3Y033gg1T9Ze+oyXYxbtO9vG9qidSmYY0PEyUhShqK?=
 =?us-ascii?Q?+1hOaQn39jhTw72HUUNRw9utCj1qmVkfhCTXymA9DlbF0xJy+uw9Ago9UNhW?=
 =?us-ascii?Q?gvf7IRhKxu6q/5vMEuE9lCHE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bdba0b1-2638-4628-830e-08d97df4ee4d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 18:15:17.4674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5bNiv5tPeHV1v5PoKTXWfZn+ow9ptUl0HV1qr7KZGnrqu4FAX9tM5/IgPMxPSCH2tMrNS2uv7/zj/uJRNrmFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink parses the firmware node for 'managed = "in-band-status"' and
populates the initial pl->cfg_link_an_mode to MLO_AN_PHY or MLO_AN_INBAND
accordingly, but sometimes things do not really work out at runtime, and
the pl->cur_link_an_mode may change.

The most notable case is when an SFP module with a PHY that has broken
in-band autoneg is attached. Phylink currently open-codes a check for
the BCM84881 PHY ID and updates pl->cur_link_an_mode from MLO_AN_INBAND
to MLO_AN_PHY.

There is an additional degree of freedom I would like to add. This has
to do with the on-board PHY case (not on SFP). Sometimes, a PHY can only
operate with in-band autoneg enabled, but the MAC driver does not
declare 'managed = "in-band-status"' in the firmware node (say it was
recently converted from phylib to phylink). If the MAC driver is strict
in its phylink ops implementation, it will disable in-band autoneg and
thus the connection to the PHY will be broken.

The firmware can (and should) be updated, but if the PHY driver is
patched to report that it only supports in-band autoneg, then the
pl->cur_link_an_mode can be fixed up to request in-band autoneg from the
MAC driver, even if the firmware node does not. While I do not expect
production systems to rely on this feature, it seems sensible to have it
as long as it is not difficult to implement (the PHY driver should be
updated with a small .validate_inband_aneg method), and it can even ease
the transition from phylib to phylink.

There is also the reverse case: the firmware node reports MLO_AN_INBAND
but the on-board PHY doesn't support that. That sounds like a serious
bug, so while we still do attempt to fix it up (it seems within our
reach to handle it, and worth it), we print to the kernel log on a more
severe tone and not just at the debug level.

So if the 3 code paths:
- phylink_sfp_config
- phylink_connect_phy
- phylink_fwnode_phy_connect

do more or less the same thing (adapt pl->cur_link_an_mode based on the
capability reported by the PHY), the intention is different. With SFP
modules this behavior is absolutely to be expected, and pl->cfg_link_an_mode
only denotes the initial operating mode. On the other hand, when the PHY
is on-board, the initial link AN mode should ideally also be the final
one. So the implementations for the three are different.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phy.c     | 13 ++++++++
 drivers/net/phy/phylink.c | 63 +++++++++++++++++++++++++++++++++++++--
 include/linux/phy.h       | 16 ++++++++++
 3 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index f124a8a58bd4..975ae3595f8f 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -750,6 +750,19 @@ static int phy_check_link_status(struct phy_device *phydev)
 	return 0;
 }
 
+int phy_validate_inband_aneg(struct phy_device *phydev,
+			     phy_interface_t interface)
+{
+	if (!phydev->drv)
+		return -EIO;
+
+	if (!phydev->drv->validate_inband_aneg)
+		return PHY_INBAND_ANEG_UNKNOWN;
+
+	return phydev->drv->validate_inband_aneg(phydev, interface);
+}
+EXPORT_SYMBOL_GPL(phy_validate_inband_aneg);
+
 /**
  * phy_start_aneg - start auto-negotiation for this PHY device
  * @phydev: the phy_device struct
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fd02ec265a39..f9a7c999821b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1043,6 +1043,39 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
 	return phy_attach_direct(pl->netdev, phy, 0, interface);
 }
 
+static unsigned int phylink_fixup_inband_aneg(struct phylink *pl,
+					      struct phy_device *phy,
+					      unsigned int mode)
+{
+	int ret;
+
+	ret = phy_validate_inband_aneg(phy, pl->link_interface);
+	if (ret == PHY_INBAND_ANEG_UNKNOWN) {
+		phylink_dbg(pl,
+			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
+			    phylink_autoneg_inband(mode) ? "true" : "false");
+
+		return mode;
+	}
+
+	if (phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG_ON)) {
+		phylink_err(pl,
+			    "Requested in-band autoneg but driver does not support this, disabling it.\n");
+
+		return MLO_AN_PHY;
+	}
+
+	if (!phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG_OFF)) {
+		phylink_dbg(pl,
+			    "PHY driver requests in-band autoneg, force-enabling it.\n");
+
+		mode = MLO_AN_INBAND;
+	}
+
+	/* Peaceful agreement, isn't it great? */
+	return mode;
+}
+
 /**
  * phylink_connect_phy() - connect a PHY to the phylink instance
  * @pl: a pointer to a &struct phylink returned from phylink_create()
@@ -1062,6 +1095,9 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 {
 	int ret;
 
+	pl->cur_link_an_mode = phylink_fixup_inband_aneg(pl, phy,
+							 pl->cfg_link_an_mode);
+
 	/* Use PHY device/driver interface */
 	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
 		pl->link_interface = phy->interface;
@@ -1137,6 +1173,9 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 	if (!phy_dev)
 		return -ENODEV;
 
+	pl->cur_link_an_mode = phylink_fixup_inband_aneg(pl, phy_dev,
+							 pl->cfg_link_an_mode);
+
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
 	if (ret) {
@@ -2207,10 +2246,28 @@ static int phylink_sfp_config(struct phylink *pl, struct phy_device *phy,
 		return -EINVAL;
 	}
 
-	if (phy && phylink_phy_no_inband(phy))
-		mode = MLO_AN_PHY;
-	else
+	/* Select whether to operate in in-band mode or not, based on the
+	 * presence and capability of the PHY in the current link mode.
+	 */
+	if (phy) {
+		ret = phy_validate_inband_aneg(phy, iface);
+		if (ret == PHY_INBAND_ANEG_UNKNOWN) {
+			if (phylink_phy_no_inband(phy))
+				mode = MLO_AN_PHY;
+			else
+				mode = MLO_AN_INBAND;
+
+			phylink_dbg(pl,
+				    "PHY driver does not report in-band autoneg capability, assuming %s\n",
+				    phylink_autoneg_inband(mode) ? "true" : "false");
+		} else if (ret & PHY_INBAND_ANEG_ON) {
+			mode = MLO_AN_INBAND;
+		} else {
+			mode = MLO_AN_PHY;
+		}
+	} else {
 		mode = MLO_AN_INBAND;
+	}
 
 	config.interface = iface;
 	linkmode_copy(support1, support);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 736e1d1a47c4..4ac876f988ca 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -698,6 +698,12 @@ struct phy_tdr_config {
 };
 #define PHY_PAIR_ALL -1
 
+enum phy_inband_aneg {
+	PHY_INBAND_ANEG_UNKNOWN		= BIT(0),
+	PHY_INBAND_ANEG_OFF		= BIT(1),
+	PHY_INBAND_ANEG_ON		= BIT(2),
+};
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -767,6 +773,14 @@ struct phy_driver {
 	 */
 	int (*config_aneg)(struct phy_device *phydev);
 
+	/**
+	 * @validate_inband_aneg: Report what types of in-band auto-negotiation
+	 * are available for the given PHY interface type. Returns a bit mask
+	 * of type enum phy_inband_aneg.
+	 */
+	int (*validate_inband_aneg)(struct phy_device *phydev,
+				    phy_interface_t interface);
+
 	/** @aneg_done: Determines the auto negotiation result */
 	int (*aneg_done)(struct phy_device *phydev);
 
@@ -1458,6 +1472,8 @@ void phy_start(struct phy_device *phydev);
 void phy_stop(struct phy_device *phydev);
 int phy_config_aneg(struct phy_device *phydev);
 int phy_start_aneg(struct phy_device *phydev);
+int phy_validate_inband_aneg(struct phy_device *phydev,
+			     phy_interface_t interface);
 int phy_aneg_done(struct phy_device *phydev);
 int phy_speed_down(struct phy_device *phydev, bool sync);
 int phy_speed_up(struct phy_device *phydev);
-- 
2.25.1

