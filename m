Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3945E8786
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiIXCeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbiIXCdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:33:22 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19751151B0F;
        Fri, 23 Sep 2022 19:33:18 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MZCdG6JF0z1P6qG;
        Sat, 24 Sep 2022 10:29:06 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:17 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 10/14] net: hns3: modify macro hnae3_dev_ras_imp_supported
Date:   Sat, 24 Sep 2022 10:30:20 +0800
Message-ID: <20220924023024.14219-11-huangguangbin2@huawei.com>
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

Redefine macro hnae3_dev_ras_imp_supported(hdev) to
hnae3_ae_dev_ras_imp_supported(ae_dev), so it can be
used in both hclge and hns3_enet layer.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 494402074cb9..0d8e0c461a31 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -134,8 +134,8 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_phy_imp_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, (ae_dev)->caps)
 
-#define hnae3_dev_ras_imp_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_RAS_IMP_B, (hdev)->ae_dev->caps)
+#define hnae3_ae_dev_ras_imp_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_RAS_IMP_B, (ae_dev)->caps)
 
 #define hnae3_dev_tqp_txrx_indep_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, (hdev)->ae_dev->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7995e3388778..cc3ba2a16f5e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4579,7 +4579,7 @@ static void hclge_errhand_service_task(struct hclge_dev *hdev)
 	if (!test_and_clear_bit(HCLGE_STATE_ERR_SERVICE_SCHED, &hdev->state))
 		return;
 
-	if (hnae3_dev_ras_imp_supported(hdev))
+	if (hnae3_ae_dev_ras_imp_supported(hdev->ae_dev))
 		hclge_handle_err_recovery(hdev);
 	else
 		hclge_misc_err_recovery(hdev);
@@ -11671,7 +11671,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_clear_resetting_state(hdev);
 
 	/* Log and clear the hw errors those already occurred */
-	if (hnae3_dev_ras_imp_supported(hdev))
+	if (hnae3_ae_dev_ras_imp_supported(hdev->ae_dev))
 		hclge_handle_occurred_error(hdev);
 	else
 		hclge_handle_all_hns_hw_errors(ae_dev);
@@ -12035,7 +12035,7 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 
 	/* Log and clear the hw errors those already occurred */
-	if (hnae3_dev_ras_imp_supported(hdev))
+	if (hnae3_ae_dev_ras_imp_supported(hdev->ae_dev))
 		hclge_handle_occurred_error(hdev);
 	else
 		hclge_handle_all_hns_hw_errors(ae_dev);
-- 
2.33.0

