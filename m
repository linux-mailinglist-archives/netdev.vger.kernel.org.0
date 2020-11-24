Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF252C2E8B
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390890AbgKXR3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:29:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390815AbgKXR3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:29:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606238970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kw/6zL0+DwqJJoi4AemVttrsG0jEunMq0o/xAEP6HHU=;
        b=Np3duxPhSbr1gdoUM7gUaWI094SU5kthlu7hi3zEix0km6uCdI//O/K0pPxAo5MRE9ilOT
        TSnKlkpdqk3VhIvd9ERdqLl+BSyMVWgDTB+ya02EHUmRwswU0orkhr5LwETbjvWpampakX
        OmqoDa0qOnyGqOqhpLAqJRAGCekJ2I0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-OiTTr571PO67B39HYqt_fw-1; Tue, 24 Nov 2020 12:28:51 -0500
X-MC-Unique: OiTTr571PO67B39HYqt_fw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A8B586ABD6;
        Tue, 24 Nov 2020 17:28:50 +0000 (UTC)
Received: from f31.redhat.com (ovpn-113-8.rdu2.redhat.com [10.10.113.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 995195C1A3;
        Tue, 24 Nov 2020 17:28:46 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 3/3] tipc: update address terminology in code
Date:   Tue, 24 Nov 2020 12:28:34 -0500
Message-Id: <20201124172834.317966-4-jmaloy@redhat.com>
In-Reply-To: <20201124172834.317966-1-jmaloy@redhat.com>
References: <20201124172834.317966-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We update the terminology in the code so that deprecated structure
names and macros are replaced with those currently recommended in
the user API.

struct tipc_portid   -> struct tipc_socket_addr
struct tipc_name     -> struct tipc_service_addr
struct tipc_name_seq -> struct tipc_service_range

TIPC_ADDR_ID       -> TIPC_SOCKET_ADDR
TIPC_ADDR_NAME     -> TIPC_SERVICE_ADDR
TIPC_ADDR_NAMESEQ  -> TIPC_SERVICE_RANGE
TIPC_CFG_SRV       -> TIPC_NODE_STATE

Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/group.c      |  3 ++-
 net/tipc/group.h      |  3 ++-
 net/tipc/name_table.c | 11 ++++++-----
 net/tipc/net.c        |  2 +-
 net/tipc/socket.c     | 44 +++++++++++++++++++++----------------------
 net/tipc/subscr.c     |  5 +++--
 net/tipc/subscr.h     |  5 +++--
 net/tipc/topsrv.c     |  4 ++--
 8 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/net/tipc/group.c b/net/tipc/group.c
index b1fcd2ad5ecf..3e137d8c9d2f 100644
--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -2,6 +2,7 @@
  * net/tipc/group.c: TIPC group messaging code
  *
  * Copyright (c) 2017, Ericsson AB
+ * Copyright (c) 2020, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -359,7 +360,7 @@ struct tipc_nlist *tipc_group_dests(struct tipc_group *grp)
 	return &grp->dests;
 }
 
-void tipc_group_self(struct tipc_group *grp, struct tipc_name_seq *seq,
+void tipc_group_self(struct tipc_group *grp, struct tipc_service_range *seq,
 		     int *scope)
 {
 	seq->type = grp->type;
diff --git a/net/tipc/group.h b/net/tipc/group.h
index 76b4e5a7b39d..ea4c3be64c78 100644
--- a/net/tipc/group.h
+++ b/net/tipc/group.h
@@ -2,6 +2,7 @@
  * net/tipc/group.h: Include file for TIPC group unicast/multicast functions
  *
  * Copyright (c) 2017, Ericsson AB
+ * Copyright (c) 2020, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -50,7 +51,7 @@ void tipc_group_delete(struct net *net, struct tipc_group *grp);
 void tipc_group_add_member(struct tipc_group *grp, u32 node,
 			   u32 port, u32 instance);
 struct tipc_nlist *tipc_group_dests(struct tipc_group *grp);
-void tipc_group_self(struct tipc_group *grp, struct tipc_name_seq *seq,
+void tipc_group_self(struct tipc_group *grp, struct tipc_service_range *seq,
 		     int *scope);
 u32 tipc_group_exclude(struct tipc_group *grp);
 void tipc_group_filter_msg(struct tipc_group *grp,
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 2ac33d32edc2..e1233d6d5163 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2000-2006, 2014-2018, Ericsson AB
  * Copyright (c) 2004-2008, 2010-2014, Wind River Systems
+ * Copyright (c) 2020, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -403,12 +404,12 @@ static void tipc_service_subscribe(struct tipc_service *service,
 	struct publication *p, *first, *tmp;
 	struct list_head publ_list;
 	struct service_range *sr;
-	struct tipc_name_seq ns;
+	struct tipc_service_range r;
 	u32 filter;
 
-	ns.type = tipc_sub_read(sb, seq.type);
-	ns.lower = tipc_sub_read(sb, seq.lower);
-	ns.upper = tipc_sub_read(sb, seq.upper);
+	r.type = tipc_sub_read(sb, seq.type);
+	r.lower = tipc_sub_read(sb, seq.lower);
+	r.upper = tipc_sub_read(sb, seq.upper);
 	filter = tipc_sub_read(sb, filter);
 
 	tipc_sub_get(sub);
@@ -418,7 +419,7 @@ static void tipc_service_subscribe(struct tipc_service *service,
 		return;
 
 	INIT_LIST_HEAD(&publ_list);
-	service_range_foreach_match(sr, service, ns.lower, ns.upper) {
+	service_range_foreach_match(sr, service, r.lower, r.upper) {
 		first = NULL;
 		list_for_each_entry(p, &sr->all_publ, all_publ) {
 			if (filter & TIPC_SUB_PORTS)
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 0bb2323201da..a129f661bee3 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -132,7 +132,7 @@ static void tipc_net_finalize(struct net *net, u32 addr)
 	tipc_named_reinit(net);
 	tipc_sk_reinit(net);
 	tipc_mon_reinit_self(net);
-	tipc_nametbl_publish(net, TIPC_CFG_SRV, addr, addr,
+	tipc_nametbl_publish(net, TIPC_NODE_STATE, addr, addr,
 			     TIPC_CLUSTER_SCOPE, 0, addr);
 }
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 2b633463f40d..75e81fc8e9a8 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -139,9 +139,9 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 		       bool kern);
 static void tipc_sk_timeout(struct timer_list *t);
 static int tipc_sk_publish(struct tipc_sock *tsk, uint scope,
-			   struct tipc_name_seq const *seq);
+			   struct tipc_service_range const *seq);
 static int tipc_sk_withdraw(struct tipc_sock *tsk, uint scope,
-			    struct tipc_name_seq const *seq);
+			    struct tipc_service_range const *seq);
 static int tipc_sk_leave(struct tipc_sock *tsk);
 static struct tipc_sock *tipc_sk_lookup(struct net *net, u32 portid);
 static int tipc_sk_insert(struct tipc_sock *tsk);
@@ -667,7 +667,7 @@ static int __tipc_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
 	if (unlikely(!alen))
 		return tipc_sk_withdraw(tsk, 0, NULL);
 
-	if (addr->addrtype == TIPC_ADDR_NAME)
+	if (addr->addrtype == TIPC_SERVICE_ADDR)
 		addr->addr.nameseq.upper = addr->addr.nameseq.lower;
 
 	if (tsk->group)
@@ -740,7 +740,7 @@ static int tipc_getname(struct socket *sock, struct sockaddr *uaddr,
 		addr->addr.id.node = tipc_own_addr(sock_net(sk));
 	}
 
-	addr->addrtype = TIPC_ADDR_ID;
+	addr->addrtype = TIPC_SOCKET_ADDR;
 	addr->family = AF_TIPC;
 	addr->scope = 0;
 	addr->addr.name.domain = 0;
@@ -818,7 +818,7 @@ static __poll_t tipc_poll(struct file *file, struct socket *sock,
  * Called from function tipc_sendmsg(), which has done all sanity checks
  * Returns the number of bytes sent on success, or errno
  */
-static int tipc_sendmcast(struct  socket *sock, struct tipc_name_seq *seq,
+static int tipc_sendmcast(struct  socket *sock, struct tipc_service_range *seq,
 			  struct msghdr *msg, size_t dlen, long timeout)
 {
 	struct sock *sk = sock->sk;
@@ -1403,7 +1403,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	bool syn = !tipc_sk_type_connectionless(sk);
 	struct tipc_group *grp = tsk->group;
 	struct tipc_msg *hdr = &tsk->phdr;
-	struct tipc_name_seq *seq;
+	struct tipc_service_range *seq;
 	struct sk_buff_head pkts;
 	u32 dport = 0, dnode = 0;
 	u32 type = 0, inst = 0;
@@ -1422,9 +1422,9 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	if (grp) {
 		if (!dest)
 			return tipc_send_group_bcast(sock, m, dlen, timeout);
-		if (dest->addrtype == TIPC_ADDR_NAME)
+		if (dest->addrtype == TIPC_SERVICE_ADDR)
 			return tipc_send_group_anycast(sock, m, dlen, timeout);
-		if (dest->addrtype == TIPC_ADDR_ID)
+		if (dest->addrtype == TIPC_SOCKET_ADDR)
 			return tipc_send_group_unicast(sock, m, dlen, timeout);
 		if (dest->addrtype == TIPC_ADDR_MCAST)
 			return tipc_send_group_mcast(sock, m, dlen, timeout);
@@ -1444,7 +1444,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 			return -EISCONN;
 		if (tsk->published)
 			return -EOPNOTSUPP;
-		if (dest->addrtype == TIPC_ADDR_NAME) {
+		if (dest->addrtype == TIPC_SERVICE_ADDR) {
 			tsk->conn_type = dest->addr.name.name.type;
 			tsk->conn_instance = dest->addr.name.name.instance;
 		}
@@ -1455,14 +1455,14 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	if (dest->addrtype == TIPC_ADDR_MCAST)
 		return tipc_sendmcast(sock, seq, m, dlen, timeout);
 
-	if (dest->addrtype == TIPC_ADDR_NAME) {
+	if (dest->addrtype == TIPC_SERVICE_ADDR) {
 		type = dest->addr.name.name.type;
 		inst = dest->addr.name.name.instance;
 		dnode = dest->addr.name.domain;
 		dport = tipc_nametbl_translate(net, type, inst, &dnode);
 		if (unlikely(!dport && !dnode))
 			return -EHOSTUNREACH;
-	} else if (dest->addrtype == TIPC_ADDR_ID) {
+	} else if (dest->addrtype == TIPC_SOCKET_ADDR) {
 		dnode = dest->addr.id.node;
 	} else {
 		return -EINVAL;
@@ -1474,7 +1474,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	if (unlikely(rc))
 		return rc;
 
-	if (dest->addrtype == TIPC_ADDR_NAME) {
+	if (dest->addrtype == TIPC_SERVICE_ADDR) {
 		msg_set_type(hdr, TIPC_NAMED_MSG);
 		msg_set_hdr_sz(hdr, NAMED_H_SIZE);
 		msg_set_nametype(hdr, type);
@@ -1482,7 +1482,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 		msg_set_lookup_scope(hdr, tipc_node2scope(dnode));
 		msg_set_destnode(hdr, dnode);
 		msg_set_destport(hdr, dport);
-	} else { /* TIPC_ADDR_ID */
+	} else { /* TIPC_SOCKET_ADDR */
 		msg_set_type(hdr, TIPC_DIRECT_MSG);
 		msg_set_lookup_scope(hdr, 0);
 		msg_set_destnode(hdr, dnode);
@@ -1687,7 +1687,7 @@ static void tipc_sk_set_orig_addr(struct msghdr *m, struct sk_buff *skb)
 		return;
 
 	srcaddr->sock.family = AF_TIPC;
-	srcaddr->sock.addrtype = TIPC_ADDR_ID;
+	srcaddr->sock.addrtype = TIPC_SOCKET_ADDR;
 	srcaddr->sock.scope = 0;
 	srcaddr->sock.addr.id.ref = msg_origport(hdr);
 	srcaddr->sock.addr.id.node = msg_orignode(hdr);
@@ -1699,7 +1699,7 @@ static void tipc_sk_set_orig_addr(struct msghdr *m, struct sk_buff *skb)
 
 	/* Group message users may also want to know sending member's id */
 	srcaddr->member.family = AF_TIPC;
-	srcaddr->member.addrtype = TIPC_ADDR_NAME;
+	srcaddr->member.addrtype = TIPC_SERVICE_ADDR;
 	srcaddr->member.scope = 0;
 	srcaddr->member.addr.name.name.type = msg_nametype(hdr);
 	srcaddr->member.addr.name.name.instance = TIPC_SKB_CB(skb)->orig_member;
@@ -2867,7 +2867,7 @@ static void tipc_sk_timeout(struct timer_list *t)
 }
 
 static int tipc_sk_publish(struct tipc_sock *tsk, uint scope,
-			   struct tipc_name_seq const *seq)
+			   struct tipc_service_range const *seq)
 {
 	struct sock *sk = &tsk->sk;
 	struct net *net = sock_net(sk);
@@ -2895,7 +2895,7 @@ static int tipc_sk_publish(struct tipc_sock *tsk, uint scope,
 }
 
 static int tipc_sk_withdraw(struct tipc_sock *tsk, uint scope,
-			    struct tipc_name_seq const *seq)
+			    struct tipc_service_range const *seq)
 {
 	struct net *net = sock_net(&tsk->sk);
 	struct publication *publ;
@@ -3042,7 +3042,7 @@ static int tipc_sk_join(struct tipc_sock *tsk, struct tipc_group_req *mreq)
 	struct net *net = sock_net(&tsk->sk);
 	struct tipc_group *grp = tsk->group;
 	struct tipc_msg *hdr = &tsk->phdr;
-	struct tipc_name_seq seq;
+	struct tipc_service_range seq;
 	int rc;
 
 	if (mreq->type < TIPC_RESERVED_TYPES)
@@ -3079,7 +3079,7 @@ static int tipc_sk_leave(struct tipc_sock *tsk)
 {
 	struct net *net = sock_net(&tsk->sk);
 	struct tipc_group *grp = tsk->group;
-	struct tipc_name_seq seq;
+	struct tipc_service_range seq;
 	int scope;
 
 	if (!grp)
@@ -3203,7 +3203,7 @@ static int tipc_getsockopt(struct socket *sock, int lvl, int opt,
 {
 	struct sock *sk = sock->sk;
 	struct tipc_sock *tsk = tipc_sk(sk);
-	struct tipc_name_seq seq;
+	struct tipc_service_range seq;
 	int len, scope;
 	u32 value;
 	int res;
@@ -3304,12 +3304,12 @@ static int tipc_socketpair(struct socket *sock1, struct socket *sock2)
 	u32 onode = tipc_own_addr(sock_net(sock1->sk));
 
 	tsk1->peer.family = AF_TIPC;
-	tsk1->peer.addrtype = TIPC_ADDR_ID;
+	tsk1->peer.addrtype = TIPC_SOCKET_ADDR;
 	tsk1->peer.scope = TIPC_NODE_SCOPE;
 	tsk1->peer.addr.id.ref = tsk2->portid;
 	tsk1->peer.addr.id.node = onode;
 	tsk2->peer.family = AF_TIPC;
-	tsk2->peer.addrtype = TIPC_ADDR_ID;
+	tsk2->peer.addrtype = TIPC_SOCKET_ADDR;
 	tsk2->peer.scope = TIPC_NODE_SCOPE;
 	tsk2->peer.addr.id.ref = tsk1->portid;
 	tsk2->peer.addr.id.node = onode;
diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
index f340e53da625..5edfb2d522b9 100644
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2000-2017, Ericsson AB
  * Copyright (c) 2005-2007, 2010-2013, Wind River Systems
+ * Copyright (c) 2020, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -60,7 +61,7 @@ static void tipc_sub_send_event(struct tipc_subscription *sub,
  *
  * Returns 1 if there is overlap, otherwise 0.
  */
-int tipc_sub_check_overlap(struct tipc_name_seq *seq, u32 found_lower,
+int tipc_sub_check_overlap(struct tipc_service_range *seq, u32 found_lower,
 			   u32 found_upper)
 {
 	if (found_lower < seq->lower)
@@ -79,7 +80,7 @@ void tipc_sub_report_overlap(struct tipc_subscription *sub,
 {
 	struct tipc_subscr *s = &sub->evt.s;
 	u32 filter = tipc_sub_read(s, filter);
-	struct tipc_name_seq seq;
+	struct tipc_service_range seq;
 
 	seq.type = tipc_sub_read(s, seq.type);
 	seq.lower = tipc_sub_read(s, seq.lower);
diff --git a/net/tipc/subscr.h b/net/tipc/subscr.h
index 6ebbec1bedd1..a083b1b0c1d2 100644
--- a/net/tipc/subscr.h
+++ b/net/tipc/subscr.h
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2003-2017, Ericsson AB
  * Copyright (c) 2005-2007, 2012-2013, Wind River Systems
+ * Copyright (c) 2020, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -71,8 +72,8 @@ struct tipc_subscription *tipc_sub_subscribe(struct net *net,
 					     int conid);
 void tipc_sub_unsubscribe(struct tipc_subscription *sub);
 
-int tipc_sub_check_overlap(struct tipc_name_seq *seq, u32 found_lower,
-			   u32 found_upper);
+int tipc_sub_check_overlap(struct tipc_service_range *seq,
+			   u32 found_lower, u32 found_upper);
 void tipc_sub_report_overlap(struct tipc_subscription *sub,
 			     u32 found_lower, u32 found_upper,
 			     u32 event, u32 port, u32 node,
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 88ad39e47a98..5522865deae9 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -519,8 +519,8 @@ static int tipc_topsrv_create_listener(struct tipc_topsrv *srv)
 		goto err;
 
 	saddr.family	                = AF_TIPC;
-	saddr.addrtype		        = TIPC_ADDR_NAMESEQ;
-	saddr.addr.nameseq.type         = TIPC_TOP_SRV;
+	saddr.addrtype		        = TIPC_SERVICE_RANGE;
+	saddr.addr.nameseq.type	= TIPC_TOP_SRV;
 	saddr.addr.nameseq.lower	= TIPC_TOP_SRV;
 	saddr.addr.nameseq.upper	= TIPC_TOP_SRV;
 	saddr.scope			= TIPC_NODE_SCOPE;
-- 
2.25.4

