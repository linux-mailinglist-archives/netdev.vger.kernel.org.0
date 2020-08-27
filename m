Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEBF253BC3
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 04:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgH0CA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 22:00:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54366 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgH0CAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 22:00:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kB7Dc-00C1gK-IS; Thu, 27 Aug 2020 04:00:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 0/5] Move MDIO drivers into their own directory
Date:   Thu, 27 Aug 2020 04:00:27 +0200
Message-Id: <20200827020032.2866339-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy subdirectory is getting cluttered. It has both PHY drivers and
MDIO drivers, plus a stray switch driver. Soon more PCS drivers are
likely to appear.

Move MDIO and PCS drivers into new directories. This requires fixing
up the xgene driver which uses a relative include path.

v2:
Move the subdirs to drivers/net, rather than drivers/net/phy.

v3:
Add subdirectories under include/linux for mdio and pcs

v4:
there->their
include path fix
No new kconfig prompts

Andrew Lunn (5):
  net: pcs: Move XPCS into new PCS subdirectory
  net/phy/mdio-i2c: Move header file to include/linux/mdio
  net: xgene: Move shared header file into include/linux
  net: mdio: Move MDIO drivers into a new subdirectory
  net: phy: Sort Kconfig and Makefile

 MAINTAINERS                                   |  12 +-
 drivers/net/Kconfig                           |   4 +
 drivers/net/Makefile                          |   2 +
 .../net/ethernet/apm/xgene/xgene_enet_main.h  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +-
 drivers/net/mdio/Kconfig                      | 241 +++++++++++
 drivers/net/mdio/Makefile                     |  27 ++
 drivers/net/{phy => mdio}/mdio-aspeed.c       |   0
 drivers/net/{phy => mdio}/mdio-bcm-iproc.c    |   0
 drivers/net/{phy => mdio}/mdio-bcm-unimac.c   |   0
 drivers/net/{phy => mdio}/mdio-bitbang.c      |   0
 drivers/net/{phy => mdio}/mdio-cavium.c       |   0
 drivers/net/{phy => mdio}/mdio-cavium.h       |   0
 drivers/net/{phy => mdio}/mdio-gpio.c         |   0
 drivers/net/{phy => mdio}/mdio-hisi-femac.c   |   0
 drivers/net/{phy => mdio}/mdio-i2c.c          |   3 +-
 drivers/net/{phy => mdio}/mdio-ipq4019.c      |   0
 drivers/net/{phy => mdio}/mdio-ipq8064.c      |   0
 drivers/net/{phy => mdio}/mdio-moxart.c       |   0
 drivers/net/{phy => mdio}/mdio-mscc-miim.c    |   0
 .../net/{phy => mdio}/mdio-mux-bcm-iproc.c    |   0
 drivers/net/{phy => mdio}/mdio-mux-gpio.c     |   0
 .../net/{phy => mdio}/mdio-mux-meson-g12a.c   |   0
 drivers/net/{phy => mdio}/mdio-mux-mmioreg.c  |   0
 .../net/{phy => mdio}/mdio-mux-multiplexer.c  |   0
 drivers/net/{phy => mdio}/mdio-mux.c          |   0
 drivers/net/{phy => mdio}/mdio-mvusb.c        |   0
 drivers/net/{phy => mdio}/mdio-octeon.c       |   0
 drivers/net/{phy => mdio}/mdio-sun4i.c        |   0
 drivers/net/{phy => mdio}/mdio-thunder.c      |   0
 drivers/net/{phy => mdio}/mdio-xgene.c        |   2 +-
 drivers/net/pcs/Kconfig                       |  20 +
 drivers/net/pcs/Makefile                      |   4 +
 .../net/{phy/mdio-xpcs.c => pcs/pcs-xpcs.c}   |   2 +-
 drivers/net/phy/Kconfig                       | 404 ++++--------------
 drivers/net/phy/Makefile                      |  37 +-
 drivers/net/phy/sfp.c                         |   2 +-
 .../net/phy => include/linux/mdio}/mdio-i2c.h |   0
 .../phy => include/linux/mdio}/mdio-xgene.h   |   0
 include/linux/{mdio-xpcs.h => pcs/pcs-xpcs.h} |   8 +-
 41 files changed, 405 insertions(+), 369 deletions(-)
 create mode 100644 drivers/net/mdio/Kconfig
 create mode 100644 drivers/net/mdio/Makefile
 rename drivers/net/{phy => mdio}/mdio-aspeed.c (100%)
 rename drivers/net/{phy => mdio}/mdio-bcm-iproc.c (100%)
 rename drivers/net/{phy => mdio}/mdio-bcm-unimac.c (100%)
 rename drivers/net/{phy => mdio}/mdio-bitbang.c (100%)
 rename drivers/net/{phy => mdio}/mdio-cavium.c (100%)
 rename drivers/net/{phy => mdio}/mdio-cavium.h (100%)
 rename drivers/net/{phy => mdio}/mdio-gpio.c (100%)
 rename drivers/net/{phy => mdio}/mdio-hisi-femac.c (100%)
 rename drivers/net/{phy => mdio}/mdio-i2c.c (98%)
 rename drivers/net/{phy => mdio}/mdio-ipq4019.c (100%)
 rename drivers/net/{phy => mdio}/mdio-ipq8064.c (100%)
 rename drivers/net/{phy => mdio}/mdio-moxart.c (100%)
 rename drivers/net/{phy => mdio}/mdio-mscc-miim.c (100%)
 rename drivers/net/{phy => mdio}/mdio-mux-bcm-iproc.c (100%)
 rename drivers/net/{phy => mdio}/mdio-mux-gpio.c (100%)
 rename drivers/net/{phy => mdio}/mdio-mux-meson-g12a.c (100%)
 rename drivers/net/{phy => mdio}/mdio-mux-mmioreg.c (100%)
 rename drivers/net/{phy => mdio}/mdio-mux-multiplexer.c (100%)
 rename drivers/net/{phy => mdio}/mdio-mux.c (100%)
 rename drivers/net/{phy => mdio}/mdio-mvusb.c (100%)
 rename drivers/net/{phy => mdio}/mdio-octeon.c (100%)
 rename drivers/net/{phy => mdio}/mdio-sun4i.c (100%)
 rename drivers/net/{phy => mdio}/mdio-thunder.c (100%)
 rename drivers/net/{phy => mdio}/mdio-xgene.c (99%)
 create mode 100644 drivers/net/pcs/Kconfig
 create mode 100644 drivers/net/pcs/Makefile
 rename drivers/net/{phy/mdio-xpcs.c => pcs/pcs-xpcs.c} (99%)
 rename {drivers/net/phy => include/linux/mdio}/mdio-i2c.h (100%)
 rename {drivers/net/phy => include/linux/mdio}/mdio-xgene.h (100%)
 rename include/linux/{mdio-xpcs.h => pcs/pcs-xpcs.h} (88%)

-- 
2.28.0

