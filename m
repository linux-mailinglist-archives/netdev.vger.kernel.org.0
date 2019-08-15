Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D596F8EB68
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbfHOMVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:21:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42451 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730944AbfHOMVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:21:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id b16so2036823wrq.9
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 05:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=H8lQFNOctMLfg/aMOx4+XSt/QV1NvhlIY0S5WInNiuY=;
        b=BupCF6QgaLCLSwO4W/AQU5KWL4BTUivs2VeKPJkdku4lLCbUkPF2xYw91qdynvNJ+V
         1bxMqR3iTLT1a26gt7+tDY7dAq8ve54R4iGCctKQU+QBG/ORsmwpyyxsChW7l/GM7TEV
         u5Uyc67r61YBxsbE/WfeHUMXWLwLS0BM7uShcgG8fZ31uZhRIl2L6g7oFS5AFarBrl2h
         MRF7Wh43VHVvGyGYzBjNCz4gU5G1Jjp91Pi7dgWPulYwtNOdDXneiJm8i31EwU3PeMfR
         qkeO2p2SfEo1s06PfUr/NJisTcm/UGXEoqrE+Vr8A/LD73Ci1NeFw/bJtkbIXYfMXWZx
         hqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=H8lQFNOctMLfg/aMOx4+XSt/QV1NvhlIY0S5WInNiuY=;
        b=lSgprzk7g1vcQo/IDw2brWrfKCJ1ovyju56hZ4LvIbY26f3Q0asrzzSb9Z0FSyg9nR
         xIQfiWjPeNZRJq+fkYk1CdkjxyviEaRwyGFYwVpdDM7AgBfPsNb73P0D3j/36pjJSyeo
         xgyCL+ZckpmT5Ul4xbkyR7LEASs+4qrcNQW/yUSLmp77uOuy1vFk19ihVVnPpY2k+WOR
         JwSLFuuZcbT+CnnGdmHpF1T5GYl7Oqb/pDvNuqzul1KCa3WoFRZ4d8vCvvCkSozqYXLK
         i22/KU616XDGk7jpyUfzSLLDOkpnFTinBgnsyOVucxEugVohVym9EXo/DLFfQQZ7T73P
         qUaQ==
X-Gm-Message-State: APjAAAWL+qszs12A0aZMNd3jwsgHxCQm6mqgGK4v3D++6sXlSlypAoTl
        BadwfrfBC1Ek0XKNb4dW02c/WEH0
X-Google-Smtp-Source: APXvYqwfx2kxwUs3ckkVFrqwnvV47NiyvFLLvzPxgTy7mDfqrvX1UT7Z8BEJ0GoCtN0HJcWz6+/Ong==
X-Received: by 2002:adf:facc:: with SMTP id a12mr3924396wrs.205.1565871701112;
        Thu, 15 Aug 2019 05:21:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b8fa:18d8:f880:513c? (p200300EA8F2F3200B8FA18D8F880513C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b8fa:18d8:f880:513c])
        by smtp.googlemail.com with ESMTPSA id z8sm3190946wru.13.2019.08.15.05.21.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 05:21:40 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: sync EEE handling for RTL8168h with vendor
 driver
Message-ID: <79a1db61-3aab-065b-9e18-0094c5023300@gmail.com>
Date:   Thu, 15 Aug 2019 14:21:30 +0200
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

Sync EEE init for RTL8168h with vendor driver and add two writes to
vendor-specific registers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c9550b4f9..910944120 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2216,6 +2216,16 @@ static void rtl8168g_config_eee_phy(struct rtl8169_private *tp)
 	phy_modify_paged(tp->phydev, 0x0a43, 0x11, 0, BIT(4));
 }
 
+static void rtl8168h_config_eee_phy(struct rtl8169_private *tp)
+{
+	struct phy_device *phydev = tp->phydev;
+
+	rtl8168g_config_eee_phy(tp);
+
+	phy_modify_paged(phydev, 0xa4a, 0x11, 0x0000, 0x0200);
+	phy_modify_paged(phydev, 0xa42, 0x14, 0x0000, 0x0080);
+}
+
 static void rtl8169s_hw_phy_config(struct rtl8169_private *tp)
 {
 	static const struct phy_reg phy_reg_init[] = {
@@ -3283,7 +3293,7 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(tp->phydev, 0x0a44, 0x11, BIT(7), 0);
 
 	rtl8168g_disable_aldps(tp);
-	rtl8168g_config_eee_phy(tp);
+	rtl8168h_config_eee_phy(tp);
 	rtl_enable_eee(tp);
 }
 
-- 
2.22.1

