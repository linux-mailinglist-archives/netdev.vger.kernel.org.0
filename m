Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7BC27D893
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbgI2UhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:37:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49816 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729599AbgI2UgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:36:25 -0400
Message-Id: <20200929203502.866542017@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=MEQ1GtTEDYE6uzouC25TNjb2rSwUvIGCg1MzGPoj41Q=;
        b=GWlSWozRBJXlwHUE9sBFZVKh/a1TjzBo9j5Ch6+K6H5hzizPCUtMsj6pJH9FWZDDPYtAfD
        QaZKXP3/Wt78dpl6OvIHsKKMVNLY7uJax2H5NEKnmzSuaoE2yBCenuEE/bC5s/Gw6dV5MY
        lC5tgN8spGaMz9dmHJ3y6jSWLWlmA5n2DZF+N1kqpdrG1JN35XCsMg0HC4XeyXRaJA83B0
        qtntGNasYaRRsfP3oyN2UYrtsJ8O8eIg37akNMgSOII/GCtvdssrjbN8uO7WpLAHEbTaPH
        o7sJGBzka32FoZoQ+Gt+j6kSMy6zAuaBas+w8z1Uzoc3KaMdGI9K/Joo6IoQuQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=MEQ1GtTEDYE6uzouC25TNjb2rSwUvIGCg1MzGPoj41Q=;
        b=1pgLVU9Dsa7bHr3auCOokv6XkLgmka1Ldkw0gc01ZS8+oJrBuNxzR/bvc8dpMuxGOSd+4O
        JqbIcjuUJrbbJvCw==
Date:   Tue, 29 Sep 2020 22:25:43 +0200
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
Subject: [patch V2 34/36] net: rtlwifi: Remove void* casts related to delayed work
References: <20200929202509.673358734@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

INIT_DELAYED_WORK() takes two arguments: A pointer to the delayed work and
a function reference for the callback.

The rtl code casts all function references to (void *) because the
callbacks in use are not matching the required function signature. That's
error prone and bad pratice.

Some of the callback functions are also global, but only used in a single
file.

Clean the mess up by:

  - Adding the proper arguments to the callback functions and using them in
    the container_of() constructs correctly which removes the hideous
    container_of_dwork_rtl() macro as well.

  - Removing the type cast at the initializers

  - Making the unnecessary global functions static

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c |   39 +++++++++++++---------------
 drivers/net/wireless/realtek/rtlwifi/base.h |    3 --
 drivers/net/wireless/realtek/rtlwifi/ps.c   |   19 ++++++-------
 drivers/net/wireless/realtek/rtlwifi/ps.h   |    6 ++--
 drivers/net/wireless/realtek/rtlwifi/wifi.h |    3 --
 5 files changed, 31 insertions(+), 39 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -436,6 +436,10 @@ static void _rtl_init_mac80211(struct ie
 	}
 }
 
+static void rtl_watchdog_wq_callback(struct work_struct *work);
+static void rtl_fwevt_wq_callback(struct work_struct *work);
+static void rtl_c2hcmd_wq_callback(struct work_struct *work);
+
 static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -454,17 +458,14 @@ static void _rtl_init_deferred_work(stru
 	}
 
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
-			  (void *)rtl_watchdog_wq_callback);
+			  rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
-			  (void *)rtl_ips_nic_off_wq_callback);
-	INIT_DELAYED_WORK(&rtlpriv->works.ps_work,
-			  (void *)rtl_swlps_wq_callback);
+			  rtl_ips_nic_off_wq_callback);
+	INIT_DELAYED_WORK(&rtlpriv->works.ps_work, rtl_swlps_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ps_rfon_wq,
-			  (void *)rtl_swlps_rfon_wq_callback);
-	INIT_DELAYED_WORK(&rtlpriv->works.fwevt_wq,
-			  (void *)rtl_fwevt_wq_callback);
-	INIT_DELAYED_WORK(&rtlpriv->works.c2hcmd_wq,
-			  (void *)rtl_c2hcmd_wq_callback);
+			  rtl_swlps_rfon_wq_callback);
+	INIT_DELAYED_WORK(&rtlpriv->works.fwevt_wq, rtl_fwevt_wq_callback);
+	INIT_DELAYED_WORK(&rtlpriv->works.c2hcmd_wq, rtl_c2hcmd_wq_callback);
 }
 
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw, bool ips_wq)
@@ -2042,11 +2043,10 @@ void rtl_collect_scan_list(struct ieee80
 }
 EXPORT_SYMBOL(rtl_collect_scan_list);
 
-void rtl_watchdog_wq_callback(void *data)
+static void rtl_watchdog_wq_callback(struct work_struct *work)
 {
-	struct rtl_works *rtlworks = container_of_dwork_rtl(data,
-							    struct rtl_works,
-							    watchdog_wq);
+	struct rtl_works *rtlworks = container_of(work, struct rtl_works,
+						  watchdog_wq.work);
 	struct ieee80211_hw *hw = rtlworks->hw;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -2239,10 +2239,10 @@ void rtl_watch_dog_timer_callback(struct
 		  jiffies + MSECS(RTL_WATCH_DOG_TIME));
 }
 
-void rtl_fwevt_wq_callback(void *data)
+static void rtl_fwevt_wq_callback(struct work_struct *work)
 {
-	struct rtl_works *rtlworks =
-		container_of_dwork_rtl(data, struct rtl_works, fwevt_wq);
+	struct rtl_works *rtlworks = container_of(work, struct rtl_works,
+						  fwevt_wq.work);
 	struct ieee80211_hw *hw = rtlworks->hw;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -2368,11 +2368,10 @@ void rtl_c2hcmd_launcher(struct ieee8021
 	}
 }
 
-void rtl_c2hcmd_wq_callback(void *data)
+static void rtl_c2hcmd_wq_callback(struct work_struct *work)
 {
-	struct rtl_works *rtlworks = container_of_dwork_rtl(data,
-							    struct rtl_works,
-							    c2hcmd_wq);
+	struct rtl_works *rtlworks = container_of(work, struct rtl_works,
+						  c2hcmd_wq.work);
 	struct ieee80211_hw *hw = rtlworks->hw;
 
 	rtl_c2hcmd_launcher(hw, 1);
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -108,9 +108,6 @@ int rtl_rx_agg_start(struct ieee80211_hw
 int rtl_rx_agg_stop(struct ieee80211_hw *hw,
 		    struct ieee80211_sta *sta, u16 tid);
 void rtl_rx_ampdu_apply(struct rtl_priv *rtlpriv);
-void rtl_watchdog_wq_callback(void *data);
-void rtl_fwevt_wq_callback(void *data);
-void rtl_c2hcmd_wq_callback(void *data);
 void rtl_c2hcmd_launcher(struct ieee80211_hw *hw, int exec);
 void rtl_c2hcmd_enqueue(struct ieee80211_hw *hw, struct sk_buff *skb);
 
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -179,10 +179,10 @@ static void _rtl_ps_inactive_ps(struct i
 	ppsc->swrf_processing = false;
 }
 
-void rtl_ips_nic_off_wq_callback(void *data)
+void rtl_ips_nic_off_wq_callback(struct work_struct *work)
 {
-	struct rtl_works *rtlworks =
-	    container_of_dwork_rtl(data, struct rtl_works, ips_nic_off_wq);
+	struct rtl_works *rtlworks = container_of(work, struct rtl_works,
+						  ips_nic_off_wq.work);
 	struct ieee80211_hw *hw = rtlworks->hw;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -562,10 +562,10 @@ void rtl_swlps_rf_awake(struct ieee80211
 	mutex_unlock(&rtlpriv->locks.lps_mutex);
 }
 
-void rtl_swlps_rfon_wq_callback(void *data)
+void rtl_swlps_rfon_wq_callback(struct work_struct *work)
 {
-	struct rtl_works *rtlworks =
-	    container_of_dwork_rtl(data, struct rtl_works, ps_rfon_wq);
+	struct rtl_works *rtlworks = container_of(work, struct rtl_works,
+						  ps_rfon_wq.work);
 	struct ieee80211_hw *hw = rtlworks->hw;
 
 	rtl_swlps_rf_awake(hw);
@@ -675,11 +675,10 @@ void rtl_lps_leave(struct ieee80211_hw *
 }
 EXPORT_SYMBOL_GPL(rtl_lps_leave);
 
-void rtl_swlps_wq_callback(void *data)
+void rtl_swlps_wq_callback(struct work_struct *work)
 {
-	struct rtl_works *rtlworks = container_of_dwork_rtl(data,
-				     struct rtl_works,
-				     ps_work);
+	struct rtl_works *rtlworks = container_of(work, struct rtl_works,
+						  ps_work.work);
 	struct ieee80211_hw *hw = rtlworks->hw;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	bool ps = false;
--- a/drivers/net/wireless/realtek/rtlwifi/ps.h
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.h
@@ -10,15 +10,15 @@ bool rtl_ps_enable_nic(struct ieee80211_
 bool rtl_ps_disable_nic(struct ieee80211_hw *hw);
 void rtl_ips_nic_off(struct ieee80211_hw *hw);
 void rtl_ips_nic_on(struct ieee80211_hw *hw);
-void rtl_ips_nic_off_wq_callback(void *data);
+void rtl_ips_nic_off_wq_callback(struct work_struct *work);
 void rtl_lps_enter(struct ieee80211_hw *hw);
 void rtl_lps_leave(struct ieee80211_hw *hw);
 
 void rtl_lps_set_psmode(struct ieee80211_hw *hw, u8 rt_psmode);
 
 void rtl_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len);
-void rtl_swlps_wq_callback(void *data);
-void rtl_swlps_rfon_wq_callback(void *data);
+void rtl_swlps_wq_callback(struct work_struct *work);
+void rtl_swlps_rfon_wq_callback(struct work_struct *work);
 void rtl_swlps_rf_awake(struct ieee80211_hw *hw);
 void rtl_swlps_rf_sleep(struct ieee80211_hw *hw);
 void rtl_p2p_ps_cmd(struct ieee80211_hw *hw , u8 p2p_ps_state);
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2936,9 +2936,6 @@ enum bt_radio_shared {
 #define	RT_SET_PS_LEVEL(ppsc, _ps_flg)		\
 	(ppsc->cur_ps_level |= _ps_flg)
 
-#define container_of_dwork_rtl(x, y, z) \
-	container_of(to_delayed_work(x), y, z)
-
 #define FILL_OCTET_STRING(_os, _octet, _len)	\
 		(_os).octet = (u8 *)(_octet);		\
 		(_os).length = (_len);


