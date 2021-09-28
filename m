Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A2C41B250
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241311AbhI1Oqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241398AbhI1Oqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 10:46:31 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA028C06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:44:51 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id y26so54384794lfa.11
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RfMbMlQjSaKkpfo5xwj8gseBOZYY/BMF2dEl6C0fxC0=;
        b=sdQ0Qdhxilyfy10pym7nFr+vqT5EzQjH2dZLiQ4uCXPnHSrmkjDtwkSt4KoKijGoR3
         fN+mAhOS4s1rGFr3LS4XMLUm3kI2t5C+5iwbA5bv3kq8zXnwhjKGNx5bRhGkdmyLp1WM
         VmeXiiR4iFoPnOUeRshe8B7f+3ZdA8uFi1h/dB0EKohoSfaChDJxm22DVVlsu7963EuK
         8qpfJ89WuHA5EwuyQH+mlGSdQUYK80vxiQoWx05aHyb+MrPonqQMufu6N3ssgiQ1dX0C
         BgBllj7cdkrR30mCuOfP4F1EEZqNYUEDqERuycrT70IFD9/m2jcPBAhzIQd8jTVsjH2L
         XRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RfMbMlQjSaKkpfo5xwj8gseBOZYY/BMF2dEl6C0fxC0=;
        b=Bg7uJoZbt1thZNQMyEqpGUkER2GV1Mge39fDhtQO2HtOS7Zrfki8HUVnDrZLcos59A
         saI0P5Oj506TcN/YUGyRwzaGboaaeDwMU5L6z8V9QtRR8uHn8z4ggbQZYbV8TKzMOq9q
         c9Um52b5sRfM84+XNSkNgGIK7U/1X5NYZKjQHFPPDRyxLL/Rk+3kneJEZ6sj4AHXaBXB
         ynG7u1yfLNkFL59NU7zT3GzSMoAPMIMIPt5m0yn019qgE+iwRzc/V490K9SdgRptwnQr
         hiDuhryyjaA77YjoZL2LFcXXNVfW1A2dGQj7drNf0/aKD88QCiUqs27EqTrxjc209/ZW
         atBA==
X-Gm-Message-State: AOAM531FAUPfiiBzU+xdvGLvUHTrO+MyXJwhUfjBto2PC5uhXaGyVNP/
        T3OJLvgVd5pp5Aur0FI1h6Gg1A==
X-Google-Smtp-Source: ABdhPJwgalsB4e6Af4X1whhW0ybTdLqWPW/0FZYHYgj3/EK9ZhvlYnqLiWYshATdSp5NDDSyXpWGEA==
X-Received: by 2002:a05:6512:2302:: with SMTP id o2mr6156471lfu.297.1632840288841;
        Tue, 28 Sep 2021 07:44:48 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x23sm1933462lfd.136.2021.09.28.07.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 07:44:47 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 3/6 v8] net: dsa: rtl8366rb: Rewrite weird VLAN filering enablement
Date:   Tue, 28 Sep 2021 16:41:46 +0200
Message-Id: <20210928144149.84612-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928144149.84612-1-linus.walleij@linaro.org>
References: <20210928144149.84612-1-linus.walleij@linaro.org>
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
with filtering on the RTL8366RB, so we implement an ASIC-specific
callback and implement filering using the register bit that makes
the switch drop frames if the port is not in the VLAN member set.

The DSA documentation Documentation/networking/switchdev.rst states:

  When the bridge has VLAN filtering enabled and a PVID is not
  configured on the ingress port, untagged and 802.1p tagged
  packets must be dropped. When the bridge has VLAN filtering
  enabled and a PVID exists on the ingress port, untagged and
  priority-tagged packets must be accepted and forwarded according
  to the bridge's port membership of the PVID VLAN. When the
  bridge has VLAN filtering disabled, the presence/lack of a
  PVID should not influence the packet forwarding decision.

To comply with this, we add two arrays of bool in the RTL8366RB
state that keeps track of if filtering and PVID is enabled or
not for each port. We then add code such that whenever filtering
or PVID changes, we update the filter according to the
specification.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v7->v8:
- Do not keep track of the filtering state in the driver but
  use the core dsa_port_is_vlan_filtering() to query the
  state instead.
- Fix some spelling mistake.
- Collect Alvin's Review tag
ChangeLog v6->v7:
- Add comments to the register definitions.
- Rewrite the code to keep track on whether filtering and
  PVID is enabled on each port, and use this information to
  selectively drop untagged and C-tagged (802.1p) frames.
- Add a hook in the PVID setup to always check the filtering
  of untagged and C-tagged frames when changing the PVID
  setting.
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
 drivers/net/dsa/realtek-smi-core.h |  2 -
 drivers/net/dsa/rtl8366.c          | 35 -----------
 drivers/net/dsa/rtl8366rb.c        | 97 +++++++++++++++++++++++++++---
 3 files changed, 90 insertions(+), 44 deletions(-)

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
index a5b7d7ff8884..b565074b0462 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -143,6 +143,21 @@
 #define RTL8366RB_PHY_NO_OFFSET			9
 #define RTL8366RB_PHY_NO_MASK			(0x1f << 9)
 
+/* VLAN Ingress Control Register 1, one bit per port.
+ * bit 0 .. 5 will make the switch drop ingress frames without
+ * VID such as untagged or priority-tagged frames for respective
+ * port.
+ * bit 6 .. 11 will make the switch drop ingress frames carrying
+ * a C-tag with VID != 0 for respective port.
+ */
+#define RTL8366RB_VLAN_INGRESS_CTRL1_REG	0x037E
+#define RTL8366RB_VLAN_INGRESS_CTRL1_DROP(port)	(BIT((port)) | BIT((port) + 6))
+
+/* VLAN Ingress Control Register 2, one bit per port.
+ * bit0 .. bit5 will make the switch drop all ingress frames with
+ * a VLAN classification that does not include the port is in its
+ * member set.
+ */
 #define RTL8366RB_VLAN_INGRESS_CTRL2_REG	0x037f
 
 /* LED control registers */
@@ -321,9 +336,11 @@
 /**
  * struct rtl8366rb - RTL8366RB-specific data
  * @max_mtu: per-port max MTU setting
+ * @pvid_enabled: if PVID is set for respective port
  */
 struct rtl8366rb {
 	unsigned int max_mtu[RTL8366RB_NUM_PORTS];
+	bool pvid_enabled[RTL8366RB_NUM_PORTS];
 };
 
 static struct rtl8366_mib_counter rtl8366rb_mib_counters[] = {
@@ -933,11 +950,13 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
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
 
@@ -1209,6 +1228,50 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
 			   RTL8366RB_PORT_ISO_PORTS(port_bitmap), 0);
 }
 
+/**
+ * rtl8366rb_drop_untagged() - make the switch drop untagged and C-tagged frames
+ * @smi: SMI state container
+ * @port: the port to drop untagged and C-tagged frames on
+ * @drop: whether to drop or pass untagged and C-tagged frames
+ */
+static int rtl8366rb_drop_untagged(struct realtek_smi *smi, int port, bool drop)
+{
+	return regmap_update_bits(smi->map, RTL8366RB_VLAN_INGRESS_CTRL1_REG,
+				  RTL8366RB_VLAN_INGRESS_CTRL1_DROP(port),
+				  drop ? RTL8366RB_VLAN_INGRESS_CTRL1_DROP(port) : 0);
+}
+
+static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
+				    bool vlan_filtering,
+				    struct netlink_ext_ack *extack)
+{
+	struct realtek_smi *smi = ds->priv;
+	struct rtl8366rb *rb;
+	int ret;
+
+	rb = smi->chip_data;
+
+	dev_dbg(smi->dev, "port %d: %s VLAN filtering\n", port,
+		vlan_filtering ? "enable" : "disable");
+
+	/* If the port is not in the member set, the frame will be dropped */
+	ret = regmap_update_bits(smi->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
+				 BIT(port), vlan_filtering ? BIT(port) : 0);
+	if (ret)
+		return ret;
+
+	/* If VLAN filtering is enabled and PVID is also enabled, we must
+	 * not drop any untagged or C-tagged frames. If we turn off VLAN
+	 * filtering on a port, we need to accept any frames.
+	 */
+	if (vlan_filtering)
+		ret = rtl8366rb_drop_untagged(smi, port, !rb->pvid_enabled[port]);
+	else
+		ret = rtl8366rb_drop_untagged(smi, port, false);
+
+	return ret;
+}
+
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
@@ -1420,14 +1483,34 @@ static int rtl8366rb_get_mc_index(struct realtek_smi *smi, int port, int *val)
 
 static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
 {
+	struct rtl8366rb *rb;
+	bool pvid_enabled;
+	int ret;
+
+	rb = smi->chip_data;
+	pvid_enabled = !!index;
+
 	if (port >= smi->num_ports || index >= RTL8366RB_NUM_VLANS)
 		return -EINVAL;
 
-	return regmap_update_bits(smi->map, RTL8366RB_PORT_VLAN_CTRL_REG(port),
+	ret = regmap_update_bits(smi->map, RTL8366RB_PORT_VLAN_CTRL_REG(port),
 				RTL8366RB_PORT_VLAN_CTRL_MASK <<
 					RTL8366RB_PORT_VLAN_CTRL_SHIFT(port),
 				(index & RTL8366RB_PORT_VLAN_CTRL_MASK) <<
 					RTL8366RB_PORT_VLAN_CTRL_SHIFT(port));
+	if (ret)
+		return ret;
+
+	rb->pvid_enabled[port] = pvid_enabled;
+
+	/* If VLAN filtering is enabled and PVID is also enabled, we must
+	 * not drop any untagged or C-tagged frames. Make sure to update the
+	 * filtering setting.
+	 */
+	if (dsa_port_is_vlan_filtering(dsa_to_port(smi->ds, port)))
+		ret = rtl8366rb_drop_untagged(smi, port, !pvid_enabled);
+
+	return ret;
 }
 
 static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
@@ -1437,7 +1520,7 @@ static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
 
-	if (vlan == 0 || vlan > max)
+	if (vlan > max)
 		return false;
 
 	return true;
@@ -1594,7 +1677,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
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

