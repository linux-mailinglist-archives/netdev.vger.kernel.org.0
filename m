Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BED54A0239
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiA1Ulw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiA1Ulv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 15:41:51 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448E2C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 12:41:51 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id l25so13007480wrb.13
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 12:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=jkTdM2UpYXtXlrQtx3IjKRC/TYgbA0fLNj7SrQVLlfI=;
        b=ZfNugUut4xDh9abMxs5k1hdzoRIgJeZp4/+JsAkYckjyWeJ54OTq5MIhNm9ouqOffc
         +XMGg8H3KJJP9AGplwJOYY7c4udAgQ2qH2vgkS7voyowaOQMJ1mF/VH7HhSS55Ufob0U
         s+PAqm6jwQAkH24anJ7G6zwmZxDmof/0CUr3RnhcepVlCY0DOsPLhqJHyUCJJAp1eWeL
         s2dKAmUTDgf051tqTw2xM1iQSDvodk02K8DSGD6/TYdQ4c434LeSzBc1KKFx+Fvz7vcy
         8cTB+eVXM6R5AFjiLlBCgqU0XX6RIqq8Vk92eD8VOcGPpJuoeUEYbC2lEyhGuyY+4nSy
         gxLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=jkTdM2UpYXtXlrQtx3IjKRC/TYgbA0fLNj7SrQVLlfI=;
        b=IObjVHlBXkt4nRZOdB2mGZkL24yBCdtP61UjF3az7lHc86rN1foyDx4ldfHlsAisSJ
         DLHkjpsco8oZW3U7OfGpVosnuPi0MZXaAGEeT7uHmAmq5yT48sfRDXEnXRGTJzTYEB47
         ooFOY5UimFaUZBlefrHsBs3ksyjnD8bLsyeIosFPJlwlgXJn06L4a+Jrni7viG7uIa88
         y1lva+sAeelY6/846CCfbjAjZQguW2udYNA0aJZuTEVJD1hy2PVoJfguHT42zSSoaW12
         noiXT0NpF06wYRsPx9f6JjOBtFgup/dZBYXgsVXfzo1bro1fz+Ck90qdBOri97cX1Mpe
         p21g==
X-Gm-Message-State: AOAM530pmYrc02rSsejsSSZCAOalgOtXxFxDOagTAb6whefaZ3DqjpUJ
        p5SyQYMRS63p8d8bJYuc5nxpnRZTeH0=
X-Google-Smtp-Source: ABdhPJx7RZRaZb51MbXvusljeWyXMWMG/6iWXyBs1SQNX70PjKggMNaYT6YldE8dS3nrgCZvJYXASg==
X-Received: by 2002:a05:6000:15c5:: with SMTP id y5mr8942018wry.656.1643402509709;
        Fri, 28 Jan 2022 12:41:49 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:2ced:b45:1cf4:7a9e? (p200300ea8f4d2b002ced0b451cf47a9e.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:2ced:b45:1cf4:7a9e])
        by smtp.googlemail.com with ESMTPSA id y3sm6196186wry.109.2022.01.28.12.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 12:41:49 -0800 (PST)
Message-ID: <c92aeff4-e887-06e9-ecef-f458a9903ee8@gmail.com>
Date:   Fri, 28 Jan 2022 21:41:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net-next] r8169: add rtl_disable_exit_l1()
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Content-Language: en-US
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

v2:
- call rtl_disable_exit_l1() also if DASH or WoL are enabled

Suggested-by: Chun-Hao Lin <hau@realtek.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 65 +++++++++++++----------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3c3d1506b..126d7322d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
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
@@ -4702,7 +4713,7 @@ static void rtl8169_down(struct rtl8169_private *tp)
 	rtl_pci_commit(tp);
 
 	rtl8169_cleanup(tp, true);
-
+	rtl_disable_exit_l1(tp);
 	rtl_prepare_power_down(tp);
 }
 
-- 
2.35.0

