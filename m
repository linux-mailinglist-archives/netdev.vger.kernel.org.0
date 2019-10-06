Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98083CCF1B
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 09:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfJFHJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 03:09:00 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54624 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbfJFHJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Oct 2019 03:09:00 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 825AFBAE63C8E18FDC26;
        Sun,  6 Oct 2019 15:08:57 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Sun, 6 Oct 2019
 15:08:51 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <ka-cheong.poon@oracle.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net/rds: Add missing include file
Date:   Sun, 6 Oct 2019 15:08:32 +0800
Message-ID: <20191006070832.55532-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build error:

net/rds/ib_cm.c: In function rds_dma_hdrs_alloc:
net/rds/ib_cm.c:475:13: error: implicit declaration of function dma_pool_zalloc; did you mean mempool_alloc? [-Werror=implicit-function-declaration]
   hdrs[i] = dma_pool_zalloc(pool, GFP_KERNEL, &hdr_daddrs[i]);
             ^~~~~~~~~~~~~~~
             mempool_alloc

net/rds/ib.c: In function rds_ib_dev_free:
net/rds/ib.c:111:3: error: implicit declaration of function dma_pool_destroy; did you mean mempool_destroy? [-Werror=implicit-function-declaration]
   dma_pool_destroy(rds_ibdev->rid_hdrs_pool);
   ^~~~~~~~~~~~~~~~
   mempool_destroy

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 9b17f5884be4 ("net/rds: Use DMA memory pool allocation for rds_header")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/rds/ib.c    | 1 +
 net/rds/ib_cm.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 23a2ae53f231..62d4ebeb08c1 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  *
  */
+#include <linux/dmapool.h>
 #include <linux/kernel.h>
 #include <linux/in.h>
 #include <linux/if.h>
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index d08251f4a00c..6b345c858dba 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  *
  */
+#include <linux/dmapool.h>
 #include <linux/kernel.h>
 #include <linux/in.h>
 #include <linux/slab.h>
-- 
2.20.1


