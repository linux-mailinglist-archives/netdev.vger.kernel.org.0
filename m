Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3295627A334
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgI0T53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:57:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41032 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgI0T5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:57:19 -0400
Message-Id: <20200927194920.730139599@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=EEFvcB/PwX9I89XLy131RQtWz3cYksfF3sbWg1NgDKQ=;
        b=18wUYjsdKMHJjgk4Us6khomilIdN25/SxDKIyuwyy0mSiSW/AeUP1NyRsE5FG33qrGO7QW
        jAw9J0tpj7pkffmpsb/I2xP+dFW27rpV0wEiciSCAhxQ4lnNpojA/FRCq5TQQMHJs+lphz
        fgNiUXBSNsmvPrgof215OGNS4MuZnGdrVxgP/w3I5rVQS+sGNlkRrVZGKmKgjWg+gIT3ZC
        R3cytjZp8ns5FunZ7qOWr6CiFfel+oq9NIgBWersYnxzOkskjX86LkiuElpQ5nTvA14pAx
        TSOmfZ9AKUnaegaoe9jBxklb5wqP3NKRYyZYH2Da+kRNpZ7XfqbG/dYW5gWETg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=EEFvcB/PwX9I89XLy131RQtWz3cYksfF3sbWg1NgDKQ=;
        b=Uk0vLGNob7iKmswDXccCQehW+RKFAsRxN//Pf6BDgW08Dcoqm6jDgpCxycTWKPE0t0GELZ
        tesv+y7MgSj9WRBg==
Date:   Sun, 27 Sep 2020 21:48:55 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
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
Subject: [patch 09/35] net: fec_mpc52xx: Replace in_interrupt() usage
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be seperated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

mpc52xx_fec_stop() uses in_interrupt() to check if it is safe to sleep. All
callers run in well defined contexts.

Pass an argument from the callers indicating whether it is safe to sleep.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org

---
 drivers/net/ethernet/freescale/fec_mpc52xx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -74,7 +74,7 @@ struct mpc52xx_fec_priv {
 static irqreturn_t mpc52xx_fec_interrupt(int, void *);
 static irqreturn_t mpc52xx_fec_rx_interrupt(int, void *);
 static irqreturn_t mpc52xx_fec_tx_interrupt(int, void *);
-static void mpc52xx_fec_stop(struct net_device *dev);
+static void mpc52xx_fec_stop(struct net_device *dev, bool may_sleep);
 static void mpc52xx_fec_start(struct net_device *dev);
 static void mpc52xx_fec_reset(struct net_device *dev);
 
@@ -283,7 +283,7 @@ static int mpc52xx_fec_close(struct net_
 
 	netif_stop_queue(dev);
 
-	mpc52xx_fec_stop(dev);
+	mpc52xx_fec_stop(dev, true);
 
 	mpc52xx_fec_free_rx_buffers(dev, priv->rx_dmatsk);
 
@@ -693,7 +693,7 @@ static void mpc52xx_fec_start(struct net
  *
  * stop all activity on fec and empty dma buffers
  */
-static void mpc52xx_fec_stop(struct net_device *dev)
+static void mpc52xx_fec_stop(struct net_device *dev, bool may_sleep)
 {
 	struct mpc52xx_fec_priv *priv = netdev_priv(dev);
 	struct mpc52xx_fec __iomem *fec = priv->fec;
@@ -706,7 +706,7 @@ static void mpc52xx_fec_stop(struct net_
 	bcom_disable(priv->rx_dmatsk);
 
 	/* Wait for tx queue to drain, but only if we're in process context */
-	if (!in_interrupt()) {
+	if (may_sleep) {
 		timeout = jiffies + msecs_to_jiffies(2000);
 		while (time_before(jiffies, timeout) &&
 				!bcom_queue_empty(priv->tx_dmatsk))
@@ -738,7 +738,7 @@ static void mpc52xx_fec_reset(struct net
 	struct mpc52xx_fec_priv *priv = netdev_priv(dev);
 	struct mpc52xx_fec __iomem *fec = priv->fec;
 
-	mpc52xx_fec_stop(dev);
+	mpc52xx_fec_stop(dev, false);
 
 	out_be32(&fec->rfifo_status, in_be32(&fec->rfifo_status));
 	out_be32(&fec->reset_cntrl, FEC_RESET_CNTRL_RESET_FIFO);

