Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D4E6400D3
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiLBHEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiLBHEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:04:39 -0500
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DE7DBEE36;
        Thu,  1 Dec 2022 23:04:37 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 439C01E80D27;
        Fri,  2 Dec 2022 15:00:33 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Si2qrSyBFN9Z; Fri,  2 Dec 2022 15:00:30 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id CDC741E80CCF;
        Fri,  2 Dec 2022 15:00:29 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        coreteam@netfilter.org, Yu Zhe <yuzhe@nfschina.com>,
        Li Qiong <liqiong@nfschina.com>
Subject: [PATCH] netfilter: initialize 'ret' variable
Date:   Fri,  2 Dec 2022 15:03:31 +0800
Message-Id: <20221202070331.10865-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'ret' should need to be initialized to 0, in case
return a uninitialized value.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index b350fe9d00b0..225ff865d609 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -351,7 +351,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	struct rtable *rt;
 	struct iphdr *iph;
 	__be32 nexthop;
-	int ret;
+	int ret = 0;
 
 	if (skb->protocol != htons(ETH_P_IP) &&
 	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &offset))
@@ -613,7 +613,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	u32 hdrsize, offset = 0;
 	struct ipv6hdr *ip6h;
 	struct rt6_info *rt;
-	int ret;
+	int ret = 0;
 
 	if (skb->protocol != htons(ETH_P_IPV6) &&
 	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IPV6), &offset))
-- 
2.11.0

