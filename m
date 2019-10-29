Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD48E8A88
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389344AbfJ2OPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:15:55 -0400
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:53348 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388932AbfJ2OPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 10:15:18 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 37710C04DC;
        Tue, 29 Oct 2019 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572358517; bh=AAMOx6e5D47bkbXqXrtoDHy1k1iDqzrTt/zXJAhG2jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Jo9fbP/aSDkD2XloCo4ygLMiJ67jBLLL9XrXz9HDmxYq9Mp2cpmLER9DYFGxcRGiF
         VO8cjGxxQkHr6eil+0YRKe2MS13RHMwgW58DUpR8hdSmbN3f9rDyjZXq2erevo+ZuX
         mAMfJ5V9SHJRvhLi9wd7uStLQhZB27S+b7y5tUemBvjTrw/57FSouSMRmbUG9t+S99
         PUVb+oKs9fy1PnMbAp8feZodTOHakd2h/TXgJndBzcl6+CUTZvS5gLqHJa77xLce7z
         X3NC5wNDpNpTfnDKyNwK2qTowg+CkVMg/C47dEk2Snw0DMgvX6FzsQnErzdvUjfZy+
         W2D7tTLVfycLg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id BDEC9A0069;
        Tue, 29 Oct 2019 14:15:14 +0000 (UTC)
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
Subject: [PATCH net 3/9] net: stmmac: xgmac: bitrev32 returns u32
Date:   Tue, 29 Oct 2019 15:14:47 +0100
Message-Id: <fc89e2306802511f70d0320a2b82487032cb237e.1572355609.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572355609.git.Jose.Abreu@synopsys.com>
References: <cover.1572355609.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572355609.git.Jose.Abreu@synopsys.com>
References: <cover.1572355609.git.Jose.Abreu@synopsys.com>
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

