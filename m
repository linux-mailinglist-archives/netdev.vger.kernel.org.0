Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F4B27A33F
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgI0T6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:58:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40792 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgI0T5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:57:20 -0400
Message-Id: <20200927194920.824108021@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=83qDvGuLXzUs/9fusW5YkDt4paS3sBnoEIk7Nou3kd0=;
        b=qDV71a+1GCvWhc9lufX4zEQV7QRn9/bZHT8FQITekgxUS3UAIr0pogPAdA1ExY69S+jY/y
        fkbAjNZifsS1uaBZ56OIZlb/i3fbugRM4FDd4AfJ2FXShvtx00KA5Db9UVXjW6mUGqUgfg
        rinNQlXj5sEvgqNILV8BDzifz0AdiMlUsSB1znzPo1Q6Pmi+re17ux1P+Oi4e3ZiLtwaIg
        Bsr9UzJiR/me2V1yYQ6eX720Q8Itoag1PNITz/wjwjbcca850NRUnYK12EbcnOuGtOvg5Z
        7iEEqlEw6MUfb6qe7q0AmBk4MYMjT4fHF9lFdtOJUh92ScVj2MbYTXe8t+QmQg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=83qDvGuLXzUs/9fusW5YkDt4paS3sBnoEIk7Nou3kd0=;
        b=VP4vqOvBpurOsdqBLfFebJsD1S6lOmeXln+fiJ3timSPl/o5O/7c6kKdrszLlbgNceW6o4
        F9IPNZN2VRbcQUDg==
Date:   Sun, 27 Sep 2020 21:48:56 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
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
Subject: [patch 10/35] net: intel: Remove in_interrupt() warnings
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

in_interrupt() is ill defined and does not provide what the name
suggests. The usage especially in driver code is deprecated and a tree wide
effort to clean up and consolidate the (ab)usage of in_interrupt() and
related checks is happening.

In this case the checks cover only parts of the contexts in which these
functions cannot be called. They fail to detect preemption or interrupt
disabled invocations.

As the functions which are invoked from the various places contain already
a broad variety of checks (always enabled or debug option dependent) cover
all invalid conditions already, there is no point in having inconsistent
warnings in those drivers.

Just remove them.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org

---
 drivers/net/ethernet/intel/e1000/e1000_main.c     |    1 -
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c      |    2 --
 drivers/net/ethernet/intel/i40e/i40e_main.c       |    4 ----
 drivers/net/ethernet/intel/ice/ice_main.c         |    1 -
 drivers/net/ethernet/intel/igb/igb_main.c         |    1 -
 drivers/net/ethernet/intel/igc/igc_main.c         |    1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |    1 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    2 --
 8 files changed, 13 deletions(-)

--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -534,7 +534,6 @@ void e1000_down(struct e1000_adapter *ad
 
 void e1000_reinit_locked(struct e1000_adapter *adapter)
 {
-	WARN_ON(in_interrupt());
 	while (test_and_set_bit(__E1000_RESETTING, &adapter->flags))
 		msleep(1);
 
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -221,8 +221,6 @@ static bool fm10k_prepare_for_reset(stru
 {
 	struct net_device *netdev = interface->netdev;
 
-	WARN_ON(in_interrupt());
-
 	/* put off any impending NetWatchDogTimeout */
 	netif_trans_update(netdev);
 
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6689,7 +6689,6 @@ static void i40e_vsi_reinit_locked(struc
 {
 	struct i40e_pf *pf = vsi->back;
 
-	WARN_ON(in_interrupt());
 	while (test_and_set_bit(__I40E_CONFIG_BUSY, pf->state))
 		usleep_range(1000, 2000);
 	i40e_down(vsi);
@@ -8462,9 +8461,6 @@ void i40e_do_reset(struct i40e_pf *pf, u
 {
 	u32 val;
 
-	WARN_ON(in_interrupt());
-
-
 	/* do the biggest reset indicated */
 	if (reset_flags & BIT_ULL(__I40E_GLOBAL_RESET_REQUESTED)) {
 
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -486,7 +486,6 @@ static void ice_do_reset(struct ice_pf *
 	struct ice_hw *hw = &pf->hw;
 
 	dev_dbg(dev, "reset_type 0x%x requested\n", reset_type);
-	WARN_ON(in_interrupt());
 
 	ice_prepare_for_reset(pf);
 
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2220,7 +2220,6 @@ void igb_down(struct igb_adapter *adapte
 
 void igb_reinit_locked(struct igb_adapter *adapter)
 {
-	WARN_ON(in_interrupt());
 	while (test_and_set_bit(__IGB_RESETTING, &adapter->state))
 		usleep_range(1000, 2000);
 	igb_down(adapter);
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3831,7 +3831,6 @@ void igc_down(struct igc_adapter *adapte
 
 void igc_reinit_locked(struct igc_adapter *adapter)
 {
-	WARN_ON(in_interrupt());
 	while (test_and_set_bit(__IGC_RESETTING, &adapter->state))
 		usleep_range(1000, 2000);
 	igc_down(adapter);
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5677,7 +5677,6 @@ static void ixgbe_up_complete(struct ixg
 
 void ixgbe_reinit_locked(struct ixgbe_adapter *adapter)
 {
-	WARN_ON(in_interrupt());
 	/* put off any impending NetWatchDogTimeout */
 	netif_trans_update(adapter->netdev);
 
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2526,8 +2526,6 @@ void ixgbevf_down(struct ixgbevf_adapter
 
 void ixgbevf_reinit_locked(struct ixgbevf_adapter *adapter)
 {
-	WARN_ON(in_interrupt());
-
 	while (test_and_set_bit(__IXGBEVF_RESETTING, &adapter->state))
 		msleep(1);
 

