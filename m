Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDA5377737
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 17:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhEIPS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 11:18:59 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59855 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhEIPS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 11:18:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3B23F5C00F4;
        Sun,  9 May 2021 11:17:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 09 May 2021 11:17:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=uMxsj8c5T7TuaPTe38OsxiuWz9tnuh4V9yD0unYn6jA=; b=C/NjcnG/
        Da75ioM4lI4gWW77Sswdv2okpJCn3clwP3e0NQR4laC6c4cJSXIuuxXUD0BE70G3
        f82c6GtWFTJzL0LmAcJhrzgoTTaEBD6x5K0WUM/s51dKq/bfCOmfdoYuGl0CEpdq
        LUvZxhN9IV5Mhbl2QGiGh+kGsxFaJZDozLdvjFyogOLXUwv8WNhCnCk5bUFDDTKc
        P1L30ZHRx7ggup9DGLkgw/EEdz90w0CxfXs6UGTaf4SQaCJXG7aQTo02tqcrVUrS
        8BYOj/5sOZ5cUm8AvI23I8ITN2epZrcf9KGTDOHCElqv2DwiF6h/rjQgE84eSoOc
        0GMGzhyutusv0g==
X-ME-Sender: <xms:If2XYDhnHIuFGJX6gJk1r_AmZvTW2bblaTEBZ_T5nC60bpio-5gCBA>
    <xme:If2XYABfar-8s7sVj50BT2tK3mRUioIGGRUdk4Dj7Zg-nDfwM6aonBvVVNPUSILb4
    jMaEAiMZe6vneg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:If2XYDHLBJ1_rg5i0PdwC5H-WB6caTWoJZWOBkXhykARdI63Hf2zdg>
    <xmx:If2XYAT2pz2tumeGEVCFxrexe-vMi0ZLVbqLdkb_24e5mz5v9USDeQ>
    <xmx:If2XYAwcf6cHKi1DOop9ysjnJxP5xKtzqCC4DxKilpu8DXLVPFhnCw>
    <xmx:If2XYHkK0vvR61-rT5t8fIZ4NttCS4uo-A2KrRw5UJk-mo0t8Cn4Aw>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 11:17:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 06/10] ipv6: Add a sysctl to control multipath hash fields
Date:   Sun,  9 May 2021 18:16:11 +0300
Message-Id: <20210509151615.200608-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509151615.200608-1-idosch@idosch.org>
References: <20210509151615.200608-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

A subsequent patch will add a new multipath hash policy where the packet
fields used for multipath hash calculation are determined by user space.
This patch adds a sysctl that allows user space to set these fields.

The packet fields are represented using a bitmask and are common between
IPv4 and IPv6 to allow user space to use the same numbering across both
protocols. For example, to hash based on standard 5-tuple:

 # sysctl -w net.ipv6.fib_multipath_hash_fields=0x0037
 net.ipv6.fib_multipath_hash_fields = 0x0037

To avoid introducing holes in 'struct netns_sysctl_ipv6', move the
'bindv6only' field after the multipath hash fields.

The kernel rejects unknown fields, for example:

 # sysctl -w net.ipv6.fib_multipath_hash_fields=0x1000
 sysctl: setting key "net.ipv6.fib_multipath_hash_fields": Invalid argument

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 27 ++++++++++++++++++++++++++
 include/net/ipv6.h                     |  8 ++++++++
 include/net/netns/ipv6.h               |  3 ++-
 net/ipv6/ip6_fib.c                     |  5 +++++
 net/ipv6/sysctl_net_ipv6.c             | 11 +++++++++++
 5 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 2c3b7677222e..f7ae65524ff3 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1773,6 +1773,33 @@ fib_multipath_hash_policy - INTEGER
 	- 1 - Layer 4 (standard 5-tuple)
 	- 2 - Layer 3 or inner Layer 3 if present
 
+fib_multipath_hash_fields - UNSIGNED INTEGER
+	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
+	fields used for multipath hash calculation are determined by this
+	sysctl.
+
+	This value is a bitmask which enables various fields for multipath hash
+	calculation.
+
+	Possible fields are:
+
+	====== ============================
+	0x0001 Source IP address
+	0x0002 Destination IP address
+	0x0004 IP protocol
+	0x0008 Flow Label
+	0x0010 Source port
+	0x0020 Destination port
+	0x0040 Inner source IP address
+	0x0080 Inner destination IP address
+	0x0100 Inner IP protocol
+	0x0200 Inner Flow Label
+	0x0400 Inner source port
+	0x0800 Inner destination port
+	====== ============================
+
+	Default: 0x0007 (source IP, destination IP and IP protocol)
+
 anycast_src_echo_reply - BOOLEAN
 	Controls the use of anycast addresses as source addresses for ICMPv6
 	echo reply
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 448bf2b34759..f2d0ecc257bb 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -926,11 +926,19 @@ static inline int ip6_multipath_hash_policy(const struct net *net)
 {
 	return net->ipv6.sysctl.multipath_hash_policy;
 }
+static inline u32 ip6_multipath_hash_fields(const struct net *net)
+{
+	return net->ipv6.sysctl.multipath_hash_fields;
+}
 #else
 static inline int ip6_multipath_hash_policy(const struct net *net)
 {
 	return 0;
 }
+static inline u32 ip6_multipath_hash_fields(const struct net *net)
+{
+	return 0;
+}
 #endif
 
 /*
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 6153c8067009..bde0b7adb4a3 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -28,8 +28,9 @@ struct netns_sysctl_ipv6 {
 	int ip6_rt_gc_elasticity;
 	int ip6_rt_mtu_expires;
 	int ip6_rt_min_advmss;
-	u8 bindv6only;
+	u32 multipath_hash_fields;
 	u8 multipath_hash_policy;
+	u8 bindv6only;
 	u8 flowlabel_consistency;
 	u8 auto_flowlabels;
 	int icmpv6_time;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 33d2d6a4e28c..2d650dc24349 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -32,6 +32,7 @@
 #include <net/lwtunnel.h>
 #include <net/fib_notifier.h>
 
+#include <net/ip_fib.h>
 #include <net/ip6_fib.h>
 #include <net/ip6_route.h>
 
@@ -2355,6 +2356,10 @@ static int __net_init fib6_net_init(struct net *net)
 	if (err)
 		return err;
 
+	/* Default to 3-tuple */
+	net->ipv6.sysctl.multipath_hash_fields =
+		FIB_MULTIPATH_HASH_FIELD_DEFAULT_MASK;
+
 	spin_lock_init(&net->ipv6.fib6_gc_lock);
 	rwlock_init(&net->ipv6.fib6_walker_lock);
 	INIT_LIST_HEAD(&net->ipv6.fib6_walkers);
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 27102c3d6e1d..fb73d9839bc8 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -17,6 +17,7 @@
 #include <net/addrconf.h>
 #include <net/inet_frag.h>
 #include <net/netevent.h>
+#include <net/ip_fib.h>
 #ifdef CONFIG_NETLABEL
 #include <net/calipso.h>
 #endif
@@ -24,6 +25,8 @@
 static int two = 2;
 static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
+static u32 rt6_multipath_hash_fields_all_mask =
+	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
 
 static int proc_rt6_multipath_hash_policy(struct ctl_table *table, int write,
 					  void *buffer, size_t *lenp, loff_t *ppos)
@@ -151,6 +154,14 @@ static struct ctl_table ipv6_table_template[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "fib_multipath_hash_fields",
+		.data		= &init_net.ipv6.sysctl.multipath_hash_fields,
+		.maxlen		= sizeof(u32),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra2		= &rt6_multipath_hash_fields_all_mask,
+	},
 	{
 		.procname	= "seg6_flowlabel",
 		.data		= &init_net.ipv6.sysctl.seg6_flowlabel,
-- 
2.31.1

