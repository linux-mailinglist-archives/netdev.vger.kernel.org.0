Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F73043E5D
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbfFMPtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:49:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18157 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731708AbfFMJO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:14:28 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 445ACD9AE11E383EFF84;
        Thu, 13 Jun 2019 17:14:19 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 17:14:09 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: some variable modification
Date:   Thu, 13 Jun 2019 17:12:32 +0800
Message-ID: <1560417152-53050-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
References: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

This patch does following things:
1. add the keyword const before some variables which won't be modified
   in functions.
2. changes some variables from signed to unsigned to avoid bitwise
   operation on signed variables.
3. adds or removes initialization of some variables.
4. defines a new structure to help parsing mailbox messages instead of
   using an array which is harder to get the meaning of each element.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  3 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 16 +++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 64 +++++++++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    | 15 ++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 20 ++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |  8 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 11 ++--
 12 files changed, 95 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 0de3d6b..908d4f4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -26,7 +26,8 @@ static bool hnae3_client_match(enum hnae3_client_type client_type)
 }
 
 void hnae3_set_client_init_flag(struct hnae3_client *client,
-				struct hnae3_ae_dev *ae_dev, int inited)
+				struct hnae3_ae_dev *ae_dev,
+				unsigned int inited)
 {
 	if (!client || !ae_dev)
 		return;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 79044b5..bf921ef 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -493,7 +493,7 @@ struct hnae3_ae_ops {
 	void (*enable_fd)(struct hnae3_handle *handle, bool enable);
 	int (*add_arfs_entry)(struct hnae3_handle *handle, u16 queue_id,
 			      u16 flow_id, struct flow_keys *fkeys);
-	int (*dbg_run_cmd)(struct hnae3_handle *handle, char *cmd_buf);
+	int (*dbg_run_cmd)(struct hnae3_handle *handle, const char *cmd_buf);
 	pci_ers_result_t (*handle_hw_ras_error)(struct hnae3_ae_dev *ae_dev);
 	bool (*get_hw_reset_stat)(struct hnae3_handle *handle);
 	bool (*ae_dev_resetting)(struct hnae3_handle *handle);
@@ -645,5 +645,6 @@ void hnae3_unregister_client(struct hnae3_client *client);
 int hnae3_register_client(struct hnae3_client *client);
 
 void hnae3_set_client_init_flag(struct hnae3_client *client,
-				struct hnae3_ae_dev *ae_dev, int inited);
+				struct hnae3_ae_dev *ae_dev,
+				unsigned int inited);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 30354fa..a4b9372 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -11,7 +11,8 @@
 
 static struct dentry *hns3_dbgfs_root;
 
-static int hns3_dbg_queue_info(struct hnae3_handle *h, char *cmd_buf)
+static int hns3_dbg_queue_info(struct hnae3_handle *h,
+			       const char *cmd_buf)
 {
 	struct hns3_nic_priv *priv = h->priv;
 	struct hns3_nic_ring_data *ring_data;
@@ -155,7 +156,7 @@ static int hns3_dbg_queue_map(struct hnae3_handle *h)
 	return 0;
 }
 
-static int hns3_dbg_bd_info(struct hnae3_handle *h, char *cmd_buf)
+static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 {
 	struct hns3_nic_priv *priv = h->priv;
 	struct hns3_nic_ring_data *ring_data;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 735419e..951a812 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1011,7 +1011,8 @@ static int hns3_fill_desc_vtags(struct sk_buff *skb,
 }
 
 static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
-			  int size, int frag_end, enum hns_desc_type type)
+			  unsigned int size, int frag_end,
+			  enum hns_desc_type type)
 {
 	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_use];
 	struct hns3_desc *desc = &ring->desc[ring->next_to_use];
@@ -3424,7 +3425,7 @@ static int hns3_nic_dealloc_vector_data(struct hns3_nic_priv *priv)
 }
 
 static int hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
-			     int ring_type)
+			     unsigned int ring_type)
 {
 	struct hns3_nic_ring_data *ring_data = priv->ring_data;
 	int queue_num = priv->ae_handle->kinfo.num_tqps;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index efab15f..3ac1411 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -417,7 +417,7 @@ struct hns3_enet_ring {
 	 */
 	int next_to_clean;
 
-	int pull_len; /* head length for current packet */
+	u32 pull_len; /* head length for current packet */
 	u32 frag_num;
 	unsigned char *va; /* first buffer address for current packet */
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 95dc163..ab625c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -61,8 +61,8 @@ static int hclge_dbg_cmd_send(struct hclge_dev *hdev,
 
 static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 				      struct hclge_dbg_dfx_message *dfx_message,
-				      char *cmd_buf, int msg_num, int offset,
-				      enum hclge_opcode_type cmd)
+				      const char *cmd_buf, int msg_num,
+				      int offset, enum hclge_opcode_type cmd)
 {
 #define BD_DATA_NUM       6
 
@@ -111,7 +111,7 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 	kfree(desc_src);
 }
 
-static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, char *cmd_buf)
+static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 {
 	struct device *dev = &hdev->pdev->dev;
 	struct hclge_dbg_bitmap_cmd *bitmap;
@@ -211,7 +211,7 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, char *cmd_buf)
 	dev_info(dev, "IGU_TX_PRI_MAP_TC_CFG: 0x%x\n", desc[0].data[5]);
 }
 
-static void hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev, char *cmd_buf)
+static void hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev, const char *cmd_buf)
 {
 	int msg_num;
 
@@ -541,7 +541,8 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 		cmd, ret);
 }
 
-static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev, char *cmd_buf)
+static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
+				  const char *cmd_buf)
 {
 	struct hclge_bp_to_qs_map_cmd *bp_to_qs_map_cmd;
 	struct hclge_nq_to_qs_link_cmd *nq_to_qs_map;
@@ -984,7 +985,8 @@ void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
  * @hdev: pointer to struct hclge_dev
  * @cmd_buf: string that contains offset and length
  */
-static void hclge_dbg_dump_ncl_config(struct hclge_dev *hdev, char *cmd_buf)
+static void hclge_dbg_dump_ncl_config(struct hclge_dev *hdev,
+				      const char *cmd_buf)
 {
 #define HCLGE_MAX_NCL_CONFIG_OFFSET	4096
 #define HCLGE_MAX_NCL_CONFIG_LENGTH	(20 + 24 * 4)
@@ -1063,7 +1065,7 @@ static void hclge_dbg_dump_mac_tnl_status(struct hclge_dev *hdev)
 	}
 }
 
-int hclge_dbg_run_cmd(struct hnae3_handle *handle, char *cmd_buf)
+int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c1e5a00..fbf0c20 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -27,7 +27,7 @@
 #define HCLGE_STATS_READ(p, offset) (*((u64 *)((u8 *)(p) + (offset))))
 #define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
 
-#define HCLGE_BUF_SIZE_UNIT	256
+#define HCLGE_BUF_SIZE_UNIT	256U
 #define HCLGE_BUF_MUL_BY	2
 #define HCLGE_BUF_DIV_BY	2
 
@@ -536,7 +536,7 @@ static u8 *hclge_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
 	return buff;
 }
 
-static u64 *hclge_comm_get_stats(void *comm_stats,
+static u64 *hclge_comm_get_stats(const void *comm_stats,
 				 const struct hclge_comm_stats_str strs[],
 				 int size, u64 *data)
 {
@@ -1076,7 +1076,7 @@ static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 	struct hclge_cfg_param_cmd *req;
 	u64 mac_addr_tmp_high;
 	u64 mac_addr_tmp;
-	int i;
+	unsigned int i;
 
 	req = (struct hclge_cfg_param_cmd *)desc[0].data;
 
@@ -1138,7 +1138,8 @@ static int hclge_get_cfg(struct hclge_dev *hdev, struct hclge_cfg *hcfg)
 {
 	struct hclge_desc desc[HCLGE_PF_CFG_DESC_NUM];
 	struct hclge_cfg_param_cmd *req;
-	int i, ret;
+	unsigned int i;
+	int ret;
 
 	for (i = 0; i < HCLGE_PF_CFG_DESC_NUM; i++) {
 		u32 offset = 0;
@@ -1204,7 +1205,8 @@ static void hclge_init_kdump_kernel_config(struct hclge_dev *hdev)
 static int hclge_configure(struct hclge_dev *hdev)
 {
 	struct hclge_cfg cfg;
-	int ret, i;
+	unsigned int i;
+	int ret;
 
 	ret = hclge_get_cfg(hdev, &cfg);
 	if (ret) {
@@ -1267,8 +1269,8 @@ static int hclge_configure(struct hclge_dev *hdev)
 	return ret;
 }
 
-static int hclge_config_tso(struct hclge_dev *hdev, int tso_mss_min,
-			    int tso_mss_max)
+static int hclge_config_tso(struct hclge_dev *hdev, unsigned int tso_mss_min,
+			    unsigned int tso_mss_max)
 {
 	struct hclge_cfg_tso_status_cmd *req;
 	struct hclge_desc desc;
@@ -1580,7 +1582,8 @@ static int hclge_tx_buffer_alloc(struct hclge_dev *hdev,
 
 static u32 hclge_get_tc_num(struct hclge_dev *hdev)
 {
-	int i, cnt = 0;
+	unsigned int i;
+	u32 cnt = 0;
 
 	for (i = 0; i < HCLGE_MAX_TC_NUM; i++)
 		if (hdev->hw_tc_map & BIT(i))
@@ -1593,7 +1596,8 @@ static int hclge_get_pfc_priv_num(struct hclge_dev *hdev,
 				  struct hclge_pkt_buf_alloc *buf_alloc)
 {
 	struct hclge_priv_buf *priv;
-	int i, cnt = 0;
+	unsigned int i;
+	int cnt = 0;
 
 	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
 		priv = &buf_alloc->priv_buf[i];
@@ -1610,7 +1614,8 @@ static int hclge_get_no_pfc_priv_num(struct hclge_dev *hdev,
 				     struct hclge_pkt_buf_alloc *buf_alloc)
 {
 	struct hclge_priv_buf *priv;
-	int i, cnt = 0;
+	unsigned int i;
+	int cnt = 0;
 
 	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
 		priv = &buf_alloc->priv_buf[i];
@@ -1740,7 +1745,7 @@ static bool hclge_rx_buf_calc_all(struct hclge_dev *hdev, bool max,
 {
 	u32 rx_all = hdev->pkt_buf_size - hclge_get_tx_buff_alloced(buf_alloc);
 	u32 aligned_mps = round_up(hdev->mps, HCLGE_BUF_SIZE_UNIT);
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
 		struct hclge_priv_buf *priv = &buf_alloc->priv_buf[i];
@@ -1781,9 +1786,10 @@ static bool hclge_drop_nopfc_buf_till_fit(struct hclge_dev *hdev,
 	/* let the last to be cleared first */
 	for (i = HCLGE_MAX_TC_NUM - 1; i >= 0; i--) {
 		struct hclge_priv_buf *priv = &buf_alloc->priv_buf[i];
+		unsigned int mask = BIT((unsigned int)i);
 
-		if (hdev->hw_tc_map & BIT(i) &&
-		    !(hdev->tm_info.hw_pfc_map & BIT(i))) {
+		if (hdev->hw_tc_map & mask &&
+		    !(hdev->tm_info.hw_pfc_map & mask)) {
 			/* Clear the no pfc TC private buffer */
 			priv->wl.low = 0;
 			priv->wl.high = 0;
@@ -1810,9 +1816,10 @@ static bool hclge_drop_pfc_buf_till_fit(struct hclge_dev *hdev,
 	/* let the last to be cleared first */
 	for (i = HCLGE_MAX_TC_NUM - 1; i >= 0; i--) {
 		struct hclge_priv_buf *priv = &buf_alloc->priv_buf[i];
+		unsigned int mask = BIT((unsigned int)i);
 
-		if (hdev->hw_tc_map & BIT(i) &&
-		    hdev->tm_info.hw_pfc_map & BIT(i)) {
+		if (hdev->hw_tc_map & mask &&
+		    hdev->tm_info.hw_pfc_map & mask) {
 			/* Reduce the number of pfc TC with private buffer */
 			priv->wl.low = 0;
 			priv->enable = 0;
@@ -2451,7 +2458,7 @@ static int hclge_get_mac_link_status(struct hclge_dev *hdev)
 
 static int hclge_get_mac_phy_link(struct hclge_dev *hdev)
 {
-	int mac_state;
+	unsigned int mac_state;
 	int link_stat;
 
 	if (test_bit(HCLGE_STATE_DOWN, &hdev->state))
@@ -2746,8 +2753,8 @@ static void hclge_enable_vector(struct hclge_misc_vector *vector, bool enable)
 static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 {
 	struct hclge_dev *hdev = data;
+	u32 clearval = 0;
 	u32 event_cause;
-	u32 clearval;
 
 	hclge_enable_vector(&hdev->misc_vector, false);
 	event_cause = hclge_check_event_cause(hdev, &clearval);
@@ -3618,8 +3625,8 @@ static int hclge_set_rss_algo_key(struct hclge_dev *hdev,
 				  const u8 hfunc, const u8 *key)
 {
 	struct hclge_rss_config_cmd *req;
+	unsigned int key_offset = 0;
 	struct hclge_desc desc;
-	int key_offset = 0;
 	int key_counts;
 	int key_size;
 	int ret;
@@ -4004,7 +4011,8 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 	u16 tc_valid[HCLGE_MAX_TC_NUM];
 	u16 tc_size[HCLGE_MAX_TC_NUM];
 	u16 roundup_size;
-	int i, ret;
+	unsigned int i;
+	int ret;
 
 	ret = hclge_set_rss_indir_table(hdev, rss_indir);
 	if (ret)
@@ -4617,7 +4625,7 @@ static void hclge_fd_convert_meta_data(struct hclge_fd_key_cfg *key_cfg,
 {
 	u32 tuple_bit, meta_data = 0, tmp_x, tmp_y, port_number;
 	u8 cur_pos = 0, tuple_size, shift_bits;
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < MAX_META_DATA; i++) {
 		tuple_size = meta_data_key_info[i].key_length;
@@ -4659,7 +4667,8 @@ static int hclge_config_key(struct hclge_dev *hdev, u8 stage,
 	struct hclge_fd_key_cfg *key_cfg = &hdev->fd_cfg.key_cfg[stage];
 	u8 key_x[MAX_KEY_BYTES], key_y[MAX_KEY_BYTES];
 	u8 *cur_key_x, *cur_key_y;
-	int i, ret, tuple_size;
+	unsigned int i;
+	int ret, tuple_size;
 	u8 meta_data_region;
 
 	memset(key_x, 0, sizeof(key_x));
@@ -5983,7 +5992,7 @@ static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en,
 	return -EBUSY;
 }
 
-static int hclge_tqp_enable(struct hclge_dev *hdev, int tqp_id,
+static int hclge_tqp_enable(struct hclge_dev *hdev, unsigned int tqp_id,
 			    int stream_id, bool enable)
 {
 	struct hclge_desc desc;
@@ -5994,7 +6003,8 @@ static int hclge_tqp_enable(struct hclge_dev *hdev, int tqp_id,
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_COM_TQP_QUEUE, false);
 	req->tqp_id = cpu_to_le16(tqp_id & HCLGE_RING_ID_MASK);
 	req->stream_id = cpu_to_le16(stream_id);
-	req->enable |= enable << HCLGE_TQP_ENABLE_B;
+	if (enable)
+		req->enable |= 1U << HCLGE_TQP_ENABLE_B;
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
@@ -7024,7 +7034,7 @@ static void hclge_enable_vlan_filter(struct hnae3_handle *handle, bool enable)
 		handle->netdev_flags &= ~HNAE3_VLAN_FLTR;
 }
 
-static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, int vfid,
+static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 				    bool is_kill, u16 vlan, u8 qos,
 				    __be16 proto)
 {
@@ -8128,7 +8138,8 @@ static void hclge_get_mdix_mode(struct hnae3_handle *handle,
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 	struct phy_device *phydev = hdev->hw.mac.phydev;
-	int mdix_ctrl, mdix, retval, is_resolved;
+	int mdix_ctrl, mdix, is_resolved;
+	unsigned int retval;
 
 	if (!phydev) {
 		*tp_mdix_ctrl = ETH_TP_MDI_INVALID;
@@ -8855,7 +8866,8 @@ static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 	u16 tc_size[HCLGE_MAX_TC_NUM];
 	u16 roundup_size;
 	u32 *rss_indir;
-	int ret, i;
+	unsigned int i;
+	int ret;
 
 	kinfo->req_rss_size = new_tqps_num;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 2189675..c55fd61 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -701,6 +701,17 @@ struct hclge_mac_tnl_stats {
 
 #define HCLGE_RESET_INTERVAL	(10 * HZ)
 
+#pragma pack(1)
+struct hclge_vf_vlan_cfg {
+	u8 mbx_cmd;
+	u8 subcode;
+	u8 is_kill;
+	u16 vlan;
+	u16 proto;
+};
+
+#pragma pack()
+
 /* For each bit of TCAM entry, it uses a pair of 'x' and
  * 'y' to indicate which value to match, like below:
  * ----------------------------------
@@ -924,7 +935,7 @@ struct hclge_vport {
 
 	u16 used_umv_num;
 
-	int vport_id;
+	u16 vport_id;
 	struct hclge_dev *back;  /* Back reference to associated dev */
 	struct hnae3_handle nic;
 	struct hnae3_handle roce;
@@ -986,7 +997,7 @@ int hclge_func_reset_cmd(struct hclge_dev *hdev, int func_id);
 int hclge_vport_start(struct hclge_vport *vport);
 void hclge_vport_stop(struct hclge_vport *vport);
 int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu);
-int hclge_dbg_run_cmd(struct hnae3_handle *handle, char *cmd_buf);
+int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf);
 u16 hclge_covert_handle_qid_global(struct hnae3_handle *handle, u16 queue_id);
 int hclge_notify_client(struct hclge_dev *hdev,
 			enum hnae3_reset_notify_type type);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 64578e9..9adeba9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -306,21 +306,23 @@ int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
 static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 				 struct hclge_mbx_vf_to_pf_cmd *mbx_req)
 {
+	struct hclge_vf_vlan_cfg *msg_cmd;
 	int status = 0;
 
-	if (mbx_req->msg[1] == HCLGE_MBX_VLAN_FILTER) {
+	msg_cmd = (struct hclge_vf_vlan_cfg *)mbx_req->msg;
+	if (msg_cmd->subcode == HCLGE_MBX_VLAN_FILTER) {
 		struct hnae3_handle *handle = &vport->nic;
 		u16 vlan, proto;
 		bool is_kill;
 
-		is_kill = !!mbx_req->msg[2];
-		memcpy(&vlan, &mbx_req->msg[3], sizeof(vlan));
-		memcpy(&proto, &mbx_req->msg[5], sizeof(proto));
+		is_kill = !!msg_cmd->is_kill;
+		vlan =  msg_cmd->vlan;
+		proto =  msg_cmd->proto;
 		status = hclge_set_vlan_filter(handle, cpu_to_be16(proto),
 					       vlan, is_kill);
-	} else if (mbx_req->msg[1] == HCLGE_MBX_VLAN_RX_OFF_CFG) {
+	} else if (msg_cmd->subcode == HCLGE_MBX_VLAN_RX_OFF_CFG) {
 		struct hnae3_handle *handle = &vport->nic;
-		bool en = mbx_req->msg[2] ? true : false;
+		bool en = msg_cmd->is_kill ? true : false;
 
 		status = hclge_en_hw_strip_rxvtag(handle, en);
 	} else if (mbx_req->msg[1] == HCLGE_MBX_PORT_BASE_VLAN_CFG) {
@@ -363,7 +365,8 @@ static int hclge_get_vf_tcinfo(struct hclge_vport *vport,
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
 	u8 vf_tc_map = 0;
-	int i, ret;
+	unsigned int i;
+	int ret;
 
 	for (i = 0; i < kinfo->num_tc; i++)
 		vf_tc_map |= BIT(i);
@@ -551,7 +554,8 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 	struct hclge_mbx_vf_to_pf_cmd *req;
 	struct hclge_vport *vport;
 	struct hclge_desc *desc;
-	int ret, flag;
+	unsigned int flag;
+	int ret;
 
 	/* handle all the mailbox requests in the queue */
 	while (!hclge_cmd_crq_empty(&hdev->hw)) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 1e81348..d906d09 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -55,9 +55,9 @@ static int hclge_mdio_write(struct mii_bus *bus, int phyid, int regnum,
 	mdio_cmd = (struct hclge_mdio_cfg_cmd *)desc.data;
 
 	hnae3_set_field(mdio_cmd->phyid, HCLGE_MDIO_PHYID_M,
-			HCLGE_MDIO_PHYID_S, phyid);
+			HCLGE_MDIO_PHYID_S, (u32)phyid);
 	hnae3_set_field(mdio_cmd->phyad, HCLGE_MDIO_PHYREG_M,
-			HCLGE_MDIO_PHYREG_S, regnum);
+			HCLGE_MDIO_PHYREG_S, (u32)regnum);
 
 	hnae3_set_bit(mdio_cmd->ctrl_bit, HCLGE_MDIO_CTRL_START_B, 1);
 	hnae3_set_field(mdio_cmd->ctrl_bit, HCLGE_MDIO_CTRL_ST_M,
@@ -93,9 +93,9 @@ static int hclge_mdio_read(struct mii_bus *bus, int phyid, int regnum)
 	mdio_cmd = (struct hclge_mdio_cfg_cmd *)desc.data;
 
 	hnae3_set_field(mdio_cmd->phyid, HCLGE_MDIO_PHYID_M,
-			HCLGE_MDIO_PHYID_S, phyid);
+			HCLGE_MDIO_PHYID_S, (u32)phyid);
 	hnae3_set_field(mdio_cmd->phyad, HCLGE_MDIO_PHYREG_M,
-			HCLGE_MDIO_PHYREG_S, regnum);
+			HCLGE_MDIO_PHYREG_S, (u32)regnum);
 
 	hnae3_set_bit(mdio_cmd->ctrl_bit, HCLGE_MDIO_CTRL_START_B, 1);
 	hnae3_set_field(mdio_cmd->ctrl_bit, HCLGE_MDIO_CTRL_ST_M,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index fa28141..9edae5f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -976,7 +976,7 @@ static int hclge_tm_ets_tc_dwrr_cfg(struct hclge_dev *hdev)
 
 	struct hclge_ets_tc_weight_cmd *ets_weight;
 	struct hclge_desc desc;
-	int i;
+	unsigned int i;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_ETS_TC_WEIGHT, false);
 	ets_weight = (struct hclge_ets_tc_weight_cmd *)desc.data;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index b98ab97..270447e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -382,7 +382,7 @@ static int hclgevf_knic_setup(struct hclgevf_dev *hdev)
 	struct hnae3_handle *nic = &hdev->nic;
 	struct hnae3_knic_private_info *kinfo;
 	u16 new_tqps = hdev->num_tqps;
-	int i;
+	unsigned int i;
 
 	kinfo = &nic->kinfo;
 	kinfo->num_tc = 0;
@@ -540,8 +540,8 @@ static int hclgevf_set_rss_algo_key(struct hclgevf_dev *hdev,
 				    const u8 hfunc, const u8 *key)
 {
 	struct hclgevf_rss_config_cmd *req;
+	unsigned int key_offset = 0;
 	struct hclgevf_desc desc;
-	int key_offset = 0;
 	int key_counts;
 	int key_size;
 	int ret;
@@ -626,7 +626,7 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 	struct hclgevf_desc desc;
 	u16 roundup_size;
 	int status;
-	int i;
+	unsigned int i;
 
 	req = (struct hclgevf_rss_tc_mode_cmd *)desc.data;
 
@@ -1129,7 +1129,7 @@ static int hclgevf_set_promisc_mode(struct hclgevf_dev *hdev, bool en_bc_pmc)
 	return hclgevf_cmd_set_promisc_mode(hdev, en_bc_pmc);
 }
 
-static int hclgevf_tqp_enable(struct hclgevf_dev *hdev, int tqp_id,
+static int hclgevf_tqp_enable(struct hclgevf_dev *hdev, unsigned int tqp_id,
 			      int stream_id, bool enable)
 {
 	struct hclgevf_cfg_com_tqp_queue_cmd *req;
@@ -1142,7 +1142,8 @@ static int hclgevf_tqp_enable(struct hclgevf_dev *hdev, int tqp_id,
 				     false);
 	req->tqp_id = cpu_to_le16(tqp_id & HCLGEVF_RING_ID_MASK);
 	req->stream_id = cpu_to_le16(stream_id);
-	req->enable |= enable << HCLGEVF_TQP_ENABLE_B;
+	if (enable)
+		req->enable |= 1U << HCLGEVF_TQP_ENABLE_B;
 
 	status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
-- 
2.7.4

