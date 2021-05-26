Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F63390F87
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 06:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhEZEcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 00:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbhEZEcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 00:32:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56C3C061756
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 21:30:51 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBo-0001Op-Bk; Wed, 26 May 2021 06:30:40 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBm-0002bL-G5; Wed, 26 May 2021 06:30:38 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH net-next v3 0/9] provide cable test support for the ksz886x switch
Date:   Wed, 26 May 2021 06:30:28 +0200
Message-Id: <20210526043037.9830-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we already have 5.13-rc3, I assume http://vger.kernel.org/~davem/net-next.html
is out of date.

changes v3:
- remove RFC tag

changes v2:
- use generic MII_* defines where possible
- rework phylink validate
- remove phylink get state function
- reorder cabletest patches to make PHY flag patch in the right order
- fix MDI-X detection

This patches provide support for cable testing on the ksz886x switches.
Since it has one special port, we needed to add phylink with validation
and extra quirk for the PHY to signal, that one port will not provide
valid cable testing reports.

Michael Grzeschik (2):
  net: phy: micrel: move phy reg offsets to common header
  net: dsa: microchip: ksz8795: add phylink support

Oleksij Rempel (7):
  net: phy: micrel: use consistent indention after define
  net: phy: micrel: apply resume errata workaround for ksz8873 and
    ksz8863
  net: phy/dsa micrel/ksz886x add MDI-X support
  net: phy: micrel: ksz8081 add MDI-X support
  net: dsa: microchip: ksz8795: add LINK_MD register support
  net: dsa: dsa_slave_phy_connect(): extend phy's flags with port
    specific phy flags
  net: phy: micrel: ksz886x/ksz8081: add cabletest support

 drivers/net/dsa/microchip/ksz8795.c     | 218 +++++++++----
 drivers/net/dsa/microchip/ksz8795_reg.h |  67 +---
 drivers/net/ethernet/micrel/ksz884x.c   | 105 +-----
 drivers/net/phy/micrel.c                | 403 +++++++++++++++++++++++-
 drivers/net/phy/phylink.c               |   2 +-
 include/linux/micrel_phy.h              |  16 +
 net/dsa/slave.c                         |   4 +
 7 files changed, 588 insertions(+), 227 deletions(-)

-- 
2.29.2

