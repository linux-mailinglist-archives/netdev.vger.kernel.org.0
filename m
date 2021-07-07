Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886333BEBFE
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhGGQVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:21:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55186 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhGGQVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:21:39 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8C8206244F;
        Wed,  7 Jul 2021 18:18:44 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 10/11] netfilter: nft_last: incorrect arithmetics when restoring last used
Date:   Wed,  7 Jul 2021 18:18:43 +0200
Message-Id: <20210707161844.20827-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210707161844.20827-1-pablo@netfilter.org>
References: <20210707161844.20827-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subtract the jiffies that have passed by to current jiffies to fix last
used restoration.

Fixes: 836382dc2471 ("netfilter: nf_tables: add last expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_last.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index bbb352b64c73..8088b99f2ee3 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -37,7 +37,7 @@ static int nft_last_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		if (err < 0)
 			return err;
 
-		priv->last_jiffies = jiffies + (unsigned long)last_jiffies;
+		priv->last_jiffies = jiffies - (unsigned long)last_jiffies;
 	}
 
 	return 0;
-- 
2.20.1

