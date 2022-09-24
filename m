Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BEA5E8787
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiIXCeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiIXCdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:33:25 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE07151B1B;
        Fri, 23 Sep 2022 19:33:19 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MZCdT14yNzWgnl;
        Sat, 24 Sep 2022 10:29:17 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:16 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 08/14] net: hns3: modify macro hnae3_dev_tx_push_supported
Date:   Sat, 24 Sep 2022 10:30:18 +0800
Message-ID: <20220924023024.14219-9-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220924023024.14219-1-huangguangbin2@huawei.com>
References: <20220924023024.14219-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Redefine macro hnae3_dev_tx_push_supported(hdev) to
hnae3_ae_dev_tx_push_supported(ae_dev), so it can be
used in both hclge and hns3_enet layer.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h               | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c        | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index b802de61e63b..2a6d2ff3056b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -128,8 +128,8 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_hw_csum_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, (ae_dev)->caps)
 
-#define hnae3_dev_tx_push_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, (hdev)->ae_dev->caps)
+#define hnae3_ae_dev_tx_push_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, (ae_dev)->caps)
 
 #define hnae3_dev_phy_imp_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, (hdev)->ae_dev->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 878c60d58061..fa7949fb2cb0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5229,7 +5229,7 @@ static void hns3_state_init(struct hnae3_handle *handle)
 
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 
-	if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+	if (hnae3_ae_dev_tx_push_supported(ae_dev))
 		set_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index f866b6676318..dd1a32659800 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1192,7 +1192,7 @@ static int hns3_set_tx_push(struct net_device *netdev, u32 tx_push)
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 	u32 old_state = test_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
 
-	if (!test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps) && tx_push)
+	if (!hnae3_ae_dev_tx_push_supported(ae_dev) && tx_push)
 		return -EOPNOTSUPP;
 
 	if (tx_push == old_state)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 5fa5ae7c32a6..a93df064da46 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1709,7 +1709,7 @@ static int hclge_alloc_tqps(struct hclge_dev *hdev)
 		 * the queue can execute push mode or doorbell mode on
 		 * device memory.
 		 */
-		if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+		if (hnae3_ae_dev_tx_push_supported(ae_dev))
 			tqp->q.mem_base = hdev->hw.hw.mem_base +
 					  HCLGE_TQP_MEM_OFFSET(hdev, i);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 34ac33783e97..191daa5cc537 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -353,7 +353,7 @@ static int hclgevf_alloc_tqps(struct hclgevf_dev *hdev)
 		 * the queue can execute push mode or doorbell mode on
 		 * device memory.
 		 */
-		if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+		if (hnae3_ae_dev_tx_push_supported(ae_dev))
 			tqp->q.mem_base = hdev->hw.hw.mem_base +
 					  HCLGEVF_TQP_MEM_OFFSET(hdev, i);
 
-- 
2.33.0

