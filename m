Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088113E4CA1
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhHITEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:04:08 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:52065
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235939AbhHITEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 15:04:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kx8HEepS+/Vf7WuYgezSREUERvqAi+BJhAAEBYedWWxgm8mSHx2CzWMebbJcpDyp4yR+ZBRvNFmgpVGKn2X5UErVdZAF+t0pbJeTd2/SvSJ7zd9R00ZvJ/BD1H7YpFXwLsKcOmcmwKKfe+71fTt5dVE3u82is904rAxK/t6UQG6v+4NFl2FVXrkpludLRQsaEBiwu5WvMpfOmEDpbpsGgyNk5fftOssCe5habXtiz/oCO+hB8bHIsT8E2c74JDKdglwc79wOg76Z+ppZVS+ZTelSO1PfeVYGxmLdjoI4nr9SW8Ygn/vChANCr7V+Y6FLtrhyTCdKYpbmrD+RQL318Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iovXHmNfZ0AbBtR6RPBTV47hN6ypF7d0Gt2T3bEaY64=;
 b=H2io1tP1V5exH+r7E1VQYfTOQ9tSgRREGfY9YNeYwOnUqKIRaEDkqy5j4pvvphV6oE+JL5h8AH0NyMMK3jHZkCM5nIX/76tzyq06AO+qG2mNVPeC7Y3uW+YT02zBxP18YP4WGqY8FNC/olDj8LYx/Z3H4hD8bc9sosEjCtWpVKxzzVj79FcTBY1k380dzo7/XPdIUeFTjyXlRCOJ6aGwtc/faIgSJAybu+Ie+uRci6HQp6wX6g8JdROYLl6NBLW01lIoU5SfcPBNSvRSLwcGdFOUeoiIaAiVW2uXJeIehMwuHQuNbBdfDJEu0tMCtVfhrBlk7CgHdpoeKRnxmIc+tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iovXHmNfZ0AbBtR6RPBTV47hN6ypF7d0Gt2T3bEaY64=;
 b=O4s/8ULKa0nVoeT+gcsKaYV+qkaS3b4h9JA8vRMnevV1v4WyjzxdFG20RuxR3/ur2gTxfos8aSlenaXSg4ahh6WVpIJ3ekFRSE0Y0UP7ShNgR886LU6eEK7tCAJhzwWik13O3ppZzM44LjzJvBeeWU9TB1lKNacxhf/0Do2VyKM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Mon, 9 Aug
 2021 19:03:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 19:03:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH net-next 3/4] net: dsa: remove the "dsa_to_port in a loop" antipattern from drivers
Date:   Mon,  9 Aug 2021 22:03:19 +0300
Message-Id: <20210809190320.1058373-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0057.eurprd04.prod.outlook.com
 (2603:10a6:208:1::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0057.eurprd04.prod.outlook.com (2603:10a6:208:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 19:03:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01c989c3-2750-466b-4594-08d95b68676b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5501F739457DE3AA99FDC556E0F69@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+LlCwiHrBQxAAoL/bNe/UPYk17BdGfBzKIejgq0ACzXyl59YYBa7EmPeMxSX8UoOMJ/4KHDj+XuC7oS8CUvx9T27aW91lZd8nleNifd6zHpn9oVfYAIfbghNix48h9gQy3RGl/kWI7PmT9/owhb0sG+MF7NMoJclVkeHyIKsDO5CCnkOj4QVADUYPzuitYGus0UAln3+N4PB/LWvIxjmm4GCjlCzPJOWsvWcGF/fDbd6R2/807BhZsGH7zBfv/v2viTFg/MKDY264OMUqPqcJxjHerzI0hCAK+u3yGo2d6XUPXVwljBnMKK5dG10KrdHN4kZlWzQvuk10pbxNre6teL1iSZKhHHqIONk1hlqKjysRy1im2c6SmZyktWy+qmQ3bCc4Zx3jtYqIKAFv1Ls3d5KJqRnTrM8Aaf0ZFdlyDHPHGb0et75QWJN+5T9pJfCvTSeOracz/ZK+LJ4umo2lo1GvM8QfOeWLzbx7tSrkt2xhSIsfTDx3dtleBf0IN5Ri4qBuJ1MU1LTwo72zYkK96fgrxFpQ42IpTBXaAR8UjjR0ijSFDk92qRYHtvxXCcgO3FIKSXRB9QX38t/ewwRapB6K6H2DySPwIjI0PASoVB407mE5/B9Yjk6PftcQE1o52k3g2Z8gFhgrcTGzRzVsCXM+94LejDelNa5/Z6MdhZXHs3tJ2oMo5b1ed5CEnT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(366004)(396003)(376002)(5660300002)(66946007)(66476007)(66556008)(7416002)(4326008)(6506007)(44832011)(54906003)(52116002)(6512007)(6486002)(38100700002)(2616005)(1076003)(956004)(110136005)(30864003)(6666004)(38350700002)(86362001)(186003)(36756003)(8676002)(83380400001)(8936002)(478600001)(26005)(2906002)(316002)(559001)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CMy+YJVV89KTFMBvnhOk6RVfKVHQLUBjdFnojhW2c/Ngdo9abZ90CvoACN8K?=
 =?us-ascii?Q?AHIbGqKaBVl0sTLN+n3xA3GHroMUPPSx+qa2+HG+8jzbzmpDh9Q5w1vqrIFh?=
 =?us-ascii?Q?PAj8YU9SdM5d+bsTlo1NDx319oQUOwWpZLLEKgG6tM1+A4Gf5up/1AAfLB4S?=
 =?us-ascii?Q?JALkBp7Hqv662n7kZV8aE3NEzq2hkECJt9RA+PgTW1v3qBAdcnC0DiKxF1FU?=
 =?us-ascii?Q?rAsqHHi0LbnbiRIJehGBNLgjR3/GGIe6H3Xi0JG7rl4W06fQLHfFrOn0sL4d?=
 =?us-ascii?Q?j2ACN5JcXvz2aHFFNSzDcSdtkyEha1fouzR8L+s0DMHxA8+Tj3QAxoetrvhE?=
 =?us-ascii?Q?bNzQ/ixTkra7poOJKTjZ2lt4b7R4qbO6i/RZnElwsT83lWw221GmGhnBClbn?=
 =?us-ascii?Q?6kWmKoNCUQBJtTQHGp317M5efcDLRnQXab+X33q/NLaBPY3BRSOxPuHc6E+w?=
 =?us-ascii?Q?NKw8J2LCE759F105nPrjdQBSk7RwkahsB6a5GztBFZvpRJbWzua4HNGpI1gn?=
 =?us-ascii?Q?E8S2QLRMH9bKqEWc7xSS5RIjgG8SfMYYgg+Xz8A9gahbZI9ySPWkA4JT7bPR?=
 =?us-ascii?Q?czLkNnbv9OhHqjNL4XrSP7Iyy+q3XByLuozMkFa5ioZdavPQAyfl0Cjjvlzy?=
 =?us-ascii?Q?6NbZsRWEqLYIFXF114yKDNVGNKFvRMDLzcVmuQELlCBhMhi4GOgN72kWUIWX?=
 =?us-ascii?Q?C8GFBnmK20KcIMKaFm2iuY2YRBsgiYduFgze3IyWxAWHrnR9RrmWNRJ3KabF?=
 =?us-ascii?Q?ZqUmHU+1GimwiUvdIdruNY+JWyfy3GdHEKhhcdo1ebHBN4Xa9e3CkrLlYeAP?=
 =?us-ascii?Q?OZxJaxGzuhb1PhfSDq2E6UZ0zW9QhuCBwEaKpZso+dfaCVpjVPn4+kQIjd2f?=
 =?us-ascii?Q?gYCeBC2oMQUg2HNZONt7h1HprxzA0FyHRPLTN5fdhDBK7yneyU/lj6sO9CG8?=
 =?us-ascii?Q?QP/q1XOvbPme8TIO3t0Oeg+fg429b4w4klwY/24Y4mqujPi+RjZpIHePcfqp?=
 =?us-ascii?Q?Cj4bEGnp1pkrYPVhSUlgiOrSX8kReidgZO5CsIDqK8kk8nKwtJ4kMYtLxXu6?=
 =?us-ascii?Q?iQ4Tkp8SakCFnSqZ2TZXteMWWmGqP/JJNnr1gYRayf6BpHJbIKJd/XVjioan?=
 =?us-ascii?Q?eDmqaTzq3XHTnlmeWx0bYBYgTEFl+E03U40B5AnijDPf1A8nyBBf8zJ6wG98?=
 =?us-ascii?Q?FapST4uNtWdjysc9WpwtWVoztGs8JLI/7WGeYgbvmUE6FyPiR6Sld9evRzij?=
 =?us-ascii?Q?dW264Sz0mAYVOPbJnHthkIb44Tnqn1iDRmxC4aQaG+GE9TWpeOhPIxt0VQIx?=
 =?us-ascii?Q?0KBxNfgtnbzXhOgrL/BhF9pj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c989c3-2750-466b-4594-08d95b68676b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 19:03:42.2084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZr9K9ZMvnn+wOw97xB16FOmvw7Pdz2KyP2+Yi2aebxeZS//u0vVcXXjfWqPKLJWieBwGttgmlrA9Kb2Lsl3sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the DSA conversion from the ds->ports array into the dst->ports
list, the DSA API has encouraged driver writers to write inefficient
code.

Currently, switch drivers which want to filter by a specific type of
port when iterating, like {!unused, user, cpu, dsa}, use the
dsa_is_*_port helper. Under the hood, this uses dsa_to_port which
iterates again through dst->ports. But the driver iterates through the
port list already, so the complexity is quadratic for the typical case
of a single-switch tree.

Many drivers also call dsa_to_port many times while iterating and do not
even cache the result, probably unaware of the hidden complexity of this
function.

When drivers need to iterate between pairs of {to, from} ports, and use
any of the functions above, the complexity is even higher.

Use the newly introduced DSA port iterators, and also introduce some
more which are not directly needed by the DSA core.

Note that the b53_br_{join,leave} functions have been converted to use
the dp-based iterators, but to preserve the original behavior, the
dev->enabled_ports check from b53_for_each_port has been split out and
open-coded. This will be addressed in the next patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c              |  22 ++-
 drivers/net/dsa/bcm_sf2.c                     |   8 +-
 drivers/net/dsa/hirschmann/hellcreek.c        |  27 +--
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   |  19 +-
 drivers/net/dsa/microchip/ksz9477.c           |  19 +-
 drivers/net/dsa/microchip/ksz_common.c        |  19 +-
 drivers/net/dsa/mt7530.c                      |  58 +++---
 drivers/net/dsa/mv88e6xxx/chip.c              |  37 ++--
 drivers/net/dsa/mv88e6xxx/hwtstamp.c          |  10 +-
 drivers/net/dsa/mv88e6xxx/port.c              |  12 +-
 drivers/net/dsa/ocelot/felix.c                |  79 +++-----
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  10 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c      |  14 +-
 drivers/net/dsa/qca8k.c                       |  32 ++--
 drivers/net/dsa/sja1105/sja1105_main.c        | 176 ++++++++----------
 drivers/net/dsa/sja1105/sja1105_mdio.c        |  12 +-
 drivers/net/dsa/xrs700x/xrs700x.c             |  37 ++--
 include/net/dsa.h                             |  19 ++
 18 files changed, 284 insertions(+), 326 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index bd1417a66cbf..ccd93147d994 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1851,6 +1851,7 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct b53_device *dev = ds->priv;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
+	struct dsa_port *dp;
 	u16 pvlan, reg;
 	unsigned int i;
 
@@ -1873,8 +1874,13 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 
 	b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), &pvlan);
 
-	b53_for_each_port(dev, i) {
-		if (dsa_to_port(ds, i)->bridge_dev != br)
+	dsa_switch_for_each_port(dp, ds) {
+		i = dp->index;
+
+		if (!(dev->enabled_ports & BIT(i)))
+			continue;
+
+		if (dp->bridge_dev != br)
 			continue;
 
 		/* Add this local port to the remote port VLAN control
@@ -1903,14 +1909,20 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 	struct b53_device *dev = ds->priv;
 	struct b53_vlan *vl = &dev->vlans[0];
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
-	unsigned int i;
 	u16 pvlan, reg, pvid;
+	struct dsa_port *dp;
+	unsigned int i;
 
 	b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), &pvlan);
 
-	b53_for_each_port(dev, i) {
+	dsa_switch_for_each_port(dp, ds) {
+		i = dp->index;
+
+		if (!(dev->enabled_ports & BIT(i)))
+			continue;
+
 		/* Don't touch the remaining ports */
-		if (dsa_to_port(ds, i)->bridge_dev != br)
+		if (dp->bridge_dev != br)
 			continue;
 
 		b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(i), &reg);
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 6ce9ec1283e0..2f78fb88ed9e 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -913,7 +913,7 @@ static void bcm_sf2_enable_acb(struct dsa_switch *ds)
 static int bcm_sf2_sw_suspend(struct dsa_switch *ds)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
-	unsigned int port;
+	struct dsa_port *dp;
 
 	bcm_sf2_intr_disable(priv);
 
@@ -921,10 +921,8 @@ static int bcm_sf2_sw_suspend(struct dsa_switch *ds)
 	 * port, the other ones have already been disabled during
 	 * bcm_sf2_sw_setup
 	 */
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_user_port(ds, port) || dsa_is_cpu_port(ds, port))
-			bcm_sf2_port_disable(ds, port);
-	}
+	dsa_switch_for_each_available_port(dp, ds)
+		bcm_sf2_port_disable(ds, dp->index);
 
 	if (!priv->wol_ports_mask)
 		clk_disable_unprepare(priv->clk);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 9fdcc4bde480..c457b521942d 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -345,7 +345,7 @@ static int hellcreek_vlan_prepare(struct dsa_switch *ds, int port,
 				  struct netlink_ext_ack *extack)
 {
 	struct hellcreek *hellcreek = ds->priv;
-	int i;
+	struct dsa_port *dp;
 
 	dev_dbg(hellcreek->dev, "VLAN prepare for port %d\n", port);
 
@@ -353,11 +353,8 @@ static int hellcreek_vlan_prepare(struct dsa_switch *ds, int port,
 	 * VLANs are internally used by the driver to ensure port
 	 * separation. Thus, they cannot be used by someone else.
 	 */
-	for (i = 0; i < hellcreek->pdata->num_ports; ++i) {
-		const u16 restricted_vid = hellcreek_private_vid(i);
-
-		if (!dsa_is_user_port(ds, i))
-			continue;
+	dsa_switch_for_each_user_port(dp, ds) {
+		const u16 restricted_vid = hellcreek_private_vid(dp->index);
 
 		if (vlan->vid == restricted_vid) {
 			NL_SET_ERR_MSG_MOD(extack, "VID restricted by driver");
@@ -1301,8 +1298,9 @@ static void hellcreek_teardown_devlink_regions(struct dsa_switch *ds)
 static int hellcreek_setup(struct dsa_switch *ds)
 {
 	struct hellcreek *hellcreek = ds->priv;
+	struct dsa_port *dp;
 	u16 swcfg = 0;
-	int ret, i;
+	int ret;
 
 	dev_dbg(hellcreek->dev, "Set up the switch\n");
 
@@ -1328,12 +1326,8 @@ static int hellcreek_setup(struct dsa_switch *ds)
 	hellcreek_write(hellcreek, swcfg, HR_SWCFG);
 
 	/* Initial vlan membership to reflect port separation */
-	for (i = 0; i < ds->num_ports; ++i) {
-		if (!dsa_is_user_port(ds, i))
-			continue;
-
-		hellcreek_setup_vlan_membership(ds, i, true);
-	}
+	dsa_switch_for_each_user_port(dp, ds)
+		hellcreek_setup_vlan_membership(ds, dp->index, true);
 
 	/* Configure PCP <-> TC mapping */
 	hellcreek_setup_tc_identity_mapping(hellcreek);
@@ -1410,10 +1404,10 @@ hellcreek_port_prechangeupper(struct dsa_switch *ds, int port,
 			      struct netdev_notifier_changeupper_info *info)
 {
 	struct hellcreek *hellcreek = ds->priv;
+	struct dsa_port *dp;
 	bool used = true;
 	int ret = -EBUSY;
 	u16 vid;
-	int i;
 
 	dev_dbg(hellcreek->dev, "Pre change upper for port %d\n", port);
 
@@ -1432,9 +1426,8 @@ hellcreek_port_prechangeupper(struct dsa_switch *ds, int port,
 
 	/* For all ports, check bitmaps */
 	mutex_lock(&hellcreek->vlan_lock);
-	for (i = 0; i < hellcreek->pdata->num_ports; ++i) {
-		if (!dsa_is_user_port(ds, i))
-			continue;
+	dsa_switch_for_each_user_port(dp, ds) {
+		int i = dp->index;
 
 		if (port == i)
 			continue;
diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
index 40b41c794dfa..1cbae1654dfe 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
@@ -354,13 +354,12 @@ long hellcreek_hwtstamp_work(struct ptp_clock_info *ptp)
 {
 	struct hellcreek *hellcreek = ptp_to_hellcreek(ptp);
 	struct dsa_switch *ds = hellcreek->ds;
-	int i, restart = 0;
+	struct dsa_port *dp;
+	int restart = 0;
 
-	for (i = 0; i < ds->num_ports; i++) {
+	dsa_switch_for_each_user_port(dp, ds) {
 		struct hellcreek_port_hwtstamp *ps;
-
-		if (!dsa_is_user_port(ds, i))
-			continue;
+		int i = dp->index;
 
 		ps = &hellcreek->ports[i].port_hwtstamp;
 
@@ -459,15 +458,11 @@ static void hellcreek_hwtstamp_port_setup(struct hellcreek *hellcreek, int port)
 int hellcreek_hwtstamp_setup(struct hellcreek *hellcreek)
 {
 	struct dsa_switch *ds = hellcreek->ds;
-	int i;
+	struct dsa_port *dp;
 
 	/* Initialize timestamping ports. */
-	for (i = 0; i < ds->num_ports; ++i) {
-		if (!dsa_is_user_port(ds, i))
-			continue;
-
-		hellcreek_hwtstamp_port_setup(hellcreek, i);
-	}
+	dsa_switch_for_each_user_port(dp, ds)
+		hellcreek_hwtstamp_port_setup(hellcreek, dp->index);
 
 	/* Select the synchronized clock as the source timekeeper for the
 	 * timestamps and enable inline timestamping.
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 854e25f43fa7..a7435c581e49 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1266,11 +1266,14 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	struct dsa_port *dp;
 	struct ksz_port *p;
 	int i;
 
-	for (i = 0; i < dev->port_cnt; i++) {
-		if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 << i))) {
+	dsa_switch_for_each_port(dp, ds) {
+		i = dp->index;
+
+		if (dsa_port_is_cpu(dp) && (dev->cpu_ports & (1 << i))) {
 			phy_interface_t interface;
 			const char *prev_msg;
 			const char *prev_mode;
@@ -1609,18 +1612,22 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 
 int ksz9477_switch_register(struct ksz_device *dev)
 {
-	int ret, i;
 	struct phy_device *phydev;
+	struct dsa_switch *ds;
+	struct dsa_port *dp;
+	int ret;
 
 	ret = ksz_switch_register(dev, &ksz9477_dev_ops);
 	if (ret)
 		return ret;
 
-	for (i = 0; i < dev->phy_port_cnt; ++i) {
-		if (!dsa_is_user_port(dev->ds, i))
+	ds = dev->ds;
+
+	dsa_switch_for_each_user_port(dp, ds) {
+		if (dp->index >= dev->phy_port_cnt)
 			continue;
 
-		phydev = dsa_to_port(dev->ds, i)->slave->phydev;
+		phydev = dp->slave->phydev;
 
 		/* The MAC actually cannot run in 1000 half-duplex mode. */
 		phy_remove_link_mode(phydev,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 1542bfb8b5e5..2b188f998115 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -68,28 +68,23 @@ static void ksz_mib_read_work(struct work_struct *work)
 {
 	struct ksz_device *dev = container_of(work, struct ksz_device,
 					      mib_read.work);
+	struct dsa_switch *ds = dev->ds;
 	struct ksz_port_mib *mib;
+	struct dsa_port *dp;
 	struct ksz_port *p;
-	int i;
-
-	for (i = 0; i < dev->port_cnt; i++) {
-		if (dsa_is_unused_port(dev->ds, i))
-			continue;
 
-		p = &dev->ports[i];
+	dsa_switch_for_each_available_port(dp, ds) {
+		p = &dev->ports[dp->index];
 		mib = &p->mib;
 		mutex_lock(&mib->cnt_mutex);
 
 		/* Only read MIB counters when the port is told to do.
 		 * If not, read only dropped counters when link is not up.
 		 */
-		if (!p->read) {
-			const struct dsa_port *dp = dsa_to_port(dev->ds, i);
+		if (!p->read && !netif_carrier_ok(dp->slave))
+			mib->cnt_ptr = dev->reg_mib_cnt;
 
-			if (!netif_carrier_ok(dp->slave))
-				mib->cnt_ptr = dev->reg_mib_cnt;
-		}
-		port_r_cnt(dev, i);
+		port_r_cnt(dev, dp->index);
 		p->read = false;
 		mutex_unlock(&mib->cnt_mutex);
 	}
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 53e6150e95b6..010d4bb7794f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1195,25 +1195,27 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
-	int i;
+	struct dsa_port *dp;
 
 	mutex_lock(&priv->reg_mutex);
 
-	for (i = 0; i < MT7530_NUM_PORTS; i++) {
+	dsa_switch_for_each_user_port(dp, ds) {
+		if (dp->index == port)
+			continue;
+
+		if (dp->bridge_dev != bridge)
+			continue;
+
 		/* Add this port to the port matrix of the other ports in the
 		 * same bridge. If the port is disabled, port matrix is kept
 		 * and not being setup until the port becomes enabled.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port) {
-			if (dsa_to_port(ds, i)->bridge_dev != bridge)
-				continue;
-			if (priv->ports[i].enable)
-				mt7530_set(priv, MT7530_PCR_P(i),
-					   PCR_MATRIX(BIT(port)));
-			priv->ports[i].pm |= PCR_MATRIX(BIT(port));
+		if (priv->ports[dp->index].enable)
+			mt7530_set(priv, MT7530_PCR_P(dp->index),
+				   PCR_MATRIX(BIT(port)));
+		priv->ports[dp->index].pm |= PCR_MATRIX(BIT(port));
 
-			port_bitmap |= BIT(i);
-		}
+		port_bitmap |= BIT(dp->index);
 	}
 
 	/* Add the all other ports to this port matrix. */
@@ -1236,7 +1238,7 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
 	bool all_user_ports_removed = true;
-	int i;
+	struct dsa_port *dp;
 
 	/* This is called after .port_bridge_leave when leaving a VLAN-aware
 	 * bridge. Don't set standalone ports to fallback mode.
@@ -1255,9 +1257,8 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 	mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
 		   G0_PORT_VID_DEF);
 
-	for (i = 0; i < MT7530_NUM_PORTS; i++) {
-		if (dsa_is_user_port(ds, i) &&
-		    dsa_port_is_vlan_filtering(dsa_to_port(ds, i))) {
+	dsa_switch_for_each_user_port(dp, ds) {
+		if (dsa_port_is_vlan_filtering(dp)) {
 			all_user_ports_removed = false;
 			break;
 		}
@@ -1307,26 +1308,31 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 			 struct net_device *bridge)
 {
 	struct mt7530_priv *priv = ds->priv;
-	int i;
+	struct dsa_port *dp;
 
 	mutex_lock(&priv->reg_mutex);
 
-	for (i = 0; i < MT7530_NUM_PORTS; i++) {
+	dsa_switch_for_each_user_port(dp, ds) {
 		/* Remove this port from the port matrix of the other ports
 		 * in the same bridge. If the port is disabled, port matrix
 		 * is kept and not being setup until the port becomes enabled.
 		 * And the other port's port matrix cannot be broken when the
 		 * other port is still a VLAN-aware port.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port &&
-		   !dsa_port_is_vlan_filtering(dsa_to_port(ds, i))) {
-			if (dsa_to_port(ds, i)->bridge_dev != bridge)
-				continue;
-			if (priv->ports[i].enable)
-				mt7530_clear(priv, MT7530_PCR_P(i),
-					     PCR_MATRIX(BIT(port)));
-			priv->ports[i].pm &= ~PCR_MATRIX(BIT(port));
-		}
+		if (dp->index == port)
+			continue;
+
+		if (dsa_port_is_vlan_filtering(dp))
+			continue;
+
+		if (dp->bridge_dev != bridge)
+			continue;
+
+		if (priv->ports[dp->index].enable)
+			mt7530_clear(priv, MT7530_PCR_P(dp->index),
+				     PCR_MATRIX(BIT(port)));
+
+		priv->ports[dp->index].pm &= ~PCR_MATRIX(BIT(port));
 	}
 
 	/* Set the cpu port to be the only one in the port matrix of
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c45ca2473743..1525415aca46 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1635,9 +1635,11 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 					u16 vid)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_vtu_entry vlan;
-	int i, err;
+	struct dsa_port *other_dp;
+	int err;
 
 	/* DSA and CPU ports have to be members of multiple vlans */
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
@@ -1650,27 +1652,20 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	if (!vlan.valid)
 		return 0;
 
-	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
-		if (dsa_is_dsa_port(ds, i) || dsa_is_cpu_port(ds, i))
-			continue;
-
-		if (!dsa_to_port(ds, i)->slave)
-			continue;
-
-		if (vlan.member[i] ==
+	dsa_switch_for_each_user_port(other_dp, ds) {
+		if (vlan.member[other_dp->index] ==
 		    MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER)
 			continue;
 
-		if (dsa_to_port(ds, i)->bridge_dev ==
-		    dsa_to_port(ds, port)->bridge_dev)
+		if (other_dp->bridge_dev == dp->bridge_dev)
 			break; /* same bridge, check next VLAN */
 
-		if (!dsa_to_port(ds, i)->bridge_dev)
+		if (!other_dp->bridge_dev)
 			continue;
 
 		dev_err(ds->dev, "p%d: hw VLAN %d already used by port %d in %s\n",
-			port, vlan.vid, i,
-			netdev_name(dsa_to_port(ds, i)->bridge_dev));
+			port, vlan.vid, other_dp->index,
+			netdev_name(other_dp->bridge_dev));
 		return -EOPNOTSUPP;
 	}
 
@@ -1996,16 +1991,14 @@ static int mv88e6xxx_port_add_broadcast(struct mv88e6xxx_chip *chip, int port,
 
 static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
 {
+	struct dsa_switch *ds = chip->ds;
+	struct dsa_port *dp;
 	int port;
 	int err;
 
-	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
-		struct dsa_port *dp = dsa_to_port(chip->ds, port);
+	dsa_switch_for_each_available_port(dp, ds) {
 		struct net_device *brport;
 
-		if (dsa_is_unused_port(chip->ds, port))
-			continue;
-
 		brport = dsa_port_to_bridge_port(dp);
 		if (brport && !br_port_flag_is_set(brport, BR_BCAST_FLOOD))
 			/* Skip bridged user ports where broadcast
@@ -3077,6 +3070,7 @@ static void mv88e6xxx_teardown(struct dsa_switch *ds)
 static int mv88e6xxx_setup(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	struct dsa_port *dp;
 	u8 cmode;
 	int err;
 	int i;
@@ -3113,9 +3107,8 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	}
 
 	/* Setup Switch Port Registers */
-	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
-		if (dsa_is_unused_port(ds, i))
-			continue;
+	dsa_switch_for_each_available_port(dp, ds) {
+		i = dp->index;
 
 		/* Prevent the use of an invalid port. */
 		if (mv88e6xxx_is_invalid_port(chip, i)) {
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
index 8f74ffc7a279..73153249b4c0 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
@@ -452,13 +452,11 @@ long mv88e6xxx_hwtstamp_work(struct ptp_clock_info *ptp)
 	struct mv88e6xxx_chip *chip = ptp_to_chip(ptp);
 	struct dsa_switch *ds = chip->ds;
 	struct mv88e6xxx_port_hwtstamp *ps;
-	int i, restart = 0;
+	struct dsa_port *dp;
+	int restart = 0;
 
-	for (i = 0; i < ds->num_ports; i++) {
-		if (!dsa_is_user_port(ds, i))
-			continue;
-
-		ps = &chip->port_hwtstamp[i];
+	dsa_switch_for_each_user_port(dp, ds) {
+		ps = &chip->port_hwtstamp[dp->index];
 		if (test_bit(MV88E6XXX_HWTSTAMP_TX_IN_PROGRESS, &ps->state))
 			restart |= mv88e6xxx_txtstamp_work(chip, ps);
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index f77e2ee64a60..2c300ab70002 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1381,13 +1381,13 @@ static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, int port,
 static int mv88e6393x_port_policy_write_all(struct mv88e6xxx_chip *chip,
 					    u16 pointer, u8 data)
 {
-	int err, port;
-
-	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
-		if (dsa_is_unused_port(chip->ds, port))
-			continue;
+	struct dsa_switch *ds = chip->ds;
+	struct dsa_port *dp;
+	int err;
 
-		err = mv88e6393x_port_policy_write(chip, port, pointer, data);
+	dsa_switch_for_each_available_port(dp, ds) {
+		err = mv88e6393x_port_policy_write(chip, dp->index, pointer,
+						   data);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9505f9b3ac90..f4bd43545f04 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -266,12 +266,12 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
  */
 static int felix_setup_mmio_filtering(struct felix *felix)
 {
-	unsigned long user_ports = 0, cpu_ports = 0;
+	unsigned long user_ports = dsa_user_ports(felix->ds);
+	unsigned long cpu_ports = dsa_cpu_ports(felix->ds);
 	struct ocelot_vcap_filter *redirect_rule;
 	struct ocelot_vcap_filter *tagging_rule;
 	struct ocelot *ocelot = &felix->ocelot;
-	struct dsa_switch *ds = felix->ds;
-	int port, ret;
+	int ret;
 
 	tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
 	if (!tagging_rule)
@@ -283,13 +283,6 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 		return -ENOMEM;
 	}
 
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (dsa_is_user_port(ds, port))
-			user_ports |= BIT(port);
-		if (dsa_is_cpu_port(ds, port))
-			cpu_ports |= BIT(port);
-	}
-
 	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
 	*(__be16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
 	*(__be16 *)tagging_rule->key.etype.etype.mask = htons(0xffff);
@@ -388,14 +381,12 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 	unsigned long cpu_flood;
-	int port, err;
+	struct dsa_port *dp;
+	int err;
 
 	felix_8021q_cpu_port_init(ocelot, cpu);
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
+	dsa_switch_for_each_available_port(dp, ds) {
 		/* This overwrites ocelot_init():
 		 * Do not forward BPDU frames to the CPU port module,
 		 * for 2 reasons:
@@ -408,7 +399,7 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 		 */
 		ocelot_write_gix(ocelot,
 				 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0),
-				 ANA_PORT_CPU_FWD_BPDU_CFG, port);
+				 ANA_PORT_CPU_FWD_BPDU_CFG, dp->index);
 	}
 
 	/* In tag_8021q mode, the CPU port module is unused, except for PTP
@@ -439,7 +430,8 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	int err, port;
+	struct dsa_port *dp;
+	int err;
 
 	err = felix_teardown_mmio_filtering(felix);
 	if (err)
@@ -448,17 +440,14 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
 
 	dsa_tag_8021q_unregister(ds);
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
+	dsa_switch_for_each_available_port(dp, ds) {
 		/* Restore the logic from ocelot_init:
 		 * do not forward BPDU frames to the front ports.
 		 */
 		ocelot_write_gix(ocelot,
 				 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0xffff),
 				 ANA_PORT_CPU_FWD_BPDU_CFG,
-				 port);
+				 dp->index);
 	}
 
 	felix_8021q_cpu_port_deinit(ocelot, cpu);
@@ -1178,7 +1167,8 @@ static int felix_setup(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	int port, err;
+	struct dsa_port *dp;
+	int err;
 
 	err = felix_init_structs(felix, ds->num_ports);
 	if (err)
@@ -1197,31 +1187,24 @@ static int felix_setup(struct dsa_switch *ds)
 		}
 	}
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
-		ocelot_init_port(ocelot, port);
+	dsa_switch_for_each_available_port(dp, ds) {
+		ocelot_init_port(ocelot, dp->index);
 
 		/* Set the default QoS Classification based on PCP and DEI
 		 * bits of vlan tag.
 		 */
-		felix_port_qos_map_init(ocelot, port);
+		felix_port_qos_map_init(ocelot, dp->index);
 	}
 
 	err = ocelot_devlink_sb_register(ocelot);
 	if (err)
 		goto out_deinit_ports;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!dsa_is_cpu_port(ds, port))
-			continue;
-
+	dsa_switch_for_each_cpu_port(dp, ds)
 		/* The initial tag protocol is NPI which always returns 0, so
 		 * there's no real point in checking for errors.
 		 */
-		felix_set_tag_protocol(ds, port, felix->tag_proto);
-	}
+		felix_set_tag_protocol(ds, dp->index, felix->tag_proto);
 
 	ds->mtu_enforcement_ingress = true;
 	ds->assisted_learning_on_cpu_port = true;
@@ -1229,12 +1212,8 @@ static int felix_setup(struct dsa_switch *ds)
 	return 0;
 
 out_deinit_ports:
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
-		ocelot_deinit_port(ocelot, port);
-	}
+	dsa_switch_for_each_available_port(dp, ds)
+		ocelot_deinit_port(ocelot, dp->index);
 
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
@@ -1250,25 +1229,17 @@ static void felix_teardown(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	int port;
-
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!dsa_is_cpu_port(ds, port))
-			continue;
+	struct dsa_port *dp;
 
-		felix_del_tag_protocol(ds, port, felix->tag_proto);
-	}
+	dsa_switch_for_each_cpu_port(dp, ds)
+		felix_del_tag_protocol(ds, dp->index, felix->tag_proto);
 
 	ocelot_devlink_sb_unregister(ocelot);
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
 
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
-		ocelot_deinit_port(ocelot, port);
-	}
+	dsa_switch_for_each_available_port(dp, ds)
+		ocelot_deinit_port(ocelot, dp->index);
 
 	if (felix->info->mdio_bus_free)
 		felix->info->mdio_bus_free(ocelot);
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index f966a253d1c7..5b61da586102 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1034,12 +1034,14 @@ static const struct ocelot_ops vsc9959_ops = {
 static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
 	struct enetc_mdio_priv *mdio_priv;
 	struct device *dev = ocelot->dev;
 	void __iomem *imdio_regs;
 	struct resource res;
 	struct enetc_hw *hw;
 	struct mii_bus *bus;
+	struct dsa_port *dp;
 	int port;
 	int rc;
 
@@ -1091,13 +1093,11 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 
 	felix->imdio = bus;
 
-	for (port = 0; port < felix->info->num_ports; port++) {
-		struct ocelot_port *ocelot_port = ocelot->ports[port];
+	dsa_switch_for_each_available_port(dp, ds) {
+		struct ocelot_port *ocelot_port = ocelot->ports[dp->index];
 		struct mdio_device *pcs;
 		struct lynx_pcs *lynx;
-
-		if (dsa_is_unused_port(felix->ds, port))
-			continue;
+		int port = dp->index;
 
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index deae923c8b7a..fe7828c402bd 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1085,9 +1085,10 @@ static const struct ocelot_ops vsc9953_ops = {
 static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
 	struct device *dev = ocelot->dev;
+	struct dsa_port *dp;
 	struct mii_bus *bus;
-	int port;
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
@@ -1118,15 +1119,12 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 
 	felix->imdio = bus;
 
-	for (port = 0; port < felix->info->num_ports; port++) {
-		struct ocelot_port *ocelot_port = ocelot->ports[port];
-		int addr = port + 4;
+	dsa_switch_for_each_available_port(dp, ds) {
+		struct ocelot_port *ocelot_port = ocelot->ports[dp->index];
+		int addr = dp->index + 4;
 		struct mdio_device *pcs;
 		struct lynx_pcs *lynx;
 
-		if (dsa_is_unused_port(felix->ds, port))
-			continue;
-
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
@@ -1140,7 +1138,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 			continue;
 		}
 
-		felix->pcs[port] = lynx;
+		felix->pcs[dp->index] = lynx;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", addr);
 	}
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1f63f50f73f1..f2c1369c2bff 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -940,6 +940,7 @@ static int
 qca8k_setup(struct dsa_switch *ds)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	struct dsa_port *dp;
 	int ret, i;
 	u32 mask;
 
@@ -1009,9 +1010,11 @@ qca8k_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Setup connection between CPU port & user ports */
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+	dsa_switch_for_each_port(dp, ds) {
+		i = dp->index;
+
 		/* CPU port gets connected to all user ports of the switch */
-		if (dsa_is_cpu_port(ds, i)) {
+		if (dsa_port_is_cpu(dp)) {
 			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
 					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 			if (ret)
@@ -1019,7 +1022,7 @@ qca8k_setup(struct dsa_switch *ds)
 		}
 
 		/* Individual user ports get connected to CPU port only */
-		if (dsa_is_user_port(ds, i)) {
+		if (dsa_port_is_user(dp)) {
 			int shift = 16 * (i % 2);
 
 			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
@@ -1509,21 +1512,23 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask = BIT(QCA8K_CPU_PORT);
-	int i, ret;
+	struct dsa_port *dp;
+	int ret;
 
-	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
-		if (dsa_to_port(ds, i)->bridge_dev != br)
+	dsa_switch_for_each_port(dp, ds) {
+		if (dp->bridge_dev != br)
 			continue;
+
 		/* Add this port to the portvlan mask of the other ports
 		 * in the bridge
 		 */
 		ret = qca8k_reg_set(priv,
-				    QCA8K_PORT_LOOKUP_CTRL(i),
+				    QCA8K_PORT_LOOKUP_CTRL(dp->index),
 				    BIT(port));
 		if (ret)
 			return ret;
-		if (i != port)
-			port_mask |= BIT(i);
+		if (dp->index != port)
+			port_mask |= BIT(dp->index);
 	}
 
 	/* Add all other ports to this ports portvlan mask */
@@ -1537,16 +1542,17 @@ static void
 qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int i;
+	struct dsa_port *dp;
 
-	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
-		if (dsa_to_port(ds, i)->bridge_dev != br)
+	dsa_switch_for_each_port(dp, ds) {
+		if (dp->bridge_dev != br)
 			continue;
+
 		/* Remove this port to the portvlan mask of the other ports
 		 * in the bridge
 		 */
 		qca8k_reg_clear(priv,
-				QCA8K_PORT_LOOKUP_CTRL(i),
+				QCA8K_PORT_LOOKUP_CTRL(dp->index),
 				BIT(port));
 	}
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2bb35da0af12..42d6ab656afd 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -207,10 +207,7 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 
 	mac = table->entries;
 
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (dp->ds != ds)
-			continue;
-
+	dsa_switch_for_each_available_port(dp, ds) {
 		mac[dp->index] = default_mac;
 
 		/* Let sja1105_bridge_stp_state_set() keep address learning
@@ -239,7 +236,7 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv)
 	struct sja1105_xmii_params_entry *mii;
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-	int i;
+	struct dsa_port *dp;
 
 	table = &priv->static_config.tables[BLK_IDX_XMII_PARAMS];
 
@@ -259,11 +256,9 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv)
 
 	mii = table->entries;
 
-	for (i = 0; i < ds->num_ports; i++) {
+	dsa_switch_for_each_available_port(dp, ds) {
 		sja1105_mii_role_t role = XMII_MAC;
-
-		if (dsa_is_unused_port(priv->ds, i))
-			continue;
+		int i = dp->index;
 
 		switch (priv->phy_mode[i]) {
 		case PHY_INTERFACE_MODE_INTERNAL:
@@ -331,8 +326,9 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv)
 static int sja1105_init_static_fdb(struct sja1105_private *priv)
 {
 	struct sja1105_l2_lookup_entry *l2_lookup;
+	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-	int port;
+	struct dsa_port *dp;
 
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP];
 
@@ -363,9 +359,8 @@ static int sja1105_init_static_fdb(struct sja1105_private *priv)
 	l2_lookup[0].index = SJA1105_MAX_L2_LOOKUP_COUNT - 1;
 
 	/* Flood multicast to every port by default */
-	for (port = 0; port < priv->ds->num_ports; port++)
-		if (!dsa_is_unused_port(priv->ds, port))
-			l2_lookup[0].destports |= BIT(port);
+	dsa_switch_for_each_available_port(dp, ds)
+		l2_lookup[0].destports |= BIT(dp->index);
 
 	return 0;
 }
@@ -405,20 +400,16 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 	struct dsa_switch *ds = priv->ds;
 	int port, num_used_ports = 0;
 	struct sja1105_table *table;
+	struct dsa_port *dp;
 	u64 max_fdb_entries;
 
-	for (port = 0; port < ds->num_ports; port++)
-		if (!dsa_is_unused_port(ds, port))
-			num_used_ports++;
+	dsa_switch_for_each_available_port(dp, ds)
+		num_used_ports++;
 
 	max_fdb_entries = SJA1105_MAX_L2_LOOKUP_COUNT / num_used_ports;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
+	dsa_switch_for_each_available_port(dp, ds)
 		default_l2_lookup_params.maxaddrp[port] = max_fdb_entries;
-	}
 
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
 
@@ -461,7 +452,7 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 		.vlanid = SJA1105_DEFAULT_VLAN,
 	};
 	struct dsa_switch *ds = priv->ds;
-	int port;
+	struct dsa_port *dp;
 
 	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
 
@@ -477,15 +468,14 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 
 	table->entry_count = 1;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
+	dsa_switch_for_each_available_port(dp, ds) {
+		int port = dp->index;
 
 		pvid.vmemb_port |= BIT(port);
 		pvid.vlan_bc |= BIT(port);
 		pvid.tag_port &= ~BIT(port);
 
-		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port)) {
+		if (dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)) {
 			priv->tag_8021q_pvid[port] = SJA1105_DEFAULT_VLAN;
 			priv->bridge_pvid[port] = SJA1105_DEFAULT_VLAN;
 		}
@@ -498,12 +488,12 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 {
 	struct sja1105_l2_forwarding_entry *l2fwd;
+	struct dsa_port *dp, *from_dp, *to_dp;
 	struct dsa_switch *ds = priv->ds;
 	struct dsa_switch_tree *dst;
 	struct sja1105_table *table;
 	struct dsa_link *dl;
-	int port, tc;
-	int from, to;
+	int tc;
 
 	table = &priv->static_config.tables[BLK_IDX_L2_FORWARDING];
 
@@ -525,24 +515,21 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 	 * rules and the VLAN PCP to ingress queue mapping.
 	 * Set up the ingress queue mapping first.
 	 */
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
+	dsa_switch_for_each_available_port(dp, ds)
 		for (tc = 0; tc < SJA1105_NUM_TC; tc++)
-			l2fwd[port].vlan_pmap[tc] = tc;
-	}
+			l2fwd[dp->index].vlan_pmap[tc] = tc;
 
 	/* Then manage the forwarding domain for user ports. These can forward
 	 * only to the always-on domain (CPU port and DSA links)
 	 */
-	for (from = 0; from < ds->num_ports; from++) {
-		if (!dsa_is_user_port(ds, from))
-			continue;
+	dsa_switch_for_each_user_port(from_dp, ds) {
+		int from = from_dp->index;
 
-		for (to = 0; to < ds->num_ports; to++) {
-			if (!dsa_is_cpu_port(ds, to) &&
-			    !dsa_is_dsa_port(ds, to))
+		dsa_switch_for_each_port(to_dp, ds) {
+			int to = to_dp->index;
+
+			if (!dsa_port_is_cpu(to_dp) &&
+			    !dsa_port_is_dsa(to_dp))
 				continue;
 
 			l2fwd[from].bc_domain |= BIT(to);
@@ -556,13 +543,14 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 	 * always-on domain). These can send packets to any enabled port except
 	 * themselves.
 	 */
-	for (from = 0; from < ds->num_ports; from++) {
-		if (!dsa_is_cpu_port(ds, from) && !dsa_is_dsa_port(ds, from))
+	dsa_switch_for_each_port(from_dp, ds) {
+		int from = from_dp->index;
+
+		if (!dsa_port_is_cpu(from_dp) && !dsa_port_is_dsa(from_dp))
 			continue;
 
-		for (to = 0; to < ds->num_ports; to++) {
-			if (dsa_is_unused_port(ds, to))
-				continue;
+		dsa_switch_for_each_available_port(to_dp, ds) {
+			int to = to_dp->index;
 
 			if (from == to)
 				continue;
@@ -585,6 +573,8 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 	dst = ds->dst;
 
 	list_for_each_entry(dl, &dst->rtable, list) {
+		int from, to;
+
 		if (dl->dp->ds != ds || dl->link_dp->cpu_dp == dl->dp->cpu_dp)
 			continue;
 
@@ -604,24 +594,17 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 	/* Finally, manage the egress flooding domain. All ports start up with
 	 * flooding enabled, including the CPU port and DSA links.
 	 */
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
-		priv->ucast_egress_floods |= BIT(port);
-		priv->bcast_egress_floods |= BIT(port);
+	dsa_switch_for_each_available_port(dp, ds) {
+		priv->ucast_egress_floods |= BIT(dp->index);
+		priv->bcast_egress_floods |= BIT(dp->index);
 	}
 
 	/* Next 8 entries define VLAN PCP mapping from ingress to egress.
 	 * Create a one-to-one mapping.
 	 */
 	for (tc = 0; tc < SJA1105_NUM_TC; tc++) {
-		for (port = 0; port < ds->num_ports; port++) {
-			if (dsa_is_unused_port(ds, port))
-				continue;
-
-			l2fwd[ds->num_ports + tc].vlan_pmap[port] = tc;
-		}
+		dsa_switch_for_each_available_port(dp, ds)
+			l2fwd[ds->num_ports + tc].vlan_pmap[dp->index] = tc;
 
 		l2fwd[ds->num_ports + tc].type_egrpcp2outputq = true;
 	}
@@ -634,7 +617,8 @@ static int sja1110_init_pcp_remapping(struct sja1105_private *priv)
 	struct sja1110_pcp_remapping_entry *pcp_remap;
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-	int port, tc;
+	struct dsa_port *dp;
+	int tc;
 
 	table = &priv->static_config.tables[BLK_IDX_PCP_REMAPPING];
 
@@ -657,13 +641,9 @@ static int sja1110_init_pcp_remapping(struct sja1105_private *priv)
 	pcp_remap = table->entries;
 
 	/* Repeat the configuration done for vlan_pmap */
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
+	dsa_switch_for_each_available_port(dp, ds)
 		for (tc = 0; tc < SJA1105_NUM_TC; tc++)
-			pcp_remap[port].egrpcp[tc] = tc;
-	}
+			pcp_remap[dp->index].egrpcp[tc] = tc;
 
 	return 0;
 }
@@ -999,7 +979,8 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	struct sja1105_l2_policing_entry *policing;
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-	int port, tc;
+	struct dsa_port *dp;
+	int tc;
 
 	table = &priv->static_config.tables[BLK_IDX_L2_POLICING];
 
@@ -1019,9 +1000,10 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	policing = table->entries;
 
 	/* Setup shared indices for the matchall policers */
-	for (port = 0; port < ds->num_ports; port++) {
-		int mcast = (ds->num_ports * (SJA1105_NUM_TC + 1)) + port;
-		int bcast = (ds->num_ports * SJA1105_NUM_TC) + port;
+	dsa_switch_for_each_available_port(dp, ds) {
+		int mcast = (ds->num_ports * (SJA1105_NUM_TC + 1)) + dp->index;
+		int bcast = (ds->num_ports * SJA1105_NUM_TC) + dp->index;
+		int port = dp->index;
 
 		for (tc = 0; tc < SJA1105_NUM_TC; tc++)
 			policing[port * SJA1105_NUM_TC + tc].sharindx = port;
@@ -1033,10 +1015,11 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	}
 
 	/* Setup the matchall policer parameters */
-	for (port = 0; port < ds->num_ports; port++) {
+	dsa_switch_for_each_available_port(dp, ds) {
 		int mtu = VLAN_ETH_FRAME_LEN + ETH_FCS_LEN;
+		int port = dp->index;
 
-		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+		if (dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp))
 			mtu += VLAN_HLEN;
 
 		policing[port].smax = 65535; /* Burst size in bytes */
@@ -1994,16 +1977,17 @@ static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 {
 	struct sja1105_l2_forwarding_entry *l2_fwd;
 	struct sja1105_private *priv = ds->priv;
-	int i, rc;
+	struct dsa_port *dp;
+	int rc;
 
 	l2_fwd = priv->static_config.tables[BLK_IDX_L2_FORWARDING].entries;
 
-	for (i = 0; i < ds->num_ports; i++) {
-		/* Add this port to the forwarding matrix of the
-		 * other ports in the same bridge, and viceversa.
-		 */
-		if (!dsa_is_user_port(ds, i))
-			continue;
+	/* Add this port to the forwarding matrix of the
+	 * other ports in the same bridge, and viceversa.
+	 */
+	dsa_switch_for_each_user_port(dp, ds) {
+		int i = dp->index;
+
 		/* For the ports already under the bridge, only one thing needs
 		 * to be done, and that is to add this port to their
 		 * reachability domain. So we can perform the SPI write for
@@ -2015,8 +1999,10 @@ static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 		 */
 		if (i == port)
 			continue;
-		if (dsa_to_port(ds, i)->bridge_dev != br)
+
+		if (dp->bridge_dev != br)
 			continue;
+
 		sja1105_port_allow_traffic(l2_fwd, i, port, member);
 		sja1105_port_allow_traffic(l2_fwd, port, i, member);
 
@@ -2364,6 +2350,7 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_table *table;
 	struct sja1105_rule *rule;
+	struct dsa_port *dp;
 	u16 tpid, tpid2;
 	int rc;
 
@@ -2433,11 +2420,8 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	l2_lookup_params = table->entries;
 	l2_lookup_params->shared_learn = !priv->vlan_aware;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_unused_port(ds, port))
-			continue;
-
-		rc = sja1105_commit_pvid(ds, port);
+	dsa_switch_for_each_available_port(dp, ds) {
+		rc = sja1105_commit_pvid(ds, dp->index);
 		if (rc)
 			return rc;
 	}
@@ -2751,17 +2735,14 @@ static int sja1105_setup(struct dsa_switch *ds)
 static void sja1105_teardown(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
-	int port;
+	struct dsa_port *dp;
 
 	rtnl_lock();
 	dsa_tag_8021q_unregister(ds);
 	rtnl_unlock();
 
-	for (port = 0; port < ds->num_ports; port++) {
-		struct sja1105_port *sp = &priv->ports[port];
-
-		if (!dsa_is_user_port(ds, port))
-			continue;
+	dsa_switch_for_each_user_port(dp, ds) {
+		struct sja1105_port *sp = &priv->ports[dp->index];
 
 		if (sp->xmit_worker)
 			kthread_destroy_worker(sp->xmit_worker);
@@ -3282,7 +3263,8 @@ static int sja1105_probe(struct spi_device *spi)
 	struct sja1105_private *priv;
 	size_t max_xfer, max_msg;
 	struct dsa_switch *ds;
-	int rc, port;
+	struct dsa_port *dp;
+	int rc;
 
 	if (!dev->of_node) {
 		dev_err(dev, "No DTS bindings for SJA1105 driver\n");
@@ -3387,14 +3369,10 @@ static int sja1105_probe(struct spi_device *spi)
 	}
 
 	/* Connections between dsa_port and sja1105_port */
-	for (port = 0; port < ds->num_ports; port++) {
-		struct sja1105_port *sp = &priv->ports[port];
-		struct dsa_port *dp = dsa_to_port(ds, port);
+	dsa_switch_for_each_user_port(dp, ds) {
+		struct sja1105_port *sp = &priv->ports[dp->index];
 		struct net_device *slave;
 
-		if (!dsa_is_user_port(ds, port))
-			continue;
-
 		dp->priv = sp;
 		sp->dp = dp;
 		sp->data = tagger_data;
@@ -3416,10 +3394,10 @@ static int sja1105_probe(struct spi_device *spi)
 	return 0;
 
 out_destroy_workers:
-	while (port-- > 0) {
-		struct sja1105_port *sp = &priv->ports[port];
+	dsa_switch_for_each_port_continue_reverse(dp, ds) {
+		struct sja1105_port *sp = &priv->ports[dp->index];
 
-		if (!dsa_is_user_port(ds, port))
+		if (!dsa_port_is_user(dp))
 			continue;
 
 		kthread_destroy_worker(sp->xmit_worker);
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 5acf6742da4d..00fb2e589ee8 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -390,9 +390,9 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 {
 	struct sja1105_mdio_private *mdio_priv;
 	struct dsa_switch *ds = priv->ds;
+	struct dsa_port *dp;
 	struct mii_bus *bus;
 	int rc = 0;
-	int port;
 
 	if (!priv->info->pcs_mdio_read || !priv->info->pcs_mdio_write)
 		return 0;
@@ -420,12 +420,10 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 		return rc;
 	}
 
-	for (port = 0; port < ds->num_ports; port++) {
+	dsa_switch_for_each_available_port(dp, ds) {
 		struct mdio_device *mdiodev;
 		struct dw_xpcs *xpcs;
-
-		if (dsa_is_unused_port(ds, port))
-			continue;
+		int port = dp->index;
 
 		if (priv->phy_mode[port] != PHY_INTERFACE_MODE_SGMII &&
 		    priv->phy_mode[port] != PHY_INTERFACE_MODE_2500BASEX)
@@ -455,7 +453,9 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 	return 0;
 
 out_pcs_free:
-	for (port = 0; port < ds->num_ports; port++) {
+	dsa_switch_for_each_port_continue_reverse(dp, ds) {
+		int port = dp->index;
+
 		if (!priv->xpcs[port])
 			continue;
 
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 130abb0f1438..7465be144cc9 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -297,7 +297,6 @@ static void xrs700x_port_stp_state_set(struct dsa_switch *ds, int port,
 static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
 {
 	struct xrs700x *priv = ds->priv;
-	unsigned int val = 0;
 	int i = 0;
 	int ret;
 
@@ -316,12 +315,8 @@ static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
 	}
 
 	/* Mirror BPDU to CPU port */
-	for (i = 0; i < ds->num_ports; i++) {
-		if (dsa_is_cpu_port(ds, i))
-			val |= BIT(i);
-	}
-
-	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_MIRROR(port, 0), val);
+	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_MIRROR(port, 0),
+			   dsa_cpu_ports(ds));
 	if (ret)
 		return ret;
 
@@ -340,8 +335,8 @@ static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
 static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port,
 				       int fwdport)
 {
+	unsigned int val = dsa_cpu_ports(ds);
 	struct xrs700x *priv = ds->priv;
-	unsigned int val = 0;
 	int i = 0;
 	int ret;
 
@@ -360,11 +355,6 @@ static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port,
 	}
 
 	/* Mirror HSR/PRP supervision to CPU port */
-	for (i = 0; i < ds->num_ports; i++) {
-		if (dsa_is_cpu_port(ds, i))
-			val |= BIT(i);
-	}
-
 	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_MIRROR(port, 1), val);
 	if (ret)
 		return ret;
@@ -505,28 +495,27 @@ static void xrs700x_mac_link_up(struct dsa_switch *ds, int port,
 static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 				 struct net_device *bridge, bool join)
 {
-	unsigned int i, cpu_mask = 0, mask = 0;
+	unsigned int cpu_mask = 0, mask = 0;
 	struct xrs700x *priv = ds->priv;
+	struct dsa_port *dp;
 	int ret;
 
-	for (i = 0; i < ds->num_ports; i++) {
-		if (dsa_is_cpu_port(ds, i))
-			continue;
-
-		cpu_mask |= BIT(i);
+	dsa_switch_for_each_user_port(dp, ds) {
+		cpu_mask |= BIT(dp->index);
 
-		if (dsa_to_port(ds, i)->bridge_dev == bridge)
+		if (dp->bridge_dev == bridge)
 			continue;
 
-		mask |= BIT(i);
+		mask |= BIT(dp->index);
 	}
 
-	for (i = 0; i < ds->num_ports; i++) {
-		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+	dsa_switch_for_each_port(dp, ds) {
+		if (dp->bridge_dev != bridge)
 			continue;
 
 		/* 1 = Disable forwarding to the port */
-		ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(i), mask);
+		ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(dp->index),
+				   mask);
 		if (ret)
 			return ret;
 	}
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4639a82bab66..379ad8183639 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -475,6 +475,14 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	list_for_each_entry((_dp), &(_ds)->dst->ports, list) \
 		if ((_dp)->ds == (_ds))
 
+#define dsa_switch_for_each_port_continue_reverse(_dp, _ds) \
+	list_for_each_entry_continue_reverse((_dp), &(_ds)->dst->ports, list) \
+		if ((_dp)->ds == (_ds))
+
+#define dsa_switch_for_each_available_port(_dp, _ds) \
+	dsa_switch_for_each_port((_dp), (_ds)) \
+		if (!dsa_port_is_unused((_dp)))
+
 #define dsa_switch_for_each_user_port(_dp, _ds) \
 	dsa_switch_for_each_port((_dp), (_ds)) \
 		if (dsa_port_is_user((_dp)))
@@ -494,6 +502,17 @@ static inline u32 dsa_user_ports(struct dsa_switch *ds)
 	return mask;
 }
 
+static inline u32 dsa_cpu_ports(struct dsa_switch *ds)
+{
+	struct dsa_port *dp;
+	u32 mask = 0;
+
+	dsa_switch_for_each_cpu_port(dp, ds)
+		mask |= BIT(dp->index);
+
+	return mask;
+}
+
 /* Return the local port used to reach an arbitrary switch device */
 static inline unsigned int dsa_routing_port(struct dsa_switch *ds, int device)
 {
-- 
2.25.1

