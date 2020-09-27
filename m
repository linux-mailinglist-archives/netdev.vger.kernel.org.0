Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAD427A34A
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgI0T6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:58:22 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41944 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgI0T6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:58:03 -0400
Message-Id: <20200927194922.536621749@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=daDzhx3DvG51sTf56IB3yW6+rlEuvlygn45KtLExpjQ=;
        b=VDYdrR3D7XjRpQdJxPO/TxGAWgfhd1RQ4YxZh3nEP39AiPjDDUfpg2sG9x07pOXHmWWrJ0
        +aHCKBA2Zp00GLghYfZHTOEu2eKzaq76OX8KV8VWxYajhojrwnohq9Hg1WaHhQy+gAgZqN
        HUhDdkUCchbKQKuhjj16d7aFoOkNs2eNyLz1PFjFoZEeip9z6AU06bV8vl2GrDROb2nzWW
        UU+rM8Y5XR6G2CnQ/TXBuDnScIVZG8ysLD6H2wZ3k/OUoEZSirqZd3r+OvkkQATgf7CM4F
        kF12yrb/thtllRj+oGQFnAYUkj+DTnB3Y2SPJ0DYrBQ7MhbkJDWMBd/CQExPig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=daDzhx3DvG51sTf56IB3yW6+rlEuvlygn45KtLExpjQ=;
        b=iLxGQIzE9QQNx58eXUsrAU0S724ow2imBqdAogU5f13GH9anLJFn4KOcXC0gX4kViOxyXb
        GDpQ8t6ZtZPd4CCQ==
Date:   Sun, 27 Sep 2020 21:49:13 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
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
        Ulrich Kunitz <kune@deine-taler.de>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [patch 27/35] net: ipw2x00,iwlegacy,iwlwifi: Remove in_interrupt()
 from debug macros
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The usage of in_interrupt() in non-core code is phased out.

The debugging macros in these drivers use in_interrupt() to print 'I' or
'U' depending on the return value of in_interrupt(). While 'U' is confusing
at best and 'I' is not really describing the actual context (hard interupt,
soft interrupt, bottom half disabled section) these debug macros originate
from the pre ftrace kernel era and their value today is questionable. They
probably should be removed completely.

The macros weere added initially for ipw2100 and then spreaded when the
driver was forked.

Remove the in_interrupt() usage at least..

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>

---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c   |    3 +--
 drivers/net/wireless/intel/ipw2x00/ipw2200.h   |    6 ++----
 drivers/net/wireless/intel/ipw2x00/libipw.h    |    3 +--
 drivers/net/wireless/intel/iwlegacy/common.h   |    4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c |    3 +--
 5 files changed, 7 insertions(+), 12 deletions(-)

--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -201,8 +201,7 @@ static u32 ipw2100_debug_level = IPW_DL_
 #define IPW_DEBUG(level, message...) \
 do { \
 	if (ipw2100_debug_level & (level)) { \
-		printk(KERN_DEBUG "ipw2100: %c %s ", \
-                       in_interrupt() ? 'I' : 'U',  __func__); \
+		printk(KERN_DEBUG "ipw2100: %s ", __func__); \
 		printk(message); \
 	} \
 } while (0)
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
@@ -1382,14 +1382,12 @@ BIT_ARG16(x)
 
 #define IPW_DEBUG(level, fmt, args...) \
 do { if (ipw_debug_level & (level)) \
-  printk(KERN_DEBUG DRV_NAME": %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
+  printk(KERN_DEBUG DRV_NAME": %s " fmt, __func__ , ## args); } while (0)
 
 #ifdef CONFIG_IPW2200_DEBUG
 #define IPW_LL_DEBUG(level, fmt, args...) \
 do { if (ipw_debug_level & (level)) \
-  printk(KERN_DEBUG DRV_NAME": %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
+  printk(KERN_DEBUG DRV_NAME": %s " fmt, __func__ , ## args); } while (0)
 #else
 #define IPW_LL_DEBUG(level, fmt, args...) do {} while (0)
 #endif				/* CONFIG_IPW2200_DEBUG */
--- a/drivers/net/wireless/intel/ipw2x00/libipw.h
+++ b/drivers/net/wireless/intel/ipw2x00/libipw.h
@@ -60,8 +60,7 @@
 extern u32 libipw_debug_level;
 #define LIBIPW_DEBUG(level, fmt, args...) \
 do { if (libipw_debug_level & (level)) \
-  printk(KERN_DEBUG "libipw: %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
+  printk(KERN_DEBUG "libipw: %s " fmt, __func__ , ## args); } while (0)
 #else
 #define LIBIPW_DEBUG(level, fmt, args...) do {} while (0)
 #endif				/* CONFIG_LIBIPW_DEBUG */
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -2925,8 +2925,8 @@ do {									\
 #define IL_DBG(level, fmt, args...)					\
 do {									\
 	if (il_get_debug_level(il) & level)				\
-		dev_err(&il->hw->wiphy->dev, "%c %s " fmt,		\
-			in_interrupt() ? 'I' : 'U', __func__ , ##args); \
+		dev_err(&il->hw->wiphy->dev, "%s " fmt, __func__,	\
+			 ##args);					\
 } while (0)
 
 #define il_print_hex_dump(il, level, p, len)				\
--- a/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
@@ -121,8 +121,7 @@ void __iwl_dbg(struct device *dev,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_have_debug_level(level) &&
 	    (!limit || net_ratelimit()))
-		dev_printk(KERN_DEBUG, dev, "%c %s %pV",
-			   in_interrupt() ? 'I' : 'U', function, &vaf);
+		dev_printk(KERN_DEBUG, dev, "%s %pV", function, &vaf);
 #endif
 	trace_iwlwifi_dbg(level, in_interrupt(), function, &vaf);
 	va_end(args);

