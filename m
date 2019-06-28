Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580B9594DD
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfF1H30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:29:26 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:48038 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726514AbfF1H30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:29:26 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 90B9FC0BE0;
        Fri, 28 Jun 2019 07:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561706965; bh=Iki79zGofNdgZ8gydLcTATbmq5GAswHgqaJEbRwJaXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=VvxLEriOS+YLUJGdGQYQxKTVFpwb5qHIxlF9TXMRxBxD3H4pREpPX3vzNNqYg7/j1
         13HYwGJjIK2v5SiawgKvyJ7m4sO9wjwBTkQtAn0MZP6nODT94boYlJi0Ha1ianN9PE
         lTRcHchPsfqRWgPyRypPul+DSFC0MO2Wvor3fu1EhXT44LBSh4NKD7l6OCBmUtfuFw
         xqHmy/NAAzEVuH9deap0ui45gJvlseHcyNz4J5HK63V1foC8nUK/TYSIMQxRNVyQPq
         leOGeczw+9jHlkVdSA8wdQTCmrWw16QpJ8VU2CtFGDEXlz+j8PIZ122jQ6fjFifSxr
         Qbt+IadQdiMRA==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id B8EC3A0062;
        Fri, 28 Jun 2019 07:29:23 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 75AC23E94F;
        Fri, 28 Jun 2019 09:29:23 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 03/10] net: stmmac: Decrease default RX Watchdog value
Date:   Fri, 28 Jun 2019 09:29:14 +0200
Message-Id: <b03961032062c8d04001ded5e1eb8da52c6ab6f1.1561706801.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For performance reasons decrease the default RX Watchdog value for the
minimum allowed.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index ad9e9368535d..14d8f6d7cb9a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -246,7 +246,7 @@ struct stmmac_safety_stats {
 
 /* Max/Min RI Watchdog Timer count value */
 #define MAX_DMA_RIWT		0xff
-#define MIN_DMA_RIWT		0x20
+#define MIN_DMA_RIWT		0x10
 /* Tx coalesce parameters */
 #define STMMAC_COAL_TX_TIMER	1000
 #define STMMAC_MAX_COAL_TX_TICK	100000
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0b1900bf4e9e..40408a067400 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2516,9 +2516,9 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	priv->tx_lpi_timer = STMMAC_DEFAULT_TWT_LS;
 
 	if (priv->use_riwt) {
-		ret = stmmac_rx_watchdog(priv, priv->ioaddr, MAX_DMA_RIWT, rx_cnt);
+		ret = stmmac_rx_watchdog(priv, priv->ioaddr, MIN_DMA_RIWT, rx_cnt);
 		if (!ret)
-			priv->rx_riwt = MAX_DMA_RIWT;
+			priv->rx_riwt = MIN_DMA_RIWT;
 	}
 
 	if (priv->hw->pcs)
-- 
2.7.4

