Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766E110A3AE
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 18:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfKZR4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 12:56:16 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45861 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbfKZR4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 12:56:13 -0500
Received: by mail-pg1-f193.google.com with SMTP id k1so9343276pgg.12;
        Tue, 26 Nov 2019 09:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XX2U608hnsjlr3CObVhxW7h8IxFeUeweX4fxE0/OsVM=;
        b=Hiy7sKkZVG3/9CDo5Cxv9GJFo4F7t8yzz68tEQSopnvhTTDI1JRvwlk4+qu5x9oTKd
         8D1Q484BdK43q+9RpNoHOLX+C/64hUqCzy3J3LZpjWRsnu359AFLeAJzS/aRE7bNA95O
         5TG1K3XHRmB/uJUTN2n0gJyuIkRoHAj9bFKNlH3maSjSSwKjCvrxkchL8unJmQ/R+RTZ
         rO+/FsXecJvDD33dmyVT4B8cGEtswDDNNr8LgN+hgQN27YLRZmdpd8bSxIZQ87Z0lYcd
         nEmxUenHk77pF72gvpj0XbJP1k5UIP+cbHWQzQlFe8nsy6sj4hPTAwjN2b7+bxOEKXpE
         MMIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XX2U608hnsjlr3CObVhxW7h8IxFeUeweX4fxE0/OsVM=;
        b=IIPZCWdUlc7YbZMoNfOtSdC8Acuc7mrnMOepNojgYk7LoDjRYqTk0QZoBh9NRIJPAJ
         mIOIff9uJy5jHW8alHfw8tnMmJIVkWXBhgjUlVTEb3b8jDb2TvgumSNNcizWydlEu8q1
         la4h1Ln5lnuFLiFAm6DvzG79EeXkNUSKq43dF6lnf847pqzDPB0QlT2hllOytaeVkBOg
         y2dtthhT3dHoqiARFyInsaVdmgKdLA8TDj+dMBZOt2IqQofhT+XUglm5oiv4bDMUmgXW
         9msi5I7eW/zNb5tT5rTQadLmnyCCib8nY5Zme+PPc3Hi+5KuRF20cZGdB00glFzVnS5Y
         cYww==
X-Gm-Message-State: APjAAAXL6s+zfvaAR3pYB5rglLWgneYIYTwXHup4uifTnEv9zbNtmhXp
        vZzhRx0AgJsiBAe6eh0ck4o6g/qsWxs=
X-Google-Smtp-Source: APXvYqwoRVvWyIjrQtvMM/Zeg7rUjcKSI9l9DZUN/LtZip4JAqCwXeGSz6ftfryrGBh/LmF65zYm+A==
X-Received: by 2002:a63:a34b:: with SMTP id v11mr18766550pgn.229.1574790972466;
        Tue, 26 Nov 2019 09:56:12 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:2f79:ce3b:4b9:a68f:959f])
        by smtp.gmail.com with ESMTPSA id q6sm781577pfl.140.2019.11.26.09.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 09:56:11 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     Larry.Finger@lwfinger.net, jakub.kicinski@netronome.com,
        kvalo@codeaurora.org
Cc:     tranmanphong@gmail.com, Wright.Feng@cypress.com,
        arend.vanspriel@broadcom.com, davem@davemloft.net,
        emmanuel.grumbach@intel.com, franky.lin@broadcom.com,
        johannes.berg@intel.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, netdev@vger.kernel.org,
        p.figiel@camlintechnologies.com,
        pieter-paul.giesberts@broadcom.com, pkshih@realtek.com,
        rafal@milecki.pl, sara.sharon@intel.com,
        shahar.s.matityahu@intel.com, yhchuang@realtek.com,
        yuehaibing@huawei.com
Subject: [Patch v2 4/4] rtlwifi: rtl_pci: Fix -Wcast-function-type
Date:   Wed, 27 Nov 2019 00:55:29 +0700
Message-Id: <20191126175529.10909-5-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191126175529.10909-1-tranmanphong@gmail.com>
References: <20191125150215.29263-1-tranmanphong@gmail.com>
 <20191126175529.10909-1-tranmanphong@gmail.com>
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

