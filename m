Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78ADB2BB37F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgKTSe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730424AbgKTSe4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:34:56 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD03E24124;
        Fri, 20 Nov 2020 18:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897295;
        bh=+18ftOuWTTwQmNA74ECgfzhFD1fxaiRwBOoM24rI8aw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=woTw521mDkE6icq5ms2WJ8hdRcRN64D89VKj+BomMPEPy9TTsmDrOkojy9bDYhLUz
         01fFKN5143rQ6vUKmLgrcTdjwWBCuS/MJfLWz3BCZvGHCNCPvuQxScA6uptMQGeUlX
         cVPDiow16rDgzpCv9oiQYl7OAjwAa6gzekqY8BH0=
Date:   Fri, 20 Nov 2020 12:35:01 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 076/141] decnet: Fix fall-through warnings for Clang
Message-ID: <c0b4dfadf61968028e9265fca33d537817e0771c.1605896059.git.gustavoars@kernel.org>
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
 net/decnet/dn_route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 4cac31d22a50..2f3e5c49a221 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1407,7 +1407,7 @@ static int dn_route_input_slow(struct sk_buff *skb)
 			flags |= RTCF_DOREDIRECT;
 
 		local_src = DN_FIB_RES_PREFSRC(res);
-
+		break;
 	case RTN_BLACKHOLE:
 	case RTN_UNREACHABLE:
 		break;
-- 
2.27.0

