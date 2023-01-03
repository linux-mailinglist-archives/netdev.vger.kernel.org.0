Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9CF65C91D
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbjACWFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbjACWFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:05:45 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2062.outbound.protection.outlook.com [40.107.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198F814D29;
        Tue,  3 Jan 2023 14:05:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHn1KFts8xodf4iuPvW9JgyhPgMhgzknIl8GNG8SRyaGyqWWKbSyJSennOGadI00Hi9+w8CuX5m507UvykzqAsLGtDV3MMTX0Jl5m6nUcaOdPxU8kL9iARTeS7WvXLiJ57qmi5AvRn4gvpkPOlkOVMkCe7AR8tCAy3ZSmGm3LZk1FB6Koi8u9JSpiJC7od2UNZ37xGI6GTrwkfNVMAS1uu9hDi/t+A05RiIqtBXCgPOYIPdbkoSZX2fdzwo2ziKhN2Ykj5ZEHQnRJCFguI/ds2qOOyBIoAsEd9jsZ7EaAkrR5eeHiKcGbxPXITyFrGhD3UL41Fb2MJZCFeBity1g0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBx2EPpjk5eg3mcjNHLHlcfeB089h5/CB2j8PXvrIjk=;
 b=XPTb3oqBqiFsp5vwNu/0R3HrkETS5oeUKcm0JvKla9159z4s6W94kdfVgJxH6nEXHKDYvFodcsUkooLPDxrYSU+33NX73fr4hc5mIILBTR/0srb8mQL+S1QsEvnztAbhrh6ohXr7ZLpIQMDZqGC4xuTK9rUh7EiV3jTVrSbZEf8GZnGvWBZ1XeUnEz/xx2W12dHrJGgePtjSlrH7UEsgvEs8h/CkvpUNxncA+EUPLa0O//ui7AnDL3f0CTAk+I+dmcrKp9S9e4nK6aFbGacHhDQ+6Jct0wGAzJY70xOsLg+D0BgTUJYcNdJ9zTcxxOriJeilfLvFzfbbDpqJaxSVXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBx2EPpjk5eg3mcjNHLHlcfeB089h5/CB2j8PXvrIjk=;
 b=d7agaVsF3qSeitqqrCxbapTanDHt1XqbxwkS/Ej/jfjypYpJfLozAvXgf10JoIpJcjzBHXrJC+KzDX8j9c9b7hd3u12DXhSdJbPlQ7cT/paeZabH4iaX5VsXgZz5VDmZjB79ncszv+jvV+RfCYkXEUzdUAHuIPLBfOKijFpaWCbRSxUyEGNzSN/VkgJKEUbr88dByCgb/jJdi+SS94Kz3WgFQj116pm041lyk23pumjMXndxFfkGMo0/H6+YxNWVSGuwCAFZYxDglpxhIQieOfeGNKPXAv5NJwE0RmzAc3GZaH0y2y2GFMrH4a4nLVBa6SUq3H7aW+dACaB88sN1Zg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by VI1PR03MB9900.eurprd03.prod.outlook.com (2603:10a6:800:1c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 22:05:40 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 22:05:40 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v5 1/4] net: phy: Move/rename phylink_interface_max_speed
Date:   Tue,  3 Jan 2023 17:05:08 -0500
Message-Id: <20230103220511.3378316-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20230103220511.3378316-1-sean.anderson@seco.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0332.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::7) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|VI1PR03MB9900:EE_
X-MS-Office365-Filtering-Correlation-Id: 09f99c14-fedf-4ced-dec7-08daedd6a6ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dzJBgWkz8wu+ZBdwjl5c4ztKnn75d1AFWZuH1QVfUEYpcM3sNpyIk9A5LjzxAuBdmSRef+MlzWZAENo5q1yX0JQt54LGnS4m8r7DMfMfS0r0lGMspwBw8EJr0ixQU1RFMyeo96CDoYd6Fo9ygc7v+Y03HfUc2nrzAFCpnOeXxRFMgjrICjh6fQgDvz1fsJ/MVNxvrowSyKP8Tah3kOt0op1LiBibtO9/sTGTZzLknv+GzqU/z520gRrX86IAlt5Khip+7QzYWMGPjHDbgerPgtWmpFbHpCRBr60w2tZuscWsyD6p1RiiFzflnCce4Cw6P0PE6Upt5WiT/g+g8aKrgIg9gp937blg96FTf8w4/MFUgiowaeQPHvxRoTIE6uoup2EMcip8Vvz9qJv3TqMrDmWaY7oeauPP0ZAR+yTSF/e0SFMwlac935bZdKyE50XwjeVGT+HDX4VDEXTGq6Vmj/bo8rNysL8H32uYTs2POV7w5vRfGQhWVK+rSdpsmORu1MuiCj69SUf0YOOC8vMekMeM42URlHsQ2N2ulceOhA1d1lZKXQXsQwidTlmESirtc1+zCBzYHe/x4lRfdcza++rd4U9om3XeHRfrpbnAB4BDvXriN3VavQubKUgzUU+mTfZw3Xlx7sFOdD+pezH4Dvgywrl632bvR+ZuzQKLrqVamFmKKCq8N4ZFuTwDE4PXLncfwmApILiI1ersdBsngOJjc7ApEY0UvC4zsYfBHiY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39840400004)(396003)(346002)(451199015)(110136005)(54906003)(26005)(186003)(52116002)(6666004)(1076003)(2616005)(66476007)(6486002)(66556008)(66946007)(6512007)(478600001)(4326008)(83380400001)(8936002)(8676002)(5660300002)(7416002)(41300700001)(44832011)(2906002)(316002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/yQNNFEQIqu5rt84iwn5vhW/p71sL1Tg/+e1r0NBUES12rlY4/dvZrOVGGXK?=
 =?us-ascii?Q?Oyu9HsWL5lTBKa29ApD9wgUBe2kG03/0U+kbdIsrU4Xpor7vVJ+zoXm6VTye?=
 =?us-ascii?Q?a3mYdwd3WdQWa1hXfYOMz5dDS04ExxxnkvVAlhYyJ0RgNBUg215Y6tE8j//m?=
 =?us-ascii?Q?ee7LIO1DiICRA9G5+mY1ML9oR+/SE4hrHf1Zb5GDCRCLvUrrvd0ZXUEr6ErM?=
 =?us-ascii?Q?Juv8mMcYipLlVFFV3KNlC6jfzWLCWAmlVKHxB2+d7MvrdR8o25dQY6hu5Teu?=
 =?us-ascii?Q?oZGm4Fv/ypmpJnOKz4ZnUFjuzXRNI0AbYqoOAN9C2Tl4y0dB0J4dnBhhaVhY?=
 =?us-ascii?Q?oA3LhoFS28ACIvTaL28GMztjPdgiZEzaBT9SPOLH2UPx0IfwzvtKkRYNtxZq?=
 =?us-ascii?Q?n+8LsA7pmeYMreRXsezIGsxCz/1zM1nU8btH0tVZAp2PgqovsajSl2mAEn2H?=
 =?us-ascii?Q?eR8gUtP6taIjkXnGKmFNkBtGr3yx6f9p/VCMUJJvY0HkBR4J9vmJdImUfbHH?=
 =?us-ascii?Q?up9dGTV4ldgOePIyZGM9sGGyrjPqfkPSV2O4VxAHihfKEWcmzk6+CSQdaSQx?=
 =?us-ascii?Q?RlVCYuNS3186CdpX4iLD1nh+JVHRA1ABRUOELk8XmgMmjSF+j10B1QsSNpOW?=
 =?us-ascii?Q?aiCVv1GIwLRInWgN768mp4U5Dks2WK2CchLGbsn7uDyr3x3HsxxjMG86MRy7?=
 =?us-ascii?Q?CpNkSvB2RwOj0qWkyYOsYExrXAZXp5IdzC8eEVGRo76QmQ7le4XHY/uDBlVk?=
 =?us-ascii?Q?4cZfBY5XklCFpJts67SdeWiAStMAP3ySE4ssOM/MQtP00JWoYN3zP4y5IcpC?=
 =?us-ascii?Q?Mmy26fWmyH9mYAyk6MBDXmwSlfc8lbWCP+Gqfk/XFcKcUVYRdaGz5/UAtJ31?=
 =?us-ascii?Q?eB95n0gUGDSdPynn5ZQUrtGxq/j2RmyjkWzoomzgh8oVQ/xFzq57e1i3YwYR?=
 =?us-ascii?Q?3zzTu9qd52mczFhdM/ChIrVYReXvhgpcEP75GEOv1G+H0E2oswjbfZHxuOi3?=
 =?us-ascii?Q?/X+a9wA6VSCSRqWygCqQyjHkzZI97Wvw+UDwEZR5Xb5qJ7bmZ3NPVPphnFcc?=
 =?us-ascii?Q?mx3SrZd4diAvlivvh0UjKZXCjvF3ngzdii0VOc7MWuDCTin1LSRgDN3c4oR2?=
 =?us-ascii?Q?uwG5wyW8vOyw7BC8UVjIGt084kMY+xjZy79XPoHZ5wMu+gejr9r9HHdFHtQh?=
 =?us-ascii?Q?KraXp+UjO3FjtacHFdkB2nD2Q1EUUvWKdTMkGAd5eI+FiR5sdkox08cVMWI/?=
 =?us-ascii?Q?N352MFkWGPHcy3C4iUxeAfoLJ7CeCTCiDALgw+J5oEuZ5iu41n3KObxY+qMZ?=
 =?us-ascii?Q?Tce85vTDuhrp84lp/buhr77j9NtnQu5PsTnKNuqgjduFqM54VcCvd4+KD40+?=
 =?us-ascii?Q?sGyvrAvEkVhCxtVvNu2SnhGB9hbn3T2oUQyBPZWBq0TEHDJAEMRs82fMVv58?=
 =?us-ascii?Q?HqlY83wqLDSCKQv/RQca4SIASMkrgw/dSMyRThK0EZID4IHlYZFSUDnWOLnp?=
 =?us-ascii?Q?LCV9Fkar3mrNsgfAtTscvGGhJiOCqPyOzsOkrYLj1j4D6uLJm9fpt3mVVRS6?=
 =?us-ascii?Q?HqU9sxJaWmFF209AdL+skbaCE+jiLzdPWM2nBphxMNB+JDLYF+w2+YmCuVDe?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f99c14-fedf-4ced-dec7-08daedd6a6ff
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 22:05:40.8167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJYRKcHxNfJspCkgINWgk6KJMS3wnQyXOBjLSL8wgguyKh1Bbw+oOH7R0zhylh4xplRmKVHCw3YPhHfwC81k/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB9900
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is really a core phy function like phy_interface_num_ports. Move it
to drivers/net/phy/phy-core.c and rename it accordingly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---

(no changes since v2)

Changes in v2:
- New

 drivers/net/phy/phy-core.c | 70 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/phylink.c  | 75 ++------------------------------------
 include/linux/phy.h        |  1 +
 3 files changed, 74 insertions(+), 72 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 5d08c627a516..5a515434a228 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -150,6 +150,76 @@ int phy_interface_num_ports(phy_interface_t interface)
 }
 EXPORT_SYMBOL_GPL(phy_interface_num_ports);
 
+/**
+ * phy_interface_max_speed() - get the maximum speed of a phy interface
+ * @interface: phy interface mode defined by &typedef phy_interface_t
+ *
+ * Determine the maximum speed of a phy interface. This is intended to help
+ * determine the correct speed to pass to the MAC when the phy is performing
+ * rate matching.
+ *
+ * Return: The maximum speed of @interface
+ */
+int phy_interface_max_speed(phy_interface_t interface)
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
+EXPORT_SYMBOL_GPL(phy_interface_max_speed);
+
 /* A mapping of all SUPPORTED settings to speed/duplex.  This table
  * must be grouped by speed and sorted in descending match priority
  * - iow, descending speed.
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09cc65c0da93..f8cba09f9d87 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -156,75 +156,6 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
-/**
- * phylink_interface_max_speed() - get the maximum speed of a phy interface
- * @interface: phy interface mode defined by &typedef phy_interface_t
- *
- * Determine the maximum speed of a phy interface. This is intended to help
- * determine the correct speed to pass to the MAC when the phy is performing
- * rate matching.
- *
- * Return: The maximum speed of @interface
- */
-static int phylink_interface_max_speed(phy_interface_t interface)
-{
-	switch (interface) {
-	case PHY_INTERFACE_MODE_100BASEX:
-	case PHY_INTERFACE_MODE_REVRMII:
-	case PHY_INTERFACE_MODE_RMII:
-	case PHY_INTERFACE_MODE_SMII:
-	case PHY_INTERFACE_MODE_REVMII:
-	case PHY_INTERFACE_MODE_MII:
-		return SPEED_100;
-
-	case PHY_INTERFACE_MODE_TBI:
-	case PHY_INTERFACE_MODE_MOCA:
-	case PHY_INTERFACE_MODE_RTBI:
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_1000BASEKX:
-	case PHY_INTERFACE_MODE_TRGMII:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_GMII:
-		return SPEED_1000;
-
-	case PHY_INTERFACE_MODE_2500BASEX:
-		return SPEED_2500;
-
-	case PHY_INTERFACE_MODE_5GBASER:
-		return SPEED_5000;
-
-	case PHY_INTERFACE_MODE_XGMII:
-	case PHY_INTERFACE_MODE_RXAUI:
-	case PHY_INTERFACE_MODE_XAUI:
-	case PHY_INTERFACE_MODE_10GBASER:
-	case PHY_INTERFACE_MODE_10GKR:
-	case PHY_INTERFACE_MODE_USXGMII:
-	case PHY_INTERFACE_MODE_QUSGMII:
-		return SPEED_10000;
-
-	case PHY_INTERFACE_MODE_25GBASER:
-		return SPEED_25000;
-
-	case PHY_INTERFACE_MODE_XLGMII:
-		return SPEED_40000;
-
-	case PHY_INTERFACE_MODE_INTERNAL:
-	case PHY_INTERFACE_MODE_NA:
-	case PHY_INTERFACE_MODE_MAX:
-		/* No idea! Garbage in, unknown out */
-		return SPEED_UNKNOWN;
-	}
-
-	/* If we get here, someone forgot to add an interface mode above */
-	WARN_ON_ONCE(1);
-	return SPEED_UNKNOWN;
-}
-
 /**
  * phylink_caps_to_linkmodes() - Convert capabilities to ethtool link modes
  * @linkmodes: ethtool linkmode mask (must be already initialised)
@@ -435,7 +366,7 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
 				       unsigned long mac_capabilities,
 				       int rate_matching)
 {
-	int max_speed = phylink_interface_max_speed(interface);
+	int max_speed = phy_interface_max_speed(interface);
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 	unsigned long matched_caps = 0;
 
@@ -1221,7 +1152,7 @@ static void phylink_link_up(struct phylink *pl,
 		 * the link_state) to the interface speed, and will send
 		 * pause frames to the MAC to limit its transmission speed.
 		 */
-		speed = phylink_interface_max_speed(link_state.interface);
+		speed = phy_interface_max_speed(link_state.interface);
 		duplex = DUPLEX_FULL;
 		rx_pause = true;
 		break;
@@ -1231,7 +1162,7 @@ static void phylink_link_up(struct phylink *pl,
 		 * the link_state) to the interface speed, and will cause
 		 * collisions to the MAC to limit its transmission speed.
 		 */
-		speed = phylink_interface_max_speed(link_state.interface);
+		speed = phy_interface_max_speed(link_state.interface);
 		duplex = DUPLEX_HALF;
 		break;
 	}
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 71eeb4e3b1fd..65d21a79bab3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1004,6 +1004,7 @@ const char *phy_duplex_to_str(unsigned int duplex);
 const char *phy_rate_matching_to_str(int rate_matching);
 
 int phy_interface_num_ports(phy_interface_t interface);
+int phy_interface_max_speed(phy_interface_t interface);
 
 /* A structure for mapping a particular speed and duplex
  * combination to a particular SUPPORTED and ADVERTISED value
-- 
2.35.1.1320.gc452695387.dirty

