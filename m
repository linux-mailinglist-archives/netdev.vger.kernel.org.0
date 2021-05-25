Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D408D38FA6E
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 07:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhEYF5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 01:57:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:6381 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhEYF5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 01:57:20 -0400
IronPort-SDR: LxM+ldHm+7Ojx9iGR9sry1r88gVc5TJadE2b93pLngqPv7rUYqcwmp+EQM5BMW8ArGawzDeL2i
 wthLpe570zGw==
X-IronPort-AV: E=McAfee;i="6200,9189,9994"; a="201860402"
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="201860402"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 22:55:51 -0700
IronPort-SDR: fxzLbUfFVHEbsRkNrPKG5pqht9ZyH/zhsQquL3K9tzylGIbruuxq70RtZVbKLjq+1AnYMCmNtX
 BlTP4eZ4nJrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="408614873"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga007.fm.intel.com with ESMTP; 24 May 2021 22:55:51 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id D4B05580911;
        Mon, 24 May 2021 22:55:48 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next 2/2] net: stmmac: allow gmac4 to probe for c45 devices before c22
Date:   Tue, 25 May 2021 14:00:54 +0800
Message-Id: <20210525060054.23750-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the order of probing devices to Clause-45 followed by Clause-22.
This will allow probing devices that only return valid PHY ID when
accessed via Clause-45.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index b750074f8f9c..1050d4c128ff 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -425,7 +425,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 	new_bus->name = "stmmac";
 
 	if (priv->plat->has_gmac4)
-		new_bus->probe_capabilities = MDIOBUS_C22_C45;
+		new_bus->probe_capabilities = MDIOBUS_C45_C22;
 
 	if (priv->plat->has_xgmac) {
 		new_bus->read = &stmmac_xgmac2_mdio_read;
-- 
2.25.1

