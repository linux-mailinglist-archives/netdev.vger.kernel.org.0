Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCC932E31F
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhCEHni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:43:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCEHnh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 02:43:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6312564FFD;
        Fri,  5 Mar 2021 07:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614930217;
        bh=c0d0xdnkz9rdqv7x58JjZeemTCwzuu8lYBizo3XXlX4=;
        h=Date:From:To:Cc:Subject:From;
        b=oNcjvdnBwZY0Hum6a1gmDD7cjKw7XmG6uYdD1yyht4NakpJxI0B7edruvX7mc0dem
         je4Nhol4O4RFmy01yqMUqQS2m01JvOJUng4wlLicznPqrLSb7KUfqvHDTPQaqzVSl5
         gm9fFnhpCu2KPnQ27ZNKJDAc5Hz6VHUxdyDVZ5bgjxzRrcjSmiRSJNDtzBZG5a7B/6
         1nD3K4TNUvRy1t6RzmikYhtOlAKaIPS/0P2MtlV+X7nFvPMYfYh44TQo0TdC+NT6CC
         X52zgmbySLPICWjvuI5gIiWpiOF1fN51TIx6OYK3lgk2URHZLCI+NiOuBzjaSyTltj
         Mro6Nt7EsI4AA==
Date:   Fri, 5 Mar 2021 01:43:34 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: core: Fix fall-through warnings for Clang
Message-ID: <20210305074334.GA123155@embeddedor>
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
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..2bfdd528c7c3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5265,6 +5265,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 			goto another_round;
 		case RX_HANDLER_EXACT:
 			deliver_exact = true;
+			break;
 		case RX_HANDLER_PASS:
 			break;
 		default:
-- 
2.27.0

