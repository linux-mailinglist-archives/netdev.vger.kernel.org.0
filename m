Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED4234A74D
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhCZMak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:30:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15321 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhCZMaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 08:30:25 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F6Lq80fCBz9vHR;
        Fri, 26 Mar 2021 20:28:20 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Fri, 26 Mar 2021
 20:30:14 +0800
From:   'Liu Jian <liujian56@huawei.com>
To:     <liujian56@huawei.com>, Kevin Curtis <kevin.curtis@farsite.co.uk>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] farsync: use DEFINE_SPINLOCK() for spinlock
Date:   Fri, 26 Mar 2021 20:31:38 +0800
Message-ID: <20210326123138.159616-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 drivers/net/wan/farsync.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 686a25d3b512..5de71e44fc5a 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -573,7 +573,7 @@ static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q);
 static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q);
 
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];
-static spinlock_t fst_work_q_lock;
+static DEFINE_SPINLOCK(fst_work_q_lock);
 static u64 fst_work_txq;
 static u64 fst_work_intq;
 
@@ -2648,7 +2648,6 @@ fst_init(void)
 
 	for (i = 0; i < FST_MAX_CARDS; i++)
 		fst_card_array[i] = NULL;
-	spin_lock_init(&fst_work_q_lock);
 	return pci_register_driver(&fst_driver);
 }
 

