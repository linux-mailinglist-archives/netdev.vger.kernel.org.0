Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA82510909F
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfKYPCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:02:43 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41409 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfKYPCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:02:42 -0500
Received: by mail-pf1-f194.google.com with SMTP id p26so7490284pfq.8;
        Mon, 25 Nov 2019 07:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XX2U608hnsjlr3CObVhxW7h8IxFeUeweX4fxE0/OsVM=;
        b=cB2EV1LTsKcc+xMfsZ/9lZItciPyRYwhdKwF4OJ34eh9MadXxnnjTCXk39VUy16I1R
         PrwJSSFjkEkgkiIgaCfmK0oz5eHWszJShgBjmr+uI1TZGRCAp1v03cwx3a9+5BWc4rtI
         f1NsPeaj5URc59v1/9yxmIIku00flIlHZNA0bHzJWTCpIWNBqRP1y8xJLn1Wb+bh0zqM
         hOVIDgL8PCVfK/nJW6yMWMIVW3Go3Zg641fMzXLKaG0Yk6axTvf0f7YD5BINMExIKYML
         mG7CGT0I5vy3T2BLvKNKF9XDwBvGaDVJTlwlfd4MYqIQU/BsitFh/mm+2O4EXO768ws7
         G4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XX2U608hnsjlr3CObVhxW7h8IxFeUeweX4fxE0/OsVM=;
        b=Y562Lvd5xbg6/vXEQSRUe9yXjZh5A/XCo8rDimLQttLT+OKs8CW0Oo/HoJ4gVvLNyQ
         qL8rU07VnAPW7VXJF82rSOoxeukcoafdHmMDdmEygdEaOBhHaLpxf+fgLi1Hi5fUtKjG
         PBIhz/j5UNEIuWungVYvT/xUL7frVQigitkXhtjgIbgrcpKA3DlNSh8qic78ibmEKop6
         BcMaIpPTsIXCskvgkhZarAn3FP3oJtjgJueDFUClqV1AyPo4jftbA24P+cjvfrN10Fc8
         88z6Uc5C+/XD+VGOY9Douh60sf0WKHwcTxfwfj6Iuf5Gq6trB/iKMRyq5J+5bjzWh7xM
         eYIQ==
X-Gm-Message-State: APjAAAVKwRsBHSEMpKhaXBdcoC/u8RM4Kgq5Cql5JbIsilv3qPRlPExU
        PKspSsqipPwoEXRnUM/6mNf9y8h7JPU=
X-Google-Smtp-Source: APXvYqwsAMsGsUqN4Iz2GSvHnZHivnG1YKPfYwHXacXEfXmT5GdOdxiTU/AYMU8xkWCMaM2N9zJWjA==
X-Received: by 2002:a63:4a50:: with SMTP id j16mr33687514pgl.308.1574694161158;
        Mon, 25 Nov 2019 07:02:41 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:550c:6dad:1b5f:afc6:7758])
        by smtp.gmail.com with ESMTPSA id x2sm8703129pfn.167.2019.11.25.07.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 07:02:40 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     jakub.kicinski@netronome.com, kvalo@codeaurora.org,
        davem@davemloft.net, luciano.coelho@intel.com,
        shahar.s.matityahu@intel.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, sara.sharon@intel.com,
        Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        yuehaibing@huawei.com, pkshih@realtek.com,
        arend.vanspriel@broadcom.com, rafal@milecki.pl,
        franky.lin@broadcom.com, pieter-paul.giesberts@broadcom.com,
        p.figiel@camlintechnologies.com, Wright.Feng@cypress.com,
        keescook@chromium.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 3/3] drivers: net: realtek: Fix -Wcast-function-type
Date:   Mon, 25 Nov 2019 22:02:15 +0700
Message-Id: <20191125150215.29263-3-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125150215.29263-1-tranmanphong@gmail.com>
References: <20191125150215.29263-1-tranmanphong@gmail.com>
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

