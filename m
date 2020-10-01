Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D1B2801D4
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732688AbgJAO6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:58:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732674AbgJAO55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pZ2LCJFNFpU868U2uKNNq+7zkCZGrGHX9m/gRt2/T/E=;
        b=irrFaYzbi7QDDe1b6w3r0nRZweI/Avt1yowiQ+PL1U+ZxMTvudRcj9ussXpubcNzD28W2l
        KmdED/e4eedzHUVJRiOs7Bv56uYxUJnN5ng5W0QYx4P7ffuI7tVnEE3kPHwHipFNIbnpqx
        Fc5sK0eJBoPmC0VeyDmMXNC6/Y+5ACQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-PUUN74EsOEGvhdpZqZ2v8w-1; Thu, 01 Oct 2020 10:57:48 -0400
X-MC-Unique: PUUN74EsOEGvhdpZqZ2v8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA5A381A41F;
        Thu,  1 Oct 2020 14:57:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28C8060BFA;
        Thu,  1 Oct 2020 14:57:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 09/23] rxrpc: Change basic data packet size alignment
 to 1
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:57:45 +0100
Message-ID: <160156426536.1728886.12306247875002872210.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the basic data packet size alignment to be 1 not 4.  There isn't
really any need to do otherwise unless there's crypto involved.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/conn_object.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 3bcbe0665f91..d84db9eb9a85 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -49,7 +49,7 @@ struct rxrpc_connection *rxrpc_alloc_connection(gfp_t gfp)
 		conn->security = &rxrpc_no_security;
 		spin_lock_init(&conn->state_lock);
 		conn->debug_id = atomic_inc_return(&rxrpc_debug_id);
-		conn->size_align = 4;
+		conn->size_align = 1;
 		conn->idle_timestamp = jiffies;
 	}
 


