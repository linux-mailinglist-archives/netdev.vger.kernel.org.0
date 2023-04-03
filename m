Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D356D42C9
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjDCLBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjDCLBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:01:32 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548FE113EA;
        Mon,  3 Apr 2023 04:01:30 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 333B1Hs5074100;
        Mon, 3 Apr 2023 06:01:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680519677;
        bh=k9V1lSwbZhwxw2ZyRU7l9HZE28rX40IS6pfm2TGDZJk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Byz0OkTzY08vvUKJ7fI/lHxUdXVv4oVF4RSI0mlcwpN8dUJlmq1WhVJvqvZti5SsL
         XsZiAsxLUmiIyL79eyrykLY/2DqPlTK9rb1ONs3m0PILuzJqa9R4yj3PG9ayFx2Xxj
         dplhOVxhjk0ibHfYfBU8loe3aA0DfOZsj9s0QyqE=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 333B1HvM069561
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 06:01:17 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 06:01:16 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 06:01:16 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 333B17wq101591;
        Mon, 3 Apr 2023 06:01:14 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v2 2/3] net: ethernet: ti: am65-cpsw: Enable QSGMII for J784S4 CPSW9G
Date:   Mon, 3 Apr 2023 16:31:05 +0530
Message-ID: <20230403110106.983994-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230403110106.983994-1-s-vadapalli@ti.com>
References: <20230403110106.983994-1-s-vadapalli@ti.com>
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

TI's J784S4 SoC supports QSGMII mode with the CPSW9G instance of the
CPSW Ethernet Switch. Add a new compatible for J784S4 SoC and enable
QSGMII support for it by adding QSGMII mode to the extra_modes member of
the "j784s4_cpswxg_pdata" SoC data.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 74e099828978..6c118a9abb2f 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2800,12 +2800,20 @@ static const struct am65_cpsw_pdata j721e_cpswxg_pdata = {
 	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII) | BIT(PHY_INTERFACE_MODE_SGMII),
 };
 
+static const struct am65_cpsw_pdata j784s4_cpswxg_pdata = {
+	.quirks = 0,
+	.ale_dev_id = "am64-cpswxg",
+	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
+	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
+};
+
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
 	{ .compatible = "ti,am654-cpsw-nuss", .data = &am65x_sr1_0},
 	{ .compatible = "ti,j721e-cpsw-nuss", .data = &j721e_pdata},
 	{ .compatible = "ti,am642-cpsw-nuss", .data = &am64x_cpswxg_pdata},
 	{ .compatible = "ti,j7200-cpswxg-nuss", .data = &j7200_cpswxg_pdata},
 	{ .compatible = "ti,j721e-cpswxg-nuss", .data = &j721e_cpswxg_pdata},
+	{ .compatible = "ti,j784s4-cpswxg-nuss", .data = &j784s4_cpswxg_pdata},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, am65_cpsw_nuss_of_mtable);
-- 
2.25.1

