Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41B43A670
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhJYW06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:26:58 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230246AbhJYW04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:26:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/OmAiWfJvIRtsCxYE6BsqZE7nUg/DNq1ZndrSl83usiEEqGRO6OiYqveCr0ETx4VlOP/wX7Z2g2xB1piP+yUmcpKJjWuA0hMRsv2m6Na39pUPpOkdrB//J25eOGt5IVT1L/0hb2iDiqau0NggYJp+ipO2PVwmaXGAoI6X2mrEGVTFuYROBd1ZlbHn3mRweXUWwz8/a4dwyxAAGcksG7bfBkh5eouonp6SdpDyZkxofeqGG3qV2MPLs/Gt4y/GsyIT+scguTgKSAc5FNvUYwIjw9sxTh7YO7D4N1P0kvk3XgkGr0eHrm4A274asqGeEVze/KgkQTf9TYd53TviJD9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGbcQMN9oyHcF78l/qhpxrp2wFveYxuRwvoJ9nc7P70=;
 b=PfZWOrLioHCbs4ifYPC4YyoKPQz2+OuJLStSfAi6AF/9AkJZKyAI0GCWkI3vAus+PYiLFM8uhFAmRXF+tJuzeIhdXaBOAuEUrDspOi/Jl3SLbruhFXqQFTVVy5iaeaaoK0q3TNR8P0WINBhle/qSimcKwjGNV6dQ/vaKUEqcQLGMooIbk2QohvMIz/5t8uZKmnmVtvYHYAYPY5TTwYGlXX0fObHbo4AvQGtl9NM9AU8OJ1JiSeSJLh/SVOyXyqGV7hhuAy29QFwBpv/C7NsGOd2vp48takuc15PSeszDoVymXL0s5ZpGEGATQmecFJ2L2d4YJHxdrjYFtEyfjKREjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGbcQMN9oyHcF78l/qhpxrp2wFveYxuRwvoJ9nc7P70=;
 b=mguXy2bDSLB1xNwUJ8JMI45fq9c52dc8hm8ReQjOp9BtzrTt5RagyBfksfwHMi9MQUjWMBIwp3YMt5nA27u6PvP7SQAQVkEJXI0o6dT+2bSkYz/62c8WVt+ske1K4u/q1W8WbQql57DrTL43gwzchQ/a2To17/0tgh7zpul5jA0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH net-next 01/15] net: bridge: remove fdb_notify forward declaration
Date:   Tue, 26 Oct 2021 01:24:01 +0300
Message-Id: <20211025222415.983883-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2784b8ba-1cdf-46e3-9e13-08d9980636e2
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB230456833053F3CCB400F3A0E0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qsdt+iV3iHryDtct97RgR90F5IWizOKDV9LFNfg9h3DDrjvuk90N6P5xEbpZeC2xUVtACuGSqNKTe9c5cVVkQDln0FM4fpNPGu77157D19O8SPh7exTDJbUPGlhXdf1cp9re34D2lzLM7j0N0ZZ0RzHwiv8ZZUVjuWdIA4fQYAWFPPbEw/jevvSM0mTFd5RpAjbK+fWduCOs28usEG8wj7u+MAVtVP6JI79Fn865dSVyd9ImWPrn2cvKmSGRDx6Sx/DuCDMRAeZ5vw4msAGr1VOISWmNI8tShAh5mZpFFIkkIRj3mIDpRJlNoIeD8FeVONkNj9PVEFq0aVmPxEcLKTz8VhaY4tN/cg9DqbPrz3bYd8WYHj/pWUkf4YOCuGmLJXeiye8xDDsK161Oz1nhN+XS2q2+u7ksVUgv8a1KRAerwaOtoBhZXswX7TBhKP4k2lDq7dS98Qx9rLeWZLp6pnkBFzr8M1r7/IgpuW99/tnwWjWuCj6FySyq6wOziJA1Jb+DpyCMSP4+TRpw7HYJpik6kAKpWiUPcbPZIM3dVif9T/2/8cj7VRHcIiYx/GdSLfZ6YcrlLtRjOTNooLxMkFNKjsg5/xIpsApPiy545ti6YcY+qXj01Tu1YaTok9c6T34OjCJ1amHT1OOctC/Q1xGSAJSxUngGTROfkR2G16KwgAlkW4SMaL/9NnpxAEQxVfbT8oSBf/AKWzx9gyWHfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rExTOp4m0RU5/bZakDe+VZeAxscenDvlVd0GhPhjoRvFuLddYPyuHGAmnvVG?=
 =?us-ascii?Q?w6dXHqr5JYDM3Naf50VZ/qv/1EmMmtGyYVLNg5EOQse2QPuqZC41xprQqjo8?=
 =?us-ascii?Q?8C0Xsw7+4fIiNBXQlUU7Sie+wwg8kDveJAUbKnEPDw0/34EjTspBtsF7dZtY?=
 =?us-ascii?Q?zPq2X1NMCe/pm/n+V57oI9UkF+tL+cnbOkpL2jTZygKz5+3D++vcndOuzgji?=
 =?us-ascii?Q?C0/4nQRJ02doqW91+C/fJx2yRJZjCYk06Mf1jb0F7wWnunNAVYsmLwMuOXbF?=
 =?us-ascii?Q?6t94Zrt6GKyhZ0ZhxHaFzo9F4UPpDs2MvTX5jbNTiHYCTOIX00EXb6rjwqea?=
 =?us-ascii?Q?vEOt81nfwXdMZoL9gTQ4PnkGFjHtuBrGE848X1dsQ25S1aIRqgHiaGbcwo7u?=
 =?us-ascii?Q?FGnMeNge6YdJRuszadPh6nH18r9M/YLo/McyYZUJzfIqb1eAGMfw7pb/oGVm?=
 =?us-ascii?Q?BioBeM2NiIg5HsJyYDwjjTRVJR6QNegjA3s/PNSvYEk9Hor4lfdPKvmnnhGt?=
 =?us-ascii?Q?bBpUh1fuUkhrdgb9IX2fNWTSfRJqNIQGRwlsVoFC511X9ZLlWsV3jd3aAdOa?=
 =?us-ascii?Q?7PUCUn7e/lLigyoSF3uiNuJyeK46bmlHCmRIGviV87cX5JHXK+iENMnKgVfi?=
 =?us-ascii?Q?2sMHyjm68S7Pyzp8Q0MiPdW5AZh30BJUi9dEjDQpIc3tVt7+J1b8uJi7DsUq?=
 =?us-ascii?Q?l0iemwlBPgHBen7VGeQRShnbsChrE1BaCrPhi2iOZikoYEa77JxiQh3i+8/M?=
 =?us-ascii?Q?0b4maYrkzca8U1wxA1R6wsWXkZhf3fWQobnlhbUYgTx1uK7fnm+Z8R1EPM8R?=
 =?us-ascii?Q?SvqB9YGRO48Nlu3vGWiJK1hjzwZYsCE6nEKHKfGp0kCys4KxUyYQvc4mKo24?=
 =?us-ascii?Q?hy3b0wHEF1JXrooE795dlX358/R4ZN4pic0v4eV102KaQ+/9r3oyLH0ZLJiq?=
 =?us-ascii?Q?S2Z8+xbCXHTrsQFVUh2ZLzIbJABEpeFP0YoNBhvTAZssuY6yF47+cg/UEQ+r?=
 =?us-ascii?Q?EfxC1hMXMM01N8eo7/yxtwvQsnndTV4CKlJj7rDfJDgOCt6gYhuZN1XfnbpS?=
 =?us-ascii?Q?Odot4nHBQwFN8p3cxfS3liuF0Wy5EOj6W3w8VLZqRWLggUxV6prFi4iwFD6U?=
 =?us-ascii?Q?GiyTCqjQZXDu6P2GpycV4ZY56Pi/Qkut8nTPEDY+k+GdpU8F8a9cFB+HfTrC?=
 =?us-ascii?Q?kCyoDVfhXLYccPJKDucD6/+EWGCP8ev3iTY2iml4/b/dOyA+abkUSIv7Ye8u?=
 =?us-ascii?Q?e1DvKysEcwfRB+/wclhM3Lx08fRwemg0D7EBsTFcWk5t6gv2X5+MhvICWJd7?=
 =?us-ascii?Q?ku+ZX17Bvg7kzfRN5RFj//yVYGMw6mBsSemZmMuKvFjbzyx8kN9HqMcB9GPX?=
 =?us-ascii?Q?m5t0DVkfUM4YerZlLtMmsxv4T66+IV8cOiCiAGIZ8BdDoES6KLsB1puEqFY1?=
 =?us-ascii?Q?q/taayxSaXEDiRnzxxfphwlQUiNV3jc/toy0xkA6JMxird+xkVGqGBEbxk78?=
 =?us-ascii?Q?fOHJYNDD/fa8tjVTBET3iqFYoQ9fKpnT/VRrML/NpbQpzJ3Iu13VL3HHuLk9?=
 =?us-ascii?Q?9fC/0he2VQiwoQGnSo7GMITV/fz2EEBB+QdLUszwZdDBlQCtt8memRBCGSYf?=
 =?us-ascii?Q?qZ15RlaV5QlVSmc3YBXWDz0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2784b8ba-1cdf-46e3-9e13-08d9980636e2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:30.9251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5mBa4bHvsGTFmqJS20kCzQU6pfE1R42ME/jtipkJV9kC4PmxSufjw+DbdP/4DrgCqHBBd4kra4ev2VfdtspDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fdb_notify() has a forward declaration because its first caller,
fdb_delete(), is declared before 3 functions that fdb_notify() needs:
fdb_to_nud(), fdb_fill_info() and fdb_nlmsg_size().

This patch moves the aforementioned 4 functions above fdb_delete() and
deletes the forward declaration.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 246 ++++++++++++++++++++++----------------------
 1 file changed, 122 insertions(+), 124 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index a6a68e18c70a..bfb28a24ea81 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -34,8 +34,6 @@ static const struct rhashtable_params br_fdb_rht_params = {
 static struct kmem_cache *br_fdb_cache __read_mostly;
 static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
 		      const unsigned char *addr, u16 vid);
-static void fdb_notify(struct net_bridge *br,
-		       const struct net_bridge_fdb_entry *, int, bool);
 
 int __init br_fdb_init(void)
 {
@@ -87,6 +85,128 @@ static void fdb_rcu_free(struct rcu_head *head)
 	kmem_cache_free(br_fdb_cache, ent);
 }
 
+static int fdb_to_nud(const struct net_bridge *br,
+		      const struct net_bridge_fdb_entry *fdb)
+{
+	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
+		return NUD_PERMANENT;
+	else if (test_bit(BR_FDB_STATIC, &fdb->flags))
+		return NUD_NOARP;
+	else if (has_expired(br, fdb))
+		return NUD_STALE;
+	else
+		return NUD_REACHABLE;
+}
+
+static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
+			 const struct net_bridge_fdb_entry *fdb,
+			 u32 portid, u32 seq, int type, unsigned int flags)
+{
+	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
+	unsigned long now = jiffies;
+	struct nda_cacheinfo ci;
+	struct nlmsghdr *nlh;
+	struct ndmsg *ndm;
+
+	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
+	if (nlh == NULL)
+		return -EMSGSIZE;
+
+	ndm = nlmsg_data(nlh);
+	ndm->ndm_family	 = AF_BRIDGE;
+	ndm->ndm_pad1    = 0;
+	ndm->ndm_pad2    = 0;
+	ndm->ndm_flags	 = 0;
+	ndm->ndm_type	 = 0;
+	ndm->ndm_ifindex = dst ? dst->dev->ifindex : br->dev->ifindex;
+	ndm->ndm_state   = fdb_to_nud(br, fdb);
+
+	if (test_bit(BR_FDB_OFFLOADED, &fdb->flags))
+		ndm->ndm_flags |= NTF_OFFLOADED;
+	if (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
+		ndm->ndm_flags |= NTF_EXT_LEARNED;
+	if (test_bit(BR_FDB_STICKY, &fdb->flags))
+		ndm->ndm_flags |= NTF_STICKY;
+
+	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
+		goto nla_put_failure;
+	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
+		goto nla_put_failure;
+	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
+	ci.ndm_confirmed = 0;
+	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
+	ci.ndm_refcnt	 = 0;
+	if (nla_put(skb, NDA_CACHEINFO, sizeof(ci), &ci))
+		goto nla_put_failure;
+
+	if (fdb->key.vlan_id && nla_put(skb, NDA_VLAN, sizeof(u16),
+					&fdb->key.vlan_id))
+		goto nla_put_failure;
+
+	if (test_bit(BR_FDB_NOTIFY, &fdb->flags)) {
+		struct nlattr *nest = nla_nest_start(skb, NDA_FDB_EXT_ATTRS);
+		u8 notify_bits = FDB_NOTIFY_BIT;
+
+		if (!nest)
+			goto nla_put_failure;
+		if (test_bit(BR_FDB_NOTIFY_INACTIVE, &fdb->flags))
+			notify_bits |= FDB_NOTIFY_INACTIVE_BIT;
+
+		if (nla_put_u8(skb, NFEA_ACTIVITY_NOTIFY, notify_bits)) {
+			nla_nest_cancel(skb, nest);
+			goto nla_put_failure;
+		}
+
+		nla_nest_end(skb, nest);
+	}
+
+	nlmsg_end(skb, nlh);
+	return 0;
+
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
+static inline size_t fdb_nlmsg_size(void)
+{
+	return NLMSG_ALIGN(sizeof(struct ndmsg))
+		+ nla_total_size(ETH_ALEN) /* NDA_LLADDR */
+		+ nla_total_size(sizeof(u32)) /* NDA_MASTER */
+		+ nla_total_size(sizeof(u16)) /* NDA_VLAN */
+		+ nla_total_size(sizeof(struct nda_cacheinfo))
+		+ nla_total_size(0) /* NDA_FDB_EXT_ATTRS */
+		+ nla_total_size(sizeof(u8)); /* NFEA_ACTIVITY_NOTIFY */
+}
+
+static void fdb_notify(struct net_bridge *br,
+		       const struct net_bridge_fdb_entry *fdb, int type,
+		       bool swdev_notify)
+{
+	struct net *net = dev_net(br->dev);
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+
+	if (swdev_notify)
+		br_switchdev_fdb_notify(br, fdb, type);
+
+	skb = nlmsg_new(fdb_nlmsg_size(), GFP_ATOMIC);
+	if (skb == NULL)
+		goto errout;
+
+	err = fdb_fill_info(skb, br, fdb, 0, 0, type, 0);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in fdb_nlmsg_size() */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(skb);
+		goto errout;
+	}
+	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, NULL, GFP_ATOMIC);
+	return;
+errout:
+	rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
+}
+
 static struct net_bridge_fdb_entry *fdb_find_rcu(struct rhashtable *tbl,
 						 const unsigned char *addr,
 						 __u16 vid)
@@ -638,100 +758,6 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 	}
 }
 
-static int fdb_to_nud(const struct net_bridge *br,
-		      const struct net_bridge_fdb_entry *fdb)
-{
-	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
-		return NUD_PERMANENT;
-	else if (test_bit(BR_FDB_STATIC, &fdb->flags))
-		return NUD_NOARP;
-	else if (has_expired(br, fdb))
-		return NUD_STALE;
-	else
-		return NUD_REACHABLE;
-}
-
-static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
-			 const struct net_bridge_fdb_entry *fdb,
-			 u32 portid, u32 seq, int type, unsigned int flags)
-{
-	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
-	unsigned long now = jiffies;
-	struct nda_cacheinfo ci;
-	struct nlmsghdr *nlh;
-	struct ndmsg *ndm;
-
-	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
-	if (nlh == NULL)
-		return -EMSGSIZE;
-
-	ndm = nlmsg_data(nlh);
-	ndm->ndm_family	 = AF_BRIDGE;
-	ndm->ndm_pad1    = 0;
-	ndm->ndm_pad2    = 0;
-	ndm->ndm_flags	 = 0;
-	ndm->ndm_type	 = 0;
-	ndm->ndm_ifindex = dst ? dst->dev->ifindex : br->dev->ifindex;
-	ndm->ndm_state   = fdb_to_nud(br, fdb);
-
-	if (test_bit(BR_FDB_OFFLOADED, &fdb->flags))
-		ndm->ndm_flags |= NTF_OFFLOADED;
-	if (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
-		ndm->ndm_flags |= NTF_EXT_LEARNED;
-	if (test_bit(BR_FDB_STICKY, &fdb->flags))
-		ndm->ndm_flags |= NTF_STICKY;
-
-	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
-		goto nla_put_failure;
-	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
-		goto nla_put_failure;
-	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
-	ci.ndm_confirmed = 0;
-	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
-	ci.ndm_refcnt	 = 0;
-	if (nla_put(skb, NDA_CACHEINFO, sizeof(ci), &ci))
-		goto nla_put_failure;
-
-	if (fdb->key.vlan_id && nla_put(skb, NDA_VLAN, sizeof(u16),
-					&fdb->key.vlan_id))
-		goto nla_put_failure;
-
-	if (test_bit(BR_FDB_NOTIFY, &fdb->flags)) {
-		struct nlattr *nest = nla_nest_start(skb, NDA_FDB_EXT_ATTRS);
-		u8 notify_bits = FDB_NOTIFY_BIT;
-
-		if (!nest)
-			goto nla_put_failure;
-		if (test_bit(BR_FDB_NOTIFY_INACTIVE, &fdb->flags))
-			notify_bits |= FDB_NOTIFY_INACTIVE_BIT;
-
-		if (nla_put_u8(skb, NFEA_ACTIVITY_NOTIFY, notify_bits)) {
-			nla_nest_cancel(skb, nest);
-			goto nla_put_failure;
-		}
-
-		nla_nest_end(skb, nest);
-	}
-
-	nlmsg_end(skb, nlh);
-	return 0;
-
-nla_put_failure:
-	nlmsg_cancel(skb, nlh);
-	return -EMSGSIZE;
-}
-
-static inline size_t fdb_nlmsg_size(void)
-{
-	return NLMSG_ALIGN(sizeof(struct ndmsg))
-		+ nla_total_size(ETH_ALEN) /* NDA_LLADDR */
-		+ nla_total_size(sizeof(u32)) /* NDA_MASTER */
-		+ nla_total_size(sizeof(u16)) /* NDA_VLAN */
-		+ nla_total_size(sizeof(struct nda_cacheinfo))
-		+ nla_total_size(0) /* NDA_FDB_EXT_ATTRS */
-		+ nla_total_size(sizeof(u8)); /* NFEA_ACTIVITY_NOTIFY */
-}
-
 static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 			     const struct net_bridge_fdb_entry *fdb,
 			     unsigned long action, const void *ctx)
@@ -786,34 +812,6 @@ int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
 	return err;
 }
 
-static void fdb_notify(struct net_bridge *br,
-		       const struct net_bridge_fdb_entry *fdb, int type,
-		       bool swdev_notify)
-{
-	struct net *net = dev_net(br->dev);
-	struct sk_buff *skb;
-	int err = -ENOBUFS;
-
-	if (swdev_notify)
-		br_switchdev_fdb_notify(br, fdb, type);
-
-	skb = nlmsg_new(fdb_nlmsg_size(), GFP_ATOMIC);
-	if (skb == NULL)
-		goto errout;
-
-	err = fdb_fill_info(skb, br, fdb, 0, 0, type, 0);
-	if (err < 0) {
-		/* -EMSGSIZE implies BUG in fdb_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
-		kfree_skb(skb);
-		goto errout;
-	}
-	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, NULL, GFP_ATOMIC);
-	return;
-errout:
-	rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
-}
-
 /* Dump information about entries, in response to GETNEIGH */
 int br_fdb_dump(struct sk_buff *skb,
 		struct netlink_callback *cb,
-- 
2.25.1

