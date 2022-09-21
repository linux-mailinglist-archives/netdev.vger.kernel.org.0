Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A916E5BFDB7
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiIUMVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIUMV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:21:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CFF8B2CF;
        Wed, 21 Sep 2022 05:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663762888; x=1695298888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X5YoVHDmA5S2hnj0A8k23Gt3j3pneaMUBM6qY7S9w5U=;
  b=xCNrVJadD5ts0FI6JmWgDXH5qRbW7/l65FxZpOFLeVbsvBKrwMocmUdY
   h0G5JnSX6lH+YjcWvLSUP9TX7X38fYqyXBEwh7XBMY7zumkUwb6l0DBOI
   jMuOOttyKtXLL4qJ8gVkDEe9z1pIAwgUXFJRT4zoVC3cbzcP8VJl/Tua2
   RQ9bASQsdkiPAFUoK+09QZg3SpJWxo2dOXPBYWxtSRmWw/wEdtfvp37eZ
   PejNwCb6kr1mu+jLIyBJraAnfhOq0dXPSPN/8JtDwaP1/9lkXpMsOOmYm
   QpnaZbnrnhUxeq84azchegVIc64qgq3Vo2gIg9Osif/32MnKpOnFItuPl
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="174903309"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Sep 2022 05:21:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 21 Sep 2022 05:21:25 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 21 Sep 2022 05:21:23 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 3/4] net: lan966x: Add registers used by taprio
Date:   Wed, 21 Sep 2022 14:25:37 +0200
Message-ID: <20220921122538.2079744-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220921122538.2079744-1-horatiu.vultur@microchip.com>
References: <20220921122538.2079744-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add registers that are used by taprio to configure the HW.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_regs.h | 159 ++++++++++++++++++
 1 file changed, 159 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index f2d83fc540d24..684b08c6ff34e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -1018,6 +1018,165 @@ enum lan966x_target {
 /*      QSYS:RES_CTRL:RES_CFG */
 #define QSYS_RES_CFG(g)           __REG(TARGET_QSYS, 0, 1, 32768, g, 1024, 8, 0, 0, 1, 4)
 
+/*      QSYS:TAS_CONFIG:TAS_CFG_CTRL */
+#define QSYS_TAS_CFG_CTRL         __REG(TARGET_QSYS, 0, 1, 57372, 0, 1, 12, 0, 0, 1, 4)
+
+#define QSYS_TAS_CFG_CTRL_LIST_NUM_MAX           GENMASK(27, 23)
+#define QSYS_TAS_CFG_CTRL_LIST_NUM_MAX_SET(x)\
+	FIELD_PREP(QSYS_TAS_CFG_CTRL_LIST_NUM_MAX, x)
+#define QSYS_TAS_CFG_CTRL_LIST_NUM_MAX_GET(x)\
+	FIELD_GET(QSYS_TAS_CFG_CTRL_LIST_NUM_MAX, x)
+
+#define QSYS_TAS_CFG_CTRL_LIST_NUM               GENMASK(22, 18)
+#define QSYS_TAS_CFG_CTRL_LIST_NUM_SET(x)\
+	FIELD_PREP(QSYS_TAS_CFG_CTRL_LIST_NUM, x)
+#define QSYS_TAS_CFG_CTRL_LIST_NUM_GET(x)\
+	FIELD_GET(QSYS_TAS_CFG_CTRL_LIST_NUM, x)
+
+#define QSYS_TAS_CFG_CTRL_ALWAYS_GB_SCH_Q        BIT(17)
+#define QSYS_TAS_CFG_CTRL_ALWAYS_GB_SCH_Q_SET(x)\
+	FIELD_PREP(QSYS_TAS_CFG_CTRL_ALWAYS_GB_SCH_Q, x)
+#define QSYS_TAS_CFG_CTRL_ALWAYS_GB_SCH_Q_GET(x)\
+	FIELD_GET(QSYS_TAS_CFG_CTRL_ALWAYS_GB_SCH_Q, x)
+
+#define QSYS_TAS_CFG_CTRL_GCL_ENTRY_NUM          GENMASK(16, 5)
+#define QSYS_TAS_CFG_CTRL_GCL_ENTRY_NUM_SET(x)\
+	FIELD_PREP(QSYS_TAS_CFG_CTRL_GCL_ENTRY_NUM, x)
+#define QSYS_TAS_CFG_CTRL_GCL_ENTRY_NUM_GET(x)\
+	FIELD_GET(QSYS_TAS_CFG_CTRL_GCL_ENTRY_NUM, x)
+
+/*      QSYS:TAS_CONFIG:TAS_GATE_STATE_CTRL */
+#define QSYS_TAS_GS_CTRL          __REG(TARGET_QSYS, 0, 1, 57372, 0, 1, 12, 4, 0, 1, 4)
+
+#define QSYS_TAS_GS_CTRL_HSCH_POS                GENMASK(2, 0)
+#define QSYS_TAS_GS_CTRL_HSCH_POS_SET(x)\
+	FIELD_PREP(QSYS_TAS_GS_CTRL_HSCH_POS, x)
+#define QSYS_TAS_GS_CTRL_HSCH_POS_GET(x)\
+	FIELD_GET(QSYS_TAS_GS_CTRL_HSCH_POS, x)
+
+/*      QSYS:TAS_CONFIG:TAS_STATEMACHINE_CFG */
+#define QSYS_TAS_STM_CFG          __REG(TARGET_QSYS, 0, 1, 57372, 0, 1, 12, 8, 0, 1, 4)
+
+#define QSYS_TAS_STM_CFG_REVISIT_DLY             GENMASK(7, 0)
+#define QSYS_TAS_STM_CFG_REVISIT_DLY_SET(x)\
+	FIELD_PREP(QSYS_TAS_STM_CFG_REVISIT_DLY, x)
+#define QSYS_TAS_STM_CFG_REVISIT_DLY_GET(x)\
+	FIELD_GET(QSYS_TAS_STM_CFG_REVISIT_DLY, x)
+
+/*      QSYS:TAS_PROFILE_CFG:TAS_PROFILE_CONFIG */
+#define QSYS_TAS_PROFILE_CFG(g)   __REG(TARGET_QSYS, 0, 1, 30720, g, 16, 64, 32, 0, 1, 4)
+
+#define QSYS_TAS_PROFILE_CFG_PORT_NUM            GENMASK(21, 19)
+#define QSYS_TAS_PROFILE_CFG_PORT_NUM_SET(x)\
+	FIELD_PREP(QSYS_TAS_PROFILE_CFG_PORT_NUM, x)
+#define QSYS_TAS_PROFILE_CFG_PORT_NUM_GET(x)\
+	FIELD_GET(QSYS_TAS_PROFILE_CFG_PORT_NUM, x)
+
+#define QSYS_TAS_PROFILE_CFG_LINK_SPEED          GENMASK(18, 16)
+#define QSYS_TAS_PROFILE_CFG_LINK_SPEED_SET(x)\
+	FIELD_PREP(QSYS_TAS_PROFILE_CFG_LINK_SPEED, x)
+#define QSYS_TAS_PROFILE_CFG_LINK_SPEED_GET(x)\
+	FIELD_GET(QSYS_TAS_PROFILE_CFG_LINK_SPEED, x)
+
+/*      QSYS:TAS_LIST_CFG:TAS_BASE_TIME_NSEC */
+#define QSYS_TAS_BT_NSEC          __REG(TARGET_QSYS, 0, 1, 27904, 0, 1, 64, 0, 0, 1, 4)
+
+#define QSYS_TAS_BT_NSEC_NSEC                    GENMASK(29, 0)
+#define QSYS_TAS_BT_NSEC_NSEC_SET(x)\
+	FIELD_PREP(QSYS_TAS_BT_NSEC_NSEC, x)
+#define QSYS_TAS_BT_NSEC_NSEC_GET(x)\
+	FIELD_GET(QSYS_TAS_BT_NSEC_NSEC, x)
+
+/*      QSYS:TAS_LIST_CFG:TAS_BASE_TIME_SEC_LSB */
+#define QSYS_TAS_BT_SEC_LSB       __REG(TARGET_QSYS, 0, 1, 27904, 0, 1, 64, 4, 0, 1, 4)
+
+/*      QSYS:TAS_LIST_CFG:TAS_BASE_TIME_SEC_MSB */
+#define QSYS_TAS_BT_SEC_MSB       __REG(TARGET_QSYS, 0, 1, 27904, 0, 1, 64, 8, 0, 1, 4)
+
+#define QSYS_TAS_BT_SEC_MSB_SEC_MSB              GENMASK(15, 0)
+#define QSYS_TAS_BT_SEC_MSB_SEC_MSB_SET(x)\
+	FIELD_PREP(QSYS_TAS_BT_SEC_MSB_SEC_MSB, x)
+#define QSYS_TAS_BT_SEC_MSB_SEC_MSB_GET(x)\
+	FIELD_GET(QSYS_TAS_BT_SEC_MSB_SEC_MSB, x)
+
+/*      QSYS:TAS_LIST_CFG:TAS_CYCLE_TIME_CFG */
+#define QSYS_TAS_CT_CFG           __REG(TARGET_QSYS, 0, 1, 27904, 0, 1, 64, 24, 0, 1, 4)
+
+/*      QSYS:TAS_LIST_CFG:TAS_STARTUP_CFG */
+#define QSYS_TAS_STARTUP_CFG      __REG(TARGET_QSYS, 0, 1, 27904, 0, 1, 64, 28, 0, 1, 4)
+
+#define QSYS_TAS_STARTUP_CFG_OBSOLETE_IDX        GENMASK(27, 23)
+#define QSYS_TAS_STARTUP_CFG_OBSOLETE_IDX_SET(x)\
+	FIELD_PREP(QSYS_TAS_STARTUP_CFG_OBSOLETE_IDX, x)
+#define QSYS_TAS_STARTUP_CFG_OBSOLETE_IDX_GET(x)\
+	FIELD_GET(QSYS_TAS_STARTUP_CFG_OBSOLETE_IDX, x)
+
+/*      QSYS:TAS_LIST_CFG:TAS_LIST_CFG */
+#define QSYS_TAS_LIST_CFG         __REG(TARGET_QSYS, 0, 1, 27904, 0, 1, 64, 32, 0, 1, 4)
+
+#define QSYS_TAS_LIST_CFG_LIST_BASE_ADDR         GENMASK(11, 0)
+#define QSYS_TAS_LIST_CFG_LIST_BASE_ADDR_SET(x)\
+	FIELD_PREP(QSYS_TAS_LIST_CFG_LIST_BASE_ADDR, x)
+#define QSYS_TAS_LIST_CFG_LIST_BASE_ADDR_GET(x)\
+	FIELD_GET(QSYS_TAS_LIST_CFG_LIST_BASE_ADDR, x)
+
+/*      QSYS:TAS_LIST_CFG:TAS_LIST_STATE */
+#define QSYS_TAS_LST              __REG(TARGET_QSYS, 0, 1, 27904, 0, 1, 64, 36, 0, 1, 4)
+
+#define QSYS_TAS_LST_LIST_STATE                  GENMASK(2, 0)
+#define QSYS_TAS_LST_LIST_STATE_SET(x)\
+	FIELD_PREP(QSYS_TAS_LST_LIST_STATE, x)
+#define QSYS_TAS_LST_LIST_STATE_GET(x)\
+	FIELD_GET(QSYS_TAS_LST_LIST_STATE, x)
+
+/*      QSYS:TAS_GCL_CFG:TAS_GCL_CTRL_CFG */
+#define QSYS_TAS_GCL_CT_CFG       __REG(TARGET_QSYS, 0, 1, 27968, 0, 1, 16, 0, 0, 1, 4)
+
+#define QSYS_TAS_GCL_CT_CFG_HSCH_POS             GENMASK(12, 10)
+#define QSYS_TAS_GCL_CT_CFG_HSCH_POS_SET(x)\
+	FIELD_PREP(QSYS_TAS_GCL_CT_CFG_HSCH_POS, x)
+#define QSYS_TAS_GCL_CT_CFG_HSCH_POS_GET(x)\
+	FIELD_GET(QSYS_TAS_GCL_CT_CFG_HSCH_POS, x)
+
+#define QSYS_TAS_GCL_CT_CFG_GATE_STATE           GENMASK(9, 2)
+#define QSYS_TAS_GCL_CT_CFG_GATE_STATE_SET(x)\
+	FIELD_PREP(QSYS_TAS_GCL_CT_CFG_GATE_STATE, x)
+#define QSYS_TAS_GCL_CT_CFG_GATE_STATE_GET(x)\
+	FIELD_GET(QSYS_TAS_GCL_CT_CFG_GATE_STATE, x)
+
+#define QSYS_TAS_GCL_CT_CFG_OP_TYPE              GENMASK(1, 0)
+#define QSYS_TAS_GCL_CT_CFG_OP_TYPE_SET(x)\
+	FIELD_PREP(QSYS_TAS_GCL_CT_CFG_OP_TYPE, x)
+#define QSYS_TAS_GCL_CT_CFG_OP_TYPE_GET(x)\
+	FIELD_GET(QSYS_TAS_GCL_CT_CFG_OP_TYPE, x)
+
+/*      QSYS:TAS_GCL_CFG:TAS_GCL_CTRL_CFG2 */
+#define QSYS_TAS_GCL_CT_CFG2      __REG(TARGET_QSYS, 0, 1, 27968, 0, 1, 16, 4, 0, 1, 4)
+
+#define QSYS_TAS_GCL_CT_CFG2_PORT_PROFILE        GENMASK(15, 12)
+#define QSYS_TAS_GCL_CT_CFG2_PORT_PROFILE_SET(x)\
+	FIELD_PREP(QSYS_TAS_GCL_CT_CFG2_PORT_PROFILE, x)
+#define QSYS_TAS_GCL_CT_CFG2_PORT_PROFILE_GET(x)\
+	FIELD_GET(QSYS_TAS_GCL_CT_CFG2_PORT_PROFILE, x)
+
+#define QSYS_TAS_GCL_CT_CFG2_NEXT_GCL            GENMASK(11, 0)
+#define QSYS_TAS_GCL_CT_CFG2_NEXT_GCL_SET(x)\
+	FIELD_PREP(QSYS_TAS_GCL_CT_CFG2_NEXT_GCL, x)
+#define QSYS_TAS_GCL_CT_CFG2_NEXT_GCL_GET(x)\
+	FIELD_GET(QSYS_TAS_GCL_CT_CFG2_NEXT_GCL, x)
+
+/*      QSYS:TAS_GCL_CFG:TAS_GCL_TIME_CFG */
+#define QSYS_TAS_GCL_TM_CFG       __REG(TARGET_QSYS, 0, 1, 27968, 0, 1, 16, 8, 0, 1, 4)
+
+/*      QSYS:HSCH_TAS_STATE:TAS_GATE_STATE */
+#define QSYS_TAS_GATE_STATE       __REG(TARGET_QSYS, 0, 1, 28004, 0, 1, 4, 0, 0, 1, 4)
+
+#define QSYS_TAS_GATE_STATE_TAS_GATE_STATE       GENMASK(7, 0)
+#define QSYS_TAS_GATE_STATE_TAS_GATE_STATE_SET(x)\
+	FIELD_PREP(QSYS_TAS_GATE_STATE_TAS_GATE_STATE, x)
+#define QSYS_TAS_GATE_STATE_TAS_GATE_STATE_GET(x)\
+	FIELD_GET(QSYS_TAS_GATE_STATE_TAS_GATE_STATE, x)
+
 /*      REW:PORT:PORT_VLAN_CFG */
 #define REW_PORT_VLAN_CFG(g)      __REG(TARGET_REW, 0, 1, 0, g, 10, 128, 0, 0, 1, 4)
 
-- 
2.33.0

