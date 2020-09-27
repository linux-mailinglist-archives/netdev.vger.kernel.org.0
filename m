Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808C327A3B6
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgI0T5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:57:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40678 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgI0T5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:57:13 -0400
Message-Id: <20200927194920.214592677@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=9orafjgYKDlDKEG62n274dWmcmLVLFnX3OlrGfMTV/Q=;
        b=vuP6S8UXSfNxWHGc7Yb2QTKmLAxUiHJyEitt9UbeznGeTfFpoA4hIKR0wXAjx9ERlKFh9W
        B3bju1K9kWHZBkDD4J7eFPdctXUZRyh96hhl3Tx1GvWD8Y/XyJWWryMdeorFYWMQDKrTL5
        kqEzzHZXGSW+yc33fKh0Hu2PgYS+NeHki6h+C1HvVyfClaaDmUPPyP0mJ9LvLSPNglIAuo
        ijVHzC9fe4+qCIeoRmB8/Z/YabntsJvY9IgF8P8zl9mXgHpPjJZSKLDCF9g88NWv4FcmbF
        /sN3MaPfnUFBZt+Ua6vxU4jIFoZjJgzrGe8Wmt35MCdWxPI91VOXLcu/jEI4vQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=9orafjgYKDlDKEG62n274dWmcmLVLFnX3OlrGfMTV/Q=;
        b=LxBnZ/3kK2Kn1E01Ma+vj2UE6c25FltAkOE1MjniUMmLf0trqgyT+SHySRxbhxfte+GZQe
        x6hYcFF/6UZwDWAA==
Date:   Sun, 27 Sep 2020 21:48:50 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        netdev@vger.kernel.org, Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org, Jay Cliburn <jcliburn@gmail.com>,
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
Subject: [patch 04/35] net: caif: Use netif_rx_any_context()
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The usage of in_interrupt() in non-core code is phased out. Ideally the
information of the calling context should be passed by the callers or the
functions be split as appropriate.

cfhsi_rx_desc() and cfhsi_rx_pld() use in_interrupt() to distinguish if
they should use netif_rx() or netif_rx_ni() for receiving packets.

The attempt to consolidate the code by passing an arguemnt or by
distangling it failed due lack of knowledge about this driver and because
the call chains are hard to follow.

As a stop gap use netif_rx_any_context() which invokes the correct code path
depending on context and confines the in_interrupt() usage to core code.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/caif/caif_hsi.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/drivers/net/caif/caif_hsi.c
+++ b/drivers/net/caif/caif_hsi.c
@@ -458,15 +458,7 @@ static int cfhsi_rx_desc(struct cfhsi_de
 		skb_reset_mac_header(skb);
 		skb->dev = cfhsi->ndev;
 
-		/*
-		 * We are in a callback handler and
-		 * unfortunately we don't know what context we're
-		 * running in.
-		 */
-		if (in_interrupt())
-			netif_rx(skb);
-		else
-			netif_rx_ni(skb);
+		netif_rx_any_context(skb);
 
 		/* Update network statistics. */
 		cfhsi->ndev->stats.rx_packets++;
@@ -587,14 +579,7 @@ static int cfhsi_rx_pld(struct cfhsi_des
 		skb_reset_mac_header(skb);
 		skb->dev = cfhsi->ndev;
 
-		/*
-		 * We're called in callback from HSI
-		 * and don't know the context we're running in.
-		 */
-		if (in_interrupt())
-			netif_rx(skb);
-		else
-			netif_rx_ni(skb);
+		netif_rx_any_context(skb);
 
 		/* Update network statistics. */
 		cfhsi->ndev->stats.rx_packets++;

