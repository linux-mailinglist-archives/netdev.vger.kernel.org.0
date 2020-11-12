Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8282B094B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgKLP63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728867AbgKLP61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:27 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624BFC0613D1;
        Thu, 12 Nov 2020 07:58:27 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id a15so6882796edy.1;
        Thu, 12 Nov 2020 07:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EHyQQOuXf5BU03as2u/ud2yF/KPxzFMDQ2v3ffUTBGc=;
        b=Utq/OY7XRc/1p3xa6RHABkxuywYkGAebNmi4tUghrLQjwkT+P7YgNrGip2HfcBH39l
         idwnT3O57BEwpdF0Ks7RzAIfd2j2HQrw/k8kk2fHLNkO6YFqtwf6q8mYLAu4zzuAL5gO
         qn2VRmGUd/mYVHcJvdXu2SsSar0PzR3/QGv5yAtbxewQmS8Q5isxuxwp4o4k9LvmNI1Y
         Rp4BarqCdTMaarkQGuyhf1PoP0KI6WL2BeMKK3Dy9jrUJMUuPlbiASdYLMakmmIf0fas
         sWUDShjF7Glc0iO+Ut+qrpglv1sqhy/MJnqFVzAn+lZ/BfvKqz1OXFUzCfr8IvJzIXbz
         +LUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EHyQQOuXf5BU03as2u/ud2yF/KPxzFMDQ2v3ffUTBGc=;
        b=QTmtzIGS6zQHANrppfLYlshDTf5ASwJXdBwHTmn/zeK7s6g4cV7PfPxnX97o8SCjV4
         p3iNoX+RoHFhWh3IcuEB9ja7Entl3fYpv/am7DFlEzDWqeEVDQZywpKVxrP4ktRuuxP6
         Nn0KeKaR2FNT/XSWV6XMj6i3yH0USaHvi5jiyVcqQP5dF7+goKylyNcAZjyvybQjHhnW
         i3e0jQDnyW0rn2RmBPOpVDD+FHfnaTT8kQsx4K0fPxM5GpHgZEbV8JoTCkLOUyzK0dZr
         c8mkA8h7yjnEYNKkw+HZ0ugRk8Pkop/1FX4jZczfXpM1PW+sbXvRWTiXCHMd6lU4ko5j
         HGnw==
X-Gm-Message-State: AOAM531/hw29KGSl96W6gmRENStA5n06Paq4YOFF/7AjDFWT06f3Kbwy
        BoBQl26LUbysR9MPTrp4XOE=
X-Google-Smtp-Source: ABdhPJweZwoyUgwW3g5JPWBu+a0P3//eI6J11zMAQkYN2ayetuvfxpi4yxOZ//ewRQFDsxXXI0T8CQ==
X-Received: by 2002:a50:ab5e:: with SMTP id t30mr413639edc.314.1605196706153;
        Thu, 12 Nov 2020 07:58:26 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:25 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH net-next 08/18] net: phy: lxt: remove the use of .ack_interrupt()
Date:   Thu, 12 Nov 2020 17:55:03 +0200
Message-Id: <20201112155513.411604-9-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112155513.411604-1-ciorneiioana@gmail.com>
References: <20201112155513.411604-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In preparation of removing the .ack_interrupt() callback, we must replace
its occurrences (aka phy_clear_interrupt), from the 2 places where it is
called from (phy_enable_interrupts and phy_disable_interrupts), with
equivalent functionality.

This means that clearing interrupts now becomes something that the PHY
driver is responsible of doing, before enabling interrupts and after
clearing them. Make this driver follow the new contract.

Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/lxt.c | 44 +++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
index 716d9936bc90..0ee23d29c0d4 100644
--- a/drivers/net/phy/lxt.c
+++ b/drivers/net/phy/lxt.c
@@ -78,10 +78,23 @@ static int lxt970_ack_interrupt(struct phy_device *phydev)
 
 static int lxt970_config_intr(struct phy_device *phydev)
 {
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
-		return phy_write(phydev, MII_LXT970_IER, MII_LXT970_IER_IEN);
-	else
-		return phy_write(phydev, MII_LXT970_IER, 0);
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = lxt970_ack_interrupt(phydev);
+		if (err)
+			return err;
+
+		err = phy_write(phydev, MII_LXT970_IER, MII_LXT970_IER_IEN);
+	} else {
+		err = phy_write(phydev, MII_LXT970_IER, 0);
+		if (err)
+			return err;
+
+		err = lxt970_ack_interrupt(phydev);
+	}
+
+	return err;
 }
 
 static irqreturn_t lxt970_handle_interrupt(struct phy_device *phydev)
@@ -129,10 +142,23 @@ static int lxt971_ack_interrupt(struct phy_device *phydev)
 
 static int lxt971_config_intr(struct phy_device *phydev)
 {
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
-		return phy_write(phydev, MII_LXT971_IER, MII_LXT971_IER_IEN);
-	else
-		return phy_write(phydev, MII_LXT971_IER, 0);
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = lxt971_ack_interrupt(phydev);
+		if (err)
+			return err;
+
+		err = phy_write(phydev, MII_LXT971_IER, MII_LXT971_IER_IEN);
+	} else {
+		err = phy_write(phydev, MII_LXT971_IER, 0);
+		if (err)
+			return err;
+
+		err = lxt971_ack_interrupt(phydev);
+	}
+
+	return err;
 }
 
 static irqreturn_t lxt971_handle_interrupt(struct phy_device *phydev)
@@ -285,7 +311,6 @@ static struct phy_driver lxt97x_driver[] = {
 	.phy_id_mask	= 0xfffffff0,
 	/* PHY_BASIC_FEATURES */
 	.config_init	= lxt970_config_init,
-	.ack_interrupt	= lxt970_ack_interrupt,
 	.config_intr	= lxt970_config_intr,
 	.handle_interrupt = lxt970_handle_interrupt,
 }, {
@@ -293,7 +318,6 @@ static struct phy_driver lxt97x_driver[] = {
 	.name		= "LXT971",
 	.phy_id_mask	= 0xfffffff0,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt	= lxt971_ack_interrupt,
 	.config_intr	= lxt971_config_intr,
 	.handle_interrupt = lxt971_handle_interrupt,
 	.suspend	= genphy_suspend,
-- 
2.28.0

