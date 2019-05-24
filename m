Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90726295E8
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390391AbfEXKfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:35:44 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38986 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389448AbfEXKfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:35:44 -0400
Received: by mail-lf1-f66.google.com with SMTP id f1so6745697lfl.6
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 03:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6BdEv6mWSbFe6DfGZmsnczTFq5qkHp5GWCG/06nTBow=;
        b=JefqU1d7fjxjR6hC5SVK/KRD/vQWjTRTFOMBMY1YZWbnmcU41yvICZmz09znhrBObh
         xC1ctOnYHrqIwpoolpSa8pxIcCO2NbRcENXyT8i26nrtWvt7cNW7CiDZEkV8CNYk5dwx
         lOKCkM6L6e+aT5x2ja0Ws9KLrKKNMogSve3b7wysdFLirVDKJ/GOp8TP3KFSFfJ22r6/
         Ng00QywOaKZkgotCeeAnFw1GlNmp12BLgCa8C5HDcxgeRQYUHFNN9N259kDKXBd+cIW8
         r4ibK4uFbPngCCHFo5QXeAZ2akF9+EgjhUh0e9+pVUtIjfgSJFfk1ugWDXq74DWmFMTj
         wOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6BdEv6mWSbFe6DfGZmsnczTFq5qkHp5GWCG/06nTBow=;
        b=ZFUmJLnxL2frgl6ns6kvxWxCcQ2HFtRSaEeqqptvrSFFe1/oYofcVq21150FQGNSG2
         2ZOqkCoXQD80RBGnZmdolqFRTA1SNg6VMGlA/52sqicVJIuOyR/cF71SOntYwdYiAAMy
         1Cq8Ifm/P9/yiRlcoOt4cdrxKHzDVok+8bIg93LLn9iRMG3GO3ZArVO8+Avzwrw7wdBV
         dQTBlwHqkHUJCCD0FLPeAzXqBS8PkkU6Wze+9c3DM3HKV0c1IjP/9Y7K4vzk2srJ/AAW
         RrAOX6ZYGQsA2vYkZrQj4cRpUN2xQO2aH/WrVPwDUmmU0QYn7AeysxmPF50yZxo95xFo
         AnPw==
X-Gm-Message-State: APjAAAV08RPpH6aEfUhZGNGbjpQn1zZOeT5domOesNyyp5YU/dqv5BX0
        zL3Ty1r0Hjp4D6cKsgtmRxqs1hZSErUuZA==
X-Google-Smtp-Source: APXvYqyLMtSH4oZ7c+Fj5F9PlfzTgCRH2dSCYmASWo/CaZwr/fvVrV8JLfa0lZXQzefWTfrXbMFBPw==
X-Received: by 2002:a19:2d53:: with SMTP id t19mr13312253lft.138.1558694142421;
        Fri, 24 May 2019 03:35:42 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id w3sm422399lji.19.2019.05.24.03.35.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 03:35:41 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH] net:phy:dp83867: set up rgmii tx delay
Date:   Fri, 24 May 2019 13:35:23 +0300
Message-Id: <20190524103523.8459-1-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY_INTERFACE_MODE_RGMII_RXID is less then TXID
so code to set tx delay is never called.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
---
 drivers/net/phy/dp83867.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 2984fd5ae495..5fed837665ea 100644
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

