Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1134155DC64
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241105AbiF0UJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 16:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240963AbiF0UJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 16:09:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CFC1EEE9;
        Mon, 27 Jun 2022 13:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656360592; x=1687896592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZBIS9vf0JNugI6BuLOu53/aRY/vdyAbuzLRAWzcdQdw=;
  b=jfTY1IbRypBe2YglOaQD66GWWN91NV/Za7WwoUvd5UsbCgqVx2AsmeiP
   +r9ILeuHE9R/CKgUxM5cl5xFxMRHNl+99prZelWosw4BgqESEHHmQAUAx
   LbJ5VzIi/I2K/RovkL/2RpFmkhy+1uQSPtYQ1mPjKSfAM+HAfxo6GCZA4
   kWFTQkKE/oe/0K3WmxlYvrPtVXSA1Nz1ya/BAGEWZxotLm0k7SZatDq4J
   zeOpCs5dkP4lfmXzMJbwWlntmJ/yE5uzm2i0iloonqbtiYrusjov0EKxY
   jzaYpHaGpO9NwY04LnHHSyVAUqiQB6d/cy3hOhlbfhW04rZsJgZqKHEGN
   w==;
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="162277515"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jun 2022 13:09:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 27 Jun 2022 13:09:49 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 27 Jun 2022 13:09:47 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/7] net: lan966x: Add reqisters used to configure lag interfaces
Date:   Mon, 27 Jun 2022 22:13:24 +0200
Message-ID: <20220627201330.45219-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220627201330.45219-1-horatiu.vultur@microchip.com>
References: <20220627201330.45219-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the registers used by lan966x to configure the lag interface.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_regs.h | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index 8265ad89f0bc..69eedff28ce3 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -363,6 +363,51 @@ enum lan966x_target {
 #define ANA_PFC_CFG_FC_LINK_SPEED_GET(x)\
 	FIELD_GET(ANA_PFC_CFG_FC_LINK_SPEED, x)
 
+/*      ANA:COMMON:AGGR_CFG */
+#define ANA_AGGR_CFG              __REG(TARGET_ANA, 0, 1, 31232, 0, 1, 552, 0, 0, 1, 4)
+
+#define ANA_AGGR_CFG_AC_RND_ENA                  BIT(6)
+#define ANA_AGGR_CFG_AC_RND_ENA_SET(x)\
+	FIELD_PREP(ANA_AGGR_CFG_AC_RND_ENA, x)
+#define ANA_AGGR_CFG_AC_RND_ENA_GET(x)\
+	FIELD_GET(ANA_AGGR_CFG_AC_RND_ENA, x)
+
+#define ANA_AGGR_CFG_AC_DMAC_ENA                 BIT(5)
+#define ANA_AGGR_CFG_AC_DMAC_ENA_SET(x)\
+	FIELD_PREP(ANA_AGGR_CFG_AC_DMAC_ENA, x)
+#define ANA_AGGR_CFG_AC_DMAC_ENA_GET(x)\
+	FIELD_GET(ANA_AGGR_CFG_AC_DMAC_ENA, x)
+
+#define ANA_AGGR_CFG_AC_SMAC_ENA                 BIT(4)
+#define ANA_AGGR_CFG_AC_SMAC_ENA_SET(x)\
+	FIELD_PREP(ANA_AGGR_CFG_AC_SMAC_ENA, x)
+#define ANA_AGGR_CFG_AC_SMAC_ENA_GET(x)\
+	FIELD_GET(ANA_AGGR_CFG_AC_SMAC_ENA, x)
+
+#define ANA_AGGR_CFG_AC_IP6_FLOW_LBL_ENA         BIT(3)
+#define ANA_AGGR_CFG_AC_IP6_FLOW_LBL_ENA_SET(x)\
+	FIELD_PREP(ANA_AGGR_CFG_AC_IP6_FLOW_LBL_ENA, x)
+#define ANA_AGGR_CFG_AC_IP6_FLOW_LBL_ENA_GET(x)\
+	FIELD_GET(ANA_AGGR_CFG_AC_IP6_FLOW_LBL_ENA, x)
+
+#define ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA           BIT(2)
+#define ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA_SET(x)\
+	FIELD_PREP(ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA, x)
+#define ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA_GET(x)\
+	FIELD_GET(ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA, x)
+
+#define ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA           BIT(1)
+#define ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA_SET(x)\
+	FIELD_PREP(ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA, x)
+#define ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA_GET(x)\
+	FIELD_GET(ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA, x)
+
+#define ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA           BIT(0)
+#define ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA_SET(x)\
+	FIELD_PREP(ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA, x)
+#define ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA_GET(x)\
+	FIELD_GET(ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA, x)
+
 /*      CHIP_TOP:CUPHY_CFG:CUPHY_PORT_CFG */
 #define CHIP_TOP_CUPHY_PORT_CFG(r) __REG(TARGET_CHIP_TOP, 0, 1, 16, 0, 1, 20, 8, r, 2, 4)
 
-- 
2.33.0

