Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33517138620
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 13:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732793AbgALMFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 07:05:05 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33041 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732787AbgALMFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 07:05:04 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so6970229lji.0
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 04:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WUNHrFy2PHEDV96geAtT18iWI41BchnG9pgSmSLWX4o=;
        b=p9Tc+bexlPUBA1ctwIuKXF7eDG2SvJE9u37yMMU50czgBg5DSa+KRAC7GJ/OGqp0yo
         vIc9P8O2onvC17ON+6KsoRDHAouv9rEyUNX7PjqJwA1Dcd2Ysfu21agHcJKFUPFv4FMw
         1ZGsLQnFr6FYxVFXMjZ0qcofOy9NL92WkpxjNxrhznQ4jnjvnO6cbgiRWFNaFjD3jm59
         jqMNUM/hnOP+im21vA9CSTWPJM047Lbkxz58BNOHQWloBNMfsMr3TbfzBVptHnDc3ZDk
         xquzdEOrH2+ZDspRO8BUq/iL83oq3J5cy+LgIA6qOd7BFeGxUOLkwPiTRRA+NYPXS9im
         puqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WUNHrFy2PHEDV96geAtT18iWI41BchnG9pgSmSLWX4o=;
        b=KBe8OPOJcdPaWLqSorknVc7uNRo3uo11MOHfsBgKZ/s29kdWNylFHEe6BMlgAkl5uU
         z+tguwcJ2GEsmpyeRYGr16ViCjDbVd1SIBEHz5YQTmvalGuQowEaL9qCVEys+hYRfjV9
         M7O5w+tYb+IQVI34UqSArrJf1y44fJLwV344mvq2MPy6e201kJ3en7NgJs5xQrg41l3D
         cSQAfr4Bh+EGKjuJnrDSXCIG4k6PqyGmWUC+K09VhX7lI4nYObSv6YtYyYKrHwSAA5Ey
         PGDx93poqlj+cXMYadzUeEcaBiY5Jab4Wdsxn6lK/Ac8aXQIMQ4eBTYtxAfv4P4Gl0xW
         EMuA==
X-Gm-Message-State: APjAAAWv3tSIhTjVUc6rOQtxPwKOiEIJ+oqjH4vhNoWzXJvNymlJNFtM
        4XTgrATPb7C+WRbpk50WQuZc2jIk7nSybA==
X-Google-Smtp-Source: APXvYqwV2wN1yx133TNtGgPq4A1CQWSTCwKORpLj368zpLxvKRv8CIn7NPOkAYmZvb3sNIuVxbz/Eg==
X-Received: by 2002:a05:651c:1068:: with SMTP id y8mr7721654ljm.71.1578830702283;
        Sun, 12 Jan 2020 04:05:02 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id z7sm4660347lfa.81.2020.01.12.04.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 04:05:01 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 3/9 v5] ptp: ixp46x: move adjacent to ethernet driver
Date:   Sun, 12 Jan 2020 13:04:44 +0100
Message-Id: <20200112120450.11874-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200112120450.11874-1-linus.walleij@linaro.org>
References: <20200112120450.11874-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ixp46x ptp driver has a somewhat unusual setup, where the ptp
driver and the ethernet driver are in different directories but
access the same registers that are defined a platform specific
header file.

Moving everything into drivers/net/ makes it look more like most
other ptp drivers and allows compile-testing this driver on
other targets.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- Renase onto the net-next tree
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChangeLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Rename patch as "move ADJACENT" which makes more sense
---
 drivers/net/ethernet/xscale/Kconfig                | 14 ++++++++++++++
 drivers/net/ethernet/xscale/Makefile               |  3 ++-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |  3 ++-
 drivers/{ptp => net/ethernet/xscale}/ptp_ixp46x.c  |  3 ++-
 .../net/ethernet/xscale/ptp_ixp46x.h               |  0
 drivers/ptp/Kconfig                                | 14 --------------
 drivers/ptp/Makefile                               |  3 +--
 7 files changed, 21 insertions(+), 19 deletions(-)
 rename drivers/{ptp => net/ethernet/xscale}/ptp_ixp46x.c (99%)
 rename arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h => drivers/net/ethernet/xscale/ptp_ixp46x.h (100%)

diff --git a/drivers/net/ethernet/xscale/Kconfig b/drivers/net/ethernet/xscale/Kconfig
index cd0a8f46e7c6..98aa7b8ddb06 100644
--- a/drivers/net/ethernet/xscale/Kconfig
+++ b/drivers/net/ethernet/xscale/Kconfig
@@ -27,4 +27,18 @@ config IXP4XX_ETH
 	  Say Y here if you want to use built-in Ethernet ports
 	  on IXP4xx processor.
 
+config PTP_1588_CLOCK_IXP46X
+	tristate "Intel IXP46x as PTP clock"
+	depends on IXP4XX_ETH
+	depends on PTP_1588_CLOCK
+	default y
+	help
+	  This driver adds support for using the IXP46X as a PTP
+	  clock. This clock is only useful if your PTP programs are
+	  getting hardware time stamps on the PTP Ethernet packets
+	  using the SO_TIMESTAMPING API.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ptp_ixp46x.
+
 endif # NET_VENDOR_XSCALE
diff --git a/drivers/net/ethernet/xscale/Makefile b/drivers/net/ethernet/xscale/Makefile
index 794a519d07b3..607f91b1e878 100644
--- a/drivers/net/ethernet/xscale/Makefile
+++ b/drivers/net/ethernet/xscale/Makefile
@@ -3,4 +3,5 @@
 # Makefile for the Intel XScale IXP device drivers.
 #
 
-obj-$(CONFIG_IXP4XX_ETH) += ixp4xx_eth.o
+obj-$(CONFIG_IXP4XX_ETH)		+= ixp4xx_eth.o
+obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 6fc04ffb22c2..0075ecdb21f4 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -33,10 +33,11 @@
 #include <linux/ptp_classify.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <mach/ixp46x_ts.h>
 #include <linux/soc/ixp4xx/npe.h>
 #include <linux/soc/ixp4xx/qmgr.h>
 
+#include "ixp46x_ts.h"
+
 #define DEBUG_DESC		0
 #define DEBUG_RX		0
 #define DEBUG_TX		0
diff --git a/drivers/ptp/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
similarity index 99%
rename from drivers/ptp/ptp_ixp46x.c
rename to drivers/net/ethernet/xscale/ptp_ixp46x.c
index 67028484e9a0..9ecc395239e9 100644
--- a/drivers/ptp/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -15,7 +15,8 @@
 #include <linux/module.h>
 
 #include <linux/ptp_clock_kernel.h>
-#include <mach/ixp46x_ts.h>
+
+#include "ixp46x_ts.h"
 
 #define DRIVER		"ptp_ixp46x"
 #define N_EXT_TS	2
diff --git a/arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h b/drivers/net/ethernet/xscale/ptp_ixp46x.h
similarity index 100%
rename from arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h
rename to drivers/net/ethernet/xscale/ptp_ixp46x.h
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index c382158f587d..475c60dccaa4 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -56,20 +56,6 @@ config PTP_1588_CLOCK_QORIQ
 	  To compile this driver as a module, choose M here: the module
 	  will be called ptp-qoriq.
 
-config PTP_1588_CLOCK_IXP46X
-	tristate "Intel IXP46x as PTP clock"
-	depends on IXP4XX_ETH
-	depends on PTP_1588_CLOCK
-	default y
-	help
-	  This driver adds support for using the IXP46X as a PTP
-	  clock. This clock is only useful if your PTP programs are
-	  getting hardware time stamps on the PTP Ethernet packets
-	  using the SO_TIMESTAMPING API.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called ptp_ixp46x.
-
 comment "Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks."
 	depends on PHYLIB=n || NETWORK_PHY_TIMESTAMPING=n
 
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 3fb91bebbaf7..8c830336f178 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -7,10 +7,9 @@ ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
 obj-$(CONFIG_PTP_1588_CLOCK_INES)	+= ptp_ines.o
-obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
 obj-$(CONFIG_PTP_1588_CLOCK_PCH)	+= ptp_pch.o
 obj-$(CONFIG_PTP_1588_CLOCK_KVM)	+= ptp_kvm.o
 obj-$(CONFIG_PTP_1588_CLOCK_QORIQ)	+= ptp-qoriq.o
 ptp-qoriq-y				+= ptp_qoriq.o
 ptp-qoriq-$(CONFIG_DEBUG_FS)		+= ptp_qoriq_debugfs.o
-obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_clockmatrix.o
\ No newline at end of file
+obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_clockmatrix.o
-- 
2.21.0

