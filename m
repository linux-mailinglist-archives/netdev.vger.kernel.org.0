Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B79E484014
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiADKrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiADKq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:46:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B51C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 02:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/7m9yW7Gl1RoJbVFF8dfb0YHL9Erp5yUJh/lOz4Vwlc=; b=JZgFolv7xrYX4DoXM9PSQKHrpK
        YuKMhRqVq4pZjVMzp1ZfsuezRutuCmW62syboJH0LnW/VcYmSie4JYKAxr3IdhD2VNBaRiKJNZtHa
        bc8dkIILS4Tl4uO+cTXOCzqZHNxC7nCg9BY10lAq4EsSg1xJhL8xZgGxiO6c37iTyBzD7Y6M8Ka0K
        AjGD7Q46XZXeiAL7+Gswt/dae+/Wy8IqPeBfgqQ2YYIZLewSTo+xt6pqPRx/mT8s8j0O5h6FK9L0V
        9CISe0xiMT5cSyaDDbUrH8+xgB+se5AG8lnGfhN65E4dfrm42ZWjdtRjWXDaVWPv/sRrdxwhSL1Ma
        m21+4ZKQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46552 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1n4hLD-0006t8-KA; Tue, 04 Jan 2022 10:46:55 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1n4hLD-002NWF-0a; Tue, 04 Jan 2022 10:46:55 +0000
In-Reply-To: <YdQlI8gcVwg2sR+5@shell.armlinux.org.uk>
References: <YdQlI8gcVwg2sR+5@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH CFT v2 net-next 2/2] net: axienet: replace mdiobus_write()
 with mdiodev_write()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1n4hLD-002NWF-0a@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 04 Jan 2022 10:46:55 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0ebecb2644c8 ("net: mdio: Add helper functions for accessing
MDIO devices") added support for mdiodev accessor operations that
neatly wrap the mdiobus accessor operations. Since we are dealing with
a mdio device here, update the driver to use mdiodev_write().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 7a28355114a8..42ffa8500c2b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1540,8 +1540,7 @@ static int axienet_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	int ret;
 
 	if (lp->switch_x_sgmii) {
-		ret = mdiobus_write(pcs_phy->bus, pcs_phy->addr,
-				    XLNX_MII_STD_SELECT_REG,
+		ret = mdiodev_write(pcs_phy, XLNX_MII_STD_SELECT_REG,
 				    interface == PHY_INTERFACE_MODE_SGMII ?
 					XLNX_MII_STD_SELECT_SGMII : 0);
 		if (ret < 0) {
-- 
2.30.2

