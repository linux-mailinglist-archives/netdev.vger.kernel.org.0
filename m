Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED0227218E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgIUK4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgIUK4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:18 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991E4C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:17 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j2so12238981wrx.7
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ynxvS52GFgVISxCrLMAhqxHP2Rg1ErDlZ6rvqJHD3LY=;
        b=wynHXAYxsNjuoEi/JC8ohwBBCrHAgzwxZEjioK0s7AYUgb3Z1tDN+RXmyGS+ie70hk
         h6WhOhzcno56py0sUdEduLmAyGLO6j8/y18vKKsbvhtWhBNK9vGf1SiZ/o204QmLau3q
         Nil5G81dGq1Hoj1yevlALDLblog4E5fZjPgsT6U4Adg2kDDiGscJsJTQqR4LKu71hesH
         mOmNFJBeGbwh/WqTPQoN8Fxr8CqjeePwqIoWlm9KuWyD/WYP1EL5myt8rqhOga+/CN09
         c1Mc7pFZiJIjABkERJfeEnC79+NQU32ve/i6rpXMEWlz0kMVFeYzxglqevHjIKBMV7r1
         z9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ynxvS52GFgVISxCrLMAhqxHP2Rg1ErDlZ6rvqJHD3LY=;
        b=E07dnnmBiFIRh9BE1hIVMVgGxYKNYPRmh21LWwtHXpehGQ2XXe077LCLGWsBdugoDQ
         DajGCCJO+9Wa130ppwxZpfCtTAo7K7o9x++Ysm0Vhl4tEJp57jBkN5vOYxVLMtFxnEut
         BJufXTYvDCIGkACusHVNoSM4SoDLxYeOcWxiZCXOSeghvvfFihapauZo4ucG19SViYnW
         u5yZxsmSJg4GuBYr+vw1xSuUW5Sur7ctv4RtE8L3Jya0fV20e/ImreI2i2C347Gg1nsW
         3RPFEybpFk/bMMobME26yHK/4BcodPC8+j4kgB0XwpFBNJ7ndnqY4sOqjVCfRj52r75/
         dwnA==
X-Gm-Message-State: AOAM533Hg6UnjH0i88b1gFpSM+Ak3AqszQyge27JV5F9Py3rSu6V8IMD
        5m4IH/p2kDbnwhkhhQ6oQczqnn1gMKuw7GVBN87G+w==
X-Google-Smtp-Source: ABdhPJwU3WxzcYVx22Hj9ED3ESNltJqeNCT5v/HF3o6fCy+jH3Aayvo5Kzbn7nhmOrcTvgpC3oUsIA==
X-Received: by 2002:adf:ee8d:: with SMTP id b13mr56080531wro.249.1600685775981;
        Mon, 21 Sep 2020 03:56:15 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:15 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH net-next 06/16] net: bridge: mcast: rename br_ip's u member to dst
Date:   Mon, 21 Sep 2020 13:55:16 +0300
Message-Id: <20200921105526.1056983-7-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Since now we have src in br_ip, u no longer makes sense so rename
it to dst. No functional changes.

CC: Marek Lindner <mareklindner@neomailbox.ch>
CC: Simon Wunderlich <sw@simonwunderlich.de>
CC: Antonio Quartulli <a@unstable.cc
CC: Sven Eckelmann <sven@narfation.org>
CC: b.a.t.m.a.n@lists.open-mesh.org
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/linux/if_bridge.h  |  2 +-
 net/batman-adv/multicast.c | 10 +++++-----
 net/bridge/br_mdb.c        | 16 ++++++++--------
 net/bridge/br_multicast.c  | 26 +++++++++++++-------------
 4 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 4fb9c4954f3a..556caed00258 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -25,7 +25,7 @@ struct br_ip {
 #if IS_ENABLED(CONFIG_IPV6)
 		struct in6_addr ip6;
 #endif
-	} u;
+	} dst;
 	__be16		proto;
 	__u16           vid;
 };
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 1622c3f5898f..2317c0d69b58 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -220,7 +220,7 @@ static u8 batadv_mcast_mla_rtr_flags_bridge_get(struct batadv_priv *bat_priv,
 		 * address here, only IPv6 ones
 		 */
 		if (br_ip_entry->addr.proto == htons(ETH_P_IPV6) &&
-		    ipv6_addr_is_ll_all_routers(&br_ip_entry->addr.u.ip6))
+		    ipv6_addr_is_ll_all_routers(&br_ip_entry->addr.dst.ip6))
 			flags &= ~BATADV_MCAST_WANT_NO_RTR6;
 
 		list_del(&br_ip_entry->list);
@@ -608,11 +608,11 @@ static int batadv_mcast_mla_bridge_get(struct net_device *dev,
 				continue;
 
 			if (tvlv_flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES &&
-			    ipv4_is_local_multicast(br_ip_entry->addr.u.ip4))
+			    ipv4_is_local_multicast(br_ip_entry->addr.dst.ip4))
 				continue;
 
 			if (!(tvlv_flags & BATADV_MCAST_WANT_NO_RTR4) &&
-			    !ipv4_is_local_multicast(br_ip_entry->addr.u.ip4))
+			    !ipv4_is_local_multicast(br_ip_entry->addr.dst.ip4))
 				continue;
 		}
 
@@ -622,11 +622,11 @@ static int batadv_mcast_mla_bridge_get(struct net_device *dev,
 				continue;
 
 			if (tvlv_flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES &&
-			    ipv6_addr_is_ll_all_nodes(&br_ip_entry->addr.u.ip6))
+			    ipv6_addr_is_ll_all_nodes(&br_ip_entry->addr.dst.ip6))
 				continue;
 
 			if (!(tvlv_flags & BATADV_MCAST_WANT_NO_RTR6) &&
-			    IPV6_ADDR_MC_SCOPE(&br_ip_entry->addr.u.ip6) >
+			    IPV6_ADDR_MC_SCOPE(&br_ip_entry->addr.dst.ip6) >
 			    IPV6_ADDR_SCOPE_LINKLOCAL)
 				continue;
 		}
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 269ffd2e549b..a1ff0a372185 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -70,10 +70,10 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
 	ip->vid = entry->vid;
 	ip->proto = entry->addr.proto;
 	if (ip->proto == htons(ETH_P_IP))
-		ip->u.ip4 = entry->addr.u.ip4;
+		ip->dst.ip4 = entry->addr.u.ip4;
 #if IS_ENABLED(CONFIG_IPV6)
 	else
-		ip->u.ip6 = entry->addr.u.ip6;
+		ip->dst.ip6 = entry->addr.u.ip6;
 #endif
 }
 
@@ -158,10 +158,10 @@ static int __mdb_fill_info(struct sk_buff *skb,
 	e.ifindex = ifindex;
 	e.vid = mp->addr.vid;
 	if (mp->addr.proto == htons(ETH_P_IP))
-		e.addr.u.ip4 = mp->addr.u.ip4;
+		e.addr.u.ip4 = mp->addr.dst.ip4;
 #if IS_ENABLED(CONFIG_IPV6)
 	if (mp->addr.proto == htons(ETH_P_IPV6))
-		e.addr.u.ip6 = mp->addr.u.ip6;
+		e.addr.u.ip6 = mp->addr.dst.ip6;
 #endif
 	e.addr.proto = mp->addr.proto;
 	nest_ent = nla_nest_start_noflag(skb,
@@ -474,10 +474,10 @@ static void br_mdb_switchdev_host_port(struct net_device *dev,
 	};
 
 	if (mp->addr.proto == htons(ETH_P_IP))
-		ip_eth_mc_map(mp->addr.u.ip4, mdb.addr);
+		ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
 #if IS_ENABLED(CONFIG_IPV6)
 	else
-		ipv6_eth_mc_map(&mp->addr.u.ip6, mdb.addr);
+		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
 #endif
 
 	mdb.obj.orig_dev = dev;
@@ -520,10 +520,10 @@ void br_mdb_notify(struct net_device *dev,
 
 	if (pg) {
 		if (mp->addr.proto == htons(ETH_P_IP))
-			ip_eth_mc_map(mp->addr.u.ip4, mdb.addr);
+			ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
 #if IS_ENABLED(CONFIG_IPV6)
 		else
-			ipv6_eth_mc_map(&mp->addr.u.ip6, mdb.addr);
+			ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
 #endif
 		mdb.obj.orig_dev = pg->port->dev;
 		switch (type) {
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index a899c22c8f57..e1fb822b9ddb 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -86,7 +86,7 @@ static struct net_bridge_mdb_entry *br_mdb_ip4_get(struct net_bridge *br,
 	struct br_ip br_dst;
 
 	memset(&br_dst, 0, sizeof(br_dst));
-	br_dst.u.ip4 = dst;
+	br_dst.dst.ip4 = dst;
 	br_dst.proto = htons(ETH_P_IP);
 	br_dst.vid = vid;
 
@@ -101,7 +101,7 @@ static struct net_bridge_mdb_entry *br_mdb_ip6_get(struct net_bridge *br,
 	struct br_ip br_dst;
 
 	memset(&br_dst, 0, sizeof(br_dst));
-	br_dst.u.ip6 = *dst;
+	br_dst.dst.ip6 = *dst;
 	br_dst.proto = htons(ETH_P_IPV6);
 	br_dst.vid = vid;
 
@@ -126,11 +126,11 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		ip.u.ip4 = ip_hdr(skb)->daddr;
+		ip.dst.ip4 = ip_hdr(skb)->daddr;
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		ip.u.ip6 = ipv6_hdr(skb)->daddr;
+		ip.dst.ip6 = ipv6_hdr(skb)->daddr;
 		break;
 #endif
 	default:
@@ -625,9 +625,9 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 
 	switch (group->proto) {
 	case htons(ETH_P_IP):
-		ip4_dst = ip_dst ? ip_dst->u.ip4 : htonl(INADDR_ALLHOSTS_GROUP);
+		ip4_dst = ip_dst ? ip_dst->dst.ip4 : htonl(INADDR_ALLHOSTS_GROUP);
 		return br_ip4_multicast_alloc_query(br, pg,
-						    ip4_dst, group->u.ip4,
+						    ip4_dst, group->dst.ip4,
 						    with_srcs, over_lmqt,
 						    sflag, igmp_type,
 						    need_rexmit);
@@ -636,13 +636,13 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 		struct in6_addr ip6_dst;
 
 		if (ip_dst)
-			ip6_dst = ip_dst->u.ip6;
+			ip6_dst = ip_dst->dst.ip6;
 		else
 			ipv6_addr_set(&ip6_dst, htonl(0xff020000), 0, 0,
 				      htonl(1));
 
 		return br_ip6_multicast_alloc_query(br, pg,
-						    &ip6_dst, &group->u.ip6,
+						    &ip6_dst, &group->dst.ip6,
 						    with_srcs, over_lmqt,
 						    sflag, igmp_type,
 						    need_rexmit);
@@ -906,7 +906,7 @@ static int br_ip4_multicast_add_group(struct net_bridge *br,
 		return 0;
 
 	memset(&br_group, 0, sizeof(br_group));
-	br_group.u.ip4 = group;
+	br_group.dst.ip4 = group;
 	br_group.proto = htons(ETH_P_IP);
 	br_group.vid = vid;
 	filter_mode = igmpv2 ? MCAST_EXCLUDE : MCAST_INCLUDE;
@@ -930,7 +930,7 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 		return 0;
 
 	memset(&br_group, 0, sizeof(br_group));
-	br_group.u.ip6 = *group;
+	br_group.dst.ip6 = *group;
 	br_group.proto = htons(ETH_P_IPV6);
 	br_group.vid = vid;
 	filter_mode = mldv1 ? MCAST_EXCLUDE : MCAST_INCLUDE;
@@ -1079,7 +1079,7 @@ static void br_multicast_send_query(struct net_bridge *br,
 	    !br_opt_get(br, BROPT_MULTICAST_QUERIER))
 		return;
 
-	memset(&br_group.u, 0, sizeof(br_group.u));
+	memset(&br_group.dst, 0, sizeof(br_group.dst));
 
 	if (port ? (own_query == &port->ip4_own_query) :
 		   (own_query == &br->ip4_own_query)) {
@@ -2506,7 +2506,7 @@ static void br_ip4_multicast_leave_group(struct net_bridge *br,
 	own_query = port ? &port->ip4_own_query : &br->ip4_own_query;
 
 	memset(&br_group, 0, sizeof(br_group));
-	br_group.u.ip4 = group;
+	br_group.dst.ip4 = group;
 	br_group.proto = htons(ETH_P_IP);
 	br_group.vid = vid;
 
@@ -2530,7 +2530,7 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
 	own_query = port ? &port->ip6_own_query : &br->ip6_own_query;
 
 	memset(&br_group, 0, sizeof(br_group));
-	br_group.u.ip6 = *group;
+	br_group.dst.ip6 = *group;
 	br_group.proto = htons(ETH_P_IPV6);
 	br_group.vid = vid;
 
-- 
2.25.4

