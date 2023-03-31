Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F816D17D1
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjCaGvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjCaGvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:51:39 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD514EE0;
        Thu, 30 Mar 2023 23:51:36 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32V6pLv8080888;
        Fri, 31 Mar 2023 01:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680245481;
        bh=6njTvXEnxXoEV5wcZpCdsrSx9gXmNsXV7RWSU6VOBKw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=q/JJdS37jKVDO5FU2QPtH/f7c1mSLFWaEaLfgrIjoxUvYaLHRNa/4+jA4k+f3r2QL
         7EeaH3rhPXCTlTAirhbQQTQXNCMXwDFd+mcFeheaSSlay1ayG8F6o2rmwlM09Qp6pB
         EeTpvcgqyiY5Ju8nG4ekc33B+mf4QtheC/9R1FhM=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32V6pLQp049860
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Mar 2023 01:51:21 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 31
 Mar 2023 01:51:20 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 31 Mar 2023 01:51:20 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32V6pAmS017251;
        Fri, 31 Mar 2023 01:51:17 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 2/2] net: ethernet: ti: am65-cpsw: Enable USXGMII mode for J784S4 CPSW9G
Date:   Fri, 31 Mar 2023 12:21:10 +0530
Message-ID: <20230331065110.604516-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230331065110.604516-1-s-vadapalli@ti.com>
References: <20230331065110.604516-1-s-vadapalli@ti.com>
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
extra_modes member of the J784S4 SoC data. Additionally, configure the
MAC Control register for supporting USXGMII mode. Also, for USXGMII
mode, include MAC_5000FD in the "mac_capabilities" member of struct
"phylink_config".

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4b4d06199b45..ab33e6fe5b1a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1555,6 +1555,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 		mac_control |= CPSW_SL_CTL_GIG;
 	if (interface == PHY_INTERFACE_MODE_SGMII)
 		mac_control |= CPSW_SL_CTL_EXT_EN;
+	if (interface == PHY_INTERFACE_MODE_USXGMII)
+		mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
 	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
 		/* Can be used with in band mode only */
 		mac_control |= CPSW_SL_CTL_EXT_EN;
@@ -2175,6 +2177,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 
 	case PHY_INTERFACE_MODE_QSGMII:
 	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_USXGMII:
 		if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
 			__set_bit(port->slave.phy_if,
 				  port->slave.phylink_config.supported_interfaces);
@@ -2182,6 +2185,9 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 			dev_err(dev, "selected phy-mode is not supported\n");
 			return -EOPNOTSUPP;
 		}
+		/* For USXGMII mode, enable MAC_5000FD */
+		if (port->slave.phy_if == PHY_INTERFACE_MODE_USXGMII)
+			port->slave.phylink_config.mac_capabilities |= MAC_5000FD;
 		break;
 
 	default:
@@ -2800,7 +2806,7 @@ static const struct am65_cpsw_pdata j784s4_cpswxg_pdata = {
 	.quirks = 0,
 	.ale_dev_id = "am64-cpswxg",
 	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
-	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
+	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII) | BIT(PHY_INTERFACE_MODE_USXGMII),
 };
 
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
-- 
2.25.1

