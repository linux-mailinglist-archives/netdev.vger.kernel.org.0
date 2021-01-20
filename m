Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423762FD457
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731707AbhATPji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387613AbhATOyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:54:46 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CEEC061798
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:09 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id by1so27490808ejc.0
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r6eGbI5T1ZbJb6/fIDxJvPsg6g6XzCNDGMhxMVE7KiU=;
        b=X6RzaWHtb8yw8tbOiXobIbN96Xov1DyWcra3y7BxsqYJIKK9CLufCSZpy2J8aMdKbs
         5Y6bktsicSNuNRz6Cnf75Z0KkpykgkzwA4PGU2NfD4+pAzb9bRzwXHhTAndAlWyaYOYP
         e6qsYvV65es4JA4IrH1k3j5VLlPeokS5YbluFKwBKO9eyUHru/pV+haJPDblDIxPdiw2
         I8AmJnHIjId0RmylS6Vn2mKiFFmlMiOc1217nq9p3wYchSyiVi8R0/paCjVKybhdzKl8
         +uhCH7ihO2USs2Y55WZ3jn8LC2spYriGFELWL06G8TsMp7MimZ4RM9yFO0Lty8/mLOOB
         Z5rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r6eGbI5T1ZbJb6/fIDxJvPsg6g6XzCNDGMhxMVE7KiU=;
        b=C1PBzBTBU7EHX+h0hWatm+lHP5Jpp6TRe3P61SPpnhp8wX0shoGzjgciGqQ62JuBho
         k/D+LvwEWkFxmYFTfA0y6Cgabnld2vrZKqzDf8R6rkwp3IATxNewRMaNI5ta0G8o1Foh
         tGUmtXHiKCbUuzP/dVcBfk4F30d/0A0N3E9/wsOWw/QN1osInFjP3kruoVqCwFXGOvdv
         5rm4CHpPOEcPdUjs1aY9GuM8gPRE9FDesucYn6e0nnNEQCPkgZOOg6PiyQqEku8YqJVC
         qYvF8mxS9WaN1jA82BKnuZyM/vfL22LRnHNdYA+7o50AhIc3AupWWXvCNULbDTdgpUz3
         4m1Q==
X-Gm-Message-State: AOAM5332e5VEBFu5QsNQgaPvRpi4xNdgF7gSVgRuC2Q5GujBbgY4+9Q7
        DYJbrYkRScw29McqI2cNbKUuRiJN5lPULmOH0Tg=
X-Google-Smtp-Source: ABdhPJxQKUIhoz6+ceN1wf0HbJmBg5i4EiYGcTRkPHhvTpCAz8Xg+XUzm9Z1oDvqFDrreGmWF91u4g==
X-Received: by 2002:a17:906:7689:: with SMTP id o9mr6519678ejm.324.1611154388091;
        Wed, 20 Jan 2021 06:53:08 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:07 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 05/14] net: bridge: multicast: add EHT structures and definitions
Date:   Wed, 20 Jan 2021 16:51:54 +0200
Message-Id: <20210120145203.1109140-6-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add EHT structures for tracking hosts and sources per group. We keep one
set for each host which has all of the host's S,G entries, and one set for
each multicast source which has all hosts that have joined that S,G. For
each host, source entry we record the filter_mode and we keep an expiry
timer. There is also one global expiry timer per source set, it is
updated with each set entry update, it will be later used to lower the
set's timer instead of lowering each entry's timer separately.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c         |  1 +
 net/bridge/br_private.h           |  2 ++
 net/bridge/br_private_mcast_eht.h | 50 +++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)
 create mode 100644 net/bridge/br_private_mcast_eht.h

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index f8b685ae56d4..3aaa6adbff82 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -33,6 +33,7 @@
 #endif
 
 #include "br_private.h"
+#include "br_private_mcast_eht.h"
 
 static const struct rhashtable_params br_mdb_rht_params = {
 	.head_offset = offsetof(struct net_bridge_mdb_entry, rhnode),
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d62c6e1af64a..0bf4c544a5da 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -252,6 +252,8 @@ struct net_bridge_port_group {
 	struct timer_list		timer;
 	struct timer_list		rexmit_timer;
 	struct hlist_node		mglist;
+	struct rb_root			eht_set_tree;
+	struct rb_root			eht_host_tree;
 
 	struct rhash_head		rhnode;
 	struct net_bridge_mcast_gc	mcast_gc;
diff --git a/net/bridge/br_private_mcast_eht.h b/net/bridge/br_private_mcast_eht.h
new file mode 100644
index 000000000000..0c9c4267969d
--- /dev/null
+++ b/net/bridge/br_private_mcast_eht.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ * Copyright (c) 2020, Nikolay Aleksandrov <nikolay@nvidia.com>
+ */
+#ifndef _BR_PRIVATE_MCAST_EHT_H_
+#define _BR_PRIVATE_MCAST_EHT_H_
+
+union net_bridge_eht_addr {
+	__be32				ip4;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct in6_addr			ip6;
+#endif
+};
+
+/* single host's list of set entries and filter_mode */
+struct net_bridge_group_eht_host {
+	struct rb_node			rb_node;
+
+	union net_bridge_eht_addr	h_addr;
+	struct hlist_head		set_entries;
+	unsigned int			num_entries;
+	unsigned char			filter_mode;
+	struct net_bridge_port_group	*pg;
+};
+
+/* (host, src entry) added to a per-src set and host's list */
+struct net_bridge_group_eht_set_entry {
+	struct rb_node			rb_node;
+	struct hlist_node		host_list;
+
+	union net_bridge_eht_addr	h_addr;
+	struct timer_list		timer;
+	struct net_bridge		*br;
+	struct net_bridge_group_eht_set	*eht_set;
+	struct net_bridge_group_eht_host *h_parent;
+	struct net_bridge_mcast_gc	mcast_gc;
+};
+
+/* per-src set */
+struct net_bridge_group_eht_set {
+	struct rb_node			rb_node;
+
+	union net_bridge_eht_addr	src_addr;
+	struct rb_root			entry_tree;
+	struct timer_list		timer;
+	struct net_bridge_port_group	*pg;
+	struct net_bridge		*br;
+	struct net_bridge_mcast_gc	mcast_gc;
+};
+
+#endif /* _BR_PRIVATE_MCAST_EHT_H_ */
-- 
2.29.2

