Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 938599975C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733092AbfHVOvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:51:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4769 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfHVOvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 10:51:07 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1C14AB204D7617C720F4;
        Thu, 22 Aug 2019 22:51:03 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 22:50:55 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <shenjian15@huawei.com>,
        <linyunsheng@huawei.com>, <liuzhongzhu@huawei.com>,
        <huangguangbin2@huawei.com>, <liweihang@hisilicon.com>,
        <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: hns3: Fix -Wunused-const-variable warning
Date:   Thu, 22 Aug 2019 22:49:37 +0800
Message-ID: <20190822144937.75884-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h:542:30:
 warning: meta_data_key_info defined but not used [-Wunused-const-variable=]
drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h:553:30:
 warning: tuple_key_info defined but not used [-Wunused-const-variable=]

The two variable is only used in hclge_main.c,
so just move the definition over there.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 44 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    | 44 ----------------------
 2 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9d64c43..dde17be 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -364,6 +364,50 @@ static const enum hclge_opcode_type hclge_dfx_reg_opcode_list[] = {
 	HCLGE_OPC_DFX_SSU_REG_2
 };
 
+static const struct key_info meta_data_key_info[] = {
+	{ PACKET_TYPE_ID, 6},
+	{ IP_FRAGEMENT, 1},
+	{ ROCE_TYPE, 1},
+	{ NEXT_KEY, 5},
+	{ VLAN_NUMBER, 2},
+	{ SRC_VPORT, 12},
+	{ DST_VPORT, 12},
+	{ TUNNEL_PACKET, 1},
+};
+
+static const struct key_info tuple_key_info[] = {
+	{ OUTER_DST_MAC, 48},
+	{ OUTER_SRC_MAC, 48},
+	{ OUTER_VLAN_TAG_FST, 16},
+	{ OUTER_VLAN_TAG_SEC, 16},
+	{ OUTER_ETH_TYPE, 16},
+	{ OUTER_L2_RSV, 16},
+	{ OUTER_IP_TOS, 8},
+	{ OUTER_IP_PROTO, 8},
+	{ OUTER_SRC_IP, 32},
+	{ OUTER_DST_IP, 32},
+	{ OUTER_L3_RSV, 16},
+	{ OUTER_SRC_PORT, 16},
+	{ OUTER_DST_PORT, 16},
+	{ OUTER_L4_RSV, 32},
+	{ OUTER_TUN_VNI, 24},
+	{ OUTER_TUN_FLOW_ID, 8},
+	{ INNER_DST_MAC, 48},
+	{ INNER_SRC_MAC, 48},
+	{ INNER_VLAN_TAG_FST, 16},
+	{ INNER_VLAN_TAG_SEC, 16},
+	{ INNER_ETH_TYPE, 16},
+	{ INNER_L2_RSV, 16},
+	{ INNER_IP_TOS, 8},
+	{ INNER_IP_PROTO, 8},
+	{ INNER_SRC_IP, 32},
+	{ INNER_DST_IP, 32},
+	{ INNER_L3_RSV, 16},
+	{ INNER_SRC_PORT, 16},
+	{ INNER_DST_PORT, 16},
+	{ INNER_L4_RSV, 32},
+};
+
 static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
 {
 #define HCLGE_MAC_CMD_NUM 21
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 7c28933..7ff03b9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -539,50 +539,6 @@ struct key_info {
 	u8 key_length; /* use bit as unit */
 };
 
-static const struct key_info meta_data_key_info[] = {
-	{ PACKET_TYPE_ID, 6},
-	{ IP_FRAGEMENT, 1},
-	{ ROCE_TYPE, 1},
-	{ NEXT_KEY, 5},
-	{ VLAN_NUMBER, 2},
-	{ SRC_VPORT, 12},
-	{ DST_VPORT, 12},
-	{ TUNNEL_PACKET, 1},
-};
-
-static const struct key_info tuple_key_info[] = {
-	{ OUTER_DST_MAC, 48},
-	{ OUTER_SRC_MAC, 48},
-	{ OUTER_VLAN_TAG_FST, 16},
-	{ OUTER_VLAN_TAG_SEC, 16},
-	{ OUTER_ETH_TYPE, 16},
-	{ OUTER_L2_RSV, 16},
-	{ OUTER_IP_TOS, 8},
-	{ OUTER_IP_PROTO, 8},
-	{ OUTER_SRC_IP, 32},
-	{ OUTER_DST_IP, 32},
-	{ OUTER_L3_RSV, 16},
-	{ OUTER_SRC_PORT, 16},
-	{ OUTER_DST_PORT, 16},
-	{ OUTER_L4_RSV, 32},
-	{ OUTER_TUN_VNI, 24},
-	{ OUTER_TUN_FLOW_ID, 8},
-	{ INNER_DST_MAC, 48},
-	{ INNER_SRC_MAC, 48},
-	{ INNER_VLAN_TAG_FST, 16},
-	{ INNER_VLAN_TAG_SEC, 16},
-	{ INNER_ETH_TYPE, 16},
-	{ INNER_L2_RSV, 16},
-	{ INNER_IP_TOS, 8},
-	{ INNER_IP_PROTO, 8},
-	{ INNER_SRC_IP, 32},
-	{ INNER_DST_IP, 32},
-	{ INNER_L3_RSV, 16},
-	{ INNER_SRC_PORT, 16},
-	{ INNER_DST_PORT, 16},
-	{ INNER_L4_RSV, 32},
-};
-
 #define MAX_KEY_LENGTH	400
 #define MAX_KEY_DWORDS	DIV_ROUND_UP(MAX_KEY_LENGTH / 8, 4)
 #define MAX_KEY_BYTES	(MAX_KEY_DWORDS * 4)
-- 
2.7.4


