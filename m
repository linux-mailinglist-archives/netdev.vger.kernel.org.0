Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEF82D40D0
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgLILQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:16:57 -0500
Received: from mga17.intel.com ([192.55.52.151]:37324 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgLILQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 06:16:56 -0500
IronPort-SDR: pX558xBZYEW9rPWkL9bBTVgrI3BPoOuWKfE2/O71OwiS/KD4yO3ROGFtLjvhT2Es456jYGmDgl
 KNYbbYRSt6pQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9829"; a="153869054"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="153869054"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 03:16:16 -0800
IronPort-SDR: eee8sjsM9prCLqQtVC0BnY60zaqw2Zpdbf1FUEdxvtY2pQUkOMDpP/p5Pys6PpqEvyF3EtTul9
 NA/5xNo8/d9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="318747975"
Received: from unknown (HELO glass.png.intel.com) ([10.158.65.144])
  by fmsmga007.fm.intel.com with ESMTP; 09 Dec 2020 03:16:13 -0800
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net-next 1/1] net: stmmac: allow stmmac to probe for C45 PHY devices
Date:   Wed,  9 Dec 2020 19:19:33 +0800
Message-Id: <20201209111933.16121-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assign stmmac's mdio_bus probe capabilities to MDIOBUS_C22_C45.
This extends the probing of C45 PHY devices on the MDIO bus.

Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index b2a707e2ef43..9f96bb7d27db 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -364,6 +364,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 		memcpy(new_bus->irq, mdio_bus_data->irqs, sizeof(new_bus->irq));
 
 	new_bus->name = "stmmac";
+	new_bus->probe_capabilities = MDIOBUS_C22_C45;
 
 	if (priv->plat->has_xgmac) {
 		new_bus->read = &stmmac_xgmac2_mdio_read;
-- 
2.17.0

