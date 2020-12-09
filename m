Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A486C2D4E4B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388752AbgLIWoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:44:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:15832 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388242AbgLIWoX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 17:44:23 -0500
IronPort-SDR: IL8iKtOvhi15/qs6ztMwRZ+bZpWfbXOsv0lelIBlT7omlK8srjrvtLGWfFqGWyEDx8DE82MX0V
 1Nz78UnCOwkg==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="161920277"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="161920277"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 14:43:42 -0800
IronPort-SDR: CvYUj1NyjNZmuLu6KhWt70IfCjm+TvOwdSLHpjCAh8vwPJux9UaI0JDKbQtf8RqfdQpQFZoW4+
 cxQHwu3hNmdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="484179333"
Received: from unknown (HELO glass.png.intel.com) ([10.158.65.144])
  by orsmga004.jf.intel.com with ESMTP; 09 Dec 2020 14:43:39 -0800
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
Subject: [PATCH v2 net-next 1/1] net: stmmac: allow stmmac to probe for C45 PHY devices
Date:   Thu, 10 Dec 2020 06:47:00 +0800
Message-Id: <20201209224700.30295-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assign stmmac's mdio_bus probe capabilities to MDIOBUS_C22_C45.
This extended the probing of C45 PHY devices on the MDIO bus.

Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
v2 changelog:
- Added conditional check for gmac4.
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index b2a707e2ef43..d64116e0543e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -365,6 +365,9 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 	new_bus->name = "stmmac";
 
+	if (priv->plat->has_gmac4)
+		new_bus->probe_capabilities = MDIOBUS_C22_C45;
+
 	if (priv->plat->has_xgmac) {
 		new_bus->read = &stmmac_xgmac2_mdio_read;
 		new_bus->write = &stmmac_xgmac2_mdio_write;
-- 
2.17.0

