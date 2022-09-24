Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0127B5E877E
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiIXCdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiIXCdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:33:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29218151B03;
        Fri, 23 Sep 2022 19:33:18 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MZCdF62m5zlWGG;
        Sat, 24 Sep 2022 10:29:05 +0800 (CST)
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
Subject: [PATCH net-next 07/14] net: hns3: modify macro hnae3_dev_hw_csum_supported
Date:   Sat, 24 Sep 2022 10:30:17 +0800
Message-ID: <20220924023024.14219-8-huangguangbin2@huawei.com>
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

Redefine macro hnae3_dev_hw_csum_supported(hdev) to
hnae3_ae_dev_hw_csum_supported(ae_dev), so it can be
used in both hclge and hns3_enet layer.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h     | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index ed06f8db2a27..b802de61e63b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -125,8 +125,8 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_int_ql_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_INT_QL_B, (ae_dev)->caps)
 
-#define hnae3_dev_hw_csum_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, (hdev)->ae_dev->caps)
+#define hnae3_ae_dev_hw_csum_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, (ae_dev)->caps)
 
 #define hnae3_dev_tx_push_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, (hdev)->ae_dev->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index ede31db761b3..878c60d58061 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3323,7 +3323,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	if (hnae3_ae_dev_udp_gso_supported(ae_dev))
 		netdev->features |= NETIF_F_GSO_UDP_L4;
 
-	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
+	if (hnae3_ae_dev_hw_csum_supported(ae_dev))
 		netdev->features |= NETIF_F_HW_CSUM;
 	else
 		netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
@@ -5235,7 +5235,7 @@ static void hns3_state_init(struct hnae3_handle *handle)
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
 		set_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->supported_pflags);
 
-	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
+	if (hnae3_ae_dev_hw_csum_supported(ae_dev))
 		set_bit(HNS3_NIC_STATE_HW_TX_CSUM_ENABLE, &priv->state);
 
 	if (hnae3_ae_dev_rxd_adv_layout_supported(ae_dev))
-- 
2.33.0

