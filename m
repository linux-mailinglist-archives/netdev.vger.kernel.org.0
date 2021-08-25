Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9903F7A89
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240825AbhHYQaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhHYQap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:30:45 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5335AC061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:29:59 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id i6so214408wrv.2
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+xXQw0+LXWT/Zbq0+/xrdK+1DY3e3iqItvWtAzKPvig=;
        b=Um/TmMLg91mrWDMo4p077FRVCvTiid60nhjkVRt9dfZ9XwcX2a9VTGNl8NTb3kLbq3
         L6s4CzQzE01ZsIC9+mZ+VoGrYvAyv1W4Q3KQwPwGdTNJ7J6Jum677y4+Qn4+p5oOnzzj
         cJDAjA57QzsRKQCnBfWjA2Wtvp1SdIUMtYfPgDQNwmsIHwhUZ1gVsjg+Uaa3exGGU6I8
         v5gPz6dQaTl/RABUZRgi0sdsIia81lIg4/rX7eJs+8/NhDuxun4jX8LomTnmqJL52ONu
         PuvUQb9r4j+rKkPMQ6LO5yaiZ6Ra8VZBwdKc0s+xmYfPPndh+yrfLaMIzyoh3zfnBPzh
         Wkxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+xXQw0+LXWT/Zbq0+/xrdK+1DY3e3iqItvWtAzKPvig=;
        b=tWkw3bPHuwue0NsvlyR/E45BaSZZBpt7g3KVO8P5Tci5ApHunQHZvvSYyZ0GGGhFqx
         Dm8Y8LKqxbT0+Iy+ux1NR4IGcCLCEL7+B7YHxVwEpkeL+J+JYQtgQA9QlM+qWMvqptm/
         fJVtvvv63TdqkHvw/Hp6Qcc40z543dbilYtvMH3mfLjWdYRalWuhkZr5R7PYRF1jIC1j
         EsCPHNNKTLCJRciXVljAhRFpm56EUOpa3wQ1t/XiuVf+SPc8OquHs2HU7eH+VAwd0qpZ
         axa3+XYzUto+PSifOv0m6znlSxzaOiuSMaetlajzadjj+wBJLM3cPDikAM0npwSI3TNz
         zb+A==
X-Gm-Message-State: AOAM532sD1qxztTcEAgsdYG2o5QJEobK6OZeJmb87DpAiLM2+TI0uE+K
        1Pe5P4Xthq3WeVTUJRin6jonO/COfBQ2zA==
X-Google-Smtp-Source: ABdhPJwNNTJidMEql3rgQeA4IpGjuc1SYPS+daYwvIal3S/+ej8F5eFVppb9+lGX5u9Y9/uuh20D6A==
X-Received: by 2002:adf:dd11:: with SMTP id a17mr26138144wrm.132.1629908997543;
        Wed, 25 Aug 2021 09:29:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:852f:c82:dc0c:90b8? (p200300ea8f084500852f0c82dc0c90b8.dip0.t-ipconnect.de. [2003:ea:8f08:4500:852f:c82:dc0c:90b8])
        by smtp.googlemail.com with ESMTPSA id m4sm5961723wml.28.2021.08.25.09.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:29:57 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: add rtl_enable_exit_l1
Message-ID: <789e3560-4c6d-6906-d6d4-2a419bab0054@gmail.com>
Date:   Wed, 25 Aug 2021 18:29:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a function for what has been magic register writes so far.
It's based on recent changes to vendor drivers r8101, r8168, r8125,
and deals with events that trigger an early ASPM L1 exit.
Description of the bits has been kindly provided by Realtek.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 41 +++++++++++++++++------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9ea59efd0..0b2b0b249 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2663,6 +2663,34 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Rdy_to_L23);
 }
 
+static void rtl_enable_exit_l1(struct rtl8169_private *tp)
+{
+	/* Bits control which events trigger ASPM L1 exit:
+	 * Bit 12: rxdv
+	 * Bit 11: ltr_msg
+	 * Bit 10: txdma_poll
+	 * Bit  9: xadm
+	 * Bit  8: pktavi
+	 * Bit  7: txpla
+	 */
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_36:
+		rtl_eri_set_bits(tp, 0xd4, 0x1f00);
+		break;
+	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_38:
+		rtl_eri_set_bits(tp, 0xd4, 0x0c00);
+		break;
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
+		rtl_eri_set_bits(tp, 0xd4, 0x1f80);
+		break;
+	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+		r8168_mac_ocp_modify(tp, 0xc0ac, 0, 0x1f80);
+		break;
+	default:
+		break;
+	}
+}
+
 static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
 	/* Don't enable ASPM in the chip if OS can't control ASPM */
@@ -2851,7 +2879,6 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_1111, 0x0000);
 	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
-	rtl_eri_set_bits(tp, 0x0d4, 0x1f00);
 	rtl_eri_set_bits(tp, 0x1d0, BIT(1));
 	rtl_reset_packet_filter(tp);
 	rtl_eri_set_bits(tp, 0x1b0, BIT(4));
@@ -2908,8 +2935,6 @@ static void rtl_hw_start_8168f_1(struct rtl8169_private *tp)
 	rtl_hw_start_8168f(tp);
 
 	rtl_ephy_init(tp, e_info_8168f_1);
-
-	rtl_eri_set_bits(tp, 0x0d4, 0x1f00);
 }
 
 static void rtl_hw_start_8411(struct rtl8169_private *tp)
@@ -2926,8 +2951,6 @@ static void rtl_hw_start_8411(struct rtl8169_private *tp)
 	rtl_pcie_state_l2l3_disable(tp);
 
 	rtl_ephy_init(tp, e_info_8168f_1);
-
-	rtl_eri_set_bits(tp, 0x0d4, 0x0c00);
 }
 
 static void rtl_hw_start_8168g(struct rtl8169_private *tp)
@@ -2944,7 +2967,6 @@ static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
-	rtl_eri_set_bits(tp, 0x0d4, 0x1f80);
 
 	rtl8168_config_eee_mac(tp);
 
@@ -3175,7 +3197,6 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 	rtl_reset_packet_filter(tp);
 
-	rtl_eri_set_bits(tp, 0xd4, 0x1f00);
 	rtl_eri_set_bits(tp, 0xdc, 0x001c);
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
@@ -3229,8 +3250,6 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 
 	rtl_reset_packet_filter(tp);
 
-	rtl_eri_set_bits(tp, 0xd4, 0x1f80);
-
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
@@ -3332,7 +3351,7 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 
 	rtl_reset_packet_filter(tp);
 
-	rtl_eri_set_bits(tp, 0xd4, 0x1f90);
+	rtl_eri_set_bits(tp, 0xd4, 0x0010);
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
@@ -3563,7 +3582,6 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 	r8168_mac_ocp_modify(tp, 0xea1c, 0x0003, 0x0001);
 	r8168_mac_ocp_modify(tp, 0xe0c0, 0x4f0f, 0x4403);
 	r8168_mac_ocp_modify(tp, 0xe052, 0x0080, 0x0068);
-	r8168_mac_ocp_modify(tp, 0xc0ac, 0x0080, 0x1f00);
 	r8168_mac_ocp_modify(tp, 0xd430, 0x0fff, 0x047f);
 
 	r8168_mac_ocp_modify(tp, 0xea1c, 0x0004, 0x0000);
@@ -3786,6 +3804,7 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	else
 		rtl_hw_start_8168(tp);
 
+	rtl_enable_exit_l1(tp);
 	rtl_set_rx_max_size(tp);
 	rtl_set_rx_tx_desc_registers(tp);
 	rtl_lock_config_regs(tp);
-- 
2.33.0

