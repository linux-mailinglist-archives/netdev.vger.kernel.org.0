Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC1E6608FE
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbjAFVzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjAFVzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:55:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DF77F44C
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 13:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673042099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X8E5j31Lu/JWtPajnnF4aeVig1ox17nrF27XPorz280=;
        b=LTJFc+7YMhrcYSoMpgNgta/bAnnri6V2suT4JV3t08CQjB/o10Duf8p4QFY/pHa1esrjsb
        n+6qlz26GxUiOJZaN6yiYD1lRzBYo7ii9C8YmhuRE+Mh8rOhmJFlW30p5OIlV7pWsXdota
        fAdcOA3xdu01TEFJwchNgCSf2RJCsa0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-311-zFK_BlqQMHWsRd0XPz3Faw-1; Fri, 06 Jan 2023 16:54:56 -0500
X-MC-Unique: zFK_BlqQMHWsRd0XPz3Faw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7C291875042;
        Fri,  6 Jan 2023 21:54:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38C1840C945A;
        Fri,  6 Jan 2023 21:54:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <00000000000026c40c05f19b9b69@google.com>
References: <00000000000026c40c05f19b9b69@google.com>
To:     syzbot <syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] kernel BUG in rxrpc_put_peer
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1278569.1673042093.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 06 Jan 2023 21:54:53 +0000
Message-ID: <1278570.1673042093@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com> wrote:

> syzbot has tested the proposed patch but the reproducer is still trigger=
ing an issue:
> INFO: rcu detected stall in corrupted
> =

> rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5540 =
} 2684 jiffies s: 2885 root: 0x0/T
> rcu: blocking rcu_node structures (internal RCU debug):

Okay, I think this is very likely not due to rxrpc, but rather to one of t=
he
tunnel drivers used by the test (it seems to use a lot of different driver=
s).
I added the attached patch which removes almost every last bit of RCU from
rxrpc (there's still a bit because the UDP socket notification hooks requi=
re
it), and the problem still occurs.

However, the original problem seems to be fixed.

David
---
commit 9e80802b1c2374cdc7ed4a3fd40a3489ec8e9910
Author: David Howells <dhowells@redhat.com>
Date:   Fri Jan 6 09:49:06 2023 +0000

    rxrpc: TEST: Remove almost all use of RCU
    =

    ... to try and fix syzbot rcu issue

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index cf200e4e0eae..b746f8d556db 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -45,29 +45,11 @@ struct workqueue_struct *rxrpc_workqueue;
 =

 static void rxrpc_sock_destructor(struct sock *);
 =

-/*
- * see if an RxRPC socket is currently writable
- */
-static inline int rxrpc_writable(struct sock *sk)
-{
-	return refcount_read(&sk->sk_wmem_alloc) < (size_t) sk->sk_sndbuf;
-}
-
 /*
  * wait for write bufferage to become available
  */
 static void rxrpc_write_space(struct sock *sk)
 {
-	_enter("%p", sk);
-	rcu_read_lock();
-	if (rxrpc_writable(sk)) {
-		struct socket_wq *wq =3D rcu_dereference(sk->sk_wq);
-
-		if (skwq_has_sleeper(wq))
-			wake_up_interruptible(&wq->wait);
-		sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
-	}
-	rcu_read_unlock();
 }
 =

 /*
@@ -155,10 +137,10 @@ static int rxrpc_bind(struct socket *sock, struct so=
ckaddr *saddr, int len)
 =

 		if (service_id) {
 			write_lock(&local->services_lock);
-			if (rcu_access_pointer(local->service))
+			if (local->service)
 				goto service_in_use;
 			rx->local =3D local;
-			rcu_assign_pointer(local->service, rx);
+			local->service =3D rx;
 			write_unlock(&local->services_lock);
 =

 			rx->sk.sk_state =3D RXRPC_SERVER_BOUND;
@@ -738,8 +720,7 @@ static __poll_t rxrpc_poll(struct file *file, struct s=
ocket *sock,
 	/* the socket is writable if there is space to add new data to the
 	 * socket; there is no guarantee that any particular call in progress
 	 * on the socket may have space in the Tx ACK window */
-	if (rxrpc_writable(sk))
-		mask |=3D EPOLLOUT | EPOLLWRNORM;
+	mask |=3D EPOLLOUT | EPOLLWRNORM;
 =

 	return mask;
 }
@@ -875,9 +856,9 @@ static int rxrpc_release_sock(struct sock *sk)
 =

 	sk->sk_state =3D RXRPC_CLOSE;
 =

-	if (rx->local && rcu_access_pointer(rx->local->service) =3D=3D rx) {
+	if (rx->local && rx->local->service =3D=3D rx) {
 		write_lock(&rx->local->services_lock);
-		rcu_assign_pointer(rx->local->service, NULL);
+		rx->local->service =3D NULL;
 		write_unlock(&rx->local->services_lock);
 	}
 =

@@ -1053,12 +1034,6 @@ static void __exit af_rxrpc_exit(void)
 	proto_unregister(&rxrpc_proto);
 	unregister_pernet_device(&rxrpc_net_ops);
 	ASSERTCMP(atomic_read(&rxrpc_n_rx_skbs), =3D=3D, 0);
-
-	/* Make sure the local and peer records pinned by any dying connections
-	 * are released.
-	 */
-	rcu_barrier();
-
 	destroy_workqueue(rxrpc_workqueue);
 	rxrpc_exit_security();
 	kmem_cache_destroy(rxrpc_call_jar);
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 007258538bee..d21eea915967 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -283,7 +283,7 @@ struct rxrpc_local {
 	struct socket		*socket;	/* my UDP socket */
 	struct task_struct	*io_thread;
 	struct completion	io_thread_ready; /* Indication that the I/O thread sta=
rted */
-	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoi=
nt */
+	struct rxrpc_sock	*service;	/* Service(s) listening on this endpoint */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 	struct sk_buff_head	rx_queue;	/* Received packets */
 	struct list_head	conn_attend_q;	/* Conns requiring immediate attention *=
/
@@ -313,7 +313,6 @@ struct rxrpc_local {
  * - matched by local endpoint, remote port, address and protocol type
  */
 struct rxrpc_peer {
-	struct rcu_head		rcu;		/* This must be first */
 	refcount_t		ref;
 	unsigned long		hash_key;
 	struct hlist_node	hash_link;
@@ -460,7 +459,6 @@ struct rxrpc_connection {
 =

 	refcount_t		ref;
 	atomic_t		active;		/* Active count for service conns */
-	struct rcu_head		rcu;
 	struct list_head	cache_link;
 =

 	unsigned char		act_chans;	/* Mask of active channels */
@@ -593,12 +591,11 @@ enum rxrpc_congest_mode {
  * - matched by { connection, call_id }
  */
 struct rxrpc_call {
-	struct rcu_head		rcu;
 	struct rxrpc_connection	*conn;		/* connection carrying call */
 	struct rxrpc_bundle	*bundle;	/* Connection bundle to use */
 	struct rxrpc_peer	*peer;		/* Peer record for remote address */
 	struct rxrpc_local	*local;		/* Representation of local endpoint */
-	struct rxrpc_sock __rcu	*socket;	/* socket responsible */
+	struct rxrpc_sock	*socket;	/* socket responsible */
 	struct rxrpc_net	*rxnet;		/* Network namespace to which call belongs */
 	struct key		*key;		/* Security details */
 	const struct rxrpc_security *security;	/* applied security module */
@@ -770,7 +767,6 @@ struct rxrpc_send_params {
  * Buffer of data to be output as a packet.
  */
 struct rxrpc_txbuf {
-	struct rcu_head		rcu;
 	struct list_head	call_link;	/* Link in call->tx_sendmsg/tx_buffer */
 	struct list_head	tx_link;	/* Link in live Enc queue or Tx queue */
 	ktime_t			last_sent;	/* Time at which last transmitted */
@@ -979,9 +975,9 @@ extern unsigned int rxrpc_closed_conn_expiry;
 =

 void rxrpc_poke_conn(struct rxrpc_connection *conn, enum rxrpc_conn_trace=
 why);
 struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *, gfp_t=
);
-struct rxrpc_connection *rxrpc_find_client_connection_rcu(struct rxrpc_lo=
cal *,
-							  struct sockaddr_rxrpc *,
-							  struct sk_buff *);
+struct rxrpc_connection *rxrpc_find_client_connection(struct rxrpc_local =
*,
+						      struct sockaddr_rxrpc *,
+						      struct sk_buff *);
 void __rxrpc_disconnect_call(struct rxrpc_connection *, struct rxrpc_call=
 *);
 void rxrpc_disconnect_call(struct rxrpc_call *);
 void rxrpc_kill_client_conn(struct rxrpc_connection *);
@@ -1014,8 +1010,8 @@ static inline void rxrpc_reduce_conn_timer(struct rx=
rpc_connection *conn,
 /*
  * conn_service.c
  */
-struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *,
-						     struct sk_buff *);
+struct rxrpc_connection *rxrpc_find_service_conn(struct rxrpc_peer *,
+						 struct sk_buff *);
 struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_n=
et *, gfp_t);
 void rxrpc_new_incoming_connection(struct rxrpc_sock *, struct rxrpc_conn=
ection *,
 				   const struct rxrpc_security *, struct sk_buff *);
@@ -1141,8 +1137,8 @@ void rxrpc_peer_keepalive_worker(struct work_struct =
*);
 /*
  * peer_object.c
  */
-struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *,
-					 const struct sockaddr_rxrpc *);
+struct rxrpc_peer *rxrpc_find_peer(struct rxrpc_local *,
+				   const struct sockaddr_rxrpc *);
 struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_local *local,
 				     struct sockaddr_rxrpc *srx, gfp_t gfp);
 struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *, gfp_t,
@@ -1156,10 +1152,6 @@ void rxrpc_put_peer(struct rxrpc_peer *, enum rxrpc=
_peer_trace);
 /*
  * proc.c
  */
-extern const struct seq_operations rxrpc_call_seq_ops;
-extern const struct seq_operations rxrpc_connection_seq_ops;
-extern const struct seq_operations rxrpc_peer_seq_ops;
-extern const struct seq_operations rxrpc_local_seq_ops;
 =

 /*
  * recvmsg.c
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 3fbf2fcaaf9e..7dd7a9a37632 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -139,7 +139,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_soc=
k *rx,
 =

 	rxnet =3D call->rxnet;
 	spin_lock(&rxnet->call_lock);
-	list_add_tail_rcu(&call->link, &rxnet->calls);
+	list_add_tail(&call->link, &rxnet->calls);
 	spin_unlock(&rxnet->call_lock);
 =

 	b->call_backlog[call_head] =3D call;
@@ -218,7 +218,7 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 	tail =3D b->call_backlog_tail;
 	while (CIRC_CNT(head, tail, size) > 0) {
 		struct rxrpc_call *call =3D b->call_backlog[tail];
-		rcu_assign_pointer(call->socket, rx);
+		call->socket =3D rx;
 		if (rx->discard_new_call) {
 			_debug("discard %lx", call->user_call_ID);
 			rx->discard_new_call(call, call->user_call_ID);
@@ -343,13 +343,13 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *loc=
al,
 	if (sp->hdr.type !=3D RXRPC_PACKET_TYPE_DATA)
 		return rxrpc_protocol_error(skb, rxrpc_eproto_no_service_call);
 =

-	rcu_read_lock();
+	read_lock(&local->services_lock);
 =

 	/* Weed out packets to services we're not offering.  Packets that would
 	 * begin a call are explicitly rejected and the rest are just
 	 * discarded.
 	 */
-	rx =3D rcu_dereference(local->service);
+	rx =3D local->service;
 	if (!rx || (sp->hdr.serviceId !=3D rx->srx.srx_service &&
 		    sp->hdr.serviceId !=3D rx->second_service)
 	    ) {
@@ -399,7 +399,7 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local=
,
 	spin_unlock(&conn->state_lock);
 =

 	spin_unlock(&rx->incoming_lock);
-	rcu_read_unlock();
+	read_unlock(&local->services_lock);
 =

 	if (hlist_unhashed(&call->error_link)) {
 		spin_lock(&call->peer->lock);
@@ -413,20 +413,20 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *loc=
al,
 	return true;
 =

 unsupported_service:
-	rcu_read_unlock();
+	read_unlock(&local->services_lock);
 	return rxrpc_direct_abort(skb, rxrpc_abort_service_not_offered,
 				  RX_INVALID_OPERATION, -EOPNOTSUPP);
 unsupported_security:
-	rcu_read_unlock();
+	read_unlock(&local->services_lock);
 	return rxrpc_direct_abort(skb, rxrpc_abort_service_not_offered,
 				  RX_INVALID_OPERATION, -EKEYREJECTED);
 no_call:
 	spin_unlock(&rx->incoming_lock);
-	rcu_read_unlock();
+	read_unlock(&local->services_lock);
 	_leave(" =3D f [%u]", skb->mark);
 	return false;
 discard:
-	rcu_read_unlock();
+	read_unlock(&local->services_lock);
 	return true;
 }
 =

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 1abdef15debc..436b8db6667a 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -76,8 +76,7 @@ void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reas=
on,
 =

 	rxrpc_inc_stat(call->rxnet, stat_tx_acks[ack_reason]);
 =

-	txb =3D rxrpc_alloc_txbuf(call, RXRPC_PACKET_TYPE_ACK,
-				rcu_read_lock_held() ? GFP_ATOMIC | __GFP_NOWARN : GFP_NOFS);
+	txb =3D rxrpc_alloc_txbuf(call, RXRPC_PACKET_TYPE_ACK, GFP_NOFS);
 	if (!txb) {
 		kleave(" =3D -ENOMEM");
 		return;
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 3ded5a24627c..54c1dc7dde5c 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -377,7 +377,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_=
sock *rx,
 			goto error_dup_user_ID;
 	}
 =

-	rcu_assign_pointer(call->socket, rx);
+	call->socket =3D rx;
 	call->user_call_ID =3D p->user_call_ID;
 	__set_bit(RXRPC_CALL_HAS_USERID, &call->flags);
 	rxrpc_get_call(call, rxrpc_call_get_userid);
@@ -389,7 +389,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_=
sock *rx,
 =

 	rxnet =3D call->rxnet;
 	spin_lock(&rxnet->call_lock);
-	list_add_tail_rcu(&call->link, &rxnet->calls);
+	list_add_tail(&call->link, &rxnet->calls);
 	spin_unlock(&rxnet->call_lock);
 =

 	/* From this point on, the call is protected by its own lock. */
@@ -448,7 +448,7 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 =

 	_enter(",%d", call->conn->debug_id);
 =

-	rcu_assign_pointer(call->socket, rx);
+	call->socket		=3D rx;
 	call->call_id		=3D sp->hdr.callNumber;
 	call->dest_srx.srx_service =3D sp->hdr.serviceId;
 	call->cid		=3D sp->hdr.cid;
@@ -655,11 +655,10 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rx=
rpc_call_trace why)
 }
 =

 /*
- * Free up the call under RCU.
+ * Free up the call.
  */
-static void rxrpc_rcu_free_call(struct rcu_head *rcu)
+static void rxrpc_free_call(struct rxrpc_call *call)
 {
-	struct rxrpc_call *call =3D container_of(rcu, struct rxrpc_call, rcu);
 	struct rxrpc_net *rxnet =3D READ_ONCE(call->rxnet);
 =

 	kmem_cache_free(rxrpc_call_jar, call);
@@ -695,7 +694,7 @@ static void rxrpc_destroy_call(struct work_struct *wor=
k)
 	rxrpc_put_bundle(call->bundle, rxrpc_bundle_put_call);
 	rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
 	rxrpc_put_local(call->local, rxrpc_local_put_call);
-	call_rcu(&call->rcu, rxrpc_rcu_free_call);
+	rxrpc_free_call(call);
 }
 =

 /*
@@ -709,14 +708,7 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
 =

 	del_timer(&call->timer);
-
-	if (rcu_read_lock_held())
-		/* Can't use the rxrpc workqueue as we need to cancel/flush
-		 * something that may be running/waiting there.
-		 */
-		schedule_work(&call->destroyer);
-	else
-		rxrpc_destroy_call(&call->destroyer);
+	rxrpc_destroy_call(&call->destroyer);
 }
 =

 /*
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index ac85d4644a3c..beef64d14d98 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -88,12 +88,10 @@ struct rxrpc_connection *rxrpc_alloc_connection(struct=
 rxrpc_net *rxnet,
  *
  * When searching for a service call, if we find a peer but no connection=
, we
  * return that through *_peer in case we need to create a new service cal=
l.
- *
- * The caller must be holding the RCU read lock.
  */
-struct rxrpc_connection *rxrpc_find_client_connection_rcu(struct rxrpc_lo=
cal *local,
-							  struct sockaddr_rxrpc *srx,
-							  struct sk_buff *skb)
+struct rxrpc_connection *rxrpc_find_client_connection(struct rxrpc_local =
*local,
+						      struct sockaddr_rxrpc *srx,
+						      struct sk_buff *skb)
 {
 	struct rxrpc_connection *conn;
 	struct rxrpc_skb_priv *sp =3D rxrpc_skb(skb);
@@ -286,10 +284,8 @@ static void rxrpc_set_service_reap_timer(struct rxrpc=
_net *rxnet,
 /*
  * destroy a virtual connection
  */
-static void rxrpc_rcu_free_connection(struct rcu_head *rcu)
+static void rxrpc_free_connection(struct rxrpc_connection *conn)
 {
-	struct rxrpc_connection *conn =3D
-		container_of(rcu, struct rxrpc_connection, rcu);
 	struct rxrpc_net *rxnet =3D conn->rxnet;
 =

 	_enter("{%d,u=3D%d}", conn->debug_id, refcount_read(&conn->ref));
@@ -341,7 +337,7 @@ static void rxrpc_clean_up_connection(struct work_stru=
ct *work)
 	 */
 	rxrpc_purge_queue(&conn->rx_queue);
 =

-	call_rcu(&conn->rcu, rxrpc_rcu_free_connection);
+	rxrpc_free_connection(conn);
 }
 =

 /*
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index f30323de82bd..0d4e34c8c7ad 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -14,7 +14,7 @@ static struct rxrpc_bundle rxrpc_service_dummy_bundle =3D=
 {
 };
 =

 /*
- * Find a service connection under RCU conditions.
+ * Find a service connection conditions.
  *
  * We could use a hash table, but that is subject to bucket stuffing by a=
n
  * attacker as the client gets to pick the epoch and cid values and would=
 know
@@ -23,40 +23,33 @@ static struct rxrpc_bundle rxrpc_service_dummy_bundle =
=3D {
  * it might be slower than a large hash table, but it is at least limited=
 in
  * depth.
  */
-struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *p=
eer,
-						     struct sk_buff *skb)
+struct rxrpc_connection *rxrpc_find_service_conn(struct rxrpc_peer *peer,
+						 struct sk_buff *skb)
 {
 	struct rxrpc_connection *conn =3D NULL;
 	struct rxrpc_conn_proto k;
 	struct rxrpc_skb_priv *sp =3D rxrpc_skb(skb);
 	struct rb_node *p;
-	unsigned int seq =3D 0;
 =

 	k.epoch	=3D sp->hdr.epoch;
 	k.cid	=3D sp->hdr.cid & RXRPC_CIDMASK;
 =

-	do {
-		/* Unfortunately, rbtree walking doesn't give reliable results
-		 * under just the RCU read lock, so we have to check for
-		 * changes.
-		 */
-		read_seqbegin_or_lock(&peer->service_conn_lock, &seq);
-
-		p =3D rcu_dereference_raw(peer->service_conns.rb_node);
-		while (p) {
-			conn =3D rb_entry(p, struct rxrpc_connection, service_node);
-
-			if (conn->proto.index_key < k.index_key)
-				p =3D rcu_dereference_raw(p->rb_left);
-			else if (conn->proto.index_key > k.index_key)
-				p =3D rcu_dereference_raw(p->rb_right);
-			else
-				break;
-			conn =3D NULL;
-		}
-	} while (need_seqretry(&peer->service_conn_lock, seq));
-
-	done_seqretry(&peer->service_conn_lock, seq);
+	read_seqlock_excl(&peer->service_conn_lock);
+
+	p =3D peer->service_conns.rb_node;
+	while (p) {
+		conn =3D rb_entry(p, struct rxrpc_connection, service_node);
+
+		if (conn->proto.index_key < k.index_key)
+			p =3D p->rb_left;
+		else if (conn->proto.index_key > k.index_key)
+			p =3D p->rb_right;
+		else
+			break;
+		conn =3D NULL;
+	}
+
+	read_sequnlock_excl(&peer->service_conn_lock);
 	_leave(" =3D %d", conn ? conn->debug_id : -1);
 	return conn;
 }
@@ -89,7 +82,7 @@ static void rxrpc_publish_service_conn(struct rxrpc_peer=
 *peer,
 			goto found_extant_conn;
 	}
 =

-	rb_link_node_rcu(&conn->service_node, parent, pp);
+	rb_link_node(&conn->service_node, parent, pp);
 	rb_insert_color(&conn->service_node, &peer->service_conns);
 conn_published:
 	set_bit(RXRPC_CONN_IN_SERVICE_CONNS, &conn->flags);
@@ -110,9 +103,9 @@ static void rxrpc_publish_service_conn(struct rxrpc_pe=
er *peer,
 replace_old_connection:
 	/* The old connection is from an outdated epoch. */
 	_debug("replace conn");
-	rb_replace_node_rcu(&cursor->service_node,
-			    &conn->service_node,
-			    &peer->service_conns);
+	rb_replace_node(&cursor->service_node,
+			&conn->service_node,
+			&peer->service_conns);
 	clear_bit(RXRPC_CONN_IN_SERVICE_CONNS, &cursor->flags);
 	goto conn_published;
 }
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 367927a99881..ad622d185dea 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -210,7 +210,7 @@ static bool rxrpc_rotate_tx_window(struct rxrpc_call *=
call, rxrpc_seq_t to,
 	struct rxrpc_txbuf *txb;
 	bool rot_last =3D false;
 =

-	list_for_each_entry_rcu(txb, &call->tx_buffer, call_link, false) {
+	list_for_each_entry(txb, &call->tx_buffer, call_link) {
 		if (before_eq(txb->seq, call->acks_hard_ack))
 			continue;
 		summary->nr_rot_new_acks++;
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 9e9dfb2fc559..b9e6f1e3c6fc 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -259,10 +259,8 @@ static bool rxrpc_input_packet(struct rxrpc_local *lo=
cal, struct sk_buff **_skb)
 	}
 =

 	if (rxrpc_to_client(sp)) {
-		rcu_read_lock();
-		conn =3D rxrpc_find_client_connection_rcu(local, &peer_srx, skb);
+		conn =3D rxrpc_find_client_connection(local, &peer_srx, skb);
 		conn =3D rxrpc_get_connection_maybe(conn, rxrpc_conn_get_call_input);
-		rcu_read_unlock();
 		if (!conn)
 			return rxrpc_protocol_error(skb, rxrpc_eproto_no_client_conn);
 =

@@ -275,25 +273,25 @@ static bool rxrpc_input_packet(struct rxrpc_local *l=
ocal, struct sk_buff **_skb)
 	 * parameter set.  We look up the peer first as an intermediate step
 	 * and then the connection from the peer's tree.
 	 */
-	rcu_read_lock();
+	spin_lock(&local->rxnet->peer_hash_lock);
 =

-	peer =3D rxrpc_lookup_peer_rcu(local, &peer_srx);
+	peer =3D rxrpc_find_peer(local, &peer_srx);
 	if (!peer) {
-		rcu_read_unlock();
+		spin_lock(&local->rxnet->peer_hash_lock);
 		return rxrpc_new_incoming_call(local, NULL, NULL, &peer_srx, skb);
 	}
 =

-	conn =3D rxrpc_find_service_conn_rcu(peer, skb);
+	conn =3D rxrpc_find_service_conn(peer, skb);
 	conn =3D rxrpc_get_connection_maybe(conn, rxrpc_conn_get_call_input);
 	if (conn) {
-		rcu_read_unlock();
+		spin_unlock(&local->rxnet->peer_hash_lock);
 		ret =3D rxrpc_input_packet_on_conn(conn, &peer_srx, skb);
 		rxrpc_put_connection(conn, rxrpc_conn_put_call_input);
 		return ret;
 	}
 =

 	peer =3D rxrpc_get_peer_maybe(peer, rxrpc_peer_get_input);
-	rcu_read_unlock();
+	spin_unlock(&local->rxnet->peer_hash_lock);
 =

 	ret =3D rxrpc_new_incoming_call(local, peer, NULL, &peer_srx, skb);
 	rxrpc_put_peer(peer, rxrpc_peer_put_input);
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index b8eaca5d9f22..3d2707d7f478 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -285,10 +285,10 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *n=
et,
 		goto sock_error;
 =

 	if (cursor) {
-		hlist_replace_rcu(cursor, &local->link);
-		cursor->pprev =3D NULL;
+		hlist_add_before(&local->link, cursor);
+		hlist_del_init(cursor);
 	} else {
-		hlist_add_head_rcu(&local->link, &rxnet->local_endpoints);
+		hlist_add_head(&local->link, &rxnet->local_endpoints);
 	}
 =

 found:
@@ -417,7 +417,7 @@ void rxrpc_destroy_local(struct rxrpc_local *local)
 	local->dead =3D true;
 =

 	mutex_lock(&rxnet->local_mutex);
-	hlist_del_init_rcu(&local->link);
+	hlist_del_init(&local->link);
 	mutex_unlock(&rxnet->local_mutex);
 =

 	rxrpc_clean_up_local_conns(local);
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index a0319c040c25..1f36d27cf257 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -73,17 +73,6 @@ static __net_init int rxrpc_init_net(struct net *net)
 	if (!rxnet->proc_net)
 		goto err_proc;
 =

-	proc_create_net("calls", 0444, rxnet->proc_net, &rxrpc_call_seq_ops,
-			sizeof(struct seq_net_private));
-	proc_create_net("conns", 0444, rxnet->proc_net,
-			&rxrpc_connection_seq_ops,
-			sizeof(struct seq_net_private));
-	proc_create_net("peers", 0444, rxnet->proc_net,
-			&rxrpc_peer_seq_ops,
-			sizeof(struct seq_net_private));
-	proc_create_net("locals", 0444, rxnet->proc_net,
-			&rxrpc_local_seq_ops,
-			sizeof(struct seq_net_private));
 	proc_create_net_single_write("stats", S_IFREG | 0644, rxnet->proc_net,
 				     rxrpc_stats_show, rxrpc_stats_clear, NULL);
 	return 0;
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 552ba84a255c..a44289cf54f6 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -25,11 +25,12 @@ static void rxrpc_distribute_error(struct rxrpc_peer *=
, struct sk_buff *,
 /*
  * Find the peer associated with a local error.
  */
-static struct rxrpc_peer *rxrpc_lookup_peer_local_rcu(struct rxrpc_local =
*local,
-						      const struct sk_buff *skb,
-						      struct sockaddr_rxrpc *srx)
+static struct rxrpc_peer *rxrpc_lookup_peer_local(struct rxrpc_local *loc=
al,
+						  const struct sk_buff *skb,
+						  struct sockaddr_rxrpc *srx)
 {
 	struct sock_exterr_skb *serr =3D SKB_EXT_ERR(skb);
+	struct rxrpc_peer *peer;
 =

 	_enter("");
 =

@@ -94,7 +95,11 @@ static struct rxrpc_peer *rxrpc_lookup_peer_local_rcu(s=
truct rxrpc_local *local,
 		BUG();
 	}
 =

-	return rxrpc_lookup_peer_rcu(local, srx);
+	spin_lock(&local->rxnet->peer_hash_lock);
+	peer =3D rxrpc_find_peer(local, srx);
+	peer =3D rxrpc_get_peer_maybe(peer, rxrpc_peer_get_input_error);
+	spin_unlock(&local->rxnet->peer_hash_lock);
+	return peer;
 }
 =

 /*
@@ -144,11 +149,7 @@ void rxrpc_input_error(struct rxrpc_local *local, str=
uct sk_buff *skb)
 		return;
 	}
 =

-	rcu_read_lock();
-	peer =3D rxrpc_lookup_peer_local_rcu(local, skb, &srx);
-	if (peer && !rxrpc_get_peer_maybe(peer, rxrpc_peer_get_input_error))
-		peer =3D NULL;
-	rcu_read_unlock();
+	peer =3D rxrpc_lookup_peer_local(local, skb, &srx);
 	if (!peer)
 		return;
 =

diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 8d7a715a0bb1..8d2fd34411ee 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -111,15 +111,14 @@ static long rxrpc_peer_cmp_key(const struct rxrpc_pe=
er *peer,
 /*
  * Look up a remote transport endpoint for the specified address using RC=
U.
  */
-static struct rxrpc_peer *__rxrpc_lookup_peer_rcu(
-	struct rxrpc_local *local,
-	const struct sockaddr_rxrpc *srx,
-	unsigned long hash_key)
+static struct rxrpc_peer *__rxrpc_find_peer(struct rxrpc_local *local,
+					    const struct sockaddr_rxrpc *srx,
+					    unsigned long hash_key)
 {
 	struct rxrpc_peer *peer;
 	struct rxrpc_net *rxnet =3D local->rxnet;
 =

-	hash_for_each_possible_rcu(rxnet->peer_hash, peer, hash_link, hash_key) =
{
+	hash_for_each_possible(rxnet->peer_hash, peer, hash_link, hash_key) {
 		if (rxrpc_peer_cmp_key(peer, local, srx, hash_key) =3D=3D 0 &&
 		    refcount_read(&peer->ref) > 0)
 			return peer;
@@ -129,15 +128,15 @@ static struct rxrpc_peer *__rxrpc_lookup_peer_rcu(
 }
 =

 /*
- * Look up a remote transport endpoint for the specified address using RC=
U.
+ * Look up a remote transport endpoint for the specified address.
  */
-struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *local,
-					 const struct sockaddr_rxrpc *srx)
+struct rxrpc_peer *rxrpc_find_peer(struct rxrpc_local *local,
+				   const struct sockaddr_rxrpc *srx)
 {
 	struct rxrpc_peer *peer;
 	unsigned long hash_key =3D rxrpc_peer_hash_key(local, srx);
 =

-	peer =3D __rxrpc_lookup_peer_rcu(local, srx, hash_key);
+	peer =3D __rxrpc_find_peer(local, srx, hash_key);
 	if (peer)
 		_leave(" =3D %p {u=3D%d}", peer, refcount_read(&peer->ref));
 	return peer;
@@ -295,7 +294,7 @@ static void rxrpc_free_peer(struct rxrpc_peer *peer)
 {
 	trace_rxrpc_peer(peer->debug_id, 0, rxrpc_peer_free);
 	rxrpc_put_local(peer->local, rxrpc_local_put_peer);
-	kfree_rcu(peer, rcu);
+	kfree(peer);
 }
 =

 /*
@@ -312,7 +311,7 @@ void rxrpc_new_incoming_peer(struct rxrpc_local *local=
, struct rxrpc_peer *peer)
 	rxrpc_init_peer(local, peer, hash_key);
 =

 	spin_lock(&rxnet->peer_hash_lock);
-	hash_add_rcu(rxnet->peer_hash, &peer->hash_link, hash_key);
+	hash_add(rxnet->peer_hash, &peer->hash_link, hash_key);
 	list_add_tail(&peer->keepalive_link, &rxnet->peer_keepalive_new);
 	spin_unlock(&rxnet->peer_hash_lock);
 }
@@ -330,11 +329,11 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_lo=
cal *local,
 	_enter("{%pISp}", &srx->transport);
 =

 	/* search the peer list first */
-	rcu_read_lock();
-	peer =3D __rxrpc_lookup_peer_rcu(local, srx, hash_key);
+	spin_lock(&rxnet->peer_hash_lock);
+	peer =3D __rxrpc_find_peer(local, srx, hash_key);
 	if (peer && !rxrpc_get_peer_maybe(peer, rxrpc_peer_get_lookup_client))
 		peer =3D NULL;
-	rcu_read_unlock();
+	spin_unlock(&rxnet->peer_hash_lock);
 =

 	if (!peer) {
 		/* The peer is not yet present in hash - create a candidate
@@ -349,12 +348,12 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_lo=
cal *local,
 		spin_lock(&rxnet->peer_hash_lock);
 =

 		/* Need to check that we aren't racing with someone else */
-		peer =3D __rxrpc_lookup_peer_rcu(local, srx, hash_key);
+		peer =3D __rxrpc_find_peer(local, srx, hash_key);
 		if (peer && !rxrpc_get_peer_maybe(peer, rxrpc_peer_get_lookup_client))
 			peer =3D NULL;
 		if (!peer) {
-			hash_add_rcu(rxnet->peer_hash,
-				     &candidate->hash_link, hash_key);
+			hash_add(rxnet->peer_hash,
+				 &candidate->hash_link, hash_key);
 			list_add_tail(&candidate->keepalive_link,
 				      &rxnet->peer_keepalive_new);
 		}
@@ -410,7 +409,7 @@ static void __rxrpc_put_peer(struct rxrpc_peer *peer)
 	ASSERT(hlist_empty(&peer->error_targets));
 =

 	spin_lock(&rxnet->peer_hash_lock);
-	hash_del_rcu(&peer->hash_link);
+	hash_del(&peer->hash_link);
 	list_del_init(&peer->keepalive_link);
 	spin_unlock(&rxnet->peer_hash_lock);
 =

diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 750158a085cd..84fa70fe2d74 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -10,392 +10,6 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 =

-static const char *const rxrpc_conn_states[RXRPC_CONN__NR_STATES] =3D {
-	[RXRPC_CONN_UNUSED]			=3D "Unused  ",
-	[RXRPC_CONN_CLIENT_UNSECURED]		=3D "ClUnsec ",
-	[RXRPC_CONN_CLIENT]			=3D "Client  ",
-	[RXRPC_CONN_SERVICE_PREALLOC]		=3D "SvPrealc",
-	[RXRPC_CONN_SERVICE_UNSECURED]		=3D "SvUnsec ",
-	[RXRPC_CONN_SERVICE_CHALLENGING]	=3D "SvChall ",
-	[RXRPC_CONN_SERVICE]			=3D "SvSecure",
-	[RXRPC_CONN_ABORTED]			=3D "Aborted ",
-};
-
-/*
- * generate a list of extant and dead calls in /proc/net/rxrpc_calls
- */
-static void *rxrpc_call_seq_start(struct seq_file *seq, loff_t *_pos)
-	__acquires(rcu)
-{
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-
-	rcu_read_lock();
-	return seq_list_start_head_rcu(&rxnet->calls, *_pos);
-}
-
-static void *rxrpc_call_seq_next(struct seq_file *seq, void *v, loff_t *p=
os)
-{
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-
-	return seq_list_next_rcu(v, &rxnet->calls, pos);
-}
-
-static void rxrpc_call_seq_stop(struct seq_file *seq, void *v)
-	__releases(rcu)
-{
-	rcu_read_unlock();
-}
-
-static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
-{
-	struct rxrpc_local *local;
-	struct rxrpc_call *call;
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-	enum rxrpc_call_state state;
-	unsigned long timeout =3D 0;
-	rxrpc_seq_t acks_hard_ack;
-	char lbuff[50], rbuff[50];
-	u64 wtmp;
-
-	if (v =3D=3D &rxnet->calls) {
-		seq_puts(seq,
-			 "Proto Local                                          "
-			 " Remote                                         "
-			 " SvID ConnID   CallID   End Use State    Abort   "
-			 " DebugId  TxSeq    TW RxSeq    RW RxSerial CW RxTimo\n");
-		return 0;
-	}
-
-	call =3D list_entry(v, struct rxrpc_call, link);
-
-	local =3D call->local;
-	if (local)
-		sprintf(lbuff, "%pISpc", &local->srx.transport);
-	else
-		strcpy(lbuff, "no_local");
-
-	sprintf(rbuff, "%pISpc", &call->dest_srx.transport);
-
-	state =3D rxrpc_call_state(call);
-	if (state !=3D RXRPC_CALL_SERVER_PREALLOC) {
-		timeout =3D READ_ONCE(call->expect_rx_by);
-		timeout -=3D jiffies;
-	}
-
-	acks_hard_ack =3D READ_ONCE(call->acks_hard_ack);
-	wtmp   =3D atomic64_read_acquire(&call->ackr_window);
-	seq_printf(seq,
-		   "UDP   %-47.47s %-47.47s %4x %08x %08x %s %3u"
-		   " %-8.8s %08x %08x %08x %02x %08x %02x %08x %02x %06lx\n",
-		   lbuff,
-		   rbuff,
-		   call->dest_srx.srx_service,
-		   call->cid,
-		   call->call_id,
-		   rxrpc_is_service_call(call) ? "Svc" : "Clt",
-		   refcount_read(&call->ref),
-		   rxrpc_call_states[state],
-		   call->abort_code,
-		   call->debug_id,
-		   acks_hard_ack, READ_ONCE(call->tx_top) - acks_hard_ack,
-		   lower_32_bits(wtmp), upper_32_bits(wtmp) - lower_32_bits(wtmp),
-		   call->rx_serial,
-		   call->cong_cwnd,
-		   timeout);
-
-	return 0;
-}
-
-const struct seq_operations rxrpc_call_seq_ops =3D {
-	.start  =3D rxrpc_call_seq_start,
-	.next   =3D rxrpc_call_seq_next,
-	.stop   =3D rxrpc_call_seq_stop,
-	.show   =3D rxrpc_call_seq_show,
-};
-
-/*
- * generate a list of extant virtual connections in /proc/net/rxrpc_conns
- */
-static void *rxrpc_connection_seq_start(struct seq_file *seq, loff_t *_po=
s)
-	__acquires(rxnet->conn_lock)
-{
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-
-	read_lock(&rxnet->conn_lock);
-	return seq_list_start_head(&rxnet->conn_proc_list, *_pos);
-}
-
-static void *rxrpc_connection_seq_next(struct seq_file *seq, void *v,
-				       loff_t *pos)
-{
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-
-	return seq_list_next(v, &rxnet->conn_proc_list, pos);
-}
-
-static void rxrpc_connection_seq_stop(struct seq_file *seq, void *v)
-	__releases(rxnet->conn_lock)
-{
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-
-	read_unlock(&rxnet->conn_lock);
-}
-
-static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
-{
-	struct rxrpc_connection *conn;
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-	const char *state;
-	char lbuff[50], rbuff[50];
-
-	if (v =3D=3D &rxnet->conn_proc_list) {
-		seq_puts(seq,
-			 "Proto Local                                          "
-			 " Remote                                         "
-			 " SvID ConnID   End Ref Act State    Key     "
-			 " Serial   ISerial  CallId0  CallId1  CallId2  CallId3\n"
-			 );
-		return 0;
-	}
-
-	conn =3D list_entry(v, struct rxrpc_connection, proc_link);
-	if (conn->state =3D=3D RXRPC_CONN_SERVICE_PREALLOC) {
-		strcpy(lbuff, "no_local");
-		strcpy(rbuff, "no_connection");
-		goto print;
-	}
-
-	sprintf(lbuff, "%pISpc", &conn->local->srx.transport);
-	sprintf(rbuff, "%pISpc", &conn->peer->srx.transport);
-print:
-	state =3D rxrpc_is_conn_aborted(conn) ?
-		rxrpc_call_completions[conn->completion] :
-		rxrpc_conn_states[conn->state];
-	seq_printf(seq,
-		   "UDP   %-47.47s %-47.47s %4x %08x %s %3u %3d"
-		   " %s %08x %08x %08x %08x %08x %08x %08x\n",
-		   lbuff,
-		   rbuff,
-		   conn->service_id,
-		   conn->proto.cid,
-		   rxrpc_conn_is_service(conn) ? "Svc" : "Clt",
-		   refcount_read(&conn->ref),
-		   atomic_read(&conn->active),
-		   state,
-		   key_serial(conn->key),
-		   atomic_read(&conn->serial),
-		   conn->hi_serial,
-		   conn->channels[0].call_id,
-		   conn->channels[1].call_id,
-		   conn->channels[2].call_id,
-		   conn->channels[3].call_id);
-
-	return 0;
-}
-
-const struct seq_operations rxrpc_connection_seq_ops =3D {
-	.start  =3D rxrpc_connection_seq_start,
-	.next   =3D rxrpc_connection_seq_next,
-	.stop   =3D rxrpc_connection_seq_stop,
-	.show   =3D rxrpc_connection_seq_show,
-};
-
-/*
- * generate a list of extant virtual peers in /proc/net/rxrpc/peers
- */
-static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
-{
-	struct rxrpc_peer *peer;
-	time64_t now;
-	char lbuff[50], rbuff[50];
-
-	if (v =3D=3D SEQ_START_TOKEN) {
-		seq_puts(seq,
-			 "Proto Local                                          "
-			 " Remote                                         "
-			 " Use SST   MTU LastUse      RTT      RTO\n"
-			 );
-		return 0;
-	}
-
-	peer =3D list_entry(v, struct rxrpc_peer, hash_link);
-
-	sprintf(lbuff, "%pISpc", &peer->local->srx.transport);
-
-	sprintf(rbuff, "%pISpc", &peer->srx.transport);
-
-	now =3D ktime_get_seconds();
-	seq_printf(seq,
-		   "UDP   %-47.47s %-47.47s %3u"
-		   " %3u %5u %6llus %8u %8u\n",
-		   lbuff,
-		   rbuff,
-		   refcount_read(&peer->ref),
-		   peer->cong_ssthresh,
-		   peer->mtu,
-		   now - peer->last_tx_at,
-		   peer->srtt_us >> 3,
-		   jiffies_to_usecs(peer->rto_j));
-
-	return 0;
-}
-
-static void *rxrpc_peer_seq_start(struct seq_file *seq, loff_t *_pos)
-	__acquires(rcu)
-{
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-	unsigned int bucket, n;
-	unsigned int shift =3D 32 - HASH_BITS(rxnet->peer_hash);
-	void *p;
-
-	rcu_read_lock();
-
-	if (*_pos >=3D UINT_MAX)
-		return NULL;
-
-	n =3D *_pos & ((1U << shift) - 1);
-	bucket =3D *_pos >> shift;
-	for (;;) {
-		if (bucket >=3D HASH_SIZE(rxnet->peer_hash)) {
-			*_pos =3D UINT_MAX;
-			return NULL;
-		}
-		if (n =3D=3D 0) {
-			if (bucket =3D=3D 0)
-				return SEQ_START_TOKEN;
-			*_pos +=3D 1;
-			n++;
-		}
-
-		p =3D seq_hlist_start_rcu(&rxnet->peer_hash[bucket], n - 1);
-		if (p)
-			return p;
-		bucket++;
-		n =3D 1;
-		*_pos =3D (bucket << shift) | n;
-	}
-}
-
-static void *rxrpc_peer_seq_next(struct seq_file *seq, void *v, loff_t *_=
pos)
-{
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-	unsigned int bucket, n;
-	unsigned int shift =3D 32 - HASH_BITS(rxnet->peer_hash);
-	void *p;
-
-	if (*_pos >=3D UINT_MAX)
-		return NULL;
-
-	bucket =3D *_pos >> shift;
-
-	p =3D seq_hlist_next_rcu(v, &rxnet->peer_hash[bucket], _pos);
-	if (p)
-		return p;
-
-	for (;;) {
-		bucket++;
-		n =3D 1;
-		*_pos =3D (bucket << shift) | n;
-
-		if (bucket >=3D HASH_SIZE(rxnet->peer_hash)) {
-			*_pos =3D UINT_MAX;
-			return NULL;
-		}
-		if (n =3D=3D 0) {
-			*_pos +=3D 1;
-			n++;
-		}
-
-		p =3D seq_hlist_start_rcu(&rxnet->peer_hash[bucket], n - 1);
-		if (p)
-			return p;
-	}
-}
-
-static void rxrpc_peer_seq_stop(struct seq_file *seq, void *v)
-	__releases(rcu)
-{
-	rcu_read_unlock();
-}
-
-
-const struct seq_operations rxrpc_peer_seq_ops =3D {
-	.start  =3D rxrpc_peer_seq_start,
-	.next   =3D rxrpc_peer_seq_next,
-	.stop   =3D rxrpc_peer_seq_stop,
-	.show   =3D rxrpc_peer_seq_show,
-};
-
-/*
- * Generate a list of extant virtual local endpoints in /proc/net/rxrpc/l=
ocals
- */
-static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
-{
-	struct rxrpc_local *local;
-	char lbuff[50];
-
-	if (v =3D=3D SEQ_START_TOKEN) {
-		seq_puts(seq,
-			 "Proto Local                                          "
-			 " Use Act RxQ\n");
-		return 0;
-	}
-
-	local =3D hlist_entry(v, struct rxrpc_local, link);
-
-	sprintf(lbuff, "%pISpc", &local->srx.transport);
-
-	seq_printf(seq,
-		   "UDP   %-47.47s %3u %3u %3u\n",
-		   lbuff,
-		   refcount_read(&local->ref),
-		   atomic_read(&local->active_users),
-		   local->rx_queue.qlen);
-
-	return 0;
-}
-
-static void *rxrpc_local_seq_start(struct seq_file *seq, loff_t *_pos)
-	__acquires(rcu)
-{
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-	unsigned int n;
-
-	rcu_read_lock();
-
-	if (*_pos >=3D UINT_MAX)
-		return NULL;
-
-	n =3D *_pos;
-	if (n =3D=3D 0)
-		return SEQ_START_TOKEN;
-
-	return seq_hlist_start_rcu(&rxnet->local_endpoints, n - 1);
-}
-
-static void *rxrpc_local_seq_next(struct seq_file *seq, void *v, loff_t *=
_pos)
-{
-	struct rxrpc_net *rxnet =3D rxrpc_net(seq_file_net(seq));
-
-	if (*_pos >=3D UINT_MAX)
-		return NULL;
-
-	return seq_hlist_next_rcu(v, &rxnet->local_endpoints, _pos);
-}
-
-static void rxrpc_local_seq_stop(struct seq_file *seq, void *v)
-	__releases(rcu)
-{
-	rcu_read_unlock();
-}
-
-const struct seq_operations rxrpc_local_seq_ops =3D {
-	.start  =3D rxrpc_local_seq_start,
-	.next   =3D rxrpc_local_seq_next,
-	.stop   =3D rxrpc_local_seq_stop,
-	.show   =3D rxrpc_local_seq_show,
-};
-
 /*
  * Display stats in /proc/net/rxrpc/stats
  */
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index dd54ceee7bcc..c589d691552e 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -30,15 +30,13 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
 	if (!list_empty(&call->recvmsg_link))
 		return;
 =

-	rcu_read_lock();
+	spin_lock(&call->notify_lock);
 =

-	rx =3D rcu_dereference(call->socket);
+	rx =3D call->socket;
 	sk =3D &rx->sk;
 	if (rx && sk->sk_state < RXRPC_CLOSE) {
 		if (call->notify_rx) {
-			spin_lock(&call->notify_lock);
 			call->notify_rx(sk, call, call->user_call_ID);
-			spin_unlock(&call->notify_lock);
 		} else {
 			write_lock(&rx->recvmsg_lock);
 			if (list_empty(&call->recvmsg_link)) {
@@ -54,7 +52,7 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
 		}
 	}
 =

-	rcu_read_unlock();
+	spin_unlock(&call->notify_lock);
 	_leave("");
 }
 =

diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index 16dcabb71ebe..962bdc608a0b 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -606,7 +606,6 @@ static int __init rxperf_init(void)
 	key_put(rxperf_sec_keyring);
 error_keyring:
 	destroy_workqueue(rxperf_workqueue);
-	rcu_barrier();
 error_workqueue:
 	pr_err("Failed to register: %d\n", ret);
 	return ret;
@@ -620,7 +619,6 @@ static void __exit rxperf_exit(void)
 	rxperf_close_socket();
 	key_put(rxperf_sec_keyring);
 	destroy_workqueue(rxperf_workqueue);
-	rcu_barrier();
 }
 module_exit(rxperf_exit);
 =

diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index cd66634dffe6..cb8dd1d3b1d4 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -178,9 +178,9 @@ struct key *rxrpc_look_up_server_security(struct rxrpc=
_connection *conn,
 		sprintf(kdesc, "%u:%u",
 			sp->hdr.serviceId, sp->hdr.securityIndex);
 =

-	rcu_read_lock();
+	read_lock(&conn->local->services_lock);
 =

-	rx =3D rcu_dereference(conn->local->service);
+	rx =3D conn->local->service;
 	if (!rx)
 		goto out;
 =

@@ -202,6 +202,6 @@ struct key *rxrpc_look_up_server_security(struct rxrpc=
_connection *conn,
 	}
 =

 out:
-	rcu_read_unlock();
+	read_unlock(&conn->local->services_lock);
 	return key;
 }
diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
index d2cf2aac3adb..7df082f3e9be 100644
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -71,10 +71,8 @@ void rxrpc_see_txbuf(struct rxrpc_txbuf *txb, enum rxrp=
c_txbuf_trace what)
 	trace_rxrpc_txbuf(txb->debug_id, txb->call_debug_id, txb->seq, r, what);
 }
 =

-static void rxrpc_free_txbuf(struct rcu_head *rcu)
+static void rxrpc_free_txbuf(struct rxrpc_txbuf *txb)
 {
-	struct rxrpc_txbuf *txb =3D container_of(rcu, struct rxrpc_txbuf, rcu);
-
 	trace_rxrpc_txbuf(txb->debug_id, txb->call_debug_id, txb->seq, 0,
 			  rxrpc_txbuf_free);
 	kfree(txb);
@@ -95,7 +93,7 @@ void rxrpc_put_txbuf(struct rxrpc_txbuf *txb, enum rxrpc=
_txbuf_trace what)
 		dead =3D __refcount_dec_and_test(&txb->ref, &r);
 		trace_rxrpc_txbuf(debug_id, call_debug_id, seq, r - 1, what);
 		if (dead)
-			call_rcu(&txb->rcu, rxrpc_free_txbuf);
+			rxrpc_free_txbuf(txb);
 	}
 }
 =

@@ -105,38 +103,31 @@ void rxrpc_put_txbuf(struct rxrpc_txbuf *txb, enum r=
xrpc_txbuf_trace what)
 void rxrpc_shrink_call_tx_buffer(struct rxrpc_call *call)
 {
 	struct rxrpc_txbuf *txb;
-	rxrpc_seq_t hard_ack =3D smp_load_acquire(&call->acks_hard_ack);
 	bool wake =3D false;
 =

 	_enter("%x/%x/%x", call->tx_bottom, call->acks_hard_ack, call->tx_top);
 =

 	for (;;) {
-		spin_lock(&call->tx_lock);
 		txb =3D list_first_entry_or_null(&call->tx_buffer,
 					       struct rxrpc_txbuf, call_link);
 		if (!txb)
 			break;
-		hard_ack =3D smp_load_acquire(&call->acks_hard_ack);
-		if (before(hard_ack, txb->seq))
+		if (before(call->acks_hard_ack, txb->seq))
 			break;
 =

 		if (txb->seq !=3D call->tx_bottom + 1)
 			rxrpc_see_txbuf(txb, rxrpc_txbuf_see_out_of_step);
 		ASSERTCMP(txb->seq, =3D=3D, call->tx_bottom + 1);
 		smp_store_release(&call->tx_bottom, call->tx_bottom + 1);
-		list_del_rcu(&txb->call_link);
+		list_del(&txb->call_link);
 =

 		trace_rxrpc_txqueue(call, rxrpc_txqueue_dequeue);
 =

-		spin_unlock(&call->tx_lock);
-
 		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_rotated);
 		if (after(call->acks_hard_ack, call->tx_bottom + 128))
 			wake =3D true;
 	}
 =

-	spin_unlock(&call->tx_lock);
-
 	if (wake)
 		wake_up(&call->waitq);
 }

