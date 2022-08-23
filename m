Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2D259E4DC
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 16:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242413AbiHWODh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 10:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243871AbiHWOBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 10:01:23 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFFE23EC56
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:09:13 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id y3so318215ejc.1
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=NSAqLKm5v7LC885LP4TJhDfY36sDMzCl5TSFE2NC9zg=;
        b=RDIg1K2JOQSULe4SwJvMvODkelbQN3dSg+pvNg6Be/XNTF7R/Vv0fl9rRcrTwJf57R
         Sroq5r/30KZr0J5N/tPIXcG9t4971+1tTkRxnVeK+ws3Kdj8WC42FOwhXsMf9DNUMT+Y
         3AL931T9osWc1s6wcs4Z6Ui4Gob+xHuy8SJOOyz+cHE1jEY9C7djTev8FSayxuzt0hBn
         6LTtaaEnmWNcM6JxrDbddVdjA5ulI9VeHdY16K6g+fPE+Ya3+DVBB7q4MpqasUD3tyYe
         1bCjDliab9UYgaTkDEvSxTngy/DF4lHFG7YistbtlHvDDHMtEXeecXofMkU+yGRNwryK
         0Ygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=NSAqLKm5v7LC885LP4TJhDfY36sDMzCl5TSFE2NC9zg=;
        b=PkFJ9NBxquzfCdQ/b2AH3ZV5QfkSGm0ofecB6q4bVLVXF5ars2PVP+MzJXdK6jO48+
         rR651X39TExiolfMTnbPuYWnQG6z8emFSpl4AFE6MIDGatlNUSoOi/e0wGEtkek5JFoj
         LLKMtmajMTK1bnv7VMTD02YSaC+bvXzYVL+B0+VYDYPRTAlcVQzcogZH3A+CZkN+5qEc
         8gGtx5yyrPHjM1oenai5fDw1Nplu9iyboz4KhtmxJ6iAo9MmdrNG3ZVF7bMcdoWx+7sS
         PPF2nWLh0tYwu3lyprZMa1tCFj4HpHPl3fJbN6TJhUqKuWLSlxAZticYqezwSeVHbx2Q
         7WHA==
X-Gm-Message-State: ACgBeo2JWzWU7ItWTP4xq+mvuKK/3OhxkbKQ9Yxe1DzIDtI+PdRiHWzu
        uimx7Xu9aq7z8nxMjaMovzE=
X-Google-Smtp-Source: AA6agR7jzTLIgXrwz+ZfKWiaW//0F97vu5UpiIxRP0lewPPTeqNUF5CvuauwjJ/eoTacXsoLOzqUFw==
X-Received: by 2002:a17:906:5d08:b0:734:bf6a:6309 with SMTP id g8-20020a1709065d0800b00734bf6a6309mr15602191ejt.516.1661252887036;
        Tue, 23 Aug 2022 04:08:07 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8? (dynamic-2a01-0c22-7758-1500-d4cf-79a3-3d29-c3f8.c22.pool.telefonica.de. [2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8])
        by smtp.googlemail.com with ESMTPSA id e4-20020a056402088400b0043cb1a83c9fsm1238980edy.71.2022.08.23.04.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 04:08:06 -0700 (PDT)
Message-ID: <80c13c4f-ddc8-42bb-19b4-ae499f464e57@gmail.com>
Date:   Tue, 23 Aug 2022 13:03:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: [PATCH net-next v2 2/5] r8169: remove support for chip versions 45
 and 47
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

Detection of these chip versions has been disabled for few kernel versions now.
Nobody complained, so remove support for this chip version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h          |  4 +-
 drivers/net/ethernet/realtek/r8169_main.c     | 16 +----
 .../net/ethernet/realtek/r8169_phy_config.c   | 67 -------------------
 3 files changed, 5 insertions(+), 82 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index e2ace50e0..a66b10850 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -55,9 +55,9 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_42,
 	RTL_GIGA_MAC_VER_43,
 	RTL_GIGA_MAC_VER_44,
-	RTL_GIGA_MAC_VER_45,
+	/* support for RTL_GIGA_MAC_VER_45 has been removed */
 	RTL_GIGA_MAC_VER_46,
-	RTL_GIGA_MAC_VER_47,
+	/* support for RTL_GIGA_MAC_VER_47 has been removed */
 	RTL_GIGA_MAC_VER_48,
 	RTL_GIGA_MAC_VER_49,
 	RTL_GIGA_MAC_VER_50,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a2baeb8da..0e7d10cd6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -49,10 +49,8 @@
 #define FIRMWARE_8106E_2	"rtl_nic/rtl8106e-2.fw"
 #define FIRMWARE_8168G_2	"rtl_nic/rtl8168g-2.fw"
 #define FIRMWARE_8168G_3	"rtl_nic/rtl8168g-3.fw"
-#define FIRMWARE_8168H_1	"rtl_nic/rtl8168h-1.fw"
 #define FIRMWARE_8168H_2	"rtl_nic/rtl8168h-2.fw"
 #define FIRMWARE_8168FP_3	"rtl_nic/rtl8168fp-3.fw"
-#define FIRMWARE_8107E_1	"rtl_nic/rtl8107e-1.fw"
 #define FIRMWARE_8107E_2	"rtl_nic/rtl8107e-2.fw"
 #define FIRMWARE_8125A_3	"rtl_nic/rtl8125a-3.fw"
 #define FIRMWARE_8125B_2	"rtl_nic/rtl8125b-2.fw"
@@ -134,9 +132,7 @@ static const struct {
 	[RTL_GIGA_MAC_VER_42] = {"RTL8168gu/8111gu",	FIRMWARE_8168G_3},
 	[RTL_GIGA_MAC_VER_43] = {"RTL8106eus",		FIRMWARE_8106E_2},
 	[RTL_GIGA_MAC_VER_44] = {"RTL8411b",		FIRMWARE_8411_2 },
-	[RTL_GIGA_MAC_VER_45] = {"RTL8168h/8111h",	FIRMWARE_8168H_1},
 	[RTL_GIGA_MAC_VER_46] = {"RTL8168h/8111h",	FIRMWARE_8168H_2},
-	[RTL_GIGA_MAC_VER_47] = {"RTL8107e",		FIRMWARE_8107E_1},
 	[RTL_GIGA_MAC_VER_48] = {"RTL8107e",		FIRMWARE_8107E_2},
 	[RTL_GIGA_MAC_VER_49] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
@@ -657,10 +653,8 @@ MODULE_FIRMWARE(FIRMWARE_8106E_1);
 MODULE_FIRMWARE(FIRMWARE_8106E_2);
 MODULE_FIRMWARE(FIRMWARE_8168G_2);
 MODULE_FIRMWARE(FIRMWARE_8168G_3);
-MODULE_FIRMWARE(FIRMWARE_8168H_1);
 MODULE_FIRMWARE(FIRMWARE_8168H_2);
 MODULE_FIRMWARE(FIRMWARE_8168FP_3);
-MODULE_FIRMWARE(FIRMWARE_8107E_1);
 MODULE_FIRMWARE(FIRMWARE_8107E_2);
 MODULE_FIRMWARE(FIRMWARE_8125A_3);
 MODULE_FIRMWARE(FIRMWARE_8125B_2);
@@ -2086,8 +2080,6 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 	if (ver != RTL_GIGA_MAC_NONE && !gmii) {
 		if (ver == RTL_GIGA_MAC_VER_42)
 			ver = RTL_GIGA_MAC_VER_43;
-		else if (ver == RTL_GIGA_MAC_VER_45)
-			ver = RTL_GIGA_MAC_VER_47;
 		else if (ver == RTL_GIGA_MAC_VER_46)
 			ver = RTL_GIGA_MAC_VER_48;
 	}
@@ -2698,7 +2690,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
 
 		switch (tp->mac_version) {
-		case RTL_GIGA_MAC_VER_45 ... RTL_GIGA_MAC_VER_48:
+		case RTL_GIGA_MAC_VER_46 ... RTL_GIGA_MAC_VER_48:
 		case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
 			/* reset ephy tx/rx disable timer */
 			r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
@@ -2710,7 +2702,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		}
 	} else {
 		switch (tp->mac_version) {
-		case RTL_GIGA_MAC_VER_45 ... RTL_GIGA_MAC_VER_48:
+		case RTL_GIGA_MAC_VER_46 ... RTL_GIGA_MAC_VER_48:
 		case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
 			r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
 			break;
@@ -3749,9 +3741,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_42] = rtl_hw_start_8168g_2,
 		[RTL_GIGA_MAC_VER_43] = rtl_hw_start_8168g_2,
 		[RTL_GIGA_MAC_VER_44] = rtl_hw_start_8411_2,
-		[RTL_GIGA_MAC_VER_45] = rtl_hw_start_8168h_1,
 		[RTL_GIGA_MAC_VER_46] = rtl_hw_start_8168h_1,
-		[RTL_GIGA_MAC_VER_47] = rtl_hw_start_8168h_1,
 		[RTL_GIGA_MAC_VER_48] = rtl_hw_start_8168h_1,
 		[RTL_GIGA_MAC_VER_49] = rtl_hw_start_8168ep_1,
 		[RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
@@ -5375,7 +5365,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (rtl_aspm_is_safe(tp))
 		rc = 0;
-	else if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
+	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
 		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
 	else
 		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 2b4bc2d6f..8653f678a 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -793,71 +793,6 @@ static void rtl8168g_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl8168g_config_eee_phy(phydev);
 }
 
-static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	u16 dout_tapbin;
-	u32 data;
-
-	r8169_apply_firmware(tp);
-
-	/* CHN EST parameters adjust - giga master */
-	r8168g_phy_param(phydev, 0x809b, 0xf800, 0x8000);
-	r8168g_phy_param(phydev, 0x80a2, 0xff00, 0x8000);
-	r8168g_phy_param(phydev, 0x80a4, 0xff00, 0x8500);
-	r8168g_phy_param(phydev, 0x809c, 0xff00, 0xbd00);
-
-	/* CHN EST parameters adjust - giga slave */
-	r8168g_phy_param(phydev, 0x80ad, 0xf800, 0x7000);
-	r8168g_phy_param(phydev, 0x80b4, 0xff00, 0x5000);
-	r8168g_phy_param(phydev, 0x80ac, 0xff00, 0x4000);
-
-	/* CHN EST parameters adjust - fnet */
-	r8168g_phy_param(phydev, 0x808e, 0xff00, 0x1200);
-	r8168g_phy_param(phydev, 0x8090, 0xff00, 0xe500);
-	r8168g_phy_param(phydev, 0x8092, 0xff00, 0x9f00);
-
-	/* enable R-tune & PGA-retune function */
-	dout_tapbin = 0;
-	data = phy_read_paged(phydev, 0x0a46, 0x13);
-	data &= 3;
-	data <<= 2;
-	dout_tapbin |= data;
-	data = phy_read_paged(phydev, 0x0a46, 0x12);
-	data &= 0xc000;
-	data >>= 14;
-	dout_tapbin |= data;
-	dout_tapbin = ~(dout_tapbin ^ 0x08);
-	dout_tapbin <<= 12;
-	dout_tapbin &= 0xf000;
-
-	r8168g_phy_param(phydev, 0x827a, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x827b, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x827c, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x827d, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x0811, 0x0000, 0x0800);
-	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
-
-	rtl8168g_enable_gphy_10m(phydev);
-
-	/* SAR ADC performance */
-	phy_modify_paged(phydev, 0x0bca, 0x17, BIT(12) | BIT(13), BIT(14));
-
-	r8168g_phy_param(phydev, 0x803f, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x8047, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x804f, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x8057, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x805f, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x8067, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x806f, 0x3000, 0x0000);
-
-	/* disable phy pfm mode */
-	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
-
-	rtl8168g_disable_aldps(phydev);
-	rtl8168h_config_eee_phy(phydev);
-}
-
 static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
@@ -1269,9 +1204,7 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_42] = rtl8168g_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_43] = rtl8168g_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_44] = rtl8168g_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_45] = rtl8168h_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_46] = rtl8168h_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_47] = rtl8168h_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_48] = rtl8168h_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_49] = rtl8168ep_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
-- 
2.37.2

