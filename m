Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC09AF76B7
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfKKOnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:43:01 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:55154 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726973AbfKKOnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:43:00 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6E02EC08B8;
        Mon, 11 Nov 2019 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573483379; bh=scoltA+WigVvTzqdJe03QvtfADm3p97oUkWlWeL7UFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=eZzmHFxmbImhW0FoFa8LLlSvauoyC9st1qU6FgqrlEjRz1Ls3tYuKqZrGXHnKi8cc
         CjvWmsGScCrs+U9vwSC4yqi3AL4U4a2pM6XQ/q/aduRyKNyIoxa81aWfBiKjSwsnRQ
         Npfi0Z6OZswdsN9i3AG5DBnNGa4t2W5gZgw7kTBeKngpC8644r5bjYNgv4hoWLHe4a
         Blb3NaxgykQlvAGraEY3v84auAjvGgcoaEahJ4A7Mn/7qKckzTn5lJpGQF2D6jqsL7
         1wX5yjUnu+afVGYCKQBcS/Wz/4gXFKswaMJIZNCwOo7ZzZ9bp80ezNXJ7ukYuGEZ9P
         w79TNoCn14f0A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 14128A0251;
        Mon, 11 Nov 2019 14:42:57 +0000 (UTC)
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
Subject: [PATCH net-next 4/6] net: stmmac: tc: Remove the speed dependency
Date:   Mon, 11 Nov 2019 15:42:37 +0100
Message-Id: <9186dd18e5210a51d4fc7aad5c78b49486e18bfe.1573482991.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XGMAC3 supports full CBS features with speeds that can go up to 10G so
we can now remove the maximum speed check of CBS.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index f9a9a9d82233..7d972e0fd2b0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -321,8 +321,6 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 		return -EINVAL;
 	if (!priv->dma_cap.av)
 		return -EOPNOTSUPP;
-	if (priv->speed != SPEED_100 && priv->speed != SPEED_1000)
-		return -EOPNOTSUPP;
 
 	mode_to_use = priv->plat->tx_queues_cfg[queue].mode_to_use;
 	if (mode_to_use == MTL_QUEUE_DCB && qopt->enable) {
-- 
2.7.4

