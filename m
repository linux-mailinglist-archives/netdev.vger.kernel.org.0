Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9811B143889
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgAUImj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:42:39 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10117 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729076AbgAUImh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:42:37 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D72BF44CC4715B4A8FB6;
        Tue, 21 Jan 2020 16:42:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 21 Jan 2020 16:42:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 9/9] net: hns3: cleanup some coding style issue
Date:   Tue, 21 Jan 2020 16:42:13 +0800
Message-ID: <1579596133-54842-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
References: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes some unnecessary return value assignments,
some duplicated printing in the caller, refines the judgment
of 0 and uses le16_to_cpu to replace __le16_to_cpu.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 81 ++++++----------------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 28 +++-----
 4 files changed, 35 insertions(+), 86 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 6271b69..acb796c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2094,10 +2094,8 @@ static int hns3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int ret;
 
 	ae_dev = devm_kzalloc(&pdev->dev, sizeof(*ae_dev), GFP_KERNEL);
-	if (!ae_dev) {
-		ret = -ENOMEM;
-		return ret;
-	}
+	if (!ae_dev)
+		return -ENOMEM;
 
 	ae_dev->pdev = pdev;
 	ae_dev->flag = ent->driver_data;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index f8127d7..c85b72d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1898,10 +1898,8 @@ static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
 
 	bd_num = max_t(u32, mpf_bd_num, pf_bd_num);
 	desc = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
-	if (!desc) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!desc)
+		return -ENOMEM;
 
 	ret = hclge_handle_mpf_msix_error(hdev, desc, mpf_bd_num,
 					  reset_requests);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fafae67..ec5f6ee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -862,9 +862,7 @@ static int hclge_query_function_status(struct hclge_dev *hdev)
 		usleep_range(1000, 2000);
 	} while (timeout++ < HCLGE_QUERY_MAX_CNT);
 
-	ret = hclge_parse_func_status(hdev, req);
-
-	return ret;
+	return hclge_parse_func_status(hdev, req);
 }
 
 static int hclge_query_pf_resource(struct hclge_dev *hdev)
@@ -882,12 +880,12 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 	}
 
 	req = (struct hclge_pf_res_cmd *)desc.data;
-	hdev->num_tqps = __le16_to_cpu(req->tqp_num);
-	hdev->pkt_buf_size = __le16_to_cpu(req->buf_size) << HCLGE_BUF_UNIT_S;
+	hdev->num_tqps = le16_to_cpu(req->tqp_num);
+	hdev->pkt_buf_size = le16_to_cpu(req->buf_size) << HCLGE_BUF_UNIT_S;
 
 	if (req->tx_buf_size)
 		hdev->tx_buf_size =
-			__le16_to_cpu(req->tx_buf_size) << HCLGE_BUF_UNIT_S;
+			le16_to_cpu(req->tx_buf_size) << HCLGE_BUF_UNIT_S;
 	else
 		hdev->tx_buf_size = HCLGE_DEFAULT_TX_BUF;
 
@@ -895,7 +893,7 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 
 	if (req->dv_buf_size)
 		hdev->dv_buf_size =
-			__le16_to_cpu(req->dv_buf_size) << HCLGE_BUF_UNIT_S;
+			le16_to_cpu(req->dv_buf_size) << HCLGE_BUF_UNIT_S;
 	else
 		hdev->dv_buf_size = HCLGE_DEFAULT_DV;
 
@@ -903,10 +901,10 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 
 	if (hnae3_dev_roce_supported(hdev)) {
 		hdev->roce_base_msix_offset =
-		hnae3_get_field(__le16_to_cpu(req->msixcap_localid_ba_rocee),
+		hnae3_get_field(le16_to_cpu(req->msixcap_localid_ba_rocee),
 				HCLGE_MSIX_OFT_ROCEE_M, HCLGE_MSIX_OFT_ROCEE_S);
 		hdev->num_roce_msi =
-		hnae3_get_field(__le16_to_cpu(req->pf_intr_vector_number),
+		hnae3_get_field(le16_to_cpu(req->pf_intr_vector_number),
 				HCLGE_PF_VEC_NUM_M, HCLGE_PF_VEC_NUM_S);
 
 		/* nic's msix numbers is always equals to the roce's. */
@@ -919,7 +917,7 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 				hdev->roce_base_msix_offset;
 	} else {
 		hdev->num_msi =
-		hnae3_get_field(__le16_to_cpu(req->pf_intr_vector_number),
+		hnae3_get_field(le16_to_cpu(req->pf_intr_vector_number),
 				HCLGE_PF_VEC_NUM_M, HCLGE_PF_VEC_NUM_S);
 
 		hdev->num_nic_msi = hdev->num_msi;
@@ -1333,11 +1331,7 @@ static int hclge_get_cap(struct hclge_dev *hdev)
 	}
 
 	/* get pf resource */
-	ret = hclge_query_pf_resource(hdev);
-	if (ret)
-		dev_err(&hdev->pdev->dev, "query pf resource error %d.\n", ret);
-
-	return ret;
+	return hclge_query_pf_resource(hdev);
 }
 
 static void hclge_init_kdump_kernel_config(struct hclge_dev *hdev)
@@ -2621,30 +2615,21 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 	hdev->hw.mac.duplex = HCLGE_MAC_FULL;
 	ret = hclge_cfg_mac_speed_dup_hw(hdev, hdev->hw.mac.speed,
 					 hdev->hw.mac.duplex);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"Config mac speed dup fail ret=%d\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	if (hdev->hw.mac.support_autoneg) {
 		ret = hclge_set_autoneg_en(hdev, hdev->hw.mac.autoneg);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"Config mac autoneg fail ret=%d\n", ret);
+		if (ret)
 			return ret;
-		}
 	}
 
 	mac->link = 0;
 
 	if (mac->user_fec_mode & BIT(HNAE3_FEC_USER_DEF)) {
 		ret = hclge_set_fec_hw(hdev, mac->user_fec_mode);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"Fec mode init fail, ret = %d\n", ret);
+		if (ret)
 			return ret;
-		}
 	}
 
 	ret = hclge_set_mac_mtu(hdev, hdev->mps);
@@ -2916,7 +2901,7 @@ static int hclge_get_status(struct hnae3_handle *handle)
 
 static struct hclge_vport *hclge_get_vf_vport(struct hclge_dev *hdev, int vf)
 {
-	if (pci_num_vf(hdev->pdev) == 0) {
+	if (!pci_num_vf(hdev->pdev)) {
 		dev_err(&hdev->pdev->dev,
 			"SRIOV is disabled, can not get vport(%d) info.\n", vf);
 		return NULL;
@@ -6584,7 +6569,7 @@ static int hclge_set_serdes_loopback(struct hclge_dev *hdev, bool en,
 
 	hclge_cfg_mac_mode(hdev, en);
 
-	ret = hclge_mac_phy_link_status_wait(hdev, en, FALSE);
+	ret = hclge_mac_phy_link_status_wait(hdev, en, false);
 	if (ret)
 		dev_err(&hdev->pdev->dev,
 			"serdes loopback config mac mode timeout\n");
@@ -6642,7 +6627,7 @@ static int hclge_set_phy_loopback(struct hclge_dev *hdev, bool en)
 
 	hclge_cfg_mac_mode(hdev, en);
 
-	ret = hclge_mac_phy_link_status_wait(hdev, en, TRUE);
+	ret = hclge_mac_phy_link_status_wait(hdev, en, true);
 	if (ret)
 		dev_err(&hdev->pdev->dev,
 			"phy loopback config mac mode timeout\n");
@@ -9394,17 +9379,13 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	sema_init(&hdev->reset_sem, 1);
 
 	ret = hclge_pci_init(hdev);
-	if (ret) {
-		dev_err(&pdev->dev, "PCI init failed\n");
+	if (ret)
 		goto out;
-	}
 
 	/* Firmware command queue initialize */
 	ret = hclge_cmd_queue_init(hdev);
-	if (ret) {
-		dev_err(&pdev->dev, "Cmd queue init failed, ret = %d.\n", ret);
+	if (ret)
 		goto err_pci_uninit;
-	}
 
 	/* Firmware command initialize */
 	ret = hclge_cmd_init(hdev);
@@ -9412,11 +9393,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_cmd_uninit;
 
 	ret = hclge_get_cap(hdev);
-	if (ret) {
-		dev_err(&pdev->dev, "get hw capability error, ret = %d.\n",
-			ret);
+	if (ret)
 		goto err_cmd_uninit;
-	}
 
 	ret = hclge_configure(hdev);
 	if (ret) {
@@ -9431,12 +9409,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	}
 
 	ret = hclge_misc_irq_init(hdev);
-	if (ret) {
-		dev_err(&pdev->dev,
-			"Misc IRQ(vector0) init error, ret = %d.\n",
-			ret);
+	if (ret)
 		goto err_msi_uninit;
-	}
 
 	ret = hclge_alloc_tqps(hdev);
 	if (ret) {
@@ -9445,31 +9419,22 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	}
 
 	ret = hclge_alloc_vport(hdev);
-	if (ret) {
-		dev_err(&pdev->dev, "Allocate vport error, ret = %d.\n", ret);
+	if (ret)
 		goto err_msi_irq_uninit;
-	}
 
 	ret = hclge_map_tqp(hdev);
-	if (ret) {
-		dev_err(&pdev->dev, "Map tqp error, ret = %d.\n", ret);
+	if (ret)
 		goto err_msi_irq_uninit;
-	}
 
 	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER) {
 		ret = hclge_mac_mdio_config(hdev);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"mdio config fail ret=%d\n", ret);
+		if (ret)
 			goto err_msi_irq_uninit;
-		}
 	}
 
 	ret = hclge_init_umv_space(hdev);
-	if (ret) {
-		dev_err(&pdev->dev, "umv space init error, ret=%d.\n", ret);
+	if (ret)
 		goto err_mdiobus_unreg;
-	}
 
 	ret = hclge_mac_init(hdev);
 	if (ret) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 4b87513..d659720 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2597,11 +2597,11 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 
 	if (hnae3_dev_roce_supported(hdev)) {
 		hdev->roce_base_msix_offset =
-		hnae3_get_field(__le16_to_cpu(req->msixcap_localid_ba_rocee),
+		hnae3_get_field(le16_to_cpu(req->msixcap_localid_ba_rocee),
 				HCLGEVF_MSIX_OFT_ROCEE_M,
 				HCLGEVF_MSIX_OFT_ROCEE_S);
 		hdev->num_roce_msix =
-		hnae3_get_field(__le16_to_cpu(req->vf_intr_vector_number),
+		hnae3_get_field(le16_to_cpu(req->vf_intr_vector_number),
 				HCLGEVF_VEC_NUM_M, HCLGEVF_VEC_NUM_S);
 
 		/* nic's msix numbers is always equals to the roce's. */
@@ -2614,7 +2614,7 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 				hdev->roce_base_msix_offset;
 	} else {
 		hdev->num_msi =
-		hnae3_get_field(__le16_to_cpu(req->vf_intr_vector_number),
+		hnae3_get_field(le16_to_cpu(req->vf_intr_vector_number),
 				HCLGEVF_VEC_NUM_M, HCLGEVF_VEC_NUM_S);
 
 		hdev->num_nic_msix = hdev->num_msi;
@@ -2711,16 +2711,12 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	int ret;
 
 	ret = hclgevf_pci_init(hdev);
-	if (ret) {
-		dev_err(&pdev->dev, "PCI initialization failed\n");
+	if (ret)
 		return ret;
-	}
 
 	ret = hclgevf_cmd_queue_init(hdev);
-	if (ret) {
-		dev_err(&pdev->dev, "Cmd queue init failed: %d\n", ret);
+	if (ret)
 		goto err_cmd_queue_init;
-	}
 
 	ret = hclgevf_cmd_init(hdev);
 	if (ret)
@@ -2728,11 +2724,8 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 
 	/* Get vf resource */
 	ret = hclgevf_query_vf_resource(hdev);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"Query vf status error, ret = %d.\n", ret);
+	if (ret)
 		goto err_cmd_init;
-	}
 
 	ret = hclgevf_init_msi(hdev);
 	if (ret) {
@@ -2745,11 +2738,8 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	hdev->reset_type = HNAE3_NONE_RESET;
 
 	ret = hclgevf_misc_irq_init(hdev);
-	if (ret) {
-		dev_err(&pdev->dev, "failed(%d) to init Misc IRQ(vector0)\n",
-			ret);
+	if (ret)
 		goto err_misc_irq_init;
-	}
 
 	set_bit(HCLGEVF_STATE_IRQ_INITED, &hdev->state);
 
@@ -2766,10 +2756,8 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	}
 
 	ret = hclgevf_set_handle_info(hdev);
-	if (ret) {
-		dev_err(&pdev->dev, "failed(%d) to set handle info\n", ret);
+	if (ret)
 		goto err_config;
-	}
 
 	ret = hclgevf_config_gro(hdev, true);
 	if (ret)
-- 
2.7.4

