Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF2C2B35FC
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 17:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbgKOQDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 11:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgKOQDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 11:03:17 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C9CC0613D1
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 08:03:16 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id p8so16033956wrx.5
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 08:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=+kPADuB27E+rgrzb+JXoMzNZFgbtHr3srVTi834KqI4=;
        b=B1FbFB8jr5RD/SUnroBGcRcMO0zW8Yz5NmGGACIBYS1gAWbtRXv+W54L6LspDiHdO2
         XJsBnj9D+caq1KyjRNlxz+QwHzLQjTKLBbn1wshUEeTK0688AvWVIYMy1XGK433JAemW
         7hu1m8pauoXjjnBGR2Ko7WymjqYDPfH0iC/844DrWOC60ZhV2xwXJSrakdUvH21gSxmt
         jVTQ8XzzuJMky3NAazURiDP7qJIrx0vTpYLnRBX+N+aWrbeGPKDee2S69QJTciHTEYpw
         PY5DN7f9P7P8ika5kXZOaWJPF7mjEwYSod1ZV2QFOklg95IlHA9BKy5YDZo5iwYGeUcr
         W+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=+kPADuB27E+rgrzb+JXoMzNZFgbtHr3srVTi834KqI4=;
        b=h2nG2JzJNNM7sVcFeJCmkeXlGvP8acV49BwSqJnAAmMquWj1m7rR+VWgBuZHvLOhli
         NI/rK5sNJdx9cRdp/kGgTChoD7QtUh6/9dTRHFa5otKqnFIR2FGBhXLV8xNe1Eo6fcUR
         eYOv6o8FnSqCTxWBGgPmwMzO8Cin55XTYqmSLf48UqqEGs/nH5iBIBCpylX0om31VNC+
         P5LunKutR5d5vWxi39Iof9PrZw2nXC8yEsHx3Ir6mhQizjpjGI1M0G3W7o4PuNMXcna+
         uvAjci+tfG2asua4h55rv94/kzk82Ajso8K+9F/+bKUVjTPpZdMuszhJxct/BMccYP0t
         7C8g==
X-Gm-Message-State: AOAM533UZc1d9wn4LR/rkHrvUx2edjAZeut83gfJzB1sBHPePJ++XS1u
        kgIG7Xl4pQRHJXNH6qlm+Le4ulwsGUXHQg==
X-Google-Smtp-Source: ABdhPJzb76pRhEQ35Jypoi00kXILYk+1FcmaBlfreMb8Q3wg6OfUsDvXKiUVleJZX3Dm4zgLdOPERg==
X-Received: by 2002:adf:b78b:: with SMTP id s11mr14704596wre.42.1605456195211;
        Sun, 15 Nov 2020 08:03:15 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:a8ab:4fab:3f88:f3fd? (p200300ea8f232800a8ab4fab3f88f3fd.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a8ab:4fab:3f88:f3fd])
        by smtp.googlemail.com with ESMTPSA id f5sm19655633wrg.32.2020.11.15.08.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2020 08:03:14 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: don't duplicate driver name in
 phy_attached_print
Message-ID: <8ab72586-f079-41d8-84ee-9f6a5bd97b2a@gmail.com>
Date:   Sun, 15 Nov 2020 16:03:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we print the driver name twice in phy_attached_print():
- phy_dev_info() prints it as part of the device info
- and we print it as part of the info string

This is a little bit ugly, it makes the info harder to read,
especially if the driver name is a little bit longer.
Therefore omit the driver name (if set) in the info string.

Example from r8169 that uses phylib:

old: Generic FE-GE Realtek PHY r8169-300:00: attached PHY driver \
   [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=r8169-300:00, irq=IGNORE)
new: Generic FE-GE Realtek PHY r8169-300:00: attached PHY driver \
   (mii_bus:phy_addr=r8169-300:00, irq=IGNORE)

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e13a46c25..04652603a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1156,7 +1156,7 @@ void phy_attached_info(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_attached_info);
 
-#define ATTACHED_FMT "attached PHY driver [%s] (mii_bus:phy_addr=%s, irq=%s)"
+#define ATTACHED_FMT "attached PHY driver %s(mii_bus:phy_addr=%s, irq=%s)"
 char *phy_attached_info_irq(struct phy_device *phydev)
 {
 	char *irq_str;
@@ -1181,19 +1181,17 @@ EXPORT_SYMBOL(phy_attached_info_irq);
 
 void phy_attached_print(struct phy_device *phydev, const char *fmt, ...)
 {
-	const char *drv_name = phydev->drv ? phydev->drv->name : "unbound";
+	const char *unbound = phydev->drv ? "" : "[unbound] ";
 	char *irq_str = phy_attached_info_irq(phydev);
 
 	if (!fmt) {
-		phydev_info(phydev, ATTACHED_FMT "\n",
-			 drv_name, phydev_name(phydev),
-			 irq_str);
+		phydev_info(phydev, ATTACHED_FMT "\n", unbound,
+			    phydev_name(phydev), irq_str);
 	} else {
 		va_list ap;
 
-		phydev_info(phydev, ATTACHED_FMT,
-			 drv_name, phydev_name(phydev),
-			 irq_str);
+		phydev_info(phydev, ATTACHED_FMT, unbound,
+			    phydev_name(phydev), irq_str);
 
 		va_start(ap, fmt);
 		vprintk(fmt, ap);
-- 
2.29.2

