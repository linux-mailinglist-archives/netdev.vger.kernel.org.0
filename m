Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CDC268D2D
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 16:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgINORP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 10:17:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41968 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726565AbgINN03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 09:26:29 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 62413D9BC8D7DD417C73;
        Mon, 14 Sep 2020 21:25:42 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 14 Sep 2020 21:25:41 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <shshaikh@marvell.com>, <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: qlcnic: remove unused variable 'val' in qlcnic_83xx_cam_unlock()
Date:   Mon, 14 Sep 2020 21:24:39 +0800
Message-ID: <1600089879-22944-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:661:6: warning:
 variable 'val' set but not used [-Wunused-but-set-variable]
  661 |  u32 val;
      |      ^~~

After commit 7f9664525f9c ("qlcnic: 83xx memory map and HW access
routines"), variable 'val' is never used in qlcnic_83xx_cam_unlock(), so
removing it to avoid build warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index 29b9c72..fc49088 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -658,11 +658,10 @@ int qlcnic_83xx_cam_lock(struct qlcnic_adapter *adapter)
 void qlcnic_83xx_cam_unlock(struct qlcnic_adapter *adapter)
 {
 	void __iomem *addr;
-	u32 val;
 	struct qlcnic_hardware_context *ahw = adapter->ahw;
 
 	addr = ahw->pci_base0 + QLC_83XX_SEM_UNLOCK_FUNC(ahw->pci_func);
-	val = readl(addr);
+	readl(addr);
 }
 
 void qlcnic_83xx_read_crb(struct qlcnic_adapter *adapter, char *buf,
-- 
2.9.5

