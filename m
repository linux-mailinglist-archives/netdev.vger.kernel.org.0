Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CBB360A1E
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 15:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhDONId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 09:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbhDONIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 09:08:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77509C061761
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 06:08:02 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lX1ig-0006KP-Ub; Thu, 15 Apr 2021 15:07:42 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lX1if-0005KG-GR; Thu, 15 Apr 2021 15:07:41 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v2 0/7] provide generic net selftest support
Date:   Thu, 15 Apr 2021 15:07:31 +0200
Message-Id: <20210415130738.19603-1-o.rempel@pengutronix.de>
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

changes v2:
- make this tests available for all netowking devices.
- enable them on FEC, ag71xx and all DSA switches.
- add and test loopback support on more PHYs.

This patch set provides diagnostic capabilities for some iMX, ag71xx or
any DSA based devices. For proper functionality, PHY loopback support is
needed.
So far there is only initial infrastructure with basic tests. 

Oleksij Rempel (7):
  net: phy: genphy_loopback: add link speed configuration
  net: phy: micrel: KSZ8081 & KSZ9031: add loopback support
  net: phy: at803x: AR8085 & AR9331: add loopback support
  net: add generic selftest support
  net: fec: make use of generic NET_SELFTESTS library
  net: ag71xx: make use of generic NET_SELFTESTS library
  net: dsa: enable selftest support for all switches by default

 drivers/net/ethernet/atheros/Kconfig      |   1 +
 drivers/net/ethernet/atheros/ag71xx.c     |  20 +-
 drivers/net/ethernet/freescale/Kconfig    |   1 +
 drivers/net/ethernet/freescale/fec_main.c |   7 +
 drivers/net/phy/at803x.c                  |   2 +
 drivers/net/phy/micrel.c                  |   2 +
 drivers/net/phy/phy.c                     |   3 +-
 drivers/net/phy/phy_device.c              |  21 +-
 include/linux/phy.h                       |   1 +
 include/net/dsa.h                         |   2 +
 include/net/selftests.h                   |  12 +
 net/Kconfig                               |   4 +
 net/core/Makefile                         |   1 +
 net/core/selftests.c                      | 366 ++++++++++++++++++++++
 net/dsa/Kconfig                           |   1 +
 net/dsa/slave.c                           |  21 ++
 16 files changed, 458 insertions(+), 7 deletions(-)
 create mode 100644 include/net/selftests.h
 create mode 100644 net/core/selftests.c

-- 
2.29.2

