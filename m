Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9784620679
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiKHCIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiKHCIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:08:23 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E376638D;
        Mon,  7 Nov 2022 18:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667873302; x=1699409302;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i/dLpV2uFjEVIuCUEjBPXiMF2Qtt/k5JOyenuO0QQz0=;
  b=C6srNNIhEhb76aYNHdKzhPs3/l8VECFnAW+NgYkt3TGHdi97sfFH0C3H
   nePra7KVgW+BUoXb4EdMu4dgYeulOlYmXXWmxZ4nTVIpwXcH3gfiiVgm4
   mPNxq9G2Xja3GrJF7HBxn+jT6zOTd9NZ5LmT9awwoNIitAmwqlUAazN3M
   pkFufHameSMXXA+tzupDsxfTsjg+GBtmEtcj3At01S6Ucq6JwO+ebyFjF
   SWCx8751K4qPGcyxl6O7maMpP8P4rYsti2uIBXsp8aOF8LU702kgcAxXY
   HXAvlgor9SHHsPdiaxHR3p9jGsoToUnxNdAyVpSjFC8scEEED5neN7qFz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="372719715"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="372719715"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 18:08:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811064706"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811064706"
Received: from ganyifangubuntu20-ilbpg12.png.intel.com ([10.88.229.31])
  by orsmga005.jf.intel.com with ESMTP; 07 Nov 2022 18:08:17 -0800
From:   Gan Yi Fang <yi.fang.gan@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gan Yi Fang <yi.fang.gan@intel.com>
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>
Subject: [PATCH net 1/1] stmmac: intel: Update PCH PTP clock rate from 200MHz to 204.8MHz
Date:   Mon,  7 Nov 2022 21:08:11 -0500
Message-Id: <20221108020811.12919-1-yi.fang.gan@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Tan, Tee Min" <tee.min.tan@intel.com>

Current Intel platform has an output of ~976ms interval
when probed on 1 Pulse-per-Second(PPS) hardware pin.

The correct PTP clock frequency for PCH GbE should be 204.8MHz
instead of 200MHz. PSE GbE PTP clock rate remains at 200MHz.

Fixes: 58da0cfa6cf1 ("net: stmmac: create dwmac-intel.c to contain all Intel platform")
Signed-off-by: Ling Pei Lee <pei.lee.ling@intel.com>
Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Gan Yi Fang <yi.fang.gan@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 0a2afc1a3124..7deb1f817dac 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -629,7 +629,6 @@ static int ehl_common_data(struct pci_dev *pdev,
 {
 	plat->rx_queues_to_use = 8;
 	plat->tx_queues_to_use = 8;
-	plat->clk_ptp_rate = 200000000;
 	plat->use_phy_wol = 1;
 
 	plat->safety_feat_cfg->tsoee = 1;
@@ -654,6 +653,8 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 
+	plat->clk_ptp_rate = 204800000;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -667,6 +668,8 @@ static int ehl_rgmii_data(struct pci_dev *pdev,
 	plat->bus_id = 1;
 	plat->phy_interface = PHY_INTERFACE_MODE_RGMII;
 
+	plat->clk_ptp_rate = 204800000;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -683,6 +686,8 @@ static int ehl_pse0_common_data(struct pci_dev *pdev,
 	plat->bus_id = 2;
 	plat->addr64 = 32;
 
+	plat->clk_ptp_rate = 200000000;
+
 	intel_mgbe_pse_crossts_adj(intel_priv, EHL_PSE_ART_MHZ);
 
 	return ehl_common_data(pdev, plat);
@@ -722,6 +727,8 @@ static int ehl_pse1_common_data(struct pci_dev *pdev,
 	plat->bus_id = 3;
 	plat->addr64 = 32;
 
+	plat->clk_ptp_rate = 200000000;
+
 	intel_mgbe_pse_crossts_adj(intel_priv, EHL_PSE_ART_MHZ);
 
 	return ehl_common_data(pdev, plat);
@@ -757,7 +764,7 @@ static int tgl_common_data(struct pci_dev *pdev,
 {
 	plat->rx_queues_to_use = 6;
 	plat->tx_queues_to_use = 4;
-	plat->clk_ptp_rate = 200000000;
+	plat->clk_ptp_rate = 204800000;
 	plat->speed_mode_2500 = intel_speed_mode_2500;
 
 	plat->safety_feat_cfg->tsoee = 1;
-- 
2.34.1

