Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB9C5E8781
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiIXCeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbiIXCdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:33:33 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661E8151B03;
        Fri, 23 Sep 2022 19:33:20 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MZCdJ0XjBz1P6tw;
        Sat, 24 Sep 2022 10:29:08 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:18 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 14/14] net: hns3: modify macro hnae3_dev_pause_supported
Date:   Sat, 24 Sep 2022 10:30:24 +0800
Message-ID: <20220924023024.14219-15-huangguangbin2@huawei.com>
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

Redefine macro hnae3_dev_pause_supported(hdev) to
hnae3_ae_dev_pause_supported(ae_dev), so it can be
used in both hclge and hns3_enet layer.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c      | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 94b71701a74d..1bd695e88cca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -143,8 +143,8 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_stash_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_STASH_B, (ae_dev)->caps)
 
-#define hnae3_dev_pause_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_PAUSE_B, (hdev)->ae_dev->caps)
+#define hnae3_ae_dev_pause_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_PAUSE_B, (ae_dev)->caps)
 
 #define hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, (ae_dev)->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e4278ec95d21..58f19006e403 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -701,7 +701,7 @@ static void hns3_get_pauseparam(struct net_device *netdev,
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 
-	if (!test_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps))
+	if (!hnae3_ae_dev_pause_supported(ae_dev))
 		return;
 
 	if (h->ae_algo->ops->get_pauseparam)
@@ -715,7 +715,7 @@ static int hns3_set_pauseparam(struct net_device *netdev,
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 
-	if (!test_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps))
+	if (!hnae3_ae_dev_pause_supported(ae_dev))
 		return -EOPNOTSUPP;
 
 	netif_dbg(h, drv, netdev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index cc3ba2a16f5e..e8e18bac5b50 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1182,7 +1182,7 @@ static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
 	if (hnae3_ae_dev_fec_supported(hdev->ae_dev))
 		hclge_convert_setting_fec(mac);
 
-	if (hnae3_dev_pause_supported(hdev))
+	if (hnae3_ae_dev_pause_supported(hdev->ae_dev))
 		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, mac->supported);
 
 	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, mac->supported);
@@ -1198,7 +1198,7 @@ static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
 	if (hnae3_ae_dev_fec_supported(hdev->ae_dev))
 		hclge_convert_setting_fec(mac);
 
-	if (hnae3_dev_pause_supported(hdev))
+	if (hnae3_ae_dev_pause_supported(hdev->ae_dev))
 		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, mac->supported);
 
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Backplane_BIT, mac->supported);
@@ -1230,7 +1230,7 @@ static void hclge_parse_copper_link_mode(struct hclge_dev *hdev,
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, supported);
 	}
 
-	if (hnae3_dev_pause_supported(hdev)) {
+	if (hnae3_ae_dev_pause_supported(hdev->ae_dev)) {
 		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, supported);
 		linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, supported);
 	}
-- 
2.33.0

