Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9659A49B859
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353358AbiAYQOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583337AbiAYQKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:10:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB7CC061753
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jfRhHeCItZdJDoUJOFAMeKNxqjZwLe2HA/DR6O7B1PE=; b=kb37uETahOj+nlD4Rodr6GAA8g
        r8fURlYIzTPqNag4LqHwvLqDZepgTQoZ2P4UQ1YT4b4E27PcIg62VHfPvHDUOh5gNw7noHlRN6pVy
        5s8gV7EfFvJPoazsCO7x91TzbTpzB+Cw61A4TSB7EukiMoZfXBCMRB6vN7LjlvEp6ElXXmpGLJfxB
        ptMfhpo+37EOLcfMcJtI4RfnFBURYCzXpeP/rbZCvE46PxGtgB0WetugBXLVkdkMWPTOMArfrgDvT
        DOSvr1XQ46U/sMzKM1ie90HLv/M2gHPzWAdyc4iO+LtRHryNgtwBd8x9WPMGlEw98tGKB9XojX8vd
        E7ORlwrA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57224 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCOOf-00028E-6q; Tue, 25 Jan 2022 16:10:17 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCOOe-005L92-JE; Tue, 25 Jan 2022 16:10:16 +0000
In-Reply-To: <YfAgeKiKvxcQ0w57@shell.armlinux.org.uk>
References: <YfAgeKiKvxcQ0w57@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 2/2] net: axienet: replace mdiobus_write() with
 mdiodev_write()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCOOe-005L92-JE@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 25 Jan 2022 16:10:16 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0ebecb2644c8 ("net: mdio: Add helper functions for accessing
MDIO devices") added support for mdiodev accessor operations that
neatly wrap the mdiobus accessor operations. Since we are dealing with
a mdio device here, update the driver to use mdiodev_write().

Tested-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 1ebdf1c62db8..de0a6372ae0e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1568,8 +1568,7 @@ static int axienet_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
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

