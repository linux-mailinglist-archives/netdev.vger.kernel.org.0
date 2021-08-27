Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1143F9712
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244852AbhH0JdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:33:13 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:15221 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244579AbhH0JdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:33:07 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GwvcF0ChXz1DDBw;
        Fri, 27 Aug 2021 17:31:41 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:16 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/8] net: hns3: add macros for mac speeds of firmware command
Date:   Fri, 27 Aug 2021 17:28:17 +0800
Message-ID: <1630056504-31725-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
References: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve code readability, replace digital numbers of mac speeds
defined by firmware command with macros.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 13 ++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 36 +++++++++++-----------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 53872c7b2940..2e49a52dfd3a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1201,6 +1201,19 @@ struct hclge_dev_specs_1_cmd {
 	u8 rsv1[18];
 };
 
+/* mac speed type defined in firmware command */
+enum HCLGE_FIRMWARE_MAC_SPEED {
+	HCLGE_FW_MAC_SPEED_1G,
+	HCLGE_FW_MAC_SPEED_10G,
+	HCLGE_FW_MAC_SPEED_25G,
+	HCLGE_FW_MAC_SPEED_40G,
+	HCLGE_FW_MAC_SPEED_50G,
+	HCLGE_FW_MAC_SPEED_100G,
+	HCLGE_FW_MAC_SPEED_10M,
+	HCLGE_FW_MAC_SPEED_100M,
+	HCLGE_FW_MAC_SPEED_200G,
+};
+
 #define HCLGE_PHY_LINK_SETTING_BD_NUM		2
 
 struct hclge_phy_link_ksetting_0_cmd {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1b6bb0d71fcb..cb756cf307eb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -959,31 +959,31 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 static int hclge_parse_speed(u8 speed_cmd, u32 *speed)
 {
 	switch (speed_cmd) {
-	case 6:
+	case HCLGE_FW_MAC_SPEED_10M:
 		*speed = HCLGE_MAC_SPEED_10M;
 		break;
-	case 7:
+	case HCLGE_FW_MAC_SPEED_100M:
 		*speed = HCLGE_MAC_SPEED_100M;
 		break;
-	case 0:
+	case HCLGE_FW_MAC_SPEED_1G:
 		*speed = HCLGE_MAC_SPEED_1G;
 		break;
-	case 1:
+	case HCLGE_FW_MAC_SPEED_10G:
 		*speed = HCLGE_MAC_SPEED_10G;
 		break;
-	case 2:
+	case HCLGE_FW_MAC_SPEED_25G:
 		*speed = HCLGE_MAC_SPEED_25G;
 		break;
-	case 3:
+	case HCLGE_FW_MAC_SPEED_40G:
 		*speed = HCLGE_MAC_SPEED_40G;
 		break;
-	case 4:
+	case HCLGE_FW_MAC_SPEED_50G:
 		*speed = HCLGE_MAC_SPEED_50G;
 		break;
-	case 5:
+	case HCLGE_FW_MAC_SPEED_100G:
 		*speed = HCLGE_MAC_SPEED_100G;
 		break;
-	case 8:
+	case HCLGE_FW_MAC_SPEED_200G:
 		*speed = HCLGE_MAC_SPEED_200G;
 		break;
 	default:
@@ -2582,39 +2582,39 @@ static int hclge_cfg_mac_speed_dup_hw(struct hclge_dev *hdev, int speed,
 	switch (speed) {
 	case HCLGE_MAC_SPEED_10M:
 		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, 6);
+				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_10M);
 		break;
 	case HCLGE_MAC_SPEED_100M:
 		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, 7);
+				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_100M);
 		break;
 	case HCLGE_MAC_SPEED_1G:
 		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, 0);
+				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_1G);
 		break;
 	case HCLGE_MAC_SPEED_10G:
 		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, 1);
+				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_10G);
 		break;
 	case HCLGE_MAC_SPEED_25G:
 		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, 2);
+				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_25G);
 		break;
 	case HCLGE_MAC_SPEED_40G:
 		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, 3);
+				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_40G);
 		break;
 	case HCLGE_MAC_SPEED_50G:
 		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, 4);
+				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_50G);
 		break;
 	case HCLGE_MAC_SPEED_100G:
 		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, 5);
+				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_100G);
 		break;
 	case HCLGE_MAC_SPEED_200G:
 		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, 8);
+				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_200G);
 		break;
 	default:
 		dev_err(&hdev->pdev->dev, "invalid speed (%d)\n", speed);
-- 
2.8.1

