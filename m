Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371E212892A
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 14:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfLUNP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 08:15:58 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41707 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfLUNP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 08:15:56 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so12028936wrw.8
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 05:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8pSEcUmSs6isyuCyJY0A/zUx9r1MVTC8a3YoOEX1Qh8=;
        b=CEtKiwIA/dZv0exbukUK9q9p4UDjcjLzKu0RW/FQStoLOkEgJN9qP0lgf7P9axmg8q
         bsTHuZw4678ZoCnymFlQK9RTgOJ4ahdm0FeA+VCOGF1gRFDNPoFprGY5Fj/guePGo6z6
         A1SrLOXn0j0SW0AZptgj3zYBRic3+HdEPuTSX/pvqRsEmYUR/EuBL+1gE2BsBrtDX5+Z
         DYGfcKLGmDPiKtsp/SX563TOxkUt+M6x6ig/L8Z0/5R8SKhTCG9ptirZtUSyg8KupVOM
         U7MjMuv0n6NTpAcJkELygbAyjzfyK4J7o8iidClwudr271T4DyFiioNywWDwfvBkEzxT
         v1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8pSEcUmSs6isyuCyJY0A/zUx9r1MVTC8a3YoOEX1Qh8=;
        b=WBQBsFVag+1GJcr/i3rIGyOVMsBbE3AePfY3OyI7WgosoMcjShVK9tFNcZ/hZp1Qde
         grw5bq9yzdw9FqeOmNBLTz9ygJJNiZgaax383bm9kOOLNeOH0/PMCTrVj6ih9R9LMaDZ
         Od0HXLNv9xVVPhDDE0IjNRNE0G928bpuclwEn+3fxF8eHfA2VpnZdjvPXOvooDDeEaY3
         EFXOTMDc9wBLwKwKXrYy8Z9Cww+f2qdd2AIlPcgwsKQwa0k7V/kRNwEgnfjZEN7Nsga3
         NJ3vjl8R7nrhFwsRJtU2xRr+0rTGg18iQ4SNj7Cn3MVK6LsAvCvbKOx+/i2o5tUb6+T/
         BFFQ==
X-Gm-Message-State: APjAAAUrnsGcCJpkxeDcKV/7/tUyGs2RQ+iwrXlLBrgYua0z9OJvrXng
        MacvqZv2u5HINp4sULUNzukdt3HV
X-Google-Smtp-Source: APXvYqxgj9T9eiHrC+V9C41ALQBiHIfL2PqKEZm/lqG7o+0GyXVU4E6eZnt7RK1Nq44qW3PYyKu2tQ==
X-Received: by 2002:adf:e812:: with SMTP id o18mr20027185wrm.127.1576934154017;
        Sat, 21 Dec 2019 05:15:54 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:1d9b:6ccb:460c:7d9e? (p200300EA8F4A63001D9B6CCB460C7D9E.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:1d9b:6ccb:460c:7d9e])
        by smtp.googlemail.com with ESMTPSA id h2sm13193570wrv.66.2019.12.21.05.15.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Dec 2019 05:15:53 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: move enabling EEE to rtl8169_init_phy
Message-ID: <2f337f78-64c6-4be4-4962-a09b8b5814ac@gmail.com>
Date:   Sat, 21 Dec 2019 14:15:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code by moving the call to rtl_enable_eee() from the
individual PHY configs to rtl8169_init_phy().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 38a09b5ee..0161d839f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2951,7 +2951,6 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
 
 	rtl8168f_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 
 	/* Green feature */
 	rtl_writephy(tp, 0x1f, 0x0003);
@@ -2978,7 +2977,6 @@ static void rtl8168f_hw_phy_config(struct rtl8169_private *tp)
 	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
 
 	rtl8168f_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 }
 
 static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp)
@@ -3124,14 +3122,12 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168g_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 }
 
 static void rtl8168g_2_hw_phy_config(struct rtl8169_private *tp)
 {
 	rtl_apply_firmware(tp);
 	rtl8168g_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 }
 
 static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
@@ -3198,7 +3194,6 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168h_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 }
 
 static u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp)
@@ -3253,7 +3248,6 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168g_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 }
 
 static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp)
@@ -3276,7 +3270,6 @@ static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168g_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 }
 
 static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp)
@@ -3328,7 +3321,6 @@ static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168g_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 }
 
 static void rtl8117_hw_phy_config(struct rtl8169_private *tp)
@@ -3368,7 +3360,6 @@ static void rtl8117_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168h_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 }
 
 static void rtl8102e_hw_phy_config(struct rtl8169_private *tp)
@@ -3475,7 +3466,6 @@ static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
 
 	rtl8125_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 }
 
 static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp)
@@ -3541,7 +3531,6 @@ static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
 
 	rtl8125_config_eee_phy(tp);
-	rtl_enable_eee(tp);
 }
 
 static void rtl_hw_phy_config(struct net_device *dev)
@@ -3630,6 +3619,9 @@ static void rtl8169_init_phy(struct net_device *dev, struct rtl8169_private *tp)
 	/* We may have called phy_speed_down before */
 	phy_speed_up(tp->phydev);
 
+	if (rtl_supports_eee(tp))
+		rtl_enable_eee(tp);
+
 	genphy_soft_reset(tp->phydev);
 }
 
-- 
2.24.1

