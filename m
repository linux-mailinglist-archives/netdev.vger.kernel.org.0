Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D24315D47
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbhBJC3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:29:12 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12503 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235395AbhBJC1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 21:27:33 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Db3Wm1vcPzjLhL;
        Wed, 10 Feb 2021 10:25:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 10:26:43 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH] cxgb4: fix unnecessary NULL check warnings
Date:   Wed, 10 Feb 2021 10:26:03 +0800
Message-ID: <1612923963-18222-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove NULL checks before vfree() to fix these warnings:
drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c:3558:2-8: WARNING: NULL
check before some freeing functions is not needed.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 75474f8..94eb8a6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -3554,8 +3554,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 	}
 
 out_free:
-	if (data)
-		kvfree(data);
+	kvfree(data);
 
 #undef QDESC_GET_FLQ
 #undef QDESC_GET_RXQ
-- 
2.7.4

