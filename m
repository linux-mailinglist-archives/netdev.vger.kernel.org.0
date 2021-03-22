Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940CA343D45
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 10:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCVJx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 05:53:56 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:56885 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229647AbhCVJxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 05:53:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0USw2o5d_1616406796;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0USw2o5d_1616406796)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Mar 2021 17:53:21 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     rajur@chelsio.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] cxgb4: Remove redundant NULL check
Date:   Mon, 22 Mar 2021 17:53:14 +0800
Message-Id: <1616406794-105194-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c:3540:2-8: WARNING: NULL
check before some freeing functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 6c85a10..d2ba40c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -3536,8 +3536,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 	}
 
 out_free:
-	if (data)
-		kvfree(data);
+	kvfree(data);
 
 #undef QDESC_GET_FLQ
 #undef QDESC_GET_RXQ
-- 
1.8.3.1

