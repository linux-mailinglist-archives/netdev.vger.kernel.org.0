Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99895333576
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhCJFil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:38:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232311AbhCJFiO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:38:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15C6264D90;
        Wed, 10 Mar 2021 05:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615354693;
        bh=HEbOjc/PITm8oz4nfMKzFJ3cbaJmd0Dg6I/RKPWIIgg=;
        h=Date:From:To:Cc:Subject:From;
        b=LIXEtGlEPHW/qimEs9ftYG+cyEy6rYG63mxIUNkUj7VPiY0ZVt8fFv3t6/D9MQVot
         AJ7fjVGLSz0xwfDf1o4oBimqwwSQD0BVdRn3/yH6ijEj+R4zItt9AO7tm6HvM/+q+s
         moNHZCXbnfKWUy5dSLOzhgnS/thHW2Okf+zGQEswY5zwsYf4roPlcEe4SepAiMITcA
         NLBz0N4kkaySqfCjxDwT/ilwhiYHUSZQtfSCq5fxJbbEBzBbm158f+V9sbD5D2/C8x
         Ss416VtzGEXrBenPUrrKYfZlHcDjxheByFhc2SMxyADZU+XSf8RxinsCHGISe3Yjl1
         UrwymCVAT9anA==
Date:   Tue, 9 Mar 2021 23:38:11 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] decnet: Fix fall-through warnings for Clang
Message-ID: <20210310053811.GA285532@embeddedor>
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
 Changes in RESEND:
 - None. Resending now that net-next is open.

 net/decnet/dn_route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 2193ae529e75..37c90c1fdc93 100644
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

