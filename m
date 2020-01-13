Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB211391B0
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgAMNCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:02:53 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:56760 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbgAMNCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:02:53 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A67C8C05CC;
        Mon, 13 Jan 2020 13:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578920572; bh=Ben06d7t9W2BvCud3kGg7X4OfXW/BtwnEBLz0+lX38c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=gTS81Hli2yTwMbs6NcfqUORcIq2q6Z96PjA5tjQCtvoIV3pqp89Sfdl3Il1Eoxjt1
         ccQyfH4lSFKVOylsuAH9cPUFeO2vjJHu32V6DzDWe9uUX2zhFBiuBgHd72XwSTqmMr
         EX1j0Eygwjx4fU8/yNk9wkPEpeMcAoSG9OVh8H3fbgsHJZ/T7+Qqqi7rFi4jArMIKW
         0GD6Gi83y1+WGmWUdXdBIDqhLTO2TV5I6YwEfVi4d7AXuUJF+1AfIi81R0JllkCfdl
         lWRzWKY666wfR+zsXDElTcu20cyuBxODfn+wjK6RGmPfpaN6eg7gEeALxi3nO/GMyl
         vbn7/dc4Kjxwg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 617E7A006F;
        Mon, 13 Jan 2020 13:02:50 +0000 (UTC)
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
Subject: [PATCH net-next v2 5/8] net: stmmac: pci: Enable TBS on GMAC5 IPK PCI entry
Date:   Mon, 13 Jan 2020 14:02:40 +0100
Message-Id: <89c71da18546c396463f286d518d57054b7b6de9.1578920366.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578920366.git.Jose.Abreu@synopsys.com>
References: <cover.1578920366.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578920366.git.Jose.Abreu@synopsys.com>
References: <cover.1578920366.git.Jose.Abreu@synopsys.com>
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

