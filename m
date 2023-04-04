Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AFD6D5895
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjDDGQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbjDDGQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:16:06 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAFA30FB;
        Mon,  3 Apr 2023 23:15:43 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3346FD9g053403;
        Tue, 4 Apr 2023 01:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680588913;
        bh=XBRjH3CxR+z0hKee/nrrgTzBzmYllKaKKk/QFqGG+9s=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=WfZVJVwY7fTOo5GS0V7QTXafJi/4ysLXHNOGFHhfDV/dDDcvRjLk7gOCBrp8YHJl7
         0xMj4igJ7piYIgiQa/Cbwpzf1zrRtKd1q0Rs07jIRVT82dQFjbub/BwWjNsyQtTCTY
         V/2MaoGPxOkDZzmxPEyq7si50s7zgXf7FS3MOI58=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3346FD7I064350
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 4 Apr 2023 01:15:13 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 4
 Apr 2023 01:15:13 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 4 Apr 2023 01:15:13 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3346ExNA087499;
        Tue, 4 Apr 2023 01:15:10 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v3 3/3] net: ethernet: ti: am65-cpsw: Enable USXGMII mode for J784S4 CPSW9G
Date:   Tue, 4 Apr 2023 11:44:59 +0530
Message-ID: <20230404061459.1100519-4-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230404061459.1100519-1-s-vadapalli@ti.com>
References: <20230404061459.1100519-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
extra_modes member of the J784S4 SoC data.

Configure MAC control register for supporting USXGMII mode and add
MAC_5000FD in the "mac_capabilities" member of struct "phylink_config".

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index f1e83d49de75..cf7bef5e3e22 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1514,6 +1514,14 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
 			cpsw_sl_ctl_clr(port->slave.mac_sl, CPSW_SL_CTL_EXT_EN);
 		}
 
+		if (state->interface == PHY_INTERFACE_MODE_USXGMII) {
+			cpsw_sl_ctl_set(port->slave.mac_sl,
+					CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN);
+		} else {
+			cpsw_sl_ctl_clr(port->slave.mac_sl,
+					CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN);
+		}
+
 		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
 		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
 	}
@@ -2171,7 +2179,8 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	/* Configuring Phylink */
 	port->slave.phylink_config.dev = &port->ndev->dev;
 	port->slave.phylink_config.type = PHYLINK_NETDEV;
-	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD;
+	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
+						      MAC_1000FD | MAC_5000FD;
 	port->slave.phylink_config.mac_managed_pm = true; /* MAC does PM */
 
 	switch (port->slave.phy_if) {
@@ -2189,6 +2198,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 
 	case PHY_INTERFACE_MODE_QSGMII:
 	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_USXGMII:
 		if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
 			__set_bit(port->slave.phy_if,
 				  port->slave.phylink_config.supported_interfaces);
@@ -2814,7 +2824,7 @@ static const struct am65_cpsw_pdata j784s4_cpswxg_pdata = {
 	.quirks = 0,
 	.ale_dev_id = "am64-cpswxg",
 	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
-	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
+	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII) | BIT(PHY_INTERFACE_MODE_USXGMII),
 };
 
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
-- 
2.25.1

