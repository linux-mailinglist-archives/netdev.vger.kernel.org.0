Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1BC3122AB
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBGI3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:29:07 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:44279 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230086AbhBGIYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:24:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 84F705801D2;
        Sun,  7 Feb 2021 03:23:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Feb 2021 03:23:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=b3cTFORZWU8PMzUw84BHRflv9GB4zEryRADwEl/F9AU=; b=jHzfjx39
        h2x8eKdwrPbSUpDcceQh7CDRJ+cg0w1H4pEuiGR0hOYGrhQp9H4bxRETk1hmoHgp
        bUmfLb7U9uE8jWZt/yGn3rH3lFMgLXFTBMjcn3h08b5YPc/51/+wJqPIf8jm2dUk
        USp9Oo+0Hhnmxv6GLt7ZBoZfzXZM+ghzyjBjgVfma1wHhJkeQzYj5GTYJKT+T/G8
        Klst94NQA5IW0DFYXQn/14oswsKqdnEdu3S/a7hMs0NQBi6sIJo/O4x6cUeAZHDo
        aHpQyDqfUblbvkZK46Ess7kWTZPx6TkVmfIEM+PIVuR0XJZcA+568nGJJzGEzgpM
        9YOVCSlBeRo25g==
X-ME-Sender: <xms:j6MfYD9yjNWm6SrUkkmZdn_DXI_MUYsOp58noVYlZNbwFy5CIrA7Jg>
    <xme:j6MfYPtae1crj71BGkZ3rSWPg9TQpdAchgbJAyftt9QquvyxejzX04YzkUfOxHNNh
    UZYRqOzIN7ry5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:j6MfYBCXB5T-fDU4bW9B0KQ63kl2tl7P7jtTU1qaO6faYZtO7kDQTw>
    <xmx:j6MfYPcdl0DLUXOwgtytV_TwRcQGqlJluG4_VGxYdr2JpSPgqmiv0A>
    <xmx:j6MfYINwO1OCLtMpYAazzDtWGLiGdnRkto5-lAyv2N6qpteqksoiVA>
    <xmx:j6MfYJhjClCXtSWnQKvRQL2SbGRVU6Ndh6D2A5vPqIN_1P13T9wGRA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D58971080057;
        Sun,  7 Feb 2021 03:23:40 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/10] IPv6: Add "offload failed" indication to routes
Date:   Sun,  7 Feb 2021 10:22:52 +0200
Message-Id: <20210207082258.3872086-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207082258.3872086-1-idosch@idosch.org>
References: <20210207082258.3872086-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

After installing a route to the kernel, user space receives an
acknowledgment, which means the route was installed in the kernel, but not
necessarily in hardware.

The asynchronous nature of route installation in hardware can lead to a
routing daemon advertising a route before it was actually installed in
hardware. This can result in packet loss or mis-routed packets until the
route is installed in hardware.

To avoid such cases, previous patch set added the ability to emit
RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
are changed, this behavior is controlled by sysctl.

With the above mentioned behavior, it is possible to know from user-space
if the route was offloaded, but if the offload fails there is no indication
to user-space. Following a failure, a routing daemon will wait indefinitely
for a notification that will never come.

This patch adds an "offload_failed" indication to IPv6 routes, so that
users will have better visibility into the offload process.

'struct fib6_info' is extended with new field that indicates if route
offload failed. Note that the new field is added using unused bit and
therefore there is no need to increase struct size.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 ++--
 drivers/net/netdevsim/fib.c                           | 2 +-
 include/net/ip6_fib.h                                 | 5 +++--
 net/ipv6/route.c                                      | 8 ++++++--
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index ac9a174372cc..a5f980b6940e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5008,7 +5008,7 @@ mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 				  common);
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list)
 		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), mlxsw_sp_rt6->rt,
-				       should_offload, !should_offload);
+				       should_offload, !should_offload, false);
 }
 #else
 static void
@@ -5030,7 +5030,7 @@ mlxsw_sp_fib6_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 				  common);
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list)
 		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), mlxsw_sp_rt6->rt,
-				       false, false);
+				       false, false, false);
 }
 #else
 static void
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index ca19da169853..6b1ec3b4750c 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -595,7 +595,7 @@ static void nsim_fib6_rt_hw_flags_set(struct nsim_fib_data *data,
 	struct nsim_fib6_rt_nh *fib6_rt_nh;
 
 	list_for_each_entry(fib6_rt_nh, &fib6_rt->nh_list, list)
-		fib6_info_hw_flags_set(net, fib6_rt_nh->rt, false, trap);
+		fib6_info_hw_flags_set(net, fib6_rt_nh->rt, false, trap, false);
 }
 #else
 static void nsim_fib6_rt_hw_flags_set(struct nsim_fib_data *data,
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 1e262b23c68b..15b7fbe6b15c 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -195,7 +195,8 @@ struct fib6_info {
 					fib6_destroying:1,
 					offload:1,
 					trap:1,
-					unused:2;
+					offload_failed:1,
+					unused:1;
 
 	struct rcu_head			rcu;
 	struct nexthop			*nh;
@@ -539,7 +540,7 @@ static inline bool fib6_metric_locked(struct fib6_info *f6i, int metric)
 	return !!(f6i->fib6_metrics->metrics[RTAX_LOCK - 1] & (1 << metric));
 }
 void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
-			    bool offload, bool trap);
+			    bool offload, bool trap, bool offload_failed);
 
 #if IS_BUILTIN(CONFIG_IPV6) && defined(CONFIG_BPF_SYSCALL)
 struct bpf_iter__ipv6_route {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0d1784b0d65d..bc75b705f54b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5619,6 +5619,8 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 			rtm->rtm_flags |= RTM_F_OFFLOAD;
 		if (rt->trap)
 			rtm->rtm_flags |= RTM_F_TRAP;
+		if (rt->offload_failed)
+			rtm->rtm_flags |= RTM_F_OFFLOAD_FAILED;
 	}
 
 	if (rtnl_put_cacheinfo(skb, dst, 0, expires, dst ? dst->error : 0) < 0)
@@ -6070,16 +6072,18 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 }
 
 void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
-			    bool offload, bool trap)
+			    bool offload, bool trap, bool offload_failed)
 {
 	struct sk_buff *skb;
 	int err;
 
-	if (f6i->offload == offload && f6i->trap == trap)
+	if (f6i->offload == offload && f6i->trap == trap &&
+	    f6i->offload_failed == offload_failed)
 		return;
 
 	f6i->offload = offload;
 	f6i->trap = trap;
+	f6i->offload_failed = offload_failed;
 
 	if (!rcu_access_pointer(f6i->fib6_node))
 		/* The route was removed from the tree, do not send
-- 
2.29.2

