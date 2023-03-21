Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8E26C303B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjCULUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjCULUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:20:44 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1501F35EF6;
        Tue, 21 Mar 2023 04:20:26 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32LBKGgP127940;
        Tue, 21 Mar 2023 06:20:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679397616;
        bh=jBC27NVz62HEI0wnUjqxuZ4OIo0kJ6Ik6S5R7yCBZtE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=AbI0+0c34T2AnmZxOc/7rQEhmpzlYTNcZCfQZJRkSzZqrtoW7DPjy8zBP/61VZUmY
         PVBHPaVBZdGcg/4tT+N1vfxkoAFBahOAZpxyi9wy9oIFp7Vdx9AoWppTLwLePYaWvM
         hYW0meeEfRRPhw7XwkHhKL/NbyCBdJq3jbHILkrI=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32LBKG0g016957
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Mar 2023 06:20:16 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 21
 Mar 2023 06:20:16 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 21 Mar 2023 06:20:16 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32LBJxVq088542;
        Tue, 21 Mar 2023 06:20:13 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 4/4] net: ethernet: ti: am65-cpsw: Enable SGMII mode for J721E
Date:   Tue, 21 Mar 2023 16:49:58 +0530
Message-ID: <20230321111958.2800005-5-s-vadapalli@ti.com>
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

TI's J721E SoC supports SGMII mode with the CPSW9G instance of the CPSW
Ethernet Switch. Thus, enable it by adding SGMII mode to the extra_modes
member of the "j721e_cpswxg_pdata" SoC data.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 66e1fe58b895..9ddb79776c88 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2784,7 +2784,7 @@ static const struct am65_cpsw_pdata j721e_cpswxg_pdata = {
 	.quirks = 0,
 	.ale_dev_id = "am64-cpswxg",
 	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
-	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
+	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII) | BIT(PHY_INTERFACE_MODE_SGMII),
 };
 
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
-- 
2.25.1

