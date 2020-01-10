Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84871370DA
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgAJPNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:13:42 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:37166 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728376AbgAJPNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:13:41 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1C461C0522;
        Fri, 10 Jan 2020 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578669220; bh=m62mtPJSBlHY0ixcqJ0iQUPZHLHvY4azjA/cSUMxlA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=QwltsTjis72UcOn/ju1CBT3hvuUF8kzWv/AtR/Tw0TtgFdUWJuTTvT1mo0offS+9i
         tKck/aO+oc1X3tiJYWbvDoUuCeMzrPDZSoEhwyyzIU4NcIeiqNB8KT58CMyun9x9qZ
         n2/dmi62IpYI2ioyqHVrQFgVw4SjzwcOt8zH2Zj/xl8fuqhLsRlnjz+GqAAAvk94o7
         1u7SR+84rpbugK1cobB14AOk+t9olnPz8w+/zno055Ej57TqMS55uDvM4cfGVZ8xVQ
         c7nr2uRmWku+4uW2BACC61oKpZfJlI/8xzmAD014ShWBvkweQqd4cOd9C8svnxCJUM
         VSiaUvR+khRMA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 95981A0063;
        Fri, 10 Jan 2020 15:13:38 +0000 (UTC)
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
Subject: [PATCH net-next 1/2] net: stmmac: xgmac: Fix missing return
Date:   Fri, 10 Jan 2020 16:13:34 +0100
Message-Id: <19e465556983a8c758781c4ac90d237fd7f007ba.1578669088.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578669088.git.Jose.Abreu@synopsys.com>
References: <cover.1578669088.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578669088.git.Jose.Abreu@synopsys.com>
References: <cover.1578669088.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If FPE is supposed to be disabled we need to return after disabling it.

Fixes: f0e56c8d8f7d ("net: stmmac: xgmac3+: Add support for Frame Preemption")
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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 307105e8dea0..2af3ac5409b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -1421,6 +1421,7 @@ static void dwxgmac3_fpe_configure(void __iomem *ioaddr, u32 num_txq,
 		value &= ~XGMAC_EFPE;
 
 		writel(value, ioaddr + XGMAC_FPE_CTRL_STS);
+		return;
 	}
 
 	value = readl(ioaddr + XGMAC_RXQ_CTRL1);
-- 
2.7.4

