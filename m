Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88C4C1CDC
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbfI3IT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:19:28 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:33648 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729981AbfI3IT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:19:26 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4F6A0C039E;
        Mon, 30 Sep 2019 08:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569831565; bh=4HYL1pfc0TYPaJ4P5PLnhQ03OR2L/vm8sjEKLBLrB04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=bNw/FJ/vHkcRwIVtTgEUlkmi0fBavp4BMzbNHh72Z52WCNNvala978hXNqUSS3Qxz
         Rutb+NWjSbG7Gpmg9W8kThueQ2CM/dSYZvtqFJT1uJeDnnT3ewn1ptvhhfWRr658co
         A/eG5RVfO/0hb8DOJrhuMuObiM7tmyvlE0fl0ZjgA96P12iBV/osMJ9mvQXMbusLDo
         yDXcNjXhj7XH1PCF9Ltjugp5zMlBT5qF4A4OUiUCQEPQX/k2+/1NzXzDs3IJUTHjPo
         WvbGinYAvPrPJphhVt3UzSQCCUUY4dK7sRGUzctJH44B6x+TxvJQdmCIzD1ESuj+1+
         Cik5m0WldyTiw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 642B1A0066;
        Mon, 30 Sep 2019 08:19:23 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 3/9] net: stmmac: selftests: Always use max DMA size in Jumbo Test
Date:   Mon, 30 Sep 2019 10:19:07 +0200
Message-Id: <66876680549fe86f71bc61a1b8961d68f6e54442.1569831229.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although some XGMAC setups support frames larger than DMA size, some of
them may not. As we can't know before-hand which ones support let's use
the maximum DMA buffer size in the Jumbo Tests.

User can always reconfigure the MTU to achieve larger frames.

Fixes: 427849e8c37f ("net: stmmac: selftests: Add Jumbo Frame tests")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 5f66f6161629..cc76a42c7466 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1564,10 +1564,6 @@ static int __stmmac_test_jumbo(struct stmmac_priv *priv, u16 queue)
 	struct stmmac_packet_attrs attr = { };
 	int size = priv->dma_buf_sz;
 
-	/* Only XGMAC has SW support for multiple RX descs in same packet */
-	if (priv->plat->has_xgmac)
-		size = priv->dev->max_mtu;
-
 	attr.dst = priv->dev->dev_addr;
 	attr.max_size = size - ETH_FCS_LEN;
 	attr.queue_mapping = queue;
-- 
2.7.4

