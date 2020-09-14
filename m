Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DED8268C24
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 15:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgINNXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 09:23:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12255 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726051AbgINNUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 09:20:23 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 86977E70763307ED38C6;
        Mon, 14 Sep 2020 21:20:17 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 14 Sep 2020 21:20:15 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: pxa168_eth: remove unused variable 'retval' int pxa168_eth_change_mtu()
Date:   Mon, 14 Sep 2020 21:19:12 +0800
Message-ID: <1600089552-22368-1-git-send-email-zhangchangzhong@huawei.com>
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

drivers/net/ethernet/marvell/pxa168_eth.c:1190:6: warning:
 variable 'retval' set but not used [-Wunused-but-set-variable]
 1190 |  int retval;
      |      ^~~~~~

Function pxa168_eth_change_mtu() always return zero, so variable 'retval'
is redundant, just remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index faac94b..d1e4d42 100644
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
2.9.5

