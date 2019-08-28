Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2B7A0B86
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfH1U3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:29:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40640 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfH1U3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:29:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id c3so1103387wrd.7
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FCsM4eiq4nnr15cZS0T9CEdwdsOBmsmuabQUwpGZKHk=;
        b=ZmlR0Tnp2ukKKodGoQSjTWTpoqhEbsapXUe0XRBTtSJloAl+xY6cCvlOTHUJxOVCeL
         zvUmkKO+2J2TkLhxnOn9hFfQsLGmUdi+7Zk5mEZpcRAKZNUTfhO0BsfUjNnPCQXfIM2p
         E7AlyPRO2XePy0J7OvwiF1hGSvKCDxjGIGHfCoAfIoqRpcry2k2q+gmpKPPeEQh8ZOmy
         fH18QP+KRNlsWYJohwxvqFxsIR7oXuwagrZf+VNMVKI+1nN1SkRus/YfIhmP45KzGNdO
         xuCbQlTUPf0uyGXrYLYOpfRXCBbPSHymAEpjUtUL6JFLxNQVOfZih8IdAeeyvsr9lP1r
         RMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FCsM4eiq4nnr15cZS0T9CEdwdsOBmsmuabQUwpGZKHk=;
        b=ar52VekPqBQAr9BJwNnlKFJcMtB1bYr0BSEiXT1yyDCtybeycImIX18nSCAoPY6VGZ
         5TnXgH//l9MM2V5uN/E14RwIP1Y7FAysim9rvz7Z0ghh4NZ0FgMZ7H/UOnn70dEpIFkM
         rEUM0UIive1GkpaYaaceBGZr6uQaoMgdXYOF0JCAXVwMXiyqj0FSwcLPmorAPEAZRMVt
         E7rtbMx6Mq5+XoApqxqn202cj7NHOCm2FMmMZ4RCccqoPLlVEvnp5TnWM30j3XViGgzB
         0Y6D1o+3cYf5oZC7vnTlM7joL2yim9DRa24IEdJKFMVyOSsvtuquRSAbVFfAGrk/+g11
         61ig==
X-Gm-Message-State: APjAAAXTREAurR/lKI8WzPccnZ/Xu/DyOTjuEPm1393ks+QalWa8LBq6
        M+q67cbFfdaHEf/aa8hTj7Y=
X-Google-Smtp-Source: APXvYqz6E+A0liSRJDCjzDzBH9aoWtmoaE80YnshcCFeH+np7EG45gT8+cmd6Iwp4FvyrrVmBq4oHQ==
X-Received: by 2002:adf:db49:: with SMTP id f9mr7035331wrj.112.1567024171038;
        Wed, 28 Aug 2019 13:29:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9? (p200300EA8F047C00AC08EFF5E9D677A9.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9])
        by smtp.googlemail.com with ESMTPSA id j15sm172443wrn.70.2019.08.28.13.29.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 13:29:30 -0700 (PDT)
Subject: [PATCH net-next v2 7/9] r8169: add support for RTL8125
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Message-ID: <d3f35d78-77de-6d0d-ca4d-fde346fff43d@gmail.com>
Date:   Wed, 28 Aug 2019 22:28:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for 2.5Gbps chip RTL8125, it's partially based on the
r8125 vendor driver. Tested with a Delock 89531 PCIe card against a
Netgear GS110MX Multi-Gig switch. Firmware isn't strictly needed,
but on some systems there may be compatibility issues w/o firmware.
Firmware has been submitted to linux-firmware.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/Kconfig      |   9 +-
 drivers/net/ethernet/realtek/r8169_main.c | 274 ++++++++++++++++++++--
 2 files changed, 265 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/realtek/Kconfig b/drivers/net/ethernet/realtek/Kconfig
index b18e7a91d..5e0b9d2f1 100644
--- a/drivers/net/ethernet/realtek/Kconfig
+++ b/drivers/net/ethernet/realtek/Kconfig
@@ -96,14 +96,19 @@ config 8139_OLD_RX_RESET
 	  old RX-reset behavior.  If unsure, say N.
 
 config R8169
-	tristate "Realtek 8169 gigabit ethernet support"
+	tristate "Realtek 8169/8168/8101/8125 ethernet support"
 	depends on PCI
 	select FW_LOADER
 	select CRC32
 	select PHYLIB
 	select REALTEK_PHY
 	---help---
-	  Say Y here if you have a Realtek 8169 PCI Gigabit Ethernet adapter.
+	  Say Y here if you have a Realtek Ethernet adapter belonging to
+	  the following families:
+	  RTL8169 Gigabit Ethernet
+	  RTL8168 Gigabit Ethernet
+	  RTL8101 Fast Ethernet
+	  RTL8125 2.5GBit Ethernet
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called r8169.  This is recommended.
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4489cd9f2..4d1779e39 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -135,6 +135,8 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_49,
 	RTL_GIGA_MAC_VER_50,
 	RTL_GIGA_MAC_VER_51,
+	RTL_GIGA_MAC_VER_60,
+	RTL_GIGA_MAC_VER_61,
 	RTL_GIGA_MAC_NONE
 };
 
@@ -200,6 +202,8 @@ static const struct {
 	[RTL_GIGA_MAC_VER_49] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
+	[RTL_GIGA_MAC_VER_60] = {"RTL8125"				},
+	[RTL_GIGA_MAC_VER_61] = {"RTL8125"				},
 };
 
 static const struct pci_device_id rtl8169_pci_tbl[] = {
@@ -220,6 +224,8 @@ static const struct pci_device_id rtl8169_pci_tbl[] = {
 	{ PCI_VDEVICE(USR,	0x0116) },
 	{ PCI_VENDOR_ID_LINKSYS, 0x1032, PCI_ANY_ID, 0x0024 },
 	{ 0x0001, 0x8168, PCI_ANY_ID, 0x2410 },
+	{ PCI_VDEVICE(REALTEK,	0x8125) },
+	{ PCI_VDEVICE(REALTEK,	0x3000) },
 	{}
 };
 
@@ -384,6 +390,19 @@ enum rtl8168_registers {
 #define EARLY_TALLY_EN			(1 << 16)
 };
 
+enum rtl8125_registers {
+	IntrMask_8125		= 0x38,
+	IntrStatus_8125		= 0x3c,
+	TxPoll_8125		= 0x90,
+	MAC0_BKP		= 0x19e0,
+};
+
+#define RX_VLAN_INNER_8125	BIT(22)
+#define RX_VLAN_OUTER_8125	BIT(23)
+#define RX_VLAN_8125		(RX_VLAN_INNER_8125 | RX_VLAN_OUTER_8125)
+
+#define RX_FETCH_DFLT_8125	(8 << 27)
+
 enum rtl_register_content {
 	/* InterruptStatusBits */
 	SYSErr		= 0x8000,
@@ -727,6 +746,11 @@ static void rtl_tx_performance_tweak(struct rtl8169_private *tp, u16 force)
 					   PCI_EXP_DEVCTL_READRQ, force);
 }
 
+static bool rtl_is_8125(struct rtl8169_private *tp)
+{
+	return tp->mac_version >= RTL_GIGA_MAC_VER_60;
+}
+
 static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
@@ -1023,7 +1047,7 @@ static void rtl_writephy(struct rtl8169_private *tp, int location, int val)
 	case RTL_GIGA_MAC_VER_31:
 		r8168dp_2_mdio_write(tp, location, val);
 		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_61:
 		r8168g_mdio_write(tp, location, val);
 		break;
 	default:
@@ -1040,7 +1064,7 @@ static int rtl_readphy(struct rtl8169_private *tp, int location)
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		return r8168dp_2_mdio_read(tp, location);
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_61:
 		return r8168g_mdio_read(tp, location);
 	default:
 		return r8169_mdio_read(tp, location);
@@ -1324,17 +1348,26 @@ static u8 rtl8168d_efuse_read(struct rtl8169_private *tp, int reg_addr)
 
 static u32 rtl_get_events(struct rtl8169_private *tp)
 {
-	return RTL_R16(tp, IntrStatus);
+	if (rtl_is_8125(tp))
+		return RTL_R32(tp, IntrStatus_8125);
+	else
+		return RTL_R16(tp, IntrStatus);
 }
 
 static void rtl_ack_events(struct rtl8169_private *tp, u32 bits)
 {
-	RTL_W16(tp, IntrStatus, bits);
+	if (rtl_is_8125(tp))
+		RTL_W32(tp, IntrStatus_8125, bits);
+	else
+		RTL_W16(tp, IntrStatus, bits);
 }
 
 static void rtl_irq_disable(struct rtl8169_private *tp)
 {
-	RTL_W16(tp, IntrMask, 0);
+	if (rtl_is_8125(tp))
+		RTL_W32(tp, IntrMask_8125, 0);
+	else
+		RTL_W16(tp, IntrMask, 0);
 	tp->irq_enabled = 0;
 }
 
@@ -1345,7 +1378,10 @@ static void rtl_irq_disable(struct rtl8169_private *tp)
 static void rtl_irq_enable(struct rtl8169_private *tp)
 {
 	tp->irq_enabled = 1;
-	RTL_W16(tp, IntrMask, tp->irq_mask);
+	if (rtl_is_8125(tp))
+		RTL_W32(tp, IntrMask_8125, tp->irq_mask);
+	else
+		RTL_W16(tp, IntrMask, tp->irq_mask);
 }
 
 static void rtl8169_irq_mask_and_ack(struct rtl8169_private *tp)
@@ -1410,7 +1446,6 @@ static void rtl8169_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 
 static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 {
-	unsigned int i, tmp;
 	static const struct {
 		u32 opt;
 		u16 reg;
@@ -1423,20 +1458,25 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		{ WAKE_ANY,   Config5, LanWake },
 		{ WAKE_MAGIC, Config3, MagicPacket }
 	};
+	unsigned int i, tmp = ARRAY_SIZE(cfg);
 	u8 options;
 
 	rtl_unlock_config_regs(tp);
 
 	if (rtl_is_8168evl_up(tp)) {
-		tmp = ARRAY_SIZE(cfg) - 1;
+		tmp--;
 		if (wolopts & WAKE_MAGIC)
 			rtl_eri_set_bits(tp, 0x0dc, ERIAR_MASK_0100,
 					 MagicPacket_v2);
 		else
 			rtl_eri_clear_bits(tp, 0x0dc, ERIAR_MASK_0100,
 					   MagicPacket_v2);
-	} else {
-		tmp = ARRAY_SIZE(cfg);
+	} else if (rtl_is_8125(tp)) {
+		tmp--;
+		if (wolopts & WAKE_MAGIC)
+			r8168_mac_ocp_modify(tp, 0xc0b6, 0, BIT(0));
+		else
+			r8168_mac_ocp_modify(tp, 0xc0b6, BIT(0), 0);
 	}
 
 	for (i = 0; i < tmp; i++) {
@@ -1542,6 +1582,13 @@ static int rtl8169_set_features(struct net_device *dev,
 	else
 		rx_config &= ~(AcceptErr | AcceptRunt);
 
+	if (rtl_is_8125(tp)) {
+		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+			rx_config |= RX_VLAN_8125;
+		else
+			rx_config &= ~RX_VLAN_8125;
+	}
+
 	RTL_W32(tp, RxConfig, rx_config);
 
 	if (features & NETIF_F_RXCSUM)
@@ -1549,10 +1596,12 @@ static int rtl8169_set_features(struct net_device *dev,
 	else
 		tp->cp_cmd &= ~RxChkSum;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		tp->cp_cmd |= RxVlan;
-	else
-		tp->cp_cmd &= ~RxVlan;
+	if (!rtl_is_8125(tp)) {
+		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+			tp->cp_cmd |= RxVlan;
+		else
+			tp->cp_cmd &= ~RxVlan;
+	}
 
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 	RTL_R16(tp, CPlusCmd);
@@ -1851,6 +1900,9 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	int i;
 	u16 w;
 
+	if (rtl_is_8125(tp))
+		return -EOPNOTSUPP;
+
 	memset(ec, 0, sizeof(*ec));
 
 	/* get rx/tx scale corresponding to current speed and CPlusCmd[0:1] */
@@ -1919,6 +1971,9 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	u16 w = 0, cp01;
 	int i;
 
+	if (rtl_is_8125(tp))
+		return -EOPNOTSUPP;
+
 	scale = rtl_coalesce_choose_scale(dev,
 			max(p[0].usecs, p[1].usecs) * 1000, &cp01);
 	if (IS_ERR(scale))
@@ -2065,6 +2120,10 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp)
 		u16 val;
 		u16 mac_version;
 	} mac_info[] = {
+		/* 8125 family. */
+		{ 0x7cf, 0x608,	RTL_GIGA_MAC_VER_60 },
+		{ 0x7c8, 0x608,	RTL_GIGA_MAC_VER_61 },
+
 		/* 8168EP family. */
 		{ 0x7cf, 0x502,	RTL_GIGA_MAC_VER_51 },
 		{ 0x7cf, 0x501,	RTL_GIGA_MAC_VER_50 },
@@ -3615,6 +3674,8 @@ static void rtl_hw_phy_config(struct net_device *dev)
 		[RTL_GIGA_MAC_VER_49] = rtl8168ep_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_60] = NULL,
+		[RTL_GIGA_MAC_VER_61] = NULL,
 	};
 	struct rtl8169_private *tp = netdev_priv(dev);
 
@@ -3742,6 +3803,8 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_48:
 	case RTL_GIGA_MAC_VER_50:
 	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_60:
+	case RTL_GIGA_MAC_VER_61:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
 		break;
 	case RTL_GIGA_MAC_VER_40:
@@ -3771,6 +3834,8 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_48:
 	case RTL_GIGA_MAC_VER_50:
 	case RTL_GIGA_MAC_VER_51:
+	case RTL_GIGA_MAC_VER_60:
+	case RTL_GIGA_MAC_VER_61:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
 		break;
 	case RTL_GIGA_MAC_VER_40:
@@ -3803,6 +3868,10 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
 		break;
+	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
+		RTL_W32(tp, RxConfig, RX_FETCH_DFLT_8125 | RX_VLAN_8125 |
+				      RX_DMA_BURST);
+		break;
 	default:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
 		break;
@@ -5020,6 +5089,126 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
+DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)
+{
+	return r8168_mac_ocp_read(tp, 0xe00e) & BIT(13);
+}
+
+static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
+{
+	rtl_pcie_state_l2l3_disable(tp);
+
+	RTL_W16(tp, 0x382, 0x221b);
+	RTL_W8(tp, 0x4500, 0);
+	RTL_W16(tp, 0x4800, 0);
+
+	/* disable UPS */
+	r8168_mac_ocp_modify(tp, 0xd40a, 0x0010, 0x0000);
+
+	RTL_W8(tp, Config1, RTL_R8(tp, Config1) & ~0x10);
+
+	r8168_mac_ocp_write(tp, 0xc140, 0xffff);
+	r8168_mac_ocp_write(tp, 0xc142, 0xffff);
+
+	r8168_mac_ocp_modify(tp, 0xd3e2, 0x0fff, 0x03a9);
+	r8168_mac_ocp_modify(tp, 0xd3e4, 0x00ff, 0x0000);
+	r8168_mac_ocp_modify(tp, 0xe860, 0x0000, 0x0080);
+
+	/* disable new tx descriptor format */
+	r8168_mac_ocp_modify(tp, 0xeb58, 0x0001, 0x0000);
+
+	r8168_mac_ocp_modify(tp, 0xe614, 0x0700, 0x0400);
+	r8168_mac_ocp_modify(tp, 0xe63e, 0x0c30, 0x0020);
+	r8168_mac_ocp_modify(tp, 0xc0b4, 0x0000, 0x000c);
+	r8168_mac_ocp_modify(tp, 0xeb6a, 0x00ff, 0x0033);
+	r8168_mac_ocp_modify(tp, 0xeb50, 0x03e0, 0x0040);
+	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0030);
+	r8168_mac_ocp_modify(tp, 0xe040, 0x1000, 0x0000);
+	r8168_mac_ocp_modify(tp, 0xe0c0, 0x4f0f, 0x4403);
+	r8168_mac_ocp_modify(tp, 0xe052, 0x0080, 0x0067);
+	r8168_mac_ocp_modify(tp, 0xc0ac, 0x0080, 0x1f00);
+	r8168_mac_ocp_modify(tp, 0xd430, 0x0fff, 0x047f);
+	r8168_mac_ocp_modify(tp, 0xe84c, 0x0000, 0x00c0);
+	r8168_mac_ocp_modify(tp, 0xea1c, 0x0004, 0x0000);
+	r8168_mac_ocp_modify(tp, 0xeb54, 0x0000, 0x0001);
+	udelay(1);
+	r8168_mac_ocp_modify(tp, 0xeb54, 0x0001, 0x0000);
+	RTL_W16(tp, 0x1880, RTL_R16(tp, 0x1880) & ~0x0030);
+
+	r8168_mac_ocp_write(tp, 0xe098, 0xc302);
+
+	rtl_udelay_loop_wait_low(tp, &rtl_mac_ocp_e00e_cond, 1000, 10);
+
+	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
+	udelay(10);
+}
+
+static void rtl_hw_start_8125_1(struct rtl8169_private *tp)
+{
+	static const struct ephy_info e_info_8125_1[] = {
+		{ 0x01, 0xffff, 0xa812 },
+		{ 0x09, 0xffff, 0x520c },
+		{ 0x04, 0xffff, 0xd000 },
+		{ 0x0d, 0xffff, 0xf702 },
+		{ 0x0a, 0xffff, 0x8653 },
+		{ 0x06, 0xffff, 0x001e },
+		{ 0x08, 0xffff, 0x3595 },
+		{ 0x20, 0xffff, 0x9455 },
+		{ 0x21, 0xffff, 0x99ff },
+		{ 0x02, 0xffff, 0x6046 },
+		{ 0x29, 0xffff, 0xfe00 },
+		{ 0x23, 0xffff, 0xab62 },
+
+		{ 0x41, 0xffff, 0xa80c },
+		{ 0x49, 0xffff, 0x520c },
+		{ 0x44, 0xffff, 0xd000 },
+		{ 0x4d, 0xffff, 0xf702 },
+		{ 0x4a, 0xffff, 0x8653 },
+		{ 0x46, 0xffff, 0x001e },
+		{ 0x48, 0xffff, 0x3595 },
+		{ 0x60, 0xffff, 0x9455 },
+		{ 0x61, 0xffff, 0x99ff },
+		{ 0x42, 0xffff, 0x6046 },
+		{ 0x69, 0xffff, 0xfe00 },
+		{ 0x63, 0xffff, 0xab62 },
+	};
+
+	rtl_set_def_aspm_entry_latency(tp);
+
+	/* disable aspm and clock request before access ephy */
+	rtl_hw_aspm_clkreq_enable(tp, false);
+	rtl_ephy_init(tp, e_info_8125_1);
+
+	rtl_hw_start_8125_common(tp);
+}
+
+static void rtl_hw_start_8125_2(struct rtl8169_private *tp)
+{
+	static const struct ephy_info e_info_8125_2[] = {
+		{ 0x04, 0xffff, 0xd000 },
+		{ 0x0a, 0xffff, 0x8653 },
+		{ 0x23, 0xffff, 0xab66 },
+		{ 0x20, 0xffff, 0x9455 },
+		{ 0x21, 0xffff, 0x99ff },
+		{ 0x29, 0xffff, 0xfe04 },
+
+		{ 0x44, 0xffff, 0xd000 },
+		{ 0x4a, 0xffff, 0x8653 },
+		{ 0x63, 0xffff, 0xab66 },
+		{ 0x60, 0xffff, 0x9455 },
+		{ 0x61, 0xffff, 0x99ff },
+		{ 0x69, 0xffff, 0xfe04 },
+	};
+
+	rtl_set_def_aspm_entry_latency(tp);
+
+	/* disable aspm and clock request before access ephy */
+	rtl_hw_aspm_clkreq_enable(tp, false);
+	rtl_ephy_init(tp, e_info_8125_2);
+
+	rtl_hw_start_8125_common(tp);
+}
+
 static void rtl_hw_config(struct rtl8169_private *tp)
 {
 	static const rtl_generic_fct hw_configs[] = {
@@ -5068,12 +5257,25 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_49] = rtl_hw_start_8168ep_1,
 		[RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
 		[RTL_GIGA_MAC_VER_51] = rtl_hw_start_8168ep_3,
+		[RTL_GIGA_MAC_VER_60] = rtl_hw_start_8125_1,
+		[RTL_GIGA_MAC_VER_61] = rtl_hw_start_8125_2,
 	};
 
 	if (hw_configs[tp->mac_version])
 		hw_configs[tp->mac_version](tp);
 }
 
+static void rtl_hw_start_8125(struct rtl8169_private *tp)
+{
+	int i;
+
+	/* disable interrupt coalescing */
+	for (i = 0xa00; i < 0xb00; i += 4)
+		RTL_W32(tp, i, 0);
+
+	rtl_hw_config(tp);
+}
+
 static void rtl_hw_start_8168(struct rtl8169_private *tp)
 {
 	if (tp->mac_version == RTL_GIGA_MAC_VER_13 ||
@@ -5127,6 +5329,8 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 
 	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
 		rtl_hw_start_8169(tp);
+	else if (rtl_is_8125(tp))
+		rtl_hw_start_8125(tp);
 	else
 		rtl_hw_start_8168(tp);
 
@@ -5510,6 +5714,14 @@ static bool rtl_chip_supports_csum_v2(struct rtl8169_private *tp)
 	}
 }
 
+static void rtl8169_doorbell(struct rtl8169_private *tp)
+{
+	if (rtl_is_8125(tp))
+		RTL_W16(tp, TxPoll_8125, BIT(0));
+	else
+		RTL_W8(tp, TxPoll, NPQ);
+}
+
 static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
@@ -5589,7 +5801,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	}
 
 	if (door_bell)
-		RTL_W8(tp, TxPoll, NPQ);
+		rtl8169_doorbell(tp);
 
 	if (unlikely(stop_queue)) {
 		/* Sync with rtl_tx:
@@ -5751,7 +5963,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		 * it is slow enough). -- FR
 		 */
 		if (tp->cur_tx != dirty_tx)
-			RTL_W8(tp, TxPoll, NPQ);
+			rtl8169_doorbell(tp);
 	}
 }
 
@@ -6473,6 +6685,8 @@ static void rtl_read_mac_address(struct rtl8169_private *tp,
 		value = rtl_eri_read(tp, 0xe4);
 		mac_addr[4] = (value >>  0) & 0xff;
 		mac_addr[5] = (value >>  8) & 0xff;
+	} else if (rtl_is_8125(tp)) {
+		rtl_read_mac_from_reg(tp, mac_addr, MAC0_BKP);
 	}
 }
 
@@ -6570,6 +6784,31 @@ static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 	rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
 }
 
+static void rtl_hw_init_8125(struct rtl8169_private *tp)
+{
+	tp->ocp_base = OCP_STD_PHY_BASE;
+
+	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
+
+	if (!rtl_udelay_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42))
+		return;
+
+	RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) & ~(CmdTxEnb | CmdRxEnb));
+	msleep(1);
+	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
+
+	r8168_mac_ocp_modify(tp, 0xe8de, BIT(14), 0);
+
+	if (!rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42))
+		return;
+
+	r8168_mac_ocp_write(tp, 0xc0aa, 0x07d0);
+	r8168_mac_ocp_write(tp, 0xc0a6, 0x0150);
+	r8168_mac_ocp_write(tp, 0xc01e, 0x5555);
+
+	rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
+}
+
 static void rtl_hw_initialize(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
@@ -6579,6 +6818,9 @@ static void rtl_hw_initialize(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
 		rtl_hw_init_8168g(tp);
 		break;
+	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
+		rtl_hw_init_8125(tp);
+		break;
 	default:
 		break;
 	}
-- 
2.23.0


