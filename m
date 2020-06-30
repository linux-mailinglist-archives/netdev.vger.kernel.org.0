Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEDF20EB7D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 04:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgF3Cb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 22:31:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6882 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728206AbgF3Cb3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 22:31:29 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3AD7F8AA1A967F251270;
        Tue, 30 Jun 2020 10:31:27 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 30 Jun 2020 10:31:19 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next] hinic: remove unused but set variable
Date:   Tue, 30 Jun 2020 10:30:34 +0800
Message-ID: <20200630023034.9281-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove unused but set variable to avoid auto build test WARNING

Signed-off-by: Luo bin <luobin9@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c  | 18 ------------------
 .../net/ethernet/huawei/hinic/hinic_sriov.c    |  2 --
 2 files changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index a4a2a2d68f5c..cb5ebae54f73 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -749,12 +749,9 @@ static int __set_hw_coal_param(struct hinic_dev *nic_dev,
 static int __hinic_set_coalesce(struct net_device *netdev,
 				struct ethtool_coalesce *coal, u16 queue)
 {
-	struct hinic_intr_coal_info *ori_rx_intr_coal = NULL;
-	struct hinic_intr_coal_info *ori_tx_intr_coal = NULL;
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	struct hinic_intr_coal_info rx_intr_coal = {0};
 	struct hinic_intr_coal_info tx_intr_coal = {0};
-	char obj_str[OBJ_STR_MAX_LEN] = {0};
 	bool set_rx_coal = false;
 	bool set_tx_coal = false;
 	int err;
@@ -779,21 +776,6 @@ static int __hinic_set_coalesce(struct net_device *netdev,
 		set_tx_coal = true;
 	}
 
-	if (queue == COALESCE_ALL_QUEUE) {
-		ori_rx_intr_coal = &nic_dev->rx_intr_coalesce[0];
-		ori_tx_intr_coal = &nic_dev->tx_intr_coalesce[0];
-		err = snprintf(obj_str, OBJ_STR_MAX_LEN, "for netdev");
-	} else {
-		ori_rx_intr_coal = &nic_dev->rx_intr_coalesce[queue];
-		ori_tx_intr_coal = &nic_dev->tx_intr_coalesce[queue];
-		err = snprintf(obj_str, OBJ_STR_MAX_LEN, "for queue %d", queue);
-	}
-	if (err <= 0 || err >= OBJ_STR_MAX_LEN) {
-		netif_err(nic_dev, drv, netdev, "Failed to snprintf string, function return(%d) and dest_len(%d)\n",
-			  err, OBJ_STR_MAX_LEN);
-		return -EFAULT;
-	}
-
 	/* setting coalesce timer or pending limit to zero will disable
 	 * coalesce
 	 */
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index f5c7c1f48542..caf7e81e3f62 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -1060,9 +1060,7 @@ static int hinic_init_vf_infos(struct hinic_func_to_io *nic_io, u16 vf_id)
 static void hinic_clear_vf_infos(struct hinic_dev *nic_dev, u16 vf_id)
 {
 	struct vf_data_storage *vf_infos;
-	u16 func_id;
 
-	func_id = hinic_glb_pf_vf_offset(nic_dev->hwdev->hwif) + vf_id;
 	vf_infos = nic_dev->hwdev->func_to_io.vf_infos + HW_VF_ID_TO_OS(vf_id);
 	if (vf_infos->pf_set_mac)
 		hinic_port_del_mac(nic_dev, vf_infos->vf_mac_addr, 0);
-- 
2.17.1

