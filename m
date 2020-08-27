Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD06253BC4
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 04:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgH0CBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 22:01:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54386 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbgH0CBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 22:01:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kB7Dc-00C1gU-NK; Thu, 27 Aug 2020 04:00:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 4/5] net: mdio: Move MDIO drivers into a new subdirectory
Date:   Thu, 27 Aug 2020 04:00:31 +0200
Message-Id: <20200827020032.2866339-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200827020032.2866339-1-andrew@lunn.ch>
References: <20200827020032.2866339-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move all the MDIO drivers and multiplexers into drivers/net/mdio.  The
mdio core is however left in the phy directory, due to mutual
dependencies between the MDIO core and the PHY core.

Take this opportunity to sort the Kconfig based on the menuconfig
strings, and move the multiplexers to the end with a separating
comment.

v2:
Fix typo in commit message

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 MAINTAINERS                                   |   6 +-
 drivers/net/Kconfig                           |   2 +
 drivers/net/Makefile                          |   1 +
 drivers/net/mdio/Kconfig                      | 241 ++++++++++++++++++
 drivers/net/mdio/Makefile                     |  27 ++
 drivers/net/{phy => mdio}/mdio-aspeed.c       |   0
 drivers/net/{phy => mdio}/mdio-bcm-iproc.c    |   0
 drivers/net/{phy => mdio}/mdio-bcm-unimac.c   |   0
 drivers/net/{phy => mdio}/mdio-bitbang.c      |   0
 drivers/net/{phy => mdio}/mdio-cavium.c       |   0
 drivers/net/{phy => mdio}/mdio-cavium.h       |   0
 drivers/net/{phy => mdio}/mdio-gpio.c         |   0
 drivers/net/{phy => mdio}/mdio-hisi-femac.c   |   0
 drivers/net/{phy => mdio}/mdio-i2c.c          |   0
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
 drivers/net/{phy => mdio}/mdio-xgene.c        |   0
 drivers/net/phy/Kconfig                       | 234 -----------------
 drivers/net/phy/Makefile                      |  26 +-
 31 files changed, 276 insertions(+), 261 deletions(-)
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
 rename drivers/net/{phy => mdio}/mdio-i2c.c (100%)
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
 rename drivers/net/{phy => mdio}/mdio-xgene.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index af25e8d003e7..b0e909937499 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1286,7 +1286,7 @@ S:	Supported
 F:	Documentation/devicetree/bindings/net/apm-xgene-enet.txt
 F:	Documentation/devicetree/bindings/net/apm-xgene-mdio.txt
 F:	drivers/net/ethernet/apm/xgene/
-F:	drivers/net/phy/mdio-xgene.c
+F:	drivers/net/mdio/mdio-xgene.c
 
 APPLIED MICRO (APM) X-GENE SOC PMU
 M:	Khuong Dinh <khuong@os.amperecomputing.com>
@@ -6513,12 +6513,14 @@ F:	Documentation/devicetree/bindings/net/ethernet-phy.yaml
 F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
+F:	drivers/net/mdio/
 F:	drivers/net/pcs/
 F:	drivers/net/phy/
 F:	drivers/of/of_mdio.c
 F:	drivers/of/of_net.c
 F:	include/dt-bindings/net/qca-ar803x.h
 F:	include/linux/*mdio*.h
+F:	include/linux/mdio/*.h
 F:	include/linux/of_net.h
 F:	include/linux/phy.h
 F:	include/linux/phy_fixed.h
@@ -10498,7 +10500,7 @@ M:	Tobias Waldekranz <tobias@waldekranz.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/marvell,mvusb.yaml
-F:	drivers/net/phy/mdio-mvusb.c
+F:	drivers/net/mdio/mdio-mvusb.c
 
 MARVELL XENON MMC/SD/SDIO HOST CONTROLLER DRIVER
 M:	Hu Ziji <huziji@marvell.com>
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 2b07566de78c..c3dbe64e628e 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -473,6 +473,8 @@ config NET_SB1000
 
 source "drivers/net/phy/Kconfig"
 
+source "drivers/net/mdio/Kconfig"
+
 source "drivers/net/pcs/Kconfig"
 
 source "drivers/net/plip/Kconfig"
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index f7402d766b67..72e18d505d1a 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_MDIO) += mdio.o
 obj-$(CONFIG_NET) += Space.o loopback.o
 obj-$(CONFIG_NETCONSOLE) += netconsole.o
 obj-y += phy/
+obj-y += mdio/
 obj-y += pcs/
 obj-$(CONFIG_RIONET) += rionet.o
 obj-$(CONFIG_NET_TEAM) += team/
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
new file mode 100644
index 000000000000..1299880dfe74
--- /dev/null
+++ b/drivers/net/mdio/Kconfig
@@ -0,0 +1,241 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# MDIO Layer Configuration
+#
+
+menuconfig MDIO_DEVICE
+	tristate "MDIO bus device drivers"
+	help
+	  MDIO devices and driver infrastructure code.
+
+if MDIO_DEVICE
+
+config MDIO_BUS
+	tristate
+	default m if PHYLIB=m
+	default MDIO_DEVICE
+	help
+	  This internal symbol is used for link time dependencies and it
+	  reflects whether the mdio_bus/mdio_device code is built as a
+	  loadable module or built-in.
+
+if MDIO_BUS
+
+config MDIO_DEVRES
+	tristate
+
+config MDIO_SUN4I
+	tristate "Allwinner sun4i MDIO interface support"
+	depends on ARCH_SUNXI || COMPILE_TEST
+	help
+	  This driver supports the MDIO interface found in the network
+	  interface units of the Allwinner SoC that have an EMAC (A10,
+	  A12, A10s, etc.)
+
+config MDIO_XGENE
+	tristate "APM X-Gene SoC MDIO bus controller"
+	depends on ARCH_XGENE || COMPILE_TEST
+	help
+	  This module provides a driver for the MDIO busses found in the
+	  APM X-Gene SoC's.
+
+config MDIO_ASPEED
+	tristate "ASPEED MDIO bus controller"
+	depends on ARCH_ASPEED || COMPILE_TEST
+	depends on OF_MDIO && HAS_IOMEM
+	help
+	  This module provides a driver for the independent MDIO bus
+	  controllers found in the ASPEED AST2600 SoC. This is a driver for the
+	  third revision of the ASPEED MDIO register interface - the first two
+	  revisions are the "old" and "new" interfaces found in the AST2400 and
+	  AST2500, embedded in the MAC. For legacy reasons, FTGMAC100 driver
+	  continues to drive the embedded MDIO controller for the AST2400 and
+	  AST2500 SoCs, so say N if AST2600 support is not required.
+
+config MDIO_BITBANG
+	tristate "Bitbanged MDIO buses"
+	help
+	  This module implements the MDIO bus protocol in software,
+	  for use by low level drivers that export the ability to
+	  drive the relevant pins.
+
+	  If in doubt, say N.
+
+config MDIO_BCM_IPROC
+	tristate "Broadcom iProc MDIO bus controller"
+	depends on ARCH_BCM_IPROC || COMPILE_TEST
+	depends on HAS_IOMEM && OF_MDIO
+	default ARCH_BCM_IPROC
+	help
+	  This module provides a driver for the MDIO busses found in the
+	  Broadcom iProc SoC's.
+
+config MDIO_BCM_UNIMAC
+	tristate "Broadcom UniMAC MDIO bus controller"
+	depends on HAS_IOMEM
+	help
+	  This module provides a driver for the Broadcom UniMAC MDIO busses.
+	  This hardware can be found in the Broadcom GENET Ethernet MAC
+	  controllers as well as some Broadcom Ethernet switches such as the
+	  Starfighter 2 switches.
+
+config MDIO_CAVIUM
+	tristate
+
+config MDIO_GPIO
+	tristate "GPIO lib-based bitbanged MDIO buses"
+	depends on MDIO_BITBANG
+	depends on GPIOLIB || COMPILE_TEST
+	help
+	  Supports GPIO lib-based MDIO busses.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called mdio-gpio.
+
+config MDIO_HISI_FEMAC
+	tristate "Hisilicon FEMAC MDIO bus controller"
+	depends on HAS_IOMEM && OF_MDIO
+	help
+	  This module provides a driver for the MDIO busses found in the
+	  Hisilicon SoC that have an Fast Ethernet MAC.
+
+config MDIO_I2C
+	tristate
+	depends on I2C
+	help
+	  Support I2C based PHYs.  This provides a MDIO bus bridged
+	  to I2C to allow PHYs connected in I2C mode to be accessed
+	  using the existing infrastructure.
+
+	  This is library mode.
+
+config MDIO_MVUSB
+	tristate "Marvell USB to MDIO Adapter"
+	depends on USB
+	select MDIO_DEVRES
+	help
+	  A USB to MDIO converter present on development boards for
+	  Marvell's Link Street family of Ethernet switches.
+
+config MDIO_MSCC_MIIM
+	tristate "Microsemi MIIM interface support"
+	depends on HAS_IOMEM
+	select MDIO_DEVRES
+	help
+	  This driver supports the MIIM (MDIO) interface found in the network
+	  switches of the Microsemi SoCs; it is recommended to switch on
+	  CONFIG_HIGH_RES_TIMERS
+
+config MDIO_MOXART
+	tristate "MOXA ART MDIO interface support"
+	depends on ARCH_MOXART || COMPILE_TEST
+	help
+	  This driver supports the MDIO interface found in the network
+	  interface units of the MOXA ART SoC
+
+config MDIO_OCTEON
+	tristate "Octeon and some ThunderX SOCs MDIO buses"
+	depends on (64BIT && OF_MDIO) || COMPILE_TEST
+	depends on HAS_IOMEM
+	select MDIO_CAVIUM
+	help
+	  This module provides a driver for the Octeon and ThunderX MDIO
+	  buses. It is required by the Octeon and ThunderX ethernet device
+	  drivers on some systems.
+
+config MDIO_IPQ4019
+	tristate "Qualcomm IPQ4019 MDIO interface support"
+	depends on HAS_IOMEM && OF_MDIO
+	help
+	  This driver supports the MDIO interface found in Qualcomm
+	  IPQ40xx series Soc-s.
+
+config MDIO_IPQ8064
+	tristate "Qualcomm IPQ8064 MDIO interface support"
+	depends on HAS_IOMEM && OF_MDIO
+	depends on MFD_SYSCON
+	help
+	  This driver supports the MDIO interface found in the network
+	  interface units of the IPQ8064 SoC
+
+config MDIO_THUNDER
+	tristate "ThunderX SOCs MDIO buses"
+	depends on 64BIT
+	depends on PCI
+	select MDIO_CAVIUM
+	help
+	  This driver supports the MDIO interfaces found on Cavium
+	  ThunderX SoCs when the MDIO bus device appears as a PCI
+	  device.
+
+comment "MDIO Multiplexers"
+
+config MDIO_BUS_MUX
+	tristate
+	depends on OF_MDIO
+	help
+	  This module provides a driver framework for MDIO bus
+	  multiplexers which connect one of several child MDIO busses
+	  to a parent bus.  Switching between child busses is done by
+	  device specific drivers.
+
+config MDIO_BUS_MUX_MESON_G12A
+	tristate "Amlogic G12a based MDIO bus multiplexer"
+	depends on ARCH_MESON || COMPILE_TEST
+	depends on OF_MDIO && HAS_IOMEM && COMMON_CLK
+	select MDIO_BUS_MUX
+	default m if ARCH_MESON
+	help
+	  This module provides a driver for the MDIO multiplexer/glue of
+	  the amlogic g12a SoC. The multiplexers connects either the external
+	  or the internal MDIO bus to the parent bus.
+
+config MDIO_BUS_MUX_BCM_IPROC
+	tristate "Broadcom iProc based MDIO bus multiplexers"
+	depends on OF && OF_MDIO && (ARCH_BCM_IPROC || COMPILE_TEST)
+	select MDIO_BUS_MUX
+	default ARCH_BCM_IPROC
+	help
+	  This module provides a driver for MDIO bus multiplexers found in
+	  iProc based Broadcom SoCs. This multiplexer connects one of several
+	  child MDIO bus to a parent bus. Buses could be internal as well as
+	  external and selection logic lies inside the same multiplexer.
+
+config MDIO_BUS_MUX_GPIO
+	tristate "GPIO controlled MDIO bus multiplexers"
+	depends on OF_GPIO && OF_MDIO
+	select MDIO_BUS_MUX
+	help
+	  This module provides a driver for MDIO bus multiplexers that
+	  are controlled via GPIO lines.  The multiplexer connects one of
+	  several child MDIO busses to a parent bus.  Child bus
+	  selection is under the control of GPIO lines.
+
+config MDIO_BUS_MUX_MULTIPLEXER
+	tristate "MDIO bus multiplexer using kernel multiplexer subsystem"
+	depends on OF_MDIO
+	select MULTIPLEXER
+	select MDIO_BUS_MUX
+	help
+	  This module provides a driver for MDIO bus multiplexer
+	  that is controlled via the kernel multiplexer subsystem. The
+	  bus multiplexer connects one of several child MDIO busses to
+	  a parent bus.  Child bus selection is under the control of
+	  the kernel multiplexer subsystem.
+
+config MDIO_BUS_MUX_MMIOREG
+	tristate "MMIO device-controlled MDIO bus multiplexers"
+	depends on OF_MDIO && HAS_IOMEM
+	select MDIO_BUS_MUX
+	help
+	  This module provides a driver for MDIO bus multiplexers that
+	  are controlled via a simple memory-mapped device, like an FPGA.
+	  The multiplexer connects one of several child MDIO busses to a
+	  parent bus.  Child bus selection is under the control of one of
+	  the FPGA's registers.
+
+	  Currently, only 8/16/32 bits registers are supported.
+
+
+endif
+endif
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
new file mode 100644
index 000000000000..14d1beb633c9
--- /dev/null
+++ b/drivers/net/mdio/Makefile
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for Linux MDIO bus drivers
+
+obj-$(CONFIG_MDIO_ASPEED)		+= mdio-aspeed.o
+obj-$(CONFIG_MDIO_BCM_IPROC)		+= mdio-bcm-iproc.o
+obj-$(CONFIG_MDIO_BCM_UNIMAC)		+= mdio-bcm-unimac.o
+obj-$(CONFIG_MDIO_BITBANG)		+= mdio-bitbang.o
+obj-$(CONFIG_MDIO_CAVIUM)		+= mdio-cavium.o
+obj-$(CONFIG_MDIO_GPIO)			+= mdio-gpio.o
+obj-$(CONFIG_MDIO_HISI_FEMAC)		+= mdio-hisi-femac.o
+obj-$(CONFIG_MDIO_I2C)			+= mdio-i2c.o
+obj-$(CONFIG_MDIO_IPQ4019)		+= mdio-ipq4019.o
+obj-$(CONFIG_MDIO_IPQ8064)		+= mdio-ipq8064.o
+obj-$(CONFIG_MDIO_MOXART)		+= mdio-moxart.o
+obj-$(CONFIG_MDIO_MSCC_MIIM)		+= mdio-mscc-miim.o
+obj-$(CONFIG_MDIO_MVUSB)		+= mdio-mvusb.o
+obj-$(CONFIG_MDIO_OCTEON)		+= mdio-octeon.o
+obj-$(CONFIG_MDIO_SUN4I)		+= mdio-sun4i.o
+obj-$(CONFIG_MDIO_THUNDER)		+= mdio-thunder.o
+obj-$(CONFIG_MDIO_XGENE)		+= mdio-xgene.o
+
+obj-$(CONFIG_MDIO_BUS_MUX)		+= mdio-mux.o
+obj-$(CONFIG_MDIO_BUS_MUX_BCM_IPROC)	+= mdio-mux-bcm-iproc.o
+obj-$(CONFIG_MDIO_BUS_MUX_GPIO)		+= mdio-mux-gpio.o
+obj-$(CONFIG_MDIO_BUS_MUX_MESON_G12A)	+= mdio-mux-meson-g12a.o
+obj-$(CONFIG_MDIO_BUS_MUX_MMIOREG) 	+= mdio-mux-mmioreg.o
+obj-$(CONFIG_MDIO_BUS_MUX_MULTIPLEXER) 	+= mdio-mux-multiplexer.o
diff --git a/drivers/net/phy/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
similarity index 100%
rename from drivers/net/phy/mdio-aspeed.c
rename to drivers/net/mdio/mdio-aspeed.c
diff --git a/drivers/net/phy/mdio-bcm-iproc.c b/drivers/net/mdio/mdio-bcm-iproc.c
similarity index 100%
rename from drivers/net/phy/mdio-bcm-iproc.c
rename to drivers/net/mdio/mdio-bcm-iproc.c
diff --git a/drivers/net/phy/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
similarity index 100%
rename from drivers/net/phy/mdio-bcm-unimac.c
rename to drivers/net/mdio/mdio-bcm-unimac.c
diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/mdio/mdio-bitbang.c
similarity index 100%
rename from drivers/net/phy/mdio-bitbang.c
rename to drivers/net/mdio/mdio-bitbang.c
diff --git a/drivers/net/phy/mdio-cavium.c b/drivers/net/mdio/mdio-cavium.c
similarity index 100%
rename from drivers/net/phy/mdio-cavium.c
rename to drivers/net/mdio/mdio-cavium.c
diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/mdio/mdio-cavium.h
similarity index 100%
rename from drivers/net/phy/mdio-cavium.h
rename to drivers/net/mdio/mdio-cavium.h
diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/mdio/mdio-gpio.c
similarity index 100%
rename from drivers/net/phy/mdio-gpio.c
rename to drivers/net/mdio/mdio-gpio.c
diff --git a/drivers/net/phy/mdio-hisi-femac.c b/drivers/net/mdio/mdio-hisi-femac.c
similarity index 100%
rename from drivers/net/phy/mdio-hisi-femac.c
rename to drivers/net/mdio/mdio-hisi-femac.c
diff --git a/drivers/net/phy/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
similarity index 100%
rename from drivers/net/phy/mdio-i2c.c
rename to drivers/net/mdio/mdio-i2c.c
diff --git a/drivers/net/phy/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
similarity index 100%
rename from drivers/net/phy/mdio-ipq4019.c
rename to drivers/net/mdio/mdio-ipq4019.c
diff --git a/drivers/net/phy/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
similarity index 100%
rename from drivers/net/phy/mdio-ipq8064.c
rename to drivers/net/mdio/mdio-ipq8064.c
diff --git a/drivers/net/phy/mdio-moxart.c b/drivers/net/mdio/mdio-moxart.c
similarity index 100%
rename from drivers/net/phy/mdio-moxart.c
rename to drivers/net/mdio/mdio-moxart.c
diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
similarity index 100%
rename from drivers/net/phy/mdio-mscc-miim.c
rename to drivers/net/mdio/mdio-mscc-miim.c
diff --git a/drivers/net/phy/mdio-mux-bcm-iproc.c b/drivers/net/mdio/mdio-mux-bcm-iproc.c
similarity index 100%
rename from drivers/net/phy/mdio-mux-bcm-iproc.c
rename to drivers/net/mdio/mdio-mux-bcm-iproc.c
diff --git a/drivers/net/phy/mdio-mux-gpio.c b/drivers/net/mdio/mdio-mux-gpio.c
similarity index 100%
rename from drivers/net/phy/mdio-mux-gpio.c
rename to drivers/net/mdio/mdio-mux-gpio.c
diff --git a/drivers/net/phy/mdio-mux-meson-g12a.c b/drivers/net/mdio/mdio-mux-meson-g12a.c
similarity index 100%
rename from drivers/net/phy/mdio-mux-meson-g12a.c
rename to drivers/net/mdio/mdio-mux-meson-g12a.c
diff --git a/drivers/net/phy/mdio-mux-mmioreg.c b/drivers/net/mdio/mdio-mux-mmioreg.c
similarity index 100%
rename from drivers/net/phy/mdio-mux-mmioreg.c
rename to drivers/net/mdio/mdio-mux-mmioreg.c
diff --git a/drivers/net/phy/mdio-mux-multiplexer.c b/drivers/net/mdio/mdio-mux-multiplexer.c
similarity index 100%
rename from drivers/net/phy/mdio-mux-multiplexer.c
rename to drivers/net/mdio/mdio-mux-multiplexer.c
diff --git a/drivers/net/phy/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
similarity index 100%
rename from drivers/net/phy/mdio-mux.c
rename to drivers/net/mdio/mdio-mux.c
diff --git a/drivers/net/phy/mdio-mvusb.c b/drivers/net/mdio/mdio-mvusb.c
similarity index 100%
rename from drivers/net/phy/mdio-mvusb.c
rename to drivers/net/mdio/mdio-mvusb.c
diff --git a/drivers/net/phy/mdio-octeon.c b/drivers/net/mdio/mdio-octeon.c
similarity index 100%
rename from drivers/net/phy/mdio-octeon.c
rename to drivers/net/mdio/mdio-octeon.c
diff --git a/drivers/net/phy/mdio-sun4i.c b/drivers/net/mdio/mdio-sun4i.c
similarity index 100%
rename from drivers/net/phy/mdio-sun4i.c
rename to drivers/net/mdio/mdio-sun4i.c
diff --git a/drivers/net/phy/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
similarity index 100%
rename from drivers/net/phy/mdio-thunder.c
rename to drivers/net/mdio/mdio-thunder.c
diff --git a/drivers/net/phy/mdio-xgene.c b/drivers/net/mdio/mdio-xgene.c
similarity index 100%
rename from drivers/net/phy/mdio-xgene.c
rename to drivers/net/mdio/mdio-xgene.c
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index c69cc806f064..20252d7487db 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -3,240 +3,6 @@
 # PHY Layer Configuration
 #
 
-menuconfig MDIO_DEVICE
-	tristate "MDIO bus device drivers"
-	help
-	  MDIO devices and driver infrastructure code.
-
-if MDIO_DEVICE
-
-config MDIO_BUS
-	tristate
-	default m if PHYLIB=m
-	default MDIO_DEVICE
-	help
-	  This internal symbol is used for link time dependencies and it
-	  reflects whether the mdio_bus/mdio_device code is built as a
-	  loadable module or built-in.
-
-if MDIO_BUS
-
-config MDIO_DEVRES
-	tristate
-
-config MDIO_ASPEED
-	tristate "ASPEED MDIO bus controller"
-	depends on ARCH_ASPEED || COMPILE_TEST
-	depends on OF_MDIO && HAS_IOMEM
-	help
-	  This module provides a driver for the independent MDIO bus
-	  controllers found in the ASPEED AST2600 SoC. This is a driver for the
-	  third revision of the ASPEED MDIO register interface - the first two
-	  revisions are the "old" and "new" interfaces found in the AST2400 and
-	  AST2500, embedded in the MAC. For legacy reasons, FTGMAC100 driver
-	  continues to drive the embedded MDIO controller for the AST2400 and
-	  AST2500 SoCs, so say N if AST2600 support is not required.
-
-config MDIO_BCM_IPROC
-	tristate "Broadcom iProc MDIO bus controller"
-	depends on ARCH_BCM_IPROC || COMPILE_TEST
-	depends on HAS_IOMEM && OF_MDIO
-	default ARCH_BCM_IPROC
-	help
-	  This module provides a driver for the MDIO busses found in the
-	  Broadcom iProc SoC's.
-
-config MDIO_BCM_UNIMAC
-	tristate "Broadcom UniMAC MDIO bus controller"
-	depends on HAS_IOMEM
-	help
-	  This module provides a driver for the Broadcom UniMAC MDIO busses.
-	  This hardware can be found in the Broadcom GENET Ethernet MAC
-	  controllers as well as some Broadcom Ethernet switches such as the
-	  Starfighter 2 switches.
-
-config MDIO_BITBANG
-	tristate "Bitbanged MDIO buses"
-	help
-	  This module implements the MDIO bus protocol in software,
-	  for use by low level drivers that export the ability to
-	  drive the relevant pins.
-
-	  If in doubt, say N.
-
-config MDIO_BUS_MUX
-	tristate
-	depends on OF_MDIO
-	help
-	  This module provides a driver framework for MDIO bus
-	  multiplexers which connect one of several child MDIO busses
-	  to a parent bus.  Switching between child busses is done by
-	  device specific drivers.
-
-config MDIO_BUS_MUX_BCM_IPROC
-	tristate "Broadcom iProc based MDIO bus multiplexers"
-	depends on OF && OF_MDIO && (ARCH_BCM_IPROC || COMPILE_TEST)
-	select MDIO_BUS_MUX
-	default ARCH_BCM_IPROC
-	help
-	  This module provides a driver for MDIO bus multiplexers found in
-	  iProc based Broadcom SoCs. This multiplexer connects one of several
-	  child MDIO bus to a parent bus. Buses could be internal as well as
-	  external and selection logic lies inside the same multiplexer.
-
-config MDIO_BUS_MUX_GPIO
-	tristate "GPIO controlled MDIO bus multiplexers"
-	depends on OF_GPIO && OF_MDIO
-	select MDIO_BUS_MUX
-	help
-	  This module provides a driver for MDIO bus multiplexers that
-	  are controlled via GPIO lines.  The multiplexer connects one of
-	  several child MDIO busses to a parent bus.  Child bus
-	  selection is under the control of GPIO lines.
-
-config MDIO_BUS_MUX_MESON_G12A
-	tristate "Amlogic G12a based MDIO bus multiplexer"
-	depends on ARCH_MESON || COMPILE_TEST
-	depends on OF_MDIO && HAS_IOMEM && COMMON_CLK
-	select MDIO_BUS_MUX
-	default m if ARCH_MESON
-	help
-	  This module provides a driver for the MDIO multiplexer/glue of
-	  the amlogic g12a SoC. The multiplexers connects either the external
-	  or the internal MDIO bus to the parent bus.
-
-config MDIO_BUS_MUX_MMIOREG
-	tristate "MMIO device-controlled MDIO bus multiplexers"
-	depends on OF_MDIO && HAS_IOMEM
-	select MDIO_BUS_MUX
-	help
-	  This module provides a driver for MDIO bus multiplexers that
-	  are controlled via a simple memory-mapped device, like an FPGA.
-	  The multiplexer connects one of several child MDIO busses to a
-	  parent bus.  Child bus selection is under the control of one of
-	  the FPGA's registers.
-
-	  Currently, only 8/16/32 bits registers are supported.
-
-config MDIO_BUS_MUX_MULTIPLEXER
-	tristate "MDIO bus multiplexer using kernel multiplexer subsystem"
-	depends on OF_MDIO
-	select MULTIPLEXER
-	select MDIO_BUS_MUX
-	help
-	  This module provides a driver for MDIO bus multiplexer
-	  that is controlled via the kernel multiplexer subsystem. The
-	  bus multiplexer connects one of several child MDIO busses to
-	  a parent bus.  Child bus selection is under the control of
-	  the kernel multiplexer subsystem.
-
-config MDIO_CAVIUM
-	tristate
-
-config MDIO_GPIO
-	tristate "GPIO lib-based bitbanged MDIO buses"
-	depends on MDIO_BITBANG
-	depends on GPIOLIB || COMPILE_TEST
-	help
-	  Supports GPIO lib-based MDIO busses.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called mdio-gpio.
-
-config MDIO_HISI_FEMAC
-	tristate "Hisilicon FEMAC MDIO bus controller"
-	depends on HAS_IOMEM && OF_MDIO
-	help
-	  This module provides a driver for the MDIO busses found in the
-	  Hisilicon SoC that have an Fast Ethernet MAC.
-
-config MDIO_I2C
-	tristate
-	depends on I2C
-	help
-	  Support I2C based PHYs.  This provides a MDIO bus bridged
-	  to I2C to allow PHYs connected in I2C mode to be accessed
-	  using the existing infrastructure.
-
-	  This is library mode.
-
-config MDIO_IPQ4019
-	tristate "Qualcomm IPQ4019 MDIO interface support"
-	depends on HAS_IOMEM && OF_MDIO
-	help
-	  This driver supports the MDIO interface found in Qualcomm
-	  IPQ40xx series Soc-s.
-
-config MDIO_IPQ8064
-	tristate "Qualcomm IPQ8064 MDIO interface support"
-	depends on HAS_IOMEM && OF_MDIO
-	depends on MFD_SYSCON
-	help
-	  This driver supports the MDIO interface found in the network
-	  interface units of the IPQ8064 SoC
-
-config MDIO_MOXART
-	tristate "MOXA ART MDIO interface support"
-	depends on ARCH_MOXART || COMPILE_TEST
-	help
-	  This driver supports the MDIO interface found in the network
-	  interface units of the MOXA ART SoC
-
-config MDIO_MSCC_MIIM
-	tristate "Microsemi MIIM interface support"
-	depends on HAS_IOMEM
-	select MDIO_DEVRES
-	help
-	  This driver supports the MIIM (MDIO) interface found in the network
-	  switches of the Microsemi SoCs; it is recommended to switch on
-	  CONFIG_HIGH_RES_TIMERS
-
-config MDIO_MVUSB
-	tristate "Marvell USB to MDIO Adapter"
-	depends on USB
-	select MDIO_DEVRES
-	help
-	  A USB to MDIO converter present on development boards for
-	  Marvell's Link Street family of Ethernet switches.
-
-config MDIO_OCTEON
-	tristate "Octeon and some ThunderX SOCs MDIO buses"
-	depends on (64BIT && OF_MDIO) || COMPILE_TEST
-	depends on HAS_IOMEM
-	select MDIO_CAVIUM
-	help
-	  This module provides a driver for the Octeon and ThunderX MDIO
-	  buses. It is required by the Octeon and ThunderX ethernet device
-	  drivers on some systems.
-
-config MDIO_SUN4I
-	tristate "Allwinner sun4i MDIO interface support"
-	depends on ARCH_SUNXI || COMPILE_TEST
-	help
-	  This driver supports the MDIO interface found in the network
-	  interface units of the Allwinner SoC that have an EMAC (A10,
-	  A12, A10s, etc.)
-
-config MDIO_THUNDER
-	tristate "ThunderX SOCs MDIO buses"
-	depends on 64BIT
-	depends on PCI
-	select MDIO_CAVIUM
-	help
-	  This driver supports the MDIO interfaces found on Cavium
-	  ThunderX SoCs when the MDIO bus device appears as a PCI
-	  device.
-
-config MDIO_XGENE
-	tristate "APM X-Gene SoC MDIO bus controller"
-	depends on ARCH_XGENE || COMPILE_TEST
-	help
-	  This module provides a driver for the MDIO busses found in the
-	  APM X-Gene SoC's.
-
-endif
-endif
-
 config PHYLINK
 	tristate
 	depends on NETDEVICES
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 7cd8a0d1c0d0..3d83b648e3f0 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-# Makefile for Linux PHY drivers and MDIO bus drivers
+# Makefile for Linux PHY drivers
 
 libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o \
 				   linkmode.o
@@ -24,30 +24,6 @@ libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
 obj-$(CONFIG_PHYLINK)		+= phylink.o
 obj-$(CONFIG_PHYLIB)		+= libphy.o
 
-obj-$(CONFIG_MDIO_ASPEED)	+= mdio-aspeed.o
-obj-$(CONFIG_MDIO_BCM_IPROC)	+= mdio-bcm-iproc.o
-obj-$(CONFIG_MDIO_BCM_UNIMAC)	+= mdio-bcm-unimac.o
-obj-$(CONFIG_MDIO_BITBANG)	+= mdio-bitbang.o
-obj-$(CONFIG_MDIO_BUS_MUX)	+= mdio-mux.o
-obj-$(CONFIG_MDIO_BUS_MUX_BCM_IPROC)	+= mdio-mux-bcm-iproc.o
-obj-$(CONFIG_MDIO_BUS_MUX_GPIO)	+= mdio-mux-gpio.o
-obj-$(CONFIG_MDIO_BUS_MUX_MESON_G12A)	+= mdio-mux-meson-g12a.o
-obj-$(CONFIG_MDIO_BUS_MUX_MMIOREG) += mdio-mux-mmioreg.o
-obj-$(CONFIG_MDIO_BUS_MUX_MULTIPLEXER) += mdio-mux-multiplexer.o
-obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
-obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
-obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
-obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
-obj-$(CONFIG_MDIO_IPQ4019)	+= mdio-ipq4019.o
-obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
-obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
-obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
-obj-$(CONFIG_MDIO_MVUSB)	+= mdio-mvusb.o
-obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
-obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
-obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
-obj-$(CONFIG_MDIO_XGENE)	+= mdio-xgene.o
-
 obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += mii_timestamper.o
 
 obj-$(CONFIG_SFP)		+= sfp.o
-- 
2.28.0

