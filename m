Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2294A763D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 17:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346037AbiBBQzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 11:55:00 -0500
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:30064 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231706AbiBBQy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 11:54:59 -0500
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 212F3r9L015254;
        Wed, 2 Feb 2022 16:54:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pps0720;
 bh=FTz6OT6WOyHNxpUzwanoedf6Bw/zPVKiPG+q2GqAiIM=;
 b=fhrN725VdC3tDs5BjsvVB3C82WBAVlZSZh4S9n24BQiqppAkZWWrP7C9qkSUaPm5gLOB
 UwAsoujmhMkE3fr4p1/gDbUPNj5vzDrPVEL7ngqud06tp4iViLK0Ru8p97v7aLH9V/b4
 QVR5yig+HTJbQKn9WpEKlEqwV9FskpQDzkfjEIeLeau4BI3XTVtwpteZt+2DYQCQy+p6
 Dn2FzW71ibCTJMpn0yov6HDLg8ViCGZZrZIdcCiz+hV11vGvlQ4udcEWxS0hTpdM9Ohc
 avETfGk3NQ4349SMCLmEN3UC0J/UFSJT7x/4o+D547Z7xolE2bgiqE0LniCKab5fB4Y8 ag== 
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3dytjp20kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Feb 2022 16:54:58 +0000
Received: from hpe.com (unknown [16.100.173.53])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id 04CE55E;
        Wed,  2 Feb 2022 16:54:54 +0000 (UTC)
From:   nick.hawkins@hpe.com
To:     verdun@hpe.com
Cc:     nick.hawkins@hpe.com, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Corey Minyard <minyard@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Stanislav Jakubek <stano.jakubek@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Hao Fang <fanghao11@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Wang Kefeng <wangkefeng.wang@huawei.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] HPE BMC GXP SUPPORT
Date:   Wed,  2 Feb 2022 10:52:50 -0600
Message-Id: <20220202165315.18282-1-nick.hawkins@hpe.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <nick.hawkins@hpe.com>
References: <nick.hawkins@hpe.com>
X-Proofpoint-GUID: Q85Vgzwx_h1r8S9hBXe9YbEyTUDmILaW
X-Proofpoint-ORIG-GUID: Q85Vgzwx_h1r8S9hBXe9YbEyTUDmILaW
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-02_08,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 clxscore=1011 mlxscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202020094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Hawkins <nick.hawkins@hpe.com>

GXP is the name of the HPE SoC.
This SoC is used to implement BMC features of HPE servers
(all ProLiant, Synergy, and many Apollo, and Superdome machines)
It does support many features including:
	ARMv7 architecture, and it is based on a Cortex A9 core
	Use an AXI bus to which
		a memory controller is attached, as well as
                 multiple SPI interfaces to connect boot flash,
                 and ROM flash, a 10/100/1000 Mac engine which
                 supports SGMII (2 ports) and RMII
		Multiple I2C engines to drive connectivity with a host infrastructure
		A video engine which support VGA and DP, as well as
                 an hardware video encoder
		Multiple PCIe ports
		A PECI interface, and LPC eSPI
		Multiple UART for debug purpose, and Virtual UART for host connectivity
		A GPIO engine
This Patch Includes:
	Documentation for device tree bindings
	Device Tree Bindings
	GXP Timer Support
	GXP Architecture Support

Signed-off-by: Nick Hawkins <nick.hawkins@hpe.com>
---
 .../bindings/display/hpe,gxp-thumbnail.txt    |  21 +
 .../devicetree/bindings/gpio/hpe,gxp-gpio.txt |  16 +
 .../devicetree/bindings/i2c/hpe,gxp-i2c.txt   |  19 +
 .../bindings/ipmi/hpegxp-kcs-bmc-cfg.txt      |  13 +
 .../bindings/ipmi/hpegxp-kcs-bmc.txt          |  21 +
 .../memory-controllers/hpe,gxp-srom.txt       |  13 +
 .../devicetree/bindings/mtd/hpe,gxp.txt       |  16 +
 .../bindings/net/hpe,gxp-umac-mdio.txt        |  21 +
 .../devicetree/bindings/net/hpe,gxp-umac.txt  |  20 +
 .../devicetree/bindings/pwm/hpe,gxp-fan.txt   |  15 +
 .../bindings/serial/hpe,gxp-vuart-cfg.txt     |  17 +
 .../bindings/serial/hpe,gxp-vuart.txt         |  23 +
 .../bindings/soc/hpe/hpe,gxp-chif.txt         |  16 +
 .../bindings/soc/hpe/hpe,gxp-csm.txt          |  14 +
 .../bindings/soc/hpe/hpe,gxp-dbg.txt          |  18 +
 .../bindings/soc/hpe/hpe,gxp-fn2.txt          |  20 +
 .../bindings/soc/hpe/hpe,gxp-xreg.txt         |  19 +
 .../devicetree/bindings/spi/hpe,gxp-spifi.txt |  76 +++
 .../bindings/thermal/hpe,gxp-coretemp.txt     |  14 +
 .../bindings/timer/hpe,gxp-timer.txt          |  18 +
 .../devicetree/bindings/usb/hpe,gxp-udc.txt   |  21 +
 .../devicetree/bindings/vendor-prefixes.yaml  |   4 +-
 .../bindings/watchdog/hpe,gxp-wdt.txt         |  11 +
 MAINTAINERS                                   |  14 +
 arch/arm/Kconfig                              |   2 +
 arch/arm/boot/dts/Makefile                    |   2 +
 arch/arm/boot/dts/hpe-bmc-dl360gen10.dts      | 207 +++++++
 arch/arm/boot/dts/hpe-gxp.dtsi                | 555 ++++++++++++++++++
 arch/arm/configs/gxp_defconfig                | 243 ++++++++
 arch/arm/mach-hpe/Kconfig                     |  21 +
 arch/arm/mach-hpe/Makefile                    |   1 +
 arch/arm/mach-hpe/gxp.c                       |  62 ++
 drivers/clocksource/Kconfig                   |   8 +
 drivers/clocksource/Makefile                  |   1 +
 drivers/clocksource/gxp_timer.c               | 158 +++++
 35 files changed, 1719 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/display/hpe,gxp-thumbnail.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/hpe,gxp-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/hpe,gxp-i2c.txt
 create mode 100644 Documentation/devicetree/bindings/ipmi/hpegxp-kcs-bmc-cfg.txt
 create mode 100644 Documentation/devicetree/bindings/ipmi/hpegxp-kcs-bmc.txt
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/hpe,gxp-srom.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/hpe,gxp.txt
 create mode 100644 Documentation/devicetree/bindings/net/hpe,gxp-umac-mdio.txt
 create mode 100644 Documentation/devicetree/bindings/net/hpe,gxp-umac.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/hpe,gxp-fan.txt
 create mode 100644 Documentation/devicetree/bindings/serial/hpe,gxp-vuart-cfg.txt
 create mode 100644 Documentation/devicetree/bindings/serial/hpe,gxp-vuart.txt
 create mode 100644 Documentation/devicetree/bindings/soc/hpe/hpe,gxp-chif.txt
 create mode 100644 Documentation/devicetree/bindings/soc/hpe/hpe,gxp-csm.txt
 create mode 100644 Documentation/devicetree/bindings/soc/hpe/hpe,gxp-dbg.txt
 create mode 100644 Documentation/devicetree/bindings/soc/hpe/hpe,gxp-fn2.txt
 create mode 100644 Documentation/devicetree/bindings/soc/hpe/hpe,gxp-xreg.txt
 create mode 100644 Documentation/devicetree/bindings/spi/hpe,gxp-spifi.txt
 create mode 100644 Documentation/devicetree/bindings/thermal/hpe,gxp-coretemp.txt
 create mode 100644 Documentation/devicetree/bindings/timer/hpe,gxp-timer.txt
 create mode 100644 Documentation/devicetree/bindings/usb/hpe,gxp-udc.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/hpe,gxp-wdt.txt
 create mode 100644 arch/arm/boot/dts/hpe-bmc-dl360gen10.dts
 create mode 100644 arch/arm/boot/dts/hpe-gxp.dtsi
 create mode 100644 arch/arm/configs/gxp_defconfig
 create mode 100644 arch/arm/mach-hpe/Kconfig
 create mode 100644 arch/arm/mach-hpe/Makefile
 create mode 100644 arch/arm/mach-hpe/gxp.c
 create mode 100644 drivers/clocksource/gxp_timer.c

diff --git a/Documentation/devicetree/bindings/display/hpe,gxp-thumbnail.txt b/Documentation/devicetree/bindings/display/hpe,gxp-thumbnail.txt
new file mode 100644
index 000000000000..e6d37ecce72b
--- /dev/null
+++ b/Documentation/devicetree/bindings/display/hpe,gxp-thumbnail.txt
@@ -0,0 +1,21 @@
+* GXP HPE VIDEO THUMBNAIL DRIVER
+
+Required properties:
+- compatible: Must be "hpe,gxp-thumbnail".
+- reg       : Physical base address and length of the controller's registers.
+- clocks    : phandle + clock specifier pair of the FB reference clock.
+- bits-per-pixel: Bits per pixel, must be 32.
+- width: Width in pixels, must be 800.
+- height: Height in pixels, must be 600.
+
+Optional properties:
+- lcd-supply: Regulator for LCD supply voltage.
+
+Example:
+	thumbnail: thumbnail@c0000500 {
+		compatible = "hpe,gxp-thumbnail";
+		reg = <0xc0000500 0x20>;
+		bits-per-pixel = <32>;
+		width = <800>;
+		height = <600>;
+	};
diff --git a/Documentation/devicetree/bindings/gpio/hpe,gxp-gpio.txt b/Documentation/devicetree/bindings/gpio/hpe,gxp-gpio.txt
new file mode 100644
index 000000000000..568d26d785d2
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/hpe,gxp-gpio.txt
@@ -0,0 +1,16 @@
+*HPE GXP GPIO INTERFACE
+
+Required properties:
+- compatible: Must be "hpe,gxp-gpio".
+- #gpio-cells: The number of cells to describe a GPIO, this should be 2.
+- csm: Phandle to the GXP PCI CSM Controller.
+- vuch0_handle:	Phandle to the Virtual USB Hub Controller (VUHC).
+
+Example of gpio-controller nodes for a MPC8347 SoC:
+
+	gpio: gpio {
+		compatible = "hpe,gxp-gpio";
+		#gpio-cells = <2>;
+		csm_handle = <&csm>;
+		vuhc0_handle = <&vuhc0>;
+	};
diff --git a/Documentation/devicetree/bindings/i2c/hpe,gxp-i2c.txt b/Documentation/devicetree/bindings/i2c/hpe,gxp-i2c.txt
new file mode 100644
index 000000000000..cdca203f8c3b
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/hpe,gxp-i2c.txt
@@ -0,0 +1,19 @@
+* HPE GXP I2C Interface
+
+Required Properties:
+
+  - compatible: Must be "hpe,gxp-i2c"
+  - reg: The I2C address of the device.
+  - interrupts: The interrupt number.
+  - interrupt-parent: Interrupt controller to which the I2C bus is reporting
+  - i2cg-handle: I2C Global interrupt status register handler
+
+Example:
+
+	i2c0: i2c@c0002000 {
+		compatible = "hpe,gxp-i2c";
+		reg = <0xc0002000 0x70>;
+		interrupts = <9>;
+		interrupt-parent = <&vic0>;
+		i2cg-handle = <&i2cg>;
+	};
diff --git a/Documentation/devicetree/bindings/ipmi/hpegxp-kcs-bmc-cfg.txt b/Documentation/devicetree/bindings/ipmi/hpegxp-kcs-bmc-cfg.txt
new file mode 100644
index 000000000000..20deef7a6be2
--- /dev/null
+++ b/Documentation/devicetree/bindings/ipmi/hpegxp-kcs-bmc-cfg.txt
@@ -0,0 +1,13 @@
+* HPE GXP KCS IPMI DRIVER
+
+Required properties:
+- compatible : Must contain "hpe,gxp-kcs-bmc-cfg", "simple-mfd", "syscon".
+- reg : Specifies base physical address and size of the configuration registers.
+
+Example:
+
+	kcs_conf: kcs_conf@80fc0430 {
+			compatible = "hpe,gxp-kcs-bmc-cfg", "simple-mfd", "syscon";
+			reg = <0x80fc0430 0x100>;
+	};
+
diff --git a/Documentation/devicetree/bindings/ipmi/hpegxp-kcs-bmc.txt b/Documentation/devicetree/bindings/ipmi/hpegxp-kcs-bmc.txt
new file mode 100644
index 000000000000..137411243f3f
--- /dev/null
+++ b/Documentation/devicetree/bindings/ipmi/hpegxp-kcs-bmc.txt
@@ -0,0 +1,21 @@
+* HPE GXP KCS IPMI DRIVER
+
+Required properties:
+- compatible : Must contain "hpe,gxp-kcs-bmc".
+- interrupts : The interrupt number.
+- reg : Specifies base physical address and size of the control registers.
+- kcs_chan : The KCS channel number in the controller.
+- status: The status signal from the controller.
+- kcs-bmc-cfg = Phandle to the KCS Configuration registers.
+
+Example:
+
+	kcs_reg: kcs_reg@80fd0400 {
+		compatible = "hpe,gxp-kcs-bmc";
+		reg = <0x80fd0400 0x8>;
+		interrupts = <6>;
+		interrupt-parent = <&vic1>;
+		kcs_chan = <1>;
+		status = "okay";
+		kcs-bmc-cfg = <&kcs_conf>;
+	};
diff --git a/Documentation/devicetree/bindings/memory-controllers/hpe,gxp-srom.txt b/Documentation/devicetree/bindings/memory-controllers/hpe,gxp-srom.txt
new file mode 100644
index 000000000000..027cb6fbc93c
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/hpe,gxp-srom.txt
@@ -0,0 +1,13 @@
+* HPE GXP SROM CONTROLLER
+
+Required properties:
+
+- compatible: Must be one of "hpe,gxp-srom", "simple-mfd", "syscon".
+- reg: Specifies base physical address and size of the control registers.
+
+Example:
+
+	srom@80fc0000 {
+		compatible = "hpe,gxp-srom", "simple-mfd", "syscon";
+		reg = <0x80fc0000 0x100>;
+	};
diff --git a/Documentation/devicetree/bindings/mtd/hpe,gxp.txt b/Documentation/devicetree/bindings/mtd/hpe,gxp.txt
new file mode 100644
index 000000000000..8c6f54af0260
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/hpe,gxp.txt
@@ -0,0 +1,16 @@
+
+* HPE GXP BMC
+
+HPE GXP SoC definition
+
+Required properties:
+  - compatible : Must contain: "HPE,GXP"
+
+Example:
+/ {
+	model = "Hewlett Packard Enterprise GXP BMC";
+	compatible = "HPE,GXP";
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+}
diff --git a/Documentation/devicetree/bindings/net/hpe,gxp-umac-mdio.txt b/Documentation/devicetree/bindings/net/hpe,gxp-umac-mdio.txt
new file mode 100644
index 000000000000..fa48ecb22c92
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/hpe,gxp-umac-mdio.txt
@@ -0,0 +1,21 @@
+* HPE GXP UMAC MDIO Interface Controller
+
+Required properties:
+- compatible: Must contain "hpe,gxp-umac-mdio".
+- reg:  Specifies base physical address and size of the registers.
+- interrupts: The interrupt number.
+- Cells which are configuring the external phy interfaces. Numbered through relative addressing each phy is compatible with a standard ethernet-phy-ieee802.3 phy.
+
+Example:
+
+	mdio0: mdio@c0004080 {
+		compatible = "hpe,gxp-umac-mdio";
+		reg = <0xc0004080 0x10>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		ext_phy0: ethernt-phy@0 {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			phy-mode = "sgmii";
+			reg = <0>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/net/hpe,gxp-umac.txt b/Documentation/devicetree/bindings/net/hpe,gxp-umac.txt
new file mode 100644
index 000000000000..3a620b4ad999
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/hpe,gxp-umac.txt
@@ -0,0 +1,20 @@
+* HPE GXP UMAC Controller
+
+Required properties:
+- compatible: Must contain "hpe,gxp-umac".
+- reg:  Specifies base physical address and size of the registers.
+- interrupts: The interrupt number.
+- interrupt-parent: specify main interrupt controller handler
+- phy-handle: Phandle to a PHY on the MDIO bus.
+- int-phy-handle: Phandle to PHY interrupt handler.
+
+Example:
+
+	umac0: umac@c0004000 {
+		compatible = "hpe,gxp-umac";
+		reg = <0xc0004000 0x80>;
+		interrupts = <10>;
+		interrupt-parent = <&vic0>;
+		phy-handle = <&ext_phy0>;
+		int-phy-handle = <&int_phy0>;
+	};
diff --git a/Documentation/devicetree/bindings/pwm/hpe,gxp-fan.txt b/Documentation/devicetree/bindings/pwm/hpe,gxp-fan.txt
new file mode 100644
index 000000000000..21446b7cafd9
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/hpe,gxp-fan.txt
@@ -0,0 +1,15 @@
+* HPE GXP Fan Controller
+
+Required properties:
+- compatible: Must contain "hpe,gxp-fan-ctrl".
+- reg: Physical base address and length of the controller's registers.
+- xreg_handle: Phandle to the xregister controller for fan control.
+- fn2_handle: Phandle to the FN2 interface.
+
+Example:
+	fanctrl: fanctrl@c1000c00 {
+			compatible = "hpe,gxp-fan-ctrl";
+			reg = <0xc1000c00 0x200>;
+			xreg_handle = <&xreg>;
+			fn2_handle = <&fn2>;
+	};
diff --git a/Documentation/devicetree/bindings/serial/hpe,gxp-vuart-cfg.txt b/Documentation/devicetree/bindings/serial/hpe,gxp-vuart-cfg.txt
new file mode 100644
index 000000000000..8bad8c39d044
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/hpe,gxp-vuart-cfg.txt
@@ -0,0 +1,17 @@
+*HPE Virtual UART Controller CONFIGURATION
+
+This controller is used to forward host serial to BMC chip
+
+Required properties:
+
+- compatible : Must contain "hpe,gxp-vuarta_cfg", "simple-mfd", "syscon".
+- reg : Specifies base physical address and size of the configuration register.
+- reg-io-width: io register width in bytes, must be 1.
+
+Example:
+
+	vuart_a_cfg: vuarta_cfg@80fc0230 {
+		compatible = "hpe,gxp-vuarta_cfg", "simple-mfd", "syscon";
+		reg = <0x80fc0230 0x100>;
+		reg-io-width = <1>;
+	};
diff --git a/Documentation/devicetree/bindings/serial/hpe,gxp-vuart.txt b/Documentation/devicetree/bindings/serial/hpe,gxp-vuart.txt
new file mode 100644
index 000000000000..9c5cc14d9474
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/hpe,gxp-vuart.txt
@@ -0,0 +1,23 @@
+*HPE VUART Controller port
+
+Required properties:
+
+- compatible :  Must contain "hpe,gxp-vuart".
+- reg        :  Specifies base physical address and size of the registers.
+- interrupts :  The interrupt number.
+- clock-frequency: The frequency of the clock input to the UART in Hz.
+- status: The status signal from the controller.
+
+Example:
+
+	vuart_a: vuart_a@80fd0200 {
+		compatible = "hpe,gxp-vuart";
+		reg = <0x80fd0200 0x100>;
+		interrupts = <2>;
+		interrupt-parent = <&vic1>;
+		clock-frequency = <1846153>;
+		reg-shift = <0>;
+		status = "okay";
+		serial-line = <3>;
+		vuart_cfg = <&vuart_a_cfg>;
+	};
diff --git a/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-chif.txt b/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-chif.txt
new file mode 100644
index 000000000000..9d5a8763ca22
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-chif.txt
@@ -0,0 +1,16 @@
+* HPE GXP CHIF INTERFACE
+
+Define the basic CHannel InterFace (CHIF) communication path between BMC and Host through PCI.
+Interrupts are handled through PCI function 2
+
+Required parent device properties:
+- compatible : Should be "hpe,gxp-chif".
+- interrupts : The interrupt number.
+
+Example:
+
+	chif {
+			compatible = "hpe,gxp-chif";
+			interrupts = <12>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-csm.txt b/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-csm.txt
new file mode 100644
index 000000000000..8d28fd1ec46a
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-csm.txt
@@ -0,0 +1,14 @@
+* HPE GXP PCI CSM INTERFACE
+
+Required parent device properties:
+- compatible : Should be "hpe,gxp-csm", "simple-mfd", "syscon".
+- reg : Specifies base physical address and size of control registers.
+
+Example:
+
+	csm: csm@8000005c {
+		compatible = "hpe,gxp-csm", "simple-mfd", "syscon";
+		reg = <0x8000005c 0x2>, <0x800000de 0x1>, <0x800000e7 0x1>;
+	};
+
+
diff --git a/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-dbg.txt b/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-dbg.txt
new file mode 100644
index 000000000000..39e3ed68a34d
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-dbg.txt
@@ -0,0 +1,18 @@
+* HPE GXP DBG INTERFACE
+
+Specify host debug interface. Used presently to report ROM POST code during host initialization phases
+
+Required parent device properties:
+- compatible : Should be "hpe,gxp-dbg".
+- reg : Specifies base physical address and size of the control/data registers.
+- interrupts: The interrupt number.
+- interrupt-parent: The interrupt controller to which the interface is wired to
+
+Example:
+
+	post@800000a0 {
+		compatible = "hpe,gxp-dbg";
+		reg = <0x800000a0 0x20>;
+		interrupts = <10>;
+		interrupt-parent = <&vic1>;
+	};
diff --git a/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-fn2.txt b/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-fn2.txt
new file mode 100644
index 000000000000..eb8328f59eda
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-fn2.txt
@@ -0,0 +1,20 @@
+* HPE GXP PCI FN2 INTERFACE CONTROLLER
+
+Required parent device properties:
+- compatible : Should be "hpe,gxp-fn2", "simple-mfd", "syscon".
+- reg : Specifies base physical address and size of the control/data/memory mapped registers.
+- xreg_handle : Phandle to the xregister controller interface.
+- #gpio-cells : The number of cells to describe a GPIO, this should be 2.
+- interrupts : interrupt number to which PCI FN2 is connected to
+- interrupt-parets : interrupt controller to which PCI FN2 is connected to
+
+Example:
+
+	fn2: fn2@80200000 {
+		compatible = "hpe,gxp-fn2", "simple-mfd", "syscon";
+		reg = <0x80200000 0x100000>;
+		xreg_handle = <&xreg>;
+		interrupts = <0>;
+		interrupt-parent = <&vic1>;
+		#gpio-cells = <2>;
+	};
diff --git a/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-xreg.txt b/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-xreg.txt
new file mode 100644
index 000000000000..3ec86a478302
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/hpe/hpe,gxp-xreg.txt
@@ -0,0 +1,19 @@
+* HPE GXP XREG INTERFACE
+
+Required parent device properties:
+- compatible : Should be "hpe,gxp-fn2", "simple-mfd", "syscon".
+- reg : Specifies base physical address and size of the control registers.
+- interrupts: The interrupt number.
+- interrupt-parent: main interrupt controller to which xreg is connected to
+- #gpio-cells : The number of cells to describe a GPIO, this should be 2.
+
+Example:
+
+	xreg: xreg@d1000300 {
+		compatible = "hpe,gxp-xreg", "simple-mfd", "syscon";
+		reg = <0xd1000300 0xFF>;
+		interrupts = <26>;
+		interrupt-parent = <&vic0>;
+		#gpio-cells = <2>;
+	};
+
diff --git a/Documentation/devicetree/bindings/spi/hpe,gxp-spifi.txt b/Documentation/devicetree/bindings/spi/hpe,gxp-spifi.txt
new file mode 100644
index 000000000000..78eac0ac82f4
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/hpe,gxp-spifi.txt
@@ -0,0 +1,76 @@
+* HPE GXP SPI FLASH INTERFACE
+
+Required properties:
+  - compatible : Must contain: "hpe,gxp-spifi"
+  - reg : the first contains the control register location and length,
+          the second contains the memory window mapping address and length,
+		  the third contains the configuration register location and length
+  - interrupts: The interrupt number.
+  - #address-cells : must be 1 corresponding to chip select child binding
+  - #size-cells : must be 0 corresponding to chip select child binding
+
+The child nodes are the SPI flash modules which must have a compatible
+property as specified in bindings/mtd/jedec,spi-nor.txt
+
+Example:
+	spifi0: spifi@c0000200 {
+		compatible = "hpe,gxp-spifi";
+		reg = <0xc0000200 0x80>, <0xc000c000 0x100>, <0xf8000000 0x8000000>;
+		interrupts = <20>;
+		interrupt-parent = <&vic0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		flash@0 {
+			compatible = "jedec,spi-nor";
+			reg = <0>;
+			partitions {
+				compatible = "fixed-partitions";
+				#address-cells = <1>;
+				#size-cells = <1>;
+
+				u-boot@0 {
+					label = "u-boot";
+					reg = <0x0 0x60000>;
+				};
+				u-boot-env@60000 {
+					label = "u-boot-env";
+					reg = <0x60000 0x20000>;
+				};
+				kernel@80000 {
+					label = "kernel";
+					reg = <0x80000 0x4c0000>;
+				};
+				rofs@540000 {
+					label = "rofs";
+					reg = <0x540000 0x1740000>;
+				};
+				rwfs@1c80000 {
+					label = "rwfs";
+					reg = <0x1c80000 0x250000>;
+				};
+				section@1edf000{
+					label = "section";
+					reg = <0x1ed0000 0x130000>;
+				};
+			};
+		};
+
+		flash@1 {
+			compatible = "jedec,spi-nor";
+			reg = <1>;
+			partitions {
+				compatible = "fixed-partitions";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				host-prime@0 {
+					label = "host-prime";
+					reg = <0x0 0x02000000>;
+				};
+				host-second@2000000 {
+					label = "host-second";
+					reg = <0x02000000 0x02000000>;
+				};
+			};
+		};
+	};
diff --git a/Documentation/devicetree/bindings/thermal/hpe,gxp-coretemp.txt b/Documentation/devicetree/bindings/thermal/hpe,gxp-coretemp.txt
new file mode 100644
index 000000000000..bc83db03166a
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/hpe,gxp-coretemp.txt
@@ -0,0 +1,14 @@
+* HPE GXP CORETEMP INTERFACE
+
+Required parent device properties:
+- compatible : Should be "hpe,gxp-coretemp".
+- reg : Specifies base physical address and size of the control register.
+
+Example:
+
+	coretemp: coretemp@c0000130 {
+		compatible = "hpe,gxp-coretemp";
+		reg = <0xc0000130 0x8>;
+	};
+
+
diff --git a/Documentation/devicetree/bindings/timer/hpe,gxp-timer.txt b/Documentation/devicetree/bindings/timer/hpe,gxp-timer.txt
new file mode 100644
index 000000000000..3e491b8ea740
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/hpe,gxp-timer.txt
@@ -0,0 +1,18 @@
+*HPE GXP TIMER
+
+Required properties:
+
+- compatible : Must be "hpe,gxp-timer"
+- reg : The GXP Timer Control Registers (Addresses + size) tuples list.
+- interrupts : The interrupt number.
+- clock-frequency : The frequency of the clock that drives the counter, in Hz.
+
+Example:
+
+	timer0: timer@c0000080 {
+		compatible = "hpe,gxp-timer";
+		reg = <0xc0000080 0x1>, <0xc0000094 0x01>, <0xc0000088 0x08>;
+		interrupts = <0>;
+		interrupt-parent = <&vic0>;
+		clock-frequency = <400000000>;
+	};
diff --git a/Documentation/devicetree/bindings/usb/hpe,gxp-udc.txt b/Documentation/devicetree/bindings/usb/hpe,gxp-udc.txt
new file mode 100644
index 000000000000..ed764d64a169
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/hpe,gxp-udc.txt
@@ -0,0 +1,21 @@
+* HPE USB Device Port Controller
+
+Required properties:
+- compatible: Must be "hpe,gxp-udc".
+- reg: Specifies base physical address and size of the registers.
+- interrupts: The interrupt number.
+- vdevnum: The particular usb device controller port.
+- fepnum: The particular usb device controller options.
+- udcg-handle: The usb device controller hub.
+
+Example:
+
+	udc0: udc@80401000 {
+		compatible = "hpe,gxp-udc";
+		reg = <0x80401000 0x1000>;
+		interrupts = <13>;
+		interrupt-parent = <&vic1>;
+		vdevnum = <0>;
+		fepnum = <7>;
+		udcg-handle = <&udcg>;
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 294093d45a23..913f722a6b8d 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -514,7 +514,9 @@ patternProperties:
   "^hoperun,.*":
     description: Jiangsu HopeRun Software Co., Ltd.
   "^hp,.*":
-    description: Hewlett Packard
+    description: Hewlett Packard Inc.
+  "^hpe,.*":
+    description: Hewlett Packard Enterprise
   "^hsg,.*":
     description: HannStar Display Co.
   "^holtek,.*":
diff --git a/Documentation/devicetree/bindings/watchdog/hpe,gxp-wdt.txt b/Documentation/devicetree/bindings/watchdog/hpe,gxp-wdt.txt
new file mode 100644
index 000000000000..3f17c1a00a5c
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/hpe,gxp-wdt.txt
@@ -0,0 +1,11 @@
+* HPE GXP Controlled Watchdog
+
+Required Properties:
+- compatible: Should contain "hpe,gxp-wdt".
+- reg: The GXP Watchdog Control Registers (Addresses + size) tuples list.
+
+Example:
+	watchdog: watchdog@c0000090 {
+		compatible = "hpe,gxp-wdt";
+		reg = <0xc0000090 0x02>, <0xc0000096 0x01>;
+	};
diff --git a/MAINTAINERS b/MAINTAINERS
index f41088418aae..2a4fcfff0104 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8385,6 +8385,20 @@ L:	linux-efi@vger.kernel.org
 S:	Maintained
 F:	block/partitions/efi.*
 
+GXP ARCHITECTURE
+M:	Jean-Marie Verdun <verdun@hpe.com>
+M:	Nick Hawkins <nick.hawkins@hpe.com>
+S:	Maintained
+F:	arch/arm/boot/dts/gxp.dts
+F:	arch/arm/configs/gxp_defconfig
+F:	arch/arm/mach-hpe/gxp.c
+
+GXP TIMER
+M:	Jean-Marie Verdun <verdun@hpe.com>
+M:	Nick Hawkins <nick.hawkins@hpe.com>
+S:	Maintained
+F:	drivers/clocksource/gxp_timer.c
+
 H8/300 ARCHITECTURE
 M:	Yoshinori Sato <ysato@users.sourceforge.jp>
 L:	uclinux-h8-devel@lists.sourceforge.jp (moderated for non-subscribers)
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4c97cb40eebb..6998b5b5f59e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -618,6 +618,8 @@ source "arch/arm/mach-highbank/Kconfig"
 
 source "arch/arm/mach-hisi/Kconfig"
 
+source "arch/arm/mach-hpe/Kconfig"
+
 source "arch/arm/mach-imx/Kconfig"
 
 source "arch/arm/mach-integrator/Kconfig"
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 235ad559acb2..a96b4d5b7f68 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -1549,3 +1549,5 @@ dtb-$(CONFIG_ARCH_ASPEED) += \
 	aspeed-bmc-vegman-n110.dtb \
 	aspeed-bmc-vegman-rx20.dtb \
 	aspeed-bmc-vegman-sx20.dtb
+dtb-$(CONFIG_ARCH_HPE_GXP) += \
+	hpe-bmc-dl360gen10.dtb
diff --git a/arch/arm/boot/dts/hpe-bmc-dl360gen10.dts b/arch/arm/boot/dts/hpe-bmc-dl360gen10.dts
new file mode 100644
index 000000000000..278bf2bca2c8
--- /dev/null
+++ b/arch/arm/boot/dts/hpe-bmc-dl360gen10.dts
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Device Tree file for HPE DL360Gen10
+ */
+
+/include/ "hpe-gxp.dtsi"
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "hpe,gxp";
+	model = "Hewlett Packard Enterprise ProLiant dl360 Gen10";
+
+	chosen {
+		bootargs = "earlyprintk console=ttyS0,115200 user_debug=31";
+	};
+
+	aliases {
+		ethernet0 = &umac0;
+		ethernet1 = &umac1;
+	};
+
+	memory@40000000 {
+		device_type = "memory";
+		reg = <0x40000000 0x20000000>;
+	};
+
+	ahb {
+		umac0: umac@c0004000 {
+			mac-address = [94 18 82 16 04 d8];
+		};
+
+		umac1: umac@c0005000 {
+			mac-address = [94 18 82 16 04 d9];
+		};
+
+		udc0: udc@80401000 {
+			compatible = "hpe,gxp-udc";
+			reg = <0x80401000 0x1000>;
+			interrupts = <13>;
+			interrupt-parent = <&vic1>;
+			vdevnum = <0>;
+			fepnum = <7>;
+			udcg-handle = <&udcg>;
+		};
+
+		udc1: udc@80402000 {
+			compatible = "hpe,gxp-udc";
+			reg = <0x80402000 0x1000>;
+			interrupts = <13>;
+			interrupt-parent = <&vic1>;
+			vdevnum = <1>;
+			fepnum = <7>;
+			udcg-handle = <&udcg>;
+		};
+
+		udc2: udc@80403000 {
+			compatible = "hpe,gxp-udc";
+			reg = <0x80403000 0x1000>;
+			interrupts = <13>;
+			interrupt-parent = <&vic1>;
+			vdevnum = <2>;
+			fepnum = <4>;
+			udcg-handle = <&udcg>;
+		};
+
+		fn2: fn2@80200000 {
+			gpio-line-names =
+				"POWER_OUT", "PS_PWROK", "PCIERST", "POST_COMPLETE", "", "",
+				"", "", "", "", "", "", "", "", "", "",
+				"", "", "", "", "", "", "", "", "", "",
+				"", "", "", "", "", "", "", "", "", "",
+				"", "", "", "", "", "", "", "", "", "",
+				"", "", "", "", "", "", "", "", "", "",
+				"", "", "", "", "", "", "", "", "", "",
+				"", "", "", "", "", "", "", "", "", "",
+				"", "", "", "", "", "", "", "", "", "",
+				"", "", "", "", "", "", "", "", "", "",
+				"", "", "", "";
+		};
+
+		xreg: xreg@d1000300 {
+			gpio-line-names =
+				"", "", "", "", "", "", "POWER", "HEARTBEAT", "FAN1_INST",
+				"FAN2_INST","FAN3_INST", "FAN4_INST", "FAN5_INST",
+				"FAN6_INST", "FAN7_INST", "FAN8_INST", "FAN9_INST",
+				"FAN10_INST", "FAN11_INST", "FAN12_INST","FAN13_INST",
+				"FAN14_INST", "FAN15_INST", "FAN16_INST", "FAN1_FAIL",
+				"FAN2_FAIL", "FAN3_FAIL", "FAN4_FAIL", "FAN5_FAIL",
+				"FAN6_FAIL", "FAN7_FAIL", "FAN8_FAIL", "FAN9_FAIL",
+				"FAN10_FAIL", "FAN11_FAIL", "FAN12_FAIL", "FAN13_FAIL",
+				"FAN14_FAIL", "FAN15_FAIL", "FAN16_FAIL","", "", "", "",
+				"", "", "", "", "", "", "", "", "", "", "", "", "IDENTIFY",
+				"HEALTH_RED", "HEALTH_AMBER", "POWER_BUTTON", "",
+				"SIO_POWER_GOOD", "NMI_BUTTON", "RESET_BUTTON", "SIO_S5",
+				"SIO_ONCONTROL", "", "", "", "", "", "", "", "", "", "",
+				"", "", "", "", "", "", "", "", "", "", "", "", "", "",
+				"", "", "", "", "", "", "", "", "", "";
+		};
+
+		i2c2: i2c@c0002200 {
+			24c02@50 {
+				compatible = "atmel,24c02";
+				pagesize = <8>;
+				reg = <0x50>;
+			};
+		};
+	};
+
+	vuhc: vuhc {
+		compatible = "gpio-keys-polled";
+		poll-interval = <100>;
+
+		PortOwner0 {
+			label = "Port Owner";
+			linux,code = <200>;
+			gpios = <&gpio 250 1>;
+		};
+
+		PortOwner1 {
+			label = "Port Owner";
+			linux,code = <201>;
+			gpios = <&gpio 251 1>;
+		};
+
+		PortOwner2 {
+			label = "Port Owner";
+			linux,code = <202>;
+			gpios = <&gpio 252 1>;
+		};
+	};
+
+	gpio: gpio {
+		gpio-line-names =
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "RESET_OUT", "NMI_OUT", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "",
+			"", "", "", "", "", "", "", "", "", "";
+	};
+
+	xreg_keys: xreg_keys {
+		compatible = "gpio-keys-polled";
+		poll-interval = <100>;
+
+		IdButton {
+			label = "ID Button";
+			linux,code = <200>;
+			gpios = <&xreg 60 1>;
+		};
+	};
+
+	leds: leds {
+		compatible = "gpio-leds";
+
+		power {
+			gpios = <&xreg 6 0>;
+			default-state = "off";
+		};
+
+		heartbeat {
+			gpios = <&xreg 7 0>;
+			default-state = "off";
+		};
+
+		identify {
+			gpios = <&xreg 56 0>;
+			default-state = "off";
+		};
+
+		health_red {
+			gpios = <&xreg 57 0>;
+			default-state = "off";
+		};
+
+		health_amber {
+			gpios = <&xreg 58 0>;
+			default-state = "off";
+		};
+	};
+
+};
diff --git a/arch/arm/boot/dts/hpe-gxp.dtsi b/arch/arm/boot/dts/hpe-gxp.dtsi
new file mode 100644
index 000000000000..1a16840bb72f
--- /dev/null
+++ b/arch/arm/boot/dts/hpe-gxp.dtsi
@@ -0,0 +1,555 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Device Tree file for HPE GXP
+ */
+
+/dts-v1/;
+/ {
+	model = "Hewlett Packard Enterprise GXP BMC";
+	compatible = "hpe,gxp";
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "arm,armv7";
+			device_type = "cpu";
+			reg = <0>;
+		};
+	};
+
+	memory@40000000 {
+		device_type = "memory";
+		reg = <0x40000000 0x20000000>;
+	};
+
+	ahb {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		device_type = "soc";
+		ranges;
+
+		vic0: interrupt-controller@ceff0000 {
+			compatible = "arm,pl192-vic";
+			#address-cells = <1>;
+			interrupt-controller;
+			reg = <0xceff0000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+
+		vic1: vic@80f00000 {
+			compatible = "arm,pl192-vic";
+			#address-cells = <1>;
+			interrupt-controller;
+			reg = <0x80f00000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+
+		timer0: timer@c0000080 {
+			compatible = "hpe,gxp-timer";
+			reg = <0xc0000080 0x1>, <0xc0000094 0x01>, <0xc0000088 0x08>;
+			interrupts = <0>;
+			interrupt-parent = <&vic0>;
+			clock-frequency = <400000000>;
+		};
+
+		watchdog: watchdog@c0000090 {
+			compatible = "hpe,gxp-wdt";
+			reg = <0xc0000090 0x02>, <0xc0000096 0x01>;
+		};
+
+		uartc: serial@c00000f0 {
+			compatible = "ns16550a";
+			reg = <0xc00000f0 0x8>;
+			interrupts = <19>;
+			interrupt-parent = <&vic0>;
+			clock-frequency = <1846153>;
+			reg-shift = <0>;
+		};
+
+		uarta: serial@c00000e0 {
+			compatible = "ns16550a";
+			reg = <0xc00000e0 0x8>;
+			interrupts = <17>;
+			interrupt-parent = <&vic0>;
+			clock-frequency = <1846153>;
+			reg-shift = <0>;
+		};
+
+		uartb: serial@c00000e8 {
+			compatible = "ns16550a";
+			reg = <0xc00000e8 0x8>;
+			interrupts = <18>;
+			interrupt-parent = <&vic0>;
+			clock-frequency = <1846153>;
+			reg-shift = <0>;
+		};
+
+		vuart_a_cfg: vuarta_cfg@80fc0230 {
+			compatible = "hpe,gxp-vuarta_cfg", "simple-mfd", "syscon";
+			reg = <0x80fc0230 0x100>;
+			reg-io-width = <1>;
+		};
+
+		vuart_a: vuart_a@80fd0200 {
+			compatible = "hpe,gxp-vuart";
+			reg = <0x80fd0200 0x100>;
+			interrupts = <2>;
+			interrupt-parent = <&vic1>;
+			clock-frequency = <1846153>;
+			reg-shift = <0>;
+			status = "okay";
+			serial-line = <3>;
+			vuart_cfg = <&vuart_a_cfg>;
+		};
+
+		usb0: ehci@cefe0000 {
+			compatible = "generic-ehci";
+			reg = <0xcefe0000 0x100>;
+			interrupts = <7>;
+			interrupt-parent = <&vic0>;
+		};
+
+		usb1: ohci@cefe0100 {
+			compatible = "generic-ohci";
+			reg = <0xcefe0100 0x110>;
+			interrupts = <6>;
+			interrupt-parent = <&vic0>;
+		};
+
+		spifi0: spifi@c0000200 {
+			compatible = "hpe,gxp-spifi";
+			reg = <0xc0000200 0x80>, <0xc000c000 0x100>, <0xf8000000 0x8000000>;
+			interrupts = <20>;
+			interrupt-parent = <&vic0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			flash@0 {
+				compatible = "jedec,spi-nor";
+				reg = <0>;
+				partitions {
+					compatible = "fixed-partitions";
+					#address-cells = <1>;
+					#size-cells = <1>;
+
+					u-boot@0 {
+						label = "u-boot";
+						reg = <0x0 0x60000>;
+					};
+					u-boot-env@60000 {
+						label = "u-boot-env";
+						reg = <0x60000 0x20000>;
+					};
+					kernel@80000 {
+						label = "kernel";
+						reg = <0x80000 0x4c0000>;
+					};
+					rofs@540000 {
+						label = "rofs";
+						reg = <0x540000 0x1740000>;
+					};
+					rwfs@1c80000 {
+						label = "rwfs";
+						reg = <0x1c80000 0x250000>;
+					};
+					section@1edf000{
+						label = "section";
+						reg = <0x1ed0000 0x130000>;
+					};
+				};
+			};
+
+			flash@1 {
+				compatible = "jedec,spi-nor";
+				reg = <1>;
+				partitions {
+					compatible = "fixed-partitions";
+					#address-cells = <1>;
+					#size-cells = <1>;
+					host-prime@0 {
+						label = "host-prime";
+						reg = <0x0 0x02000000>;
+					};
+					host-second@2000000 {
+						label = "host-second";
+						reg = <0x02000000 0x02000000>;
+					};
+				};
+			};
+		};
+
+		sram@d0000000 {
+			compatible = "mtd-ram";
+			reg = <0xd0000000 0x80000>;
+			bank-width = <1>;
+			erase-size =<1>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			partition@0 {
+				label = "host-reserved";
+				reg = <0x0 0x10000>;
+			};
+			partition@10000 {
+				label = "nvram";
+				reg = <0x10000 0x70000>;
+			};
+		};
+
+		srom@80fc0000 {
+			compatible = "hpe,gxp-srom", "simple-mfd", "syscon";
+			reg = <0x80fc0000 0x100>;
+		};
+
+		vrom@58000000 {
+			compatible = "mtd-ram";
+			bank-width = <4>;
+			reg = <0x58000000 0x4000000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			partition@0 {
+				label = "vrom-prime";
+				reg = <0x0 0x2000000>;
+			};
+			partition@2000000 {
+				label = "vrom-second";
+				reg = <0x2000000 0x2000000>;
+			};
+		};
+
+		i2cg: i2cg@c00000f8 {
+			compatible = "syscon";
+			reg = <0xc00000f8 0x08>;
+		};
+
+		i2c0: i2c@c0002000 {
+			compatible = "hpe,gxp-i2c";
+			reg = <0xc0002000 0x70>;
+			interrupts = <9>;
+			interrupt-parent = <&vic0>;
+			i2cg-handle = <&i2cg>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c1: i2c@c0002100 {
+			compatible = "hpe,gxp-i2c";
+			reg = <0xc0002100 0x70>;
+			interrupts = <9>;
+			interrupt-parent = <&vic0>;
+			i2cg-handle = <&i2cg>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c2: i2c@c0002200 {
+			compatible = "hpe,gxp-i2c";
+			reg = <0xc0002200 0x70>;
+			interrupts = <9>;
+			interrupt-parent = <&vic0>;
+			i2cg-handle = <&i2cg>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c3: i2c@c0002300 {
+			compatible = "hpe,gxp-i2c";
+			reg = <0xc0002300 0x70>;
+			interrupts = <9>;
+			interrupt-parent = <&vic0>;
+			i2cg-handle = <&i2cg>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c4: i2c@c0002400 {
+			compatible = "hpe,gxp-i2c";
+			reg = <0xc0002400 0x70>;
+			interrupts = <9>;
+			interrupt-parent = <&vic0>;
+			i2cg-handle = <&i2cg>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c5: i2c@c0002500 {
+			compatible = "hpe,gxp-i2c";
+			reg = <0xc0002500 0x70>;
+			interrupts = <9>;
+			interrupt-parent = <&vic0>;
+			i2cg-handle = <&i2cg>;
+		};
+
+		i2c6: i2c@c0002600 {
+			compatible = "hpe,gxp-i2c";
+			reg = <0xc0002600 0x70>;
+			interrupts = <9>;
+			interrupt-parent = <&vic0>;
+			i2cg-handle = <&i2cg>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c7: i2c@c0002700 {
+			compatible = "hpe,gxp-i2c";
+			reg = <0xc0002700 0x70>;
+			interrupts = <9>;
+			interrupt-parent = <&vic0>;
+			i2cg-handle = <&i2cg>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c8: i2c@c0002800 {
+			compatible = "hpe,gxp-i2c";
+			reg = <0xc0002800 0x70>;
+			interrupts = <9>;
+			interrupt-parent = <&vic0>;
+			i2cg-handle = <&i2cg>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c9: i2c@c0002900 {
+			compatible = "hpe,gxp-i2c";
+			reg = <0xc0002900 0x70>;
+			interrupts = <9>;
+			interrupt-parent = <&vic0>;
+			i2cg-handle = <&i2cg>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2cmux@d1000074 {
+			compatible = "i2c-mux-reg";
+			i2c-parent = <&i2c4>;
+			reg = <0xd1000074 1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			i2c4@1 {
+				reg = <1>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			i2c4@2 {
+				reg = <2>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			i2c4@3 {
+				reg = <3>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			i2c4@4 {
+				reg = <4>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+
+		i2cmux@d1000076 {
+			compatible = "i2c-mux-reg";
+			i2c-parent = <&i2c6>;
+			reg = <0xd1000076 1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			i2c6@1 {
+				reg = <1>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			i2c6@2 {
+				reg = <2>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			i2c6@3 {
+				reg = <3>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			i2c6@4 {
+				reg = <4>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			i2c6@5 {
+				reg = <5>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+
+		mdio0: mdio@c0004080 {
+			compatible = "hpe,gxp-umac-mdio";
+			reg = <0xc0004080 0x10>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ext_phy0: ethernt-phy@0 {
+				compatible = "ethernet-phy-ieee802.3-c22";
+				phy-mode = "sgmii";
+				reg = <0>;
+			};
+		};
+
+		mdio1: mdio@c0005080 {
+			compatible = "hpe,gxp-umac-mdio";
+			reg = <0xc0005080 0x10>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			int_phy0: ethernt-phy@0 {
+				compatible = "ethernet-phy-ieee802.3-c22";
+				phy-mode = "gmii";
+				reg = <0>;
+			};
+
+			int_phy1: ethernt-phy@1 {
+				compatible = "ethernet-phy-ieee802.3-c22";
+				phy-mode = "gmii";
+				reg = <1>;
+			};
+		};
+
+		umac0: umac@c0004000 {
+			compatible = "hpe,gxp-umac";
+			reg = <0xc0004000 0x80>;
+			interrupts = <10>;
+			interrupt-parent = <&vic0>;
+			phy-handle = <&ext_phy0>;
+			int-phy-handle = <&int_phy0>;
+		};
+
+		umac1: umac@c0005000 {
+			compatible = "hpe,gxp-umac";
+			use-ncsi;
+			reg = <0xc0005000 0x80>;
+			interrupts = <11>;
+			interrupt-parent = <&vic0>;
+			phy-handle = <&int_phy1>;
+		};
+
+		kcs_conf: kcs_conf@80fc0430 {
+			compatible = "hpe,gxp-kcs-bmc-cfg", "simple-mfd", "syscon";
+			reg = <0x80fc0430 0x100>;
+		};
+
+		kcs_reg: kcs_reg@80fd0400 {
+			compatible = "hpe,gxp-kcs-bmc";
+			reg = <0x80fd0400 0x8>;
+			interrupts = <6>;
+			interrupt-parent = <&vic1>;
+			kcs_chan = <1>;
+			status = "okay";
+			kcs-bmc-cfg = <&kcs_conf>;
+		};
+
+		thumbnail: thumbnail@c0000500 {
+			compatible = "hpe,gxp-thumbnail";
+			reg = <0xc0000500 0x20>;
+			bits-per-pixel = <32>;
+			width = <800>;
+			height = <600>;
+		};
+
+		fanctrl: fanctrl@c1000c00 {
+			compatible = "hpe,gxp-fan-ctrl";
+			reg = <0xc1000c00 0x200>;
+			xreg_handle = <&xreg>;
+			fn2_handle = <&fn2>;
+		};
+
+		fn2: fn2@80200000 {
+			compatible = "hpe,gxp-fn2", "simple-mfd", "syscon";
+			reg = <0x80200000 0x100000>;
+			xreg_handle = <&xreg>;
+			interrupts = <0>;
+			interrupt-parent = <&vic1>;
+			#gpio-cells = <2>;
+			chif {
+				compatible = "hpe,gxp-chif";
+				interrupts = <12>;
+			};
+		};
+
+		xreg: xreg@d1000300 {
+			compatible = "hpe,gxp-xreg", "simple-mfd", "syscon";
+			reg = <0xd1000300 0xFF>;
+			interrupts = <26>;
+			interrupt-parent = <&vic0>;
+			#gpio-cells = <2>;
+		};
+
+		csm: csm@8000005c {
+			compatible = "hpe,gxp-csm", "simple-mfd", "syscon";
+			reg = <0x8000005c 0x2>, <0x800000de 0x1>, <0x800000e7 0x1>;
+		};
+
+		vuhc0: vuhc@80400000 {
+			compatible = "syscon";
+			reg = <0x80400000 0x80>;
+		};
+
+		udcg: udcg@80400800 {
+			compatible = "syscon";
+			reg = <0x80400800 0x200>;
+		};
+
+		post@800000a0 {
+			compatible = "hpe,gxp-dbg";
+			reg = <0x800000a0 0x20>;
+			interrupts = <10>;
+			interrupt-parent = <&vic1>;
+		};
+
+		coretemp: coretemp@c0000130 {
+			compatible = "hpe,gxp-coretemp";
+			reg = <0xc0000130 0x8>;
+		};
+	};
+
+	gpio: gpio {
+		compatible = "hpe,gxp-gpio";
+		#gpio-cells = <2>;
+		csm_handle = <&csm>;
+		vuhc0_handle = <&vuhc0>;
+	};
+
+	clocks {
+		osc: osc {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-output-names = "osc";
+			clock-frequency = <33333333>;
+		};
+
+		iopclk: iopclk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clocks = <&osc>;
+			clock-out-put-names = "iopclk";
+			clock-frequency = <400000000>;
+		};
+
+		memclk: memclk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clocks = <&osc>;
+			clock-out-put-names = "memclk";
+			clock-frequency = <800000000>;
+		};
+	};
+};
diff --git a/arch/arm/configs/gxp_defconfig b/arch/arm/configs/gxp_defconfig
new file mode 100644
index 000000000000..f37c6630e06d
--- /dev/null
+++ b/arch/arm/configs/gxp_defconfig
@@ -0,0 +1,243 @@
+CONFIG_KERNEL_XZ=y
+CONFIG_DEFAULT_HOSTNAME="gxp"
+CONFIG_SYSVIPC=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_BSD_PROCESS_ACCT=y
+CONFIG_BSD_PROCESS_ACCT_V3=y
+CONFIG_LOG_BUF_SHIFT=18
+CONFIG_CFS_BANDWIDTH=y
+CONFIG_RT_GROUP_SCHED=y
+CONFIG_CGROUP_FREEZER=y
+CONFIG_CGROUP_DEVICE=y
+CONFIG_CGROUP_CPUACCT=y
+CONFIG_NAMESPACES=y
+CONFIG_SCHED_AUTOGROUP=y
+CONFIG_RELAY=y
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_KALLSYMS_ALL=y
+CONFIG_EMBEDDED=y
+# CONFIG_COMPAT_BRK is not set
+CONFIG_SLAB=y
+CONFIG_ARCH_MULTI_V6=y
+CONFIG_ARCH_HPE=y
+CONFIG_ARCH_HPE_GXP=y
+CONFIG_SECCOMP=y
+# CONFIG_ATAGS is not set
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+# CONFIG_SUSPEND is not set
+CONFIG_JUMP_LABEL=y
+# CONFIG_STRICT_KERNEL_RWX is not set
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+CONFIG_KSM=y
+CONFIG_CLEANCACHE=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_PACKET_DIAG=y
+CONFIG_UNIX=y
+CONFIG_UNIX_DIAG=y
+CONFIG_XFRM_USER=y
+CONFIG_XFRM_STATISTICS=y
+CONFIG_INET=y
+CONFIG_VLAN_8021Q=y
+CONFIG_NETLINK_DIAG=y
+CONFIG_NET_NCSI=y
+# CONFIG_WIRELESS is not set
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_STANDALONE is not set
+CONFIG_MTD=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_PHYSMAP=y
+CONFIG_MTD_PHYSMAP_OF=y
+CONFIG_MTD_PLATRAM=y
+CONFIG_MTD_SPI_NOR=y
+CONFIG_SPI_GXP_SPIFI=y
+CONFIG_BLK_DEV_NULL_BLK=y
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_BLK_DEV_NBD=y
+CONFIG_BLK_DEV_RAM=y
+CONFIG_EEPROM_AT24=y
+CONFIG_SCSI=y
+CONFIG_BLK_DEV_SD=y
+# CONFIG_SCSI_LOWLEVEL is not set
+CONFIG_NETDEVICES=y
+# CONFIG_NET_VENDOR_ALACRITECH is not set
+# CONFIG_NET_VENDOR_AMAZON is not set
+# CONFIG_NET_VENDOR_AQUANTIA is not set
+# CONFIG_NET_VENDOR_ARC is not set
+# CONFIG_NET_VENDOR_AURORA is not set
+# CONFIG_NET_VENDOR_BROADCOM is not set
+# CONFIG_NET_VENDOR_CADENCE is not set
+# CONFIG_NET_VENDOR_CAVIUM is not set
+# CONFIG_NET_VENDOR_CIRRUS is not set
+# CONFIG_NET_VENDOR_CORTINA is not set
+# CONFIG_NET_VENDOR_EZCHIP is not set
+# CONFIG_NET_VENDOR_FARADAY is not set
+# CONFIG_NET_VENDOR_GOOGLE is not set
+# CONFIG_NET_VENDOR_HISILICON is not set
+# CONFIG_NET_VENDOR_HUAWEI is not set
+# CONFIG_NET_VENDOR_INTEL is not set
+# CONFIG_NET_VENDOR_MARVELL is not set
+# CONFIG_NET_VENDOR_MELLANOX is not set
+# CONFIG_NET_VENDOR_MICREL is not set
+# CONFIG_NET_VENDOR_MICROCHIP is not set
+# CONFIG_NET_VENDOR_MICROSEMI is not set
+# CONFIG_NET_VENDOR_NATSEMI is not set
+# CONFIG_NET_VENDOR_NETRONOME is not set
+# CONFIG_NET_VENDOR_NI is not set
+# CONFIG_NET_VENDOR_QUALCOMM is not set
+# CONFIG_NET_VENDOR_RENESAS is not set
+# CONFIG_NET_VENDOR_ROCKER is not set
+# CONFIG_NET_VENDOR_SAMSUNG is not set
+# CONFIG_NET_VENDOR_SEEQ is not set
+# CONFIG_NET_VENDOR_SOLARFLARE is not set
+# CONFIG_NET_VENDOR_SMSC is not set
+# CONFIG_NET_VENDOR_SOCIONEXT is not set
+# CONFIG_NET_VENDOR_STMICRO is not set
+# CONFIG_NET_VENDOR_SYNOPSYS is not set
+# CONFIG_NET_VENDOR_VIA is not set
+# CONFIG_NET_VENDOR_WIZNET is not set
+# CONFIG_NET_VENDOR_XILINX is not set
+CONFIG_UMAC=y
+# CONFIG_USB_NET_DRIVERS is not set
+# CONFIG_WLAN is not set
+# CONFIG_INPUT_LEDS is not set
+CONFIG_INPUT_EVDEV=y
+# CONFIG_KEYBOARD_ATKBD is not set
+CONFIG_KEYBOARD_GPIO=y
+CONFIG_KEYBOARD_GPIO_POLLED=y
+# CONFIG_INPUT_MOUSE is not set
+CONFIG_SERIO_LIBPS2=y
+CONFIG_VT_HW_CONSOLE_BINDING=y
+# CONFIG_LEGACY_PTYS is not set
+CONFIG_SERIAL_8250=y
+# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_NR_UARTS=6
+CONFIG_SERIAL_8250_RUNTIME_UARTS=6
+CONFIG_SERIAL_8250_EXTENDED=y
+CONFIG_SERIAL_8250_SHARE_IRQ=y
+CONFIG_SERIAL_8250_GXP_VUART=y
+CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_TTY_PRINTK=y
+CONFIG_IPMI_HANDLER=y
+CONFIG_IPMI_DEVICE_INTERFACE=y
+CONFIG_IPMI_SI=y
+CONFIG_IPMI_SSIF=y
+CONFIG_HPE_KCS_IPMI_BMC=y
+CONFIG_HW_RANDOM_TIMERIOMEM=y
+CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_GXP=y
+CONFIG_I2C_SLAVE=y
+CONFIG_I2C_SLAVE_EEPROM=y
+CONFIG_SPI=y
+CONFIG_GPIOLIB=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_GPIO_GXP=y
+CONFIG_SENSORS_EMC1403=y
+CONFIG_SENSORS_GXP_FAN_CTRL=y
+CONFIG_SENSORS_GXP_CORETEMP=y
+CONFIG_SENSORS_GXP_PSU=y
+CONFIG_SENSORS_GXP_POWER=y
+CONFIG_WATCHDOG=y
+CONFIG_GXP_WATCHDOG=y
+CONFIG_MFD_SYSCON=y
+CONFIG_FB=y
+CONFIG_FB_THUMBNAIL=y
+CONFIG_FB_SIMPLE=y
+CONFIG_USB=y
+CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
+CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_ROOT_HUB_TT=y
+CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_OHCI_HCD_PLATFORM=y
+CONFIG_USB_STORAGE=y
+CONFIG_USB_GADGET=y
+CONFIG_USB_GXP_UDC=y
+CONFIG_USB_CONFIGFS=y
+CONFIG_USB_CONFIGFS_SERIAL=y
+CONFIG_USB_CONFIGFS_ACM=y
+CONFIG_USB_CONFIGFS_OBEX=y
+CONFIG_USB_CONFIGFS_NCM=y
+CONFIG_USB_CONFIGFS_ECM=y
+CONFIG_USB_CONFIGFS_ECM_SUBSET=y
+CONFIG_USB_CONFIGFS_RNDIS=y
+CONFIG_USB_CONFIGFS_EEM=y
+CONFIG_USB_CONFIGFS_MASS_STORAGE=y
+CONFIG_USB_CONFIGFS_F_LB_SS=y
+CONFIG_USB_CONFIGFS_F_FS=y
+CONFIG_USB_CONFIGFS_F_HID=y
+CONFIG_USB_CONFIGFS_F_PRINTER=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_ONESHOT=y
+CONFIG_LEDS_TRIGGER_MTD=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_CPU=y
+CONFIG_LEDS_TRIGGER_GPIO=y
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
+CONFIG_LEDS_TRIGGER_TRANSIENT=y
+CONFIG_LEDS_TRIGGER_PANIC=y
+# CONFIG_VIRTIO_MENU is not set
+# CONFIG_IOMMU_SUPPORT is not set
+CONFIG_HPE_GXP_XREG=y
+CONFIG_HPE_GXP_FN2=y
+CONFIG_HPE_GXP_CSM=y
+CONFIG_HPE_GXP_SROM=y
+CONFIG_FANOTIFY=y
+CONFIG_OVERLAY_FS=y
+CONFIG_OVERLAY_FS_REDIRECT_DIR=y
+CONFIG_TMPFS=y
+CONFIG_TMPFS_POSIX_ACL=y
+CONFIG_JFFS2_FS=y
+# CONFIG_JFFS2_FS_WRITEBUFFER is not set
+CONFIG_JFFS2_SUMMARY=y
+CONFIG_JFFS2_FS_XATTR=y
+# CONFIG_JFFS2_FS_POSIX_ACL is not set
+# CONFIG_JFFS2_FS_SECURITY is not set
+CONFIG_SQUASHFS=y
+CONFIG_SQUASHFS_XZ=y
+CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
+# CONFIG_NETWORK_FILESYSTEMS is not set
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_ASCII=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_NLS_UTF8=y
+CONFIG_CRYPTO_CCM=y
+CONFIG_CRYPTO_GCM=y
+CONFIG_CRYPTO_CRC32C=y
+CONFIG_CRYPTO_ARC4=y
+CONFIG_CRYPTO_DEFLATE=y
+CONFIG_CRYPTO_LZO=y
+CONFIG_CRYPTO_ZSTD=y
+CONFIG_CRYPTO_USER_API_HASH=y
+# CONFIG_CRYPTO_HW is not set
+CONFIG_CRC16=y
+# CONFIG_XZ_DEC_ARM is not set
+# CONFIG_XZ_DEC_ARMTHUMB is not set
+CONFIG_DMA_API_DEBUG=y
+CONFIG_PRINTK_TIME=y
+CONFIG_BOOT_PRINTK_DELAY=y
+CONFIG_DYNAMIC_DEBUG=y
+CONFIG_DEBUG_INFO=y
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_PANIC_ON_OOPS=y
+CONFIG_FUNCTION_PROFILER=y
+CONFIG_STACK_TRACER=y
+CONFIG_SCHED_TRACER=y
+CONFIG_STRICT_DEVMEM=y
+CONFIG_DEBUG_USER=y
+CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
+CONFIG_DEBUG_UART_PHYS=0xC00000F0
+CONFIG_DEBUG_UART_VIRT=0xF00000F0
+CONFIG_DEBUG_UART_8250_SHIFT=0
+CONFIG_EARLY_PRINTK=y
+CONFIG_TEST_KSTRTOX=y
diff --git a/arch/arm/mach-hpe/Kconfig b/arch/arm/mach-hpe/Kconfig
new file mode 100644
index 000000000000..cc63f2be6c9c
--- /dev/null
+++ b/arch/arm/mach-hpe/Kconfig
@@ -0,0 +1,21 @@
+# SPDX-License-Identifier: GPL-2.0-only
+menuconfig ARCH_HPE
+	bool "HPE SoC support"
+	help
+	  This enables support for HPE ARM based SoC chips
+if ARCH_HPE
+
+config ARCH_HPE_GXP
+	bool "HPE GXP SoC"
+	select ARM_VIC
+	select PINCTRL
+	select IRQ_DOMAIN
+	select GENERIC_IRQ_CHIP
+	select MULTI_IRQ_HANDLER
+	select SPARSE_IRQ
+	select CLKSRC_MMIO
+	depends on ARCH_MULTI_V7
+	help
+	  Support for GXP SoCs
+
+endif
diff --git a/arch/arm/mach-hpe/Makefile b/arch/arm/mach-hpe/Makefile
new file mode 100644
index 000000000000..8b0a91234df4
--- /dev/null
+++ b/arch/arm/mach-hpe/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ARCH_HPE_GXP) += gxp.o
diff --git a/arch/arm/mach-hpe/gxp.c b/arch/arm/mach-hpe/gxp.c
new file mode 100644
index 000000000000..a37838247948
--- /dev/null
+++ b/arch/arm/mach-hpe/gxp.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022 Hewlett-Packard Enterprise Development Company, L.P.
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
+#include <linux/init.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/clk-provider.h>
+#include <linux/clocksource.h>
+
+#define IOP_REGS_PHYS_BASE 0xc0000000
+#define IOP_REGS_VIRT_BASE 0xf0000000
+#define IOP_REGS_SIZE (240*SZ_1M)
+
+#define IOP_EHCI_USBCMD 0x0efe0010
+
+static struct map_desc gxp_io_desc[] __initdata = {
+	{
+	.virtual	= (unsigned long)IOP_REGS_VIRT_BASE,
+	.pfn		= __phys_to_pfn(IOP_REGS_PHYS_BASE),
+	.length		= IOP_REGS_SIZE,
+	.type		= MT_DEVICE,
+	},
+};
+
+void __init gxp_map_io(void)
+{
+	iotable_init(gxp_io_desc, ARRAY_SIZE(gxp_io_desc));
+}
+
+static void __init gxp_dt_init(void)
+{
+	/*reset EHCI host controller for clear start*/
+	__raw_writel(0x00080002,
+		(void __iomem *)(IOP_REGS_VIRT_BASE + IOP_EHCI_USBCMD));
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static void gxp_restart(enum reboot_mode mode, const char *cmd)
+{
+	__raw_writel(1, (void __iomem *) IOP_REGS_VIRT_BASE);
+}
+
+static const char * const gxp_board_dt_compat[] = {
+	"HPE,GXP",
+	NULL,
+};
+
+DT_MACHINE_START(GXP_DT, "HPE GXP")
+	.init_machine	= gxp_dt_init,
+	.map_io		= gxp_map_io,
+	.restart	= gxp_restart,
+	.dt_compat	= gxp_board_dt_compat,
+MACHINE_END
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index cfb8ea0df3b1..5916dade7608 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -617,6 +617,14 @@ config CLKSRC_ST_LPC
 	  Enable this option to use the Low Power controller timer
 	  as clocksource.
 
+config GXP_TIMER
+	bool "GXP timer driver"
+	depends on ARCH_HPE
+	default y
+	help
+	  Provides a driver for the timer control found on HPE
+	  GXP SOCs. This is required for all GXP SOCs.
+
 config ATCPIT100_TIMER
 	bool "ATCPIT100 timer driver"
 	depends on NDS32 || COMPILE_TEST
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index fa5f624eadb6..ffca09ec34de 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -89,3 +89,4 @@ obj-$(CONFIG_GX6605S_TIMER)		+= timer-gx6605s.o
 obj-$(CONFIG_HYPERV_TIMER)		+= hyperv_timer.o
 obj-$(CONFIG_MICROCHIP_PIT64B)		+= timer-microchip-pit64b.o
 obj-$(CONFIG_MSC313E_TIMER)		+= timer-msc313e.o
+obj-$(CONFIG_GXP_TIMER)			+= gxp_timer.o
diff --git a/drivers/clocksource/gxp_timer.c b/drivers/clocksource/gxp_timer.c
new file mode 100644
index 000000000000..e3c617036e0d
--- /dev/null
+++ b/drivers/clocksource/gxp_timer.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022 Hewlett-Packard Enterprise Development Company, L.P.
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bitops.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/interrupt.h>
+#include <linux/irqreturn.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/sched_clock.h>
+
+#include <asm/irq.h>
+
+#define TIMER0_FREQ 1000000
+#define TIMER1_FREQ 1000000
+
+#define MASK_TCS_ENABLE		0x01
+#define MASK_TCS_PERIOD		0x02
+#define MASK_TCS_RELOAD		0x04
+#define MASK_TCS_TC		0x80
+
+struct gxp_timer {
+	void __iomem *counter;
+	void __iomem *control;
+	struct clock_event_device evt;
+};
+
+static void __iomem *system_clock __read_mostly;
+
+static u64 notrace gxp_sched_read(void)
+{
+	return readl_relaxed(system_clock);
+}
+
+static int gxp_time_set_next_event(unsigned long event,
+					struct clock_event_device *evt_dev)
+{
+	struct gxp_timer *timer = container_of(evt_dev, struct gxp_timer, evt);
+	/*clear TC by write 1 and disable timer int and counting*/
+	writeb_relaxed(MASK_TCS_TC, timer->control);
+	/*update counter value*/
+	writel_relaxed(event, timer->counter);
+	/*enable timer counting and int*/
+	writeb_relaxed(MASK_TCS_TC|MASK_TCS_ENABLE, timer->control);
+
+	return 0;
+}
+
+static irqreturn_t gxp_time_interrupt(int irq, void *dev_id)
+{
+	struct gxp_timer *timer = dev_id;
+	void (*event_handler)(struct clock_event_device *timer);
+
+
+	if (readb_relaxed(timer->control) & MASK_TCS_TC) {
+		writeb_relaxed(MASK_TCS_TC, timer->control);
+
+		event_handler = READ_ONCE(timer->evt.event_handler);
+		if (event_handler)
+			event_handler(&timer->evt);
+		return IRQ_HANDLED;
+	} else {
+		return IRQ_NONE;
+	}
+}
+
+static int __init gxp_timer_init(struct device_node *node)
+{
+	void __iomem *base_counter;
+	void __iomem *base_control;
+	u32 freq;
+	int ret, irq;
+	struct gxp_timer *gxp_timer;
+
+	base_counter = of_iomap(node, 0);
+	if (!base_counter) {
+		pr_err("Can't remap counter registers");
+		return -ENXIO;
+	}
+
+	base_control = of_iomap(node, 1);
+	if (!base_control) {
+		pr_err("Can't remap control registers");
+		return -ENXIO;
+	}
+
+	system_clock = of_iomap(node, 2);
+	if (!system_clock) {
+		pr_err("Can't remap control registers");
+		return -ENXIO;
+	}
+
+	if (of_property_read_u32(node, "clock-frequency", &freq)) {
+		pr_err("Can't read clock-frequency\n");
+		goto err_iounmap;
+	}
+
+	sched_clock_register(gxp_sched_read, 32, freq);
+	clocksource_mmio_init(system_clock, node->name, freq,
+				300, 32, clocksource_mmio_readl_up);
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq <= 0) {
+		ret = -EINVAL;
+		pr_err("GXP Timer Can't parse IRQ %d", irq);
+		goto err_iounmap;
+	}
+
+	gxp_timer = kzalloc(sizeof(*gxp_timer), GFP_KERNEL);
+	if (!gxp_timer) {
+		ret = -ENOMEM;
+		goto err_iounmap;
+	}
+
+	gxp_timer->counter = base_counter;
+	gxp_timer->control = base_control;
+	gxp_timer->evt.name = node->name;
+	gxp_timer->evt.rating = 300;
+	gxp_timer->evt.features = CLOCK_EVT_FEAT_ONESHOT;
+	gxp_timer->evt.set_next_event = gxp_time_set_next_event;
+	gxp_timer->evt.cpumask = cpumask_of(0);
+
+	if (request_irq(irq, gxp_time_interrupt, IRQF_TIMER | IRQF_SHARED,
+		node->name, gxp_timer)) {
+		pr_err("%s: request_irq() failed\n", "GXP Timer Tick");
+		goto err_timer_free;
+	}
+
+	clockevents_config_and_register(&gxp_timer->evt, TIMER0_FREQ,
+					0xf, 0xffffffff);
+
+	pr_info("gxp: system timer (irq = %d)\n", irq);
+	return 0;
+
+
+err_timer_free:
+	kfree(gxp_timer);
+
+err_iounmap:
+	iounmap(system_clock);
+	iounmap(base_control);
+	iounmap(base_counter);
+	return ret;
+}
+
+TIMER_OF_DECLARE(gxp, "hpe,gxp-timer", gxp_timer_init);
-- 
2.17.1

