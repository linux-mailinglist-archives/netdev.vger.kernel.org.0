Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C2A2BB3E0
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbgKTSjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:39:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731151AbgKTSjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:39:05 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB0562242B;
        Fri, 20 Nov 2020 18:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897544;
        bh=t3ClybAIVgVgMruU6IzTwMzc933R2eHYAPe5wLYOfo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ivt4iX8/qEnWiABubOsfiIWojSQPWY1Q8cgAefwtBrPcfn3Nw1D4GFaGSLcgd0iCw
         pTYVU4PogldR64dt5ZMmKid257lEPwwmkFRKTVekaSGhEDwij7DhwvAwei1028peO5
         rfXwCegjrOCE5JW5SuIeAAUcaoVrKVp/ME2cOnuM=
Date:   Fri, 20 Nov 2020 12:39:10 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 119/141] rxrpc: Fix fall-through warnings for Clang
Message-ID: <93f1b2299a5ab99835cfb5b683e7a38d83da341a.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/rxrpc/af_rxrpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 0a2f4817ec6c..aa43191dbb09 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -471,6 +471,7 @@ static int rxrpc_connect(struct socket *sock, struct sockaddr *addr,
 	switch (rx->sk.sk_state) {
 	case RXRPC_UNBOUND:
 		rx->sk.sk_state = RXRPC_CLIENT_UNBOUND;
+		break;
 	case RXRPC_CLIENT_UNBOUND:
 	case RXRPC_CLIENT_BOUND:
 		break;
-- 
2.27.0

