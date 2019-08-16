Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA628FD62
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfHPIMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:12:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50876 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbfHPIMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:12:10 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8A91DFA4BAD43CA1EE73;
        Fri, 16 Aug 2019 16:11:58 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 16 Aug 2019 16:11:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Weihang Li" <liweihang@hisilicon.com>,
        Jian Shen <shenjian15@huawei.com>,
        "Guangbin Huang" <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/6] net: hns3: fix error and incorrect format
Date:   Fri, 16 Aug 2019 16:09:39 +0800
Message-ID: <1565942982-12105-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
References: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

The pointer type parameter should be declare as const for preventing
from its pointed value being unexpected modified.

The uninitialized variable can not be return directly. The default
return value is 0 if no abnormal result.

This patch fixes the preceding two errors, deletes redundant
declaration of a function and align one parameter.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c             | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c      | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 ++++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 1 -
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 6bbba15..528f624 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -46,7 +46,7 @@ void hnae3_set_client_init_flag(struct hnae3_client *client,
 EXPORT_SYMBOL(hnae3_set_client_init_flag);
 
 static int hnae3_get_client_init_flag(struct hnae3_client *client,
-				       struct hnae3_ae_dev *ae_dev)
+				      struct hnae3_ae_dev *ae_dev)
 {
 	int inited = 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 4260653..0332d6f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -704,7 +704,7 @@ static int hns3_get_link_ksettings(struct net_device *netdev,
 	return 0;
 }
 
-static int hns3_check_ksettings_param(struct net_device *netdev,
+static int hns3_check_ksettings_param(const struct net_device *netdev,
 				      const struct ethtool_link_ksettings *cmd)
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1d8dee1..24b59f0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1128,6 +1128,7 @@ static void hclge_parse_link_mode(struct hclge_dev *hdev, u8 speed_ability)
 	else if (media_type == HNAE3_MEDIA_TYPE_BACKPLANE)
 		hclge_parse_backplane_link_mode(hdev, speed_ability);
 }
+
 static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 {
 	struct hclge_cfg_param_cmd *req;
@@ -4364,8 +4365,8 @@ int hclge_bind_ring_with_vector(struct hclge_vport *vport,
 	struct hclge_dev *hdev = vport->back;
 	struct hnae3_ring_chain_node *node;
 	struct hclge_desc desc;
-	struct hclge_ctrl_vector_chain_cmd *req
-		= (struct hclge_ctrl_vector_chain_cmd *)desc.data;
+	struct hclge_ctrl_vector_chain_cmd *req =
+		(struct hclge_ctrl_vector_chain_cmd *)desc.data;
 	enum hclge_cmd_status status;
 	enum hclge_opcode_type op;
 	u16 tqp_type_and_id;
@@ -8656,7 +8657,7 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 		}
 	}
 
-	return ret;
+	return 0;
 
 clear_nic:
 	hdev->nic_client = NULL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index f6d9b57..7c28933 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1000,7 +1000,6 @@ int hclge_buffer_alloc(struct hclge_dev *hdev);
 int hclge_rss_init_hw(struct hclge_dev *hdev);
 void hclge_rss_indir_init_cfg(struct hclge_dev *hdev);
 
-int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport);
 void hclge_mbx_handler(struct hclge_dev *hdev);
 int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id);
 void hclge_reset_vf_queue(struct hclge_vport *vport, u16 queue_id);
-- 
2.7.4

