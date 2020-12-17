Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC232DCAC4
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgLQCBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:01:01 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:61436
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727331AbgLQCA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 21:00:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLLmQ6tigM2PYxVmJh5ijhI4CHOhsGi1B0YAhEmGnq2rAtL1tH37XQ+RErdb/0WwYdUK/0Hgb9u3+VCKfVakgmbXePl2kzIlDCHOX+uD1qAHVPfhAOIufocfJTGjsnlfe35wTmml+DNxtuS0+0ljihzueM/hfc1/befNu9LJuXZ2RKf8TY06i33468mAJwxlNqZcpcZPTt9Qn2bXmYIInQ3URNXyJJ6MxkG3hrxwBS212h9h/VqFVBxwJOG6Kph77Eo6MaSbj1Cx0siiKMG/XOdVKXQp33Ds5y0cAufWx7dW8rcsRv8BXXroITF5RPbPPwSwSTJuqgfZgwN6eVZOlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zbV9Ejbkdy1t5WSSWQXYgwcmRg+cAV1Rqwrzj4gMLpk=;
 b=aetFexlnlRnonZ3UlSgrtY8VfQdJ7gfLih8SGLD1FOay/EQXVxTe8goCnch01k9kmkPCoL8ZRUzhUTe/1GCXzVtj9nBcm37l0e7H9w3OXShuv3d7L04nn2pblZoIuhEA9+RFR/2NILb7JCmhc8exA1A4ld1+pmSPJOR64/HSyfrWhq9h3BrsCFDnenvkXalywTFoKP9NmT3TiQJCD50WLsoiiOt6TuwqS/dguuPCJ3k9lvLkKstDe589pUWwK4EUOliM9XVQP6YGfPF1+WkFmvSdZRm6kNPP50lEpsJsqUplAh5GXfrYMig58MBqu42nLiCQFx7GH9ddzv4Ow9FjPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zbV9Ejbkdy1t5WSSWQXYgwcmRg+cAV1Rqwrzj4gMLpk=;
 b=TMSBunMX7xqlMt6CkwDdVQe2kDhwQPLzPQluL24g4P0+QufHE6OlcykDSH2M31kF+4umfWlE9BXpECG0YsLcGVllPV5O9i84s77Wwuc2X0TGae2QUHhto9WUWTBB7fOnIxZTdwo4pvh1EReUn/vsAmTfzl0gDR6SYZ4T00hQ8vI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Thu, 17 Dec
 2020 01:59:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 01:59:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [RFC PATCH net-next 6/9] net: dsa: remove the transactional logic from VLAN objects
Date:   Thu, 17 Dec 2020 03:58:19 +0200
Message-Id: <20201217015822.826304-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201217015822.826304-1-vladimir.oltean@nxp.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VE1PR08CA0028.eurprd08.prod.outlook.com
 (2603:10a6:803:104::41) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VE1PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:803:104::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 01:59:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 374b7c1c-ff00-4c59-0a52-08d8a22f57ef
X-MS-TrafficTypeDiagnostic: VI1PR04MB6943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6943AF8B4857A9BE86DEDDC6E0C40@VI1PR04MB6943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:260;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MfQlizf3YoLYeHbphlDTbbKOUv7TPBvlFshGVgMC+OCa61FalcmnQ63FodTKXBt+RF342uim5vN5uzrqUJwVMVWJeTDmfwQd0HE5whGf683rhKJjU2Bqu783uqTfwQ8upf3IY9rqn054ttMAvthFyvtnQOICNUEEWJoailyCihCpQf4smA8Y3m+tP3Mebz1ywmoSsP8lAGSfwDRiXIxu9J5Gx5ynPMMlFx1BTXvGLGX6f1UNyBsjoD4q/46v4AghdntmWboIwLX7pVbii2PqnIlhWuXYq5RrkZg4yTI4006/a9X+wAdQG4RZUZlySGokATEM8T+VgrnQA/xmP3Dh8doVx+M2U7yK/Lz6dDcHn4w1GWOq2j5EbrShC46AYRxU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6666004)(6506007)(16526019)(478600001)(956004)(2616005)(26005)(7416002)(83380400001)(36756003)(66476007)(66556008)(110136005)(86362001)(1076003)(5660300002)(66946007)(316002)(30864003)(186003)(52116002)(6486002)(54906003)(69590400008)(6512007)(44832011)(2906002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BYxMJn4MqXlFyuDY0ZebW0f3vpX52wopvClJG+Oby1A/DcMDH8P7CcxUgfam?=
 =?us-ascii?Q?81FjuaYqIxlJ4++v59HcO7EeMvmQxJDG3VHvwrWwO22+QSC83KSjG/1eXqdE?=
 =?us-ascii?Q?yYbxAo+SfbfdJeAZruTI6taFrM5YXxeX7Cfy6R66KAWrbAKMvtOzTvgc4SLQ?=
 =?us-ascii?Q?b9rbweGbVbGwtWsRP5qHbPX7NTD9O6g1zUa/nUIXwhmgOZyFnzmrop/97xfw?=
 =?us-ascii?Q?iDHpDCxyNVyrcC5zn0YIiu6h8h8uxvzNGH+u5H8A1p31P44Oc5YRCNaZXejv?=
 =?us-ascii?Q?bcPPFcnbs4YrP3RjSDbgChGs8EQy2HZsobUlUzahlK98kzxtdd6nviLXBHa6?=
 =?us-ascii?Q?jZ75K4VdA7gLEK03Z3zKpLyPYkLW26viY9QjQ74a88SfD81kZpXRKu3RdIiI?=
 =?us-ascii?Q?dqQ2p1aScKyA0chtWlBLuJlwkdvETQfyP2KSzjBgvh3f9j09abU6T4juouEc?=
 =?us-ascii?Q?7QXTS9QqpcwEVI3Aw6eHVEMyLHbP5O2q0M1PZOMSMe/tLs+2VP1CQ6pv9E9y?=
 =?us-ascii?Q?wjfV5eCxweqq6LOAH82E8KiVfWlpLkebROeD2FrpkKQRH8mzlhF0nfBWXKju?=
 =?us-ascii?Q?c/ExUwrRofI63pSq7HeM0SZZKUdiGjEnpQDnnoMfzWNpKSXNWA08ec4MV1fh?=
 =?us-ascii?Q?UPrfemkmOwqzMpMLdV3KYtceYdRX6lZ4MgnbgyoKQEUcI8LRbgHSjWz8I9bM?=
 =?us-ascii?Q?pPb6/oWxuY9o1FHHy6b51WcxA5Qu+fBtH4EUxpsGwPOiO1dIQc2TfzSqUJra?=
 =?us-ascii?Q?YL1JP8k8Agfceof+uG1dGjTT7EXryhT+46ugwLxlBPqsyWilS52acgSaDmCQ?=
 =?us-ascii?Q?WuHjKFKFjT64tuQ/uyaBM92CemVqDBCAgkG+JV10k5AIT1DfWBo/NKlCsQQH?=
 =?us-ascii?Q?LXM+N7n2Bcr6UscbBKHVRQ8wH8zCMHTfbIFGmWoB8mUIna+292asjYstT59f?=
 =?us-ascii?Q?EGlKlNGZSH6VF3O2Jxd5vFojNgLHFDpoeOWifJE3OlkSaZ+K2DOnffKUsqcc?=
 =?us-ascii?Q?kLCW?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 01:59:09.4381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 374b7c1c-ff00-4c59-0a52-08d8a22f57ef
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmg5h12tHc82WVbMJp/0hul8PeZH99cnd5/NqdFLQSU9LAF0ufDVOWqGgN8w5nWQwzVmuqM/x5z+oj84s7u+fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should be the driver's business to logically separate its VLAN
offloading into a preparation and a commit phase, and some drivers don't
need / can't do this.

So remove the transactional shim from DSA and let drivers to propagate
errors directly from the .port_vlan_add callback.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       | 17 +++++++----
 drivers/net/dsa/b53/b53_priv.h         |  6 ++--
 drivers/net/dsa/bcm_sf2.c              |  1 -
 drivers/net/dsa/bcm_sf2_cfp.c          |  7 ++---
 drivers/net/dsa/dsa_loop.c             | 29 +++++-------------
 drivers/net/dsa/hirschmann/hellcreek.c | 12 ++++++--
 drivers/net/dsa/lantiq_gswip.c         | 14 ++++++---
 drivers/net/dsa/microchip/ksz8795.c    |  7 +++--
 drivers/net/dsa/microchip/ksz9477.c    | 20 ++++++-------
 drivers/net/dsa/microchip/ksz_common.c |  9 ------
 drivers/net/dsa/microchip/ksz_common.h |  2 --
 drivers/net/dsa/mt7530.c               | 14 ++-------
 drivers/net/dsa/mv88e6xxx/chip.c       | 41 ++++++++++++++++----------
 drivers/net/dsa/ocelot/felix.c         | 13 +++++---
 drivers/net/dsa/qca8k.c                | 14 ++++-----
 drivers/net/dsa/realtek-smi-core.h     |  6 ++--
 drivers/net/dsa/rtl8366.c              | 25 +++++++++++-----
 drivers/net/dsa/rtl8366rb.c            |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 17 ++++++-----
 include/net/dsa.h                      |  4 +--
 net/dsa/dsa_priv.h                     |  1 -
 net/dsa/port.c                         | 10 -------
 net/dsa/switch.c                       | 24 +--------------
 23 files changed, 128 insertions(+), 166 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 9865e734150e..e8fe8ba226c4 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1384,8 +1384,8 @@ int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 }
 EXPORT_SYMBOL(b53_vlan_filtering);
 
-int b53_vlan_prepare(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_vlan *vlan)
+static int b53_vlan_prepare(struct dsa_switch *ds, int port,
+			    const struct switchdev_obj_port_vlan *vlan)
 {
 	struct b53_device *dev = ds->priv;
 
@@ -1407,16 +1407,20 @@ int b53_vlan_prepare(struct dsa_switch *ds, int port,
 
 	return 0;
 }
-EXPORT_SYMBOL(b53_vlan_prepare);
 
-void b53_vlan_add(struct dsa_switch *ds, int port,
-		  const struct switchdev_obj_port_vlan *vlan)
+int b53_vlan_add(struct dsa_switch *ds, int port,
+		 const struct switchdev_obj_port_vlan *vlan)
 {
 	struct b53_device *dev = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct b53_vlan *vl;
 	u16 vid;
+	int err;
+
+	err = b53_vlan_prepare(ds, port, vlan);
+	if (err)
+		return err;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
 		vl = &dev->vlans[vid];
@@ -1441,6 +1445,8 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
 			    vlan->vid_end);
 		b53_fast_age_vlan(dev, vid);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL(b53_vlan_add);
 
@@ -2191,7 +2197,6 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_fast_age		= b53_br_fast_age,
 	.port_egress_floods	= b53_br_egress_floods,
 	.port_vlan_filtering	= b53_vlan_filtering,
-	.port_vlan_prepare	= b53_vlan_prepare,
 	.port_vlan_add		= b53_vlan_add,
 	.port_vlan_del		= b53_vlan_del,
 	.port_fdb_dump		= b53_fdb_dump,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 224423ab0682..7cdf36755a2b 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -348,10 +348,8 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			     int speed, int duplex,
 			     bool tx_pause, bool rx_pause);
 int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering);
-int b53_vlan_prepare(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_vlan *vlan);
-void b53_vlan_add(struct dsa_switch *ds, int port,
-		  const struct switchdev_obj_port_vlan *vlan);
+int b53_vlan_add(struct dsa_switch *ds, int port,
+		 const struct switchdev_obj_port_vlan *vlan);
 int b53_vlan_del(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan);
 int b53_fdb_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 4c493bb47d30..e377ab142e41 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1113,7 +1113,6 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.port_stp_state_set	= b53_br_set_stp_state,
 	.port_fast_age		= b53_br_fast_age,
 	.port_vlan_filtering	= b53_vlan_filtering,
-	.port_vlan_prepare	= b53_vlan_prepare,
 	.port_vlan_add		= b53_vlan_add,
 	.port_vlan_del		= b53_vlan_del,
 	.port_fdb_dump		= b53_fdb_dump,
diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index d82cee5d9202..764503fd8bcb 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -892,11 +892,9 @@ static int bcm_sf2_cfp_rule_insert(struct dsa_switch *ds, int port,
 		else
 			vlan.flags = 0;
 
-		ret = ds->ops->port_vlan_prepare(ds, port_num, &vlan);
+		ret = ds->ops->port_vlan_add(ds, port_num, &vlan);
 		if (ret)
 			return ret;
-
-		ds->ops->port_vlan_add(ds, port_num, &vlan);
 	}
 
 	/*
@@ -942,8 +940,7 @@ static int bcm_sf2_cfp_rule_set(struct dsa_switch *ds, int port,
 		return -EINVAL;
 
 	if ((fs->flow_type & FLOW_EXT) &&
-	    !(ds->ops->port_vlan_prepare || ds->ops->port_vlan_add ||
-	      ds->ops->port_vlan_del))
+	    !(ds->ops->port_vlan_add || ds->ops->port_vlan_del))
 		return -EOPNOTSUPP;
 
 	if (fs->location != RX_CLS_LOC_ANY &&
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index b588614d1e5e..7c16fc66c730 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -198,27 +198,8 @@ static int dsa_loop_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int
-dsa_loop_port_vlan_prepare(struct dsa_switch *ds, int port,
-			   const struct switchdev_obj_port_vlan *vlan)
-{
-	struct dsa_loop_priv *ps = ds->priv;
-	struct mii_bus *bus = ps->bus;
-
-	dev_dbg(ds->dev, "%s: port: %d, vlan: %d-%d",
-		__func__, port, vlan->vid_begin, vlan->vid_end);
-
-	/* Just do a sleeping operation to make lockdep checks effective */
-	mdiobus_read(bus, ps->port_base + port, MII_BMSR);
-
-	if (vlan->vid_end > ARRAY_SIZE(ps->vlans))
-		return -ERANGE;
-
-	return 0;
-}
-
-static void dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
-				   const struct switchdev_obj_port_vlan *vlan)
+static int dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
+				  const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
@@ -227,6 +208,9 @@ static void dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
 	struct dsa_loop_vlan *vl;
 	u16 vid;
 
+	if (vlan->vid_end > ARRAY_SIZE(ps->vlans))
+		return -ERANGE;
+
 	/* Just do a sleeping operation to make lockdep checks effective */
 	mdiobus_read(bus, ps->port_base + port, MII_BMSR);
 
@@ -245,6 +229,8 @@ static void dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
 
 	if (pvid)
 		ps->ports[port].pvid = vid;
+
+	return 0;
 }
 
 static int dsa_loop_port_vlan_del(struct dsa_switch *ds, int port,
@@ -306,7 +292,6 @@ static const struct dsa_switch_ops dsa_loop_driver = {
 	.port_bridge_leave	= dsa_loop_port_bridge_leave,
 	.port_stp_state_set	= dsa_loop_port_stp_state_set,
 	.port_vlan_filtering	= dsa_loop_port_vlan_filtering,
-	.port_vlan_prepare	= dsa_loop_port_vlan_prepare,
 	.port_vlan_add		= dsa_loop_port_vlan_add,
 	.port_vlan_del		= dsa_loop_port_vlan_del,
 	.port_change_mtu	= dsa_loop_port_change_mtu,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 88d4f602b21c..f107185419ea 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -440,13 +440,18 @@ static void hellcreek_unapply_vlan(struct hellcreek *hellcreek, int port,
 	mutex_unlock(&hellcreek->reg_lock);
 }
 
-static void hellcreek_vlan_add(struct dsa_switch *ds, int port,
-			       const struct switchdev_obj_port_vlan *vlan)
+static int hellcreek_vlan_add(struct dsa_switch *ds, int port,
+			      const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct hellcreek *hellcreek = ds->priv;
 	u16 vid;
+	int err;
+
+	err = hellcreek_vlan_prepare(ds, port, vlan);
+	if (err)
+		return err;
 
 	dev_dbg(hellcreek->dev, "Add VLANs (%d -- %d) on port %d, %s, %s\n",
 		vlan->vid_begin, vlan->vid_end, port,
@@ -455,6 +460,8 @@ static void hellcreek_vlan_add(struct dsa_switch *ds, int port,
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
 		hellcreek_apply_vlan(hellcreek, port, vid, pvid, untagged);
+
+	return 0;
 }
 
 static int hellcreek_vlan_del(struct dsa_switch *ds, int port,
@@ -1154,7 +1161,6 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.port_vlan_add	     = hellcreek_vlan_add,
 	.port_vlan_del	     = hellcreek_vlan_del,
 	.port_vlan_filtering = hellcreek_vlan_filtering,
-	.port_vlan_prepare   = hellcreek_vlan_prepare,
 	.setup		     = hellcreek_setup,
 };
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 6f8e46d21981..dcfcb17eac48 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1183,14 +1183,19 @@ static int gswip_port_vlan_prepare(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void gswip_port_vlan_add(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_vlan *vlan)
+static int gswip_port_vlan_add(struct dsa_switch *ds, int port,
+			       const struct switchdev_obj_port_vlan *vlan)
 {
 	struct gswip_priv *priv = ds->priv;
 	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	u16 vid;
+	int err;
+
+	err = gswip_port_vlan_prepare(ds, port, vlan);
+	if (err)
+		return err;
 
 	/* We have to receive all packets on the CPU port and should not
 	 * do any VLAN filtering here. This is also called with bridge
@@ -1198,10 +1203,12 @@ static void gswip_port_vlan_add(struct dsa_switch *ds, int port,
 	 * this.
 	 */
 	if (dsa_is_cpu_port(ds, port))
-		return;
+		return 0;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
 		gswip_vlan_add_aware(priv, bridge, port, vid, untagged, pvid);
+
+	return 0;
 }
 
 static int gswip_port_vlan_del(struct dsa_switch *ds, int port,
@@ -1607,7 +1614,6 @@ static const struct dsa_switch_ops gswip_switch_ops = {
 	.port_bridge_leave	= gswip_port_bridge_leave,
 	.port_fast_age		= gswip_port_fast_age,
 	.port_vlan_filtering	= gswip_port_vlan_filtering,
-	.port_vlan_prepare	= gswip_port_vlan_prepare,
 	.port_vlan_add		= gswip_port_vlan_add,
 	.port_vlan_del		= gswip_port_vlan_del,
 	.port_stp_state_set	= gswip_port_stp_state_set,
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 49cd82109ee9..9b59cf9ef840 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -792,8 +792,8 @@ static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
-				  const struct switchdev_obj_port_vlan *vlan)
+static int ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
@@ -828,6 +828,8 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 		vid |= new_pvid;
 		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, vid);
 	}
+
+	return 0;
 }
 
 static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
@@ -1112,7 +1114,6 @@ static const struct dsa_switch_ops ksz8795_switch_ops = {
 	.port_stp_state_set	= ksz8795_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz8795_port_vlan_filtering,
-	.port_vlan_prepare	= ksz_port_vlan_prepare,
 	.port_vlan_add		= ksz8795_port_vlan_add,
 	.port_vlan_del		= ksz8795_port_vlan_del,
 	.port_fdb_dump		= ksz_port_fdb_dump,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 8e7439e91f60..5ca826079af6 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -510,19 +510,19 @@ static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
+static int ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
 				  const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 vlan_table[3];
 	u16 vid;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	int err;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		if (ksz9477_get_vlan_table(dev, vid, vlan_table)) {
-			dev_dbg(dev->dev, "Failed to get vlan table\n");
-			return;
-		}
+		err = ksz9477_get_vlan_table(dev, vid, vlan_table);
+		if (err)
+			return err;
 
 		vlan_table[0] = VLAN_VALID | (vid & VLAN_FID_M);
 		if (untagged)
@@ -533,15 +533,16 @@ static void ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
 
 		vlan_table[2] |= BIT(port) | BIT(dev->cpu_port);
 
-		if (ksz9477_set_vlan_table(dev, vid, vlan_table)) {
-			dev_dbg(dev->dev, "Failed to set vlan table\n");
-			return;
-		}
+		err = ksz9477_set_vlan_table(dev, vid, vlan_table);
+		if (err)
+			return err;
 
 		/* change PVID */
 		if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
 			ksz_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vid);
 	}
+
+	return 0;
 }
 
 static int ksz9477_port_vlan_del(struct dsa_switch *ds, int port,
@@ -1400,7 +1401,6 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_stp_state_set	= ksz9477_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz9477_port_vlan_filtering,
-	.port_vlan_prepare	= ksz_port_vlan_prepare,
 	.port_vlan_add		= ksz9477_port_vlan_add,
 	.port_vlan_del		= ksz9477_port_vlan_del,
 	.port_fdb_dump		= ksz9477_port_fdb_dump,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 874cdc38fad2..0a5878c01091 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -213,15 +213,6 @@ void ksz_port_fast_age(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL_GPL(ksz_port_fast_age);
 
-int ksz_port_vlan_prepare(struct dsa_switch *ds, int port,
-			  const struct switchdev_obj_port_vlan *vlan)
-{
-	/* nothing needed */
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ksz_port_vlan_prepare);
-
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a1f0929d45a0..f212775372ce 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -161,8 +161,6 @@ int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct net_device *br);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
-int ksz_port_vlan_prepare(struct dsa_switch *ds, int port,
-			  const struct switchdev_obj_port_vlan *vlan);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
 int ksz_port_mdb_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 95ea7d1ecb05..5be38faf0463 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1393,15 +1393,6 @@ mt7530_port_vlan_filtering(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int
-mt7530_port_vlan_prepare(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_vlan *vlan)
-{
-	/* nothing needed */
-
-	return 0;
-}
-
 static void
 mt7530_hw_vlan_add(struct mt7530_priv *priv,
 		   struct mt7530_hw_vlan_entry *entry)
@@ -1489,7 +1480,7 @@ mt7530_hw_vlan_update(struct mt7530_priv *priv, u16 vid,
 	mt7530_vlan_cmd(priv, MT7530_VTCR_WR_VID, vid);
 }
 
-static void
+static int
 mt7530_port_vlan_add(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan)
 {
@@ -1514,6 +1505,8 @@ mt7530_port_vlan_add(struct dsa_switch *ds, int port,
 	}
 
 	mutex_unlock(&priv->reg_mutex);
+
+	return 0;
 }
 
 static int
@@ -2614,7 +2607,6 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_fdb_del		= mt7530_port_fdb_del,
 	.port_fdb_dump		= mt7530_port_fdb_dump,
 	.port_vlan_filtering	= mt7530_port_vlan_filtering,
-	.port_vlan_prepare	= mt7530_port_vlan_prepare,
 	.port_vlan_add		= mt7530_port_vlan_add,
 	.port_vlan_del		= mt7530_port_vlan_del,
 	.port_mirror_add	= mt753x_port_mirror_add,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dc9da2d46786..2aae7e82f9cd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1620,9 +1620,6 @@ mv88e6xxx_port_vlan_prepare(struct dsa_switch *ds, int port,
 					   vlan->vid_end);
 	mv88e6xxx_reg_unlock(chip);
 
-	/* We don't need any dynamic resource from the kernel (yet),
-	 * so skip the prepare phase.
-	 */
 	return err;
 }
 
@@ -1969,8 +1966,8 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
 	return 0;
 }
 
-static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
-				    const struct switchdev_obj_port_vlan *vlan)
+static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
+				   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
@@ -1978,9 +1975,11 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	bool warn;
 	u8 member;
 	u16 vid;
+	int err;
 
-	if (!mv88e6xxx_max_vid(chip))
-		return;
+	err = mv88e6xxx_port_vlan_prepare(ds, port, vlan);
+	if (err)
+		return err;
 
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED;
@@ -1996,16 +1995,29 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 
 	mv88e6xxx_reg_lock(chip);
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
-		if (mv88e6xxx_port_vlan_join(chip, port, vid, member, warn))
-			dev_err(ds->dev, "p%d: failed to add VLAN %d%c\n", port,
-				vid, untagged ? 'u' : 't');
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
+		err = mv88e6xxx_port_vlan_join(chip, port, vid, member, warn);
+		if (err)
+			break;
+	}
+
+	if (err) {
+		dev_err(ds->dev, "p%d: failed to add VLAN %d%c\n", port,
+			vid, untagged ? 'u' : 't');
+		return err;
+	}
 
-	if (pvid && mv88e6xxx_port_set_pvid(chip, port, vlan->vid_end))
-		dev_err(ds->dev, "p%d: failed to set PVID %d\n", port,
-			vlan->vid_end);
+	if (pvid) {
+		err = mv88e6xxx_port_set_pvid(chip, port, vlan->vid_end);
+		if (err) {
+			dev_err(ds->dev, "p%d: failed to set PVID %d\n", port,
+				vlan->vid_end);
+		}
+	}
 
 	mv88e6xxx_reg_unlock(chip);
+
+	return err;
 }
 
 static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
@@ -5398,7 +5410,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
 	.port_fast_age		= mv88e6xxx_port_fast_age,
 	.port_vlan_filtering	= mv88e6xxx_port_vlan_filtering,
-	.port_vlan_prepare	= mv88e6xxx_port_vlan_prepare,
 	.port_vlan_add		= mv88e6xxx_port_vlan_add,
 	.port_vlan_del		= mv88e6xxx_port_vlan_del,
 	.port_fdb_add           = mv88e6xxx_port_fdb_add,
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d3e0693ae2df..76edbfd7b8e9 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -141,14 +141,18 @@ static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	return ocelot_port_vlan_filtering(ocelot, port, enabled);
 }
 
-static void felix_vlan_add(struct dsa_switch *ds, int port,
-			   const struct switchdev_obj_port_vlan *vlan)
+static int felix_vlan_add(struct dsa_switch *ds, int port,
+			  const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ocelot *ocelot = ds->priv;
 	u16 flags = vlan->flags;
 	u16 vid;
 	int err;
 
+	err = felix_vlan_prepare(ds, port, vlan);
+	if (err)
+		return err;
+
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		err = ocelot_vlan_add(ocelot, port, vid,
 				      flags & BRIDGE_VLAN_INFO_PVID,
@@ -156,9 +160,11 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
 		if (err) {
 			dev_err(ds->dev, "Failed to add VLAN %d to port %d: %d\n",
 				vid, port, err);
-			return;
+			return err;
 		}
 	}
+
+	return 0;
 }
 
 static int felix_vlan_del(struct dsa_switch *ds, int port,
@@ -795,7 +801,6 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_bridge_join	= felix_bridge_join,
 	.port_bridge_leave	= felix_bridge_leave,
 	.port_stp_state_set	= felix_bridge_stp_state_set,
-	.port_vlan_prepare	= felix_vlan_prepare,
 	.port_vlan_filtering	= felix_vlan_filtering,
 	.port_vlan_add		= felix_vlan_add,
 	.port_vlan_del		= felix_vlan_del,
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 7adf71ebd9fe..7978027aded8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1312,13 +1312,6 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 }
 
 static int
-qca8k_port_vlan_prepare(struct dsa_switch *ds, int port,
-			const struct switchdev_obj_port_vlan *vlan)
-{
-	return 0;
-}
-
-static void
 qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 		    const struct switchdev_obj_port_vlan *vlan)
 {
@@ -1331,8 +1324,10 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
 		ret = qca8k_vlan_add(priv, port, vid, untagged);
 
-	if (ret)
+	if (ret) {
 		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
+		return ret;
+	}
 
 	if (pvid) {
 		int shift = 16 * (port % 2);
@@ -1344,6 +1339,8 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 			    QCA8K_PORT_VLAN_CVID(vlan->vid_end) |
 			    QCA8K_PORT_VLAN_SVID(vlan->vid_end));
 	}
+
+	return 0;
 }
 
 static int
@@ -1389,7 +1386,6 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_fdb_del		= qca8k_port_fdb_del,
 	.port_fdb_dump		= qca8k_port_fdb_dump,
 	.port_vlan_filtering	= qca8k_port_vlan_filtering,
-	.port_vlan_prepare	= qca8k_port_vlan_prepare,
 	.port_vlan_add		= qca8k_port_vlan_add,
 	.port_vlan_del		= qca8k_port_vlan_del,
 	.phylink_validate	= qca8k_phylink_validate,
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index bc7bd47fb037..26376b052594 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -132,10 +132,8 @@ int rtl8366_reset_vlan(struct realtek_smi *smi);
 int rtl8366_init_vlan(struct realtek_smi *smi);
 int rtl8366_vlan_filtering(struct dsa_switch *ds, int port,
 			   bool vlan_filtering);
-int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_vlan *vlan);
-void rtl8366_vlan_add(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_vlan *vlan);
+int rtl8366_vlan_add(struct dsa_switch *ds, int port,
+		     const struct switchdev_obj_port_vlan *vlan);
 int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan);
 void rtl8366_get_strings(struct dsa_switch *ds, int port, u32 stringset,
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 212c2bf87aac..30dba9e76c66 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -374,8 +374,8 @@ int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_filtering);
 
-int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_vlan *vlan)
+static int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_vlan *vlan)
 {
 	struct realtek_smi *smi = ds->priv;
 	u16 vid;
@@ -393,10 +393,9 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
 	 */
 	return rtl8366_enable_vlan4k(smi, true);
 }
-EXPORT_SYMBOL_GPL(rtl8366_vlan_prepare);
 
-void rtl8366_vlan_add(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_vlan *vlan)
+int rtl8366_vlan_add(struct dsa_switch *ds, int port,
+		     const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untagged = !!(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
 	bool pvid = !!(vlan->flags & BRIDGE_VLAN_INFO_PVID);
@@ -406,9 +405,13 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	u16 vid;
 	int ret;
 
+	ret = rtl8366_vlan_prepare(ds, port, vlan);
+	if (ret)
+		return ret;
+
 	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
 		if (!smi->ops->is_vlan_valid(smi, vid))
-			return;
+			return -EINVAL;
 
 	dev_info(smi->dev, "add VLAN %d on port %d, %s, %s\n",
 		 vlan->vid_begin,
@@ -426,24 +429,30 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 			untag |= BIT(port);
 
 		ret = rtl8366_set_vlan(smi, vid, member, untag, 0);
-		if (ret)
+		if (ret) {
 			dev_err(smi->dev,
 				"failed to set up VLAN %04x",
 				vid);
+			return ret;
+		}
 
 		if (!pvid)
 			continue;
 
 		ret = rtl8366_set_pvid(smi, port, vid);
-		if (ret)
+		if (ret) {
 			dev_err(smi->dev,
 				"failed to set PVID on port %d to VLAN %04x",
 				port, vid);
+			return ret;
+		}
 
 		if (!ret)
 			dev_dbg(smi->dev, "VLAN add: added VLAN %d with PVID on port %d\n",
 				vid, port);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_add);
 
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index cfe56960f44b..896978568716 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1504,7 +1504,6 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_ethtool_stats = rtl8366_get_ethtool_stats,
 	.get_sset_count = rtl8366_get_sset_count,
 	.port_vlan_filtering = rtl8366_vlan_filtering,
-	.port_vlan_prepare = rtl8366_vlan_prepare,
 	.port_vlan_add = rtl8366_vlan_add,
 	.port_vlan_del = rtl8366_vlan_del,
 	.port_enable = rtl8366rb_port_enable,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 3dfcb750e169..7f960ecc6b6b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2782,29 +2782,31 @@ static int sja1105_vlan_del_one(struct dsa_switch *ds, int port, u16 vid,
 	return 0;
 }
 
-static void sja1105_vlan_add(struct dsa_switch *ds, int port,
-			     const struct switchdev_obj_port_vlan *vlan)
+static int sja1105_vlan_add(struct dsa_switch *ds, int port,
+			    const struct switchdev_obj_port_vlan *vlan)
 {
 	struct sja1105_private *priv = ds->priv;
 	bool vlan_table_changed = false;
 	u16 vid;
 	int rc;
 
+	rc = sja1105_vlan_prepare(ds, port, vlan);
+	if (rc)
+		return rc;
+
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		rc = sja1105_vlan_add_one(ds, port, vid, vlan->flags,
 					  &priv->bridge_vlans);
 		if (rc < 0)
-			return;
+			return rc;
 		if (rc > 0)
 			vlan_table_changed = true;
 	}
 
 	if (!vlan_table_changed)
-		return;
+		return 0;
 
-	rc = sja1105_build_vlan_table(priv, true);
-	if (rc)
-		dev_err(ds->dev, "Failed to build VLAN table: %d\n", rc);
+	return sja1105_build_vlan_table(priv, true);
 }
 
 static int sja1105_vlan_del(struct dsa_switch *ds, int port,
@@ -3286,7 +3288,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_bridge_join	= sja1105_bridge_join,
 	.port_bridge_leave	= sja1105_bridge_leave,
 	.port_stp_state_set	= sja1105_bridge_stp_state_set,
-	.port_vlan_prepare	= sja1105_vlan_prepare,
 	.port_vlan_filtering	= sja1105_vlan_filtering,
 	.port_vlan_add		= sja1105_vlan_add,
 	.port_vlan_del		= sja1105_vlan_del,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2d715b0502e3..b5d04adc09b0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -561,10 +561,8 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_vlan_filtering)(struct dsa_switch *ds, int port,
 				       bool vlan_filtering);
-	int (*port_vlan_prepare)(struct dsa_switch *ds, int port,
+	int	(*port_vlan_add)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan);
-	void (*port_vlan_add)(struct dsa_switch *ds, int port,
-			      const struct switchdev_obj_port_vlan *vlan);
 	int	(*port_vlan_del)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan);
 	/*
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f8362860cdaa..5bd2327d519f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -58,7 +58,6 @@ struct dsa_notifier_mdb_info {
 /* DSA_NOTIFIER_VLAN_* */
 struct dsa_notifier_vlan_info {
 	const struct switchdev_obj_port_vlan *vlan;
-	struct switchdev_trans *trans;
 	int sw_index;
 	int port;
 };
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c89e3c0c65ed..e59bf66c4c0d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -441,17 +441,7 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		.port = dp->index,
 		.vlan = vlan,
 	};
-	struct switchdev_trans trans;
-	int err;
-
-	info.trans = &trans;
-
-	trans.ph_prepare = true;
-	err = dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
-	if (err)
-		return err;
 
-	trans.ph_prepare = false;
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
 }
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 65124bc3ddfb..bd00ef6296f9 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -217,35 +217,13 @@ static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
 	return false;
 }
 
-static int dsa_switch_vlan_prepare(struct dsa_switch *ds,
-				   struct dsa_notifier_vlan_info *info)
-{
-	int port, err;
-
-	if (!ds->ops->port_vlan_prepare || !ds->ops->port_vlan_add)
-		return -EOPNOTSUPP;
-
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_vlan_match(ds, port, info)) {
-			err = ds->ops->port_vlan_prepare(ds, port, info->vlan);
-			if (err)
-				return err;
-		}
-	}
-
-	return 0;
-}
-
 static int dsa_switch_vlan_add(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
 	int port;
 
-	if (switchdev_trans_ph_prepare(info->trans))
-		return dsa_switch_vlan_prepare(ds, info);
-
 	if (!ds->ops->port_vlan_add)
-		return 0;
+		return -EOPNOTSUPP;
 
 	for (port = 0; port < ds->num_ports; port++)
 		if (dsa_switch_vlan_match(ds, port, info))
-- 
2.25.1

