Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4201755B215
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 15:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiFZNBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 09:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbiFZNBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 09:01:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9697A11800;
        Sun, 26 Jun 2022 06:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656248496; x=1687784496;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZBIS9vf0JNugI6BuLOu53/aRY/vdyAbuzLRAWzcdQdw=;
  b=zNwy4G3mz0+uSZVbRJ01N75wMcJ+vDd95Rnw+E8m0ZSLTWCOz2L+Yret
   LfViM+bsmn8ZzJ7vTsbyi2GdMdiP7KwFGK5ozFCwt7Hy/WKrDkhP9NYW1
   PZwTr7jZAGEfJO++3hIXeTWk/LYrCBYdMDZb8p9tvcB3jsO7z0NJklOJm
   WrR9ytr189dheqrO9Kf1DN7C5gbxVzpnZWC7djvZQ3zthMeGz7rcHtQCM
   Jwo57OlsP2DZaEdpZ7B6BnScNJwmC+pVK9Yc0qp5Ur6VedujVZXrA4p1Q
   Rtu9J8l0f7eVZKDj8/vcCnzi3p0E979MmHT+Yd8aZPeH1bfehj5Ts1AjE
   A==;
X-IronPort-AV: E=Sophos;i="5.92,224,1650956400"; 
   d="scan'208";a="101779755"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2022 06:01:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 26 Jun 2022 06:01:35 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 26 Jun 2022 06:01:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/8] net: lan966x: Add reqisters used to configure lag interfaces
Date:   Sun, 26 Jun 2022 15:04:44 +0200
Message-ID: <20220626130451.1079933-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
References: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
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

