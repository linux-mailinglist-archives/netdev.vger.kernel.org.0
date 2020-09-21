Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD92725AA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgIUNfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:35:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13812 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726471AbgIUNfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:35:01 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A144145167C2A9CC913C;
        Mon, 21 Sep 2020 21:34:58 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:34:50 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: qlogic: Remove set but not used variable
Date:   Mon, 21 Sep 2020 21:35:46 +0800
Message-ID: <20200921133546.32730-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c: In function qlcnic_83xx_cam_unlock:
drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:661:6: warning: variable ‘val’ set but not used [-Wunused-but-set-variable]

`val` is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index 29b9c728a65e..fc490881cd03 100644
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
2.17.1

