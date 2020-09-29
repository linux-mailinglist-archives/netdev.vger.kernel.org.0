Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE30F27D8B4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgI2UiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:38:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50578 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbgI2UgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:20 -0400
Message-Id: <20200929203502.481146256@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=60HDT5DhE8SC2OZ0F8d0KZw6s4EX8xVrL/PVP+OTIeg=;
        b=RMOQhTVgBWYvgJW6v9UhblZTsppMMIcgZV++8+B2pRW64Kd1HeJ9PGycKLfMxYzhaQdOhc
        WHLhtFz46AWXPNLluC9Y0nQ9u8U5hhMtcxX7Hvjk9xdWVFUg9cCf7LjpmMqKDXr/0HhjLI
        hgZi0BPlJ/CSRqqbJ4SNeLzRiJquqT1+jwX6bH8X89mrtJLvd/UaAf1nod/Fwn6FUWA+eG
        tn7Iz1SxlLG27Q6yjKfPpSkgd9N58IoeBCr+360rmp7lUYqDoIn4n45BLMSaGBMAyLnAuq
        JHTYp4N3cTYmfh8eT3e1TE+6lTTklQjyAYAtfmeHQ+9BTSkxtFjLKOR3XcUN3A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=60HDT5DhE8SC2OZ0F8d0KZw6s4EX8xVrL/PVP+OTIeg=;
        b=uynYowaB8wyvJDh/sGgqeLLNpQ/TnV1z/qETkqkeENX7iVEBdUK0/Bt8J701JfWo79N5al
        bmpUyhRknzvZKHCg==
Date:   Tue, 29 Sep 2020 22:25:39 +0200
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
Subject: [patch V2 30/36] net: hostap: Remove in_interrupt() usage
References: <20200929202509.673358734@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

in_interrupt() is ill defined and does not provide what the name
suggests. The usage especially in driver code is deprecated and a tree wide
effort to clean up and consolidate the (ab)usage of in_interrupt() and
related checks is happening.

hfa384x_cmd() and prism2_hw_reset() check in_interrupt() at function entry
and if true emit a printk at debug loglevel and return. This is clearly debug
code.

Both functions invoke functions which can sleep. These functions already
have appropriate debug checks which cover all invalid contexts, while
in_interrupt() fails to detect context which just has preemption or
interrupts disabled.

Remove both checks as they are incomplete, debug only and already covered
by the subsequently invoked functions properly. If called from invalid
context the resulting back trace is definitely more helpful to analyze the
problem than a printk at debug loglevel.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Kalle Valo <kvalo@codeaurora.org>

---
 drivers/net/wireless/intersil/hostap/hostap_hw.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -320,12 +320,6 @@ static int hfa384x_cmd(struct net_device
 	iface = netdev_priv(dev);
 	local = iface->local;
 
-	if (in_interrupt()) {
-		printk(KERN_DEBUG "%s: hfa384x_cmd called from interrupt "
-		       "context\n", dev->name);
-		return -1;
-	}
-
 	if (local->cmd_queue_len >= HOSTAP_CMD_QUEUE_MAX_LEN) {
 		printk(KERN_DEBUG "%s: hfa384x_cmd: cmd_queue full\n",
 		       dev->name);
@@ -1560,12 +1554,6 @@ static void prism2_hw_reset(struct net_d
 	iface = netdev_priv(dev);
 	local = iface->local;
 
-	if (in_interrupt()) {
-		printk(KERN_DEBUG "%s: driver bug - prism2_hw_reset() called "
-		       "in interrupt context\n", dev->name);
-		return;
-	}
-
 	if (local->hw_downloading)
 		return;
 


