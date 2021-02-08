Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9B0313165
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhBHLu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:50:59 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12598 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhBHLqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:46:39 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZ3vT1lk5z165Pw;
        Mon,  8 Feb 2021 19:39:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:40:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/12] net: hns3: clean up unnecessary parentheses in macro definitions
Date:   Mon, 8 Feb 2021 19:39:35 +0800
Message-ID: <1612784382-27262-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
References: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

In macro definitions, parentheses are unnecessary in some cases,
such as the calling parameter of a function, the left variable
of the equal sign, and so on. So remove these unnecessary
parentheses according to these rules.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h              |  6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c          |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h          | 10 +++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h   |  4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h  |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h    |  6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h |  4 ++--
 8 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 12548809..e9e60a9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -272,7 +272,7 @@ struct hnae3_ring_chain_node {
 };
 
 #define HNAE3_IS_TX_RING(node) \
-	(((node)->flag & (1 << HNAE3_RING_TYPE_B)) == HNAE3_RING_TYPE_TX)
+	(((node)->flag & 1 << HNAE3_RING_TYPE_B) == HNAE3_RING_TYPE_TX)
 
 /* device specification info from firmware */
 struct hnae3_dev_specs {
@@ -775,9 +775,9 @@ struct hnae3_handle {
 #define hnae3_get_field(origin, mask, shift) (((origin) & (mask)) >> (shift))
 
 #define hnae3_set_bit(origin, shift, val) \
-	hnae3_set_field((origin), (0x1 << (shift)), (shift), (val))
+	hnae3_set_field(origin, 0x1 << (shift), shift, val)
 #define hnae3_get_bit(origin, shift) \
-	hnae3_get_field((origin), (0x1 << (shift)), (shift))
+	hnae3_get_field(origin, 0x1 << (shift), shift)
 
 #define HNAE3_DBG_TM_NODES		"tm_nodes"
 #define HNAE3_DBG_TM_PRI		"tm_priority"
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4c10b87..e544fe3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -32,7 +32,7 @@
 #define CREATE_TRACE_POINTS
 #include "hns3_trace.h"
 
-#define hns3_set_field(origin, shift, val)	((origin) |= ((val) << (shift)))
+#define hns3_set_field(origin, shift, val)	((origin) |= (val) << (shift))
 #define hns3_tx_bd_count(S)	DIV_ROUND_UP(S, HNS3_MAX_BD_SIZE)
 
 #define hns3_rl_err(fmt, ...)						\
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index d70af1d..7435a83 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -554,7 +554,7 @@ static inline void hns3_write_reg(void __iomem *base, u32 reg, u32 value)
 }
 
 #define hns3_read_dev(a, reg) \
-	hns3_read_reg((a)->io_base, (reg))
+	hns3_read_reg((a)->io_base, reg)
 
 static inline bool hns3_nic_resetting(struct net_device *netdev)
 {
@@ -564,7 +564,7 @@ static inline bool hns3_nic_resetting(struct net_device *netdev)
 }
 
 #define hns3_write_dev(a, reg, value) \
-	hns3_write_reg((a)->io_base, (reg), (value))
+	hns3_write_reg((a)->io_base, reg, value)
 
 #define ring_to_dev(ring) ((ring)->dev)
 
@@ -588,15 +588,15 @@ static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
 
 /* iterator for handling rings in ring group */
 #define hns3_for_each_ring(pos, head) \
-	for (pos = (head).ring; pos; pos = pos->next)
+	for (pos = (head).ring; (pos); pos = (pos)->next)
 
 #define hns3_get_handle(ndev) \
 	(((struct hns3_nic_priv *)netdev_priv(ndev))->ae_handle)
 
-#define hns3_gl_usec_to_reg(int_gl) (int_gl >> 1)
+#define hns3_gl_usec_to_reg(int_gl) ((int_gl) >> 1)
 #define hns3_gl_round_down(int_gl) round_down(int_gl, 2)
 
-#define hns3_rl_usec_to_reg(int_rl) (int_rl >> 2)
+#define hns3_rl_usec_to_reg(int_rl) ((int_rl) >> 2)
 #define hns3_rl_round_down(int_rl) round_down(int_rl, 4)
 
 void hns3_ethtool_set_ops(struct net_device *netdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index e7c915e..ff52a65 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1144,9 +1144,9 @@ static inline void hclge_write_reg(void __iomem *base, u32 reg, u32 value)
 }
 
 #define hclge_write_dev(a, reg, value) \
-	hclge_write_reg((a)->io_base, (reg), (value))
+	hclge_write_reg((a)->io_base, reg, value)
 #define hclge_read_dev(a, reg) \
-	hclge_read_reg((a)->io_base, (reg))
+	hclge_read_reg((a)->io_base, reg)
 
 static inline u32 hclge_read_reg(u8 __iomem *base, u32 reg)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 037df35..b27203e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -24,7 +24,7 @@
 #include "hnae3.h"
 
 #define HCLGE_NAME			"hclge"
-#define HCLGE_STATS_READ(p, offset) (*((u64 *)((u8 *)(p) + (offset))))
+#define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
 #define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
 
 #define HCLGE_BUF_SIZE_UNIT	256U
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 33b17a1..0d86c4d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -728,7 +728,7 @@ struct hclge_vf_vlan_cfg {
  *	x = (~k) & v
  *	y = (k ^ ~v) & k
  */
-#define calc_x(x, k, v) ((x) = (~(k) & (v)))
+#define calc_x(x, k, v) (x = ~(k) & (v))
 #define calc_y(y, k, v) \
 	do { \
 		const typeof(k) _k_ = (k); \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index d33cb04..b25d760 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -17,7 +17,7 @@
 
 /* SP or DWRR */
 #define HCLGE_TM_TX_SCHD_DWRR_MSK	BIT(0)
-#define HCLGE_TM_TX_SCHD_SP_MSK		(0xFE)
+#define HCLGE_TM_TX_SCHD_SP_MSK		0xFE
 
 #define HCLGE_ETHER_MAX_RATE	100000
 
@@ -214,8 +214,8 @@ struct hclge_pri_shaper_para {
 			   (HCLGE_TM_SHAP_##string##_MSK), \
 			   (HCLGE_TM_SHAP_##string##_LSH), val)
 #define hclge_tm_get_field(src, string) \
-			hnae3_get_field((src), (HCLGE_TM_SHAP_##string##_MSK), \
-				       (HCLGE_TM_SHAP_##string##_LSH))
+			hnae3_get_field((src), HCLGE_TM_SHAP_##string##_MSK, \
+					HCLGE_TM_SHAP_##string##_LSH)
 
 int hclge_tm_schd_init(struct hclge_dev *hdev);
 int hclge_tm_vport_map_update(struct hclge_dev *hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index ac2864a..cb619cc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -315,9 +315,9 @@ static inline u32 hclgevf_read_reg(u8 __iomem *base, u32 reg)
 }
 
 #define hclgevf_write_dev(a, reg, value) \
-	hclgevf_write_reg((a)->io_base, (reg), (value))
+	hclgevf_write_reg((a)->io_base, reg, value)
 #define hclgevf_read_dev(a, reg) \
-	hclgevf_read_reg((a)->io_base, (reg))
+	hclgevf_read_reg((a)->io_base, reg)
 
 #define HCLGEVF_SEND_SYNC(flag) \
 	((flag) & HCLGEVF_CMD_FLAG_NO_INTR)
-- 
2.7.4

