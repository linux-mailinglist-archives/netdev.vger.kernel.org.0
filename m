Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAA42E94E2
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 13:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbhADMbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 07:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbhADMbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 07:31:19 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F207C061574
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 04:30:38 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D8Zj91Vfcz1rwbJ;
        Mon,  4 Jan 2021 13:30:37 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D8Zj91295z1qwHK;
        Mon,  4 Jan 2021 13:30:37 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id tXeALKteTzeD; Mon,  4 Jan 2021 13:30:36 +0100 (CET)
X-Auth-Info: vCVdQPsiR+O9hyO6Qa+M3MWlWNqbE7MKAeLAd7y1Eqg=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon,  4 Jan 2021 13:30:36 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH V2 1/2] net: phy: micrel: Add KS8851 PHY support
Date:   Mon,  4 Jan 2021 13:30:16 +0100
Message-Id: <20210104123017.261452-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KS8851 has a reduced internal PHY, which is accessible through its
registers at offset 0xe4. The PHY is compatible with KS886x PHY present
in Micrel switches, including the PHY ID Low/High registers swap, which
is present both in the MAC and the switch.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>
To: netdev@vger.kernel.org
---
V2: Merge the KSZ8851 and KS886X entries, as those PHYs cannot be discerned
---
 drivers/net/phy/micrel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 54e0d75203da..39c7c786a912 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1389,7 +1389,7 @@ static struct phy_driver ksphy_driver[] = {
 }, {
 	.phy_id		= PHY_ID_KSZ886X,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-	.name		= "Micrel KSZ886X Switch",
+	.name		= "Micrel KSZ8851 Ethernet MAC or KSZ886X Switch",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
 	.suspend	= genphy_suspend,
-- 
2.29.2

