Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C282E7128
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgL2NxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:53:14 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9701 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgL2NxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:53:13 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D4wmy03BkzkwZk;
        Tue, 29 Dec 2020 21:51:14 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:52:08 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <michael.chan@broadcom.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] bnxt_en: Use kzalloc for allocating only one thing
Date:   Tue, 29 Dec 2020 21:52:46 +0800
Message-ID: <20201229135246.23978-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0af0af2b70fe..0ed6fc90ebea 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8600,7 +8600,7 @@ static int bnxt_init_msix(struct bnxt *bp)
 
 static int bnxt_init_inta(struct bnxt *bp)
 {
-	bp->irq_tbl = kcalloc(1, sizeof(struct bnxt_irq), GFP_KERNEL);
+	bp->irq_tbl = kzalloc(sizeof(struct bnxt_irq), GFP_KERNEL);
 	if (!bp->irq_tbl)
 		return -ENOMEM;
 
-- 
2.22.0

