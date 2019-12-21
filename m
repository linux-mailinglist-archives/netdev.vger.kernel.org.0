Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 915CA128928
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 14:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfLUNPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 08:15:54 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45464 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfLUNPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 08:15:53 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so11983963wrj.12
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 05:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=b+01DHsjgzWzNigG4PLZ1ooESzXnVsXUp8lBVQelzWI=;
        b=HHFQAO6DwSQMtM+Uum5jdZO7BA/je9l0l3IcLkGpUx2TwQSjgObsrm2bPhQ7/g4zDR
         Qs7zsQM+DpOR3fO3RwPb3+4AbvCVkQLD7s5lN5tG5+1wq8Q5LAfaHeEUmgwDRavKdlRF
         ic8sFZXCA8u6Cmr4JlT18qrmfKV2o5ybBrVVteUFAJ9k8Y1b2ONIzMgUDF8EXruLWUfs
         Ycav9+QUTe88mulefifYaUv11P5zOkMsRdcsPctErvtNw1h0VxsEJoomBb2gutg9DuPx
         FyZ4g0jOEIu0Wbmep2VEE4bGVzRVUxROaD3gtZEjQ4dQ67lGclFc+COkLr/b+PVSyUqH
         gigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=b+01DHsjgzWzNigG4PLZ1ooESzXnVsXUp8lBVQelzWI=;
        b=SnIIoqvAm2vPl5nU9EK34dCHPdco+9pHO/A1Gpqp4puCRQnRhpT7SYELTRATtZVvB9
         VKitf1l+sjQivvQGRI14+s063hbCyg92186RWq0cEv5Rpy6hKSmJBQupmywND8GbNlim
         3n4ODf6gy5ZgZHB+Q2UN/R3dI7O9fTdiBrewzJ5kfElMrM4OPJqnbabJ07o6XaROVBG0
         p1COB4m4Ff7SHeJCJ8Dtmn4hdj7dhQ9nAKgCVQIM32Q9flg7ZebNWlRaI3DsB3zhGR1T
         a5AM3PWOPMQErlcpHJbUmurFfYrzzQXs33fPXNsujqcoKGRNwumb1PCGcG3SBFarou//
         WwqQ==
X-Gm-Message-State: APjAAAV5R36G4WYaixkEArq2Rw006vEMRO4Hpi6pC6k9Ju0k+9VNMtp9
        RnUQU4/JXoY6Wid/9s9R4snbInj+
X-Google-Smtp-Source: APXvYqxwNUVImKNc65xSGoldSVoOGheLgh74xB+CIJdxPGaKP/Qef8SLQjHKwROrP7H5a/5PmhVa5Q==
X-Received: by 2002:adf:fc08:: with SMTP id i8mr21841250wrr.82.1576934151195;
        Sat, 21 Dec 2019 05:15:51 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:1d9b:6ccb:460c:7d9e? (p200300EA8F4A63001D9B6CCB460C7D9E.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:1d9b:6ccb:460c:7d9e])
        by smtp.googlemail.com with ESMTPSA id u18sm13655370wrt.26.2019.12.21.05.15.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Dec 2019 05:15:50 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: factor out rtl8168h_2_get_adc_bias_ioffset
Message-ID: <eef6a148-da23-7561-69bf-0d10aea04b60@gmail.com>
Date:   Sat, 21 Dec 2019 14:03:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify and factor out this magic from rtl8168h_2_hw_phy_config()
and name it based on the vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 39 ++++++++++++-----------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a887b685d..c845a5850 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3204,11 +3204,26 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_enable_eee(tp);
 }
 
+static u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp)
+{
+	u16 data1, data2, ioffset;
+
+	r8168_mac_ocp_write(tp, 0xdd02, 0x807d);
+	data1 = r8168_mac_ocp_read(tp, 0xdd02);
+	data2 = r8168_mac_ocp_read(tp, 0xdd00);
+
+	ioffset = (data2 >> 1) & 0x7ff8;
+	ioffset |= data2 & 0x0007;
+	if (data1 & BIT(7))
+		ioffset |= BIT(15);
+
+	return ioffset;
+}
+
 static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 {
-	u16 ioffset_p3, ioffset_p2, ioffset_p1, ioffset_p0;
 	struct phy_device *phydev = tp->phydev;
-	u16 rlen;
+	u16 ioffset, rlen;
 	u32 data;
 
 	rtl_apply_firmware(tp);
@@ -3223,23 +3238,9 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp)
 	/* enable GPHY 10M */
 	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(11));
 
-	r8168_mac_ocp_write(tp, 0xdd02, 0x807d);
-	data = r8168_mac_ocp_read(tp, 0xdd02);
-	ioffset_p3 = ((data & 0x80)>>7);
-	ioffset_p3 <<= 3;
-
-	data = r8168_mac_ocp_read(tp, 0xdd00);
-	ioffset_p3 |= ((data & (0xe000))>>13);
-	ioffset_p2 = ((data & (0x1e00))>>9);
-	ioffset_p1 = ((data & (0x01e0))>>5);
-	ioffset_p0 = ((data & 0x0010)>>4);
-	ioffset_p0 <<= 3;
-	ioffset_p0 |= (data & (0x07));
-	data = (ioffset_p3<<12)|(ioffset_p2<<8)|(ioffset_p1<<4)|(ioffset_p0);
-
-	if ((ioffset_p3 != 0x0f) || (ioffset_p2 != 0x0f) ||
-	    (ioffset_p1 != 0x0f) || (ioffset_p0 != 0x0f))
-		phy_write_paged(phydev, 0x0bcf, 0x16, data);
+	ioffset = rtl8168h_2_get_adc_bias_ioffset(tp);
+	if (ioffset != 0xffff)
+		phy_write_paged(phydev, 0x0bcf, 0x16, ioffset);
 
 	/* Modify rlen (TX LPF corner frequency) level */
 	data = phy_read_paged(phydev, 0x0bcd, 0x16);
-- 
2.24.1

