Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0CE201991
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 19:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392943AbgFSRgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 13:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733014AbgFSRga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 13:36:30 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4AC207FC;
        Fri, 19 Jun 2020 17:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592588190;
        bh=L+tk6K8+KLeTw56G+NcQJe1v8l4u5Inpr28aIByN6bM=;
        h=Date:From:To:Cc:Subject:From;
        b=pFszgEe7W52VYhYygyQ81y07znn+5vd4rlFJsiO3UMl1RN0TlJ8AbdjXbaWwCm/2B
         YYKLYOweHPapKY1Aoxb065KEKNpUvox6CHx7LTeNP1Ja5k3+QQPDs3AgB4xxaArU8c
         oHfLTfSYF3i9C1z65G43J+1DpgFZdHNXiyXJ2Jts=
Date:   Fri, 19 Jun 2020 12:41:54 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: stmmac: selftests: Use struct_size() in kzalloc()
Message-ID: <20200619174154.GA21660@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index e6696495f126..e113b1376fdd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1094,7 +1094,7 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 	if (!priv->dma_cap.frpsel)
 		return -EOPNOTSUPP;
 
-	sel = kzalloc(sizeof(*sel) + nk * sizeof(struct tc_u32_key), GFP_KERNEL);
+	sel = kzalloc(struct_size(sel, keys, nk), GFP_KERNEL);
 	if (!sel)
 		return -ENOMEM;
 
-- 
2.27.0

