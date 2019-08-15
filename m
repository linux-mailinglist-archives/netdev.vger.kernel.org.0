Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F32C8EAFD
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbfHOME2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:04:28 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:55035 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731066AbfHOME1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:04:27 -0400
Received: by mail-wm1-f43.google.com with SMTP id p74so1077459wme.4
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 05:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=upg+bZO2tl76NuL5qRGzzUNcHidJHyMzxJdBLW1vxSA=;
        b=Lk1QYm3XO1TtrYnK82C1/2XHM6FgvEjRLBDA78xV8inQss+x3UpnkON9d1b0nrwZPD
         EvmnribxuwZyieoATcD5QzkZ9Ei8oat9lstQPRD8tBF+LTL0d0BZxUHJSJ1RJemQ5VNG
         vLhv9lGnP1UWtvUst2PLOUzBMFXGElWnIWqmA1TFkaHWdOEw9mrJRl+06JJ518+3nQRl
         9tJ9iIf2M637YJppuwb6YJuNdaOE4yQZ2RVz5jLOaTAahS2hBnM6+3pJQAH9flr0rKDk
         7np4leR9J5gPkGmCXj+dtSYOH+Toms002zCHqLI424gi1wSGY+cj74DWa16DP/+FcK79
         rtBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=upg+bZO2tl76NuL5qRGzzUNcHidJHyMzxJdBLW1vxSA=;
        b=pfxrCwLd3VIGVddYxMFR/CzhamwMqcnveJ1s53PHiSamPTH/D0NiAlW6HophqvPSBO
         8ATJYJgU0WtPTZ9bVVOg7SO5cFjAzru6AQOpbCWdh3zeAV5lTKSJ6E2y2uL13ntQVN+L
         XK7SVBsDl5hejH3Tltn6rudBR4krKHQsJP/O+FbwQEtUHGv6uxV1+sARMxIOQ5BUKvnb
         qnhwemJeqqk8Ydr+8INaowZAPLin7J/ewVgtFN/LV7LyAyBLOMW9CP2uNfvjC1rvq0t3
         oYYlJfX8+6JnGIW4pBh0aAAXrK1mr+OhEeGpDyL8XOO6v5ucR9fXHurM1JKShw8EJ80V
         mN5A==
X-Gm-Message-State: APjAAAUklsnjdt5m06H71c/FXaAUQ1M1ZjsL1oBBeX6nNvzulJrXOAHb
        6CWgAzoSjUOmYIsZkT2NDJQ=
X-Google-Smtp-Source: APXvYqxDY3rncrRpFh7C8203dLkXoB1cu1beyAIHcrcOVnulG2BXBLacpK+xewCQya0hkBQnJeKQcQ==
X-Received: by 2002:a7b:c929:: with SMTP id h9mr2609218wml.1.1565870664648;
        Thu, 15 Aug 2019 05:04:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b8fa:18d8:f880:513c? (p200300EA8F2F3200B8FA18D8F880513C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b8fa:18d8:f880:513c])
        by smtp.googlemail.com with ESMTPSA id v23sm1645106wmj.32.2019.08.15.05.04.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 05:04:24 -0700 (PDT)
Subject: [PATCH net-next 2/3] net: dsa: remove calls to genphy_config_init
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <95dfdb55-415c-c995-cba3-1902bdd46aec@gmail.com>
Message-ID: <8c34396e-fa3d-bf1f-8792-4056df64fc0f@gmail.com>
Date:   Thu, 15 Aug 2019 14:03:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <95dfdb55-415c-c995-cba3-1902bdd46aec@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supported PHY features are either auto-detected or explicitly set.
In both cases calling genphy_config_init isn't needed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/dsa/port.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index f071acf28..f75301456 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -538,10 +538,6 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 		return PTR_ERR(phydev);
 
 	if (enable) {
-		err = genphy_config_init(phydev);
-		if (err < 0)
-			goto err_put_dev;
-
 		err = genphy_resume(phydev);
 		if (err < 0)
 			goto err_put_dev;
@@ -589,7 +585,6 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 		mode = PHY_INTERFACE_MODE_NA;
 	phydev->interface = mode;
 
-	genphy_config_init(phydev);
 	genphy_read_status(phydev);
 
 	if (ds->ops->adjust_link)
-- 
2.22.1


