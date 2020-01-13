Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5E4138CD9
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 09:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgAMI34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 03:29:56 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:54356 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728879AbgAMI34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 03:29:56 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A08D440692;
        Mon, 13 Jan 2020 08:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578904196; bh=Ben06d7t9W2BvCud3kGg7X4OfXW/BtwnEBLz0+lX38c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=DzjEKWVEjc5TkB7btFpWwzZuBnS1ivO72dE+YqSFRLVvBHEtr0Fl38WhJ3JG7CI6K
         q5+YN7cXCZ4lWYGQG+xLUr5ADris9bTV3hRxhfH1mGdukcbAq8T523SK5Two/gjtrv
         PAQ3sSKWWCisXTpjDGA6suVvlUOLi8poCa+ylk8jQS3962dyXQfVHMTAvsTzD4pt4O
         00LNYmEzUv1HunaNGUFK44Jx6A20MnMIyb/khCkIpFudg0cic/9Z8K6HLSxryJRL+p
         oFxHupN++nOfEs3wjN4i5K6L1n3b9zlmz9+OvaWxnYFiXfz3Mimz5Wc27GEEQKIeQT
         dvVatQdPNxD7A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 63D40A0077;
        Mon, 13 Jan 2020 08:29:54 +0000 (UTC)
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
Subject: [PATCH net-next 5/6] net: stmmac: pci: Enable TBS on GMAC5 IPK PCI entry
Date:   Mon, 13 Jan 2020 09:29:39 +0100
Message-Id: <2ab70398e404244933f9feac1be0795aff871730.1578903874.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578903874.git.Jose.Abreu@synopsys.com>
References: <cover.1578903874.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578903874.git.Jose.Abreu@synopsys.com>
References: <cover.1578903874.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable TBS support on GMAC5 PCI entry for all Queues except Queue 0.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 40f171d310d7..623521052152 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -401,6 +401,8 @@ static int snps_gmac5_default_data(struct pci_dev *pdev,
 		plat->tx_queues_cfg[i].use_prio = false;
 		plat->tx_queues_cfg[i].mode_to_use = MTL_QUEUE_DCB;
 		plat->tx_queues_cfg[i].weight = 25;
+		if (i > 0)
+			plat->tx_queues_cfg[i].tbs_en = 1;
 	}
 
 	plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
-- 
2.7.4

