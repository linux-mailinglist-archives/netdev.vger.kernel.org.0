Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A0421F65B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgGNPqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgGNPqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 11:46:10 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9197FC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:46:10 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p20so22509044ejd.13
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C/cTyabzElBsFKfNgBGGyQzIIrt1XiZ9dI2mJEm2guI=;
        b=Zd/LXKDlqHX42d2zsKrgD0xfVDw9Wruhz00mL6mwFOwq6mz93vnrlTH88K79CVki/u
         jpkFBWS0UJisXmM+4zAJ04eDfy8Bra2/dgu2gxedynuIjObNTfdcilxAUswPMLUXXEpB
         96xCuakI7KkT5csdp7sV2PjJ588REqEJ1CHoZRpVO3zMqhZmWdzuS0m3cq4jX3GtAQUP
         MEFngJDxhjUj3Hjwpem02pb+TpTzfLynDC5lsnrRwT8YXjuNKuzZvoXLNvCaDyeKZBbZ
         lxQClcQ9w2X1dmR80bZNsO0ME94V44dZuB62fAjNqtcGd7GoL3FaChqRLDu8HV+lPyXu
         VTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C/cTyabzElBsFKfNgBGGyQzIIrt1XiZ9dI2mJEm2guI=;
        b=kHH05SPLpn4oBpcRKOnROSvKOqjgUUg0L18Q7i8g7tcOoIhaQslbcVKIe5v4GGGiLM
         /CLnc5PRCERWWrfDx2cZ6ePc1Rxgs0w0b0LCeSB/81jzlMp0JD4Y5V0RUcAT17jzwjNR
         aEDFpJ6I+1eucTxXsLI+DGF9ohWlGBGtJ2jEHfJwwbDvpndli7DwdZ+IIxmGsfZ2J4qk
         FG0GlmQOysXIE6+CKQCC94Bfux5+Y/y4MBk1KyX631WtUUApvxRkrAI+WGfhQ8ochtvk
         8Gox3r/HDyj8j2TMeltx2H5bMZbOxyQlMf909p4aSTop3yw8NXhnEW2JLp/UUswx8inu
         mAfA==
X-Gm-Message-State: AOAM532kIHn3/35nrJFUPN2v8R+hruMSHHDmFSOhpGM4QTKkFua9PA8I
        /OzprWFZXSoxSCzCobUwQmlwDofj4TA=
X-Google-Smtp-Source: ABdhPJx0Qpq13b0f5imFcJFY3yv2vkhg4hST4ES29pxpWOIN549Lm5x+C0aGm4Xup62LalOTKpQQgA==
X-Received: by 2002:a17:906:c452:: with SMTP id ck18mr5307105ejb.415.1594741568820;
        Tue, 14 Jul 2020 08:46:08 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b47b:7b5:8aff:5077? (p200300ea8f235700b47b07b58aff5077.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b47b:7b5:8aff:5077])
        by smtp.googlemail.com with ESMTPSA id dh16sm14903650edb.3.2020.07.14.08.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 08:46:08 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: add support for RTL8125B
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1cf79621-63ab-0886-3a23-2c9b3625c23f@gmail.com>
Message-ID: <d0d1bb3b-28c9-c3ce-066e-8a642abae16a@gmail.com>
Date:   Tue, 14 Jul 2020 17:46:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1cf79621-63ab-0886-3a23-2c9b3625c23f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for RTL8125B rev.b. In my tests 2.5Gbps worked well
w/o firmware, however for a stable link at 1Gbps firmware revision
0.0.2 is needed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h          |   1 +
 drivers/net/ethernet/realtek/r8169_main.c     | 110 ++++++++++++++----
 .../net/ethernet/realtek/r8169_phy_config.c   |  53 +++++++++
 3 files changed, 141 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 422a8e5a8..7be86ef5a 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -65,6 +65,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_52,
 	RTL_GIGA_MAC_VER_60,
 	RTL_GIGA_MAC_VER_61,
+	RTL_GIGA_MAC_VER_63,
 	RTL_GIGA_MAC_NONE
 };
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 745e1739e..975f5c10b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -56,6 +56,7 @@
 #define FIRMWARE_8107E_1	"rtl_nic/rtl8107e-1.fw"
 #define FIRMWARE_8107E_2	"rtl_nic/rtl8107e-2.fw"
 #define FIRMWARE_8125A_3	"rtl_nic/rtl8125a-3.fw"
+#define FIRMWARE_8125B_2	"rtl_nic/rtl8125b-2.fw"
 
 /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
    The RTL chips use a 64 element hash table based on the Ethernet CRC. */
@@ -146,6 +147,8 @@ static const struct {
 	[RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
 	[RTL_GIGA_MAC_VER_60] = {"RTL8125A"				},
 	[RTL_GIGA_MAC_VER_61] = {"RTL8125A",		FIRMWARE_8125A_3},
+	/* reserve 62 for CFG_METHOD_4 in the vendor driver */
+	[RTL_GIGA_MAC_VER_63] = {"RTL8125B",		FIRMWARE_8125B_2},
 };
 
 static const struct pci_device_id rtl8169_pci_tbl[] = {
@@ -335,6 +338,7 @@ enum rtl8125_registers {
 	IntrStatus_8125		= 0x3c,
 	TxPoll_8125		= 0x90,
 	MAC0_BKP		= 0x19e0,
+	EEE_TXIDLE_TIMER_8125	= 0x6048,
 };
 
 #define RX_VLAN_INNER_8125	BIT(22)
@@ -655,6 +659,7 @@ MODULE_FIRMWARE(FIRMWARE_8168FP_3);
 MODULE_FIRMWARE(FIRMWARE_8107E_1);
 MODULE_FIRMWARE(FIRMWARE_8107E_2);
 MODULE_FIRMWARE(FIRMWARE_8125A_3);
+MODULE_FIRMWARE(FIRMWARE_8125B_2);
 
 static inline struct device *tp_to_dev(struct rtl8169_private *tp)
 {
@@ -966,7 +971,7 @@ static void rtl_writephy(struct rtl8169_private *tp, int location, int val)
 	case RTL_GIGA_MAC_VER_31:
 		r8168dp_2_mdio_write(tp, location, val);
 		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_63:
 		r8168g_mdio_write(tp, location, val);
 		break;
 	default:
@@ -983,7 +988,7 @@ static int rtl_readphy(struct rtl8169_private *tp, int location)
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		return r8168dp_2_mdio_read(tp, location);
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_63:
 		return r8168g_mdio_read(tp, location);
 	default:
 		return r8169_mdio_read(tp, location);
@@ -1389,7 +1394,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		break;
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_37:
-	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_63:
 		options = RTL_R8(tp, Config2) & ~PME_SIGNAL;
 		if (wolopts)
 			options |= PME_SIGNAL;
@@ -1935,7 +1940,10 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		u16 val;
 		enum mac_version ver;
 	} mac_info[] = {
-		/* 8125 family. */
+		/* 8125B family. */
+		{ 0x7cf, 0x641,	RTL_GIGA_MAC_VER_63 },
+
+		/* 8125A family. */
 		{ 0x7cf, 0x608,	RTL_GIGA_MAC_VER_60 },
 		{ 0x7c8, 0x608,	RTL_GIGA_MAC_VER_61 },
 
@@ -2073,6 +2081,17 @@ static void rtl8125a_config_eee_mac(struct rtl8169_private *tp)
 	r8168_mac_ocp_modify(tp, 0xeb62, 0, BIT(2) | BIT(1));
 }
 
+static void rtl8125_set_eee_txidle_timer(struct rtl8169_private *tp)
+{
+	RTL_W16(tp, EEE_TXIDLE_TIMER_8125, tp->dev->mtu + ETH_HLEN + 0x20);
+}
+
+static void rtl8125b_config_eee_mac(struct rtl8169_private *tp)
+{
+	rtl8125_set_eee_txidle_timer(tp);
+	r8168_mac_ocp_modify(tp, 0xe040, 0, BIT(1) | BIT(0));
+}
+
 static void rtl_rar_exgmac_set(struct rtl8169_private *tp, u8 *addr)
 {
 	const u16 w[] = {
@@ -2174,7 +2193,7 @@ static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_32:
 	case RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_63:
 		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
 			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
 		break;
@@ -2208,11 +2227,7 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_46:
 	case RTL_GIGA_MAC_VER_47:
 	case RTL_GIGA_MAC_VER_48:
-	case RTL_GIGA_MAC_VER_50:
-	case RTL_GIGA_MAC_VER_51:
-	case RTL_GIGA_MAC_VER_52:
-	case RTL_GIGA_MAC_VER_60:
-	case RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_63:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
 		break;
 	case RTL_GIGA_MAC_VER_40:
@@ -2244,11 +2259,7 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_46:
 	case RTL_GIGA_MAC_VER_47:
 	case RTL_GIGA_MAC_VER_48:
-	case RTL_GIGA_MAC_VER_50:
-	case RTL_GIGA_MAC_VER_51:
-	case RTL_GIGA_MAC_VER_52:
-	case RTL_GIGA_MAC_VER_60:
-	case RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_63:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
 		break;
 	case RTL_GIGA_MAC_VER_40:
@@ -2279,7 +2290,7 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
 		break;
-	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
 		RTL_W32(tp, RxConfig, RX_FETCH_DFLT_8125 | RX_DMA_BURST);
 		break;
 	default:
@@ -2442,6 +2453,12 @@ DECLARE_RTL_COND(rtl_rxtx_empty_cond)
 	return (RTL_R8(tp, MCU) & RXTX_EMPTY) == RXTX_EMPTY;
 }
 
+DECLARE_RTL_COND(rtl_rxtx_empty_cond_2)
+{
+	/* IntrMitigate has new functionality on RTL8125 */
+	return (RTL_R16(tp, IntrMitigate) & 0x0103) == 0x0103;
+}
+
 static void rtl_wait_txrx_fifo_empty(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
@@ -2452,6 +2469,11 @@ static void rtl_wait_txrx_fifo_empty(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
 		rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42);
 		break;
+	case RTL_GIGA_MAC_VER_63:
+		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
+		rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42);
+		rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond_2, 100, 42);
+		break;
 	default:
 		break;
 	}
@@ -3523,18 +3545,27 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 	/* disable new tx descriptor format */
 	r8168_mac_ocp_modify(tp, 0xeb58, 0x0001, 0x0000);
 
-	r8168_mac_ocp_modify(tp, 0xe614, 0x0700, 0x0400);
-	r8168_mac_ocp_modify(tp, 0xe63e, 0x0c30, 0x0020);
+	if (tp->mac_version == RTL_GIGA_MAC_VER_63)
+		r8168_mac_ocp_modify(tp, 0xe614, 0x0700, 0x0200);
+	else
+		r8168_mac_ocp_modify(tp, 0xe614, 0x0700, 0x0400);
+
+	if (tp->mac_version == RTL_GIGA_MAC_VER_63)
+		r8168_mac_ocp_modify(tp, 0xe63e, 0x0c30, 0x0000);
+	else
+		r8168_mac_ocp_modify(tp, 0xe63e, 0x0c30, 0x0020);
+
 	r8168_mac_ocp_modify(tp, 0xc0b4, 0x0000, 0x000c);
 	r8168_mac_ocp_modify(tp, 0xeb6a, 0x00ff, 0x0033);
 	r8168_mac_ocp_modify(tp, 0xeb50, 0x03e0, 0x0040);
 	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0030);
 	r8168_mac_ocp_modify(tp, 0xe040, 0x1000, 0x0000);
+	r8168_mac_ocp_modify(tp, 0xea1c, 0x0003, 0x0001);
 	r8168_mac_ocp_modify(tp, 0xe0c0, 0x4f0f, 0x4403);
-	r8168_mac_ocp_modify(tp, 0xe052, 0x0080, 0x0067);
+	r8168_mac_ocp_modify(tp, 0xe052, 0x0080, 0x0068);
 	r8168_mac_ocp_modify(tp, 0xc0ac, 0x0080, 0x1f00);
 	r8168_mac_ocp_modify(tp, 0xd430, 0x0fff, 0x047f);
-	r8168_mac_ocp_modify(tp, 0xe84c, 0x0000, 0x00c0);
+
 	r8168_mac_ocp_modify(tp, 0xea1c, 0x0004, 0x0000);
 	r8168_mac_ocp_modify(tp, 0xeb54, 0x0000, 0x0001);
 	udelay(1);
@@ -3545,7 +3576,10 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 
 	rtl_loop_wait_low(tp, &rtl_mac_ocp_e00e_cond, 1000, 10);
 
-	rtl8125a_config_eee_mac(tp);
+	if (tp->mac_version == RTL_GIGA_MAC_VER_63)
+		rtl8125b_config_eee_mac(tp);
+	else
+		rtl8125a_config_eee_mac(tp);
 
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
 	udelay(10);
@@ -3617,6 +3651,26 @@ static void rtl_hw_start_8125a_2(struct rtl8169_private *tp)
 	rtl_hw_start_8125_common(tp);
 }
 
+static void rtl_hw_start_8125b(struct rtl8169_private *tp)
+{
+	static const struct ephy_info e_info_8125b[] = {
+		{ 0x0b, 0xffff, 0xa908 },
+		{ 0x1e, 0xffff, 0x20eb },
+		{ 0x4b, 0xffff, 0xa908 },
+		{ 0x5e, 0xffff, 0x20eb },
+		{ 0x22, 0x0030, 0x0020 },
+		{ 0x62, 0x0030, 0x0020 },
+	};
+
+	rtl_set_def_aspm_entry_latency(tp);
+	rtl_hw_aspm_clkreq_enable(tp, false);
+
+	rtl_ephy_init(tp, e_info_8125b);
+	rtl_hw_start_8125_common(tp);
+
+	rtl_hw_aspm_clkreq_enable(tp, true);
+}
+
 static void rtl_hw_config(struct rtl8169_private *tp)
 {
 	static const rtl_generic_fct hw_configs[] = {
@@ -3667,6 +3721,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_52] = rtl_hw_start_8117,
 		[RTL_GIGA_MAC_VER_60] = rtl_hw_start_8125a_1,
 		[RTL_GIGA_MAC_VER_61] = rtl_hw_start_8125a_2,
+		[RTL_GIGA_MAC_VER_63] = rtl_hw_start_8125b,
 	};
 
 	if (hw_configs[tp->mac_version])
@@ -3753,6 +3808,15 @@ static int rtl8169_change_mtu(struct net_device *dev, int new_mtu)
 	netdev_update_features(dev);
 	rtl_jumbo_config(tp);
 
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_63:
+		rtl8125_set_eee_txidle_timer(tp);
+		break;
+	default:
+		break;
+	}
+
 	return 0;
 }
 
@@ -3899,7 +3963,7 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
 		rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 666);
 		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_63:
 		rtl_enable_rxdvgate(tp);
 		fsleep(2000);
 		break;
@@ -5075,7 +5139,7 @@ static void rtl_hw_initialize(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
 		rtl_hw_init_8168g(tp);
 		break;
-	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
 		rtl_hw_init_8125(tp);
 		break;
 	default:
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index bc8bf48bd..913d030d7 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -97,6 +97,14 @@ static void rtl8125a_config_eee_phy(struct phy_device *phydev)
 	phy_modify_paged(phydev, 0xa6d, 0x14, 0x0010, 0x0000);
 }
 
+static void rtl8125b_config_eee_phy(struct phy_device *phydev)
+{
+	phy_modify_paged(phydev, 0xa6d, 0x12, 0x0001, 0x0000);
+	phy_modify_paged(phydev, 0xa6d, 0x14, 0x0010, 0x0000);
+	phy_modify_paged(phydev, 0xa42, 0x14, 0x0080, 0x0000);
+	phy_modify_paged(phydev, 0xa4a, 0x11, 0x0200, 0x0000);
+}
+
 static void rtl8169s_hw_phy_config(struct rtl8169_private *tp,
 				   struct phy_device *phydev)
 {
@@ -1147,6 +1155,11 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
 	rtl_writephy_batch(phydev, phy_reg_init);
 }
 
+static void rtl8125_legacy_force_mode(struct phy_device *phydev)
+{
+	phy_modify_paged(phydev, 0xa5b, 0x12, BIT(15), 0);
+}
+
 static void rtl8125a_1_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
@@ -1250,6 +1263,45 @@ static void rtl8125a_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl8125a_config_eee_phy(phydev);
 }
 
+static void rtl8125b_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
+{
+	r8169_apply_firmware(tp);
+
+	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+	phy_modify_paged(phydev, 0xac4, 0x13, 0x00f0, 0x0090);
+	phy_modify_paged(phydev, 0xad3, 0x10, 0x0003, 0x0001);
+
+	phy_write(phydev, 0x1f, 0x0b87);
+	phy_write(phydev, 0x16, 0x80f5);
+	phy_write(phydev, 0x17, 0x760e);
+	phy_write(phydev, 0x16, 0x8107);
+	phy_write(phydev, 0x17, 0x360e);
+	phy_write(phydev, 0x16, 0x8551);
+	phy_modify(phydev, 0x17, 0xff00, 0x0800);
+	phy_write(phydev, 0x1f, 0x0000);
+
+	phy_modify_paged(phydev, 0xbf0, 0x10, 0xe000, 0xa000);
+	phy_modify_paged(phydev, 0xbf4, 0x13, 0x0f00, 0x0300);
+
+	r8168g_phy_param(phydev, 0x8044, 0xffff, 0x2417);
+	r8168g_phy_param(phydev, 0x804a, 0xffff, 0x2417);
+	r8168g_phy_param(phydev, 0x8050, 0xffff, 0x2417);
+	r8168g_phy_param(phydev, 0x8056, 0xffff, 0x2417);
+	r8168g_phy_param(phydev, 0x805c, 0xffff, 0x2417);
+	r8168g_phy_param(phydev, 0x8062, 0xffff, 0x2417);
+	r8168g_phy_param(phydev, 0x8068, 0xffff, 0x2417);
+	r8168g_phy_param(phydev, 0x806e, 0xffff, 0x2417);
+	r8168g_phy_param(phydev, 0x8074, 0xffff, 0x2417);
+	r8168g_phy_param(phydev, 0x807a, 0xffff, 0x2417);
+
+	phy_modify_paged(phydev, 0xa4c, 0x15, 0x0000, 0x0040);
+	phy_modify_paged(phydev, 0xbf8, 0x12, 0xe000, 0xa000);
+
+	rtl8125_legacy_force_mode(phydev);
+	rtl8125b_config_eee_phy(phydev);
+}
+
 void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 			 enum mac_version ver)
 {
@@ -1308,6 +1360,7 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_52] = rtl8117_hw_phy_config,
 		[RTL_GIGA_MAC_VER_60] = rtl8125a_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_61] = rtl8125a_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_63] = rtl8125b_hw_phy_config,
 	};
 
 	if (phy_configs[ver])
-- 
2.27.0


