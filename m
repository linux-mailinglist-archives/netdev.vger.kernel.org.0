Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77BA59E4DB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 16:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242056AbiHWODd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 10:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244000AbiHWOB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 10:01:28 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D6823DFBB
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:09:11 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id j21so21297213ejs.0
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=UYo8KdnhbMATn3EiBwibikf/SnQbUSFVGkhKoQiBBrc=;
        b=bUiYGQI4Vwv+4Q5hbZGvlJ5oFe6M9UosNk+nLMvmTagAjNZMGXxbYUpg+1RiV3KSNS
         cnQk9j61NYsEhHZ82iTObODXU1m5eqMm/7wbeKmR2U1qldnCZtiZwon/BEp+aaO6LnHB
         AFrrQtlIgbBBk9O8WWXEjH4B0YvQ3fE3rlXAE3lm96IYdyu5zdPniFpGT16ly5xlk+7p
         fkxuSzuSHsqkJkh7GwUM4rk7Vk1782X7HrQ1FdfY89DK/pCCl/vcOeVzSeoymnTlm1ni
         FgYlJOPnCdz0UWCd/ONchkY8udyQxKom43Sjv69UtQiFpL1wMBosMDoRZQO1tOTlyTnm
         uiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=UYo8KdnhbMATn3EiBwibikf/SnQbUSFVGkhKoQiBBrc=;
        b=voyAhiXvoV1in+Ykqvgy8ykbhgDmPdEU5eOD6d1ggloiymq6AX/U1Q9WlknTMI2RHl
         k210FBtbtt8d0HEg0Wh7UFb5wfcHcIbles9vAk8XVbbYXBgGsnJNk5FnbVpIhVpdqM3y
         Yh+6ZeRoiVBPnDbe716SVWH+UBGDYf4zmISHp8y/KzGp5tqI88xaQz0xztgIzc8UrLen
         BBEkV8zyxO28W1eLpnQ3VU7IEYiAIIi8DBIMLTSEPnmNP5hFTnS8++D51DDUDHmVZDkT
         6pSXhqLXw4H/Smt8A2pYli4kyBrHKokET8UJ9LPL2ALcm1msDshprdebKGGMw9kBXrzg
         aEfQ==
X-Gm-Message-State: ACgBeo2tFrk2w3EqbifDiPFPdSdJOGzp217MaF54rWpwVmWSEiV/xpfo
        AA1ijhx6EWkVfgivSWG/hdA=
X-Google-Smtp-Source: AA6agR6vowGhVN3k+yyGckXZJbPBLPh7DaPRX89rne7fyWu9nTp9q2J1rp4TsX+l/D0+Lzkd52NnsQ==
X-Received: by 2002:a17:907:3e86:b0:6f5:917:10cc with SMTP id hs6-20020a1709073e8600b006f5091710ccmr16631033ejc.53.1661252885789;
        Tue, 23 Aug 2022 04:08:05 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8? (dynamic-2a01-0c22-7758-1500-d4cf-79a3-3d29-c3f8.c22.pool.telefonica.de. [2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8])
        by smtp.googlemail.com with ESMTPSA id 16-20020a170906301000b0073100dfa7b5sm7329577ejz.33.2022.08.23.04.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 04:08:05 -0700 (PDT)
Message-ID: <6b2fe460-9dd7-e3c4-c131-95cf6ed5a28c@gmail.com>
Date:   Tue, 23 Aug 2022 13:03:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next v2 1/5] r8169: remove support for chip version 41
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ceb7b283-a41a-6c7d-1b63-7909da2c8a7a@gmail.com>
In-Reply-To: <ceb7b283-a41a-6c7d-1b63-7909da2c8a7a@gmail.com>
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

