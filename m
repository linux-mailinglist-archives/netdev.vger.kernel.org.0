Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE066C3038
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjCULUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCULUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:20:43 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5359A2311A;
        Tue, 21 Mar 2023 04:20:25 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32LBKDmr127878;
        Tue, 21 Mar 2023 06:20:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679397613;
        bh=kDVAWvXcw2wihjPIxBJny9weUv0d1raHHwD5Q+RAKQM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=cnP93vNjg0GKmgKMjDC3ywFoZCaU9HoyZ6yGg99OJdO6uarLh7rir6Ce7ZQK2J4QR
         cy5m5ukSRfVYroEqDXJtmz0tN1d+cB1hOdZmuCRbSWYfNo1WsWK7oyt+aWUNgLi4Ng
         9N7SCsWx92RcHm5ncYZjw7J7lAP2qZbrqEIaNGCo=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32LBKD8s008411
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Mar 2023 06:20:13 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 21
 Mar 2023 06:20:12 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 21 Mar 2023 06:20:12 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32LBJxVp088542;
        Tue, 21 Mar 2023 06:20:10 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 3/4] net: ethernet: ti: am65-cpsw: Enable SGMII mode for J7200
Date:   Tue, 21 Mar 2023 16:49:57 +0530
Message-ID: <20230321111958.2800005-4-s-vadapalli@ti.com>
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

TI's J7200 SoC supports SGMII mode with the CPSW5G instance of the CPSW
Ethernet Switch. Thus, enable it by adding SGMII mode to the extra_modes
member of the "j7200_cpswxg_pdata" SoC data.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index d2ca1f2035f4..66e1fe58b895 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2777,7 +2777,7 @@ static const struct am65_cpsw_pdata j7200_cpswxg_pdata = {
 	.quirks = 0,
 	.ale_dev_id = "am64-cpswxg",
 	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
-	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
+	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII) | BIT(PHY_INTERFACE_MODE_SGMII),
 };
 
 static const struct am65_cpsw_pdata j721e_cpswxg_pdata = {
-- 
2.25.1

