Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D3C59E4D7
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 16:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242221AbiHWODf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 10:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243858AbiHWOBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 10:01:22 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFACD23EC6E
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:09:17 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id j21so21297423ejs.0
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=i8MDPOPOxocXhBL9bJJ/9P67ecB5fqUdYVjZ+KWbeLo=;
        b=gh8dpIJwiB8uva5gOI6yh8nUbzEqb/2jpRUP8iVlcJZR/CABcOU2eo42XWXOjaTKBH
         NG9JetP59ExvsPvj8JDsXHAbwF5i/zArNWJD+mjioo45T7NqBE43ggqzSdryCmPPI7w3
         8JN0Bq00xEzV156/4gCQkdqG05D4wnI7G658pxocWkQhwfOhQXl9pQBjoQrMITuJ3vDa
         31CueNhgX8ZZtM79uZbvo7MM7NUN7lLI7T7LPRIuJiGyj98SWlPGPrB4Pt5OW2E66DBU
         0jB2IbTYASwEI9vOQmcG+0S9bJo4l4iS/L9utFsnvERvYPhIj7NSExyAtIY1vr9bDwhe
         cc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=i8MDPOPOxocXhBL9bJJ/9P67ecB5fqUdYVjZ+KWbeLo=;
        b=2+cgXrhahp7Qn+KWwu2AN+6zhhH8lWawqNuzGrtnVdulWWqXTbuKd5tB7Ch/rBJjZ7
         NCK0A2NrbTmzxT9+k0bWO2cv7sk9OSl25Su0eHce/0LBoySOWTpGK6Wu6jr4mvFWLxBF
         ksQC/7bYgEyRMiYMk7cfKB9uWQ0Vpa8kXeZTG/GAPI6FBfigwahA8WkRpOWU9x/Qm6h8
         bmyhFtiqPHJg2EUPyUQN/ZA4fUScFuOaz488bbKnD9WiwxIQJxA4+dnXNKudQaxWZqYm
         o0tTBRpcamX9c2kAR3VGFOdNoIGc6XbXPQAGykTLo/7LEIAIU7C2lYsADVbKjdzdVzMr
         eM6A==
X-Gm-Message-State: ACgBeo3awnCcu5FOGHeSYWQlK7kiLzv0hIzgh76pc5WLKAyRzPnD1+1r
        dDdeUraO+wJBqAA3dOZQLe0=
X-Google-Smtp-Source: AA6agR7hJIaWmYhD5rdvvH3Mg0xO8Xqqx1fpX54omXJ6ucvjB0eW4OhONhydvdIjndZdi9uDLpYSYw==
X-Received: by 2002:a17:907:7dac:b0:739:8df9:3c16 with SMTP id oz44-20020a1709077dac00b007398df93c16mr16095776ejc.9.1661252889122;
        Tue, 23 Aug 2022 04:08:09 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8? (dynamic-2a01-0c22-7758-1500-d4cf-79a3-3d29-c3f8.c22.pool.telefonica.de. [2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8])
        by smtp.googlemail.com with ESMTPSA id z2-20020a50eb42000000b0044687e93f74sm1272535edp.43.2022.08.23.04.08.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 04:08:08 -0700 (PDT)
Message-ID: <715e4200-9cf3-b7c8-86cb-05c6c1b7ea4a@gmail.com>
Date:   Tue, 23 Aug 2022 13:06:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next v2 4/5] r8169: remove support for chip version 50
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

