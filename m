Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9028559AE93
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 15:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346093AbiHTNyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 09:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346048AbiHTNyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 09:54:43 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E4F71711
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:54:41 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b16so8679305edd.4
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 06:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=i8MDPOPOxocXhBL9bJJ/9P67ecB5fqUdYVjZ+KWbeLo=;
        b=GcpN+3ma1XQlVjBxYa+iWbEBiUqQORnQAmTizHiIIzsy7PhstY5Ey45ziQ7vv51VMU
         WhRxAWangEcQWMdUJ84Hw3ePsAGqpNa8jw8rN8o6+pNB3BLb6XipFNNVCJzR/hNIStfC
         M/mFRdlYmncQOIa3cng30moJ1yZFHrVULbT8nS6+CZtzx8C4B6Rc0FRaO/O4nUatewaN
         PIZHRwBqeHwuk3krkbEIA8s54f3W1+aErQPJMs1d7HaLIUtpnjzSrqzMU7qplBJ5znQs
         5ijBUVSA3O5mBaRxeyZksGqXb4Khm9zBDCYpAK7FILuMEyskvW7o1iQ/5RtUN7R/plbQ
         uG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=i8MDPOPOxocXhBL9bJJ/9P67ecB5fqUdYVjZ+KWbeLo=;
        b=WdpamX5LVAxiOzJ1xxW4CYbzzuAOlypQ6Ztl0QK60IGve2YsqxNlG4RQnxMqI0WW11
         QkjCfI1ceVuIf2yw2zjg5C+DKvRP09Fdmc4FQfJWwyRCaVcI4jGTw4JlVYOHQlQATDYD
         ImyivB/xVAG0R5PBXTyAoxhJSibci6HzLbOjnrrH8Z5kke6vEX83OMh9pZHO5psqqLoZ
         ybHE0GGaCdstIZtMkXjPPEAGC471jOnbbNJyJtbZoPV/EdPv5AinkeZWOUktOoUdm1ZV
         Bf4tNu77dCEdusnpqkQS0otK05Ne5RTy7Knyfa6MvM/0LDGhwuswTHyrTFp67rlNuytB
         nEBA==
X-Gm-Message-State: ACgBeo2qiHAp7TSeLu5li0TIVYCMUYtv0PR/2lvYCV/f5iVOpWQ8JiRC
        MX5ZBKMQr7jbEY0IGpJrwolTzO06I4E=
X-Google-Smtp-Source: AA6agR6kgNSQCe8GpPpXVuAI+q0RKyE8L4z3XznLuzn67eS+YjcRvmwnHRllB6w0jGSmao9nKjWWIA==
X-Received: by 2002:a05:6402:5510:b0:43a:76ff:b044 with SMTP id fi16-20020a056402551000b0043a76ffb044mr9701295edb.197.1661003679726;
        Sat, 20 Aug 2022 06:54:39 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531? (dynamic-2a01-0c23-c0bb-f700-3cb6-47a0-41b9-1531.c23.pool.telefonica.de. [2a01:c23:c0bb:f700:3cb6:47a0:41b9:1531])
        by smtp.googlemail.com with ESMTPSA id c4-20020a170906694400b0073048c183a2sm3562759ejs.110.2022.08.20.06.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Aug 2022 06:54:39 -0700 (PDT)
Message-ID: <e26a13f4-1f72-89a3-1f45-e75a7b5d16c8@gmail.com>
Date:   Sat, 20 Aug 2022 15:53:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next 4/5] r8169: remove support for chip version 50
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
 drivers/net/ethernet/realtek/r8169.h          |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     | 24 +------------------
 .../net/ethernet/realtek/r8169_phy_config.c   |  1 -
 3 files changed, 2 insertions(+), 25 deletions(-)

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
index b22b80aab..db653776e 100644
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


