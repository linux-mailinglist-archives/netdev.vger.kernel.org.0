Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 856F513612E
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbgAITfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37599 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730715AbgAITfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so8706096wru.4
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jThfvR9gMd1ADkV067NxtGID/0UDbv6Wb1QHkitLPNI=;
        b=s+5ME5T/QiipudZk5ujXmlcGVMou/vZCKLcgMqm16/3iXe0hzr1JstD+Iagrt/KaPo
         WyGjSpaXRMt0bo8UTkA9Jp6gcyGgGwogwrgs+jNMBVw/FUiBjxl4iF6JXdABUbGDbQQp
         oIVB1XQnZMBrPW2l/QwpGBLMrrksEWucOZMKIVXoRhEcHvVrXFLy0kcNYfkda9sHktBX
         VChTNsILsLnf4i/8VMvDBJHZXxylPyP0v7thaKZy8W/E1Vx+tVXDs4O3d7e3QSXoiIR8
         H904oD6X4EtZAdBPjzArSWJJYCPQt2OAXPWo+9M8KI2C9rTDiwqtmbUSaHO54vDSCEle
         kRaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jThfvR9gMd1ADkV067NxtGID/0UDbv6Wb1QHkitLPNI=;
        b=c9eIR4SRKkdvYlJUt/DrHue+I/StBo99LUccUid6QrwSq5xLq/RHPW9KK8vBPtLU6o
         qKhBaEQEHqWdRG0QvaBmk8zmFFRsje4/yyyqdMrc7d3O4QVc6tSWnN3tBPK4HCAd0D3H
         Ct1rbK5Ugatfbx+tjO4/1UOtwH8uCrJQOurVyY3EMhYzU+HcAd01T+w8iyjaj9r9XfdH
         LHuVMVDiSEV28FFmedHpjxReXooJPU35qcsZlGIjp5Mx2K71E2CNh+TVQYgTfkQuu1Oo
         JeM4/lmbZe6ejxWSj3jluCIOyRbzLp4enly6HpKypAHIieIMs1WnHwPyoPv/SUirz8Au
         BUaQ==
X-Gm-Message-State: APjAAAUKo3JmAdxJcf4HM9+giUoTo4A5vZYo1aj5PJzk28g9sRKJjmKz
        pyYvbDMFxDLLigW5X2YTGWv3KIDq
X-Google-Smtp-Source: APXvYqzP/6djzmLjxqfY1/dvgV/YqNWylhMtzLgBWDok6xZqi0/aZaeq3LRjJp5BcUAvVTnXYRYBQg==
X-Received: by 2002:adf:806e:: with SMTP id 101mr13137356wrk.300.1578598543881;
        Thu, 09 Jan 2020 11:35:43 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id 60sm9681599wrn.86.2020.01.09.11.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:43 -0800 (PST)
Subject: [PATCH net-next 09/15] r8169: replace rtl_patchphy
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <70157e57-a931-1acc-eb62-616a56f6cbb2@gmail.com>
Date:   Thu, 9 Jan 2020 20:30:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace rtl_patchphy with phylib functions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 42 +++++++++--------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3fb3f2ac6..9765f49e7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1081,11 +1081,6 @@ static int rtl_readphy(struct rtl8169_private *tp, int location)
 	}
 }
 
-static void rtl_patchphy(struct rtl8169_private *tp, int reg_addr, int value)
-{
-	rtl_writephy(tp, reg_addr, rtl_readphy(tp, reg_addr) | value);
-}
-
 static void rtl_w0w1_phy(struct rtl8169_private *tp, int reg_addr, int p, int m)
 {
 	int val;
@@ -2527,7 +2522,7 @@ static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp,
 				    struct phy_device *phydev)
 {
 	rtl_writephy(tp, 0x1f, 0x0001);
-	rtl_patchphy(tp, 0x16, 1 << 0);
+	phy_set_bits(phydev, 0x16, BIT(0));
 	rtl_writephy(tp, 0x10, 0xf41b);
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
@@ -2578,9 +2573,8 @@ static void rtl8168c_1_hw_phy_config(struct rtl8169_private *tp,
 
 	rtl_writephy_batch(phydev, phy_reg_init);
 
-	rtl_patchphy(tp, 0x14, 1 << 5);
-	rtl_patchphy(tp, 0x0d, 1 << 5);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_set_bits(phydev, 0x14, BIT(5));
+	phy_set_bits(phydev, 0x0d, BIT(5));
 }
 
 static void rtl8168c_2_hw_phy_config(struct rtl8169_private *tp,
@@ -2606,10 +2600,9 @@ static void rtl8168c_2_hw_phy_config(struct rtl8169_private *tp,
 
 	rtl_writephy_batch(phydev, phy_reg_init);
 
-	rtl_patchphy(tp, 0x16, 1 << 0);
-	rtl_patchphy(tp, 0x14, 1 << 5);
-	rtl_patchphy(tp, 0x0d, 1 << 5);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_set_bits(phydev, 0x16, BIT(0));
+	phy_set_bits(phydev, 0x14, BIT(5));
+	phy_set_bits(phydev, 0x0d, BIT(5));
 }
 
 static void rtl8168c_3_hw_phy_config(struct rtl8169_private *tp,
@@ -2629,10 +2622,9 @@ static void rtl8168c_3_hw_phy_config(struct rtl8169_private *tp,
 
 	rtl_writephy_batch(phydev, phy_reg_init);
 
-	rtl_patchphy(tp, 0x16, 1 << 0);
-	rtl_patchphy(tp, 0x14, 1 << 5);
-	rtl_patchphy(tp, 0x0d, 1 << 5);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_set_bits(phydev, 0x16, BIT(0));
+	phy_set_bits(phydev, 0x14, BIT(5));
+	phy_set_bits(phydev, 0x0d, BIT(5));
 }
 
 static const struct phy_reg rtl8168d_1_phy_reg_init_0[] = {
@@ -2740,8 +2732,8 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 
 	/* RSET couple improve */
 	rtl_writephy(tp, 0x1f, 0x0002);
-	rtl_patchphy(tp, 0x0d, 0x0300);
-	rtl_patchphy(tp, 0x0f, 0x0010);
+	phy_set_bits(phydev, 0x0d, 0x0300);
+	phy_set_bits(phydev, 0x0f, 0x0010);
 
 	/* Fine tune PLL performance */
 	rtl_writephy(tp, 0x1f, 0x0002);
@@ -2785,11 +2777,10 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl_writephy(tp, 0x1f, 0x0002);
 	rtl_w0w1_phy(tp, 0x02, 0x0100, 0x0600);
 	rtl_w0w1_phy(tp, 0x03, 0x0000, 0xe000);
+	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* Switching regulator Slew rate */
-	rtl_writephy(tp, 0x1f, 0x0002);
-	rtl_patchphy(tp, 0x0f, 0x0017);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(phydev, 0x0002, 0x0f, 0x0000, 0x0017);
 
 	rtl8168d_apply_firmware_cond(tp, 0xb300);
 }
@@ -3368,10 +3359,9 @@ static void rtl8102e_hw_phy_config(struct rtl8169_private *tp,
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_patchphy(tp, 0x11, 1 << 12);
-	rtl_patchphy(tp, 0x19, 1 << 13);
-	rtl_patchphy(tp, 0x10, 1 << 15);
+	phy_set_bits(phydev, 0x11, BIT(12));
+	phy_set_bits(phydev, 0x19, BIT(13));
+	phy_set_bits(phydev, 0x10, BIT(15));
 
 	rtl_writephy_batch(phydev, phy_reg_init);
 }
-- 
2.24.1


