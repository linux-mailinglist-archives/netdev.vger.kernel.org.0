Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EC259EC94
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiHWTlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiHWTkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:40:23 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3081C422E7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 11:38:19 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id y3so2801605ejc.1
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 11:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=HhHj3VwqhyDaKMBVif274pGYZMAuJsuDdkwv2l1zTa0=;
        b=Airiuqzo2MXycaGOq8bi16ZySlT/lGpZzcvFKlfKzsGk/9pBVzCivWi24P287kCLkj
         rTitkYMHusEK5KBITH/Bkx8WXvWhMtqYDd6r0sa7nlrDUW9w0ajhjF1OQylbqcdvP4XD
         lYWOyaWvoODk4uMnSO5EqqhwZCtd+xGSlRFWw5zDvdEuwk2rtBeMTCb9WWHw2w/xGQhG
         7tYl8DWqaWkAG6s4N2RPHJTF3zOvgwIrqgRHTNFmzrJzn0rIWLfOXVoc/XLLa20T4vUy
         LWC4zEcDqnXf9UTwdnKYzPGtlu3l+cnbWuddmUrUntthrG9gAmzh7YESK4SpvFqcLvQG
         OtLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=HhHj3VwqhyDaKMBVif274pGYZMAuJsuDdkwv2l1zTa0=;
        b=yPH9EZsyo/iPOJOtaeMJfCLbviU+LLPBFfCHWAVVuObWE9L3qXwe6pKF302o+ZgVgk
         2wXo/eT52fhkRXqQnJcyY/GIbr1lmE+MofV2vJqbl6viGCDs8D+XW9a22Zo0wMgOC3oC
         6rXGEWmHPvfw0RH2DvxeaGLe1S6m/CP49N6vjjrNjULNttGeB9IRB2oOym7Fh3roHvRp
         oHKZohMPlrrZxiALQI2SNFWLwbRlN+keQjcRuY1kWJaDj1+FkkZCJbVXMxYB1g3j4n/w
         sD7kd/pvihYVntT7/sQ6DrNLZRJwRik4IbogmeeKXC4WQUSBP50ies9qsbDoDFtmLNRQ
         FwyQ==
X-Gm-Message-State: ACgBeo3yqyyTPNOWWMYG38IK9o6YSeA+DLDLdFoBce55m578MBs5YK9z
        XB53l/e2e4CwOJAqZvOAx0A=
X-Google-Smtp-Source: AA6agR4iDNy89WR0tQ/mBRWwTXOrj7RkondBkbsshnR4AyaZ5Frsgx3ekGZ4juGM0iZql6IheXzAcg==
X-Received: by 2002:a17:907:7615:b0:730:e1ad:b132 with SMTP id jx21-20020a170907761500b00730e1adb132mr579148ejc.744.1661279897449;
        Tue, 23 Aug 2022 11:38:17 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7758:1500:8528:d099:20f2:8fd6? (dynamic-2a01-0c22-7758-1500-8528-d099-20f2-8fd6.c22.pool.telefonica.de. [2a01:c22:7758:1500:8528:d099:20f2:8fd6])
        by smtp.googlemail.com with ESMTPSA id z2-20020a05640240c200b004471178888fsm1735696edb.92.2022.08.23.11.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 11:38:17 -0700 (PDT)
Message-ID: <1352c25c-b723-d2bd-c439-32fae87df5ba@gmail.com>
Date:   Tue, 23 Aug 2022 20:37:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next v3 4/5] r8169: remove support for chip version 50
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

v3:
- rebase patch

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h          |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     | 26 ++-----------------
 .../net/ethernet/realtek/r8169_phy_config.c   |  1 -
 3 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 7c85c4696..68cd71289 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -60,7 +60,7 @@ enum mac_version {
 	/* support for RTL_GIGA_MAC_VER_47 has been removed */
 	RTL_GIGA_MAC_VER_48,
 	/* support for RTL_GIGA_MAC_VER_49 has been removed */
-	RTL_GIGA_MAC_VER_50,
+	/* support for RTL_GIGA_MAC_VER_50 has been removed */
 	RTL_GIGA_MAC_VER_51,
 	RTL_GIGA_MAC_VER_52,
 	RTL_GIGA_MAC_VER_53,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index cc2bed903..0fa478e22 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -134,7 +134,6 @@ static const struct {
 	[RTL_GIGA_MAC_VER_44] = {"RTL8411b",		FIRMWARE_8411_2 },
 	[RTL_GIGA_MAC_VER_46] = {"RTL8168h/8111h",	FIRMWARE_8168H_2},
 	[RTL_GIGA_MAC_VER_48] = {"RTL8107e",		FIRMWARE_8107E_2},
-	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
 	[RTL_GIGA_MAC_VER_53] = {"RTL8168fp/RTL8117",			},
@@ -1197,7 +1196,7 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		return r8168dp_check_dash(tp) ? RTL_DASH_DP : RTL_DASH_NONE;
-	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_53:
+	case RTL_GIGA_MAC_VER_51 ... RTL_GIGA_MAC_VER_53:
 		return r8168ep_check_dash(tp) ? RTL_DASH_EP : RTL_DASH_NONE;
 	default:
 		return RTL_DASH_NONE;
@@ -3276,26 +3275,6 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 	rtl_pcie_state_l2l3_disable(tp);
 }
 
-static void rtl_hw_start_8168ep_2(struct rtl8169_private *tp)
-{
-	static const struct ephy_info e_info_8168ep_2[] = {
-		{ 0x00, 0xffff,	0x10a3 },
-		{ 0x19, 0xffff,	0xfc00 },
-		{ 0x1e, 0xffff,	0x20ea }
-	};
-
-	/* disable aspm and clock request before access ephy */
-	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8168ep_2);
-
-	rtl_hw_start_8168ep(tp);
-
-	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
-	RTL_W8(tp, MISC_1, RTL_R8(tp, MISC_1) & ~PFM_D3COLD_EN);
-
-	rtl_hw_aspm_clkreq_enable(tp, true);
-}
-
 static void rtl_hw_start_8168ep_3(struct rtl8169_private *tp)
 {
 	static const struct ephy_info e_info_8168ep_3[] = {
@@ -3722,7 +3701,6 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_44] = rtl_hw_start_8411_2,
 		[RTL_GIGA_MAC_VER_46] = rtl_hw_start_8168h_1,
 		[RTL_GIGA_MAC_VER_48] = rtl_hw_start_8168h_1,
-		[RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
 		[RTL_GIGA_MAC_VER_51] = rtl_hw_start_8168ep_3,
 		[RTL_GIGA_MAC_VER_52] = rtl_hw_start_8117,
 		[RTL_GIGA_MAC_VER_53] = rtl_hw_start_8117,
@@ -5159,7 +5137,7 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
 static void rtl_hw_initialize(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_53:
+	case RTL_GIGA_MAC_VER_51 ... RTL_GIGA_MAC_VER_53:
 		rtl8168ep_stop_cmac(tp);
 		fallthrough;
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index de1d78df4..99e4f06f8 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1185,7 +1185,6 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_44] = rtl8168g_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_46] = rtl8168h_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_48] = rtl8168h_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_52] = rtl8117_hw_phy_config,
 		[RTL_GIGA_MAC_VER_53] = rtl8117_hw_phy_config,
-- 
2.37.2


