Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668B75A91AB
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 10:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiIAIIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 04:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiIAIIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 04:08:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA95513252A
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 01:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662019687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/VisaIuDwQPL/j6BsI0dXcRMhVm18M62DV4g+QfZJE=;
        b=i5KBiIzW8l+jiTOorS6sZGvYO1KimL5poHoV4u6w9GUj5eqbeO0svRMj5NEK/O1hlU6Uw9
        lN1v29cw9D0rrRVofq+ljnfTdN5SGKoXsVhutnV9Xir/pjivSRk9SB85bJ95oN+GONBo4H
        XzZyqZfzqfttZuN6F4+z7UGZO11rIVI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-5jdIn-CiNKCP1Xk3IVylmw-1; Thu, 01 Sep 2022 04:08:04 -0400
X-MC-Unique: 5jdIn-CiNKCP1Xk3IVylmw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7206C96408C;
        Thu,  1 Sep 2022 08:08:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0C5740C141D;
        Thu,  1 Sep 2022 08:08:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 6/6] rxrpc: Remove rxrpc_get_reply_time() which is no
 longer used
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Sep 2022 09:08:03 +0100
Message-ID: <166201968325.3817988.15791788974507422429.stgit@warthog.procyon.org.uk>
In-Reply-To: <166201964443.3817988.12088441548413332725.stgit@warthog.procyon.org.uk>
References: <166201964443.3817988.12088441548413332725.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove rxrpc_get_reply_time() as that is no longer used now that the call
issue time is used instead of the reply time.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/networking/rxrpc.rst |   11 ---------
 include/net/af_rxrpc.h             |    2 --
 net/rxrpc/recvmsg.c                |   43 ------------------------------------
 3 files changed, 56 deletions(-)

diff --git a/Documentation/networking/rxrpc.rst b/Documentation/networking/rxrpc.rst
index 39c2249c7aa7..39494a6ea739 100644
--- a/Documentation/networking/rxrpc.rst
+++ b/Documentation/networking/rxrpc.rst
@@ -1055,17 +1055,6 @@ The kernel interface functions are as follows:
      first function to change.  Note that this must be called in TASK_RUNNING
      state.
 
- (#) Get reply timestamp::
-
-	bool rxrpc_kernel_get_reply_time(struct socket *sock,
-					 struct rxrpc_call *call,
-					 ktime_t *_ts)
-
-     This allows the timestamp on the first DATA packet of the reply of a
-     client call to be queried, provided that it is still in the Rx ring.  If
-     successful, the timestamp will be stored into ``*_ts`` and true will be
-     returned; false will be returned otherwise.
-
  (#) Get remote client epoch::
 
 	u32 rxrpc_kernel_get_epoch(struct socket *sock,
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index cee5f83c0f11..b69ca695935c 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -66,8 +66,6 @@ int rxrpc_kernel_charge_accept(struct socket *, rxrpc_notify_rx_t,
 void rxrpc_kernel_set_tx_length(struct socket *, struct rxrpc_call *, s64);
 bool rxrpc_kernel_check_life(const struct socket *, const struct rxrpc_call *);
 u32 rxrpc_kernel_get_epoch(struct socket *, struct rxrpc_call *);
-bool rxrpc_kernel_get_reply_time(struct socket *, struct rxrpc_call *,
-				 ktime_t *);
 bool rxrpc_kernel_call_is_complete(struct rxrpc_call *);
 void rxrpc_kernel_set_max_life(struct socket *, struct rxrpc_call *,
 			       unsigned long);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 250f23bc1c07..7e39c262fd79 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -771,46 +771,3 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 	goto out;
 }
 EXPORT_SYMBOL(rxrpc_kernel_recv_data);
-
-/**
- * rxrpc_kernel_get_reply_time - Get timestamp on first reply packet
- * @sock: The socket that the call exists on
- * @call: The call to query
- * @_ts: Where to put the timestamp
- *
- * Retrieve the timestamp from the first DATA packet of the reply if it is
- * in the ring.  Returns true if successful, false if not.
- */
-bool rxrpc_kernel_get_reply_time(struct socket *sock, struct rxrpc_call *call,
-				 ktime_t *_ts)
-{
-	struct sk_buff *skb;
-	rxrpc_seq_t hard_ack, top, seq;
-	bool success = false;
-
-	mutex_lock(&call->user_mutex);
-
-	if (READ_ONCE(call->state) != RXRPC_CALL_CLIENT_RECV_REPLY)
-		goto out;
-
-	hard_ack = call->rx_hard_ack;
-	if (hard_ack != 0)
-		goto out;
-
-	seq = hard_ack + 1;
-	top = smp_load_acquire(&call->rx_top);
-	if (after(seq, top))
-		goto out;
-
-	skb = call->rxtx_buffer[seq & RXRPC_RXTX_BUFF_MASK];
-	if (!skb)
-		goto out;
-
-	*_ts = skb_get_ktime(skb);
-	success = true;
-
-out:
-	mutex_unlock(&call->user_mutex);
-	return success;
-}
-EXPORT_SYMBOL(rxrpc_kernel_get_reply_time);


