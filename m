Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127B16DCFBF
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 04:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjDKCfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 22:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjDKCfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 22:35:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C7426B2
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 19:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=9qY02U4dyO1Werb1gxvpJfmvHJ5mAhpH7CA1yJvqX0g=; b=MhN0BrUYGG11HkB0RTy9k6eF4c
        uzVlB9T2/e2PLUzF7wWOhnqgMEeY27fGp+w9Rb3pUgnrq275A8tcgap0utHWaRw/aSXfjwoa5P6n9
        BhQYZTn/4Kozrx9vKmnVKlMfhhlZPq4kcwICYUm2zjnm1oW+X7dU5J3rzpNluvcMl174=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pm3rF-009xE4-FV; Tue, 11 Apr 2023 04:35:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Correct cmode to PHY_INTERFACE_
Date:   Tue, 11 Apr 2023 04:35:41 +0200
Message-Id: <20230411023541.2372609-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch can either take the MAC or the PHY role in an MII or RMII
link. There are distinct PHY_INTERFACE_ macros for these two roles.
Correct the mapping so that the `REV` version is used for the PHY
role.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---

Since this has not caused any known issues so far, i decided to not
add a Fixes: tag and submit for net.

 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 62a126402983..ffe6a88f94ce 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -611,10 +611,10 @@ static void mv88e6185_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 }
 
 static const u8 mv88e6xxx_phy_interface_modes[] = {
-	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_MII,
+	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_REVMII,
 	[MV88E6XXX_PORT_STS_CMODE_MII]		= PHY_INTERFACE_MODE_MII,
 	[MV88E6XXX_PORT_STS_CMODE_GMII]		= PHY_INTERFACE_MODE_GMII,
-	[MV88E6XXX_PORT_STS_CMODE_RMII_PHY]	= PHY_INTERFACE_MODE_RMII,
+	[MV88E6XXX_PORT_STS_CMODE_RMII_PHY]	= PHY_INTERFACE_MODE_REVRMII,
 	[MV88E6XXX_PORT_STS_CMODE_RMII]		= PHY_INTERFACE_MODE_RMII,
 	[MV88E6XXX_PORT_STS_CMODE_100BASEX]	= PHY_INTERFACE_MODE_100BASEX,
 	[MV88E6XXX_PORT_STS_CMODE_1000BASEX]	= PHY_INTERFACE_MODE_1000BASEX,
-- 
2.40.0

