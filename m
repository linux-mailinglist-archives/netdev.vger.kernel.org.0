Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451D3FE743
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 22:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfKOVig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 16:38:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39544 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfKOVig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 16:38:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id l7so12472674wrp.6
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 13:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pQzqiO//7tq//zWmM3dPFXBEELdmrHLeAL9DXRd3X1w=;
        b=pjsErFPoaDeeono8TmURZ1LDwiqJF0D2MzxEW9c+UFTXkEI1WLMGsfok4TtK/awCco
         5g0yZFXNoWjnEFg6UQjEdPEZfUYhRh9kQvmErPATSDGQxATAn1QpsdFXX3N1tmDFElk3
         BDFaR/kIa3Bu6iv6sA+whXpfmFfz8kA1plcdd0LdkttNanh2ik5LWHsKlxILwgmEc1rM
         YbTtBopzgDKrct+gyTN8pcyz+0ic+vynBw2Mhza1SvzbIYttyL9K1XD9HlAVnVRW7XSV
         CKOcGkXiMQx2x6DzNJZ0OoFI656dVdVfRuuhr6O7b/GEwgXEmbVA/vFCzZ+yo3p4ISGR
         ainw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pQzqiO//7tq//zWmM3dPFXBEELdmrHLeAL9DXRd3X1w=;
        b=g4HkYDlSbIzBQU9vf6BUy+G84Ewhrl5P/YQHCEbrRgIvHqh6xKa2pflJg3dPFtbVW0
         x/zozcVFbmbKrxzXOZap3PuHr0f40jClPyr2OkX77TTS7+Npc4Cw+/JmI1afU6lxCDhn
         QQc481s4LUavtw/YKojWLPIuyQw3fhA+ZS2o+3V4dNXXkBKkJ7yqBjmtNOBwQHlqmvEF
         a9VkJsEMCLkG4FHSeYRugnn8LDcJrSdvrcJS+mMel6E4Pd5CrVdmHLQkhjMtDFNciycu
         fZ5AlCT+4Dhtvrp64mNl3GYv1sTcb5e8Vqz92SRqIHwUQNvMyZdVUsL4KqkRzs97QtDB
         OjGw==
X-Gm-Message-State: APjAAAX94/C17wwpsvUG5VYtZV3Y+4/4K3II4gMV1iR09kHToyTAtP8o
        0r8GVFOUwMmiDWKaqbUjEYtsODKN
X-Google-Smtp-Source: APXvYqyEPE5dfSEh4yIEdBC5ibn5TMKFVS5+y1rS4JZDQKC3sXQh4soe/gwOf1jOFJQyC2LsrEtAeA==
X-Received: by 2002:a5d:5191:: with SMTP id k17mr17342071wrv.350.1573853913198;
        Fri, 15 Nov 2019 13:38:33 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:a4ca:7f51:f03b:b2bd? (p200300EA8F2D7D00A4CA7F51F03BB2BD.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:a4ca:7f51:f03b:b2bd])
        by smtp.googlemail.com with ESMTPSA id h140sm12518815wme.22.2019.11.15.13.38.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 13:38:32 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: load firmware for RTL8168fp/RTL8117
Message-ID: <927c7de5-adbb-8f96-5f77-994c7cfa7eb0@gmail.com>
Date:   Fri, 15 Nov 2019 22:38:25 +0100
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

Load Realtek-provided firmware for RTL8168fp/RTL8117. Unlike the
firmware for other chip versions which is for the PHY, firmware for
RTL8168fp/RTL8117 is for the MAC.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
Firmware file has been submitted to linux-firmware.
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ca4aa14fc..53d39c6fe 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -52,6 +52,7 @@
 #define FIRMWARE_8168G_3	"rtl_nic/rtl8168g-3.fw"
 #define FIRMWARE_8168H_1	"rtl_nic/rtl8168h-1.fw"
 #define FIRMWARE_8168H_2	"rtl_nic/rtl8168h-2.fw"
+#define FIRMWARE_8168FP_3	"rtl_nic/rtl8168fp-3.fw"
 #define FIRMWARE_8107E_1	"rtl_nic/rtl8107e-1.fw"
 #define FIRMWARE_8107E_2	"rtl_nic/rtl8107e-2.fw"
 #define FIRMWARE_8125A_3	"rtl_nic/rtl8125a-3.fw"
@@ -203,7 +204,7 @@ static const struct {
 	[RTL_GIGA_MAC_VER_49] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
-	[RTL_GIGA_MAC_VER_52] = {"RTL8117"				},
+	[RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
 	[RTL_GIGA_MAC_VER_60] = {"RTL8125"				},
 	[RTL_GIGA_MAC_VER_61] = {"RTL8125",		FIRMWARE_8125A_3},
 };
@@ -715,6 +716,7 @@ MODULE_FIRMWARE(FIRMWARE_8168G_2);
 MODULE_FIRMWARE(FIRMWARE_8168G_3);
 MODULE_FIRMWARE(FIRMWARE_8168H_1);
 MODULE_FIRMWARE(FIRMWARE_8168H_2);
+MODULE_FIRMWARE(FIRMWARE_8168FP_3);
 MODULE_FIRMWARE(FIRMWARE_8107E_1);
 MODULE_FIRMWARE(FIRMWARE_8107E_2);
 MODULE_FIRMWARE(FIRMWARE_8125A_3);
@@ -4883,6 +4885,9 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 	r8168_mac_ocp_write(tp, 0xc094, 0x0000);
 	r8168_mac_ocp_write(tp, 0xc09e, 0x0000);
 
+	/* firmware is for MAC only */
+	rtl_apply_firmware(tp);
+
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
-- 
2.24.0

