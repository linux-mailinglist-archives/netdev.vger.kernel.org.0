Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D465C0064
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 09:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfI0Htq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 03:49:46 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:34688 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726628AbfI0HtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 03:49:12 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DAF8CC0DD4;
        Fri, 27 Sep 2019 07:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569570552; bh=4HYL1pfc0TYPaJ4P5PLnhQ03OR2L/vm8sjEKLBLrB04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Nm9BvF+icBU96Z9GmayCx5H+4tYOScnKTia+xJGfTgqb8HLEdkR2JvoTKFQjNGuSW
         aBcDVaMY1c1YSGRI8ceV+bBmpzH9WwXostxGgS44X7hXVcjvYDXa4RZ4rr8HfkKw+X
         2GJJiGLs5Q1vJtypdTnnEKMr2LQz5gyN77M0/ArrfpuH4QdVzOWWsSxyJWnhts82WO
         0Z5m8I6LEqXmLIWResNEQL4+zdp4wtkuXcIfYUMJ7fI1d21tmn7B0TL7xJmj/rXL1K
         I0Sp4NWeB4kBbvs8qNuVajVFuefa35f5lsRJeJjnbnYutNu+BVy++jectQg1COYhX+
         yctlxiqe5Ufvg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 579C3A0078;
        Fri, 27 Sep 2019 07:49:09 +0000 (UTC)
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
Subject: [PATCH net 3/8] net: stmmac: selftests: Always use max DMA size in Jumbo Test
Date:   Fri, 27 Sep 2019 09:48:51 +0200
Message-Id: <aafbe5bbc45dae9fcfb49b0a803581c5f24328e5.1569569778.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1569569778.git.Jose.Abreu@synopsys.com>
References: <cover.1569569778.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1569569778.git.Jose.Abreu@synopsys.com>
References: <cover.1569569778.git.Jose.Abreu@synopsys.com>
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

