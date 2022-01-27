Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0A949DF26
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239219AbiA0KVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:21:49 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:53483 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239217AbiA0KVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:21:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643278906; x=1674814906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Q+LrKsq1793ZmzU4Sd1wMJw/eH7sVnXxOKexSJIgCs=;
  b=KVKr2io4baRB446GNo12paD0J4nzwhxpWpZrZMfBP+tYoczmMC/NeO9R
   +I2Gjg3tfwO8ySrzdk6F4nGPcXSBHIWysX6YJq38rX1UD+/2g5QdWLVYo
   Tiq+DI81XNahy0Sp+Ofmey6KH5duqedrU0gWCpITcGnTre9Vk6fw4pZAx
   hp6QeJeyFGaSpgvbhwgSw0IAbyzoW7JK+z+0JC8G8OCmrI438uPfvB2CC
   bwAXNEcW6axvYvvmlKfBSwF41JZUx4rldtS7r9jsqV2eWBLpeSnLuW+sS
   NqpPU0RvviX0Ncf/ZNrzM9e8wnyBG6yIa2EyV7wtb9GW649bgUL3k9sgN
   w==;
IronPort-SDR: PHEtmaMwQyhU6GiG/WiYvuJA4ae/XPfVLE9Z7xqPr71/hqDSddDYLY/YKeFIsqggUJ/OhoGnd4
 4NQ9KaKYhJ9quz+wD2/pqNeBiTAYclkdjinTMLIr2EMNJrN1bhuY943LzZ66xGbfy4eCVFnXDQ
 lHgFY92v3qo4X6J55I7qUhxD+ob0AmKB0KQm9kh1qwFCjQcp+mCoi9x5Go1gP+5fb3hnu5uRZJ
 7sIy1ZqviSIOYnz5Kn/fRjapoqQmUK2bBZjri32POTDuW2DAI3AGs78U7C8lWoTjIo7GM+JjAf
 jTF96GKdQD6t2feSZwkWbmYG
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="151628255"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 03:21:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 03:21:43 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 03:21:40 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/7] net: lan966x: Add registers that are use for ptp functionality
Date:   Thu, 27 Jan 2022 11:23:28 +0100
Message-ID: <20220127102333.987195-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220127102333.987195-1-horatiu.vultur@microchip.com>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the registers that will be used to configure the PHC in
the HW.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c |   1 +
 .../ethernet/microchip/lan966x/lan966x_regs.h | 103 ++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1f60fd125a1d..2853e8f7fb39 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -44,6 +44,7 @@ static const struct lan966x_main_io_resource lan966x_main_iomap[] =  {
 	{ TARGET_ORG,                         0, 1 }, /* 0xe2000000 */
 	{ TARGET_GCB,                    0x4000, 1 }, /* 0xe2004000 */
 	{ TARGET_QS,                     0x8000, 1 }, /* 0xe2008000 */
+	{ TARGET_PTP,                    0xc000, 1 }, /* 0xe200c000 */
 	{ TARGET_CHIP_TOP,              0x10000, 1 }, /* 0xe2010000 */
 	{ TARGET_REW,                   0x14000, 1 }, /* 0xe2014000 */
 	{ TARGET_SYS,                   0x28000, 1 }, /* 0xe2028000 */
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 797560172aca..37a5d7e63cb6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -19,6 +19,7 @@ enum lan966x_target {
 	TARGET_DEV = 13,
 	TARGET_GCB = 27,
 	TARGET_ORG = 36,
+	TARGET_PTP = 41,
 	TARGET_QS = 42,
 	TARGET_QSYS = 46,
 	TARGET_REW = 47,
@@ -559,6 +560,108 @@ enum lan966x_target {
 #define DEV_PCS1G_STICKY_LINK_DOWN_STICKY_GET(x)\
 	FIELD_GET(DEV_PCS1G_STICKY_LINK_DOWN_STICKY, x)
 
+/*      PTP:PTP_CFG:PTP_DOM_CFG */
+#define PTP_DOM_CFG               __REG(TARGET_PTP, 0, 1, 512, 0, 1, 16, 12, 0, 1, 4)
+
+#define PTP_DOM_CFG_ENA                          GENMASK(11, 9)
+#define PTP_DOM_CFG_ENA_SET(x)\
+	FIELD_PREP(PTP_DOM_CFG_ENA, x)
+#define PTP_DOM_CFG_ENA_GET(x)\
+	FIELD_GET(PTP_DOM_CFG_ENA, x)
+
+#define PTP_DOM_CFG_CLKCFG_DIS                   GENMASK(2, 0)
+#define PTP_DOM_CFG_CLKCFG_DIS_SET(x)\
+	FIELD_PREP(PTP_DOM_CFG_CLKCFG_DIS, x)
+#define PTP_DOM_CFG_CLKCFG_DIS_GET(x)\
+	FIELD_GET(PTP_DOM_CFG_CLKCFG_DIS, x)
+
+/*      PTP:PTP_TOD_DOMAINS:CLK_PER_CFG */
+#define PTP_CLK_PER_CFG(g, r)     __REG(TARGET_PTP, 0, 1, 528, g, 3, 28, 0, r, 2, 4)
+
+/*      PTP:PTP_PINS:PTP_PIN_CFG */
+#define PTP_PIN_CFG(g)            __REG(TARGET_PTP, 0, 1, 0, g, 8, 64, 0, 0, 1, 4)
+
+#define PTP_PIN_CFG_PIN_ACTION                   GENMASK(29, 27)
+#define PTP_PIN_CFG_PIN_ACTION_SET(x)\
+	FIELD_PREP(PTP_PIN_CFG_PIN_ACTION, x)
+#define PTP_PIN_CFG_PIN_ACTION_GET(x)\
+	FIELD_GET(PTP_PIN_CFG_PIN_ACTION, x)
+
+#define PTP_PIN_CFG_PIN_SYNC                     GENMASK(26, 25)
+#define PTP_PIN_CFG_PIN_SYNC_SET(x)\
+	FIELD_PREP(PTP_PIN_CFG_PIN_SYNC, x)
+#define PTP_PIN_CFG_PIN_SYNC_GET(x)\
+	FIELD_GET(PTP_PIN_CFG_PIN_SYNC, x)
+
+#define PTP_PIN_CFG_PIN_DOM                      GENMASK(17, 16)
+#define PTP_PIN_CFG_PIN_DOM_SET(x)\
+	FIELD_PREP(PTP_PIN_CFG_PIN_DOM, x)
+#define PTP_PIN_CFG_PIN_DOM_GET(x)\
+	FIELD_GET(PTP_PIN_CFG_PIN_DOM, x)
+
+/*      PTP:PTP_PINS:PTP_TOD_SEC_MSB */
+#define PTP_TOD_SEC_MSB(g)        __REG(TARGET_PTP, 0, 1, 0, g, 8, 64, 4, 0, 1, 4)
+
+#define PTP_TOD_SEC_MSB_TOD_SEC_MSB              GENMASK(15, 0)
+#define PTP_TOD_SEC_MSB_TOD_SEC_MSB_SET(x)\
+	FIELD_PREP(PTP_TOD_SEC_MSB_TOD_SEC_MSB, x)
+#define PTP_TOD_SEC_MSB_TOD_SEC_MSB_GET(x)\
+	FIELD_GET(PTP_TOD_SEC_MSB_TOD_SEC_MSB, x)
+
+/*      PTP:PTP_PINS:PTP_TOD_SEC_LSB */
+#define PTP_TOD_SEC_LSB(g)        __REG(TARGET_PTP, 0, 1, 0, g, 8, 64, 8, 0, 1, 4)
+
+/*      PTP:PTP_PINS:PTP_TOD_NSEC */
+#define PTP_TOD_NSEC(g)           __REG(TARGET_PTP, 0, 1, 0, g, 8, 64, 12, 0, 1, 4)
+
+#define PTP_TOD_NSEC_TOD_NSEC                    GENMASK(29, 0)
+#define PTP_TOD_NSEC_TOD_NSEC_SET(x)\
+	FIELD_PREP(PTP_TOD_NSEC_TOD_NSEC, x)
+#define PTP_TOD_NSEC_TOD_NSEC_GET(x)\
+	FIELD_GET(PTP_TOD_NSEC_TOD_NSEC, x)
+
+/*      PTP:PTP_TS_FIFO:PTP_TWOSTEP_CTRL */
+#define PTP_TWOSTEP_CTRL          __REG(TARGET_PTP, 0, 1, 612, 0, 1, 12, 0, 0, 1, 4)
+
+#define PTP_TWOSTEP_CTRL_NXT                     BIT(11)
+#define PTP_TWOSTEP_CTRL_NXT_SET(x)\
+	FIELD_PREP(PTP_TWOSTEP_CTRL_NXT, x)
+#define PTP_TWOSTEP_CTRL_NXT_GET(x)\
+	FIELD_GET(PTP_TWOSTEP_CTRL_NXT, x)
+
+#define PTP_TWOSTEP_CTRL_VLD                     BIT(10)
+#define PTP_TWOSTEP_CTRL_VLD_SET(x)\
+	FIELD_PREP(PTP_TWOSTEP_CTRL_VLD, x)
+#define PTP_TWOSTEP_CTRL_VLD_GET(x)\
+	FIELD_GET(PTP_TWOSTEP_CTRL_VLD, x)
+
+#define PTP_TWOSTEP_CTRL_STAMP_TX                BIT(9)
+#define PTP_TWOSTEP_CTRL_STAMP_TX_SET(x)\
+	FIELD_PREP(PTP_TWOSTEP_CTRL_STAMP_TX, x)
+#define PTP_TWOSTEP_CTRL_STAMP_TX_GET(x)\
+	FIELD_GET(PTP_TWOSTEP_CTRL_STAMP_TX, x)
+
+#define PTP_TWOSTEP_CTRL_STAMP_PORT              GENMASK(8, 1)
+#define PTP_TWOSTEP_CTRL_STAMP_PORT_SET(x)\
+	FIELD_PREP(PTP_TWOSTEP_CTRL_STAMP_PORT, x)
+#define PTP_TWOSTEP_CTRL_STAMP_PORT_GET(x)\
+	FIELD_GET(PTP_TWOSTEP_CTRL_STAMP_PORT, x)
+
+#define PTP_TWOSTEP_CTRL_OVFL                    BIT(0)
+#define PTP_TWOSTEP_CTRL_OVFL_SET(x)\
+	FIELD_PREP(PTP_TWOSTEP_CTRL_OVFL, x)
+#define PTP_TWOSTEP_CTRL_OVFL_GET(x)\
+	FIELD_GET(PTP_TWOSTEP_CTRL_OVFL, x)
+
+/*      PTP:PTP_TS_FIFO:PTP_TWOSTEP_STAMP */
+#define PTP_TWOSTEP_STAMP         __REG(TARGET_PTP, 0, 1, 612, 0, 1, 12, 4, 0, 1, 4)
+
+#define PTP_TWOSTEP_STAMP_STAMP_NSEC             GENMASK(31, 2)
+#define PTP_TWOSTEP_STAMP_STAMP_NSEC_SET(x)\
+	FIELD_PREP(PTP_TWOSTEP_STAMP_STAMP_NSEC, x)
+#define PTP_TWOSTEP_STAMP_STAMP_NSEC_GET(x)\
+	FIELD_GET(PTP_TWOSTEP_STAMP_STAMP_NSEC, x)
+
 /*      DEVCPU_QS:XTR:XTR_GRP_CFG */
 #define QS_XTR_GRP_CFG(r)         __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 0, r, 2, 4)
 
-- 
2.33.0

