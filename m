Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3594843B401
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbhJZOac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:30:32 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:8192
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235005AbhJZOab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:30:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrtlAq7XNAjxpog5LcACD8TjXASiVS06i1cR0QeimflEchHctvlMiNORX2qnyiG8CyGKQ8cApdoiGVJolBF+S1CCy7zYPwxFa3b9m5Kp4E36H82USTlcIQ62t88FZPs1V8DtNk2Tq4LcDDvpgnaR0p4RUNOhaHPOiRSA+s2VNiksLKjmNm1o/KfGnJMbbwxlM5j+SSn7xGap6v/S/zRRArrikyXczrfrvoWmjchMDsj5gbxcaZp+ksHgiAVqHTaItnTTRX8WkHbvDiTGj4c1sy0/nPlYoJ6k5gjFWW/bN4J3KSyZzTxMv+HyPZFQ44JYbPQj3GU+sW1q0fZdYQbN0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGbcQMN9oyHcF78l/qhpxrp2wFveYxuRwvoJ9nc7P70=;
 b=KJITCgFIpqh6Typk2TZeF2mLq5sRGPbB2gcWN2G+c/xtWTDeYRtV3TP/XY92TslhAjcm9hOtXz+REp1qBis3rEw/Hhpmsz/EZNdv3zspnGc3OhEmGRgS5NheB9mG4S9+8Kg0eSnCFlbuAeY2JlbsNoe1XDNYNIrD7HShf61vW6zad/1Cj8VZ1Dw4qQLab9y2e/34a3pX6p+a55F7i1fB10QfNZYO9W0783qwQbweKRfRulIV7qXuwo6nlAaUh3c0Ts+wXZF9J4TZHMlj/5ZQrgqfgVNpzARNquYUF+xNpkno1+mpsxd9g5G+mhT+yWnw5Sb7BDlSFxHB5xYutWDWag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGbcQMN9oyHcF78l/qhpxrp2wFveYxuRwvoJ9nc7P70=;
 b=FZ1LbA2oRE70Shs/6b5+KIWRXT9F2eQIGVO8N8udkpxvAfKPFjVPVaVjjJzL7yueJxZa9gf8L/Hd8a+9cvBLhISAwAIHq+Gg7mQjyICpNvnLCWw0DzRdHN9ZU42XAToGpmkPuvI9XEMbnEguxnauYLpUGGktIY3doIdlUnWf618=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6016.eurprd04.prod.outlook.com (2603:10a6:803:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 14:28:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 14:28:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 1/8] net: bridge: remove fdb_notify forward declaration
Date:   Tue, 26 Oct 2021 17:27:36 +0300
Message-Id: <20211026142743.1298877-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0113.eurprd07.prod.outlook.com
 (2603:10a6:207:7::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0113.eurprd07.prod.outlook.com (2603:10a6:207:7::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend Transport; Tue, 26 Oct 2021 14:28:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a07b211-ae25-4b43-b821-08d9988cd2ab
X-MS-TrafficTypeDiagnostic: VI1PR04MB6016:
X-Microsoft-Antispam-PRVS: <VI1PR04MB60160096CB4AC40A2D2E7D19E0849@VI1PR04MB6016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oiqyK93tCkp8iWKJBgD9+8/T5fKH0ZKqed/jgWSUrvgIga5zz/Xqjdck3xyMdmYqA7mNRNwwZcIl1q4acIKPShI28HrlxB6DoAa1ZiSCT7lNcWG4R4N522gsu9T7BCD5zcMu3E0Nzg9pxXl+FfW0v/mun8wVu2E+T0oth2Xtu2+NCc8cUCx1jhpBEXtZhsPNLaTUVBLyI8exr9Aux6Rb+7Xfgb0VoywbVwUVuBiyN8aPvxyIh+VExVN+gLD6uc/h1sD5s6c9iNd///noYRzfJP9vb2LHDWAMvznGqafVmwWZVyFBtPeAck0oxofjOBlApObkl3pmA6GKp6J0Ni3+W8Tov8o7MMrFDvdSb4y8mTO7Ec9Yz1riJHkz6O/iKcBH6xe9JfV4bI5USgjLDDJ9Kk5ND+ofqko0g5xEh4nLG7FcUXlue+koR2E/jUTS44eaBgmNe7D+kUh3jCG6a9tXaT5bipQteED35/8qgqfxdWWTvL1HKwCKLKwd9QcBkxoc39ApACg2Urma/crBByXNbd7Hw9ujQ1VODiBeM5rRvQnWQaHFxS3TZSAQBhwlV7qK+BANiIRpozfQSgAttfroqYzY6j4fzorsZUCjg7Rmv4rsGtDopFKaPuJ5ZFtddYZO+F8QL6NqEMe9BkW9biTlMV+tWoS9Eb0ipc25JnQ689gkv8pmbcUoF9kWDl9XXWu94iiMAuQVW2vaF8mkiHFR1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(52116002)(44832011)(66476007)(26005)(38100700002)(54906003)(8676002)(86362001)(5660300002)(2616005)(38350700002)(7416002)(6486002)(6506007)(6666004)(66556008)(316002)(6512007)(956004)(6916009)(36756003)(83380400001)(66946007)(2906002)(186003)(8936002)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vn5eRMmiMxXuWR611bIefu6mSCY+PRRLVpHVn6a2v2j8OGqxNLZl6x+o0fcW?=
 =?us-ascii?Q?+1XyzhwehAn2UU0QYW8CDClfqkOtnZLp6JjP1m0e6L1sc7HUvxYXBaDYwtp8?=
 =?us-ascii?Q?n9bNsuG3AKJDWxIjQkzfHH8f+kpjm+pjzfEOkhL6p+gMaRi+8csuGIecjwBb?=
 =?us-ascii?Q?o0BPdNK9S4lMVHCTqRuf5uBmVtiD+nbLcyeiXz4cGJhu7nRKEyq/qS52hLkn?=
 =?us-ascii?Q?NeR/TGkPmAIfDjScw+GRzRC9zkPetMgMZitHcUdwf9E6SLjGetmxnMHsbLlY?=
 =?us-ascii?Q?3Y4FyAVY1t/vDjooooASqS0bNUzpdhBYkqMfDCYdEFJVpCXjIGlHHpl0l4rb?=
 =?us-ascii?Q?IRiDQXn+pliT7GgU+di4l3AsQYLfNv/82elxU7eBZmmUWC2UnwbEYFxoLexh?=
 =?us-ascii?Q?8j9wPjeQwFZ4QeQeSEmqXfJ62uMebKsJx+bvOdD/YFQlybW+NNoDiQkpKLI2?=
 =?us-ascii?Q?y58T5GTpZF6lzo4MidV9e3IuwltgeZjFZ+BZXGJQpAj7TK0nwEbQye/xZ0V8?=
 =?us-ascii?Q?CP2jmCXugXB/caKnAJXNjqzOtlcS9R31SNL+SE2QEpfLwBwREi3OdYZoC1FG?=
 =?us-ascii?Q?yJrPmjAT7U4DaLqCdnWy4Ba6wTFCCOWu/chWDcvHciYOQXYpnMaVNcPIFKBI?=
 =?us-ascii?Q?gGc49nRyQGPUE9tNXYPbl1pVYDr7dHWcqr1H5WdjWL87C2AkBUbMl+YLANdJ?=
 =?us-ascii?Q?4TC118K7ArPEk+OY6TE04dhClcCzqZyhdwcBXwKhw2uYhH6L+2Gf7iUZ/WML?=
 =?us-ascii?Q?gKKvDlWp1f/n6SKahxpbb/WmqcMv73qzJ5vNwaCEBFVoc7yXwY+DH/pJjipW?=
 =?us-ascii?Q?WKXS6BAQRG7R4kQowJTxNluYjeNeItKBALtHptxrWBBXJkJjH2S0OM3LHg47?=
 =?us-ascii?Q?Ysz8XpCUklwEibPLqAtfV6vgDoPoBII6dhgml9zCQmpgcKzFpHZ5VMIRMbMs?=
 =?us-ascii?Q?fz2DJP+k0yj4I/YVr5t/godiNxoLkUU78/KHu+yLMeKDW0DtTUrhzOo8lcDQ?=
 =?us-ascii?Q?ch+rnjWzAz7TCZq85QZNdgV6xYwT6Tehg2edgTUOjxCEAShHsRY7l61dEAAR?=
 =?us-ascii?Q?dot6RPqdpwSG/toJxUC75oM91GOfF7XtJQU8G/tJsBK4UEamwzyriuOAO5yC?=
 =?us-ascii?Q?Eiq4qH6dwjFVtb2IZxIs13bzBW5BYdD2gBN96mwJPQPjMD5t0UNrW8IyFOfO?=
 =?us-ascii?Q?eH+9u1EyMOcTMMVi1/t3pzj4SP8XmMV02lRhiNdqed6ULWAPB2PBsq/1NFYh?=
 =?us-ascii?Q?0TB7CQZ61jGi2KYZLzKM7UYco4Ma52496TkNTENEmuBdVO4IIPaJKWG2Rnmn?=
 =?us-ascii?Q?Vn8KOErHnzneabRu8zyzJT7hy8n+JpgKkIbqG3+xLxjtwYyayZPPS/8opLPd?=
 =?us-ascii?Q?6xxN7KFLDfITwFTyET4Ht7ytQPFWTBaRgPmACkRqR8c4iM3PAxOE6GaaYxYt?=
 =?us-ascii?Q?KIjLbrCyphISWngFsK/ESGxkmv8SzSpKkB6S0QiSp5ng6EXi9GVo9r4H4gFz?=
 =?us-ascii?Q?pTfgOrxc5sgQ9s82zz1V+Hkxse7z45wfxgHnYBCwQzLOInaxVEEFHl5J+59N?=
 =?us-ascii?Q?oyotSIhcDR6zva1X0LjKwTN78acgNJjT83N3febKRoXRDi49XYYvg88yvB24?=
 =?us-ascii?Q?kSouUbD0XSruRoSljtifFGo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a07b211-ae25-4b43-b821-08d9988cd2ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 14:28:04.9017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9pj4d73BfNmqc4i17TLwKpt7DwMaZlbF0MGhZrinHIX88fI6BcYSXnRsT2vSjFDUJdm2ZTR7UYj0SirswsRUOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6016
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

