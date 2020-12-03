Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DAA2CD8B1
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbgLCONL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:13:11 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8998 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgLCONL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:13:11 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CmySv4CLQzhm12;
        Thu,  3 Dec 2020 22:11:59 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Dec 2020
 22:12:25 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <rmk+kernel@armlinux.org.uk>, <mcroce@microsoft.com>,
        <sven.auhagen@voleatech.de>, <andrew@lunn.ch>, <atenart@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: mvpp2: Fix error return code in mvpp2_open()
Date:   Thu, 3 Dec 2020 22:18:06 +0800
Message-ID: <20201203141806.37966-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return negative error code -ENOENT from invalid configuration
error handling case instead of 0, as done elsewhere in this function.

Fixes: 4bb043262878 ("net: mvpp2: phylink support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index f6616c8933ca..cea886c5bcb5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4426,6 +4426,7 @@ static int mvpp2_open(struct net_device *dev)
 	if (!valid) {
 		netdev_err(port->dev,
 			   "invalid configuration: no dt or link IRQ");
+		err = -ENOENT;
 		goto err_free_irq;
 	}
 
-- 
2.17.1

