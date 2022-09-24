Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE94C5E877B
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiIXCd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiIXCdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:33:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91B51514FD;
        Fri, 23 Sep 2022 19:33:18 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MZCdT2brjzWgq4;
        Sat, 24 Sep 2022 10:29:17 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:16 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:33:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 09/14] net: hns3: modify macro hnae3_dev_phy_imp_supported
Date:   Sat, 24 Sep 2022 10:30:19 +0800
Message-ID: <20220924023024.14219-10-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220924023024.14219-1-huangguangbin2@huawei.com>
References: <20220924023024.14219-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Redefine macro hnae3_dev_phy_imp_supported(hdev) to
hnae3_ae_dev_phy_imp_supported(ae_dev), so it can be
used in both hclge and hns3_enet layer.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h      |  4 ++--
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.c  |  2 +-
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.h  |  3 ---
 .../net/ethernet/hisilicon/hns3/hns3_ethtool.c   |  4 ++--
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c        |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c  | 16 ++++++++--------
 6 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 2a6d2ff3056b..494402074cb9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -131,8 +131,8 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_tx_push_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, (ae_dev)->caps)
 
-#define hnae3_dev_phy_imp_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, (hdev)->ae_dev->caps)
+#define hnae3_ae_dev_phy_imp_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, (ae_dev)->caps)
 
 #define hnae3_dev_ras_imp_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_RAS_IMP_B, (hdev)->ae_dev->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index f671a63cecde..bfef94360920 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -87,7 +87,7 @@ int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev,
 
 		hnae3_set_bit(compat, HCLGE_COMM_LINK_EVENT_REPORT_EN_B, 1);
 		hnae3_set_bit(compat, HCLGE_COMM_NCSI_ERROR_REPORT_EN_B, 1);
-		if (hclge_comm_dev_phy_imp_supported(ae_dev))
+		if (hnae3_ae_dev_phy_imp_supported(ae_dev))
 			hnae3_set_bit(compat, HCLGE_COMM_PHY_IMP_EN_B, 1);
 		hnae3_set_bit(compat, HCLGE_COMM_MAC_STATS_EXT_EN_B, 1);
 		hnae3_set_bit(compat, HCLGE_COMM_SYNC_RX_RING_HEAD_EN_B, 1);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index b1f9383b418f..ba2e46adde72 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -22,9 +22,6 @@
 #define HCLGE_COMM_SYNC_RX_RING_HEAD_EN_B	4
 #define HCLGE_COMM_LLRS_FEC_EN_B		5
 
-#define hclge_comm_dev_phy_imp_supported(ae_dev) \
-	test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, (ae_dev)->caps)
-
 #define HCLGE_COMM_TYPE_CRQ			0
 #define HCLGE_COMM_TYPE_CSQ			1
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index dd1a32659800..e4278ec95d21 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -789,7 +789,7 @@ static int hns3_get_link_ksettings(struct net_device *netdev,
 		break;
 	case HNAE3_MEDIA_TYPE_COPPER:
 		cmd->base.port = PORT_TP;
-		if (test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps) &&
+		if (hnae3_ae_dev_phy_imp_supported(ae_dev) &&
 		    ops->get_phy_link_ksettings)
 			ops->get_phy_link_ksettings(h, cmd);
 		else if (!netdev->phydev)
@@ -890,7 +890,7 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 			return -EINVAL;
 
 		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
-	} else if (test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps) &&
+	} else if (hnae3_ae_dev_phy_imp_supported(ae_dev) &&
 		   ops->set_phy_link_ksettings) {
 		return ops->set_phy_link_ksettings(handle, cmd);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 142415c84c6b..90000ec07d55 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1932,7 +1932,7 @@ static int hclge_dbg_dump_loopback(struct hclge_dev *hdev, char *buf, int len)
 		loopback_en = phydev->loopback_enabled;
 		pos += scnprintf(buf + pos, len - pos, "phy loopback: %s\n",
 				 state_str[loopback_en]);
-	} else if (hnae3_dev_phy_imp_supported(hdev)) {
+	} else if (hnae3_ae_dev_phy_imp_supported(hdev->ae_dev)) {
 		loopback_en = req_common->enable &
 			      HCLGE_CMD_GE_PHY_INNER_LOOP_B;
 		pos += scnprintf(buf + pos, len - pos, "phy loopback: %s\n",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a93df064da46..7995e3388778 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -751,7 +751,7 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 
 		if ((hdev->hw.mac.phydev && hdev->hw.mac.phydev->drv &&
 		     hdev->hw.mac.phydev->drv->set_loopback) ||
-		    hnae3_dev_phy_imp_supported(hdev)) {
+		    hnae3_ae_dev_phy_imp_supported(hdev->ae_dev)) {
 			count += 1;
 			handle->flags |= HNAE3_SUPPORT_PHY_LOOPBACK;
 		}
@@ -3433,7 +3433,7 @@ static int hclge_update_tp_port_info(struct hclge_dev *hdev)
 	struct ethtool_link_ksettings cmd;
 	int ret;
 
-	if (!hnae3_dev_phy_imp_supported(hdev))
+	if (!hnae3_ae_dev_phy_imp_supported(hdev->ae_dev))
 		return 0;
 
 	ret = hclge_get_phy_link_ksettings(&hdev->vport->nic, &cmd);
@@ -3451,7 +3451,7 @@ static int hclge_tp_port_init(struct hclge_dev *hdev)
 {
 	struct ethtool_link_ksettings cmd;
 
-	if (!hnae3_dev_phy_imp_supported(hdev))
+	if (!hnae3_ae_dev_phy_imp_supported(hdev->ae_dev))
 		return 0;
 
 	cmd.base.autoneg = hdev->hw.mac.autoneg;
@@ -7852,7 +7852,7 @@ static int hclge_set_phy_loopback(struct hclge_dev *hdev, bool en)
 	int ret;
 
 	if (!phydev) {
-		if (hnae3_dev_phy_imp_supported(hdev))
+		if (hnae3_ae_dev_phy_imp_supported(hdev->ae_dev))
 			return hclge_set_common_loopback(hdev, en,
 							 HNAE3_LOOP_PHY);
 		return -ENOTSUPP;
@@ -9369,7 +9369,7 @@ static int hclge_mii_ioctl(struct hclge_dev *hdev, struct ifreq *ifr, int cmd)
 {
 	struct mii_ioctl_data *data = if_mii(ifr);
 
-	if (!hnae3_dev_phy_imp_supported(hdev))
+	if (!hnae3_ae_dev_phy_imp_supported(hdev->ae_dev))
 		return -EOPNOTSUPP;
 
 	switch (cmd) {
@@ -10975,7 +10975,7 @@ static int hclge_set_pauseparam(struct hnae3_handle *handle, u32 auto_neg,
 	struct phy_device *phydev = hdev->hw.mac.phydev;
 	u32 fc_autoneg;
 
-	if (phydev || hnae3_dev_phy_imp_supported(hdev)) {
+	if (phydev || hnae3_ae_dev_phy_imp_supported(hdev->ae_dev)) {
 		fc_autoneg = hclge_get_autoneg(handle);
 		if (auto_neg != fc_autoneg) {
 			dev_info(&hdev->pdev->dev,
@@ -10994,7 +10994,7 @@ static int hclge_set_pauseparam(struct hnae3_handle *handle, u32 auto_neg,
 
 	hclge_record_user_pauseparam(hdev, rx_en, tx_en);
 
-	if (!auto_neg || hnae3_dev_phy_imp_supported(hdev))
+	if (!auto_neg || hnae3_ae_dev_phy_imp_supported(hdev->ae_dev))
 		return hclge_cfg_pauseparam(hdev, rx_en, tx_en);
 
 	if (phydev)
@@ -11588,7 +11588,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_msi_irq_uninit;
 
 	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER &&
-	    !hnae3_dev_phy_imp_supported(hdev)) {
+	    !hnae3_ae_dev_phy_imp_supported(hdev->ae_dev)) {
 		ret = hclge_mac_mdio_config(hdev);
 		if (ret)
 			goto err_msi_irq_uninit;
-- 
2.33.0

