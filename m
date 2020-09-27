Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D46527A35C
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgI0T6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:58:52 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41464 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbgI0T6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:58:03 -0400
Message-Id: <20200927194923.249291290@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=vdFvMNzU/x4SViOrfq3OSncwJYM+GQFlzT+TSG/Jurw=;
        b=d1rdgmwnvlZUOMpyU4UwQtQF5yM+v2oLv1PhrnAnkHxJQzIDZgi08y5xJkIOTSE/HAzJEH
        m73NHuf5Y89Z2k6h38GqvMhbSuHXcsYWEhQFMlCubYP/tF8Jn7+x0BWkiqvq84BZz2au5+
        jeOQRZ+SbMvIfd0bYm/vRXEfCj8GFf9rdkD2NTEk9issoJjNBodZCfdyRGpCwXRDJ4t3Vj
        NFI1CZVkn2YaxWM0AceskQU+v5Y6CKEVl7I9HSw0GC9gTC+iEMk2EuYdRrcFbkjWF/toyh
        50r7CaIT6BWY13Wv5j7G+heQ0084VyqmX0HOzN5sSyE1/j5ABUNMQkw1MxEM2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=vdFvMNzU/x4SViOrfq3OSncwJYM+GQFlzT+TSG/Jurw=;
        b=+Iasu9O3lwwW7SROFddv+F7Dm0tiCLGVcfnBPStOmcOCHkGfZ9zKVkGE4wbbUA3CekIMz/
        b5ri9EnSdYCQtJBQ==
Date:   Sun, 27 Sep 2020 21:49:20 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
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
        Pascal Terjan <pterjan@google.com>
Subject: [patch 34/35] net: rtlwifi: Remove in_interrupt() from debug macro
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The usage of in_interrupt() in drivers in is phased out.

rtlwifi uses in_interrupt() in the RT_TRACE() debug macro which is
sprinkled all over the driver. RT_TRACE() is almost identical to RTPRINT()
which another hideous debug printk wrapper. The only difference is the
printout of in_interrupt().

The decoding of in_interrupt() as hexvalue is non-trivial and aside of
being phased out for driver use the return value is just by chance the
masked preempt count value and not a boolean.

These home brewn printk debug aids are tedious to work with and provide
only minimal context.  They should be replaced by trace_printk() or a debug
tracepoint which automatically records all context information.

To make progress on the in_interrupt() cleanup, make RT_TRACE() use the
RTPRINT() debug function and remove _rtl_dbg_trace().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org

---
 drivers/net/wireless/realtek/rtlwifi/debug.c |   20 --------------------
 drivers/net/wireless/realtek/rtlwifi/debug.h |    6 +-----
 2 files changed, 1 insertion(+), 25 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -8,26 +8,6 @@
 #include <linux/vmalloc.h>
 
 #ifdef CONFIG_RTLWIFI_DEBUG
-void _rtl_dbg_trace(struct rtl_priv *rtlpriv, u64 comp, int level,
-		    const char *fmt, ...)
-{
-	if (unlikely((comp & rtlpriv->cfg->mod_params->debug_mask) &&
-		     level <= rtlpriv->cfg->mod_params->debug_level)) {
-		struct va_format vaf;
-		va_list args;
-
-		va_start(args, fmt);
-
-		vaf.fmt = fmt;
-		vaf.va = &args;
-
-		pr_info(":<%lx> %pV", in_interrupt(), &vaf);
-
-		va_end(args);
-	}
-}
-EXPORT_SYMBOL_GPL(_rtl_dbg_trace);
-
 void _rtl_dbg_print(struct rtl_priv *rtlpriv, u64 comp, int level,
 		    const char *fmt, ...)
 {
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -149,10 +149,6 @@ enum dbgp_flag_e {
 struct rtl_priv;
 
 __printf(4, 5)
-void _rtl_dbg_trace(struct rtl_priv *rtlpriv, u64 comp, int level,
-		    const char *fmt, ...);
-
-__printf(4, 5)
 void _rtl_dbg_print(struct rtl_priv *rtlpriv, u64 comp, int level,
 		    const char *fmt, ...);
 
@@ -161,7 +157,7 @@ void _rtl_dbg_print_data(struct rtl_priv
 			 const void *hexdata, int hexdatalen);
 
 #define RT_TRACE(rtlpriv, comp, level, fmt, ...)			\
-	_rtl_dbg_trace(rtlpriv, comp, level,				\
+	_rtl_dbg_print(rtlpriv, comp, level,				\
 		       fmt, ##__VA_ARGS__)
 
 #define RTPRINT(rtlpriv, dbgtype, dbgflag, fmt, ...)			\

