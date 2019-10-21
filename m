Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9AE7DE161
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfJUAKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:10:10 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35941 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:10:10 -0400
Received: by mail-lj1-f193.google.com with SMTP id v24so11363583ljj.3
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9/FLpztDlNWbBg/JuYp1tFoVp95L3E5/Cpe4B2PPpq8=;
        b=ceSY77Z2ACB2CbaTnA8NInoDHEl53XTFKp3dOKq7jxdtrLK/BrwPJPMqwFdL9Xff+H
         uQIkavYNUrgvdxKrIaeZa0YRjqmlWX8M4CGIE7t8R1TUWjOzUXjnBYTWh0a2uiMQQOuN
         df80IsAkfnE6AylzUx/u+qPnA4iPQ25M4B0LU2qQXCtT5c3I8SfmyE1WaWbc0EtCRCiW
         7hsLrGMag1qn7CVktlh9Z3nuY1bIprl4zGlnk/ZmZRC9cy811WWkMPSN3BAxscdQnAqO
         VVl0uvUrAvEHwlEoHoK5hkfOlxA0sQD3lCONhd1vgHNRi5mk/B5mkN13C2UuuVmkCILL
         e/IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/FLpztDlNWbBg/JuYp1tFoVp95L3E5/Cpe4B2PPpq8=;
        b=GB8zoW6JRdG+L5W4yA8kmfTNnd2354EgBGNU+pMFmvpfVFBqsfgnB+4A2tFVSDEL71
         nh57d5XaMJbsSwyb+8TIe3ltGw4rdNbthaDdW9eU9TyOOokPpn4rrZc6rl+NGFQi9vr6
         uLA+4Fit4WXC3k3DJXaFGuSHYD78w0ofvRMPZ3YZ64b740ZRp2bLNMSn7pawbjyCcMe0
         u4dOzmhs/rb3NYqsPcKYyOAjGYTRyYLm/6gmKNoDtDAG/2KSHauljOqyc+mUwbNaQGeZ
         74wDE9ntQ3CJTtI0J6qjU3lO7gHmCMmhMYhlrFGeYMBZW9QqHluisZxLMhUjlJ1g6xqk
         MNeA==
X-Gm-Message-State: APjAAAW+xNeCQxSzOxzHr/QC6GGz9cxkI6ZVgs+4u+Pt4qWoIaJJDYvu
        nWpd1CIHQsFSbunob6a58nQ0zPpUKGI=
X-Google-Smtp-Source: APXvYqxkNMnxCcngJBmYiFKK+kSNdTDxhhVvaorDNjqW6yb5TjzLPtUUYGFrpkTlEcnw6oUpFAN6UA==
X-Received: by 2002:a2e:a415:: with SMTP id p21mr12601906ljn.59.1571616606515;
        Sun, 20 Oct 2019 17:10:06 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:10:01 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 02/10] wan: ixp4xx_hss: enable compile testing
Date:   Mon, 21 Oct 2019 02:08:16 +0200
Message-Id: <20191021000824.531-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ixp4xx_hss driver needs the platform data definition and the
system clock rate to be compiled. Move both into a new platform_data
header file and enable compile testing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ixp4xx/goramo_mlr.c            |  4 +++
 arch/arm/mach-ixp4xx/include/mach/platform.h |  9 -----
 drivers/net/wan/Kconfig                      |  3 +-
 drivers/net/wan/ixp4xx_hss.c                 | 35 +++++++++++---------
 include/linux/platform_data/wan_ixp4xx_hss.h | 17 ++++++++++
 5 files changed, 43 insertions(+), 25 deletions(-)
 create mode 100644 include/linux/platform_data/wan_ixp4xx_hss.h

diff --git a/arch/arm/mach-ixp4xx/goramo_mlr.c b/arch/arm/mach-ixp4xx/goramo_mlr.c
index a0e0b6b7dc5c..93b7afeee142 100644
--- a/arch/arm/mach-ixp4xx/goramo_mlr.c
+++ b/arch/arm/mach-ixp4xx/goramo_mlr.c
@@ -11,6 +11,7 @@
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/platform_data/wan_ixp4xx_hss.h>
 #include <linux/serial_8250.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -405,6 +406,9 @@ static void __init gmlr_init(void)
 	if (hw_bits & CFG_HW_HAS_HSS1)
 		device_tab[devices++] = &device_hss_tab[1]; /* max index 5 */
 
+	hss_plat[0].timer_freq = ixp4xx_timer_freq;
+	hss_plat[1].timer_freq = ixp4xx_timer_freq;
+
 	gpio_request(GPIO_SCL, "SCL/clock");
 	gpio_request(GPIO_SDA, "SDA/data");
 	gpio_request(GPIO_STR, "strobe");
diff --git a/arch/arm/mach-ixp4xx/include/mach/platform.h b/arch/arm/mach-ixp4xx/include/mach/platform.h
index 342acbe20f7c..04ef8025accc 100644
--- a/arch/arm/mach-ixp4xx/include/mach/platform.h
+++ b/arch/arm/mach-ixp4xx/include/mach/platform.h
@@ -104,15 +104,6 @@ struct eth_plat_info {
 	u8 hwaddr[6];
 };
 
-/* Information about built-in HSS (synchronous serial) interfaces */
-struct hss_plat_info {
-	int (*set_clock)(int port, unsigned int clock_type);
-	int (*open)(int port, void *pdev,
-		    void (*set_carrier_cb)(void *pdev, int carrier));
-	void (*close)(int port, void *pdev);
-	u8 txreadyq;
-};
-
 /*
  * Frequency of clock used for primary clocksource
  */
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index dd1a147f2971..bf2fe1d602ea 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -315,7 +315,8 @@ config DSCC4_PCI_RST
 
 config IXP4XX_HSS
 	tristate "Intel IXP4xx HSS (synchronous serial port) support"
-	depends on HDLC && ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR
+	depends on HDLC && IXP4XX_NPE && IXP4XX_QMGR
+	depends on ARCH_IXP4XX || COMPILE_TEST
 	help
 	  Say Y here if you want to use built-in HSS ports
 	  on IXP4xx processor.
diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index e7619cec978a..7c5cf77e9ef1 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/wan_ixp4xx_hss.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/soc/ixp4xx/npe.h>
@@ -1182,14 +1183,14 @@ static int hss_hdlc_attach(struct net_device *dev, unsigned short encoding,
 	}
 }
 
-static u32 check_clock(u32 rate, u32 a, u32 b, u32 c,
+static u32 check_clock(u32 timer_freq, u32 rate, u32 a, u32 b, u32 c,
 		       u32 *best, u32 *best_diff, u32 *reg)
 {
 	/* a is 10-bit, b is 10-bit, c is 12-bit */
 	u64 new_rate;
 	u32 new_diff;
 
-	new_rate = ixp4xx_timer_freq * (u64)(c + 1);
+	new_rate = timer_freq * (u64)(c + 1);
 	do_div(new_rate, a * (c + 1) + b + 1);
 	new_diff = abs((u32)new_rate - rate);
 
@@ -1201,40 +1202,43 @@ static u32 check_clock(u32 rate, u32 a, u32 b, u32 c,
 	return new_diff;
 }
 
-static void find_best_clock(u32 rate, u32 *best, u32 *reg)
+static void find_best_clock(u32 timer_freq, u32 rate, u32 *best, u32 *reg)
 {
 	u32 a, b, diff = 0xFFFFFFFF;
 
-	a = ixp4xx_timer_freq / rate;
+	a = timer_freq / rate;
 
 	if (a > 0x3FF) { /* 10-bit value - we can go as slow as ca. 65 kb/s */
-		check_clock(rate, 0x3FF, 1, 1, best, &diff, reg);
+		check_clock(timer_freq, rate, 0x3FF, 1, 1, best, &diff, reg);
 		return;
 	}
 	if (a == 0) { /* > 66.666 MHz */
 		a = 1; /* minimum divider is 1 (a = 0, b = 1, c = 1) */
-		rate = ixp4xx_timer_freq;
+		rate = timer_freq;
 	}
 
-	if (rate * a == ixp4xx_timer_freq) { /* don't divide by 0 later */
-		check_clock(rate, a - 1, 1, 1, best, &diff, reg);
+	if (rate * a == timer_freq) { /* don't divide by 0 later */
+		check_clock(timer_freq, rate, a - 1, 1, 1, best, &diff, reg);
 		return;
 	}
 
 	for (b = 0; b < 0x400; b++) {
 		u64 c = (b + 1) * (u64)rate;
-		do_div(c, ixp4xx_timer_freq - rate * a);
+		do_div(c, timer_freq - rate * a);
 		c--;
 		if (c >= 0xFFF) { /* 12-bit - no need to check more 'b's */
 			if (b == 0 && /* also try a bit higher rate */
-			    !check_clock(rate, a - 1, 1, 1, best, &diff, reg))
+			    !check_clock(timer_freq, rate, a - 1, 1, 1, best,
+					 &diff, reg))
 				return;
-			check_clock(rate, a, b, 0xFFF, best, &diff, reg);
+			check_clock(timer_freq, rate, a, b, 0xFFF, best,
+				    &diff, reg);
 			return;
 		}
-		if (!check_clock(rate, a, b, c, best, &diff, reg))
+		if (!check_clock(timer_freq, rate, a, b, c, best, &diff, reg))
 			return;
-		if (!check_clock(rate, a, b, c + 1, best, &diff, reg))
+		if (!check_clock(timer_freq, rate, a, b, c + 1, best, &diff,
+				 reg))
 			return;
 	}
 }
@@ -1285,8 +1289,9 @@ static int hss_hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 		port->clock_type = clk; /* Update settings */
 		if (clk == CLOCK_INT)
-			find_best_clock(new_line.clock_rate, &port->clock_rate,
-					&port->clock_reg);
+			find_best_clock(port->plat->timer_freq,
+					new_line.clock_rate,
+					&port->clock_rate, &port->clock_reg);
 		else {
 			port->clock_rate = 0;
 			port->clock_reg = CLK42X_SPEED_2048KHZ;
diff --git a/include/linux/platform_data/wan_ixp4xx_hss.h b/include/linux/platform_data/wan_ixp4xx_hss.h
new file mode 100644
index 000000000000..d525a0feb9e1
--- /dev/null
+++ b/include/linux/platform_data/wan_ixp4xx_hss.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __PLATFORM_DATA_WAN_IXP4XX_HSS_H
+#define __PLATFORM_DATA_WAN_IXP4XX_HSS_H
+
+#include <linux/types.h>
+
+/* Information about built-in HSS (synchronous serial) interfaces */
+struct hss_plat_info {
+	int (*set_clock)(int port, unsigned int clock_type);
+	int (*open)(int port, void *pdev,
+		    void (*set_carrier_cb)(void *pdev, int carrier));
+	void (*close)(int port, void *pdev);
+	u8 txreadyq;
+	u32 timer_freq;
+};
+
+#endif
-- 
2.21.0

