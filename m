Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB18B2310C3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731982AbgG1RUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731684AbgG1RUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:20:46 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81209C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 10:20:45 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id CB3F18AD8E;
        Tue, 28 Jul 2020 18:20:44 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595956845; bh=jLnIJ9gUfT+mQNg0K3cwtrjCXkRP2Mqo3vmydjT7V4U=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=206/6]=20l2tp:=20improve=20API=2
         0documentation=20in=20l2tp_core.h|Date:=20Tue,=2028=20Jul=202020=2
         018:20:33=20+0100|Message-Id:=20<20200728172033.19532-7-tparkin@ka
         talix.com>|In-Reply-To:=20<20200728172033.19532-1-tparkin@katalix.
         com>|References:=20<20200728172033.19532-1-tparkin@katalix.com>;
        b=aw2qsVprXOnwAsEScNtVKtU1dgCYL5rBT4Lo7kYjSoUWqls0weWP1IpPM1mr0cqkV
         lZzOqEsSbz/1RuModCM67nlfP55z7uo4W+FYBuUfyD5eYnu2QR1cz3UXuRdLYPlkN8
         9fix3P/p0M+AZY+BniSbgtdmMBE14bLeC5BVP/GixFNEzjThiP7ue1vAwMBxU/9qS4
         Qlo6C7bEu9wju/KFf4wIjiSghoEytvXiUW9/cM9iOdMNDANRxSXn9W9oyNvKYj8bUv
         WoHZI6igdd1aarTajvn27dsx5x29Y9u6LRz0N3W/n0BGApzoj4/L0/We8wQ59OyQWx
         vazixmRQc8DMQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 6/6] l2tp: improve API documentation in l2tp_core.h
Date:   Tue, 28 Jul 2020 18:20:33 +0100
Message-Id: <20200728172033.19532-7-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728172033.19532-1-tparkin@katalix.com>
References: <20200728172033.19532-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 * Improve the description of the key l2tp subsystem data structures.
 * Add high-level description of the main APIs for interacting with l2tp
   core.
 * Add documentation for the l2tp netlink session command callbacks.
 * Document the session pseudowire callbacks.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.h | 86 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 72 insertions(+), 14 deletions(-)

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 3dfd3ddd28fd..3468d6b177a0 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -15,15 +15,15 @@
 #include <net/xfrm.h>
 #endif
 
-/* Just some random numbers */
+/* Random numbers used for internal consistency checks of tunnel and session structures */
 #define L2TP_TUNNEL_MAGIC	0x42114DDA
 #define L2TP_SESSION_MAGIC	0x0C04EB7D
 
-/* Per tunnel, session hash table size */
+/* Per tunnel session hash table size */
 #define L2TP_HASH_BITS	4
 #define L2TP_HASH_SIZE	BIT(L2TP_HASH_BITS)
 
-/* System-wide, session hash table size */
+/* System-wide session hash table size */
 #define L2TP_HASH_BITS_2	8
 #define L2TP_HASH_SIZE_2	BIT(L2TP_HASH_BITS_2)
 
@@ -43,9 +43,7 @@ struct l2tp_stats {
 
 struct l2tp_tunnel;
 
-/* Describes a session. Contains information to determine incoming
- * packets and transmit outgoing ones.
- */
+/* L2TP session configuration */
 struct l2tp_session_cfg {
 	enum l2tp_pwtype	pw_type;
 	unsigned int		recv_seq:1;	/* expect receive packets with sequence numbers? */
@@ -63,6 +61,11 @@ struct l2tp_session_cfg {
 	char			*ifname;
 };
 
+/* Represents a session (pseudowire) instance.
+ * Tracks runtime state including cookies, dataplane packet sequencing, and IO statistics.
+ * Is linked into a per-tunnel session hashlist; and in the case of an L2TPv3 session into
+ * an additional per-net ("global") hashlist.
+ */
 struct l2tp_session {
 	int			magic;		/* should be L2TP_SESSION_MAGIC */
 	long			dead;
@@ -101,15 +104,32 @@ struct l2tp_session {
 	struct l2tp_stats	stats;
 	struct hlist_node	global_hlist;	/* global hash list node */
 
+	/* Session receive handler for data packets.
+	 * Each pseudowire implementation should implement this callback in order to
+	 * handle incoming packets.  Packets are passed to the pseudowire handler after
+	 * reordering, if data sequence numbers are enabled for the session.
+	 */
 	void (*recv_skb)(struct l2tp_session *session, struct sk_buff *skb, int data_len);
+
+	/* Session close handler.
+	 * Each pseudowire implementation may implement this callback in order to carry
+	 * out pseudowire-specific shutdown actions.
+	 * The callback is called by core after unhashing the session and purging its
+	 * reorder queue.
+	 */
 	void (*session_close)(struct l2tp_session *session);
+
+	/* Session show handler.
+	 * Pseudowire-specific implementation of debugfs session rendering.
+	 * The callback is called by l2tp_debugfs.c after rendering core session
+	 * information.
+	 */
 	void (*show)(struct seq_file *m, void *priv);
+
 	u8			priv[];		/* private data */
 };
 
-/* Describes the tunnel. It contains info to track all the associated
- * sessions so incoming packets can be sorted out
- */
+/* L2TP tunnel configuration */
 struct l2tp_tunnel_cfg {
 	int			debug;		/* bitmask of debug message categories */
 	enum l2tp_encap_type	encap;
@@ -128,6 +148,12 @@ struct l2tp_tunnel_cfg {
 				udp6_zero_rx_checksums:1;
 };
 
+/* Represents a tunnel instance.
+ * Tracks runtime state including IO statistics.
+ * Holds the tunnel socket (either passed from userspace or directly created by the kernel).
+ * Maintains a hashlist of sessions belonging to the tunnel instance.
+ * Is linked into a per-net list of tunnels.
+ */
 struct l2tp_tunnel {
 	int			magic;		/* Should be L2TP_TUNNEL_MAGIC */
 
@@ -162,10 +188,23 @@ struct l2tp_tunnel {
 	struct work_struct	del_work;
 };
 
+/* Pseudowire ops callbacks for use with the l2tp genetlink interface */
 struct l2tp_nl_cmd_ops {
+	/* The pseudowire session create callback is responsible for creating a session
+	 * instance for a specific pseudowire type.
+	 * It must call l2tp_session_create and l2tp_session_register to register the
+	 * session instance, as well as carry out any pseudowire-specific initialisation.
+	 * It must return >= 0 on success, or an appropriate negative errno value on failure.
+	 */
 	int (*session_create)(struct net *net, struct l2tp_tunnel *tunnel,
 			      u32 session_id, u32 peer_session_id,
 			      struct l2tp_session_cfg *cfg);
+
+	/* The pseudowire session delete callback is responsible for initiating the deletion
+	 * of a session instance.
+	 * It must call l2tp_session_delete, as well as carry out any pseudowire-specific
+	 * teardown actions.
+	 */
 	void (*session_delete)(struct l2tp_session *session);
 };
 
@@ -174,11 +213,16 @@ static inline void *l2tp_session_priv(struct l2tp_session *session)
 	return &session->priv[0];
 }
 
+/* Tunnel and session refcounts */
 void l2tp_tunnel_inc_refcount(struct l2tp_tunnel *tunnel);
 void l2tp_tunnel_dec_refcount(struct l2tp_tunnel *tunnel);
 void l2tp_session_inc_refcount(struct l2tp_session *session);
 void l2tp_session_dec_refcount(struct l2tp_session *session);
 
+/* Tunnel and session lookup.
+ * These functions take a reference on the instances they return, so
+ * the caller must ensure that the reference is dropped appropriately.
+ */
 struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id);
 struct l2tp_tunnel *l2tp_tunnel_get_nth(const struct net *net, int nth);
 struct l2tp_session *l2tp_tunnel_get_session(struct l2tp_tunnel *tunnel,
@@ -189,33 +233,47 @@ struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth);
 struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
 						const char *ifname);
 
+/* Tunnel and session lifetime management.
+ * Creation of a new instance is a two-step process: create, then register.
+ * Destruction is triggered using the *_delete functions, and completes asynchronously.
+ */
 int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id,
 		       u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg,
 		       struct l2tp_tunnel **tunnelp);
 int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 			 struct l2tp_tunnel_cfg *cfg);
-
 void l2tp_tunnel_delete(struct l2tp_tunnel *tunnel);
+
 struct l2tp_session *l2tp_session_create(int priv_size,
 					 struct l2tp_tunnel *tunnel,
 					 u32 session_id, u32 peer_session_id,
 					 struct l2tp_session_cfg *cfg);
 int l2tp_session_register(struct l2tp_session *session,
 			  struct l2tp_tunnel *tunnel);
-
 void l2tp_session_delete(struct l2tp_session *session);
+
+/* Receive path helpers.  If data sequencing is enabled for the session these
+ * functions handle queuing and reordering prior to passing packets to the
+ * pseudowire code to be passed to userspace.
+ */
 void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		      unsigned char *ptr, unsigned char *optr, u16 hdrflags,
 		      int length);
 int l2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb);
-void l2tp_session_set_header_len(struct l2tp_session *session, int version);
 
+/* Transmit path helpers for sending packets over the tunnel socket. */
+void l2tp_session_set_header_len(struct l2tp_session *session, int version);
 int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb,
 		  int hdr_len);
 
-int l2tp_nl_register_ops(enum l2tp_pwtype pw_type,
-			 const struct l2tp_nl_cmd_ops *ops);
+/* Pseudowire management.
+ * Pseudowires should register with l2tp core on module init, and unregister
+ * on module exit.
+ */
+int l2tp_nl_register_ops(enum l2tp_pwtype pw_type, const struct l2tp_nl_cmd_ops *ops);
 void l2tp_nl_unregister_ops(enum l2tp_pwtype pw_type);
+
+/* IOCTL helper for IP encap modules. */
 int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg);
 
 static inline int l2tp_get_l2specific_len(struct l2tp_session *session)
-- 
2.17.1

