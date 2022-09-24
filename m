Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50ABC5E877C
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiIXCdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiIXCdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:33:19 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A1E151B01;
        Fri, 23 Sep 2022 19:33:17 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MZCgW5THWzHqBT;
        Sat, 24 Sep 2022 10:31:03 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:16 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 05/14] net: hns3: modify macro hnae3_dev_ptp_supported
Date:   Sat, 24 Sep 2022 10:30:15 +0800
Message-ID: <20220924023024.14219-6-huangguangbin2@huawei.com>
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

Redefine macro hnae3_dev_ptp_supported(hdev) to
hnae3_ae_dev_ptp_supported(ae_dev), so it can be
used in both hclge and hns3_enet layer.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h            | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c     | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 60fda66e08bd..dd2dd085ab3d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -119,8 +119,8 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_fd_forward_tc_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, (ae_dev)->caps)
 
-#define hnae3_dev_ptp_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_PTP_B, (hdev)->ae_dev->caps)
+#define hnae3_ae_dev_ptp_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_PTP_B, (ae_dev)->caps)
 
 #define hnae3_dev_int_ql_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_INT_QL_B, (hdev)->ae_dev->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 66feb23f7b7b..7de1f91c4877 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -1367,7 +1367,7 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 		if ((hns3_dbg_cmd[i].cmd == HNAE3_DBG_CMD_TM_NODES &&
 		     ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) ||
 		    (hns3_dbg_cmd[i].cmd == HNAE3_DBG_CMD_PTP_INFO &&
-		     !test_bit(HNAE3_DEV_SUPPORT_PTP_B, ae_dev->caps)))
+		     !hnae3_ae_dev_ptp_supported(ae_dev)))
 			continue;
 
 		if (!hns3_dbg_cmd[i].init) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index a40b1583f114..aebd98586e62 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -486,7 +486,7 @@ int hclge_ptp_init(struct hclge_dev *hdev)
 	struct timespec64 ts;
 	int ret;
 
-	if (!test_bit(HNAE3_DEV_SUPPORT_PTP_B, ae_dev->caps))
+	if (!hnae3_ae_dev_ptp_supported(ae_dev))
 		return 0;
 
 	if (!hdev->ptp) {
-- 
2.33.0

