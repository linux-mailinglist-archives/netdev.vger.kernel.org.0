Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80CC60DDC8
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 11:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbiJZJKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 05:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiJZJKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 05:10:40 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1130F3FA1C;
        Wed, 26 Oct 2022 02:10:34 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 29Q9ADhr005853;
        Wed, 26 Oct 2022 04:10:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1666775413;
        bh=YWx1XDLf8Fl9cqZIj0Gsk1/WG+6R5ZNcITJYTKSR0nQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=KPPW/kDDhmCzUjIy9DLAsb+OOi5VFfVOp4h1/Ron2VGvLZh7IimbbXhU9eSrZphVm
         Vmc8NTwfTmMeC7DXruqtdifM9XP6egvsXFOlbCvYEzWzRlqPAiTBr99FR7iinKM1la
         1I0c/iM4ZUW13r0/1ElgfJCtYSLrxOWLNYhxgYtE=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 29Q9AD3w125136
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Oct 2022 04:10:13 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 26
 Oct 2022 04:10:12 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 26 Oct 2022 04:10:12 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 29Q99wxr005870;
        Wed, 26 Oct 2022 04:10:08 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <s-vadapalli@ti.com>
Subject: [PATCH v3 2/3] net: ethernet: ti: am65-cpsw: Enable QSGMII mode for J721e CPSW9G
Date:   Wed, 26 Oct 2022 14:39:56 +0530
Message-ID: <20221026090957.180592-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026090957.180592-1-s-vadapalli@ti.com>
References: <20221026090957.180592-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPSW9G in J721e supports additional modes like QSGMII.
Add new compatible for J721e in am65-cpsw driver.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 7f86068f3ff6..91e294afc3ad 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2642,11 +2642,19 @@ static const struct am65_cpsw_pdata j7200_cpswxg_pdata = {
 	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
 };
 
+static const struct am65_cpsw_pdata j721e_cpswxg_pdata = {
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
+	{ .compatible = "ti,j721e-cpswxg-nuss", .data = &j721e_cpswxg_pdata},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, am65_cpsw_nuss_of_mtable);
-- 
2.25.1

