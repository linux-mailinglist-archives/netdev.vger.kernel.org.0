Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD565409D90
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 21:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347671AbhIMT7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 15:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238454AbhIMT7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 15:59:51 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D37C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 12:58:35 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q26so16474689wrc.7
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 12:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=fynHNcg758ZnVGHVMXWB8OS8MKqYoOW+Z10p7x2uL3o=;
        b=LaEJZIpicbrLA91obSBlyJiJ/YJCDfbE0Y1VnzC++vtA8BNxUyKqRHY3IunZeapfwL
         e8xCme5WHhO3JvjuLkwsHzsFsXrEbCpHTsJAsxLuQFwtQpQ584hmJIPWlO1/8E/+xKum
         ITNs/IslE+Dcdj8Krr4mbSK00kjcKCuhzvCxgUPv5iEsvhGmPa9vJIIgW3Wy4n2aqmgL
         /TiChuUD2pWLj/xBbtNDGIsQnIfVKqTXZJlgKvX41TcwUnnylx/M5cF+I+QvEHRKvK9p
         dahG9Qka7jBmTzNrfUl/hJW1BvObCNxFU/+7k0YpHiYvZ2TqcotoxEeK0vMAh1oHG1iR
         CN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fynHNcg758ZnVGHVMXWB8OS8MKqYoOW+Z10p7x2uL3o=;
        b=fQle4UX9QSd2MR3FAD+HPXeCJ9MtcJFCivgyOTihRa/q/sSuwke43JqRhSjOm5wGvT
         KldgsnguCX0cvasQd740wPzW7s7wlrsnq60AXfahimoGKTW30PrHo3DcVPPQI2zp9yOW
         RmkDB7WQ5X8MrCL2TaW5t3e5jU8ujKQKueI88N0I6hxUv3cMCdzx17pEmQNmXVQeMsPk
         dYwvpQIw7xCdXRBjL0KtH0KOl35ybxZg14XXdGvSOA16NfIGg1v/h3bUU+IOKOUlK0VI
         aOV9dLSnjQAlwouFloYyfn3MzCnT1pSUAUGMVwe4mwQlho8jGUKMookakUcYstzCXutJ
         MfNQ==
X-Gm-Message-State: AOAM531rnu/o968+IhC1Zb3KLFTOf3hIQ88KO/LXVpoIeFa2WCTiYwIr
        ZIYWZWYqrRjm4sS6YWl8hfjLp/6yNQo=
X-Google-Smtp-Source: ABdhPJzYCfMBEcPToYPH+3XwU6NqqfJxu252sH5k1BVuWAj+rh7QhW7trDeMhqpRhrtCdof4IAOS1Q==
X-Received: by 2002:adf:f890:: with SMTP id u16mr8124065wrp.388.1631563113814;
        Mon, 13 Sep 2021 12:58:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:2517:8cca:49d8:dcdc? (p200300ea8f08450025178cca49d8dcdc.dip0.t-ipconnect.de. [2003:ea:8f08:4500:2517:8cca:49d8:dcdc])
        by smtp.googlemail.com with ESMTPSA id x13sm8244092wrg.62.2021.09.13.12.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 12:58:33 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: remove support for chip version
 RTL_GIGA_MAC_VER_27
Message-ID: <7892bfe6-ad86-2b1e-e2ea-7e1667e17151@gmail.com>
Date:   Mon, 13 Sep 2021 21:46:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is a follow-up to beb401ec5006 ("r8169: deprecate support for
RTL_GIGA_MAC_VER_27") that came with 5.12. Nobody complained, so let's
remove support for this chip version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h          |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     | 41 +------------
 .../net/ethernet/realtek/r8169_phy_config.c   | 59 -------------------
 3 files changed, 3 insertions(+), 99 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 2728df46e..8da4b66b7 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -37,7 +37,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_24,
 	RTL_GIGA_MAC_VER_25,
 	RTL_GIGA_MAC_VER_26,
-	RTL_GIGA_MAC_VER_27,
+	/* support for RTL_GIGA_MAC_VER_27 has been removed */
 	RTL_GIGA_MAC_VER_28,
 	RTL_GIGA_MAC_VER_29,
 	RTL_GIGA_MAC_VER_30,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 46a6ff9a7..019991444 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -118,7 +118,6 @@ static const struct {
 	[RTL_GIGA_MAC_VER_24] = {"RTL8168cp/8111cp"			},
 	[RTL_GIGA_MAC_VER_25] = {"RTL8168d/8111d",	FIRMWARE_8168D_1},
 	[RTL_GIGA_MAC_VER_26] = {"RTL8168d/8111d",	FIRMWARE_8168D_2},
-	[RTL_GIGA_MAC_VER_27] = {"RTL8168dp/8111dp"			},
 	[RTL_GIGA_MAC_VER_28] = {"RTL8168dp/8111dp"			},
 	[RTL_GIGA_MAC_VER_29] = {"RTL8105e",		FIRMWARE_8105E_1},
 	[RTL_GIGA_MAC_VER_30] = {"RTL8105e",		FIRMWARE_8105E_1},
@@ -985,33 +984,6 @@ DECLARE_RTL_COND(rtl_ocpar_cond)
 	return RTL_R32(tp, OCPAR) & OCPAR_FLAG;
 }
 
-static void r8168dp_1_mdio_access(struct rtl8169_private *tp, int reg, u32 data)
-{
-	RTL_W32(tp, OCPDR, data | ((reg & OCPDR_REG_MASK) << OCPDR_GPHY_REG_SHIFT));
-	RTL_W32(tp, OCPAR, OCPAR_GPHY_WRITE_CMD);
-	RTL_W32(tp, EPHY_RXER_NUM, 0);
-
-	rtl_loop_wait_low(tp, &rtl_ocpar_cond, 1000, 100);
-}
-
-static void r8168dp_1_mdio_write(struct rtl8169_private *tp, int reg, int value)
-{
-	r8168dp_1_mdio_access(tp, reg,
-			      OCPDR_WRITE_CMD | (value & OCPDR_DATA_MASK));
-}
-
-static int r8168dp_1_mdio_read(struct rtl8169_private *tp, int reg)
-{
-	r8168dp_1_mdio_access(tp, reg, OCPDR_READ_CMD);
-
-	mdelay(1);
-	RTL_W32(tp, OCPAR, OCPAR_GPHY_READ_CMD);
-	RTL_W32(tp, EPHY_RXER_NUM, 0);
-
-	return rtl_loop_wait_high(tp, &rtl_ocpar_cond, 1000, 100) ?
-		RTL_R32(tp, OCPDR) & OCPDR_DATA_MASK : -ETIMEDOUT;
-}
-
 #define R8168DP_1_MDIO_ACCESS_BIT	0x00020000
 
 static void r8168dp_2_mdio_start(struct rtl8169_private *tp)
@@ -1053,9 +1025,6 @@ static int r8168dp_2_mdio_read(struct rtl8169_private *tp, int reg)
 static void rtl_writephy(struct rtl8169_private *tp, int location, int val)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_27:
-		r8168dp_1_mdio_write(tp, location, val);
-		break;
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		r8168dp_2_mdio_write(tp, location, val);
@@ -1072,8 +1041,6 @@ static void rtl_writephy(struct rtl8169_private *tp, int location, int val)
 static int rtl_readphy(struct rtl8169_private *tp, int location)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_27:
-		return r8168dp_1_mdio_read(tp, location);
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		return r8168dp_2_mdio_read(tp, location);
@@ -1235,7 +1202,6 @@ static bool r8168ep_check_dash(struct rtl8169_private *tp)
 static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_27:
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		return r8168dp_check_dash(tp) ? RTL_DASH_DP : RTL_DASH_NONE;
@@ -2040,8 +2006,7 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 
 		/* 8168DP family. */
 		/* It seems this early RTL8168dp version never made it to
-		 * the wild. Let's see whether somebody complains, if not
-		 * we'll remove support for this chip version completely.
+		 * the wild. Support has been removed.
 		 * { 0x7cf, 0x288,      RTL_GIGA_MAC_VER_27 },
 		 */
 		{ 0x7cf, 0x28a,	RTL_GIGA_MAC_VER_28 },
@@ -2371,7 +2336,7 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 			r8168c_hw_jumbo_disable(tp);
 		}
 		break;
-	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
+	case RTL_GIGA_MAC_VER_28:
 		if (jumbo)
 			r8168dp_hw_jumbo_enable(tp);
 		else
@@ -3719,7 +3684,6 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_24] = rtl_hw_start_8168cp_3,
 		[RTL_GIGA_MAC_VER_25] = rtl_hw_start_8168d,
 		[RTL_GIGA_MAC_VER_26] = rtl_hw_start_8168d,
-		[RTL_GIGA_MAC_VER_27] = rtl_hw_start_8168d,
 		[RTL_GIGA_MAC_VER_28] = rtl_hw_start_8168d_4,
 		[RTL_GIGA_MAC_VER_29] = rtl_hw_start_8105e_1,
 		[RTL_GIGA_MAC_VER_30] = rtl_hw_start_8105e_2,
@@ -3982,7 +3946,6 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 		goto no_reset;
 
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_27:
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		rtl_loop_wait_low(tp, &rtl_npq_cond, 20, 2000);
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 50f0f621b..f7ad54878 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -548,64 +548,6 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl8168d_apply_firmware_cond(tp, phydev, 0xb300);
 }
 
-static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0002 },
-		{ 0x10, 0x0008 },
-		{ 0x0d, 0x006c },
-
-		{ 0x1f, 0x0000 },
-		{ 0x0d, 0xf880 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x17, 0x0cc0 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x0b, 0xa4d8 },
-		{ 0x09, 0x281c },
-		{ 0x07, 0x2883 },
-		{ 0x0a, 0x6b35 },
-		{ 0x1d, 0x3da4 },
-		{ 0x1c, 0xeffd },
-		{ 0x14, 0x7f52 },
-		{ 0x18, 0x7fc6 },
-		{ 0x08, 0x0601 },
-		{ 0x06, 0x4063 },
-		{ 0x10, 0xf074 },
-		{ 0x1f, 0x0003 },
-		{ 0x13, 0x0789 },
-		{ 0x12, 0xf4bd },
-		{ 0x1a, 0x04fd },
-		{ 0x14, 0x84b0 },
-		{ 0x1f, 0x0000 },
-		{ 0x00, 0x9200 },
-
-		{ 0x1f, 0x0005 },
-		{ 0x01, 0x0340 },
-		{ 0x1f, 0x0001 },
-		{ 0x04, 0x4000 },
-		{ 0x03, 0x1d21 },
-		{ 0x02, 0x0c32 },
-		{ 0x01, 0x0200 },
-		{ 0x00, 0x5554 },
-		{ 0x04, 0x4800 },
-		{ 0x04, 0x4000 },
-		{ 0x04, 0xf000 },
-		{ 0x03, 0xdf01 },
-		{ 0x02, 0xdf20 },
-		{ 0x01, 0x101a },
-		{ 0x00, 0xa0ff },
-		{ 0x04, 0xf800 },
-		{ 0x04, 0xf000 },
-		{ 0x1f, 0x0000 },
-	};
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-	r8168d_modify_extpage(phydev, 0x0023, 0x16, 0xffff, 0x0000);
-}
-
 static void rtl8168d_4_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
@@ -1332,7 +1274,6 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_24] = rtl8168cp_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_25] = rtl8168d_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_26] = rtl8168d_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_27] = rtl8168d_3_hw_phy_config,
 		[RTL_GIGA_MAC_VER_28] = rtl8168d_4_hw_phy_config,
 		[RTL_GIGA_MAC_VER_29] = rtl8105e_hw_phy_config,
 		[RTL_GIGA_MAC_VER_30] = rtl8105e_hw_phy_config,
-- 
2.33.0

