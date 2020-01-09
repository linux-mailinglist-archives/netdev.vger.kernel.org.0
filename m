Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937A0136131
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbgAITfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:54 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44397 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730892AbgAITfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:48 -0500
Received: by mail-wr1-f65.google.com with SMTP id q10so8631430wrm.11
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wso+yMkbY7eWlefecytniGx9jhOimka5+LShV1Kuq/M=;
        b=jM1v3W8cvEb4PbN6vyRbSLm4u+kEe/MulzW92onWav4bwkXB+Q5a9WpTdiW4b7/ozK
         7TJYqcT2xXNnAePA2C+pvhoi2zts4DG/TrqMR3D4phbx3Qettcqt/Lra7876TvEFo9ol
         4pUXm0AC4aCwBsUaWSHImmPD+ysYmlZ6Jl108BuVJoEa9FsE4IkPxvyU1PWhV80CpoY4
         L/w1PWlsD03/uQhsyGixMW2n4fV8U3JTIRAL1twfwBZNIpf19Wm6YWbsRgL6G9k9LlRF
         mpIZpXgCL9MmXruQQiEIJ+sz4gZJ9meTw53MePv3jsKfQKRb7dZSiIi1drM8QbFiJBjc
         D6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wso+yMkbY7eWlefecytniGx9jhOimka5+LShV1Kuq/M=;
        b=gy2yemxyp2WApaakyOfBvb8Rq3m96weGFVzoZyfhPT7ZhdcwBbowXIlbf9Xl9ZAzPj
         PMoKIN4+GeVLzu3jQm7NqqyIh0wTzhj8hmgx9Xf1kH+uiNdkmyVK8E+LqN2DKeIyO1nk
         a9eF8a/vOZQYAjQWq1dAqtz6RqTxs9W9z/Z2L7O7NQskL+5e5fjjvA3uWh1V8stT+kGz
         c/hjRQcFIqW/5/+03pjwtJ1XxdoK2QDQGDoepXX0mCrWYSqs0LM4XNbLf0EeyCkHroS5
         wzaies30FANfmFyIuQThZKgmar0VOR/0pndn98ivCtGLywrHl0ukkOySTbre5AKHnNRH
         aQwA==
X-Gm-Message-State: APjAAAXaqBrtb4E0KEYKTQ//tc/voG5R9MaAgvxI7+8UTzC3/nCD7/Ok
        8WPFltkJQkzguZ056H9l2u9TV5ng
X-Google-Smtp-Source: APXvYqw1YZik2l0rNFJg3Kr+a0YNzYmAXs5q/i28ms9Q72qeSWvcaHsfv5xF9IRhNVZqxmYgpv9oSQ==
X-Received: by 2002:adf:90e1:: with SMTP id i88mr11951804wri.95.1578598546799;
        Thu, 09 Jan 2020 11:35:46 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id z8sm8734769wrq.22.2020.01.09.11.35.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:46 -0800 (PST)
Subject: [PATCH net-next 12/15] r8169: add phydev argument to
 rtl8168d_apply_firmware_cond
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <607289e3-536d-7911-dca2-84a47a972829@gmail.com>
Date:   Thu, 9 Jan 2020 20:32:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the phy_device as parameter to rtl8168d_apply_firmware_cond(),
this avoids having to access rtl8169_private internals.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 595659c2b..e022f5551 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2669,9 +2669,10 @@ static const struct phy_reg rtl8168d_1_phy_reg_init_1[] = {
 	{ 0x1f, 0x0002 }
 };
 
-static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp, u16 val)
+static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp,
+					 struct phy_device *phydev,
+					 u16 val)
 {
-	struct phy_device *phydev = tp->phydev;
 	u16 reg_val;
 
 	phy_write(phydev, 0x1f, 0x0005);
@@ -2734,7 +2735,7 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 	phy_clear_bits(phydev, 0x03, 0xe000);
 	phy_write(phydev, 0x1f, 0x0000);
 
-	rtl8168d_apply_firmware_cond(tp, 0xbf00);
+	rtl8168d_apply_firmware_cond(tp, phydev, 0xbf00);
 }
 
 static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
@@ -2775,7 +2776,7 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
 	/* Switching regulator Slew rate */
 	phy_modify_paged(phydev, 0x0002, 0x0f, 0x0000, 0x0017);
 
-	rtl8168d_apply_firmware_cond(tp, 0xb300);
+	rtl8168d_apply_firmware_cond(tp, phydev, 0xb300);
 }
 
 static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp,
-- 
2.24.1


