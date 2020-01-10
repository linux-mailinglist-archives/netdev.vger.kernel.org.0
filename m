Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB111368FB
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 09:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgAJI3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 03:29:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41745 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgAJI3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 03:29:33 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so1219335ljc.8
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 00:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/DyHb62mHtC09zvM8IqL1LuJPDw+xo32O1B4WTTR8E8=;
        b=ABsP9dBuC8l0emcuXqNBCphkSBcoO29DeAW/NeyFfZcnMzOAfsP28VZY77LUQAlbrF
         FX1g58XiyHI2Hf07yk7lGH22HG+tyiKbBF2s7ZWTxgCzbApvaocclZ0cNib6wphs4KQA
         sAybMadldd0Vju6D4ocFiKgAedeqJWuURiB56+w2HBql+deZ1VkPu5lm1kxMw1ANxzvD
         tbtYwdo8MTi+o7CWhbw9dC2savLuZPEoRyCZf1Da+4lkhNq+kpeTDsT93+C1wmOSIT5m
         BQSJsRAxpZ1M+TcufBTbsL3A4xSdewc6L8nnhSJlFShIEpsJ40oO4CUSmY4A+8tqCQ2S
         x5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/DyHb62mHtC09zvM8IqL1LuJPDw+xo32O1B4WTTR8E8=;
        b=Lpi/KdqY8l9ukaZXBbftWq3Rm7wyuVgLfFqWUW+9VU1FksGWxXJW+sj24TQnqptVQo
         7TP1bqnnQnz1xDBaghvN3spbz5axv43g+iGpeo4QMiQX/f17/e30P7/1V7/avh3v2fNp
         6A48i5pN6oWkL0rIf0piFxrJcM2xlMvMPH1xT63fuzQIZBwyyAUA1O6Upmj9DI1K6Ql9
         iuZLnBxyqooVIvso9Qkfz5QtMzDfgcUG0Y1PICjiGeHd5788kkNDyx0L+toRmby0vpQq
         +Y7b0119nEgqy6Q7OWJrDzHu5zlOehOQOjM4ypmhvJUvhsrGb3vlMWQohSoZ4n1aOcmP
         Y7aA==
X-Gm-Message-State: APjAAAVjgB13xrXX/C0Jv9Cf7O5MrlpSx5s7oAnFNrinvpYZPvyslFsk
        EUnSVV4IGhp3f1nXvXju51mP2fe73UzjDA==
X-Google-Smtp-Source: APXvYqxlQer3DnrfN2KWz8ReSjFZDX/dGNQFxW+7CftmPboGwl64Qtv4WDek/1X9jGIBzYsAe7ZkiA==
X-Received: by 2002:a2e:b4cb:: with SMTP id r11mr1772865ljm.68.1578644971633;
        Fri, 10 Jan 2020 00:29:31 -0800 (PST)
Received: from linux.local (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id g24sm606464lfb.85.2020.01.10.00.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 00:29:30 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 3/9 v4] ptp: ixp46x: move adjacent to ethernet driver
Date:   Fri, 10 Jan 2020 09:28:31 +0100
Message-Id: <20200110082837.11473-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200110082837.11473-1-linus.walleij@linaro.org>
References: <20200110082837.11473-1-linus.walleij@linaro.org>
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
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChanegLog v2->v3:
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
 drivers/ptp/Makefile                               |  1 -
 7 files changed, 20 insertions(+), 18 deletions(-)
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
index b45d2b86d8ca..dc3d8ecb4231 100644
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
index 69a06f86a450..74dd39f9d967 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -6,7 +6,6 @@
 ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+= ptp_dte.o
-obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
 obj-$(CONFIG_PTP_1588_CLOCK_PCH)	+= ptp_pch.o
 obj-$(CONFIG_PTP_1588_CLOCK_KVM)	+= ptp_kvm.o
 obj-$(CONFIG_PTP_1588_CLOCK_QORIQ)	+= ptp-qoriq.o
-- 
2.21.0

