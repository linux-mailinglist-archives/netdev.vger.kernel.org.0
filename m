Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09AA33357C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhCJFlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:41:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhCJFlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:41:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9370E64FE3;
        Wed, 10 Mar 2021 05:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615354878;
        bh=2ghYgVS5Shi73FGvOYYFayRncHNij4Rvm0AP/O4q19U=;
        h=Date:From:To:Cc:Subject:From;
        b=CXfHEBsPkJGF3emkhgbN/jg3/rB+AsSJmHESVvkovzUD8G4OmFvIB4qh/AxyAG+Zj
         GzvxBhUybD/ibtjIHyZx3SmM7MzfJfQ+PfL4HqLFyjgTuQCSsf6K6CGLkhPFTH9AoR
         hv3GhEWfI4aqa7aBsnQokp6TJfBS4Jglmq+WcBJ90JNAjHVSbN8ch4vNM/SWNwDz5X
         sP8w3sNxciyp0pbO4kYBsvS5OBE8PFYsDk/ExtlvBKKtEI9a9VXr8ntVQ6xA89SitY
         +/g8Dk9IYVe32FSvtWmcR8PnTNmQlE+hGBXs9eX7b1tQDRZrSPtJi06mhgAY9Kwobo
         lhIqObbNlIDhw==
Date:   Tue, 9 Mar 2021 23:41:15 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] net: bridge: Fix fall-through warnings for Clang
Message-ID: <20210310054115.GA285785@embeddedor>
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
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 Changes in RESEND:
 - None. Resending now that net-next is open.

 net/bridge/br_input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 222285d9dae2..8875e953ac53 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -144,6 +144,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		break;
 	case BR_PKT_UNICAST:
 		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

