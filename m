Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC6227D870
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgI2UgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:36:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48970 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbgI2Ufw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:35:52 -0400
Message-Id: <20200929203500.387065111@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=PXfmmgnLqJrKbGfM8Rno7TyW/8sPcCBInVY2ghnpy1k=;
        b=flqsN7bhcZA5Gw8H61esyNKoIuK+eoQXrensTvj/LyVRl43ik4SPulyUAEKMp1yDYLyGDP
        D9B0Ixm9oRoH8KTg+e+7s2Fn6Lva3dPkWEMLiHhPp1IlfC19hCBf9zb6E9g71fll8PukQD
        NRJBtmyojfh7kHqy5+QkuRwvrf9C8DSIqvBSt4LzhfjLEnloUE6vyU4B1N8NUA0N3IiCs5
        VqBUHxBrHMaDhc1URd/tZkWC4I7J98XWC/UfOyCfyvEPTu8BeiYx/XnUdWjH7qPa4poY5x
        QzprHXM2q2Ybp0p/gTovJvJHX28WMo2/AYNrPo6uEcgYbnyD26FntiZnhw2FCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=PXfmmgnLqJrKbGfM8Rno7TyW/8sPcCBInVY2ghnpy1k=;
        b=oCN2qgxmVrimWJDSWDSzOU3Ho3aP5P7+Iri+NSeJMXl19XYF6nwaQsBCpQWTTc2WCbRWS6
        cY9ORhiBMg/aoFBQ==
Date:   Tue, 29 Sep 2020 22:25:18 +0200
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
Subject: [patch V2 09/36] net: fec_mpc52xx: Replace in_interrupt() usage
References: <20200929202509.673358734@linutronix.de>
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


