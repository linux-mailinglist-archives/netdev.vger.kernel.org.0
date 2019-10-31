Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F03EAE2A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfJaLBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:01:06 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59404 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727330AbfJaLBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:01:03 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6C9D1C08AD;
        Thu, 31 Oct 2019 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572519662; bh=AAMOx6e5D47bkbXqXrtoDHy1k1iDqzrTt/zXJAhG2jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=DN7z4MUMKRPVBbpT/IdvnwCsXEICMS/lTXrDaZVM4zU8llpWvVcGDA7XSi8Rgs9UH
         SfKSwjrSq0MH62XSA5Mp9uBdBSSDqTnl42/e03glpNL6aD4guL9+2BLUJMiJizBNaq
         Q4lYz4oLwsEGqXddaiMwnAKNuxgwLWFhddWK56qRS1vAbqrpr1HO25SmVBNkSwB9K7
         f987f6bw8OGM/TsEjxNDLYnvGA4GQzbio8Mk8N/pB2twPaTpTnHlDUK58nxDsDi0lb
         okfK+hqClwsmWV9wHmDO2I/IieR+YvJdVc0tT/Xz7XbBUn7hpqxAhni56hGfiv3V9U
         lmb8Sx5tjkHAw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 042CDA0069;
        Thu, 31 Oct 2019 11:01:00 +0000 (UTC)
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
Subject: [PATCH net v2 03/10] net: stmmac: xgmac: bitrev32 returns u32
Date:   Thu, 31 Oct 2019 12:00:41 +0100
Message-Id: <fc89e2306802511f70d0320a2b82487032cb237e.1572519070.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bitrev32 function returns an u32 var, not an int. Fix it.

Fixes: 0efedbf11f07 ("net: stmmac: xgmac: Fix XGMAC selftests")
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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index e24382d00e62..b58522b8f782 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -463,7 +463,7 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 		value |= XGMAC_FILTER_HMC;
 
 		netdev_for_each_mc_addr(ha, dev) {
-			int nr = (bitrev32(~crc32_le(~0, ha->addr, 6)) >>
+			u32 nr = (bitrev32(~crc32_le(~0, ha->addr, 6)) >>
 					(32 - mcbitslog2));
 			mc_filter[nr >> 5] |= (1 << (nr & 0x1F));
 		}
-- 
2.7.4

