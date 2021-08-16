Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8BC3ECBD8
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 02:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhHPAGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 20:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbhHPAGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 20:06:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43A0C061764;
        Sun, 15 Aug 2021 17:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=f2ZIVAVeoY8nho9NzjTCoBlb9ewzNUoIx59sjqw0Jyc=; b=Xa6Kr5aC888Zl6VKH/79Jw5PLu
        UcqjL5rjGSlBWgJeuaQX5SE3kod4ZuWcmHgc1O9uWJFjsufNDjsygMAI29HJthDWDGkyhFfzw3toA
        ZJ7KeZtUZoVhtGWPoY+fzgo0x++NyM69nZ8y5M3mEbLrcP5AIqZC6RQ955vmO6XQxrerhPGMGs+Ze
        N1nX9ybS6TWq7LmLfrZZsLAGboC54CMjOHvUKI5s+ZyzbDNoxPaJkVVYoSt+kLPTLwIRqrjWiAJA1
        cZOAfKiwLiPMzNmDUocYcf9MaTrCbGgMrhoqKX4PbGP3emE68Y4cgOznYvPUE18pa4oAtEEjkg9pr
        MAmnsTFA==;
Received: from [2601:1c0:6280:3f0:e65e:37ff:febd:ee53] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFQ8N-00Fkzd-I6; Mon, 16 Aug 2021 00:05:43 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net: RxRPC: make dependent Kconfig symbols be shown indented
Date:   Sun, 15 Aug 2021 17:05:42 -0700
Message-Id: <20210816000542.18711-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make all dependent RxRPC kconfig entries be dependent on AF_RXRPC
so that they are presented (indented) after AF_RXRPC instead
of being presented at the same level on indentation.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: linux-afs@lists.infradead.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 net/rxrpc/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-next-20210813.orig/net/rxrpc/Kconfig
+++ linux-next-20210813/net/rxrpc/Kconfig
@@ -21,6 +21,8 @@ config AF_RXRPC
 
 	  See Documentation/networking/rxrpc.rst.
 
+if AF_RXRPC
+
 config AF_RXRPC_IPV6
 	bool "IPv6 support for RxRPC"
 	depends on (IPV6 = m && AF_RXRPC = m) || (IPV6 = y && AF_RXRPC)
@@ -30,7 +32,6 @@ config AF_RXRPC_IPV6
 
 config AF_RXRPC_INJECT_LOSS
 	bool "Inject packet loss into RxRPC packet stream"
-	depends on AF_RXRPC
 	help
 	  Say Y here to inject packet loss by discarding some received and some
 	  transmitted packets.
@@ -38,7 +39,6 @@ config AF_RXRPC_INJECT_LOSS
 
 config AF_RXRPC_DEBUG
 	bool "RxRPC dynamic debugging"
-	depends on AF_RXRPC
 	help
 	  Say Y here to make runtime controllable debugging messages appear.
 
@@ -47,7 +47,6 @@ config AF_RXRPC_DEBUG
 
 config RXKAD
 	bool "RxRPC Kerberos security"
-	depends on AF_RXRPC
 	select CRYPTO
 	select CRYPTO_MANAGER
 	select CRYPTO_SKCIPHER
@@ -58,3 +57,5 @@ config RXKAD
 	  through the use of the key retention service.
 
 	  See Documentation/networking/rxrpc.rst.
+
+endif
