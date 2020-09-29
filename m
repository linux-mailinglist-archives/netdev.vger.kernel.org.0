Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC8527D898
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbgI2Uhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbgI2UgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:23 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FD1C0613DC;
        Tue, 29 Sep 2020 13:36:17 -0700 (PDT)
Message-Id: <20200929203502.385024523@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=SqK4/L4V4YIpR+Cf9q8Rsc2k2CTTs6ylS8pwAbu3Yj0=;
        b=FAMEZpr0/xz2zWnRMbRiAFXGmbJoLy0tVsOnE09HVffmixLQ0JQERV3PmJGSJml7ArfdtF
        Qrj4k6OEsA07yjNKmIIdtwvO9hNm0lraWr4COJohqbN4VWOgkHjUEs6pXs9yuk53GlEVSJ
        A/auHDldwcEKy6qpNBk4xO1CsdICEla7jdmFRoqpjgOqp3t46Oy0gGGM82FXltWgedYUGD
        iEXh0yEUFNGefrj4qnlvTEprk6mel0ddoIOTS6SVdLObrbPfIdOP9yW8NF7suptKhahjgF
        awen4Yyt3Qp0zQLw3XTX/7EIu0J/QmtczQry1UeLLLnhqNZcaVWiliI1YQW71g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=SqK4/L4V4YIpR+Cf9q8Rsc2k2CTTs6ylS8pwAbu3Yj0=;
        b=XcVhZQenrAHTCOos0UAijJD17iujZX6ZURvEupVGG3ac+zSKjlTEYBCnenYA9RiyRRtEvZ
        A7wdkq3eLocfzSDg==
Date:   Tue, 29 Sep 2020 22:25:38 +0200
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
        Ping-Ke Shih <pkshih@realtek.com>, Luca Coelho <luca@coelho.fi>
Subject: [patch V2 29/36] net: iwlwifi: Remove in_interrupt() from tracing macro.
References: <20200929202509.673358734@linutronix.de>
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
Acked-by: Luca Coelho <luca@coelho.fi>
Acked-by: Kalle Valo <kvalo@codeaurora.org>

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


