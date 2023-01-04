Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E2765D0BB
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 11:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbjADKfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 05:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbjADKfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 05:35:11 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC151EC76;
        Wed,  4 Jan 2023 02:35:08 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 304AYmpD043673;
        Wed, 4 Jan 2023 04:34:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1672828488;
        bh=fcQA3jf+9LM186CWUyIFjsIFtnpAFJ3ZuglIHaQd0CU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Jus6x7oK6aTebhhnLyNrIsjIptfo3m89IEJ2uPR5tSK8MpdpY5jRYt/ZD8ASGSjAL
         Rvq8+BA3liKrbMDiXDkxOv6OeugNSWgjwH5LwMO3hpx5yt0IX3549UoM+qfENx5M4X
         x1WW4sj+e0sy38b2p6jUQ8pJ+UGzZzoK0H5aMXH4=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 304AYm8n121127
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Jan 2023 04:34:48 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 4
 Jan 2023 04:34:48 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 4 Jan 2023 04:34:48 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 304AYWFY018054;
        Wed, 4 Jan 2023 04:34:43 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v6 2/3] net: ethernet: ti: am65-cpsw: Enable QSGMII mode for J721e CPSW9G
Date:   Wed, 4 Jan 2023 16:04:31 +0530
Message-ID: <20230104103432.1126403-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230104103432.1126403-1-s-vadapalli@ti.com>
References: <20230104103432.1126403-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 9decb0c7961b..06912363d5d5 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2684,11 +2684,19 @@ static const struct am65_cpsw_pdata j7200_cpswxg_pdata = {
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

