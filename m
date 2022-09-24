Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31845E8785
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbiIXCdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbiIXCdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:33:18 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A532151B02;
        Fri, 23 Sep 2022 19:33:17 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MZCdF4YvMz1P6p6;
        Sat, 24 Sep 2022 10:29:05 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:15 +0800
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
Subject: [PATCH net-next 04/14] net: hns3: modify macro hnae3_dev_fd_forward_tc_supported
Date:   Sat, 24 Sep 2022 10:30:14 +0800
Message-ID: <20220924023024.14219-5-huangguangbin2@huawei.com>
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

Redefine macro hnae3_dev_fd_forward_tc_supported(hdev) to
hnae3_ae_dev_fd_forward_tc_supported(ae_dev), so it can be
used in both hclge and hns3_enet layer.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 60e06c7be32d..60fda66e08bd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -116,8 +116,8 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_qb_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_QB_B, (ae_dev)->caps)
 
-#define hnae3_dev_fd_forward_tc_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, (hdev)->ae_dev->caps)
+#define hnae3_ae_dev_fd_forward_tc_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, (ae_dev)->caps)
 
 #define hnae3_dev_ptp_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_PTP_B, (hdev)->ae_dev->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9e4935a90c8b..ede31db761b3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3331,7 +3331,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
 		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 
-	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
+	if (hnae3_ae_dev_fd_forward_tc_supported(ae_dev))
 		netdev->features |= NETIF_F_HW_TC;
 
 	netdev->hw_features |= netdev->features;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0134bc8f7865..5fa5ae7c32a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5649,7 +5649,7 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 		      action->write_rule_id_to_bd);
 	hnae3_set_field(ad_data, HCLGE_FD_AD_RULE_ID_M, HCLGE_FD_AD_RULE_ID_S,
 			action->rule_id);
-	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps)) {
+	if (hnae3_ae_dev_fd_forward_tc_supported(ae_dev)) {
 		hnae3_set_bit(ad_data, HCLGE_FD_AD_TC_OVRD_B,
 			      action->override_tc);
 		hnae3_set_field(ad_data, HCLGE_FD_AD_TC_SIZE_M,
-- 
2.33.0

