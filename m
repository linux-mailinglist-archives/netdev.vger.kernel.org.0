Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3810E3390F
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFCT0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:26:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45533 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCT0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:26:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id b18so13280087wrq.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 12:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=75CbRHA1tSHGyf9Ctjpd3Ugm66hHJk2PuuxrjoUfRUw=;
        b=oevWJMjwQuxdwkPJzLvWYkFuLvhw8Hq6e+Q0MyIMge61a+DGcov3LV3O6wj9MPOdMm
         xT80zD8/YK4ElY1JncC4f8LZvmM9NpSvRrqpbY/1b3BWPHcd2F7Qlvnd/UV3QuiE7tts
         YC65PvC7UId4+JMxBXq8PBHhv1u4RzuyNVIKc40lyK9MnHHrU1iRmVimsioor1nv84oE
         Hx4CXebMUYiFQg+XzD/XoPFzkkNjHb7MCfz5UHU2E4naYi/HwFkM09DoBiDaEvbozpyZ
         QevcgzNwuhJ2fPH3mdKC35+sHTGmvyJsdYHqLH3l9g4gTBItoDuSKR5XYwv4LkUt31/f
         JiVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=75CbRHA1tSHGyf9Ctjpd3Ugm66hHJk2PuuxrjoUfRUw=;
        b=TjvYosH9rfbFz6t9OEltHdvdLRYl7KyZy2BFlmC9sdItL3/h0ApTEJZKecsazGL+Di
         vEJgWg7JQvXjzYILIi1Nf187d4f1nIR2mGs0cLeSO3qMUERIuy5jyCDZcPYEk97q9aRY
         GVkSz1t7dMAhgksUja//tNuvrxlwfTz+A7kjKox1/zhI0nMmYeTUdpbAF5dGRlwNebvo
         D28QGEm2YfJFrzvj/y4I95WrVpuiswk/ZPhtb5KL3e8cIyK9sZtxB3YeWgMlU0wRsK++
         H3kyvQTSXPzNRcN9y1YJIlxX4aWq6HGM1/Z05GLoW6d1jzA/TUivzqc5u/wgK13Dcrgu
         VTUw==
X-Gm-Message-State: APjAAAWxR/PatlFqoZNLeoPMPc8C6yXBKesq/+pBlKm39N0+fLG2Jp8I
        AyN+XAV0FsEbZla8zjKAs2NCXB9K
X-Google-Smtp-Source: APXvYqzY/+aCRWr/O0YBDWrwp01rJ4V3xw+8j4sufJKhA/P7eLfvDTfapO5cudG4gtikU3tChsT8Jg==
X-Received: by 2002:adf:df8f:: with SMTP id z15mr2152824wrl.140.1559590007952;
        Mon, 03 Jun 2019 12:26:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2453:b919:ed8b:94f6? (p200300EA8BF3BD002453B919ED8B94F6.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2453:b919:ed8b:94f6])
        by smtp.googlemail.com with ESMTPSA id o1sm27805964wre.76.2019.06.03.12.26.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 12:26:47 -0700 (PDT)
Subject: [PATCH net-next 2/4] r8169: simplify rtl_fw_write_firmware
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7c425378-dadb-399e-0a51-f226039e441f@gmail.com>
Message-ID: <3a50a637-89fc-25a5-836f-9dbd3c604a74@gmail.com>
Date:   Mon, 3 Jun 2019 21:24:38 +0200
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

Similar to rtl_fw_data_ok() we can simplify the code by moving
incrementing the index to the for loop initialization.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 1a1253237..7ba2107ae 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -2451,7 +2451,7 @@ static void rtl_fw_write_firmware(struct rtl8169_private *tp,
 	int predata = 0, count = 0;
 	size_t index;
 
-	for (index = 0; index < pa->size; ) {
+	for (index = 0; index < pa->size; index++) {
 		u32 action = le32_to_cpu(pa->code[index]);
 		u32 data = action & 0x0000ffff;
 		u32 regno = (action & 0x0fff0000) >> 16;
@@ -2464,18 +2464,15 @@ static void rtl_fw_write_firmware(struct rtl8169_private *tp,
 		case PHY_READ:
 			predata = fw_read(tp, regno);
 			count++;
-			index++;
 			break;
 		case PHY_DATA_OR:
 			predata |= data;
-			index++;
 			break;
 		case PHY_DATA_AND:
 			predata &= data;
-			index++;
 			break;
 		case PHY_BJMPN:
-			index -= regno;
+			index -= (regno + 1);
 			break;
 		case PHY_MDIO_CHG:
 			if (data == 0) {
@@ -2486,39 +2483,33 @@ static void rtl_fw_write_firmware(struct rtl8169_private *tp,
 				fw_read = rtl_fw->mac_mcu_read;
 			}
 
-			index++;
 			break;
 		case PHY_CLEAR_READCOUNT:
 			count = 0;
-			index++;
 			break;
 		case PHY_WRITE:
 			fw_write(tp, regno, data);
-			index++;
 			break;
 		case PHY_READCOUNT_EQ_SKIP:
-			index += (count == data) ? 2 : 1;
+			if (count == data)
+				index++;
 			break;
 		case PHY_COMP_EQ_SKIPN:
 			if (predata == data)
 				index += regno;
-			index++;
 			break;
 		case PHY_COMP_NEQ_SKIPN:
 			if (predata != data)
 				index += regno;
-			index++;
 			break;
 		case PHY_WRITE_PREVIOUS:
 			fw_write(tp, regno, predata);
-			index++;
 			break;
 		case PHY_SKIPN:
-			index += regno + 1;
+			index += regno;
 			break;
 		case PHY_DELAY_MS:
 			mdelay(data);
-			index++;
 			break;
 		}
 	}
-- 
2.21.0


