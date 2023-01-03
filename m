Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC12565C924
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbjACWG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238476AbjACWGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:06:22 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2064.outbound.protection.outlook.com [40.107.104.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1E2EE3D;
        Tue,  3 Jan 2023 14:05:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8DmdA0jk5gCJsK3PNAN6hhCwNzEYFb5tG2PooDcgOsYI17KKemUqYaonWj0akNIbUUry8haq4qmrJj5rCAGNE/qNvEm3y+xRyKCFSgv+zSHSzDyerYEFAvPb3C1GrvFvKjZg97I3MWdhlHRjHDDcCHFVEcsFOb5HobXh2HPAmCbGglAQlOil79B1rEPgwHUly5+vx2NK/9J8H+S5qxbEfI9j/zBYWfpd+FvaTAtBdkTJ5wJ1YIklaYI+mfO4AKotT7XxZ4MOSBDbx7OFva0VfUwe8dmS+APDwa9pctKYqeDLr4bEpUJvBMdCKb3DRBxRej3eqLnqBwgjQzCp2q58w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FixiQeZX2s4eSs/V+hSzO+cxbXlZ70ZmQ7Ft0qtjywU=;
 b=Dlf9m4v5YVLZPzFhLBQF94v+dCbeWdOWCnlp+TPG5s1Dt4+elJ7PsBkRNBXR54e6eSDQX2/i9s7JDHaVEmY0rMR1LgdjicGNiNsy2EZQyUKb8AVDMiu2JYMcyPUYDt5LCwCSbZb6Jce+IZi9l4Ee8QX3+P5Y2tObjKNlsBrubD8uFiLFKJAa7BgAX9OQsCKFWLAfz7J/jgbJqJMDqUUxLO36GNBegYLmJVklLorhwpRjp80Kxhovmp7Vml0GCsahwiYYvY9V6SJntV33Xxx0kJuGVpb/huXCpj9kolA1AtqhrXOv4WMNvV0QWLZDVtHS+LM8ibG3/TjYD82MYF4/hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FixiQeZX2s4eSs/V+hSzO+cxbXlZ70ZmQ7Ft0qtjywU=;
 b=ueUA6LQkgRNmhc0cQCPCu0C+HEhGzrHo1ukIxZKNsfufWlckwSbX9Oi5elZlA1sMhm3WpoJ0POa5x3Sz/yhxICS/13QFXD189ZZql0WKJUX5jJ5v8XA+XYaqzfjKt3Xwe+xOE85QfJvuBRvrc57S6bHqFu+95csnRWD8yBLygNiq1ezrwC0MsAGhs3jN98UBKrmXCyL/vN6+Q3p1/6ve/cGuy3R/8/0ECufTA1ITM/YHZKvEghmqvE6gueqi9lCA4WrV1iyTtfP8b1+fO2Yusd+80lesGZFta0hBf5t7MlT3hRlacHUhzT5fZjMqCD81/+MosDjf+t+zCGU/CXRjjw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by VI1PR03MB9900.eurprd03.prod.outlook.com (2603:10a6:800:1c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 22:05:51 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 22:05:51 +0000
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
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation support from registers
Date:   Tue,  3 Jan 2023 17:05:11 -0500
Message-Id: <20230103220511.3378316-5-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3aafd07d-0f39-44e8-3fa8-08daedd6ad61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U4s5GdQuOwYkBUIwirw2cbRKM0bNw4ODAoUIDTqeyITsO07Ysb031ZHv7jwBeRj0XBijx2WTloWnManYh1/jH/3WbKwOHXiM6yqGe21CSyRuiiq/O6px7m08TfqfYdDQJofpaS+TAyucCWo6rvY2gIZEqlFsqjfywqXsR96XFJuSZYfGGeBbaydWctu3VLxIDJJOk9gmxCyIw/aFwq/S+P0+QEUHq0+JBPb+dBbMMmAdIgZ5KViUkPVXbPJAG2eFhFtuPpyC/fAkfcP79Ek9KVlIKwiXp3CxoQ1JNDeQ3x/0WVIae89zByViXWe8JhNOyl5uL0ArJi1Hk2kdpypIm6ehBKXxHhn109JSaNG1jxsrA2Ldxw0vpuUxxL3/SuP8bGhuIkF+/4CoVoLpxsltOt4PFUuSSYHJYxslDWRmhELUAbtgRjFaD8yGch+hAmtsdiKgq7DWOnfV2Z0ORGPcDjmR5Jfq+IFFV0ZkJ6ZDAkxRZYo9ibrq4XSZS9Uvu+pxYkdeBcuvxSjsDCTeMJDG5WnTDgQyEM7D/vmsM6qG3mdQaLCGvD+qPsrTSAQyDt76r8c/rC31yaM3hnHeKh1KrBaePyamSmxqyloTVYVpFxLLLXAFly4eElh4wbqOvFuBMa9Xw82sbd0TV6GdBkoFdS7PvITQ578Rq/PwlUGdjpIk6a+4CAzCC1j5FO17X0PDgTyO4xc/gbT51AgRYKK4o8TmqpzV2iaCW1bYjCyOuCw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39840400004)(396003)(346002)(451199015)(110136005)(54906003)(26005)(186003)(52116002)(107886003)(6666004)(1076003)(2616005)(66476007)(6486002)(66556008)(66946007)(6512007)(478600001)(4326008)(83380400001)(8936002)(8676002)(5660300002)(7416002)(41300700001)(44832011)(2906002)(316002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krNJFP4NigfE4tSJSfT1WWUJjklw6t6VC4lh1iALDUZM1K3zB6T2yd6T/JjI?=
 =?us-ascii?Q?zEFTnlMnAbtrhzTinY7toW5rw+fHoDpG3TYrLcewYfHO4rIKkYeUBsbQgvxh?=
 =?us-ascii?Q?3l0dWKsgBoesi1Y+PeFXOpawhgycrPRzFsU4mGSAJ5m1E141ixKUvE0qQUSt?=
 =?us-ascii?Q?LSHW4ElofBrY2eSdDP+xP9Fdlv39l7wwtChiLycpdib/QH9lq5Dt5Iq2cvrR?=
 =?us-ascii?Q?31kOWOu+J8euDNJSFe/22A3WbzaUJEl4t9UfOMndXL9O+uIJXqATyB978UuK?=
 =?us-ascii?Q?7T331kUTNCskRjQQHB6obNcOX5ttZUsvOrlWKF3MPVNFowmtyhr3xIqUhe/p?=
 =?us-ascii?Q?SeFpaFYJd3FPLg3yoQ80GVP29GBpM6DDVHJRbVIU2KmSrfAcg3SNYjJDHT5s?=
 =?us-ascii?Q?A2c9wC9TbXww5/Y3l5/OW0g0S8/sC7n5Fq0Dn2kkEmiYm7nETtNJWrBPXf94?=
 =?us-ascii?Q?iUlacFtxXDdb5AsxnHEmjdp+47S0MlPvlFhwgSxGpdW0RLPHzSrRkTQwPs1W?=
 =?us-ascii?Q?hlFGNOl0DDZT31fSu0oMaWYtFNp1+gyvSsOMD785Y77019MSBH+qhuOajbFM?=
 =?us-ascii?Q?sTNJP+sj5abb/9v08dO6O6Ms0P8iLqwvFzUfr5YwCBQyLl0pOnwMR+YEaQlk?=
 =?us-ascii?Q?AKNNSgXVI3Zyw4DgQaQo4/RLYSz9yCzIooKj7hTR09d52IDLEZuLNX94YS89?=
 =?us-ascii?Q?/T0uI6PJM5lmUY0RDfAQEz1+RSnYNLx24mfbhgVAk2Ue4zzhJ7kf+l26GFId?=
 =?us-ascii?Q?gH4UbFy9iTE1byJyiT0RCtraF/yHjLTMHIT0IC4uPVajKKxVgAwdai4YlVrV?=
 =?us-ascii?Q?xYcwFcH3EdHnSyFzS1ETo7YOgkNa2/1Jcs7mMIG3eJFJScOM/OPpgFUf10E6?=
 =?us-ascii?Q?gQ6yyDllWqRRYNYyftjgHVc7VHSBUWvG5ED6avgFT1eMETYOdECsPIhrY76z?=
 =?us-ascii?Q?wcWzN8V7ajLFa9NH6leLXAT7TeDYqXS6FcnuzBEF2SvI593iRD/zf114cyzu?=
 =?us-ascii?Q?uOcOp4xePqmmQX1lEaNW+IL2Ko2IiTkIM/SVAf0mxnHwoxejZBHLQT2rum/q?=
 =?us-ascii?Q?o83cUFWqc5Kdit7FKMEwfr+Q5yoSY5htlZBqwPxzU0yhHCdHvefV7+RWy/2G?=
 =?us-ascii?Q?yXrQhstOq9OBZ8cnkdcDIPIBYBpDpo85FJ5nLIVQJAD8T/PLXwjjLvcFZlTa?=
 =?us-ascii?Q?oOsUgS5w38ubZyirh8sVWy1+0le70GZiBAZmi73C8OtDe0AJXUoUBucmd3eU?=
 =?us-ascii?Q?aAdgUDQ9uJPtmrzcYRZPoow4XimUDdyloNECxz3QvE4wTEpHYRBJjK2JCj+e?=
 =?us-ascii?Q?Bw94f7yv8KWDmyuQGEb1j2DBAT6IET8RtDNfhzw9yD6NX4d+zBM3V7RzdBZy?=
 =?us-ascii?Q?4qFSbrGimPVOoAsUz2fHBkb/UgyorNeXWWMwiyy1QfQY2bvs2pE9oDUxfx4i?=
 =?us-ascii?Q?ZgY6ZkMW3YySFfoPHyekXybJYX2tfn+m20utgrCmpy1Yofshz+VabLVYAmZ0?=
 =?us-ascii?Q?ILN1we9dejHNF9eUOm/s752vb6iMaqlCtI9KCR/+WO8PSRxkUmU7+crFglb4?=
 =?us-ascii?Q?yt6RW6yW+GN6zOkpvzdfXuqkfVTsalntj6HBKPWyjd1t17oiucOOWmVrU4XL?=
 =?us-ascii?Q?DA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aafd07d-0f39-44e8-3fa8-08daedd6ad61
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 22:05:51.5211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0TDNglbytGbmspDeJzX8n6kSr6allzP0tWsjna8MCxI/M2BMx3NkkjQyRDQwzYNeYoLOevH/R6m/bsr4QEzOA==
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

When autonegotiation completes, the phy interface will be set based on
the global config register for that speed. If the SERDES mode is set to
something which the MAC does not support, then the link will not come
up. To avoid this, validate each combination of interface speed and link
speed which might be configured. This way, we ensure that we only
consider rate adaptation in our advertisement when we can actually use
it.

For some firmwares, not all speeds are supported. In this case, the
global config register for that speed will be initialized to zero
(indicating that rate adaptation is not supported). We can detect this
by reading the PMA/PMD speed register to determine which speeds are
supported. This register is read once in probe and cached for later.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This commit fixes 3c42563b3041 ("net: phy: aquantia: Add support for
rate matching"). In an effort to avoid backporting of this commit until
it has soaked in master for a while, the fixes tag has been left off.

Changes in v5:
- Don't handle PHY_INTERFACE_MODE_NA, and simplify logic

Changes in v4:
- Fix kerneldoc using - instead of : for parameters

Changes in v3:
- Fix incorrect bits for PMA/PMD speed

Changes in v2:
- Rework to just validate things instead of modifying registers

 drivers/net/phy/aquantia_main.c | 136 ++++++++++++++++++++++++++++++--
 1 file changed, 128 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 334a6904ca5a..06078cd2d5b3 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -111,6 +111,12 @@
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
+#define VEND1_GLOBAL_CFG_SERDES_MODE		GENMASK(2, 0)
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI	0
+#define VEND1_GLOBAL_CFG_SERDES_MODE_SGMII	3
+#define VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII	4
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G	6
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G	7
 
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
@@ -175,6 +181,7 @@ static const struct aqr107_hw_stat aqr107_hw_stats[] = {
 
 struct aqr107_priv {
 	u64 sgmii_stats[AQR107_SGMII_STAT_SZ];
+	int pmapmd_speeds;
 };
 
 static int aqr107_get_sset_count(struct phy_device *phydev)
@@ -677,14 +684,119 @@ static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
 	return 0;
 }
 
+/**
+ * struct aqr107_link_speed_cfg - Common configuration for link speeds
+ * @speed: The speed of this config
+ * @reg: The global system configuration register for this speed
+ * @speed_bit: The bit in the PMA/PMD speed ability register which determines
+ *             whether this link speed is supported
+ */
+struct aqr107_link_speed_cfg {
+	int speed;
+	u16 reg, speed_bit;
+};
+
+/**
+ * aqr107_rate_adapt_ok() - Validate rate adaptation for a configuration
+ * @phydev: The phy to act on
+ * @serdes_speed: The speed of the serdes (aka the phy interface)
+ * @link_cfg: The config for the link speed
+ *
+ * This function validates whether rate adaptation will work for a particular
+ * combination of @serdes_speed and @link_cfg.
+ *
+ * Return: %true if the @link_cfg.reg is configured for rate adaptation or if
+ *         @link_cfg.speed will not be advertised, %false otherwise.
+ */
+static bool aqr107_rate_adapt_ok(struct phy_device *phydev, int serdes_speed,
+				 const struct aqr107_link_speed_cfg *link_cfg)
+{
+	struct aqr107_priv *priv = phydev->priv;
+	int val;
+
+	phydev_dbg(phydev, "validating link_speed=%d serdes_speed=%d\n",
+		   link_cfg->speed, serdes_speed);
+
+	/* Vacuously OK, since we won't advertise it anyway */
+	if (!(priv->pmapmd_speeds & link_cfg->speed_bit))
+		return true;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, link_cfg->reg);
+	if (val < 0) {
+		phydev_warn(phydev, "could not read register %x:%.04x (err = %d)\n",
+			    MDIO_MMD_VEND1, link_cfg->reg, val);
+		return false;
+	}
+
+	phydev_dbg(phydev, "%x:%.04x = %.04x\n", MDIO_MMD_VEND1, link_cfg->reg, val);
+	if (FIELD_GET(VEND1_GLOBAL_CFG_RATE_ADAPT, val) !=
+		VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE)
+		return false;
+
+	switch (FIELD_GET(VEND1_GLOBAL_CFG_SERDES_MODE, val)) {
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G:
+		return serdes_speed == SPEED_20000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI:
+		return serdes_speed == SPEED_10000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G:
+		return serdes_speed == SPEED_5000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII:
+		return serdes_speed == SPEED_2500;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_SGMII:
+		return serdes_speed == SPEED_1000;
+	default:
+		return false;
+	}
+}
+
 static int aqr107_get_rate_matching(struct phy_device *phydev,
 				    phy_interface_t iface)
 {
-	if (iface == PHY_INTERFACE_MODE_10GBASER ||
-	    iface == PHY_INTERFACE_MODE_2500BASEX ||
-	    iface == PHY_INTERFACE_MODE_NA)
-		return RATE_MATCH_PAUSE;
-	return RATE_MATCH_NONE;
+	static const struct aqr107_link_speed_cfg speed_table[] = {
+		{
+			.speed = SPEED_10,
+			.reg = VEND1_GLOBAL_CFG_10M,
+			.speed_bit = MDIO_PMA_SPEED_10,
+		},
+		{
+			.speed = SPEED_100,
+			.reg = VEND1_GLOBAL_CFG_100M,
+			.speed_bit = MDIO_PMA_SPEED_100,
+		},
+		{
+			.speed = SPEED_1000,
+			.reg = VEND1_GLOBAL_CFG_1G,
+			.speed_bit = MDIO_PMA_SPEED_1000,
+		},
+		{
+			.speed = SPEED_2500,
+			.reg = VEND1_GLOBAL_CFG_2_5G,
+			.speed_bit = MDIO_PMA_SPEED_2_5G,
+		},
+		{
+			.speed = SPEED_5000,
+			.reg = VEND1_GLOBAL_CFG_5G,
+			.speed_bit = MDIO_PMA_SPEED_5G,
+		},
+		{
+			.speed = SPEED_10000,
+			.reg = VEND1_GLOBAL_CFG_10G,
+			.speed_bit = MDIO_PMA_SPEED_10G,
+		},
+	};
+	int speed = phy_interface_max_speed(iface);
+	bool got_one = false;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(speed_table) &&
+		    speed_table[i].speed <= speed; i++) {
+		if (!aqr107_rate_adapt_ok(phydev, speed, &speed_table[i]))
+			return RATE_MATCH_NONE;
+		got_one = true;
+	}
+
+	/* Must match at least one speed */
+	return got_one ? RATE_MATCH_PAUSE : RATE_MATCH_NONE;
 }
 
 static int aqr107_suspend(struct phy_device *phydev)
@@ -713,10 +825,18 @@ static int aqr107_resume(struct phy_device *phydev)
 
 static int aqr107_probe(struct phy_device *phydev)
 {
-	phydev->priv = devm_kzalloc(&phydev->mdio.dev,
-				    sizeof(struct aqr107_priv), GFP_KERNEL);
-	if (!phydev->priv)
+	struct aqr107_priv *priv;
+
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
 		return -ENOMEM;
+	phydev->priv = priv;
+
+	priv->pmapmd_speeds = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_SPEED);
+	if (priv->pmapmd_speeds < 0) {
+		phydev_err(phydev, "could not read PMA/PMD speeds\n");
+		return priv->pmapmd_speeds;
+	};
 
 	return aqr_hwmon_probe(phydev);
 }
-- 
2.35.1.1320.gc452695387.dirty

