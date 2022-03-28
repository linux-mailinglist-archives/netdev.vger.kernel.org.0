Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231E94E8FFA
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 10:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239256AbiC1IWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 04:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbiC1IWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 04:22:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EF0E53704;
        Mon, 28 Mar 2022 01:20:27 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 12A4D63016;
        Mon, 28 Mar 2022 10:17:19 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/3] netfilter: egress: Report interface as outgoing
Date:   Mon, 28 Mar 2022 10:20:20 +0200
Message-Id: <20220328082022.636423-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220328082022.636423-1-pablo@netfilter.org>
References: <20220328082022.636423-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Otherwise packets in egress chains seem like they are being received by
the interface, not sent out via it.

Fixes: 42df6e1d221dd ("netfilter: Introduce egress hook")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_netdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index e6487a691136..8676316547cc 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -99,7 +99,7 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
 		return skb;
 
 	nf_hook_state_init(&state, NF_NETDEV_EGRESS,
-			   NFPROTO_NETDEV, dev, NULL, NULL,
+			   NFPROTO_NETDEV, NULL, dev, NULL,
 			   dev_net(dev), NULL);
 
 	/* nf assumes rcu_read_lock, not just read_lock_bh */
-- 
2.30.2

