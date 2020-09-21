Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B17272593
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgIUNbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:31:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34198 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726846AbgIUNbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:31:25 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E5A4869D4C4C827F7CB0;
        Mon, 21 Sep 2020 21:31:21 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:31:13 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: realtek: Remove set but not used variable
Date:   Mon, 21 Sep 2020 21:32:09 +0800
Message-ID: <20200921133209.32610-1-zhengyongjun3@huawei.com>
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

drivers/net/ethernet/realtek/8139cp.c: In function cp_tx_timeout:
drivers/net/ethernet/realtek/8139cp.c:1242:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]

`rc` is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/realtek/8139cp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index e291e6ac40cb..4e44313b7651 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1239,7 +1239,7 @@ static void cp_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct cp_private *cp = netdev_priv(dev);
 	unsigned long flags;
-	int rc, i;
+	int i;
 
 	netdev_warn(dev, "Transmit timeout, status %2x %4x %4x %4x\n",
 		    cpr8(Cmd), cpr16(CpCmd),
@@ -1260,7 +1260,7 @@ static void cp_tx_timeout(struct net_device *dev, unsigned int txqueue)
 
 	cp_stop_hw(cp);
 	cp_clean_rings(cp);
-	rc = cp_init_rings(cp);
+	cp_init_rings(cp);
 	cp_start_hw(cp);
 	__cp_set_rx_mode(dev);
 	cpw16_f(IntrMask, cp_norx_intr_mask);
-- 
2.17.1

