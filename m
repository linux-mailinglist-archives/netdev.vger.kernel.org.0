Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC60E2D2C4C
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 14:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgLHNzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 08:55:03 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8726 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgLHNzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 08:55:03 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cr1qP1Vjzzkn52;
        Tue,  8 Dec 2020 21:53:37 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 21:54:11 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] drivers: net: qlcnic: simplify the return expression of qlcnic_sriov_vf_shutdown()
Date:   Tue, 8 Dec 2020 21:54:37 +0800
Message-ID: <20201208135437.11764-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 30e52f969759..dd03be3fc82a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -2112,7 +2112,6 @@ static int qlcnic_sriov_vf_shutdown(struct pci_dev *pdev)
 {
 	struct qlcnic_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
-	int retval;
 
 	netif_device_detach(netdev);
 	qlcnic_cancel_idc_work(adapter);
@@ -2125,11 +2124,7 @@ static int qlcnic_sriov_vf_shutdown(struct pci_dev *pdev)
 	qlcnic_83xx_disable_mbx_intr(adapter);
 	cancel_delayed_work_sync(&adapter->idc_aen_work);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-	return 0;
+	return pci_save_state(pdev);
 }
 
 static int qlcnic_sriov_vf_resume(struct qlcnic_adapter *adapter)
-- 
2.22.0

