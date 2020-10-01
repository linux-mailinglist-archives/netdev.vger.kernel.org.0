Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C9F27FDC2
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732185AbgJAKxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:53:23 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43052 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAKxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:53:12 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 091Ar9Lr064209;
        Thu, 1 Oct 2020 05:53:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601549589;
        bh=zgrtzCIGRkZUluOTCMrRQjI65dX6+rZ7sdyXkY6/+MM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=zBtgAxmAJLf7Gl67FeznLPemuCtw1D2PpI6R6iblIX+UftzdR3AC0frm5d6zvrTL1
         uotj11Y9/vn1IQHIJ9Pzb27Y39DC59KfN7t7mSuJHr9UUczgDeLEaM+fWjTebz04vk
         4hbwbho7XtlyDpAmPoFPdnk3tJ13KC5UfvJ37I6I=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 091Ar9Y0074174
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 1 Oct 2020 05:53:09 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 1 Oct
 2020 05:53:09 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 1 Oct 2020 05:53:08 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 091Ar7W6073934;
        Thu, 1 Oct 2020 05:53:08 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 1/8] net: ethernet: ti: am65-cpsw: move ale selection in pdata
Date:   Thu, 1 Oct 2020 13:52:51 +0300
Message-ID: <20201001105258.2139-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001105258.2139-1-grygorii.strashko@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of adding more multi-port K3 CPSW versions move ALE
selection in am65_cpsw_pdata, so it can be selected basing on DT
compatibility property.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 4 +++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 501d676fd88b..0ee1c7a5c90f 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2005,10 +2005,12 @@ static const struct soc_device_attribute am65_cpsw_socinfo[] = {
 
 static const struct am65_cpsw_pdata am65x_sr1_0 = {
 	.quirks = AM65_CPSW_QUIRK_I2027_NO_TX_CSUM,
+	.ale_dev_id = "am65x-cpsw2g",
 };
 
 static const struct am65_cpsw_pdata j721e_pdata = {
 	.quirks = 0,
+	.ale_dev_id = "am65x-cpsw2g",
 };
 
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
@@ -2145,7 +2147,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	ale_params.ale_ageout = AM65_CPSW_ALE_AGEOUT_DEFAULT;
 	ale_params.ale_ports = common->port_num + 1;
 	ale_params.ale_regs = common->cpsw_base + AM65_CPSW_NU_ALE_BASE;
-	ale_params.dev_id = "am65x-cpsw2g";
+	ale_params.dev_id = common->pdata.ale_dev_id;
 	ale_params.bus_freq = common->bus_freq;
 
 	common->ale = cpsw_ale_create(&ale_params);
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 993e1d4d3222..9c2186b8eae9 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -77,6 +77,7 @@ struct am65_cpsw_rx_chn {
 
 struct am65_cpsw_pdata {
 	u32	quirks;
+	const char	*ale_dev_id;
 };
 
 struct am65_cpsw_common {
-- 
2.17.1

