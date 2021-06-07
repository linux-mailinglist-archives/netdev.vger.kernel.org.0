Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D021B39D73F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhFGI3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhFGI31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:29:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B67C061766
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 01:27:36 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqAba-0004cs-01; Mon, 07 Jun 2021 10:27:30 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqAbZ-0006n7-3j; Mon, 07 Jun 2021 10:27:29 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/8] port asix ax88772 to the PHYlib
Date:   Mon,  7 Jun 2021 10:27:19 +0200
Message-Id: <20210607082727.26045-1-o.rempel@pengutronix.de>
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
- add Reviewed-by: Andrew Lunn <andrew@lunn.ch> to some patches
- refactor asix_read_phy_addr() and add error handling for all callers
- refactor asix_mdio_bus_read()

Port ax88772 part of asix driver to the phylib to be able to use more
advanced external PHY attached to this controller.

Oleksij Rempel (8):
  net: usb: asix: ax88772_bind: use devm_kzalloc() instead of kzalloc()
  net: usb: asix: refactor asix_read_phy_addr() and handle errors on
    return
  net: usb/phy: asix: add support for ax88772A/C PHYs
  net: usb: asix: ax88772: add phylib support
  net: usb: asix: ax88772: add generic selftest support
  net: usb: asix: add error handling for asix_mdio_* functions
  net: phy: do not print dump stack if device was removed
  usbnet: run unbind() before unregister_netdev()

 drivers/net/phy/ax88796b.c     |  74 +++++++++++++++-
 drivers/net/phy/phy.c          |   3 +
 drivers/net/usb/Kconfig        |   2 +
 drivers/net/usb/asix.h         |  13 ++-
 drivers/net/usb/asix_common.c  | 106 ++++++++++++++++------
 drivers/net/usb/asix_devices.c | 157 +++++++++++++++++++++++----------
 drivers/net/usb/ax88172a.c     |  19 ++--
 drivers/net/usb/usbnet.c       |   6 +-
 8 files changed, 286 insertions(+), 94 deletions(-)

-- 
2.29.2

