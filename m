Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D793CE0F
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 16:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389926AbfFKOIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 10:08:16 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46058 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbfFKOIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 10:08:15 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E9B0B3591BC58F871261;
        Tue, 11 Jun 2019 22:08:12 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 11 Jun 2019
 22:08:04 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <aelior@marvell.com>,
        <GR-everest-linux-l2@marvell.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] qede: Make two functions static
Date:   Tue, 11 Jun 2019 22:07:09 +0800
Message-ID: <20190611140709.24452-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

drivers/net/ethernet/qlogic/qede/qede_main.c:963:6:
 warning: symbol 'qede_lock' was not declared. Should it be static?
drivers/net/ethernet/qlogic/qede/qede_main.c:969:6:
 warning: symbol 'qede_unlock' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 741377b..d4a2966 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -960,13 +960,13 @@ void __qede_unlock(struct qede_dev *edev)
 /* This version of the lock should be used when acquiring the RTNL lock is also
  * needed in addition to the internal qede lock.
  */
-void qede_lock(struct qede_dev *edev)
+static void qede_lock(struct qede_dev *edev)
 {
 	rtnl_lock();
 	__qede_lock(edev);
 }
 
-void qede_unlock(struct qede_dev *edev)
+static void qede_unlock(struct qede_dev *edev)
 {
 	__qede_unlock(edev);
 	rtnl_unlock();
-- 
2.7.4


