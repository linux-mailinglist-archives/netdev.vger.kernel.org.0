Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2496511F01
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240263AbiD0Pov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbiD0Poo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:44:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A7BE0AC;
        Wed, 27 Apr 2022 08:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B097618F3;
        Wed, 27 Apr 2022 15:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBAAC385AF;
        Wed, 27 Apr 2022 15:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074083;
        bh=8awBbU0kDevZDPWjt3mx3CiKYVArRWf3BdXSHzS1gE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9p5Siha/7wtpTum4+7jVOyZsUGMhLmq0aXYIcs32aHb7rkrFNBwBLetzp9dRb4G7
         l++pFY4sBgb08gLumZ4bJ7+jaXlvEcl6pupEZ40be+gYbdn3H0+F6TkB6/RWTIuaY8
         /TH/I8G6fsKiRgqNM2N0lYnMeVwF/U+LaIFyKgmSTJXtEI/PDMTA8Kj1QxRkfFwSHd
         UEnrlsmzL6KO4lT9jtP3JscxCMaO2NFPT/t/u9lcQacP/sWVAhPmCPz6I7nwvpb4GI
         FqLG+gUXbGc++WDfpnycFlDUPamM7n11L4hgJHC71m4wWI0MyJGImbL0slz+KYS3K7
         C3hg0b6hSSQkw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        grygorii.strashko@ti.com, chi.minghao@zte.com.cn,
        vladimir.oltean@nxp.com, toke@redhat.com, chenhao288@hisilicon.com,
        moyufeng@huawei.com, linux-omap@vger.kernel.org
Subject: [PATCH net-next 03/14] eth: cpsw: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Wed, 27 Apr 2022 08:41:00 -0700
Message-Id: <20220427154111.529975-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220427154111.529975-1-kuba@kernel.org>
References: <20220427154111.529975-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defining local versions of NAPI_POLL_WEIGHT with the same
values in the drivers just makes refactoring harder.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: grygorii.strashko@ti.com
CC: chi.minghao@zte.com.cn
CC: vladimir.oltean@nxp.com
CC: toke@redhat.com
CC: chenhao288@hisilicon.com
CC: moyufeng@huawei.com
CC: linux-omap@vger.kernel.org
---
 drivers/net/ethernet/ti/cpsw.c      |  4 ++--
 drivers/net/ethernet/ti/cpsw_new.c  |  4 ++--
 drivers/net/ethernet/ti/cpsw_priv.c | 12 ++++++------
 drivers/net/ethernet/ti/cpsw_priv.h |  1 -
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index e6ad2e53f1cd..662435e36805 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1639,10 +1639,10 @@ static int cpsw_probe(struct platform_device *pdev)
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
 	netif_napi_add(ndev, &cpsw->napi_rx,
 		       cpsw->quirk_irq ? cpsw_rx_poll : cpsw_rx_mq_poll,
-		       CPSW_POLL_WEIGHT);
+		       NAPI_POLL_WEIGHT);
 	netif_tx_napi_add(ndev, &cpsw->napi_tx,
 			  cpsw->quirk_irq ? cpsw_tx_poll : cpsw_tx_mq_poll,
-			  CPSW_POLL_WEIGHT);
+			  NAPI_POLL_WEIGHT);
 
 	/* register the network device */
 	SET_NETDEV_DEV(ndev, dev);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 0f31cb4168bb..b33781ed760e 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1416,11 +1416,11 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 			netif_napi_add(ndev, &cpsw->napi_rx,
 				       cpsw->quirk_irq ?
 				       cpsw_rx_poll : cpsw_rx_mq_poll,
-				       CPSW_POLL_WEIGHT);
+				       NAPI_POLL_WEIGHT);
 			netif_tx_napi_add(ndev, &cpsw->napi_tx,
 					  cpsw->quirk_irq ?
 					  cpsw_tx_poll : cpsw_tx_mq_poll,
-					  CPSW_POLL_WEIGHT);
+					  NAPI_POLL_WEIGHT);
 		}
 
 		napi_ndev = ndev;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 887285c57db8..758295c898ac 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -364,7 +364,7 @@ void cpsw_split_res(struct cpsw_common *cpsw)
 	if (cpsw->tx_ch_num == rlim_ch_num) {
 		max_rate = consumed_rate;
 	} else if (!rlim_ch_num) {
-		ch_budget = CPSW_POLL_WEIGHT / cpsw->tx_ch_num;
+		ch_budget = NAPI_POLL_WEIGHT / cpsw->tx_ch_num;
 		bigest_rate = 0;
 		max_rate = consumed_rate;
 	} else {
@@ -379,19 +379,19 @@ void cpsw_split_res(struct cpsw_common *cpsw)
 		if (max_rate < consumed_rate)
 			max_rate *= 10;
 
-		ch_budget = (consumed_rate * CPSW_POLL_WEIGHT) / max_rate;
-		ch_budget = (CPSW_POLL_WEIGHT - ch_budget) /
+		ch_budget = (consumed_rate * NAPI_POLL_WEIGHT) / max_rate;
+		ch_budget = (NAPI_POLL_WEIGHT - ch_budget) /
 			    (cpsw->tx_ch_num - rlim_ch_num);
 		bigest_rate = (max_rate - consumed_rate) /
 			      (cpsw->tx_ch_num - rlim_ch_num);
 	}
 
 	/* split tx weight/budget */
-	budget = CPSW_POLL_WEIGHT;
+	budget = NAPI_POLL_WEIGHT;
 	for (i = 0; i < cpsw->tx_ch_num; i++) {
 		ch_rate = cpdma_chan_get_rate(txv[i].ch);
 		if (ch_rate) {
-			txv[i].budget = (ch_rate * CPSW_POLL_WEIGHT) / max_rate;
+			txv[i].budget = (ch_rate * NAPI_POLL_WEIGHT) / max_rate;
 			if (!txv[i].budget)
 				txv[i].budget++;
 			if (ch_rate > bigest_rate) {
@@ -417,7 +417,7 @@ void cpsw_split_res(struct cpsw_common *cpsw)
 		txv[bigest_rate_ch].budget += budget;
 
 	/* split rx budget */
-	budget = CPSW_POLL_WEIGHT;
+	budget = NAPI_POLL_WEIGHT;
 	ch_budget = budget / cpsw->rx_ch_num;
 	for (i = 0; i < cpsw->rx_ch_num; i++) {
 		cpsw->rxv[i].budget = ch_budget;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index fc591f5ebe18..34230145ca0b 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -89,7 +89,6 @@ do {								\
 #define CPDMA_TXCP		0x40
 #define CPDMA_RXCP		0x60
 
-#define CPSW_POLL_WEIGHT	64
 #define CPSW_RX_VLAN_ENCAP_HDR_SIZE		4
 #define CPSW_MIN_PACKET_SIZE_VLAN	(VLAN_ETH_ZLEN)
 #define CPSW_MIN_PACKET_SIZE	(ETH_ZLEN)
-- 
2.34.1

