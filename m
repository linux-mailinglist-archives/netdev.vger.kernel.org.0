Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BA3229D2C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbgGVQcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729816AbgGVQcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:32:35 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D421C0619E0
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:32:35 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 46F2593AD8;
        Wed, 22 Jul 2020 17:32:34 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595435554; bh=s9OJDADf/id5ORojGQslYAMRJkBsMD9TznHNXIOZMIg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=2002/10]=20l2tp:=20cleanup=20com
         ments|Date:=20Wed,=2022=20Jul=202020=2017:32:06=20+0100|Message-Id
         :=20<20200722163214.7920-3-tparkin@katalix.com>|In-Reply-To:=20<20
         200722163214.7920-1-tparkin@katalix.com>|References:=20<2020072216
         3214.7920-1-tparkin@katalix.com>;
        b=3PO83hix1LxkRQeTNgg+aBcuds+OaQyDvz9Jx2K6MEXG3TuqAfdrVDx8ZNEyyfDFg
         +lXwWDkO2sT8mrjHeLm7+cKLzAdHVL3fKiZcxX9ft1CCP8daITpKjm1TE1aT89gCSN
         LOu0nCCj6a5agxPtI96jjCpnfnNWU1wCIhQrFXu7XciWMFXpCmgA6InJUEFZHraHA2
         yf6KLvmZGJjg4BvZ/lLKOJvWs2wnzFiO2/yRgncRncNqexr0dAM0Rnj0xdq8uCq5oR
         a9Y8p3M9JD5vhd+gqG6XOzERRHu6/leJuXmzl99DaOlxjEPkyKYCCGVGigfxaZqxZ8
         vtKs43Ik5GvxA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 02/10] l2tp: cleanup comments
Date:   Wed, 22 Jul 2020 17:32:06 +0100
Message-Id: <20200722163214.7920-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
References: <20200722163214.7920-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify some l2tp comments to better adhere to kernel coding style, as
reported by checkpatch.pl.

Add descriptive comments for the l2tp per-net spinlocks to document
their use.

Fix an incorrect comment in l2tp_recv_common:

RFC2661 section 5.4 states that:

"The LNS controls enabling and disabling of sequence numbers by sending a
data message with or without sequence numbers present at any time during
the life of a session."

l2tp handles this correctly in l2tp_recv_common, but the comment around
the code was incorrect and confusing.  Fix up the comment accordingly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c    |  9 ++---
 net/l2tp/l2tp_core.h    | 76 +++++++++++++++++------------------------
 net/l2tp/l2tp_debugfs.c |  3 +-
 net/l2tp/l2tp_eth.c     |  3 +-
 net/l2tp/l2tp_ip.c      |  3 +-
 net/l2tp/l2tp_ip6.c     | 15 ++++----
 net/l2tp/l2tp_netlink.c |  3 +-
 net/l2tp/l2tp_ppp.c     |  3 +-
 8 files changed, 47 insertions(+), 68 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 0992d5fab9b8..f5e314d8a02b 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * L2TP core.
+/* L2TP core.
  *
  * Copyright (c) 2008,2009,2010 Katalix Systems Ltd
  *
@@ -102,8 +101,10 @@ static struct workqueue_struct *l2tp_wq;
 static unsigned int l2tp_net_id;
 struct l2tp_net {
 	struct list_head l2tp_tunnel_list;
+	/* Lock for write access to l2tp_tunnel_list */
 	spinlock_t l2tp_tunnel_list_lock;
 	struct hlist_head l2tp_session_hlist[L2TP_HASH_SIZE_2];
+	/* Lock for write access to l2tp_session_hlist */
 	spinlock_t l2tp_session_hlist_lock;
 };
 
@@ -678,7 +679,7 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	}
 
 	if (L2TP_SKB_CB(skb)->has_seq) {
-		/* Received a packet with sequence numbers. If we're the LNS,
+		/* Received a packet with sequence numbers. If we're the LAC,
 		 * check if we sre sending sequence numbers and if not,
 		 * configure it so.
 		 */
@@ -1604,7 +1605,7 @@ void __l2tp_session_unhash(struct l2tp_session *session)
 EXPORT_SYMBOL_GPL(__l2tp_session_unhash);
 
 /* This function is used by the netlink SESSION_DELETE command and by
-   pseudowire modules.
+ * pseudowire modules.
  */
 int l2tp_session_delete(struct l2tp_session *session)
 {
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 10cf7c3dcbb3..3ebb701eebbf 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -1,6 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * L2TP internal definitions.
+/* L2TP internal definitions.
  *
  * Copyright (c) 2008,2009 Katalix Systems Ltd
  */
@@ -49,32 +48,26 @@ struct l2tp_tunnel;
  */
 struct l2tp_session_cfg {
 	enum l2tp_pwtype	pw_type;
-	unsigned int		recv_seq:1;	/* expect receive packets with
-						 * sequence numbers? */
-	unsigned int		send_seq:1;	/* send packets with sequence
-						 * numbers? */
-	unsigned int		lns_mode:1;	/* behave as LNS? LAC enables
-						 * sequence numbers under
-						 * control of LNS. */
-	int			debug;		/* bitmask of debug message
-						 * categories */
+	unsigned int		recv_seq:1;	/* expect receive packets with sequence numbers? */
+	unsigned int		send_seq:1;	/* send packets with sequence numbers? */
+	unsigned int		lns_mode:1;	/* behave as LNS?
+						 * LAC enables sequence numbers under LNS control.
+						 */
+	int			debug;		/* bitmask of debug message categories */
 	u16			l2specific_type; /* Layer 2 specific type */
 	u8			cookie[8];	/* optional cookie */
 	int			cookie_len;	/* 0, 4 or 8 bytes */
 	u8			peer_cookie[8];	/* peer's cookie */
 	int			peer_cookie_len; /* 0, 4 or 8 bytes */
-	int			reorder_timeout; /* configured reorder timeout
-						  * (in jiffies) */
+	int			reorder_timeout; /* configured reorder timeout (in jiffies) */
 	char			*ifname;
 };
 
 struct l2tp_session {
-	int			magic;		/* should be
-						 * L2TP_SESSION_MAGIC */
+	int			magic;		/* should be L2TP_SESSION_MAGIC */
 	long			dead;
 
-	struct l2tp_tunnel	*tunnel;	/* back pointer to tunnel
-						 * context */
+	struct l2tp_tunnel	*tunnel;	/* back pointer to tunnel context */
 	u32			session_id;
 	u32			peer_session_id;
 	u8			cookie[8];
@@ -89,42 +82,37 @@ struct l2tp_session {
 	u32			nr_max;		/* max NR. Depends on tunnel */
 	u32			nr_window_size;	/* NR window size */
 	u32			nr_oos;		/* NR of last OOS packet */
-	int			nr_oos_count;	/* For OOS recovery */
+	int			nr_oos_count;	/* for OOS recovery */
 	int			nr_oos_count_max;
-	struct hlist_node	hlist;		/* Hash list node */
+	struct hlist_node	hlist;		/* hash list node */
 	refcount_t		ref_count;
 
 	char			name[32];	/* for logging */
 	char			ifname[IFNAMSIZ];
-	unsigned int		recv_seq:1;	/* expect receive packets with
-						 * sequence numbers? */
-	unsigned int		send_seq:1;	/* send packets with sequence
-						 * numbers? */
-	unsigned int		lns_mode:1;	/* behave as LNS? LAC enables
-						 * sequence numbers under
-						 * control of LNS. */
-	int			debug;		/* bitmask of debug message
-						 * categories */
-	int			reorder_timeout; /* configured reorder timeout
-						  * (in jiffies) */
+	unsigned int		recv_seq:1;	/* expect receive packets with sequence numbers? */
+	unsigned int		send_seq:1;	/* send packets with sequence numbers? */
+	unsigned int		lns_mode:1;	/* behave as LNS?
+						 * LAC enables sequence numbers under LNS control.
+						 */
+	int			debug;		/* bitmask of debug message categories */
+	int			reorder_timeout; /* configured reorder timeout (in jiffies) */
 	int			reorder_skip;	/* set if skip to next nr */
 	enum l2tp_pwtype	pwtype;
 	struct l2tp_stats	stats;
-	struct hlist_node	global_hlist;	/* Global hash list node */
+	struct hlist_node	global_hlist;	/* global hash list node */
 
 	int (*build_header)(struct l2tp_session *session, void *buf);
 	void (*recv_skb)(struct l2tp_session *session, struct sk_buff *skb, int data_len);
 	void (*session_close)(struct l2tp_session *session);
 	void (*show)(struct seq_file *m, void *priv);
-	u8			priv[];	/* private data */
+	u8			priv[];		/* private data */
 };
 
 /* Describes the tunnel. It contains info to track all the associated
  * sessions so incoming packets can be sorted out
  */
 struct l2tp_tunnel_cfg {
-	int			debug;		/* bitmask of debug message
-						 * categories */
+	int			debug;		/* bitmask of debug message categories */
 	enum l2tp_encap_type	encap;
 
 	/* Used only for kernel-created sockets */
@@ -148,31 +136,29 @@ struct l2tp_tunnel {
 
 	struct rcu_head rcu;
 	rwlock_t		hlist_lock;	/* protect session_hlist */
-	bool			acpt_newsess;	/* Indicates whether this
-						 * tunnel accepts new sessions.
-						 * Protected by hlist_lock.
+	bool			acpt_newsess;	/* indicates whether this tunnel accepts
+						 * new sessions. Protected by hlist_lock.
 						 */
 	struct hlist_head	session_hlist[L2TP_HASH_SIZE];
-						/* hashed list of sessions,
-						 * hashed by id */
+						/* hashed list of sessions, hashed by id */
 	u32			tunnel_id;
 	u32			peer_tunnel_id;
 	int			version;	/* 2=>L2TPv2, 3=>L2TPv3 */
 
 	char			name[20];	/* for logging */
-	int			debug;		/* bitmask of debug message
-						 * categories */
+	int			debug;		/* bitmask of debug message categories */
 	enum l2tp_encap_type	encap;
 	struct l2tp_stats	stats;
 
-	struct list_head	list;		/* Keep a list of all tunnels */
+	struct list_head	list;		/* list node on per-namespace list of tunnels */
 	struct net		*l2tp_net;	/* the net we belong to */
 
 	refcount_t		ref_count;
 	void (*old_sk_destruct)(struct sock *);
-	struct sock		*sock;		/* Parent socket */
-	int			fd;		/* Parent fd, if tunnel socket
-						 * was created by userspace */
+	struct sock		*sock;		/* parent socket */
+	int			fd;		/* parent fd, if tunnel socket was created
+						 * by userspace
+						 */
 
 	struct work_struct	del_work;
 };
diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index f0301cb41ae0..93181133e155 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * L2TP subsystem debugfs
+/* L2TP subsystem debugfs
  *
  * Copyright (c) 2010 Katalix Systems Ltd
  */
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index a84627d7be27..7ed2b4eced94 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * L2TPv3 ethernet pseudowire driver
+/* L2TPv3 ethernet pseudowire driver
  *
  * Copyright (c) 2008,2009,2010 Katalix Systems Ltd
  */
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index e5b63eab887d..70f9fdaf6c86 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * L2TPv3 IP encapsulation support
+/* L2TPv3 IP encapsulation support
  *
  * Copyright (c) 2008,2009,2010 Katalix Systems Ltd
  */
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index d17b9fe1180f..ca7696147c7e 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * L2TPv3 IP encapsulation support for IPv6
+/* L2TPv3 IP encapsulation support for IPv6
  *
  * Copyright (c) 2012 Katalix Systems Ltd
  */
@@ -38,7 +37,8 @@ struct l2tp_ip6_sock {
 	u32			peer_conn_id;
 
 	/* ipv6_pinfo has to be the last member of l2tp_ip6_sock, see
-	   inet6_sk_generic */
+	 * inet6_sk_generic
+	 */
 	struct ipv6_pinfo	inet6;
 };
 
@@ -519,7 +519,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int err;
 
 	/* Rough check on arithmetic overflow,
-	   better check is made in ip6_append_data().
+	 * better check is made in ip6_append_data().
 	 */
 	if (len > INT_MAX)
 		return -EMSGSIZE;
@@ -528,9 +528,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	/*
-	 *	Get and verify the address.
-	 */
+	/* Get and verify the address */
 	memset(&fl6, 0, sizeof(fl6));
 
 	fl6.flowi6_mark = sk->sk_mark;
@@ -555,8 +553,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			}
 		}
 
-		/*
-		 * Otherwise it will be difficult to maintain
+		/* Otherwise it will be difficult to maintain
 		 * sk->sk_dst_cache.
 		 */
 		if (sk->sk_state == TCP_ESTABLISHED &&
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 0ce8e94ace78..3120f8dcc56a 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * L2TP netlink layer, for management
+/* L2TP netlink layer, for management
  *
  * Copyright (c) 2008,2009,2010 Katalix Systems Ltd
  *
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 6dccffa29d02..48fbaf5ee82c 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -117,8 +117,7 @@ struct pppol2tp_session {
 	int			owner;		/* pid that opened the socket */
 
 	struct mutex		sk_lock;	/* Protects .sk */
-	struct sock __rcu	*sk;		/* Pointer to the session
-						 * PPPoX socket */
+	struct sock __rcu	*sk;		/* Pointer to the session PPPoX socket */
 	struct sock		*__sk;		/* Copy of .sk, for cleanup */
 	struct rcu_head		rcu;		/* For asynchronous release */
 };
-- 
2.17.1

