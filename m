Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D876759AE94
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 15:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345398AbiHTNyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 09:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345124AbiHTNyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 09:54:37 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095836F57F
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:54:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id fy5so13523378ejc.3
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=UYo8KdnhbMATn3EiBwibikf/SnQbUSFVGkhKoQiBBrc=;
        b=KmwJCAWVhgLxJndOeLIGGwm2naToskQ4di/hjrjPhvtC0AV3nv0J2T78/cqbNXtOkl
         8B7kH2muy48xM/0m4ehIITYSTjbGNWjzH0OrDtwM1FnLFsz3+W6qn6GB4oaNJ/D+QVUL
         ZbJgjJBoMDBc0xJcEKOP37Cd48/dQRoRNr/1DKYn1V5buV7AUJBVxuMHoXhwgf3J0Tzg
         Irji8irhAMyvGCc7Ed1F6fkQYR6oAA0VNmMi6SDPF4FZs6Uil2ioOWCnHFWLywtGDoTL
         ud7W3FHggWDb+K4NKfpa8SS/wEBnWIOQCYTsnQ+25at9xSZBV1FzuVE4h1Cu2/0llTcJ
         ND+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=UYo8KdnhbMATn3EiBwibikf/SnQbUSFVGkhKoQiBBrc=;
        b=jSo3PPYL5Qn89egk6jodg2WRSCel2pvYCe31mCwm2TPj8PRmw7Se106aVQDWnzAlnx
         xVmT0qPB37OdExp0kd9h7r3qHtk3dHs+I4NqYCpwXXgFlnqj8dzV1ydJH2idScol5+31
         F+Efj7rsds4eVCim1v6cRVvgskcValX2P+XZjJxrW8ObM2j+0I9aDh2SVXFtAC4syOJL
         hzZ6KlMFIKOo0gtgEj6wSGcawZqproqeOa/gEuCztsXyx7q4RVGdjsO+EiZtwG/8+xrQ
         OyZkul88BVK6v2DnAcmW8sBUZeZHuM/Jy9HMUO2eKUjAmCw6w2jaHTzoE8GZrNpM+cRJ
         5htw==
X-Gm-Message-State: ACgBeo3un1xVSmiHUTI+1qeOd3WTZB60fG3XvKeKxqAruHFBn+jtr0xF
        bSnos5+Z2PEaWaAL/VHwL7bHXuMvBe0=
X-Google-Smtp-Source: AA6agR7L+zf8AMNP1Kvuc2sy5oKmJnzDrgnSGekPTgNnXaWsfgbGPX0kF05SlpVdSPk/EFwh6xhV5Q==
X-Received: by 2002:a17:907:3f88:b0:730:9d82:5114 with SMTP id hr8-20020a1709073f8800b007309d825114mr7672986ejc.333.1661003674477;
        Sat, 20 Aug 2022 06:54:34 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531? (dynamic-2a01-0c23-c0bb-f700-3cb6-47a0-41b9-1531.c23.pool.telefonica.de. [2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531])
        by smtp.googlemail.com with ESMTPSA id 1-20020a170906318100b007030c97ae62sm3570933ejy.191.2022.08.20.06.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Aug 2022 06:54:33 -0700 (PDT)
Message-ID: <fdfb77eb-0f16-1ef9-6ccc-1f2520885dd2@gmail.com>
Date:   Sat, 20 Aug 2022 15:51:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next 1/5] r8169: remove support for chip version 41
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3d2fc9d-3ce7-b545-9cd1-6ad9fbe0adb7@gmail.com>
In-Reply-To: <e3d2fc9d-3ce7-b545-9cd1-6ad9fbe0adb7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Detection of this chip version has been disabled for few kernel versions now.
Nobody complained, so remove support for this chip version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h            | 2 +-
 drivers/net/ethernet/realtek/r8169_main.c       | 3 ---
 drivers/net/ethernet/realtek/r8169_phy_config.c | 1 -
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 8da4b66b7..e2ace50e0 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -51,7 +51,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_38,
 	RTL_GIGA_MAC_VER_39,
 	RTL_GIGA_MAC_VER_40,
-	RTL_GIGA_MAC_VER_41,
+	/* support for RTL_GIGA_MAC_VER_41 has been removed */
 	RTL_GIGA_MAC_VER_42,
 	RTL_GIGA_MAC_VER_43,
 	RTL_GIGA_MAC_VER_44,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1b7fdb4f0..a2baeb8da 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -131,7 +131,6 @@ static const struct {
 	[RTL_GIGA_MAC_VER_38] = {"RTL8411",		FIRMWARE_8411_1 },
 	[RTL_GIGA_MAC_VER_39] = {"RTL8106e",		FIRMWARE_8106E_1},
 	[RTL_GIGA_MAC_VER_40] = {"RTL8168g/8111g",	FIRMWARE_8168G_2},
-	[RTL_GIGA_MAC_VER_41] = {"RTL8168g/8111g"			},
 	[RTL_GIGA_MAC_VER_42] = {"RTL8168gu/8111gu",	FIRMWARE_8168G_3},
 	[RTL_GIGA_MAC_VER_43] = {"RTL8106eus",		FIRMWARE_8106E_2},
 	[RTL_GIGA_MAC_VER_44] = {"RTL8411b",		FIRMWARE_8411_2 },
@@ -892,7 +891,6 @@ static void rtl8168g_phy_suspend_quirk(struct rtl8169_private *tp, int value)
 {
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_40:
-	case RTL_GIGA_MAC_VER_41:
 	case RTL_GIGA_MAC_VER_49:
 		if (value & BMCR_RESET || !(value & BMCR_PDOWN))
 			rtl_eri_set_bits(tp, 0x1a8, 0xfc000000);
@@ -3748,7 +3746,6 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_38] = rtl_hw_start_8411,
 		[RTL_GIGA_MAC_VER_39] = rtl_hw_start_8106,
 		[RTL_GIGA_MAC_VER_40] = rtl_hw_start_8168g_1,
-		[RTL_GIGA_MAC_VER_41] = rtl_hw_start_8168g_1,
 		[RTL_GIGA_MAC_VER_42] = rtl_hw_start_8168g_2,
 		[RTL_GIGA_MAC_VER_43] = rtl_hw_start_8168g_2,
 		[RTL_GIGA_MAC_VER_44] = rtl_hw_start_8411_2,
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 15c295f90..2b4bc2d6f 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1266,7 +1266,6 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_38] = rtl8411_hw_phy_config,
 		[RTL_GIGA_MAC_VER_39] = rtl8106e_hw_phy_config,
 		[RTL_GIGA_MAC_VER_40] = rtl8168g_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_41] = NULL,
 		[RTL_GIGA_MAC_VER_42] = rtl8168g_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_43] = rtl8168g_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_44] = rtl8168g_2_hw_phy_config,
-- 
2.37.2


