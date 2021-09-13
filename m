Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4B1409763
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241712AbhIMPff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhIMPfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:35:25 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24984C12C745
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:34 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id s3so17751419ljp.11
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Segi0yvuz1/GUUIwrgvIqZ9jyUD+kdlugOeE72ywQP4=;
        b=ZPqE+VesFGU6Kly9pwUykJzXtz7ZqXStgDc/yREvjXjs98yrdH5KPrkzZqaVbs1BP6
         dQgBPFO3zQ+u3jS8pn2AeK+r8dOcXhf/Ag0m3/4cmf02LPiEyxu6RREufd4qONmbMSjH
         d8qAiCpzH4X/mxUA3yN9SySgs0boVMh+0VGX2scocDT3s/0g+C8P9I2ZdHSIchQVtTUB
         Wnpn9zOpJGOUR4JbH6cKpjULif7B0LYPggL9KVjRld1hhi/MVQy1BrLbULeJEuwd7mvD
         Vsebtd5oz6mbtpcQPondaKWbcXYM4YRoO7/7dhxJ5Guol2CNKmnY7UWNUxEhZ1igLUpy
         54yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Segi0yvuz1/GUUIwrgvIqZ9jyUD+kdlugOeE72ywQP4=;
        b=apfYAEWmpn9kOfuy/x//WS189VXY5RUN3u/nGAHpKheW3SsjYm6fgXlqmJTCO0oqSx
         g04Na1wHm3zbn3bP86yPulhG/LSCcsacckmoe970ughsPoXucvokJY8EGeu0SyUUO/w7
         g25ksdhjJU4Q9/x849gVsx+itdNiW9OXB+/o5c4+KctNdzIX88I3ln19R0kuU0QjnJm1
         DDCdyqOjj1SfVhVtev5S4a48JkUYh/EgoUgVZne5vIla3Rh6IohsUK8kMTcwIckcAUxr
         y9KoFJUGLovV0SKpGlgAZgJLpw3sfRgMbRc8CoU7p5l3qcKZFC/S9elTR3cuY6mwDcOa
         EE3w==
X-Gm-Message-State: AOAM532l1qzYDW+TRa/wKPwSm2kYGK7bk1V4hbBo8hfUkR1rUnmMxFu/
        Jc/6XIt1RNYhoZ+gNfmPuD1lgg==
X-Google-Smtp-Source: ABdhPJysNisMQ3W8I8r74uypActZ9QB/HaIf2KutkzaewyQsm3k7XErd+Iaf/SrFF4naI+hf+IFC5w==
X-Received: by 2002:a2e:7d13:: with SMTP id y19mr10818111ljc.344.1631544332462;
        Mon, 13 Sep 2021 07:45:32 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id i12sm849825lfb.301.2021.09.13.07.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 07:45:31 -0700 (PDT)
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
Subject: [PATCH net-next 1/8] net: dsa: rtl8366rb: Support bridge offloading
Date:   Mon, 13 Sep 2021 16:42:53 +0200
Message-Id: <20210913144300.1265143-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913144300.1265143-1-linus.walleij@linaro.org>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
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

