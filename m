Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9D9EAEC6
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfJaLXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:23:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5661 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726540AbfJaLXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:23:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F15F7668FCB8FCBEF37E;
        Thu, 31 Oct 2019 19:22:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 19:22:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 8/9] net: hns3: cleanup some print format warning
Date:   Thu, 31 Oct 2019 19:23:23 +0800
Message-ID: <1572521004-36126-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
References: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

Using '%d' for printing type unsigned int or '%u' for
type int would cause static tools to give false warnings,
so this patch cleanups this warning by using the suitable
format specifier of the type of variable.

BTW, modifies the type of some variables and macro to
synchronize with their usage.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 30 ++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 20 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 12 ++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 78 +++++++++++-----------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 12 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 16 ++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   | 18 ++---
 14 files changed, 101 insertions(+), 101 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index cb45c7d..1b03139 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -72,7 +72,7 @@ enum hclge_mbx_vlan_cfg_subcode {
 };
 
 #define HCLGE_MBX_MAX_MSG_SIZE	16
-#define HCLGE_MBX_MAX_RESP_DATA_SIZE	8
+#define HCLGE_MBX_MAX_RESP_DATA_SIZE	8U
 #define HCLGE_MBX_RING_MAP_BASIC_MSG_NUM	3
 #define HCLGE_MBX_RING_NODE_VARIABLE_NUM	3
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index fe5bc6f..466a6e3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -57,68 +57,68 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 					   HNS3_RING_RX_RING_BASEADDR_H_REG);
 		base_add_l = readl_relaxed(ring->tqp->io_base +
 					   HNS3_RING_RX_RING_BASEADDR_L_REG);
-		dev_info(&h->pdev->dev, "RX(%d) BASE ADD: 0x%08x%08x\n", i,
+		dev_info(&h->pdev->dev, "RX(%u) BASE ADD: 0x%08x%08x\n", i,
 			 base_add_h, base_add_l);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_RX_RING_BD_NUM_REG);
-		dev_info(&h->pdev->dev, "RX(%d) RING BD NUM: %u\n", i, value);
+		dev_info(&h->pdev->dev, "RX(%u) RING BD NUM: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_RX_RING_BD_LEN_REG);
-		dev_info(&h->pdev->dev, "RX(%d) RING BD LEN: %u\n", i, value);
+		dev_info(&h->pdev->dev, "RX(%u) RING BD LEN: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_RX_RING_TAIL_REG);
-		dev_info(&h->pdev->dev, "RX(%d) RING TAIL: %u\n", i, value);
+		dev_info(&h->pdev->dev, "RX(%u) RING TAIL: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_RX_RING_HEAD_REG);
-		dev_info(&h->pdev->dev, "RX(%d) RING HEAD: %u\n", i, value);
+		dev_info(&h->pdev->dev, "RX(%u) RING HEAD: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_RX_RING_FBDNUM_REG);
-		dev_info(&h->pdev->dev, "RX(%d) RING FBDNUM: %u\n", i, value);
+		dev_info(&h->pdev->dev, "RX(%u) RING FBDNUM: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_RX_RING_PKTNUM_RECORD_REG);
-		dev_info(&h->pdev->dev, "RX(%d) RING PKTNUM: %u\n", i, value);
+		dev_info(&h->pdev->dev, "RX(%u) RING PKTNUM: %u\n", i, value);
 
 		ring = &priv->ring[i];
 		base_add_h = readl_relaxed(ring->tqp->io_base +
 					   HNS3_RING_TX_RING_BASEADDR_H_REG);
 		base_add_l = readl_relaxed(ring->tqp->io_base +
 					   HNS3_RING_TX_RING_BASEADDR_L_REG);
-		dev_info(&h->pdev->dev, "TX(%d) BASE ADD: 0x%08x%08x\n", i,
+		dev_info(&h->pdev->dev, "TX(%u) BASE ADD: 0x%08x%08x\n", i,
 			 base_add_h, base_add_l);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_TX_RING_BD_NUM_REG);
-		dev_info(&h->pdev->dev, "TX(%d) RING BD NUM: %u\n", i, value);
+		dev_info(&h->pdev->dev, "TX(%u) RING BD NUM: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_TX_RING_TC_REG);
-		dev_info(&h->pdev->dev, "TX(%d) RING TC: %u\n", i, value);
+		dev_info(&h->pdev->dev, "TX(%u) RING TC: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_TX_RING_TAIL_REG);
-		dev_info(&h->pdev->dev, "TX(%d) RING TAIL: %u\n", i, value);
+		dev_info(&h->pdev->dev, "TX(%u) RING TAIL: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_TX_RING_HEAD_REG);
-		dev_info(&h->pdev->dev, "TX(%d) RING HEAD: %u\n", i, value);
+		dev_info(&h->pdev->dev, "TX(%u) RING HEAD: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_TX_RING_FBDNUM_REG);
-		dev_info(&h->pdev->dev, "TX(%d) RING FBDNUM: %u\n", i, value);
+		dev_info(&h->pdev->dev, "TX(%u) RING FBDNUM: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_TX_RING_OFFSET_REG);
-		dev_info(&h->pdev->dev, "TX(%d) RING OFFSET: %u\n", i, value);
+		dev_info(&h->pdev->dev, "TX(%u) RING OFFSET: %u\n", i, value);
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_TX_RING_PKTNUM_RECORD_REG);
-		dev_info(&h->pdev->dev, "TX(%d) RING PKTNUM: %u\n\n", i,
+		dev_info(&h->pdev->dev, "TX(%u) RING PKTNUM: %u\n\n", i,
 			 value);
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 82ed9c4..d5a121a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2002,7 +2002,7 @@ bool hns3_is_phys_func(struct pci_dev *pdev)
 	case HNAE3_DEV_ID_100G_RDMA_DCB_PFC_VF:
 		return false;
 	default:
-		dev_warn(&pdev->dev, "un-recognized pci device-id %d",
+		dev_warn(&pdev->dev, "un-recognized pci device-id %u",
 			 dev_id);
 	}
 
@@ -3939,14 +3939,14 @@ static void hns3_info_show(struct hns3_nic_priv *priv)
 	struct hnae3_knic_private_info *kinfo = &priv->ae_handle->kinfo;
 
 	dev_info(priv->dev, "MAC address: %pM\n", priv->netdev->dev_addr);
-	dev_info(priv->dev, "Task queue pairs numbers: %d\n", kinfo->num_tqps);
-	dev_info(priv->dev, "RSS size: %d\n", kinfo->rss_size);
-	dev_info(priv->dev, "Allocated RSS size: %d\n", kinfo->req_rss_size);
-	dev_info(priv->dev, "RX buffer length: %d\n", kinfo->rx_buf_len);
-	dev_info(priv->dev, "Desc num per TX queue: %d\n", kinfo->num_tx_desc);
-	dev_info(priv->dev, "Desc num per RX queue: %d\n", kinfo->num_rx_desc);
-	dev_info(priv->dev, "Total number of enabled TCs: %d\n", kinfo->num_tc);
-	dev_info(priv->dev, "Max mtu size: %d\n", priv->netdev->max_mtu);
+	dev_info(priv->dev, "Task queue pairs numbers: %u\n", kinfo->num_tqps);
+	dev_info(priv->dev, "RSS size: %u\n", kinfo->rss_size);
+	dev_info(priv->dev, "Allocated RSS size: %u\n", kinfo->req_rss_size);
+	dev_info(priv->dev, "RX buffer length: %u\n", kinfo->rx_buf_len);
+	dev_info(priv->dev, "Desc num per TX queue: %u\n", kinfo->num_tx_desc);
+	dev_info(priv->dev, "Desc num per RX queue: %u\n", kinfo->num_rx_desc);
+	dev_info(priv->dev, "Total number of enabled TCs: %u\n", kinfo->num_tc);
+	dev_info(priv->dev, "Max mtu size: %u\n", priv->netdev->max_mtu);
 }
 
 static int hns3_client_init(struct hnae3_handle *handle)
@@ -4566,7 +4566,7 @@ int hns3_set_channels(struct net_device *netdev,
 	if (new_tqp_num > hns3_get_max_available_channels(h) ||
 	    new_tqp_num < 1) {
 		dev_err(&netdev->dev,
-			"Change tqps fail, the tqp range is from 1 to %d",
+			"Change tqps fail, the tqp range is from 1 to %u",
 			hns3_get_max_available_channels(h));
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 50b07b9..b104d3c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -985,7 +985,7 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	}
 
 	netdev_info(ndev,
-		    "Changing Tx/Rx ring depth from %d/%d to %d/%d\n",
+		    "Changing Tx/Rx ring depth from %u/%u to %u/%u\n",
 		    old_tx_desc_num, old_rx_desc_num,
 		    new_tx_desc_num, new_rx_desc_num);
 
@@ -1097,7 +1097,7 @@ static int hns3_get_coalesce_per_queue(struct net_device *netdev, u32 queue,
 
 	if (queue >= queue_num) {
 		netdev_err(netdev,
-			   "Invalid queue value %d! Queue max id=%d\n",
+			   "Invalid queue value %u! Queue max id=%u\n",
 			   queue, queue_num - 1);
 		return -EINVAL;
 	}
@@ -1147,14 +1147,14 @@ static int hns3_check_gl_coalesce_para(struct net_device *netdev,
 	rx_gl = hns3_gl_round_down(cmd->rx_coalesce_usecs);
 	if (rx_gl != cmd->rx_coalesce_usecs) {
 		netdev_info(netdev,
-			    "rx_usecs(%d) rounded down to %d, because it must be multiple of 2.\n",
+			    "rx_usecs(%u) rounded down to %u, because it must be multiple of 2.\n",
 			    cmd->rx_coalesce_usecs, rx_gl);
 	}
 
 	tx_gl = hns3_gl_round_down(cmd->tx_coalesce_usecs);
 	if (tx_gl != cmd->tx_coalesce_usecs) {
 		netdev_info(netdev,
-			    "tx_usecs(%d) rounded down to %d, because it must be multiple of 2.\n",
+			    "tx_usecs(%u) rounded down to %u, because it must be multiple of 2.\n",
 			    cmd->tx_coalesce_usecs, tx_gl);
 	}
 
@@ -1182,7 +1182,7 @@ static int hns3_check_rl_coalesce_para(struct net_device *netdev,
 	rl = hns3_rl_round_down(cmd->rx_coalesce_usecs_high);
 	if (rl != cmd->rx_coalesce_usecs_high) {
 		netdev_info(netdev,
-			    "usecs_high(%d) rounded down to %d, because it must be multiple of 4.\n",
+			    "usecs_high(%u) rounded down to %u, because it must be multiple of 4.\n",
 			    cmd->rx_coalesce_usecs_high, rl);
 	}
 
@@ -1211,7 +1211,7 @@ static int hns3_check_coalesce_para(struct net_device *netdev,
 	if (cmd->use_adaptive_tx_coalesce == 1 ||
 	    cmd->use_adaptive_rx_coalesce == 1) {
 		netdev_info(netdev,
-			    "adaptive-tx=%d and adaptive-rx=%d, tx_usecs or rx_usecs will changed dynamically.\n",
+			    "adaptive-tx=%u and adaptive-rx=%u, tx_usecs or rx_usecs will changed dynamically.\n",
 			    cmd->use_adaptive_tx_coalesce,
 			    cmd->use_adaptive_rx_coalesce);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index c331146..940ead3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -145,7 +145,7 @@ static int hclge_cmd_csq_clean(struct hclge_hw *hw)
 	rmb(); /* Make sure head is ready before touch any data */
 
 	if (!is_valid_csq_clean_head(csq, head)) {
-		dev_warn(&hdev->pdev->dev, "wrong cmd head (%d, %d-%d)\n", head,
+		dev_warn(&hdev->pdev->dev, "wrong cmd head (%u, %d-%d)\n", head,
 			 csq->next_to_use, csq->next_to_clean);
 		dev_warn(&hdev->pdev->dev,
 			 "Disabling any further commands to IMP firmware\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index c063301..49ad848 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -87,7 +87,7 @@ static int hclge_dcb_common_validate(struct hclge_dev *hdev, u8 num_tc,
 	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++) {
 		if (prio_tc[i] >= num_tc) {
 			dev_err(&hdev->pdev->dev,
-				"prio_tc[%u] checking failed, %u >= num_tc(%u)\n",
+				"prio_tc[%d] checking failed, %u >= num_tc(%u)\n",
 				i, prio_tc[i], num_tc);
 			return -EINVAL;
 		}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 87dece0..dc66b4e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1747,7 +1747,7 @@ static void hclge_handle_over_8bd_err(struct hclge_dev *hdev,
 
 	if (vf_id) {
 		if (vf_id >= hdev->num_alloc_vport) {
-			dev_err(dev, "invalid vf id(%d)\n", vf_id);
+			dev_err(dev, "invalid vf id(%u)\n", vf_id);
 			return;
 		}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e578029..babec3b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1398,7 +1398,7 @@ static int hclge_configure(struct hclge_dev *hdev)
 
 	if ((hdev->tc_max > HNAE3_MAX_TC) ||
 	    (hdev->tc_max < 1)) {
-		dev_warn(&hdev->pdev->dev, "TC num = %d.\n",
+		dev_warn(&hdev->pdev->dev, "TC num = %u.\n",
 			 hdev->tc_max);
 		hdev->tc_max = 1;
 	}
@@ -1658,7 +1658,7 @@ static int hclge_alloc_vport(struct hclge_dev *hdev)
 	num_vport = hdev->num_vmdq_vport + hdev->num_req_vfs + 1;
 
 	if (hdev->num_tqps < num_vport) {
-		dev_err(&hdev->pdev->dev, "tqps(%d) is less than vports(%d)",
+		dev_err(&hdev->pdev->dev, "tqps(%u) is less than vports(%d)",
 			hdev->num_tqps, num_vport);
 		return -EINVAL;
 	}
@@ -2345,7 +2345,7 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 	}
 	if (vectors < hdev->num_msi)
 		dev_warn(&hdev->pdev->dev,
-			 "requested %d MSI/MSI-X, but allocated %d MSI/MSI-X\n",
+			 "requested %u MSI/MSI-X, but allocated %d MSI/MSI-X\n",
 			 hdev->num_msi, vectors);
 
 	hdev->num_msi = vectors;
@@ -3280,7 +3280,7 @@ static int hclge_reset_wait(struct hclge_dev *hdev)
 
 		if (!test_bit(HNAE3_FLR_DONE, &hdev->flr_state)) {
 			dev_err(&hdev->pdev->dev,
-				"flr wait timeout: %d\n", cnt);
+				"flr wait timeout: %u\n", cnt);
 			return -EBUSY;
 		}
 
@@ -3330,7 +3330,7 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 		ret = hclge_set_vf_rst(hdev, vport->vport_id, reset);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
-				"set vf(%d) rst failed %d!\n",
+				"set vf(%u) rst failed %d!\n",
 				vport->vport_id, ret);
 			return ret;
 		}
@@ -3345,7 +3345,7 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 		ret = hclge_inform_reset_assert_to_vf(vport);
 		if (ret)
 			dev_warn(&hdev->pdev->dev,
-				 "inform reset to vf(%d) failed %d!\n",
+				 "inform reset to vf(%u) failed %d!\n",
 				 vport->vport_id, ret);
 	}
 
@@ -3658,7 +3658,7 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 		hdev->rst_stats.reset_fail_cnt++;
 		set_bit(hdev->reset_type, &hdev->reset_pending);
 		dev_info(&hdev->pdev->dev,
-			 "re-schedule reset task(%d)\n",
+			 "re-schedule reset task(%u)\n",
 			 hdev->rst_stats.reset_fail_cnt);
 		return true;
 	}
@@ -4493,7 +4493,7 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 	 */
 	if (rss_size > HCLGE_RSS_TC_SIZE_7 || rss_size == 0) {
 		dev_err(&hdev->pdev->dev,
-			"Configure rss tc size failed, invalid TC_SIZE = %d\n",
+			"Configure rss tc size failed, invalid TC_SIZE = %u\n",
 			rss_size);
 		return -EINVAL;
 	}
@@ -4843,7 +4843,7 @@ static int hclge_init_fd_config(struct hclge_dev *hdev)
 		break;
 	default:
 		dev_err(&hdev->pdev->dev,
-			"Unsupported flow director mode %d\n",
+			"Unsupported flow director mode %u\n",
 			hdev->fd_cfg.fd_mode);
 		return -EOPNOTSUPP;
 	}
@@ -5173,7 +5173,7 @@ static int hclge_config_key(struct hclge_dev *hdev, u8 stage,
 				   true);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"fd key_y config fail, loc=%d, ret=%d\n",
+			"fd key_y config fail, loc=%u, ret=%d\n",
 			rule->queue_id, ret);
 		return ret;
 	}
@@ -5182,7 +5182,7 @@ static int hclge_config_key(struct hclge_dev *hdev, u8 stage,
 				   true);
 	if (ret)
 		dev_err(&hdev->pdev->dev,
-			"fd key_x config fail, loc=%d, ret=%d\n",
+			"fd key_x config fail, loc=%u, ret=%d\n",
 			rule->queue_id, ret);
 	return ret;
 }
@@ -5431,7 +5431,7 @@ static int hclge_fd_update_rule_list(struct hclge_dev *hdev,
 		}
 	} else if (!is_add) {
 		dev_err(&hdev->pdev->dev,
-			"delete fail, rule %d is inexistent\n",
+			"delete fail, rule %u is inexistent\n",
 			location);
 		return -EINVAL;
 	}
@@ -5671,7 +5671,7 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 
 		if (vf > hdev->num_req_vfs) {
 			dev_err(&hdev->pdev->dev,
-				"Error: vf id (%d) > max vf num (%d)\n",
+				"Error: vf id (%u) > max vf num (%u)\n",
 				vf, hdev->num_req_vfs);
 			return -EINVAL;
 		}
@@ -5681,7 +5681,7 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 
 		if (ring >= tqps) {
 			dev_err(&hdev->pdev->dev,
-				"Error: queue id (%d) > max tqp num (%d)\n",
+				"Error: queue id (%u) > max tqp num (%u)\n",
 				ring, tqps - 1);
 			return -EINVAL;
 		}
@@ -5817,7 +5817,7 @@ static int hclge_restore_fd_entries(struct hnae3_handle *handle)
 
 		if (ret) {
 			dev_warn(&hdev->pdev->dev,
-				 "Restore rule %d failed, remove it\n",
+				 "Restore rule %u failed, remove it\n",
 				 rule->location);
 			clear_bit(rule->location, hdev->fd_bmap);
 			hlist_del(&rule->rule_node);
@@ -6810,7 +6810,7 @@ static int hclge_get_mac_vlan_cmd_status(struct hclge_vport *vport,
 
 	if (cmdq_resp) {
 		dev_err(&hdev->pdev->dev,
-			"cmdq execute failed for get_mac_vlan_cmd_status,status=%d.\n",
+			"cmdq execute failed for get_mac_vlan_cmd_status,status=%u.\n",
 			cmdq_resp);
 		return -EIO;
 	}
@@ -7062,7 +7062,7 @@ static int hclge_init_umv_space(struct hclge_dev *hdev)
 
 	if (allocated_size < hdev->wanted_umv_size)
 		dev_warn(&hdev->pdev->dev,
-			 "Alloc umv space failed, want %d, get %d\n",
+			 "Alloc umv space failed, want %u, get %u\n",
 			 hdev->wanted_umv_size, allocated_size);
 
 	mutex_init(&hdev->umv_mutex);
@@ -7230,7 +7230,7 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
 
 	/* check if we just hit the duplicate */
 	if (!ret) {
-		dev_warn(&hdev->pdev->dev, "VF %d mac(%pM) exists\n",
+		dev_warn(&hdev->pdev->dev, "VF %u mac(%pM) exists\n",
 			 vport->vport_id, addr);
 		return 0;
 	}
@@ -7483,7 +7483,7 @@ static int hclge_get_mac_ethertype_cmd_status(struct hclge_dev *hdev,
 
 	if (cmdq_resp) {
 		dev_err(&hdev->pdev->dev,
-			"cmdq execute failed for get_mac_ethertype_cmd_status, status=%d.\n",
+			"cmdq execute failed for get_mac_ethertype_cmd_status, status=%u.\n",
 			cmdq_resp);
 		return -EIO;
 	}
@@ -7505,7 +7505,7 @@ static int hclge_get_mac_ethertype_cmd_status(struct hclge_dev *hdev,
 		break;
 	default:
 		dev_err(&hdev->pdev->dev,
-			"add mac ethertype failed for undefined, code=%d.\n",
+			"add mac ethertype failed for undefined, code=%u.\n",
 			resp_code);
 		return_status = -EIO;
 	}
@@ -7810,7 +7810,7 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 		}
 
 		dev_err(&hdev->pdev->dev,
-			"Add vf vlan filter fail, ret =%d.\n",
+			"Add vf vlan filter fail, ret =%u.\n",
 			req0->resp_code);
 	} else {
 #define HCLGE_VF_VLAN_DEL_NO_FOUND	1
@@ -7826,7 +7826,7 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 			return 0;
 
 		dev_err(&hdev->pdev->dev,
-			"Kill vf vlan filter fail, ret =%d.\n",
+			"Kill vf vlan filter fail, ret =%u.\n",
 			req0->resp_code);
 	}
 
@@ -7876,7 +7876,7 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 				       proto);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"Set %d vport vlan filter config fail, ret =%d.\n",
+			"Set %u vport vlan filter config fail, ret =%d.\n",
 			vport_id, ret);
 		return ret;
 	}
@@ -7888,7 +7888,7 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 
 	if (!is_kill && test_and_set_bit(vport_id, hdev->vlan_table[vlan_id])) {
 		dev_err(&hdev->pdev->dev,
-			"Add port vlan failed, vport %d is already in vlan %d\n",
+			"Add port vlan failed, vport %u is already in vlan %u\n",
 			vport_id, vlan_id);
 		return -EINVAL;
 	}
@@ -7896,7 +7896,7 @@ static int hclge_set_vlan_filter_hw(struct hclge_dev *hdev, __be16 proto,
 	if (is_kill &&
 	    !test_and_clear_bit(vport_id, hdev->vlan_table[vlan_id])) {
 		dev_err(&hdev->pdev->dev,
-			"Delete port vlan failed, vport %d is not in vlan %d\n",
+			"Delete port vlan failed, vport %u is not in vlan %u\n",
 			vport_id, vlan_id);
 		return -EINVAL;
 	}
@@ -8968,16 +8968,16 @@ static void hclge_info_show(struct hclge_dev *hdev)
 
 	dev_info(dev, "PF info begin:\n");
 
-	dev_info(dev, "Task queue pairs numbers: %d\n", hdev->num_tqps);
-	dev_info(dev, "Desc num per TX queue: %d\n", hdev->num_tx_desc);
-	dev_info(dev, "Desc num per RX queue: %d\n", hdev->num_rx_desc);
-	dev_info(dev, "Numbers of vports: %d\n", hdev->num_alloc_vport);
-	dev_info(dev, "Numbers of vmdp vports: %d\n", hdev->num_vmdq_vport);
-	dev_info(dev, "Numbers of VF for this PF: %d\n", hdev->num_req_vfs);
-	dev_info(dev, "HW tc map: %d\n", hdev->hw_tc_map);
-	dev_info(dev, "Total buffer size for TX/RX: %d\n", hdev->pkt_buf_size);
-	dev_info(dev, "TX buffer size for each TC: %d\n", hdev->tx_buf_size);
-	dev_info(dev, "DV buffer size for each TC: %d\n", hdev->dv_buf_size);
+	dev_info(dev, "Task queue pairs numbers: %u\n", hdev->num_tqps);
+	dev_info(dev, "Desc num per TX queue: %u\n", hdev->num_tx_desc);
+	dev_info(dev, "Desc num per RX queue: %u\n", hdev->num_rx_desc);
+	dev_info(dev, "Numbers of vports: %u\n", hdev->num_alloc_vport);
+	dev_info(dev, "Numbers of vmdp vports: %u\n", hdev->num_vmdq_vport);
+	dev_info(dev, "Numbers of VF for this PF: %u\n", hdev->num_req_vfs);
+	dev_info(dev, "HW tc map: 0x%x\n", hdev->hw_tc_map);
+	dev_info(dev, "Total buffer size for TX/RX: %u\n", hdev->pkt_buf_size);
+	dev_info(dev, "TX buffer size for each TC: %u\n", hdev->tx_buf_size);
+	dev_info(dev, "DV buffer size for each TC: %u\n", hdev->dv_buf_size);
 	dev_info(dev, "This is %s PF\n",
 		 hdev->flag & HCLGE_FLAG_MAIN ? "main" : "not main");
 	dev_info(dev, "DCB %s\n",
@@ -9293,7 +9293,7 @@ static void hclge_clear_resetting_state(struct hclge_dev *hdev)
 		ret = hclge_set_vf_rst(hdev, vport->vport_id, false);
 		if (ret)
 			dev_warn(&hdev->pdev->dev,
-				 "clear vf(%d) rst failed %d!\n",
+				 "clear vf(%u) rst failed %d!\n",
 				 vport->vport_id, ret);
 	}
 }
@@ -9914,8 +9914,8 @@ static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 	u16 tc_offset[HCLGE_MAX_TC_NUM] = {0};
 	struct hclge_dev *hdev = vport->back;
 	u16 tc_size[HCLGE_MAX_TC_NUM] = {0};
-	int cur_rss_size = kinfo->rss_size;
-	int cur_tqps = kinfo->num_tqps;
+	u16 cur_rss_size = kinfo->rss_size;
+	u16 cur_tqps = kinfo->num_tqps;
 	u16 tc_valid[HCLGE_MAX_TC_NUM];
 	u16 roundup_size;
 	u32 *rss_indir;
@@ -9969,7 +9969,7 @@ static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 out:
 	if (!ret)
 		dev_info(&hdev->pdev->dev,
-			 "Channels changed, rss_size from %d to %d, tqps from %d to %d",
+			 "Channels changed, rss_size from %u to %u, tqps from %u to %u",
 			 cur_rss_size, kinfo->rss_size,
 			 cur_tqps, kinfo->rss_size * kinfo->num_tc);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 088fc7c..0b433eb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -26,7 +26,7 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 
 	if (resp_data_len > HCLGE_MBX_MAX_RESP_DATA_SIZE) {
 		dev_err(&hdev->pdev->dev,
-			"PF fail to gen resp to VF len %d exceeds max len %d\n",
+			"PF fail to gen resp to VF len %u exceeds max len %u\n",
 			resp_data_len,
 			HCLGE_MBX_MAX_RESP_DATA_SIZE);
 		/* If resp_data_len is too long, set the value to max length
@@ -285,7 +285,7 @@ static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
 						 false, HCLGE_MAC_ADDR_UC);
 	} else {
 		dev_err(&hdev->pdev->dev,
-			"failed to set unicast mac addr, unknown subcode %d\n",
+			"failed to set unicast mac addr, unknown subcode %u\n",
 			mbx_req->msg[1]);
 		return -EIO;
 	}
@@ -319,7 +319,7 @@ static int hclge_set_vf_mc_mac_addr(struct hclge_vport *vport,
 						 false, HCLGE_MAC_ADDR_MC);
 	} else {
 		dev_err(&hdev->pdev->dev,
-			"failed to set mcast mac addr, unknown subcode %d\n",
+			"failed to set mcast mac addr, unknown subcode %u\n",
 			mbx_req->msg[1]);
 		return -EIO;
 	}
@@ -555,7 +555,7 @@ static void hclge_reset_vf(struct hclge_vport *vport,
 	struct hclge_dev *hdev = vport->back;
 	int ret;
 
-	dev_warn(&hdev->pdev->dev, "PF received VF reset request from VF %d!",
+	dev_warn(&hdev->pdev->dev, "PF received VF reset request from VF %u!",
 		 vport->vport_id);
 
 	ret = hclge_func_reset_cmd(hdev, vport->vport_id);
@@ -681,7 +681,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		flag = le16_to_cpu(crq->desc[crq->next_to_use].flag);
 		if (unlikely(!hnae3_get_bit(flag, HCLGE_CMDQ_RX_OUTVLD_B))) {
 			dev_warn(&hdev->pdev->dev,
-				 "dropped invalid mailbox message, code = %d\n",
+				 "dropped invalid mailbox message, code = %u\n",
 				 req->msg[0]);
 
 			/* dropping/not processing this invalid message */
@@ -828,7 +828,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			break;
 		default:
 			dev_err(&hdev->pdev->dev,
-				"un-supported mailbox message, code = %d\n",
+				"un-supported mailbox message, code = %u\n",
 				req->msg[0]);
 			break;
 		}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index dc4dfd4..696c5ae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -134,7 +134,7 @@ int hclge_mac_mdio_config(struct hclge_dev *hdev)
 			 "no phy device is connected to mdio bus\n");
 		return 0;
 	} else if (hdev->hw.mac.phy_addr >= PHY_MAX_ADDR) {
-		dev_err(&hdev->pdev->dev, "phy_addr(%d) is too large.\n",
+		dev_err(&hdev->pdev->dev, "phy_addr(%u) is too large.\n",
 			hdev->hw.mac.phy_addr);
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index b3c30e5..fbc39a2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -544,7 +544,7 @@ int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate)
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
-				"vf%d, qs%u failed to set tx_rate:%d, ret=%d\n",
+				"vf%u, qs%u failed to set tx_rate:%d, ret=%d\n",
 				vport->vport_id, shap_cfg_cmd->qs_id,
 				max_tx_rate, ret);
 			return ret;
@@ -575,7 +575,7 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	/* Set to user value, no larger than max_rss_size. */
 	if (kinfo->req_rss_size != kinfo->rss_size && kinfo->req_rss_size &&
 	    kinfo->req_rss_size <= max_rss_size) {
-		dev_info(&hdev->pdev->dev, "rss changes from %d to %d\n",
+		dev_info(&hdev->pdev->dev, "rss changes from %u to %u\n",
 			 kinfo->rss_size, kinfo->req_rss_size);
 		kinfo->rss_size = kinfo->req_rss_size;
 	} else if (kinfo->rss_size > max_rss_size ||
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index d261b5a..af2245e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -50,7 +50,7 @@ static int hclgevf_cmd_csq_clean(struct hclgevf_hw *hw)
 	rmb(); /* Make sure head is ready before touch any data */
 
 	if (!hclgevf_is_valid_csq_clean_head(csq, head)) {
-		dev_warn(&hdev->pdev->dev, "wrong cmd head (%d, %d-%d)\n", head,
+		dev_warn(&hdev->pdev->dev, "wrong cmd head (%u, %d-%d)\n", head,
 			 csq->next_to_use, csq->next_to_clean);
 		dev_warn(&hdev->pdev->dev,
 			 "Disabling any further commands to IMP firmware\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 9506d7d..25d78a5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1581,7 +1581,7 @@ static void hclgevf_reset_err_handle(struct hclgevf_dev *hdev)
 	/* recover handshake status with IMP when reset fail */
 	hclgevf_reset_handshake(hdev, true);
 	hdev->rst_stats.rst_fail_cnt++;
-	dev_err(&hdev->pdev->dev, "failed to reset VF(%d)\n",
+	dev_err(&hdev->pdev->dev, "failed to reset VF(%u)\n",
 		hdev->rst_stats.rst_fail_cnt);
 
 	if (hdev->rst_stats.rst_fail_cnt < HCLGEVF_RESET_MAX_FAIL_CNT)
@@ -2338,7 +2338,7 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
 	}
 	if (vectors < hdev->num_msi)
 		dev_warn(&hdev->pdev->dev,
-			 "requested %d MSI/MSI-X, but allocated %d MSI/MSI-X\n",
+			 "requested %u MSI/MSI-X, but allocated %d MSI/MSI-X\n",
 			 hdev->num_msi, vectors);
 
 	hdev->num_msi = vectors;
@@ -2414,12 +2414,12 @@ static void hclgevf_info_show(struct hclgevf_dev *hdev)
 
 	dev_info(dev, "VF info begin:\n");
 
-	dev_info(dev, "Task queue pairs numbers: %d\n", hdev->num_tqps);
-	dev_info(dev, "Desc num per TX queue: %d\n", hdev->num_tx_desc);
-	dev_info(dev, "Desc num per RX queue: %d\n", hdev->num_rx_desc);
-	dev_info(dev, "Numbers of vports: %d\n", hdev->num_alloc_vport);
-	dev_info(dev, "HW tc map: %d\n", hdev->hw_tc_map);
-	dev_info(dev, "PF media type of this VF: %d\n",
+	dev_info(dev, "Task queue pairs numbers: %u\n", hdev->num_tqps);
+	dev_info(dev, "Desc num per TX queue: %u\n", hdev->num_tx_desc);
+	dev_info(dev, "Desc num per RX queue: %u\n", hdev->num_rx_desc);
+	dev_info(dev, "Numbers of vports: %u\n", hdev->num_alloc_vport);
+	dev_info(dev, "HW tc map: 0x%x\n", hdev->hw_tc_map);
+	dev_info(dev, "PF media type of this VF: %u\n",
 		 hdev->hw.mac.media_type);
 
 	dev_info(dev, "VF info end.\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 72bacf8..7cbd715 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -33,7 +33,7 @@ static int hclgevf_get_mbx_resp(struct hclgevf_dev *hdev, u16 code0, u16 code1,
 
 	if (resp_len > HCLGE_MBX_MAX_RESP_DATA_SIZE) {
 		dev_err(&hdev->pdev->dev,
-			"VF mbx response len(=%d) exceeds maximum(=%d)\n",
+			"VF mbx response len(=%u) exceeds maximum(=%u)\n",
 			resp_len,
 			HCLGE_MBX_MAX_RESP_DATA_SIZE);
 		return -EINVAL;
@@ -49,7 +49,7 @@ static int hclgevf_get_mbx_resp(struct hclgevf_dev *hdev, u16 code0, u16 code1,
 
 	if (i >= HCLGEVF_MAX_TRY_TIMES) {
 		dev_err(&hdev->pdev->dev,
-			"VF could not get mbx(%d,%d) resp(=%d) from PF in %d tries\n",
+			"VF could not get mbx(%u,%u) resp(=%d) from PF in %d tries\n",
 			code0, code1, hdev->mbx_resp.received_resp, i);
 		return -EIO;
 	}
@@ -68,10 +68,10 @@ static int hclgevf_get_mbx_resp(struct hclgevf_dev *hdev, u16 code0, u16 code1,
 
 	if (!(r_code0 == code0 && r_code1 == code1 && !mbx_resp->resp_status)) {
 		dev_err(&hdev->pdev->dev,
-			"VF could not match resp code(code0=%d,code1=%d), %d\n",
+			"VF could not match resp code(code0=%u,code1=%u), %d\n",
 			code0, code1, mbx_resp->resp_status);
 		dev_err(&hdev->pdev->dev,
-			"VF could not match resp r_code(r_code0=%d,r_code1=%d)\n",
+			"VF could not match resp r_code(r_code0=%u,r_code1=%u)\n",
 			r_code0, r_code1);
 		return -EIO;
 	}
@@ -168,7 +168,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		flag = le16_to_cpu(crq->desc[crq->next_to_use].flag);
 		if (unlikely(!hnae3_get_bit(flag, HCLGEVF_CMDQ_RX_OUTVLD_B))) {
 			dev_warn(&hdev->pdev->dev,
-				 "dropped invalid mailbox message, code = %d\n",
+				 "dropped invalid mailbox message, code = %u\n",
 				 req->msg[0]);
 
 			/* dropping/not processing this invalid message */
@@ -187,7 +187,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		case HCLGE_MBX_PF_VF_RESP:
 			if (resp->received_resp)
 				dev_warn(&hdev->pdev->dev,
-					 "VF mbx resp flag not clear(%d)\n",
+					 "VF mbx resp flag not clear(%u)\n",
 					 req->msg[1]);
 			resp->received_resp = true;
 
@@ -219,7 +219,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 			if (atomic_read(&hdev->arq.count) >=
 			    HCLGE_MBX_MAX_ARQ_MSG_NUM) {
 				dev_warn(&hdev->pdev->dev,
-					 "Async Q full, dropping msg(%d)\n",
+					 "Async Q full, dropping msg(%u)\n",
 					 req->msg[1]);
 				break;
 			}
@@ -236,7 +236,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 			break;
 		default:
 			dev_err(&hdev->pdev->dev,
-				"VF received unsupported(%d) mbx msg from PF\n",
+				"VF received unsupported(%u) mbx msg from PF\n",
 				req->msg[0]);
 			break;
 		}
@@ -327,7 +327,7 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 			break;
 		default:
 			dev_err(&hdev->pdev->dev,
-				"fetched unsupported(%d) message from arq\n",
+				"fetched unsupported(%u) message from arq\n",
 				msg_q[0]);
 			break;
 		}
-- 
2.7.4

