Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608297C07D
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 13:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfGaLwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 07:52:12 -0400
Received: from correo.us.es ([193.147.175.20]:59326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728263AbfGaLwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 07:52:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EFCA080762
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFAAF1150DF
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:52:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D4F4ADA708; Wed, 31 Jul 2019 13:52:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC98A1150CB;
        Wed, 31 Jul 2019 13:52:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 31 Jul 2019 13:52:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5658241FF231;
        Wed, 31 Jul 2019 13:52:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/8] netfilter: nft_meta_bridge: Eliminate 'out' label
Date:   Wed, 31 Jul 2019 13:51:52 +0200
Message-Id: <20190731115157.27020-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190731115157.27020-1-pablo@netfilter.org>
References: <20190731115157.27020-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

The label is used just once and the code it points at is not reused, no
point in keeping it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_meta_bridge.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index a98dec2cf0cf..1804e867f715 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -57,13 +57,11 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		return;
 	}
 	default:
-		goto out;
+		return nft_meta_get_eval(expr, regs, pkt);
 	}
 
 	strncpy((char *)dest, br_dev ? br_dev->name : "", IFNAMSIZ);
 	return;
-out:
-	return nft_meta_get_eval(expr, regs, pkt);
 err:
 	regs->verdict.code = NFT_BREAK;
 }
-- 
2.11.0

