Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DF615530D
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 08:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgBGHev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 02:34:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:15598 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgBGHev (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 02:34:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 23:34:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,412,1574150400"; 
   d="scan'208";a="264900707"
Received: from unknown (HELO bong5-HP-Z440.png.intel.com) ([10.221.118.166])
  by fmsmga002.fm.intel.com with ESMTP; 06 Feb 2020 23:34:47 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     netdev@vger.kernel.org
Cc:     Tan Tee Min <tee.min.tan@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v5 5/5] net: stmmac: update pci platform data to use phy_interface
Date:   Fri,  7 Feb 2020 15:34:28 +0800
Message-Id: <20200207073428.9562-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

The recent patch to support passive mode converter did not take care the
phy interface configuration in PCI platform data. Hence, converting all
the PCI platform data from plat->interface to plat->phy_interface as the
default mode is meant for PHY.

Fixes: 0060c8783330 ("net: stmmac: implement support for passive mode converters via dt")
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Tested-by: Tan, Tee Min <tee.min.tan@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 623521052152..fe2c9fa6a71c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -95,7 +95,7 @@ static int stmmac_default_data(struct pci_dev *pdev,
 
 	plat->bus_id = 1;
 	plat->phy_addr = 0;
-	plat->interface = PHY_INTERFACE_MODE_GMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_GMII;
 
 	plat->dma_cfg->pbl = 32;
 	plat->dma_cfg->pblx8 = true;
@@ -217,7 +217,8 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_addr = 0;
-	plat->interface = PHY_INTERFACE_MODE_SGMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -230,7 +231,8 @@ static int ehl_rgmii_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_addr = 0;
-	plat->interface = PHY_INTERFACE_MODE_RGMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_RGMII;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -258,7 +260,7 @@ static int tgl_sgmii_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_addr = 0;
-	plat->interface = PHY_INTERFACE_MODE_SGMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
 	return tgl_common_data(pdev, plat);
 }
 
@@ -358,7 +360,7 @@ static int quark_default_data(struct pci_dev *pdev,
 
 	plat->bus_id = pci_dev_id(pdev);
 	plat->phy_addr = ret;
-	plat->interface = PHY_INTERFACE_MODE_RMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_RMII;
 
 	plat->dma_cfg->pbl = 16;
 	plat->dma_cfg->pblx8 = true;
@@ -415,7 +417,7 @@ static int snps_gmac5_default_data(struct pci_dev *pdev,
 
 	plat->bus_id = 1;
 	plat->phy_addr = -1;
-	plat->interface = PHY_INTERFACE_MODE_GMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_GMII;
 
 	plat->dma_cfg->pbl = 32;
 	plat->dma_cfg->pblx8 = true;
-- 
2.17.1

