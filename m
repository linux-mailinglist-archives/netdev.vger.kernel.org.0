Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148143EE485
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 04:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhHQCkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 22:40:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8428 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbhHQCkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 22:40:32 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GpZs8628Sz88FG;
        Tue, 17 Aug 2021 10:35:56 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 10:39:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 10:39:58 +0800
From:   Yufeng Mo <moyufeng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <shenjian15@huawei.com>,
        <lipeng321@huawei.com>, <yisen.zhuang@huawei.com>,
        <linyunsheng@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <salil.mehta@huawei.com>,
        <moyufeng@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH net-next 4/4] net: hns3: add ethtool support for CQE/EQE mode configuration
Date:   Tue, 17 Aug 2021 10:36:07 +0800
Message-ID: <1629167767-7550-5-git-send-email-moyufeng@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629167767-7550-1-git-send-email-moyufeng@huawei.com>
References: <1629167767-7550-1-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support in ethtool for switching EQE/CQE mode.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 18 +++++++++++++++++-
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1bd83d7..39d01ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5055,9 +5055,9 @@ static void hns3_set_cq_period_mode(struct hns3_nic_priv *priv,
 	}
 }
 
-static void hns3_cq_period_mode_init(struct hns3_nic_priv *priv,
-				     enum dim_cq_period_mode tx_mode,
-				     enum dim_cq_period_mode rx_mode)
+void hns3_cq_period_mode_init(struct hns3_nic_priv *priv,
+			      enum dim_cq_period_mode tx_mode,
+			      enum dim_cq_period_mode rx_mode)
 {
 	hns3_set_cq_period_mode(priv, tx_mode, true);
 	hns3_set_cq_period_mode(priv, rx_mode, false);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index ff45825..dfad906 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -718,4 +718,7 @@ void hns3_dbg_register_debugfs(const char *debugfs_dir_name);
 void hns3_dbg_unregister_debugfs(void);
 void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size);
 u16 hns3_get_max_available_channels(struct hnae3_handle *h);
+void hns3_cq_period_mode_init(struct hns3_nic_priv *priv,
+			      enum dim_cq_period_mode tx_mode,
+			      enum dim_cq_period_mode rx_mode);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 049be076..b8d9851 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1203,6 +1203,11 @@ static int hns3_get_coalesce(struct net_device *netdev,
 	cmd->tx_max_coalesced_frames = tx_coal->int_ql;
 	cmd->rx_max_coalesced_frames = rx_coal->int_ql;
 
+	kernel_coal->use_cqe_mode_tx = (priv->tx_cqe_mode ==
+					DIM_CQ_PERIOD_MODE_START_FROM_CQE);
+	kernel_coal->use_cqe_mode_rx = (priv->rx_cqe_mode ==
+					DIM_CQ_PERIOD_MODE_START_FROM_CQE);
+
 	return 0;
 }
 
@@ -1372,6 +1377,8 @@ static int hns3_set_coalesce(struct net_device *netdev,
 	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
 	struct hns3_enet_coalesce *rx_coal = &priv->rx_coal;
 	u16 queue_num = h->kinfo.num_tqps;
+	enum dim_cq_period_mode tx_mode;
+	enum dim_cq_period_mode rx_mode;
 	int ret;
 	int i;
 
@@ -1397,6 +1404,14 @@ static int hns3_set_coalesce(struct net_device *netdev,
 	for (i = 0; i < queue_num; i++)
 		hns3_set_coalesce_per_queue(netdev, cmd, i);
 
+	tx_mode = kernel_coal->use_cqe_mode_tx ?
+		  DIM_CQ_PERIOD_MODE_START_FROM_CQE :
+		  DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	rx_mode = kernel_coal->use_cqe_mode_rx ?
+		  DIM_CQ_PERIOD_MODE_START_FROM_CQE :
+		  DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	hns3_cq_period_mode_init(priv, tx_mode, rx_mode);
+
 	return 0;
 }
 
@@ -1702,7 +1717,8 @@ static int hns3_set_tunable(struct net_device *netdev,
 				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
 				 ETHTOOL_COALESCE_RX_USECS_HIGH |	\
 				 ETHTOOL_COALESCE_TX_USECS_HIGH |	\
-				 ETHTOOL_COALESCE_MAX_FRAMES)
+				 ETHTOOL_COALESCE_MAX_FRAMES |		\
+				 ETHTOOL_COALESCE_USE_CQE)
 
 static int hns3_get_ts_info(struct net_device *netdev,
 			    struct ethtool_ts_info *info)
-- 
2.8.1

