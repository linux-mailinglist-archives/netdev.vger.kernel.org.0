Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEA86448CD
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiLFQJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiLFQI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:08:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062012F38A
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=if43UGApWWJdqTN/53+zoOb2JfWQ93VyHHfMWcbQemE=;
        b=XtbGqGyFNR3bwtLMEv8s+WKND6Aw8UWusjjaHxvZoGhA+XqbcpGnLb//ggkg8uSyw29KVT
        nr1q/0fJrV9U2j+1AmL+cS53xrofg6qtbHfKZPMBWfTNnpoNOkhQnbNZTyAri6c2r+dh4C
        L7EDraIzvsN8Ay9Y4n3pI25KgyykZmY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-DRMKhfe8PJ2MOlVLvAu9cQ-1; Tue, 06 Dec 2022 11:03:08 -0500
X-MC-Unique: DRMKhfe8PJ2MOlVLvAu9cQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42205857FAC;
        Tue,  6 Dec 2022 16:03:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BE651410DD9;
        Tue,  6 Dec 2022 16:03:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 32/32] rxrpc: Kill service bundle
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:03:05 +0000
Message-ID: <167034258505.1105287.5403397572562689183.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the bundle->channel_lock has been eliminated, we don't need the
dummy service bundle anymore.  It's purpose was purely to provide the
channel_lock for service connections.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/conn_service.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index f30323de82bd..89ac05a711a4 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -8,11 +8,6 @@
 #include <linux/slab.h>
 #include "ar-internal.h"
 
-static struct rxrpc_bundle rxrpc_service_dummy_bundle = {
-	.ref		= REFCOUNT_INIT(1),
-	.debug_id	= UINT_MAX,
-};
-
 /*
  * Find a service connection under RCU conditions.
  *
@@ -132,8 +127,6 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 		 */
 		conn->state = RXRPC_CONN_SERVICE_PREALLOC;
 		refcount_set(&conn->ref, 2);
-		conn->bundle = rxrpc_get_bundle(&rxrpc_service_dummy_bundle,
-						rxrpc_bundle_get_service_conn);
 
 		atomic_inc(&rxnet->nr_conns);
 		write_lock(&rxnet->conn_lock);


