Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F426C3039
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCULUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjCULUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:20:43 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3307B33CD0;
        Tue, 21 Mar 2023 04:20:25 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32LBK9r2127867;
        Tue, 21 Mar 2023 06:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679397610;
        bh=rg0pr5+qWnGZXVJsqCJwL2c2bXVbI+dN4RZpf6rUM8o=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=LJybZsh/aPXT7rXlUyDWAqJK+AbG9k1iCcuA71oOjbvTzhjnbj9Z0Zmq+2lmiKhxu
         vwj1vy2t4Xo9BuGwFvp0yfjW/hikrzo/ht0w33aM7yDXhWl8tpd0pKLNddN6rwXt4d
         6T/dkntlH+VHzbg/aei4oXuViHEKLqI1zfowUvHk=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32LBK9VS091452
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Mar 2023 06:20:09 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 21
 Mar 2023 06:20:09 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 21 Mar 2023 06:20:09 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32LBJxVo088542;
        Tue, 21 Mar 2023 06:20:06 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 2/4] net: ethernet: ti: am65-cpsw: Add support for SGMII mode
Date:   Tue, 21 Mar 2023 16:49:56 +0530
Message-ID: <20230321111958.2800005-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230321111958.2800005-1-s-vadapalli@ti.com>
References: <20230321111958.2800005-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring the CPSW Ethernet Switch in SGMII mode.

Depending on the SoC, allow selecting SGMII mode as a supported interface,
based on the compatible used.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index cba8db14e160..d2ca1f2035f4 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -76,6 +76,7 @@
 #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
 
 #define AM65_CPSW_SGMII_CONTROL_REG		0x010
+#define AM65_CPSW_SGMII_MR_ADV_ABILITY_REG	0x018
 #define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)
 
 #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
@@ -1496,9 +1497,14 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
 	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
 	struct am65_cpsw_common *common = port->common;
 
-	if (common->pdata.extra_modes & BIT(state->interface))
+	if (common->pdata.extra_modes & BIT(state->interface)) {
+		if (state->interface == PHY_INTERFACE_MODE_SGMII)
+			writel(ADVERTISE_SGMII,
+			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
+
 		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
 		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
+	}
 }
 
 static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned int mode,
@@ -1539,6 +1545,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 
 	if (speed == SPEED_1000)
 		mac_control |= CPSW_SL_CTL_GIG;
+	if (interface == PHY_INTERFACE_MODE_SGMII)
+		mac_control |= CPSW_SL_CTL_EXT_EN;
 	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
 		/* Can be used with in band mode only */
 		mac_control |= CPSW_SL_CTL_EXT_EN;
@@ -2157,6 +2165,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 		break;
 
 	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_SGMII:
 		if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
 			__set_bit(port->slave.phy_if,
 				  port->slave.phylink_config.supported_interfaces);
-- 
2.25.1

