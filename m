Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54C14CD302
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238973AbiCDLHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238707AbiCDLHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:07:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6841AF8EA;
        Fri,  4 Mar 2022 03:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646392004; x=1677928004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RDnQpSOlX46fP6hyh3ro4qNGIhVAH0AQI6i02GCbvg8=;
  b=pc07gLAGjcq4LFDdE5kJNSpkRYP+NpA3oXMdenCqTzDyPYmO3C0dYNXs
   TNyJz+JPDYCwX/WZKEH4ZakEQ2vaV0GWYyb0yDsHNg+/3mlNaxElICFm1
   gBqSv+Z3RA+Oqb2xO16LhYjsxonO0g8DtQT5qBQqhgyfFXdGAYmCdgnbB
   kyTvT0PXZhIC7n/bxXsystH8zOnmzS+/AKvEyxFgOgLwCPA8+DYrfzJwb
   NUNq7CSk4/Vh79jwN17TiP70Rz/3kAVSd5X8dEuSpvx9ZbNDWIFQKmEo+
   XFLXaZI9C3eSBLoAD8ArYNH95aa5BXeU46rBSgfOAwKTn5qwkLav+SYk6
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="150853652"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 04:06:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 04:06:42 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 04:06:39 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/9] net: sparx5: Add registers that are used by ptp functionality
Date:   Fri, 4 Mar 2022 12:08:55 +0100
Message-ID: <20220304110900.3199904-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
References: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR,UPPERCASE_50_75 autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the registers that will be used to configure the PHC in the HW.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   |   1 +
 .../microchip/sparx5/sparx5_main_regs.h       | 335 +++++++++++++++++-
 2 files changed, 334 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 394de85d360d..e8d26b330945 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -190,6 +190,7 @@ static const struct sparx5_main_io_resource sparx5_main_iomap[] =  {
 	{ TARGET_ASM,                0x10600000, 1 }, /* 0x610600000 */
 	{ TARGET_GCB,                0x11010000, 2 }, /* 0x611010000 */
 	{ TARGET_QS,                 0x11030000, 2 }, /* 0x611030000 */
+	{ TARGET_PTP,                0x11040000, 2 }, /* 0x611040000 */
 	{ TARGET_ANA_ACL,            0x11050000, 2 }, /* 0x611050000 */
 	{ TARGET_LRN,                0x11060000, 2 }, /* 0x611060000 */
 	{ TARGET_VCAP_SUPER,         0x11080000, 2 }, /* 0x611080000 */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
index 5ab2373a7178..c94de436b281 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -4,8 +4,8 @@
  * Copyright (c) 2021 Microchip Technology Inc.
  */
 
-/* This file is autogenerated by cml-utils 2021-05-06 13:06:37 +0200.
- * Commit ID: 9ae4ec441e25e4b9003f4e514df5cb12a36b84d3
+/* This file is autogenerated by cml-utils 2022-02-26 14:15:01 +0100.
+ * Commit ID: 98bdd3d171cc2a1afd30d241d41a4281d471a48c (dirty)
  */
 
 #ifndef _SPARX5_MAIN_REGS_H_
@@ -40,6 +40,7 @@ enum sparx5_target {
 	TARGET_PCS25G_BR = 144,
 	TARGET_PCS5G_BR = 160,
 	TARGET_PORT_CONF = 173,
+	TARGET_PTP = 174,
 	TARGET_QFWD = 175,
 	TARGET_QRES = 176,
 	TARGET_QS = 177,
@@ -4156,6 +4157,249 @@ enum sparx5_target {
 #define PORT_CONF_USGMII_CFG_QUAD_MODE_GET(x)\
 	FIELD_GET(PORT_CONF_USGMII_CFG_QUAD_MODE, x)
 
+/*      DEVCPU_PTP:PTP_CFG:PTP_PIN_INTR */
+#define PTP_PTP_PIN_INTR          __REG(TARGET_PTP, 0, 1, 320, 0, 1, 16, 0, 0, 1, 4)
+
+#define PTP_PTP_PIN_INTR_INTR_PTP                GENMASK(4, 0)
+#define PTP_PTP_PIN_INTR_INTR_PTP_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_INTR_INTR_PTP, x)
+#define PTP_PTP_PIN_INTR_INTR_PTP_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_INTR_INTR_PTP, x)
+
+/*      DEVCPU_PTP:PTP_CFG:PTP_PIN_INTR_ENA */
+#define PTP_PTP_PIN_INTR_ENA      __REG(TARGET_PTP, 0, 1, 320, 0, 1, 16, 4, 0, 1, 4)
+
+#define PTP_PTP_PIN_INTR_ENA_INTR_PTP_ENA        GENMASK(4, 0)
+#define PTP_PTP_PIN_INTR_ENA_INTR_PTP_ENA_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_INTR_ENA_INTR_PTP_ENA, x)
+#define PTP_PTP_PIN_INTR_ENA_INTR_PTP_ENA_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_INTR_ENA_INTR_PTP_ENA, x)
+
+/*      DEVCPU_PTP:PTP_CFG:PTP_INTR_IDENT */
+#define PTP_PTP_INTR_IDENT        __REG(TARGET_PTP, 0, 1, 320, 0, 1, 16, 8, 0, 1, 4)
+
+#define PTP_PTP_INTR_IDENT_INTR_PTP_IDENT        GENMASK(4, 0)
+#define PTP_PTP_INTR_IDENT_INTR_PTP_IDENT_SET(x)\
+	FIELD_PREP(PTP_PTP_INTR_IDENT_INTR_PTP_IDENT, x)
+#define PTP_PTP_INTR_IDENT_INTR_PTP_IDENT_GET(x)\
+	FIELD_GET(PTP_PTP_INTR_IDENT_INTR_PTP_IDENT, x)
+
+/*      DEVCPU_PTP:PTP_CFG:PTP_DOM_CFG */
+#define PTP_PTP_DOM_CFG           __REG(TARGET_PTP, 0, 1, 320, 0, 1, 16, 12, 0, 1, 4)
+
+#define PTP_PTP_DOM_CFG_PTP_ENA                  GENMASK(11, 9)
+#define PTP_PTP_DOM_CFG_PTP_ENA_SET(x)\
+	FIELD_PREP(PTP_PTP_DOM_CFG_PTP_ENA, x)
+#define PTP_PTP_DOM_CFG_PTP_ENA_GET(x)\
+	FIELD_GET(PTP_PTP_DOM_CFG_PTP_ENA, x)
+
+#define PTP_PTP_DOM_CFG_PTP_HOLD                 GENMASK(8, 6)
+#define PTP_PTP_DOM_CFG_PTP_HOLD_SET(x)\
+	FIELD_PREP(PTP_PTP_DOM_CFG_PTP_HOLD, x)
+#define PTP_PTP_DOM_CFG_PTP_HOLD_GET(x)\
+	FIELD_GET(PTP_PTP_DOM_CFG_PTP_HOLD, x)
+
+#define PTP_PTP_DOM_CFG_PTP_TOD_FREEZE           GENMASK(5, 3)
+#define PTP_PTP_DOM_CFG_PTP_TOD_FREEZE_SET(x)\
+	FIELD_PREP(PTP_PTP_DOM_CFG_PTP_TOD_FREEZE, x)
+#define PTP_PTP_DOM_CFG_PTP_TOD_FREEZE_GET(x)\
+	FIELD_GET(PTP_PTP_DOM_CFG_PTP_TOD_FREEZE, x)
+
+#define PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS           GENMASK(2, 0)
+#define PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS_SET(x)\
+	FIELD_PREP(PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS, x)
+#define PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS_GET(x)\
+	FIELD_GET(PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS, x)
+
+/*      DEVCPU_PTP:PTP_TOD_DOMAINS:CLK_PER_CFG */
+#define PTP_CLK_PER_CFG(g, r)     __REG(TARGET_PTP, 0, 1, 336, g, 3, 28, 0, r, 2, 4)
+
+/*      DEVCPU_PTP:PTP_TOD_DOMAINS:PTP_CUR_NSEC */
+#define PTP_PTP_CUR_NSEC(g)       __REG(TARGET_PTP, 0, 1, 336, g, 3, 28, 8, 0, 1, 4)
+
+#define PTP_PTP_CUR_NSEC_PTP_CUR_NSEC            GENMASK(29, 0)
+#define PTP_PTP_CUR_NSEC_PTP_CUR_NSEC_SET(x)\
+	FIELD_PREP(PTP_PTP_CUR_NSEC_PTP_CUR_NSEC, x)
+#define PTP_PTP_CUR_NSEC_PTP_CUR_NSEC_GET(x)\
+	FIELD_GET(PTP_PTP_CUR_NSEC_PTP_CUR_NSEC, x)
+
+/*      DEVCPU_PTP:PTP_TOD_DOMAINS:PTP_CUR_NSEC_FRAC */
+#define PTP_PTP_CUR_NSEC_FRAC(g)  __REG(TARGET_PTP, 0, 1, 336, g, 3, 28, 12, 0, 1, 4)
+
+#define PTP_PTP_CUR_NSEC_FRAC_PTP_CUR_NSEC_FRAC  GENMASK(7, 0)
+#define PTP_PTP_CUR_NSEC_FRAC_PTP_CUR_NSEC_FRAC_SET(x)\
+	FIELD_PREP(PTP_PTP_CUR_NSEC_FRAC_PTP_CUR_NSEC_FRAC, x)
+#define PTP_PTP_CUR_NSEC_FRAC_PTP_CUR_NSEC_FRAC_GET(x)\
+	FIELD_GET(PTP_PTP_CUR_NSEC_FRAC_PTP_CUR_NSEC_FRAC, x)
+
+/*      DEVCPU_PTP:PTP_TOD_DOMAINS:PTP_CUR_SEC_LSB */
+#define PTP_PTP_CUR_SEC_LSB(g)    __REG(TARGET_PTP, 0, 1, 336, g, 3, 28, 16, 0, 1, 4)
+
+/*      DEVCPU_PTP:PTP_TOD_DOMAINS:PTP_CUR_SEC_MSB */
+#define PTP_PTP_CUR_SEC_MSB(g)    __REG(TARGET_PTP, 0, 1, 336, g, 3, 28, 20, 0, 1, 4)
+
+#define PTP_PTP_CUR_SEC_MSB_PTP_CUR_SEC_MSB      GENMASK(15, 0)
+#define PTP_PTP_CUR_SEC_MSB_PTP_CUR_SEC_MSB_SET(x)\
+	FIELD_PREP(PTP_PTP_CUR_SEC_MSB_PTP_CUR_SEC_MSB, x)
+#define PTP_PTP_CUR_SEC_MSB_PTP_CUR_SEC_MSB_GET(x)\
+	FIELD_GET(PTP_PTP_CUR_SEC_MSB_PTP_CUR_SEC_MSB, x)
+
+/*      DEVCPU_PTP:PTP_TOD_DOMAINS:NTP_CUR_NSEC */
+#define PTP_NTP_CUR_NSEC(g)       __REG(TARGET_PTP, 0, 1, 336, g, 3, 28, 24, 0, 1, 4)
+
+/*      DEVCPU_PTP:PTP_PINS:PTP_PIN_CFG */
+#define PTP_PTP_PIN_CFG(g)        __REG(TARGET_PTP, 0, 1, 0, g, 5, 64, 0, 0, 1, 4)
+
+#define PTP_PTP_PIN_CFG_PTP_PIN_ACTION           GENMASK(28, 26)
+#define PTP_PTP_PIN_CFG_PTP_PIN_ACTION_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_CFG_PTP_PIN_ACTION, x)
+#define PTP_PTP_PIN_CFG_PTP_PIN_ACTION_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_CFG_PTP_PIN_ACTION, x)
+
+#define PTP_PTP_PIN_CFG_PTP_PIN_SYNC             GENMASK(25, 24)
+#define PTP_PTP_PIN_CFG_PTP_PIN_SYNC_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_CFG_PTP_PIN_SYNC, x)
+#define PTP_PTP_PIN_CFG_PTP_PIN_SYNC_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_CFG_PTP_PIN_SYNC, x)
+
+#define PTP_PTP_PIN_CFG_PTP_PIN_INV_POL          BIT(23)
+#define PTP_PTP_PIN_CFG_PTP_PIN_INV_POL_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_CFG_PTP_PIN_INV_POL, x)
+#define PTP_PTP_PIN_CFG_PTP_PIN_INV_POL_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_CFG_PTP_PIN_INV_POL, x)
+
+#define PTP_PTP_PIN_CFG_PTP_PIN_SELECT           GENMASK(22, 21)
+#define PTP_PTP_PIN_CFG_PTP_PIN_SELECT_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_CFG_PTP_PIN_SELECT, x)
+#define PTP_PTP_PIN_CFG_PTP_PIN_SELECT_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_CFG_PTP_PIN_SELECT, x)
+
+#define PTP_PTP_PIN_CFG_PTP_CLK_SELECT           GENMASK(20, 18)
+#define PTP_PTP_PIN_CFG_PTP_CLK_SELECT_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_CFG_PTP_CLK_SELECT, x)
+#define PTP_PTP_PIN_CFG_PTP_CLK_SELECT_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_CFG_PTP_CLK_SELECT, x)
+
+#define PTP_PTP_PIN_CFG_PTP_PIN_DOM              GENMASK(17, 16)
+#define PTP_PTP_PIN_CFG_PTP_PIN_DOM_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_CFG_PTP_PIN_DOM, x)
+#define PTP_PTP_PIN_CFG_PTP_PIN_DOM_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_CFG_PTP_PIN_DOM, x)
+
+#define PTP_PTP_PIN_CFG_PTP_PIN_OPT              GENMASK(15, 14)
+#define PTP_PTP_PIN_CFG_PTP_PIN_OPT_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_CFG_PTP_PIN_OPT, x)
+#define PTP_PTP_PIN_CFG_PTP_PIN_OPT_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_CFG_PTP_PIN_OPT, x)
+
+#define PTP_PTP_PIN_CFG_PTP_PIN_EMBEDDED_CLK     BIT(13)
+#define PTP_PTP_PIN_CFG_PTP_PIN_EMBEDDED_CLK_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_CFG_PTP_PIN_EMBEDDED_CLK, x)
+#define PTP_PTP_PIN_CFG_PTP_PIN_EMBEDDED_CLK_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_CFG_PTP_PIN_EMBEDDED_CLK, x)
+
+#define PTP_PTP_PIN_CFG_PTP_PIN_OUTP_OFS         GENMASK(12, 0)
+#define PTP_PTP_PIN_CFG_PTP_PIN_OUTP_OFS_SET(x)\
+	FIELD_PREP(PTP_PTP_PIN_CFG_PTP_PIN_OUTP_OFS, x)
+#define PTP_PTP_PIN_CFG_PTP_PIN_OUTP_OFS_GET(x)\
+	FIELD_GET(PTP_PTP_PIN_CFG_PTP_PIN_OUTP_OFS, x)
+
+/*      DEVCPU_PTP:PTP_PINS:PTP_TOD_SEC_MSB */
+#define PTP_PTP_TOD_SEC_MSB(g)    __REG(TARGET_PTP, 0, 1, 0, g, 5, 64, 4, 0, 1, 4)
+
+#define PTP_PTP_TOD_SEC_MSB_PTP_TOD_SEC_MSB      GENMASK(15, 0)
+#define PTP_PTP_TOD_SEC_MSB_PTP_TOD_SEC_MSB_SET(x)\
+	FIELD_PREP(PTP_PTP_TOD_SEC_MSB_PTP_TOD_SEC_MSB, x)
+#define PTP_PTP_TOD_SEC_MSB_PTP_TOD_SEC_MSB_GET(x)\
+	FIELD_GET(PTP_PTP_TOD_SEC_MSB_PTP_TOD_SEC_MSB, x)
+
+/*      DEVCPU_PTP:PTP_PINS:PTP_TOD_SEC_LSB */
+#define PTP_PTP_TOD_SEC_LSB(g)    __REG(TARGET_PTP, 0, 1, 0, g, 5, 64, 8, 0, 1, 4)
+
+/*      DEVCPU_PTP:PTP_PINS:PTP_TOD_NSEC */
+#define PTP_PTP_TOD_NSEC(g)       __REG(TARGET_PTP, 0, 1, 0, g, 5, 64, 12, 0, 1, 4)
+
+#define PTP_PTP_TOD_NSEC_PTP_TOD_NSEC            GENMASK(29, 0)
+#define PTP_PTP_TOD_NSEC_PTP_TOD_NSEC_SET(x)\
+	FIELD_PREP(PTP_PTP_TOD_NSEC_PTP_TOD_NSEC, x)
+#define PTP_PTP_TOD_NSEC_PTP_TOD_NSEC_GET(x)\
+	FIELD_GET(PTP_PTP_TOD_NSEC_PTP_TOD_NSEC, x)
+
+/*      DEVCPU_PTP:PTP_PINS:PTP_TOD_NSEC_FRAC */
+#define PTP_PTP_TOD_NSEC_FRAC(g)  __REG(TARGET_PTP, 0, 1, 0, g, 5, 64, 16, 0, 1, 4)
+
+#define PTP_PTP_TOD_NSEC_FRAC_PTP_TOD_NSEC_FRAC  GENMASK(7, 0)
+#define PTP_PTP_TOD_NSEC_FRAC_PTP_TOD_NSEC_FRAC_SET(x)\
+	FIELD_PREP(PTP_PTP_TOD_NSEC_FRAC_PTP_TOD_NSEC_FRAC, x)
+#define PTP_PTP_TOD_NSEC_FRAC_PTP_TOD_NSEC_FRAC_GET(x)\
+	FIELD_GET(PTP_PTP_TOD_NSEC_FRAC_PTP_TOD_NSEC_FRAC, x)
+
+/*      DEVCPU_PTP:PTP_PINS:NTP_NSEC */
+#define PTP_NTP_NSEC(g)           __REG(TARGET_PTP, 0, 1, 0, g, 5, 64, 20, 0, 1, 4)
+
+/*      DEVCPU_PTP:PTP_PINS:PIN_WF_HIGH_PERIOD */
+#define PTP_PIN_WF_HIGH_PERIOD(g) __REG(TARGET_PTP, 0, 1, 0, g, 5, 64, 24, 0, 1, 4)
+
+#define PTP_PIN_WF_HIGH_PERIOD_PIN_WFH           GENMASK(29, 0)
+#define PTP_PIN_WF_HIGH_PERIOD_PIN_WFH_SET(x)\
+	FIELD_PREP(PTP_PIN_WF_HIGH_PERIOD_PIN_WFH, x)
+#define PTP_PIN_WF_HIGH_PERIOD_PIN_WFH_GET(x)\
+	FIELD_GET(PTP_PIN_WF_HIGH_PERIOD_PIN_WFH, x)
+
+/*      DEVCPU_PTP:PTP_PINS:PIN_WF_LOW_PERIOD */
+#define PTP_PIN_WF_LOW_PERIOD(g)  __REG(TARGET_PTP, 0, 1, 0, g, 5, 64, 28, 0, 1, 4)
+
+#define PTP_PIN_WF_LOW_PERIOD_PIN_WFL            GENMASK(29, 0)
+#define PTP_PIN_WF_LOW_PERIOD_PIN_WFL_SET(x)\
+	FIELD_PREP(PTP_PIN_WF_LOW_PERIOD_PIN_WFL, x)
+#define PTP_PIN_WF_LOW_PERIOD_PIN_WFL_GET(x)\
+	FIELD_GET(PTP_PIN_WF_LOW_PERIOD_PIN_WFL, x)
+
+/*      DEVCPU_PTP:PTP_PINS:PIN_IOBOUNCH_DELAY */
+#define PTP_PIN_IOBOUNCH_DELAY(g) __REG(TARGET_PTP, 0, 1, 0, g, 5, 64, 32, 0, 1, 4)
+
+#define PTP_PIN_IOBOUNCH_DELAY_PIN_IOBOUNCH_VAL  GENMASK(18, 3)
+#define PTP_PIN_IOBOUNCH_DELAY_PIN_IOBOUNCH_VAL_SET(x)\
+	FIELD_PREP(PTP_PIN_IOBOUNCH_DELAY_PIN_IOBOUNCH_VAL, x)
+#define PTP_PIN_IOBOUNCH_DELAY_PIN_IOBOUNCH_VAL_GET(x)\
+	FIELD_GET(PTP_PIN_IOBOUNCH_DELAY_PIN_IOBOUNCH_VAL, x)
+
+#define PTP_PIN_IOBOUNCH_DELAY_PIN_IOBOUNCH_CFG  GENMASK(2, 0)
+#define PTP_PIN_IOBOUNCH_DELAY_PIN_IOBOUNCH_CFG_SET(x)\
+	FIELD_PREP(PTP_PIN_IOBOUNCH_DELAY_PIN_IOBOUNCH_CFG, x)
+#define PTP_PIN_IOBOUNCH_DELAY_PIN_IOBOUNCH_CFG_GET(x)\
+	FIELD_GET(PTP_PIN_IOBOUNCH_DELAY_PIN_IOBOUNCH_CFG, x)
+
+/*      DEVCPU_PTP:PHASE_DETECTOR_CTRL:PHAD_CTRL */
+#define PTP_PHAD_CTRL(g)          __REG(TARGET_PTP, 0, 1, 420, g, 5, 8, 0, 0, 1, 4)
+
+#define PTP_PHAD_CTRL_PHAD_ENA                   BIT(7)
+#define PTP_PHAD_CTRL_PHAD_ENA_SET(x)\
+	FIELD_PREP(PTP_PHAD_CTRL_PHAD_ENA, x)
+#define PTP_PHAD_CTRL_PHAD_ENA_GET(x)\
+	FIELD_GET(PTP_PHAD_CTRL_PHAD_ENA, x)
+
+#define PTP_PHAD_CTRL_PHAD_FAILED                BIT(6)
+#define PTP_PHAD_CTRL_PHAD_FAILED_SET(x)\
+	FIELD_PREP(PTP_PHAD_CTRL_PHAD_FAILED, x)
+#define PTP_PHAD_CTRL_PHAD_FAILED_GET(x)\
+	FIELD_GET(PTP_PHAD_CTRL_PHAD_FAILED, x)
+
+#define PTP_PHAD_CTRL_REDUCED_RES                GENMASK(5, 3)
+#define PTP_PHAD_CTRL_REDUCED_RES_SET(x)\
+	FIELD_PREP(PTP_PHAD_CTRL_REDUCED_RES, x)
+#define PTP_PHAD_CTRL_REDUCED_RES_GET(x)\
+	FIELD_GET(PTP_PHAD_CTRL_REDUCED_RES, x)
+
+#define PTP_PHAD_CTRL_LOCK_ACC                   GENMASK(2, 0)
+#define PTP_PHAD_CTRL_LOCK_ACC_SET(x)\
+	FIELD_PREP(PTP_PHAD_CTRL_LOCK_ACC, x)
+#define PTP_PHAD_CTRL_LOCK_ACC_GET(x)\
+	FIELD_GET(PTP_PHAD_CTRL_LOCK_ACC, x)
+
+/*      DEVCPU_PTP:PHASE_DETECTOR_CTRL:PHAD_CYC_STAT */
+#define PTP_PHAD_CYC_STAT(g)      __REG(TARGET_PTP, 0, 1, 420, g, 5, 8, 4, 0, 1, 4)
+
 /*      QFWD:SYSTEM:SWITCH_PORT_MODE */
 #define QFWD_SWITCH_PORT_MODE(r)  __REG(TARGET_QFWD, 0, 1, 0, 0, 1, 340, 0, r, 70, 4)
 
@@ -4528,6 +4772,93 @@ enum sparx5_target {
 #define REW_TAG_CTRL_TAG_DEI_CFG_GET(x)\
 	FIELD_GET(REW_TAG_CTRL_TAG_DEI_CFG, x)
 
+/*      REW:PTP_CTRL:PTP_TWOSTEP_CTRL */
+#define REW_PTP_TWOSTEP_CTRL      __REG(TARGET_REW, 0, 1, 378368, 0, 1, 40, 0, 0, 1, 4)
+
+#define REW_PTP_TWOSTEP_CTRL_PTP_OVWR_ENA        BIT(12)
+#define REW_PTP_TWOSTEP_CTRL_PTP_OVWR_ENA_SET(x)\
+	FIELD_PREP(REW_PTP_TWOSTEP_CTRL_PTP_OVWR_ENA, x)
+#define REW_PTP_TWOSTEP_CTRL_PTP_OVWR_ENA_GET(x)\
+	FIELD_GET(REW_PTP_TWOSTEP_CTRL_PTP_OVWR_ENA, x)
+
+#define REW_PTP_TWOSTEP_CTRL_PTP_NXT             BIT(11)
+#define REW_PTP_TWOSTEP_CTRL_PTP_NXT_SET(x)\
+	FIELD_PREP(REW_PTP_TWOSTEP_CTRL_PTP_NXT, x)
+#define REW_PTP_TWOSTEP_CTRL_PTP_NXT_GET(x)\
+	FIELD_GET(REW_PTP_TWOSTEP_CTRL_PTP_NXT, x)
+
+#define REW_PTP_TWOSTEP_CTRL_PTP_VLD             BIT(10)
+#define REW_PTP_TWOSTEP_CTRL_PTP_VLD_SET(x)\
+	FIELD_PREP(REW_PTP_TWOSTEP_CTRL_PTP_VLD, x)
+#define REW_PTP_TWOSTEP_CTRL_PTP_VLD_GET(x)\
+	FIELD_GET(REW_PTP_TWOSTEP_CTRL_PTP_VLD, x)
+
+#define REW_PTP_TWOSTEP_CTRL_STAMP_TX            BIT(9)
+#define REW_PTP_TWOSTEP_CTRL_STAMP_TX_SET(x)\
+	FIELD_PREP(REW_PTP_TWOSTEP_CTRL_STAMP_TX, x)
+#define REW_PTP_TWOSTEP_CTRL_STAMP_TX_GET(x)\
+	FIELD_GET(REW_PTP_TWOSTEP_CTRL_STAMP_TX, x)
+
+#define REW_PTP_TWOSTEP_CTRL_STAMP_PORT          GENMASK(8, 1)
+#define REW_PTP_TWOSTEP_CTRL_STAMP_PORT_SET(x)\
+	FIELD_PREP(REW_PTP_TWOSTEP_CTRL_STAMP_PORT, x)
+#define REW_PTP_TWOSTEP_CTRL_STAMP_PORT_GET(x)\
+	FIELD_GET(REW_PTP_TWOSTEP_CTRL_STAMP_PORT, x)
+
+#define REW_PTP_TWOSTEP_CTRL_PTP_OVFL            BIT(0)
+#define REW_PTP_TWOSTEP_CTRL_PTP_OVFL_SET(x)\
+	FIELD_PREP(REW_PTP_TWOSTEP_CTRL_PTP_OVFL, x)
+#define REW_PTP_TWOSTEP_CTRL_PTP_OVFL_GET(x)\
+	FIELD_GET(REW_PTP_TWOSTEP_CTRL_PTP_OVFL, x)
+
+/*      REW:PTP_CTRL:PTP_TWOSTEP_STAMP */
+#define REW_PTP_TWOSTEP_STAMP     __REG(TARGET_REW, 0, 1, 378368, 0, 1, 40, 4, 0, 1, 4)
+
+#define REW_PTP_TWOSTEP_STAMP_STAMP_NSEC         GENMASK(29, 0)
+#define REW_PTP_TWOSTEP_STAMP_STAMP_NSEC_SET(x)\
+	FIELD_PREP(REW_PTP_TWOSTEP_STAMP_STAMP_NSEC, x)
+#define REW_PTP_TWOSTEP_STAMP_STAMP_NSEC_GET(x)\
+	FIELD_GET(REW_PTP_TWOSTEP_STAMP_STAMP_NSEC, x)
+
+/*      REW:PTP_CTRL:PTP_TWOSTEP_STAMP_SUBNS */
+#define REW_PTP_TWOSTEP_STAMP_SUBNS __REG(TARGET_REW, 0, 1, 378368, 0, 1, 40, 8, 0, 1, 4)
+
+#define REW_PTP_TWOSTEP_STAMP_SUBNS_STAMP_SUB_NSEC GENMASK(7, 0)
+#define REW_PTP_TWOSTEP_STAMP_SUBNS_STAMP_SUB_NSEC_SET(x)\
+	FIELD_PREP(REW_PTP_TWOSTEP_STAMP_SUBNS_STAMP_SUB_NSEC, x)
+#define REW_PTP_TWOSTEP_STAMP_SUBNS_STAMP_SUB_NSEC_GET(x)\
+	FIELD_GET(REW_PTP_TWOSTEP_STAMP_SUBNS_STAMP_SUB_NSEC, x)
+
+/*      REW:PTP_CTRL:PTP_RSRV_NOT_ZERO */
+#define REW_PTP_RSRV_NOT_ZERO     __REG(TARGET_REW, 0, 1, 378368, 0, 1, 40, 12, 0, 1, 4)
+
+/*      REW:PTP_CTRL:PTP_RSRV_NOT_ZERO1 */
+#define REW_PTP_RSRV_NOT_ZERO1    __REG(TARGET_REW, 0, 1, 378368, 0, 1, 40, 16, 0, 1, 4)
+
+/*      REW:PTP_CTRL:PTP_RSRV_NOT_ZERO2 */
+#define REW_PTP_RSRV_NOT_ZERO2    __REG(TARGET_REW, 0, 1, 378368, 0, 1, 40, 20, 0, 1, 4)
+
+#define REW_PTP_RSRV_NOT_ZERO2_PTP_RSRV_NOT_ZERO2 GENMASK(5, 0)
+#define REW_PTP_RSRV_NOT_ZERO2_PTP_RSRV_NOT_ZERO2_SET(x)\
+	FIELD_PREP(REW_PTP_RSRV_NOT_ZERO2_PTP_RSRV_NOT_ZERO2, x)
+#define REW_PTP_RSRV_NOT_ZERO2_PTP_RSRV_NOT_ZERO2_GET(x)\
+	FIELD_GET(REW_PTP_RSRV_NOT_ZERO2_PTP_RSRV_NOT_ZERO2, x)
+
+/*      REW:PTP_CTRL:PTP_GEN_STAMP_FMT */
+#define REW_PTP_GEN_STAMP_FMT(r)  __REG(TARGET_REW, 0, 1, 378368, 0, 1, 40, 24, r, 4, 4)
+
+#define REW_PTP_GEN_STAMP_FMT_RT_OFS             GENMASK(6, 2)
+#define REW_PTP_GEN_STAMP_FMT_RT_OFS_SET(x)\
+	FIELD_PREP(REW_PTP_GEN_STAMP_FMT_RT_OFS, x)
+#define REW_PTP_GEN_STAMP_FMT_RT_OFS_GET(x)\
+	FIELD_GET(REW_PTP_GEN_STAMP_FMT_RT_OFS, x)
+
+#define REW_PTP_GEN_STAMP_FMT_RT_FMT             GENMASK(1, 0)
+#define REW_PTP_GEN_STAMP_FMT_RT_FMT_SET(x)\
+	FIELD_PREP(REW_PTP_GEN_STAMP_FMT_RT_FMT, x)
+#define REW_PTP_GEN_STAMP_FMT_RT_FMT_GET(x)\
+	FIELD_GET(REW_PTP_GEN_STAMP_FMT_RT_FMT, x)
+
 /*      REW:RAM_CTRL:RAM_INIT */
 #define REW_RAM_INIT              __REG(TARGET_REW, 0, 1, 378696, 0, 1, 4, 0, 0, 1, 4)
 
-- 
2.33.0

