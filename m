Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFE941C934
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344851AbhI2QC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:29 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23250 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbhI2P7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:51 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbt1wN0z8tW2;
        Wed, 29 Sep 2021 23:57:14 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:06 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:05 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 072/167] net: rionet: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:59 +0800
Message-ID: <20210929155334.12454-73-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/rionet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 2056d6ad04b5..eac3e882cf5a 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -513,7 +513,8 @@ static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
 	/* MTU range: 68 - 4082 */
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = RIONET_MAX_MTU;
-	ndev->features = NETIF_F_LLTX;
+	netdev_feature_zero(&ndev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &ndev->features);
 	SET_NETDEV_DEV(ndev, &mport->dev);
 	ndev->ethtool_ops = &rionet_ethtool_ops;
 
-- 
2.33.0

