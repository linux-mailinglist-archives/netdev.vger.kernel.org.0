Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC072F8FDD
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKLMo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:44:58 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33535 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbfKLMo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:56 -0500
Received: by mail-wm1-f67.google.com with SMTP id a17so2256558wmb.0
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zfCGd9Wh1GZULLFtr2NjQya/R9aGRqweFuSz6coB51o=;
        b=ti86A1n2oCfLfnsJMXssLvmwtBHCEPwLUcuLzGwAJ5R9mWFquoObcVvph1x0Ilgtyk
         AD4wys+yz6uuIsfH0vg0lI2QsTon0OLfYXLmNlxECmyxja9t84h6neGN+mnxaZGrWwuK
         Qfg9SPuYHmRFuXfylhBu4GF22jJAAzGvzlf4gXfMCnHa26/Zs90yD97EKTG2rWCHBTjh
         Prmp3KoISe1yp018O7OL2lKbadWHbBHtVuSioIV0Vw9MYseMFL6JOREtj05g/+brC0m1
         mH7UNaQ9Qm84YLG6PWs3vMuKyAQvXXwfJJx3FaFTIUcfL2NB7pyJW3yrkFxtjH4fyOta
         AEpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zfCGd9Wh1GZULLFtr2NjQya/R9aGRqweFuSz6coB51o=;
        b=lWF9k4d6zLQZj7YL7+2XiiqRTgJyOsxfd9k4mG3G3CxSNdT5HNAvP6cdM6iBbGvWnM
         YtJRZYoTi3kM5gVIuQMLb5F0cjRuP0oCHQ+DE+YqsCHYUXS4l1P74g1Fhf35CIPtVGJP
         KjLHKa6RpkzINfqdjcexSDONsutb9TecnelJkgPlCox5csNVF496wmAGncVqNviD2pZP
         8MI5qXz22tU9TblzAA3ACHGtAJLaQnBgrYA2F2oRFqoUpeQFlspNzSu2BJU6cOoS3ygz
         AjvTrkaG35Nl7TciwOjMnk667YOCFQras5WtwzES+Fxb6YY3e/DOqLa+6cSgNutThP3J
         U9ug==
X-Gm-Message-State: APjAAAVU+tumlvyNLaFLMCYzZQ6qIbPiCkHg/8wDOfg6trcKKQj92URv
        uGM7tIkTT2TqhKtw7cL7w9s=
X-Google-Smtp-Source: APXvYqz27zWLJb5wQ1IBdR5rzXauWs8GIOoLrvJbdSC/mpvG/O2N7aOe0mlJoepjNJhw/9qNpJLTDQ==
X-Received: by 2002:a1c:a791:: with SMTP id q139mr3647234wme.155.1573562692376;
        Tue, 12 Nov 2019 04:44:52 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:51 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 10/12] net: dsa: vitesse: move vsc73xx driver to a separate folder
Date:   Tue, 12 Nov 2019 14:44:18 +0200
Message-Id: <20191112124420.6225-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112124420.6225-1-olteanv@gmail.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The vitesse/ folder will contain drivers for switching chips derived
from legacy Vitesse IPs (VSC family), including those produced by
Microsemi and Microchip (acquirers of Vitesse).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/Kconfig                       | 31 +------------------
 drivers/net/dsa/Makefile                      |  4 +--
 drivers/net/dsa/vitesse/Kconfig               | 31 +++++++++++++++++++
 drivers/net/dsa/vitesse/Makefile              |  3 ++
 .../vsc73xx-core.c}                           |  2 +-
 .../vsc73xx-platform.c}                       |  2 +-
 .../vsc73xx-spi.c}                            |  2 +-
 .../{vitesse-vsc73xx.h => vitesse/vsc73xx.h}  |  0
 8 files changed, 39 insertions(+), 36 deletions(-)
 create mode 100644 drivers/net/dsa/vitesse/Kconfig
 create mode 100644 drivers/net/dsa/vitesse/Makefile
 rename drivers/net/dsa/{vitesse-vsc73xx-core.c => vitesse/vsc73xx-core.c} (99%)
 rename drivers/net/dsa/{vitesse-vsc73xx-platform.c => vitesse/vsc73xx-platform.c} (99%)
 rename drivers/net/dsa/{vitesse-vsc73xx-spi.c => vitesse/vsc73xx-spi.c} (99%)
 rename drivers/net/dsa/{vitesse-vsc73xx.h => vitesse/vsc73xx.h} (100%)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 685e12b05a7c..ec91960e58ac 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -99,35 +99,6 @@ config NET_DSA_SMSC_LAN9303_MDIO
 	  Enable access functions if the SMSC/Microchip LAN9303 is configured
 	  for MDIO managed mode.
 
-config NET_DSA_VITESSE_VSC73XX
-	tristate
-	depends on OF
-	depends on NET_DSA
-	select FIXED_PHY
-	select VITESSE_PHY
-	select GPIOLIB
-	---help---
-	  This enables support for the Vitesse VSC7385, VSC7388,
-	  VSC7395 and VSC7398 SparX integrated ethernet switches.
+source "drivers/net/dsa/vitesse/Kconfig"
 
-config NET_DSA_VITESSE_VSC73XX_SPI
-	tristate "Vitesse VSC7385/7388/7395/7398 SPI mode support"
-	depends on OF
-	depends on NET_DSA
-	depends on SPI
-	select NET_DSA_VITESSE_VSC73XX
-	---help---
-	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
-	  and VSC7398 SparX integrated ethernet switches in SPI managed mode.
-
-config NET_DSA_VITESSE_VSC73XX_PLATFORM
-	tristate "Vitesse VSC7385/7388/7395/7398 Platform mode support"
-	depends on OF
-	depends on NET_DSA
-	depends on HAS_IOMEM
-	select NET_DSA_VITESSE_VSC73XX
-	---help---
-	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
-	  and VSC7398 SparX integrated ethernet switches, connected over
-	  a CPU-attached address bus and work in memory-mapped I/O mode.
 endmenu
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index ae70b79628d6..158d34f8c085 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -14,10 +14,8 @@ realtek-smi-objs		:= realtek-smi-core.o rtl8366.o rtl8366rb.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
-obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx-core.o
-obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vitesse-vsc73xx-platform.o
-obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
 obj-y				+= b53/
 obj-y				+= microchip/
 obj-y				+= mv88e6xxx/
 obj-y				+= sja1105/
+obj-y				+= vitesse/
diff --git a/drivers/net/dsa/vitesse/Kconfig b/drivers/net/dsa/vitesse/Kconfig
new file mode 100644
index 000000000000..54be4b34fd17
--- /dev/null
+++ b/drivers/net/dsa/vitesse/Kconfig
@@ -0,0 +1,31 @@
+config NET_DSA_VITESSE_VSC73XX
+	tristate
+	depends on OF
+	depends on NET_DSA
+	select FIXED_PHY
+	select VITESSE_PHY
+	select GPIOLIB
+	---help---
+	  This enables support for the Vitesse VSC7385, VSC7388,
+	  VSC7395 and VSC7398 SparX integrated ethernet switches.
+
+config NET_DSA_VITESSE_VSC73XX_SPI
+	tristate "Vitesse VSC7385/7388/7395/7398 SPI mode support"
+	depends on OF
+	depends on NET_DSA
+	depends on SPI
+	select NET_DSA_VITESSE_VSC73XX
+	---help---
+	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
+	  and VSC7398 SparX integrated ethernet switches in SPI managed mode.
+
+config NET_DSA_VITESSE_VSC73XX_PLATFORM
+	tristate "Vitesse VSC7385/7388/7395/7398 Platform mode support"
+	depends on OF
+	depends on NET_DSA
+	depends on HAS_IOMEM
+	select NET_DSA_VITESSE_VSC73XX
+	---help---
+	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
+	  and VSC7398 SparX integrated ethernet switches, connected over
+	  a CPU-attached address bus and work in memory-mapped I/O mode.
diff --git a/drivers/net/dsa/vitesse/Makefile b/drivers/net/dsa/vitesse/Makefile
new file mode 100644
index 000000000000..adceeeec5d12
--- /dev/null
+++ b/drivers/net/dsa/vitesse/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vsc73xx-core.o
+obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vsc73xx-platform.o
+obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vsc73xx-spi.o
diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse/vsc73xx-core.c
similarity index 99%
rename from drivers/net/dsa/vitesse-vsc73xx-core.c
rename to drivers/net/dsa/vitesse/vsc73xx-core.c
index 42c1574d45f2..d44dc5821938 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse/vsc73xx-core.c
@@ -28,7 +28,7 @@
 #include <linux/random.h>
 #include <net/dsa.h>
 
-#include "vitesse-vsc73xx.h"
+#include "vsc73xx.h"
 
 #define VSC73XX_BLOCK_MAC	0x1 /* Subblocks 0-4, 6 (CPU port) */
 #define VSC73XX_BLOCK_ANALYZER	0x2 /* Only subblock 0 */
diff --git a/drivers/net/dsa/vitesse-vsc73xx-platform.c b/drivers/net/dsa/vitesse/vsc73xx-platform.c
similarity index 99%
rename from drivers/net/dsa/vitesse-vsc73xx-platform.c
rename to drivers/net/dsa/vitesse/vsc73xx-platform.c
index 0541785f9fee..0ccf622aff96 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-platform.c
+++ b/drivers/net/dsa/vitesse/vsc73xx-platform.c
@@ -20,7 +20,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
-#include "vitesse-vsc73xx.h"
+#include "vsc73xx.h"
 
 #define VSC73XX_CMD_PLATFORM_BLOCK_SHIFT		14
 #define VSC73XX_CMD_PLATFORM_BLOCK_MASK			0x7
diff --git a/drivers/net/dsa/vitesse-vsc73xx-spi.c b/drivers/net/dsa/vitesse/vsc73xx-spi.c
similarity index 99%
rename from drivers/net/dsa/vitesse-vsc73xx-spi.c
rename to drivers/net/dsa/vitesse/vsc73xx-spi.c
index e73c8fcddc9f..d75fcee0defb 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-spi.c
+++ b/drivers/net/dsa/vitesse/vsc73xx-spi.c
@@ -17,7 +17,7 @@
 #include <linux/of.h>
 #include <linux/spi/spi.h>
 
-#include "vitesse-vsc73xx.h"
+#include "vsc73xx.h"
 
 #define VSC73XX_CMD_SPI_MODE_READ		0
 #define VSC73XX_CMD_SPI_MODE_WRITE		1
diff --git a/drivers/net/dsa/vitesse-vsc73xx.h b/drivers/net/dsa/vitesse/vsc73xx.h
similarity index 100%
rename from drivers/net/dsa/vitesse-vsc73xx.h
rename to drivers/net/dsa/vitesse/vsc73xx.h
-- 
2.17.1

