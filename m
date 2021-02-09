Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF10D315420
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhBIQmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:42:00 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:45603 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbhBIQll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:41:41 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6564723E65;
        Tue,  9 Feb 2021 17:40:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612888858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1BD6GPXkd0mznI05m9cMdTNT1X2LD11re7vav4rqhD0=;
        b=R2b/VGoPaff0WY+PzMsySf7eAZTLlSadCgVNnYQqoHKIqO2g6/vp0F/o1MAQ6kSYPBtBMi
        v7/ahw3irOC/yj4CEM4uFvb+GGvfUpWOYghi5h4EUnUsxISb+Rm8nCVHI5Dhnelns9gxQ8
        rB5/fuIw3Z+3OEyIvRI4NAoU6S2OV5E=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/9] net: phy: icplus: use PHY_ID_MATCH_EXACT() for IP101A/G
Date:   Tue,  9 Feb 2021 17:40:44 +0100
Message-Id: <20210209164051.18156-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210209164051.18156-1-michael@walle.cc>
References: <20210209164051.18156-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the datasheet of the IP101A/G there is no revision field
and MII_PHYSID2 always reads as 0x0c54. Use PHY_ID_MATCH_EXACT() then.

Signed-off-by: Michael Walle <michael@walle.cc>
---
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

