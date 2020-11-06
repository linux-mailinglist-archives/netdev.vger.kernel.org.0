Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40A62A92F8
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgKFJks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 04:40:48 -0500
Received: from mga05.intel.com ([192.55.52.43]:32829 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgKFJks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 04:40:48 -0500
IronPort-SDR: TWoiwc2yCoJo7ECPGeewuJw/3Os4doTgKcfjPN/ZUzsZ08tcf12I4fbvSZS2RXDZasBXBIwaPF
 5zVzQn6cwT/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="254230709"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="254230709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 01:40:47 -0800
IronPort-SDR: mFsLs/WbQF0CrQWu6INR/ALjXHhz2xqtBvAnYtd2IXKMvL88+duqxlA3zlLJNq3J+CTwO40l8W
 GFvX9a6FlZlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="354673376"
Received: from glass.png.intel.com ([172.30.181.98])
  by fmsmga004.fm.intel.com with ESMTP; 06 Nov 2020 01:40:43 -0800
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net-next 1/1] stmmac: intel: change all EHL/TGL to auto detect phy addr
Date:   Fri,  6 Nov 2020 17:43:41 +0800
Message-Id: <20201106094341.4241-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

Set all EHL/TGL phy_addr to -1 so that the driver will automatically
detect it at run-time by probing all the possible 32 addresses.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index b6e5e3e36b63..7c1353f37247 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -236,6 +236,7 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	int ret;
 	int i;
 
+	plat->phy_addr = -1;
 	plat->clk_csr = 5;
 	plat->has_gmac = 0;
 	plat->has_gmac4 = 1;
@@ -345,7 +346,6 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
 			  struct plat_stmmacenet_data *plat)
 {
 	plat->bus_id = 1;
-	plat->phy_addr = 0;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
 
 	plat->serdes_powerup = intel_serdes_powerup;
@@ -362,7 +362,6 @@ static int ehl_rgmii_data(struct pci_dev *pdev,
 			  struct plat_stmmacenet_data *plat)
 {
 	plat->bus_id = 1;
-	plat->phy_addr = 0;
 	plat->phy_interface = PHY_INTERFACE_MODE_RGMII;
 
 	return ehl_common_data(pdev, plat);
@@ -376,7 +375,6 @@ static int ehl_pse0_common_data(struct pci_dev *pdev,
 				struct plat_stmmacenet_data *plat)
 {
 	plat->bus_id = 2;
-	plat->phy_addr = 1;
 	return ehl_common_data(pdev, plat);
 }
 
@@ -408,7 +406,6 @@ static int ehl_pse1_common_data(struct pci_dev *pdev,
 				struct plat_stmmacenet_data *plat)
 {
 	plat->bus_id = 3;
-	plat->phy_addr = 1;
 	return ehl_common_data(pdev, plat);
 }
 
@@ -450,7 +447,6 @@ static int tgl_sgmii_data(struct pci_dev *pdev,
 			  struct plat_stmmacenet_data *plat)
 {
 	plat->bus_id = 1;
-	plat->phy_addr = 0;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
-- 
2.17.0

