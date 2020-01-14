Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 247E1138EBF
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgAMKNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:13:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:10161 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbgAMKNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 05:13:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 02:13:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,428,1571727600"; 
   d="scan'208";a="397116867"
Received: from bong5-hp-z440.png.intel.com ([10.221.118.136])
  by orsmga005.jf.intel.com with ESMTP; 13 Jan 2020 02:13:45 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 7/7] net: stmmac: update pci platform data to use phy_interface
Date:   Tue, 14 Jan 2020 10:01:16 +0800
Message-Id: <1578967276-55956-8-git-send-email-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578967276-55956-1-git-send-email-boon.leong.ong@intel.com>
References: <1578967276-55956-1-git-send-email-boon.leong.ong@intel.com>
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
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 8237dbc..d2bc04d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -96,7 +96,7 @@ static int stmmac_default_data(struct pci_dev *pdev,
 
 	plat->bus_id = 1;
 	plat->phy_addr = 0;
-	plat->interface = PHY_INTERFACE_MODE_GMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_GMII;
 
 	plat->dma_cfg->pbl = 32;
 	plat->dma_cfg->pblx8 = true;
@@ -220,7 +220,8 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_addr = 0;
-	plat->interface = PHY_INTERFACE_MODE_SGMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -233,7 +234,8 @@ static int ehl_rgmii_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_addr = 0;
-	plat->interface = PHY_INTERFACE_MODE_RGMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_RGMII;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -261,7 +263,7 @@ static int tgl_sgmii_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_addr = 0;
-	plat->interface = PHY_INTERFACE_MODE_SGMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
 	return tgl_common_data(pdev, plat);
 }
 
@@ -361,7 +363,7 @@ static int quark_default_data(struct pci_dev *pdev,
 
 	plat->bus_id = pci_dev_id(pdev);
 	plat->phy_addr = ret;
-	plat->interface = PHY_INTERFACE_MODE_RMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_RMII;
 
 	plat->dma_cfg->pbl = 16;
 	plat->dma_cfg->pblx8 = true;
@@ -418,7 +420,7 @@ static int snps_gmac5_default_data(struct pci_dev *pdev,
 
 	plat->bus_id = 1;
 	plat->phy_addr = -1;
-	plat->interface = PHY_INTERFACE_MODE_GMII;
+	plat->phy_interface = PHY_INTERFACE_MODE_GMII;
 
 	plat->dma_cfg->pbl = 32;
 	plat->dma_cfg->pblx8 = true;
-- 
2.7.4

