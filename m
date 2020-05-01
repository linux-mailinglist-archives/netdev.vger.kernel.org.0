Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7721C0EFD
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 09:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgEAHqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 03:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728384AbgEAHqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 03:46:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475DAC035495
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 00:46:50 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jUQNa-0001Z0-Cr; Fri, 01 May 2020 09:46:38 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jUQNW-0006Mu-Is; Fri, 01 May 2020 09:46:34 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH net-next v4 0/2] provide support for PHY master/slave configuration
Date:   Fri,  1 May 2020 09:46:31 +0200
Message-Id: <20200501074633.24421-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v3:
- rename port_mode to master_slave 
- move validation code to net/ethtool/linkmodes.c 
- add UNSUPPORTED state and avoid sending unsupported fields
- more formatting and naming fixes
- tja11xx: support only force mode
- tja11xx: mark state as unsupported

changes v3:
- provide separate field for config and state.
- make state rejected on set
- add validation

changes v2:
- change names. Use MASTER_PREFERRED instead of MULTIPORT
- configure master/slave only on request. Default configuration can be
  provided by PHY or eeprom
- status and configuration to the user space.

Oleksij Rempel (2):
  ethtool: provide UAPI for PHY master/slave configuration.
  net: phy: tja11xx: add support for master-slave configuration

 Documentation/networking/ethtool-netlink.rst | 35 ++++----
 drivers/net/phy/nxp-tja11xx.c                | 47 +++++++++-
 drivers/net/phy/phy.c                        |  4 +-
 drivers/net/phy/phy_device.c                 | 95 ++++++++++++++++++++
 include/linux/phy.h                          |  3 +
 include/uapi/linux/ethtool.h                 | 16 +++-
 include/uapi/linux/ethtool_netlink.h         |  2 +
 include/uapi/linux/mii.h                     |  2 +
 net/ethtool/linkmodes.c                      | 48 ++++++++++
 9 files changed, 233 insertions(+), 19 deletions(-)

-- 
2.26.2

