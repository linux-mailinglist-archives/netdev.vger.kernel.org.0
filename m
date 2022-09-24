Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131DD5E8771
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiIXCdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiIXCdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:33:15 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E661514FF;
        Fri, 23 Sep 2022 19:33:14 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MZCdB1NHqz1P6mK;
        Sat, 24 Sep 2022 10:29:02 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:12 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:11 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 01/14] net: hns3: modify macro hnae3_dev_fec_supported
Date:   Sat, 24 Sep 2022 10:30:11 +0800
Message-ID: <20220924023024.14219-2-huangguangbin2@huawei.com>
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

The macro hnae3_dev_fec_supported(hdev) just can be used in hclge layer,
so redefine it to hnae3_ae_dev_fec_supported(ae_dev), then it can be used
in both hclge and hns3_enet layer.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c      | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0179fc288f5f..21308c5e280b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -107,8 +107,8 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_gro_supported(ae_dev) \
 		test_bit(HNAE3_DEV_SUPPORT_GRO_B, (ae_dev)->caps)
 
-#define hnae3_dev_fec_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_FEC_B, (hdev)->ae_dev->caps)
+#define hnae3_ae_dev_fec_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_FEC_B, (ae_dev)->caps)
 
 #define hnae3_dev_udp_gso_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, (hdev)->ae_dev->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index cdf76fb58d45..f866b6676318 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1705,7 +1705,7 @@ static int hns3_get_fecparam(struct net_device *netdev,
 	u8 fec_ability;
 	u8 fec_mode;
 
-	if (!test_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps))
+	if (!hnae3_ae_dev_fec_supported(ae_dev))
 		return -EOPNOTSUPP;
 
 	if (!ops->get_fec)
@@ -1729,7 +1729,7 @@ static int hns3_set_fecparam(struct net_device *netdev,
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
 	u32 fec_mode;
 
-	if (!test_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps))
+	if (!hnae3_ae_dev_fec_supported(ae_dev))
 		return -EOPNOTSUPP;
 
 	if (!ops->set_fec)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7b25d8f89427..0134bc8f7865 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1179,7 +1179,7 @@ static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
 	hclge_convert_setting_sr(speed_ability, mac->supported);
 	hclge_convert_setting_lr(speed_ability, mac->supported);
 	hclge_convert_setting_cr(speed_ability, mac->supported);
-	if (hnae3_dev_fec_supported(hdev))
+	if (hnae3_ae_dev_fec_supported(hdev->ae_dev))
 		hclge_convert_setting_fec(mac);
 
 	if (hnae3_dev_pause_supported(hdev))
@@ -1195,7 +1195,7 @@ static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
 	struct hclge_mac *mac = &hdev->hw.mac;
 
 	hclge_convert_setting_kr(speed_ability, mac->supported);
-	if (hnae3_dev_fec_supported(hdev))
+	if (hnae3_ae_dev_fec_supported(hdev->ae_dev))
 		hclge_convert_setting_fec(mac);
 
 	if (hnae3_dev_pause_supported(hdev))
@@ -3232,7 +3232,7 @@ static void hclge_update_advertising(struct hclge_dev *hdev)
 static void hclge_update_port_capability(struct hclge_dev *hdev,
 					 struct hclge_mac *mac)
 {
-	if (hnae3_dev_fec_supported(hdev))
+	if (hnae3_ae_dev_fec_supported(hdev->ae_dev))
 		hclge_convert_setting_fec(mac);
 
 	/* firmware can not identify back plane type, the media type
-- 
2.33.0

