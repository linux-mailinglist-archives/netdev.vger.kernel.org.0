Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031592709EC
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 04:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgISCFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 22:05:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13705 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgISCFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 22:05:04 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 160CA2C7497F4FAB015E;
        Sat, 19 Sep 2020 10:05:03 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:04:56 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: marvell: Remove set but not used variable
Date:   Sat, 19 Sep 2020 10:05:50 +0800
Message-ID: <20200919020550.23227-1-zhengyongjun3@huawei.com>
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

drivers/net/ethernet/marvell/pxa168_eth.c: In function pxa168_eth_change_mtu:
drivers/net/ethernet/marvell/pxa168_eth.c:1190:6: warning: variable ‘retval’ set but not used [-Wunused-but-set-variable]

`retval` is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index eb8cf60ecf12..0af31ec5dc7d 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1187,11 +1187,10 @@ static int pxa168_eth_stop(struct net_device *dev)
 
 static int pxa168_eth_change_mtu(struct net_device *dev, int mtu)
 {
-	int retval;
 	struct pxa168_eth_private *pep = netdev_priv(dev);
 
 	dev->mtu = mtu;
-	retval = set_port_config_ext(pep);
+	set_port_config_ext(pep);
 
 	if (!netif_running(dev))
 		return 0;
-- 
2.17.1

