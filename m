Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4994277CEB
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgIYA3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:29:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14279 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726738AbgIYA3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:29:02 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BFFEE7D46A7B22380482;
        Fri, 25 Sep 2020 08:28:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 08:28:52 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/6] net: hns3: remove unnecessary variable initialization
Date:   Fri, 25 Sep 2020 08:26:14 +0800
Message-ID: <1600993578-41008-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
References: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

If a variable is assigned a value before it is used, it's no
need to assign an initial value to the variable. So remove
these redundant operations.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c        | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c    | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c     | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index fe7fb56..c6d7463 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -19,7 +19,7 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 	struct hns3_enet_ring *ring;
 	u32 base_add_l, base_add_h;
 	u32 queue_num, queue_max;
-	u32 value, i = 0;
+	u32 value, i;
 	int cnt;
 
 	if (!priv->ring) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index feeaf75..0542033 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1254,7 +1254,7 @@ static bool hns3_skb_need_linearized(struct sk_buff *skb, unsigned int *bd_size,
 
 void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size)
 {
-	int i = 0;
+	int i;
 
 	for (i = 0; i < MAX_SKB_FRAGS; i++)
 		size[i] = skb_frag_size(&shinfo->frags[i]);
@@ -3511,7 +3511,7 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 	struct hnae3_ring_chain_node vector_ring_chain;
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_tqp_vector *tqp_vector;
-	int ret = 0;
+	int ret;
 	int i;
 
 	hns3_nic_set_cpumask(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 1d6c328..81aa67b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -261,7 +261,7 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 	bool complete = false;
 	u32 timeout = 0;
 	int handle = 0;
-	int retval = 0;
+	int retval;
 	int ntc;
 
 	spin_lock_bh(&hw->cmq.csq.lock);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 40d68a4..279e627 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -622,7 +622,7 @@ static u8 *hclge_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
 {
 	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
 	u8 *buff = data;
-	int i = 0;
+	int i;
 
 	for (i = 0; i < kinfo->num_tqps; i++) {
 		struct hclge_tqp *tqp = container_of(handle->kinfo.tqp[i],
@@ -3211,7 +3211,7 @@ static int hclge_notify_roce_client(struct hclge_dev *hdev,
 				    enum hnae3_reset_notify_type type)
 {
 	struct hnae3_client *client = hdev->roce_client;
-	int ret = 0;
+	int ret;
 	u16 i;
 
 	if (!test_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state) || !client)
@@ -11093,7 +11093,7 @@ static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
 {
 	struct hclge_vport *vport = &hdev->vport[0];
 	struct hnae3_handle *handle = &vport->nic;
-	u8 tmp_flags = 0;
+	u8 tmp_flags;
 	int ret;
 
 	if (vport->last_promisc_flags != vport->overflow_promisc_flags) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 28db132..19742f9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1355,7 +1355,7 @@ static int hclge_mac_pause_setup_hw(struct hclge_dev *hdev)
 
 static int hclge_tm_bp_setup(struct hclge_dev *hdev)
 {
-	int ret = 0;
+	int ret;
 	int i;
 
 	for (i = 0; i < hdev->tm_info.num_tc; i++) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 8eb9af4..f9f8312 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -171,7 +171,7 @@ static u8 *hclgevf_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
 {
 	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
 	u8 *buff = data;
-	int i = 0;
+	int i;
 
 	for (i = 0; i < kinfo->num_tqps; i++) {
 		struct hclgevf_tqp *tqp = container_of(kinfo->tqp[i],
-- 
2.7.4

