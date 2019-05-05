Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7213EDF
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfEEKel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:34:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39309 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfEEKej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:34:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id v10so1166952wrt.6
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e9zy81puoCSPnRf9rCIJOkva2b81hbzdn5+WttoYveY=;
        b=rM0hehEglhIPl8FFJNaWMrSgDnP+qlSnjHNkiyCv7IJVORhUTG0V8IJ5cIv3hiNqEa
         uP5jPOYUnhl7UH5j8ZBsmAOHnB2v1TDT4NRaJPbtOuYGZIQd9y6x7s/CPNsnC8u0vyBG
         +OdxEQfdrim0c8irV150HsyM4S+U8yk5Ok4WIzNloGK7kIgKmI1hB9yoLNybcMYt/bOy
         8mt40R//j1QWbhbxlzDeIh1PoJQNm0eHU3greLHgV26kZER6qKGkilhbZEtKqrdE1pIF
         7H/n0KZk/Qw3TrbSkZcw/YiCamGriUS0fX8ysrMibpw8cB7DmFmS5BAf1boSEwsgCvT+
         3gDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e9zy81puoCSPnRf9rCIJOkva2b81hbzdn5+WttoYveY=;
        b=cneXwQ3qQMb5Q86vUBpItqP9fGc0OsQvu40bCZebwzFKiy73cV7ubowmXxE1Pg9BzY
         xNqB9BMJj4XtdkQhBD7c/hjnK/ZyKbKRqyVBJabVilYc3gzDuiIjcPVj8AgX2kGQSjHz
         yHt4N9EfiwVz5U/VM5kEzkC1eURYQAQkG4fchXAwIhDNrmm7ZBs0+M4Uut1FlDXKEA8V
         I1mJYjieK3E+KJnw7haCrEiMsFhSV53Sl6iDCsk7tRjDa6Pk9Texgcipa0/NeSg+zMnm
         0SDQvw1ETWKNsWTOqdsUTHLw3/xz8U/Vm70Fxt9vnzRkrmPMrMuq/nRd6Q935a2zytYF
         QBBA==
X-Gm-Message-State: APjAAAVt6tsaFzAVSrhGVjVGzUAQWY4hcixtStEkLHq6dQ4woY722Kx1
        alY9+CxXSVoH+ybZq5ohqt1ttMxVtCc=
X-Google-Smtp-Source: APXvYqxOX28nC9BLuMO+TuO5vluazqjCIMdjH/KoGhNbRKXoQW1Ddl/YlBhYOVBK52EwZ7V3XSQxfg==
X-Received: by 2002:adf:e546:: with SMTP id z6mr8505025wrm.287.1557052477138;
        Sun, 05 May 2019 03:34:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:d9a7:917c:8564:c504? (p200300EA8BD45700D9A7917C8564C504.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:d9a7:917c:8564:c504])
        by smtp.googlemail.com with ESMTPSA id k2sm1202107wrg.22.2019.05.05.03.34.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:34:36 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: add rtl8168g_set_pause_thresholds
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <68744103-d101-6c47-b5bd-a3ed383d5798@gmail.com>
Message-ID: <6be51bdb-f5b6-3389-8403-c14378eb9608@gmail.com>
Date:   Sun, 5 May 2019 12:34:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <68744103-d101-6c47-b5bd-a3ed383d5798@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on info from Realtek add a function for defining the thresholds
controlling ethernet flow control.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index ed63c98a6..2e20334b7 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4766,6 +4766,14 @@ static void rtl_set_fifo_size(struct rtl8169_private *tp, u16 rx_stat,
 	rtl_eri_write(tp, 0xe8, ERIAR_MASK_1111, (tx_stat << 16) | tx_dyn);
 }
 
+static void rtl8168g_set_pause_thresholds(struct rtl8169_private *tp,
+					  u8 low, u8 high)
+{
+	/* FIFO thresholds for pause flow control */
+	rtl_eri_write(tp, 0xcc, ERIAR_MASK_0001, low);
+	rtl_eri_write(tp, 0xd0, ERIAR_MASK_0001, high);
+}
+
 static void rtl_hw_start_8168bb(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
@@ -5076,8 +5084,7 @@ static void rtl_hw_start_8411(struct rtl8169_private *tp)
 static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 {
 	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
-	rtl_eri_write(tp, 0xcc, ERIAR_MASK_0001, 0x38);
-	rtl_eri_write(tp, 0xd0, ERIAR_MASK_0001, 0x48);
+	rtl8168g_set_pause_thresholds(tp, 0x38, 0x48);
 
 	rtl_set_def_aspm_entry_latency(tp);
 
@@ -5170,8 +5177,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 	rtl_ephy_init(tp, e_info_8168h_1);
 
 	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
-	rtl_eri_write(tp, 0xcc, ERIAR_MASK_0001, 0x38);
-	rtl_eri_write(tp, 0xd0, ERIAR_MASK_0001, 0x48);
+	rtl8168g_set_pause_thresholds(tp, 0x38, 0x48);
 
 	rtl_set_def_aspm_entry_latency(tp);
 
@@ -5249,8 +5255,7 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 	rtl8168ep_stop_cmac(tp);
 
 	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
-	rtl_eri_write(tp, 0xcc, ERIAR_MASK_0001, 0x2f);
-	rtl_eri_write(tp, 0xd0, ERIAR_MASK_0001, 0x5f);
+	rtl8168g_set_pause_thresholds(tp, 0x2f, 0x5f);
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-- 
2.21.0


