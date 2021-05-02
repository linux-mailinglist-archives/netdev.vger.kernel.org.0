Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4D1370DEB
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 18:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhEBQZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 12:25:48 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52945 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhEBQZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 12:25:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 518115C012B;
        Sun,  2 May 2021 12:24:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 02 May 2021 12:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/oxXd2ccNvebZFYyMu6Dmty9S3Uu+511EGTvu/wp9Ng=; b=c2T+2y0w
        E6cDurwXPafzXfcEBAnoELbepwvsqbtKERNIls3Tsx7Zznw1yV5/hJ4ttHxtoFvE
        R14D8jIrvWOOwLk5HCZ3iNLgL4Gt2sqWtWCnpP/a2RGi6aiQeP9rZqwAojsd7r5U
        uNC3eDGOj/B9mEkDZuTYehXpZZuwvpSZFRnAI1z+haKrkln4fL1YTkF0mc/N2TV1
        ViXYTNVx2CLVi0gaJEjUNXbCJYHiCVJ3nKPIwjTx/0fZGUiSUx7NQBIXd6voG5k3
        rN5om+zw0/w9/ra6bPEXECF1K4Hmyq3bRfJKi6dRDyyU6qIJZ2Rs+9PsWFaHimb/
        L+9tdWqO46QwUA==
X-ME-Sender: <xms:WNKOYCEdCqZ2kPvkl2RwWHGbkh9i9G-1DjjIVy8CAIs5Erk1N9iNQg>
    <xme:WNKOYDUp3Ii1DqNR1MECihSy6wx4Umal2Yw_bdCSelFVmOKavBaeObdzFMQhEWhKv
    mBkUc0xM_snhDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefvddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:WNKOYMKB__xK5lR07LynKWBYO3HQK7DB-q9EPAYeNWEAH-To4UtSVw>
    <xmx:WNKOYMH3GWeSrPIS7-zp01JUvECEN9O1PbB-eiTRSZPTd80lDJM77g>
    <xmx:WNKOYIWn1ToD9skSJWTc6uHmFAo0DAUbVx-9xeQmroxIQ0QOuR2p9Q>
    <xmx:WNKOYKIMLXuqW-tUE3oA6DCkQYb0r0_YMvfxp-IwK8aJprd8egR_rQ>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 12:24:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 06/10] ipv6: Add a sysctl to control multipath hash fields
Date:   Sun,  2 May 2021 19:22:53 +0300
Message-Id: <20210502162257.3472453-7-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502162257.3472453-1-idosch@idosch.org>
References: <20210502162257.3472453-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

A subsequent patch will add a new multipath hash policy where the packet
fields used for multipath hash calculation are determined by user space.
This patch adds a sysctl that allows user space to set these fields.

The packet fields are represented using a bitmap and are common between
IPv4 and IPv6 to allow user space to use the same numbering across both
protocols. For example, to hash based on standard 5-tuple:

 # sysctl -w net.ipv6.fib_multipath_hash_fields=0-2,4-5
 net.ipv6.fib_multipath_hash_fields = 0-2,4-5

More fields can be added in the future, if needed.

The 'need_outer' and 'need_inner' variables are set in the control path
to indicate whether dissection of the outer or inner flow is needed.
They will be used by a subsequent patch to allow the data path to avoid
dissection of the outer or inner flow when not needed.

To avoid introducing holes in 'struct netns_sysctl_ipv6', move the
'bindv6only' field after the multipath hash fields.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 29 +++++++++++++++++++++++
 include/net/ipv6.h                     |  8 +++++++
 include/net/netns/ipv6.h               |  6 ++++-
 net/ipv6/ip6_fib.c                     | 21 ++++++++++++++++-
 net/ipv6/sysctl_net_ipv6.c             | 32 ++++++++++++++++++++++++++
 5 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 549601494694..5289336227b3 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1775,6 +1775,35 @@ fib_multipath_hash_policy - INTEGER
 	- 1 - Layer 4 (standard 5-tuple)
 	- 2 - Layer 3 or inner Layer 3 if present
 
+fib_multipath_hash_fields - list of comma separated ranges
+	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
+	fields used for multipath hash calculation are determined by this
+	sysctl.
+
+	The format used for both input and output is a comma separated list of
+	ranges (e.g., "0-2" for source IP, destination IP and IP protocol).
+	Writing to the file will clear all previous ranges and update the
+	current list with the input.
+
+	Possible fields are:
+
+	== ============================
+	 0 Source IP address
+	 1 Destination IP address
+	 2 IP protocol
+	 3 Flow Label
+	 4 Source port
+	 5 Destination port
+	 6 Inner source IP address
+	 7 Inner destination IP address
+	 8 Inner IP protocol
+	 9 Inner Flow Label
+	10 Inner source port
+	11 Inner destination port
+	== ============================
+
+	Default: 0-2 (source IP, destination IP and IP protocol)
+
 anycast_src_echo_reply - BOOLEAN
 	Controls the use of anycast addresses as source addresses for ICMPv6
 	echo reply
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 448bf2b34759..61cce23f628e 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -926,11 +926,19 @@ static inline int ip6_multipath_hash_policy(const struct net *net)
 {
 	return net->ipv6.sysctl.multipath_hash_policy;
 }
+static inline unsigned long *ip6_multipath_hash_fields(const struct net *net)
+{
+	return net->ipv6.sysctl.multipath_hash_fields;
+}
 #else
 static inline int ip6_multipath_hash_policy(const struct net *net)
 {
 	return 0;
 }
+static inline unsigned long *ip6_multipath_hash_fields(const struct net *net)
+{
+	return NULL;
+}
 #endif
 
 /*
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 6153c8067009..81f78e07e2d5 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -28,8 +28,12 @@ struct netns_sysctl_ipv6 {
 	int ip6_rt_gc_elasticity;
 	int ip6_rt_mtu_expires;
 	int ip6_rt_min_advmss;
-	u8 bindv6only;
+	unsigned long *multipath_hash_fields;
+	u8 multipath_hash_fields_need_outer:1,
+	   multipath_hash_fields_need_inner:1,
+	   unused:6;
 	u8 multipath_hash_policy;
+	u8 bindv6only;
 	u8 flowlabel_consistency;
 	u8 auto_flowlabels;
 	int icmpv6_time;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 33d2d6a4e28c..3aa6b6532343 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -32,6 +32,7 @@
 #include <net/lwtunnel.h>
 #include <net/fib_notifier.h>
 
+#include <net/ip_fib.h>
 #include <net/ip6_fib.h>
 #include <net/ip6_route.h>
 
@@ -2355,6 +2356,21 @@ static int __net_init fib6_net_init(struct net *net)
 	if (err)
 		return err;
 
+	net->ipv6.sysctl.multipath_hash_fields =
+		bitmap_zalloc(__FIB_MULTIPATH_HASH_FIELD_CNT, GFP_KERNEL);
+	if (!net->ipv6.sysctl.multipath_hash_fields)
+		goto out_notifier;
+
+	/* Default to 3-tuple */
+	set_bit(FIB_MULTIPATH_HASH_FIELD_SRC_IP,
+		net->ipv6.sysctl.multipath_hash_fields);
+	set_bit(FIB_MULTIPATH_HASH_FIELD_DST_IP,
+		net->ipv6.sysctl.multipath_hash_fields);
+	set_bit(FIB_MULTIPATH_HASH_FIELD_IP_PROTO,
+		net->ipv6.sysctl.multipath_hash_fields);
+	net->ipv6.sysctl.multipath_hash_fields_need_outer = 1;
+	net->ipv6.sysctl.multipath_hash_fields_need_inner = 0;
+
 	spin_lock_init(&net->ipv6.fib6_gc_lock);
 	rwlock_init(&net->ipv6.fib6_walker_lock);
 	INIT_LIST_HEAD(&net->ipv6.fib6_walkers);
@@ -2362,7 +2378,7 @@ static int __net_init fib6_net_init(struct net *net)
 
 	net->ipv6.rt6_stats = kzalloc(sizeof(*net->ipv6.rt6_stats), GFP_KERNEL);
 	if (!net->ipv6.rt6_stats)
-		goto out_notifier;
+		goto out_hash_fields;
 
 	/* Avoid false sharing : Use at least a full cache line */
 	size = max_t(size_t, size, L1_CACHE_BYTES);
@@ -2407,6 +2423,8 @@ static int __net_init fib6_net_init(struct net *net)
 	kfree(net->ipv6.fib_table_hash);
 out_rt6_stats:
 	kfree(net->ipv6.rt6_stats);
+out_hash_fields:
+	bitmap_free(net->ipv6.sysctl.multipath_hash_fields);
 out_notifier:
 	fib6_notifier_exit(net);
 	return -ENOMEM;
@@ -2431,6 +2449,7 @@ static void fib6_net_exit(struct net *net)
 
 	kfree(net->ipv6.fib_table_hash);
 	kfree(net->ipv6.rt6_stats);
+	bitmap_free(net->ipv6.sysctl.multipath_hash_fields);
 	fib6_notifier_exit(net);
 }
 
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 27102c3d6e1d..8d94a1d621d0 100644
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
@@ -40,6 +41,30 @@ static int proc_rt6_multipath_hash_policy(struct ctl_table *table, int write,
 	return ret;
 }
 
+static int
+proc_rt6_multipath_hash_fields(struct ctl_table *table, int write, void *buffer,
+			       size_t *lenp, loff_t *ppos)
+{
+	unsigned long *hash_fields;
+	struct net *net;
+	int ret;
+
+	net = container_of(table->data, struct net,
+			   ipv6.sysctl.multipath_hash_fields);
+	ret = proc_do_large_bitmap(table, write, buffer, lenp, ppos);
+	if (!write || ret)
+		goto out;
+
+	hash_fields = net->ipv6.sysctl.multipath_hash_fields;
+	net->ipv6.sysctl.multipath_hash_fields_need_outer =
+		fib_multipath_hash_need_outer(hash_fields);
+	net->ipv6.sysctl.multipath_hash_fields_need_inner =
+		fib_multipath_hash_need_inner(hash_fields);
+
+out:
+	return ret;
+}
+
 static struct ctl_table ipv6_table_template[] = {
 	{
 		.procname	= "bindv6only",
@@ -151,6 +176,13 @@ static struct ctl_table ipv6_table_template[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "fib_multipath_hash_fields",
+		.data		= &init_net.ipv6.sysctl.multipath_hash_fields,
+		.maxlen		= __FIB_MULTIPATH_HASH_FIELD_CNT,
+		.mode		= 0644,
+		.proc_handler	= proc_rt6_multipath_hash_fields,
+	},
 	{
 		.procname	= "seg6_flowlabel",
 		.data		= &init_net.ipv6.sysctl.seg6_flowlabel,
-- 
2.30.2

