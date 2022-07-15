Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1A8576948
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiGOWBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiGOWBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:03 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A73F868A7;
        Fri, 15 Jul 2022 15:00:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlbvdtyTkFvIczoEdR+ApEnrL7sZUUoI6Oi5NS7uX8fIp6LLVZysHY/wHgYSnW7UV4FEgZSW4gQqJkARXT3GDHxS7Bka6TWD8JoqaVx+Mes0ypDRY5TfmHZ6IxBYt0oyK5e9Zh5/UUgJ1TxFfjH895qVkeyfmlSR+lyHje/B+/mA0c/d1Hxl+93m89rl1i5ZPP95FrwhYtsrHply5GbZ4QR4w1XQcXu0Zh2jqI81brclaTD/FGZXFG6rQKPRgCEYkuhuU2zawMWLNTwt0hpShsVUKry7xSaFfkjNGN3gJwowLJnlCUTv/LBlTnHkEqqDFUBLTQNVKSGl7/WYSSR0Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKyIEPmxdQWxr0xKNkYQ5OCHp19pkWfoYCluchWDGzM=;
 b=bbBBjEJXdFuQk7f4MhKtRekaENqgzfDzeYjF70967UBEcWs4ncaqSfBNdFyFiCtDks1QkaG2/gOLapTKsYCtU0cG4jGM2UCYjyruNwrgpMnP4YMOTN20v/U/9XW6C1B8ILEg/qKFuUxTPtluHQeUyfU7Vl2am8Ew9NE+bDE71W4OmJNnVVibgkARhI/H71JD28GXICrLfgdXFUM4WF9GAX7gEi6yO8KU/dGYT4L5ru76qy852NzS0tOU5bR9GHt9uI8d/PrWCzok8D1XLoI8DUyH82vd07wWbreXDdQ13/7PsSJDbD6ncbCF3slI0+L5djWJNMgtcS+DN8YaTXQLHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKyIEPmxdQWxr0xKNkYQ5OCHp19pkWfoYCluchWDGzM=;
 b=GOcPyYEnNpED5onEAkWzuUxADuN46IsVfbJsETEOzMagLPqpG0E5IAyAcUPVwWFNOn1NYRDipCWprRZt8lRjuK2Cu+4uJbmLQzPyOJCDquXjlkuZzBvhF2/PkViUPWTatoolZT53HluFQzMtFZChIGk29QjIX4WWVyr5qXArJvsQcl8mlDX23GGrf882DCXAa1vJkKjMwZ6nqb/buVsx5MJJsaTFdT+lEea4+8RlY4iaY2Q/f7gvxxjZ+i8W+f62kiaHjQUpWhpXT3JuqSW5J9kNsmCL8oe17c6/n/0qSk6dUBCbpLE2zPVw1cTGjfJ249YI3GyeU7CDqqUq/tnLoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBBPR03MB5302.eurprd03.prod.outlook.com (2603:10a6:10:f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 22:00:31 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:31 +0000
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
Subject: [PATCH net-next v3 08/47] net: phylink: Support differing link speeds and interface speeds
Date:   Fri, 15 Jul 2022 17:59:15 -0400
Message-Id: <20220715215954.1449214-9-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0d570eeb-b41a-45a2-f5f2-08da66ad6f84
X-MS-TrafficTypeDiagnostic: DBBPR03MB5302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPefRGTeTxNWly2bWJws7NeqIFAW48Fycknlt7s2tYWouYGEKgLfkijquY4OpNaYLlrj1/UnNUHYh/QiaTNZ5FEPj3rc9/sSWjd6CMdB+hP8JB5Vfor0CZelwDssXn1+fJia3W3gRAAqilokSB1c2fGw8G7hPBXfVZRbIqIq9ILrBD3SBvSfvSWNHwX95GY/e75jU4YyMMZWfvNXoRvKaIQsg1NDy6siEey6we9+C57NNWpfYM8hk1DbORASONfme2cvylswXt8ffwZJAkC07ypnF9YLxPHDrirSDbrPXONL3ZATziA3XJjUUFr7R/NwsWRYPz72Rr4pYIBbBrGaN+kve46QxFm71+93QDB3PLD+Nu2RChRA1Dy8cvxn0TpaED2IgFXE2uc598Wm/tOfWfw3JN2zvLxUfyLclvnoFbWgYWiPKghW4quIAcmq2fvl8OzD5O5pcMgFv6RkMNcErIhZYy/qXTOjmLSaYvxTkIo367FBWFJmLmHP8dXXMZ2Vvl2TL5hRMDslElj/4mpHwXxiMsrHOGVF+0rmyfb8rtQSa94DKGn/+m1EguiLtmbUg7La96osHUU2Ot202haAZvTJLjIP1M4SFFb3Su9XcvAQLvkkvTfG8hjIdKLCQsi7FJ1SCCN+QprsXk3WYRI0NLcDUbZ5Eq2yjfwHfsuLPikoMDJbd1PqO+d/QYoAhoj3a7pUTEMPbuv+u5JT4baFDL7lz4Y5ZK/34FM/XsTQkYv4X+c/rb9+67EImy9RSvby0CGVorbQ+GM1a7bBXBjA2sMqnAZv0yMdjnTPlcMsL3NndqwFkm0Z+Zpc85lVBEXm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(136003)(39850400004)(346002)(478600001)(66556008)(41300700001)(66476007)(52116002)(6506007)(6486002)(6512007)(26005)(8676002)(6666004)(54906003)(86362001)(66946007)(316002)(8936002)(4326008)(83380400001)(38350700002)(2616005)(1076003)(186003)(7416002)(36756003)(110136005)(38100700002)(2906002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aC3Ocn1vbLMVDDIdyFw4cM/MahJkNGsxWYD1tpKHd8B/gvHTGZKWCugrYHEC?=
 =?us-ascii?Q?ZlASOdi5CY9DE8y+rNpWtJ9y+r+PLGNifltpRhyLIlZPcSOZ3KCSGowzoH4f?=
 =?us-ascii?Q?AYx5EUfb2Xp3drRD8O+ot+oZzwwICXPefOy1xUXiVvNhdh5ZKFccGJRAdLNd?=
 =?us-ascii?Q?6GXymb2rDAe/9ayvCHIpowYT9cY788tg3aE2Zd93N15dCQvubUgUJkrFrxJf?=
 =?us-ascii?Q?/eEQ7QLdWEXAmv4BmA0630sbSbw+a4bzAQX2yWL2Sm+DefmQqCUms6O7G2Eq?=
 =?us-ascii?Q?BIOiEXnTUSMbELVsIqg0ekqctSzfa73biLqPCJDDKOi3kRgDz5nVGe3tqy+c?=
 =?us-ascii?Q?nGYZGPH3qvTEktN1t3A7bthA4SyHrC/r5kDwgHNQQClSMBYcjOEcmClwL3Gx?=
 =?us-ascii?Q?C9+JXvaMtkh2NquGgL251bcQQHIA4Y5jwHcVifztincgf50O76M4Ta63xQ2W?=
 =?us-ascii?Q?ZxJgtCiFk2ooHj5VIEf4oReYbngTJDzu8gvfE+HtHqDrIfYDlVaIj+IL3oFH?=
 =?us-ascii?Q?ceILfHvflduTfox/GnIDp4R83Ym5vfOHknNzhlcG6cjBDzRjIeyiKUEt8Lmq?=
 =?us-ascii?Q?UeLJRUTwomCBen/g5q1nHX0wZXbiDskLE/AgmnClIXOLyiBtbpDzjsa77JE+?=
 =?us-ascii?Q?9XSPLLECwy5O4WKMqwnSSNUzQ+KqOtxKFGe1qyo2DkIw/MY/R9+fFxAiRNyQ?=
 =?us-ascii?Q?HICeUmUGLpHzon7zq1FBC1X+tmZ4TF+HZ+RphZtHy0/uFGWPBN9LWRbQWQPf?=
 =?us-ascii?Q?pjI9IbyMz9+1wtwngbQ4fN+7hu/NqrNXNBmrUaATGyhBEDl4jRS4n2h5a6kI?=
 =?us-ascii?Q?XJT3H5pqusluDKEgRl0EEkZA3s9rqKGOJqj6M33qNPmu9omQUILAocdmsYnM?=
 =?us-ascii?Q?idIjkFp+/guDnyaQspwtoRsbWOLVj6V5BSVMQoz2jQBtfG71q7G3P7QVJ9m9?=
 =?us-ascii?Q?DbL2TyB7VQA2cP5CVMoH4eCts2SqOwRsJS5pq1pDfEbhChJWJu3NeNuN4wVw?=
 =?us-ascii?Q?PrPxw8Bf/exQZPg25LwEo3vdVHcGiumaQfw1boJdnekqUezyf3snjAfKOJLS?=
 =?us-ascii?Q?g/A33GIDl4gIACVruLNUaugyKJKjuw4+ZHEfhLVoWloph/QJnRdWNdyAUSXF?=
 =?us-ascii?Q?fgHq+Zhbp8yuk84T8ulmGPx0ya2soZnYL9jjF5OW8W3y4h/CPpCrRUudxhIr?=
 =?us-ascii?Q?cwgE+9wu8+DNNEnnfzq+7twN5CaJHriQabLT38ZdYZeiHOjJGPmurdeSbL06?=
 =?us-ascii?Q?LH8+3iPk1dT+NZ69w13Slky5DuMV8mP3OM6X8wku+9trreJgYPe6tzWzIaQc?=
 =?us-ascii?Q?nNEhHsVUAp2KMRRtO3YCpazVXvm+aZY0h0d0rm2W1XCKmGXbRVopsoOl8A5V?=
 =?us-ascii?Q?YFgL25aqaeubbQYT8358n1+kGzes/ABRqQrWeFSO2ZIs9aSBVjsomQloLscV?=
 =?us-ascii?Q?ilmMGP9Xee/mnrj6CHMP8aoDbgWTvHlWwnkd1EvqeA/Eaz3oXYpcfoT+vnWq?=
 =?us-ascii?Q?KxcNXMsL9DlfA221r5TLlglAltForqfhdMZbQG2q3Us6Ho78KUZtShmwg9iY?=
 =?us-ascii?Q?cDhg3LedbRAdRH5CXewrjPbg4ds/z14J+JttLqSFrFeSdGUAzQ6gT7F4JxJQ?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d570eeb-b41a-45a2-f5f2-08da66ad6f84
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:31.3800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NW/GzIHXjGXo13hrI/ii4bL7oxXzq3k1fgjF/7EOU+g9xKZGEpkHle0WE5sXBXfbQkoTLma6m151j87/0piYHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for cases when the link speed differs from the speed of
the phy interface mode. Such cases can occur when some kind of rate
adaptation is occurring. The interface speed is used for the link state
speed member. This is done for compatibility with existing drivers. For
example, if the link mode is 1000BASE-T, and the phy interface mode is
XGMII, then the MAC will expect SPEED_10000 for speed (which is what would
have been passed previously). On the other hand, external APIs use
link_speed instead of speed.  This is so the speed reported to userspace
matches the resolved link mode.

phy_interface_speed assumes that certain interfaces adapt to the link rate
and others do not. Generally, interface speed adaptation occurs by changing
the clock rate (such as for MII), or by repeating symbols (such as for
SGMII). This assumptation precludes using rate adaptation for interfaces
which already adapt their speed. For example, a phy which performed rate
adaptation with GMII (keeping the frequency at 125MHz) would not be
supported.

Although speed is one of the more prominent ways the link mode can differ
from the phy interface mode, they can also differ in duplex. With
pause-based rate adaptation, both the interface and link must be full
duplex.  However, with CRS-based rate adaptation, the interface must be
half duplex, but the link mode may be full duplex. This can occur with
10PASS-TS and 2BASE-TL. In these cases, ethtool will report the "wrong"
duplex. To fix this, a similar process could be performed for duplex.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 drivers/net/phy/phylink.c | 105 +++++++++++++++++++++++++++++++++-----
 include/linux/phylink.h   |   6 ++-
 2 files changed, 97 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b08716fe22c1..a952cdc7c96e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -296,6 +296,75 @@ static void phylink_caps_to_linkmodes(unsigned long *linkmodes,
 	}
 }
 
+/**
+ * phy_interface_speed() - get the speed of a phy interface
+ * @interface: phy interface mode defined by &typedef phy_interface_t
+ * @link_speed: the speed of the link
+ *
+ * Some phy interfaces modes adapt to the speed of the underlying link (such as
+ * by duplicating data or changing the clock rate). Others, however, are fixed
+ * at a particular rate. Determine the speed of a phy interface mode for a
+ * particular link speed.
+ *
+ * Return: The speed of @interface
+ */
+static int phy_interface_speed(phy_interface_t interface, int link_speed)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_100BASEX:
+		return SPEED_100;
+
+	case PHY_INTERFACE_MODE_TBI:
+	case PHY_INTERFACE_MODE_MOCA:
+	case PHY_INTERFACE_MODE_RTBI:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_1000BASEKX:
+	case PHY_INTERFACE_MODE_TRGMII:
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
+		return SPEED_10000;
+
+	case PHY_INTERFACE_MODE_25GBASER:
+		return SPEED_25000;
+
+	case PHY_INTERFACE_MODE_XLGMII:
+		return SPEED_40000;
+
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_REVRMII:
+	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_SMII:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_INTERNAL:
+		return link_speed;
+
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_MAX:
+		break;
+	}
+
+	return SPEED_UNKNOWN;
+}
+
 /**
  * phylink_get_linkmodes() - get acceptable link modes
  * @linkmodes: ethtool linkmode mask (must be already initialised)
@@ -515,7 +584,7 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 	if (fixed_node) {
 		ret = fwnode_property_read_u32(fixed_node, "speed", &speed);
 
-		pl->link_config.speed = speed;
+		pl->link_config.link_speed = speed;
 		pl->link_config.duplex = DUPLEX_HALF;
 
 		if (fwnode_property_read_bool(fixed_node, "full-duplex"))
@@ -559,7 +628,7 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 		if (!ret) {
 			pl->link_config.duplex = prop[1] ?
 						DUPLEX_FULL : DUPLEX_HALF;
-			pl->link_config.speed = prop[2];
+			pl->link_config.link_speed = prop[2];
 			if (prop[3])
 				__set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
 					  pl->link_config.lp_advertising);
@@ -569,11 +638,13 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 		}
 	}
 
-	if (pl->link_config.speed > SPEED_1000 &&
+	if (pl->link_config.link_speed > SPEED_1000 &&
 	    pl->link_config.duplex != DUPLEX_FULL)
 		phylink_warn(pl, "fixed link specifies half duplex for %dMbps link?\n",
-			     pl->link_config.speed);
+			     pl->link_config.link_speed);
 
+	pl->link_config.speed = phy_interface_speed(pl->link_config.interface,
+						    pl->link_config.link_speed);
 	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	linkmode_copy(pl->link_config.advertising, pl->supported);
 	phylink_validate(pl, pl->supported, &pl->link_config);
@@ -1270,7 +1341,8 @@ struct phylink *phylink_create(struct phylink_config *config,
 		pl->link_port = PORT_MII;
 	pl->link_config.interface = iface;
 	pl->link_config.pause = MLO_PAUSE_AN;
-	pl->link_config.speed = SPEED_UNKNOWN;
+	pl->link_config.link_speed = SPEED_UNKNOWN;
+	pl->link_config.speed = phy_interface_speed(iface, SPEED_UNKNOWN);
 	pl->link_config.duplex = DUPLEX_UNKNOWN;
 	pl->link_config.an_enabled = true;
 	pl->mac_ops = mac_ops;
@@ -1335,7 +1407,9 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	phy_get_pause(phydev, &tx_pause, &rx_pause);
 
 	mutex_lock(&pl->state_mutex);
-	pl->phy_state.speed = phydev->speed;
+	pl->phy_state.link_speed = phydev->speed;
+	pl->phy_state.speed = phy_interface_speed(phydev->interface,
+						  phydev->speed);
 	pl->phy_state.duplex = phydev->duplex;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
@@ -1413,7 +1487,8 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	pl->phydev = phy;
 	pl->phy_state.interface = interface;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
-	pl->phy_state.speed = SPEED_UNKNOWN;
+	pl->phy_state.link_speed = SPEED_UNKNOWN;
+	pl->phy_state.speed = phy_interface_speed(interface, SPEED_UNKNOWN);
 	pl->phy_state.duplex = DUPLEX_UNKNOWN;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
@@ -1857,7 +1932,7 @@ static void phylink_get_ksettings(const struct phylink_link_state *state,
 {
 	phylink_merge_link_mode(kset->link_modes.advertising, state->advertising);
 	linkmode_copy(kset->link_modes.lp_advertising, state->lp_advertising);
-	kset->base.speed = state->speed;
+	kset->base.speed = state->link_speed;
 	kset->base.duplex = state->duplex;
 	kset->base.autoneg = state->an_enabled ? AUTONEG_ENABLE :
 				AUTONEG_DISABLE;
@@ -1974,13 +2049,13 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		 * If the link parameters match, accept them but do nothing.
 		 */
 		if (pl->cur_link_an_mode == MLO_AN_FIXED) {
-			if (s->speed != pl->link_config.speed ||
+			if (s->speed != pl->link_config.link_speed ||
 			    s->duplex != pl->link_config.duplex)
 				return -EINVAL;
 			return 0;
 		}
 
-		config.speed = s->speed;
+		config.link_speed = s->speed;
 		config.duplex = s->duplex;
 		break;
 
@@ -1996,7 +2071,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 			return 0;
 		}
 
-		config.speed = SPEED_UNKNOWN;
+		config.link_speed = SPEED_UNKNOWN;
 		config.duplex = DUPLEX_UNKNOWN;
 		break;
 
@@ -2046,7 +2121,10 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
 		return -EINVAL;
 
+	config.speed = phy_interface_speed(config.interface, config.link_speed);
+
 	mutex_lock(&pl->state_mutex);
+	pl->link_config.link_speed = config.link_speed;
 	pl->link_config.speed = config.speed;
 	pl->link_config.duplex = config.duplex;
 	pl->link_config.an_enabled = config.an_enabled;
@@ -2291,7 +2369,7 @@ static int phylink_mii_emul_read(unsigned int reg,
 	int val;
 
 	fs.link = state->link;
-	fs.speed = state->speed;
+	fs.speed = state->link_speed;
 	fs.duplex = state->duplex;
 	fs.pause = test_bit(ETHTOOL_LINK_MODE_Pause_BIT, lpa);
 	fs.asym_pause = test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, lpa);
@@ -2588,7 +2666,8 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	memset(&config, 0, sizeof(config));
 	linkmode_copy(config.advertising, advertising);
 	config.interface = PHY_INTERFACE_MODE_NA;
-	config.speed = SPEED_UNKNOWN;
+	config.link_speed = SPEED_UNKNOWN;
+	config.speed = PHY_INTERFACE_MODE_NA;
 	config.duplex = DUPLEX_UNKNOWN;
 	config.pause = MLO_PAUSE_AN;
 	config.an_enabled = pl->link_config.an_enabled;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..30e3fbe19fb4 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -56,7 +56,10 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
  * @lp_advertising: ethtool bitmask containing link partner advertised link
  *   modes
  * @interface: link &typedef phy_interface_t mode
- * @speed: link speed, one of the SPEED_* constants.
+ * @speed: interface speed, one of the SPEED_* constants. If
+ *   @rate_adaptation is being performed, this will be different from
+ *   @link_speed.
+ * @link_speed: link speed, one of the SPEED_* constants.
  * @duplex: link duplex mode, one of DUPLEX_* constants.
  * @pause: link pause state, described by MLO_PAUSE_* constants.
  * @link: true if the link is up.
@@ -68,6 +71,7 @@ struct phylink_link_state {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	phy_interface_t interface;
 	int speed;
+	int link_speed;
 	int duplex;
 	int pause;
 	unsigned int link:1;
-- 
2.35.1.1320.gc452695387.dirty

