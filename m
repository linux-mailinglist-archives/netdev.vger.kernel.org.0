Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7F033ED3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 08:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfFDGLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 02:11:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40853 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFDGLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 02:11:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so9584517wre.7
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 23:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=U8nQJLQOWqinlF92/WhXqDu0KR0cNhmIRC1pOKu3b0g=;
        b=azoCtH/5F9BwRAOuUa/EAGstJGR5hR3289Proo/LKjBEzuG09svXQ84ALOsi4Jig6S
         deCgTm6U1o92JROgoy79NKX5nqRmuhJg1epp4w6XYDNlA3v9YmTzFxAS3p1bmu4Ooqcm
         PmT2xjTi6lW58INYl0gUZ5CPryeuAAm9rogEqHG8qb9wcnFezEHl55YX0Hvd52zXefEv
         B1vxTNZpVMhVHIT/4iLQQplK70gy/arDImABemGMyDk3+y7HaRJterhaHE+A3hUIZkYO
         zrHmkf3qQe32va1yT0gkSF1xSnzvhLDzN8EhqyqwWG29SO54RNama9QTGcozz1RdcLX2
         KQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=U8nQJLQOWqinlF92/WhXqDu0KR0cNhmIRC1pOKu3b0g=;
        b=X5Lr9g6Z4mBIL91Qr9TmBdXj9X6L2Y9Onfp5A5uhX92sLMAgwoSqO0F7E6oM7kZ6fX
         0ScQZIzfnY7ZJQzGHdjWJuCjQmHF6XTUW46yS8dQZR1QRm2kqVPmA3Bj2ZHk9PlmUDnB
         ZzzbbfVDjfYw0Q6ey9RAC3GzHCu8pPtx6WoKAjc3lSAjB2B8MdfY4TIIMmRmSh2VSas2
         OtbDmVCgRxCLA057qf+xr0rx+jDFafE79wcoHsBJKj8wGpBG0pjBtFvF8h+Nqg9e9M8g
         32EAN90Gvdoq09tcpLmTUAQ6RVqV+cpEFhFEwQ3iTSOuLCAyU4PDjAlyPbeCXjy6iaKA
         SRig==
X-Gm-Message-State: APjAAAXpJIFvPVN/JXo5Q2rwSaEj5t2YrVP3Bs/UIgl4AU0Pui0iAMpc
        vVueZgtrvOAdBozzpDLqLxYcbHsy
X-Google-Smtp-Source: APXvYqyxe882yNb97awF9uL+w2F4d+Pq6CcQWyKDsTDzNlW4N3wL0VlaB7vOu0OrwYxTCP9A/8ET4g==
X-Received: by 2002:adf:ef09:: with SMTP id e9mr5136258wro.79.1559628675724;
        Mon, 03 Jun 2019 23:11:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:15c:4632:d703:a1f7? (p200300EA8BF3BD00015C4632D703A1F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:15c:4632:d703:a1f7])
        by smtp.googlemail.com with ESMTPSA id l4sm6602750wmh.18.2019.06.03.23.11.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 23:11:15 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Robert Hancock <hancock@sedsystems.ca>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: add flag PHY_QUIRK_NO_ESTATEN
Message-ID: <e5518425-0a62-0790-8203-b011c3db69d3@gmail.com>
Date:   Tue, 4 Jun 2019 08:10:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a Xilinx GBit PHY that doesn't have BMSR_ESTATEN set
(what violates the Clause 22 standard). Instead of having the PHY
driver to implement almost identical copies of few generic functions
let's add a flag for this quirk to phylib.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c |  6 +++---
 include/linux/phy.h          | 16 +++++++++++++---
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2c879ba01..7593ebebf 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1595,7 +1595,7 @@ static int genphy_config_advert(struct phy_device *phydev)
 	 * 1000Mbits/sec capable PHYs shall have the BMSR_ESTATEN bit set to a
 	 * logical 1.
 	 */
-	if (!(bmsr & BMSR_ESTATEN))
+	if (!(bmsr & BMSR_ESTATEN) && !phy_quirk_no_estaten(phydev))
 		return changed;
 
 	/* Configure gigabit if it's supported */
@@ -1919,7 +1919,7 @@ int genphy_config_init(struct phy_device *phydev)
 	if (val & BMSR_10HALF)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, features);
 
-	if (val & BMSR_ESTATEN) {
+	if (val & BMSR_ESTATEN || phy_quirk_no_estaten(phydev)) {
 		val = phy_read(phydev, MII_ESTATUS);
 		if (val < 0)
 			return val;
@@ -1972,7 +1972,7 @@ int genphy_read_abilities(struct phy_device *phydev)
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, phydev->supported,
 			 val & BMSR_10HALF);
 
-	if (val & BMSR_ESTATEN) {
+	if (val & BMSR_ESTATEN || phy_quirk_no_estaten(phydev)) {
 		val = phy_read(phydev, MII_ESTATUS);
 		if (val < 0)
 			return val;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index dc4b51060..b2ffd82b1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -73,9 +73,10 @@ extern const int phy_10gbit_features_array[1];
 #define PHY_POLL		-1
 #define PHY_IGNORE_INTERRUPT	-2
 
-#define PHY_IS_INTERNAL		0x00000001
-#define PHY_RST_AFTER_CLK_EN	0x00000002
-#define MDIO_DEVICE_IS_PHY	0x80000000
+#define PHY_IS_INTERNAL		BIT(0)
+#define PHY_RST_AFTER_CLK_EN	BIT(1)
+#define PHY_QUIRK_NO_ESTATEN	BIT(2)
+#define MDIO_DEVICE_IS_PHY	BIT(31)
 
 /* Interface Mode definitions */
 typedef enum {
@@ -677,6 +678,15 @@ size_t phy_speeds(unsigned int *speeds, size_t size,
 void of_set_phy_supported(struct phy_device *phydev);
 void of_set_phy_eee_broken(struct phy_device *phydev);
 
+/**
+ * phy_quirk_no_estaten - Helper to check for flag PHY_QUIRK_NO_ESTATEN
+ * @phydev: The phy_device struct
+ */
+static inline bool phy_quirk_no_estaten(struct phy_device *phydev)
+{
+	return phydev->drv && phydev->drv->flags & PHY_QUIRK_NO_ESTATEN;
+}
+
 /**
  * phy_is_started - Convenience function to check whether PHY is started
  * @phydev: The phy_device struct
-- 
2.21.0


