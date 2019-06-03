Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE7C933911
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfFCT0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:26:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40079 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfFCT0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:26:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so8474396wre.7
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 12:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YEFwJmeOODdaOh+90gAeFNVjzK/DT7u/kmA/weEOeCc=;
        b=pghu3iRmiGoJ7ixEGctXISPM8bbwhblVPsxO41lizLoRC0aJuK7PxR63lO49Q+rqao
         VP/aSWIUuieRUCDzYHVLCouNxdclmOmQyy1FVx7Z43XXWJb+odNGJopp9F645wqSc1A+
         Gy+Urz7roohR0J+f5NKRuj4c82xGlNdu1EMoVk3d0GEF+gRe0SVkYVOAaWOfmDCuaTFt
         kBeOm1ZDCHJiDzmYiqdtKowUOW26XoP/e7EqeuyvraDnvHPSj3X8COAcIopUn/pnKTvY
         UZDF9jzyeuFuWeI9QwUcyWVv4rF8rD6UW5+Uc3f5PoBEjzlGf3SjmAPyzkqcnGvbxfmh
         LrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YEFwJmeOODdaOh+90gAeFNVjzK/DT7u/kmA/weEOeCc=;
        b=JB2j+N4F+MwwPG2Cv+nhQeiIPJB5s+rFIzzE2SGdG5GBroon/n/y41/sZvyI5SusMj
         FZ0PXoV1ktO3gSl4BFuKq9qJKp3st4NwqfqY2WY5Rq/zJ2D7cidZpXjwQqxP2lMpym7m
         gGfKwPyrBvloB3CblyqaPi8jezukrnGjkYJpiL6/0iB8kK/VENIC0Q75qV5hKIxkjfd7
         PPtM2Y1pm5LSlghCyaFye/mwmputL1yI4KlZgiEaySviQYl0WkUf8vY1cQjgt9NddYpg
         ZKmgSj62EkXIYddru/uPHMSehX94T+rzrYG15k1UEwFPfftq/vA9M1l7/+INFpX3OH45
         jRZg==
X-Gm-Message-State: APjAAAXEkI6zCCFwgKlwASRP/hK1y99KCm2i832kyPJhyfM6VVQwTYKY
        sciRYtMaEw/ItFt9QGBsgKKPao/E
X-Google-Smtp-Source: APXvYqxwzii0hsw5x8VhmPb2GTKiPzFm3wLf9dBkY4704jipLPoXxxk+rcKcHm7h5U7+u59ru48mag==
X-Received: by 2002:adf:cc85:: with SMTP id p5mr3430135wrj.47.1559590009179;
        Mon, 03 Jun 2019 12:26:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2453:b919:ed8b:94f6? (p200300EA8BF3BD002453B919ED8B94F6.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2453:b919:ed8b:94f6])
        by smtp.googlemail.com with ESMTPSA id k2sm15758739wrx.84.2019.06.03.12.26.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 12:26:48 -0700 (PDT)
Subject: [PATCH net-next 3/4] r8169: make rtl_fw_format_ok and rtl_fw_data_ok
 more independent
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7c425378-dadb-399e-0a51-f226039e441f@gmail.com>
Message-ID: <086d40ea-af81-4daf-5618-b43808ecc577@gmail.com>
Date:   Mon, 3 Jun 2019 21:25:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7c425378-dadb-399e-0a51-f226039e441f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of factoring out the firmware handling code avoid any
usage of struct rtl8169_private internals. As part of it we can inline
rtl_check_firmware.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 58 +++++++++-------------------
 1 file changed, 19 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 7ba2107ae..e7b11324c 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -677,6 +677,8 @@ struct rtl8169_private {
 		rtl_fw_write_t mac_mcu_write;
 		rtl_fw_read_t mac_mcu_read;
 		const struct firmware *fw;
+		const char *fw_name;
+		struct device *dev;
 
 #define RTL_VER_SIZE		32
 
@@ -2324,7 +2326,7 @@ struct fw_info {
 
 #define FW_OPCODE_SIZE	sizeof(typeof(*((struct rtl_fw_phy_action *)0)->code))
 
-static bool rtl_fw_format_ok(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
+static bool rtl_fw_format_ok(struct rtl_fw *rtl_fw)
 {
 	const struct firmware *fw = rtl_fw->fw;
 	struct fw_info *fw_info = (struct fw_info *)fw->data;
@@ -2361,7 +2363,7 @@ static bool rtl_fw_format_ok(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 		if (fw->size % FW_OPCODE_SIZE)
 			return false;
 
-		strscpy(rtl_fw->version, tp->fw_name, RTL_VER_SIZE);
+		strscpy(rtl_fw->version, rtl_fw->fw_name, RTL_VER_SIZE);
 
 		pa->code = (__le32 *)fw->data;
 		pa->size = fw->size / FW_OPCODE_SIZE;
@@ -2370,10 +2372,9 @@ static bool rtl_fw_format_ok(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 	return true;
 }
 
-static bool rtl_fw_data_ok(struct rtl8169_private *tp, struct net_device *dev,
-			   struct rtl_fw_phy_action *pa)
+static bool rtl_fw_data_ok(struct rtl_fw *rtl_fw)
 {
-	bool rc = false;
+	struct rtl_fw_phy_action *pa = &rtl_fw->phy_action;
 	size_t index;
 
 	for (index = 0; index < pa->size; index++) {
@@ -2392,54 +2393,30 @@ static bool rtl_fw_data_ok(struct rtl8169_private *tp, struct net_device *dev,
 			break;
 
 		case PHY_BJMPN:
-			if (regno > index) {
-				netif_err(tp, ifup, tp->dev,
-					  "Out of range of firmware\n");
+			if (regno > index)
 				goto out;
-			}
 			break;
 		case PHY_READCOUNT_EQ_SKIP:
-			if (index + 2 >= pa->size) {
-				netif_err(tp, ifup, tp->dev,
-					  "Out of range of firmware\n");
+			if (index + 2 >= pa->size)
 				goto out;
-			}
 			break;
 		case PHY_COMP_EQ_SKIPN:
 		case PHY_COMP_NEQ_SKIPN:
 		case PHY_SKIPN:
-			if (index + 1 + regno >= pa->size) {
-				netif_err(tp, ifup, tp->dev,
-					  "Out of range of firmware\n");
+			if (index + 1 + regno >= pa->size)
 				goto out;
-			}
 			break;
 
 		default:
-			netif_err(tp, ifup, tp->dev,
-				  "Invalid action 0x%08x\n", action);
-			goto out;
+			dev_err(rtl_fw->dev, "Invalid action 0x%08x\n", action);
+			return false;
 		}
 	}
-	rc = true;
-out:
-	return rc;
-}
-
-static int rtl_check_firmware(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
-{
-	struct net_device *dev = tp->dev;
-	int rc = -EINVAL;
-
-	if (!rtl_fw_format_ok(tp, rtl_fw)) {
-		netif_err(tp, ifup, dev, "invalid firmware\n");
-		goto out;
-	}
 
-	if (rtl_fw_data_ok(tp, dev, &rtl_fw->phy_action))
-		rc = 0;
+	return true;
 out:
-	return rc;
+	dev_err(rtl_fw->dev, "Out of range of firmware\n");
+	return false;
 }
 
 static void rtl_fw_write_firmware(struct rtl8169_private *tp,
@@ -4289,14 +4266,17 @@ static void rtl_request_firmware(struct rtl8169_private *tp)
 	rtl_fw->phy_read = rtl_readphy;
 	rtl_fw->mac_mcu_write = mac_mcu_write;
 	rtl_fw->mac_mcu_read = mac_mcu_read;
+	rtl_fw->fw_name = tp->fw_name;
+	rtl_fw->dev = tp_to_dev(tp);
 
 	rc = request_firmware(&rtl_fw->fw, tp->fw_name, tp_to_dev(tp));
 	if (rc < 0)
 		goto err_free;
 
-	rc = rtl_check_firmware(tp, rtl_fw);
-	if (rc < 0)
+	if (!rtl_fw_format_ok(rtl_fw) || !rtl_fw_data_ok(rtl_fw)) {
+		dev_err(rtl_fw->dev, "invalid firmware\n");
 		goto err_release_firmware;
+	}
 
 	tp->rtl_fw = rtl_fw;
 
-- 
2.21.0


