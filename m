Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A80F31AE05
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhBMUpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhBMUpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:45:12 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DECC06178A
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:07 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id y26so5104539eju.13
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KuVtxaPnvS4sbA/jhYdW+x0XjJTSU88eh02faiRLnbo=;
        b=K10Do/ptX3tKsanY5/l/g0So3ZrlHkuikIFmGMudzJYjzRHotum64f4Gr5Jbpmr0yb
         ZKvxQ5Pzz/dBIXrpm5tg+TlqqU4SlF+PEEXUgKnHcve4Uba/wfhhyNfhKqc8+iRjBF76
         pA31ivTUZgynT6Db3Gq/4fqlVLWuAcfj4lk0BzgBefYw8X9CXPyQiZvTEvNQ8zPt4Twp
         Nqzg+llOe4CWmLuwHHLKrKYYEGJalDtB6z0O7VUuHUaJxjCYXp5FlC+V8oOVf6iOCidk
         DYmMZQTPCQHgUn14eEqDe8ZLXeqLrvR4FoEHtXrtMfdQP68Fcsf+pjnBf4ZhskZp5eha
         d1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KuVtxaPnvS4sbA/jhYdW+x0XjJTSU88eh02faiRLnbo=;
        b=ImwQGlz5hYXgjM/KUIxBm8+BCikGn8OUC9cZpk6EAnzma9KByj2saREFhBksMxCTJl
         Z+u/GT0IHqVO8UmrsCqtphgno5cVA1RmStUbJyp76QwVqf93+jI4a80GV4tD62j/hkEq
         sksNyDyypXRkGWOWegDqZJcOBk7Bp+KJnK0pBae0834yTfo6eRKDtFgLg94x+cFar88t
         tvjizzLo8cdjAlHgurswU0K/TbSdYVim8lonBZUnQw19AH38oZM6D+YxXmCDd2BUdwVx
         hNCnZzEV/bRTiMD/JNGpgX+CVlqzjx/LTH9vxbMQ6kpDHfy+dsKB7G8oUt/egzFTzqX2
         RzIg==
X-Gm-Message-State: AOAM532gh0BdPXKjroLl2vEx4v/x3dK3pKBf3tGHTqzBdN6ntDVTQvqF
        B3u7RN0cPEFX6g+Imc4iaV8=
X-Google-Smtp-Source: ABdhPJzAtFtJFc5tyEkccQakziiK8GbDSXgkFsTEUMRtTEcESOI4IC3m1+1f2mN/OkZxgl+cWX0ehw==
X-Received: by 2002:a17:906:3599:: with SMTP id o25mr2350352ejb.136.1613249046030;
        Sat, 13 Feb 2021 12:44:06 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p6sm2363937ejw.79.2021.02.13.12.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:44:05 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net-next 4/5] net: dsa: propagate extack to .port_vlan_add
Date:   Sat, 13 Feb 2021 22:43:18 +0200
Message-Id: <20210213204319.1226170-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213204319.1226170-1-olteanv@gmail.com>
References: <20210213204319.1226170-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Allow drivers to communicate their restrictions to user space directly,
instead of printing to the kernel log. Where the conversion would have
been lossy and things like VLAN ID could no longer be conveyed (due to
the lack of support for printf format specifier in netlink extack), I
chose to keep the messages in full form to the kernel log only, and
leave it up to individual driver maintainers to move more messages to
extack.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       |  3 ++-
 drivers/net/dsa/b53/b53_priv.h         |  3 ++-
 drivers/net/dsa/bcm_sf2_cfp.c          |  2 +-
 drivers/net/dsa/dsa_loop.c             |  3 ++-
 drivers/net/dsa/hirschmann/hellcreek.c | 12 ++++++++----
 drivers/net/dsa/lantiq_gswip.c         | 12 ++++++++----
 drivers/net/dsa/microchip/ksz8795.c    |  3 ++-
 drivers/net/dsa/microchip/ksz9477.c    |  7 ++++---
 drivers/net/dsa/mt7530.c               |  3 ++-
 drivers/net/dsa/mv88e6xxx/chip.c       |  3 ++-
 drivers/net/dsa/ocelot/felix.c         |  3 ++-
 drivers/net/dsa/qca8k.c                |  3 ++-
 drivers/net/dsa/realtek-smi-core.h     |  3 ++-
 drivers/net/dsa/rtl8366.c              | 11 ++++++++---
 drivers/net/dsa/sja1105/sja1105_main.c |  6 ++++--
 include/net/dsa.h                      |  3 ++-
 net/dsa/dsa_priv.h                     |  4 +++-
 net/dsa/port.c                         |  4 +++-
 net/dsa/slave.c                        | 25 ++++++++++++++++++-------
 net/dsa/switch.c                       |  3 ++-
 20 files changed, 79 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 72c75c7bdb65..98cc051e513e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1444,7 +1444,8 @@ static int b53_vlan_prepare(struct dsa_switch *ds, int port,
 }
 
 int b53_vlan_add(struct dsa_switch *ds, int port,
-		 const struct switchdev_obj_port_vlan *vlan)
+		 const struct switchdev_obj_port_vlan *vlan,
+		 struct netlink_ext_ack *extack)
 {
 	struct b53_device *dev = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index ae72ef46b0b6..fc5d6fddb3fe 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -348,7 +348,8 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			     bool tx_pause, bool rx_pause);
 int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering);
 int b53_vlan_add(struct dsa_switch *ds, int port,
-		 const struct switchdev_obj_port_vlan *vlan);
+		 const struct switchdev_obj_port_vlan *vlan,
+		 struct netlink_ext_ack *extack);
 int b53_vlan_del(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan);
 int b53_fdb_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index 178218cf73a3..a7e2fcf2df2c 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -891,7 +891,7 @@ static int bcm_sf2_cfp_rule_insert(struct dsa_switch *ds, int port,
 		else
 			vlan.flags = 0;
 
-		ret = ds->ops->port_vlan_add(ds, port_num, &vlan);
+		ret = ds->ops->port_vlan_add(ds, port_num, &vlan, NULL);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 8c283f59158b..e55b63a7e907 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -199,7 +199,8 @@ static int dsa_loop_port_vlan_filtering(struct dsa_switch *ds, int port,
 }
 
 static int dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
-				  const struct switchdev_obj_port_vlan *vlan)
+				  const struct switchdev_obj_port_vlan *vlan,
+				  struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index f984ca75a71f..5816ef922e55 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -341,7 +341,8 @@ static u16 hellcreek_private_vid(int port)
 }
 
 static int hellcreek_vlan_prepare(struct dsa_switch *ds, int port,
-				  const struct switchdev_obj_port_vlan *vlan)
+				  const struct switchdev_obj_port_vlan *vlan,
+				  struct netlink_ext_ack *extack)
 {
 	struct hellcreek *hellcreek = ds->priv;
 	int i;
@@ -358,8 +359,10 @@ static int hellcreek_vlan_prepare(struct dsa_switch *ds, int port,
 		if (!dsa_is_user_port(ds, i))
 			continue;
 
-		if (vlan->vid == restricted_vid)
+		if (vlan->vid == restricted_vid) {
+			NL_SET_ERR_MSG_MOD(extack, "VID restricted by driver");
 			return -EBUSY;
+		}
 	}
 
 	return 0;
@@ -445,14 +448,15 @@ static void hellcreek_unapply_vlan(struct hellcreek *hellcreek, int port,
 }
 
 static int hellcreek_vlan_add(struct dsa_switch *ds, int port,
-			      const struct switchdev_obj_port_vlan *vlan)
+			      const struct switchdev_obj_port_vlan *vlan,
+			      struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct hellcreek *hellcreek = ds->priv;
 	int err;
 
-	err = hellcreek_vlan_prepare(ds, port, vlan);
+	err = hellcreek_vlan_prepare(ds, port, vlan, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 9fec97773a15..174ca3a484a0 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1128,7 +1128,8 @@ static void gswip_port_bridge_leave(struct dsa_switch *ds, int port,
 }
 
 static int gswip_port_vlan_prepare(struct dsa_switch *ds, int port,
-				   const struct switchdev_obj_port_vlan *vlan)
+				   const struct switchdev_obj_port_vlan *vlan,
+				   struct netlink_ext_ack *extack)
 {
 	struct gswip_priv *priv = ds->priv;
 	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
@@ -1163,15 +1164,18 @@ static int gswip_port_vlan_prepare(struct dsa_switch *ds, int port,
 			}
 		}
 
-		if (idx == -1)
+		if (idx == -1) {
+			NL_SET_ERR_MSG_MOD(extack, "No slot in VLAN table");
 			return -ENOSPC;
+		}
 	}
 
 	return 0;
 }
 
 static int gswip_port_vlan_add(struct dsa_switch *ds, int port,
-			       const struct switchdev_obj_port_vlan *vlan)
+			       const struct switchdev_obj_port_vlan *vlan,
+			       struct netlink_ext_ack *extack)
 {
 	struct gswip_priv *priv = ds->priv;
 	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
@@ -1179,7 +1183,7 @@ static int gswip_port_vlan_add(struct dsa_switch *ds, int port,
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	int err;
 
-	err = gswip_port_vlan_prepare(ds, port, vlan);
+	err = gswip_port_vlan_prepare(ds, port, vlan, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index c87d445b30fd..1e27a3e58141 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -793,7 +793,8 @@ static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
 }
 
 static int ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_vlan *vlan)
+				 const struct switchdev_obj_port_vlan *vlan,
+				 struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 00e38c8e0d01..772e34d5b6b8 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -511,7 +511,8 @@ static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_vlan *vlan)
+				 const struct switchdev_obj_port_vlan *vlan,
+				 struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 vlan_table[3];
@@ -520,7 +521,7 @@ static int ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
 
 	err = ksz9477_get_vlan_table(dev, vlan->vid, vlan_table);
 	if (err) {
-		dev_dbg(dev->dev, "Failed to get vlan table\n");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to get vlan table");
 		return err;
 	}
 
@@ -535,7 +536,7 @@ static int ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
 
 	err = ksz9477_set_vlan_table(dev, vlan->vid, vlan_table);
 	if (err) {
-		dev_dbg(dev->dev, "Failed to set vlan table\n");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to set vlan table");
 		return err;
 	}
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index eb13ba79dd01..c089cd48e65d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1483,7 +1483,8 @@ mt7530_hw_vlan_update(struct mt7530_priv *priv, u16 vid,
 
 static int
 mt7530_port_vlan_add(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_vlan *vlan)
+		     const struct switchdev_obj_port_vlan *vlan,
+		     struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0ef1fadfec68..d46f0c096c97 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1982,7 +1982,8 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
 }
 
 static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
-				   const struct switchdev_obj_port_vlan *vlan)
+				   const struct switchdev_obj_port_vlan *vlan,
+				   struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d3180b0f2307..4db54d91eae2 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -651,7 +651,8 @@ static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 }
 
 static int felix_vlan_add(struct dsa_switch *ds, int port,
-			  const struct switchdev_obj_port_vlan *vlan)
+			  const struct switchdev_obj_port_vlan *vlan,
+			  struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = ds->priv;
 	u16 flags = vlan->flags;
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 6127823d6c2e..73978e7e85cd 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1313,7 +1313,8 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 
 static int
 qca8k_port_vlan_add(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_vlan *vlan)
+		    const struct switchdev_obj_port_vlan *vlan,
+		    struct netlink_ext_ack *extack)
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index 26376b052594..93a3e05a6f71 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -133,7 +133,8 @@ int rtl8366_init_vlan(struct realtek_smi *smi);
 int rtl8366_vlan_filtering(struct dsa_switch *ds, int port,
 			   bool vlan_filtering);
 int rtl8366_vlan_add(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_vlan *vlan);
+		     const struct switchdev_obj_port_vlan *vlan,
+		     struct netlink_ext_ack *extack);
 int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan);
 void rtl8366_get_strings(struct dsa_switch *ds, int port, u32 stringset,
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 3b24f2e13200..76303a77aa82 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -375,7 +375,8 @@ int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 EXPORT_SYMBOL_GPL(rtl8366_vlan_filtering);
 
 int rtl8366_vlan_add(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_vlan *vlan)
+		     const struct switchdev_obj_port_vlan *vlan,
+		     struct netlink_ext_ack *extack)
 {
 	bool untagged = !!(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
 	bool pvid = !!(vlan->flags & BRIDGE_VLAN_INFO_PVID);
@@ -384,16 +385,20 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	u32 untag = 0;
 	int ret;
 
-	if (!smi->ops->is_vlan_valid(smi, vlan->vid))
+	if (!smi->ops->is_vlan_valid(smi, vlan->vid)) {
+		NL_SET_ERR_MSG_MOD(extack, "VLAN ID not valid");
 		return -EINVAL;
+	}
 
 	/* Enable VLAN in the hardware
 	 * FIXME: what's with this 4k business?
 	 * Just rtl8366_enable_vlan() seems inconclusive.
 	 */
 	ret = rtl8366_enable_vlan4k(smi, true);
-	if (ret)
+	if (ret) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to enable VLAN 4K");
 		return ret;
+	}
 
 	dev_info(smi->dev, "add VLAN %d on port %d, %s, %s\n",
 		 vlan->vid, port, untagged ? "untagged" : "tagged",
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 260073e830c7..6aea8034c32b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2795,7 +2795,8 @@ static int sja1105_vlan_del_one(struct dsa_switch *ds, int port, u16 vid,
 }
 
 static int sja1105_vlan_add(struct dsa_switch *ds, int port,
-			    const struct switchdev_obj_port_vlan *vlan)
+			    const struct switchdev_obj_port_vlan *vlan,
+			    struct netlink_ext_ack *extack)
 {
 	struct sja1105_private *priv = ds->priv;
 	bool vlan_table_changed = false;
@@ -2807,7 +2808,8 @@ static int sja1105_vlan_add(struct dsa_switch *ds, int port,
 	 */
 	if (priv->vlan_state != SJA1105_VLAN_FILTERING_FULL &&
 	    vid_is_dsa_8021q(vlan->vid)) {
-		dev_err(ds->dev, "Range 1024-3071 reserved for dsa_8021q operation\n");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Range 1024-3071 reserved for dsa_8021q operation");
 		return -EBUSY;
 	}
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 74457aaffec7..94dfe96df39a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -641,7 +641,8 @@ struct dsa_switch_ops {
 	int	(*port_vlan_filtering)(struct dsa_switch *ds, int port,
 				       bool vlan_filtering);
 	int	(*port_vlan_add)(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_vlan *vlan);
+				 const struct switchdev_obj_port_vlan *vlan,
+				 struct netlink_ext_ack *extack);
 	int	(*port_vlan_del)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan);
 	/*
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f5949b39f6f7..17a9f82db937 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -75,6 +75,7 @@ struct dsa_notifier_vlan_info {
 	const struct switchdev_obj_port_vlan *vlan;
 	int sw_index;
 	int port;
+	struct netlink_ext_ack *extack;
 };
 
 /* DSA_NOTIFIER_MTU */
@@ -192,7 +193,8 @@ int dsa_port_bridge_flags(const struct dsa_port *dp,
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
 		     struct netlink_ext_ack *extack);
 int dsa_port_vlan_add(struct dsa_port *dp,
-		      const struct switchdev_obj_port_vlan *vlan);
+		      const struct switchdev_obj_port_vlan *vlan,
+		      struct netlink_ext_ack *extack);
 int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_link_register_of(struct dsa_port *dp);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 80e6471a7a5c..03ecefe1064a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -535,12 +535,14 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 }
 
 int dsa_port_vlan_add(struct dsa_port *dp,
-		      const struct switchdev_obj_port_vlan *vlan)
+		      const struct switchdev_obj_port_vlan *vlan,
+		      struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_vlan_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.vlan = vlan,
+		.extack = extack,
 	};
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8c9a41a7209a..9ec487b63e13 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -357,11 +357,14 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 		rcu_read_lock();
 		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
 		rcu_read_unlock();
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Port already has a VLAN upper with this VID");
 			return err;
+		}
 	}
 
-	err = dsa_port_vlan_add(dp, &vlan);
+	err = dsa_port_vlan_add(dp, &vlan, extack);
 	if (err)
 		return err;
 
@@ -371,7 +374,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	 */
 	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
 
-	err = dsa_port_vlan_add(dp->cpu_dp, &vlan);
+	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, extack);
 	if (err)
 		return err;
 
@@ -1287,17 +1290,25 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
+	struct netlink_ext_ack extack = {0};
 	int ret;
 
 	/* User port... */
-	ret = dsa_port_vlan_add(dp, &vlan);
-	if (ret)
+	ret = dsa_port_vlan_add(dp, &vlan, &extack);
+	if (ret) {
+		if (extack._msg)
+			netdev_err(dev, "%s\n", extack._msg);
 		return ret;
+	}
 
 	/* And CPU port... */
-	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan);
-	if (ret)
+	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &extack);
+	if (ret) {
+		if (extack._msg)
+			netdev_err(dev, "CPU port %d: %s\n", dp->cpu_dp->index,
+				   extack._msg);
 		return ret;
+	}
 
 	return vlan_vid_add(master, proto, vid);
 }
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 1906179e59f7..c82d201181a5 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -291,7 +291,8 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_switch_vlan_match(ds, port, info)) {
-			err = ds->ops->port_vlan_add(ds, port, info->vlan);
+			err = ds->ops->port_vlan_add(ds, port, info->vlan,
+						     info->extack);
 			if (err)
 				return err;
 		}
-- 
2.25.1

