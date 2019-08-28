Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B8FA04DE
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfH1O0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:26:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50140 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726858AbfH1OZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:44 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1B403C668089192C9D17;
        Wed, 28 Aug 2019 22:25:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:31 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Zhongzhu Liu <liuzhongzhu@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/12] net: hns3: optimize some log printings
Date:   Wed, 28 Aug 2019 22:23:09 +0800
Message-ID: <1567002196-63242-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

To better identify abnormal conditions, this patch modifies or
adds some logs to show driver status more accurately.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Zhongzhu Liu <liuzhongzhu@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 25 +++++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 32 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  2 +-
 3 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 7070d25..5cf4c1e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -39,7 +39,7 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 
 	if (queue_num >= h->kinfo.num_tqps) {
 		dev_err(&h->pdev->dev,
-			"Queue number(%u) is out of range(%u)\n", queue_num,
+			"Queue number(%u) is out of range(0-%u)\n", queue_num,
 			h->kinfo.num_tqps - 1);
 		return -EINVAL;
 	}
@@ -177,7 +177,7 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	}
 
 	if (q_num >= h->kinfo.num_tqps) {
-		dev_err(dev, "Queue number(%u) is out of range(%u)\n", q_num,
+		dev_err(dev, "Queue number(%u) is out of range(0-%u)\n", q_num,
 			h->kinfo.num_tqps - 1);
 		return -EINVAL;
 	}
@@ -188,14 +188,14 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	tx_index = (cnt == 1) ? value : tx_index;
 
 	if (tx_index >= ring->desc_num) {
-		dev_err(dev, "bd index (%u) is out of range(%u)\n", tx_index,
+		dev_err(dev, "bd index(%u) is out of range(0-%u)\n", tx_index,
 			ring->desc_num - 1);
 		return -EINVAL;
 	}
 
 	tx_desc = &ring->desc[tx_index];
 	dev_info(dev, "TX Queue Num: %u, BD Index: %u\n", q_num, tx_index);
-	dev_info(dev, "(TX) addr: 0x%llx\n", tx_desc->addr);
+	dev_info(dev, "(TX)addr: 0x%llx\n", tx_desc->addr);
 	dev_info(dev, "(TX)vlan_tag: %u\n", tx_desc->tx.vlan_tag);
 	dev_info(dev, "(TX)send_size: %u\n", tx_desc->tx.send_size);
 	dev_info(dev, "(TX)vlan_tso: %u\n", tx_desc->tx.type_cs_vlan_tso);
@@ -219,6 +219,7 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 
 	dev_info(dev, "RX Queue Num: %u, BD Index: %u\n", q_num, rx_index);
 	dev_info(dev, "(RX)addr: 0x%llx\n", rx_desc->addr);
+	dev_info(dev, "(RX)l234_info: %u\n", rx_desc->rx.l234_info);
 	dev_info(dev, "(RX)pkt_len: %u\n", rx_desc->rx.pkt_len);
 	dev_info(dev, "(RX)size: %u\n", rx_desc->rx.size);
 	dev_info(dev, "(RX)rss_hash: %u\n", rx_desc->rx.rss_hash);
@@ -238,16 +239,16 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	char printf_buf[HNS3_DBG_BUF_LEN];
 
 	dev_info(&h->pdev->dev, "available commands\n");
-	dev_info(&h->pdev->dev, "queue info [number]\n");
+	dev_info(&h->pdev->dev, "queue info <number>\n");
 	dev_info(&h->pdev->dev, "queue map\n");
-	dev_info(&h->pdev->dev, "bd info [q_num] <bd index>\n");
+	dev_info(&h->pdev->dev, "bd info <q_num> <bd index>\n");
 
 	if (!hns3_is_phys_func(h->pdev))
 		return;
 
 	dev_info(&h->pdev->dev, "dump fd tcam\n");
 	dev_info(&h->pdev->dev, "dump tc\n");
-	dev_info(&h->pdev->dev, "dump tm map [q_num]\n");
+	dev_info(&h->pdev->dev, "dump tm map <q_num>\n");
 	dev_info(&h->pdev->dev, "dump tm\n");
 	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 	dev_info(&h->pdev->dev, "dump qos pri map\n");
@@ -259,20 +260,20 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 
 	memset(printf_buf, 0, HNS3_DBG_BUF_LEN);
-	strncat(printf_buf, "dump reg [[bios common] [ssu <prt_id>]",
+	strncat(printf_buf, "dump reg [[bios common] [ssu <port_id>]",
 		HNS3_DBG_BUF_LEN - 1);
 	strncat(printf_buf + strlen(printf_buf),
-		" [igu egu <prt_id>] [rpu <tc_queue_num>]",
+		" [igu egu <port_id>] [rpu <tc_queue_num>]",
 		HNS3_DBG_BUF_LEN - strlen(printf_buf) - 1);
 	strncat(printf_buf + strlen(printf_buf),
-		" [rtc] [ppp] [rcb] [tqp <q_num>]]\n",
+		" [rtc] [ppp] [rcb] [tqp <queue_num>]]\n",
 		HNS3_DBG_BUF_LEN - strlen(printf_buf) - 1);
 	dev_info(&h->pdev->dev, "%s", printf_buf);
 
 	memset(printf_buf, 0, HNS3_DBG_BUF_LEN);
-	strncat(printf_buf, "dump reg dcb [port_id] [pri_id] [pg_id]",
+	strncat(printf_buf, "dump reg dcb <port_id> <pri_id> <pg_id>",
 		HNS3_DBG_BUF_LEN - 1);
-	strncat(printf_buf + strlen(printf_buf), " [rq_id] [nq_id] [qset_id]\n",
+	strncat(printf_buf + strlen(printf_buf), " <rq_id> <nq_id> <qset_id>\n",
 		HNS3_DBG_BUF_LEN - strlen(printf_buf) - 1);
 	dev_info(&h->pdev->dev, "%s", printf_buf);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 0639250..1debe37 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -83,7 +83,7 @@ static int hclge_dbg_get_dfx_bd_num(struct hclge_dev *hdev, int offset)
 	ret = hclge_query_bd_num_cmd_send(hdev, desc);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"get dfx bdnum fail, status is %d.\n", ret);
+			"get dfx bdnum fail, ret = %d\n", ret);
 		return ret;
 	}
 
@@ -110,12 +110,9 @@ static int hclge_dbg_cmd_send(struct hclge_dev *hdev,
 	}
 
 	ret = hclge_cmd_send(&hdev->hw, desc_src, bd_num);
-	if (ret) {
+	if (ret)
 		dev_err(&hdev->pdev->dev,
-			"read reg cmd send fail, status is %d.\n", ret);
-		return ret;
-	}
-
+			"cmd(0x%x) send fail, ret = %d\n", cmd, ret);
 	return ret;
 }
 
@@ -142,8 +139,11 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 	}
 
 	bd_num = hclge_dbg_get_dfx_bd_num(hdev, reg_msg->offset);
-	if (bd_num <= 0)
+	if (bd_num <= 0) {
+		dev_err(&hdev->pdev->dev, "get cmd(%d) bd num(%d) failed\n",
+			reg_msg->offset, bd_num);
 		return;
+	}
 
 	buf_len	 = sizeof(struct hclge_desc) * bd_num;
 	desc_src = kzalloc(buf_len, GFP_KERNEL);
@@ -331,7 +331,7 @@ static void hclge_dbg_dump_tc(struct hclge_dev *hdev)
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
-		dev_err(&hdev->pdev->dev, "dump tc fail, status is %d.\n", ret);
+		dev_err(&hdev->pdev->dev, "dump tc fail, ret = %d\n", ret);
 		return;
 	}
 
@@ -433,7 +433,7 @@ static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
 	return;
 
 err_tm_pg_cmd_send:
-	dev_err(&hdev->pdev->dev, "dump tm_pg fail(0x%x), status is %d\n",
+	dev_err(&hdev->pdev->dev, "dump tm_pg fail(0x%x), ret = %d\n",
 		cmd, ret);
 }
 
@@ -545,7 +545,7 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 	return;
 
 err_tm_cmd_send:
-	dev_err(&hdev->pdev->dev, "dump tm fail(0x%x), status is %d\n",
+	dev_err(&hdev->pdev->dev, "dump tm fail(0x%x), ret = %d\n",
 		cmd, ret);
 }
 
@@ -634,7 +634,7 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 	return;
 
 err_tm_map_cmd_send:
-	dev_err(&hdev->pdev->dev, "dump tqp map fail(0x%x), status is %d\n",
+	dev_err(&hdev->pdev->dev, "dump tqp map fail(0x%x), ret = %d\n",
 		cmd, ret);
 }
 
@@ -648,7 +648,7 @@ static void hclge_dbg_dump_qos_pause_cfg(struct hclge_dev *hdev)
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
-		dev_err(&hdev->pdev->dev, "dump checksum fail, status is %d.\n",
+		dev_err(&hdev->pdev->dev, "dump checksum fail, ret = %d\n",
 			ret);
 		return;
 	}
@@ -672,7 +672,7 @@ static void hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev)
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"dump qos pri map fail, status is %d.\n", ret);
+			"dump qos pri map fail, ret = %d\n", ret);
 		return;
 	}
 
@@ -805,7 +805,7 @@ static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
 
 err_qos_cmd_send:
 	dev_err(&hdev->pdev->dev,
-		"dump qos buf cfg fail(0x%x), status is %d\n", cmd, ret);
+		"dump qos buf cfg fail(0x%x), ret = %d\n", cmd, ret);
 }
 
 static void hclge_dbg_dump_mng_table(struct hclge_dev *hdev)
@@ -963,7 +963,7 @@ void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"get firmware statistics bd number failed, ret=%d\n",
+			"get firmware statistics bd number failed, ret = %d\n",
 			ret);
 		return;
 	}
@@ -984,7 +984,7 @@ void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
 	if (ret) {
 		kfree(desc_src);
 		dev_err(&hdev->pdev->dev,
-			"get firmware statistics failed, ret=%d\n", ret);
+			"get firmware statistics failed, ret = %d\n", ret);
 		return;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fa85d9e..8a5b81d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7237,7 +7237,7 @@ static int hclge_set_mac_addr(struct hnae3_handle *handle, void *p,
 	    is_broadcast_ether_addr(new_addr) ||
 	    is_multicast_ether_addr(new_addr)) {
 		dev_err(&hdev->pdev->dev,
-			"Change uc mac err! invalid mac:%p.\n",
+			"Change uc mac err! invalid mac:%pM.\n",
 			 new_addr);
 		return -EINVAL;
 	}
-- 
2.7.4

