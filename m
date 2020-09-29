Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D9627D8D8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgI2UjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:39:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49612 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729480AbgI2UgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:03 -0400
Message-Id: <20200929203501.286933338@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=cza+isFpw3pjruNrzTB8YyTwaqZU0A2/Xz5zP+VRSno=;
        b=lxX+rTT1pI51rZFZT1JdFT4qOji42w0SzxHblZBXZSm8be+ql14IyJD5IYfetVdCq21kTh
        bZwpBl60iJzu7ftA31P1I7DHnicK0JZKnT+a2aB/1x6S7HHdwpz4zv/NAD6DwmE0dTKset
        2Kp9fUPpUDJyR06jN8QNKnSGkRxLDfnIY6Lia2c/qw0dnFpDbEs6hRTNVixJJEU8KY+Nck
        Mm/6Qeu5+G5Emijx3UAxTPhiJlahyQEtrDa5lqfl6IXteQy9xiCsh1NN9eImAadW4Phyxk
        EqmCGCq5iClRs7LPRLx49nJuW49IwwR6mGEbHT6ow5gUnowkjiuan9fB97h9rA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=cza+isFpw3pjruNrzTB8YyTwaqZU0A2/Xz5zP+VRSno=;
        b=jVvPk/ekodleQluohgeB/CSgyS0z1JUCu+zeuCcBc+VXPVD4aVtIlLcjuNQsP6M1OLn2vE
        CdUSxMOMzZQ6RECA==
Date:   Tue, 29 Sep 2020 22:25:27 +0200
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
Subject: [patch V2 18/36] net: sun3lance: Remove redundant checks in interrupt handler
References: <20200929202509.673358734@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

lance_interrupt() contains two pointless checks:

 - A check whether the 'dev_id' argument is NULL. 'dev_id' is the pointer
   which was handed in to request_irq() and the interrupt handler will
   always be invoked with that pointer as 'dev_id' argument by the core
   code.

 - A check for interrupt reentrancy. The core code already guarantees
   non-reentrancy of interrupt handlers.

Remove these check.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/net/ethernet/amd/sun3lance.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -657,16 +657,6 @@ static irqreturn_t lance_interrupt( int
 	struct net_device *dev = dev_id;
 	struct lance_private *lp = netdev_priv(dev);
 	int csr0;
-	static int in_interrupt;
-
-	if (dev == NULL) {
-		DPRINTK( 1, ( "lance_interrupt(): invalid dev_id\n" ));
-		return IRQ_NONE;
-	}
-
-	if (in_interrupt)
-		DPRINTK( 2, ( "%s: Re-entering the interrupt handler.\n", dev->name ));
-	in_interrupt = 1;
 
  still_more:
 	flush_cache_all();
@@ -774,7 +764,6 @@ static irqreturn_t lance_interrupt( int
 
 	DPRINTK( 2, ( "%s: exiting interrupt, csr0=%#04x.\n",
 				  dev->name, DREG ));
-	in_interrupt = 0;
 	return IRQ_HANDLED;
 }
 


