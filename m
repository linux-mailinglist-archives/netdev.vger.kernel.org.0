Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB67B563B61
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiGAUtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiGAUti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:49:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A415C9D9;
        Fri,  1 Jul 2022 13:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656708578; x=1688244578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZBIS9vf0JNugI6BuLOu53/aRY/vdyAbuzLRAWzcdQdw=;
  b=UGK+9DTq/PF7HnzagI2Ia703+pGsL/GSjBnu2bMEFTFGxOos0+AGwjQY
   FGhtN9GolBB+YVMcwPXrv5IhsHDP8FcLbkO4QRV/sf7ddffh3TJTJw2tv
   4uibtoA20R/12til+SGGVZ3Dh3ZJYk3IJjXHNg/y9tGSXI83pAYoTUNfg
   IAKxgR/4OKx07MvmTvJfpoqmLOZcBVCrgo/Si4NvcZ5NOa3z/85TGILuh
   +9w977vjjnbnioqJzu/LwIjDNBiTptHZjdoIYVa2FjMk0xB+vtetrSDVi
   9yCgdqgXDfLD8E1JNcl1rYhF8o38oa3mhGeC1h9XEuWfx4yZ4oEMN+7xK
   g==;
X-IronPort-AV: E=Sophos;i="5.92,238,1650956400"; 
   d="scan'208";a="180427108"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 13:49:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 13:49:37 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 13:49:35 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 1/7] net: lan966x: Add reqisters used to configure lag interfaces
Date:   Fri, 1 Jul 2022 22:52:21 +0200
Message-ID: <20220701205227.1337160-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
References: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
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

