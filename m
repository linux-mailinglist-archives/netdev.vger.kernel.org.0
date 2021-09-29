Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8273F41C943
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346101AbhI2QDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12995 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344383AbhI2QAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:00 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbY4jX3zWWr8;
        Wed, 29 Sep 2021 23:56:57 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:16 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 141/167] net: pasemi: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:08 +0800
Message-ID: <20210929155334.12454-142-shenjian15@huawei.com>
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
 drivers/net/ethernet/pasemi/pasemi_mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index 7e096b2888b9..2af65e8a27fd 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1699,8 +1699,10 @@ pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &mac->napi, pasemi_mac_poll, 64);
 
-	dev->features = NETIF_F_IP_CSUM | NETIF_F_LLTX | NETIF_F_SG |
-			NETIF_F_HIGHDMA | NETIF_F_GSO;
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_LLTX | NETIF_F_SG |
+				NETIF_F_HIGHDMA | NETIF_F_GSO,
+				&dev->features);
 
 	mac->dma_pdev = pci_get_device(PCI_VENDOR_ID_PASEMI, 0xa007, NULL);
 	if (!mac->dma_pdev) {
-- 
2.33.0

