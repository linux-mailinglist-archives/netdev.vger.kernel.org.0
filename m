Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466B249EF01
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241096AbiA0Xwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:52:42 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42994 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343621AbiA0Xwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:52:41 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4E47460693;
        Fri, 28 Jan 2022 00:49:36 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/8] netfilter: Remove flowtable relics
Date:   Fri, 28 Jan 2022 00:52:28 +0100
Message-Id: <20220127235235.656931-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127235235.656931-1-pablo@netfilter.org>
References: <20220127235235.656931-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

NF_FLOW_TABLE_IPV4 and NF_FLOW_TABLE_IPV6 are invisble, selected by
nothing (so they can no longer be enabled), and their last real users
have been removed (nf_flow_table_ipv6.c is empty).

Clean up the leftovers.

Fixes: c42ba4290b2147aa ("netfilter: flowtable: remove ipv4/ipv6 modules")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig              | 4 ----
 net/ipv6/netfilter/Kconfig              | 4 ----
 net/ipv6/netfilter/Makefile             | 3 ---
 net/ipv6/netfilter/nf_flow_table_ipv6.c | 0
 4 files changed, 11 deletions(-)
 delete mode 100644 net/ipv6/netfilter/nf_flow_table_ipv6.c

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 67087f95579f..aab384126f61 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -58,10 +58,6 @@ config NF_TABLES_ARP
 
 endif # NF_TABLES
 
-config NF_FLOW_TABLE_IPV4
-	tristate
-	select NF_FLOW_TABLE_INET
-
 config NF_DUP_IPV4
 	tristate "Netfilter IPv4 packet duplication to alternate destination"
 	depends on !NF_CONNTRACK || NF_CONNTRACK
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 97d3d1b36dbc..0ba62f4868f9 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -47,10 +47,6 @@ config NFT_FIB_IPV6
 endif # NF_TABLES_IPV6
 endif # NF_TABLES
 
-config NF_FLOW_TABLE_IPV6
-	tristate
-	select NF_FLOW_TABLE_INET
-
 config NF_DUP_IPV6
 	tristate "Netfilter IPv6 packet duplication to alternate destination"
 	depends on !NF_CONNTRACK || NF_CONNTRACK
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index b85383606df7..b8d6dc9aeeb6 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -28,9 +28,6 @@ obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
 obj-$(CONFIG_NFT_DUP_IPV6) += nft_dup_ipv6.o
 obj-$(CONFIG_NFT_FIB_IPV6) += nft_fib_ipv6.o
 
-# flow table support
-obj-$(CONFIG_NF_FLOW_TABLE_IPV6) += nf_flow_table_ipv6.o
-
 # matches
 obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
deleted file mode 100644
index e69de29bb2d1..000000000000
-- 
2.30.2

