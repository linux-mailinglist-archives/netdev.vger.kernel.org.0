Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4533370DE7
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 18:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhEBQZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 12:25:38 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42179 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhEBQZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 12:25:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 074DA5C0117;
        Sun,  2 May 2021 12:24:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 02 May 2021 12:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ZWV2q+ggA1lFN/AxHMibF/3tMOAN0JjkmhcxXLjxAh0=; b=Il+z+EBz
        67Q3tgpmanGFHANCxbwy81X1XoSQIo8vgIbBGT6PHn4BpDKS1MoEvNnd+3rhxH3A
        OcThaee6nylbvYergzTvlBnONhS2HV3zJ2OPdgIYXIHJzLOJhge70QGqP+02zdyS
        8hqClFfgszuH7+8mde8FqgBA7th3cl0TwVgFBKD0cidjJ83ZKxHrE1gTFF4avPz2
        EHnlPuCd7qf7ULov5jwwMBsKS78CVtc9EJUp3/Cl2tKJIgIvQDPOD6KsSOzqXICX
        6z/eOSP7aTOwLF5L6udxs8JuymtGxsRil8p2T1BA2G0IDh4JGx5nj/vIIE6aOKvn
        me6LOllvwMAhAw==
X-ME-Sender: <xms:TdKOYOggdT1zmTXYK3EvjMNVPi7Vqm1xDCv7-m-3sh4ZH1Cn1msM5w>
    <xme:TdKOYPCORTQxAYdAlXz9MT7K-ubSimB2bmXFnuhoEz_OmJfRWKSdPRjFX7RxkyNhu
    RZAOiy7cEBzauk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefvddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:TdKOYGHUqZyzG4IDFdMglmPt6qf0jholTw8yDXfJZf5B1-qAeBoqyw>
    <xmx:TdKOYHT_bXW9Q99ywhqSrpANJ80TOKREuN6nIW7XaTLm49RX-oKAxQ>
    <xmx:TdKOYLzAiyZBDS6iQ-d4stYlt3bs_UWMYHRxuWfqo5ryCUl0j5g0ag>
    <xmx:TtKOYCmQjBk9h6j53sZiPVzZ2OiP19pG5PpKeQQ7M4EtRlHekFMLyQ>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 12:24:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 02/10] ipv4: Add a sysctl to control multipath hash fields
Date:   Sun,  2 May 2021 19:22:49 +0300
Message-Id: <20210502162257.3472453-3-idosch@idosch.org>
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

 # sysctl -w net.ipv4.fib_multipath_hash_fields=0-2,4-5
 net.ipv4.fib_multipath_hash_fields = 0-2,4-5

More fields can be added in the future, if needed.

The 'need_outer' and 'need_inner' variables are set in the control path
to indicate whether dissection of the outer or inner flow is needed.
They will be used by a subsequent patch to allow the data path to avoid
dissection of the outer or inner flow when not needed.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 29 ++++++++++++++++
 include/net/ip_fib.h                   | 46 ++++++++++++++++++++++++++
 include/net/netns/ipv4.h               |  4 +++
 net/ipv4/fib_frontend.c                | 24 ++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             | 32 ++++++++++++++++++
 5 files changed, 135 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c2ecc9894fd0..8ab61f4edf02 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -100,6 +100,35 @@ fib_multipath_hash_policy - INTEGER
 	- 1 - Layer 4
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
+	 3 Unused
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
 fib_sync_mem - UNSIGNED INTEGER
 	Amount of dirty memory from fib entries that can be backlogged before
 	synchronize_rcu is forced.
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index a914f33f3ed5..d70a4c524bef 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -466,6 +466,52 @@ int fib_sync_up(struct net_device *dev, unsigned char nh_flags);
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu);
 void fib_nhc_update_mtu(struct fib_nh_common *nhc, u32 new, u32 orig);
 
+/* Fields used for sysctl_fib_multipath_hash_fields.
+ * Common to IPv4 and IPv6.
+ */
+enum {
+	FIB_MULTIPATH_HASH_FIELD_SRC_IP,
+	FIB_MULTIPATH_HASH_FIELD_DST_IP,
+	FIB_MULTIPATH_HASH_FIELD_IP_PROTO,
+	FIB_MULTIPATH_HASH_FIELD_FLOWLABEL,
+	FIB_MULTIPATH_HASH_FIELD_SRC_PORT,
+	FIB_MULTIPATH_HASH_FIELD_DST_PORT,
+	FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP,
+	FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP,
+	FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO,
+	FIB_MULTIPATH_HASH_FIELD_INNER_FLOWLABEL,
+	FIB_MULTIPATH_HASH_FIELD_INNER_SRC_PORT,
+	FIB_MULTIPATH_HASH_FIELD_INNER_DST_PORT,
+
+	/* Add new fields above. This is user API. */
+	__FIB_MULTIPATH_HASH_FIELD_CNT,
+};
+
+#define FIB_MULTIPATH_HASH_TEST_FIELD(_field, _hash_fields)		      \
+	test_bit(FIB_MULTIPATH_HASH_FIELD_##_field, _hash_fields)
+
+static inline bool
+fib_multipath_hash_need_outer(const unsigned long *hash_fields)
+{
+	return FIB_MULTIPATH_HASH_TEST_FIELD(SRC_IP, hash_fields) ||
+	       FIB_MULTIPATH_HASH_TEST_FIELD(DST_IP, hash_fields) ||
+	       FIB_MULTIPATH_HASH_TEST_FIELD(IP_PROTO, hash_fields) ||
+	       FIB_MULTIPATH_HASH_TEST_FIELD(FLOWLABEL, hash_fields) ||
+	       FIB_MULTIPATH_HASH_TEST_FIELD(SRC_PORT, hash_fields) ||
+	       FIB_MULTIPATH_HASH_TEST_FIELD(DST_PORT, hash_fields);
+}
+
+static inline bool
+fib_multipath_hash_need_inner(const unsigned long *hash_fields)
+{
+	return FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_IP, hash_fields) ||
+	       FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_IP, hash_fields) ||
+	       FIB_MULTIPATH_HASH_TEST_FIELD(INNER_IP_PROTO, hash_fields) ||
+	       FIB_MULTIPATH_HASH_TEST_FIELD(INNER_FLOWLABEL, hash_fields) ||
+	       FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_PORT, hash_fields) ||
+	       FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_PORT, hash_fields);
+}
+
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		       const struct sk_buff *skb, struct flow_keys *flkeys);
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index f6af8d96d3c6..d0fcd968be44 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -210,6 +210,10 @@ struct netns_ipv4 {
 #endif
 #endif
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
+	unsigned long *sysctl_fib_multipath_hash_fields;
+	u8 fib_multipath_hash_fields_need_outer:1,
+	   fib_multipath_hash_fields_need_inner:1,
+	   unused:6;
 	u8 sysctl_fib_multipath_use_neigh;
 	u8 sysctl_fib_multipath_hash_policy;
 #endif
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 84bb707bd88d..f685e84b03b6 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1516,6 +1516,23 @@ static int __net_init ip_fib_net_init(struct net *net)
 	if (err)
 		return err;
 
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+	net->ipv4.sysctl_fib_multipath_hash_fields =
+		bitmap_zalloc(__FIB_MULTIPATH_HASH_FIELD_CNT, GFP_KERNEL);
+	if (!net->ipv4.sysctl_fib_multipath_hash_fields)
+		goto err_hash_fields_alloc;
+
+	/* Default to 3-tuple */
+	set_bit(FIB_MULTIPATH_HASH_FIELD_SRC_IP,
+		net->ipv4.sysctl_fib_multipath_hash_fields);
+	set_bit(FIB_MULTIPATH_HASH_FIELD_DST_IP,
+		net->ipv4.sysctl_fib_multipath_hash_fields);
+	set_bit(FIB_MULTIPATH_HASH_FIELD_IP_PROTO,
+		net->ipv4.sysctl_fib_multipath_hash_fields);
+	net->ipv4.fib_multipath_hash_fields_need_outer = 1;
+	net->ipv4.fib_multipath_hash_fields_need_inner = 0;
+#endif
+
 	/* Avoid false sharing : Use at least a full cache line */
 	size = max_t(size_t, size, L1_CACHE_BYTES);
 
@@ -1533,6 +1550,10 @@ static int __net_init ip_fib_net_init(struct net *net)
 err_rules_init:
 	kfree(net->ipv4.fib_table_hash);
 err_table_hash_alloc:
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+	bitmap_free(net->ipv4.sysctl_fib_multipath_hash_fields);
+err_hash_fields_alloc:
+#endif
 	fib4_notifier_exit(net);
 	return err;
 }
@@ -1568,6 +1589,9 @@ static void ip_fib_net_exit(struct net *net)
 #endif
 	rtnl_unlock();
 	kfree(net->ipv4.fib_table_hash);
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+	bitmap_free(net->ipv4.sysctl_fib_multipath_hash_fields);
+#endif
 	fib4_notifier_exit(net);
 }
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a62934b9f15a..0db7e68c38cd 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -19,6 +19,7 @@
 #include <net/snmp.h>
 #include <net/icmp.h>
 #include <net/ip.h>
+#include <net/ip_fib.h>
 #include <net/route.h>
 #include <net/tcp.h>
 #include <net/udp.h>
@@ -461,6 +462,30 @@ static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 
 	return ret;
 }
+
+static int proc_fib_multipath_hash_fields(struct ctl_table *table, int write,
+					  void *buffer, size_t *lenp,
+					  loff_t *ppos)
+{
+	unsigned long *hash_fields;
+	struct net *net;
+	int ret;
+
+	net = container_of(table->data, struct net,
+			   ipv4.sysctl_fib_multipath_hash_fields);
+	ret = proc_do_large_bitmap(table, write, buffer, lenp, ppos);
+	if (!write || ret)
+		goto out;
+
+	hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	net->ipv4.fib_multipath_hash_fields_need_outer =
+		fib_multipath_hash_need_outer(hash_fields);
+	net->ipv4.fib_multipath_hash_fields_need_inner =
+		fib_multipath_hash_need_inner(hash_fields);
+
+out:
+	return ret;
+}
 #endif
 
 static struct ctl_table ipv4_table[] = {
@@ -1052,6 +1077,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "fib_multipath_hash_fields",
+		.data		= &init_net.ipv4.sysctl_fib_multipath_hash_fields,
+		.maxlen		= __FIB_MULTIPATH_HASH_FIELD_CNT,
+		.mode		= 0644,
+		.proc_handler	= proc_fib_multipath_hash_fields,
+	},
 #endif
 	{
 		.procname	= "ip_unprivileged_port_start",
-- 
2.30.2

