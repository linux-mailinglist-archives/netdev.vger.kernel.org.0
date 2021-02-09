Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EC731524E
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhBIPDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:03:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhBIPDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:03:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612882932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3tgkguWc5COknhf3MfpndDObNvyg3XXCqrTvWwHzWnQ=;
        b=YTC5OSkGjpwW45GWXXNlye1fO2FZGnz2WYr7CxwyDiV56N9o4NibmxV9QRzBvqsxhfq+VL
        nFpT5YU8rnQL4CoP2J+FzNSon8RnW/rSFMkKpc46sgNGrOsRCaj9ipC/ArFUVFSfWYnkST
        VXyc/iTE0r84lsGixjttC2L37FwAcRQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-QzklC8vMMpepi8KAWww_jw-1; Tue, 09 Feb 2021 10:02:09 -0500
X-MC-Unique: QzklC8vMMpepi8KAWww_jw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21BBB19611A0;
        Tue,  9 Feb 2021 15:02:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AD096062F;
        Tue,  9 Feb 2021 15:02:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next] rxrpc: Fix missing dependency on NET_UDP_TUNNEL
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Xin Long <lucien.xin@gmail.com>, alaa@dev.mellanox.co.il,
        Jakub Kicinski <kuba@kernel.org>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        lucien.xin@gmail.com, vfedorenko@novek.ru
Date:   Tue, 09 Feb 2021 15:02:05 +0000
Message-ID: <161288292553.585687.14447945995623785380.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The changes to make rxrpc create the udp socket missed a bit to add the
Kconfig dependency on the udp tunnel code to do this.

Fix this by adding making AF_RXRPC select NET_UDP_TUNNEL.

Fixes: 1a9b86c9fd95 ("rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
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


