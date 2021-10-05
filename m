Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD9C4230F8
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbhJETvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbhJETvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:51:06 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B425C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 12:49:15 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id j5so562080lfg.8
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 12:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6cOBj8Ho+R4A3czQgOztHyGCDFY9XNMJ6+Udhy+QpXk=;
        b=W0p1TIfPeZBJIzpESMXdx9qvlAwqgecetFByDKVbe9Lc8YHQRNfm8xP0u063ZL4eq3
         RbDtAWAOe7UAo5AT/9Nfsjl9DbS+XCZfVcUttEbuteSWuCJIvnqsCI8ZtuGQCdtEARou
         MIKRKJ/aPA/I2jR+xz4BjkEWurAp/JtqqQf2h4/zVuD5vFYwoxArv9lmcWTHGUnf5Da7
         VB0HlCGln8AVFfeSwCfoV3aWlWh0XkQSCtroAkRowGPI89xi/uq1XOB5KUb7+5NXGj5a
         3wzeYllfwtD4eqPDPvVPhCcDxJBg5xw6Pb1kZ1CTB600I1PuGxvvH2Kyvqtm17rYB2pR
         qC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6cOBj8Ho+R4A3czQgOztHyGCDFY9XNMJ6+Udhy+QpXk=;
        b=3r4Z4cYtbn1owBiIvcchBMiBov8RkEvphBPNP8pStB8JtjBmo9huePfukEFeEExUTE
         Gied9cx8PHtAw6FIKYr1KyqLPiUGcSXiWItXh7cvNgWFyesU0d3W0NScBlxY1BPH28pP
         3XPHLjUB4CA8pu8hBQuVsGw14g552LtITMS6VjEj9kvxrwp5ihcANVzA1sOsIvZ/8HX6
         R12BhXpLmod4tqQpH7PDMp7kQ7gQvZpiQklQ3625U9GklqhM+YOdC2T3Ns+f7sJYJ08H
         wRQhhKMJdIOPtq/m1Cx4qvbTt5oZhpyV+p72FAEmnHFocfGh6lSmIaF0naO924qeUXI8
         zTvg==
X-Gm-Message-State: AOAM532jFddiTSmlQjlJRY0hk5t71PC/1tWcpmO9I6EOK9l4D65H4wqR
        Ur5tUb7D0mxCqpZcO9JdZsrx1Q==
X-Google-Smtp-Source: ABdhPJzY80DsKARaQhVvfa8bLVVeGLI7Jq6SnN5CV2lObpv3ZKw6BDYtXOsUmVxF/nbhyveRixT8eQ==
X-Received: by 2002:ac2:4251:: with SMTP id m17mr5539862lfl.514.1633463353635;
        Tue, 05 Oct 2021 12:49:13 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k28sm2083577ljn.57.2021.10.05.12.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 12:49:13 -0700 (PDT)
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
Subject: [PATCH net-next 1/3 v5] net: dsa: rtl8366rb: Support disabling learning
Date:   Tue,  5 Oct 2021 21:47:02 +0200
Message-Id: <20211005194704.342329-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005194704.342329-1-linus.walleij@linaro.org>
References: <20211005194704.342329-1-linus.walleij@linaro.org>
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- Collect Vladimir's review tag.
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

