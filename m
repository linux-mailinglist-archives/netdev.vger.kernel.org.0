Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA0B33C330
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbhCORBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235230AbhCORBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:01:53 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A52C06174A;
        Mon, 15 Mar 2021 10:01:52 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so14732742pjh.1;
        Mon, 15 Mar 2021 10:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P4LvijN3bMifiTb/0lgyYh4xxnVtEvA5pDE32AW+xU0=;
        b=uEQGdwQp2ak3InwMuxkKEOPJ0WuupFVWKkCc/lpIAOv209E9tvBFpLy4YnQpBc8Tfl
         eEu8jYzomYxIrhde2wlrgkddZ5Wqn8QjvMMFj4XouSVp+C4G/gx3lPlOAkAJ4ygl1Kj9
         2wSAiCviiAp9jX7AJBh/YSZzdwaMxmpdeDKpbywSdeA31LR5FnPwd1XfrktF/U8wghN9
         QpzSvrHJBehCJG6RXWiUoTVamAw4tYtB4v82R3HsngO2iluXqpMBOC0D8ibQ5IkHmjf+
         HxUgdQ7345vVukw5y+8U6iJU9HkIJlvIX2ILs7X9A8FuB7eMPBU+va5wol/qZzcBQYGw
         I21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P4LvijN3bMifiTb/0lgyYh4xxnVtEvA5pDE32AW+xU0=;
        b=IyjXWVct+1Iz0Xv2k23Pzus/keAg3DSDAxZFVLw5JhGz7bWpPvcFY9dx0R/3RbCFvM
         VHEMr9D55D+EcJHb2UfG2V6oSTTcFtBl7lyrre4RTVj9gTfzHCK0PQ9/7li9bw0kx4rV
         0lSZD90lLIERsUss123JZRRSyy2dWhdHgWqj9Vv7GElqKq7EI9BJWN1VShNd2rVGhs8Y
         dCJeq4ZeYWCJORTbNc9ia+3qzaNrlKCIDy/z5bMDwsfvY9TgTu8UQyRC8ugCIjyX7fpj
         /pYNp9eF2bxKdAF0sFZQPaHA3UDRQ7NVM4nDuP+3gglhGRDkLuMT09ZvLfQqo3aAmhCA
         2XVg==
X-Gm-Message-State: AOAM531hdQ0au4AUtoyb/FE6mqfj2JqSz7YFqBN1UueVWthrS0U9SvHU
        5Wiml2ian3EMtn8UuPHQjZQ=
X-Google-Smtp-Source: ABdhPJyDIkdABKsaucW86vRXx7R6hQzqtSddilHZNYedmrFS7IEZ6svFxREdahgLJxdftAj8OxutwQ==
X-Received: by 2002:a17:90a:7103:: with SMTP id h3mr49966pjk.82.1615827712517;
        Mon, 15 Mar 2021 10:01:52 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id t6sm176083pjs.26.2021.03.15.10.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 10:01:51 -0700 (PDT)
From:   LGA1150 <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next] net: dsa: rtl8366rb: support bridge offloading
Date:   Tue, 16 Mar 2021 01:01:44 +0800
Message-Id: <20210315170144.2081099-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

Use port isolation registers to configure bridge offloading.
Remove the VLAN init, as we have proper CPU tag and bridge offloading
support now.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
Changes since RFC:
  Fix build error

 drivers/net/dsa/rtl8366rb.c | 71 +++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a89093bc6c6a..bbcfdd84f0e9 100644
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
 
@@ -835,6 +841,15 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	/* Isolate user ports */
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
+				   RTL8366RB_PORT_ISO_EN |
+				   BIT(RTL8366RB_PORT_NUM_CPU + 1));
+		if (ret)
+			return ret;
+	}
+
 	/* Set up the "green ethernet" feature */
 	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
 				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
@@ -963,10 +978,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 			return ret;
 	}
 
-	ret = rtl8366_init_vlan(smi);
-	if (ret)
-		return ret;
-
 	ret = rtl8366rb_setup_cascaded_irq(smi);
 	if (ret)
 		dev_info(smi->dev, "no interrupt support\n");
@@ -977,8 +988,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
-	ds->configure_vlan_while_not_filtering = false;
-
 	return 0;
 }
 
@@ -1127,6 +1136,54 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
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
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		if (i == port)
+			continue;
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
+					 0, BIT(port + 1));
+		if (ret)
+			return ret;
+
+		port_bitmap |= BIT(i);
+	}
+
+	return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+				  0, port_bitmap << 1);
+}
+
+static void
+rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
+			    struct net_device *bridge)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int port_bitmap = 0;
+	int i;
+
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		if (i == port)
+			continue;
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+		regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
+				   BIT(port + 1), 0);
+
+		port_bitmap |= BIT(i);
+	}
+
+	regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+			   port_bitmap << 1, 0);
+}
+
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
@@ -1510,6 +1567,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_strings = rtl8366_get_strings,
 	.get_ethtool_stats = rtl8366_get_ethtool_stats,
 	.get_sset_count = rtl8366_get_sset_count,
+	.port_bridge_join = rtl8366rb_port_bridge_join,
+	.port_bridge_leave = rtl8366rb_port_bridge_leave,
 	.port_vlan_filtering = rtl8366_vlan_filtering,
 	.port_vlan_add = rtl8366_vlan_add,
 	.port_vlan_del = rtl8366_vlan_del,
-- 
2.25.1

