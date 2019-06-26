Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC0456B23
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbfFZNs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:48:28 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:51146 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727872AbfFZNry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:47:54 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B430CC0C40;
        Wed, 26 Jun 2019 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561556874; bh=H2kiYnYGHwJPiP9Y0nLRQqjcyaPDBfP9rf52uCVBhRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=GYHi4t0s4Pv4OdtDYgTlf6tfhH/2/XLUNEH3z1G2wNwFyMBaZjZMbEtnrZf3YULHk
         PDGmt1L9t836g/d3PuhwckHFQSGCpVrqRv0rHNS2eifaoPBfvMw++Q/YOdWcHvrcg9
         2zgS+wDVHH2tF9fMdA2+IK/1zan10WZB6rB8gOFrgAGLry6OiQ3F7pSPx4zu2b4iSC
         49xWY9b9SxffJ9osq9NcOgN1hocKFlvdatIsylSTzXd/XMlh01jbft063aPJ2i4OCh
         HRtlgtX+xwzzpskQdQppMrQq94OXPAe52JLJu1hMqemz/eCdSlbuCbioANoxDYGY2F
         KxE8sdGU2l5bg==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id E7176A005F;
        Wed, 26 Jun 2019 13:47:51 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id C9AE93B561;
        Wed, 26 Jun 2019 15:47:51 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 03/10] net: stmmac: Decrease default RX Watchdog value
Date:   Wed, 26 Jun 2019 15:47:37 +0200
Message-Id: <30dc1c3732ff94aa2e77bac89250ee83f2144eea.1561556555.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
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
index fab65f129207..dc57a2c0a630 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2512,9 +2512,9 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
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

