Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536FE468768
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 21:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237837AbhLDUPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 15:15:43 -0500
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:17024
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231561AbhLDUPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 15:15:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6Rj7lVcbFVDxpw+vRsnOq0yewH9oT5G2BJZGqUzpqKTtxaOMVae7CXJFK7sbFHQyKjvbGioyMqNXJpZjQ8uvtDxpaLJQI/bsy9+M5lP87xxoG3WRdVKOGXQQ5KFY9qUeiC04Q9PVDcNJtAYvLKGi99bNlLpbDcyJeaMwWlY5BoIWRw9y4UkQqcIXbK/dCNuEsbA5qZ/FU6PQgMiu07bPP/w1LeF2+G9OZfdkP0yLaElZh4Ak738szX1lAbT7rFQlapC2BOKpUp5bSiweRxwa50G79YEQe6Zzu/rr+9TLytaHk/cOuzIaWZAaYkW2MxVB0U3rnOYb5ygN0UgNbGkNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FtgnwYaNqKO16jeTLObHtf3hVw6m/g0f8Bjo1b0XPfg=;
 b=Zu4EFgVWOn9d4Yj5J6FKV6nQYgvACtGdX+2qEW/gDxINrj6AGMxACRqe1mPxR/NVq+IoiJUcm7+uNz7S4MWNqvXt5zaTyJZrn0kYWPlnXSkoxk87aHPaN5vP5Is43zCeHx8eI7pzLMOOYrHpvaECppFDfvhngobDSeWU9750rBf2hXE0OENZuSj4Geyqnc3nxYCMnGnhYkWEUAoxABP5cQz0uVa9La8Xf/HNP7gLIPfz5S/LNczdNhimcbpvTPL0OuSWQ0uOjHh44d0mm6/QiOimQK20w+ceQBqbxjAaVHARWIdD1+J9M3h5FzkjEb0mcHMBpYHYzoVLT9DmiUs2OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FtgnwYaNqKO16jeTLObHtf3hVw6m/g0f8Bjo1b0XPfg=;
 b=LuIIVOpWWGtwYE/N7BVVPgfrhYoD2TI1xjyi4TdZTAKj0KgVAUGtWVPBJelGxSP3g6582nLWV15jBwm9FzoK9NR3huppVt3DIBtG+l7CSoiqltImRXnxYxQ4wOwYwI4gPz2UuIv8nVUMBl8VjqA4HistwAlrkaioqz3bMBxtEQY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR0402MB3651.eurprd04.prod.outlook.com (2603:10a6:208:5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 20:12:05 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 20:12:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 6/7] net: dsa: add a "tx_fwd_offload" argument to ->port_bridge_join
Date:   Sat,  4 Dec 2021 22:11:45 +0200
Message-Id: <20211204201146.4088103-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
References: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9P194CA0030.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:46d::26) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AS9P194CA0030.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 20:12:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2d956bf-89c3-4c3e-33f7-08d9b762578c
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3651:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB36514F3FA03F5BAA5D6435F1E06B9@AM0PR0402MB3651.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZJyhL7WRNgR4UUwUCdMS3fa7R7wHJpS9DmzJDvCXA+TeK/4XbLhyF1UV9Tnz3/LtDNPwTkESbxs7EPYyajI7NuBgLB59knTsOKhkKcseDLCcbAYu7G0kOGvM7TClJ6tshOMcIYSxYWsLSiaRGlIlNJUQ8hvUA2KvP47pu4A2kTvuv7H0JEHju/f8t7MeMMl9+eptRzWvAxNs9X4kQ3cethdZoVtHlHh5yOat2wfWHGKcR5uloaOr1HbnVhPi/LBHCqNe0aTRyAmj730osTnDzuO8YBMZYT1QdydLXHXTdEJkGw41gLUb5IvDbI+AVuPrD8gtOTHB3mDaSLgmD+mxKfx5R0B9xl8phmtJzaAU7EuCmeNj6H9DZorlb0nyiw+cS/aINApRDUywrc/nSwprxXIFdIYC3pZnmC+6YBrPH1pPl+a30eGWlie9b6Idg3KQO8+Om59xTeGvOSXokxP0Id8N3tbMmKk2byVWnzIpA7DwhuPD+Jq7S6rjFrAerE2Vs7UqGbnj3BPGGKINS+t44y5HJYFPtgANHyIvr+PUwoumCrayyqbUSEKeuBPQDnxmHQ3yztzO1lNTWmFC6Kri2UA9x32bsbA1uaqeK2YHSeI+8/wyj7/8NCiFLNrwDmCLHr1NhDQ9/LRMZ8LqWjE/wzHSHcDfWeQ2DcXEb4CBK5OtxMx7MR+NlGp3xoKx+m87ynN3/6amSVjtBHmMrAFkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(6506007)(4326008)(6486002)(6666004)(66556008)(8936002)(508600001)(54906003)(2906002)(44832011)(66476007)(316002)(6512007)(86362001)(66946007)(7416002)(52116002)(1076003)(83380400001)(30864003)(38100700002)(6916009)(2616005)(38350700002)(186003)(956004)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PoUnDQ21b31pIWKJ4h+Eh9plnI7dlOWS23EiFOuFdCTkwY85yfGbZSHj4z+1?=
 =?us-ascii?Q?tMh+f3z1xZ6RadJbP7Fh7nefU2CrF6H6SDUAXKSXCWQkqX03cyL3GacHkxi6?=
 =?us-ascii?Q?4sqriWflh6Bm7Tvz509DRIyxbW67aL9mURjRrOBm6poxgRJftbl8QXbWySBa?=
 =?us-ascii?Q?zO12ZDvM40iFNW7dOad0S/1+PQjLeDauC/AoTcQTyyiho6umJ0iHGH3kh/r5?=
 =?us-ascii?Q?ZWGoy02KEoWLyNYelgTmaGtVoWwAoYoGKQSF/9Hebaajv8/ZB31y/wvGapQM?=
 =?us-ascii?Q?bMB2s5APCm8kYkBwjBirfc6Uiu6OU6PKHBudlUS1nh1Jm6luKSke6dwMu5QH?=
 =?us-ascii?Q?5B0NhmLU6nCCm/jHiBOshCP3MqUsG5w64q4eGNYBAeNdHL/VOC2ygh7A5JiY?=
 =?us-ascii?Q?JJ3gcqW62frNSGNmuQ24OMxskJ524pDyoaZGr36zLFRqfxzIIDiVGJCL4VIA?=
 =?us-ascii?Q?2RCch1PKcXMZVYUk9SKgR9RjYkLY8KkDFxyqwZss3YjM8Yw5DBmPyfjchPe3?=
 =?us-ascii?Q?2OPpoX1A9y6LmmL8KFGucLcUI+HTKSR25JqJusmLXwVthzNjLwZaUyxNjKlY?=
 =?us-ascii?Q?Szl2ZaRzN23NZ6fEkZwgDLlxccrq4934Clil3ynuM7mhe4nY7D2kAyU+8fZV?=
 =?us-ascii?Q?hmngX6bhSu18JwPTaymQcjdlOt0QJt4DJJ2bo1EcAZIT6gLMFuAzl/mFWHHA?=
 =?us-ascii?Q?ZOVZyNulQLuME9vRdyR+NFCOjEZeZfqVx7w2Ir9mqBkch171RR1n9ep94mHt?=
 =?us-ascii?Q?Mct+3GBFjQ4J1gevuLOz/9X0JmbKcbHqv/IY14D57iDiqp+cmHMHOEeJBHMj?=
 =?us-ascii?Q?Uc1C6M04jfrA4XhCHwAVa+H/7m064b7Yi1+cm7xiXrtupPyFlJZbueu9oAO8?=
 =?us-ascii?Q?aRuYBsPR3+PG9Bpb8IeX+8oxPvRP2v9DgDZy81Okxp8SoatKeNWN+uqhlqJ6?=
 =?us-ascii?Q?MtBJzuXWKAj4lNSfDl+Ctw6yj3IkHRcvI7riqOx2LBuWSRmI0eH4+Yrc6UjV?=
 =?us-ascii?Q?9hQcDW9RT0lWUJZ5yTROK1YzAC9/JpjinW8sZ2rY3+psdfFJTGjx9V7wHIsh?=
 =?us-ascii?Q?LPZ3CUfW6rWry7mNrLVin49ID6ZCzHaCOoC/tcm4Y1GHBh+55SfQa4PWIDm4?=
 =?us-ascii?Q?+MPHdFL3hp+xwbE/xcLZEij1YSC4pxG4u2q5ZoAibWk6lpquPizCBO0wIlcy?=
 =?us-ascii?Q?T6LvCv8aeaRkBzEQPq1du+EtOXTE272aMevhqGALIvmNzAl0n35Pzui02oye?=
 =?us-ascii?Q?l76mEeSu+6d0ZUmus/L/rAbqtKrKJoU1+yD358cn2S2iDE9OKBOglHswK96M?=
 =?us-ascii?Q?7sHbein0eV+f92bha01BiKNahQ0LMyYYrAHSCEkP11UKrpjaZnL1EDXbFGFM?=
 =?us-ascii?Q?f/eQu8T0SLhVxp7m6Xs6SfJpGI8pF5vVNJ/OhEiU71iw2W+XLvpjLKPNIvu4?=
 =?us-ascii?Q?MGEZV0md8uZl5AFGt41EQFEd7VY5iYeMqPypjpDvOUcphQT88pP4iRMDWF0C?=
 =?us-ascii?Q?1rUCx/nRWhr428bCx/nMbkjlFW8X7jE3APzoCNW2ELHu7++5OHfAb8oV1TFW?=
 =?us-ascii?Q?+pAwKmfSaputoyjgQHHPj8U/DqcQuY1f/OGoh/kg3Z/Kz+sWoqBI5zNOoWzF?=
 =?us-ascii?Q?9Tmj0T6xq21ilNTWc0jdllg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d956bf-89c3-4c3e-33f7-08d9b762578c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 20:12:05.4509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kSBEHORxLaPsA3zC29E9l6v7E/u8/GiKBiZlviL8FOcv4OJ1HBWPCETIaZJBDAiZDDTBLPYknj/NlSalUcSGyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3651
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparation patch for the removal of the DSA switch methods
->port_bridge_tx_fwd_offload() and ->port_bridge_tx_fwd_unoffload().
The plan is for the switch to report whether it offloads TX forwarding
directly as a response to the ->port_bridge_join() method.

This change deals with the noisy portion of converting all existing
function prototypes to take this new boolean pointer argument.
The bool is placed in the cross-chip notifier structure for bridge join,
and a reference to it is provided to drivers. In the next change, DSA
will then actually look at this value instead of calling
->port_bridge_tx_fwd_offload().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is kind of new, the noisy conversion from v1's patch 6/6
        has been split into a separate change. Had to drop Alvin's
        Reviewed-by tag because he technically did not review the change
        in this form.

 drivers/net/dsa/b53/b53_common.c       | 3 ++-
 drivers/net/dsa/b53/b53_priv.h         | 3 ++-
 drivers/net/dsa/dsa_loop.c             | 3 ++-
 drivers/net/dsa/hirschmann/hellcreek.c | 3 ++-
 drivers/net/dsa/lan9303-core.c         | 3 ++-
 drivers/net/dsa/lantiq_gswip.c         | 3 ++-
 drivers/net/dsa/microchip/ksz_common.c | 3 ++-
 drivers/net/dsa/microchip/ksz_common.h | 2 +-
 drivers/net/dsa/mt7530.c               | 2 +-
 drivers/net/dsa/mv88e6xxx/chip.c       | 3 ++-
 drivers/net/dsa/ocelot/felix.c         | 2 +-
 drivers/net/dsa/qca8k.c                | 3 ++-
 drivers/net/dsa/rtl8366rb.c            | 3 ++-
 drivers/net/dsa/sja1105/sja1105_main.c | 3 ++-
 drivers/net/dsa/xrs700x/xrs700x.c      | 2 +-
 include/net/dsa.h                      | 3 ++-
 net/dsa/dsa_priv.h                     | 1 +
 net/dsa/switch.c                       | 3 ++-
 18 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 4e41b1a63108..3867f3d4545f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1860,7 +1860,8 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_mdb_del);
 
-int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
+int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
+		bool *tx_fwd_offload)
 {
 	struct b53_device *dev = ds->priv;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index ee17f8b516ca..b41dc8ac2ca8 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -324,7 +324,8 @@ void b53_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void b53_get_ethtool_phy_stats(struct dsa_switch *ds, int port, uint64_t *data);
-int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
+int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
+		bool *tx_fwd_offload);
 void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 70db3a9aa355..33daaf10c488 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -167,7 +167,8 @@ static int dsa_loop_phy_write(struct dsa_switch *ds, int port,
 }
 
 static int dsa_loop_port_bridge_join(struct dsa_switch *ds, int port,
-				     struct dsa_bridge bridge)
+				     struct dsa_bridge bridge,
+				     bool *tx_fwd_offload)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
 		__func__, port, bridge.dev->name);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index c8dc83c69147..9eecb7529573 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -674,7 +674,8 @@ static int hellcreek_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct dsa_bridge bridge)
+				      struct dsa_bridge bridge,
+				      bool *tx_fwd_offload)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 29d909484275..d55784d19fa4 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1103,7 +1103,8 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 }
 
 static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
-				    struct dsa_bridge bridge)
+				    struct dsa_bridge bridge,
+				    bool *tx_fwd_offload)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 1f59fefc29c1..46ed953e787e 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1146,7 +1146,8 @@ static int gswip_vlan_remove(struct gswip_priv *priv,
 }
 
 static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct dsa_bridge bridge)
+				  struct dsa_bridge bridge,
+				  bool *tx_fwd_offload)
 {
 	struct net_device *br = bridge.dev;
 	struct gswip_priv *priv = ds->priv;
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 40d6e3f4deb5..47a856533cff 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -192,7 +192,8 @@ void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf)
 EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
 
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct dsa_bridge bridge)
+			 struct dsa_bridge bridge,
+			 bool *tx_fwd_offload)
 {
 	/* port_stp_state_set() will be called after to put the port in
 	 * appropriate state so there is no need to do anything.
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 88e5a5d56219..df8ae59c8525 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -155,7 +155,7 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct dsa_bridge bridge);
+			 struct dsa_bridge bridge, bool *tx_fwd_offload);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 85cc5aca7f96..dcd1a3932cfb 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1186,7 +1186,7 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
-			struct dsa_bridge bridge)
+			struct dsa_bridge bridge, bool *tx_fwd_offload)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b06ac29a1f7b..c30d1f825776 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2452,7 +2452,8 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct dsa_bridge bridge)
+				      struct dsa_bridge bridge,
+				      bool *tx_fwd_offload)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e563bafca74f..f76dcf0d369f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -706,7 +706,7 @@ static int felix_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int felix_bridge_join(struct dsa_switch *ds, int port,
-			     struct dsa_bridge bridge)
+			     struct dsa_bridge bridge, bool *tx_fwd_offload)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index dc983f79f0d6..039694518788 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1811,7 +1811,8 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 }
 
 static int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct dsa_bridge bridge)
+				  struct dsa_bridge bridge,
+				  bool *tx_fwd_offload)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask, cpu_port;
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index fac2333a3f5e..ecc19bd5115f 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1186,7 +1186,8 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 
 static int
 rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
-			   struct dsa_bridge bridge)
+			   struct dsa_bridge bridge,
+			   bool *tx_fwd_offload)
 {
 	struct realtek_smi *smi = ds->priv;
 	unsigned int port_bitmap = 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 24584fe2e760..21622c60faab 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2074,7 +2074,8 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_bridge_join(struct dsa_switch *ds, int port,
-			       struct dsa_bridge bridge)
+			       struct dsa_bridge bridge,
+			       bool *tx_fwd_offload)
 {
 	return sja1105_bridge_member(ds, port, bridge, true);
 }
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index ebb55dfd9c4e..35fa19ddaf19 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -540,7 +540,7 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 }
 
 static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
-			       struct dsa_bridge bridge)
+			       struct dsa_bridge bridge, bool *tx_fwd_offload)
 {
 	return xrs700x_bridge_common(ds, port, bridge, true);
 }
diff --git a/include/net/dsa.h b/include/net/dsa.h
index b9789c0cd5e3..584b3f9462a0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -822,7 +822,8 @@ struct dsa_switch_ops {
 	 */
 	int	(*set_ageing_time)(struct dsa_switch *ds, unsigned int msecs);
 	int	(*port_bridge_join)(struct dsa_switch *ds, int port,
-				    struct dsa_bridge bridge);
+				    struct dsa_bridge bridge,
+				    bool *tx_fwd_offload);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
 				     struct dsa_bridge bridge);
 	/* Called right after .port_bridge_join() */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index da6ff99ba5ed..38ce5129a33d 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -56,6 +56,7 @@ struct dsa_notifier_bridge_info {
 	int tree_index;
 	int sw_index;
 	int port;
+	bool tx_fwd_offload;
 };
 
 /* DSA_NOTIFIER_FDB_* */
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index cd0630dd5417..9c92edd96961 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -95,7 +95,8 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 		if (!ds->ops->port_bridge_join)
 			return -EOPNOTSUPP;
 
-		err = ds->ops->port_bridge_join(ds, info->port, info->bridge);
+		err = ds->ops->port_bridge_join(ds, info->port, info->bridge,
+						&info->tx_fwd_offload);
 		if (err)
 			return err;
 	}
-- 
2.25.1

