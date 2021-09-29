Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B6941CDC6
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346009AbhI2VIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345622AbhI2VIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:08:38 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3173BC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:06:57 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id b20so16378625lfv.3
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qWI4Ka7n0dQPnT0TU9YWQ06UE86yJzfw98UR0cjXhAs=;
        b=sve1s1NYfV8LKdtjDZJcKI0g55R/QRdpEVt7PgzFvk0gk62D4SYQ55qtejDYGfvIU2
         HR4npCkP2G6Ny7GJic8GGkhp6pUX3iTJF+R2KAPrXN5mRc1D1eTwQfvhj0jes5piGDzT
         Rz2qWD5FfrkAPLvARIBphD+Qd7HmjaCD1MLKXPKjeDGXWI50TF5ubZwHLJxVO7Rsv8+E
         zE+5fbbhxc4LW54IHQ0ZbVpl1XtoUeOVFJ+JUpRbriQnPfOtd8hH3zgIecarsU30+JLx
         BbGsdqjTLR4HlJWXx7FqKwqwLv0B/qaNdz96/tqfxBP+Sf9UqvdhTbOLTXtXxfGofTKW
         DtmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qWI4Ka7n0dQPnT0TU9YWQ06UE86yJzfw98UR0cjXhAs=;
        b=tETbwSU1F27AH0YEKQXX0q87jnUsMHqS89ccfaq/oF5B+2AWBr3J2yqqVVk8+hnG4e
         GBfoWMUIiwkR4MQbUpck0TLfreII/zjRVI2KewlYbyq2unRzAGb0taFQK3H6WmIx6CO+
         prThV5XRyre91iyoPXEeLXkAPvSe9uicmVOa/1fiRC1NCXFRXv7HlmfZx+pYzZx3DkY/
         4lorJSMD3WNDbcab8SCbN3WCcJTDyrSv3b6kDEyHMk9hgRD+Y1eiEVpCFbx2UJW2vIn9
         XcXDCK/S38UPhJNx66W5w6Q6DJXiIB/8lCpr2gznSg+ywMfF46pzk+c8rWPNNtlNI/xR
         LvTw==
X-Gm-Message-State: AOAM531SVK81CwKUxz4mg3bx3I6GO96U+Nh8xGpyTkpGLBd+WThRPxuo
        1GXve7ra9JkiuLb+0bEEt4Kavg==
X-Google-Smtp-Source: ABdhPJxchcvhxFwXhLHuhkk+QFtTCMVirQcfnW0iAHZFgGTqqoSyi9CANBBOZyvE43pPHRzl6ZMLdA==
X-Received: by 2002:ac2:59c6:: with SMTP id x6mr1930673lfn.298.1632949615472;
        Wed, 29 Sep 2021 14:06:55 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s9sm112613lfp.291.2021.09.29.14.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:06:54 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 1/4 v4] net: dsa: rtl8366rb: Support disabling learning
Date:   Wed, 29 Sep 2021 23:03:46 +0200
Message-Id: <20210929210349.130099-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929210349.130099-1-linus.walleij@linaro.org>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8366RB hardware supports disabling learning per-port
so let's make use of this feature. Rename some unfortunately
named registers in the process.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- No changes, rebased on other patches.
ChangeLog v2->v3:
- Disable learning by default, learning will be turned
  on selectively using the callback.
ChangeLog v1->v2:
- New patch suggested by Vladimir.
---
 drivers/net/dsa/rtl8366rb.c | 50 ++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index bb9d017c2f9f..b3056064b937 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -14,6 +14,7 @@
 
 #include <linux/bitops.h>
 #include <linux/etherdevice.h>
+#include <linux/if_bridge.h>
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 #include <linux/irqchip/chained_irq.h>
@@ -42,9 +43,12 @@
 /* Port Enable Control register */
 #define RTL8366RB_PECR				0x0001
 
-/* Switch Security Control registers */
-#define RTL8366RB_SSCR0				0x0002
-#define RTL8366RB_SSCR1				0x0003
+/* Switch per-port learning disablement register */
+#define RTL8366RB_PORT_LEARNDIS_CTRL		0x0002
+
+/* Security control, actually aging register */
+#define RTL8366RB_SECURITY_CTRL			0x0003
+
 #define RTL8366RB_SSCR2				0x0004
 #define RTL8366RB_SSCR2_DROP_UNKNOWN_DA		BIT(0)
 
@@ -927,13 +931,14 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		/* layer 2 size, see rtl8366rb_change_mtu() */
 		rb->max_mtu[i] = 1532;
 
-	/* Enable learning for all ports */
-	ret = regmap_write(smi->map, RTL8366RB_SSCR0, 0);
+	/* Disable learning for all ports */
+	ret = regmap_write(smi->map, RTL8366RB_PORT_LEARNDIS_CTRL,
+			   RTL8366RB_PORT_ALL);
 	if (ret)
 		return ret;
 
 	/* Enable auto ageing for all ports */
-	ret = regmap_write(smi->map, RTL8366RB_SSCR1, 0);
+	ret = regmap_write(smi->map, RTL8366RB_SECURITY_CTRL, 0);
 	if (ret)
 		return ret;
 
@@ -1272,6 +1277,37 @@ static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static int
+rtl8366rb_port_pre_bridge_flags(struct dsa_switch *ds, int port,
+				struct switchdev_brport_flags flags,
+				struct netlink_ext_ack *extack)
+{
+	/* We support enabling/disabling learning */
+	if (flags.mask & ~(BR_LEARNING))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int
+rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
+			    struct switchdev_brport_flags flags,
+			    struct netlink_ext_ack *extack)
+{
+	struct realtek_smi *smi = ds->priv;
+	int ret;
+
+	if (flags.mask & BR_LEARNING) {
+		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_LEARNDIS_CTRL,
+					 BIT(port),
+					 (flags.val & BR_LEARNING) ? 0 : BIT(port));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
@@ -1682,6 +1718,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.port_vlan_del = rtl8366_vlan_del,
 	.port_enable = rtl8366rb_port_enable,
 	.port_disable = rtl8366rb_port_disable,
+	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
+	.port_bridge_flags = rtl8366rb_port_bridge_flags,
 	.port_change_mtu = rtl8366rb_change_mtu,
 	.port_max_mtu = rtl8366rb_max_mtu,
 };
-- 
2.31.1

