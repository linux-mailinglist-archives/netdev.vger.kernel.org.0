Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E02F27D878
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgI2Ugj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:36:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50286 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729591AbgI2UgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:25 -0400
Message-Id: <20200929203502.960332937@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=BzNYl/5Di+kyHWokGedFIzx/rP561B9MjZOC0kJ9vSg=;
        b=pIrJK/4QaWydDe1lhnPEEPW8lUPHEJNhW6tvZd6cuCiHXNtLNxly31CrpWbRWeA1Nqi4ev
        cHB3rU40dVT0tHBnGgPv/quj3XhHz3bg+yn7amm6pjqCquUOYhArLzM2Vv3ARQsAL6MdFB
        kEbsIIqhi+nm0tONUXFZ18PIdDHC5Y0/pmkzlXbEhyqpUo8Upq3KsTEXi/65zEMfBNYd7e
        lkYaULJsxmzQMCYn6PK6FXILSEf5BWP03FLdCEO9HUCeTtyLp4bsnja4XpMRcsxki/z2Ji
        68ELnBK6wMaaIqG6D6QKXvnjD0xRh2x/hAF83UKqhPWdVnkMtLhcm6Mg9ELhvw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=BzNYl/5Di+kyHWokGedFIzx/rP561B9MjZOC0kJ9vSg=;
        b=8qgu4ybn3DiYWS5CupcAxsENTbKhc+qvsJKQRLzHtLMXb63EA2V97Ykwydzc3ABFl2jstp
        E3mOFBY4PzuNPpCA==
Date:   Tue, 29 Sep 2020 22:25:44 +0200
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
Subject: [patch V2 35/36] net: rtlwifi: Remove in_interrupt() from debug macro
References: <20200929202509.673358734@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The usage of in_interrupt() in drivers in is phased out.

rtl_dbg() a printk based debug aid is using in_interrupt() in the
underlying C function _rtl_dbg_out() which is almost identical to
_rtl_dbg_print(). The only difference is the printout of in_interrupt().

The decoding of in_interrupt() as hexvalue is non-trivial and aside of
being phased out for driver usage the return value is just by chance the
masked preempt count value and not a boolean.

These home brewn printk debug aids are tedious to work with and provide
only minimal context.  They should be replaced by trace_printk() or a debug
tracepoint which automatically records all context information.

To make progress on the in_interrupt() cleanup, make rtl_dbg() use
_rtl_dbg_print() and remove _rtl_dbg_out().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
---
V2: Adopted to the new names of the same thing.
---
 drivers/net/wireless/realtek/rtlwifi/debug.c |   20 --------------------
 drivers/net/wireless/realtek/rtlwifi/debug.h |    8 ++------
 2 files changed, 2 insertions(+), 26 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -8,26 +8,6 @@
 #include <linux/vmalloc.h>
 
 #ifdef CONFIG_RTLWIFI_DEBUG
-void _rtl_dbg_out(struct rtl_priv *rtlpriv, u64 comp, int level,
-		  const char *fmt, ...)
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
-EXPORT_SYMBOL_GPL(_rtl_dbg_out);
-
 void _rtl_dbg_print(struct rtl_priv *rtlpriv, u64 comp, int level,
 		    const char *fmt, ...)
 {
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -149,10 +149,6 @@ enum dbgp_flag_e {
 struct rtl_priv;
 
 __printf(4, 5)
-void _rtl_dbg_out(struct rtl_priv *rtlpriv, u64 comp, int level,
-		  const char *fmt, ...);
-
-__printf(4, 5)
 void _rtl_dbg_print(struct rtl_priv *rtlpriv, u64 comp, int level,
 		    const char *fmt, ...);
 
@@ -160,8 +156,8 @@ void _rtl_dbg_print_data(struct rtl_priv
 			 const char *titlestring,
 			 const void *hexdata, int hexdatalen);
 
-#define rtl_dbg(rtlpriv, comp, level, fmt, ...)			\
-	_rtl_dbg_out(rtlpriv, comp, level,				\
+#define rtl_dbg(rtlpriv, comp, level, fmt, ...)				\
+	_rtl_dbg_print(rtlpriv, comp, level,				\
 		       fmt, ##__VA_ARGS__)
 
 #define RTPRINT(rtlpriv, dbgtype, dbgflag, fmt, ...)			\

