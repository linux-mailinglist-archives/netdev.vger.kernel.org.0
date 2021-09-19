Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A76410B5A
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbhISL5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:57:32 -0400
Received: from mail-dm6nam08on2046.outbound.protection.outlook.com ([40.107.102.46]:61408
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230393AbhISL5b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:57:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmoW4hmk8eUuIBPCkOUTCcFRYqjKJs8KzMj/1fVtFkFvrjZSMdzXzbK7yfQnwrBwvLnOOnofsFq7h3ZAzRRYOd7aEPtIkZ0ZvxFeD6U0Bi5aAs9S6vqFsZlB0AmKu58j3THjK+8tvoKeOztkQgdAHw/qXGF9ltU4nKl5Br/J9/gY657BUsjN7HIWrzjadPspbQBoLBlGAj160ZltVqjHEUdPl4QAW2kxGEJGZA60rsEHdCGncn34tMaOYoZg+hBird428O80PzqqXET1Fy1Xwa2qaIA1O7OPwlFvUl7p/SRGUu/004tHYA50bTZiu0NO3BirWt7r3aUiMZ4TUAGHXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5JVv2062jgXg8WpdaIzWeISj0daVZpBE+nHeLO29iN8=;
 b=OC1zfayeH6+rsQIMbGw2tM17/SAsRkd4nY0FvbWDAWGC+WpF2qltboFxxpZuDhpkzKYWl2tUH145xDzuQsvXUo34/erRCQ+RFoxvOXnZ4GNKu6xvvLVBxokqITWKlU/9u4dsIanz6ZyZ+WdiuCtAcuRuvSzqCnAbZ+of7gzxjMsDtrMG3XHO2TRQrkyXdQgX26uUO2c+SkdHzsd3oGvQs6ewtY7Q/Tbx6nbkbp7yUKuLapD+jW2g/8DUEBmvli4HGurfAlPx/ofjKwFhBowJ74aSyRCi/ZVVVVBqewBeYl6uWviUTFJ5t7YZ5cV2x7UpKNnOQq/X05vOAO/Jc9p8nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JVv2062jgXg8WpdaIzWeISj0daVZpBE+nHeLO29iN8=;
 b=CIYfM9qFPnhX+d6KtE0TmA+1TJy+sOoFSaU3hqjdYcYV4Iczl+suClN8yrSdz8TM5ufVAqYvO2Cg2IEiVhjSsGs7D2JR7ODiFBuHBEjuGf9LZqhqsqTO8+miInq3iNRuW5c0IfuE9uL44wTwpboLsLL7Qkewp2s4/alGlRK/YrpjWXc006KNov1tjA6aA16eN7NhpFTTUW63kZ+x5gTTiX/2fdNehF1UTSsM1ury+TlJnS4lejXwETbFPz+SPxuMsxm/3rkKAgMO1o2W3AYU/bCh0jAkMaq1TmIladudVF187eBN2Hz8PImDVx9/mDSB2OSXaPsA3Ay1kyCU5MJG2g==
Received: from BN9PR03CA0192.namprd03.prod.outlook.com (2603:10b6:408:f9::17)
 by PH0PR12MB5451.namprd12.prod.outlook.com (2603:10b6:510:ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Sun, 19 Sep
 2021 11:56:04 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::22) by BN9PR03CA0192.outlook.office365.com
 (2603:10b6:408:f9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Sun, 19 Sep 2021 11:56:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Sun, 19 Sep 2021 11:56:04 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 19 Sep
 2021 11:56:04 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 19 Sep
 2021 11:56:03 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 19 Sep 2021 04:56:01 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        "Moshe Shemesh" <moshe@nvidia.com>, Lama Kayal <lkayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx4_en: Resolve bad operstate value
Date:   Sun, 19 Sep 2021 14:55:45 +0300
Message-ID: <20210919115545.28530-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 175bb3ef-9d42-4d98-5a20-08d97b647586
X-MS-TrafficTypeDiagnostic: PH0PR12MB5451:
X-Microsoft-Antispam-PRVS: <PH0PR12MB5451D8866FF9744FAF8D7EDCA3DF9@PH0PR12MB5451.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KhozezsuTIs/j2yLTbku5NSLACJvHBcaf+1MSWKcUcmbnzsm64Kbb6CduyPUpv7Xr8eGVRGhIyexHph3KnlNVWpkVXA072ki03B42w8xP5qsEdC3MWq5IOlfUS2pBNGUn0B8zvNOEgHHFPCS6R2wcZ640OAmiSUFOZn7nMYfjyaAFmhCyNCylH+tISdilNW5fPBtFAMN9AGDXVNNbLb+iQTPixuGEpUYPC6OBIYh1rnKe+IksTBeDZnDbJv0AYBQm4K7/f9kpsuaVxl/Z2po3gaimpdfeyNLSUQQsgisQKF+FrOCb7RLG8rhaem8cQPEJ+I224GaXIcebghx+kOpqBypLeaKdx4QiuenHcuK1tEsrxbps+K6g7rrRu5QLpJ8fBM1QW3M3IIJOfat/Tpp3zt2lPD0rcqV/+2q5zmv+5pHvGTEQXy17OKEvzKXbVgjpd6dwSGCAmzd1yjfrX3aHqvw8l5Yz/bZsw43KJ63J9lLS7ZLegnooi1mV9eGH7Lm7YD0HOVMnQnLcpIJWgqsSQZ4/CkkGdLgHVp8SJ7tRxJ2WcZjj43PV1dEOPGgLRAFKO6A8lupNZsUt4GRQV9qFuOoaaSnCe0C9PsaIIFTQMC53yNNmQHuHciEzADNJXn/jF1BhRcfDhMH5+4zi+kf+wpoO3VPKCDudOoRdOkjt9fU6zEunXtJaaEZdmqCVOk/0r7WeiLFibaoRQf25zL2mA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36756003)(356005)(2906002)(26005)(2616005)(8936002)(36906005)(82310400003)(110136005)(316002)(1076003)(7636003)(86362001)(186003)(70586007)(47076005)(36860700001)(7696005)(5660300002)(6666004)(8676002)(83380400001)(336012)(426003)(508600001)(4326008)(70206006)(54906003)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2021 11:56:04.6808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 175bb3ef-9d42-4d98-5a20-08d97b647586
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5451
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Any link state change that's done prior to net device registration
isn't reflected on the state, thus the operational state is left
obsolete, with 'UNKNOWN' status.

To resolve the issue, query link state from FW upon open operations
to ensure operational state is updated.

Fixes: c27a02cd94d6 ("mlx4_en: Add driver for Mellanox ConnectX 10GbE NIC")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 47 ++++++++++++-------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  1 -
 2 files changed, 29 insertions(+), 19 deletions(-)

Hi,
Please queue to -stable.

Thanks,
Tariq

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index a2f61a87cef8..35154635ec3a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1269,7 +1269,6 @@ static void mlx4_en_do_set_rx_mode(struct work_struct *work)
 	if (!netif_carrier_ok(dev)) {
 		if (!mlx4_en_QUERY_PORT(mdev, priv->port)) {
 			if (priv->port_state.link_state) {
-				priv->last_link_state = MLX4_DEV_EVENT_PORT_UP;
 				netif_carrier_on(dev);
 				en_dbg(LINK, priv, "Link Up\n");
 			}
@@ -1557,26 +1556,36 @@ static void mlx4_en_service_task(struct work_struct *work)
 	mutex_unlock(&mdev->state_lock);
 }
 
-static void mlx4_en_linkstate(struct work_struct *work)
+static void mlx4_en_linkstate(struct mlx4_en_priv *priv)
+{
+	struct mlx4_en_port_state *port_state = &priv->port_state;
+	struct mlx4_en_dev *mdev = priv->mdev;
+	struct net_device *dev = priv->dev;
+	bool up;
+
+	if (mlx4_en_QUERY_PORT(mdev, priv->port))
+		port_state->link_state = MLX4_PORT_STATE_DEV_EVENT_PORT_DOWN;
+
+	up = port_state->link_state == MLX4_PORT_STATE_DEV_EVENT_PORT_UP;
+	if (up == netif_carrier_ok(dev))
+		netif_carrier_event(dev);
+	if (!up) {
+		en_info(priv, "Link Down\n");
+		netif_carrier_off(dev);
+	} else {
+		en_info(priv, "Link Up\n");
+		netif_carrier_on(dev);
+	}
+}
+
+static void mlx4_en_linkstate_work(struct work_struct *work)
 {
 	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
 						 linkstate_task);
 	struct mlx4_en_dev *mdev = priv->mdev;
-	int linkstate = priv->link_state;
 
 	mutex_lock(&mdev->state_lock);
-	/* If observable port state changed set carrier state and
-	 * report to system log */
-	if (priv->last_link_state != linkstate) {
-		if (linkstate == MLX4_DEV_EVENT_PORT_DOWN) {
-			en_info(priv, "Link Down\n");
-			netif_carrier_off(priv->dev);
-		} else {
-			en_info(priv, "Link Up\n");
-			netif_carrier_on(priv->dev);
-		}
-	}
-	priv->last_link_state = linkstate;
+	mlx4_en_linkstate(priv);
 	mutex_unlock(&mdev->state_lock);
 }
 
@@ -2079,9 +2088,11 @@ static int mlx4_en_open(struct net_device *dev)
 	mlx4_en_clear_stats(dev);
 
 	err = mlx4_en_start_port(dev);
-	if (err)
+	if (err) {
 		en_err(priv, "Failed starting port:%d\n", priv->port);
-
+		goto out;
+	}
+	mlx4_en_linkstate(priv);
 out:
 	mutex_unlock(&mdev->state_lock);
 	return err;
@@ -3168,7 +3179,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	spin_lock_init(&priv->stats_lock);
 	INIT_WORK(&priv->rx_mode_task, mlx4_en_do_set_rx_mode);
 	INIT_WORK(&priv->restart_task, mlx4_en_restart);
-	INIT_WORK(&priv->linkstate_task, mlx4_en_linkstate);
+	INIT_WORK(&priv->linkstate_task, mlx4_en_linkstate_work);
 	INIT_DELAYED_WORK(&priv->stats_task, mlx4_en_do_get_stats);
 	INIT_DELAYED_WORK(&priv->service_task, mlx4_en_service_task);
 #ifdef CONFIG_RFS_ACCEL
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index f3d1a20201ef..6bf558c5ec10 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -552,7 +552,6 @@ struct mlx4_en_priv {
 
 	struct mlx4_hwq_resources res;
 	int link_state;
-	int last_link_state;
 	bool port_up;
 	int port;
 	int registered;
-- 
2.21.0

