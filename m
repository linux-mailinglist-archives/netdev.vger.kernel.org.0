Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616EF304AEB
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbhAZEzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:55:02 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:54685 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727211AbhAYJsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:48:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UMpfQ7-_1611568047;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMpfQ7-_1611568047)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 17:47:47 +0800
From:   Yang Li <abaci-bugfix@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, rajur@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH 1/4] cxgb4: remove redundant NULL check
Date:   Mon, 25 Jan 2021 17:47:22 +0800
Message-Id: <1611568045-121839-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix below warnings reported by coccicheck:
./drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c:327:3-9: WARNING: NULL
check before some freeing functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
---
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
index ce28820..12fcf84 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
@@ -323,8 +323,7 @@ void t4_cleanup_clip_tbl(struct adapter *adap)
 	struct clip_tbl *ctbl = adap->clipt;
 
 	if (ctbl) {
-		if (ctbl->cl_list)
-			kvfree(ctbl->cl_list);
+		kvfree(ctbl->cl_list);
 		kvfree(ctbl);
 	}
 }
-- 
1.8.3.1

