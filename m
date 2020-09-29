Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E1C27D86B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgI2Ug0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729568AbgI2UgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:23 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD62C0613D7;
        Tue, 29 Sep 2020 13:36:11 -0700 (PDT)
Message-Id: <20200929203501.990651184@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=nmdfvbBdxc+F4LPbcHtWk8LDo4taGeEsCCFXJ53hMe0=;
        b=1bYv3DnXkNw/hSM4Nbg1Y9iOR3XrEgyVJxt5WvlsV7LV+bDZR9sXtsXiFtxi/GUL8So33c
        6JT9kP+vg/vwkU83hFjotL3A5wnGg0MQ67NpMu3g/YNVFzVs9Ju1urHXtldZClm2+PqHDG
        W3QkFf1mGMK9WtJSTJp3gDruTAqAqjslZMT/CkbQfhFFnjks2VuytpmLaV6f1sbEMKenwA
        FeKBWF0bZnBtmunfN9FNarsHezWSQcxcDgZRudB8/atxwuIBD1AR8BC/eJDs4u+q3DIY0+
        37CeMKqTBZchMZKeyT1yQK9yogh4KjCXVo8hnD+tZArWPx281ma3F+P0eZ+W2Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=nmdfvbBdxc+F4LPbcHtWk8LDo4taGeEsCCFXJ53hMe0=;
        b=NTn83D4YH6ysj5p9NgvKY4vhETcAWKaws1Uy8zXoCrhCdKnDt7aF8bdJR3JQ4nIH6kIL2k
        mn+yFYZvhlq5M+AQ==
Date:   Tue, 29 Sep 2020 22:25:34 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [patch V2 25/36] net: brcmfmac: Replace in_interrupt()
References: <20200929202509.673358734@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

brcmf_sdio_isr() is using in_interrupt() to distinguish if it is called
from a interrupt service routine or from a worker thread.

Passing such information from the calling context is preferred and
requested by Linus, so add an argument `in_isr' to brcmf_sdio_isr() and let
the callers pass the information about the calling context.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |    4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   |    4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -73,7 +73,7 @@ static irqreturn_t brcmf_sdiod_oob_irqha
 		sdiodev->irq_en = false;
 	}
 
-	brcmf_sdio_isr(sdiodev->bus);
+	brcmf_sdio_isr(sdiodev->bus, true);
 
 	return IRQ_HANDLED;
 }
@@ -85,7 +85,7 @@ static void brcmf_sdiod_ib_irqhandler(st
 
 	brcmf_dbg(INTR, "IB intr triggered\n");
 
-	brcmf_sdio_isr(sdiodev->bus);
+	brcmf_sdio_isr(sdiodev->bus, false);
 }
 
 /* dummy handler for SDIO function 2 interrupt */
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3625,7 +3625,7 @@ void brcmf_sdio_trigger_dpc(struct brcmf
 	}
 }
 
-void brcmf_sdio_isr(struct brcmf_sdio *bus)
+void brcmf_sdio_isr(struct brcmf_sdio *bus, bool in_isr)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3636,7 +3636,7 @@ void brcmf_sdio_isr(struct brcmf_sdio *b
 
 	/* Count the interrupt call */
 	bus->sdcnt.intrcount++;
-	if (in_interrupt())
+	if (in_isr)
 		atomic_set(&bus->ipend, 1);
 	else
 		if (brcmf_sdio_intr_rstatus(bus)) {
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -372,7 +372,7 @@ int brcmf_sdiod_remove(struct brcmf_sdio
 
 struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdio_remove(struct brcmf_sdio *bus);
-void brcmf_sdio_isr(struct brcmf_sdio *bus);
+void brcmf_sdio_isr(struct brcmf_sdio *bus, bool in_isr);
 
 void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, bool active);
 void brcmf_sdio_wowl_config(struct device *dev, bool enabled);


