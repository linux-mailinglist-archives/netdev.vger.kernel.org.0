Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1164657B2AE
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbiGTIR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiGTIRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:17:55 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221E1624BB
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:17:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D840E2061E;
        Wed, 20 Jul 2022 10:17:52 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OLXfWLRgS0Vj; Wed, 20 Jul 2022 10:17:52 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 91D7D205CF;
        Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 8964880004A;
        Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 10:17:51 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 10:17:50 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id DAD783182A77; Wed, 20 Jul 2022 10:17:49 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/5] xfrm: change the type of xfrm_register_km and xfrm_unregister_km
Date:   Wed, 20 Jul 2022 10:17:44 +0200
Message-ID: <20220720081746.1187382-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220720081746.1187382-1-steffen.klassert@secunet.com>
References: <20220720081746.1187382-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

Functions xfrm_register_km and xfrm_unregister_km do always return 0,
change the type of functions to void.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h    | 4 ++--
 net/key/af_key.c      | 6 +-----
 net/xfrm/xfrm_state.c | 6 ++----
 net/xfrm/xfrm_user.c  | 6 ++----
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 9287712ad977..afb5940919f8 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -583,8 +583,8 @@ struct xfrm_mgr {
 	bool			(*is_alive)(const struct km_event *c);
 };
 
-int xfrm_register_km(struct xfrm_mgr *km);
-int xfrm_unregister_km(struct xfrm_mgr *km);
+void xfrm_register_km(struct xfrm_mgr *km);
+void xfrm_unregister_km(struct xfrm_mgr *km);
 
 struct xfrm_tunnel_skb_cb {
 	union {
diff --git a/net/key/af_key.c b/net/key/af_key.c
index fb16d7c4e1b8..fda2dcc8a383 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3894,14 +3894,10 @@ static int __init ipsec_pfkey_init(void)
 	err = sock_register(&pfkey_family_ops);
 	if (err != 0)
 		goto out_unregister_pernet;
-	err = xfrm_register_km(&pfkeyv2_mgr);
-	if (err != 0)
-		goto out_sock_unregister;
+	xfrm_register_km(&pfkeyv2_mgr);
 out:
 	return err;
 
-out_sock_unregister:
-	sock_unregister(PF_KEY);
 out_unregister_pernet:
 	unregister_pernet_subsys(&pfkey_net_ops);
 out_unregister_key_proto:
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 08564e0eef20..03b180878e61 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2481,22 +2481,20 @@ EXPORT_SYMBOL(xfrm_user_policy);
 
 static DEFINE_SPINLOCK(xfrm_km_lock);
 
-int xfrm_register_km(struct xfrm_mgr *km)
+void xfrm_register_km(struct xfrm_mgr *km)
 {
 	spin_lock_bh(&xfrm_km_lock);
 	list_add_tail_rcu(&km->list, &xfrm_km_list);
 	spin_unlock_bh(&xfrm_km_lock);
-	return 0;
 }
 EXPORT_SYMBOL(xfrm_register_km);
 
-int xfrm_unregister_km(struct xfrm_mgr *km)
+void xfrm_unregister_km(struct xfrm_mgr *km)
 {
 	spin_lock_bh(&xfrm_km_lock);
 	list_del_rcu(&km->list);
 	spin_unlock_bh(&xfrm_km_lock);
 	synchronize_rcu();
-	return 0;
 }
 EXPORT_SYMBOL(xfrm_unregister_km);
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 6a58fec6a1fb..2ff017117730 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3633,10 +3633,8 @@ static int __init xfrm_user_init(void)
 	rv = register_pernet_subsys(&xfrm_user_net_ops);
 	if (rv < 0)
 		return rv;
-	rv = xfrm_register_km(&netlink_mgr);
-	if (rv < 0)
-		unregister_pernet_subsys(&xfrm_user_net_ops);
-	return rv;
+	xfrm_register_km(&netlink_mgr);
+	return 0;
 }
 
 static void __exit xfrm_user_exit(void)
-- 
2.25.1

