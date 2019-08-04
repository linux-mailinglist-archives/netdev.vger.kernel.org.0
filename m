Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBA4809E0
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 09:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfHDHw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 03:52:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35176 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfHDHw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 03:52:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so81301533wrm.2
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 00:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=avuAd1qOGTy07VWIQqsi7hs0vhQJEIQJotFFEGUhpTk=;
        b=HlAzsrs9uBGdbDIAueDTfT+Y5Uu6IDY6ZV3YCxt9cpDqyHnWnUrzGbaVcc/BxRP25w
         VwqbnzJeodwal4MWSfoeudiFvMM0drpzSOHk/vHfTWyIXaGefEqeb4JfY1Xsnt2H69Lw
         GbhiVzS5h7d342t+jxPcMVBYF59O7/AT7QrOlLQa5wPLnToAjEnANSWHVU6ZCJs27jVg
         TEdlxtd2j/90Hmmiz5VGJqJx9KeeJgKiKnjeh79jQt3E+tptDykuLMBDfK/bI5WeEQWA
         0+JkvW+gFg3iwuQgU7zg06zSORIRTT7978nutxM0sYB408csGQU4L7O7KUdL6DJpyNNO
         8fiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=avuAd1qOGTy07VWIQqsi7hs0vhQJEIQJotFFEGUhpTk=;
        b=MiUTwxyqcAVysS/CTWzgTkLF6hXGHqlsW0rLdODGRZjf8WqB7yK1iUeIiDxZTBdCjE
         tBkVLYzwHg3gtSoHRQL2U162B0vMdttC0Jx1sRaa4CUJ8IJkYDp/7cBYQ+IVja5SazW3
         wFaR+5lR+p8xFFtkLD9DvM0twZiIwC1IGojBcmDQZ+2HLaor9aUGstsLYN1tkj0DFwWV
         0VTN7ZutjmSmpUHaweL5/kOhk0plF+i7G7wbUQ07y9OWoAPKRRcHh/d4ZM1iA+ecGz1W
         hqfwcqJhf5IECAVJbT9QxfGod78L2lNwrp9bzUXcyaH908TT3qN8M4kRwiL6YLKVYZxH
         VEDQ==
X-Gm-Message-State: APjAAAW4fwOflyEvVeAQ2RPmFXIFUpEdXRviBpnZ3mPOkOMq8bEmnEJs
        59n5rT3E37K48EM8OhGxYlMJPYnBKrI=
X-Google-Smtp-Source: APXvYqz+Pgznpf9Sup08Sl7acgY8woCSHxOL+w75wjJmfqhTwLacUU6yI9Dd072eZBjQA+e9QFCjmg==
X-Received: by 2002:adf:ec49:: with SMTP id w9mr145356660wrn.303.1564905173317;
        Sun, 04 Aug 2019 00:52:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:9900:d80f:58c5:990d:c59b? (p200300EA8F289900D80F58C5990DC59B.dip0.t-ipconnect.de. [2003:ea:8f28:9900:d80f:58c5:990d:c59b])
        by smtp.googlemail.com with ESMTPSA id r11sm124251041wre.14.2019.08.04.00.52.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 00:52:52 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: sync PCIe PHY init with vendor driver
 8.047.01
Message-ID: <52b6804e-b2d4-0724-9b71-45ec46f4b1b4@gmail.com>
Date:   Sun, 4 Aug 2019 09:52:33 +0200
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

Synchronize PCIe PHY initialization with vendor driver version 8.047.01.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 60 ++++++++++++++---------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 039a967c7..3c7af6669 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4415,7 +4415,7 @@ static void rtl_hw_start_8168c_2(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8168c_2[] = {
 		{ 0x01, 0,	0x0001 },
-		{ 0x03, 0x0400,	0x0220 }
+		{ 0x03, 0x0400,	0x0020 }
 	};
 
 	rtl_set_def_aspm_entry_latency(tp);
@@ -4462,7 +4462,8 @@ static void rtl_hw_start_8168d_4(struct rtl8169_private *tp)
 	static const struct ephy_info e_info_8168d_4[] = {
 		{ 0x0b, 0x0000,	0x0048 },
 		{ 0x19, 0x0020,	0x0050 },
-		{ 0x0c, 0x0100,	0x0020 }
+		{ 0x0c, 0x0100,	0x0020 },
+		{ 0x10, 0x0004,	0x0000 },
 	};
 
 	rtl_set_def_aspm_entry_latency(tp);
@@ -4512,7 +4513,9 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8168e_2[] = {
 		{ 0x09, 0x0000,	0x0080 },
-		{ 0x19, 0x0000,	0x0224 }
+		{ 0x19, 0x0000,	0x0224 },
+		{ 0x00, 0x0000,	0x0004 },
+		{ 0x0c, 0x3df0,	0x0200 },
 	};
 
 	rtl_set_def_aspm_entry_latency(tp);
@@ -4574,7 +4577,9 @@ static void rtl_hw_start_8168f_1(struct rtl8169_private *tp)
 		{ 0x06, 0x00c0,	0x0020 },
 		{ 0x08, 0x0001,	0x0002 },
 		{ 0x09, 0x0000,	0x0080 },
-		{ 0x19, 0x0000,	0x0224 }
+		{ 0x19, 0x0000,	0x0224 },
+		{ 0x00, 0x0000,	0x0004 },
+		{ 0x0c, 0x3df0,	0x0200 },
 	};
 
 	rtl_hw_start_8168f(tp);
@@ -4589,8 +4594,9 @@ static void rtl_hw_start_8411(struct rtl8169_private *tp)
 	static const struct ephy_info e_info_8168f_1[] = {
 		{ 0x06, 0x00c0,	0x0020 },
 		{ 0x0f, 0xffff,	0x5200 },
-		{ 0x1e, 0x0000,	0x4000 },
-		{ 0x19, 0x0000,	0x0224 }
+		{ 0x19, 0x0000,	0x0224 },
+		{ 0x00, 0x0000,	0x0004 },
+		{ 0x0c, 0x3df0,	0x0200 },
 	};
 
 	rtl_hw_start_8168f(tp);
@@ -4629,8 +4635,8 @@ static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 static void rtl_hw_start_8168g_1(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8168g_1[] = {
-		{ 0x00, 0x0000,	0x0008 },
-		{ 0x0c, 0x37d0,	0x0820 },
+		{ 0x00, 0x0008,	0x0000 },
+		{ 0x0c, 0x3ff0,	0x0820 },
 		{ 0x1e, 0x0000,	0x0001 },
 		{ 0x19, 0x8000,	0x0000 }
 	};
@@ -4646,10 +4652,15 @@ static void rtl_hw_start_8168g_1(struct rtl8169_private *tp)
 static void rtl_hw_start_8168g_2(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8168g_2[] = {
-		{ 0x00, 0x0000,	0x0008 },
-		{ 0x0c, 0x3df0,	0x0200 },
-		{ 0x19, 0xffff,	0xfc00 },
-		{ 0x1e, 0xffff,	0x20eb }
+		{ 0x00, 0x0008,	0x0000 },
+		{ 0x0c, 0x3ff0,	0x0820 },
+		{ 0x19, 0xffff,	0x7c00 },
+		{ 0x1e, 0xffff,	0x20eb },
+		{ 0x0d, 0xffff,	0x1666 },
+		{ 0x00, 0xffff,	0x10a3 },
+		{ 0x06, 0xffff,	0xf050 },
+		{ 0x04, 0x0000,	0x0010 },
+		{ 0x1d, 0x4000,	0x0000 },
 	};
 
 	rtl_hw_start_8168g(tp);
@@ -4663,11 +4674,16 @@ static void rtl_hw_start_8168g_2(struct rtl8169_private *tp)
 static void rtl_hw_start_8411_2(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8411_2[] = {
-		{ 0x00, 0x0000,	0x0008 },
-		{ 0x0c, 0x3df0,	0x0200 },
-		{ 0x0f, 0xffff,	0x5200 },
-		{ 0x19, 0x0020,	0x0000 },
-		{ 0x1e, 0x0000,	0x2000 }
+		{ 0x00, 0x0008,	0x0000 },
+		{ 0x0c, 0x37d0,	0x0820 },
+		{ 0x1e, 0x0000,	0x0001 },
+		{ 0x19, 0x8021,	0x0000 },
+		{ 0x1e, 0x0000,	0x2000 },
+		{ 0x0d, 0x0100,	0x0200 },
+		{ 0x00, 0x0000,	0x0080 },
+		{ 0x06, 0x0000,	0x0010 },
+		{ 0x04, 0x0000,	0x0010 },
+		{ 0x1d, 0x0000,	0x4000 },
 	};
 
 	rtl_hw_start_8168g(tp);
@@ -4822,7 +4838,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 		{ 0x1d, 0x0000,	0x0800 },
 		{ 0x05, 0xffff,	0x2089 },
 		{ 0x06, 0xffff,	0x5881 },
-		{ 0x04, 0xffff,	0x154a },
+		{ 0x04, 0xffff,	0x854a },
 		{ 0x01, 0xffff,	0x068b }
 	};
 	int rg_saw_cnt;
@@ -4959,10 +4975,10 @@ static void rtl_hw_start_8168ep_2(struct rtl8169_private *tp)
 static void rtl_hw_start_8168ep_3(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8168ep_3[] = {
-		{ 0x00, 0xffff,	0x10a3 },
-		{ 0x19, 0xffff,	0x7c00 },
-		{ 0x1e, 0xffff,	0x20eb },
-		{ 0x0d, 0xffff,	0x1666 }
+		{ 0x00, 0x0000,	0x0080 },
+		{ 0x0d, 0x0100,	0x0200 },
+		{ 0x19, 0x8021,	0x0000 },
+		{ 0x1e, 0x0000,	0x2000 },
 	};
 
 	/* disable aspm and clock request before access ephy */
-- 
2.22.0

