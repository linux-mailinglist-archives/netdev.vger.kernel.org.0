Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD36B621F14
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiKHWVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiKHWUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:20:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D6C64A09
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BmYwYEwE3K4lKT0t70YgMsajeLE4ht81LMIqW4jXi8c=;
        b=ajlsYLSuWkgN+1TMfIwjqgfRqpGelwv9uhxatM6XqWNYboJA6JnK5EyRnF6D1IE3r/JP8R
        96FUqruREKV1jM40lBEDpqDOvOmrhN6z47b91J8CNhiuAJms4Vw7x8k1q4jJPlzaynFE8O
        b1oafuQtw9URB2KYp2jZp9IDY1fmyK0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-SOQNcofAN8S3zWT9HdpFww-1; Tue, 08 Nov 2022 17:19:23 -0500
X-MC-Unique: SOQNcofAN8S3zWT9HdpFww-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03382185A79C;
        Tue,  8 Nov 2022 22:19:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B317492B05;
        Tue,  8 Nov 2022 22:19:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 14/26] rxrpc: Remove call->tx_phase
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:19:21 +0000
Message-ID: <166794596151.2389296.15788531007597364165.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove call->tx_phase as it's only ever set.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    1 -
 net/rxrpc/call_object.c |    1 -
 net/rxrpc/input.c       |    5 +----
 net/rxrpc/recvmsg.c     |    1 -
 4 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 92f20b6c23ca..282cb986f8a7 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -678,7 +678,6 @@ struct rxrpc_call {
 	rxrpc_serial_t		rx_serial;	/* Highest serial received for this call */
 	u8			rx_winsize;	/* Size of Rx window */
 	u8			tx_winsize;	/* Maximum size of Tx window */
-	bool			tx_phase;	/* T if transmission phase, F if receive phase */
 	u8			nr_jumbo_bad;	/* Number of jumbo dups/exceeds-windows */
 
 	spinlock_t		input_lock;	/* Lock for packet input to this call */
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index a75861a0c477..8290d94e9233 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -206,7 +206,6 @@ static struct rxrpc_call *rxrpc_alloc_client_call(struct rxrpc_sock *rx,
 		return ERR_PTR(-ENOMEM);
 	call->state = RXRPC_CALL_CLIENT_AWAIT_CONN;
 	call->service_id = srx->srx_service;
-	call->tx_phase = true;
 	now = ktime_get_real();
 	call->acks_latest_ts = now;
 	call->cong_tstamp = now;
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 59a0b8aee2a2..0cb23ba79e3b 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -309,10 +309,7 @@ static bool rxrpc_receiving_reply(struct rxrpc_call *call)
 			return false;
 		}
 	}
-	if (!rxrpc_end_tx_phase(call, true, "ETD"))
-		return false;
-	call->tx_phase = false;
-	return true;
+	return rxrpc_end_tx_phase(call, true, "ETD");
 }
 
 /*
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 7e39c262fd79..a378e7a672a8 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -203,7 +203,6 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 		break;
 
 	case RXRPC_CALL_SERVER_RECV_REQUEST:
-		call->tx_phase = true;
 		call->state = RXRPC_CALL_SERVER_ACK_REQUEST;
 		call->expect_req_by = jiffies + MAX_JIFFY_OFFSET;
 		write_unlock_bh(&call->state_lock);


