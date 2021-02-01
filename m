Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C65330B0D6
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhBATwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:52:51 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:42651 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232830AbhBATwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:52:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id CF80658050D;
        Mon,  1 Feb 2021 14:48:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 14:48:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=+lWoQT5XNEZ4fTxttEVbaXY/68CwGOEy0JypdjT014M=; b=cGI3RhdI
        KSdleJ+x6Lz68OlYszzRnOkoqOWKpndrUsJ0+UD3/jB3hCuCFoRTxDpOegKHWaue
        khD94ZpEnoWugUNqDSuYdH6jfuPCyMVYfMI/6nulYqwdHvjcmFJCAF/fyT8hk5xP
        Aaqr39sPvnzGRtqX/aZuH1x34wIepY/SYqV3Ht4+uodVYWyGY13oxMXoKeaztuOg
        AcSO5wz2NxXwXTptWQoQtNYu0+4EOrcydpY3fw7uFvqqY67FRtPE/rfRQg9DlNQ1
        4uQuGv3KTWSU30Oqaqq96P+tf1SBc5X00H+4okdMC2fYP6Fz267y9S2ayLG3glzu
        yZy8IVtChFKi9w==
X-ME-Sender: <xms:JFsYYABgSfH7_8s5uEkwdAbB-Vpe9aVgCvkIZIGrLX1HaSGS5EVN4A>
    <xme:JFsYYCj8c3DqcSr1at9lKQNbCaQFy0kBh8SHo5r8q_Nsv0RVJEmJA1Kztz8-9qtVn
    PtZ365ZJnLRJ5k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:JFsYYDmlLjKxxp2VgYuwAxhUBbw3XQ7t-iZQ19L5f64YeuVqbjS9kg>
    <xmx:JFsYYGz7vEnUSfyS-mIcCedi4xqq_35bRpvGqYzp6yzS6-0L1KQvYQ>
    <xmx:JFsYYFTZLds7zEo3pFlxYJKvGvVOtEpD4RWe-Y9Fpiyo3fkGFSySfg>
    <xmx:JFsYYAFOpZDEVICgtwpEM3839WmSwHdhpQiNPMm30VPXw0lA6BOVwg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 523D624005C;
        Mon,  1 Feb 2021 14:48:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@nvidia.com, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 05/10] net: ipv4: Emit notification when fib hardware flags are changed
Date:   Mon,  1 Feb 2021 21:47:52 +0200
Message-Id: <20210201194757.3463461-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201194757.3463461-1-idosch@idosch.org>
References: <20210201194757.3463461-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

After installing a route to the kernel, user space receives an
acknowledgment, which means the route was installed in the kernel,
but not necessarily in hardware.

The asynchronous nature of route installation in hardware can lead to a
routing daemon advertising a route before it was actually installed in
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

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Acked-by: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 20 +++++++++++++++++++
 include/net/netns/ipv4.h               |  2 ++
 net/ipv4/af_inet.c                     |  2 ++
 net/ipv4/fib_trie.c                    | 27 ++++++++++++++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 5 files changed, 60 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index f0353fb751d1..06568aceb223 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -178,6 +178,26 @@ min_adv_mss - INTEGER
 	The advertised MSS depends on the first hop route MTU, but will
 	never be lower than this setting.
 
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
 IP Fragmentation:
 
 ipfrag_high_thresh - LONG INTEGER
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 8e4fcac4df72..70a2a085dd1a 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -188,6 +188,8 @@ struct netns_ipv4 {
 	int sysctl_udp_wmem_min;
 	int sysctl_udp_rmem_min;
 
+	int sysctl_fib_notify_on_flag_change;
+
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	int sysctl_udp_l3mdev_accept;
 #endif
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b94fa8eb831b..ab42f6404fc6 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1871,6 +1871,8 @@ static __net_init int inet_init_net(struct net *net)
 	net->ipv4.sysctl_igmp_llm_reports = 1;
 	net->ipv4.sysctl_igmp_qrv = 2;
 
+	net->ipv4.sysctl_fib_notify_on_flag_change = 0;
+
 	return 0;
 }
 
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 28117c05dc35..60559b708158 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1038,6 +1038,8 @@ fib_find_matching_alias(struct net *net, const struct fib_rt_info *fri)
 void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 {
 	struct fib_alias *fa_match;
+	struct sk_buff *skb;
+	int err;
 
 	rcu_read_lock();
 
@@ -1045,9 +1047,34 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 	if (!fa_match)
 		goto out;
 
+	if (fa_match->offload == fri->offload && fa_match->trap == fri->trap)
+		goto out;
+
 	fa_match->offload = fri->offload;
 	fa_match->trap = fri->trap;
 
+	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
+		goto out;
+
+	skb = nlmsg_new(fib_nlmsg_size(fa_match->fa_info), GFP_ATOMIC);
+	if (!skb) {
+		err = -ENOBUFS;
+		goto errout;
+	}
+
+	err = fib_dump_info(skb, 0, 0, RTM_NEWROUTE, fri, 0);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(skb);
+		goto errout;
+	}
+
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_ROUTE, NULL, GFP_ATOMIC);
+	goto out;
+
+errout:
+	rtnl_set_sk_err(net, RTNLGRP_IPV4_ROUTE, err);
 out:
 	rcu_read_unlock();
 }
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 3e5f4f2e705e..e5798b3b59d2 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1354,6 +1354,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ONE
 	},
+	{
+		.procname	= "fib_notify_on_flag_change",
+		.data		= &init_net.ipv4.sysctl_fib_notify_on_flag_change,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{ }
 };
 
-- 
2.29.2

