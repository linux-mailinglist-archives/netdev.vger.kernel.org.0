Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B59333582
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhCJFnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhCJFmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:42:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26E5864FE3;
        Wed, 10 Mar 2021 05:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615354965;
        bh=8sqY/NJDPujpuNyJoOQPT7Ic/DuNS6TM8cQ/HgWhjIg=;
        h=Date:From:To:Cc:Subject:From;
        b=gllnUOlMgm4qHwd0KXVs84qES5RNXcdN4cqHRgr2C4K/UMGQG2udhrXHZx6vYMUp6
         HhRKRUKrAH+y22MGYT3V8zIgxOqeb06bNKCpJAObF8l6MGydoG0D5qH4b1AzDkMMdy
         TEFyRPyQYGyxLO70meymldQzDV4Pv2x3pK9RnT2CF3aW2ak+Fax4blGWtHVv8tlgL2
         hZwz93tLVMdbDKgWwFfJ7s1GW+IeoRwcTcVo0i3jFsAm06sGheHjbh1gCCdaGDXHwW
         lkp7dHTuZuxzu8ciOilXcT+CcC0ssY5BFJoWBa/X7bp5MZCYeHPiV3CX6DwA6lHDW0
         KjAhuJgVo/SUA==
Date:   Tue, 9 Mar 2021 23:42:43 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] net: core: Fix fall-through warnings for Clang
Message-ID: <20210310054243.GA285911@embeddedor>
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

