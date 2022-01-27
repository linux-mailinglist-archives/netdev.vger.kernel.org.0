Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6388B49EDFD
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 23:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbiA0WOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 17:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbiA0WOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 17:14:41 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D808C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:14:41 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l35-20020a05600c1d2300b0034d477271c1so2750519wms.3
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=/k3AmdaNagjESu+lzj4xALQ2hQci6vO/gRe2DHZ/D/s=;
        b=KyOZsyiLulwcqARyiVTHpr5MFeuHTKaTN1FdiQz5wrJ31+ha8T7LFW3nwhDsjtRLeJ
         qKBwlUDrkOQUd2zg6/gdr94L7SPVtlIIZVMVpv5o/vi5S75ARZJPCNWZH5w8H+J1GaYP
         nzmCehBpATq8RqUVN3LUffNt6iMKmAViIYRZccIMAnoK62WbhoPOH7Pp+n9C9tjdUQWA
         WgW6kWScPeBIElr8Xgzjqr+WjPEk6idKe72qFvqxdZbXlAS+ST4mYXkY34Ar/WaCIyLD
         JuzVGhcSfjeL7iN3qNeNUEgk5AEW/jMHrRhGq7Q7pSFvxBKSIV2bizxO6SzRr196EcDa
         LgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=/k3AmdaNagjESu+lzj4xALQ2hQci6vO/gRe2DHZ/D/s=;
        b=3unAQtg5+/I4XoXXDKeUnBooWvq7x7ukAUrLpfTWTSQRTH6a5zpD4wd00YOhgSiuXV
         yLAqJxYASoDfKwmCCJ3OQfXgw8/ny/ooMDXc39BkCf98xTPf/2XXgI86FrhiZj5Fw+dY
         j3dwvBj9PuXJhYwERLISNonlzV1tBZQO6vbv1h1vHDm5GEugeOqYl7A4fpYaW+d8LEd1
         Nb4yU1Hf6TQGuIt9Qr455Th7mSlfEfByoLi4DF24eRFqr3S8pYS8kCF6CFdvj9zsizd4
         sH71Ep/lm1g057kY8ZRRlOysLPcY24TJc9op8nc4RGkFdXqXnoGpB/x4ztLJBfi97RGs
         HU3A==
X-Gm-Message-State: AOAM530jhdmr8ZBGPSSTCVm+Q9vAEoFGThogOGyfi1ybb4HuNqbrhumI
        M2ga66tWNjMSItiwOxfHvAgZPDstqnE=
X-Google-Smtp-Source: ABdhPJyZJG6UDezFh2agfk3UTGxgC8aEdMD/Bn7PYy34Uhp+fc5hZLART6cajfSXtHrFCm8w3akICg==
X-Received: by 2002:a1c:a9d7:: with SMTP id s206mr4890350wme.38.1643321679627;
        Thu, 27 Jan 2022 14:14:39 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:8bb:72c8:ebd4:2603? (p200300ea8f4d2b0008bb72c8ebd42603.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:8bb:72c8:ebd4:2603])
        by smtp.googlemail.com with ESMTPSA id d7sm4466385wri.117.2022.01.27.14.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 14:14:39 -0800 (PST)
Message-ID: <f448b546-5b0a-79e0-f09a-dcfabb4fc8a5@gmail.com>
Date:   Thu, 27 Jan 2022 23:14:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Content-Language: en-US
Subject: [PATCH net-next] r8169: add rtl_disable_exit_l1()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add rtl_disable_exit_l1() for ensuring that the chip doesn't
inadvertently exit ASPM L1 when being in a low-power mode.
The new function is called from rtl_prepare_power_down() which
has to be moved in the code to avoid a forward declaration.

According to Realtek OCP register 0xc0ac shadows ERI register 0xd4
on RTL8168 versions from RTL8168g. This allows to simplify the
code a little.

Suggested-by: Chun-Hao Lin <hau@realtek.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 65 ++++++++++++++---------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3c3d1506b..104ebc0fb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2231,28 +2231,6 @@ static int rtl_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-static void rtl_wol_enable_rx(struct rtl8169_private *tp)
-{
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
-		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
-			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
-}
-
-static void rtl_prepare_power_down(struct rtl8169_private *tp)
-{
-	if (tp->dash_type != RTL_DASH_NONE)
-		return;
-
-	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_33)
-		rtl_ephy_write(tp, 0x19, 0xff64);
-
-	if (device_may_wakeup(tp_to_dev(tp))) {
-		phy_speed_down(tp->phydev, false);
-		rtl_wol_enable_rx(tp);
-	}
-}
-
 static void rtl_init_rxcfg(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
@@ -2667,10 +2645,7 @@ static void rtl_enable_exit_l1(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_38:
 		rtl_eri_set_bits(tp, 0xd4, 0x0c00);
 		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
-		rtl_eri_set_bits(tp, 0xd4, 0x1f80);
-		break;
-	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_63:
 		r8168_mac_ocp_modify(tp, 0xc0ac, 0, 0x1f80);
 		break;
 	default:
@@ -2678,6 +2653,20 @@ static void rtl_enable_exit_l1(struct rtl8169_private *tp)
 	}
 }
 
+static void rtl_disable_exit_l1(struct rtl8169_private *tp)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_38:
+		rtl_eri_clear_bits(tp, 0xd4, 0x1f00);
+		break;
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_63:
+		r8168_mac_ocp_modify(tp, 0xc0ac, 0x1f80, 0);
+		break;
+	default:
+		break;
+	}
+}
+
 static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
 	/* Don't enable ASPM in the chip if OS can't control ASPM */
@@ -4689,6 +4678,30 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	return 0;
 }
 
+static void rtl_wol_enable_rx(struct rtl8169_private *tp)
+{
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
+		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
+			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
+}
+
+static void rtl_prepare_power_down(struct rtl8169_private *tp)
+{
+	if (tp->dash_type != RTL_DASH_NONE)
+		return;
+
+	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_33)
+		rtl_ephy_write(tp, 0x19, 0xff64);
+
+	if (device_may_wakeup(tp_to_dev(tp))) {
+		phy_speed_down(tp->phydev, false);
+		rtl_wol_enable_rx(tp);
+	} else {
+		rtl_disable_exit_l1(tp);
+	}
+}
+
 static void rtl8169_down(struct rtl8169_private *tp)
 {
 	/* Clear all task flags */
-- 
2.35.0

