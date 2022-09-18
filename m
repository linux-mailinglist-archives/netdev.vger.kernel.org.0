Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61BF5BBD12
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiIRJut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiIRJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D311211C0A
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjbt3HLMzlVw9;
        Sun, 18 Sep 2022 17:45:46 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:49 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 18/55] net: mlx4: adjust the net device feature relative macroes
Date:   Sun, 18 Sep 2022 09:42:59 +0000
Message-ID: <20220918094336.28958-19-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macro DEV_FEATURE_CHANGED use NETIF_F_XXX as parameter,
change it to use NETIF_F_XXX_BIT instead, for all the macroes
NETIF_F_XXX will be removed later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 22 +++++++++----------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  5 +++--
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 1b224f28f1f1..044ec3f7bae1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2522,13 +2522,13 @@ static int mlx4_en_set_features(struct net_device *netdev,
 	bool reset = false;
 	int ret = 0;
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXFCS)) {
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXFCS_BIT)) {
 		en_info(priv, "Turn %s RX-FCS\n",
 			(features & NETIF_F_RXFCS) ? "ON" : "OFF");
 		reset = true;
 	}
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXALL)) {
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXALL_BIT)) {
 		u8 ignore_fcs_value = (features & NETIF_F_RXALL) ? 1 : 0;
 
 		en_info(priv, "Turn %s RX-ALL\n",
@@ -2539,21 +2539,21 @@ static int mlx4_en_set_features(struct net_device *netdev,
 			return ret;
 	}
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_RX)) {
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 		en_info(priv, "Turn %s RX vlan strip offload\n",
 			(features & NETIF_F_HW_VLAN_CTAG_RX) ? "ON" : "OFF");
 		reset = true;
 	}
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_TX))
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		en_info(priv, "Turn %s TX vlan strip offload\n",
 			(features & NETIF_F_HW_VLAN_CTAG_TX) ? "ON" : "OFF");
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_STAG_TX))
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_STAG_TX_BIT))
 		en_info(priv, "Turn %s TX S-VLAN strip offload\n",
 			(features & NETIF_F_HW_VLAN_STAG_TX) ? "ON" : "OFF");
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_LOOPBACK)) {
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_LOOPBACK_BIT)) {
 		en_info(priv, "Turn %s loopback\n",
 			(features & NETIF_F_LOOPBACK) ? "ON" : "OFF");
 		mlx4_en_update_loopback_state(netdev, features);
@@ -3508,11 +3508,11 @@ int mlx4_en_reset_config(struct net_device *dev,
 
 	if (priv->hwtstamp_config.tx_type == ts_config.tx_type &&
 	    priv->hwtstamp_config.rx_filter == ts_config.rx_filter &&
-	    !DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX) &&
-	    !DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS))
+	    !DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
+	    !DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS_BIT))
 		return 0; /* Nothing to change */
 
-	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
 	    (features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    (priv->hwtstamp_config.rx_filter != HWTSTAMP_FILTER_NONE)) {
 		en_warn(priv, "Can't turn ON rx vlan offload while time-stamping rx filter is ON\n");
@@ -3539,7 +3539,7 @@ int mlx4_en_reset_config(struct net_device *dev,
 
 	mlx4_en_safe_replace_resources(priv, tmp);
 
-	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX)) {
+	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 		if (features & NETIF_F_HW_VLAN_CTAG_RX)
 			dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 		else
@@ -3554,7 +3554,7 @@ int mlx4_en_reset_config(struct net_device *dev,
 			dev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 	}
 
-	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS)) {
+	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS_BIT)) {
 		if (features & NETIF_F_RXFCS)
 			dev->features |= NETIF_F_RXFCS;
 		else
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index e132ff4c82f2..29b0ac52c6a9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -774,8 +774,9 @@ void mlx4_en_cleanup_filters(struct mlx4_en_priv *priv);
 void mlx4_en_ex_selftest(struct net_device *dev, u32 *flags, u64 *buf);
 void mlx4_en_ptp_overflow_check(struct mlx4_en_dev *mdev);
 
-#define DEV_FEATURE_CHANGED(dev, new_features, feature) \
-	((dev->features & feature) ^ (new_features & feature))
+#define DEV_FEATURE_CHANGED(dev, new_features, feature_bit) \
+	(netdev_active_feature_test(dev, feature_bit) != \
+	 netdev_feature_test(feature_bit, new_features))
 
 int mlx4_en_moderation_update(struct mlx4_en_priv *priv);
 int mlx4_en_reset_config(struct net_device *dev,
-- 
2.33.0

