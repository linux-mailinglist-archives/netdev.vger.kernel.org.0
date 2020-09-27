Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C0727A3D4
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgI0UBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:01:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40462 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgI0T5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:57:09 -0400
Message-Id: <20200927194919.806110712@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=JTTK/iwFBS/lwuXuEFjiZEf5zOcCMhuI2Qrc8qysdmE=;
        b=dTurmhNkhlSDVW3y/bXCSbXhHjsX2Znsv8S2xOsxpKNZbIjums2OPbSjNFy+wp9wEMCK4s
        /WH5BpNwRyonykNemmxlL2nRMiB/2svlByU2u7AHCjS2a2+qJ2UNuq5mueQQ4SJnLlTckV
        wXCVpxlhAo83mcTjFfGklccsLaH44hYlSYtUdPoUYszPVR0nlJVjmXqa9+uO/9CB7diIjf
        +mypTgdgZ7FEb9iPN7U99vluG0HbDCK2ZeKrpDz1esRYusXCAbr0JuyodrwactGjYDI6RN
        BX0JX8PLu5togBKAznx7pdnauDK5ZEbqxOJRhJyJCYYEJwcIU7JMzEqA8SkOXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=JTTK/iwFBS/lwuXuEFjiZEf5zOcCMhuI2Qrc8qysdmE=;
        b=33r9PiCBgAGIgPr/Gjw7tySmuVUoiduugzeHovAIDOO2BuhcexNnPA2DJQe3tBNIy3Suvf
        y+NWnP2mXGCzRUBQ==
Date:   Sun, 27 Sep 2020 21:48:47 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: [patch 01/35] net: enic: Cure the enic api locking trainwreck
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

enic_dev_wait() has a BUG_ON(in_interrupt()).

Chasing the callers of enic_dev_wait() revealed the gems of enic_reset()
and enic_tx_hang_reset() which are both invoked through work queues in
order to be able to call rtnl_lock(). So far so good.

After locking rtnl both functions acquire enic::enic_api_lock which
serializes against the (ab)use from infiniband. This is where the
trainwreck starts.

enic::enic_api_lock is a spin_lock() which implicitly disables preemption,
but both functions invoke a ton of functions under that lock which can
sleep. The BUG_ON(in_interrupt()) does not trigger in that case because it
can't detect the preempt disabled condition.

This clearly has never been tested with any of the mandatory debug options
for 7+ years, which would have caught that for sure.

Cure it by adding a enic_api_busy member to struct enic, which is modified
and evaluated with enic::enic_api_lock held.

If enic_api_devcmd_proxy_by_index() observes enic::enic_api_busy as true,
it drops enic::enic_api_lock and busy waits for enic::enic_api_busy to
become false.

It would be smarter to wait for a completion of that busy period, but
enic_api_devcmd_proxy_by_index() is called with other spin locks held which
obviously can't sleep.

Remove the BUG_ON(in_interrupt()) check as well because it's incomplete and
with proper debugging enabled the problem would have been caught from the
debug checks in schedule_timeout().

Fixes: 0b038566c0ea ("drivers/net: enic: Add an interface for USNIC to interact with firmware")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: Govindarajulu Varadarajan <_govind@gmx.com>
Cc: Dave Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/cisco/enic/enic.h      |    1 +
 drivers/net/ethernet/cisco/enic/enic_api.c  |    6 ++++++
 drivers/net/ethernet/cisco/enic/enic_main.c |   27 +++++++++++++++++++++------
 3 files changed, 28 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/cisco/enic/enic.h
+++ b/drivers/net/ethernet/cisco/enic/enic.h
@@ -169,6 +169,7 @@ struct enic {
 	u16 num_vfs;
 #endif
 	spinlock_t enic_api_lock;
+	bool enic_api_busy;
 	struct enic_port_profile *pp;
 
 	/* work queue cache line section */
--- a/drivers/net/ethernet/cisco/enic/enic_api.c
+++ b/drivers/net/ethernet/cisco/enic/enic_api.c
@@ -34,6 +34,12 @@ int enic_api_devcmd_proxy_by_index(struc
 	struct vnic_dev *vdev = enic->vdev;
 
 	spin_lock(&enic->enic_api_lock);
+	while (enic->enic_api_busy) {
+		spin_unlock(&enic->enic_api_lock);
+		cpu_relax();
+		spin_lock(&enic->enic_api_lock);
+	}
+
 	spin_lock_bh(&enic->devcmd_lock);
 
 	vnic_dev_cmd_proxy_by_index_start(vdev, vf);
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2106,8 +2106,6 @@ static int enic_dev_wait(struct vnic_dev
 	int done;
 	int err;
 
-	BUG_ON(in_interrupt());
-
 	err = start(vdev, arg);
 	if (err)
 		return err;
@@ -2295,6 +2293,13 @@ static int enic_set_rss_nic_cfg(struct e
 		rss_hash_bits, rss_base_cpu, rss_enable);
 }
 
+static void enic_set_api_busy(struct enic *enic, bool busy)
+{
+	spin_lock(&enic->enic_api_lock);
+	enic->enic_api_busy = busy;
+	spin_unlock(&enic->enic_api_lock);
+}
+
 static void enic_reset(struct work_struct *work)
 {
 	struct enic *enic = container_of(work, struct enic, reset);
@@ -2304,7 +2309,9 @@ static void enic_reset(struct work_struc
 
 	rtnl_lock();
 
-	spin_lock(&enic->enic_api_lock);
+	/* Stop any activity from infiniband */
+	enic_set_api_state(enic, true);
+
 	enic_stop(enic->netdev);
 	enic_dev_soft_reset(enic);
 	enic_reset_addr_lists(enic);
@@ -2312,7 +2319,10 @@ static void enic_reset(struct work_struc
 	enic_set_rss_nic_cfg(enic);
 	enic_dev_set_ig_vlan_rewrite_mode(enic);
 	enic_open(enic->netdev);
-	spin_unlock(&enic->enic_api_lock);
+
+	/* Allow infiniband to fiddle with the device again */
+	enic_set_api_state(enic, false);
+
 	call_netdevice_notifiers(NETDEV_REBOOT, enic->netdev);
 
 	rtnl_unlock();
@@ -2324,7 +2334,9 @@ static void enic_tx_hang_reset(struct wo
 
 	rtnl_lock();
 
-	spin_lock(&enic->enic_api_lock);
+	/* Stop any activity from infiniband */
+	enic_set_api_state(enic, true);
+
 	enic_dev_hang_notify(enic);
 	enic_stop(enic->netdev);
 	enic_dev_hang_reset(enic);
@@ -2333,7 +2345,10 @@ static void enic_tx_hang_reset(struct wo
 	enic_set_rss_nic_cfg(enic);
 	enic_dev_set_ig_vlan_rewrite_mode(enic);
 	enic_open(enic->netdev);
-	spin_unlock(&enic->enic_api_lock);
+
+	/* Allow infiniband to fiddle with the device again */
+	enic_set_api_state(enic, false);
+
 	call_netdevice_notifiers(NETDEV_REBOOT, enic->netdev);
 
 	rtnl_unlock();

