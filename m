Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAABE417E57
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245709AbhIXXk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245038AbhIXXkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:40:25 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941F4C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:51 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id y28so46385668lfb.0
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jnT3sJXLA57GZ/AQJZhWi+XbpVu8sqEszBnk3MfHqYw=;
        b=N9KaThGn050IWLOTn66Xm2lRr5ap3DTFLn0IKfXqELLK6pL788ReLU7AhgNq/fxoG/
         fM/LDX7dpHk0SP+IQwE8Wp2bEbdS+uifcgzkrKooikYCQJ99GpEInsjblxRls+yU1Xql
         VLBq7rAdFgWIimTayIrndpFJzzY8yGgfkfWMG9pHsiCZ5rk+c9SbZw1ed7GjtErfEoET
         EemczMimWqxTKj0L7/W4m4a+o81qbe2XzJDC8efrOxIEILIR7f5P/fohGmwFmWThyAeq
         8llTJbFfOBXEy83/+Uy4+4paytvsVK5qO25fbBwAdh3pf2vshTdH2RvpgChlmlJaFDbg
         4T3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jnT3sJXLA57GZ/AQJZhWi+XbpVu8sqEszBnk3MfHqYw=;
        b=AjWae71xihsUMCYfZNrdcZCdDK0WohMqzjm2Jtft4KuwZEerTKyU8HBB5G3OMfTOC9
         bRHJDnRZJ5KXLTyCoAhbuQPJAFtMCrx6Ms6/v6mMa4a2SNLhFRwqzlLIRgfGwkKt13au
         /Dl46zvZSG0XVGQYlCbDLkojcjygXNK9KaXkJrlh7LNIM5p38cTe33hM3rwAdSegmPbq
         HFl0CxewOnl0KsQox7zpDyIsTwnLrcu+Rrk3KNaV8slBC4+iyLfijn1qyJGlVRPNq6G6
         nLBG4lqoui634RpvRoTBJMJ1NHbFbb8tMoW5OHYHOCOc1LE+AfZ6PFJcJq8v6Vv7T+qE
         R6Lg==
X-Gm-Message-State: AOAM531M9cm9j9901DHHhwI71cRz/zAdZShdHU0/jjpz/0WwvQG4jvux
        LkR2HjQDyHbEkQQidFNXarvtJA==
X-Google-Smtp-Source: ABdhPJxJjDhepPxc3SIxgyzcVnOZgXd2/vGEKe9VcxiK1mN5718Y8ygpRWgS//dJYfpCumFeTwlrQw==
X-Received: by 2002:a2e:87ca:: with SMTP id v10mr13094638ljj.369.1632526729882;
        Fri, 24 Sep 2021 16:38:49 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k21sm1176652lji.81.2021.09.24.16.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:38:49 -0700 (PDT)
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
Subject: [PATCH net-next 1/6 v5] net: dsa: rtl8366rb: Support bridge offloading
Date:   Sat, 25 Sep 2021 01:36:23 +0200
Message-Id: <20210924233628.2016227-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924233628.2016227-1-linus.walleij@linaro.org>
References: <20210924233628.2016227-1-linus.walleij@linaro.org>
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
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
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

