Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F00263147
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbgIIQF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:05:26 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46798 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730912AbgIIQFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:05:18 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EC685CB9941A0048A30F;
        Wed,  9 Sep 2020 22:07:38 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 9 Sep 2020 22:07:34 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: pxa168_eth: remove redundant null check before clk_disable_unprepare()
Date:   Wed, 9 Sep 2020 22:06:37 +0800
Message-ID: <1599660397-25077-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because clk_prepare_enable() and clk_disable_unprepare() already checked
NULL clock parameter, so the additional checks are unnecessary, just
remove them.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index eb8cf60..faac94b 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1541,10 +1541,8 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 	}
 	if (dev->phydev)
 		phy_disconnect(dev->phydev);
-	if (pep->clk) {
-		clk_disable_unprepare(pep->clk);
-	}
 
+	clk_disable_unprepare(pep->clk);
 	mdiobus_unregister(pep->smi_bus);
 	mdiobus_free(pep->smi_bus);
 	unregister_netdev(dev);
-- 
2.9.5

