Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827D739D80A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFGI7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:59:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3083 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhFGI7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:59:37 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fz6Zw0B70zWsTP;
        Mon,  7 Jun 2021 16:52:56 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 16:57:44 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] xfrm: use BUG_ON instead of if condition followed by BUG
Date:   Mon, 7 Jun 2021 17:11:21 +0800
Message-ID: <20210607091121.2766815-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use BUG_ON instead of if condition followed by BUG.

This issue was detected with the help of Coccinelle.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/xfrm/xfrm_policy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index ce500f847b99..532314578151 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -421,8 +421,7 @@ void xfrm_policy_destroy(struct xfrm_policy *policy)
 {
 	BUG_ON(!policy->walk.dead);
 
-	if (del_timer(&policy->timer) || del_timer(&policy->polq.hold_timer))
-		BUG();
+	BUG_ON(del_timer(&policy->timer) || del_timer(&policy->polq.hold_timer));
 
 	call_rcu(&policy->rcu, xfrm_policy_destroy_rcu);
 }
-- 
2.25.1

