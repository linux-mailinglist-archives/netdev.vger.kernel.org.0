Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1787B107F5B
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 17:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfKWQ2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 11:28:50 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41799 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbfKWQ2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 11:28:49 -0500
Received: by mail-wr1-f66.google.com with SMTP id b18so12285187wrj.8
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 08:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=6Hyn/FSpgpQw+zPOOamKaaqvdfRupW+VHF0Gt4Mh8Dk=;
        b=Ajzx1tzxQJ7NyBx2G4GrRACEKj8xxraS91/f839i1n7xa+u4d0h+1eKYMzPCqGBNZ6
         F+iM7ormI8RnOp3lq7c+9Gt5jFSFwMZCnt7Qu0752UAfB9Kyfk3+yyAFFE531ctAMZZq
         bCIuUvgpO9EoCxTpr9UdVWcdEMa79vXfUE25HgtIh9yc+XIHv/mPe9zEG+ORKi1evuZK
         3NkQ6puSFWYfELGheQbGISIntC5RI/gXfGC+WE99e3WVdpaFJmtvG+cuVPxEW24eZtf7
         DRZbfVedc7zQKWf8HJ5dI8bG9DfWrh0bdLVkotmrBda++r70I0UJ/gWEwQHpDZHe64v0
         Jglw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=6Hyn/FSpgpQw+zPOOamKaaqvdfRupW+VHF0Gt4Mh8Dk=;
        b=Rg9n4RNYGHPgRg2cAToI9vvu8tzByleyZ4fMx9VUcfWCtcX7VLAb99sTYtvikL+COy
         H2m6o1C84236iBha8DoiQDhFJfLriogXh7dMT1QkzKyZvvIBUX9Bw5BUj5kPFzBR33Mk
         FbIE3/sPBo4cMC/a/E1aVsxHA6OYUtsA/slS0dFz5RgxPQtjsAgPuKFjXi0oop/tjn63
         BzffKYFY/SPVC6/n3BaumdLijyQXpCB5mlha+jHJ6qEMBZTg+txYVPqdxMn507aiKZXb
         9zDIvRCS89wu91ufam+f1TMlcF579PQa2C+Jdf+7XGxojmXAg1yqaW1LD1z5fkQo5R6a
         Ucxw==
X-Gm-Message-State: APjAAAW0HvDrJ/SC5hlKeMWgV/pZP9bYmi6VTsziUrEKXp5OSWtpSrB6
        SwwctEN7XeJPsr/ogNb+Z3NAcTwg
X-Google-Smtp-Source: APXvYqx6uFS/HvdQSqpOM6q89/J9kuuddOE2wrNKykUu/dPvDho/GPql0EzQMa5gup55Wyl07vQKIg==
X-Received: by 2002:adf:fd45:: with SMTP id h5mr19521263wrs.388.1574526525597;
        Sat, 23 Nov 2019 08:28:45 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:b95b:3533:2c0b:a023? (p200300EA8F2D7D00B95B35332C0BA023.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:b95b:3533:2c0b:a023])
        by smtp.googlemail.com with ESMTPSA id b10sm2715174wrw.53.2019.11.23.08.28.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 08:28:44 -0800 (PST)
To:     David Miller <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: add helpers phy_(un)lock_mdio_bus
Message-ID: <c0ec9c7b-d646-c9a5-d960-8710bc5bfc65@gmail.com>
Date:   Sat, 23 Nov 2019 17:28:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers to make locking/unlocking the MDIO bus easier.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy-core.c | 28 ++++++++++++++--------------
 include/linux/phy.h        | 10 ++++++++++
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 5458ed1b8..769a07651 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -419,9 +419,9 @@ int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
 {
 	int ret;
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 	ret = __phy_read_mmd(phydev, devad, regnum);
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	return ret;
 }
@@ -480,9 +480,9 @@ int phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 {
 	int ret;
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 	ret = __phy_write_mmd(phydev, devad, regnum, val);
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	return ret;
 }
@@ -536,9 +536,9 @@ int phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask, u16 set)
 {
 	int ret;
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 	ret = __phy_modify_changed(phydev, regnum, mask, set);
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	return ret;
 }
@@ -580,9 +580,9 @@ int phy_modify(struct phy_device *phydev, u32 regnum, u16 mask, u16 set)
 {
 	int ret;
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 	ret = __phy_modify(phydev, regnum, mask, set);
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	return ret;
 }
@@ -639,9 +639,9 @@ int phy_modify_mmd_changed(struct phy_device *phydev, int devad, u32 regnum,
 {
 	int ret;
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 	ret = __phy_modify_mmd_changed(phydev, devad, regnum, mask, set);
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	return ret;
 }
@@ -687,9 +687,9 @@ int phy_modify_mmd(struct phy_device *phydev, int devad, u32 regnum,
 {
 	int ret;
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 	ret = __phy_modify_mmd(phydev, devad, regnum, mask, set);
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	return ret;
 }
@@ -721,7 +721,7 @@ static int __phy_write_page(struct phy_device *phydev, int page)
  */
 int phy_save_page(struct phy_device *phydev)
 {
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 	return __phy_read_page(phydev);
 }
 EXPORT_SYMBOL_GPL(phy_save_page);
@@ -788,7 +788,7 @@ int phy_restore_page(struct phy_device *phydev, int oldpage, int ret)
 		ret = oldpage;
 	}
 
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	return ret;
 }
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 124516fe2..dbd4332b2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1076,6 +1076,16 @@ static inline const char *phydev_name(const struct phy_device *phydev)
 	return dev_name(&phydev->mdio.dev);
 }
 
+static inline void phy_lock_mdio_bus(struct phy_device *phydev)
+{
+	mutex_lock(&phydev->mdio.bus->mdio_lock);
+}
+
+static inline void phy_unlock_mdio_bus(struct phy_device *phydev)
+{
+	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+}
+
 void phy_attached_print(struct phy_device *phydev, const char *fmt, ...)
 	__printf(2, 3);
 void phy_attached_info(struct phy_device *phydev);
-- 
2.24.0

