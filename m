Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5975E8A8A
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389372AbfJ2OQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:16:02 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:53352 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389092AbfJ2OPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 10:15:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7902FC0C3C;
        Tue, 29 Oct 2019 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572358517; bh=evZvvLApro5hVwuymO7sh6uSbwgwXdDeSzUoyB4odvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Plp55JQHq0ATBlVxh634syHSyndAcYi8WxBB2hL3r9is7wHYNlY1ZroA++Xut6RtW
         RJQkul6oy+irrP/ylEkQxiN7keocpDkVp28z93EfYRJF7Xtu9poAtDZy2IsYHwDL0/
         XzNLbQQ8bFzo+yqQyj3hdCku/pHK6iu4P9QAj8HRL5fmDzdFjcotOrG9ivk6W/uxhN
         LGP9aAbCKpVApKCYVpfn5qmzX82w+cbLvI3oZtDoGGLX8W8WlBRpJJ/fibMtVJJV/c
         MsCBrPiAN9EIgTbJI21MDSrw1oGVYGQlPPjhyM4I/6sQ2UXjw90m6VDDlv/9lkwOo/
         mUMQtKRYGNHcg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id AAFC1A0065;
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
Subject: [PATCH net 2/9] net: stmmac: gmac4: bitrev32 returns u32
Date:   Tue, 29 Oct 2019 15:14:46 +0100
Message-Id: <897a8a6291b1533e6b64f2b85fc5a782983ccfe9.1572355609.git.Jose.Abreu@synopsys.com>
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

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
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
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 365e607f07cd..40ca00e596dd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -432,7 +432,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 			 * bits used depends on the hardware configuration
 			 * selected at core configuration time.
 			 */
-			int bit_nr = bitrev32(~crc32_le(~0, ha->addr,
+			u32 bit_nr = bitrev32(~crc32_le(~0, ha->addr,
 					ETH_ALEN)) >> (32 - mcbitslog2);
 			/* The most significant bit determines the register to
 			 * use (H/L) while the other 5 bits determine the bit
-- 
2.7.4

