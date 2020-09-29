Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9285127D8BA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgI2UiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:38:21 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50358 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729159AbgI2UgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:16 -0400
Message-Id: <20200929203502.290194412@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=7Y3JxN63Q/PAehxAHjlctr5zLB/0T1XlCp5sBBJ6ers=;
        b=oiKP0Xh0hgA+5zrGUYdekn9rQzAC4LdhldgalfF+GD+80VdiZXZKs0d75kx8FgkG4UHHVJ
        o3rqlCb4K9+JNHIsFIL5WLeFB7ty070G/8LtX60ximHuITgnlH9wpX7tsgz3tkwi44KWwb
        2HCpK0W6133MFuLdi0x3bknXOXCQKj4vV33vpVcw74G548uIlqDiVhr//B8e1Y70vEooRz
        FCokcITKwTHomIJfNuDvGD9UcFM++gfJyvxS7AqaLGGogozINtZ+NSuE0Yxm2n6PMhWcpI
        3xl50c76FhcB18vk4+R5AN/njwD4JesFpZCbRIwbexbhX5MIjp1gUXFbryQa9g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=7Y3JxN63Q/PAehxAHjlctr5zLB/0T1XlCp5sBBJ6ers=;
        b=Cv7GOQA6CjaeBoQZgaP2ugJNvaDW0z8PoRHJHLEmmHHtU9PIoDOnTj0hyjRawikbMf+aw1
        9TZvSn3S/yPlakBw==
Date:   Tue, 29 Sep 2020 22:25:37 +0200
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
Subject: [patch V2 28/36] net: ipw2x00,iwlegacy,iwlwifi: Remove in_interrupt()
 from debug macros
References: <20200929202509.673358734@linutronix.de>
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
Acked-by: Kalle Valo <kvalo@codeaurora.org>

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


