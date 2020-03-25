Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93ADA191E87
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 02:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCYBSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 21:18:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49570 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727102AbgCYBSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 21:18:48 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DE254EDA07573CE7D228;
        Wed, 25 Mar 2020 09:18:36 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Wed, 25 Mar 2020
 09:18:29 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <vishal@chelsio.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rahul.lakkireddy@chelsio.com>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 net-next] cxgb4: remove set but not used variable 'tab'
Date:   Wed, 25 Mar 2020 09:17:50 +0800
Message-ID: <20200325011750.53008-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20200324062614.29644-1-yuehaibing@huawei.com>
References: <20200324062614.29644-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c: In function cxgb4_get_free_ftid:
drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c:547:23:
 warning: variable tab set but not used [-Wunused-but-set-variable]

commit 8d174351f285 ("cxgb4: rework TC filter rule insertion across regions")
involved this, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: keep christmas tree ordering
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index e8852dfcc1f1..4490042b5a95 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -544,8 +544,8 @@ int cxgb4_get_free_ftid(struct net_device *dev, u8 family, bool hash_en,
 {
 	struct adapter *adap = netdev2adap(dev);
 	struct tid_info *t = &adap->tids;
-	struct filter_entry *tab, *f;
 	u32 bmap_ftid, max_ftid;
+	struct filter_entry *f;
 	unsigned long *bmap;
 	bool found = false;
 	u8 i, cnt, n;
@@ -617,7 +617,6 @@ int cxgb4_get_free_ftid(struct net_device *dev, u8 family, bool hash_en,
 
 			bmap = t->hpftid_bmap;
 			bmap_ftid = ftid;
-			tab = t->hpftid_tab;
 		} else if (hash_en) {
 			/* Ensure priority is >= last rule in HPFILTER
 			 * region.
@@ -657,7 +656,6 @@ int cxgb4_get_free_ftid(struct net_device *dev, u8 family, bool hash_en,
 
 			bmap = t->ftid_bmap;
 			bmap_ftid = ftid - t->nhpftids;
-			tab = t->ftid_tab;
 		}
 
 		cnt = 0;
-- 
2.17.1


