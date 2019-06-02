Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9578322C1
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 10:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfFBIx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 04:53:56 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41265 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbfFBIx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 04:53:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so9237241wrm.8
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 01:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=646vwrdUjGPgp5Xpk69ulTEiumrAk6uCROQ1O1C4gW4=;
        b=Tq9GKLRmjdyn5JyFjcRzqRoXK2U3rptYc9k6nLkj/VOzi/KdnXUfkpPNuSTMSCzXTP
         1hLQrYSPsp/BLZNJsFfFm7Vq94COpT8vsjgUAldrOLIv6ie0HeYUhx2LaRZlJD382LDD
         38Vf/12ud5ZKneWuaIpkPlFW40+j97tvmLSIqS6qXqfMVnUhp5VrxYYkkQ2TaFSwKUnn
         Ve62XyslaHiafMJVro9uaH6dEg2ZgCiBWpQdO9Os5qkZpt4C2N7bXDvkcoK7pskww457
         ogfuRV15b93gcTLwsGk4fN9dSZViwIC0zT9M1eyglMlx+H3L68ntekrDMMdM0zxlHgG5
         A71w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=646vwrdUjGPgp5Xpk69ulTEiumrAk6uCROQ1O1C4gW4=;
        b=GcZ4F4t8p9xYIn3IoAMjZP333MFGuGtmIuEk+DBV83y9BjpZ8CQlRc6qG+6W9lP1ZO
         dfUoiSOr040gQaK+LueluH1IS5VzDzoIfeJGUGZ4z4EKXQAecwVY5rzguKB9WKF3l9sa
         o6OIesEmMKvfHnQ+clDlo6BdFCMjSoCjNm2YmdVblbsE+bs8OEXiL7sg0R65EeA2Sb5+
         xn8BVO3vOdWpXuq5grgM+IYB6E15/eb0dMVCIxtEa2ngXoPcOWMnL7fGL3oBztv13RVL
         CAS3EsaMCN3zueauismlFT/5L4N+zX7zQd1a1NQcmJRS4OstuK0YJ7L0HslZr4nGH+4m
         5Yfg==
X-Gm-Message-State: APjAAAXrCEg3lqBSe9K0lW3Pz+h4z54z17lFLFlRKKPDXAWWMGUOpaxy
        yjecGPg8B1aMNOFZN6Doq+RoH0Fz
X-Google-Smtp-Source: APXvYqyXfbXqJvZQNNF1pZmpqv+9eMTGvfenLsjUGczSVHtFhUT96JqDuyYu3suRXA//TmF/64Jjrw==
X-Received: by 2002:a5d:6745:: with SMTP id l5mr5149203wrw.160.1559465633841;
        Sun, 02 Jun 2019 01:53:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:5dff:1e78:fa4c:7fa7? (p200300EA8BF3BD005DFF1E78FA4C7FA7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:5dff:1e78:fa4c:7fa7])
        by smtp.googlemail.com with ESMTPSA id t6sm22450220wmt.34.2019.06.02.01.53.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 01:53:53 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: use paged versions of phylib MDIO access
 functions
Message-ID: <f7415a62-625d-06d8-0402-f2f8ef9764df@gmail.com>
Date:   Sun, 2 Jun 2019 10:53:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use paged versions of phylib MDIO access functions to simplify
the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 105 +++++++++------------------
 1 file changed, 33 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 2705eb510..53a4e3a73 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1969,9 +1969,7 @@ static int rtl_get_eee_supp(struct rtl8169_private *tp)
 		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
 		break;
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		phy_write(phydev, 0x1f, 0x0a5c);
-		ret = phy_read(phydev, 0x12);
-		phy_write(phydev, 0x1f, 0x0000);
+		ret = phy_read_paged(phydev, 0x0a5c, 0x12);
 		break;
 	default:
 		ret = -EPROTONOSUPPORT;
@@ -1994,9 +1992,7 @@ static int rtl_get_eee_lpadv(struct rtl8169_private *tp)
 		ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_LPABLE);
 		break;
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		phy_write(phydev, 0x1f, 0x0a5d);
-		ret = phy_read(phydev, 0x11);
-		phy_write(phydev, 0x1f, 0x0000);
+		ret = phy_read_paged(phydev, 0x0a5d, 0x11);
 		break;
 	default:
 		ret = -EPROTONOSUPPORT;
@@ -2019,9 +2015,7 @@ static int rtl_get_eee_adv(struct rtl8169_private *tp)
 		ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV);
 		break;
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		phy_write(phydev, 0x1f, 0x0a5d);
-		ret = phy_read(phydev, 0x10);
-		phy_write(phydev, 0x1f, 0x0000);
+		ret = phy_read_paged(phydev, 0x0a5d, 0x10);
 		break;
 	default:
 		ret = -EPROTONOSUPPORT;
@@ -2044,9 +2038,7 @@ static int rtl_set_eee_adv(struct rtl8169_private *tp, int val)
 		ret = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, val);
 		break;
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		phy_write(phydev, 0x1f, 0x0a5d);
-		phy_write(phydev, 0x10, val);
-		phy_write(phydev, 0x1f, 0x0000);
+		phy_write_paged(phydev, 0x0a5d, 0x10, val);
 		break;
 	default:
 		ret = -EPROTONOSUPPORT;
@@ -2582,9 +2574,7 @@ static void rtl8168f_config_eee_phy(struct rtl8169_private *tp)
 
 static void rtl8168g_config_eee_phy(struct rtl8169_private *tp)
 {
-	phy_write(tp->phydev, 0x1f, 0x0a43);
-	phy_set_bits(tp->phydev, 0x11, BIT(4));
-	phy_write(tp->phydev, 0x1f, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0a43, 0x11, 0, BIT(4));
 }
 
 static void rtl8169s_hw_phy_config(struct rtl8169_private *tp)
@@ -3483,20 +3473,15 @@ static void rtl8411_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8168g_disable_aldps(struct rtl8169_private *tp)
 {
-	phy_write(tp->phydev, 0x1f, 0x0a43);
-	phy_clear_bits(tp->phydev, 0x10, BIT(2));
+	phy_modify_paged(tp->phydev, 0x0a43, 0x10, BIT(2), 0);
 }
 
 static void rtl8168g_phy_adjust_10m_aldps(struct rtl8169_private *tp)
 {
 	struct phy_device *phydev = tp->phydev;
 
-	phy_write(phydev, 0x1f, 0x0bcc);
-	phy_clear_bits(phydev, 0x14, BIT(8));
-
-	phy_write(phydev, 0x1f, 0x0a44);
-	phy_set_bits(phydev, 0x11, BIT(7) | BIT(6));
-
+	phy_modify_paged(phydev, 0x0bcc, 0x14, BIT(8), 0);
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(7) | BIT(6));
 	phy_write(phydev, 0x1f, 0x0a43);
 	phy_write(phydev, 0x13, 0x8084);
 	phy_clear_bits(phydev, 0x14, BIT(14) | BIT(13));
@@ -3507,43 +3492,36 @@ static void rtl8168g_phy_adjust_10m_aldps(struct rtl8169_private *tp)
 
 static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
 {
+	int ret;
+
 	rtl_apply_firmware(tp);
 
-	rtl_writephy(tp, 0x1f, 0x0a46);
-	if (rtl_readphy(tp, 0x10) & 0x0100) {
-		rtl_writephy(tp, 0x1f, 0x0bcc);
-		rtl_w0w1_phy(tp, 0x12, 0x0000, 0x8000);
-	} else {
-		rtl_writephy(tp, 0x1f, 0x0bcc);
-		rtl_w0w1_phy(tp, 0x12, 0x8000, 0x0000);
-	}
+	ret = phy_read_paged(tp->phydev, 0x0a46, 0x10);
+	if (ret & BIT(8))
+		phy_modify_paged(tp->phydev, 0x0bcc, 0x12, BIT(15), 0);
+	else
+		phy_modify_paged(tp->phydev, 0x0bcc, 0x12, 0, BIT(15));
 
-	rtl_writephy(tp, 0x1f, 0x0a46);
-	if (rtl_readphy(tp, 0x13) & 0x0100) {
-		rtl_writephy(tp, 0x1f, 0x0c41);
-		rtl_w0w1_phy(tp, 0x15, 0x0002, 0x0000);
-	} else {
-		rtl_writephy(tp, 0x1f, 0x0c41);
-		rtl_w0w1_phy(tp, 0x15, 0x0000, 0x0002);
-	}
+	ret = phy_read_paged(tp->phydev, 0x0a46, 0x13);
+	if (ret & BIT(8))
+		phy_modify_paged(tp->phydev, 0x0c41, 0x12, 0, BIT(1));
+	else
+		phy_modify_paged(tp->phydev, 0x0c41, 0x12, BIT(1), 0);
 
 	/* Enable PHY auto speed down */
-	rtl_writephy(tp, 0x1f, 0x0a44);
-	rtl_w0w1_phy(tp, 0x11, 0x000c, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
 
 	rtl8168g_phy_adjust_10m_aldps(tp);
 
 	/* EEE auto-fallback function */
-	rtl_writephy(tp, 0x1f, 0x0a4b);
-	rtl_w0w1_phy(tp, 0x11, 0x0004, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0a4b, 0x11, 0, BIT(2));
 
 	/* Enable UC LPF tune function */
 	rtl_writephy(tp, 0x1f, 0x0a43);
 	rtl_writephy(tp, 0x13, 0x8012);
 	rtl_w0w1_phy(tp, 0x14, 0x8000, 0x0000);
 
-	rtl_writephy(tp, 0x1f, 0x0c42);
-	rtl_w0w1_phy(tp, 0x11, 0x4000, 0x2000);
+	phy_modify_paged(tp->phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
 	/* Improve SWR Efficiency */
 	rtl_writephy(tp, 0x1f, 0x0bcd);
@@ -3555,6 +3533,7 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x14, 0x1065);
 	rtl_writephy(tp, 0x14, 0x9065);
 	rtl_writephy(tp, 0x14, 0x1065);
+	rtl_writephy(tp, 0x1f, 0x0000);
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168g_config_eee_phy(tp);
@@ -3639,14 +3618,10 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* enable GPHY 10M */
-	rtl_writephy(tp, 0x1f, 0x0a44);
-	rtl_w0w1_phy(tp, 0x11, 0x0800, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(11));
 
 	/* SAR ADC performance */
-	rtl_writephy(tp, 0x1f, 0x0bca);
-	rtl_w0w1_phy(tp, 0x17, 0x4000, 0x3000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0bca, 0x17, BIT(12) | BIT(13), BIT(14));
 
 	rtl_writephy(tp, 0x1f, 0x0a43);
 	rtl_writephy(tp, 0x13, 0x803f);
@@ -3666,9 +3641,7 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* disable phy pfm mode */
-	rtl_writephy(tp, 0x1f, 0x0a44);
-	rtl_w0w1_phy(tp, 0x11, 0x0000, 0x0080);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0a44, 0x11, BIT(7), 0);
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168g_config_eee_phy(tp);
@@ -3698,9 +3671,7 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* enable GPHY 10M */
-	rtl_writephy(tp, 0x1f, 0x0a44);
-	rtl_w0w1_phy(tp, 0x11, 0x0800, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(11));
 
 	r8168_mac_ocp_write(tp, 0xdd02, 0x807d);
 	data = r8168_mac_ocp_read(tp, 0xdd02);
@@ -3736,9 +3707,7 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* disable phy pfm mode */
-	rtl_writephy(tp, 0x1f, 0x0a44);
-	rtl_w0w1_phy(tp, 0x11, 0x0000, 0x0080);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0a44, 0x11, BIT(7), 0);
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168g_config_eee_phy(tp);
@@ -3748,16 +3717,12 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp)
 {
 	/* Enable PHY auto speed down */
-	rtl_writephy(tp, 0x1f, 0x0a44);
-	rtl_w0w1_phy(tp, 0x11, 0x000c, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
 
 	rtl8168g_phy_adjust_10m_aldps(tp);
 
 	/* Enable EEE auto-fallback function */
-	rtl_writephy(tp, 0x1f, 0x0a4b);
-	rtl_w0w1_phy(tp, 0x11, 0x0004, 0x0000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0a4b, 0x11, 0, BIT(2));
 
 	/* Enable UC LPF tune function */
 	rtl_writephy(tp, 0x1f, 0x0a43);
@@ -3766,9 +3731,7 @@ static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* set rg_sel_sdm_rate */
-	rtl_writephy(tp, 0x1f, 0x0c42);
-	rtl_w0w1_phy(tp, 0x11, 0x4000, 0x2000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
 	rtl8168g_disable_aldps(tp);
 	rtl8168g_config_eee_phy(tp);
@@ -3786,9 +3749,7 @@ static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* Set rg_sel_sdm_rate */
-	rtl_writephy(tp, 0x1f, 0x0c42);
-	rtl_w0w1_phy(tp, 0x11, 0x4000, 0x2000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_modify_paged(tp->phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
 	/* Channel estimation parameters */
 	rtl_writephy(tp, 0x1f, 0x0a43);
-- 
2.21.0

