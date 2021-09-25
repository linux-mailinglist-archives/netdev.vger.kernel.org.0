Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A620418514
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 01:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhIYXD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 19:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhIYXD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 19:03:27 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED482C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:51 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z24so58286955lfu.13
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MR0PfYx22ke+kh/lxH00XljqzBmM0dQBgyVIJd3ubUI=;
        b=ovrA7yy4r3PPO/W6llfIAmnxGiNudqE3KRajjaehEBA1OA8Sv+wlMg6JOC7W3qTGgD
         CmAaAM3C3slNSD1K70rfgN6xtcCT1CWOuZIjz+C+zt5LfH+uJlWIWUwMgQDwM98oivn4
         XXgLYpTkXyDtnRTszctePc4PG7VhC3FBfUghJBYWIg25xzsraw/ZOaw2DkkiguzLuUPt
         RiVn/DqOsR0UVFA+18gfFzT5LFAKyIV0nhywKjCQMsWZ0+U9ueVz8KyQ4615pOcdGDI7
         XsIzSrqBf/XzUBzAWJKwJTmF1Xekl/k3vPOdZxWdUbUA10OAk5u0FKVwhjF8Ki5qEt7l
         uW/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MR0PfYx22ke+kh/lxH00XljqzBmM0dQBgyVIJd3ubUI=;
        b=PINoqTpy4zx1W0U9BQrWSjnNgtnsUjdCWzVREtHBWgbUWfATYehDBa8ZgfDt/fN6LS
         loNmSLbQWKm2bJ7mBi7bvn7nhKB2eD8jULntmtPXDE1xAP2sZGETSCWlHtY4umW7ffxM
         A7ypbKgVtdnCtzXnEp0qbhIM+4lJ8KJkInw6t6SuSRDdnbQDeo2XTbC1l5x2zc16R8PH
         B6eyBIrISIdZDnUgAyz4nv0AazjTN7nX63MvAYLwjFhJsUo60C2FkQDCCswb65zmlkoo
         pzubQ9fNLSDHqrbwPv//VfxFBLGNaEF3BoLRe8PiBpvnTc73LASl/yTxOYdxZLm8TIsz
         GBMQ==
X-Gm-Message-State: AOAM530ZKn2V56SA15b9plp+LR3WByKLN0+Rd1i0LoN0vpyakeYCn5jE
        08fb714Zac92jZ+guCeZGRXn2A==
X-Google-Smtp-Source: ABdhPJyt+zHaXnOCoalA+XOrFmu1CT9B9q47wvBNkHYvKIr46uK3mKiB0r4eT5y5mYaj7t4718Ilcg==
X-Received: by 2002:a2e:8782:: with SMTP id n2mr20157642lji.177.1632610910343;
        Sat, 25 Sep 2021 16:01:50 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id d27sm1448111ljo.119.2021.09.25.16.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 16:01:50 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 1/6 v7] net: dsa: rtl8366rb: Support bridge offloading
Date:   Sun, 26 Sep 2021 00:59:24 +0200
Message-Id: <20210925225929.2082046-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210925225929.2082046-1-linus.walleij@linaro.org>
References: <20210925225929.2082046-1-linus.walleij@linaro.org>
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
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v6->v7:
- Collect Vladimir's review tag.
ChangeLog v5->v6:
- No changes just resending with the rest of the
  patches.
ChangeLog v4->v5:
- No changes just resending with the rest of the
  patches.
ChangeLog v3->v4:
- Fix a bug where I managed to mask off the CPU port
  from the ports we could access leading to numb
  bridge.
- Reword some comments.
ChangeLog v2->v3:
- Parens around the (pmask) in the port isolation macro.
- Do not exit join/leave functions on regmap failures,
  print an error and continue.
- Clarify comments around the port in join/leave
  functions.
ChangeLog v1->v2:
- introduce RTL8366RB_PORT_ISO_PORTS() to shift the port
  mask into place so we are not confused by the enable
  bit.
- Use this with dsa_user_ports() to isolate the CPU port
  from itself.
---
 drivers/net/dsa/rtl8366rb.c | 86 +++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a89093bc6c6a..b930050cfd1b 100644
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
+#define RTL8366RB_PORT_ISO_PORTS(pmask)	((pmask) << 1)
+
 /* bits 0..5 enable force when cleared */
 #define RTL8366RB_MAC_FORCE_CTRL_REG	0x0F11
 
@@ -835,6 +842,21 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	/* Isolate all user ports so they can only send packets to itself and the CPU port */
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
+				   RTL8366RB_PORT_ISO_PORTS(BIT(RTL8366RB_PORT_NUM_CPU)) |
+				   RTL8366RB_PORT_ISO_EN);
+		if (ret)
+			return ret;
+	}
+	/* CPU port can send packets to all ports */
+	ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(RTL8366RB_PORT_NUM_CPU),
+			   RTL8366RB_PORT_ISO_PORTS(dsa_user_ports(ds)) |
+			   RTL8366RB_PORT_ISO_EN);
+	if (ret)
+		return ret;
+
 	/* Set up the "green ethernet" feature */
 	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
 				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
@@ -1127,6 +1149,68 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
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
+	/* Loop over all other ports than the current one */
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		/* Current port handled last */
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
+			dev_err(smi->dev, "failed to join port %d\n", port);
+
+		port_bitmap |= BIT(i);
+	}
+
+	/* Set the bits for the ports we can access */
+	return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+				  RTL8366RB_PORT_ISO_PORTS(port_bitmap),
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
+		/* Current port handled last */
+		if (i == port)
+			continue;
+		/* Not on this bridge */
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+		/* Remove this port from any other port on the bridge */
+		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
+					 RTL8366RB_PORT_ISO_PORTS(BIT(port)), 0);
+		if (ret)
+			dev_err(smi->dev, "failed to leave port %d\n", port);
+
+		port_bitmap |= BIT(i);
+	}
+
+	/* Clear the bits for the ports we can not access, leave ourselves */
+	regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+			   RTL8366RB_PORT_ISO_PORTS(port_bitmap), 0);
+}
+
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
@@ -1510,6 +1594,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
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

