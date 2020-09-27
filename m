Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDCB27A384
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgI0T7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:59:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41642 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgI0T6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:58:03 -0400
Message-Id: <20200927194922.722439719@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=WvKjADYjqlirQWpKFkh9jiGNfOCHnSN3m3D0jVUtW0s=;
        b=XwDPR8KfhhwdgM2h3NXTwz7S032tPQFhsINIdBsrnxyP9xEIwf9JmvxDxIDGkwJhi4fwsG
        4jvQ/uRtX1vttmdiFbJHm4ezHJNt3bCShDxDaUvSfhBTOm/RkxdeJVnW88dvf9PLLy3OGo
        vHOr6TBL43ji8aWZNzBoqQJ7OgeTmJ6wp0xFDunenDs+jppIUe4HkFoOgH18K249SYQ6Q3
        IWsmuizwOoi5ttWgeDOX5I8Zx/OXCLtPXYxotFDSoT8DgXcpWS3+FaUaj2sj338D7H8uqH
        sT5fHF8WghHkzuK7LQdE7N0LB1JjJR2LsCP5jhxjNwP7oDBbC6vFq6II02AmnA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=WvKjADYjqlirQWpKFkh9jiGNfOCHnSN3m3D0jVUtW0s=;
        b=5eiMnruQvx3MYP7nVlqCqSPo+NiHBVbHE0sWnKSIYRXN5H1WKNKQKtiPGb9iUFiHaZTWcN
        op8hWZ7x4vBnp6Dg==
Date:   Sun, 27 Sep 2020 21:49:15 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
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
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [patch 29/35] net: hostap: Remove in_interrupt() usage
References: <20200927194846.045411263@linutronix.de>
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
Cc: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org

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
 

