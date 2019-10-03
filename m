Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1051ECA9AB
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392872AbfJCQqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:46:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731237AbfJCQp6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 12:45:58 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C648065998;
        Thu,  3 Oct 2019 16:45:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-125-72.rdu2.redhat.com [10.10.125.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD3CE46;
        Thu,  3 Oct 2019 16:45:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next] rxrpc: Add missing "new peer" trace
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 03 Oct 2019 17:45:57 +0100
Message-ID: <157012115701.21124.13973726693523106899.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 03 Oct 2019 16:45:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was supposed to be a trace indicating that a new peer had been
created.  Add it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/peer_object.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 9c3ac96f71cb..bf4dd6cf79a0 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -209,6 +209,7 @@ static void rxrpc_assess_MTU_size(struct rxrpc_sock *rx,
  */
 struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 {
+	const void *here = __builtin_return_address(0);
 	struct rxrpc_peer *peer;
 
 	_enter("");
@@ -230,6 +231,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 			peer->cong_cwnd = 3;
 		else
 			peer->cong_cwnd = 4;
+		trace_rxrpc_peer(peer, rxrpc_peer_new, 1, here);
 	}
 
 	_leave(" = %p", peer);

