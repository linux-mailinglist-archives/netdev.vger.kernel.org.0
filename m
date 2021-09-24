Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C3B417E59
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345028AbhIXXkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343829AbhIXXk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:40:28 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A37C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:54 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id t10so46788346lfd.8
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f1Lk6JdP5CWoXDRFIqdoJOcLkUVMzlgSPzu3lEYWJIc=;
        b=XF3jgE+vk2ccsQuTLBTjaKFiYp1g/ox3qMJvsDITvKU/jSindLuUFEmdT0PEkgXWUz
         2yP0grzmGa0iMviNtdwW6eSJr6Yvk/T62daq37kIgqrZFV0ADix+rcwz4+nPPOoc4reP
         vM2e8cLV62sZMFNmp56k7lNQdt0nhhqRKs9dXibLO8U/zul52mIAtWphjbROhbkgUkxG
         WGtEsxKGjOn5PKlvy7D3v/z6QhSTbHw9z3iJDzOBX0ssFG/tUDs5Wk6Bs06XYghmwPuj
         Vu46NFqx1r7KsbuSBVpq5N1jKCk5zMmCytmbk2hQEx2tSuOLuy9BOKc6On7LbFxpT+4r
         5DyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f1Lk6JdP5CWoXDRFIqdoJOcLkUVMzlgSPzu3lEYWJIc=;
        b=2waDXP2AKwyDHvV95MlVUFVlhRUvUW7wmcdek08jH5DjUZtl9swbLe2mDwHC/aq28k
         k4LDT9pA2+nXQaUZ32mK2pQpKTaFo3XiVXYqJs2YKX4OxjlZUwYlkudgjMAHhWGnvqpX
         ViikSxeVZWUsM2/nLm4PQG0qTmWhcZr8PyfGyoEt5gZSeddCANZTa1LJ3els89+D+gMh
         GaJpSHKK+wym/FjU+n85V8eRbluzVT9F3JIxShQABis2MG5ITcgzEin9Pl2AhSBQOVm4
         2X/c/UT0pT+fGyORBXe1ubH3wOFxKX1v5w0HOallkC4dbS606Pd3yvFy1/SQETPTNWQG
         YreQ==
X-Gm-Message-State: AOAM531zdOU7NFTdyUTD8ITiFBEZ2OwqfNglAnA2ecLvCa6LU0/BkEAV
        YDIBtxA6yTfA35FRl1NlWK+WZg==
X-Google-Smtp-Source: ABdhPJz8dIvY5b49KjI7gFrab0YxQxT5OqPTd6odfrwFFka6fPRsLwiz7G7x/yRsCZ8nQCloqe+brA==
X-Received: by 2002:a2e:82c4:: with SMTP id n4mr14212417ljh.283.1632526732732;
        Fri, 24 Sep 2021 16:38:52 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k21sm1176652lji.81.2021.09.24.16.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:38:52 -0700 (PDT)
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
Subject: [PATCH net-next 3/6 v5] net: dsa: rtl8366rb: Rewrite weird VLAN filering enablement
Date:   Sat, 25 Sep 2021 01:36:25 +0200
Message-Id: <20210924233628.2016227-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924233628.2016227-1-linus.walleij@linaro.org>
References: <20210924233628.2016227-1-linus.walleij@linaro.org>
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
 drivers/net/dsa/rtl8366rb.c        | 31 +++++++++++++++++++++-----
 3 files changed, 25 insertions(+), 43 deletions(-)

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
index a5b7d7ff8884..1f228a7a5685 100644
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
 
@@ -1209,6 +1213,21 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
 			   RTL8366RB_PORT_ISO_PORTS(port_bitmap), 0);
 }
 
+static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
+				    bool vlan_filtering,
+				    struct netlink_ext_ack *extack)
+{
+	struct realtek_smi *smi = ds->priv;
+	int ret;
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
@@ -1437,7 +1456,7 @@ static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
 
-	if (vlan == 0 || vlan > max)
+	if (vlan > max)
 		return false;
 
 	return true;
@@ -1594,7 +1613,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
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

