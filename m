Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F42DDA46
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 20:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfJSSm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 14:42:29 -0400
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.104]:22572 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfJSSlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 14:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571510510;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=8/ITeyMIKJXiU8PIrPxcxydlS2MxJhnwQVJo5WpZiiw=;
        b=dztIfHmVPGCxOsQFGGi5frWN/VFGM8SQK9Cbau1kCzX9/Xbzmg8d3dreGQCLuJoRWL
        nOfhW6ydjUj52dUE7y7e0HZqGUSBnROUt8qWuV+/I23jcWCh3PBso5SpnCWaT7CYcRJx
        spjB0mR1540Ydp05RuS+/xb/Byn5kE8PE/3cnzWTyQi9gKa1iOrvFwwsp9zfCPV1Ef4Z
        yUUbxncQ1THLqQVZgY5u6q7L9DsjICjzituEDwj8Wx8R59jmTzqz9GYlEOczJ6NPD9Qx
        65k5pfBJt352KodIVY31W7VqayF8cdY8Ok/rkIdj5GEjlRBT9GkAAnT2phJTCFiXf+h7
        mGYA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o12DNOsPj0pAyXkHTz8="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9JIfUFMN
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 19 Oct 2019 20:41:30 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Subject: [PATCH v2 02/11] net: wireless: ti: wl1251 add device tree support
Date:   Sat, 19 Oct 2019 20:41:17 +0200
Message-Id: <062703f6033df5919d814c7312f577e8b2a96838.1571510481.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1571510481.git.hns@goldelico.com>
References: <cover.1571510481.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will have the wl1251 defined as a child node of the mmc interface
and can read setup for gpios, interrupts and the ti,use-eeprom
property from there instead of pdata to be provided by pdata-quirks.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ti/wl1251/sdio.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ti/wl1251/sdio.c b/drivers/net/wireless/ti/wl1251/sdio.c
index 677f1146ccf0..c54a273713ed 100644
--- a/drivers/net/wireless/ti/wl1251/sdio.c
+++ b/drivers/net/wireless/ti/wl1251/sdio.c
@@ -16,6 +16,9 @@
 #include <linux/irq.h>
 #include <linux/pm_runtime.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/of_irq.h>
 
 #include "wl1251.h"
 
@@ -217,6 +220,7 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	struct ieee80211_hw *hw;
 	struct wl1251_sdio *wl_sdio;
 	const struct wl1251_platform_data *wl1251_board_data;
+	struct device_node *np = func->dev.of_node;
 
 	hw = wl1251_alloc_hw();
 	if (IS_ERR(hw))
@@ -248,6 +252,15 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 		wl->power_gpio = wl1251_board_data->power_gpio;
 		wl->irq = wl1251_board_data->irq;
 		wl->use_eeprom = wl1251_board_data->use_eeprom;
+	} else if (np) {
+		wl->use_eeprom =of_property_read_bool(np, "ti,wl1251-has-eeprom");
+		wl->power_gpio = of_get_named_gpio(np, "ti,power-gpio", 0);
+		wl->irq = of_irq_get(np, 0);
+
+		if (wl->power_gpio == -EPROBE_DEFER || wl->irq == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto disable;
+		}
 	}
 
 	if (gpio_is_valid(wl->power_gpio)) {
-- 
2.19.1

