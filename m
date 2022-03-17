Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156394DCDEE
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbiCQSvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236433AbiCQSu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:50:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6925415282D;
        Thu, 17 Mar 2022 11:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647542979; x=1679078979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WfI5G02fGHkS/S1ac3LCaw287JuZCekgMpLauxPRYAA=;
  b=czTl7RQWEZH17QGu11H1vWQd/++yu/b7EfDIsDSR19LZRqRa8E7+DHlP
   T31Wchy9DZyGlZvzRSvLzzwFN/a8s2qf4416DcMsbgn/uJJMtmjY21gFv
   RX8Me65ktHFRPyK2/OC0l8pRKwmEaRx3Q20+iOwPT+k4mIyfwhGp5lBF9
   cjgLBqtlCohfjuYrVaA/z18OQznnmT1mapuhjKWH7enxS02/uzlRZfgFK
   YnNAgpOYmkwEuthzHXdhnCF3RQAfngyxiTpOz+zjnTBBgD48yDWTjPpRf
   4qljackiOUQqrN7iSPULhQEf6hbbaDOOC5d6+PxgOrmWlro+9yLlnrsjy
   A==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="157296999"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 11:49:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 11:49:27 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 17 Mar 2022 11:49:25 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/5] net: lan966x: Add registers that are used for FDMA.
Date:   Thu, 17 Mar 2022 19:51:56 +0100
Message-ID: <20220317185159.1661469-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220317185159.1661469-1-horatiu.vultur@microchip.com>
References: <20220317185159.1661469-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR,UPPERCASE_50_75 autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the registers that are used to configure the FDMA.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c |   1 +
 .../ethernet/microchip/lan966x/lan966x_regs.h | 106 ++++++++++++++++++
 2 files changed, 107 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index e1bcb28039dc..4240db708886 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -43,6 +43,7 @@ struct lan966x_main_io_resource {
 
 static const struct lan966x_main_io_resource lan966x_main_iomap[] =  {
 	{ TARGET_CPU,                   0xc0000, 0 }, /* 0xe00c0000 */
+	{ TARGET_FDMA,                  0xc0400, 0 }, /* 0xe00c0400 */
 	{ TARGET_ORG,                         0, 1 }, /* 0xe2000000 */
 	{ TARGET_GCB,                    0x4000, 1 }, /* 0xe2004000 */
 	{ TARGET_QS,                     0x8000, 1 }, /* 0xe2008000 */
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 0c0b3e173d53..2f59285bef29 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -17,6 +17,7 @@ enum lan966x_target {
 	TARGET_CHIP_TOP = 5,
 	TARGET_CPU = 6,
 	TARGET_DEV = 13,
+	TARGET_FDMA = 21,
 	TARGET_GCB = 27,
 	TARGET_ORG = 36,
 	TARGET_PTP = 41,
@@ -578,6 +579,111 @@ enum lan966x_target {
 #define DEV_PCS1G_STICKY_LINK_DOWN_STICKY_GET(x)\
 	FIELD_GET(DEV_PCS1G_STICKY_LINK_DOWN_STICKY, x)
 
+/*      FDMA:FDMA:FDMA_CH_ACTIVATE */
+#define FDMA_CH_ACTIVATE          __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 0, 0, 1, 4)
+
+#define FDMA_CH_ACTIVATE_CH_ACTIVATE             GENMASK(7, 0)
+#define FDMA_CH_ACTIVATE_CH_ACTIVATE_SET(x)\
+	FIELD_PREP(FDMA_CH_ACTIVATE_CH_ACTIVATE, x)
+#define FDMA_CH_ACTIVATE_CH_ACTIVATE_GET(x)\
+	FIELD_GET(FDMA_CH_ACTIVATE_CH_ACTIVATE, x)
+
+/*      FDMA:FDMA:FDMA_CH_RELOAD */
+#define FDMA_CH_RELOAD            __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 4, 0, 1, 4)
+
+#define FDMA_CH_RELOAD_CH_RELOAD                 GENMASK(7, 0)
+#define FDMA_CH_RELOAD_CH_RELOAD_SET(x)\
+	FIELD_PREP(FDMA_CH_RELOAD_CH_RELOAD, x)
+#define FDMA_CH_RELOAD_CH_RELOAD_GET(x)\
+	FIELD_GET(FDMA_CH_RELOAD_CH_RELOAD, x)
+
+/*      FDMA:FDMA:FDMA_CH_DISABLE */
+#define FDMA_CH_DISABLE           __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 8, 0, 1, 4)
+
+#define FDMA_CH_DISABLE_CH_DISABLE               GENMASK(7, 0)
+#define FDMA_CH_DISABLE_CH_DISABLE_SET(x)\
+	FIELD_PREP(FDMA_CH_DISABLE_CH_DISABLE, x)
+#define FDMA_CH_DISABLE_CH_DISABLE_GET(x)\
+	FIELD_GET(FDMA_CH_DISABLE_CH_DISABLE, x)
+
+/*      FDMA:FDMA:FDMA_CH_DB_DISCARD */
+#define FDMA_CH_DB_DISCARD        __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 16, 0, 1, 4)
+
+#define FDMA_CH_DB_DISCARD_DB_DISCARD            GENMASK(7, 0)
+#define FDMA_CH_DB_DISCARD_DB_DISCARD_SET(x)\
+	FIELD_PREP(FDMA_CH_DB_DISCARD_DB_DISCARD, x)
+#define FDMA_CH_DB_DISCARD_DB_DISCARD_GET(x)\
+	FIELD_GET(FDMA_CH_DB_DISCARD_DB_DISCARD, x)
+
+/*      FDMA:FDMA:FDMA_DCB_LLP */
+#define FDMA_DCB_LLP(r)           __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 52, r, 8, 4)
+
+/*      FDMA:FDMA:FDMA_DCB_LLP1 */
+#define FDMA_DCB_LLP1(r)          __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 84, r, 8, 4)
+
+/*      FDMA:FDMA:FDMA_CH_ACTIVE */
+#define FDMA_CH_ACTIVE            __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 180, 0, 1, 4)
+
+/*      FDMA:FDMA:FDMA_CH_CFG */
+#define FDMA_CH_CFG(r)            __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 224, r, 8, 4)
+
+#define FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY          BIT(4)
+#define FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY_SET(x)\
+	FIELD_PREP(FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY, x)
+#define FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY_GET(x)\
+	FIELD_GET(FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY, x)
+
+#define FDMA_CH_CFG_CH_INJ_PORT                  BIT(3)
+#define FDMA_CH_CFG_CH_INJ_PORT_SET(x)\
+	FIELD_PREP(FDMA_CH_CFG_CH_INJ_PORT, x)
+#define FDMA_CH_CFG_CH_INJ_PORT_GET(x)\
+	FIELD_GET(FDMA_CH_CFG_CH_INJ_PORT, x)
+
+#define FDMA_CH_CFG_CH_DCB_DB_CNT                GENMASK(2, 1)
+#define FDMA_CH_CFG_CH_DCB_DB_CNT_SET(x)\
+	FIELD_PREP(FDMA_CH_CFG_CH_DCB_DB_CNT, x)
+#define FDMA_CH_CFG_CH_DCB_DB_CNT_GET(x)\
+	FIELD_GET(FDMA_CH_CFG_CH_DCB_DB_CNT, x)
+
+#define FDMA_CH_CFG_CH_MEM                       BIT(0)
+#define FDMA_CH_CFG_CH_MEM_SET(x)\
+	FIELD_PREP(FDMA_CH_CFG_CH_MEM, x)
+#define FDMA_CH_CFG_CH_MEM_GET(x)\
+	FIELD_GET(FDMA_CH_CFG_CH_MEM, x)
+
+/*      FDMA:FDMA:FDMA_PORT_CTRL */
+#define FDMA_PORT_CTRL(r)         __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 376, r, 2, 4)
+
+#define FDMA_PORT_CTRL_INJ_STOP                  BIT(4)
+#define FDMA_PORT_CTRL_INJ_STOP_SET(x)\
+	FIELD_PREP(FDMA_PORT_CTRL_INJ_STOP, x)
+#define FDMA_PORT_CTRL_INJ_STOP_GET(x)\
+	FIELD_GET(FDMA_PORT_CTRL_INJ_STOP, x)
+
+#define FDMA_PORT_CTRL_XTR_STOP                  BIT(2)
+#define FDMA_PORT_CTRL_XTR_STOP_SET(x)\
+	FIELD_PREP(FDMA_PORT_CTRL_XTR_STOP, x)
+#define FDMA_PORT_CTRL_XTR_STOP_GET(x)\
+	FIELD_GET(FDMA_PORT_CTRL_XTR_STOP, x)
+
+/*      FDMA:FDMA:FDMA_INTR_DB */
+#define FDMA_INTR_DB              __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 392, 0, 1, 4)
+
+/*      FDMA:FDMA:FDMA_INTR_DB_ENA */
+#define FDMA_INTR_DB_ENA          __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 396, 0, 1, 4)
+
+#define FDMA_INTR_DB_ENA_INTR_DB_ENA             GENMASK(7, 0)
+#define FDMA_INTR_DB_ENA_INTR_DB_ENA_SET(x)\
+	FIELD_PREP(FDMA_INTR_DB_ENA_INTR_DB_ENA, x)
+#define FDMA_INTR_DB_ENA_INTR_DB_ENA_GET(x)\
+	FIELD_GET(FDMA_INTR_DB_ENA_INTR_DB_ENA, x)
+
+/*      FDMA:FDMA:FDMA_INTR_ERR */
+#define FDMA_INTR_ERR             __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 400, 0, 1, 4)
+
+/*      FDMA:FDMA:FDMA_ERRORS */
+#define FDMA_ERRORS               __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 412, 0, 1, 4)
+
 /*      PTP:PTP_CFG:PTP_DOM_CFG */
 #define PTP_DOM_CFG               __REG(TARGET_PTP, 0, 1, 512, 0, 1, 16, 12, 0, 1, 4)
 
-- 
2.33.0

