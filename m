Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CB025EB27
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 23:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgIEV7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 17:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEV7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 17:59:46 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B7EC061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 14:59:45 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id k25so11856972ljg.9
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 14:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8zpEhhNtfBbtx0B6RqWPmSpARaYFGkA/S04KBRTF+ak=;
        b=m3JazldCGOrQ04pd27AVKvkNoyoks2IBfd/HBzpaJSwTpbRjdIgnimLjcJRWZHvMkX
         wdO2e70/Q31BfbPzDFw5BoEJd5AqOSS5e7lQcUjgkp0JFB301e6lJwC8HvanphB4QNoR
         ISV9sQ27plbcPmzHts8WyM2Yr3RxtxJhIeWKbi7CLrGAbibutGux79QQ+2ehSvNEG1Rw
         mD8saFpdIdDGllF2JwefrEuXFPhng2UfnWc6IbZcshEJdqYBqsvuD1vUAm/VnJdRNelf
         Bom7D3dPHhhX/eI5GimfNwgb4qTAYVB/1xxE2bY5sDtKtH+sB+Px5ZeRKkRlFL57J8UO
         fErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8zpEhhNtfBbtx0B6RqWPmSpARaYFGkA/S04KBRTF+ak=;
        b=HxvnbNjsmKcihBF77XYyuNGCUgtX6M7Gonftm0TiOd8L2Yxn0VwF7pkil7AdiE86L8
         FhPx5y4x2IUt14xEZ8hVlgZcnVQfd1jvJmXnt7iFZryEiqm23xe8MXbGBmPyadwAhdvK
         Gt/M+sIvz8Vox4rFj0hcgvTBJ5c6+cngfiaE7+uclKrP4B3TxjBa2vvM3Af9DWt/ZIKa
         BDj9+VIWej7zWPuNq8FJcGnMHBDnnn5hbZOTxYRBOYaOT457U88eYv4wwcuVpZicupZi
         MTA44rgN4GsjNSl0qovYt6iQursaMEPu39N/doS+qN4DXC+Puv86OAYeiaWqUBpvdrdY
         kuBg==
X-Gm-Message-State: AOAM533XWFpqcKyq/q310IMT9zmH7RY9F6zN7t/4GO5NO+qhHovgX9Wx
        z0xL2iYXpztX9CkM0qmYPlI9Ig3jWInzXw==
X-Google-Smtp-Source: ABdhPJwoHUoJ8+5neX0wnF1j9iOxXhgu+EpgkpWQKCyNyo62Fi70nfE4Mm6kE5ZLwm77NBy5T29zpg==
X-Received: by 2002:a2e:9e0a:: with SMTP id e10mr4120588ljk.454.1599343183792;
        Sat, 05 Sep 2020 14:59:43 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id i26sm2818516ljj.102.2020.09.05.14.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:59:43 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] net: dsa: rtl8366rb: Support setting MTU
Date:   Sat,  5 Sep 2020 23:59:14 +0200
Message-Id: <20200905215914.77640-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements the missing MTU setting for the RTL8366RB
switch.

Apart from supporting jumboframes, this rids us of annoying
boot messages like this:
realtek-smi switch: nonfatal error -95 setting MTU on port 0

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366rb.c | 38 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 48f1ff746799..f763f93f600f 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -35,7 +35,7 @@
 #define RTL8366RB_SGCR_MAX_LENGTH_1522		RTL8366RB_SGCR_MAX_LENGTH(0x0)
 #define RTL8366RB_SGCR_MAX_LENGTH_1536		RTL8366RB_SGCR_MAX_LENGTH(0x1)
 #define RTL8366RB_SGCR_MAX_LENGTH_1552		RTL8366RB_SGCR_MAX_LENGTH(0x2)
-#define RTL8366RB_SGCR_MAX_LENGTH_9216		RTL8366RB_SGCR_MAX_LENGTH(0x3)
+#define RTL8366RB_SGCR_MAX_LENGTH_16000		RTL8366RB_SGCR_MAX_LENGTH(0x3)
 #define RTL8366RB_SGCR_EN_VLAN			BIT(13)
 #define RTL8366RB_SGCR_EN_VLAN_4KTB		BIT(14)
 
@@ -1077,6 +1077,40 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 	rb8366rb_set_port_led(smi, port, false);
 }
 
+static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct realtek_smi *smi = ds->priv;
+	u32 len;
+
+	/* The first setting, 1522 bytes, is max IP packet 1500 bytes,
+	 * plus ethernet header, 1518 bytes, plus CPU tag, 4 bytes.
+	 * This function should consider the parameter an SDU, so the
+	 * MTU passed for this setting is 1518 bytes. The same logic
+	 * of subtracting the DSA tag of 4 bytes apply to the other
+	 * settings.
+	 */
+	if (new_mtu <= 1518)
+		len = RTL8366RB_SGCR_MAX_LENGTH_1522;
+	else if (new_mtu > 1518 && new_mtu <= 1532)
+		len = RTL8366RB_SGCR_MAX_LENGTH_1536;
+	else if (new_mtu > 1532 && new_mtu <= 1548)
+		len = RTL8366RB_SGCR_MAX_LENGTH_1552;
+	else
+		len = RTL8366RB_SGCR_MAX_LENGTH_16000;
+
+	return regmap_update_bits(smi->map, RTL8366RB_SGCR,
+				  RTL8366RB_SGCR_MAX_LENGTH_MASK,
+				  len);
+}
+
+static int rtl8366rb_max_mtu(struct dsa_switch *ds, int port)
+{
+	/* The max MTU is 16000 bytes, so we subtract the CPU tag
+	 * and the max presented to the system is 15996 bytes.
+	 */
+	return 15996;
+}
+
 static int rtl8366rb_get_vlan_4k(struct realtek_smi *smi, u32 vid,
 				 struct rtl8366_vlan_4k *vlan4k)
 {
@@ -1415,6 +1449,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.port_vlan_del = rtl8366_vlan_del,
 	.port_enable = rtl8366rb_port_enable,
 	.port_disable = rtl8366rb_port_disable,
+	.port_change_mtu = rtl8366rb_change_mtu,
+	.port_max_mtu = rtl8366rb_max_mtu,
 };
 
 static const struct realtek_smi_ops rtl8366rb_smi_ops = {
-- 
2.26.2

