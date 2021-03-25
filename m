Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7FC348CFA
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCYJcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 05:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhCYJbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 05:31:49 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6A0C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 02:31:48 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k8so1565188wrc.3
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 02:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=AFUG+Vnc5MDnv/U/h9CVi7CFA8oBjOHJIoyO9rIs0QQ=;
        b=k4MYerf1SudrrAsCgbTGiPTr/05hhiYKoy3GoWK0tVYV3G8vlYIe5BZ0gLaj9KHgwL
         Gt71pzvyKWQg+D24PeqlcTXE22Ajotg7EIaifMscAo8RBKA61JATdkC3WfVGgPycaalW
         2mvjOhloF0KCnLm5dUnvlNqkQUFfITp0YmBo8Yxoew55nGKURyJrFn1pt0QBHMyJWAot
         MLe6fNHaJKhSxYhde+cJOR3tm8aK0Zdno99SPFY5uWSAyelxTaI8eMj/ZvTm1xwQg1A4
         Scopib2hHUXh1coQkZ2dS2u0+1wuWraOn95oTBov7ONizzbYh21LqFbpGBNhpdzo70si
         jWag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AFUG+Vnc5MDnv/U/h9CVi7CFA8oBjOHJIoyO9rIs0QQ=;
        b=XZ/L/I57XTZTSka50O8VcyUz3aPx1wUmeFie+YM0PoUXTSrESUa/sPTEhwS7AQod38
         TeACzndtHsU/6h4uKd//FQ+X1q8BUQmU4cuVrTTgPsBiG9axNB0D/W//SixQseQqHKo0
         BkAkScOnYbjMKMr2PHbEjbpSV+W+0jQ3NxYr56yCuy2xRjjlCF/J4C8JlbjYHAlX8P1t
         wMYHa/OZKUFElMdrQZ8rwqUYY7Zw0m2zQuARsFbrFamqgIQxE7ibxf53fMVw+UW1R7Sw
         Ar97OtnAzzXkf2drwf6OdZRR8tgeLa7I9iqU5W2hnLuJfmaAFK7WpFl5Fimun8CD5ScZ
         DUBQ==
X-Gm-Message-State: AOAM531T2TG4kzC/z/UTJlAdiZ0JQgDdd75t1+1/lYMmnys73zDZdKbR
        HH6HDP1DFAvdXmgLtpnEKjLZOUTXsGo/SA==
X-Google-Smtp-Source: ABdhPJzSRbxpC11poQ0yYq7Bk5uk92LtNYU+Mc6O6+hwR7VnGzVyO7lOWTfOUjKIP2FkiN9LEradtw==
X-Received: by 2002:a05:6000:2c4:: with SMTP id o4mr7811845wry.190.1616664706192;
        Thu, 25 Mar 2021 02:31:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:ec1d:f023:8a26:fc6b? (p200300ea8f1fbb00ec1df0238a26fc6b.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:ec1d:f023:8a26:fc6b])
        by smtp.googlemail.com with ESMTPSA id b131sm5460126wmb.34.2021.03.25.02.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 02:31:45 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: remove rtl_hw_start_8168c_3
Message-ID: <a09162c7-8e7f-da1f-ea28-f3a425568020@gmail.com>
Date:   Thu, 25 Mar 2021 10:31:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can simply use rtl_hw_start_8168c_2() also for chip version 21.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7a8bb7e83..1cd5c6f6d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2736,11 +2736,6 @@ static void rtl_hw_start_8168c_2(struct rtl8169_private *tp)
 	__rtl_hw_start_8168cp(tp);
 }
 
-static void rtl_hw_start_8168c_3(struct rtl8169_private *tp)
-{
-	rtl_hw_start_8168c_2(tp);
-}
-
 static void rtl_hw_start_8168c_4(struct rtl8169_private *tp)
 {
 	rtl_set_def_aspm_entry_latency(tp);
@@ -3653,7 +3648,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_18] = rtl_hw_start_8168cp_1,
 		[RTL_GIGA_MAC_VER_19] = rtl_hw_start_8168c_1,
 		[RTL_GIGA_MAC_VER_20] = rtl_hw_start_8168c_2,
-		[RTL_GIGA_MAC_VER_21] = rtl_hw_start_8168c_3,
+		[RTL_GIGA_MAC_VER_21] = rtl_hw_start_8168c_2,
 		[RTL_GIGA_MAC_VER_22] = rtl_hw_start_8168c_4,
 		[RTL_GIGA_MAC_VER_23] = rtl_hw_start_8168cp_2,
 		[RTL_GIGA_MAC_VER_24] = rtl_hw_start_8168cp_3,
-- 
2.31.0

