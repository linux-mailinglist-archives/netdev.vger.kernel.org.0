Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728523A1B7D
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhFIRHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:07:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49331 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhFIRHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:07:20 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lr1dh-0007Xt-Te; Wed, 09 Jun 2021 17:05:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: stmmac: Fix missing { } around two statements in an if statement
Date:   Wed,  9 Jun 2021 18:05:12 +0100
Message-Id: <20210609170512.297623-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are missing { } around a block of code on an if statement. Fix this
by adding them in.

Addresses-Coverity: ("Nesting level does not match indentation")
Fixes: 46682cb86a37 ("net: stmmac: enable Intel mGbE 2.5Gbps link speed")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1c881ec8cd04..1f817b1b890c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -932,9 +932,10 @@ static void stmmac_validate(struct phylink_config *config,
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
 	} else if (priv->plat->has_gmac4) {
-		if (!max_speed || max_speed >= 2500)
+		if (!max_speed || max_speed >= 2500) {
 			phylink_set(mac_supported, 2500baseT_Full);
 			phylink_set(mac_supported, 2500baseX_Full);
+		}
 	} else if (priv->plat->has_xgmac) {
 		if (!max_speed || (max_speed >= 2500)) {
 			phylink_set(mac_supported, 2500baseT_Full);
-- 
2.31.1

