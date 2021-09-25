Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F08418240
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 15:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245563AbhIYN1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 09:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245524AbhIYN1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 09:27:09 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53791C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 06:25:34 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u8so52108417lff.9
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 06:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iAP+yZt5ncqGNoQg/AEmqn2wFTwsPLnCWgGNpidADs4=;
        b=KKUZslDSHCLor8pLmklrCxphfirZNeBlXWsMIeNPIEp7Irmv3id2IpvU/cynt99Fmp
         ug0Zk/TTnjnTCkC3DsnAEH0xsxHVcWZiii4R0BlWMN919qM9j4VBIPmG9xjU9iNm2wKf
         KcXSifuGcNFTdY3dVHam8OYKWwMxCzNmIsdxEEy+Gmk9LxG1zS88cNTlSI1L1s2K+/5A
         xVhECQnJMCblL/6ClDYDmU0LyFtyIhTW2nndtD8Sk+47vsZ1tHFBbKUL3+ZfqXSAnHZP
         g9k0Tu5c+23D/t0UfQ652J8vpbwud2uffG1g2+wOpFPSnSKRRW3wDxnYZjYi3rv1d9/S
         /k8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iAP+yZt5ncqGNoQg/AEmqn2wFTwsPLnCWgGNpidADs4=;
        b=e2qa2/BBMMNfXYpjV8jqjpsBdeyzNg+pwccEsu1knLv/RrOCOkkIbjy0FAeOemilS/
         8nqWLTgyAzpmc2epL5ntZWn3bwunh5eytPofRZ686Z8EoENUc6DLEGMdpv/J42HYMTy9
         YJEs102bzrhG0Xpr7IpR6klG95e/SIaEh0GQYOaqmK0yEsp4v8aE6vSflynNBwwG3E3H
         htSjY7Dgae1oVWaNfRg979qP32yhIlha9RJi8MdUjLfaMlaE9vI8MWVuNtVXu3n5pi6q
         zMewdHaBKVsl6UTvqX+fSdteko8s3buSVQsbpNXlESCRbRPW2MtcmK9tvJ3HIDer+itT
         p8FA==
X-Gm-Message-State: AOAM531fEJaw/1hzVPFsQTnJBIFXkd2bDn/5kVgJdmjbhFyhk5ads7wM
        7V82HgIS/QHjF3aXJnrLeHMG6A==
X-Google-Smtp-Source: ABdhPJx4bWyBHKJ+8LpMEYqEXzdHVnzxXIp5O0/Cu3X3i6T0xf1LiCzkWRyJvDPGlFuhH/d3F2sWgg==
X-Received: by 2002:a05:6512:3128:: with SMTP id p8mr15087412lfd.502.1632576332671;
        Sat, 25 Sep 2021 06:25:32 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id y25sm199590ljj.23.2021.09.25.06.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 06:25:32 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 3/6 v6] net: dsa: rtl8366rb: Rewrite weird VLAN filering enablement
Date:   Sat, 25 Sep 2021 15:23:08 +0200
Message-Id: <20210925132311.2040272-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210925132311.2040272-1-linus.walleij@linaro.org>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While we were defining one VLAN per port for isolating the ports
the port_vlan_filtering() callback was implemented to enable a
VLAN on the port + 1. This function makes no sense, not only is
it incomplete as it only enables the VLAN, it doesn't do what
the callback is supposed to do, which is to selectively enable
and disable filtering on a certain port.

Implement the correct callback: we have two registers dealing
with filtering on the RTL9366RB, so we implement an ASIC-specific
callback and implement filering using the register bit that makes
the switch drop frames if the port is not in the VLAN member set.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v5->v6:
- Drop unused leftover variable "ret"
ChangeLog v4->v5:
- Drop the code dropping frames without VID, after Florian
  described that this is not expected semantics for this
  callback.
ChangeLog v1->v4:
- New patch after discovering that this weirdness of mine is
  causing problems.
---
 drivers/net/dsa/realtek-smi-core.h |  2 --
 drivers/net/dsa/rtl8366.c          | 35 ------------------------------
 drivers/net/dsa/rtl8366rb.c        | 30 ++++++++++++++++++++-----
 3 files changed, 24 insertions(+), 43 deletions(-)

diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index c8fbd7b9fd0b..214f710d7dd5 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -129,8 +129,6 @@ int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 int rtl8366_enable_vlan4k(struct realtek_smi *smi, bool enable);
 int rtl8366_enable_vlan(struct realtek_smi *smi, bool enable);
 int rtl8366_reset_vlan(struct realtek_smi *smi);
-int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
-			   struct netlink_ext_ack *extack);
 int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan,
 		     struct netlink_ext_ack *extack);
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 59c5bc4f7b71..0672dd56c698 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -292,41 +292,6 @@ int rtl8366_reset_vlan(struct realtek_smi *smi)
 }
 EXPORT_SYMBOL_GPL(rtl8366_reset_vlan);
 
-int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
-			   struct netlink_ext_ack *extack)
-{
-	struct realtek_smi *smi = ds->priv;
-	struct rtl8366_vlan_4k vlan4k;
-	int ret;
-
-	/* Use VLAN nr port + 1 since VLAN0 is not valid */
-	if (!smi->ops->is_vlan_valid(smi, port + 1))
-		return -EINVAL;
-
-	dev_info(smi->dev, "%s filtering on port %d\n",
-		 vlan_filtering ? "enable" : "disable",
-		 port);
-
-	/* TODO:
-	 * The hardware support filter ID (FID) 0..7, I have no clue how to
-	 * support this in the driver when the callback only says on/off.
-	 */
-	ret = smi->ops->get_vlan_4k(smi, port + 1, &vlan4k);
-	if (ret)
-		return ret;
-
-	/* Just set the filter to FID 1 for now then */
-	ret = rtl8366_set_vlan(smi, port + 1,
-			       vlan4k.member,
-			       vlan4k.untag,
-			       1);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rtl8366_vlan_filtering);
-
 int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan,
 		     struct netlink_ext_ack *extack)
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a5b7d7ff8884..2c66a0c2ee50 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -143,6 +143,8 @@
 #define RTL8366RB_PHY_NO_OFFSET			9
 #define RTL8366RB_PHY_NO_MASK			(0x1f << 9)
 
+/* VLAN Ingress Control Register */
+#define RTL8366RB_VLAN_INGRESS_CTRL1_REG	0x037E
 #define RTL8366RB_VLAN_INGRESS_CTRL2_REG	0x037f
 
 /* LED control registers */
@@ -933,11 +935,13 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	/* Discard VLAN tagged packets if the port is not a member of
-	 * the VLAN with which the packets is associated.
-	 */
+	/* Accept all packets by default, we enable filtering on-demand */
+	ret = regmap_write(smi->map, RTL8366RB_VLAN_INGRESS_CTRL1_REG,
+			   0);
+	if (ret)
+		return ret;
 	ret = regmap_write(smi->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
-			   RTL8366RB_PORT_ALL);
+			   0);
 	if (ret)
 		return ret;
 
@@ -1209,6 +1213,20 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
 			   RTL8366RB_PORT_ISO_PORTS(port_bitmap), 0);
 }
 
+static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
+				    bool vlan_filtering,
+				    struct netlink_ext_ack *extack)
+{
+	struct realtek_smi *smi = ds->priv;
+
+	dev_dbg(smi->dev, "port %d: %s VLAN filtering\n", port,
+		vlan_filtering ? "enable" : "disable");
+
+	/* If the port is not in the member set, the frame will be dropped */
+	return regmap_update_bits(smi->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
+				  BIT(port), vlan_filtering ? BIT(port) : 0);
+}
+
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
@@ -1437,7 +1455,7 @@ static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
 
-	if (vlan == 0 || vlan > max)
+	if (vlan > max)
 		return false;
 
 	return true;
@@ -1594,7 +1612,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_sset_count = rtl8366_get_sset_count,
 	.port_bridge_join = rtl8366rb_port_bridge_join,
 	.port_bridge_leave = rtl8366rb_port_bridge_leave,
-	.port_vlan_filtering = rtl8366_vlan_filtering,
+	.port_vlan_filtering = rtl8366rb_vlan_filtering,
 	.port_vlan_add = rtl8366_vlan_add,
 	.port_vlan_del = rtl8366_vlan_del,
 	.port_enable = rtl8366rb_port_enable,
-- 
2.31.1

