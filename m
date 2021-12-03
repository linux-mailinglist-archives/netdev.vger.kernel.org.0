Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F322046757F
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352059AbhLCKtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:49:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32101 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352029AbhLCKtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:49:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638528354; x=1670064354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CT7jtIkme9AhFMoPO9xaJSjN1ls35Idn183GYh+dElo=;
  b=RnO3+h3inU6pvV77yl1a924lKB4tQ0XZoSnAv9nIcg8FwcGUeZn9cl3d
   ZvoZ2bLJXZ5ThYe1rfBcU3S7lL7ZsE/bNIi+f1+kGKAhU+1Gvi5Uxm6/e
   icXfNWIQX0HoaN83W+SEYhrsTTbTkFgMDxpwhlQv+snD5Sp1D0uGFa+5L
   3pYPcN2dPL33plsT+YvmyRPcU9nmnBdr9WPbkUPn2PLSamvkVFgWQIR09
   nQsqTdUqDDcdzYN7OP31V0+XD1Qx60kC+nnF5RgGwvHLmNXXJlP8/S9Wz
   dxL6GkPmz3Y4YN4iflTha5CMbvGG9oz45cmQfJBxMqRGrd3OAUNSCszPb
   Q==;
IronPort-SDR: wrf+QUFJWmxhzVcd++rFbrTp43EYJi97qkIdpvSYWRngXB0HWsXwziy9xmovCuQbRM9m5MOiOt
 giOyfmsk+TP6uhh4dAFGClohKBGJh8wZJetmTS5mgyWBR8O5em4pgjRWNufKepSVHyqudi0GC4
 KcSqiEaZM/q1ytefXqHjeDaC3yd/2+TRxnqjDXv6SHSihMY68Uj0gCyZ//mJIX+9mpZm9QJlE1
 f0t/3HLDfpPdNoHgWtXJZE8aouGPNCVtJhW18OFfHm8SRi1WYRcBpAqkDWEHxFH+Nt73lVaLCl
 0mo/YLo48SkY7FaCjFr077FI
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="145985152"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2021 03:45:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 3 Dec 2021 03:45:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 3 Dec 2021 03:45:52 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/6] net: lan966x: Add registers that are used for switch and vlan functionality
Date:   Fri, 3 Dec 2021 11:46:40 +0100
Message-ID: <20211203104645.1476704-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
References: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the registers that will be used to enable switchdev and
vlan functionality in the HW.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_regs.h | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 879dcd807dec..2f2b26b9f8c6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -61,6 +61,9 @@ enum lan966x_target {
 #define ANA_ADVLEARN_VLAN_CHK_GET(x)\
 	FIELD_GET(ANA_ADVLEARN_VLAN_CHK, x)
 
+/*      ANA:ANA:VLANMASK */
+#define ANA_VLANMASK              __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 8, 0, 1, 4)
+
 /*      ANA:ANA:ANAINTR */
 #define ANA_ANAINTR               __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 16, 0, 1, 4)
 
@@ -184,6 +187,102 @@ enum lan966x_target {
 #define ANA_MACACCESS_MAC_TABLE_CMD_GET(x)\
 	FIELD_GET(ANA_MACACCESS_MAC_TABLE_CMD, x)
 
+/*      ANA:ANA_TABLES:MACTINDX */
+#define ANA_MACTINDX              __REG(TARGET_ANA, 0, 1, 27520, 0, 1, 128, 52, 0, 1, 4)
+
+#define ANA_MACTINDX_BUCKET                      GENMASK(12, 11)
+#define ANA_MACTINDX_BUCKET_SET(x)\
+	FIELD_PREP(ANA_MACTINDX_BUCKET, x)
+#define ANA_MACTINDX_BUCKET_GET(x)\
+	FIELD_GET(ANA_MACTINDX_BUCKET, x)
+
+#define ANA_MACTINDX_M_INDEX                     GENMASK(10, 0)
+#define ANA_MACTINDX_M_INDEX_SET(x)\
+	FIELD_PREP(ANA_MACTINDX_M_INDEX, x)
+#define ANA_MACTINDX_M_INDEX_GET(x)\
+	FIELD_GET(ANA_MACTINDX_M_INDEX, x)
+
+/*      ANA:ANA_TABLES:VLAN_PORT_MASK */
+#define ANA_VLAN_PORT_MASK        __REG(TARGET_ANA, 0, 1, 27520, 0, 1, 128, 56, 0, 1, 4)
+
+#define ANA_VLAN_PORT_MASK_VLAN_PORT_MASK        GENMASK(8, 0)
+#define ANA_VLAN_PORT_MASK_VLAN_PORT_MASK_SET(x)\
+	FIELD_PREP(ANA_VLAN_PORT_MASK_VLAN_PORT_MASK, x)
+#define ANA_VLAN_PORT_MASK_VLAN_PORT_MASK_GET(x)\
+	FIELD_GET(ANA_VLAN_PORT_MASK_VLAN_PORT_MASK, x)
+
+/*      ANA:ANA_TABLES:VLANACCESS */
+#define ANA_VLANACCESS            __REG(TARGET_ANA, 0, 1, 27520, 0, 1, 128, 60, 0, 1, 4)
+
+#define ANA_VLANACCESS_VLAN_TBL_CMD              GENMASK(1, 0)
+#define ANA_VLANACCESS_VLAN_TBL_CMD_SET(x)\
+	FIELD_PREP(ANA_VLANACCESS_VLAN_TBL_CMD, x)
+#define ANA_VLANACCESS_VLAN_TBL_CMD_GET(x)\
+	FIELD_GET(ANA_VLANACCESS_VLAN_TBL_CMD, x)
+
+/*      ANA:ANA_TABLES:VLANTIDX */
+#define ANA_VLANTIDX              __REG(TARGET_ANA, 0, 1, 27520, 0, 1, 128, 64, 0, 1, 4)
+
+#define ANA_VLANTIDX_VLAN_PGID_CPU_DIS           BIT(18)
+#define ANA_VLANTIDX_VLAN_PGID_CPU_DIS_SET(x)\
+	FIELD_PREP(ANA_VLANTIDX_VLAN_PGID_CPU_DIS, x)
+#define ANA_VLANTIDX_VLAN_PGID_CPU_DIS_GET(x)\
+	FIELD_GET(ANA_VLANTIDX_VLAN_PGID_CPU_DIS, x)
+
+#define ANA_VLANTIDX_V_INDEX                     GENMASK(11, 0)
+#define ANA_VLANTIDX_V_INDEX_SET(x)\
+	FIELD_PREP(ANA_VLANTIDX_V_INDEX, x)
+#define ANA_VLANTIDX_V_INDEX_GET(x)\
+	FIELD_GET(ANA_VLANTIDX_V_INDEX, x)
+
+/*      ANA:PORT:VLAN_CFG */
+#define ANA_VLAN_CFG(g)           __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 0, 0, 1, 4)
+
+#define ANA_VLAN_CFG_VLAN_AWARE_ENA              BIT(20)
+#define ANA_VLAN_CFG_VLAN_AWARE_ENA_SET(x)\
+	FIELD_PREP(ANA_VLAN_CFG_VLAN_AWARE_ENA, x)
+#define ANA_VLAN_CFG_VLAN_AWARE_ENA_GET(x)\
+	FIELD_GET(ANA_VLAN_CFG_VLAN_AWARE_ENA, x)
+
+#define ANA_VLAN_CFG_VLAN_POP_CNT                GENMASK(19, 18)
+#define ANA_VLAN_CFG_VLAN_POP_CNT_SET(x)\
+	FIELD_PREP(ANA_VLAN_CFG_VLAN_POP_CNT, x)
+#define ANA_VLAN_CFG_VLAN_POP_CNT_GET(x)\
+	FIELD_GET(ANA_VLAN_CFG_VLAN_POP_CNT, x)
+
+#define ANA_VLAN_CFG_VLAN_VID                    GENMASK(11, 0)
+#define ANA_VLAN_CFG_VLAN_VID_SET(x)\
+	FIELD_PREP(ANA_VLAN_CFG_VLAN_VID, x)
+#define ANA_VLAN_CFG_VLAN_VID_GET(x)\
+	FIELD_GET(ANA_VLAN_CFG_VLAN_VID, x)
+
+/*      ANA:PORT:DROP_CFG */
+#define ANA_DROP_CFG(g)           __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 4, 0, 1, 4)
+
+#define ANA_DROP_CFG_DROP_UNTAGGED_ENA           BIT(6)
+#define ANA_DROP_CFG_DROP_UNTAGGED_ENA_SET(x)\
+	FIELD_PREP(ANA_DROP_CFG_DROP_UNTAGGED_ENA, x)
+#define ANA_DROP_CFG_DROP_UNTAGGED_ENA_GET(x)\
+	FIELD_GET(ANA_DROP_CFG_DROP_UNTAGGED_ENA, x)
+
+#define ANA_DROP_CFG_DROP_PRIO_S_TAGGED_ENA      BIT(3)
+#define ANA_DROP_CFG_DROP_PRIO_S_TAGGED_ENA_SET(x)\
+	FIELD_PREP(ANA_DROP_CFG_DROP_PRIO_S_TAGGED_ENA, x)
+#define ANA_DROP_CFG_DROP_PRIO_S_TAGGED_ENA_GET(x)\
+	FIELD_GET(ANA_DROP_CFG_DROP_PRIO_S_TAGGED_ENA, x)
+
+#define ANA_DROP_CFG_DROP_PRIO_C_TAGGED_ENA      BIT(2)
+#define ANA_DROP_CFG_DROP_PRIO_C_TAGGED_ENA_SET(x)\
+	FIELD_PREP(ANA_DROP_CFG_DROP_PRIO_C_TAGGED_ENA, x)
+#define ANA_DROP_CFG_DROP_PRIO_C_TAGGED_ENA_GET(x)\
+	FIELD_GET(ANA_DROP_CFG_DROP_PRIO_C_TAGGED_ENA, x)
+
+#define ANA_DROP_CFG_DROP_MC_SMAC_ENA            BIT(0)
+#define ANA_DROP_CFG_DROP_MC_SMAC_ENA_SET(x)\
+	FIELD_PREP(ANA_DROP_CFG_DROP_MC_SMAC_ENA, x)
+#define ANA_DROP_CFG_DROP_MC_SMAC_ENA_GET(x)\
+	FIELD_GET(ANA_DROP_CFG_DROP_MC_SMAC_ENA, x)
+
 /*      ANA:PORT:CPU_FWD_CFG */
 #define ANA_CPU_FWD_CFG(g)        __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 96, 0, 1, 4)
 
@@ -589,6 +688,36 @@ enum lan966x_target {
 /*      QSYS:RES_CTRL:RES_CFG */
 #define QSYS_RES_CFG(g)           __REG(TARGET_QSYS, 0, 1, 32768, g, 1024, 8, 0, 0, 1, 4)
 
+/*      REW:PORT:PORT_VLAN_CFG */
+#define REW_PORT_VLAN_CFG(g)      __REG(TARGET_REW, 0, 1, 0, g, 10, 128, 0, 0, 1, 4)
+
+#define REW_PORT_VLAN_CFG_PORT_TPID              GENMASK(31, 16)
+#define REW_PORT_VLAN_CFG_PORT_TPID_SET(x)\
+	FIELD_PREP(REW_PORT_VLAN_CFG_PORT_TPID, x)
+#define REW_PORT_VLAN_CFG_PORT_TPID_GET(x)\
+	FIELD_GET(REW_PORT_VLAN_CFG_PORT_TPID, x)
+
+#define REW_PORT_VLAN_CFG_PORT_VID               GENMASK(11, 0)
+#define REW_PORT_VLAN_CFG_PORT_VID_SET(x)\
+	FIELD_PREP(REW_PORT_VLAN_CFG_PORT_VID, x)
+#define REW_PORT_VLAN_CFG_PORT_VID_GET(x)\
+	FIELD_GET(REW_PORT_VLAN_CFG_PORT_VID, x)
+
+/*      REW:PORT:TAG_CFG */
+#define REW_TAG_CFG(g)            __REG(TARGET_REW, 0, 1, 0, g, 10, 128, 4, 0, 1, 4)
+
+#define REW_TAG_CFG_TAG_CFG                      GENMASK(8, 7)
+#define REW_TAG_CFG_TAG_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CFG_TAG_CFG, x)
+#define REW_TAG_CFG_TAG_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CFG_TAG_CFG, x)
+
+#define REW_TAG_CFG_TAG_TPID_CFG                 GENMASK(6, 5)
+#define REW_TAG_CFG_TAG_TPID_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CFG_TAG_TPID_CFG, x)
+#define REW_TAG_CFG_TAG_TPID_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CFG_TAG_TPID_CFG, x)
+
 /*      REW:PORT:PORT_CFG */
 #define REW_PORT_CFG(g)           __REG(TARGET_REW, 0, 1, 0, g, 10, 128, 8, 0, 1, 4)
 
-- 
2.33.0

