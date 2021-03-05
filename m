Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3D432E30C
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhCEHiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:38:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCEHix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 02:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25CDB64F44;
        Fri,  5 Mar 2021 07:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614929933;
        bh=coqHJVKiOdwTzRmKkjxvxe6gkSwn9w9KuwMwJB7cM4I=;
        h=Date:From:To:Cc:Subject:From;
        b=BWPxntnfh0GNr3bekp1S375DyL4W920aZWKwkmjaopN0LYS3GzjCx23uQpKN82r3R
         MD+1acFWAJLYZespAlhbki5hhMqHBpANr140XNkYxBdwZHl/IactW17wBYXOxhzw35
         iQa8hNx8oYoCCMO8ely+nSw6HlnXqPYNq9N7BNvemrJmxxSObPkio+uKxniHX7jlgt
         eKTQ2p27WOauM7td4l0bWU+9axY1j1pKhY//sJ3DK4g+wkL5nsGbPq59pRYbZL0upS
         BudxDPEGsr8cmN+Rf+MVKF7yi2LQbei21ZRHQNZwMfCmprfI9LW5dEsS+qjszoWRZw
         fL2eutjHee89Q==
Date:   Fri, 5 Mar 2021 01:38:49 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] decnet: Fix fall-through warnings for Clang
Message-ID: <20210305073849.GA122638@embeddedor>
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

