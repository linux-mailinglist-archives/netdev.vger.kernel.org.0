Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33E91DF2EA
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387404AbgEVXYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:24:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49578 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731223AbgEVXXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:23:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590189812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xd7Kn/lno3L3olRbHEyTUX5d4LEKh+MuYsgRNc5tlak=;
        b=e5nskxbZM6BdVxx/iBsy6qoEe2RXl/lsAxCWPDqP2znsuAoJ7o5zgAeX04R3PfwrNp2iHx
        3QuYTa6BToBlQrYygcnd95psdtBjIathft65zbxuFIQJ0LK95Oj9MWgSL2ybJgKBVNPqlX
        QHSE4F7kudYBiLBsGv80y5++RJYES5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-pc7PmLKPNhCGOfV4Fu8Bmg-1; Fri, 22 May 2020 19:23:30 -0400
X-MC-Unique: pc7PmLKPNhCGOfV4Fu8Bmg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C585A8005AA;
        Fri, 22 May 2020 23:23:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 104C75C1D0;
        Fri, 22 May 2020 23:23:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/2] rxrpc: Fix a warning
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 23 May 2020 00:23:28 +0100
Message-ID: <159018980824.996784.6587719373730272639.stgit@warthog.procyon.org.uk>
In-Reply-To: <159018980141.996784.14747585629466633699.stgit@warthog.procyon.org.uk>
References: <159018980141.996784.14747585629466633699.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 


