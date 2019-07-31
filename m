Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B3F7CDC7
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfGaUFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:05:46 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:38567 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfGaUFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:05:46 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Ml3ym-1ie2tU2XXw-00lY85; Wed, 31 Jul 2019 22:05:08 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] ARM: dove: clean up mach/*.h headers
Date:   Wed, 31 Jul 2019 21:56:54 +0200
Message-Id: <20190731195713.3150463-13-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731195713.3150463-1-arnd@arndb.de>
References: <20190731195713.3150463-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:wm+KSeGGuXF5WOxKnt5YWZSFWSzwpQiV1pnc7vH9hnQfyF3uo3n
 gCrFBQ3yKHG0+DFWqQmfJqP6Itkdlnc8qKU99KkNC34vbDMv3YzmXoRwQFdjHC8eo7cpDHV
 j+SDEsiC6bWTa2enEM/7xwU7Kn5GLhBnlOb3naY4fXgocB8zpeFrPODfH8cbg3PRji5BClB
 j8I/Iv2fiM5yc2zhXYchQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5i9Pzgm/3dc=:/w8M1fT6vtSN5U1kHGY3ph
 SGSal8B1dZSKdDqAKV4r8z+19BRsTRWV16aimYGBkMDHyOUz6zpNKR4niLX/Om2qVaOQURJbL
 XURssmFZVOd8nruSi4JIxo9+TLstHX/YfK6xSI0/W42yzX8Y6brLdEPD+vU6LayI8OHSZr1mM
 Vbf0ESPZP0wo5wj5KNHgpJlbQmNb63x+7ABammyca8R2lwHzDfvYwu4R51VBnbiLrslfLjbns
 JPTvxyOWxtV7X56r6lSTiU3tyHin5fOZWnSD7b9mtkZ/es9F6EIx23V8OdLWXsivZjbWAxVui
 7jfvISGfL858CtIlqu0abInX7iom6syFCHd/risPtyzH/8JzwPUdJV5z7ddlWiRIKXPGBdPse
 uYr6aeY0kmuOGfP8wSl7HkVPnf+Y3HRfzBePoED2LQPqEP9kD3y7CO5hOQEay1UJ6yn35LQ85
 AkE8v7PeVXAxQ9Xd274uGZaTlhrfKLmt0fz/erSf6DS42HxMbcZe8cA9nT0OGb+qvw7VEbg3O
 N/HH/DkBh8Ckk1FEaqvDz7wuAHGrqiRlm+rlCNbJ5Zg6IjfZHcuQshUknPCoFOHtp3HHU46n6
 3cSEpfZjWPldZXeQqZzlTvel84GguhGCCFVRS+AtoaVUP0zZntzy+e18HerdrZ28fUeulDRn9
 wL88M+46YUFYW7o7K6zhFZ56wPZP+kO52PeXe44ViwpGJtwDCMKjz3LzfOgpLuPBluglyHuJm
 nFAS/hbAMJgT66nhvQMH9GdS8rPtkQfCmJ0Ifw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a simple move of all header files that are no longer
included by anything else from the include/mach directory
to the platform directory itself as preparation for
multiplatform support.

The mach/uncompress.h headers are left in place for now,
and are mildly modified to be independent of the other
headers. They will be removed entirely when ARCH_MULTIPLATFORM
gets enabled and they become obsolete.

Rather than updating the path names inside of the comments
of each header, I delete those comments to avoid having to
update them again, should they get moved or copied another
time.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Andrew Lunn <andrew@lunn.ch>
---
 .../{include/mach => }/bridge-regs.h          |  4 +---
 arch/arm/mach-dove/cm-a510.c                  |  3 +--
 arch/arm/mach-dove/common.c                   |  4 ++--
 arch/arm/mach-dove/dove-db-setup.c            |  2 +-
 arch/arm/mach-dove/{include/mach => }/dove.h  |  4 +---
 arch/arm/mach-dove/include/mach/hardware.h    | 19 -------------------
 arch/arm/mach-dove/include/mach/uncompress.h  |  8 +++-----
 arch/arm/mach-dove/irq.c                      |  5 ++++-
 arch/arm/mach-dove/{include/mach => }/irqs.h  |  2 --
 arch/arm/mach-dove/mpp.c                      |  2 +-
 arch/arm/mach-dove/pcie.c                     |  4 ++--
 arch/arm/mach-dove/{include/mach => }/pm.h    |  4 +---
 12 files changed, 17 insertions(+), 44 deletions(-)
 rename arch/arm/mach-dove/{include/mach => }/bridge-regs.h (96%)
 rename arch/arm/mach-dove/{include/mach => }/dove.h (99%)
 delete mode 100644 arch/arm/mach-dove/include/mach/hardware.h
 rename arch/arm/mach-dove/{include/mach => }/irqs.h (98%)
 rename arch/arm/mach-dove/{include/mach => }/pm.h (97%)

diff --git a/arch/arm/mach-dove/include/mach/bridge-regs.h b/arch/arm/mach-dove/bridge-regs.h
similarity index 96%
rename from arch/arm/mach-dove/include/mach/bridge-regs.h
rename to arch/arm/mach-dove/bridge-regs.h
index f4a5b34489b7..ace0b0bfbf11 100644
--- a/arch/arm/mach-dove/include/mach/bridge-regs.h
+++ b/arch/arm/mach-dove/bridge-regs.h
@@ -1,6 +1,4 @@
 /*
- * arch/arm/mach-dove/include/mach/bridge-regs.h
- *
  * Mbus-L to Mbus Bridge Registers
  *
  * This file is licensed under the terms of the GNU General Public
@@ -11,7 +9,7 @@
 #ifndef __ASM_ARCH_BRIDGE_REGS_H
 #define __ASM_ARCH_BRIDGE_REGS_H
 
-#include <mach/dove.h>
+#include "dove.h"
 
 #define CPU_CONFIG		(BRIDGE_VIRT_BASE + 0x0000)
 
diff --git a/arch/arm/mach-dove/cm-a510.c b/arch/arm/mach-dove/cm-a510.c
index b9a7c33db29a..9f25c993d863 100644
--- a/arch/arm/mach-dove/cm-a510.c
+++ b/arch/arm/mach-dove/cm-a510.c
@@ -22,8 +22,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/dove.h>
-
+#include "dove.h"
 #include "common.h"
 
 static struct mv643xx_eth_platform_data cm_a510_ge00_data = {
diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index d7b826d2695c..01b830afcea9 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -22,11 +22,11 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
-#include <mach/bridge-regs.h>
-#include <mach/pm.h>
 #include <plat/common.h>
 #include <plat/irq.h>
 #include <plat/time.h>
+#include "bridge-regs.h"
+#include "pm.h"
 #include "common.h"
 
 /* These can go away once Dove uses the mvebu-mbus DT binding */
diff --git a/arch/arm/mach-dove/dove-db-setup.c b/arch/arm/mach-dove/dove-db-setup.c
index 8971c3c0f0fe..418ab21b9d9b 100644
--- a/arch/arm/mach-dove/dove-db-setup.c
+++ b/arch/arm/mach-dove/dove-db-setup.c
@@ -24,7 +24,7 @@
 #include <linux/gpio.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-#include <mach/dove.h>
+#include "dove.h"
 #include "common.h"
 
 static struct mv643xx_eth_platform_data dove_db_ge00_data = {
diff --git a/arch/arm/mach-dove/include/mach/dove.h b/arch/arm/mach-dove/dove.h
similarity index 99%
rename from arch/arm/mach-dove/include/mach/dove.h
rename to arch/arm/mach-dove/dove.h
index 00f45458b3ec..539e735f968d 100644
--- a/arch/arm/mach-dove/include/mach/dove.h
+++ b/arch/arm/mach-dove/dove.h
@@ -1,6 +1,4 @@
 /*
- * arch/arm/mach-dove/include/mach/dove.h
- *
  * Generic definitions for Marvell Dove 88AP510 SoC
  *
  * This file is licensed under the terms of the GNU General Public
@@ -11,7 +9,7 @@
 #ifndef __ASM_ARCH_DOVE_H
 #define __ASM_ARCH_DOVE_H
 
-#include <mach/irqs.h>
+#include "irqs.h"
 
 /*
  * Marvell Dove address maps.
diff --git a/arch/arm/mach-dove/include/mach/hardware.h b/arch/arm/mach-dove/include/mach/hardware.h
deleted file mode 100644
index f1368b9a8ece..000000000000
--- a/arch/arm/mach-dove/include/mach/hardware.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * arch/arm/mach-dove/include/mach/hardware.h
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2.  This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#ifndef __ASM_ARCH_HARDWARE_H
-#define __ASM_ARCH_HARDWARE_H
-
-#include "dove.h"
-
-/* Macros below are required for compatibility with PXA AC'97 driver.	*/
-#define __REG(x)	(*((volatile u32 *)((x) - DOVE_SB_REGS_PHYS_BASE + \
-				DOVE_SB_REGS_VIRT_BASE)))
-#define __PREG(x)	(((u32)&(x)) - DOVE_SB_REGS_VIRT_BASE + \
-		DOVE_SB_REGS_PHYS_BASE)
-#endif
diff --git a/arch/arm/mach-dove/include/mach/uncompress.h b/arch/arm/mach-dove/include/mach/uncompress.h
index 5c8ae9b9d39a..7a4bd8838036 100644
--- a/arch/arm/mach-dove/include/mach/uncompress.h
+++ b/arch/arm/mach-dove/include/mach/uncompress.h
@@ -1,15 +1,13 @@
 /*
- * arch/arm/mach-dove/include/mach/uncompress.h
- *
  * This file is licensed under the terms of the GNU General Public
  * License version 2.  This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
  */
 
-#include <mach/dove.h>
+#define UART0_PHYS_BASE (0xf1000000 + 0x12000)
 
-#define UART_THR ((volatile unsigned char *)(DOVE_UART0_PHYS_BASE + 0x0))
-#define UART_LSR ((volatile unsigned char *)(DOVE_UART0_PHYS_BASE + 0x14))
+#define UART_THR ((volatile unsigned char *)(UART0_PHYS_BASE + 0x0))
+#define UART_LSR ((volatile unsigned char *)(UART0_PHYS_BASE + 0x14))
 
 #define LSR_THRE	0x20
 
diff --git a/arch/arm/mach-dove/irq.c b/arch/arm/mach-dove/irq.c
index d6627c1f7f30..31ccbcee2627 100644
--- a/arch/arm/mach-dove/irq.c
+++ b/arch/arm/mach-dove/irq.c
@@ -11,9 +11,12 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <asm/exception.h>
+
 #include <plat/irq.h>
-#include <mach/bridge-regs.h>
 #include <plat/orion-gpio.h>
+
+#include "pm.h"
+#include "bridge-regs.h"
 #include "common.h"
 
 static int __initdata gpio0_irqs[4] = {
diff --git a/arch/arm/mach-dove/include/mach/irqs.h b/arch/arm/mach-dove/irqs.h
similarity index 98%
rename from arch/arm/mach-dove/include/mach/irqs.h
rename to arch/arm/mach-dove/irqs.h
index 8ff0fa8b4fcd..a0742179faff 100644
--- a/arch/arm/mach-dove/include/mach/irqs.h
+++ b/arch/arm/mach-dove/irqs.h
@@ -1,6 +1,4 @@
 /*
- * arch/arm/mach-dove/include/mach/irqs.h
- *
  * IRQ definitions for Marvell Dove 88AP510 SoC
  *
  * This file is licensed under the terms of the GNU General Public
diff --git a/arch/arm/mach-dove/mpp.c b/arch/arm/mach-dove/mpp.c
index 8a433a51289c..6acd8488bb05 100644
--- a/arch/arm/mach-dove/mpp.c
+++ b/arch/arm/mach-dove/mpp.c
@@ -12,8 +12,8 @@
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <plat/mpp.h>
-#include <mach/dove.h>
 #include <plat/orion-gpio.h>
+#include "dove.h"
 #include "mpp.h"
 
 struct dove_mpp_grp {
diff --git a/arch/arm/mach-dove/pcie.c b/arch/arm/mach-dove/pcie.c
index dfb62f3f5dcf..ee91ac6b5ebf 100644
--- a/arch/arm/mach-dove/pcie.c
+++ b/arch/arm/mach-dove/pcie.c
@@ -17,9 +17,9 @@
 #include <asm/setup.h>
 #include <asm/delay.h>
 #include <plat/pcie.h>
-#include <mach/irqs.h>
-#include <mach/bridge-regs.h>
 #include <plat/addr-map.h>
+#include "irqs.h"
+#include "bridge-regs.h"
 #include "common.h"
 
 struct pcie_port {
diff --git a/arch/arm/mach-dove/include/mach/pm.h b/arch/arm/mach-dove/pm.h
similarity index 97%
rename from arch/arm/mach-dove/include/mach/pm.h
rename to arch/arm/mach-dove/pm.h
index d22b9b174007..01267746d707 100644
--- a/arch/arm/mach-dove/include/mach/pm.h
+++ b/arch/arm/mach-dove/pm.h
@@ -1,6 +1,4 @@
 /*
- * arch/arm/mach-dove/include/mach/pm.h
- *
  * This file is licensed under the terms of the GNU General Public
  * License version 2.  This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
@@ -10,7 +8,7 @@
 #define __ASM_ARCH_PM_H
 
 #include <asm/errno.h>
-#include <mach/irqs.h>
+#include "irqs.h"
 
 #define CLOCK_GATING_CONTROL	(DOVE_PMU_VIRT_BASE + 0x38)
 #define  CLOCK_GATING_BIT_USB0		0
-- 
2.20.0

