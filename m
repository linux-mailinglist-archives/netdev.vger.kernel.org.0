Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E058A6448C6
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiLFQIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiLFQIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:08:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593FA30551
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x9juvaXVaL28eEnmQQQRq6GWfhzwua06aQgR2Ht6E8g=;
        b=Dk5WaajmbkDKs3cJVcbevcyN6tWaoAJz3RLgBJhncfTn/xnjRwkcAYzT2c0oi7mOhmSmce
        7tmbB88hMI4/d5LJg2u2igqTtKfKu/llbKqEqs6yHp05JZ28RC+MuEO3n7RZwYPCdOfjga
        bSQFaplVtFNmi2plVfew6fLfei3NL0U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-RE_ZAWRJPYCu9p5QrirYcw-1; Tue, 06 Dec 2022 11:02:51 -0500
X-MC-Unique: RE_ZAWRJPYCu9p5QrirYcw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15D20833AF4;
        Tue,  6 Dec 2022 16:02:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F8CCC15BA4;
        Tue,  6 Dec 2022 16:02:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 30/32] rxrpc: Change rx_packet tracepoint to display
 securityIndex not type twice
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:02:47 +0000
Message-ID: <167034256776.1105287.711207190763674876.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the rx_packet tracepoint to display the securityIndex from the
packet header instead of displaying the type in numeric form.  There's no
need for the latter, as the display of the type in symbolic form will fall
back automatically to displaying the hex value if no symbol is available.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 81182efca327..a4c5bc481cfc 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -752,9 +752,8 @@ TRACE_EVENT(rxrpc_rx_packet,
 		      __entry->hdr.epoch, __entry->hdr.cid,
 		      __entry->hdr.callNumber, __entry->hdr.serviceId,
 		      __entry->hdr.serial, __entry->hdr.seq,
-		      __entry->hdr.type, __entry->hdr.flags,
-		      __entry->hdr.type <= 15 ?
-		      __print_symbolic(__entry->hdr.type, rxrpc_pkts) : "?UNK")
+		      __entry->hdr.securityIndex, __entry->hdr.flags,
+		      __print_symbolic(__entry->hdr.type, rxrpc_pkts))
 	    );
 
 TRACE_EVENT(rxrpc_rx_done,


