Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349A73C5F2B
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbhGLPZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:39 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:42723
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235519AbhGLPZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MR2P+bGQRxFXkZq06pDcSYCR+LDTzzKMZbAKRa212w4htS7X3ZbYgudqKPT3c3uC61zsomnHk0yiu7N/6xiBO/anRM41dr8WoB7dMnJ5To+4y4fpXH/vhxFqcA0+cuTuzlE8CHaBRc/bov8CeAv7ZsNgagNq82J2oDiuH4KpYWz+pxUBiOt9eqDWeqfrzZI4+WUf2lVKaOAiifuEfvf/9emVtQ4athaDO7nweevY9whAuPI8fzPuMQnMGnnpFRqrvIn0l4MMEqeqPVoOl7kzGtNO7J0NpA8TWam2tVRVqp5DeuYYNzaHmd1dA+wzIVe/W3tZWTJnCk/CYen0gZK4wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLP1enISVA6/MDMdAX4ko1JVDKim4QW0eI18R+Wa7Bs=;
 b=aKzEdPDnkTS64jWnLuoHb0baUJcDT1xWgXA1d0JaYGse7zscW4PjeSNng0usdAKpAau6Wy2bUvoePvswjAQbJYyUp7bxYjcYl/ehIXeiaVDIoVIxg76HNaamTTSRkAiYJK0I8MNDBLcKfxkNh3X8NdTfXu4C4QcFhvJQ+cFGL0G5sV/4s+4TTBd9pzGduJO5X5r3TFq+Qszb1Nv846DrDE/dN7KGEGEhLSXfN58kFVvI9ahi3F+1yWI3qeYMSqG6fPaN4dKV7kvXI1H6sJaMgdGpZz0hw7c56D+9PkzHnaH1TGCovyaKjHi4Bw8pAQg/qsh9PqVI107AIRgzQqs/NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLP1enISVA6/MDMdAX4ko1JVDKim4QW0eI18R+Wa7Bs=;
 b=jJ4OK0i+cGXBtTuU7T1c4B77vtAH/lnacElMZjhcWt7Y9/R5Npul13RJXYUz0OBO5U4LxYzMtZ0PZ41Bj5qoW38ed+TDqQfFyYde6kOD4obXdg1YiJJB1GKDsE2U6lYb3+VFmLKjJCCpBxEYzO7CGGuervwJ0+F3+ZVhkRslRvo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 18/24] net: bridge: replay vlan entries on the public switchdev notifier
Date:   Mon, 12 Jul 2021 18:21:36 +0300
Message-Id: <20210712152142.800651-19-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58689837-165d-4f26-89d8-08d94548de61
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6271A77A8B9BD402BE793156E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k2VFozJiXdXjDR/0PWMXiNcKs/xAEtkjBWlAacHufuoJlhnFCDu5tmqX29VU+YohlPM9Q0bXINIEzbv3taJUmt4VJAG+R1FGGkXgZoD0h2uD24WIZ3PpwNdpFXjTt2gfyUo6peUZZiHKwD2hKxWTlfLatdWm7JhbylfQ9BtrJSChE0M+J4ZPWwEEEK5eumCWVwJML+ltHsYxZ4RaQON5xadpQnabRYLI1S+a3/vsGhsgPdLFnEd6azIDEOsXUtJwC4KRnxJa9hALjRPjJQKGP01b9sXPdBhvKle8cuaRkdFzeVIjON7Er/Mfk/Ac6FitxkKFrUuc+XEaLn/gI/uuWxmZch0pD+hcgpNnkEqfV5Dw1s0aniZz6xmkwqBxJPdTJRNKFvOZ6rYpBTrIatMjgAB0h+jFfpqh5qIKesJOSsqPlnIxf5eeOXeA1aXRZozU3ssmdo8oSDnLHoEfsJ8fs5UMlMR4dDEWxu83gPaUtgoq3/W+BPNUYxFkcqqcLSMJ0SJaDEJ8maU2bCTD5X3MO+2FJ6Pk/cTSlbcWJZKR8rN8htlVPptWRCXHIG9/qOlYGeiXLulluFUYcp9Q+Q9BxBul2S/aw/22et4Reayj6VDpnUToPVwpfKjrPAZhiHFFmIYqf8Vb3pO80kDkJ/7TM5YkAYw4sa3611gZ/PTAQhz//Lg0wJqFQlseeijwecr0eM0mkpBHiNPvClYUPwwWHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(83380400001)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V/GhGtKI/XqBIRElFImNzCIkjfdH3OmFNL4KODW2rA/oQDj1gl7PiTVv3cMl?=
 =?us-ascii?Q?m6hPDtV4MjVdGZ6k0yLQJniRHvjMeO17bt6kU9kEFWrQ0aRBatsRMP5sz7bH?=
 =?us-ascii?Q?wnPCvbFen3HalZmPkWu3E7/ElbLCX5p3/wcznWpH8KfcdidELk2f4rp35Z0I?=
 =?us-ascii?Q?2lyPuFAJQ02u24F0vGh/bLTqWl4rFrJCqNHt2s5Cw/2v/fht2BkE1ITcpwPU?=
 =?us-ascii?Q?3GXJZgUdS1StytYQ3/x3LclJCiBgNR8DpVQdI5REgWvGWiLEmVzuovfVqxiC?=
 =?us-ascii?Q?d7MQ31uQHefbLSYNapEcmdGwKMKzJxHQIrYb7AcsGkieYXPyURByG2wz1cjy?=
 =?us-ascii?Q?0/J2N4bceoC85w4YM6dFNdEb36kyRr3tAA5xXNmE3+hUa5wGegKNzGoOjavp?=
 =?us-ascii?Q?+/w/c163fomFc7zFV5FNrDYtnGwrQrjI6IgZB6Ey7DrHjE+c4AMgrbZqz9/h?=
 =?us-ascii?Q?2MpHevdFS0IR8GB4xuyLpJ5MaX2bpzayPql+e6Rh0Ik7bw52azEoKMi6dBc8?=
 =?us-ascii?Q?bDDbY/epCWKiSsv35FSQ62MSrjI6c8LG9cvhBqke8rx8ZroLJ0KFyS4DvjPM?=
 =?us-ascii?Q?092f3979QAXd+DP+gQ6q1/VW0oNYyvcqPbuThGEgkvF2F0Hotx4OcGh5E1v8?=
 =?us-ascii?Q?McnwmrGui07adzv6xOPurApsphV00vX//fdipBHguh9SoIXND3LSQ+AZD5CM?=
 =?us-ascii?Q?C7Xuy6rz/GLna535mYC4UG0594Ctuk16PnoawuwMcpSYFHyY5PU/f2zIh1za?=
 =?us-ascii?Q?BP4cb/VN4Vrku6Ih4DZX0uAiwvdfeHvFG6Vu2x0XTR7Zk6ARdXrViDsjywdh?=
 =?us-ascii?Q?pFxZ7RrU9FEBaZWOnX8LQyXxKtD+HK7T5BhW8VWFkxTYhsfA5k3BuHKdyGv8?=
 =?us-ascii?Q?N8dsg6Frnu7DL4vnMvRHjzNJqM67ymw1Di1/8FROWATspjtdoMYPf+y0mz67?=
 =?us-ascii?Q?sXHTEaWRw5KBvgG7i5+E5q3kRnltRWEHuxKA2E3NlHzXd/eT3ayn0+kkEJr+?=
 =?us-ascii?Q?6RY2ptnT0go+fK5owpaZ8eASRGXnWsImjWASvK8OtAtzP8+buQ3JhMiWNZCB?=
 =?us-ascii?Q?EO71PMyLXaRfv6lUxM2WZ57tI6UnuiWGPJUKSvkMTaPSdwJkSakAhCh2tXP6?=
 =?us-ascii?Q?MPCHrm8ssEyA86gBEUIHT+6RLkOObCgxaBDih9adGmuAmGu8IVLiRdiviMn9?=
 =?us-ascii?Q?VNX5J0lnJbsF/CXcknW7Xrb5ZRFmoqv5DULxKWNqzTzMSVhStqoyp4t5W76s?=
 =?us-ascii?Q?MMOSY9D/9CugbLCjML2CSo0DQUzf1TPGG7esdrxff3D/A7svKdGGoa6sSbg8?=
 =?us-ascii?Q?x0cn+qsMbnE/yp5hwxcEBR4q?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58689837-165d-4f26-89d8-08d94548de61
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:32.2150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uzk3Xc/AHD71IbOWT39cIb12VLAFiKAruwnwNC49RZODaslZX4Qy24FbgF9G+3wMuH4k4uNYeFzgTZ7wTPEywg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of making br_vlan_replay() be called automatically for
every switchdev driver, we need to drop the extra argument to the
blocking notifier block so it becomes a less bureaucratic process, and
just emit the replayed events on the public chain.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c |  3 +--
 include/linux/if_bridge.h              |  6 ++---
 net/bridge/br_vlan.c                   | 32 ++++++++------------------
 net/dsa/dsa_priv.h                     |  1 -
 net/dsa/port.c                         |  6 ++---
 net/dsa/slave.c                        |  2 +-
 6 files changed, 16 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 863437990f92..981adbf21200 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1179,8 +1179,7 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_vlan_replay(bridge_dev, brport_dev, priv, true,
-			     &ocelot_switchdev_blocking_nb, extack);
+	err = br_vlan_replay(bridge_dev, brport_dev, priv, true, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index c7ed22b22256..58624f393248 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -119,8 +119,7 @@ int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-		   const void *ctx, bool adding, struct notifier_block *nb,
-		   struct netlink_ext_ack *extack);
+		   const void *ctx, bool adding, struct netlink_ext_ack *extack);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
 {
@@ -150,8 +149,7 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 
 static inline int br_vlan_replay(struct net_device *br_dev,
 				 struct net_device *dev, const void *ctx,
-				 bool adding, struct notifier_block *nb,
-				 struct netlink_ext_ack *extack)
+				 bool adding, struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 14f10203d121..ad2d1e56c6e4 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1807,35 +1807,28 @@ void br_vlan_notify(const struct net_bridge *br,
 	kfree_skb(skb);
 }
 
-static int br_vlan_replay_one(struct notifier_block *nb,
-			      struct net_device *dev,
+static int br_vlan_replay_one(struct net_device *dev,
 			      struct switchdev_obj_port_vlan *vlan,
-			      const void *ctx, unsigned long action,
+			      const void *ctx, bool adding,
 			      struct netlink_ext_ack *extack)
 {
-	struct switchdev_notifier_port_obj_info obj_info = {
-		.info = {
-			.dev = dev,
-			.extack = extack,
-			.ctx = ctx,
-		},
-		.obj = &vlan->obj,
-	};
 	int err;
 
-	err = nb->notifier_call(nb, action, &obj_info);
-	return notifier_to_errno(err);
+	if (adding)
+		err = switchdev_port_obj_add(dev, &vlan->obj, ctx, extack);
+	else
+		err = switchdev_port_obj_del(dev, &vlan->obj, ctx);
+
+	return err;
 }
 
 int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-		   const void *ctx, bool adding, struct notifier_block *nb,
-		   struct netlink_ext_ack *extack)
+		   const void *ctx, bool adding, struct netlink_ext_ack *extack)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
 	struct net_bridge_port *p;
 	struct net_bridge *br;
-	unsigned long action;
 	int err = 0;
 	u16 pvid;
 
@@ -1862,11 +1855,6 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 	if (!vg)
 		return 0;
 
-	if (adding)
-		action = SWITCHDEV_PORT_OBJ_ADD;
-	else
-		action = SWITCHDEV_PORT_OBJ_DEL;
-
 	pvid = br_get_pvid(vg);
 
 	list_for_each_entry(v, &vg->vlan_list, vlist) {
@@ -1880,7 +1868,7 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 		if (!br_vlan_should_use(v))
 			continue;
 
-		err = br_vlan_replay_one(nb, dev, &vlan, ctx, action, extack);
+		err = br_vlan_replay_one(dev, &vlan, ctx, adding, extack);
 		if (err)
 			return err;
 	}
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 20003512d8f8..3b51aaa26760 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -285,7 +285,6 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
-extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
 
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 int dsa_slave_create(struct dsa_port *dp);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c86121e9d87d..63a244858e2b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -208,8 +208,7 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_vlan_replay(br, brport_dev, dp, true,
-			     &dsa_slave_switchdev_blocking_notifier, extack);
+	err = br_vlan_replay(br, brport_dev, dp, true, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -238,8 +237,7 @@ static int dsa_port_switchdev_unsync_objs(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_vlan_replay(br, brport_dev, dp, false,
-			     &dsa_slave_switchdev_blocking_notifier, extack);
+	err = br_vlan_replay(br, brport_dev, dp, false, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 461c80bc066a..f8f06756c6a3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2521,7 +2521,7 @@ static struct notifier_block dsa_slave_switchdev_notifier = {
 	.notifier_call = dsa_slave_switchdev_event,
 };
 
-struct notifier_block dsa_slave_switchdev_blocking_notifier = {
+static struct notifier_block dsa_slave_switchdev_blocking_notifier = {
 	.notifier_call = dsa_slave_switchdev_blocking_event,
 };
 
-- 
2.25.1

