Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9413F20CAB9
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 23:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgF1VRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 17:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgF1VRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 17:17:23 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96C3C03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 14:17:22 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id z17so11207082edr.9
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 14:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hlbOd+AjXA9mOzFzttUmdXl4dBFDkqXVFgg6QaCE2Vg=;
        b=j196CY01MoyqRuL8wrAL3MS3ApBdvLVPAS/iOZbjBGw7QKT+EYdXhNNBWHQGpHysA7
         vkEFHFpG6kD5bKm4OW8s6olcqFavvmgG65dRpdiRGHP7gUzo5yg5WCdqLCq9HBo7uzmI
         xnPFdIIpJpv92W40fjmK0rzFU6TwWp5A9SDSq9Fflt9lmn0j6S6TNR03c2WGnfYz72XF
         SM0b1rTOag9cYtwLC+4Uw1/Am7zBh8T9/lBdH9WLqsdk8Nt4s9M5mF67WsgSmQkXUGVk
         cxvlulp6VWDFd526vqZQmNwbaRRR8PjnhikMxmSpsmIvLlOLs6aj7AVMrrZCRVmn7nn2
         iyrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hlbOd+AjXA9mOzFzttUmdXl4dBFDkqXVFgg6QaCE2Vg=;
        b=eB6LdJQ6MCQ9OoximFcSCgfbsFTIdOhCv88ZxgcogNA2333h/gHguuiA8TQPEVi4tU
         oPXgA2Hovswo1PPR5j9tlJCGtgN+mWiBCpNH2K/5q2GTOvrvcxxQJIoZp+ZEBSwMox2c
         wFkg8snKAwO88Kx0aFdGyjG1yJT2fhoyk8yKfU9zeE2RTgU3uxHDKKdRv7I0ef8hJ985
         NGaMzCtY1BysgNik5sBAz6ycfTsqB47aGzL5jrmrJCiI/tqJZk3Uxw88kHv07uERWqst
         qRAjuYZF/jN3WW6vU3Dxp3MMky55p8DVTRcKZhzUPFOgZwlckZ5iSOaCSQ3YDWpLPIQp
         j/rg==
X-Gm-Message-State: AOAM532yoiiDm9hz/DEPp3Zc9lF1wfuFO662la9vRBP1Nw1CR67ntK/t
        jN9JvKzJXUwdvLF96cqcjxDtBrRZ
X-Google-Smtp-Source: ABdhPJyfbKKEXD8zXeLXyTDW9TWEQHBuHhfMV/drKL4mj+R1ad7FzpcA7sTAvHes27xSLjR1G5TJmQ==
X-Received: by 2002:a50:9b18:: with SMTP id o24mr14654433edi.335.1593379041377;
        Sun, 28 Jun 2020 14:17:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:ed55:9d81:4812:8269? (p200300ea8f235700ed559d8148128269.dip0.t-ipconnect.de. [2003:ea:8f23:5700:ed55:9d81:4812:8269])
        by smtp.googlemail.com with ESMTPSA id m22sm23367115ejb.47.2020.06.28.14.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 14:17:21 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: sync support for RTL8401 with vendor
 driver
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <29ba5d31-9a0f-05c4-1472-5b15330f6408@gmail.com>
Message-ID: <d43cbecc-5b6d-a59e-a79a-9dbbd63dde17@gmail.com>
Date:   Sun, 28 Jun 2020 23:17:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <29ba5d31-9a0f-05c4-1472-5b15330f6408@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far RTL8401 was treated like a RTL8101e, means we relied on the BIOS
to configure MAC and PHY properly. Make RTL8401 a separate chip version
and copy MAC / PHY config from r8101 vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h           |  1 +
 drivers/net/ethernet/realtek/r8169_main.c      | 18 ++++++++++++++++--
 .../net/ethernet/realtek/r8169_phy_config.c    |  8 ++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index afefdec9d..422a8e5a8 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -25,6 +25,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_11,
 	RTL_GIGA_MAC_VER_12,
 	RTL_GIGA_MAC_VER_13,
+	RTL_GIGA_MAC_VER_14,
 	RTL_GIGA_MAC_VER_16,
 	RTL_GIGA_MAC_VER_17,
 	RTL_GIGA_MAC_VER_18,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 124827b19..07a33af1f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -106,6 +106,7 @@ static const struct {
 	[RTL_GIGA_MAC_VER_11] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_12] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_13] = {"RTL8101e/RTL8100e"			},
+	[RTL_GIGA_MAC_VER_14] = {"RTL8401"				},
 	[RTL_GIGA_MAC_VER_16] = {"RTL8101e"				},
 	[RTL_GIGA_MAC_VER_17] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_18] = {"RTL8168cp/8111cp"			},
@@ -1999,8 +2000,7 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7cf, 0x348,	RTL_GIGA_MAC_VER_07 },
 		{ 0x7cf, 0x248,	RTL_GIGA_MAC_VER_07 },
 		{ 0x7cf, 0x340,	RTL_GIGA_MAC_VER_13 },
-		/* RTL8401, reportedly works if treated as RTL8101e */
-		{ 0x7cf, 0x240,	RTL_GIGA_MAC_VER_13 },
+		{ 0x7cf, 0x240,	RTL_GIGA_MAC_VER_14 },
 		{ 0x7cf, 0x343,	RTL_GIGA_MAC_VER_10 },
 		{ 0x7cf, 0x342,	RTL_GIGA_MAC_VER_16 },
 		{ 0x7c8, 0x348,	RTL_GIGA_MAC_VER_09 },
@@ -3401,6 +3401,19 @@ static void rtl_hw_start_8102e_3(struct rtl8169_private *tp)
 	rtl_ephy_write(tp, 0x03, 0xc2f9);
 }
 
+static void rtl_hw_start_8401(struct rtl8169_private *tp)
+{
+	static const struct ephy_info e_info_8401[] = {
+		{ 0x01,	0xffff, 0x6fe5 },
+		{ 0x03,	0xffff, 0x0599 },
+		{ 0x06,	0xffff, 0xaf25 },
+		{ 0x07,	0xffff, 0x8e68 },
+	};
+
+	rtl_ephy_init(tp, e_info_8401);
+	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
+}
+
 static void rtl_hw_start_8105e_1(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8105e_1[] = {
@@ -3614,6 +3627,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_11] = rtl_hw_start_8168b,
 		[RTL_GIGA_MAC_VER_12] = rtl_hw_start_8168b,
 		[RTL_GIGA_MAC_VER_13] = NULL,
+		[RTL_GIGA_MAC_VER_14] = rtl_hw_start_8401,
 		[RTL_GIGA_MAC_VER_16] = NULL,
 		[RTL_GIGA_MAC_VER_17] = rtl_hw_start_8168b,
 		[RTL_GIGA_MAC_VER_18] = rtl_hw_start_8168cp_1,
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index a0c2b3330..bc8bf48bd 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1091,6 +1091,13 @@ static void rtl8102e_hw_phy_config(struct rtl8169_private *tp,
 	rtl_writephy_batch(phydev, phy_reg_init);
 }
 
+static void rtl8401_hw_phy_config(struct rtl8169_private *tp,
+				  struct phy_device *phydev)
+{
+	phy_set_bits(phydev, 0x11, BIT(12));
+	phy_modify_paged(phydev, 0x0002, 0x0f, 0x0000, 0x0003);
+}
+
 static void rtl8105e_hw_phy_config(struct rtl8169_private *tp,
 				   struct phy_device *phydev)
 {
@@ -1261,6 +1268,7 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_11] = rtl8168bb_hw_phy_config,
 		[RTL_GIGA_MAC_VER_12] = rtl8168bef_hw_phy_config,
 		[RTL_GIGA_MAC_VER_13] = NULL,
+		[RTL_GIGA_MAC_VER_14] = rtl8401_hw_phy_config,
 		[RTL_GIGA_MAC_VER_16] = NULL,
 		[RTL_GIGA_MAC_VER_17] = rtl8168bef_hw_phy_config,
 		[RTL_GIGA_MAC_VER_18] = rtl8168cp_1_hw_phy_config,
-- 
2.27.0


