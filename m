Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD8318D4D4
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCTQsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:48:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:37380 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbgCTQsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 12:48:32 -0400
IronPort-SDR: is2a0DLv2LsZ6FBYB4Rla/ajVPYVDzHbPiVKKJDqpBRdPqz5PxEmUGnjBKtf3lWvL8R0jbfbvg
 6RmGOWjQDMAg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 09:48:32 -0700
IronPort-SDR: 0FhMmNQ0m5L9FNomQATx8tSpjnqOYZ5nRDOy/SJo5svvu/1Bl8SVNG+zDbr0mEXhCgBFb2WVo7
 nRQqwp2NF3gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="239275167"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2020 09:48:29 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [net-next,v1, 1/3] net: stmmac: add EHL PSE0 & PSE1 1Gbps PCI info and PCI ID
Date:   Sat, 21 Mar 2020 00:48:23 +0800
Message-Id: <20200320164825.14200-2-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320164825.14200-1-weifeng.voon@intel.com>
References: <20200320164825.14200-1-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add EHL PSE0/1 RGMII & SGMII 1Gbps PCI info and PCI ID

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  | 72 +++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 7acbac73c29c..47f589968e66 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -240,6 +240,66 @@ static struct stmmac_pci_info ehl_rgmii1g_pci_info = {
 	.setup = ehl_rgmii_data,
 };
 
+static int ehl_pse0_common_data(struct pci_dev *pdev,
+				struct plat_stmmacenet_data *plat)
+{
+	plat->bus_id = 2;
+	plat->phy_addr = 1;
+	return ehl_common_data(pdev, plat);
+}
+
+static int ehl_pse0_rgmii1g_data(struct pci_dev *pdev,
+				 struct plat_stmmacenet_data *plat)
+{
+	plat->phy_interface = PHY_INTERFACE_MODE_RGMII_ID;
+	return ehl_pse0_common_data(pdev, plat);
+}
+
+static struct stmmac_pci_info ehl_pse0_rgmii1g_pci_info = {
+	.setup = ehl_pse0_rgmii1g_data,
+};
+
+static int ehl_pse0_sgmii1g_data(struct pci_dev *pdev,
+				 struct plat_stmmacenet_data *plat)
+{
+	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	return ehl_pse0_common_data(pdev, plat);
+}
+
+static struct stmmac_pci_info ehl_pse0_sgmii1g_pci_info = {
+	.setup = ehl_pse0_sgmii1g_data,
+};
+
+static int ehl_pse1_common_data(struct pci_dev *pdev,
+				struct plat_stmmacenet_data *plat)
+{
+	plat->bus_id = 3;
+	plat->phy_addr = 1;
+	return ehl_common_data(pdev, plat);
+}
+
+static int ehl_pse1_rgmii1g_data(struct pci_dev *pdev,
+				 struct plat_stmmacenet_data *plat)
+{
+	plat->phy_interface = PHY_INTERFACE_MODE_RGMII_ID;
+	return ehl_pse1_common_data(pdev, plat);
+}
+
+static struct stmmac_pci_info ehl_pse1_rgmii1g_pci_info = {
+	.setup = ehl_pse1_rgmii1g_data,
+};
+
+static int ehl_pse1_sgmii1g_data(struct pci_dev *pdev,
+				 struct plat_stmmacenet_data *plat)
+{
+	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	return ehl_pse1_common_data(pdev, plat);
+}
+
+static struct stmmac_pci_info ehl_pse1_sgmii1g_pci_info = {
+	.setup = ehl_pse1_sgmii1g_data,
+};
+
 static int tgl_common_data(struct pci_dev *pdev,
 			   struct plat_stmmacenet_data *plat)
 {
@@ -585,6 +645,10 @@ static SIMPLE_DEV_PM_OPS(stmmac_pm_ops, stmmac_pci_suspend, stmmac_pci_resume);
 #define PCI_DEVICE_ID_INTEL_QUARK_ID		0x0937
 #define PCI_DEVICE_ID_INTEL_EHL_RGMII1G_ID	0x4b30
 #define PCI_DEVICE_ID_INTEL_EHL_SGMII1G_ID	0x4b31
+#define PCI_DEVICE_ID_INTEL_EHL_PSE0_RGMII1G_ID	0x4ba0
+#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII1G_ID	0x4ba1
+#define PCI_DEVICE_ID_INTEL_EHL_PSE1_RGMII1G_ID	0x4bb0
+#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII1G_ID	0x4bb1
 #define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID	0xa0ac
 #define PCI_DEVICE_ID_SYNOPSYS_GMAC5_ID		0x7102
 
@@ -594,6 +658,14 @@ static const struct pci_device_id stmmac_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, QUARK_ID, &quark_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_RGMII1G_ID, &ehl_rgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII1G_ID, &ehl_sgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_RGMII1G_ID,
+			  &ehl_pse0_rgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII1G_ID,
+			  &ehl_pse0_sgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_RGMII1G_ID,
+			  &ehl_pse1_rgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII1G_ID,
+			  &ehl_pse1_sgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(SYNOPSYS, GMAC5_ID, &snps_gmac5_pci_info) },
 	{}
-- 
2.17.1

