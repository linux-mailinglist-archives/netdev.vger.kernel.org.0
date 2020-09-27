Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B85127A396
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgI0UA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:00:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42202 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgI0T5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:57:38 -0400
Message-Id: <20200927194922.245750969@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=Fz/Y8tdPmcPxNZ39xs6OXP7t7GmeJEA09IH+iG5eqPY=;
        b=tqeU52EO2XBZK/ddxUU5a112arkeHUUJxxE9PSVyDXEDKqBLkWy/SqNPHHwWYyb3sGz1JZ
        lGkGMNhtwBDXIrEFaClRwhU7/O0vbRat1U/HPln4Q+oDTdQQBOI3q84qp9pf16Ab5g85pJ
        QlJCaUVOiCLDkYSh2yx2xZN5Noqozpd/Li1JhhqRUGYrArnUjtd0jKAyZYEFp/ajaRPpJD
        eyOmp0cGo2JKISaMxw/wevnANPyTs9dg/RX9PVhj7eacVPKFmZJwmM2GFlq7wE8TYP6JWV
        eiML7z2T/jG7bgMjXY9Xv+i/fNSvkYhHG+xKystktSgzm9NEOxUntE/v+kEGnQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=Fz/Y8tdPmcPxNZ39xs6OXP7t7GmeJEA09IH+iG5eqPY=;
        b=wKmY7sgdpiakGLwk3efR391mD4s4Ls4MU5X6793GEBWur5GfvH8AeOH68vsN1rg1N5GERz
        9mCHkioqeemMDuAw==
Date:   Sun, 27 Sep 2020 21:49:10 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
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
        Ulrich Kunitz <kune@deine-taler.de>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: [patch 24/35] net: brcmfmac: Replace in_interrupt()
References: <20200927194846.045411263@linutronix.de>
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
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
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

