Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B35F5AD980
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 21:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiIETXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 15:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiIETXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 15:23:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32ECD52DEB
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:23:22 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so6177494wmb.4
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 12:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=GyqYYqwfA9QI68RpemtYDAuspidglEXUe5uHHv18QGs=;
        b=YuaYzDX1O+bPRKCtqIFn6Z246uziUIoKt2KHHXOwCK/zAufnRnzcdTUzMICXWuJrlI
         w41e8Blf3eZ8i0mOc2Uht5Z1dU+rgTKm5233fk6zld43non4U7q3Pgc6tUMgxxieMGBZ
         /LtxAMXtnIrpQo2Kvu3DIzPNLJ7O2CDj5C1aO6PPcRF8NCdDegMNs6eX4SDBVps2ihKa
         SxCpuiVaAddrGxC5ixZnUFID24LgkSG0v5IUC/zEYMYC56hOo+YjkYgH14mJwxfTODTS
         o9AydKG3zcR7tkssnptevhKoK98k7fA93VRaiSTjGleNOJV0ZaqjupnGonSuExgEu5SS
         /uWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=GyqYYqwfA9QI68RpemtYDAuspidglEXUe5uHHv18QGs=;
        b=q1acXDkSX4Oor9oA/xC+L6a/AAFzmKcAlE8NFILftmwvDyhJUFd0BF3BSDikoNroI1
         WooTog36X7hCVJVw128M8OAQxGH66gCUOu4GHnkxZjJWplo4wd1sH+ixcpSKAgNEcO51
         IpfU+Phu8DCHkNw4URnSrmsX2tpSWp4T3zLNVsQGrpn1J07e86gYsTrM6IDxJA+O50vX
         +JIfTfiBTU/hesAFeGTXnwZyx0YFg40+MMvBGan4mPwpmmTpJ1VzCPXxn35va53TynnE
         NOMaL3d5cvx4wjpLhMc/wamWFpMXHgJiMqnOOz+YeHXDMacD4ncDZi0L4cY4C5hlJEOm
         gViQ==
X-Gm-Message-State: ACgBeo0eD32NdjoSnxDbOuNNSHxo0Cven4puJgDRqpRDgd2ems80Nuf5
        Hrc3Pb1JpGyp+jMHaV3uTUQ=
X-Google-Smtp-Source: AA6agR7qB4d6+YQgjMiRw028r/oIUE8K+GT5njYaukzM0GTaIid+NRPPSWM+XEEEsdrhVpimhM16OQ==
X-Received: by 2002:a05:600c:b57:b0:3a5:3c06:f287 with SMTP id k23-20020a05600c0b5700b003a53c06f287mr11261664wmr.148.1662405800558;
        Mon, 05 Sep 2022 12:23:20 -0700 (PDT)
Received: from ?IPV6:2a02:3100:95a1:c000:850a:bce6:b228:6e6f? (dynamic-2a02-3100-95a1-c000-850a-bce6-b228-6e6f.310.pool.telefonica.de. [2a02:3100:95a1:c000:850a:bce6:b228:6e6f])
        by smtp.googlemail.com with ESMTPSA id n5-20020a05600c3b8500b003a319b67f64sm31068842wms.0.2022.09.05.12.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 12:23:20 -0700 (PDT)
Message-ID: <469d27e0-1d06-9b15-6c96-6098b3a52e35@gmail.com>
Date:   Mon, 5 Sep 2022 21:23:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next] r8169: merge support for chip versions 10, 13, 16
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

These chip versions are closely related and all of them have no
chip-specific MAC/PHY initialization. Therefore merge support
for the three chip versions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h            |  4 ++--
 drivers/net/ethernet/realtek/r8169_main.c       | 11 ++---------
 drivers/net/ethernet/realtek/r8169_phy_config.c |  2 --
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 5b188ba85..55ef8251f 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -24,9 +24,9 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_10,
 	RTL_GIGA_MAC_VER_11,
 	/* RTL_GIGA_MAC_VER_12 was handled the same as VER_17 */
-	RTL_GIGA_MAC_VER_13,
+	/* RTL_GIGA_MAC_VER_13 was merged with VER_10 */
 	RTL_GIGA_MAC_VER_14,
-	RTL_GIGA_MAC_VER_16,
+	/* RTL_GIGA_MAC_VER_16 was merged with VER_10 */
 	RTL_GIGA_MAC_VER_17,
 	RTL_GIGA_MAC_VER_18,
 	RTL_GIGA_MAC_VER_19,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 52dacf59a..3763855e4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -100,11 +100,9 @@ static const struct {
 	[RTL_GIGA_MAC_VER_07] = {"RTL8102e"				},
 	[RTL_GIGA_MAC_VER_08] = {"RTL8102e"				},
 	[RTL_GIGA_MAC_VER_09] = {"RTL8102e/RTL8103e"			},
-	[RTL_GIGA_MAC_VER_10] = {"RTL8101e"				},
+	[RTL_GIGA_MAC_VER_10] = {"RTL8101e/RTL8100e"			},
 	[RTL_GIGA_MAC_VER_11] = {"RTL8168b/8111b"			},
-	[RTL_GIGA_MAC_VER_13] = {"RTL8101e/RTL8100e"			},
 	[RTL_GIGA_MAC_VER_14] = {"RTL8401"				},
-	[RTL_GIGA_MAC_VER_16] = {"RTL8101e"				},
 	[RTL_GIGA_MAC_VER_17] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_18] = {"RTL8168cp/8111cp"			},
 	[RTL_GIGA_MAC_VER_19] = {"RTL8168c/8111c"			},
@@ -2046,13 +2044,10 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7cf, 0x249,	RTL_GIGA_MAC_VER_08 },
 		{ 0x7cf, 0x348,	RTL_GIGA_MAC_VER_07 },
 		{ 0x7cf, 0x248,	RTL_GIGA_MAC_VER_07 },
-		{ 0x7cf, 0x340,	RTL_GIGA_MAC_VER_13 },
 		{ 0x7cf, 0x240,	RTL_GIGA_MAC_VER_14 },
-		{ 0x7cf, 0x343,	RTL_GIGA_MAC_VER_10 },
-		{ 0x7cf, 0x342,	RTL_GIGA_MAC_VER_16 },
 		{ 0x7c8, 0x348,	RTL_GIGA_MAC_VER_09 },
 		{ 0x7c8, 0x248,	RTL_GIGA_MAC_VER_09 },
-		{ 0x7c8, 0x340,	RTL_GIGA_MAC_VER_16 },
+		{ 0x7c8, 0x340,	RTL_GIGA_MAC_VER_10 },
 
 		/* 8110 family. */
 		{ 0xfc8, 0x980,	RTL_GIGA_MAC_VER_06 },
@@ -3625,9 +3620,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_09] = rtl_hw_start_8102e_2,
 		[RTL_GIGA_MAC_VER_10] = NULL,
 		[RTL_GIGA_MAC_VER_11] = rtl_hw_start_8168b,
-		[RTL_GIGA_MAC_VER_13] = NULL,
 		[RTL_GIGA_MAC_VER_14] = rtl_hw_start_8401,
-		[RTL_GIGA_MAC_VER_16] = NULL,
 		[RTL_GIGA_MAC_VER_17] = rtl_hw_start_8168b,
 		[RTL_GIGA_MAC_VER_18] = rtl_hw_start_8168cp_1,
 		[RTL_GIGA_MAC_VER_19] = rtl_hw_start_8168c_1,
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 7906646f7..930496cd3 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1115,9 +1115,7 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_09] = rtl8102e_hw_phy_config,
 		[RTL_GIGA_MAC_VER_10] = NULL,
 		[RTL_GIGA_MAC_VER_11] = rtl8168bb_hw_phy_config,
-		[RTL_GIGA_MAC_VER_13] = NULL,
 		[RTL_GIGA_MAC_VER_14] = rtl8401_hw_phy_config,
-		[RTL_GIGA_MAC_VER_16] = NULL,
 		[RTL_GIGA_MAC_VER_17] = rtl8168bef_hw_phy_config,
 		[RTL_GIGA_MAC_VER_18] = rtl8168cp_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_19] = rtl8168c_1_hw_phy_config,
-- 
2.37.3

