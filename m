Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87BD2BB422
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbgKTSk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:40:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731658AbgKTSkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:40:55 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B04424655;
        Fri, 20 Nov 2020 18:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897654;
        bh=PZVaIjk40l4bncqdoGs4NhN5bCd08ySW8uH6LdCAoTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f/i9w9Dj5WbgbDNIZXrlTq5LE4Ig2xpAhPsZMTOz7vPCTZKtEz4K2FZyJNHJlKMF4
         1LB9eYYINopT0xnLSyxmMz+B+iciOM0V/2Vcbvy2OwblwScQ/GYKBsIRl/GE8XZd7u
         dzSl7Tbdwq8fW/yaX55cpt3xP+DVAlc9UKykKZPg=
Date:   Fri, 20 Nov 2020 12:41:00 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 139/141] xfrm: Fix fall-through warnings for Clang
Message-ID: <ddfa06633ac050d96303cc6455b2cf6d4a09b818.1605896060.git.gustavoars@kernel.org>
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
 net/xfrm/xfrm_interface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 9b8e292a7c6a..8ea705df8e3c 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -433,6 +433,7 @@ static int xfrmi4_err(struct sk_buff *skb, u32 info)
 	case ICMP_DEST_UNREACH:
 		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
 			return 0;
+		break;
 	case ICMP_REDIRECT:
 		break;
 	default:
-- 
2.27.0

