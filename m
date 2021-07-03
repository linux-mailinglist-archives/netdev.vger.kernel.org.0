Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0115C3BA898
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 13:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhGCMBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:01:16 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:47491
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230209AbhGCMBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 08:01:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BylWH2M228AT4o1jP/Dsr1S3JyNW3PDQ7t852Lk2501PvyWzFy7x19d1hVtvbmoqaN0gZVyd9+8kJVqoT6yPUlIieY7B1S+Ww9pKP0+JWTUjzni4X8wc4V76OoJoiOo+04ePJm7VDvu4kWhpsgaaMC07n/Q2Ls6xbg+YO4Qheud8zf0FwPihGTYPNJOmVN41n6z+IraK4bCMAuOz+LMf6EaC42EwE4IMq/oxWiOox2oZJUmYYnoM9syLW5HPvCZcw1lgpZVESJrya7+KxFkugb3gIT0BEWnTCHTXv6DWDuKWcqsAj3VuqSZstdAVuF6biTRXIADlUaIfb0oWNxzfVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgxR7hFYSoTBWSHzj5ZUbxnFm+s0uIOxEOzE3rEZmOI=;
 b=M+NqLnguW5tg2o2snbBhveyKuBwO59INcnVnisJVgwAMAZcFwoFXhWVUozKIGOD9KjaQxjc7aVY/ETiIX7vDRYtHF2FkN9lBXwERjeBERHCe07I4ZOGrKYhz87XNf0Dk9iQffCtGRlC1ij/0Hx3m3MXAxMYnJB+iQInwHBF2UklIr7MnLHKAnb5XRKQf9xzYdVkdgSv0OVTnnQ6O1WjdujrT2xsIlLkLWlSscv8LzvpXsh07bwecfXNHjoxA+oU90MjyOVbvtoPzvYZf6nTyETKcxsCc4tzQLuxHp9H43I0tBD3c/8+i0xVDwQr/UIx57VS9ieXcEzEuKeMNcEG83w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgxR7hFYSoTBWSHzj5ZUbxnFm+s0uIOxEOzE3rEZmOI=;
 b=WTrlWR3zS10EVS3swB3BcwzODRW1GdUzHXdroYIfxLI+DoLmhcRqGHEgCRKyGDPZFWhtkLseWAyVp8ppTbV5tM3QktgVfZXQ1UesGhRu1G2Wt9kHjkIsfU2Q+J1JF0LIoOFIljiQF3yxx9nTYhaf429xEA2GMejyIlnf4z4UkpM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 11:58:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4287.031; Sat, 3 Jul 2021
 11:58:32 +0000
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
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [RFC PATCH v2 net-next 04/10] net: bridge: switchdev: allow the data plane forwarding to be offloaded
Date:   Sat,  3 Jul 2021 14:56:59 +0300
Message-Id: <20210703115705.1034112-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.224.68]
X-ClientProxiedBy: PR3P189CA0081.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.224.68) by PR3P189CA0081.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Sat, 3 Jul 2021 11:58:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37ecffac-50f9-4918-5c88-08d93e19e0f7
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB250927C353C43F76AC7FA552E01E9@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ltV4ISAyUXvQStrowe9Gfveuu2ZS6VMU6iyWRmhLbd/WSb1HL2uIagx+WPf9EAlCeY9EY1RQfC3rVN7f/6Iv0VTwpPv9oFwcHP4GY4GYebEPZxeO1oaux3UlNVZwb2jMOeqJWW3PJfXi20psvGtYS8xK2KX14bAadIxs3urE9tFwRE2IYg7ElKuNFAqat8w5Dv/Wam5GUBHs867rsWpbQa7DiFm4zbJmfb7PqtpWMTomK6g07myvndb9JBSPksT9hPXMWrERzrfF+3Z8E73EVMpBSBgpav+V21T3B/RSUS1hG9RGo2tiMstuVvL3Y2xkU/eaucdBxQgnCo6MUi2CzRtTJDx9YHxGp+Jl0rdu6RnCHPmk1aggvYRQ+/M8PGXXf9PN/vjClZ0Q5PFRtQ4OXbNMsP5mMRwuwPf/wt8Jfd6XLxo58g7RWAGmPGXzpRAqYsFKqi9iHZBX+psI+89L1oZrHTJZ8Ey65B6WKi3Bklz4shR7CtmImZ52mngtIg1hNbvScSF4tShmZyEahwqm37bXwRRoHUlMHyRFpUbmNxS4cUzRNRhyN29hg5P1o3eikw9BG2LVFp/X1KEUz0Bb5xsZsnIhv5MjYQZF8VFf0b/3ol6/MYaFFjQEKb8skJrXwDAGcFhmQUtvdKVh1dznogVC7XCCAi2JTnMAut993RAVpQCfTQzaPsx1GCWERJ+P5YI67gLApocSToISiiFIBDlZSU+aLC3tBLiNeQY9CXifc/OoJGp9MQxoIqSkElMA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(6506007)(2906002)(4326008)(36756003)(2616005)(44832011)(956004)(6666004)(478600001)(7416002)(5660300002)(110136005)(66946007)(26005)(52116002)(1076003)(8676002)(8936002)(316002)(54906003)(66476007)(66556008)(6486002)(38100700002)(16526019)(38350700002)(186003)(83380400001)(86362001)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HFtd5ZjtlSgO9fNP5RxABZwzh/JdlzFqx9AXkjLTjB57qsmWKS8ffCXi6DpZ?=
 =?us-ascii?Q?07o95g+oL0xDHiggMIHVCqMXIsSiNzxvxExC/MWiQXZu9jsGydKaHYcwiY1H?=
 =?us-ascii?Q?MhuNHeYoduzTpgPTWpOMGXXs15F7X61F2QM2RLxk10dN5RwDV2T8RjM8LUPO?=
 =?us-ascii?Q?RWqd1HsTye7Et9DspAjZZe0ry86DPqXNh+bbHP7pfrpewthZb7jQbzJp64uL?=
 =?us-ascii?Q?gUNa5h3xm7WEVe+oYMHpUNoEjFEN4ye2wqVlzpKE41kTIHbm349rr/64eV4J?=
 =?us-ascii?Q?iCr7rLMPe+9b6HmXlGha2WTY4Qi3f14m+u56Xv946ar+Zr/v67POOMt/Rmso?=
 =?us-ascii?Q?5YEUTr+35maMUjlsl7AjUJgaRlIPx0/uIVyAk503zEU0y4EL87zvZzvj9cAV?=
 =?us-ascii?Q?1NK2d+4ez7RKYQZ/chym6wvHT7b+8sa2ZGXu+zcTHDkrcVjBEvduWKuy5qth?=
 =?us-ascii?Q?3tDIC7LonBt4U1xVDUTMAWOTCRWjbNACvjjvBhnkVs9hFqGkZD1/gOmAcyJ1?=
 =?us-ascii?Q?bQTO8qKCyDeuNRfFXTg/H/npOFNEnXrFnJj7JLBe4F04JeJ7sJMeXpB0A05c?=
 =?us-ascii?Q?H+cXhKeOOfMDMZhUb31AGIohpFKMGxrs0X9FKRQldXS1qRhq0z0K0OFG9FwT?=
 =?us-ascii?Q?hpmbLRwPXykon4EUQUIr2/M/FiVYzopQQ+aLBF/pE6HB+Jy4A0Zr7R4vHuIr?=
 =?us-ascii?Q?mEUTuu+U7oOL2EYuq/65NwUnVylXvre5q8EX2DGSqNllYZk+RvzuwiGP3pGv?=
 =?us-ascii?Q?gKeepIRJRSGU8pdRTceRemwhgJKrautuHY4mPz2yOF9JaqCHdj+cXMp6FKm6?=
 =?us-ascii?Q?bl7u2IPptvT4THumMJfgdEdkpFS8dubT3eHv+EXX0eFLjAFPF0RBiKGZDH1M?=
 =?us-ascii?Q?o5VyMs+YQQ2b8tKqKJ/wdAH7u0UeNkTHHd3UOqlSI8BBuQsM5wW1JQiM3hZ7?=
 =?us-ascii?Q?YzLZq37Ncds5W4ufFqr2xOMiKK898lnTMGzrQQ7P4XJ/UJOzm5/jX4I8WzLO?=
 =?us-ascii?Q?yaGvGQ6hvthVBPsE0vXjI+CTX4uj5JsQwCNCKRhO+U4fdk5Cq4AaZt13/UWr?=
 =?us-ascii?Q?84IWWDAf4eTKtdTJf5xKI4sj1PTgldfo9/e/+IP+B3/dau+y3t6rI0kaL230?=
 =?us-ascii?Q?mUtiqkJISmpz4yIhPgqzOGEXdOXJZuTKLmWjlYr4oca7UsGCIjHh86ZPqS0M?=
 =?us-ascii?Q?RE8/FmI8VJySg2q0EcEhDyx40NA2oNjTisasApQ/SJ/lb/Cj8gFnKdO1izN9?=
 =?us-ascii?Q?i7rFzSAdkiSTVBqnnu+hN1vDTkjljVCEa74LLLdSTBgf4GIvUQE7Y71Y4rgw?=
 =?us-ascii?Q?DtTlO2pprzY4Pi5g7FDYdfEG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ecffac-50f9-4918-5c88-08d93e19e0f7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 11:58:32.1086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QflPcdBNFKH7saApw93e9E9rmRaEcZrkbHr4W5AdLeS7D2ec5sRAg1Jqv6JHJaCczyrYpJ8RMNWa6T4BQ8mFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Allow switchdevs to forward frames from the CPU in accordance with the
bridge configuration in the same way as is done between bridge
ports. This means that the bridge will only send a single skb towards
one of the ports under the switchdev's control, and expects the driver
to deliver the packet to all eligible ports in its domain.

Primarily this improves the performance of multicast flows with
multiple subscribers, as it allows the hardware to perform the frame
replication.

The basic flow between the driver and the bridge is as follows:

- The switchdev accepts the offload by returning a non-null pointer
  from .ndo_dfwd_add_station when the port is added to the bridge.

- The bridge sends offloadable skbs to one of the ports under the
  switchdev's control using dev_queue_xmit_accel.

- The switchdev notices the offload by checking for a non-NULL
  "sb_dev" in the core's call to .ndo_select_queue.

v1->v2:
- convert br_input_skb_cb::fwd_hwdoms to a plain unsigned long
- introduce a static key "br_switchdev_fwd_offload_used" to minimize the
  impact of the newly introduced feature on all the setups which don't
  have hardware that can make use of it
- introduce a check for nbp->flags & BR_FWD_OFFLOAD to optimize cache
  line access
- reorder nbp_switchdev_frame_mark_accel() and br_handle_vlan() in
  __br_forward()
- do not strip VLAN on egress if forwarding offload on VLAN-aware bridge
  is being used
- propagate errors from .ndo_dfwd_add_station() if not EOPNOTSUPP

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h |  1 +
 net/bridge/br_forward.c   | 18 +++++++-
 net/bridge/br_private.h   | 24 +++++++++++
 net/bridge/br_switchdev.c | 87 +++++++++++++++++++++++++++++++++++++--
 net/bridge/br_vlan.c      | 10 ++++-
 5 files changed, 135 insertions(+), 5 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b651c5e32a28..a47b86ab7f96 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -57,6 +57,7 @@ struct br_ip_list {
 #define BR_MRP_AWARE		BIT(17)
 #define BR_MRP_LOST_CONT	BIT(18)
 #define BR_MRP_LOST_IN_CONT	BIT(19)
+#define BR_FWD_OFFLOAD		BIT(20)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 07856362538f..919246a2c7eb 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -32,6 +32,8 @@ static inline int should_deliver(const struct net_bridge_port *p,
 
 int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
+	struct net_device *sb_dev = NULL;
+
 	skb_push(skb, ETH_HLEN);
 	if (!is_skb_forwardable(skb->dev, skb))
 		goto drop;
@@ -48,7 +50,14 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
 		skb_set_network_header(skb, depth);
 	}
 
-	dev_queue_xmit(skb);
+	if (br_switchdev_accels_skb(skb)) {
+		sb_dev = BR_INPUT_SKB_CB(skb)->brdev;
+
+		WARN_ON_ONCE(br_vlan_enabled(sb_dev) &&
+			     !skb_vlan_tag_present(skb));
+	}
+
+	dev_queue_xmit_accel(skb, sb_dev);
 
 	return 0;
 
@@ -76,6 +85,11 @@ static void __br_forward(const struct net_bridge_port *to,
 	struct net *net;
 	int br_hook;
 
+	/* Mark the skb for forwarding offload early so that br_handle_vlan()
+	 * can know whether to pop the VLAN header on egress or keep it.
+	 */
+	nbp_switchdev_frame_mark_accel(to, skb);
+
 	vg = nbp_vlan_group_rcu(to);
 	skb = br_handle_vlan(to->br, to, vg, skb);
 	if (!skb)
@@ -174,6 +188,8 @@ static struct net_bridge_port *maybe_deliver(
 	if (!should_deliver(p, skb))
 		return prev;
 
+	nbp_switchdev_frame_mark_fwd(p, skb);
+
 	if (!prev)
 		goto out;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 9ff09a32e3f8..655212df57f7 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -332,6 +332,7 @@ struct net_bridge_port {
 #endif
 #ifdef CONFIG_NET_SWITCHDEV
 	int				hwdom;
+	void				*accel_priv;
 #endif
 	u16				group_fwd_mask;
 	u16				backup_redirected_cnt;
@@ -508,7 +509,9 @@ struct br_input_skb_cb {
 #endif
 
 #ifdef CONFIG_NET_SWITCHDEV
+	u8 fwd_accel:1;
 	int src_hwdom;
+	unsigned long fwd_hwdoms;
 #endif
 };
 
@@ -1647,6 +1650,12 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
+bool br_switchdev_accels_skb(struct sk_buff *skb);
+
+void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
+				    struct sk_buff *skb);
+void nbp_switchdev_frame_mark_fwd(const struct net_bridge_port *p,
+				  struct sk_buff *skb);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1669,6 +1678,21 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
+static inline bool br_switchdev_accels_skb(struct sk_buff *skb)
+{
+	return false;
+}
+
+static inline void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
+						  struct sk_buff *skb)
+{
+}
+
+static inline void nbp_switchdev_frame_mark_fwd(const struct net_bridge_port *p,
+						struct sk_buff *skb)
+{
+}
+
 static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 					    struct sk_buff *skb)
 {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index f3120f13c293..8653d9a540a1 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,6 +8,40 @@
 
 #include "br_private.h"
 
+static struct static_key_false br_switchdev_fwd_offload_used;
+
+static bool nbp_switchdev_can_accel(const struct net_bridge_port *p,
+				    const struct sk_buff *skb)
+{
+	if (!static_branch_unlikely(&br_switchdev_fwd_offload_used))
+		return false;
+
+	return (p->flags & BR_FWD_OFFLOAD) &&
+	       (p->hwdom != BR_INPUT_SKB_CB(skb)->src_hwdom);
+}
+
+bool br_switchdev_accels_skb(struct sk_buff *skb)
+{
+	if (!static_branch_unlikely(&br_switchdev_fwd_offload_used))
+		return false;
+
+	return BR_INPUT_SKB_CB(skb)->fwd_accel;
+}
+
+void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
+				    struct sk_buff *skb)
+{
+	if (nbp_switchdev_can_accel(p, skb))
+		BR_INPUT_SKB_CB(skb)->fwd_accel = true;
+}
+
+void nbp_switchdev_frame_mark_fwd(const struct net_bridge_port *p,
+				  struct sk_buff *skb)
+{
+	if (nbp_switchdev_can_accel(p, skb))
+		set_bit(p->hwdom, &BR_INPUT_SKB_CB(skb)->fwd_hwdoms);
+}
+
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb)
 {
@@ -18,8 +52,10 @@ void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 				  const struct sk_buff *skb)
 {
-	return !skb->offload_fwd_mark ||
-	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
+	struct br_input_skb_cb *cb = BR_INPUT_SKB_CB(skb);
+
+	return !test_bit(p->hwdom, &cb->fwd_hwdoms) &&
+		(!skb->offload_fwd_mark || cb->src_hwdom != p->hwdom);
 }
 
 /* Flags that can be offloaded to hardware */
@@ -125,6 +161,39 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 	return switchdev_port_obj_del(dev, &v.obj);
 }
 
+static int nbp_switchdev_fwd_offload_add(struct net_bridge_port *p)
+{
+	void *priv;
+
+	if (!(p->dev->features & NETIF_F_HW_L2FW_DOFFLOAD))
+		return 0;
+
+	priv = p->dev->netdev_ops->ndo_dfwd_add_station(p->dev, p->br->dev);
+	if (IS_ERR(priv)) {
+		int err = PTR_ERR(priv);
+
+		return err == -EOPNOTSUPP ? 0 : err;
+	}
+
+	p->accel_priv = priv;
+	p->flags |= BR_FWD_OFFLOAD;
+	static_branch_inc(&br_switchdev_fwd_offload_used);
+
+	return 0;
+}
+
+static void nbp_switchdev_fwd_offload_del(struct net_bridge_port *p)
+{
+	if (!p->accel_priv)
+		return;
+
+	p->dev->netdev_ops->ndo_dfwd_del_station(p->dev, p->accel_priv);
+
+	p->accel_priv = NULL;
+	p->flags &= ~BR_FWD_OFFLOAD;
+	static_branch_dec(&br_switchdev_fwd_offload_used);
+}
+
 static int nbp_switchdev_hwdom_set(struct net_bridge_port *joining)
 {
 	struct net_bridge *br = joining->br;
@@ -176,13 +245,25 @@ int nbp_switchdev_add(struct net_bridge_port *p)
 		return err;
 	}
 
-	return nbp_switchdev_hwdom_set(p);
+	err = nbp_switchdev_hwdom_set(p);
+	if (err)
+		return err;
+
+	if (p->hwdom) {
+		err = nbp_switchdev_fwd_offload_add(p);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 void nbp_switchdev_del(struct net_bridge_port *p)
 {
 	ASSERT_RTNL();
 
+	nbp_switchdev_fwd_offload_del(p);
+
 	if (p->hwdom)
 		nbp_switchdev_hwdom_put(p);
 }
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index a08e9f193009..bf014efa5851 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -457,7 +457,15 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 		u64_stats_update_end(&stats->syncp);
 	}
 
-	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED)
+	/* If the skb will be sent using forwarding offload, the assumption is
+	 * that the switchdev will inject the packet into hardware together
+	 * with the bridge VLAN, so that it can be forwarded according to that
+	 * VLAN. The switchdev should deal with popping the VLAN header in
+	 * hardware on each egress port as appropriate. So only strip the VLAN
+	 * header if forwarding offload is not being used.
+	 */
+	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED &&
+	    !br_switchdev_accels_skb(skb))
 		__vlan_hwaccel_clear_tag(skb);
 
 	if (p && (p->flags & BR_VLAN_TUNNEL) &&
-- 
2.25.1

