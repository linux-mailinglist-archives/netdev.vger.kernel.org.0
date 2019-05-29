Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3102E521
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 21:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfE2TPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 15:15:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55436 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2TPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 15:15:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id u78so2393445wmu.5
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 12:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q4MZWbaRk6sCXkVwURbJpviC1Ff89W2MYY0pwuiMULg=;
        b=XqZBbVQ0vhqc0bZ8vhIGFDiGSu2wTv+H4LXyt4/p5AJoB/MVQhJySH+cNeoj/IcV/B
         kqZDCGXLrhOQBKoQvlznnFnPpaXY8/DurvrOMRnVD0PLm/LlOmo0W/eqOfeN01p8s9F8
         awDNWO7O6jHab+RBKZMgDe4tUaVObtPN7GOn/sV75UDrRsBkjPunW374FmYEmXR5roeX
         tDP/tfff0S01jGsC0CdGGgsV+mMpigTPLsOCx+dLk0pyr+0QMwsDdudyjyEP68PwYrsE
         kA1g5uaRvjePChr08SZQ/i8DUc6OdTqt7zJzREXbK2/45/j+FRF0KlODfDb3I3NNoBTL
         NqfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q4MZWbaRk6sCXkVwURbJpviC1Ff89W2MYY0pwuiMULg=;
        b=oGY2gTLXGIaXj7Xo38i7m+Yt/RODDNtNaoeYBrbL1NPMP5rAZOrFrx4IlVO8iV6akf
         hcAFUo/KCh86lEp7qeMJkWS1af3vc2MbTAznxS2d8WH1GOShrROj9aZfNQAh8UM+SNhJ
         kR8rRyNdPLb+Xhelrp5Ee9Gkk2DkO01+QP8lK3dsYKbKNN1GQgpDAF3asP3qZSetlk2F
         Uei17E5OB5AKoDIis1oPoLK50rI2c9g/9CM2utqP3sbbcGjAs8CLOP1T1bK5iXcLHsD8
         QizT6HnKVtJhDU6DPaWLE/MZqYIYmRwsqv7ZM5iu3AnDvYDoJUN0eSGTLMVZuGRwCAiT
         eS5g==
X-Gm-Message-State: APjAAAV0VmJJJ06mUOQ02EIYqpW2DrGu8noedg71lnaByK5uA1F4cMf7
        ePU5Je/00L3q6Ub+ric2fPxlODKc
X-Google-Smtp-Source: APXvYqw6mlzarJpv/9qgAiGrDGM7XCAcLUkeFV4rcPGMPV2yjKHDUpph40648Wp5SIG4fTGDUsGLWA==
X-Received: by 2002:a1c:8049:: with SMTP id b70mr7644908wmd.33.1559157315346;
        Wed, 29 May 2019 12:15:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:c13b:48f0:87ee:c916? (p200300EA8BF3BD00C13B48F087EEC916.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:c13b:48f0:87ee:c916])
        by smtp.googlemail.com with ESMTPSA id s11sm250826wrb.71.2019.05.29.12.15.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 12:15:14 -0700 (PDT)
Subject: [PATCH net-next 1/2] r8169: improve rtl_fw_format_ok
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <57c46ad0-f086-7321-aeca-8744a607b622@gmail.com>
Message-ID: <9e9d2387-0257-03c8-254b-2289dcf02535@gmail.com>
Date:   Wed, 29 May 2019 21:13:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <57c46ad0-f086-7321-aeca-8744a607b622@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the function a little bit and use strscpy() where appropriate.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 89aeadc1d..af5359d20 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -2314,50 +2314,45 @@ static bool rtl_fw_format_ok(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
 	const struct firmware *fw = rtl_fw->fw;
 	struct fw_info *fw_info = (struct fw_info *)fw->data;
 	struct rtl_fw_phy_action *pa = &rtl_fw->phy_action;
-	char *version = rtl_fw->version;
-	bool rc = false;
 
 	if (fw->size < FW_OPCODE_SIZE)
-		goto out;
+		return false;
 
 	if (!fw_info->magic) {
 		size_t i, size, start;
 		u8 checksum = 0;
 
 		if (fw->size < sizeof(*fw_info))
-			goto out;
+			return false;
 
 		for (i = 0; i < fw->size; i++)
 			checksum += fw->data[i];
 		if (checksum != 0)
-			goto out;
+			return false;
 
 		start = le32_to_cpu(fw_info->fw_start);
 		if (start > fw->size)
-			goto out;
+			return false;
 
 		size = le32_to_cpu(fw_info->fw_len);
 		if (size > (fw->size - start) / FW_OPCODE_SIZE)
-			goto out;
+			return false;
 
-		memcpy(version, fw_info->version, RTL_VER_SIZE);
+		strscpy(rtl_fw->version, fw_info->version, RTL_VER_SIZE);
 
 		pa->code = (__le32 *)(fw->data + start);
 		pa->size = size;
 	} else {
 		if (fw->size % FW_OPCODE_SIZE)
-			goto out;
+			return false;
 
-		strlcpy(version, tp->fw_name, RTL_VER_SIZE);
+		strscpy(rtl_fw->version, tp->fw_name, RTL_VER_SIZE);
 
 		pa->code = (__le32 *)fw->data;
 		pa->size = fw->size / FW_OPCODE_SIZE;
 	}
-	version[RTL_VER_SIZE - 1] = 0;
 
-	rc = true;
-out:
-	return rc;
+	return true;
 }
 
 static bool rtl_fw_data_ok(struct rtl8169_private *tp, struct net_device *dev,
-- 
2.21.0


