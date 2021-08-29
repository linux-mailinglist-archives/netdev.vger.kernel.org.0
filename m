Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8343FA80D
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 02:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbhH2A3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 20:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhH2A27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 20:28:59 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AEFC061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 17:28:08 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id c8so10330172lfi.3
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 17:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3l70DLy5aSY62OLZHBch0NkaC9JJl5OYR9mteg+VIUg=;
        b=rpKJWzr29Me1i+/NA35jq1sPIbAAYUPksO9RQs70NM4u+N8nLEBUV6tw2AwqmRDnXb
         7UHvi4jPUNnMUNzI/X55QUqErNG+msFFwUAYj5FMpzrX5IytAdSGQ1sHIoJOlAk1Qivn
         uluVqeX9kClkQ6NoUTbGfnw64UyQ+M6e+8pzJbHj4LphOxlrykXnm9Y+k8gjuNiuUoIi
         uyDmj349ENtdthEMN82Z8eyLFMUsxCxUKmbX2Fab5BePkIAfxjeN84qyr8PE69XUDPIZ
         Z8yV1E/cV8dV6cJTEugOZZEnb3DOECW7tc42YRztvXWXzbD9zxeHb7wrHOiqjxGDadhh
         xFeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3l70DLy5aSY62OLZHBch0NkaC9JJl5OYR9mteg+VIUg=;
        b=FcDTc7tjDqzvKPO0FMVRrfPdvkpYW66TT0uiwFJLRHWd1GvFDQpbGYabVqAV4zhekX
         8CQv5wM+vynNarrSK1Vl7WF3uxDjG4jwx/zRzvI3hBpPXFG972HQd4ceP6EpswYyBPMq
         jIjZnwrLk54ZAJfobm8jb1zAZhQ9o31isj9iaaaEvkjUhYMCEXGPOkCUenEqQSIcmDJy
         OiTBY1AUUvQDJQhKrXWZABBnlRRJeoEa0Z4M77Ge7xWKOLwFJ+f3A5eqt4SpLSCHSIbP
         3IKZ0ZXkaMcZatgogyfL9fTgfJhLQAesSUZVo+02O+kAdATPk0QDEvKYxCSQ8w3otEHD
         k/rA==
X-Gm-Message-State: AOAM5314euK3O2h9xC/4Tsgx8rNEIIv6+f/94jFjfqvwCOI9gbAT+YDk
        e7G+FH5hYj4uxv0lxAKP5ocGRA==
X-Google-Smtp-Source: ABdhPJwad8009jIR/L7GyoXD0A9Zhf0lzryUJ7LKz7oATyoxE5xU70qvogtiHCThWMYnGDMkF8Uzlw==
X-Received: by 2002:a05:6512:39d4:: with SMTP id k20mr12394851lfu.390.1630196886406;
        Sat, 28 Aug 2021 17:28:06 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id m14sm995522lfo.196.2021.08.28.17.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 17:28:06 -0700 (PDT)
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
Subject: [PATCH net-next 1/2] net: dsa: rtl8366rb: support bridge offloading
Date:   Sun, 29 Aug 2021 02:26:00 +0200
Message-Id: <20210829002601.282521-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
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
 drivers/net/dsa/rtl8366rb.c | 84 +++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a89093bc6c6a..14939188c108 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -300,6 +300,12 @@
 #define RTL8366RB_INTERRUPT_STATUS_REG	0x0442
 #define RTL8366RB_NUM_INTERRUPT		14 /* 0..13 */
 
+/* Port isolation registers */
+#define RTL8366RB_PORT_ISO_BASE		0x0F08
+#define RTL8366RB_PORT_ISO(pnum)	(RTL8366RB_PORT_ISO_BASE + (pnum))
+#define RTL8366RB_PORT_ISO_EN		BIT(0)
+#define RTL8366RB_PORT_ISO_PORTS_MASK	GENMASK(7, 1)
+
 /* bits 0..5 enable force when cleared */
 #define RTL8366RB_MAC_FORCE_CTRL_REG	0x0F11
 
@@ -835,6 +841,21 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	/* Isolate all user ports so only the CPU port can access them */
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
+				   RTL8366RB_PORT_ISO_EN |
+				   BIT(RTL8366RB_PORT_NUM_CPU + 1));
+		if (ret)
+			return ret;
+	}
+	/* CPU port can access all ports */
+	ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(RTL8366RB_PORT_NUM_CPU),
+			   RTL8366RB_PORT_ISO_PORTS_MASK |
+			   RTL8366RB_PORT_ISO_EN);
+	if (ret)
+		return ret;
+
 	/* Set up the "green ethernet" feature */
 	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
 				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
@@ -1127,6 +1148,67 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
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
+					 BIT(port + 1), BIT(port + 1));
+		if (ret)
+			return ret;
+
+		port_bitmap |= BIT(i);
+	}
+
+	/* Set the bits for the ports we can access */
+	return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+				  RTL8366RB_PORT_ISO_PORTS_MASK,
+				  port_bitmap << 1);
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
+					 BIT(port + 1), 0);
+		if (ret)
+			return;
+
+		port_bitmap |= BIT(i);
+	}
+
+	/* Clear the bits for the ports we can access */
+	regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+			   port_bitmap << 1, 0);
+}
+
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
@@ -1510,6 +1592,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
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

