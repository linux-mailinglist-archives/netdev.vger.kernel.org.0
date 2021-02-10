Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C64B3171FF
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhBJVJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:09:33 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:42829 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhBJVJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:09:02 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C232E23E71;
        Wed, 10 Feb 2021 22:08:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612991298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QK2bcR/rLsouR+qBwCFySa41ZRH5nsbzNnUjxxYoa+E=;
        b=ZDiIFSoysac4hCGQX9o/ScNXEM0MqEVCdcqYadKtEPyDuZO0E3CR1dWWoTsRN2SWjH7UFs
        cB+QxknPtZTvPXE89RoRH0Ly4rJKczPWidzhfqITiFmuuzvQsPFyS4VJwSoq8DObcgfol2
        HbJ5MopRLI5Zl15qEi09wu0XnBb7Uxs=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 2/9] net: phy: icplus: use PHY_ID_MATCH_EXACT() for IP101A/G
Date:   Wed, 10 Feb 2021 22:08:02 +0100
Message-Id: <20210210210809.30125-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210210809.30125-1-michael@walle.cc>
References: <20210210210809.30125-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the datasheet of the IP101A/G there is no revision field
and MII_PHYSID2 always reads as 0x0c54. Use PHY_ID_MATCH_EXACT() then.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes since v2:
 - none

Changes since v1:
 - none

 drivers/net/phy/icplus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 4407b1eb1a3d..ae3cf61c5ac2 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -349,7 +349,7 @@ static struct phy_driver icplus_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	PHY_ID_MATCH_MODEL(IP101A_PHY_ID),
+	PHY_ID_MATCH_EXACT(IP101A_PHY_ID),
 	.name		= "ICPlus IP101A/G",
 	/* PHY_BASIC_FEATURES */
 	.probe		= ip101a_g_probe,
@@ -365,7 +365,7 @@ module_phy_driver(icplus_driver);
 static struct mdio_device_id __maybe_unused icplus_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(IP175C_PHY_ID) },
 	{ PHY_ID_MATCH_MODEL(IP1001_PHY_ID) },
-	{ PHY_ID_MATCH_MODEL(IP101A_PHY_ID) },
+	{ PHY_ID_MATCH_EXACT(IP101A_PHY_ID) },
 	{ }
 };
 
-- 
2.20.1

