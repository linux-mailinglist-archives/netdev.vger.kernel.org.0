Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441A21082AF
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 10:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfKXJnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 04:43:39 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39590 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfKXJng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 04:43:36 -0500
Received: by mail-pf1-f194.google.com with SMTP id x28so5812608pfo.6;
        Sun, 24 Nov 2019 01:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XX2U608hnsjlr3CObVhxW7h8IxFeUeweX4fxE0/OsVM=;
        b=pbZ48E72WllRYYPjmsEdxnNoMrZOrFp+lMZ659AYkPhUHcQG7NnptIKEfSPw/85fX7
         PjjXBPMUITuRK4nP2ilp6htpV9nHZC/wit+IO0Y5vsaMapojwHq52HihlGe1BLJGse+7
         1vatoOIj4FkqjBLH2NVvZS6PMW39NuUmZEshfgZjzcqkUNWSSSstXbuPwEJ9XEqtFIXw
         pZNOFTrhShdekxUFT5HLUPn59pPcKAqcueuqUCKlVBHPqw7aj4ZFli0yNUf/SR0kdIz5
         6VrXrnpVC5GRwprCECb1eO84NdF7UlxZJ2ZdtoGs+12OEkLsC8EvjSuj+/+HVORMuoqH
         Pt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XX2U608hnsjlr3CObVhxW7h8IxFeUeweX4fxE0/OsVM=;
        b=JozxIBtQtHdjOGqWTBrIqRjZaEkwbnNB82YMunLX7hWHL0z1xAeDoytS7j5ce0XvNs
         lERmn4ikiPD/AaLeY8mm9f4xpD11ubISYj/MNFA2eYjA+/WXph+wJclmKxSYfQ/DOSuL
         Q9I3VFJ2ntOI9uNF4Qu4j7Gm9NmFul41jmz6msna2mUXkDERJnUnF8/MSEVtAiHePNzv
         in+lFobJZDJAgJMuBbaoA+7PhVpQGIdBmriFD0sGiUPxhHVCG5qmSzXU2YYs83A/NBWm
         MfWjvqlvPLEJAHebPeBJkr/MXtkd31klySmEYSXakKIP0dMwlc6QQaO2WSfO8g0nhtOW
         d5hA==
X-Gm-Message-State: APjAAAWgv9QN940FsFZ9Wuz3dwWReAt7MpcWgJTUJoB4yosXFA/bnswc
        qJ4+BP0oVlGhV82fM6ZHkN4=
X-Google-Smtp-Source: APXvYqyDkLTF+5q1E0Qo6xZzpBxvOTU8cN84a55BpTsA4KJ4YdvSOZHeWg9UbeXT+Vj4T5foApOVlw==
X-Received: by 2002:aa7:8207:: with SMTP id k7mr29000021pfi.130.1574588615992;
        Sun, 24 Nov 2019 01:43:35 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:550c:6dad:1b5f:afc6:7758])
        by smtp.gmail.com with ESMTPSA id c3sm4091213pfi.91.2019.11.24.01.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 01:43:35 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net, keescook@chromium.org
Cc:     kvalo@codeaurora.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, luciano.coelho@intel.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 5/5] drivers: net: realtek: Fix -Wcast-function-type
Date:   Sun, 24 Nov 2019 16:43:06 +0700
Message-Id: <20191124094306.21297-6-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191124094306.21297-1-tranmanphong@gmail.com>
References: <20191124094306.21297-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index f88d26535978..25335bd2873b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1061,13 +1061,15 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
-static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
+static void _rtl_pci_irq_tasklet(unsigned long data)
 {
+	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
 	_rtl_pci_tx_chk_waitq(hw);
 }
 
-static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
+static void _rtl_pci_prepare_bcn_tasklet(unsigned long data)
 {
+	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -1193,10 +1195,10 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 
 	/*task */
 	tasklet_init(&rtlpriv->works.irq_tasklet,
-		     (void (*)(unsigned long))_rtl_pci_irq_tasklet,
+		     _rtl_pci_irq_tasklet,
 		     (unsigned long)hw);
 	tasklet_init(&rtlpriv->works.irq_prepare_bcn_tasklet,
-		     (void (*)(unsigned long))_rtl_pci_prepare_bcn_tasklet,
+		     _rtl_pci_prepare_bcn_tasklet,
 		     (unsigned long)hw);
 	INIT_WORK(&rtlpriv->works.lps_change_work,
 		  rtl_lps_change_work_callback);
-- 
2.20.1

