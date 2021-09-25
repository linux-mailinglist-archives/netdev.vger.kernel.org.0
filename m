Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C093418203
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 14:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245085AbhIYMsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 08:48:13 -0400
Received: from mx22.baidu.com ([220.181.50.185]:40176 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244895AbhIYMsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 08:48:12 -0400
Received: from BC-Mail-Ex06.internal.baidu.com (unknown [172.31.51.46])
        by Forcepoint Email with ESMTPS id 63273A049C924F700576;
        Sat, 25 Sep 2021 20:46:35 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex06.internal.baidu.com (172.31.51.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 25 Sep 2021 20:46:35 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 20:46:34 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: cisco: Fix a function name in comments
Date:   Sat, 25 Sep 2021 20:46:28 +0800
Message-ID: <20210925124629.250-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex01.internal.baidu.com (10.127.64.11) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_alloc_coherent() instead of pci_alloc_consistent(),
because only dma_alloc_coherent() is called here.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/cisco/enic/enic_ethtool.c | 4 ++--
 drivers/net/ethernet/cisco/enic/enic_main.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index 12ffc14fbecd..6ded4d9fa32a 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -139,7 +139,7 @@ static void enic_get_drvinfo(struct net_device *netdev,
 	int err;
 
 	err = enic_dev_fw_info(enic, &fw_info);
-	/* return only when pci_zalloc_consistent fails in vnic_dev_fw_info
+	/* return only when dma_alloc_coherent fails in vnic_dev_fw_info
 	 * For other failures, like devcmd failure, we return previously
 	 * recorded info.
 	 */
@@ -270,7 +270,7 @@ static void enic_get_ethtool_stats(struct net_device *netdev,
 	int err;
 
 	err = enic_dev_stats_dump(enic, &vstats);
-	/* return only when pci_zalloc_consistent fails in vnic_dev_stats_dump
+	/* return only when dma_alloc_coherent fails in vnic_dev_stats_dump
 	 * For other failures, like devcmd failure, we return previously
 	 * recorded stats.
 	 */
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index d0a8f7106958..13dbdd5d07b4 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -882,7 +882,7 @@ static void enic_get_stats(struct net_device *netdev,
 	int err;
 
 	err = enic_dev_stats_dump(enic, &stats);
-	/* return only when pci_zalloc_consistent fails in vnic_dev_stats_dump
+	/* return only when dma_alloc_coherent fails in vnic_dev_stats_dump
 	 * For other failures, like devcmd failure, we return previously
 	 * recorded stats.
 	 */
-- 
2.25.1

