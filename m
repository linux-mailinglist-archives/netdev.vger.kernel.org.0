Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF496AED5D
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 16:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732106AbfIJOld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 10:41:33 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:42924 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732225AbfIJOlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 10:41:32 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 52123C2B52;
        Tue, 10 Sep 2019 14:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568126491; bh=lVkOCoCejw+FdVkNi1DEkuCSQsbWp0vzSCTOU+r1FbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=maG0dwN9sqjrTYcrEmJPWJUP11sOR4TjwYTc/MdWqa86UHYx9amjx7WXN7iAC+X8M
         mVwZWht6k+04SQMQPE5QtONFUn9ZnaRd6EyeW0GuwNmhnvWLsc8MCWaWL5gQsWif08
         rw2+dGz1Pu0ZGhUzzSZHcptwmipKRX9a3Q1QxkcoeNo3F0IHZKwMEN3ceDPjwV2HFq
         j5ttxy0brNyRnkZQboYkwk+J/KxEYILqVO66dtro7EVCKhhzk44R0OhFMkvGcm0YnU
         9Jez7KvcLGghNIGdNV54/Wniet79x2KhVijxtu0YcPYQvgJqStKHup6KA2HvlpgHuL
         AzHmrwhJt99Pg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id DD654A0064;
        Tue, 10 Sep 2019 14:41:29 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: stmmac: xgmac: Reinitialize correctly a variable
Date:   Tue, 10 Sep 2019 16:41:24 +0200
Message-Id: <cc78134084a4d7c4f2ea35e369c422b71209d021.1568126224.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1568126224.git.joabreu@synopsys.com>
References: <cover.1568126224.git.joabreu@synopsys.com>
In-Reply-To: <cover.1568126224.git.joabreu@synopsys.com>
References: <cover.1568126224.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'value' was being or'ed with a value from another register. This is a
typo and could cause new written value to be wrong. Fix it.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

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
index 78ac659da279..d5173dd02a71 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -568,7 +568,7 @@ static void dwxgmac2_update_vlan_hash(struct mac_device_info *hw, u32 hash,
 
 		writel(value, ioaddr + XGMAC_PACKET_FILTER);
 
-		value |= XGMAC_VLAN_VTHM | XGMAC_VLAN_ETV;
+		value = XGMAC_VLAN_VTHM | XGMAC_VLAN_ETV;
 		if (is_double) {
 			value |= XGMAC_VLAN_EDVLP;
 			value |= XGMAC_VLAN_ESVL;
-- 
2.7.4

