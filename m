Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956C04F60D3
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbiDFOLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234520AbiDFOK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:10:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF7C49FA19
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 03:05:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nc2Ww-00048g-Dt; Wed, 06 Apr 2022 12:04:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net] net: ipv6mr: fix unused variable warning with CONFIG_IPV6_PIMSM_V2=n
Date:   Wed,  6 Apr 2022 12:04:45 +0200
Message-Id: <20220406100445.23847-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/ipv6/ip6mr.c:1656:14: warning: unused variable 'do_wrmifwhole'

Move it to the CONFIG_IPV6_PIMSM_V2 scope where its used.

Fixes: 4b340a5a726d ("net: ip6mr: add support for passing full packet on wrong mif")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/ip6mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index a9775c830194..4e74bc61a3db 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1653,7 +1653,6 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 	mifi_t mifi;
 	struct net *net = sock_net(sk);
 	struct mr_table *mrt;
-	bool do_wrmifwhole;
 
 	if (sk->sk_type != SOCK_RAW ||
 	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
@@ -1761,6 +1760,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 #ifdef CONFIG_IPV6_PIMSM_V2
 	case MRT6_PIM:
 	{
+		bool do_wrmifwhole;
 		int v;
 
 		if (optlen != sizeof(v))
-- 
2.35.1

