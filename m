Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF32627D8A3
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbgI2Uhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729576AbgI2UgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:23 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47C3C0613D9;
        Tue, 29 Sep 2020 13:36:12 -0700 (PDT)
Message-Id: <20200929203502.084703195@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=LrldQJQw6qypyNQybdI02NG+9/ckddJHjYgk5hlEHHQ=;
        b=W50wQ+GaNd8R4tSNqTICBdQk/2YIRsw/r76XqikWEnHF2rKl0QKsifKzK/4rpV3JddmiKx
        5X9q0gc1DwFsx2n5C1lF6JO6j7qwcsl6yNq7fwB7V/6Q3n4KpRPYmTGSv4n00HudhtSxvI
        fjbk1EPV24IDWvSw+12gnFlG6RBnY4uxWmnrJKPSZdd09LynExhub++x0V0wIKoQTOdcTv
        vVCFtXASKKnFemHFsTagTjSzQsahMlM34laJrI1RDyJofrTl+M2kz5U+WEWJu5Fu9EURdU
        9bxJK/Fruu0QWmbEeCkavOHYNgBbhfl4d0nmx0aubAlDJFkABGcbkXcnjeIWqA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=LrldQJQw6qypyNQybdI02NG+9/ckddJHjYgk5hlEHHQ=;
        b=aYCDVQdMR8R7kgHsLF+gsqoZURiRjoLdvdDdOUWZI6x+sX8Je6Xb+rKLwd0K1HqRODWQKz
        pZYqigkaNJN28jAA==
Date:   Tue, 29 Sep 2020 22:25:35 +0200
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
Subject: [patch V2 26/36] net: brcmfmac: Convey execution context via argument
 to brcmf_netif_rx()
References: <20200929202509.673358734@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bcrmgf_netif_rx() uses in_interrupt to chose between netif_rx() and
netif_rx_ni(). in_interrupt() usage in drivers is phased out.

Convey the execution mode via an 'inirq' argument through the various
callchains leading to brcmf_netif_rx():

brcmf_pcie_isr_thread()		    <- Task context
  brcmf_proto_msgbuf_rx_trigger()
    brcmf_msgbuf_process_rx()
      brcmf_msgbuf_process_msgtype()
        brcmf_msgbuf_process_rx_complete()
	  brcmf_netif_mon_rx()
	     brcmf_netif_rx(isirq = false)
	  brcmf_netif_rx(isirq = false)

brcmf_sdio_readframes()  <- Task context sdio_claim_host() might sleep
  brcmf_rx_frame(isirq = false)

brcmf_sdio_rxglom()      <- Task context sdio_claim_host() might sleep
  brcmf_rx_frame(isirq = false)

brcmf_usb_rx_complete()  <- Interrupt context
  brcmf_rx_frame(isirq = true)

brcmf_rx_frame()
  brcmf_proto_rxreorder()
    brcmf_proto_bcdc_rxreorder()
      brcmf_fws_rxreorder()
        brcmf_netif_rx()
      brcmf_netif_rx()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
---
V2: New patch. Using an argument instead of switching to netif_rx_any_context()
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c     |    4 +--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h      |    3 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     |   16 ++++++------
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h     |    2 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c |   10 +++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h |    2 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c   |    5 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h    |    6 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     |    4 +--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c      |    2 -
 10 files changed, 29 insertions(+), 25 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -397,9 +397,9 @@ brcmf_proto_bcdc_add_tdls_peer(struct br
 }
 
 static void brcmf_proto_bcdc_rxreorder(struct brcmf_if *ifp,
-				       struct sk_buff *skb)
+				       struct sk_buff *skb, bool inirq)
 {
-	brcmf_fws_rxreorder(ifp, skb);
+	brcmf_fws_rxreorder(ifp, skb, inirq);
 }
 
 static void
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -249,7 +249,8 @@ int brcmf_bus_reset(struct brcmf_bus *bu
  */
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_event);
+void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_event,
+		    bool inirq);
 /* Receive async event packet from firmware. Callee disposes of rxp. */
 void brcmf_rx_event(struct device *dev, struct sk_buff *rxp);
 
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -395,7 +395,7 @@ void brcmf_txflowblock_if(struct brcmf_i
 	spin_unlock_irqrestore(&ifp->netif_stop_lock, flags);
 }
 
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb, bool inirq)
 {
 	/* Most of Broadcom's firmwares send 802.11f ADD frame every time a new
 	 * STA connects to the AP interface. This is an obsoleted standard most
@@ -418,14 +418,15 @@ void brcmf_netif_rx(struct brcmf_if *ifp
 	ifp->ndev->stats.rx_packets++;
 
 	brcmf_dbg(DATA, "rx proto=0x%X\n", ntohs(skb->protocol));
-	if (in_interrupt())
+	if (inirq) {
 		netif_rx(skb);
-	else
+	} else {
 		/* If the receive is not processed inside an ISR,
 		 * the softirqd must be woken explicitly to service
 		 * the NET_RX_SOFTIRQ.  This is handled by netif_rx_ni().
 		 */
 		netif_rx_ni(skb);
+	}
 }
 
 void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb)
@@ -474,7 +475,7 @@ void brcmf_netif_mon_rx(struct brcmf_if
 	skb->pkt_type = PACKET_OTHERHOST;
 	skb->protocol = htons(ETH_P_802_2);
 
-	brcmf_netif_rx(ifp, skb);
+	brcmf_netif_rx(ifp, skb, false);
 }
 
 static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
@@ -496,7 +497,8 @@ static int brcmf_rx_hdrpull(struct brcmf
 	return 0;
 }
 
-void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_event)
+void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_event,
+		    bool inirq)
 {
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -508,14 +510,14 @@ void brcmf_rx_frame(struct device *dev,
 		return;
 
 	if (brcmf_proto_is_reorder_skb(skb)) {
-		brcmf_proto_rxreorder(ifp, skb);
+		brcmf_proto_rxreorder(ifp, skb, inirq);
 	} else {
 		/* Process special event packets */
 		if (handle_event)
 			brcmf_fweh_process_skb(ifp->drvr, skb,
 					       BCMILCP_SUBTYPE_VENDOR_LONG);
 
-		brcmf_netif_rx(ifp, skb);
+		brcmf_netif_rx(ifp, skb, inirq);
 	}
 }
 
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -208,7 +208,7 @@ void brcmf_remove_interface(struct brcmf
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb, bool inirq);
 void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_detach(struct net_device *ndev, bool rtnl_locked);
 int brcmf_net_mon_attach(struct brcmf_if *ifp);
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1664,7 +1664,7 @@ static void brcmf_rxreorder_get_skb_list
 	rfi->pend_pkts -= skb_queue_len(skb_list);
 }
 
-void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
+void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt, bool inirq)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
 	u8 *reorder_data;
@@ -1682,7 +1682,7 @@ void brcmf_fws_rxreorder(struct brcmf_if
 	/* validate flags and flow id */
 	if (flags == 0xFF) {
 		bphy_err(drvr, "invalid flags...so ignore this packet\n");
-		brcmf_netif_rx(ifp, pkt);
+		brcmf_netif_rx(ifp, pkt, inirq);
 		return;
 	}
 
@@ -1694,7 +1694,7 @@ void brcmf_fws_rxreorder(struct brcmf_if
 		if (rfi == NULL) {
 			brcmf_dbg(INFO, "received flags to cleanup, but no flow (%d) yet\n",
 				  flow_id);
-			brcmf_netif_rx(ifp, pkt);
+			brcmf_netif_rx(ifp, pkt, inirq);
 			return;
 		}
 
@@ -1719,7 +1719,7 @@ void brcmf_fws_rxreorder(struct brcmf_if
 		rfi = kzalloc(buf_size, GFP_ATOMIC);
 		if (rfi == NULL) {
 			bphy_err(drvr, "failed to alloc buffer\n");
-			brcmf_netif_rx(ifp, pkt);
+			brcmf_netif_rx(ifp, pkt, inirq);
 			return;
 		}
 
@@ -1833,7 +1833,7 @@ void brcmf_fws_rxreorder(struct brcmf_if
 netif_rx:
 	skb_queue_walk_safe(&reorder_list, pkt, pnext) {
 		__skb_unlink(pkt, &reorder_list);
-		brcmf_netif_rx(ifp, pkt);
+		brcmf_netif_rx(ifp, pkt, inirq);
 	}
 }
 
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
@@ -42,6 +42,6 @@ void brcmf_fws_add_interface(struct brcm
 void brcmf_fws_del_interface(struct brcmf_if *ifp);
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb);
 void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked);
-void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb);
+void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb, bool inirq);
 
 #endif /* FWSIGNAL_H_ */
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -536,7 +536,8 @@ static int brcmf_msgbuf_hdrpull(struct b
 	return -ENODEV;
 }
 
-static void brcmf_msgbuf_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb)
+static void brcmf_msgbuf_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb,
+				   bool inirq)
 {
 }
 
@@ -1190,7 +1191,7 @@ brcmf_msgbuf_process_rx_complete(struct
 	}
 
 	skb->protocol = eth_type_trans(skb, ifp->ndev);
-	brcmf_netif_rx(ifp, skb);
+	brcmf_netif_rx(ifp, skb, false);
 }
 
 static void brcmf_msgbuf_process_gen_status(struct brcmf_msgbuf *msgbuf,
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -32,7 +32,7 @@ struct brcmf_proto {
 			    u8 peer[ETH_ALEN]);
 	void (*add_tdls_peer)(struct brcmf_pub *drvr, int ifidx,
 			      u8 peer[ETH_ALEN]);
-	void (*rxreorder)(struct brcmf_if *ifp, struct sk_buff *skb);
+	void (*rxreorder)(struct brcmf_if *ifp, struct sk_buff *skb, bool inirq);
 	void (*add_if)(struct brcmf_if *ifp);
 	void (*del_if)(struct brcmf_if *ifp);
 	void (*reset_if)(struct brcmf_if *ifp);
@@ -109,9 +109,9 @@ static inline bool brcmf_proto_is_reorde
 }
 
 static inline void
-brcmf_proto_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb)
+brcmf_proto_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb, bool inirq)
 {
-	ifp->drvr->proto->rxreorder(ifp, skb);
+	ifp->drvr->proto->rxreorder(ifp, skb, inirq);
 }
 
 static inline void
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1704,7 +1704,7 @@ static u8 brcmf_sdio_rxglom(struct brcmf
 				brcmf_rx_event(bus->sdiodev->dev, pfirst);
 			else
 				brcmf_rx_frame(bus->sdiodev->dev, pfirst,
-					       false);
+					       false, false);
 			bus->sdcnt.rxglompkts++;
 		}
 
@@ -2038,7 +2038,7 @@ static uint brcmf_sdio_readframes(struct
 			brcmf_rx_event(bus->sdiodev->dev, pkt);
 		else
 			brcmf_rx_frame(bus->sdiodev->dev, pkt,
-				       false);
+				       false, false);
 
 		/* prepare the descriptor for the next read */
 		rd->len = rd->len_nxtfrm << 4;
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -532,7 +532,7 @@ static void brcmf_usb_rx_complete(struct
 	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP ||
 	    devinfo->bus_pub.state == BRCMFMAC_USB_STATE_SLEEP) {
 		skb_put(skb, urb->actual_length);
-		brcmf_rx_frame(devinfo->dev, skb, true);
+		brcmf_rx_frame(devinfo->dev, skb, true, true);
 		brcmf_usb_rx_refill(devinfo, req);
 		usb_mark_last_busy(urb->dev);
 	} else {

