Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEC336B7B5
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbhDZRMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:12:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51544 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235707AbhDZRLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:52 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4BE0264139;
        Mon, 26 Apr 2021 19:10:33 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/22] netfilter: x_tables: remove paranoia tests
Date:   Mon, 26 Apr 2021 19:10:44 +0200
Message-Id: <20210426171056.345271-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No need for these.
There is only one caller, the xtables core, when the table is registered
for the first time with a particular network namespace.

After ->table_init() call, the table is linked into the tables[af] list,
so next call to that function will skip the ->table_init().

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arptable_filter.c   | 3 ---
 net/ipv4/netfilter/iptable_filter.c    | 3 ---
 net/ipv4/netfilter/iptable_mangle.c    | 3 ---
 net/ipv4/netfilter/iptable_nat.c       | 3 ---
 net/ipv4/netfilter/iptable_raw.c       | 3 ---
 net/ipv4/netfilter/iptable_security.c  | 3 ---
 net/ipv6/netfilter/ip6table_filter.c   | 3 ---
 net/ipv6/netfilter/ip6table_mangle.c   | 3 ---
 net/ipv6/netfilter/ip6table_nat.c      | 3 ---
 net/ipv6/netfilter/ip6table_raw.c      | 3 ---
 net/ipv6/netfilter/ip6table_security.c | 3 ---
 11 files changed, 33 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index c121e13dc78c..924f096a6d89 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -44,9 +44,6 @@ static int __net_init arptable_filter_table_init(struct net *net)
 	struct arpt_replace *repl;
 	int err;
 
-	if (net->ipv4.arptable_filter)
-		return 0;
-
 	repl = arpt_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index a39998c7977f..84573fa78d1e 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -48,9 +48,6 @@ static int __net_init iptable_filter_table_init(struct net *net)
 	struct ipt_replace *repl;
 	int err;
 
-	if (net->ipv4.iptable_filter)
-		return 0;
-
 	repl = ipt_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 7d1713e22553..98e9e9053d85 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -88,9 +88,6 @@ static int __net_init iptable_mangle_table_init(struct net *net)
 	struct ipt_replace *repl;
 	int ret;
 
-	if (net->ipv4.iptable_mangle)
-		return 0;
-
 	repl = ipt_alloc_initial_table(&packet_mangler);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 16bf3009642e..f4afd28ccc06 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -90,9 +90,6 @@ static int __net_init iptable_nat_table_init(struct net *net)
 	struct ipt_replace *repl;
 	int ret;
 
-	if (net->ipv4.nat_table)
-		return 0;
-
 	repl = ipt_alloc_initial_table(&nf_nat_ipv4_table);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index a1f556464b93..18776f5a4055 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -55,9 +55,6 @@ static int __net_init iptable_raw_table_init(struct net *net)
 	if (raw_before_defrag)
 		table = &packet_raw_before_defrag;
 
-	if (net->ipv4.iptable_raw)
-		return 0;
-
 	repl = ipt_alloc_initial_table(table);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 33eded4f9080..3df92fb394c5 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -50,9 +50,6 @@ static int __net_init iptable_security_table_init(struct net *net)
 	struct ipt_replace *repl;
 	int ret;
 
-	if (net->ipv4.iptable_security)
-		return 0;
-
 	repl = ipt_alloc_initial_table(&security_table);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 0c9f75e23ca0..2bcafa3e2d35 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -49,9 +49,6 @@ static int __net_init ip6table_filter_table_init(struct net *net)
 	struct ip6t_replace *repl;
 	int err;
 
-	if (net->ipv6.ip6table_filter)
-		return 0;
-
 	repl = ip6t_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 9a2266662508..14e22022bf41 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -81,9 +81,6 @@ static int __net_init ip6table_mangle_table_init(struct net *net)
 	struct ip6t_replace *repl;
 	int ret;
 
-	if (net->ipv6.ip6table_mangle)
-		return 0;
-
 	repl = ip6t_alloc_initial_table(&packet_mangler);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 7eb61e6b1e52..c7f98755191b 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -92,9 +92,6 @@ static int __net_init ip6table_nat_table_init(struct net *net)
 	struct ip6t_replace *repl;
 	int ret;
 
-	if (net->ipv6.ip6table_nat)
-		return 0;
-
 	repl = ip6t_alloc_initial_table(&nf_nat_ipv6_table);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index c9a4aada40ba..ae3df59f0350 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -54,9 +54,6 @@ static int __net_init ip6table_raw_table_init(struct net *net)
 	if (raw_before_defrag)
 		table = &packet_raw_before_defrag;
 
-	if (net->ipv6.ip6table_raw)
-		return 0;
-
 	repl = ip6t_alloc_initial_table(table);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 73067e08662f..83ca632cbf88 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -49,9 +49,6 @@ static int __net_init ip6table_security_table_init(struct net *net)
 	struct ip6t_replace *repl;
 	int ret;
 
-	if (net->ipv6.ip6table_security)
-		return 0;
-
 	repl = ip6t_alloc_initial_table(&security_table);
 	if (repl == NULL)
 		return -ENOMEM;
-- 
2.30.2

