Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B5D315078
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhBINjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:39:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39542 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231400AbhBINjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 08:39:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612877889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D8mj2nHx0RwH9BxwdwEGf7Y7vNwuIndJNb/7KTwc/iQ=;
        b=MKPThFB/bwvjed6X9W/m3sa9wd5NzJeQET85SejGAvnSJzVHjgadiKska/IfvpVn3i9Mk+
        qzSBjp2fYh5zkciq/QQD/CDhdRfjoxs4RKlY3OmAmIORMpKV+TSUPh2nD1jxkJtZX5eXt0
        /Kzzw1HOJ1Z5Owv1w8F8InYnt1gamV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-JwpGrTvlNnqa-KCkagzzZw-1; Tue, 09 Feb 2021 08:38:05 -0500
X-MC-Unique: JwpGrTvlNnqa-KCkagzzZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAEA6107ACE3;
        Tue,  9 Feb 2021 13:38:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16EC610016F6;
        Tue,  9 Feb 2021 13:38:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH net] rxrpc: Fix missing dependency on NET_UDP_TUNNEL
From:   David Howells <dhowells@redhat.com>
To:     lucien.xin@gmail.com, vfedorenko@novek.ru
Cc:     kernel test robot <lkp@intel.com>, alaa@dev.mellanox.co.il,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 09 Feb 2021 13:38:01 +0000
Message-ID: <161287788114.579714.4927352060016972328.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The changes to make rxrpc create the udp socket missed a bit to add the
Kconfig dependency on the udp tunnel code to do this.

Fix this by adding making AF_RXRPC select NET_UDP_TUNNEL.

Fixes: 1a9b86c9fd95 ("rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Xin Long <lucien.xin@gmail.com>
cc: alaa@dev.mellanox.co.il
cc: Jakub Kicinski <kuba@kernel.org>
---

 net/rxrpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index d706bb408365..0885b22e5c0e 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -8,6 +8,7 @@ config AF_RXRPC
 	depends on INET
 	select CRYPTO
 	select KEYS
+	select NET_UDP_TUNNEL
 	help
 	  Say Y or M here to include support for RxRPC session sockets (just
 	  the transport part, not the presentation part: (un)marshalling is


