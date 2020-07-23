Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CE022AD20
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgGWLCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:02:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8366 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726867AbgGWLCh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:02:37 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 247DF9CBDFD54E8E0C4F;
        Thu, 23 Jul 2020 19:02:33 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 23 Jul 2020
 19:02:15 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <vishal@chelsio.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] cxgb4: use eth_zero_addr() to clear mac address
Date:   Thu, 23 Jul 2020 19:05:00 +0800
Message-ID: <1595502300-9470-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Use eth_zero_addr() to clear mac address insetad of memset().

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/smt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.c b/drivers/net/ethernet/chelsio/cxgb4/smt.c
index cbe72ed27b1e..e617e4aabbcc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.c
@@ -55,7 +55,7 @@ struct smt_data *t4_init_smt(void)
 	for (i = 0; i < s->smt_size; ++i) {
 		s->smtab[i].idx = i;
 		s->smtab[i].state = SMT_STATE_UNUSED;
-		memset(&s->smtab[i].src_mac, 0, ETH_ALEN);
+		eth_zero_addr(s->smtab[i].src_mac);
 		spin_lock_init(&s->smtab[i].lock);
 		s->smtab[i].refcnt = 0;
 	}
-- 
2.19.1

