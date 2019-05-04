Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD00D13AD6
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfEDPNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 11:13:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37652 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfEDPNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 11:13:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id y5so10012113wma.2
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 08:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=J8zvUyDim4AJFSfdnjmRgokHPgxrGCqjuVbJobYBeKI=;
        b=DNmvS5GRzM4EXwrYnLXvr2WehAM8lmVlYRY3MPe8Ehzdj/q8XNYsgtY0CRb6yij4w3
         DIjEhXa5zJHOuwDk/Z9RPFo+zZVS4PjjoAi5pL9NbRMCgQ9OZI/nl2gBQkOxBQ3c00cB
         nlxmBUBIIj6YVP5/JfOifNA56DYlNMcBf6EECfiG9TpWYRvRdmTmrNAgooTCzRWdwOOI
         GEUPkcUATEJlZlqOMCfKHA03ke13PUIwbPuAz5ThZskDMvD57Bbr5HQhrYjBcdNSw6BX
         0YcwFJ2rawQmcHv19YYlsooQMQ66TUbS9P1OlMwgVzMoLS5SscssnAUqi/L+2OUC7JxY
         UxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=J8zvUyDim4AJFSfdnjmRgokHPgxrGCqjuVbJobYBeKI=;
        b=LqJ4jLrg9jlHbmw+kLg13rwPztkQ80ehijPEZApaT1bcgg11wEznQPOLR8e3aNDf8H
         Cabsuo0hU+uh4sa5iNnfwJLL1p/QgKt6qiYf+QaLG0MNwKnNFC1zFVJ1uPOs9Gj7K1NB
         amE1TBNDBEtiTW0RIwTtirx+zUMiY9NXvSA6PxZuiJWGBLG3RNChPbnTC4wGLU0qTxoO
         gI8Udna+7yQTPdhMo7wa4Ii0kbL/OzGcdBpv9qusAb78daBc7FadnpEyjbspnmjNODDX
         rP/WwebSYHtMUMUcTrkgUrkP/W7HWL5xwc7Biuhx0bMi8ZjGujgnyFXlTQrK8S38xShs
         VPrw==
X-Gm-Message-State: APjAAAWIulKYQb7YJV7fZniCMLp+WYRynHkloAOX1JkxrCJJXEU0vBv+
        E/VtsCi72l3Gbh5EtBUNV1VpeMVGOCA=
X-Google-Smtp-Source: APXvYqxe8WghgGaQgLp2RiDMeoJSj4eEzUnVcB2Av1p8SvAPNZv5iAgmy3jH0n458X6j5YIigVuOjg==
X-Received: by 2002:a1c:4c14:: with SMTP id z20mr9916899wmf.116.1556982794962;
        Sat, 04 May 2019 08:13:14 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:4cd8:8005:fc98:c429? (p200300EA8BD457004CD88005FC98C429.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:4cd8:8005:fc98:c429])
        by smtp.googlemail.com with ESMTPSA id s12sm4079964wmj.42.2019.05.04.08.13.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 08:13:14 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: move EEE LED config to rtl8168_config_eee_mac
Message-ID: <f5590aac-fc8e-3ca1-f3e0-c31e83ae58db@gmail.com>
Date:   Sat, 4 May 2019 17:13:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move adjusting the EEE LED frequency to rtl8168_config_eee_mac.
Exclude RTL8411 (version 38) like in the existing code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index c1128cff4..75c99c392 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -2553,6 +2553,10 @@ static void rtl_apply_firmware_cond(struct rtl8169_private *tp, u8 reg, u16 val)
 
 static void rtl8168_config_eee_mac(struct rtl8169_private *tp)
 {
+	/* Adjust EEE LED frequency */
+	if (tp->mac_version != RTL_GIGA_MAC_VER_38)
+		RTL_W8(tp, EEE_LED, RTL_R8(tp, EEE_LED) & ~0x07);
+
 	rtl_eri_set_bits(tp, 0x1b0, ERIAR_MASK_1111, 0x0003);
 }
 
@@ -4991,9 +4995,6 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
 
-	/* Adjust EEE LED frequency */
-	RTL_W8(tp, EEE_LED, RTL_R8(tp, EEE_LED) & ~0x07);
-
 	rtl8168_config_eee_mac(tp);
 
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) | PFM_EN);
@@ -5045,9 +5046,6 @@ static void rtl_hw_start_8168f_1(struct rtl8169_private *tp)
 	rtl_ephy_init(tp, e_info_8168f_1);
 
 	rtl_w0w1_eri(tp, 0x0d4, ERIAR_MASK_0011, 0x0c00, 0xff00);
-
-	/* Adjust EEE LED frequency */
-	RTL_W8(tp, EEE_LED, RTL_R8(tp, EEE_LED) & ~0x07);
 }
 
 static void rtl_hw_start_8411(struct rtl8169_private *tp)
@@ -5087,9 +5085,6 @@ static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
 
-	/* Adjust EEE LED frequency */
-	RTL_W8(tp, EEE_LED, RTL_R8(tp, EEE_LED) & ~0x07);
-
 	rtl8168_config_eee_mac(tp);
 
 	rtl_w0w1_eri(tp, 0x2fc, ERIAR_MASK_0001, 0x01, 0x06);
@@ -5190,9 +5185,6 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
 
-	/* Adjust EEE LED frequency */
-	RTL_W8(tp, EEE_LED, RTL_R8(tp, EEE_LED) & ~0x07);
-
 	rtl8168_config_eee_mac(tp);
 
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
@@ -5271,9 +5263,6 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
 
-	/* Adjust EEE LED frequency */
-	RTL_W8(tp, EEE_LED, RTL_R8(tp, EEE_LED) & ~0x07);
-
 	rtl8168_config_eee_mac(tp);
 
 	rtl_w0w1_eri(tp, 0x2fc, ERIAR_MASK_0001, 0x01, 0x06);
-- 
2.21.0

