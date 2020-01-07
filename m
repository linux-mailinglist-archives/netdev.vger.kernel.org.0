Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091EC132897
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 15:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgAGOP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 09:15:26 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:57200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727658AbgAGOPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 09:15:25 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BB622E7F510142F69EB6;
        Tue,  7 Jan 2020 22:15:22 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Tue, 7 Jan 2020
 22:15:15 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <claudiu.manoil@nxp.com>, <davem@davemloft.net>,
        <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] enetc: Fix inconsistent IS_ERR and PTR_ERR
Date:   Tue, 7 Jan 2020 22:14:54 +0800
Message-ID: <20200107141454.44420-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The proper pointer to be passed as argument is hw
Detected using Coccinelle.

Fixes: 6517798dd343 ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
index 87c0e96..ebc635f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
@@ -27,7 +27,7 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
 	}
 
 	hw = enetc_hw_alloc(dev, port_regs);
-	if (IS_ERR(enetc_hw_alloc)) {
+	if (IS_ERR(hw)) {
 		err = PTR_ERR(hw);
 		goto err_hw_alloc;
 	}
-- 
2.7.4


