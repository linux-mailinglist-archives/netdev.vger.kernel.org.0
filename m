Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB47C63FCB3
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiLBARc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbiLBARB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:17:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF07CCEFAB
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TfU2vOhI2FJqWWTwtY56Qr3tqmx7ENd1hy5S4qU6G68=;
        b=H72qEOdFund1yPzXz3H9mazW+q1Sr6IVyoho+nhXTjOCsbjwA5rGVyvpIB3Z8aFerLfqfd
        L41pZJ5a5EkXPJd9gO25pd/NQaHiz4V4FxKSuZyqiKB+9yhpP7Jk9TzibB8H8pVzLkVcZZ
        miJbnBzXQPXTsjSjC8cowcEpMbchdgQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-NYurXNDhMfmQZqAbWgPsaA-1; Thu, 01 Dec 2022 19:16:04 -0500
X-MC-Unique: NYurXNDhMfmQZqAbWgPsaA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22EC4101A528;
        Fri,  2 Dec 2022 00:16:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65EB12022EA2;
        Fri,  2 Dec 2022 00:16:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 07/36] rxrpc: Remove the [_k]net() debugging macros
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:16:00 +0000
Message-ID: <166994016061.1732290.3005763267417843434.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the _net() and knet() debugging macros in favour of tracepoints.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h  |   10 ----------
 net/rxrpc/call_object.c  |    6 ------
 net/rxrpc/conn_client.c  |    2 --
 net/rxrpc/conn_object.c  |    2 --
 net/rxrpc/conn_service.c |    2 --
 net/rxrpc/input.c        |    1 -
 net/rxrpc/local_object.c |    8 --------
 net/rxrpc/peer_event.c   |   48 ++--------------------------------------------
 net/rxrpc/peer_object.c  |    6 +-----
 9 files changed, 3 insertions(+), 82 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index a3a29390e12b..36ece1efb1d4 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1190,20 +1190,17 @@ extern unsigned int rxrpc_debug;
 #define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
 #define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define kdebug(FMT,...)	dbgprintk("    "FMT ,##__VA_ARGS__)
-#define knet(FMT,...)	dbgprintk("@@@ "FMT ,##__VA_ARGS__)
 
 
 #if defined(__KDEBUG)
 #define _enter(FMT,...)	kenter(FMT,##__VA_ARGS__)
 #define _leave(FMT,...)	kleave(FMT,##__VA_ARGS__)
 #define _debug(FMT,...)	kdebug(FMT,##__VA_ARGS__)
-#define _net(FMT,...)	knet(FMT,##__VA_ARGS__)
 
 #elif defined(CONFIG_AF_RXRPC_DEBUG)
 #define RXRPC_DEBUG_KENTER	0x01
 #define RXRPC_DEBUG_KLEAVE	0x02
 #define RXRPC_DEBUG_KDEBUG	0x04
-#define RXRPC_DEBUG_KNET	0x10
 
 #define _enter(FMT,...)					\
 do {							\
@@ -1223,17 +1220,10 @@ do {							\
 		kdebug(FMT,##__VA_ARGS__);		\
 } while (0)
 
-#define _net(FMT,...)					\
-do {							\
-	if (unlikely(rxrpc_debug & RXRPC_DEBUG_KNET))	\
-		knet(FMT,##__VA_ARGS__);		\
-} while (0)
-
 #else
 #define _enter(FMT,...)	no_printk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
 #define _leave(FMT,...)	no_printk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define _debug(FMT,...)	no_printk("    "FMT ,##__VA_ARGS__)
-#define _net(FMT,...)	no_printk("@@@ "FMT ,##__VA_ARGS__)
 #endif
 
 /*
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 1befe22cd301..e36a317b2e9a 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -349,8 +349,6 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 
 	rxrpc_start_call_timer(call);
 
-	_net("CALL new %d on CONN %d", call->debug_id, call->conn->debug_id);
-
 	_leave(" = %p [new]", call);
 	return call;
 
@@ -423,8 +421,6 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	hlist_add_head_rcu(&call->error_link, &conn->params.peer->error_targets);
 	spin_unlock(&conn->params.peer->lock);
 
-	_net("CALL incoming %d on CONN %d", call->debug_id, call->conn->debug_id);
-
 	rxrpc_start_call_timer(call);
 	_leave("");
 }
@@ -669,8 +665,6 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 {
 	struct rxrpc_txbuf *txb;
 
-	_net("DESTROY CALL %d", call->debug_id);
-
 	memset(&call->sock_node, 0xcd, sizeof(call->sock_node));
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index f11c97e28d2a..2b76fbffd4dd 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -541,8 +541,6 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 	call->service_id = conn->service_id;
 
 	trace_rxrpc_connect_call(call);
-	_net("CONNECT call %08x:%08x as call %d on conn %d",
-	     call->cid, call->call_id, call->debug_id, conn->debug_id);
 
 	write_lock_bh(&call->state_lock);
 	call->state = RXRPC_CALL_CLIENT_SEND_REQUEST;
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 156bd26daf74..d5d15389406f 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -356,8 +356,6 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 
 	ASSERTCMP(refcount_read(&conn->ref), ==, 0);
 
-	_net("DESTROY CONN %d", conn->debug_id);
-
 	del_timer_sync(&conn->timer);
 	rxrpc_purge_queue(&conn->rx_queue);
 
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 6e6aa02c6f9e..75f903099eb0 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -184,8 +184,6 @@ void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
 
 	/* Make the connection a target for incoming packets. */
 	rxrpc_publish_service_conn(conn->params.peer, conn);
-
-	_net("CONNECTION new %d {%x}", conn->debug_id, conn->proto.cid);
 }
 
 /*
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 646ee61af40e..e2461f29d765 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -725,7 +725,6 @@ static void rxrpc_input_ackinfo(struct rxrpc_call *call, struct sk_buff *skb,
 		peer->maxdata = mtu;
 		peer->mtu = mtu + peer->hdrsize;
 		spin_unlock_bh(&peer->lock);
-		_net("Net MTU %u (maxdata %u)", peer->mtu, peer->maxdata);
 	}
 
 	if (wake)
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index a943fdf91e24..11080c335d42 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -198,7 +198,6 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 	struct rxrpc_local *local;
 	struct rxrpc_net *rxnet = rxrpc_net(net);
 	struct hlist_node *cursor;
-	const char *age;
 	long diff;
 	int ret;
 
@@ -232,7 +231,6 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 		if (!rxrpc_use_local(local))
 			break;
 
-		age = "old";
 		goto found;
 	}
 
@@ -250,14 +248,9 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 	} else {
 		hlist_add_head_rcu(&local->link, &rxnet->local_endpoints);
 	}
-	age = "new";
 
 found:
 	mutex_unlock(&rxnet->local_mutex);
-
-	_net("LOCAL %s %d {%pISp}",
-	     age, local->debug_id, &local->srx.transport);
-
 	_leave(" = %p", local);
 	return local;
 
@@ -467,7 +460,6 @@ static void rxrpc_local_rcu(struct rcu_head *rcu)
 
 	ASSERT(!work_pending(&local->processor));
 
-	_net("DESTROY LOCAL %d", local->debug_id);
 	kfree(local);
 	_leave("");
 }
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index be781c156e89..ad4d1769e02b 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -48,13 +48,11 @@ static struct rxrpc_peer *rxrpc_lookup_peer_local_rcu(struct rxrpc_local *local,
 		srx->transport.sin.sin_port = serr->port;
 		switch (serr->ee.ee_origin) {
 		case SO_EE_ORIGIN_ICMP:
-			_net("Rx ICMP");
 			memcpy(&srx->transport.sin.sin_addr,
 			       skb_network_header(skb) + serr->addr_offset,
 			       sizeof(struct in_addr));
 			break;
 		case SO_EE_ORIGIN_ICMP6:
-			_net("Rx ICMP6 on v4 sock");
 			memcpy(&srx->transport.sin.sin_addr,
 			       skb_network_header(skb) + serr->addr_offset + 12,
 			       sizeof(struct in_addr));
@@ -70,14 +68,12 @@ static struct rxrpc_peer *rxrpc_lookup_peer_local_rcu(struct rxrpc_local *local,
 	case AF_INET6:
 		switch (serr->ee.ee_origin) {
 		case SO_EE_ORIGIN_ICMP6:
-			_net("Rx ICMP6");
 			srx->transport.sin6.sin6_port = serr->port;
 			memcpy(&srx->transport.sin6.sin6_addr,
 			       skb_network_header(skb) + serr->addr_offset,
 			       sizeof(struct in6_addr));
 			break;
 		case SO_EE_ORIGIN_ICMP:
-			_net("Rx ICMP on v6 sock");
 			srx->transport_len = sizeof(srx->transport.sin);
 			srx->transport.family = AF_INET;
 			srx->transport.sin.sin_port = serr->port;
@@ -106,13 +102,9 @@ static struct rxrpc_peer *rxrpc_lookup_peer_local_rcu(struct rxrpc_local *local,
  */
 static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, unsigned int mtu)
 {
-	_net("Rx ICMP Fragmentation Needed (%d)", mtu);
-
 	/* wind down the local interface MTU */
-	if (mtu > 0 && peer->if_mtu == 65535 && mtu < peer->if_mtu) {
+	if (mtu > 0 && peer->if_mtu == 65535 && mtu < peer->if_mtu)
 		peer->if_mtu = mtu;
-		_net("I/F MTU %u", mtu);
-	}
 
 	if (mtu == 0) {
 		/* they didn't give us a size, estimate one */
@@ -133,8 +125,6 @@ static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, unsigned int mtu)
 		peer->mtu = mtu;
 		peer->maxdata = peer->mtu - peer->hdrsize;
 		spin_unlock_bh(&peer->lock);
-		_net("Net MTU %u (maxdata %u)",
-		     peer->mtu, peer->maxdata);
 	}
 }
 
@@ -222,41 +212,6 @@ static void rxrpc_store_error(struct rxrpc_peer *peer,
 	err = ee->ee_errno;
 
 	switch (ee->ee_origin) {
-	case SO_EE_ORIGIN_ICMP:
-		switch (ee->ee_type) {
-		case ICMP_DEST_UNREACH:
-			switch (ee->ee_code) {
-			case ICMP_NET_UNREACH:
-				_net("Rx Received ICMP Network Unreachable");
-				break;
-			case ICMP_HOST_UNREACH:
-				_net("Rx Received ICMP Host Unreachable");
-				break;
-			case ICMP_PORT_UNREACH:
-				_net("Rx Received ICMP Port Unreachable");
-				break;
-			case ICMP_NET_UNKNOWN:
-				_net("Rx Received ICMP Unknown Network");
-				break;
-			case ICMP_HOST_UNKNOWN:
-				_net("Rx Received ICMP Unknown Host");
-				break;
-			default:
-				_net("Rx Received ICMP DestUnreach code=%u",
-				     ee->ee_code);
-				break;
-			}
-			break;
-
-		case ICMP_TIME_EXCEEDED:
-			_net("Rx Received ICMP TTL Exceeded");
-			break;
-
-		default:
-			break;
-		}
-		break;
-
 	case SO_EE_ORIGIN_NONE:
 	case SO_EE_ORIGIN_LOCAL:
 		compl = RXRPC_CALL_LOCAL_ERROR;
@@ -266,6 +221,7 @@ static void rxrpc_store_error(struct rxrpc_peer *peer,
 		if (err == EACCES)
 			err = EHOSTUNREACH;
 		fallthrough;
+	case SO_EE_ORIGIN_ICMP:
 	default:
 		break;
 	}
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 041a51225c5f..b3c3c1c344fc 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -138,10 +138,8 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *local,
 	unsigned long hash_key = rxrpc_peer_hash_key(local, srx);
 
 	peer = __rxrpc_lookup_peer_rcu(local, srx, hash_key);
-	if (peer) {
-		_net("PEER %d {%pISp}", peer->debug_id, &peer->srx.transport);
+	if (peer)
 		_leave(" = %p {u=%d}", peer, refcount_read(&peer->ref));
-	}
 	return peer;
 }
 
@@ -371,8 +369,6 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 			peer = candidate;
 	}
 
-	_net("PEER %d {%pISp}", peer->debug_id, &peer->srx.transport);
-
 	_leave(" = %p {u=%d}", peer, refcount_read(&peer->ref));
 	return peer;
 }


