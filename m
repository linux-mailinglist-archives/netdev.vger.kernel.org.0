Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE16621F13
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiKHWVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiKHWUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:20:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B198163CF3
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gdQXPgmD8GyNZhmEMphsSAed/WP9xg/B5RyYlov1uYo=;
        b=WVVE+tCbo+NV44r291jJ4mjCxFz1q1a1VZpcfVG1caIhV5NzvgVfiqxEkOPsVZjAJrGZST
        rWWvUL69Yrq7p3K0FPsbirC/67bsKeQudQ/JL7l+V8jN0yGT+HC7cUUTe6eYW7ck1cyMhf
        GkwM+7gmkjDvOdSC1Y3h81IjFwnlH+s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-eFupv-2TO9u0sFTT_582fQ-1; Tue, 08 Nov 2022 17:19:16 -0500
X-MC-Unique: eFupv-2TO9u0sFTT_582fQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C56F299E755;
        Tue,  8 Nov 2022 22:19:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA2232024CC1;
        Tue,  8 Nov 2022 22:19:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 13/26] rxrpc: Remove the flags from the rxrpc_skb
 tracepoint
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:19:15 +0000
Message-ID: <166794595517.2389296.6062556333527132632.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the flags from the rxrpc_skb tracepoint as we're no longer going to
be using this for the transmission buffers and so marking which are
transmission buffers isn't going to be necessary.

Note that this also remove the rxrpc skb flag that indicates if this is a
transmission buffer and so the count is not updated for the moment.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    9 +++------
 net/rxrpc/ar-internal.h      |    1 -
 net/rxrpc/sendmsg.c          |    1 -
 net/rxrpc/skbuff.c           |   20 +++++++-------------
 4 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 794523d15321..484c8d032ab8 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -461,14 +461,13 @@ TRACE_EVENT(rxrpc_call,
 
 TRACE_EVENT(rxrpc_skb,
 	    TP_PROTO(struct sk_buff *skb, enum rxrpc_skb_trace op,
-		     int usage, int mod_count, u8 flags,    const void *where),
+		     int usage, int mod_count, const void *where),
 
-	    TP_ARGS(skb, op, usage, mod_count, flags, where),
+	    TP_ARGS(skb, op, usage, mod_count, where),
 
 	    TP_STRUCT__entry(
 		    __field(struct sk_buff *,		skb		)
 		    __field(enum rxrpc_skb_trace,	op		)
-		    __field(u8,				flags		)
 		    __field(int,			usage		)
 		    __field(int,			mod_count	)
 		    __field(const void *,		where		)
@@ -476,16 +475,14 @@ TRACE_EVENT(rxrpc_skb,
 
 	    TP_fast_assign(
 		    __entry->skb = skb;
-		    __entry->flags = flags;
 		    __entry->op = op;
 		    __entry->usage = usage;
 		    __entry->mod_count = mod_count;
 		    __entry->where = where;
 			   ),
 
-	    TP_printk("s=%p %cx %s u=%d m=%d p=%pSR",
+	    TP_printk("s=%p Rx %s u=%d m=%d p=%pSR",
 		      __entry->skb,
-		      __entry->flags & RXRPC_SKB_TX_BUFFER ? 'T' : 'R',
 		      __print_symbolic(__entry->op, rxrpc_skb_traces),
 		      __entry->usage,
 		      __entry->mod_count,
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index ba0ee5d1c723..92f20b6c23ca 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -198,7 +198,6 @@ struct rxrpc_skb_priv {
 	u8		nr_subpackets;		/* Number of subpackets */
 	u8		rx_flags;		/* Received packet flags */
 #define RXRPC_SKB_INCL_LAST	0x01		/* - Includes last packet */
-#define RXRPC_SKB_TX_BUFFER	0x02		/* - Is transmit buffer */
 	union {
 		int		remain;		/* amount of space remaining for next write */
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index ad6f2cd08916..b2d28aa12e10 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -363,7 +363,6 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 				goto maybe_error;
 
 			sp = rxrpc_skb(skb);
-			sp->rx_flags |= RXRPC_SKB_TX_BUFFER;
 			rxrpc_new_skb(skb, rxrpc_skb_new);
 
 			_debug("ALLOC SEND %p", skb);
diff --git a/net/rxrpc/skbuff.c b/net/rxrpc/skbuff.c
index 580a5acffee7..0c827d5bb2b8 100644
--- a/net/rxrpc/skbuff.c
+++ b/net/rxrpc/skbuff.c
@@ -14,8 +14,7 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
-#define is_tx_skb(skb) (rxrpc_skb(skb)->rx_flags & RXRPC_SKB_TX_BUFFER)
-#define select_skb_count(skb) (is_tx_skb(skb) ? &rxrpc_n_tx_skbs : &rxrpc_n_rx_skbs)
+#define select_skb_count(skb) (&rxrpc_n_rx_skbs)
 
 /*
  * Note the allocation or reception of a socket buffer.
@@ -24,8 +23,7 @@ void rxrpc_new_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(select_skb_count(skb));
-	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
-			rxrpc_skb(skb)->rx_flags, here);
+	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 }
 
 /*
@@ -36,8 +34,7 @@ void rxrpc_see_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 	const void *here = __builtin_return_address(0);
 	if (skb) {
 		int n = atomic_read(select_skb_count(skb));
-		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
-				rxrpc_skb(skb)->rx_flags, here);
+		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 	}
 }
 
@@ -48,8 +45,7 @@ void rxrpc_get_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(select_skb_count(skb));
-	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
-			rxrpc_skb(skb)->rx_flags, here);
+	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 	skb_get(skb);
 }
 
@@ -60,7 +56,7 @@ void rxrpc_eaten_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(&rxrpc_n_rx_skbs);
-	trace_rxrpc_skb(skb, op, 0, n, 0, here);
+	trace_rxrpc_skb(skb, op, 0, n, here);
 }
 
 /*
@@ -72,8 +68,7 @@ void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 	if (skb) {
 		int n;
 		n = atomic_dec_return(select_skb_count(skb));
-		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
-				rxrpc_skb(skb)->rx_flags, here);
+		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 		kfree_skb(skb);
 	}
 }
@@ -88,8 +83,7 @@ void rxrpc_purge_queue(struct sk_buff_head *list)
 	while ((skb = skb_dequeue((list))) != NULL) {
 		int n = atomic_dec_return(select_skb_count(skb));
 		trace_rxrpc_skb(skb, rxrpc_skb_purged,
-				refcount_read(&skb->users), n,
-				rxrpc_skb(skb)->rx_flags, here);
+				refcount_read(&skb->users), n, here);
 		kfree_skb(skb);
 	}
 }


