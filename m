Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A18927A36D
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgI0T7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:59:09 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41774 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbgI0T6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:58:04 -0400
Message-Id: <20200927194922.629869406@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=Ki3wNa4qUnOTSFl9Or2v+BVEDl4x1h8hIm3EJjTZXcE=;
        b=W7W1d/txuLVfTz5Gt3j5zZyALW2f3kMpwRn8gRNuPAB5eHtPCRrCzV9ZNJwpbPqEQ/eg6f
        sBq+WihGLhJmsoBS1K6HhiJMKOK8MlBal7/2OI7l/TaNg/m6FzeILzJSPiZ99295mvUyeA
        R+rWpDnz6AZzm5I4WiOfbPOO+0FwTUEQ2q7iR6PfwHqgzd2LYVaM/QYn4U5NtN3eZtcZwJ
        ub1+M3DpzM6UZ5A2BYzNi4eCZNGBuPyvBJc6bsAJDlJhQ0BTovLcOTwgDCKx3S3dI4Ljwx
        dSyTdrwmMUz/SBnqvB9seFFG23GywYmHdtFHwhzXcGpB9eX94MmoGFUGiht3tg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=Ki3wNa4qUnOTSFl9Or2v+BVEDl4x1h8hIm3EJjTZXcE=;
        b=+bW9sb+foCwyzKhCANixWcGu7F1F0w5JY3fi3c0uv8xHX4iTofneq9h/A3y3145b80cFZH
        3Z0xjOpEwIYXGwBA==
Date:   Sun, 27 Sep 2020 21:49:14 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
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
        Stanislaw Gruszka <stf_xl@wp.pl>, Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [patch 28/35] net: iwlwifi: Remove in_interrupt() from tracing macro.
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The usage of in_interrupt) in driver code is phased out.

The iwlwifi_dbg tracepoint records in_interrupt() seperately, but that's
superfluous because the trace header already records all kind of state and
context information like hardirq status, softirq status, preemption count
etc.

Aside of that the recording of in_interrupt() as boolean does not allow to
distinguish between the possible contexts (hard interrupt, soft interrupt,
bottom half disabled) while the trace header gives precise information.

Remove the duplicate information from the tracepoint and fixup the caller.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org

---
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
@@ -123,7 +123,7 @@ void __iwl_dbg(struct device *dev,
 	    (!limit || net_ratelimit()))
 		dev_printk(KERN_DEBUG, dev, "%s %pV", function, &vaf);
 #endif
-	trace_iwlwifi_dbg(level, in_interrupt(), function, &vaf);
+	trace_iwlwifi_dbg(level, function, &vaf);
 	va_end(args);
 }
 IWL_EXPORT_SYMBOL(__iwl_dbg);
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
@@ -54,18 +54,16 @@ DEFINE_EVENT(iwlwifi_msg_event, iwlwifi_
 );
 
 TRACE_EVENT(iwlwifi_dbg,
-	TP_PROTO(u32 level, bool in_interrupt, const char *function,
+	TP_PROTO(u32 level, const char *function,
 		 struct va_format *vaf),
-	TP_ARGS(level, in_interrupt, function, vaf),
+	TP_ARGS(level, function, vaf),
 	TP_STRUCT__entry(
 		__field(u32, level)
-		__field(u8, in_interrupt)
 		__string(function, function)
 		__dynamic_array(char, msg, MAX_MSG_LEN)
 	),
 	TP_fast_assign(
 		__entry->level = level;
-		__entry->in_interrupt = in_interrupt;
 		__assign_str(function, function);
 		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
 				       MAX_MSG_LEN, vaf->fmt,

