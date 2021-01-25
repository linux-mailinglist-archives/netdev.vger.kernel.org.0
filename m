Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E386F304AE9
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbhAZEzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:55:00 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:60303 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727111AbhAYJsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:48:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UMpfQ7-_1611568047;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMpfQ7-_1611568047)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 17:47:54 +0800
From:   Yang Li <abaci-bugfix@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, rajur@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH 4/4] cxgb4: remove redundant NULL check
Date:   Mon, 25 Jan 2021 17:47:25 +0800
Message-Id: <1611568045-121839-4-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611568045-121839-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611568045-121839-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix below warnings reported by coccicheck:
 ./drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c:533:2-8: WARNING:
NULL check before some freeing functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
index dede025..97a811f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
@@ -525,12 +525,10 @@ struct cxgb4_tc_u32_table *cxgb4_init_tc_u32(struct adapter *adap)
 	for (i = 0; i < t->size; i++) {
 		struct cxgb4_link *link = &t->table[i];
 
-		if (link->tid_map)
-			kvfree(link->tid_map);
+		kvfree(link->tid_map);
 	}
 
-	if (t)
-		kvfree(t);
+	kvfree(t);
 
 	return NULL;
 }
-- 
1.8.3.1

