Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35DB41B879
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 22:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242777AbhI1Ulr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 16:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242768AbhI1Ulp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 16:41:45 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A4EC06161C;
        Tue, 28 Sep 2021 13:40:05 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id e15so1233225lfr.10;
        Tue, 28 Sep 2021 13:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vBSw5+MqBmKzXLxWE7zwAHio1IPQp5qVLONa1LWZ798=;
        b=aTcMG8hb2vdBQq92D6DPQ3yxHAoBbhSMGNLmY7UhR+6s4wWEd0JV3uUL44nq8599fU
         niN3ZaUs59+HFd0n9VXnFa4Q/cOMviskMUI35UIle2U/Kb98dqnV6hSxSUT9zmocJSsY
         mHOOJfFhIY+5nAS1TnaWPMrShOEzUGYk/t+UAz0XcFijkEO1TJGP/OgMaCvAtAo98Ov8
         xcX7bxFDwk77Ry5UJcLkbg0fhl7sqJkCpFtMgceEPHqlU617I2msgQrLbzubHuj95ikB
         5It8I3GOAnwEEvXYg45gPMQDE/YLWO9c6YhfoJyWWwbJ911ZmRw79HNAK9O0nYdQpm6F
         Dkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vBSw5+MqBmKzXLxWE7zwAHio1IPQp5qVLONa1LWZ798=;
        b=Se30bQaYGZCIIROc0/3AtBeh13QDChL6gHRv5YyBPuj5SZ1Xw8/VYQmUujeHgrTtQg
         ZSqnM4fG7PPwBEio3SqQs9FAbIui8g/lpF937obj1SZhcOOg+pnZd4OdlQzbIyEJ8D9I
         9WzV9IZENHnd9jKzB7VLHfm0GTCK6mdZuGgbDijbt7xRHHmkwfwKCUrm563igaQSsMqp
         ervi7eN04pUcLclIYVfW6PY7f4R0SrlRiEd99zq5DUz9Ha+G4n5TAvWKirbiFHPJMR7R
         6rKb7WMgS5w9e7v/Vhxe1g6GagAopKEFlpgoD6URkPoTUosxDoE2yBl8D4dT2yaGi1Q4
         2ceQ==
X-Gm-Message-State: AOAM531a4Z/SkQEgj2iciOyGL8bUOG8jFMKXInWWgN937WtqYO2s+wtQ
        Gf1VsknSHOyiTLrefwOYxmk=
X-Google-Smtp-Source: ABdhPJwXpmy7rRsn+8NtEbNjk/pQkT0AVxg1q6xHz6+JXki4zWiRApkP4IBUHGZ6+3dnWxXTId5V0g==
X-Received: by 2002:a2e:5450:: with SMTP id y16mr2133032ljd.21.1632861603652;
        Tue, 28 Sep 2021 13:40:03 -0700 (PDT)
Received: from localhost.localdomain ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id e17sm19531ljk.133.2021.09.28.13.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 13:40:03 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com,
        afleming@freescale.com, dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yanfei Xu <yanfei.xu@windriver.com>
Subject: [PATCH v2 1/2] Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
Date:   Tue, 28 Sep 2021 23:39:15 +0300
Message-Id: <2324212c8d0a713eba0aae3c25635b3ca5c5243f.1632861239.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927112017.19108-1-paskripkin@gmail.com>
References: <20210927112017.19108-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit ab609f25d19858513919369ff3d9a63c02cd9e2e.

This patch is correct in the sense that we _should_ call device_put() in
case of device_register() failure, but the problem in this code is more
vast.

We need to set bus->state to UNMDIOBUS_REGISTERED before calling
device_register() to correctly release the device in mdiobus_free().
This patch prevents us from doing it, since in case of device_register()
failure put_device() will be called 2 times and it will cause UAF or
something else.

Also, Reported-by: tag in revered commit was wrong, since syzbot
reported different leak in same function.

Link: https://lore.kernel.org/netdev/20210928092657.GI2048@kadam/
Cc: Yanfei Xu <yanfei.xu@windriver.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	Added this revert

---
 drivers/net/phy/mdio_bus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6f4b4e5df639..53f034fc2ef7 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -537,7 +537,6 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
-		put_device(&bus->dev);
 		return -EINVAL;
 	}
 
-- 
2.33.0

