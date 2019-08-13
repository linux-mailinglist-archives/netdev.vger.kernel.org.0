Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4728C3A2
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfHMV07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:26:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35201 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbfHMV06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:26:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so2668496wmg.0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 14:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P+HPLtK7+A4WNyWyD0FN1JtUtHkNvPhHkygiLluEErI=;
        b=b+TjkIFwags3xyBHnnIu83HYSUcjInumqJWg9bUccNmMw/s/XkCmIRqBEoFhfp/fGl
         S8ofOJw4IK7I8UJ4JsO8cEzNmF3gTEepLOaMxxEiG6uSAWzuPCrfS4EoYzLHgccM5iQl
         iXj4pcT5zIb9/K/1hb5sfYxyTEvOEVgZuiBGUI21IpBCnMkqoS7UedrYIBDhDKqUjs7q
         FNvwNiV/WH+mydQB4LBMysA+ytYl84TXDREl+UPUJzN1VePrCtSVayN2yZHfAmav5Q3K
         9YLJqOlZu4cEqHEysMKbe2A7OSTCB9T5xdXbppxw4mdF6LXiPpWeeHa1mORq1Q6Y3zup
         GHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+HPLtK7+A4WNyWyD0FN1JtUtHkNvPhHkygiLluEErI=;
        b=iOAZt9DE1lygyVDXAjKT8XygDvcR19/iQPK8RTtmic2NEafjOCyv7wN1AsRy7MJAaS
         hv2lCam8J/zt4rA8M1y68p7FxnvNN1VjpabvUN77DKwKjBpQCEYHBBDzdLJJgYQW0Hq+
         pqDWVH56whx4l/x5TeYQcDkhaVTzp1zwy9GwR8y4zR1kNjmTaof1VKFRPm9j+hQ99VEN
         LBOU7kzvsPcpPdr8SMu7t4NoOhEaG/KUvrp3NRdg+jVUpsLM8lz8KiZ4E5w9KHmrFjc/
         RmSY3dslSOYq76elQj19iWC6JdV9V4CvnPoJeRjUJtNl4EdQxX4kLz6Kbd9cad5y0OzG
         oupA==
X-Gm-Message-State: APjAAAW81lJmGEV06xjFBhtU/Bc+qKpSl68vUx7CFY2Yp5Dt8CuYB9PR
        8D8k7eBI7TFHFh8RGqNDewUJKUx7
X-Google-Smtp-Source: APXvYqw3EsCVS7srd0ztzRngZnYB/BmUeOvewmM3DWFfQ6eNQw53i5LEaLMWTXujMQPK9lG/wae5CQ==
X-Received: by 2002:a7b:c4c6:: with SMTP id g6mr5130280wmk.52.1565731616387;
        Tue, 13 Aug 2019 14:26:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a? (p200300EA8F2F3200E1E264B7EE242D4A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a])
        by smtp.googlemail.com with ESMTPSA id f192sm1883357wmg.30.2019.08.13.14.26.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 14:26:55 -0700 (PDT)
Subject: [PATCH RFC 3/4] net: phy: swphy: bind swphy to genphy driver at probe
 time
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marek Behun <marek.behun@nic.cz>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
Message-ID: <67d4bb9b-e88b-60e8-f696-64d0403e1910@gmail.com>
Date:   Tue, 13 Aug 2019 23:26:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let a swphy bind to the genphy driver at probe time. This provides
automatic feature detection even if the swphy never gets attached to a
net_device. So far the genphy driver binds to a PHY as fallback only
once the PHY is attached to a net_device.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/swphy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/swphy.c b/drivers/net/phy/swphy.c
index 53c214a22..7ac5054fa 100644
--- a/drivers/net/phy/swphy.c
+++ b/drivers/net/phy/swphy.c
@@ -151,8 +151,9 @@ int swphy_read_reg(int reg, const struct fixed_phy_status *state)
 	case MII_BMSR:
 		return bmsr;
 	case MII_PHYSID1:
+		return GENPHY_ID_HIGH;
 	case MII_PHYSID2:
-		return 0;
+		return GENPHY_ID_LOW;
 	case MII_LPA:
 		return lpa;
 	case MII_STAT1000:
-- 
2.22.0


