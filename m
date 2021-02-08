Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165DF313157
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhBHLs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:48:56 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12597 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbhBHLoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:44:00 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZ3vT2DZ5z165Py;
        Mon,  8 Feb 2021 19:39:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:40:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/12] net: hns3: modify some unmacthed types print parameter
Date:   Mon, 8 Feb 2021 19:39:36 +0800
Message-ID: <1612784382-27262-7-git-send-email-tanhuazhong@huawei.com>
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

From: Jiaran Zhang <zhangjiaran@huawei.com>

Fix an issue where the formatting symbol of the formatting input and
output function does not match the actual type.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c        | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c        | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c    | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 36c7813..818ac2c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -162,7 +162,7 @@ static int hns3_dbg_queue_map(struct hnae3_handle *h)
 			continue;
 
 		dev_info(&h->pdev->dev,
-			 "      %4d            %4d            %4d\n",
+			 "      %4d            %4u            %4d\n",
 			 i, global_qid, priv->ring[i].tqp_vector->vector_irq);
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index e544fe3..474b082 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2329,7 +2329,7 @@ static pci_ers_result_t hns3_error_detected(struct pci_dev *pdev,
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 	pci_ers_result_t ret;
 
-	dev_info(&pdev->dev, "PCI error detected, state(=%d)!!\n", state);
+	dev_info(&pdev->dev, "PCI error detected, state(=%u)!!\n", state);
 
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 79e0a9b..adcec4e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -456,7 +456,7 @@ static void *hns3_update_strings(u8 *data, const struct hns3_stats *stats,
 			data[ETH_GSTRING_LEN - 1] = '\0';
 
 			/* first, prepend the prefix string */
-			n1 = scnprintf(data, MAX_PREFIX_SIZE, "%s%d_",
+			n1 = scnprintf(data, MAX_PREFIX_SIZE, "%s%u_",
 				       prefix, i);
 			size_left = (ETH_GSTRING_LEN - 1) - n1;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b27203e..a996900 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -626,7 +626,7 @@ static u8 *hclge_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
 	for (i = 0; i < kinfo->num_tqps; i++) {
 		struct hclge_tqp *tqp = container_of(handle->kinfo.tqp[i],
 			struct hclge_tqp, q);
-		snprintf(buff, ETH_GSTRING_LEN, "txq%d_pktnum_rcd",
+		snprintf(buff, ETH_GSTRING_LEN, "txq%u_pktnum_rcd",
 			 tqp->index);
 		buff = buff + ETH_GSTRING_LEN;
 	}
@@ -634,7 +634,7 @@ static u8 *hclge_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
 	for (i = 0; i < kinfo->num_tqps; i++) {
 		struct hclge_tqp *tqp = container_of(kinfo->tqp[i],
 			struct hclge_tqp, q);
-		snprintf(buff, ETH_GSTRING_LEN, "rxq%d_pktnum_rcd",
+		snprintf(buff, ETH_GSTRING_LEN, "rxq%u_pktnum_rcd",
 			 tqp->index);
 		buff = buff + ETH_GSTRING_LEN;
 	}
@@ -5595,7 +5595,7 @@ static int hclge_fd_check_ext_tuple(struct hclge_dev *hdev,
 		if (fs->m_ext.vlan_tci &&
 		    be16_to_cpu(fs->h_ext.vlan_tci) >= VLAN_N_VID) {
 			dev_err(&hdev->pdev->dev,
-				"failed to config vlan_tci, invalid vlan_tci: %u, max is %u.\n",
+				"failed to config vlan_tci, invalid vlan_tci: %u, max is %d.\n",
 				ntohs(fs->h_ext.vlan_tci), VLAN_N_VID - 1);
 			return -EINVAL;
 		}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index ffb416e..51a36e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -56,7 +56,7 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 		resp_pf_to_vf->msg.resp_status = resp;
 	} else {
 		dev_warn(&hdev->pdev->dev,
-			 "failed to send response to VF, response status %d is out-of-bound\n",
+			 "failed to send response to VF, response status %u is out-of-bound\n",
 			 resp);
 		resp_pf_to_vf->msg.resp_status = EIO;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index cdb1131..ab213ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -180,7 +180,7 @@ static u8 *hclgevf_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
 	for (i = 0; i < kinfo->num_tqps; i++) {
 		struct hclgevf_tqp *tqp = container_of(kinfo->tqp[i],
 						       struct hclgevf_tqp, q);
-		snprintf(buff, ETH_GSTRING_LEN, "txq%d_pktnum_rcd",
+		snprintf(buff, ETH_GSTRING_LEN, "txq%u_pktnum_rcd",
 			 tqp->index);
 		buff += ETH_GSTRING_LEN;
 	}
@@ -188,7 +188,7 @@ static u8 *hclgevf_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
 	for (i = 0; i < kinfo->num_tqps; i++) {
 		struct hclgevf_tqp *tqp = container_of(kinfo->tqp[i],
 						       struct hclgevf_tqp, q);
-		snprintf(buff, ETH_GSTRING_LEN, "rxq%d_pktnum_rcd",
+		snprintf(buff, ETH_GSTRING_LEN, "rxq%u_pktnum_rcd",
 			 tqp->index);
 		buff += ETH_GSTRING_LEN;
 	}
-- 
2.7.4

