Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615C427D865
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgI2UgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbgI2Uf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:35:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60043C061755;
        Tue, 29 Sep 2020 13:35:56 -0700 (PDT)
Message-Id: <20200929203500.772444384@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=ZU7NcQAsE/kj7cmUnOD5K9JFij/BoI0exU4lajDmnJ4=;
        b=vRU6BfuHOIAfBrVtu4hT7bOoSqNXK0UJcuUCnpmMR01XxLkNiw61gZAphCtJXKCWE5K1i7
        IJgQN52kyuidE9vQgzXypCAyr/TpToMGyk9vkHe+DlbJNfFGZSYs/NGwJ9D2ONoM2IU5Zw
        e+7S0mXG+Q1pyH7obsScTtFz8BiaioaXHn5oAupcsRCsLuGD/BLOGoblxRQGDEX1Q8ApS0
        CQbP4O88pIhIbkxZySum376e0s3/17XKI+Gu6XgErrMSBBy1fyp3qCjBpD48xFUOUtKKBQ
        W2NNaEKkJgaL98SY7jwux0HGwK9aR2mFw5NIEs+9NYNIBpgTWAtGu7VZYGiZcw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=ZU7NcQAsE/kj7cmUnOD5K9JFij/BoI0exU4lajDmnJ4=;
        b=LEfYKg1xG9lkdKgkKbBAn3aXuZsx2d/HLM7tuC+OD/dzExOSuTCCuQ+uxV82IUN/TWajPk
        Ybp+2Mpr+f/6D4Bg==
Date:   Tue, 29 Sep 2020 22:25:22 +0200
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
Subject: [patch V2 13/36] net: mdiobus: Remove WARN_ON_ONCE(in_interrupt())
References: <20200929202509.673358734@linutronix.de>
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

In this case the check covers only parts of the contexts in which these
functions cannot be called. It fails to detect preemption or interrupt
disabled invocations.

As the functions which contain these warnings invoke mutex_lock() which
contains a broad variety of checks (always enabled or debug option
dependent) and therefore covers all invalid conditions already, there is no
point in having inconsistent warnings in those drivers. The conditional
return is not really valuable in practice either.

Just remove them.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>


---
 drivers/net/phy/mdio_bus.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -825,9 +825,6 @@ int mdiobus_read_nested(struct mii_bus *
 {
 	int retval;
 
-	if (WARN_ON_ONCE(in_interrupt()))
-		return -EINVAL;
-
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 	retval = __mdiobus_read(bus, addr, regnum);
 	mutex_unlock(&bus->mdio_lock);
@@ -850,9 +847,6 @@ int mdiobus_read(struct mii_bus *bus, in
 {
 	int retval;
 
-	if (WARN_ON_ONCE(in_interrupt()))
-		return -EINVAL;
-
 	mutex_lock(&bus->mdio_lock);
 	retval = __mdiobus_read(bus, addr, regnum);
 	mutex_unlock(&bus->mdio_lock);
@@ -879,9 +873,6 @@ int mdiobus_write_nested(struct mii_bus
 {
 	int err;
 
-	if (WARN_ON_ONCE(in_interrupt()))
-		return -EINVAL;
-
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 	err = __mdiobus_write(bus, addr, regnum, val);
 	mutex_unlock(&bus->mdio_lock);
@@ -905,9 +896,6 @@ int mdiobus_write(struct mii_bus *bus, i
 {
 	int err;
 
-	if (WARN_ON_ONCE(in_interrupt()))
-		return -EINVAL;
-
 	mutex_lock(&bus->mdio_lock);
 	err = __mdiobus_write(bus, addr, regnum, val);
 	mutex_unlock(&bus->mdio_lock);
@@ -929,9 +917,6 @@ int mdiobus_modify(struct mii_bus *bus,
 {
 	int err;
 
-	if (WARN_ON_ONCE(in_interrupt()))
-		return -EINVAL;
-
 	mutex_lock(&bus->mdio_lock);
 	err = __mdiobus_modify_changed(bus, addr, regnum, mask, set);
 	mutex_unlock(&bus->mdio_lock);


