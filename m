Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4517C2BB413
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbgKTSkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730799AbgKTSkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:40:03 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5212415A;
        Fri, 20 Nov 2020 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897602;
        bh=kvNu1AecsB3qb/9gvKDWdvnXY/lZR0Q75MQ4NElqdiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iwL9eI/C9QAKLeFLezdCLBTkkS8bTbKgCJiGMcD8MWJM3JjGb2wa32Pd5Hza0iVn4
         ZI9iQNkjLvkTZHOWxdwpmirLZsYhDKt+3x6D+0rcV92c4zKbIYHmntxCe16bffSjlm
         JTjeA8mzcyVgXGqu65NqYDkOmc+12g4NHdmrm+so=
Date:   Fri, 20 Nov 2020 12:40:08 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 130/141] tipc: Fix fall-through warnings for Clang
Message-ID: <73d7bf7a4aea53ddce817ac08c043203b48df50f.1605896060.git.gustavoars@kernel.org>
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
 net/tipc/link.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 06b880da2a8e..839082cf259e 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -615,6 +615,7 @@ int tipc_link_fsm_evt(struct tipc_link *l, int evt)
 			break;
 		case LINK_FAILOVER_BEGIN_EVT:
 			l->state = LINK_FAILINGOVER;
+			break;
 		case LINK_FAILURE_EVT:
 		case LINK_RESET_EVT:
 		case LINK_ESTABLISH_EVT:
-- 
2.27.0

