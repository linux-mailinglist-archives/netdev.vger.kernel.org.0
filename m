Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108D54C3BB7
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 03:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiBYC1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 21:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiBYC1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 21:27:41 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3E040912;
        Thu, 24 Feb 2022 18:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645756029; x=1677292029;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pGMxtqj6fQbBiqvL8b0jEE020+1PJHR6Ska29JmSylg=;
  b=ZwtE9RVNVEyFNPwaYM1RxUMkTNN56BilkbjHQQ248kMvPsNFcStVG+pu
   xm/J2TbbU2yyOaSzB3udNFdOvG0vfXM7AADMdmrE1dKpj054gkkm6/WUE
   MMF84VE7Kzk23xUUQL239f08zQkFpywAfBJnzEi08WwLkjYmx1A1teBaQ
   DMKDVS2/A+lIWVWL5vg9so/zlT7wwG/WEFb82rPZ52dYVrhspPF6wCi3U
   uRCvLQGVPndy7e+zmXyE9Ny4ev7aSyh8G27z8N+k6MZTSqNSo4hg/H9fL
   ZjTnbPFw77CaqDzQVSTheXPAtEXbzu3idBZl7kO8cNqwdEPP6iOemq8+M
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252132192"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="252132192"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 18:27:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="509107432"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 24 Feb 2022 18:27:09 -0800
Received: from P12HL01TMIN.png.intel.com (P12HL01TMIN.png.intel.com [10.158.65.75])
        by linux.intel.com (Postfix) with ESMTP id CC0B5580A6C;
        Thu, 24 Feb 2022 18:27:06 -0800 (PST)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/1] stmmac: intel: Enable 2.5Gbps for Intel AlderLake-S
Date:   Fri, 25 Feb 2022 10:33:25 +0800
Message-Id: <20220225023325.474242-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel AlderLake-S platform is capable of running on 2.5GBps link speed.

This patch enables 2.5Gbps link speed on AlderLake-S platform.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 5943ff9f21c2..32ef3df4e266 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -721,6 +721,7 @@ static int tgl_common_data(struct pci_dev *pdev,
 	plat->rx_queues_to_use = 6;
 	plat->tx_queues_to_use = 4;
 	plat->clk_ptp_rate = 200000000;
+	plat->speed_mode_2500 = intel_speed_mode_2500;
 
 	plat->safety_feat_cfg->tsoee = 1;
 	plat->safety_feat_cfg->mrxpee = 0;
@@ -740,7 +741,6 @@ static int tgl_sgmii_phy0_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
-	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 	return tgl_common_data(pdev, plat);
@@ -755,7 +755,6 @@ static int tgl_sgmii_phy1_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 2;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
-	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 	return tgl_common_data(pdev, plat);
-- 
2.25.1

