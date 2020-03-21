Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0335718E393
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 19:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCUSIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 14:08:21 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33482 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbgCUSIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 14:08:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id r7so9816586wmg.0
        for <netdev@vger.kernel.org>; Sat, 21 Mar 2020 11:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=L9svU/9aDp1KNKfrQaICmvKF6NU9sK246somfvaZjj0=;
        b=YpAdbMoS7xAdghnM9OaTlvFMlK1uF9qdBgOemnlkDq2nLW3HFTfGCryprDdnQOSXNL
         YNlPz07KJtjiXli+kbkxJe+jGnREICRAYa0EXAELS3Epzyu+dfxCJlXwbXiwDsQhLH24
         pUY2wx0bFxAfmXmPIYT27Wxa6XbzEB7/WeBfBiKe1mrhEESl+gPub4zApsoIoMXMBjwR
         xHFxPATnbUv3JvxzAcQ7Kwo3iMtHrN87fO9fBn7GzHAbpNVrlpMphJIneCu8gsGaDhZv
         YZUv1KXIQ6LMUiSZESR8hpFM3Mp2cEg3JHzvUjXK5DGd61xNQcnX+ht2lF3ntD9RyVcS
         fF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=L9svU/9aDp1KNKfrQaICmvKF6NU9sK246somfvaZjj0=;
        b=J32wN8o81YdxTfkAZMznrfnPgDCUZ9jBbd3bRBIfUxxcNZ9nWIhHJBpGbmwxqBivVN
         7s1UxOBpyyAZtew3U9n3nWQ2WO1B33mt72wYE0nt0NYRmA51hV7mfSY940wMNT27Vkc1
         xL0aTZAch4XoHc0Ld1Nhe6G0yU1JdvibOLbyGUjEe+bMMy9q36Q0Vig2grmz2DbTmNpQ
         LEVAwrsAS7iw8ugsy6o+4SoUtm4FCY07WTBkV/ziUVOiSKF4kZ1rBjDMXtDn6dvmni9o
         G9o3pdWmoWmjXEe8rFodDojJyeMMcbRGX+rZoTQMXc7ZY1OtiIJxtV+WsKiRtM9GytOv
         iJ4A==
X-Gm-Message-State: ANhLgQ2Kg1VjujECGQOOjrUtn0wg1EwXeBVema2+9RQUqre4yK0e2v0U
        W/7Z6EODPT+9wlVUzfayp4QkiVb9
X-Google-Smtp-Source: ADFU+vt8GSrRZ0TSTge2+YGKkHRZqDjHXk61Y4SOxXChyBcw7jCY0c8tmQngh0iIsAGMSkY8sSWBIA==
X-Received: by 2002:a1c:2285:: with SMTP id i127mr17968822wmi.152.1584814097574;
        Sat, 21 Mar 2020 11:08:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:e44a:a16c:158d:8e2c? (p200300EA8F296000E44AA16C158D8E2C.dip0.t-ipconnect.de. [2003:ea:8f29:6000:e44a:a16c:158d:8e2c])
        by smtp.googlemail.com with ESMTPSA id q4sm13881816wro.56.2020.03.21.11.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Mar 2020 11:08:17 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: add new helper rtl8168g_enable_gphy_10m
Message-ID: <743a1fd7-e1b2-d548-1c22-7c1a2e3b268e@gmail.com>
Date:   Sat, 21 Mar 2020 19:08:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out setting GPHY 10M to new helper rtl8168g_enable_gphy_10m.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 .../net/ethernet/realtek/r8169_phy_config.c    | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index e367e77c7..b73f7d023 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -796,6 +796,11 @@ static void rtl8168g_disable_aldps(struct phy_device *phydev)
 	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(2), 0);
 }
 
+static void rtl8168g_enable_gphy_10m(struct phy_device *phydev)
+{
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
+}
+
 static void rtl8168g_phy_adjust_10m_aldps(struct phy_device *phydev)
 {
 	phy_modify_paged(phydev, 0x0bcc, 0x14, BIT(8), 0);
@@ -904,8 +909,7 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
 	r8168g_phy_param(phydev, 0x0811, 0x0000, 0x0800);
 	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
 
-	/* enable GPHY 10M */
-	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
+	rtl8168g_enable_gphy_10m(phydev);
 
 	/* SAR ADC performance */
 	phy_modify_paged(phydev, 0x0bca, 0x17, BIT(12) | BIT(13), BIT(14));
@@ -940,8 +944,7 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 	r8168g_phy_param(phydev, 0x0811, 0x0000, 0x0800);
 	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
 
-	/* enable GPHY 10M */
-	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
+	rtl8168g_enable_gphy_10m(phydev);
 
 	ioffset = rtl8168h_2_get_adc_bias_ioffset(tp);
 	if (ioffset != 0xffff)
@@ -1063,8 +1066,7 @@ static void rtl8117_hw_phy_config(struct rtl8169_private *tp,
 
 	r8168g_phy_param(phydev, 0x8011, 0x0000, 0x0800);
 
-	/* enable GPHY 10M */
-	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
+	rtl8168g_enable_gphy_10m(phydev);
 
 	r8168g_phy_param(phydev, 0x8016, 0x0000, 0x0400);
 
@@ -1171,7 +1173,7 @@ static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp,
 	phy_write_paged(phydev, 0xbc3, 0x12, 0x5555);
 	phy_modify_paged(phydev, 0xbf0, 0x15, 0x0e00, 0x0a00);
 	phy_modify_paged(phydev, 0xa5c, 0x10, 0x0400, 0x0000);
-	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+	rtl8168g_enable_gphy_10m(phydev);
 
 	rtl8125_config_eee_phy(phydev);
 }
@@ -1236,7 +1238,7 @@ static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0xa5d, 0x12, 0x0000, 0x0020);
 	phy_modify_paged(phydev, 0xad4, 0x17, 0x0010, 0x0000);
 	phy_modify_paged(phydev, 0xa86, 0x15, 0x0001, 0x0000);
-	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+	rtl8168g_enable_gphy_10m(phydev);
 
 	rtl8125_config_eee_phy(phydev);
 }
-- 
2.25.2

