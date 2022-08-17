Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D7A59768F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbiHQTbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbiHQTbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:31:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD56796FD8;
        Wed, 17 Aug 2022 12:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660764662; x=1692300662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZBIS9vf0JNugI6BuLOu53/aRY/vdyAbuzLRAWzcdQdw=;
  b=csXKEEKbRiAhoenyrc/tSedA84c3PuRxiDh/ds697xjGdrLcQfwmZFfx
   VRKtQK7CYm4Qy/oS9lSlCWpFQBzlZOkMf4EPOiXtQsH//qojAg3ITk3Cc
   PnPlOWUgHENZL1W4OBdZJ++P6ONjH5GtqbRA3QhjOCEX7MCZv6nIeKJef
   6fRthFlyVIQ380eGGm+nq0fo+v3zqQ9UPcrU0TKKP1jJJ0zgN6hG3lBAO
   Yl9fMRyubZSTMxQJllJ4wovw7+TXX6QSMECb3AiweKtKmz16b8B2oe8tY
   1hERvxAcoM3jsnf4g8xttHI4g0gerIJe0NajZdzjYuMW+cQG13p8gLudq
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="176816594"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2022 12:31:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 17 Aug 2022 12:30:48 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 17 Aug 2022 12:30:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 1/8] net: lan966x: Add registers used to configure lag interfaces
Date:   Wed, 17 Aug 2022 21:34:42 +0200
Message-ID: <20220817193449.1673002-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
References: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

