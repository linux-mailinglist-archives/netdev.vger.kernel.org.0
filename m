Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7905E5AB931
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 22:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiIBULP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 16:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiIBULM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 16:11:12 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C90AEC4D6
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 13:11:04 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id u17so3633359wrp.3
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 13:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=R3tvcbY7zT4Cmw/jgIYI2Y5skpEdmxRTpLBkKCN9oqk=;
        b=bgnsQimFp09SVRQu6E8cxV2BzTaPTYvMS1+dwcUl/5uduXb2dcSJY8EI/oUvCmFBfB
         H8y7ia4BEC3mLpvdRbpCTQqcwuXZtwgnnVLV3e+yBh/Xbz3NcjMm7Ov9cph1AJhtHAsY
         5VGEs7huzyWiT20uUnSNRKtRHnh/x50B0VBVbDmhoNWLqhKK69WGw9IW9IWKWuxJBZIU
         b03Dq9gipTJQcz7f7ZC8Ors1KjksjHe2DQA76sGwkmV/dX/ui0p8hOQGDNbvOI70SaRr
         +LcaFq3TB5g4H7x6e53f2kONyp8uIVFh2vTOOllEl5GN5r0rdBzB5Gfs6qYPp/rH62Y0
         VA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=R3tvcbY7zT4Cmw/jgIYI2Y5skpEdmxRTpLBkKCN9oqk=;
        b=UQLpuevpsVk6ZnhSCK053NJ8dnGLOOw373SO/tlWIcprYg8uTEK7ddpMK1gBzOvl6y
         HvRxe0RnNn0LOEHza1bmvZQtjNUatbqVUFwfkQEYdYBKrvmrvy2J54IlBAo1stXV8wpX
         vHQc1bH1PMeAQGCFyLSQ7Dor/MfvvvGV8fXS55YZ+fVJ5X1QlRbyLSFhygpwTyDXc/60
         +ZckFqEV1/drWAYRzympUDpiqu5T+MamZ3w5h3SRAV/9iNzG5z7yhUuU2ML/Bs/535Mx
         WvWuW0tXTIazjRLHXSYyoHMPY/cjQ4J/d71BwJ3xlBu8HcsZYWK7zqsGxT5nXu6q5HBt
         /Fmg==
X-Gm-Message-State: ACgBeo1b41ksa5hCC45uUGRGiscGFDoD4VeFwFg6uf6ofBg6eRlaW87A
        i0OnuvagcooMgPB55cb5iDM=
X-Google-Smtp-Source: AA6agR65b6jMrAOxNrYAF0LR0b2rOl1tqutKoNfJz/5mxcZfeDYnztCUttgT01OnzMAWyUURgm8MzQ==
X-Received: by 2002:a5d:4acc:0:b0:225:74d6:57a4 with SMTP id y12-20020a5d4acc000000b0022574d657a4mr17856559wrs.500.1662149462631;
        Fri, 02 Sep 2022 13:11:02 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c4c2:4e00:f4b8:68d8:d295:8a3b? (dynamic-2a01-0c23-c4c2-4e00-f4b8-68d8-d295-8a3b.c23.pool.telefonica.de. [2a01:c23:c4c2:4e00:f4b8:68d8:d295:8a3b])
        by smtp.googlemail.com with ESMTPSA id j17-20020adfea51000000b0021f0af83142sm2238187wrn.91.2022.09.02.13.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 13:11:02 -0700 (PDT)
Message-ID: <bf680a50-a445-6007-e52b-0e0b0696e24c@gmail.com>
Date:   Fri, 2 Sep 2022 22:10:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next] r8169: merge handling of chip versions 12 and 17
 (RTL8168B)
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

It's not clear why XID's 380 and 381..387 ever got different chip
version id's. VER_12 and VER_17 are handled exactly the same.
Therefore merge handling under the VER_17 umbrella.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h            | 2 +-
 drivers/net/ethernet/realtek/r8169_main.c       | 6 ------
 drivers/net/ethernet/realtek/r8169_phy_config.c | 1 -
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 36d382676..5b188ba85 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -23,7 +23,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_09,
 	RTL_GIGA_MAC_VER_10,
 	RTL_GIGA_MAC_VER_11,
-	RTL_GIGA_MAC_VER_12,
+	/* RTL_GIGA_MAC_VER_12 was handled the same as VER_17 */
 	RTL_GIGA_MAC_VER_13,
 	RTL_GIGA_MAC_VER_14,
 	RTL_GIGA_MAC_VER_16,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4e0fae8db..99d0a7b33 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -102,7 +102,6 @@ static const struct {
 	[RTL_GIGA_MAC_VER_09] = {"RTL8102e/RTL8103e"			},
 	[RTL_GIGA_MAC_VER_10] = {"RTL8101e"				},
 	[RTL_GIGA_MAC_VER_11] = {"RTL8168b/8111b"			},
-	[RTL_GIGA_MAC_VER_12] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_13] = {"RTL8101e/RTL8100e"			},
 	[RTL_GIGA_MAC_VER_14] = {"RTL8401"				},
 	[RTL_GIGA_MAC_VER_16] = {"RTL8101e"				},
@@ -2029,7 +2028,6 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7c8, 0x3c0,	RTL_GIGA_MAC_VER_22 },
 
 		/* 8168B family. */
-		{ 0x7cf, 0x380,	RTL_GIGA_MAC_VER_12 },
 		{ 0x7c8, 0x380,	RTL_GIGA_MAC_VER_17 },
 		{ 0x7c8, 0x300,	RTL_GIGA_MAC_VER_11 },
 
@@ -2324,7 +2322,6 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 
 	rtl_unlock_config_regs(tp);
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
 		if (jumbo) {
 			readrq = 512;
@@ -3628,7 +3625,6 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_09] = rtl_hw_start_8102e_2,
 		[RTL_GIGA_MAC_VER_10] = NULL,
 		[RTL_GIGA_MAC_VER_11] = rtl_hw_start_8168b,
-		[RTL_GIGA_MAC_VER_12] = rtl_hw_start_8168b,
 		[RTL_GIGA_MAC_VER_13] = NULL,
 		[RTL_GIGA_MAC_VER_14] = rtl_hw_start_8401,
 		[RTL_GIGA_MAC_VER_16] = NULL,
@@ -4859,7 +4855,6 @@ static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
 	/* WoL fails with 8168b when the receiver is disabled. */
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_11:
-	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
 		pci_clear_master(tp->pci_dev);
 
@@ -5120,7 +5115,6 @@ static int rtl_jumbo_max(struct rtl8169_private *tp)
 		return JUMBO_7K;
 	/* RTL8168b */
 	case RTL_GIGA_MAC_VER_11:
-	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
 		return JUMBO_4K;
 	/* RTL8168c */
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 8c04cc56b..7906646f7 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1115,7 +1115,6 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_09] = rtl8102e_hw_phy_config,
 		[RTL_GIGA_MAC_VER_10] = NULL,
 		[RTL_GIGA_MAC_VER_11] = rtl8168bb_hw_phy_config,
-		[RTL_GIGA_MAC_VER_12] = rtl8168bef_hw_phy_config,
 		[RTL_GIGA_MAC_VER_13] = NULL,
 		[RTL_GIGA_MAC_VER_14] = rtl8401_hw_phy_config,
 		[RTL_GIGA_MAC_VER_16] = NULL,
-- 
2.37.3

