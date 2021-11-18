Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E66C4565AB
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 23:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhKRW3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 17:29:39 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58300 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhKRW3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 17:29:35 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 762916499E;
        Thu, 18 Nov 2021 23:24:26 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 07/11] netfilter: ctnetlink: do not erase error code with EINVAL
Date:   Thu, 18 Nov 2021 23:26:14 +0100
Message-Id: <20211118222618.433273-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118222618.433273-1-pablo@netfilter.org>
References: <20211118222618.433273-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florent Fourcot <florent.fourcot@wifirst.fr>

And be consistent in error management for both orig/reply filtering

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2663764d0b6e..c7708bde057c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1012,10 +1012,8 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 						   filter->family,
 						   &filter->zone,
 						   filter->reply_flags);
-		if (err < 0) {
-			err = -EINVAL;
+		if (err < 0)
 			goto err_filter;
-		}
 	}
 
 	return filter;
-- 
2.30.2

