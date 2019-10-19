Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A89DDA2F
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 20:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfJSSmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 14:42:00 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:19862 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbfJSSl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 14:41:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571510511;
        s=strato-dkim-0002; d=goldelico.com;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=l0qWMjci4TxLI+eOGNNufcvgLLDB/JaT6TCyJXXhCcU=;
        b=UjQnHb+AQOaMSFBBI3VrgZgtWeLGA/znD4j9UHbEfOKWtuG+Ir0kG7/M48dVz7ifyP
        tQDdWO0VYp5GgydokGuAoXTfMyrPxOxh44VkuwO6GXrMq5kBUGN3iPlv2eUMW84THkGp
        hBZ2Os8m0SUzRO9MDw8hGnEeZc2OpLlPwAQmSM3SYVXjCXaBXXhB1AFiMrtsctoZhcUb
        xgkwr0xZncMleSPV9z8Q6lqs/l1Fwm0/XTfpVbJyV7BM8qgxLhyYoL6beQ0jbnzXjIOy
        LzGgblDvJrYDgd3N7815drXPtIudHqF+7oI2vdhrb/pGqkb7hZ5CT+psh7uqgEVkC6b6
        qcRA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o12DNOsPj0pAyXkHTz8="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9JIfRFML
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 19 Oct 2019 20:41:27 +0200 (CEST)
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
Subject: [PATCH v2 00/11] OpenPandora: make wl1251 connected to mmc3 sdio port of OpenPandora work again
Date:   Sat, 19 Oct 2019 20:41:15 +0200
Message-Id: <cover.1571510481.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
DT:     Pandora: fixes and extensions
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


* added acked-by for wl1251 patches - Kalle Valo <kvalo@codeaurora.org>
* really removed old pdata-quirks code (not through #if 0)
* splited out a partial revert of
	efdfeb079cc3b ("regulator: fixed: Convert to use GPIO descriptor only")
  because that was introduced after v4.19 and stops the removal of
  the pdata-quirks patch from cleanly applying to v4.9, v4.14, v4.19
  - reported by Sasha Levin <sashal@kernel.org>
* added a new patch to remove old omap hsmmc since pdata quirks
  were last user - suggested by Tony Lindgren <tony@atomide.com>

PATCH V1 2019-10-18 22:25:39:

Here we have a set of scattered patches to make the OpenPandora WiFi work again.

v4.7 did break the pdata-quirks which made the mmc3 interface
fail completely, because some code now assumes device tree
based instantiation.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

v4.11 did break the sdio qirks for wl1251 which made the driver no longer
load, although the device was found as an sdio client.

Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")

To solve these issues:
* we convert mmc3 and wl1251 initialization from pdata-quirks
  to device tree
* we make the wl1251 driver read properties from device tree
* we fix the mmc core vendor ids and quirks
* we fix the wl1251 (and wl1271) driver to use only vendor ids
  from header file instead of (potentially conflicting) local
  definitions


H. Nikolaus Schaller (11):
  Documentation: dt: wireless: update wl1251 for sdio
  net: wireless: ti: wl1251 add device tree support
  DTS: ARM: pandora-common: define wl1251 as child node of mmc3
  mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid
    of pandora_wl1251_init_card
  omap: pdata-quirks: revert pandora specific gpiod additions
  omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
  omap: remove old hsmmc.[ch] and in Makefile
  mmc: sdio: fix wl1251 vendor id
  mmc: core: fix wl1251 sdio quirks
  net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251 definition
  net: wireless: ti: remove local VENDOR_ID and DEVICE_ID definitions

 .../bindings/net/wireless/ti,wl1251.txt       |  26 +++
 arch/arm/boot/dts/omap3-pandora-common.dtsi   |  37 +++-
 arch/arm/mach-omap2/Makefile                  |   1 -
 arch/arm/mach-omap2/hsmmc.c                   | 171 ------------------
 arch/arm/mach-omap2/hsmmc.h                   |  32 ----
 arch/arm/mach-omap2/pdata-quirks.c            | 105 -----------
 drivers/mmc/core/quirks.h                     |   7 +
 drivers/mmc/host/omap_hsmmc.c                 |  21 +++
 drivers/net/wireless/ti/wl1251/sdio.c         |  23 ++-
 drivers/net/wireless/ti/wlcore/sdio.c         |   8 -
 include/linux/mmc/sdio_ids.h                  |   2 +
 11 files changed, 105 insertions(+), 328 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/hsmmc.c
 delete mode 100644 arch/arm/mach-omap2/hsmmc.h

-- 
2.19.1

