Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14A61BAD84
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 21:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgD0THK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 15:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgD0THJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 15:07:09 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24806C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 12:07:09 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z6so116449wml.2
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 12:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ieL932mYJX4ebUenx7EblR3LFPchkor+vVYB2P+THIE=;
        b=TGaycycJrfyPge7XqPZ1LPOHxufOt0ny+xvEB3+MSBmi+O+fF2QAODQW/JZA+NtlHh
         4lpMl7H/qkvEVyC6HJAf8png9NJFNYA+5DnhcX9tpkQI51zDUYkYv9p/VmYv5wHSJg2W
         atGbRX4s0NE8z25UzmWiCtzSe/yCCwOblc9/19CFyp3G/lO6tOq9ffdZG/X4biPLDaxL
         tDmt76/gajLhORvjDjMtPoByaDco7GXdKXGGxq3HPWBNAj7U7x21BOzKS41s7xFjOi0K
         ctfx+X5jDGK4aunLthk8acZYf6wyvAPaeUAEMLFrRfMNULXQfoi6umrx0AGrKn4V7iws
         H74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ieL932mYJX4ebUenx7EblR3LFPchkor+vVYB2P+THIE=;
        b=EAz46OHf6qNgosJf0JExbUn7cNCvu7bcHzkgTcjHBoq1AnlMeXyE3J35vnJNZHKCtL
         J8/mY2DX4JGSUs3k6nLzAfSBc2VgI5xdZJXuXmpTdL5FkM3FxSepNDhdtSNJ421t7QPw
         d6JI7skoQV9/VQHdpypWJkwJJo6LiNJ17Hv9Wox1yUHqL5UPnwHZ8ejiCrnED6KtNViv
         Z5u9rkeeQiS9T6rTy0mRpGLl+BZWZHUNYhtGxZkpWucemouMbujKAaSWJiVVm+DzejOw
         CTcw1EGglGjkbI1VZ02ZAhPGCNICMb4GRIGGsUELYnSEsw1dr8JWBwKssxDdnqQW1Mug
         tXxQ==
X-Gm-Message-State: AGi0PuZUPOFX6WJRtZ0NYIhwktkTKG4Bq63xYWBxLwXh5kvrS9WWztlX
        Yah71qtX9P3hvVTYgULDf11OV5/3
X-Google-Smtp-Source: APiQypI2rDmbHvk60YSPBWbrNDAUSear2zAQ6dE+RKT+v4kc4AEvMDDTp89HWud+t0sVu6wlYi1AFw==
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr184718wma.26.1588014427579;
        Mon, 27 Apr 2020 12:07:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d050:8ce:1150:1556? (p200300EA8F296000D05008CE11501556.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d050:8ce:1150:1556])
        by smtp.googlemail.com with ESMTPSA id 33sm22487353wrp.5.2020.04.27.12.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 12:07:07 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH resend net-next] r8169: improve error message if no dedicated
 PHY driver is found
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <d0d394de-6b5f-e340-6269-8539af02829b@gmail.com>
Date:   Mon, 27 Apr 2020 21:07:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a number of consumer mainboards where the BIOS leaves the PHY
in a state that it's reporting an invalid PHY ID. To detect such cases
add the PHY ID to the error message if no dedicated PHY driver is found.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
- accidently sent previous version from wrong mail account
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f70e36c20..7471fae53 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5197,7 +5197,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 		/* Most chip versions fail with the genphy driver.
 		 * Therefore ensure that the dedicated PHY driver is loaded.
 		 */
-		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
+		dev_err(&pdev->dev, "no dedicated PHY driver found for PHY ID 0x%08x, maybe realtek.ko needs to be added to initramfs?\n",
+			tp->phydev->phy_id);
 		return -EUNATCH;
 	}
 
-- 
2.26.2

