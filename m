Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509383FBE94
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbhH3Vxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238759AbhH3Vxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:53:48 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25DAC06175F
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:52:53 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id h1so28374615ljl.9
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ygzbCZeLrFRK4C7lX1xuZX3+5YuPXt2lUz8XmLXuXb4=;
        b=ULJ1sAjl7WgYNynZYhc8h70jKLUpzlMxhdcWSidWDIKbW5KQqTpdUo2IHayNNXvq/H
         1NGRu0qqchshbqau9yxck1obR50pJnieXHIII95VkoyJ+kr1VxwlXBdSxL/CQUZ/jgzQ
         +ubgyQOk7FfjnbWXo446+zIekEB5umSJXwI0Cy2nykoxSbXNMuNQhxUY0GVAn5o0l8QQ
         6ABGRpQFVL/lnw+ibKbMI43bss4LdaWs6pI9/yLePRcSVco6MgFihF8JrGXlg5Wm90YV
         scxe982AxwJ3UyDv4Ndh2DL2PXZOhHEI2RxJf7iB6VMN1Rc76bw6bYyGllKiPhk326gu
         gXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ygzbCZeLrFRK4C7lX1xuZX3+5YuPXt2lUz8XmLXuXb4=;
        b=n7nw3pSpQ5tCqYE8kb9eLTym4hpr/zTpsU3wb6Vbcqj6EgzZ98vdHx6SrRZotxIN9y
         cKSJVxm61pRECepQVkeIwkNrdH0mWvQvvGJBeoQU+aEI4t3IG5S2qZvii5rIMs917IZy
         cySYyGLlsn+w43mFERFtmJMjJLnXukEC+x0KXoCgIdKCa4afkCiVrPE6DpnRlBljI6o/
         zVR3FdDQN9b4AWQ+LBf+SKzPsekzdYJv3CfYaYIcUEvMJDGWnBDk9wLeH8/Xpy8XJrlS
         UwhWMWWPqydUXy5GhSCvNvDT9Rpl0umMuQf+GJbMfEqiXLBLaOAtJFb0pBRUBLsh6xaH
         RCaQ==
X-Gm-Message-State: AOAM533ox9NHpH7WRmMgxxDPVAPoB/X30ln01TStb+K+mMsd7G3ucJUu
        6h1hRZJXxEpGg1kXH4rtO3YSIg==
X-Google-Smtp-Source: ABdhPJzug4J/BQ3GDv46urk1SWlbYbdveuPKBwcNTqyebvwCeMKlb9EhZYKcu9bOzIAUgdmPPEd+wQ==
X-Received: by 2002:a2e:bf0d:: with SMTP id c13mr376437ljr.101.1630360372232;
        Mon, 30 Aug 2021 14:52:52 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id h4sm1514049lft.184.2021.08.30.14.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 14:52:51 -0700 (PDT)
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
Subject: [PATCH net-next 3/5 v2] net: dsa: rtl8366rb: Support disabling learning
Date:   Mon, 30 Aug 2021 23:48:57 +0200
Message-Id: <20210830214859.403100-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830214859.403100-1-linus.walleij@linaro.org>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
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
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- New patch suggested by Vladimir.
---
 drivers/net/dsa/rtl8366rb.c | 47 +++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 8b040440d2d4..2cadd3e57e8b 100644
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
 
@@ -912,12 +916,12 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		rb->max_mtu[i] = 1532;
 
 	/* Enable learning for all ports */
-	ret = regmap_write(smi->map, RTL8366RB_SSCR0, 0);
+	ret = regmap_write(smi->map, RTL8366RB_PORT_LEARNDIS_CTRL, 0);
 	if (ret)
 		return ret;
 
 	/* Enable auto ageing for all ports */
-	ret = regmap_write(smi->map, RTL8366RB_SSCR1, 0);
+	ret = regmap_write(smi->map, RTL8366RB_SECURITY_CTRL, 0);
 	if (ret)
 		return ret;
 
@@ -1148,6 +1152,37 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 	rb8366rb_set_port_led(smi, port, false);
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
 static int
 rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
 			   struct net_device *bridge)
@@ -1600,6 +1635,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
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

