Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFFA10D81
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 21:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfEATyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 15:54:35 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45650 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEATye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 15:54:34 -0400
Received: by mail-wr1-f67.google.com with SMTP id s15so25779548wra.12
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 12:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NKPtm+HwJ02Jv4ss+nossrB6dd4/54X4LWggsxI8rVs=;
        b=eWZv2fkDgmBaZ1a6NmX5UgEEzpa5Y4G8h0vVIJxEb6MJUy2KUynkpLNqsC2Dp4KEuK
         yWG0/+pdLtTibbT/TWqVjgS2u4KoyGqA+1Cj2sQNwB4cHkUNxRGfgGvPQqeh8LWwzL0a
         U8CkU4YZOM5JiZToZ3ituMItqZH9JveBU6cI4lhv8XlHB2+XgyWH8CL4+kB2qlLZxwpn
         Fl+ajdKqqjdT5ecbvp4CuyvZViuCb36ovA3vnn5eDsnlnzJOTqM/txGkEeZ/0xY/vIqO
         SpLrdCfV5Oudbu1k1q5ZpCWuZvGNXN40hHmzOffSfexbpwpNfrNzM3aBSG4OE43cYLU6
         jdew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NKPtm+HwJ02Jv4ss+nossrB6dd4/54X4LWggsxI8rVs=;
        b=tC2a07QABtLcwxN3k8nsJvxf0yKAaFlCqtVrYWrAXcs3YCyKItuqfATmyowSXczGRP
         ow1T2Ue/o73oZt82wQcPlMl2mN0PAEhpajKGu2GBGlE8fd42+DwVd9gB8tJlz2L5Bimp
         WwibaaL5p+xD9S0gdFIq2Fp21eNt9ykZdwAwHzEuICH5ExrIAMVxRjv8edzAzqSex0D7
         5t9ndPkD8tc67yamg+6RFM4yGfIf48SvSH+o35ydBw7Ccjo7OlXO6rbKItAn1stRL7LK
         c1maJSfMWd7KTd0DItTtB7R19flhbfk17K4nhC/ZJ6o6+RT2ZCPcn01B1ustjiw6KwaO
         KZ/g==
X-Gm-Message-State: APjAAAXD6vXQAv6omnPBdtoRFsJnDeHJZjUd6wXrLqbPVa9jkkz++Cu6
        DoMdrTZT5lbTDzGuigIL4A8eCElT6KQ=
X-Google-Smtp-Source: APXvYqxExwLryGAqzDx3rKYPJSCThM58HRIeAw0F3rDq/PoXsLlJp75uGl7+xDxkp37HuuVzolOt/w==
X-Received: by 2002:adf:f102:: with SMTP id r2mr21080949wro.136.1556740472574;
        Wed, 01 May 2019 12:54:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:a160:62e9:d01f:fc0a? (p200300EA8BD45700A16062E9D01FFC0A.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:a160:62e9:d01f:fc0a])
        by smtp.googlemail.com with ESMTPSA id e10sm31931996wra.52.2019.05.01.12.54.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 12:54:31 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net-next] net: phy: improve pause handling
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5ac8d9b0-ac63-64d2-d5e1-e0911a35e534@gmail.com>
Message-ID: <d437c5d8-e683-4d69-7818-c6f69053bc02@gmail.com>
Date:   Wed, 1 May 2019 21:34:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5ac8d9b0-ac63-64d2-d5e1-e0911a35e534@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When probing the phy device we set sym and asym pause in the "supported"
bitmap (unless the PHY tells us otherwise). However we don't know yet
whether the MAC supports pause. Simply copying phy->supported to
phy->advertising will trigger advertising pause, and that's not
what we want. Therefore add phy_advertise_supported() that copies all
modes but doesn't touch the pause bits.

In phy_support_(a)sym_pause we shouldn't set any bits in the supported
bitmap because we may set a bit the PHY intentionally disabled.
Effective pause support should be the AND-combined PHY and MAC pause
capabilities. If the MAC supports everything, then it's only relevant
what the PHY supports. If MAC supports sym pause only, then we have to
clear the asym bit in phydev->supported.
Copy the pause flags only and don't touch the modes, because a driver
may have intentionally removed a mode from phydev->advertising.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- removed patch 2 from the series
---
 drivers/net/phy/fixed_phy.c  |  2 +-
 drivers/net/phy/phy-core.c   |  2 +-
 drivers/net/phy/phy_device.c | 36 +++++++++++++++++++++++++++++-------
 include/linux/phy.h          |  1 +
 4 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 1acd8bfdb..3ffe46df2 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -301,7 +301,7 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 				 phy->supported);
 	}
 
-	linkmode_copy(phy->advertising, phy->supported);
+	phy_advertise_supported(phy);
 
 	ret = phy_device_register(phy);
 	if (ret) {
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 12ce67102..3daf0214a 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -228,7 +228,7 @@ int phy_set_max_speed(struct phy_device *phydev, u32 max_speed)
 	if (err)
 		return err;
 
-	linkmode_copy(phydev->advertising, phydev->supported);
+	phy_advertise_supported(phydev);
 
 	return 0;
 }
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2a2aaa5f3..544b98b34 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1985,10 +1985,35 @@ EXPORT_SYMBOL(genphy_loopback);
 void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode)
 {
 	linkmode_clear_bit(link_mode, phydev->supported);
-	linkmode_copy(phydev->advertising, phydev->supported);
+	phy_advertise_supported(phydev);
 }
 EXPORT_SYMBOL(phy_remove_link_mode);
 
+static void phy_copy_pause_bits(unsigned long *dst, unsigned long *src)
+{
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, dst,
+		linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, src));
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, dst,
+		linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, src));
+}
+
+/**
+ * phy_advertise_supported - Advertise all supported modes
+ * @phydev: target phy_device struct
+ *
+ * Description: Called to advertise all supported modes, doesn't touch
+ * pause mode advertising.
+ */
+void phy_advertise_supported(struct phy_device *phydev)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(new);
+
+	linkmode_copy(new, phydev->supported);
+	phy_copy_pause_bits(new, phydev->advertising);
+	linkmode_copy(phydev->advertising, new);
+}
+EXPORT_SYMBOL(phy_advertise_supported);
+
 /**
  * phy_support_sym_pause - Enable support of symmetrical pause
  * @phydev: target phy_device struct
@@ -1999,8 +2024,7 @@ EXPORT_SYMBOL(phy_remove_link_mode);
 void phy_support_sym_pause(struct phy_device *phydev)
 {
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->supported);
-	linkmode_copy(phydev->advertising, phydev->supported);
+	phy_copy_pause_bits(phydev->advertising, phydev->supported);
 }
 EXPORT_SYMBOL(phy_support_sym_pause);
 
@@ -2012,9 +2036,7 @@ EXPORT_SYMBOL(phy_support_sym_pause);
  */
 void phy_support_asym_pause(struct phy_device *phydev)
 {
-	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->supported);
-	linkmode_copy(phydev->advertising, phydev->supported);
+	phy_copy_pause_bits(phydev->advertising, phydev->supported);
 }
 EXPORT_SYMBOL(phy_support_asym_pause);
 
@@ -2177,7 +2199,7 @@ static int phy_probe(struct device *dev)
 		phydev->is_gigabit_capable = 1;
 
 	of_set_phy_supported(phydev);
-	linkmode_copy(phydev->advertising, phydev->supported);
+	phy_advertise_supported(phydev);
 
 	/* Get the EEE modes we want to prohibit. We will ask
 	 * the PHY stop advertising these mode later on
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0f9552b17..4a03f8a46 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1154,6 +1154,7 @@ void phy_request_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
 int phy_set_max_speed(struct phy_device *phydev, u32 max_speed);
 void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode);
+void phy_advertise_supported(struct phy_device *phydev);
 void phy_support_sym_pause(struct phy_device *phydev);
 void phy_support_asym_pause(struct phy_device *phydev);
 void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
-- 
2.21.0


