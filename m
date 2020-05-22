Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE45F1DF31C
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387436AbgEVXmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:42:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27618 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387413AbgEVXmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590190963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xd7Kn/lno3L3olRbHEyTUX5d4LEKh+MuYsgRNc5tlak=;
        b=Op4yx+4R9U9TLtXBIMFA9j25lLzGWIyFivBknCvVLrbMz0fWSGtDCiZNn2lGGFrnHUc69T
        zjUQY89eVMO7IfW94MuxeLk5LayU37YEN9mMkrgiCU++nCApANUCYt1MM3r2uiArUj9Rcr
        o9Qi74Tm9GhDljeBfejdYd0PK8rIf+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-ceVE17bLPKWBmXkjGKISEA-1; Fri, 22 May 2020 19:42:42 -0400
X-MC-Unique: ceVE17bLPKWBmXkjGKISEA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A517107ACCA;
        Fri, 22 May 2020 23:42:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C5845D788;
        Fri, 22 May 2020 23:42:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/2] rxrpc: Fix a warning [ver #2]
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 23 May 2020 00:42:39 +0100
Message-ID: <159019095956.999797.14199554784467459911.stgit@warthog.procyon.org.uk>
In-Reply-To: <159019095229.999797.5088700147400532632.stgit@warthog.procyon.org.uk>
References: <159019095229.999797.5088700147400532632.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a warning due to an uninitialised variable.

le included from ../fs/afs/fs_probe.c:11:
../fs/afs/fs_probe.c: In function 'afs_fileserver_probe_result':
../fs/afs/internal.h:1453:2: warning: 'rtt_us' may be used uninitialized in this function [-Wmaybe-uninitialized]
 1453 |  printk("[%-6.6s] "FMT"\n", current->comm ,##__VA_ARGS__)
      |  ^~~~~~
../fs/afs/fs_probe.c:35:15: note: 'rtt_us' was declared here

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/fs_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
index 237352d3cb53..37d1bba57b00 100644
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -32,7 +32,7 @@ void afs_fileserver_probe_result(struct afs_call *call)
 	struct afs_server *server = call->server;
 	unsigned int server_index = call->server_index;
 	unsigned int index = call->addr_ix;
-	unsigned int rtt_us;
+	unsigned int rtt_us = 0;
 	bool have_result = false;
 	int ret = call->error;
 


