Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C4E49EF10
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344177AbiA0Xww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:52:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:43012 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344042AbiA0Xwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:52:46 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6688860881;
        Fri, 28 Jan 2022 00:49:40 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 8/8] netfilter: nf_tables: remove assignment with no effect in chain blob builder
Date:   Fri, 28 Jan 2022 00:52:35 +0100
Message-Id: <20220127235235.656931-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127235235.656931-1-pablo@netfilter.org>
References: <20220127235235.656931-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cppcheck possible warnings:

>> net/netfilter/nf_tables_api.c:2014:2: warning: Assignment of function parameter has no effect outside the function. Did you forget dereferencing it? [uselessAssignmentPtrArg]
    ptr += offsetof(struct nft_rule_dp, data);
    ^

Reported-by: kernel test robot <yujie.liu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cf454f8ca2b0..5fa16990da95 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2011,7 +2011,6 @@ static void nft_last_rule(struct nft_rule_blob *blob, const void *ptr)
 
 	prule = (struct nft_rule_dp *)ptr;
 	prule->is_last = 1;
-	ptr += offsetof(struct nft_rule_dp, data);
 	/* blob size does not include the trailer rule */
 }
 
-- 
2.30.2

