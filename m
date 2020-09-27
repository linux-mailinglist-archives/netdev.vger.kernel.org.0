Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD4F27A3C6
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgI0UBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:01:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41008 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgI0T5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:57:21 -0400
Message-Id: <20200927194920.918550822@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=/fpa+toQOmOckTk4P8bpyLB4MBbJ8JHunUi6QvsD4Yo=;
        b=CtRgXZy1ytX0/p5X9xftiTfTn0VPr01EWM6ZZHsLKvgzshhk7j4Q6rrIgVfvsR+VinKo2J
        x1oBanNQRWjFumbU68u5+JAcFUCxfvPsdOqghKCDpl5FP+27bwJDHEV0R4KceCasrV6t4z
        EJicpEbJi88VxuekWda8z4ATJtjRgwh9cW/ttclV5jMEQe+zMGdbrMw4/BNbtxFLA04eP2
        rdoQyFA0iNXXmD2ZX5Q1A88SeU/JIQ+0WmrT1h3mUuC+M3gFYkn9M6Us3KbmXYh3NB+Kkp
        mjOW4NRPtwalK1I89k1bvvG6rHL3DLE4QdfqZRnkgmK/qsf6nxt1Yz2EwXiz2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=/fpa+toQOmOckTk4P8bpyLB4MBbJ8JHunUi6QvsD4Yo=;
        b=fOw8Y7qTo4iLde0u11Ekj1AAZR2ePbfjT+y8Hd2a4xm2+O+r2fibRhuAj395bp2J0WLTcL
        gvs7HcgEwIbgycBA==
Date:   Sun, 27 Sep 2020 21:48:57 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
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
        intel-wired-lan@lists.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
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
Subject: [patch 11/35] net: ionic: Replace in_interrupt() usage.
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The in_interrupt() usage in this driver tries to figure out which context
may sleep and which context may not sleep. in_interrupt() is not really
suitable as it misses both preemption disabled and interrupt disabled
invocations from task context.

Conditionals like that in driver code are frowned upon in general because
invocations of functions from invalid contexts might not be detected
as the conditional papers over it.

ionic_lif_addr() can be called from:

 1) ->ndo_set_rx_mode() which is under netif_addr_lock_bh()) so it must not
    sleep.

 2) Init and setup functions which are in fully preemptible task context.

_ionic_lif_rx_mode() has only one call path with BH disabled.

ionic_link_status_check_request() has two call paths:

 1) NAPI which obviously cannot sleep

 2) Setup which is again fully preemptible task context

Add 'can_sleep' arguments to the affected functions and let the callers
provide the context instead of letting the functions deduce it.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Shannon Nelson <snelson@pensando.io>
Cc: Pensando Drivers <drivers@pensando.io>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---

While reviewing the callpaths, a couple of things were observed which could
be improved:

- ionic_lif_deferred_work() can iterate over the list. There is no need
  to schedule the work item after each iteration

- ionic_link_status_check_request() could have ionic_deferred_work within
  ionic_lif(). This would avoid memory allocation from NAPI. More
  important, once IONIC_LIF_F_LINK_CHECK_REQUESTED is set and that alloc
  fails, the link check never happens.

- ionic_lif_handle_fw_down() sets IONIC_LIF_F_FW_RESET. Invokes then
  ionic_lif_deinit() which only invokes cancel_work_sync() if
  IONIC_LIF_F_FW_RESET is not set. I think the logic is wrong here as
  the work must always be cancled. Also the list with ionic_deferred
  work items needs a clean up.

---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c |    2 -
 drivers/net/ethernet/pensando/ionic/ionic_lif.c |   43 +++++++++++-------------
 drivers/net/ethernet/pensando/ionic/ionic_lif.h |    2 -
 3 files changed, 22 insertions(+), 25 deletions(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -22,7 +22,7 @@ static void ionic_watchdog_cb(struct tim
 	hb = ionic_heartbeat_check(ionic);
 
 	if (hb >= 0 && ionic->master_lif)
-		ionic_link_status_check_request(ionic->master_lif);
+		ionic_link_status_check_request(ionic->master_lif, false);
 }
 
 void ionic_init_devinfo(struct ionic *ionic)
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -135,7 +135,7 @@ static void ionic_link_status_check(stru
 	clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
 }
 
-void ionic_link_status_check_request(struct ionic_lif *lif)
+void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep)
 {
 	struct ionic_deferred_work *work;
 
@@ -143,7 +143,7 @@ void ionic_link_status_check_request(str
 	if (test_and_set_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
 		return;
 
-	if (in_interrupt()) {
+	if (!can_sleep) {
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
 		if (!work)
 			return;
@@ -751,7 +751,7 @@ static bool ionic_notifyq_service(struct
 
 	switch (le16_to_cpu(comp->event.ecode)) {
 	case IONIC_EVENT_LINK_CHANGE:
-		ionic_link_status_check_request(lif);
+		ionic_link_status_check_request(lif, false);
 		break;
 	case IONIC_EVENT_RESET:
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
@@ -928,7 +928,8 @@ static int ionic_lif_addr_del(struct ion
 	return 0;
 }
 
-static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add)
+static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add,
+			  bool can_sleep)
 {
 	struct ionic *ionic = lif->ionic;
 	struct ionic_deferred_work *work;
@@ -957,7 +958,7 @@ static int ionic_lif_addr(struct ionic_l
 			lif->nucast--;
 	}
 
-	if (in_interrupt()) {
+	if (!can_sleep) {
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
 		if (!work) {
 			netdev_err(lif->netdev, "%s OOM\n", __func__);
@@ -983,12 +984,12 @@ static int ionic_lif_addr(struct ionic_l
 
 static int ionic_addr_add(struct net_device *netdev, const u8 *addr)
 {
-	return ionic_lif_addr(netdev_priv(netdev), addr, true);
+	return ionic_lif_addr(netdev_priv(netdev), addr, true, false);
 }
 
 static int ionic_addr_del(struct net_device *netdev, const u8 *addr)
 {
-	return ionic_lif_addr(netdev_priv(netdev), addr, false);
+	return ionic_lif_addr(netdev_priv(netdev), addr, false, false);
 }
 
 static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
@@ -1032,19 +1033,15 @@ static void _ionic_lif_rx_mode(struct io
 {
 	struct ionic_deferred_work *work;
 
-	if (in_interrupt()) {
-		work = kzalloc(sizeof(*work), GFP_ATOMIC);
-		if (!work) {
-			netdev_err(lif->netdev, "%s OOM\n", __func__);
-			return;
-		}
-		work->type = IONIC_DW_TYPE_RX_MODE;
-		work->rx_mode = rx_mode;
-		netdev_dbg(lif->netdev, "deferred: rx_mode\n");
-		ionic_lif_deferred_enqueue(&lif->deferred, work);
-	} else {
-		ionic_lif_rx_mode(lif, rx_mode);
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work) {
+		netdev_err(lif->netdev, "%s OOM\n", __func__);
+		return;
 	}
+	work->type = IONIC_DW_TYPE_RX_MODE;
+	work->rx_mode = rx_mode;
+	netdev_dbg(lif->netdev, "deferred: rx_mode\n");
+	ionic_lif_deferred_enqueue(&lif->deferred, work);
 }
 
 static void ionic_set_rx_mode(struct net_device *netdev)
@@ -1312,7 +1309,7 @@ static int ionic_set_mac_address(struct
 	eth_commit_mac_addr_change(netdev, addr);
 	netdev_info(netdev, "updating mac addr %pM\n", mac);
 
-	return ionic_addr_add(netdev, mac);
+	return ionic_lif_addr(netdev_priv(netdev), mac, true, true);
 }
 
 static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
@@ -2252,7 +2249,7 @@ static void ionic_lif_handle_fw_up(struc
 	}
 
 	clear_bit(IONIC_LIF_F_FW_RESET, lif->state);
-	ionic_link_status_check_request(lif);
+	ionic_link_status_check_request(lif, true);
 	netif_device_attach(lif->netdev);
 	dev_info(ionic->dev, "FW Up: LIFs restarted\n");
 
@@ -2468,7 +2465,7 @@ static int ionic_station_set(struct ioni
 		 */
 		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
 				      netdev->dev_addr))
-			ionic_lif_addr(lif, netdev->dev_addr, true);
+			ionic_lif_addr(lif, netdev->dev_addr, true, true);
 	} else {
 		/* Update the netdev mac with the device's mac */
 		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
@@ -2485,7 +2482,7 @@ static int ionic_station_set(struct ioni
 
 	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
 		   netdev->dev_addr);
-	ionic_lif_addr(lif, netdev->dev_addr, true);
+	ionic_lif_addr(lif, netdev->dev_addr, true, true);
 
 	return 0;
 }
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -237,7 +237,7 @@ static inline u32 ionic_coal_usec_to_hw(
 
 typedef void (*ionic_reset_cb)(struct ionic_lif *lif, void *arg);
 
-void ionic_link_status_check_request(struct ionic_lif *lif);
+void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep);
 void ionic_get_stats64(struct net_device *netdev,
 		       struct rtnl_link_stats64 *ns);
 void ionic_lif_deferred_enqueue(struct ionic_deferred *def,

