Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C1563DB2A
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiK3Q4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiK3Q4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:56:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95C88DFD1
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ELwEvoqcLtONqcVmTzyiWYOh4/BRyQ//XCTjBm7n/as=;
        b=HTpmT/xRZiGtaq+yrtP1QeOjFgNv+6LH3V/AhxiToHvgOjZG2fjAHZqCGQdN45u7YwtlLp
        LvLEG+aHdISjZPx0Cn/nLP4kIDUdEpG7cCIAFjCtNYj2YJpPhR5u4tA93/mCl1kGWUV38p
        7N6ohUfwrcAzVv1AT4DJGsMKQU2cbo0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-QBErPwqRMhm2mMrJEZc66A-1; Wed, 30 Nov 2022 11:55:04 -0500
X-MC-Unique: QBErPwqRMhm2mMrJEZc66A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A1A2101A5AD;
        Wed, 30 Nov 2022 16:55:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82FF540C6EC4;
        Wed, 30 Nov 2022 16:55:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 05/35] rxrpc: Remove the [k_]proto() debugging macros
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:55:00 +0000
Message-ID: <166982730073.621383.6529596529186180273.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Remove the kproto() and _proto() debugging macros in preference to using
tracepoints for this.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   60 ++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/ar-internal.h      |   10 -------
 net/rxrpc/conn_event.c       |    4 ---
 net/rxrpc/input.c            |   17 ------------
 net/rxrpc/local_event.c      |    3 --
 net/rxrpc/output.c           |    2 -
 net/rxrpc/peer_event.c       |    4 ---
 net/rxrpc/rxkad.c            |    9 ++----
 8 files changed, 63 insertions(+), 46 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index b9886d1df825..2b77f9a75bf7 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -733,6 +733,66 @@ TRACE_EVENT(rxrpc_rx_abort,
 		      __entry->abort_code)
 	    );
 
+TRACE_EVENT(rxrpc_rx_challenge,
+	    TP_PROTO(struct rxrpc_connection *conn, rxrpc_serial_t serial,
+		     u32 version, u32 nonce, u32 min_level),
+
+	    TP_ARGS(conn, serial, version, nonce, min_level),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		conn		)
+		    __field(rxrpc_serial_t,		serial		)
+		    __field(u32,			version		)
+		    __field(u32,			nonce		)
+		    __field(u32,			min_level	)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->conn = conn->debug_id;
+		    __entry->serial = serial;
+		    __entry->version = version;
+		    __entry->nonce = nonce;
+		    __entry->min_level = min_level;
+			   ),
+
+	    TP_printk("C=%08x CHALLENGE %08x v=%x n=%x ml=%x",
+		      __entry->conn,
+		      __entry->serial,
+		      __entry->version,
+		      __entry->nonce,
+		      __entry->min_level)
+	    );
+
+TRACE_EVENT(rxrpc_rx_response,
+	    TP_PROTO(struct rxrpc_connection *conn, rxrpc_serial_t serial,
+		     u32 version, u32 kvno, u32 ticket_len),
+
+	    TP_ARGS(conn, serial, version, kvno, ticket_len),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		conn		)
+		    __field(rxrpc_serial_t,		serial		)
+		    __field(u32,			version		)
+		    __field(u32,			kvno		)
+		    __field(u32,			ticket_len	)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->conn = conn->debug_id;
+		    __entry->serial = serial;
+		    __entry->version = version;
+		    __entry->kvno = kvno;
+		    __entry->ticket_len = ticket_len;
+			   ),
+
+	    TP_printk("C=%08x RESPONSE %08x v=%x kvno=%x tl=%x",
+		      __entry->conn,
+		      __entry->serial,
+		      __entry->version,
+		      __entry->kvno,
+		      __entry->ticket_len)
+	    );
+
 TRACE_EVENT(rxrpc_rx_rwind_change,
 	    TP_PROTO(struct rxrpc_call *call, rxrpc_serial_t serial,
 		     u32 rwind, bool wake),
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index f5c538ce3e23..a3a29390e12b 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1190,7 +1190,6 @@ extern unsigned int rxrpc_debug;
 #define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
 #define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define kdebug(FMT,...)	dbgprintk("    "FMT ,##__VA_ARGS__)
-#define kproto(FMT,...)	dbgprintk("### "FMT ,##__VA_ARGS__)
 #define knet(FMT,...)	dbgprintk("@@@ "FMT ,##__VA_ARGS__)
 
 
@@ -1198,14 +1197,12 @@ extern unsigned int rxrpc_debug;
 #define _enter(FMT,...)	kenter(FMT,##__VA_ARGS__)
 #define _leave(FMT,...)	kleave(FMT,##__VA_ARGS__)
 #define _debug(FMT,...)	kdebug(FMT,##__VA_ARGS__)
-#define _proto(FMT,...)	kproto(FMT,##__VA_ARGS__)
 #define _net(FMT,...)	knet(FMT,##__VA_ARGS__)
 
 #elif defined(CONFIG_AF_RXRPC_DEBUG)
 #define RXRPC_DEBUG_KENTER	0x01
 #define RXRPC_DEBUG_KLEAVE	0x02
 #define RXRPC_DEBUG_KDEBUG	0x04
-#define RXRPC_DEBUG_KPROTO	0x08
 #define RXRPC_DEBUG_KNET	0x10
 
 #define _enter(FMT,...)					\
@@ -1226,12 +1223,6 @@ do {							\
 		kdebug(FMT,##__VA_ARGS__);		\
 } while (0)
 
-#define _proto(FMT,...)					\
-do {							\
-	if (unlikely(rxrpc_debug & RXRPC_DEBUG_KPROTO))	\
-		kproto(FMT,##__VA_ARGS__);		\
-} while (0)
-
 #define _net(FMT,...)					\
 do {							\
 	if (unlikely(rxrpc_debug & RXRPC_DEBUG_KNET))	\
@@ -1242,7 +1233,6 @@ do {							\
 #define _enter(FMT,...)	no_printk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
 #define _leave(FMT,...)	no_printk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define _debug(FMT,...)	no_printk("    "FMT ,##__VA_ARGS__)
-#define _proto(FMT,...)	no_printk("### "FMT ,##__VA_ARGS__)
 #define _net(FMT,...)	no_printk("@@@ "FMT ,##__VA_ARGS__)
 #endif
 
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index aab069701398..d5549cbfc71b 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -122,14 +122,12 @@ static void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 
 	switch (chan->last_type) {
 	case RXRPC_PACKET_TYPE_ABORT:
-		_proto("Tx ABORT %%%u { %d } [re]", serial, conn->abort_code);
 		break;
 	case RXRPC_PACKET_TYPE_ACK:
 		trace_rxrpc_tx_ack(chan->call_debug_id, serial,
 				   ntohl(pkt.ack.firstPacket),
 				   ntohl(pkt.ack.serial),
 				   pkt.ack.reason, 0);
-		_proto("Tx ACK %%%u [re]", serial);
 		break;
 	}
 
@@ -242,7 +240,6 @@ static int rxrpc_abort_connection(struct rxrpc_connection *conn,
 	serial = atomic_inc_return(&conn->serial);
 	rxrpc_abort_calls(conn, RXRPC_CALL_LOCALLY_ABORTED, serial);
 	whdr.serial = htonl(serial);
-	_proto("Tx CONN ABORT %%%u { %d }", serial, conn->abort_code);
 
 	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 2, len);
 	if (ret < 0) {
@@ -315,7 +312,6 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 			return -EPROTO;
 		}
 		abort_code = ntohl(wtmp);
-		_proto("Rx ABORT %%%u { ac=%d }", sp->hdr.serial, abort_code);
 
 		conn->error = -ECONNABORTED;
 		conn->abort_code = abort_code;
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index bdf70b81addc..646ee61af40e 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -551,9 +551,6 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	       atomic64_read(&call->ackr_window), call->rx_highest_seq,
 	       skb->len, seq0);
 
-	_proto("Rx DATA %%%u { #%u f=%02x }",
-	       sp->hdr.serial, seq0, sp->hdr.flags);
-
 	state = READ_ONCE(call->state);
 	if (state >= RXRPC_CALL_COMPLETE) {
 		rxrpc_free_skb(skb, rxrpc_skb_freed);
@@ -708,11 +705,6 @@ static void rxrpc_input_ackinfo(struct rxrpc_call *call, struct sk_buff *skb,
 	bool wake = false;
 	u32 rwind = ntohl(ackinfo->rwind);
 
-	_proto("Rx ACK %%%u Info { rx=%u max=%u rwin=%u jm=%u }",
-	       sp->hdr.serial,
-	       ntohl(ackinfo->rxMTU), ntohl(ackinfo->maxMTU),
-	       rwind, ntohl(ackinfo->jumbo_max));
-
 	if (rwind > RXRPC_TX_MAX_WINDOW)
 		rwind = RXRPC_TX_MAX_WINDOW;
 	if (call->tx_winsize != rwind) {
@@ -855,7 +847,6 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 
 	if (ack.reason == RXRPC_ACK_PING) {
-		_proto("Rx ACK %%%u PING Request", ack_serial);
 		rxrpc_send_ACK(call, RXRPC_ACK_PING_RESPONSE, ack_serial,
 			       rxrpc_propose_ack_respond_to_ping);
 	} else if (sp->hdr.flags & RXRPC_REQUEST_ACK) {
@@ -1014,9 +1005,6 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 static void rxrpc_input_ackall(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_ack_summary summary = { 0 };
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-
-	_proto("Rx ACKALL %%%u", sp->hdr.serial);
 
 	spin_lock(&call->input_lock);
 
@@ -1044,8 +1032,6 @@ static void rxrpc_input_abort(struct rxrpc_call *call, struct sk_buff *skb)
 
 	trace_rxrpc_rx_abort(call, sp->hdr.serial, abort_code);
 
-	_proto("Rx ABORT %%%u { %x }", sp->hdr.serial, abort_code);
-
 	rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
 				  abort_code, -ECONNABORTED);
 }
@@ -1081,8 +1067,6 @@ static void rxrpc_input_call_packet(struct rxrpc_call *call,
 		goto no_free;
 
 	case RXRPC_PACKET_TYPE_BUSY:
-		_proto("Rx BUSY %%%u", sp->hdr.serial);
-
 		/* Just ignore BUSY packets from the server; the retry and
 		 * lifespan timers will take care of business.  BUSY packets
 		 * from the client don't make sense.
@@ -1325,7 +1309,6 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		goto discard;
 
 	default:
-		_proto("Rx Bad Packet Type %u", sp->hdr.type);
 		goto bad_message;
 	}
 
diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
index 19e929c7c38b..f23a3fbabbda 100644
--- a/net/rxrpc/local_event.c
+++ b/net/rxrpc/local_event.c
@@ -63,8 +63,6 @@ static void rxrpc_send_version_request(struct rxrpc_local *local,
 
 	len = iov[0].iov_len + iov[1].iov_len;
 
-	_proto("Tx VERSION (reply)");
-
 	ret = kernel_sendmsg(local->socket, &msg, iov, 2, len);
 	if (ret < 0)
 		trace_rxrpc_tx_fail(local->debug_id, 0, ret,
@@ -98,7 +96,6 @@ void rxrpc_process_local_events(struct rxrpc_local *local)
 			if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
 					  &v, 1) < 0)
 				return;
-			_proto("Rx VERSION { %02x }", v);
 			if (v == 0)
 				rxrpc_send_version_request(local, &sp->hdr, skb);
 			break;
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index c5eed0e83e47..635acf3dbd77 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -701,8 +701,6 @@ void rxrpc_send_keepalive(struct rxrpc_peer *peer)
 
 	len = iov[0].iov_len + iov[1].iov_len;
 
-	_proto("Tx VERSION (keepalive)");
-
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 2, len);
 	ret = do_udp_sendmsg(peer->local->socket, &msg, len);
 	if (ret < 0)
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index cda3890657a9..be781c156e89 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -253,15 +253,12 @@ static void rxrpc_store_error(struct rxrpc_peer *peer,
 			break;
 
 		default:
-			_proto("Rx Received ICMP error { type=%u code=%u }",
-			       ee->ee_type, ee->ee_code);
 			break;
 		}
 		break;
 
 	case SO_EE_ORIGIN_NONE:
 	case SO_EE_ORIGIN_LOCAL:
-		_proto("Rx Received local error { error=%d }", err);
 		compl = RXRPC_CALL_LOCAL_ERROR;
 		break;
 
@@ -270,7 +267,6 @@ static void rxrpc_store_error(struct rxrpc_peer *peer,
 			err = EHOSTUNREACH;
 		fallthrough;
 	default:
-		_proto("Rx Received error report { orig=%u }", ee->ee_origin);
 		break;
 	}
 
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 110a5550c0a6..36cf40442a7e 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -704,7 +704,6 @@ static int rxkad_issue_challenge(struct rxrpc_connection *conn)
 
 	serial = atomic_inc_return(&conn->serial);
 	whdr.serial = htonl(serial);
-	_proto("Tx CHALLENGE %%%u", serial);
 
 	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 2, len);
 	if (ret < 0) {
@@ -762,7 +761,6 @@ static int rxkad_send_response(struct rxrpc_connection *conn,
 
 	serial = atomic_inc_return(&conn->serial);
 	whdr.serial = htonl(serial);
-	_proto("Tx RESPONSE %%%u", serial);
 
 	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 3, len);
 	if (ret < 0) {
@@ -856,8 +854,7 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
 	nonce = ntohl(challenge.nonce);
 	min_level = ntohl(challenge.min_level);
 
-	_proto("Rx CHALLENGE %%%u { v=%u n=%u ml=%u }",
-	       sp->hdr.serial, version, nonce, min_level);
+	trace_rxrpc_rx_challenge(conn, sp->hdr.serial, version, nonce, min_level);
 
 	eproto = tracepoint_string("chall_ver");
 	abort_code = RXKADINCONSISTENCY;
@@ -1139,8 +1136,8 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	version = ntohl(response->version);
 	ticket_len = ntohl(response->ticket_len);
 	kvno = ntohl(response->kvno);
-	_proto("Rx RESPONSE %%%u { v=%u kv=%u tl=%u }",
-	       sp->hdr.serial, version, kvno, ticket_len);
+
+	trace_rxrpc_rx_response(conn, sp->hdr.serial, version, kvno, ticket_len);
 
 	eproto = tracepoint_string("rxkad_rsp_ver");
 	abort_code = RXKADINCONSISTENCY;


