Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5A82724EA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgIUNKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:10:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13762 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727363AbgIUNKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:10:33 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9147AA84E4BC26210675;
        Mon, 21 Sep 2020 21:10:29 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:10:22 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] net: qlcnic: simplify the return expression of qlcnic_83xx_shutdown
Date:   Mon, 21 Sep 2020 21:10:46 +0800
Message-ID: <20200921131046.92480-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index 81a688dd0..d8882d0b6 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3811,7 +3811,6 @@ static int qlcnic_83xx_shutdown(struct pci_dev *pdev)
 {
 	struct qlcnic_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
-	int retval;
 
 	netif_device_detach(netdev);
 	qlcnic_cancel_idc_work(adapter);
@@ -3822,11 +3821,7 @@ static int qlcnic_83xx_shutdown(struct pci_dev *pdev)
 	qlcnic_83xx_disable_mbx_intr(adapter);
 	cancel_delayed_work_sync(&adapter->idc_aen_work);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-	return 0;
+	return pci_save_state(pdev);
 }
 
 static int qlcnic_83xx_resume(struct qlcnic_adapter *adapter)
-- 
2.23.0

