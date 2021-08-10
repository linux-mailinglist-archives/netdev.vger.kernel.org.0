Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB523E7C4E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243078AbhHJPa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243049AbhHJPaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:30:21 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67893C061799
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:59 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id f9-20020a05600c1549b029025b0f5d8c6cso2249880wmg.4
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T8/4dj9gTvHCpwB5IlUq9PwSZ51kg1bcJ4gzNVJjnFg=;
        b=z0i3d+rdvfy/LfTsEd0Cx2oQl8SSKqWVKoIyyhERUZ9JRA8r+gqF5xTO1oYKwook92
         voqqtbNyq7m1UswCT3wLGgrAfUx2J2d/GUWXbLKrSiGZfGjnn8++YCvyBiYjHIjD4zo8
         qTvQqUG9NKtqneo9KxzUW+yOD+Bi+Ot9QNbcpn2fFO/JjzMo5O1Ux/+EtSkVWs/tUhyF
         zdn8mTDnCPqQjvgicGrMgIL+RgaOSqFDxBXBBAlkau8sfjP5gxcrLziwikWwXAzwqZ6t
         o9EBz9DXXDY+AAfPLBmksE8pxBXcYn6lo6GGXDo/uO2z2V7JOcdK82PkXM6jeLhx/ACZ
         UJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8/4dj9gTvHCpwB5IlUq9PwSZ51kg1bcJ4gzNVJjnFg=;
        b=LFeuQBC7IJaFH9nvBakCrnHX5SqseuoRb21+8aj319wmSTGURxRq19WTvK0zhxtFLg
         c97yNUXGRjFPlA5xEoDUmFKXhDVrvzCPftFxat6PVCxTzYh6tohwRaLMCOHEZRUd6H96
         4Uw6mQahzG/e5efUp0Yfi1UdQBHMUQu3wY8IhM+7H4pleIEY1mWBvLlvGeKfHyLAprCA
         VLSTNZCv83aFtDS0qMVrEZ3XkxoQ7YkahEVxqbrJbDEdi3RfNdXZMeICkU+0eQs7Pv12
         YFwFR3NhZrM5Pc5eWSGq+1CigM/lJZ5dYP0Ckyg5jW7pnri/ta1haCd21eGLsWHZH97+
         qMQQ==
X-Gm-Message-State: AOAM531zYC5jBO3pBfR2nXhhhKM3+WYJ6dYca86stJm1DqQsFJZKWJ9L
        HEPnQ0J4MfYzdRkY0zPsOqgS3qF7qVYCZ1N/
X-Google-Smtp-Source: ABdhPJyNhT/PBctX6cq4Z+zWBn1L3GpMRbPpIbbCbYHBAnBz9acZT+DIAX+MMRYrHAaw5z0CUm3Iow==
X-Received: by 2002:a1c:f414:: with SMTP id z20mr5513421wma.94.1628609397734;
        Tue, 10 Aug 2021 08:29:57 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm22848219wrp.12.2021.08.10.08.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:29:57 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 13/15] net: bridge: vlan: add support for mcast router global option
Date:   Tue, 10 Aug 2021 18:29:31 +0300
Message-Id: <20210810152933.178325-14-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810152933.178325-1-razor@blackwall.org>
References: <20210810152933.178325-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support to change and retrieve global vlan multicast router state
which is used for the bridge itself. We just need to pass multicast context
to br_multicast_set_router instead of bridge device and the rest of the
logic remains the same.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_multicast.c      | 11 +++++------
 net/bridge/br_netlink.c        |  3 ++-
 net/bridge/br_private.h        |  3 ++-
 net/bridge/br_sysfs_br.c       |  2 +-
 net/bridge/br_vlan_options.c   | 15 ++++++++++++++-
 6 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index ee691a0bc067..716ce30b3ca8 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -561,6 +561,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL,
 	BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL,
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER,
+	BRIDGE_VLANDB_GOPTS_MCAST_ROUTER,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index a780ad8aca37..df6bf6a237aa 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4053,17 +4053,16 @@ void br_multicast_dev_del(struct net_bridge *br)
 	rcu_barrier();
 }
 
-int br_multicast_set_router(struct net_bridge *br, unsigned long val)
+int br_multicast_set_router(struct net_bridge_mcast *brmctx, unsigned long val)
 {
-	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	int err = -EINVAL;
 
-	spin_lock_bh(&br->multicast_lock);
+	spin_lock_bh(&brmctx->br->multicast_lock);
 
 	switch (val) {
 	case MDB_RTR_TYPE_DISABLED:
 	case MDB_RTR_TYPE_PERM:
-		br_mc_router_state_change(br, val == MDB_RTR_TYPE_PERM);
+		br_mc_router_state_change(brmctx->br, val == MDB_RTR_TYPE_PERM);
 		del_timer(&brmctx->ip4_mc_router_timer);
 #if IS_ENABLED(CONFIG_IPV6)
 		del_timer(&brmctx->ip6_mc_router_timer);
@@ -4073,13 +4072,13 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
 		break;
 	case MDB_RTR_TYPE_TEMP_QUERY:
 		if (brmctx->multicast_router != MDB_RTR_TYPE_TEMP_QUERY)
-			br_mc_router_state_change(br, false);
+			br_mc_router_state_change(brmctx->br, false);
 		brmctx->multicast_router = val;
 		err = 0;
 		break;
 	}
 
-	spin_unlock_bh(&br->multicast_lock);
+	spin_unlock_bh(&brmctx->br->multicast_lock);
 
 	return err;
 }
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 1d8ff9bbbd2f..93a517410671 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1349,7 +1349,8 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_MCAST_ROUTER]) {
 		u8 multicast_router = nla_get_u8(data[IFLA_BR_MCAST_ROUTER]);
 
-		err = br_multicast_set_router(br, multicast_router);
+		err = br_multicast_set_router(&br->multicast_ctx,
+					      multicast_router);
 		if (err)
 			return err;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 76adb729e58c..f5af6b56be8f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -890,7 +890,7 @@ void br_multicast_dev_del(struct net_bridge *br);
 void br_multicast_flood(struct net_bridge_mdb_entry *mdst, struct sk_buff *skb,
 			struct net_bridge_mcast *brmctx,
 			bool local_rcv, bool local_orig);
-int br_multicast_set_router(struct net_bridge *br, unsigned long val);
+int br_multicast_set_router(struct net_bridge_mcast *brmctx, unsigned long val);
 int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val);
 int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 			struct netlink_ext_ack *extack);
@@ -1204,6 +1204,7 @@ br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 	       brmctx1->multicast_startup_query_interval ==
 	       brmctx2->multicast_startup_query_interval &&
 	       brmctx1->multicast_querier == brmctx2->multicast_querier &&
+	       brmctx1->multicast_router == brmctx2->multicast_router &&
 #if IS_ENABLED(CONFIG_IPV6)
 	       brmctx1->multicast_mld_version ==
 	       brmctx2->multicast_mld_version &&
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index e1234bd8d5a0..d9a89ddd0331 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -390,7 +390,7 @@ static ssize_t multicast_router_show(struct device *d,
 static int set_multicast_router(struct net_bridge *br, unsigned long val,
 				struct netlink_ext_ack *extack)
 {
-	return br_multicast_set_router(br, val);
+	return br_multicast_set_router(&br->multicast_ctx, val);
 }
 
 static ssize_t multicast_router_store(struct device *d,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 0d0db8ddae45..6ba45b73931f 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -296,7 +296,9 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 	    nla_put_u32(skb, BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT,
 			v_opts->br_mcast_ctx.multicast_startup_query_count) ||
 	    nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_QUERIER,
-		       v_opts->br_mcast_ctx.multicast_querier))
+		       v_opts->br_mcast_ctx.multicast_querier) ||
+	    nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_ROUTER,
+		       v_opts->br_mcast_ctx.multicast_router))
 		goto out_err;
 
 	clockval = jiffies_to_clock_t(v_opts->br_mcast_ctx.multicast_last_member_interval);
@@ -358,6 +360,7 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(void)
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL */
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL */
 		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERIER */
+		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER */
 #endif
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
@@ -497,6 +500,15 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 			return err;
 		*changed = true;
 	}
+	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_ROUTER]) {
+		u8 val;
+
+		val = nla_get_u8(tb[BRIDGE_VLANDB_GOPTS_MCAST_ROUTER]);
+		err = br_multicast_set_router(&v->br_mcast_ctx, val);
+		if (err)
+			return err;
+		*changed = true;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
 		u8 ver;
@@ -520,6 +532,7 @@ static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER]	= { .type = NLA_U8 },
+	[BRIDGE_VLANDB_GOPTS_MCAST_ROUTER]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT]	= { .type = NLA_U32 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT]	= { .type = NLA_U32 },
-- 
2.31.1

