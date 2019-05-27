Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9CB2AE6D
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfE0GQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:16:21 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37498 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfE0GQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:16:20 -0400
Received: by mail-lf1-f67.google.com with SMTP id m15so10537092lfh.4
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 23:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zFh7Bi7EdT8HmKiFgFFsvuKM+sIHdEglyhTaV73oUT0=;
        b=S93iH5VbAHuC1ciFuhTLt1Kbv18LT5E4DnVBRnxc1CsVwRXjSpyKvOKKDWtllkcFDU
         wSKniTZV25RqWL5DzMHAyIdBnLnznFCIYwc+5qcZLZKCnPdXN8uAkz0Shl5aBL/6Q0Zy
         6yi6S4Zo9A2PJNae3CSl4O9bQHHq+f/5n8nQpMVYHaSX68ZyBIHzOWqMcYKyn6WxqqTP
         nj2YkuuIrGxF+DWgvP8wKxJ/4pDeMJLF/rV2WYE5e99vU/4WyCisYkWeGqCeU3Y51eGg
         1pUmnY7zeIEjqQH939BnNflkMHAXEgZiPdLX8WziPf+UpXA4X5Dot210BxPVBNXlf4BC
         j31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zFh7Bi7EdT8HmKiFgFFsvuKM+sIHdEglyhTaV73oUT0=;
        b=Onc2jtLaoU4NqWsWeiGJnUhAKV8LOlss0EF+jDTjr9gZeTtyZB8weDNbSknIgiZb5k
         IVNKasabeaueTJgl6E0rN8papyGnlUD0l99cW0FrQFMoofUkMXUzG41JChY5iwLhs2jb
         dK714+MQu0dwQ/VwQE7YRuQtJgRalX9LF4GfYvhcYeS9ex9NPNb8UMrCMfNnh4Y+buRa
         I7zCpbYBVI2EXVUU2Vlsd9KGzslmYPszfqTTvfW+2LAVRGvpHvQh+r8mkez417JfIits
         vbcFQOve3FScKAij0D+b/NL7Wymjo95GpoAgz2sFxfZcpPz/SpRT6AJIqxnUp7qMwrXX
         hFPQ==
X-Gm-Message-State: APjAAAXd7b2lF1sTdeD37Hn62g2iz12lq19qB4Dd2OuNFBjRBEqr9EwZ
        cY37D70h10OYhv0NODAa4cUctacOKImBow==
X-Google-Smtp-Source: APXvYqzT3McEwobgyIykWcGPAOnaUfRUV4zeqi7cs4UsfjMqGdTPtmj3TrJUg1gLbdEgz0jaaqVY1A==
X-Received: by 2002:a19:e34e:: with SMTP id c14mr10842023lfk.47.1558937778250;
        Sun, 26 May 2019 23:16:18 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id a25sm2045454lfc.28.2019.05.26.23.16.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 23:16:17 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH v2 4/4] net: phy: dp83867: Set up RGMII TX delay
Date:   Mon, 27 May 2019 09:16:07 +0300
Message-Id: <20190527061607.30030-5-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190527061607.30030-1-muvarov@gmail.com>
References: <20190527061607.30030-1-muvarov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY_INTERFACE_MODE_RGMII_RXID is less then TXID
so code to set tx delay is never called.
Fixes: 2a10154abcb75 ("net: phy: dp83867: Add TI dp83867 phy")

Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/dp83867.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index a1c0b2128de2..69e36d3d0968 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -251,10 +251,8 @@ static int dp83867_config_init(struct phy_device *phydev)
 		ret = phy_write(phydev, MII_DP83867_PHYCTRL, val);
 		if (ret)
 			return ret;
-	}
 
-	if ((phydev->interface >= PHY_INTERFACE_MODE_RGMII_ID) &&
-	    (phydev->interface <= PHY_INTERFACE_MODE_RGMII_RXID)) {
+		/* Set up RGMII delays */
 		val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RGMIICTL);
 
 		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-- 
2.17.1

