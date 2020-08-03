Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F5C239F47
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgHCFpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgHCFpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:45:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4606FC0617A0
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 22:45:02 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THQ-0005J2-F9; Mon, 03 Aug 2020 07:45:00 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THK-0005Tu-SX; Mon, 03 Aug 2020 07:44:54 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v4 00/11] microchip: add support for ksz88x3 driver family
Date:   Mon,  3 Aug 2020 07:44:31 +0200
Message-Id: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the ksz88x3 driver family to the dsa based ksz
drivers. The driver is making use of the already available ksz8795 driver and
moves it to an generic driver for the ksz8 based chips which have similar
functions but an totaly different register layout.

Andrew Lunn (1):
  net: phy: Add support for microchip SMI0 MDIO bus

Michael Grzeschik (10):
  dt-bindings: net: mdio-gpio: add compatible for microchip,mdio-smi0
  net: tag: ksz: Add KSZ8863 tag code
  net: dsa: microchip: ksz8795: use port_cnt where possible
  net: dsa: microchip: ksz8795: dynamic allocate memory for
    flush_dyn_mac_table
  net: dsa: microchip: ksz8795: change drivers prefix to be generic
  net: dsa: microchip: ksz8795: move register offsets and shifts to
    separate struct
  net: dsa: microchip: ksz8795: add support for ksz88xx chips
  net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support
  net: dsa: microchip: Add Microchip KSZ8863 SPI based driver support
  dt-bindings: net: dsa: document additional Microchip KSZ8863/8873
    switch

 .../devicetree/bindings/net/dsa/ksz.txt       |   2 +
 .../devicetree/bindings/net/mdio-gpio.txt     |   1 +
 drivers/net/dsa/microchip/Kconfig             |   9 +
 drivers/net/dsa/microchip/Makefile            |   1 +
 drivers/net/dsa/microchip/ksz8.h              |  68 ++
 drivers/net/dsa/microchip/ksz8795.c           | 926 ++++++++++++------
 drivers/net/dsa/microchip/ksz8795_reg.h       | 214 ++--
 drivers/net/dsa/microchip/ksz8795_spi.c       |  64 +-
 drivers/net/dsa/microchip/ksz8863_reg.h       | 124 +++
 drivers/net/dsa/microchip/ksz8863_smi.c       | 204 ++++
 drivers/net/dsa/microchip/ksz_common.h        |   2 +-
 drivers/net/phy/mdio-bitbang.c                |   8 +-
 drivers/net/phy/mdio-gpio.c                   |   9 +
 include/linux/mdio-bitbang.h                  |   3 +
 include/net/dsa.h                             |   2 +
 net/dsa/tag_ksz.c                             |  57 ++
 16 files changed, 1275 insertions(+), 419 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c

-- 
2.28.0

