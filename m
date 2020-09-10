Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E760B26512B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgIJUpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:45:44 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:52872 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgIJU2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:28:42 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08AKSbpF057713;
        Thu, 10 Sep 2020 15:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599769717;
        bh=aLrHDDzUSZnntyTRNgcA+XJgDx0ERfOCTms6pbod928=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=uPtksaCucms+eERJ5uWSYAsys6oz32h4Y+xnu5hg7p2YzxvDL+GdEUy9YS8+B5m3M
         jpEPMCTVbRABBStO/A9NeemiHYZw+Jc8RaW2Z45DKf7lFaPmAASs45s1724k7MXK+A
         ETG5ajKFLqaZ5hpcocZu8/1iAynF//P1BhuL7WXE=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08AKSarM041540
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 15:28:36 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 10
 Sep 2020 15:28:36 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 10 Sep 2020 15:28:36 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AKSZVY066204;
        Thu, 10 Sep 2020 15:28:36 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 5/9] net: ethernet: ti: am65-cpsw: use dev_id for ale configuration
Date:   Thu, 10 Sep 2020 23:28:03 +0300
Message-ID: <20200910202807.17473-6-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910202807.17473-1-grygorii.strashko@ti.com>
References: <20200910202807.17473-1-grygorii.strashko@ti.com>
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

