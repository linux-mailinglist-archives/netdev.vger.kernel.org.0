Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F73DD05B
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406153AbfJRUhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:37:33 -0400
Received: from mo4-p03-ob.smtp.rzone.de ([81.169.146.172]:8320 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388054AbfJRUhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:37:32 -0400
X-Greylist: delayed 634 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Oct 2019 16:37:31 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571431050;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=r8Vy3GR7D6oFV0HKg54ju3w3VTnD+GTmqAIqPn+j/RM=;
        b=BrSnRY6bbnqjvOGsXNCQoLpKSpCoC7YYNOb3Si4WBD/UAHBFWWYAhvB1XDYvEpYOnE
        mlYogBqtx96C17OfS7VsiopHJonOnmXVh3mRiQd/ILJz/pEIAO3MmFFDe+Hf9xT2iNVu
        PnAp2SGjrqx1XyG9P37e++hYkPdgs9Tk5s438g/AgY55MrsOXaML9SL1fxzkXAIG+7Or
        8fDaR0RstoX3ty3nlp+qWAiAyzZ0ku5D00GYxRAb0ccBPWWmdZWhGink86NCk/LOzb/l
        568bpMcqMhN+4TuV1IYC35zUt6v2O2xoPFaad3QoJFL/v9Qw4HswaX5f/347vJHsp49C
        RTfA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6F3CFF60="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9IKPXDUo
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 18 Oct 2019 22:25:33 +0200 (CEST)
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
Subject: [PATCH 2/9] net: wireless: ti: wl1251 add device tree support
Date:   Fri, 18 Oct 2019 22:25:23 +0200
Message-Id: <13d0a47ea50eacda2a493c8fde5143d6c4f34592.1571430329.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1571430329.git.hns@goldelico.com>
References: <cover.1571430329.git.hns@goldelico.com>
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

