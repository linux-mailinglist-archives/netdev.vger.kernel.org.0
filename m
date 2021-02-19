Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CC131F6C8
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 10:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhBSJtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:49:47 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:60753 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230172AbhBSJtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 04:49:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UOxr8rh_1613728136;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UOxr8rh_1613728136)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Feb 2021 17:48:56 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] xfrm: Fix incorrect types in assignment
Date:   Fri, 19 Feb 2021 17:48:54 +0800
Message-Id: <1613728134-66887-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warnings:
net/xfrm/xfrm_policy.c:1303:22: warning: incorrect type in assignment
(different address spaces)

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b74f28c..5c67407 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1225,7 +1225,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 	struct xfrm_policy *pol;
 	struct xfrm_policy *policy;
 	struct hlist_head *chain;
-	struct hlist_head *odst;
+	struct hlist_head __rcu *odst;
 	struct hlist_node *newpos;
 	int i;
 	int dir;
-- 
1.8.3.1

