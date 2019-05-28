Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13592C3D3
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfE1KB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:01:26 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33481 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbfE1KBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 06:01:21 -0400
Received: by mail-lj1-f196.google.com with SMTP id w1so17116269ljw.0
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 03:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=btUIRIm2Br7gBzgIOuLLorySPJ0QGEoHKS/cs7ietDM=;
        b=rYd+8rzbarYXI7XC6LfHWLwzRzJD1KU0XlrUvBq24k9ctqMgn0kN55VxkjcF57EJkP
         Z9YUGuTBNYDDew6QOG9F4PBuAu7TG+JO5sBk+lrG8OLjXi6+nZE4hD6dE0HGzz0BgVc9
         /4G7S2IY6wXZqNDYJgxA8sKyHuxVU+oyZHn4gGQtMUzUwtTpFNgLezrKFMFAOPXVZ6eW
         3XiR/Hjp4qc4THi315yZum5h9E+u/UoY47Pkvyf2w1ck9EfGC9B+izXnCvwx59EuQVtW
         tNvwKmSlbXA4v03yikl2XzHHGx7VqndWPsxoJJD2MSINw55zjVHoj9i2uolcC8Hr24cm
         Injg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=btUIRIm2Br7gBzgIOuLLorySPJ0QGEoHKS/cs7ietDM=;
        b=XWYjIPgd2+bzp0yB7UJNdc3RI9TSHHDnMBgH3wPeQvSGeliDap61ijjf1rwqpprtPr
         ngR5t/KhBpTzJopvjM5GoTkWeyjacEt2KQjlNDxaKipcqCh8XvRBeSzvnLkeSY64B/5m
         +t760447N5pp4a/h8B0GahOWjyV4+TNEZuTcO3+5XIRFenjA0V5/1eoQA1Blv3KIxbOT
         sIgcbizow3D0d/yYsLi248fzkd+lkJWUGA1c4zikUfGAwTd0DjB7Lat+YbtbLKbbrthx
         NC2WvM1pUIQXvN1l16M7vEnmBq453vzlToZWBMFJryR1s46XrLPLrT+4FYOsqQfNye7A
         vi3g==
X-Gm-Message-State: APjAAAWVuwdvSZcFv8MdSQNb3FviVo7SKWTY4kq54yZp08/X4+xqzEzM
        FCrtq2hTnPYZVxLo7FtLZbbEBf25h6Ul/w==
X-Google-Smtp-Source: APXvYqzD7eXLHBrCvJiun0CBAq8TEtQY84KDHVi8NH5pBpmf7yymdRYq113bwNxzVsqhJrBvw6nLPw==
X-Received: by 2002:a2e:98d5:: with SMTP id s21mr45149788ljj.142.1559037679713;
        Tue, 28 May 2019 03:01:19 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id x28sm581816lfc.2.2019.05.28.03.01.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 03:01:19 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH v3 4/4] net: phy: dp83867: Set up RGMII TX delay
Date:   Tue, 28 May 2019 13:00:52 +0300
Message-Id: <20190528100052.8023-5-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528100052.8023-1-muvarov@gmail.com>
References: <20190528100052.8023-1-muvarov@gmail.com>
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
index 1ec48ecf4133..c71c7d0f53f0 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -255,10 +255,8 @@ static int dp83867_config_init(struct phy_device *phydev)
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

