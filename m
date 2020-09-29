Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8E827D879
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgI2Ugk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:36:40 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49846 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729602AbgI2UgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:25 -0400
Message-Id: <20200929203502.769744809@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=xQW4uASz9uqznLJIj4qcsFxH9Z8YREJkeiGPclI3SY4=;
        b=VmCI2D2Ny+qH7axYUwaHrPzomt90DEvNPUFa4athxXyOldRwucZi+mpjH9cQpb7UMMgzEb
        MQs1EqyE2gm/hUycQGdCuv6ym0XqNHpQtDWesd8GQxGa7V/a2/XeRTQeCOi2+yP48VjE0B
        NWY9OJIr76Z0C2KFu6M+xQTpBcNgw4txtbJ+ATRSRWYBCn8fHrtffIem0LRZiVblqiEbFE
        Ld7FipKjWWXNWIpDPynM42KDrzIGh5Hvt9lBpsf6tdpH+P8OQc7oPB4dSLkyFIIhwMPO3m
        Tq+PSzuBOVUV2kJa9paJLjzsTZ+Gr/PqDAll9JLXUTwC2XTmgPcUpoKWi43CcA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=xQW4uASz9uqznLJIj4qcsFxH9Z8YREJkeiGPclI3SY4=;
        b=e77qSX7G44v7lcRfnWC4fJIgUIsPLTFgN73WQthw0m+L1lyZJXW7/Sici4zIQS1FFRHOHC
        csgNmx1IMIAG72Cg==
Date:   Tue, 29 Sep 2020 22:25:42 +0200
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
Subject: [patch V2 33/36] net: libertas: Use netif_rx_any_context()
References: <20200929202509.673358734@linutronix.de>
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

libertas uses in_interupt() to select the netif_rx*() variant which matches
the calling context. The attempt to consolidate the code by passing an
arguemnt or by distangling it failed due lack of knowledge about this
driver and because the call chains are hard to follow.

As a stop gap use netif_rx_any_context() which invokes the correct code
path depending on context and confines the in_interrupt() usage to core
code.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/marvell/libertas/rx.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/marvell/libertas/rx.c
+++ b/drivers/net/wireless/marvell/libertas/rx.c
@@ -147,10 +147,7 @@ int lbs_process_rxed_packet(struct lbs_p
 	dev->stats.rx_packets++;
 
 	skb->protocol = eth_type_trans(skb, dev);
-	if (in_interrupt())
-		netif_rx(skb);
-	else
-		netif_rx_ni(skb);
+	netif_rx_any_context(skb);
 
 	ret = 0;
 done:
@@ -265,11 +262,7 @@ static int process_rxed_802_11_packet(st
 	dev->stats.rx_packets++;
 
 	skb->protocol = eth_type_trans(skb, priv->dev);
-
-	if (in_interrupt())
-		netif_rx(skb);
-	else
-		netif_rx_ni(skb);
+	netif_rx_any_context(skb);
 
 	ret = 0;
 


