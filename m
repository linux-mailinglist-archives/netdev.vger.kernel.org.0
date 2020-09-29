Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA75A27D90E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbgI2Uko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:40:44 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48690 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbgI2Ufq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:35:46 -0400
Message-Id: <20200929203459.967800092@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=yPLMFV0AoKzVfjkZGD1cBol7ZHiDqQNGHcgytaaR7SU=;
        b=DGmRniuwLHzIUi4k/mQQVGbmHmlc5hKx7KI3F+Vt92K4HbV+4/N++j7KAiLrK0Aig5EI27
        OK4nc7WDsMiyTI4/TtPmO0qJWpgf23aOyvOwL6BP3SpKXbLdpDBkbXGes6GmQDAtisSw4+
        NR9MnI2PyeekW2W3WlcAcAqbaORHvTZ0ER5Zet/4TFYBCqr+vGzjXZ5fWdft3D9FxNtAR7
        n3LgKckRM18g7rRH5sLOSYPXk62LNNdGaL9Sze7y155ktki/zLKhk0pjW7usA8ejPxRQyh
        HKGpF2HD9KC7ZuQD0Oc5/IsUAXjLcIZSHxXBZ9Bb8ciVF2E9DukQYKImu4ZOyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=yPLMFV0AoKzVfjkZGD1cBol7ZHiDqQNGHcgytaaR7SU=;
        b=STkATloI5Xd/LYwyRA1wjacSEWk8sYNo/Fk8PiYrZnl0nulJcadbqh65bbryKovkMRPRbM
        i9eLFjLBfU9eplDQ==
Date:   Tue, 29 Sep 2020 22:25:14 +0200
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
Subject: [patch V2 05/36] net: atheros: Remove WARN_ON(in_interrupt())
References: <20200929202509.673358734@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

in_interrupt() is ill defined and does not provide what the name
suggests. The usage especially in driver code is deprecated and a tree wide
effort to clean up and consolidate the (ab)usage of in_interrupt() and
related checks is happening.

In this case the check covers only parts of the contexts in which these
functions cannot be called. It fails to detect preemption or interrupt
disabled invocations.

As the functions which are invoked from at*_reinit_locked() contain a broad
variety of checks (always enabled or debug option dependent) which cover
all invalid conditions already, there is no point in having inconsistent
warnings in those drivers.

Just remove them.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |    2 --
 drivers/net/ethernet/atheros/atlx/atl2.c        |    1 -
 3 files changed, 4 deletions(-)

--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -220,7 +220,6 @@ static void atl1c_phy_config(struct time
 
 void atl1c_reinit_locked(struct atl1c_adapter *adapter)
 {
-	WARN_ON(in_interrupt());
 	atl1c_down(adapter);
 	atl1c_up(adapter);
 	clear_bit(__AT_RESETTING, &adapter->flags);
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -127,8 +127,6 @@ static void atl1e_phy_config(struct time
 
 void atl1e_reinit_locked(struct atl1e_adapter *adapter)
 {
-
-	WARN_ON(in_interrupt());
 	while (test_and_set_bit(__AT_RESETTING, &adapter->flags))
 		msleep(1);
 	atl1e_down(adapter);
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -1086,7 +1086,6 @@ static int atl2_up(struct atl2_adapter *
 
 static void atl2_reinit_locked(struct atl2_adapter *adapter)
 {
-	WARN_ON(in_interrupt());
 	while (test_and_set_bit(__ATL2_RESETTING, &adapter->flags))
 		msleep(1);
 	atl2_down(adapter);

