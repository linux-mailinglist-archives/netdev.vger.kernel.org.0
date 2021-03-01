Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF73327C0E
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhCAK1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:27:05 -0500
Received: from mail-vi1eur05on2057.outbound.protection.outlook.com ([40.107.21.57]:24961
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234280AbhCAK0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 05:26:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDHMxEgMx5HWXaHix+I7vbbIaGVcAWPw4MPDwHdHYBYdepbVp3xsNI6kUKpkcTUVLAGmZz35tpFPci16rKMhUD5Rl/rfHq4BIQg5WMyVuHAB6Jko/ZG2rE7etxPdsVnlgLjT63ZvftwbZS8sC4iaqim8CjOIMAhpixXX2+A6zMkZrQWKFVFJdd2Ai6FHK2DcAbaKHpJ8/4vTfxF5VJr9217VkHdx006XmkokbikNiDZVnBH6YZLkYJR+KzQ8GMhSPkeR+hlmn9QjBD3ydGh8U5Jy52ZVVYFNMdL6wkp/TGHQddYDgiXRazt29jLSLzaFHkSMeoyZiXD0Fb39Zx/PBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3X6/J8WhEgmLeMzc8V9xRYMsQ18+O53uzRfM49YCnE=;
 b=eyKp6YYpBoZEuhuAb8iVB7yJrAWfryrlFkrc/wdMybRSNwAnzuSUwfzhi+Nwr0w2tgS6Y7GPyKjvHigyR4u0CUW2zrcS3/qK/fKcLifxoV6tknZRexyqFvSo3tz/mpvPlulnxlTHa7e0s4zvykUxR4cSIjC3eyb5NCenWZBX3Rf/aUNNfCQaheMvtfVTAHSiQ4CuQBkZfD1JG2NkmgH+Z8rkXooJgDdQaI05NMMyw76ikXz0XldlyQQfDdNBwAiMBSEZ5hB10xXhy7ZjFTV+4SukV8ctghahsM1mSZubSO45huiP8efJ12ODf1fmCzmvNCzwGbaDJO783koIfe42Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3X6/J8WhEgmLeMzc8V9xRYMsQ18+O53uzRfM49YCnE=;
 b=VoWKgWDRqHYlUSEL3ZDiIRB0b5oeFVtD9TuImwgwGaWerrf27GVSegeQr/ycrxSNao8Rt84Mup/hQa59GwY35G2+3xwof2lWZvZhBejpG23I8y7X080lzbyoBS7X2xwONqc0eDJjTb65CoZE7OqG5dgMuhWlcbjvTc9SklX303g=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4953.eurprd04.prod.outlook.com (2603:10a6:10:13::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Mon, 1 Mar
 2021 10:25:17 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 10:25:17 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [RFC V2 resend net-next 1/3] net: stmmac: add clocks management for gmac driver
Date:   Mon,  1 Mar 2021 18:25:27 +0800
Message-Id: <20210301102529.18573-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
References: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR04CA0045.apcprd04.prod.outlook.com
 (2603:1096:202:14::13) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR04CA0045.apcprd04.prod.outlook.com (2603:1096:202:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Mon, 1 Mar 2021 10:25:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fcb1585b-5367-4fe9-1019-08d8dc9c4ec8
X-MS-TrafficTypeDiagnostic: DB7PR04MB4953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4953E852DF3DE17E13E19CFAE69A9@DB7PR04MB4953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HD7n5z1ZYOKwUv+3Lgg2NO2NKfa2kkfj5mEdf+7k6icRUi046z6GThzFhLTmJK9CRpVtjsOchu5ZaqGDiMTZszku8xHFscfKy5AqoFfB37ENmIEkrAIr1OJujr03+C7BLTdxGNsLQeE04uVpyfOTNCVlrPKb2hHyu+hrD/gD0muip5VnVGV4rC+5arzdNSd5MzAu7vIkJxCO4iAnjx0fo2fPiA42TfMWnHOtYns+5a5lWCbdRAf5H2GTNhg7h5kIJ6ROBLxIxUXNRyT/avnirZAm5ta1oJoDZDrNPEM/x4z37TLW3RthuK0EtWydBiezFWiAZR+En5xTzvXfhJgb8DUw73nyjO2Tf4pzTFO4Lq0q6s2cWFBsfesG6HqSSIEOt5GRU+cXtzNtopmPZD3VWJzGEA5jYh/Rf99zdNdePa1dDtx4QezlZ7Dw2FZ8SsuM2mNvEmjxbolIqCC29suullCbnm94aYzjNdibMK1BpHph31WKSIhrpo5hEr/1BZk8BOm6uXeE7ODqm8uDWhuK/JUyO4zPwNk05n8k9G5H5rWTINufFuDuR9geigPDKgdo8SwzNQdGo7V3HKLrI8MeIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(5660300002)(6666004)(6512007)(30864003)(2906002)(1076003)(86362001)(52116002)(6506007)(36756003)(478600001)(6486002)(26005)(69590400012)(186003)(66476007)(8676002)(316002)(16526019)(4326008)(2616005)(956004)(83380400001)(8936002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QrgKILqgt0QmhDV4OIvBBoQrzeVweLD7fH5i6O0q3OV/mn957HxzrCqDFQXc?=
 =?us-ascii?Q?VK1hI1Jj7sNiPsL4E1SMZnbljd+l5n4dOEp1bP2c2HJ/hBeBMugmw+hk7oUZ?=
 =?us-ascii?Q?HDItIsfsTjhIVGrf7ZpWRUAvdkkGXSOfoiBX+ptVTWpfCrWT3pUVZdgvWIwg?=
 =?us-ascii?Q?gx6tWIEPqJD5fT63uV6MWT6puz5D6C+U7S48SzGas0O5qMDgn0YcsGiSr6c/?=
 =?us-ascii?Q?zonU+tyKxj0T5z0CrcNIzpZ297GQejkUEqLpg624z0jWKjVEG6BPCSCQllGE?=
 =?us-ascii?Q?UoytRaloUluK1hQNzpFlEfI39+pydjp7WEVd8zx2ApHE4gVE+bl9QSvzsm0A?=
 =?us-ascii?Q?gNDa4TbihJ1/9ihllNj9EcPf+8s6QQ+hTZqmZIbp6wpw78XaFlNQ4nb91Uex?=
 =?us-ascii?Q?xXw/2kvoMhSfH0UEijSfM4cctw6t1onB3fB7J+vPQbsEzhtnFomb2M5aDnMK?=
 =?us-ascii?Q?6y7hnYXT+HWnq0iIOrofg2zUG2EhMgrW4d9WpkiBIHKg87Y8voyMK/X1BXRT?=
 =?us-ascii?Q?E0SLP/73ZnFyN7xXY3f38C1MkT3pazSC6GqT28sdw3v9TMOcZ3vcukrCXAcG?=
 =?us-ascii?Q?phyZ6qcotln5EBnm7sMdNnmzGRln4xHHyX+Xxr7v3lOGgfa+epcTgrX/Ce0c?=
 =?us-ascii?Q?mFDte5kFU114cXRHmRnpMSvMS88ly+iKTS6m3RgcACaocKW2gi1wlwX1PIzS?=
 =?us-ascii?Q?Kza3/l4RyDMLjwkfcFa7dUXVmiWl2MHwkV61mYNcplMVgTIJuGS+7a1q9Euv?=
 =?us-ascii?Q?05bTPD4aw3fgRLb+maDrxt7cWqmA2nL80wodu0FibwoEM97172FCUO42sb4n?=
 =?us-ascii?Q?mhxTRXCgDiNQBACH7YWkt8ksB2Ka3uWi9KG0l2tkGEJB51lbOoCHbmecOcrI?=
 =?us-ascii?Q?NIEabjb5pWh4nBoiLTv7iPQOjM/dxTKEL9Y7yQJn76YbGIupmeWE0JzZZfG2?=
 =?us-ascii?Q?8JvfMxgDlo5Ee7+gQZNTCjobfj7tsGV2KbQiP+YrHnyviAiQ4ZlcdpjWXZ5k?=
 =?us-ascii?Q?oCjmdNd3gBNVkN6qV7MNrrhaUMDOx3J5Jf1ZYFXjRwh9oq/tHuxfAh96eMKt?=
 =?us-ascii?Q?YEQPpbsdj7O0bOsSQjb43zEe4K/3t3ZUo8xn25JkWLgTCL54P3I/P4DvX9t3?=
 =?us-ascii?Q?DQ5U4gh9RQjY4VVsFsoAsnzR+8bMiDYFcNSn2EcC5py9Pwa9M9TdWi5TtqLD?=
 =?us-ascii?Q?DSeI6aPawO8zV2YSmeHtlBaPC5AhBaYTX8EgGBlgH2wmW2s438blXpgFaM3t?=
 =?us-ascii?Q?C6wkKpUAuOceptFkkA/VnKvst6WwnsvAGQcDB2d9ftRarWrxy023vKcB7nkk?=
 =?us-ascii?Q?BKpA/u1x5Kuxv098ilRRddzB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb1585b-5367-4fe9-1019-08d8dc9c4ec8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 10:25:16.9739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZlUsOqhFBG5xKXbNfZ1Qpl2MZaoXZfg6LKyQSIaqptnPg9OLzqhFgF2oYgqy2FABCC96l8WJUcI7FlKp3CK/kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to add clocks management for stmmac driver:

If CONFIG_PM enabled:
1. Keep clocks disabled after driver probed.
2. Enable clocks when up the net device, and disable clocks when down
the net device.

If CONFIG_PM disabled:
Keep clocks always enabled after driver probed.

Note:
1. It is fine for ethtool, since the way of implementing ethtool_ops::begin
in stmmac is only can be accessed when interface is enabled, so the clocks
are ticked.
2. The MDIO bus has a different life cycle to the MAC, need ensure
clocks are enabled when _mdio_read/write() need clocks, because these
functions can be called while the interface it not opened.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  75 +++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 123 ++++++++++++++----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  24 +++-
 4 files changed, 184 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index e553b9a1f785..10e8ae8e2d58 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -272,6 +272,7 @@ void stmmac_disable_eee_mode(struct stmmac_priv *priv);
 bool stmmac_eee_init(struct stmmac_priv *priv);
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
 int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
+int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled);
 
 #if IS_ENABLED(CONFIG_STMMAC_SELFTESTS)
 void stmmac_selftest_run(struct net_device *dev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 26b971cd4da5..b4bc1c2104df 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -28,6 +28,7 @@
 #include <linux/if_vlan.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <linux/prefetch.h>
 #include <linux/pinctrl/consumer.h>
 #ifdef CONFIG_DEBUG_FS
@@ -113,6 +114,28 @@ static void stmmac_exit_fs(struct net_device *dev);
 
 #define STMMAC_COAL_TIMER(x) (ns_to_ktime((x) * NSEC_PER_USEC))
 
+int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled)
+{
+	int ret = 0;
+
+	if (enabled) {
+		ret = clk_prepare_enable(priv->plat->stmmac_clk);
+		if (ret)
+			return ret;
+		ret = clk_prepare_enable(priv->plat->pclk);
+		if (ret) {
+			clk_disable_unprepare(priv->plat->stmmac_clk);
+			return ret;
+		}
+	} else {
+		clk_disable_unprepare(priv->plat->stmmac_clk);
+		clk_disable_unprepare(priv->plat->pclk);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmmac_bus_clks_config);
+
 /**
  * stmmac_verify_args - verify the driver parameters.
  * Description: it checks the driver parameters and set a default in case of
@@ -2800,6 +2823,12 @@ static int stmmac_open(struct net_device *dev)
 	u32 chan;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
 	    priv->hw->xpcs == NULL) {
@@ -2808,7 +2837,7 @@ static int stmmac_open(struct net_device *dev)
 			netdev_err(priv->dev,
 				   "%s: Cannot attach to PHY (error: %d)\n",
 				   __func__, ret);
-			return ret;
+			goto init_phy_error;
 		}
 	}
 
@@ -2924,6 +2953,8 @@ static int stmmac_open(struct net_device *dev)
 	free_dma_desc_resources(priv);
 dma_desc_error:
 	phylink_disconnect_phy(priv->phylink);
+init_phy_error:
+	pm_runtime_put(priv->device);
 	return ret;
 }
 
@@ -2974,6 +3005,8 @@ static int stmmac_release(struct net_device *dev)
 
 	stmmac_release_ptp(priv);
 
+	pm_runtime_put(priv->device);
+
 	return 0;
 }
 
@@ -4624,6 +4657,12 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	bool is_double = false;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
 
@@ -4632,10 +4671,15 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	if (priv->hw->num_vlan) {
 		ret = stmmac_del_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
 		if (ret)
-			return ret;
+			goto del_vlan_error;
 	}
 
-	return stmmac_vlan_update(priv, is_double);
+	ret = stmmac_vlan_update(priv, is_double);
+
+del_vlan_error:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 static const struct net_device_ops stmmac_netdev_ops = {
@@ -5074,6 +5118,10 @@ int stmmac_dvr_probe(struct device *device,
 
 	stmmac_check_pcs_mode(priv);
 
+	pm_runtime_get_noresume(device);
+	pm_runtime_set_active(device);
+	pm_runtime_enable(device);
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI) {
 		/* MDIO bus Registration */
@@ -5111,6 +5159,11 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_init_fs(ndev);
 #endif
 
+	/* Let pm_runtime_put() disable the clocks.
+	 * If CONFIG_PM is not enabled, the clocks will stay powered.
+	 */
+	pm_runtime_put(device);
+
 	return ret;
 
 error_serdes_powerup:
@@ -5125,6 +5178,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_del(ndev);
 error_hw_init:
 	destroy_workqueue(priv->wq);
+	stmmac_bus_clks_config(priv, false);
 
 	return ret;
 }
@@ -5157,8 +5211,8 @@ int stmmac_dvr_remove(struct device *dev)
 	phylink_destroy(priv->phylink);
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
-	clk_disable_unprepare(priv->plat->pclk);
-	clk_disable_unprepare(priv->plat->stmmac_clk);
+	pm_runtime_put(dev);
+	pm_runtime_disable(dev);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
@@ -5181,6 +5235,7 @@ int stmmac_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	u32 chan;
+	int ret;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -5224,8 +5279,9 @@ int stmmac_suspend(struct device *dev)
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
 		clk_disable_unprepare(priv->plat->clk_ptp_ref);
-		clk_disable_unprepare(priv->plat->pclk);
-		clk_disable_unprepare(priv->plat->stmmac_clk);
+		ret = pm_runtime_force_suspend(dev);
+		if (ret)
+			return ret;
 	}
 	mutex_unlock(&priv->lock);
 
@@ -5289,8 +5345,9 @@ int stmmac_resume(struct device *dev)
 	} else {
 		pinctrl_pm_select_default_state(priv->device);
 		/* enable the clk previously disabled */
-		clk_prepare_enable(priv->plat->stmmac_clk);
-		clk_prepare_enable(priv->plat->pclk);
+		ret = pm_runtime_force_resume(dev);
+		if (ret)
+			return ret;
 		if (priv->plat->clk_ptp_ref)
 			clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index d64116e0543e..4950e7ba3716 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -15,6 +15,7 @@
 #include <linux/iopoll.h>
 #include <linux/mii.h>
 #include <linux/of_mdio.h>
+#include <linux/pm_runtime.h>
 #include <linux/phy.h>
 #include <linux/property.h>
 #include <linux/slab.h>
@@ -85,23 +86,31 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
 	u32 tmp, addr, value = MII_XGMAC_BUSY;
-	int ret;
+	int ret, data = 0;
+
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	if (phyreg & MII_ADDR_C45) {
 		phyreg &= ~MII_ADDR_C45;
 
 		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 	} else {
 		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 
 		value |= MII_XGMAC_SADDR;
 	}
@@ -112,8 +121,10 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to read */
 	writel(addr, priv->ioaddr + mii_address);
@@ -121,11 +132,22 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Read the data from the MII data register */
-	return readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
+	data = (int)readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
+
+	pm_runtime_put(priv->device);
+
+	return data;
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
@@ -138,21 +160,29 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 	u32 addr, tmp, value = MII_XGMAC_BUSY;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	if (phyreg & MII_ADDR_C45) {
 		phyreg &= ~MII_ADDR_C45;
 
 		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 	} else {
 		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 
 		value |= MII_XGMAC_SADDR;
 	}
@@ -164,16 +194,23 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to write */
 	writel(addr, priv->ioaddr + mii_address);
 	writel(value, priv->ioaddr + mii_data);
 
 	/* Wait until any existing MII operation is complete */
-	return readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-				  !(tmp & MII_XGMAC_BUSY), 100, 10000);
+	ret = readl_poll_timeout(priv->ioaddr + mii_data, tmp,
+				 !(tmp & MII_XGMAC_BUSY), 100, 10000);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
@@ -193,9 +230,15 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
 	u32 value = MII_BUSY;
-	int data = 0;
+	int ret, data = 0;
 	u32 v;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
@@ -216,20 +259,31 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	}
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Read the data from the MII data register */
 	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
 
+	pm_runtime_put(priv->device);
+
 	return data;
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
@@ -247,10 +301,16 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
+	int ret, data = phydata;
 	u32 value = MII_BUSY;
-	int data = phydata;
 	u32 v;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
@@ -275,16 +335,23 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to write */
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	/* Wait until any existing MII operation is complete */
-	return readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-				  100, 10000);
+	ret = readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+				 100, 10000);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 6dc9f10414e4..a70b0bc84b2a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -744,10 +744,30 @@ static int stmmac_pltfr_resume(struct device *dev)
 
 	return stmmac_resume(dev);
 }
+
+static int stmmac_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	stmmac_bus_clks_config(priv, false);
+
+	return 0;
+}
+
+static int stmmac_runtime_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	return stmmac_bus_clks_config(priv, true);
+}
 #endif /* CONFIG_PM_SLEEP */
 
-SIMPLE_DEV_PM_OPS(stmmac_pltfr_pm_ops, stmmac_pltfr_suspend,
-				       stmmac_pltfr_resume);
+const struct dev_pm_ops stmmac_pltfr_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_suspend, stmmac_pltfr_resume)
+	SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
+};
 EXPORT_SYMBOL_GPL(stmmac_pltfr_pm_ops);
 
 MODULE_DESCRIPTION("STMMAC 10/100/1000 Ethernet platform support");
-- 
2.17.1

