Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1666F1971
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732111AbfKFPDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:03:46 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:43166 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731957AbfKFPDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 10:03:13 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C99A7C0F3F;
        Wed,  6 Nov 2019 15:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573052592; bh=dcR015NNz5+XlS3ua0x/mswtyC/JnJmgSn+mmJnkyEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=DOfJZRtajlgOeuEGRxmVQCftwcCw41PTW6fFV1stw999KI/4CF0ZNpmpKG52dNadN
         x3tzM3rh+5+LJs9bhsd74Vy3kjwfbJM3s/hpNJ7l9NXJpv1T5E/26BvkBzjaOhEfrm
         EfnGYAydb+NnOZJuT6St73Wx9bUxhSxjheH/YbHklxJDMJSiMR0f0QJyyrM0pZgrXM
         svScwOBVQY0zM4k+RrBVBvZNQiESTZSYM1dkJry/ATtVjJSwccAKhHhUOvPn/g85WS
         SQJWOrzPrGvPoT4CH0387Q3slQcX5Ru549i7bxh60rEcj2hSt1dQga5SIjNLYzHZ4a
         BS8ZCJAnAVQag==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7105FA005E;
        Wed,  6 Nov 2019 15:03:10 +0000 (UTC)
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
Subject: [PATCH net 01/11] net: stmmac: gmac4: bitrev32 returns u32
Date:   Wed,  6 Nov 2019 16:02:55 +0100
Message-Id: <16c560e16fecc686284008ea0faa85a96b8a680e.1573052379.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573052378.git.Jose.Abreu@synopsys.com>
References: <cover.1573052378.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573052378.git.Jose.Abreu@synopsys.com>
References: <cover.1573052378.git.Jose.Abreu@synopsys.com>
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
index 5a7b0aca1d31..66e60c7e9850 100644
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

