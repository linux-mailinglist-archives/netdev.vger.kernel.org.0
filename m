Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F37041C946
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346166AbhI2QDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:31 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23251 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345582AbhI2QAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:01 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbt2Jwdz8tW6;
        Wed, 29 Sep 2021 23:57:14 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:06 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:06 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 074/167] net: vsockmon: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:01 +0800
Message-ID: <20210929155334.12454-75-shenjian15@huawei.com>
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
 drivers/net/vsockmon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vsockmon.c b/drivers/net/vsockmon.c
index b1bb1b04b664..047d04115fd9 100644
--- a/drivers/net/vsockmon.c
+++ b/drivers/net/vsockmon.c
@@ -106,8 +106,10 @@ static void vsockmon_setup(struct net_device *dev)
 	dev->ethtool_ops = &vsockmon_ethtool_ops;
 	dev->needs_free_netdev = true;
 
-	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST |
-			NETIF_F_HIGHDMA | NETIF_F_LLTX;
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST |
+				NETIF_F_HIGHDMA | NETIF_F_LLTX,
+				&dev->features);
 
 	dev->flags = IFF_NOARP;
 
-- 
2.33.0

