Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A706620B7EE
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgFZSRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:17:32 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:59798 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgFZSRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:17:30 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHEtQ115231;
        Fri, 26 Jun 2020 13:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593195434;
        bh=PSrVH9Vy0CJwlnXdecSsLB4MTfyMn7rqBfKHS4xMWEQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=MP5q6HVlfEWMWDTxgnPZBFc+ZU0ONGVhQAfH9uV4BxwCnzOSsFtjxF3YE7inZ8S86
         n3F7BoSdOy8SXm2IaLbIZzTpdEz64KiRV5HSb7+6B7hDkohys0VOTuIWG15r2vK0im
         3GswGXEtdLseMR5as4tb4WvEwa3vE0nf5O5oygqg=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHEO2004129;
        Fri, 26 Jun 2020 13:17:14 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 26
 Jun 2020 13:17:14 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 26 Jun 2020 13:17:14 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHDXV122772;
        Fri, 26 Jun 2020 13:17:13 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 2/6] net: ethernet: ti: am65-cpsw: move to pf_p0_rx_ptype_rrobin init in probe
Date:   Fri, 26 Jun 2020 21:17:05 +0300
Message-ID: <20200626181709.22635-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626181709.22635-1-grygorii.strashko@ti.com>
References: <20200626181709.22635-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pf_p0_rx_ptype_rrobin is global parameter so move its initialization in
probe.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 82d3b1f20890..89ea29a26c3a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1894,8 +1894,6 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 	netif_napi_add(port->ndev, &common->napi_rx,
 		       am65_cpsw_nuss_rx_poll, NAPI_POLL_WEIGHT);
 
-	common->pf_p0_rx_ptype_rrobin = false;
-
 	return ret;
 }
 
@@ -2038,6 +2036,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	common->rx_flow_id_base = -1;
 	init_completion(&common->tdown_complete);
 	common->tx_ch_num = 1;
+	common->pf_p0_rx_ptype_rrobin = false;
 
 	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(48));
 	if (ret) {
-- 
2.17.1

