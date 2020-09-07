Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D12125FF1F
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbgIGQ2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:28:11 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53912 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729903AbgIGOcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:32:53 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 087EVscW015797;
        Mon, 7 Sep 2020 09:31:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599489114;
        bh=aLrHDDzUSZnntyTRNgcA+XJgDx0ERfOCTms6pbod928=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=cfSJxA9VjX4kNisNtiVKVK+pk90QaKvWgn7TSxMQez5jnc4FjuosIJ+1cOsjOnLiy
         u9l/ZoWC2txxI6km0lvAusOAyVTF6D044z9Qvh/mHD+kPiFHk6tfDonSC2XKZbTKfD
         U+H+FRiQABu2waEUBxXbZgxdRNCBeVJUMptaMF3w=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 087EVsxL066835
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 7 Sep 2020 09:31:54 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Sep
 2020 09:31:54 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 7 Sep 2020 09:31:54 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EVrdR106465;
        Mon, 7 Sep 2020 09:31:54 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 5/9] net: ethernet: ti: am65-cpsw: use dev_id for ale configuration
Date:   Mon, 7 Sep 2020 17:31:39 +0300
Message-ID: <20200907143143.13735-6-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200907143143.13735-1-grygorii.strashko@ti.com>
References: <20200907143143.13735-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch has introduced possibility to select CPSW ALE by using
ALE dev_id identifier. Switch TI TI AM65x/J721E CPSW NUSS driver to use
dev_id.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 9baf3f3da91e..bec47e794359 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2131,10 +2131,9 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	/* init common data */
 	ale_params.dev = dev;
 	ale_params.ale_ageout = AM65_CPSW_ALE_AGEOUT_DEFAULT;
-	ale_params.ale_entries = 0;
 	ale_params.ale_ports = common->port_num + 1;
 	ale_params.ale_regs = common->cpsw_base + AM65_CPSW_NU_ALE_BASE;
-	ale_params.nu_switch_ale = true;
+	ale_params.dev_id = "am65x-cpsw2g";
 
 	common->ale = cpsw_ale_create(&ale_params);
 	if (IS_ERR(common->ale)) {
-- 
2.17.1

