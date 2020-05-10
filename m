Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A4C1CC94C
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 10:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgEJIND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 04:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgEJIND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 04:13:03 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD593C061A0E
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 01:13:02 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so6914450wrt.1
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 01:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ssIBRk1mUsK2tjQtYuKlRUhxTwSn1Zuytj5wBBcYvEE=;
        b=k48Mjdt8mfB5E2BXa793O+s0lIj82CYuRx8RWOXRRssZme9oMHZ+roJh7q+qS7NNTT
         29lZPvVCyoK9LLq7NZITYIjXFDpDWPGpOo49XPnHp1CDHPKi3/IEr2BlYM10opOBKOXA
         hQqzGv/QOXA9+IEMFA2diszgsWiSDInkIdtpEky7YQg90UQ/bcVsf28/1QWACHbft0Sq
         5NDKkpGjr7317HJlB5WnFKpJwYHcSdnkSioEcnh5wEMQ5m+mMxXvkmXfGpacbOg0qszV
         lHJ8nXXbVVuUHIZVg6tF6vEJWIn3ab3oHqRdyszjwkuH4iVdg4rqTx4RTSBICkeuuLVS
         e44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ssIBRk1mUsK2tjQtYuKlRUhxTwSn1Zuytj5wBBcYvEE=;
        b=ovyioPCDcke3B7+xcGnhOzS33+23fG3ignJaTP1u1TyDWRIuhNc1yfifm2VXAQ2k9b
         SVyIdIgAzQIC0hWurWciPWgSc8XCrB7OKTglEEUc2PNTUJanNy2QCYQyxYQDsi1D4u1Y
         g9s1htwK68N+QHufv8qTZcmflHkNZnOeZHhEq3DrnXDhfYNkrHW5m76KEUMZ9Q7ERBid
         XniH3dNKgnNhcNydfPFJHcN+krHXL+KV6kLij0D66stvKvXO6GBJLOga6oQ/5SSZa1l8
         FQI8kH2LaIA16DPBAiXAEP41bCPoAXJN+WUIOySZ4Ft8g0qtDjwiRE67hJtxFmHwuwLq
         v9Mg==
X-Gm-Message-State: AGi0PubsNtt0o1Ke21ATJQ2JZqWkepmEoEUo8ksL3n/v55KDrmcI5/89
        mY+edJSvya0/DPeOx0RI5k8rL86R
X-Google-Smtp-Source: APiQypKpvzMCM637qFOd/CxYNZPCmu+HibfBiU3JDgn0YDj3G5eWPrx9sSJAcosfnO/eCKpHbNHVsw==
X-Received: by 2002:a5d:5445:: with SMTP id w5mr12069686wrv.422.1589098381242;
        Sun, 10 May 2020 01:13:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:d448:ac33:cee7:aac0? (p200300EA8F285200D448AC33CEE7AAC0.dip0.t-ipconnect.de. [2003:ea:8f28:5200:d448:ac33:cee7:aac0])
        by smtp.googlemail.com with ESMTPSA id 77sm12114597wrc.6.2020.05.10.01.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2020 01:13:00 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: rely on sanity checks in
 phy_ethtool_set_eee
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <8e7df680-e3c2-24ae-81d3-e24776583966@gmail.com>
Message-ID: <104d788a-68ee-9669-f920-656dcb1e6d83@gmail.com>
Date:   Sun, 10 May 2020 10:12:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <8e7df680-e3c2-24ae-81d3-e24776583966@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These checks are integrated in phy_ethtool_set_eee() now, therefore we
can remove them from the driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0e96d0de2..966192ef0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1919,12 +1919,6 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 		goto out;
 	}
 
-	if (dev->phydev->autoneg == AUTONEG_DISABLE ||
-	    dev->phydev->duplex != DUPLEX_FULL) {
-		ret = -EPROTONOSUPPORT;
-		goto out;
-	}
-
 	ret = phy_ethtool_set_eee(tp->phydev, data);
 
 	if (!ret)
-- 
2.26.2


