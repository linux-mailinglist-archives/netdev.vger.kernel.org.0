Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F63944556
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfFMQnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:43:31 -0400
Received: from inva021.nxp.com ([92.121.34.21]:47598 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730459AbfFMGiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 02:38:07 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A17692000C7;
        Thu, 13 Jun 2019 08:38:05 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 91E7F20006F;
        Thu, 13 Jun 2019 08:38:05 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 34162205DB;
        Thu, 13 Jun 2019 08:38:05 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH] net: phylink: set the autoneg state in phylink_phy_change
Date:   Thu, 13 Jun 2019 09:37:51 +0300
Message-Id: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy_state field of phylink should carry only valid information
especially when this can be passed to the .mac_config callback.
Update the an_enabled field with the autoneg state in the
phylink_phy_change function.

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5d0af041b8f9..dd1feb7b5472 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -688,6 +688,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up,
 		pl->phy_state.pause |= MLO_PAUSE_ASYM;
 	pl->phy_state.interface = phydev->interface;
 	pl->phy_state.link = up;
+	pl->phy_state.an_enabled = phydev->autoneg;
 	mutex_unlock(&pl->state_mutex);
 
 	phylink_run_resolve(pl);
-- 
1.9.1

