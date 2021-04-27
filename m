Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E91036BFCD
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 09:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbhD0HKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 03:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234854AbhD0HK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 03:10:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF814C061760
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 00:09:22 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHqK-00011s-9W; Tue, 27 Apr 2021 09:09:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHqI-0003lp-AX; Tue, 27 Apr 2021 09:09:10 +0200
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
Subject: [PATCH net-next v8 0/9] microchip: add support for ksz88x3 driver family
Date:   Tue, 27 Apr 2021 09:09:00 +0200
Message-Id: <20210427070909.14434-1-o.rempel@pengutronix.de>
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

changes v8:
- add Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
- fix build issue on "net: dsa: microchip: ksz8795: move register
  offsets and shifts to separate struct"

changes v7:
- Reverse christmas tree fixes
- remove IS_88X3 and use chip_id instead
- drop own tag and use DSA_TAG_PROTO_KSZ9893 instead

changes v6:
- take over this patch set
- rebase against latest netdev-next and fix regressions
- disable VLAN support for KSZ8863. KSZ8863's VLAN is not compatible to the
  KSZ8795's. So disable it for now and mainline it separately.

This series adds support for the ksz88x3 driver family to the dsa based
ksz drivers. The driver is making use of the already available ksz8795
driver and moves it to an generic driver for the ksz8 based chips which
have similar functions but an totaly different register layout.

The mainlining discussion history of this branch:
v1: https://lore.kernel.org/netdev/20191107110030.25199-1-m.grzeschik@pengutronix.de/
v2: https://lore.kernel.org/netdev/20191218200831.13796-1-m.grzeschik@pengutronix.de/
v3: https://lore.kernel.org/netdev/20200508154343.6074-1-m.grzeschik@pengutronix.de/
v4: https://lore.kernel.org/netdev/20200803054442.20089-1-m.grzeschik@pengutronix.de/
v5: https://lore.kernel.org/netdev/20201207125627.30843-1-m.grzeschik@pengutronix.de/

Andrew Lunn (1):
  net: phy: Add support for microchip SMI0 MDIO bus

Michael Grzeschik (7):
  net: dsa: microchip: ksz8795: change drivers prefix to be generic
  net: dsa: microchip: ksz8795: move cpu_select_interface to extra
    function
  net: dsa: microchip: ksz8795: move register offsets and shifts to
    separate struct
  net: dsa: microchip: Add Microchip KSZ8863 SPI based driver support
  dt-bindings: net: dsa: document additional Microchip KSZ8863/8873
    switch
  net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support
  dt-bindings: net: mdio-gpio: add compatible for microchip,mdio-smi0

Oleksij Rempel (1):
  net: dsa: microchip: ksz8795: add support for ksz88xx chips

 .../bindings/net/dsa/microchip,ksz.yaml       |   2 +
 .../devicetree/bindings/net/mdio-gpio.txt     |   1 +
 drivers/net/dsa/microchip/Kconfig             |  10 +-
 drivers/net/dsa/microchip/Makefile            |   1 +
 drivers/net/dsa/microchip/ksz8.h              |  69 ++
 drivers/net/dsa/microchip/ksz8795.c           | 884 ++++++++++++------
 drivers/net/dsa/microchip/ksz8795_reg.h       | 125 +--
 drivers/net/dsa/microchip/ksz8795_spi.c       |  46 +-
 drivers/net/dsa/microchip/ksz8863_smi.c       | 213 +++++
 drivers/net/dsa/microchip/ksz_common.h        |   3 +-
 drivers/net/mdio/mdio-bitbang.c               |   8 +-
 drivers/net/mdio/mdio-gpio.c                  |   8 +
 include/linux/mdio-bitbang.h                  |   3 +
 13 files changed, 983 insertions(+), 390 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c

-- 
2.29.2

