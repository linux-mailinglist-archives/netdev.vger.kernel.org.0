Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8751E32E4BC
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhCEJZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:25:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhCEJZH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:25:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11CF964FCF;
        Fri,  5 Mar 2021 09:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614936306;
        bh=6vV6T20UPqGW4+XtmqeHrshu/Vv3GHspJmUqpSLTC1U=;
        h=Date:From:To:Cc:Subject:From;
        b=SKdnK52VeE68l+tvp/7qjXvMEOvgV6ZdC8u1yt23P7d91ArMA3pO9oMxLFdxS7iH9
         nXKcZ9WCVF0xfycTCnqg0/Lqc6wnlnpmFnlXnfHqRKb5H8eZaMhtflB1co3QFANTsX
         k/PNJnv/k9TaMe0dShRA4VlMMNWzpGUssFioRf4P6QbIwr3Htn/4Cs2Q0IWCwAt92v
         Aw70nzpu+NTN/gYKYTi5+8DnMCgujnNBCCrA8mGBPtwCJiSpYociGMZIApqrAVjia6
         4d9QLLXSQjSOP90USy0YfSKwSTVF8X45CAL0YoDIhsGr8Zjb6pjpUauarmOpmwLGlf
         2qoASeRXGxPpQ==
Date:   Fri, 5 Mar 2021 03:25:04 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] tipc: Fix fall-through warnings for Clang
Message-ID: <20210305092504.GA140204@embeddedor>
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
 net/tipc/link.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 115109259430..bcc426e16725 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -649,6 +649,7 @@ int tipc_link_fsm_evt(struct tipc_link *l, int evt)
 			break;
 		case LINK_FAILOVER_BEGIN_EVT:
 			l->state = LINK_FAILINGOVER;
+			break;
 		case LINK_FAILURE_EVT:
 		case LINK_RESET_EVT:
 		case LINK_ESTABLISH_EVT:
-- 
2.27.0

