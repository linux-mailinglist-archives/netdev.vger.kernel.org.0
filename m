Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7F859EC91
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiHWTk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiHWTkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:40:21 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C87266D
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 11:38:16 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id d1so3855187edn.9
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 11:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=UYo8KdnhbMATn3EiBwibikf/SnQbUSFVGkhKoQiBBrc=;
        b=h00vnRgsW3vfuB8/YSXM8VR/xLnAM4/JACUtHcw14DSh6picmNiZ5+1K0u0HKVBAR0
         Ky5twlZI3dO9mimBqhVe7W2sjvMHGmdsRiw06jxi2E+TXbkKaAxigCm2B7ynRNQ2+h0l
         qTJyTxM1HilnvhY0369ofUcr6GX9ehB0VE8hca7+M1TE7bi5FAlJ0gccTYGnCtqZNQMD
         kLEoGabFIDfzSGuePdtNrKfTJbr668kwbxJA7/xJwfO3OGdI32nA3sdCLvCR0YTHjhvY
         BPdhhq1iGgkO+0NYBHJDfRhVq7wCGqrPt2O6+wZj2SkpnAU2YAIlwBKp9mGtblDfndiT
         kMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=UYo8KdnhbMATn3EiBwibikf/SnQbUSFVGkhKoQiBBrc=;
        b=N76w/rpOkRK5yY4D8v8f3Ld/id3PenzDlcLC0+LEFD/smVXZJPZCq8TZhS0pJAVoa4
         dUynRdiAFn3t1z6MBd8R2F3ALN8oQBRr46BXaJr6DgL73OYXJqGC2JnnqV2YY/p9LwOJ
         8bBsp6k9Hzgr7Q0qOWHvQticc6O/Fi/67MAzgZufhO6zHeVt28t+umUm8P7S0NO8oVaZ
         qZ6HPsFZja+tnqghaHyi9EEFUKhe35t5stDomGLeAf1pkd+5jLjVaohhnRtEDFmKPbKO
         a9zf2RBVSE0Dg5IMLiL5IB2u1cjERU7K8h+ymw7oMjhDd0+fSGLG9ryk0DuKvvLyr60x
         eVlA==
X-Gm-Message-State: ACgBeo3yMlbXKgKp5sl1ATRmjvfe1X0TrCFDYK4uehDXZUofGbehn/j+
        bNRAplRyN5y+QKFjJk8r2wU=
X-Google-Smtp-Source: AA6agR7jWL0hhUBAR9CdRoZxJyPOMzLfdq/9CEkpaGNY7oGvtEM9kMHk7D6MoP5JhEoN3U5/QqBeXA==
X-Received: by 2002:a05:6402:3210:b0:43d:20bc:5e4 with SMTP id g16-20020a056402321000b0043d20bc05e4mr4692407eda.276.1661279894522;
        Tue, 23 Aug 2022 11:38:14 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7758:1500:8528:d099:20f2:8fd6? (dynamic-2a01-0c22-7758-1500-8528-d099-20f2-8fd6.c22.pool.telefonica.de. [2a01:c22:7758:1500:8528:d099:20f2:8fd6])
        by smtp.googlemail.com with ESMTPSA id g21-20020a50d0d5000000b0043d6ece495asm1792206edf.55.2022.08.23.11.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 11:38:14 -0700 (PDT)
Message-ID: <f1615e9a-bb34-fc80-1747-ed9340e4278d@gmail.com>
Date:   Tue, 23 Aug 2022 20:34:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next v3 1/5] r8169: remove support for chip version 41
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <3bff9a7a-2353-3b37-3b6e-ebcae00f7816@gmail.com>
In-Reply-To: <3bff9a7a-2353-3b37-3b6e-ebcae00f7816@gmail.com>
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


