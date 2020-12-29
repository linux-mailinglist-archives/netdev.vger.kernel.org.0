Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79CF2E7108
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgL2Nt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:49:29 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10093 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgL2Nt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:49:29 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D4whw72vlzMBwd;
        Tue, 29 Dec 2020 21:47:44 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:48:39 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <khalasa@piap.pl>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: wan: Use DEFINE_SPINLOCK() for spinlock
Date:   Tue, 29 Dec 2020 21:49:18 +0800
Message-ID: <20201229134918.23193-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wan/ixp4xx_hss.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index 7c5cf77e9ef1..ecea09fd21cb 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -323,7 +323,7 @@ struct desc {
 
 static int ports_open;
 static struct dma_pool *dma_pool;
-static spinlock_t npe_lock;
+static DEFINE_SPINLOCK(npe_lock);
 
 static const struct {
 	int tx, txdone, rx, rxfree;
@@ -1402,8 +1402,6 @@ static int __init hss_init_module(void)
 	    (IXP4XX_FEATURE_HDLC | IXP4XX_FEATURE_HSS))
 		return -ENODEV;
 
-	spin_lock_init(&npe_lock);
-
 	return platform_driver_register(&ixp4xx_hss_driver);
 }
 
-- 
2.22.0

