Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A7F41C910
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345579AbhI2QBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13838 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345487AbhI2P7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWX2W9Gz8ysh;
        Wed, 29 Sep 2021 23:53:28 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [RFCv2 net-next 077/167] net: can: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:04 +0800
Message-ID: <20210929155334.12454-78-shenjian15@huawei.com>
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
 drivers/net/can/dev/dev.c | 3 ++-
 drivers/net/can/slcan.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index e3d840b81357..97c61943125e 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -233,7 +233,8 @@ void can_setup(struct net_device *dev)
 
 	/* New-style flags. */
 	dev->flags = IFF_NOARP;
-	dev->features = NETIF_F_HW_CSUM;
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &dev->features);
 }
 
 /* Allocate and setup space for the CAN network device */
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index d42ec7d1bc14..8af2cf00a021 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -450,7 +450,8 @@ static void slc_setup(struct net_device *dev)
 
 	/* New-style flags. */
 	dev->flags		= IFF_NOARP;
-	dev->features           = NETIF_F_HW_CSUM;
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &dev->features);
 }
 
 /******************************************
-- 
2.33.0

