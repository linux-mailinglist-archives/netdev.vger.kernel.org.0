Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2775A32E4A0
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCEJTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229642AbhCEJTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:19:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78C1A64F45;
        Fri,  5 Mar 2021 09:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614935943;
        bh=1VhZoKuJ8VHh/7hh2GHHwmVS9zTteDOhYb7TJcdeSHU=;
        h=Date:From:To:Cc:Subject:From;
        b=auG1DoTD/MypavfGPZ2jDyz5qqb+eNle3bhPX7/bzV4nG9GB6/r9RaYY9NNOlEdUX
         PevrncE9YKW+EALG6i/9Vb0Mo/BQW3xjPqaHV82cG1L7PTbpikt73B4qMBSAYoAU53
         Wms9gW5SPWJ6T+d3YC5+G8zyKXBGioCH4Miu0Vxlw12v6LE11bxgB3TZk3BvIJ9YBd
         MtdUZahDfFTG151epjTMxKwyHRLCsclcPPqRHrNZYvcWDsBI2ZNmFwlArN9rMUIq+Z
         FfxQlQgORXxKjhN9iVcSL6ZJaOdFBlB64y9AnFk8SmM0o9a3bi/L4mC8fAezB3Y8fW
         s3MdX7L3X08bA==
Date:   Fri, 5 Mar 2021 03:19:00 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] rxrpc: Fix fall-through warnings for Clang
Message-ID: <20210305091900.GA139713@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
index 41671af6b33f..2b5f89713e36 100644
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

