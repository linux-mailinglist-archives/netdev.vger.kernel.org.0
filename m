Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E301CB3BC
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgEHPn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgEHPny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:43:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09BDC05BD0A
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 08:43:54 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jX5AH-0004qo-3f; Fri, 08 May 2020 17:43:53 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jX5AB-0003WF-3E; Fri, 08 May 2020 17:43:47 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v3 0/5] microchip: add support for ksz88x3 driver family
Date:   Fri,  8 May 2020 17:43:38 +0200
Message-Id: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.26.2
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

Michael Grzeschik (4):
  dt-bindings: net: mdio-gpio: add compatible for microchip,mdio-smi0
  net: tag: ksz: Add KSZ8863 tag code
  ksz: Add Microchip KSZ8863 SMI/SPI based driver support
  dt-bindings: net: dsa: document additional Microchip KSZ8863/8873
    switch

 .../devicetree/bindings/net/dsa/ksz.txt       |   2 +
 .../devicetree/bindings/net/mdio-gpio.txt     |   1 +
 drivers/net/dsa/microchip/Kconfig             |   9 +
 drivers/net/dsa/microchip/Makefile            |   1 +
 drivers/net/dsa/microchip/ksz8.h              |  68 ++
 drivers/net/dsa/microchip/ksz8795.c           | 909 ++++++++++++------
 drivers/net/dsa/microchip/ksz8795_reg.h       | 214 +++--
 drivers/net/dsa/microchip/ksz8795_spi.c       |  83 +-
 drivers/net/dsa/microchip/ksz8863_reg.h       | 121 +++
 drivers/net/dsa/microchip/ksz8863_smi.c       | 186 ++++
 drivers/net/dsa/microchip/ksz_common.h        |   1 +
 drivers/net/phy/mdio-bitbang.c                |   7 +-
 drivers/net/phy/mdio-gpio.c                   |  13 +
 include/linux/mdio-bitbang.h                  |   2 +
 include/net/dsa.h                             |   2 +
 net/dsa/tag_ksz.c                             |  57 ++
 16 files changed, 1266 insertions(+), 410 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c

-- 
2.26.2

