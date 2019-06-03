Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3DD3390E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFCT0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:26:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33848 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCT0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:26:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id e16so5060563wrn.1
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 12:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ts0kP2ZYkFVlbb/s5zvJXlz9nNQy3ld9BrAOOiD1U+8=;
        b=EPtHvR2xGQdvr3FjwxIkCVCdo5awPPl4Tu5RBMlcWauuRp/RRChjNsndmqZv3mY+8N
         Z3vka48O8iPwu/ptqFUWsmJ57b+pAq35pZRyOSdp8/bTsKxPgp2IupqKU8YuqSsqcr1l
         6Tgajj8P205GNp6rUJjYJwmqKH6ufbWRBeEpbKo0LDI8svSIKF71V4o0lMadrncu2lk0
         XHjdRd2lvfD+cuu4Zo8hOttu3AztVm7zRut7flPMYAxtYJu4dhjr3aPY//lisIHoszZn
         BQy1gADTshus2kAfBeonMGNQEESjsyHhJL2BJ9js7rEqS7Az04HC5ZDZQ3XcAJMzNKbV
         xw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ts0kP2ZYkFVlbb/s5zvJXlz9nNQy3ld9BrAOOiD1U+8=;
        b=TZb3Yt8xBC9NB0ZY2Af4ZjIAF1IBqwMKPcTpmToUHIB9luDuny38HSmdWTSBtMmVcH
         fBDkz0ilTGL/5bU8v4nhdDJ23PwHXV+e+O/jvNztSdFFZG9OFG3pqDYLgRcE/iiA+yv/
         tQUt9DZKfifc3JmwIsgAOWMoyoXBZ70Vr4+KLDKyFJ3WHkoJCUZKvhWy2hogfQGDBteK
         EFzNhwPALXA+sfKTKYh6/Sxp9kSkGYDGdEWMrrrBC2tyOcSKYYZwnv6BsWkeaQSZf+yr
         oT6LvWANglOywTtjPJiTlqVZVSncClDUwJz/LFu1sycTUIT08zMC1SMim94+YXm8Wz94
         hTsQ==
X-Gm-Message-State: APjAAAXIftjx7rvSWWjtCCQsxgt2IvNrdjMLqElbVWqyDpaAdm5QmB3V
        imnTrM6re8Eo8SXtNz0rPuSrPuhZ
X-Google-Smtp-Source: APXvYqx21gvyDqCAwYIyT+FUSxkVtVrJyhdnRT7xDCArxJuv1jPYWm3E7PiVnxeggKsIeGCGMLbb/Q==
X-Received: by 2002:a5d:5283:: with SMTP id c3mr3526093wrv.268.1559590006596;
        Mon, 03 Jun 2019 12:26:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2453:b919:ed8b:94f6? (p200300EA8BF3BD002453B919ED8B94F6.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2453:b919:ed8b:94f6])
        by smtp.googlemail.com with ESMTPSA id l18sm35860763wrh.54.2019.06.03.12.26.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 12:26:46 -0700 (PDT)
Subject: [PATCH net-next 1/4] r8169: add enum rtl_fw_opcode
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7c425378-dadb-399e-0a51-f226039e441f@gmail.com>
Message-ID: <228f3b17-240f-5e43-527c-6877e69c5253@gmail.com>
Date:   Mon, 3 Jun 2019 21:23:43 +0200
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

Replace the firmware opcode defines with a proper enum. The BUG()
in rtl_fw_write_firmware() can be removed because the call to
rtl_fw_data_ok() ensures all opcodes are valid.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 36 ++++++++++++++--------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 53a4e3a73..1a1253237 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -2298,19 +2298,21 @@ static void __rtl_writephy_batch(struct rtl8169_private *tp,
 
 #define rtl_writephy_batch(tp, a) __rtl_writephy_batch(tp, a, ARRAY_SIZE(a))
 
-#define PHY_READ		0x00000000
-#define PHY_DATA_OR		0x10000000
-#define PHY_DATA_AND		0x20000000
-#define PHY_BJMPN		0x30000000
-#define PHY_MDIO_CHG		0x40000000
-#define PHY_CLEAR_READCOUNT	0x70000000
-#define PHY_WRITE		0x80000000
-#define PHY_READCOUNT_EQ_SKIP	0x90000000
-#define PHY_COMP_EQ_SKIPN	0xa0000000
-#define PHY_COMP_NEQ_SKIPN	0xb0000000
-#define PHY_WRITE_PREVIOUS	0xc0000000
-#define PHY_SKIPN		0xd0000000
-#define PHY_DELAY_MS		0xe0000000
+enum rtl_fw_opcode {
+	PHY_READ		= 0x0,
+	PHY_DATA_OR		= 0x1,
+	PHY_DATA_AND		= 0x2,
+	PHY_BJMPN		= 0x3,
+	PHY_MDIO_CHG		= 0x4,
+	PHY_CLEAR_READCOUNT	= 0x7,
+	PHY_WRITE		= 0x8,
+	PHY_READCOUNT_EQ_SKIP	= 0x9,
+	PHY_COMP_EQ_SKIPN	= 0xa,
+	PHY_COMP_NEQ_SKIPN	= 0xb,
+	PHY_WRITE_PREVIOUS	= 0xc,
+	PHY_SKIPN		= 0xd,
+	PHY_DELAY_MS		= 0xe,
+};
 
 struct fw_info {
 	u32	magic;
@@ -2378,7 +2380,7 @@ static bool rtl_fw_data_ok(struct rtl8169_private *tp, struct net_device *dev,
 		u32 action = le32_to_cpu(pa->code[index]);
 		u32 regno = (action & 0x0fff0000) >> 16;
 
-		switch(action & 0xf0000000) {
+		switch (action >> 28) {
 		case PHY_READ:
 		case PHY_DATA_OR:
 		case PHY_DATA_AND:
@@ -2453,11 +2455,12 @@ static void rtl_fw_write_firmware(struct rtl8169_private *tp,
 		u32 action = le32_to_cpu(pa->code[index]);
 		u32 data = action & 0x0000ffff;
 		u32 regno = (action & 0x0fff0000) >> 16;
+		enum rtl_fw_opcode opcode = action >> 28;
 
 		if (!action)
 			break;
 
-		switch(action & 0xf0000000) {
+		switch (opcode) {
 		case PHY_READ:
 			predata = fw_read(tp, regno);
 			count++;
@@ -2517,9 +2520,6 @@ static void rtl_fw_write_firmware(struct rtl8169_private *tp,
 			mdelay(data);
 			index++;
 			break;
-
-		default:
-			BUG();
 		}
 	}
 }
-- 
2.21.0


