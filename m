Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD22863FEC6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiLBD0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiLBD0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:26:12 -0500
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29AE4D78FE;
        Thu,  1 Dec 2022 19:26:11 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 8B9FB1E80D50;
        Fri,  2 Dec 2022 11:22:06 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4sj_UncHBgSW; Fri,  2 Dec 2022 11:22:03 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 0411A1E80D27;
        Fri,  2 Dec 2022 11:22:02 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>, Li Qiong <liqiong@nfschina.com>
Subject: [PATCH] ipvs: initialize 'ret' variable in do_ip_vs_set_ctl()
Date:   Fri,  2 Dec 2022 11:25:11 +0800
Message-Id: <20221202032511.1435-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'ret' should need to be initialized to 0, in case
return a uninitialized value because no default process
for "switch (cmd)".

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 988222fff9f0..4b20db86077c 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2456,7 +2456,7 @@ static int
 do_ip_vs_set_ctl(struct sock *sk, int cmd, sockptr_t ptr, unsigned int len)
 {
 	struct net *net = sock_net(sk);
-	int ret;
+	int ret = 0;
 	unsigned char arg[MAX_SET_ARGLEN];
 	struct ip_vs_service_user *usvc_compat;
 	struct ip_vs_service_user_kern usvc;
-- 
2.11.0

