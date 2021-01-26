Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5B7304042
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405864AbhAZO1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:27:32 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:51585 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391710AbhAZN0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:26:08 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 97D819AF;
        Tue, 26 Jan 2021 08:24:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 26 Jan 2021 08:24:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=8frFZwEXu5e5HgRPoUIoQ1qXcZtGMcP/vAqCuSVD2p0=; b=fdEUV04Y
        BU6m5lQEPl9gjeZzQep2CvcOl4gNuM/eVhal8NPFkVKKFM1ioGZmzyoCICQpV8s0
        6IDrTDngLkMQq1XY/uJh5rwQc/jz+AdjRhvdiM0ifSfm5hzn3q7asfGfeJgPRNCN
        wj2k33mpOETKPHNKBSvLD6Gd3K8tXRcYD5VlhuUdvsLZak3W5xXOC9EpNEkUKXwd
        NGomNI6aHcE6qE94L+h/X9k0HQYxY3LwydwV4avVCBZCZGKqM4qZNDcGwGMMwYLG
        z50hKz17L6xCwXnBkqHTAlAQoJu/lSsK6WtAeiMaq8RsuM1UBIp+v9VdcWVnqwgq
        KgwItLCfpoMrVg==
X-ME-Sender: <xms:ERgQYFLFqnT3gWlguHXQac9UY0SvJSb1h5cZiGKA7lltpl-Aqx7oFg>
    <xme:ERgQYBExC4Y5NJ66sQtJe8pw9xO3GhGSvO2QMAqPtUi4v_maKdlO8aepHOXhdUGwx
    DnPyUwbnsYpxPk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ERgQYKkfqrvWtpaumf4a3MAJqtwo3q37m7_YUo_oS3Ub3TkEW2CaHQ>
    <xmx:ERgQYOI9WD_B_QynkcrCejdALJ7IaL6YZFlWEmw7fDrmR4CwQ108gA>
    <xmx:ERgQYLZuglfJ6rzXjSFgYtH_34djXvD-e013AwWqvMfoNesb1JCO_Q>
    <xmx:ERgQYPc_nBwNEO7fdG-G1uhH42ij-rZg2178XAmzGV9wFVF3ig7zag>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D3A931080057;
        Tue, 26 Jan 2021 08:24:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/10] net: ipv6: Emit notification when fib hardware flags are changed
Date:   Tue, 26 Jan 2021 15:23:09 +0200
Message-Id: <20210126132311.3061388-9-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126132311.3061388-1-idosch@idosch.org>
References: <20210126132311.3061388-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

After installing a route to the kernel, user space receives an
acknowledgment, which means the route was installed in the kernel,
but not necessarily in hardware.

The asynchronous nature of route installation in hardware can lead
to a routing daemon advertising a route before it was actually installed in
hardware. This can result in packet loss or mis-routed packets until the
route is installed in hardware.

It is also possible for a route already installed in hardware to change
its action and therefore its flags. For example, a host route that is
trapping packets can be "promoted" to perform decapsulation following
the installation of an IPinIP/VXLAN tunnel.

Emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
are changed. The aim is to provide an indication to user-space
(e.g., routing daemons) about the state of the route in hardware.

Introduce a sysctl that controls this behavior.

Keep the default value at 0 (i.e., do not emit notifications) for several
reasons:
- Multiple RTM_NEWROUTE notification per-route might confuse existing
  routing daemons.
- Convergence reasons in routing daemons.
- The extra notifications will negatively impact the insertion rate.
- Not all users are interested in these notifications.

Move fib6_info_hw_flags_set() to C file because it is no longer a short
function.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 20 ++++++++++++
 include/net/ip6_fib.h                  | 10 ++----
 include/net/netns/ipv6.h               |  1 +
 net/ipv6/af_inet6.c                    |  1 +
 net/ipv6/route.c                       | 44 ++++++++++++++++++++++++++
 net/ipv6/sysctl_net_ipv6.c             |  9 ++++++
 6 files changed, 77 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 01927b36bbee..11f10b8f4a83 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1795,6 +1795,26 @@ nexthop_compat_mode - BOOLEAN
 	and extraneous notifications.
 	Default: true (backward compat mode)
 
+fib_notify_on_flag_change - INTEGER
+        Whether to emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/
+        RTM_F_TRAP flags are changed.
+
+        After installing a route to the kernel, user space receives an
+        acknowledgment, which means the route was installed in the kernel,
+        but not necessarily in hardware.
+        It is also possible for a route already installed in hardware to change
+        its action and therefore its flags. For example, a host route that is
+        trapping packets can be "promoted" to perform decapsulation following
+        the installation of an IPinIP/VXLAN tunnel.
+        The notifications will indicate to user-space the state of the route.
+
+        Default: 0 (Do not emit notifications.)
+
+        Possible values:
+
+        - 0 - Do not emit notifications.
+        - 1 - Emit notifications.
+
 IPv6 Fragmentation:
 
 ip6frag_high_thresh - INTEGER
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index cc189e668adf..1e262b23c68b 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -336,14 +336,6 @@ static inline void fib6_info_release(struct fib6_info *f6i)
 		call_rcu(&f6i->rcu, fib6_info_destroy_rcu);
 }
 
-static inline void
-fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i, bool offload,
-		       bool trap)
-{
-	f6i->offload = offload;
-	f6i->trap = trap;
-}
-
 enum fib6_walk_state {
 #ifdef CONFIG_IPV6_SUBTREES
 	FWS_S,
@@ -546,6 +538,8 @@ static inline bool fib6_metric_locked(struct fib6_info *f6i, int metric)
 {
 	return !!(f6i->fib6_metrics->metrics[RTAX_LOCK - 1] & (1 << metric));
 }
+void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
+			    bool offload, bool trap);
 
 #if IS_BUILTIN(CONFIG_IPV6) && defined(CONFIG_BPF_SYSCALL)
 struct bpf_iter__ipv6_route {
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 5ec054473d81..21c0debbd39e 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -51,6 +51,7 @@ struct netns_sysctl_ipv6 {
 	int max_hbh_opts_len;
 	int seg6_flowlabel;
 	bool skip_notify_on_dev_down;
+	int fib_notify_on_flag_change;
 };
 
 struct netns_ipv6 {
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 8e9c3e9ea36e..0e9994e0ecd7 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -954,6 +954,7 @@ static int __net_init inet6_net_init(struct net *net)
 	net->ipv6.sysctl.max_hbh_opts_cnt = IP6_DEFAULT_MAX_HBH_OPTS_CNT;
 	net->ipv6.sysctl.max_dst_opts_len = IP6_DEFAULT_MAX_DST_OPTS_LEN;
 	net->ipv6.sysctl.max_hbh_opts_len = IP6_DEFAULT_MAX_HBH_OPTS_LEN;
+	net->ipv6.sysctl.fib_notify_on_flag_change = 0;
 	atomic_set(&net->ipv6.fib6_sernum, 1);
 
 	err = ipv6_init_mibs(net);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 188e114b29b4..dcf28240541d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6063,6 +6063,50 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 		rtnl_set_sk_err(net, RTNLGRP_IPV6_ROUTE, err);
 }
 
+void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
+			    bool offload, bool trap)
+{
+	struct sk_buff *skb;
+	int err;
+
+	if (f6i->offload == offload && f6i->trap == trap)
+		return;
+
+	f6i->offload = offload;
+	f6i->trap = trap;
+
+	if (!rcu_access_pointer(f6i->fib6_node))
+		/* The route was removed from the tree, do not send
+		 * notfication.
+		 */
+		return;
+
+	if (!net->ipv6.sysctl.fib_notify_on_flag_change)
+		return;
+
+	skb = nlmsg_new(rt6_nlmsg_size(f6i), GFP_KERNEL);
+	if (!skb) {
+		err = -ENOBUFS;
+		goto errout;
+	}
+
+	err = rt6_fill_node(net, skb, f6i, NULL, NULL, NULL, 0, RTM_NEWROUTE, 0,
+			    0, 0);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in rt6_nlmsg_size() */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(skb);
+		goto errout;
+	}
+
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_ROUTE, NULL, GFP_KERNEL);
+	return;
+
+errout:
+	rtnl_set_sk_err(net, RTNLGRP_IPV6_ROUTE, err);
+}
+EXPORT_SYMBOL(fib6_info_hw_flags_set);
+
 static int ip6_route_dev_notify(struct notifier_block *this,
 				unsigned long event, void *ptr)
 {
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 5b60a4bdd36a..392ef01e3366 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -160,6 +160,15 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "fib_notify_on_flag_change",
+		.data		= &init_net.ipv6.sysctl.fib_notify_on_flag_change,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
 	{ }
 };
 
-- 
2.29.2

