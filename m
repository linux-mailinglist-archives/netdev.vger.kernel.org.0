Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAC522FA51
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgG0Uru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:47:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58088 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgG0Urq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 16:47:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0A2A-0079fT-Ei; Mon, 27 Jul 2020 22:47:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
Date:   Mon, 27 Jul 2020 22:47:28 +0200
Message-Id: <20200727204731.1705418-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC Because it needs 0-day build testing

The directory drivers/net/phy is getting rather cluttered with the
growing number of MDIO bus drivers and PHY device drivers. We also
have one PCS driver and more are expected soon.

Restructure the directory, moving MDIO bus drivers into /mdio.  PHY
drivers into /phy. The one current PCS driver is moved into /pcs and
renamed to give it the pcs- prefix which we hope will be followed by
other PCS drivers.

Andrew Lunn (3):
  net: xgene: Move shared header file into include/linux
  net: phy: Move into subdirectories
  net: phy: Move and rename mdio-xpcs

 .../net/ethernet/apm/xgene/xgene_enet_main.h  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +-
 drivers/net/phy/Kconfig                       | 489 +-----------------
 drivers/net/phy/Makefile                      |  79 +--
 drivers/net/phy/mdio/Kconfig                  | 226 ++++++++
 drivers/net/phy/mdio/Makefile                 |  26 +
 drivers/net/phy/{ => mdio}/mdio-aspeed.c      |   0
 drivers/net/phy/{ => mdio}/mdio-bcm-iproc.c   |   0
 drivers/net/phy/{ => mdio}/mdio-bcm-unimac.c  |   0
 drivers/net/phy/{ => mdio}/mdio-bitbang.c     |   0
 drivers/net/phy/{ => mdio}/mdio-cavium.c      |   0
 drivers/net/phy/{ => mdio}/mdio-cavium.h      |   0
 drivers/net/phy/{ => mdio}/mdio-gpio.c        |   0
 drivers/net/phy/{ => mdio}/mdio-hisi-femac.c  |   0
 drivers/net/phy/{ => mdio}/mdio-ipq4019.c     |   0
 drivers/net/phy/{ => mdio}/mdio-ipq8064.c     |   0
 drivers/net/phy/{ => mdio}/mdio-moxart.c      |   0
 drivers/net/phy/{ => mdio}/mdio-mscc-miim.c   |   0
 .../net/phy/{ => mdio}/mdio-mux-bcm-iproc.c   |   0
 drivers/net/phy/{ => mdio}/mdio-mux-gpio.c    |   0
 .../net/phy/{ => mdio}/mdio-mux-meson-g12a.c  |   0
 drivers/net/phy/{ => mdio}/mdio-mux-mmioreg.c |   0
 .../net/phy/{ => mdio}/mdio-mux-multiplexer.c |   0
 drivers/net/phy/{ => mdio}/mdio-mux.c         |   0
 drivers/net/phy/{ => mdio}/mdio-mvusb.c       |   0
 drivers/net/phy/{ => mdio}/mdio-octeon.c      |   0
 drivers/net/phy/{ => mdio}/mdio-sun4i.c       |   0
 drivers/net/phy/{ => mdio}/mdio-thunder.c     |   0
 drivers/net/phy/{ => mdio}/mdio-xgene.c       |   2 +-
 drivers/net/phy/pcs/Kconfig                   |  20 +
 drivers/net/phy/pcs/Makefile                  |   4 +
 .../net/phy/{mdio-xpcs.c => pcs/pcs-xpcs.c}   |   2 +-
 drivers/net/phy/phy/Kconfig                   | 243 +++++++++
 drivers/net/phy/phy/Makefile                  |  50 ++
 drivers/net/phy/{ => phy}/adin.c              |   0
 drivers/net/phy/{ => phy}/amd.c               |   0
 drivers/net/phy/{ => phy}/aquantia.h          |   0
 drivers/net/phy/{ => phy}/aquantia_hwmon.c    |   0
 drivers/net/phy/{ => phy}/aquantia_main.c     |   0
 drivers/net/phy/{ => phy}/at803x.c            |   0
 drivers/net/phy/{ => phy}/ax88796b.c          |   0
 drivers/net/phy/{ => phy}/bcm-cygnus.c        |   0
 drivers/net/phy/{ => phy}/bcm-phy-lib.c       |   0
 drivers/net/phy/{ => phy}/bcm-phy-lib.h       |   0
 drivers/net/phy/{ => phy}/bcm54140.c          |   0
 drivers/net/phy/{ => phy}/bcm63xx.c           |   0
 drivers/net/phy/{ => phy}/bcm7xxx.c           |   0
 drivers/net/phy/{ => phy}/bcm84881.c          |   0
 drivers/net/phy/{ => phy}/bcm87xx.c           |   0
 drivers/net/phy/{ => phy}/broadcom.c          |   0
 drivers/net/phy/{ => phy}/cicada.c            |   0
 drivers/net/phy/{ => phy}/cortina.c           |   0
 drivers/net/phy/{ => phy}/davicom.c           |   0
 drivers/net/phy/{ => phy}/dp83640.c           |   0
 drivers/net/phy/{ => phy}/dp83640_reg.h       |   0
 drivers/net/phy/{ => phy}/dp83822.c           |   0
 drivers/net/phy/{ => phy}/dp83848.c           |   0
 drivers/net/phy/{ => phy}/dp83867.c           |   0
 drivers/net/phy/{ => phy}/dp83869.c           |   0
 drivers/net/phy/{ => phy}/dp83tc811.c         |   0
 drivers/net/phy/{ => phy}/et1011c.c           |   0
 drivers/net/phy/{ => phy}/icplus.c            |   0
 drivers/net/phy/{ => phy}/intel-xway.c        |   0
 drivers/net/phy/{ => phy}/lxt.c               |   0
 drivers/net/phy/{ => phy}/marvell.c           |   0
 drivers/net/phy/{ => phy}/marvell10g.c        |   0
 drivers/net/phy/{ => phy}/meson-gxl.c         |   0
 drivers/net/phy/{ => phy}/micrel.c            |   0
 drivers/net/phy/{ => phy}/microchip.c         |   0
 drivers/net/phy/{ => phy}/microchip_t1.c      |   0
 drivers/net/phy/{ => phy}/mscc/Makefile       |   0
 drivers/net/phy/{ => phy}/mscc/mscc.h         |   0
 .../net/phy/{ => phy}/mscc/mscc_fc_buffer.h   |   0
 drivers/net/phy/{ => phy}/mscc/mscc_mac.h     |   0
 drivers/net/phy/{ => phy}/mscc/mscc_macsec.c  |   0
 drivers/net/phy/{ => phy}/mscc/mscc_macsec.h  |   0
 drivers/net/phy/{ => phy}/mscc/mscc_main.c    |   0
 drivers/net/phy/{ => phy}/national.c          |   0
 drivers/net/phy/{ => phy}/nxp-tja11xx.c       |   0
 drivers/net/phy/{ => phy}/qsemi.c             |   0
 drivers/net/phy/{ => phy}/realtek.c           |   0
 drivers/net/phy/{ => phy}/rockchip.c          |   0
 drivers/net/phy/{ => phy}/smsc.c              |   0
 drivers/net/phy/{ => phy}/ste10Xp.c           |   0
 drivers/net/phy/{ => phy}/teranetics.c        |   0
 drivers/net/phy/{ => phy}/uPD60620.c          |   0
 drivers/net/phy/{ => phy}/vitesse.c           |   0
 .../net/phy => include/linux}/mdio-xgene.h    |   0
 include/linux/{mdio-xpcs.h => pcs-xpcs.h}     |   8 +-
 90 files changed, 594 insertions(+), 561 deletions(-)
 create mode 100644 drivers/net/phy/mdio/Kconfig
 create mode 100644 drivers/net/phy/mdio/Makefile
 rename drivers/net/phy/{ => mdio}/mdio-aspeed.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-bcm-iproc.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-bcm-unimac.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-bitbang.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-cavium.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-cavium.h (100%)
 rename drivers/net/phy/{ => mdio}/mdio-gpio.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-hisi-femac.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-ipq4019.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-ipq8064.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-moxart.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-mscc-miim.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-mux-bcm-iproc.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-mux-gpio.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-mux-meson-g12a.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-mux-mmioreg.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-mux-multiplexer.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-mux.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-mvusb.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-octeon.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-sun4i.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-thunder.c (100%)
 rename drivers/net/phy/{ => mdio}/mdio-xgene.c (99%)
 create mode 100644 drivers/net/phy/pcs/Kconfig
 create mode 100644 drivers/net/phy/pcs/Makefile
 rename drivers/net/phy/{mdio-xpcs.c => pcs/pcs-xpcs.c} (99%)
 create mode 100644 drivers/net/phy/phy/Kconfig
 create mode 100644 drivers/net/phy/phy/Makefile
 rename drivers/net/phy/{ => phy}/adin.c (100%)
 rename drivers/net/phy/{ => phy}/amd.c (100%)
 rename drivers/net/phy/{ => phy}/aquantia.h (100%)
 rename drivers/net/phy/{ => phy}/aquantia_hwmon.c (100%)
 rename drivers/net/phy/{ => phy}/aquantia_main.c (100%)
 rename drivers/net/phy/{ => phy}/at803x.c (100%)
 rename drivers/net/phy/{ => phy}/ax88796b.c (100%)
 rename drivers/net/phy/{ => phy}/bcm-cygnus.c (100%)
 rename drivers/net/phy/{ => phy}/bcm-phy-lib.c (100%)
 rename drivers/net/phy/{ => phy}/bcm-phy-lib.h (100%)
 rename drivers/net/phy/{ => phy}/bcm54140.c (100%)
 rename drivers/net/phy/{ => phy}/bcm63xx.c (100%)
 rename drivers/net/phy/{ => phy}/bcm7xxx.c (100%)
 rename drivers/net/phy/{ => phy}/bcm84881.c (100%)
 rename drivers/net/phy/{ => phy}/bcm87xx.c (100%)
 rename drivers/net/phy/{ => phy}/broadcom.c (100%)
 rename drivers/net/phy/{ => phy}/cicada.c (100%)
 rename drivers/net/phy/{ => phy}/cortina.c (100%)
 rename drivers/net/phy/{ => phy}/davicom.c (100%)
 rename drivers/net/phy/{ => phy}/dp83640.c (100%)
 rename drivers/net/phy/{ => phy}/dp83640_reg.h (100%)
 rename drivers/net/phy/{ => phy}/dp83822.c (100%)
 rename drivers/net/phy/{ => phy}/dp83848.c (100%)
 rename drivers/net/phy/{ => phy}/dp83867.c (100%)
 rename drivers/net/phy/{ => phy}/dp83869.c (100%)
 rename drivers/net/phy/{ => phy}/dp83tc811.c (100%)
 rename drivers/net/phy/{ => phy}/et1011c.c (100%)
 rename drivers/net/phy/{ => phy}/icplus.c (100%)
 rename drivers/net/phy/{ => phy}/intel-xway.c (100%)
 rename drivers/net/phy/{ => phy}/lxt.c (100%)
 rename drivers/net/phy/{ => phy}/marvell.c (100%)
 rename drivers/net/phy/{ => phy}/marvell10g.c (100%)
 rename drivers/net/phy/{ => phy}/meson-gxl.c (100%)
 rename drivers/net/phy/{ => phy}/micrel.c (100%)
 rename drivers/net/phy/{ => phy}/microchip.c (100%)
 rename drivers/net/phy/{ => phy}/microchip_t1.c (100%)
 rename drivers/net/phy/{ => phy}/mscc/Makefile (100%)
 rename drivers/net/phy/{ => phy}/mscc/mscc.h (100%)
 rename drivers/net/phy/{ => phy}/mscc/mscc_fc_buffer.h (100%)
 rename drivers/net/phy/{ => phy}/mscc/mscc_mac.h (100%)
 rename drivers/net/phy/{ => phy}/mscc/mscc_macsec.c (100%)
 rename drivers/net/phy/{ => phy}/mscc/mscc_macsec.h (100%)
 rename drivers/net/phy/{ => phy}/mscc/mscc_main.c (100%)
 rename drivers/net/phy/{ => phy}/national.c (100%)
 rename drivers/net/phy/{ => phy}/nxp-tja11xx.c (100%)
 rename drivers/net/phy/{ => phy}/qsemi.c (100%)
 rename drivers/net/phy/{ => phy}/realtek.c (100%)
 rename drivers/net/phy/{ => phy}/rockchip.c (100%)
 rename drivers/net/phy/{ => phy}/smsc.c (100%)
 rename drivers/net/phy/{ => phy}/ste10Xp.c (100%)
 rename drivers/net/phy/{ => phy}/teranetics.c (100%)
 rename drivers/net/phy/{ => phy}/uPD60620.c (100%)
 rename drivers/net/phy/{ => phy}/vitesse.c (100%)
 rename {drivers/net/phy => include/linux}/mdio-xgene.h (100%)
 rename include/linux/{mdio-xpcs.h => pcs-xpcs.h} (88%)

-- 
2.28.0.rc0

