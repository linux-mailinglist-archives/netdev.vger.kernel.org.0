Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35A12CF593
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 21:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388309AbgLDUVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 15:21:17 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:20048 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730090AbgLDUVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 15:21:12 -0500
Received: from pps.filterd (m0170391.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4KCA6Q001312;
        Fri, 4 Dec 2020 15:20:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=smtpout1;
 bh=YXiBzMDtFTt1Nnkq1FxQ/poJXuR1KHPhcYsDdLF324Y=;
 b=LH10oPuvb4w36p6alkKnFt62BgYpB7xwTXjw4oJiw/EdCZedY1LLuyvqfg0sWB95O7wn
 lbZ8MbXaaiyGsuoAPIcm0sSHnJlq7u2yEfyhVwTsFeyQZuP46kq0k25LUpicrmsFsHO8
 uBPWgIe0dBVjU4ntIM9/0BTf34/6MI1DEm1VCeojCIF9h8cXX3HZ8UnjR/WW/KrjwHNP
 KTjhtmjJEOdreOv5nB8yJZfRj+GRAoU/eoT6vZYkuMHYEjrb59PXNcR6gc9pENLzIgvA
 VJni1aOPlXjYD1+Uao0RXS6o3Hgt8OUXrik4fijdAbFImfeGI+132ZJwV9qvJuN5CZUq lg== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 353jk340r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 15:20:29 -0500
Received: from pps.filterd (m0144104.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4KDtgR159954;
        Fri, 4 Dec 2020 15:20:28 -0500
Received: from ausxipps310.us.dell.com (AUSXIPPS310.us.dell.com [143.166.148.211])
        by mx0b-00154901.pphosted.com with ESMTP id 357rmtkkh2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 15:20:28 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,393,1599541200"; 
   d="scan'208";a="573039889"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com,
        Mario Limonciello <mario.limonciello@dell.com>,
        Yijun Shen <yijun.shen@dell.com>
Subject: [PATCH v3 2/7] e1000e: Move all S0ix related code into its own source file
Date:   Fri,  4 Dec 2020 14:09:15 -0600
Message-Id: <20201204200920.133780-3-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201204200920.133780-1-mario.limonciello@dell.com>
References: <20201204200920.133780-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_09:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040115
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a flag to indicate the device should be using the S0ix
flows and use this flag to run those functions.

Splitting the code to it's own file will make future heuristics
more self contained.

Tested-by: Yijun Shen <yijun.shen@dell.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
---
 drivers/net/ethernet/intel/e1000e/Makefile |   2 +-
 drivers/net/ethernet/intel/e1000e/e1000.h  |   4 +
 drivers/net/ethernet/intel/e1000e/netdev.c | 272 +-------------------
 drivers/net/ethernet/intel/e1000e/s0ix.c   | 280 +++++++++++++++++++++
 4 files changed, 290 insertions(+), 268 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/e1000e/s0ix.c

diff --git a/drivers/net/ethernet/intel/e1000e/Makefile b/drivers/net/ethernet/intel/e1000e/Makefile
index 44e58b6e7660..f2332c01f86c 100644
--- a/drivers/net/ethernet/intel/e1000e/Makefile
+++ b/drivers/net/ethernet/intel/e1000e/Makefile
@@ -9,5 +9,5 @@ obj-$(CONFIG_E1000E) += e1000e.o
 
 e1000e-objs := 82571.o ich8lan.o 80003es2lan.o \
 	       mac.o manage.o nvm.o phy.o \
-	       param.o ethtool.o netdev.o ptp.o
+	       param.o ethtool.o netdev.o s0ix.o ptp.o
 
diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index ba7a0f8f6937..b13f956285ae 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -436,6 +436,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca);
 #define FLAG2_DFLT_CRC_STRIPPING          BIT(12)
 #define FLAG2_CHECK_RX_HWTSTAMP           BIT(13)
 #define FLAG2_CHECK_SYSTIM_OVERFLOW       BIT(14)
+#define FLAG2_ENABLE_S0IX_FLOWS           BIT(15)
 
 #define E1000_RX_DESC_PS(R, i)	    \
 	(&(((union e1000_rx_desc_packet_split *)((R).desc))[i]))
@@ -462,6 +463,9 @@ enum latency_range {
 extern char e1000e_driver_name[];
 
 void e1000e_check_options(struct e1000_adapter *adapter);
+void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter);
+void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter);
+void e1000e_maybe_enable_s0ix(struct e1000_adapter *adapter);
 void e1000e_set_ethtool_ops(struct net_device *netdev);
 
 int e1000e_open(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 128ab6898070..cd9839e86615 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -103,45 +103,6 @@ static const struct e1000_reg_info e1000_reg_info_tbl[] = {
 	{0, NULL}
 };
 
-struct e1000e_me_supported {
-	u16 device_id;		/* supported device ID */
-};
-
-static const struct e1000e_me_supported me_supported[] = {
-	{E1000_DEV_ID_PCH_LPT_I217_LM},
-	{E1000_DEV_ID_PCH_LPTLP_I218_LM},
-	{E1000_DEV_ID_PCH_I218_LM2},
-	{E1000_DEV_ID_PCH_I218_LM3},
-	{E1000_DEV_ID_PCH_SPT_I219_LM},
-	{E1000_DEV_ID_PCH_SPT_I219_LM2},
-	{E1000_DEV_ID_PCH_LBG_I219_LM3},
-	{E1000_DEV_ID_PCH_SPT_I219_LM4},
-	{E1000_DEV_ID_PCH_SPT_I219_LM5},
-	{E1000_DEV_ID_PCH_CNP_I219_LM6},
-	{E1000_DEV_ID_PCH_CNP_I219_LM7},
-	{E1000_DEV_ID_PCH_ICP_I219_LM8},
-	{E1000_DEV_ID_PCH_ICP_I219_LM9},
-	{E1000_DEV_ID_PCH_CMP_I219_LM10},
-	{E1000_DEV_ID_PCH_CMP_I219_LM11},
-	{E1000_DEV_ID_PCH_CMP_I219_LM12},
-	{E1000_DEV_ID_PCH_TGP_I219_LM13},
-	{E1000_DEV_ID_PCH_TGP_I219_LM14},
-	{E1000_DEV_ID_PCH_TGP_I219_LM15},
-	{0}
-};
-
-static bool e1000e_check_me(u16 device_id)
-{
-	struct e1000e_me_supported *id;
-
-	for (id = (struct e1000e_me_supported *)me_supported;
-	     id->device_id; id++)
-		if (device_id == id->device_id)
-			return true;
-
-	return false;
-}
-
 /**
  * __ew32_prepare - prepare to write to MAC CSR register on certain parts
  * @hw: pointer to the HW structure
@@ -6368,228 +6329,6 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
 	pm_runtime_put_sync(netdev->dev.parent);
 }
 
-/* S0ix implementation */
-static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
-{
-	struct e1000_hw *hw = &adapter->hw;
-	u32 mac_data;
-	u16 phy_data;
-
-	/* Disable the periodic inband message,
-	 * don't request PCIe clock in K1 page770_17[10:9] = 10b
-	 */
-	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
-	phy_data &= ~HV_PM_CTRL_K1_CLK_REQ;
-	phy_data |= BIT(10);
-	e1e_wphy(hw, HV_PM_CTRL, phy_data);
-
-	/* Make sure we don't exit K1 every time a new packet arrives
-	 * 772_29[5] = 1 CS_Mode_Stay_In_K1
-	 */
-	e1e_rphy(hw, I217_CGFREG, &phy_data);
-	phy_data |= BIT(5);
-	e1e_wphy(hw, I217_CGFREG, phy_data);
-
-	/* Change the MAC/PHY interface to SMBus
-	 * Force the SMBus in PHY page769_23[0] = 1
-	 * Force the SMBus in MAC CTRL_EXT[11] = 1
-	 */
-	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
-	phy_data |= CV_SMB_CTRL_FORCE_SMBUS;
-	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
-	mac_data = er32(CTRL_EXT);
-	mac_data |= E1000_CTRL_EXT_FORCE_SMBUS;
-	ew32(CTRL_EXT, mac_data);
-
-	/* DFT control: PHY bit: page769_20[0] = 1
-	 * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
-	 */
-	e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
-	phy_data |= BIT(0);
-	e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
-
-	mac_data = er32(EXTCNF_CTRL);
-	mac_data |= E1000_EXTCNF_CTRL_GATE_PHY_CFG;
-	ew32(EXTCNF_CTRL, mac_data);
-
-	/* Check MAC Tx/Rx packet buffer pointers.
-	 * Reset MAC Tx/Rx packet buffer pointers to suppress any
-	 * pending traffic indication that would prevent power gating.
-	 */
-	mac_data = er32(TDFH);
-	if (mac_data)
-		ew32(TDFH, 0);
-	mac_data = er32(TDFT);
-	if (mac_data)
-		ew32(TDFT, 0);
-	mac_data = er32(TDFHS);
-	if (mac_data)
-		ew32(TDFHS, 0);
-	mac_data = er32(TDFTS);
-	if (mac_data)
-		ew32(TDFTS, 0);
-	mac_data = er32(TDFPC);
-	if (mac_data)
-		ew32(TDFPC, 0);
-	mac_data = er32(RDFH);
-	if (mac_data)
-		ew32(RDFH, 0);
-	mac_data = er32(RDFT);
-	if (mac_data)
-		ew32(RDFT, 0);
-	mac_data = er32(RDFHS);
-	if (mac_data)
-		ew32(RDFHS, 0);
-	mac_data = er32(RDFTS);
-	if (mac_data)
-		ew32(RDFTS, 0);
-	mac_data = er32(RDFPC);
-	if (mac_data)
-		ew32(RDFPC, 0);
-
-	/* Enable the Dynamic Power Gating in the MAC */
-	mac_data = er32(FEXTNVM7);
-	mac_data |= BIT(22);
-	ew32(FEXTNVM7, mac_data);
-
-	/* Disable the time synchronization clock */
-	mac_data = er32(FEXTNVM7);
-	mac_data |= BIT(31);
-	mac_data &= ~BIT(0);
-	ew32(FEXTNVM7, mac_data);
-
-	/* Dynamic Power Gating Enable */
-	mac_data = er32(CTRL_EXT);
-	mac_data |= BIT(3);
-	ew32(CTRL_EXT, mac_data);
-
-	/* Disable disconnected cable conditioning for Power Gating */
-	mac_data = er32(DPGFR);
-	mac_data |= BIT(2);
-	ew32(DPGFR, mac_data);
-
-	/* Don't wake from dynamic Power Gating with clock request */
-	mac_data = er32(FEXTNVM12);
-	mac_data |= BIT(12);
-	ew32(FEXTNVM12, mac_data);
-
-	/* Ungate PGCB clock */
-	mac_data = er32(FEXTNVM9);
-	mac_data &= ~BIT(28);
-	ew32(FEXTNVM9, mac_data);
-
-	/* Enable K1 off to enable mPHY Power Gating */
-	mac_data = er32(FEXTNVM6);
-	mac_data |= BIT(31);
-	ew32(FEXTNVM6, mac_data);
-
-	/* Enable mPHY power gating for any link and speed */
-	mac_data = er32(FEXTNVM8);
-	mac_data |= BIT(9);
-	ew32(FEXTNVM8, mac_data);
-
-	/* Enable the Dynamic Clock Gating in the DMA and MAC */
-	mac_data = er32(CTRL_EXT);
-	mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
-	ew32(CTRL_EXT, mac_data);
-
-	/* No MAC DPG gating SLP_S0 in modern standby
-	 * Switch the logic of the lanphypc to use PMC counter
-	 */
-	mac_data = er32(FEXTNVM5);
-	mac_data |= BIT(7);
-	ew32(FEXTNVM5, mac_data);
-}
-
-static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
-{
-	struct e1000_hw *hw = &adapter->hw;
-	u32 mac_data;
-	u16 phy_data;
-
-	/* Disable the Dynamic Power Gating in the MAC */
-	mac_data = er32(FEXTNVM7);
-	mac_data &= 0xFFBFFFFF;
-	ew32(FEXTNVM7, mac_data);
-
-	/* Enable the time synchronization clock */
-	mac_data = er32(FEXTNVM7);
-	mac_data |= BIT(0);
-	ew32(FEXTNVM7, mac_data);
-
-	/* Disable mPHY power gating for any link and speed */
-	mac_data = er32(FEXTNVM8);
-	mac_data &= ~BIT(9);
-	ew32(FEXTNVM8, mac_data);
-
-	/* Disable K1 off */
-	mac_data = er32(FEXTNVM6);
-	mac_data &= ~BIT(31);
-	ew32(FEXTNVM6, mac_data);
-
-	/* Disable Ungate PGCB clock */
-	mac_data = er32(FEXTNVM9);
-	mac_data |= BIT(28);
-	ew32(FEXTNVM9, mac_data);
-
-	/* Cancel not waking from dynamic
-	 * Power Gating with clock request
-	 */
-	mac_data = er32(FEXTNVM12);
-	mac_data &= ~BIT(12);
-	ew32(FEXTNVM12, mac_data);
-
-	/* Cancel disable disconnected cable conditioning
-	 * for Power Gating
-	 */
-	mac_data = er32(DPGFR);
-	mac_data &= ~BIT(2);
-	ew32(DPGFR, mac_data);
-
-	/* Disable Dynamic Power Gating */
-	mac_data = er32(CTRL_EXT);
-	mac_data &= 0xFFFFFFF7;
-	ew32(CTRL_EXT, mac_data);
-
-	/* Disable the Dynamic Clock Gating in the DMA and MAC */
-	mac_data = er32(CTRL_EXT);
-	mac_data &= 0xFFF7FFFF;
-	ew32(CTRL_EXT, mac_data);
-
-	/* Revert the lanphypc logic to use the internal Gbe counter
-	 * and not the PMC counter
-	 */
-	mac_data = er32(FEXTNVM5);
-	mac_data &= 0xFFFFFF7F;
-	ew32(FEXTNVM5, mac_data);
-
-	/* Enable the periodic inband message,
-	 * Request PCIe clock in K1 page770_17[10:9] =01b
-	 */
-	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
-	phy_data &= 0xFBFF;
-	phy_data |= HV_PM_CTRL_K1_CLK_REQ;
-	e1e_wphy(hw, HV_PM_CTRL, phy_data);
-
-	/* Return back configuration
-	 * 772_29[5] = 0 CS_Mode_Stay_In_K1
-	 */
-	e1e_rphy(hw, I217_CGFREG, &phy_data);
-	phy_data &= 0xFFDF;
-	e1e_wphy(hw, I217_CGFREG, phy_data);
-
-	/* Change the MAC/PHY interface to Kumeran
-	 * Unforce the SMBus in PHY page769_23[0] = 0
-	 * Unforce the SMBus in MAC CTRL_EXT[11] = 0
-	 */
-	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
-	phy_data &= ~CV_SMB_CTRL_FORCE_SMBUS;
-	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
-	mac_data = er32(CTRL_EXT);
-	mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
-	ew32(CTRL_EXT, mac_data);
-}
-
 static int e1000e_pm_freeze(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
@@ -6962,7 +6701,6 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
 	int rc;
 
 	e1000e_flush_lpic(pdev);
@@ -6974,8 +6712,7 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 		e1000e_pm_thaw(dev);
 
 	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp &&
-	    !e1000e_check_me(hw->adapter->pdev->device))
+	if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
 		e1000e_s0ix_entry_flow(adapter);
 
 	return rc;
@@ -6986,12 +6723,10 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
 	int rc;
 
 	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp &&
-	    !e1000e_check_me(hw->adapter->pdev->device))
+	if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
 		e1000e_s0ix_exit_flow(adapter);
 
 	rc = __e1000_resume(pdev);
@@ -7655,6 +7390,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_get_hw_control(adapter);
 
+	/* use heuristics to decide whether to enable s0ix flows */
+	e1000e_maybe_enable_s0ix(adapter);
+
 	strlcpy(netdev->name, "eth%d", sizeof(netdev->name));
 	err = register_netdev(netdev);
 	if (err)
diff --git a/drivers/net/ethernet/intel/e1000e/s0ix.c b/drivers/net/ethernet/intel/e1000e/s0ix.c
new file mode 100644
index 000000000000..c3013edbd9e4
--- /dev/null
+++ b/drivers/net/ethernet/intel/e1000e/s0ix.c
@@ -0,0 +1,280 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 1999 - 2018 Intel Corporation. */
+
+#include <linux/netdevice.h>
+
+#include "e1000.h"
+
+struct e1000e_me_supported {
+	u16 device_id;		/* supported device ID */
+};
+
+static const struct e1000e_me_supported me_supported[] = {
+	{E1000_DEV_ID_PCH_LPT_I217_LM},
+	{E1000_DEV_ID_PCH_LPTLP_I218_LM},
+	{E1000_DEV_ID_PCH_I218_LM2},
+	{E1000_DEV_ID_PCH_I218_LM3},
+	{E1000_DEV_ID_PCH_SPT_I219_LM},
+	{E1000_DEV_ID_PCH_SPT_I219_LM2},
+	{E1000_DEV_ID_PCH_LBG_I219_LM3},
+	{E1000_DEV_ID_PCH_SPT_I219_LM4},
+	{E1000_DEV_ID_PCH_SPT_I219_LM5},
+	{E1000_DEV_ID_PCH_CNP_I219_LM6},
+	{E1000_DEV_ID_PCH_CNP_I219_LM7},
+	{E1000_DEV_ID_PCH_ICP_I219_LM8},
+	{E1000_DEV_ID_PCH_ICP_I219_LM9},
+	{E1000_DEV_ID_PCH_CMP_I219_LM10},
+	{E1000_DEV_ID_PCH_CMP_I219_LM11},
+	{E1000_DEV_ID_PCH_CMP_I219_LM12},
+	{E1000_DEV_ID_PCH_TGP_I219_LM13},
+	{E1000_DEV_ID_PCH_TGP_I219_LM14},
+	{E1000_DEV_ID_PCH_TGP_I219_LM15},
+	{0}
+};
+
+static bool e1000e_check_me(u16 device_id)
+{
+	struct e1000e_me_supported *id;
+
+	for (id = (struct e1000e_me_supported *)me_supported;
+	     id->device_id; id++)
+		if (device_id == id->device_id)
+			return true;
+
+	return false;
+}
+
+void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	u32 mac_data;
+	u16 phy_data;
+
+	/* Disable the periodic inband message,
+	 * don't request PCIe clock in K1 page770_17[10:9] = 10b
+	 */
+	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
+	phy_data &= ~HV_PM_CTRL_K1_CLK_REQ;
+	phy_data |= BIT(10);
+	e1e_wphy(hw, HV_PM_CTRL, phy_data);
+
+	/* Make sure we don't exit K1 every time a new packet arrives
+	 * 772_29[5] = 1 CS_Mode_Stay_In_K1
+	 */
+	e1e_rphy(hw, I217_CGFREG, &phy_data);
+	phy_data |= BIT(5);
+	e1e_wphy(hw, I217_CGFREG, phy_data);
+
+	/* Change the MAC/PHY interface to SMBus
+	 * Force the SMBus in PHY page769_23[0] = 1
+	 * Force the SMBus in MAC CTRL_EXT[11] = 1
+	 */
+	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
+	phy_data |= CV_SMB_CTRL_FORCE_SMBUS;
+	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
+	mac_data = er32(CTRL_EXT);
+	mac_data |= E1000_CTRL_EXT_FORCE_SMBUS;
+	ew32(CTRL_EXT, mac_data);
+
+	/* DFT control: PHY bit: page769_20[0] = 1
+	 * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
+	 */
+	e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
+	phy_data |= BIT(0);
+	e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
+
+	mac_data = er32(EXTCNF_CTRL);
+	mac_data |= E1000_EXTCNF_CTRL_GATE_PHY_CFG;
+	ew32(EXTCNF_CTRL, mac_data);
+
+	/* Check MAC Tx/Rx packet buffer pointers.
+	 * Reset MAC Tx/Rx packet buffer pointers to suppress any
+	 * pending traffic indication that would prevent power gating.
+	 */
+	mac_data = er32(TDFH);
+	if (mac_data)
+		ew32(TDFH, 0);
+	mac_data = er32(TDFT);
+	if (mac_data)
+		ew32(TDFT, 0);
+	mac_data = er32(TDFHS);
+	if (mac_data)
+		ew32(TDFHS, 0);
+	mac_data = er32(TDFTS);
+	if (mac_data)
+		ew32(TDFTS, 0);
+	mac_data = er32(TDFPC);
+	if (mac_data)
+		ew32(TDFPC, 0);
+	mac_data = er32(RDFH);
+	if (mac_data)
+		ew32(RDFH, 0);
+	mac_data = er32(RDFT);
+	if (mac_data)
+		ew32(RDFT, 0);
+	mac_data = er32(RDFHS);
+	if (mac_data)
+		ew32(RDFHS, 0);
+	mac_data = er32(RDFTS);
+	if (mac_data)
+		ew32(RDFTS, 0);
+	mac_data = er32(RDFPC);
+	if (mac_data)
+		ew32(RDFPC, 0);
+
+	/* Enable the Dynamic Power Gating in the MAC */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(22);
+	ew32(FEXTNVM7, mac_data);
+
+	/* Disable the time synchronization clock */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(31);
+	mac_data &= ~BIT(0);
+	ew32(FEXTNVM7, mac_data);
+
+	/* Dynamic Power Gating Enable */
+	mac_data = er32(CTRL_EXT);
+	mac_data |= BIT(3);
+	ew32(CTRL_EXT, mac_data);
+
+	/* Disable disconnected cable conditioning for Power Gating */
+	mac_data = er32(DPGFR);
+	mac_data |= BIT(2);
+	ew32(DPGFR, mac_data);
+
+	/* Don't wake from dynamic Power Gating with clock request */
+	mac_data = er32(FEXTNVM12);
+	mac_data |= BIT(12);
+	ew32(FEXTNVM12, mac_data);
+
+	/* Ungate PGCB clock */
+	mac_data = er32(FEXTNVM9);
+	mac_data &= ~BIT(28);
+	ew32(FEXTNVM9, mac_data);
+
+	/* Enable K1 off to enable mPHY Power Gating */
+	mac_data = er32(FEXTNVM6);
+	mac_data |= BIT(31);
+	ew32(FEXTNVM6, mac_data);
+
+	/* Enable mPHY power gating for any link and speed */
+	mac_data = er32(FEXTNVM8);
+	mac_data |= BIT(9);
+	ew32(FEXTNVM8, mac_data);
+
+	/* Enable the Dynamic Clock Gating in the DMA and MAC */
+	mac_data = er32(CTRL_EXT);
+	mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
+	ew32(CTRL_EXT, mac_data);
+
+	/* No MAC DPG gating SLP_S0 in modern standby
+	 * Switch the logic of the lanphypc to use PMC counter
+	 */
+	mac_data = er32(FEXTNVM5);
+	mac_data |= BIT(7);
+	ew32(FEXTNVM5, mac_data);
+}
+
+void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	u32 mac_data;
+	u16 phy_data;
+
+	/* Disable the Dynamic Power Gating in the MAC */
+	mac_data = er32(FEXTNVM7);
+	mac_data &= 0xFFBFFFFF;
+	ew32(FEXTNVM7, mac_data);
+
+	/* Enable the time synchronization clock */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(0);
+	ew32(FEXTNVM7, mac_data);
+
+	/* Disable mPHY power gating for any link and speed */
+	mac_data = er32(FEXTNVM8);
+	mac_data &= ~BIT(9);
+	ew32(FEXTNVM8, mac_data);
+
+	/* Disable K1 off */
+	mac_data = er32(FEXTNVM6);
+	mac_data &= ~BIT(31);
+	ew32(FEXTNVM6, mac_data);
+
+	/* Disable Ungate PGCB clock */
+	mac_data = er32(FEXTNVM9);
+	mac_data |= BIT(28);
+	ew32(FEXTNVM9, mac_data);
+
+	/* Cancel not waking from dynamic
+	 * Power Gating with clock request
+	 */
+	mac_data = er32(FEXTNVM12);
+	mac_data &= ~BIT(12);
+	ew32(FEXTNVM12, mac_data);
+
+	/* Cancel disable disconnected cable conditioning
+	 * for Power Gating
+	 */
+	mac_data = er32(DPGFR);
+	mac_data &= ~BIT(2);
+	ew32(DPGFR, mac_data);
+
+	/* Disable Dynamic Power Gating */
+	mac_data = er32(CTRL_EXT);
+	mac_data &= 0xFFFFFFF7;
+	ew32(CTRL_EXT, mac_data);
+
+	/* Disable the Dynamic Clock Gating in the DMA and MAC */
+	mac_data = er32(CTRL_EXT);
+	mac_data &= 0xFFF7FFFF;
+	ew32(CTRL_EXT, mac_data);
+
+	/* Revert the lanphypc logic to use the internal Gbe counter
+	 * and not the PMC counter
+	 */
+	mac_data = er32(FEXTNVM5);
+	mac_data &= 0xFFFFFF7F;
+	ew32(FEXTNVM5, mac_data);
+
+	/* Enable the periodic inband message,
+	 * Request PCIe clock in K1 page770_17[10:9] =01b
+	 */
+	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
+	phy_data &= 0xFBFF;
+	phy_data |= HV_PM_CTRL_K1_CLK_REQ;
+	e1e_wphy(hw, HV_PM_CTRL, phy_data);
+
+	/* Return back configuration
+	 * 772_29[5] = 0 CS_Mode_Stay_In_K1
+	 */
+	e1e_rphy(hw, I217_CGFREG, &phy_data);
+	phy_data &= 0xFFDF;
+	e1e_wphy(hw, I217_CGFREG, phy_data);
+
+	/* Change the MAC/PHY interface to Kumeran
+	 * Unforce the SMBus in PHY page769_23[0] = 0
+	 * Unforce the SMBus in MAC CTRL_EXT[11] = 0
+	 */
+	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
+	phy_data &= ~CV_SMB_CTRL_FORCE_SMBUS;
+	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
+	mac_data = er32(CTRL_EXT);
+	mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
+	ew32(CTRL_EXT, mac_data);
+}
+
+void e1000e_maybe_enable_s0ix(struct e1000_adapter *adapter)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	struct pci_dev *pdev = adapter->pdev;
+
+	/* require cannon point or later */
+	if (hw->mac.type < e1000_pch_cnp)
+		return;
+	/* turn off on ME configurations */
+	if (e1000e_check_me(pdev->device))
+		return;
+	adapter->flags2 |= FLAG2_ENABLE_S0IX_FLOWS;
+}
-- 
2.25.1

