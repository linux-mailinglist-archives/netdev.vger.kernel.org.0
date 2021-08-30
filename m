Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A853FBE92
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbhH3Vxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237167AbhH3Vxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:53:45 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FB2C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:52:51 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id h1so28374451ljl.9
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OPOenaKE+1kJAT6buGCuFkpiFLC09mvc5Fh3pG+x+KQ=;
        b=qpdfyD3wu1+ur1vKEVugdvICyOGi4YVhNX6LAV8pzOd6WV6VgrduS28h7OehnnPjho
         vIspmJh5q/k1UwvXz4AJz9Vzq8XHE8Ty4FFDlC8h37kUEmIo2HAempVKODct8hiolTxL
         6aEpDyGwrt8X+Xpw1SRWX/sAJ/qCf51lYOx7hMaI2V/NLDB8CtVhuweKQUUmawm4kbwz
         ix+A4PKpzRRWArie48YHLwEfTga9xtueUK1DOXSF+O81SVFRrZJhIeSVmfOHvHgt/VLU
         xPsy18Dy/R28GPoq1yGEFTcH/RkLYZjBD5xVLU+4oV963hB5GMGlmAxU9IUmggn+q6L0
         rteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OPOenaKE+1kJAT6buGCuFkpiFLC09mvc5Fh3pG+x+KQ=;
        b=ppykYeNR0bVvsLgYhkhMht8bGyN7/IqrUkH11+3rTTN8VUCoYuzwFlsl1BSxhlGpIL
         CHyjbtZs36PINIXLpl3I9t2GbeY17Lsh/T4TvK+lTTHaqAZ9hnbKOACRO7OnGZEjX2uX
         kCpPagDi8RhvmMZIdZoKwpktSedL6aTFfAxKiHZ5J6gra8xj+LsxSPvXxC09CCFO44E7
         05bEu9Sv9Mu4SXIybCiW5oo39gqxsvqCLCx1wZqKS2s/7Ym62/bl4GNAamFNgaT3NF3w
         cJ2MdUr+zZxfbc7b9CuOCniAT+Atuu6RzfHYI4TXdT9ow3Jy4QRcZ3quXAuOwnQrcVho
         mLZw==
X-Gm-Message-State: AOAM531YQZbAEzwC8d3unrJNm3nJ/xSnv00r8giAQ745+wdvYhnRFm9y
        ymQZE03Fit6/Axb2h+A3U/9Bbg==
X-Google-Smtp-Source: ABdhPJySM50kSzpCgI0XH4wT+JrWyti050taxnL5rdtMO7/FTxM+fuIkRM2sRNYfPsIPKMXpR8qENQ==
X-Received: by 2002:a2e:804a:: with SMTP id p10mr22413906ljg.216.1630360369435;
        Mon, 30 Aug 2021 14:52:49 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id h4sm1514049lft.184.2021.08.30.14.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 14:52:49 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 1/5 v2] net: dsa: rtl8366rb: support bridge offloading
Date:   Mon, 30 Aug 2021 23:48:55 +0200
Message-Id: <20210830214859.403100-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830214859.403100-1-linus.walleij@linaro.org>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

Use port isolation registers to configure bridge offloading.

Tested on the D-Link DIR-685, switching between ports and
sniffing ports to make sure no packets leak.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- introduce RTL8366RB_PORT_ISO_PORTS() to shift the port
  mask into place so we are not confused by the enable
  bit.
- Use this with dsa_user_ports() to isolate the CPU port
  from itself.
---
 drivers/net/dsa/rtl8366rb.c | 87 +++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a89093bc6c6a..50ee7cd62484 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -300,6 +300,13 @@
 #define RTL8366RB_INTERRUPT_STATUS_REG	0x0442
 #define RTL8366RB_NUM_INTERRUPT		14 /* 0..13 */
 
+/* Port isolation registers */
+#define RTL8366RB_PORT_ISO_BASE		0x0F08
+#define RTL8366RB_PORT_ISO(pnum)	(RTL8366RB_PORT_ISO_BASE + (pnum))
+#define RTL8366RB_PORT_ISO_EN		BIT(0)
+#define RTL8366RB_PORT_ISO_PORTS_MASK	GENMASK(7, 1)
+#define RTL8366RB_PORT_ISO_PORTS(pmask)	(pmask << 1)
+
 /* bits 0..5 enable force when cleared */
 #define RTL8366RB_MAC_FORCE_CTRL_REG	0x0F11
 
@@ -835,6 +842,22 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	/* Isolate all user ports so only the CPU port can access them */
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
+				   RTL8366RB_PORT_ISO_EN |
+				   RTL8366RB_PORT_ISO_PORTS(BIT(RTL8366RB_PORT_NUM_CPU)));
+		if (ret)
+			return ret;
+	}
+	/* CPU port can access all ports */
+	dev_info(smi->dev, "DSA user port mask: %08x\n", dsa_user_ports(ds));
+	ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(RTL8366RB_PORT_NUM_CPU),
+			   RTL8366RB_PORT_ISO_PORTS(dsa_user_ports(ds))|
+			   RTL8366RB_PORT_ISO_EN);
+	if (ret)
+		return ret;
+
 	/* Set up the "green ethernet" feature */
 	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
 				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
@@ -1127,6 +1150,68 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 	rb8366rb_set_port_led(smi, port, false);
 }
 
+static int
+rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
+			   struct net_device *bridge)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int port_bitmap = 0;
+	int ret, i;
+
+	/* Loop over all other ports than this one */
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		/* Handled last */
+		if (i == port)
+			continue;
+		/* Not on this bridge */
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+		/* Join this port to each other port on the bridge */
+		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
+					 RTL8366RB_PORT_ISO_PORTS(BIT(port)),
+					 RTL8366RB_PORT_ISO_PORTS(BIT(port)));
+		if (ret)
+			return ret;
+
+		port_bitmap |= BIT(i);
+	}
+
+	/* Set the bits for the ports we can access */
+	return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+				  RTL8366RB_PORT_ISO_PORTS_MASK,
+				  RTL8366RB_PORT_ISO_PORTS(port_bitmap));
+}
+
+static void
+rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
+			    struct net_device *bridge)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int port_bitmap = 0;
+	int ret, i;
+
+	/* Loop over all other ports than this one */
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		/* Handled last */
+		if (i == port)
+			continue;
+		/* Not on this bridge */
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+		/* Remove this port from any other port on the bridge */
+		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
+					 RTL8366RB_PORT_ISO_PORTS(BIT(port)), 0);
+		if (ret)
+			return;
+
+		port_bitmap |= BIT(i);
+	}
+
+	/* Clear the bits for the ports we can access */
+	regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+			   RTL8366RB_PORT_ISO_PORTS(port_bitmap), 0);
+}
+
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
@@ -1510,6 +1595,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_strings = rtl8366_get_strings,
 	.get_ethtool_stats = rtl8366_get_ethtool_stats,
 	.get_sset_count = rtl8366_get_sset_count,
+	.port_bridge_join = rtl8366rb_port_bridge_join,
+	.port_bridge_leave = rtl8366rb_port_bridge_leave,
 	.port_vlan_filtering = rtl8366_vlan_filtering,
 	.port_vlan_add = rtl8366_vlan_add,
 	.port_vlan_del = rtl8366_vlan_del,
-- 
2.31.1

