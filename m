Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927A6CF236
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 07:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbfJHFkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 01:40:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40343 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729568AbfJHFkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 01:40:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so1650241wmj.5
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 22:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=LM5N4gRwIgT1wcwK964qnmWrI152FoeR3PxstTOkVpA=;
        b=KCbmOARjOaL8ovTzCqa3eg/r8Qn14Vyf52JYS99Yr+T3mT279BaZKAFpgIk8gMMs+e
         gysLmEAqBcZ1kUJ/BF6FU1E/i2oYeOgE5g3yARP9L9t2eLFdzRB9uv1PwxuozIvkF9la
         xDftOVLtl7SBibdRMKxXaBNaUo2GpVgEbmULeS/DkfAEYAIhtGTqcynZpLXwnkV8Uxgj
         Kjpl5QlWTmpdST2Lf6hMlTvQdWIJpgFZiACgVPYzo9qTpT0bCA4eUYhcWY0dsCkaHKoM
         ohTxE5T9B+81pEdq56fqqhUCXyddXLm0DUiV+jFXbKbGtq9+jSzRU9k+/2XUwQfZpaum
         /QYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=LM5N4gRwIgT1wcwK964qnmWrI152FoeR3PxstTOkVpA=;
        b=On9KT1TvDMjV/7EAR8K+o5xUBgB5FDqlq2MHxgriVKYPrE6k8VHxnu2db6BJjQMtX5
         HJX32JbVa/1oecI5OfPFtwWZ4aeyzKoOOKYYMbLnVU1HgeU5RUMxY+EdiuBeFoOlKzcC
         DmK4YQ89CxrgfpEtrDj2MKZg4UVhHQEaUrF0n7PAznoZhC++VoqhwdmELpd3phFN9E8B
         UHTANUmfI4ZgRWd+ISUAHJ4HSUYDXi5pqlLSkX5Q83smabZZSV+LYshr3xGh6pGNtrwB
         aC4SntBTckh0olVw8hKL+njNl7Jc5TkjLNvUtQbgCx1HQXCej1+JK4HBMJ+wNJgBDSb9
         VjgA==
X-Gm-Message-State: APjAAAWLh+wUmctGBfa6SbknxInorgqKYXkytabe0zOw3sWi4anqLXx4
        ySjkete8+Xyd8O8wF/gY5P72oyX3
X-Google-Smtp-Source: APXvYqyIeA73Wu3EkpDtQxJCmUwWc9wEr3eS28DXz6uvgtyR7nYQ1WvYnzhvKdqnjKCS9vcVC+cImQ==
X-Received: by 2002:a7b:cb08:: with SMTP id u8mr2361905wmj.6.1570513196906;
        Mon, 07 Oct 2019 22:39:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:2470:3e90:d7bc:9dad? (p200300EA8F26640024703E90D7BC9DAD.dip0.t-ipconnect.de. [2003:ea:8f26:6400:2470:3e90:d7bc:9dad])
        by smtp.googlemail.com with ESMTPSA id 207sm2353674wme.17.2019.10.07.22.39.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 22:39:56 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>
Subject: [PATCH RFC] r8169: add experimental RTL8117 support
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <2046ce4c-8b77-aea3-b82e-0f3e3d772038@gmail.com>
Date:   Tue, 8 Oct 2019 07:39:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds experimental support for RTL8117. This chip version is found
on the ASUS Pro WS X570-ACE board. I have no hardware to test,
therefore I'd appreciate if people owning this board could test and
provide feedback.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 165 ++++++++++++++++++++--
 1 file changed, 150 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b5694c248..b9a020c5f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -135,6 +135,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_49,
 	RTL_GIGA_MAC_VER_50,
 	RTL_GIGA_MAC_VER_51,
+	RTL_GIGA_MAC_VER_52,
 	RTL_GIGA_MAC_VER_60,
 	RTL_GIGA_MAC_VER_61,
 	RTL_GIGA_MAC_NONE
@@ -202,6 +203,7 @@ static const struct {
 	[RTL_GIGA_MAC_VER_49] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
+	[RTL_GIGA_MAC_VER_52] = {"RTL8117"				},
 	[RTL_GIGA_MAC_VER_60] = {"RTL8125"				},
 	[RTL_GIGA_MAC_VER_61] = {"RTL8125",		FIRMWARE_8125A_3},
 };
@@ -757,7 +759,7 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
 	       tp->mac_version != RTL_GIGA_MAC_VER_39 &&
-	       tp->mac_version <= RTL_GIGA_MAC_VER_51;
+	       tp->mac_version <= RTL_GIGA_MAC_VER_52;
 }
 
 static bool rtl_supports_eee(struct rtl8169_private *tp)
@@ -1256,9 +1258,7 @@ static void rtl8168_driver_start(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_31:
 		rtl8168dp_driver_start(tp);
 		break;
-	case RTL_GIGA_MAC_VER_49:
-	case RTL_GIGA_MAC_VER_50:
-	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
 		rtl8168ep_driver_start(tp);
 		break;
 	default:
@@ -1290,9 +1290,7 @@ static void rtl8168_driver_stop(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_31:
 		rtl8168dp_driver_stop(tp);
 		break;
-	case RTL_GIGA_MAC_VER_49:
-	case RTL_GIGA_MAC_VER_50:
-	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
 		rtl8168ep_driver_stop(tp);
 		break;
 	default:
@@ -1320,9 +1318,7 @@ static bool r8168_check_dash(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		return r8168dp_check_dash(tp);
-	case RTL_GIGA_MAC_VER_49:
-	case RTL_GIGA_MAC_VER_50:
-	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
 		return r8168ep_check_dash(tp);
 	default:
 		return false;
@@ -1497,7 +1493,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		break;
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_37:
-	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_52:
 		options = RTL_R8(tp, Config2) & ~PME_SIGNAL;
 		if (wolopts)
 			options |= PME_SIGNAL;
@@ -2139,6 +2135,9 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp)
 		{ 0x7cf, 0x608,	RTL_GIGA_MAC_VER_60 },
 		{ 0x7c8, 0x608,	RTL_GIGA_MAC_VER_61 },
 
+		/* RTL8117 */
+		{ 0x7cf, 0x54a,	RTL_GIGA_MAC_VER_52 },
+
 		/* 8168EP family. */
 		{ 0x7cf, 0x502,	RTL_GIGA_MAC_VER_51 },
 		{ 0x7cf, 0x501,	RTL_GIGA_MAC_VER_50 },
@@ -3568,6 +3567,71 @@ static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_enable_eee(tp);
 }
 
+static void rtl8117_hw_phy_config(struct rtl8169_private *tp)
+{
+	rtl_writephy(tp, 0x1f, 0x0a43);
+	rtl_writephy(tp, 0x13, 0x808e);
+	rtl_w0w1_phy(tp, 0x14, 0x4800, 0xff00);
+	rtl_writephy(tp, 0x13, 0x8090);
+	rtl_w0w1_phy(tp, 0x14, 0xcc00, 0xff00);
+	rtl_writephy(tp, 0x13, 0x8092);
+	rtl_w0w1_phy(tp, 0x14, 0xb000, 0xff00);
+	rtl_writephy(tp, 0x13, 0x8088);
+	rtl_w0w1_phy(tp, 0x14, 0x6000, 0xff00);
+	rtl_writephy(tp, 0x13, 0x808b);
+	rtl_w0w1_phy(tp, 0x14, 0x0b00, 0x3f00);
+	rtl_writephy(tp, 0x13, 0x808d);
+	rtl_w0w1_phy(tp, 0x14, 0x0600, 0x1f00);
+	rtl_writephy(tp, 0x13, 0x808c);
+	rtl_w0w1_phy(tp, 0x14, 0xb000, 0xff00);
+	rtl_writephy(tp, 0x13, 0x80a0);
+	rtl_w0w1_phy(tp, 0x14, 0x2800, 0xff00);
+	rtl_writephy(tp, 0x13, 0x80a2);
+	rtl_w0w1_phy(tp, 0x14, 0x5000, 0xff00);
+	rtl_writephy(tp, 0x13, 0x809b);
+	rtl_w0w1_phy(tp, 0x14, 0xb000, 0xf800);
+	rtl_writephy(tp, 0x13, 0x809a);
+	rtl_w0w1_phy(tp, 0x14, 0x4b00, 0xff00);
+	rtl_writephy(tp, 0x13, 0x809d);
+	rtl_w0w1_phy(tp, 0x14, 0x0800, 0x3f00);
+	rtl_writephy(tp, 0x13, 0x80a1);
+	rtl_w0w1_phy(tp, 0x14, 0x7000, 0xff00);
+	rtl_writephy(tp, 0x13, 0x809f);
+	rtl_w0w1_phy(tp, 0x14, 0x0300, 0x1f00);
+	rtl_writephy(tp, 0x13, 0x809e);
+	rtl_w0w1_phy(tp, 0x14, 0x8800, 0xff00);
+	rtl_writephy(tp, 0x13, 0x80b2);
+	rtl_w0w1_phy(tp, 0x14, 0x2200, 0xff00);
+	rtl_writephy(tp, 0x13, 0x80ad);
+	rtl_w0w1_phy(tp, 0x14, 0x9800, 0xf800);
+	rtl_writephy(tp, 0x13, 0x80af);
+	rtl_w0w1_phy(tp, 0x14, 0x0800, 0x3f00);
+	rtl_writephy(tp, 0x13, 0x80b3);
+	rtl_w0w1_phy(tp, 0x14, 0x6f00, 0xff00);
+	rtl_writephy(tp, 0x13, 0x80b1);
+	rtl_w0w1_phy(tp, 0x14, 0x0300, 0x1f00);
+	rtl_writephy(tp, 0x13, 0x80b0);
+	rtl_w0w1_phy(tp, 0x14, 0x9300, 0xff00);
+	rtl_writephy(tp, 0x1f, 0x0000);
+
+	rtl_writephy(tp, 0x1f, 0x0a43);
+	rtl_writephy(tp, 0x13, 0x8011);
+	rtl_w0w1_phy(tp, 0x14, 0x0800, 0x0000);
+	rtl_writephy(tp, 0x1f, 0x0000);
+
+	/* enable GPHY 10M */
+	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(11));
+
+	rtl_writephy(tp, 0x1f, 0x0a43);
+	rtl_writephy(tp, 0x13, 0x8016);
+	rtl_w0w1_phy(tp, 0x14, 0x0400, 0x0000);
+	rtl_writephy(tp, 0x1f, 0x0000);
+
+	rtl8168g_disable_aldps(tp);
+	rtl8168h_config_eee_phy(tp);
+	rtl_enable_eee(tp);
+}
+
 static void rtl8102e_hw_phy_config(struct rtl8169_private *tp)
 {
 	static const struct phy_reg phy_reg_init[] = {
@@ -3833,6 +3897,7 @@ static void rtl_hw_phy_config(struct net_device *dev)
 		[RTL_GIGA_MAC_VER_49] = rtl8168ep_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_52] = rtl8117_hw_phy_config,
 		[RTL_GIGA_MAC_VER_60] = rtl8125_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_61] = rtl8125_2_hw_phy_config,
 	};
@@ -3926,7 +3991,7 @@ static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_32:
 	case RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_52:
 		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
 			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
 		break;
@@ -3962,6 +4027,7 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_48:
 	case RTL_GIGA_MAC_VER_50:
 	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_52:
 	case RTL_GIGA_MAC_VER_60:
 	case RTL_GIGA_MAC_VER_61:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
@@ -3993,6 +4059,7 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_48:
 	case RTL_GIGA_MAC_VER_50:
 	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_52:
 	case RTL_GIGA_MAC_VER_60:
 	case RTL_GIGA_MAC_VER_61:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
@@ -4024,7 +4091,7 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_38:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
 		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
 		break;
 	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
@@ -4228,7 +4295,7 @@ static void rtl8169_hw_reset(struct rtl8169_private *tp)
 		rtl_udelay_loop_wait_low(tp, &rtl_npq_cond, 20, 42*42);
 		break;
 	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_38:
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
 		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
 		rtl_udelay_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 666);
 		break;
@@ -5125,6 +5192,73 @@ static void rtl_hw_start_8168ep_3(struct rtl8169_private *tp)
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
+static void rtl_hw_start_8117(struct rtl8169_private *tp)
+{
+	static const struct ephy_info e_info_8117[] = {
+		{ 0x19, 0x0040,	0x1100 },
+		{ 0x59, 0x0040,	0x1100 },
+	};
+	int rg_saw_cnt;
+
+	rtl8168ep_stop_cmac(tp);
+
+	/* disable aspm and clock request before access ephy */
+	rtl_hw_aspm_clkreq_enable(tp, false);
+	rtl_ephy_init(tp, e_info_8117);
+
+	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
+	rtl8168g_set_pause_thresholds(tp, 0x2f, 0x5f);
+
+	rtl_set_def_aspm_entry_latency(tp);
+
+	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
+
+	rtl_reset_packet_filter(tp);
+
+	rtl_eri_set_bits(tp, 0xd4, ERIAR_MASK_1111, 0x1f90);
+
+	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
+
+	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
+
+	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
+	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
+
+	rtl8168_config_eee_mac(tp);
+
+	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
+	RTL_W8(tp, MISC_1, RTL_R8(tp, MISC_1) & ~PFM_D3COLD_EN);
+
+	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~TX_10M_PS_EN);
+
+	rtl_eri_clear_bits(tp, 0x1b0, ERIAR_MASK_0011, BIT(12));
+
+	rtl_pcie_state_l2l3_disable(tp);
+
+	rtl_writephy(tp, 0x1f, 0x0c42);
+	rg_saw_cnt = (rtl_readphy(tp, 0x13) & 0x3fff);
+	rtl_writephy(tp, 0x1f, 0x0000);
+	if (rg_saw_cnt > 0) {
+		u16 sw_cnt_1ms_ini;
+
+		sw_cnt_1ms_ini = 16000000/rg_saw_cnt;
+		sw_cnt_1ms_ini &= 0x0fff;
+		r8168_mac_ocp_modify(tp, 0xd412, 0x0fff, sw_cnt_1ms_ini);
+	}
+
+	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0070);
+	r8168_mac_ocp_write(tp, 0xea80, 0x0003);
+	r8168_mac_ocp_modify(tp, 0xe052, 0x0000, 0x0009);
+	r8168_mac_ocp_modify(tp, 0xd420, 0x0fff, 0x047f);
+
+	r8168_mac_ocp_write(tp, 0xe63e, 0x0001);
+	r8168_mac_ocp_write(tp, 0xe63e, 0x0000);
+	r8168_mac_ocp_write(tp, 0xc094, 0x0000);
+	r8168_mac_ocp_write(tp, 0xc09e, 0x0000);
+
+	rtl_hw_aspm_clkreq_enable(tp, true);
+}
+
 static void rtl_hw_start_8102e_1(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8102e_1[] = {
@@ -5418,6 +5552,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_49] = rtl_hw_start_8168ep_1,
 		[RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
 		[RTL_GIGA_MAC_VER_51] = rtl_hw_start_8168ep_3,
+		[RTL_GIGA_MAC_VER_52] = rtl_hw_start_8117,
 		[RTL_GIGA_MAC_VER_60] = rtl_hw_start_8125_1,
 		[RTL_GIGA_MAC_VER_61] = rtl_hw_start_8125_2,
 	};
@@ -6973,7 +7108,7 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
 static void rtl_hw_initialize(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
 		rtl8168ep_stop_cmac(tp);
 		/* fall through */
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
-- 
2.23.0

