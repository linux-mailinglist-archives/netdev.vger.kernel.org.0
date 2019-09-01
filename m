Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B8AA486E
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 10:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbfIAImz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 04:42:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36512 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728764AbfIAImz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 04:42:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so10955328wrd.3
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 01:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Lg9nXLyAmLFmncw/23iVaOST/TTr3WFKaPev7qjDmFs=;
        b=nzIVlViror7LkkDQwTNO3egfVBsmGZlQoZ6/49t9BU3DQB24YcHRQlrMzL1KNvSzcs
         ZZqVZgzsshjoXfPT+NZ9aKAWQM7FeYevQP2gBBb6UZ02n6dl9B4TR+EfGdHQxODMOS1V
         V9bp6pRaRFjlhDmQMytZmcOoHheWF/QTH2Ouf5Wek0H3SQRcyKX/cRGy3SYfpw1UM9El
         Mm/p7QRvk0oxllpHKIoGN8e/wBeuBVmVUHCifajdLOWh3jEPLVkEwJ0QdPHCI2b+1WnL
         sVmh87ziyYEswssjfUN5YHBoxlzBCWBE8BTdnTYIgI/VoUUpu/RM2i1TwGiH7vDbmmEh
         pG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Lg9nXLyAmLFmncw/23iVaOST/TTr3WFKaPev7qjDmFs=;
        b=bhZI8ify0W0deQcKHNB/krsJZUvu70E90BkAO4tt3Tn3F5V5QkQ3pFkRx9wpEspyeg
         BikS+WqDF3BKeME2DVYF4F6Mk/afvMnmRHgpYSTOc8c0P1RnMDjfiPcKEMAHhFVWx/4b
         08W2mjgm9AMpEm5RPf46f3KBGYyu1mpIGahw2sSQEWFXiG3IC0inTL8Q0FPVcc9BF54g
         1pfgWIN23sb+5QdDIiziLHPbDp3U5tDel0nPbqwgLfkZqXgyQQg3aSv+gwm6Ss8sh+IZ
         Nh8tqff8KePYOCy7xdiydq5OeBMVss/eTg1knhhtjm+ElEJj/25sSzh31tE+c6LCh0Lh
         X4vw==
X-Gm-Message-State: APjAAAWRGBBzZQGqPjV7harXmPFr0SAmxyP33pv9BS/T4Lw/UV8BD/8c
        04rSuDOFfwmtd7UmS5wRE9iAVqDL
X-Google-Smtp-Source: APXvYqzYKoIAJiZAnUmy6pLNE6JsyaICDM8NfSynlcZ3rek/dTn9s/rkd7OjWbWMwrfRJLXzDGJhog==
X-Received: by 2002:adf:f186:: with SMTP id h6mr28403770wro.274.1567327373215;
        Sun, 01 Sep 2019 01:42:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:20bd:6b4b:9f75:976c? (p200300EA8F047C0020BD6B4B9F75976C.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:20bd:6b4b:9f75:976c])
        by smtp.googlemail.com with ESMTPSA id h23sm12976570wml.43.2019.09.01.01.42.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Sep 2019 01:42:52 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: don't set bit RxVlan on RTL8125
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <84b91849-0ea6-5f76-150e-bee20a2a4d5c@gmail.com>
Date:   Sun, 1 Sep 2019 10:42:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8125 uses a different register for VLAN offloading config,
therefore don't set bit RxVlan.

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7d1094ffd..74f81fe03 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -7163,8 +7163,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		NETIF_F_HIGHDMA;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	tp->cp_cmd |= RxChkSum | RxVlan;
-
+	tp->cp_cmd |= RxChkSum;
+	/* RTL8125 uses register RxConfig for VLAN offloading config */
+	if (!rtl_is_8125(tp))
+		tp->cp_cmd |= RxVlan;
 	/*
 	 * Pretend we are using VLANs; This bypasses a nasty bug where
 	 * Interrupts stop flowing on high load on 8110SCd controllers.
-- 
2.23.0

