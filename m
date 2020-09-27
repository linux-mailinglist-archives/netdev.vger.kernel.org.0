Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DC427A34E
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgI0T6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:58:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41624 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbgI0T6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:58:03 -0400
Message-Id: <20200927194922.938263514@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601236664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=+EKrA6HqGMF4faSCoLrAtx6KX3hw/q02kTTYVH77/+8=;
        b=DgFWCTRmyeEjV0+OEYDVbCkMlQbEJFzwD69vMLAlqAaimPSm5lMXaR3fbldN0wOl0BqeFc
        zQrD8mqr+OmCWZYyLm7RLr56R6Uisc43UcpkNxfH9uStf4GT/Q/fOOinHmuT8RHGl0jL6Z
        wUdLMut+XHwHPnR1ey1uae/dXTbri3XVyYTJ74NBWHyM13bI0ohdjaz6zEB+4yolDn+ZDF
        0VIc/HnK6kTk3f3URI1GJAzoEEojDjpAtLIW88F5cK7YtFr4+asZd929ZyG9pTudMogrbw
        7fLYoNxT5ATayz/0EYF6tk7HKCZLrxinEoIEgQOi3akiNU10TFB4xtu5xojEMQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601236664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=+EKrA6HqGMF4faSCoLrAtx6KX3hw/q02kTTYVH77/+8=;
        b=jsZYaXiRN4xRZ5BWns5HUuV12Wy5QkGKco5gufMggE6/zBZBdgkjf30s/8iphwg89FOg4S
        +jX7dKxRVl7/tZBw==
Date:   Sun, 27 Sep 2020 21:49:17 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Christian Benvenuti <benve@cisco.com>,
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
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [patch 31/35] net: libertas libertas_tf: Remove in_interrupt() from
 debug macro.
References: <20200927194846.045411263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The debug macro prints (INT) when in_interrupt() returns true. The value of
this information is dubious as it does not distinguish between the various
contexts which are covered by in_interrupt().

As the usage of in_interrupt() in drivers is phased out and the same
information can be more precisely obtained with tracing, remove the
in_interrupt() conditional from this debug printk.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org

---
 drivers/net/wireless/marvell/libertas/defs.h        |    3 +--
 drivers/net/wireless/marvell/libertas_tf/deb_defs.h |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/marvell/libertas/defs.h
+++ b/drivers/net/wireless/marvell/libertas/defs.h
@@ -50,8 +50,7 @@ extern unsigned int lbs_debug;
 #ifdef DEBUG
 #define LBS_DEB_LL(grp, grpnam, fmt, args...) \
 do { if ((lbs_debug & (grp)) == (grp)) \
-  printk(KERN_DEBUG DRV_NAME grpnam "%s: " fmt, \
-         in_interrupt() ? " (INT)" : "", ## args); } while (0)
+  printk(KERN_DEBUG DRV_NAME grpnam ": " fmt, ## args); } while (0)
 #else
 #define LBS_DEB_LL(grp, grpnam, fmt, args...) do {} while (0)
 #endif
--- a/drivers/net/wireless/marvell/libertas_tf/deb_defs.h
+++ b/drivers/net/wireless/marvell/libertas_tf/deb_defs.h
@@ -48,8 +48,7 @@ extern unsigned int lbtf_debug;
 #ifdef DEBUG
 #define LBTF_DEB_LL(grp, grpnam, fmt, args...) \
 do { if ((lbtf_debug & (grp)) == (grp)) \
-  printk(KERN_DEBUG DRV_NAME grpnam "%s: " fmt, \
-         in_interrupt() ? " (INT)" : "", ## args); } while (0)
+  printk(KERN_DEBUG DRV_NAME grpnam ": " fmt, ## args); } while (0)
 #else
 #define LBTF_DEB_LL(grp, grpnam, fmt, args...) do {} while (0)
 #endif

