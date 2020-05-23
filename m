Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E851DF6D3
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 13:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbgEWLXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 07:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbgEWLXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 07:23:42 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32B7C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 04:23:41 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id i15so12745961wrx.10
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 04:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7IPz5FM+Bka9CGVewGbPlLr13YVWL09LQ2OfXvFbjqw=;
        b=fWQmoritSrffTmyVqHWYLU/WQ0ca1YXz7zpnP7kdhZTpfU+ZHhVjoGNEjWxQMjRZ8D
         HFdNfUy3DhiLAEkE1UMYIvYkHp68eqpbdXA6kFt8qbmBeKebwHDbKjA1SjnDS/fIXbGB
         zAjvKPkyOJ5auLnN44sCLDB10ikzeoZrGPEe7HFu1Z+SoZvPuITntgZGug43F7+9om0a
         i0JwIeBB3tmtgwoOi1o6axvN6F6+dW5cixZPBv/fMkA7wCF4X5TVnE9evxqTbTE/f8kE
         9ObR4FMAh9wVBZSoF3VO4bua+qZIzjBTtD+6llTFmqan6NQxy7OGtIe7OiGjMSouj0UV
         Y5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7IPz5FM+Bka9CGVewGbPlLr13YVWL09LQ2OfXvFbjqw=;
        b=KxlaTzQw7V5p7WZ8Qrc5P5IqcYeNC6ABnlGVGaxEA/zAzY3hfOKtdyeGzxTEIsM0md
         +s7NqSqmfrbZ85SmuXNdfeeTK7EhZkpW58wN/Rmv+tMbb8psg+DsvIXVlBSMtT3jykk2
         /OxePEmqT1lwCpVCWTuGnggY9QzA1nFBHqweXAKo3X+cmfS2QWqkNNywXGNIHbkoGiJn
         WTON4wglMVTAibEvv+e06ofmL1UxMsMQw1IEQ8TZtGW+bPXevwyNZe/KHNkYxYLeRQwA
         HosHwXv95BtrN2/kEFU5WmKdWXiSxSDbLwoZP2gSkC1ACs9tHUF/gzBDJc2JOx8+zKfn
         UM9Q==
X-Gm-Message-State: AOAM533r0tb2+cLTzL0CkFbO1B9U7eEKHlML74GzoQPQYZiEUrDD67LE
        eAwfPNQiG1+jqf0NDaDEURqyecC2
X-Google-Smtp-Source: ABdhPJzeqA4gUDvF/rxAQflfdR1XSIX8qzoZc9cyPSLV/58cLuGTy4NkCEqOdCuuYOXmNsbUVNqofQ==
X-Received: by 2002:adf:fd4f:: with SMTP id h15mr5206101wrs.397.1590233020256;
        Sat, 23 May 2020 04:23:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:69db:99aa:4dc0:a302? (p200300ea8f28520069db99aa4dc0a302.dip0.t-ipconnect.de. [2003:ea:8f28:5200:69db:99aa:4dc0:a302])
        by smtp.googlemail.com with ESMTPSA id h27sm121032wrb.18.2020.05.23.04.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 04:23:39 -0700 (PDT)
Subject: [PATCH net-next 2/3] r8169: remove mask argument from
 r8168dp_ocp_read
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba72d0ee-713b-0721-ed50-5dbfe502ffba@gmail.com>
Message-ID: <3cd847c4-2316-8bac-0a56-5fbd9d2e855f@gmail.com>
Date:   Sat, 23 May 2020 13:22:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <ba72d0ee-713b-0721-ed50-5dbfe502ffba@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All callers read the full 32bit value, therefore the mask argument can
be removed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b6528b1cb..6674ea529 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1091,9 +1091,9 @@ static void rtl_eri_clear_bits(struct rtl8169_private *tp, int addr, u32 m)
 	rtl_w0w1_eri(tp, addr, 0, m);
 }
 
-static u32 r8168dp_ocp_read(struct rtl8169_private *tp, u8 mask, u16 reg)
+static u32 r8168dp_ocp_read(struct rtl8169_private *tp, u16 reg)
 {
-	RTL_W32(tp, OCPAR, ((u32)mask & 0x0f) << 12 | (reg & 0x0fff));
+	RTL_W32(tp, OCPAR, 0x0fu << 12 | (reg & 0x0fff));
 	return rtl_loop_wait_high(tp, &rtl_ocpar_cond, 100, 20) ?
 		RTL_R32(tp, OCPDR) : ~0;
 }
@@ -1140,7 +1140,7 @@ DECLARE_RTL_COND(rtl_dp_ocp_read_cond)
 
 	reg = rtl8168_get_ocp_reg(tp);
 
-	return r8168dp_ocp_read(tp, 0x0f, reg) & 0x00000800;
+	return r8168dp_ocp_read(tp, reg) & 0x00000800;
 }
 
 DECLARE_RTL_COND(rtl_ep_ocp_read_cond)
@@ -1228,7 +1228,7 @@ static bool r8168dp_check_dash(struct rtl8169_private *tp)
 {
 	u16 reg = rtl8168_get_ocp_reg(tp);
 
-	return !!(r8168dp_ocp_read(tp, 0x0f, reg) & 0x00008000);
+	return !!(r8168dp_ocp_read(tp, reg) & 0x00008000);
 }
 
 static bool r8168ep_check_dash(struct rtl8169_private *tp)
-- 
2.26.2


