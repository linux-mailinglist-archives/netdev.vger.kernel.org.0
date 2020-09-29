Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0446127D8BD
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgI2UiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:38:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50286 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgI2UgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:15 -0400
Message-Id: <20200929203502.180883992@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=hwdF1V4LMxNUL7q9z/lP9cddjWDJRZagT/G6Cdx9lrk=;
        b=uZt/eUN8OfZhfYu4gZx4bXPXea7lornACIiuoDVJLvHk2H8Q8Zv+kZOUr87g2/UhKiST25
        V+/5V+y0ru/ey1GSt3YtUGGFonFivlElx2HcMOpJum88Qm4oYIvstjSTEDik2AaMV8e5Io
        J+QO3V4F0uKsEyaI4fFydfJrzfeINlStfebs97Ve8vMXpFni+74VYRi+3PTFfSf6dv3JNz
        7+tQKj8T0Nser9o2g7IMsgMJoxIKPBi7cfkxQC2Ymw0kgyaIKQQUdyTFBzUoebRwOyVN2y
        1jAndEXur5WuP/3T0J0e4fP7iBuID+fkll24K9x2fQGJYBZ1bWsjLH3RXZK3bg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=hwdF1V4LMxNUL7q9z/lP9cddjWDJRZagT/G6Cdx9lrk=;
        b=G060K35tQ0idi9JDnp6uPFJ6I678hM/pUygnucHylPIewlMqMLY0K4NAFzL375dZQcwl/H
        fhMzYNClcuz68CDw==
Date:   Tue, 29 Sep 2020 22:25:36 +0200
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
Subject: [patch V2 27/36] net: brcmfmac: Convey allocation mode as argument
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

brcmf_fweh_process_event() uses in_interrupt() to select the allocation
mode GFP_KERNEL/GFP_ATOMIC. Aside of the above reasons this check is
incomplete as it cannot detect contexts which just have preemption or
interrupts disabled.

All callchains leading to brcmf_fweh_process_event() can clearly identify
the calling context. Convey a 'gfp' argument through the callchains and let
the callers hand in the appropriate GFP mode.

This has also the advantage that any change of execution context or
preemption/interrupt state in these callchains will be detected by the
memory allocator for all GFP_KERNEL allocations.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: Adopt to the 'inirq' changes
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c   |   10 ++++++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c   |    8 ++------
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h   |    7 ++++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c |    2 +-
 4 files changed, 13 insertions(+), 14 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -513,10 +513,12 @@ void brcmf_rx_frame(struct device *dev,
 		brcmf_proto_rxreorder(ifp, skb, inirq);
 	} else {
 		/* Process special event packets */
-		if (handle_event)
-			brcmf_fweh_process_skb(ifp->drvr, skb,
-					       BCMILCP_SUBTYPE_VENDOR_LONG);
+		if (handle_event) {
+			gfp_t gfp = inirq ? GFP_ATOMIC : GFP_KERNEL;
 
+			brcmf_fweh_process_skb(ifp->drvr, skb,
+					       BCMILCP_SUBTYPE_VENDOR_LONG, gfp);
+		}
 		brcmf_netif_rx(ifp, skb, inirq);
 	}
 }
@@ -532,7 +534,7 @@ void brcmf_rx_event(struct device *dev,
 	if (brcmf_rx_hdrpull(drvr, skb, &ifp))
 		return;
 
-	brcmf_fweh_process_skb(ifp->drvr, skb, 0);
+	brcmf_fweh_process_skb(ifp->drvr, skb, 0, GFP_KERNEL);
 	brcmu_pkt_buf_free_skb(skb);
 }
 
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -388,12 +388,11 @@ int brcmf_fweh_activate_events(struct br
  */
 void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 			      struct brcmf_event *event_packet,
-			      u32 packet_len)
+			      u32 packet_len, gfp_t gfp)
 {
 	enum brcmf_fweh_event_code code;
 	struct brcmf_fweh_info *fweh = &drvr->fweh;
 	struct brcmf_fweh_queue_item *event;
-	gfp_t alloc_flag = GFP_KERNEL;
 	void *data;
 	u32 datalen;
 
@@ -412,10 +411,7 @@ void brcmf_fweh_process_event(struct brc
 	    datalen + sizeof(*event_packet) > packet_len)
 		return;
 
-	if (in_interrupt())
-		alloc_flag = GFP_ATOMIC;
-
-	event = kzalloc(sizeof(*event) + datalen, alloc_flag);
+	event = kzalloc(sizeof(*event) + datalen, gfp);
 	if (!event)
 		return;
 
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
@@ -319,11 +319,12 @@ void brcmf_fweh_unregister(struct brcmf_
 int brcmf_fweh_activate_events(struct brcmf_if *ifp);
 void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 			      struct brcmf_event *event_packet,
-			      u32 packet_len);
+			      u32 packet_len, gfp_t gfp);
 void brcmf_fweh_p2pdev_setup(struct brcmf_if *ifp, bool ongoing);
 
 static inline void brcmf_fweh_process_skb(struct brcmf_pub *drvr,
-					  struct sk_buff *skb, u16 stype)
+					  struct sk_buff *skb, u16 stype,
+					  gfp_t gfp)
 {
 	struct brcmf_event *event_packet;
 	u16 subtype, usr_stype;
@@ -354,7 +355,7 @@ static inline void brcmf_fweh_process_sk
 	if (usr_stype != BCMILCP_BCM_SUBTYPE_EVENT)
 		return;
 
-	brcmf_fweh_process_event(drvr, event_packet, skb->len + ETH_HLEN);
+	brcmf_fweh_process_event(drvr, event_packet, skb->len + ETH_HLEN, gfp);
 }
 
 #endif /* FWEH_H_ */
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1129,7 +1129,7 @@ static void brcmf_msgbuf_process_event(s
 
 	skb->protocol = eth_type_trans(skb, ifp->ndev);
 
-	brcmf_fweh_process_skb(ifp->drvr, skb, 0);
+	brcmf_fweh_process_skb(ifp->drvr, skb, 0, GFP_KERNEL);
 
 exit:
 	brcmu_pkt_buf_free_skb(skb);

