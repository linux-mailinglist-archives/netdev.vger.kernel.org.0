Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD6A538FE5
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343864AbiEaLb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343848AbiEaLby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:31:54 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7CC65DE;
        Tue, 31 May 2022 04:31:53 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 24VBVdlV111543;
        Tue, 31 May 2022 06:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1653996699;
        bh=M04/NP7b5yhylY6mvfYkzUaL6vrWBfJilWnfwx+nGTE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=S6r4LxuHiZ08RJ5hUQYy2+16fxgFaW93hFZL6S2tlthPdCkf2pRy15vziqr5XutsM
         KUNzzytha0SSxKMzkD10Q7K7jXzLfjna6rt8K+GJzCxti6kGS4YI9L/L9PA2W2e+H8
         sitPB0EPQFTdvQb/t+IdMg5zsvYul+TdAhzSuPy8=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 24VBVdaE086843
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 31 May 2022 06:31:39 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 31
 May 2022 06:31:38 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 31 May 2022 06:31:39 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 24VBV92q064165;
        Tue, 31 May 2022 06:31:33 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH 2/3] net: ethernet: ti: am65-cpsw: Add support for QSGMII mode
Date:   Tue, 31 May 2022 17:00:57 +0530
Message-ID: <20220531113058.23708-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531113058.23708-1-s-vadapalli@ti.com>
References: <20220531113058.23708-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable QSGMII mode in am65-cpsw driver.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 13 ++++++++++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 77bdda97b2b0..462f63313fb3 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -74,6 +74,9 @@
 #define AM65_CPSW_PORTN_REG_TS_VLAN_LTYPE_REG	0x318
 #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
 
+#define AM65_CPSW_SGMII_CONTROL_REG		0x010
+#define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)
+
 #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
 #define AM65_CPSW_CTL_P0_ENABLE			BIT(2)
 #define AM65_CPSW_CTL_P0_TX_CRC_REMOVE		BIT(13)
@@ -1409,7 +1412,13 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
 				      const struct phylink_link_state *state)
 {
-	/* Currently not used */
+	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
+							  phylink_config);
+	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
+
+	if (state->interface == PHY_INTERFACE_MODE_QSGMII)
+		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
+		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
 }
 
 static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned int mode,
@@ -1846,6 +1855,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		port->common = common;
 		port->port_base = common->cpsw_base + AM65_CPSW_NU_PORTS_BASE +
 				  AM65_CPSW_NU_PORTS_OFFSET * (port_id);
+		port->sgmii_base = common->ss_base + AM65_CPSW_SGMII_BASE * (port_id);
 		port->stat_base = common->cpsw_base + AM65_CPSW_NU_STATS_BASE +
 				  (AM65_CPSW_NU_STATS_PORT_OFFSET * port_id);
 		port->name = of_get_property(port_np, "label", NULL);
@@ -1981,6 +1991,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD;
 
 	phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_QSGMII, port->slave.phylink_config.supported_interfaces);
 
 	phylink = phylink_create(&port->slave.phylink_config,
 				 of_node_to_fwnode(port->slave.phy_node),
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index ac945631bf2f..8b6297e268ec 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -46,6 +46,7 @@ struct am65_cpsw_port {
 	const char			*name;
 	u32				port_id;
 	void __iomem			*port_base;
+	void __iomem			*sgmii_base;
 	void __iomem			*stat_base;
 	void __iomem			*fetch_ram_base;
 	bool				disabled;
-- 
2.36.1

