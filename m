Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53EC246209
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgHQJIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbgHQJIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:08:50 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6B5C061389;
        Mon, 17 Aug 2020 02:08:50 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 74so7897531pfx.13;
        Mon, 17 Aug 2020 02:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hi8UwSz1wvc04MfWa1AVLiltWt+NmpLjYtHAPIkiHbo=;
        b=GgJ9bCncToKOJJAOqST/Rip4jlKoQg8ZFzbBeIceTQZM24xi1Hv4QGOY2W9yiNxwZV
         4ZhGmoMkKM7qEhrUN90CO1nmAofg2V2OrvhwiPTpcdexnbSFs760dwRSDePEaxg2IUrP
         kDFIfdIORoiDjcqG9wdx5aYwNO1U3mSR2U37Elxm6dw5J6pCiS+bfSHqgXj/e24C+Xh4
         GfBhLtSD71RAEcFdjOojMFb7cohbSJRp/6s420UCbHew+xUU3DradT2R8NQXvv0WvcKu
         3gJ950Hw8HEUtvFIIJ5M6Y4P/4/bmYdWN/RYSVGgmv+SWr7cV+9NTDFH7itXWF1mEWwF
         Uk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hi8UwSz1wvc04MfWa1AVLiltWt+NmpLjYtHAPIkiHbo=;
        b=PpP5MNdvka6sb9hXfSU6kcU5SW7aoG4ItD2E6wzXSFk58nD0s5e5HyzO2YijtJRVbe
         MisvG2yZjoGS6qfo1BorgVs4KWv3RymE+VFwoFHUZgvKdC66H/v4lxwuGnA6uXFR/9Uo
         QIF8SNWRo42ED3ZZwzfAIl4ZjUO+l6OqBW54YIQ3ib0NM7re/C/YXZiSCOfYnDoeMcXC
         DmHFS6Ae9RsYeZCk3RuVv6HeakCj1ZSLfmkS1vdQrgrfVgHevuEAlTHvMvyRMbSqo9h2
         93Y8J52+IbYsoL1EhxBm3F3XbKflUK/iexREjFHceaJR7v2N1oo70B7Nx76EpJ4KsW47
         SsHQ==
X-Gm-Message-State: AOAM530W7tiFdqZMcBJ2eGucIU4PDjJDCzgzydQdNw4t8BjVj/WZEnzf
        x3mI5yZRRWwsQFfBHax8Kfk=
X-Google-Smtp-Source: ABdhPJxD2B2fbUCPy+Yz5NAKVRQCHvkUTJnZ3GAz/jLUKXaX/wW7GXbbWNHRkHrMw5FcInOnT3YhvQ==
X-Received: by 2002:a63:4c1:: with SMTP id 184mr2275088pge.35.1597655329533;
        Mon, 17 Aug 2020 02:08:49 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:08:49 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     kvalo@codeaurora.org, kuba@kernel.org, jirislaby@kernel.org,
        mickflemm@gmail.com, mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de
Cc:     keescook@chromium.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 15/16] wireless: realtek: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:36 +0530
Message-Id: <20200817090637.26887-16-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817090637.26887-1-allen.cryptic@gmail.com>
References: <20200817090637.26887-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly
and remove .data field.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 21 ++++++++++-----------
 drivers/net/wireless/realtek/rtlwifi/usb.c |  9 ++++-----
 drivers/net/wireless/realtek/rtw88/main.c  |  3 +--
 drivers/net/wireless/realtek/rtw88/tx.c    |  4 ++--
 drivers/net/wireless/realtek/rtw88/tx.h    |  2 +-
 5 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 25335bd2873b..42099369fa35 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1061,16 +1061,18 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
-static void _rtl_pci_irq_tasklet(unsigned long data)
+static void _rtl_pci_irq_tasklet(struct tasklet_struct *t)
 {
-	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
+	struct rtl_priv *rtlpriv = from_tasklet(rtlpriv, t, works.irq_tasklet);
+	struct ieee80211_hw *hw = rtlpriv->hw;
 	_rtl_pci_tx_chk_waitq(hw);
 }
 
-static void _rtl_pci_prepare_bcn_tasklet(unsigned long data)
+static void _rtl_pci_prepare_bcn_tasklet(struct tasklet_struct *t)
 {
-	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_priv *rtlpriv = from_tasklet(rtlpriv, t,
+						works.irq_prepare_bcn_tasklet);
+	struct ieee80211_hw *hw = rtlpriv->hw;
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl8192_tx_ring *ring = NULL;
@@ -1194,12 +1196,9 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	rtlpci->acm_method = EACMWAY2_SW;
 
 	/*task */
-	tasklet_init(&rtlpriv->works.irq_tasklet,
-		     _rtl_pci_irq_tasklet,
-		     (unsigned long)hw);
-	tasklet_init(&rtlpriv->works.irq_prepare_bcn_tasklet,
-		     _rtl_pci_prepare_bcn_tasklet,
-		     (unsigned long)hw);
+	tasklet_setup(&rtlpriv->works.irq_tasklet, _rtl_pci_irq_tasklet);
+	tasklet_setup(&rtlpriv->works.irq_prepare_bcn_tasklet,
+		     _rtl_pci_prepare_bcn_tasklet);
 	INIT_WORK(&rtlpriv->works.lps_change_work,
 		  rtl_lps_change_work_callback);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index d05e709536ea..8740818e8d87 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -289,7 +289,7 @@ static int _rtl_usb_init_tx(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static void _rtl_rx_work(unsigned long param);
+static void _rtl_rx_work(struct tasklet_struct *t);
 
 static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 {
@@ -310,8 +310,7 @@ static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 	init_usb_anchor(&rtlusb->rx_cleanup_urbs);
 
 	skb_queue_head_init(&rtlusb->rx_queue);
-	rtlusb->rx_work_tasklet.func = _rtl_rx_work;
-	rtlusb->rx_work_tasklet.data = (unsigned long)rtlusb;
+	rtlusb->rx_work_tasklet.func = (void(*)(unsigned long))_rtl_rx_work;
 
 	return 0;
 }
@@ -528,9 +527,9 @@ static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 #define __RX_SKB_MAX_QUEUED	64
 
-static void _rtl_rx_work(unsigned long param)
+static void _rtl_rx_work(struct tasklet_struct *t)
 {
-	struct rtl_usb *rtlusb = (struct rtl_usb *)param;
+	struct rtl_usb *rtlusb = from_tasklet(rtlusb, t, rx_work_tasklet);
 	struct ieee80211_hw *hw = usb_get_intfdata(rtlusb->intf);
 	struct sk_buff *skb;
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 54044abf30d7..6719c687a322 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1422,8 +1422,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 
 	timer_setup(&rtwdev->tx_report.purge_timer,
 		    rtw_tx_report_purge_timer, 0);
-	tasklet_init(&rtwdev->tx_tasklet, rtw_tx_tasklet,
-		     (unsigned long)rtwdev);
+	tasklet_setup(&rtwdev->tx_tasklet, rtw_tx_tasklet);
 
 	INIT_DELAYED_WORK(&rtwdev->watch_dog_work, rtw_watch_dog_work);
 	INIT_DELAYED_WORK(&coex->bt_relink_work, rtw_coex_bt_relink_work);
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 7fcc992b01a8..ca8072177ae3 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -587,9 +587,9 @@ static void rtw_txq_push(struct rtw_dev *rtwdev,
 	rcu_read_unlock();
 }
 
-void rtw_tx_tasklet(unsigned long data)
+void rtw_tx_tasklet(struct tasklet_struct *t)
 {
-	struct rtw_dev *rtwdev = (void *)data;
+	struct rtw_dev *rtwdev = from_tasklet(rtwdev, t, tx_tasklet);
 	struct rtw_txq *rtwtxq, *tmp;
 
 	spin_lock_bh(&rtwdev->txq_lock);
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index cfe84eef5923..6673dbcaa21c 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -94,7 +94,7 @@ void rtw_tx(struct rtw_dev *rtwdev,
 	    struct sk_buff *skb);
 void rtw_txq_init(struct rtw_dev *rtwdev, struct ieee80211_txq *txq);
 void rtw_txq_cleanup(struct rtw_dev *rtwdev, struct ieee80211_txq *txq);
-void rtw_tx_tasklet(unsigned long data);
+void rtw_tx_tasklet(struct tasklet_struct *t);
 void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
 			    struct rtw_tx_pkt_info *pkt_info,
 			    struct ieee80211_sta *sta,
-- 
2.17.1

