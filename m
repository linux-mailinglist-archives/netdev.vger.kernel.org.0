Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A01627A332
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgI0T52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgI0T5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:57:17 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2FBC0613D8;
        Sun, 27 Sep 2020 12:57:15 -0700 (PDT)
Message-Id: <20200927194920.529620472@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=EDKBcMIgD/09FuiGSNYHhCF3jDv+nrJ0d2CEBofmw7g=;
        b=snXKYTawQUFS88tiTEow0tXsxP1tLJM9xHT4/iSNgIAGuodQmc9Qp0KQGNZNqlz9QV4M5I
        Rwhti+lRXO9IB8T3AG1+oqCZy8zEWXsIqGQUGjndLp2o/23CsbScRTMQxV1S+kh8QLeOFq
        GhrN/1KMvDQQJRY8cCanEj7G/YgGLxhd8+CicY7yErSGgVrutMDhvDA+2Le5tZEPNrhF92
        HNLfR/nf1tFFd6gkjfLx4iaWWvrDbiiNIpQNQydVKD+szuJ1u60oQehMuNWOmSJiLRtlOZ
        NjsUY5WOXonQTXiJuGxEgPxLSh81hYb/Q/qsEkT8VlOOAQCtaHM8RWF7F0a1IA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=EDKBcMIgD/09FuiGSNYHhCF3jDv+nrJ0d2CEBofmw7g=;
        b=dCG7TC8ALt/lqqr+lqrqo16u3cIrM1QEOqBoykQQB7Oqrb7kPbGrYa/ghwEhg4k/GILAkS
        r43l5jfMGGMm/jDA==
Date:   Sun, 27 Sep 2020 21:48:53 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
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
Subject: [patch 07/35] net: cxbg4: Remove pointless in_interrupt() check
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

t4_sge_stop() is only ever called from task context and the in_interrupt()
check is presumably a leftover from copying t3_sge_stop().

Aside of in_interrupt() being deprecated because it's not providing what it
claims to provide, this check would paper over illegitimate callers.

The functions invoked from t4_sge_stop() contain already warnings to catch
invocations from invalid contexts.

Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Kulkarni <vishal@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org


---
 drivers/net/ethernet/chelsio/cxgb4/sge.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -4872,9 +4872,6 @@ void t4_sge_stop(struct adapter *adap)
 	int i;
 	struct sge *s = &adap->sge;
 
-	if (in_interrupt())  /* actions below require waiting */
-		return;
-
 	if (s->rx_timer.function)
 		del_timer_sync(&s->rx_timer);
 	if (s->tx_timer.function)

