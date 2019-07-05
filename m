Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF156021F
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfGEI1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:27:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36404 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727356AbfGEI1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:27:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 346D6201F9;
        Fri,  5 Jul 2019 10:27:08 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VKP2oP2fPPWp; Fri,  5 Jul 2019 10:27:07 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DD36520253;
        Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:27:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 326353180879;
 Fri,  5 Jul 2019 10:27:05 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/7] xfrm: remove a duplicated assignment
Date:   Fri, 5 Jul 2019 10:26:58 +0200
Message-ID: <20190705082700.31107-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705082700.31107-1-steffen.klassert@secunet.com>
References: <20190705082700.31107-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

Fixes: 30846090a746 ("xfrm: policy: add sequence count to sync with hash resize")
Cc: Florian Westphal <fw@strlen.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 7a43ae6b2a44..7eefdc9be2a7 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -581,9 +581,6 @@ static void xfrm_bydst_resize(struct net *net, int dir)
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	write_seqcount_begin(&xfrm_policy_hash_generation);
 
-	odst = rcu_dereference_protected(net->xfrm.policy_bydst[dir].table,
-				lockdep_is_held(&net->xfrm.xfrm_policy_lock));
-
 	odst = rcu_dereference_protected(net->xfrm.policy_bydst[dir].table,
 				lockdep_is_held(&net->xfrm.xfrm_policy_lock));
 
-- 
2.17.1

