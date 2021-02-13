Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1057431AE04
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhBMUpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhBMUoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:44:46 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D12CC061788
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:06 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id y26so5104481eju.13
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5otiRITfUSDFhL8v2p9+r/9akVLxGn6AUnyIgMzEmv8=;
        b=hv2HeENMeaYG+kUIgFt1NLFFKVMcPOb7vxoBAM4yZy1scne/JQRpoQLTJOLHzaNFEI
         LV+lfBYJQA18OoC0sooX6+9OYTU2uqqdyEcSODz09qSy8LtcMDQbW14zRr4tKN8Jyp5w
         wOIrlXCT2ZPN3FgTPQWm22ZRFhlkRJTlTxjhBmx+8lZIF94tn5QH3u39ZCMVgFDEBGOs
         EZ0NyQrcKFmVqhyWgx4TQkrhXNfd90pVt8tyglxz+pIMbqj+6qB1CMpQUjl3X5cF8rju
         MY6ahptgXfWvCjoRc8kigcsDO4k6KYbCSebQA6K2/V4tA6RTWe9xQCFjMPHp+5p60xaK
         bvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5otiRITfUSDFhL8v2p9+r/9akVLxGn6AUnyIgMzEmv8=;
        b=covv9hdl6DI82fkIzbiHbJ7fOXyG5uv8+r++WymjadaUzJS78DbrY8ykUyef+XzGX1
         p3XCHprn7jkJRw5rNVA3o3Qy5Onveg09oni9nAv6kjg2YE8sFFCh1bAQHdd83cnljwL3
         Gdgx0w1gihQN9sIGADYv31eUVfvIOmiR7FKd6ws3USUs71GmFPHQNmi5SQ/Xl9vsalBB
         mWwQobNmgmRPjN/4Zb6L9FNL2RhC2cviyXmtEGOms9XriJzYmGVdp2sWgrb0XgV2sCjk
         cVu8APb+5+uWDHawY5sGv2t4GtTU5/UfCC0+6gZ3LK3DkzCZ21sF3F/Y6FGi2ipzOcUz
         NxSg==
X-Gm-Message-State: AOAM533SLARWIv0ZfTIxadcEm8GbWcZ8DS2a9VPjUZwW8mtatnypVZIV
        obefGbpHslBsKaUOMKhNUyA=
X-Google-Smtp-Source: ABdhPJz32Lbufgf6Ktfxu+QeQ7pXgsuI0+5VAdVBfDyy9G29J5QAZtmNHHQ2EQPBxmk1o1/1CgVW5A==
X-Received: by 2002:a17:906:d0cd:: with SMTP id bq13mr8697351ejb.75.1613249044693;
        Sat, 13 Feb 2021 12:44:04 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p6sm2363937ejw.79.2021.02.13.12.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:44:04 -0800 (PST)
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
Subject: [PATCH net-next 3/5] net: bridge: propagate extack through switchdev_port_attr_set
Date:   Sat, 13 Feb 2021 22:43:17 +0200
Message-Id: <20210213204319.1226170-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213204319.1226170-1-olteanv@gmail.com>
References: <20210213204319.1226170-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The benefit is the ability to propagate errors from switchdev drivers
for the SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING and
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL attributes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h       |  3 ++-
 net/bridge/br_mrp_switchdev.c |  4 ++--
 net/bridge/br_multicast.c     |  6 +++---
 net/bridge/br_netlink.c       |  2 +-
 net/bridge/br_private.h       |  3 ++-
 net/bridge/br_stp.c           |  4 ++--
 net/bridge/br_switchdev.c     |  6 ++++--
 net/bridge/br_vlan.c          | 13 +++++++------
 net/switchdev/switchdev.c     | 19 ++++++++++++-------
 9 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 25d9e4570934..195f62672cc4 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -247,7 +247,8 @@ switchdev_notifier_info_to_extack(const struct switchdev_notifier_info *info)
 
 void switchdev_deferred_process(void);
 int switchdev_port_attr_set(struct net_device *dev,
-			    const struct switchdev_attr *attr);
+			    const struct switchdev_attr *attr,
+			    struct netlink_ext_ack *extack);
 int switchdev_port_obj_add(struct net_device *dev,
 			   const struct switchdev_obj *obj,
 			   struct netlink_ext_ack *extack);
diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
index 75a7e8d0a268..3c9a4abcf4ee 100644
--- a/net/bridge/br_mrp_switchdev.c
+++ b/net/bridge/br_mrp_switchdev.c
@@ -178,7 +178,7 @@ int br_mrp_port_switchdev_set_state(struct net_bridge_port *p, u32 state)
 	};
 	int err;
 
-	err = switchdev_port_attr_set(p->dev, &attr);
+	err = switchdev_port_attr_set(p->dev, &attr, NULL);
 	if (err && err != -EOPNOTSUPP)
 		br_warn(p->br, "error setting offload MRP state on port %u(%s)\n",
 			(unsigned int)p->port_no, p->dev->name);
@@ -196,7 +196,7 @@ int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
 	};
 	int err;
 
-	err = switchdev_port_attr_set(p->dev, &attr);
+	err = switchdev_port_attr_set(p->dev, &attr, NULL);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index bf10ef5bbcd9..9d265447d654 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1381,7 +1381,7 @@ static void br_mc_router_state_change(struct net_bridge *p,
 		.u.mrouter = is_mc_router,
 	};
 
-	switchdev_port_attr_set(p->dev, &attr);
+	switchdev_port_attr_set(p->dev, &attr, NULL);
 }
 
 static void br_multicast_local_router_expired(struct timer_list *t)
@@ -1602,7 +1602,7 @@ static void br_mc_disabled_update(struct net_device *dev, bool value)
 		.u.mc_disabled = !value,
 	};
 
-	switchdev_port_attr_set(dev, &attr);
+	switchdev_port_attr_set(dev, &attr, NULL);
 }
 
 int br_multicast_add_port(struct net_bridge_port *port)
@@ -2645,7 +2645,7 @@ static void br_port_mc_router_state_change(struct net_bridge_port *p,
 		.u.mrouter = is_mc_router,
 	};
 
-	switchdev_port_attr_set(p->dev, &attr);
+	switchdev_port_attr_set(p->dev, &attr, NULL);
 }
 
 /*
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 3f5dc6fcc980..f2b1343f8332 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1221,7 +1221,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_VLAN_PROTOCOL]) {
 		__be16 vlan_proto = nla_get_be16(data[IFLA_BR_VLAN_PROTOCOL]);
 
-		err = __br_vlan_set_proto(br, vlan_proto);
+		err = __br_vlan_set_proto(br, vlan_proto, extack);
 		if (err)
 			return err;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a8d483325476..da71e71fcddc 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1087,7 +1087,8 @@ struct net_bridge_vlan *br_vlan_find(struct net_bridge_vlan_group *vg, u16 vid);
 void br_recalculate_fwd_mask(struct net_bridge *br);
 int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val,
 			  struct netlink_ext_ack *extack);
-int __br_vlan_set_proto(struct net_bridge *br, __be16 proto);
+int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
+			struct netlink_ext_ack *extack);
 int br_vlan_set_proto(struct net_bridge *br, unsigned long val,
 		      struct netlink_ext_ack *extack);
 int br_vlan_set_stats(struct net_bridge *br, unsigned long val);
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index a3a5745660dd..21c6781906aa 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -43,7 +43,7 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 		return;
 
 	p->state = state;
-	err = switchdev_port_attr_set(p->dev, &attr);
+	err = switchdev_port_attr_set(p->dev, &attr, NULL);
 	if (err && err != -EOPNOTSUPP)
 		br_warn(p->br, "error setting offload STP state on port %u(%s)\n",
 				(unsigned int) p->port_no, p->dev->name);
@@ -591,7 +591,7 @@ int __set_ageing_time(struct net_device *dev, unsigned long t)
 	};
 	int err;
 
-	err = switchdev_port_attr_set(dev, &attr);
+	err = switchdev_port_attr_set(dev, &attr, NULL);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 184cf4c8b06d..b89503832fcc 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -96,9 +96,11 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	attr.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS;
 	attr.flags = SWITCHDEV_F_DEFER;
 
-	err = switchdev_port_attr_set(p->dev, &attr);
+	err = switchdev_port_attr_set(p->dev, &attr, extack);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "error setting offload flag on port");
+		if (extack && !extack->_msg)
+			NL_SET_ERR_MSG_MOD(extack,
+					   "error setting offload flag on port");
 		return err;
 	}
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index c4a51095850a..8829f621b8ec 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -820,7 +820,7 @@ int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val,
 	if (br_opt_get(br, BROPT_VLAN_ENABLED) == !!val)
 		return 0;
 
-	err = switchdev_port_attr_set(br->dev, &attr);
+	err = switchdev_port_attr_set(br->dev, &attr, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -850,7 +850,8 @@ int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto)
 }
 EXPORT_SYMBOL_GPL(br_vlan_get_proto);
 
-int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
+int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
+			struct netlink_ext_ack *extack)
 {
 	struct switchdev_attr attr = {
 		.orig_dev = br->dev,
@@ -867,7 +868,7 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 	if (br->vlan_proto == proto)
 		return 0;
 
-	err = switchdev_port_attr_set(br->dev, &attr);
+	err = switchdev_port_attr_set(br->dev, &attr, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -897,7 +898,7 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 
 err_filt:
 	attr.u.vlan_protocol = ntohs(oldproto);
-	switchdev_port_attr_set(br->dev, &attr);
+	switchdev_port_attr_set(br->dev, &attr, NULL);
 
 	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
 		vlan_vid_del(p->dev, proto, vlan->vid);
@@ -917,7 +918,7 @@ int br_vlan_set_proto(struct net_bridge *br, unsigned long val,
 	if (!eth_type_vlan(htons(val)))
 		return -EPROTONOSUPPORT;
 
-	return __br_vlan_set_proto(br, htons(val));
+	return __br_vlan_set_proto(br, htons(val), extack);
 }
 
 int br_vlan_set_stats(struct net_bridge *br, unsigned long val)
@@ -1165,7 +1166,7 @@ int nbp_vlan_init(struct net_bridge_port *p, struct netlink_ext_ack *extack)
 	if (!vg)
 		goto out;
 
-	ret = switchdev_port_attr_set(p->dev, &attr);
+	ret = switchdev_port_attr_set(p->dev, &attr, extack);
 	if (ret && ret != -EOPNOTSUPP)
 		goto err_vlan_enabled;
 
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 0b84f076591e..89a36db47ab4 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -100,7 +100,8 @@ static int switchdev_deferred_enqueue(struct net_device *dev,
 
 static int switchdev_port_attr_notify(enum switchdev_notifier_type nt,
 				      struct net_device *dev,
-				      const struct switchdev_attr *attr)
+				      const struct switchdev_attr *attr,
+				      struct netlink_ext_ack *extack)
 {
 	int err;
 	int rc;
@@ -111,7 +112,7 @@ static int switchdev_port_attr_notify(enum switchdev_notifier_type nt,
 	};
 
 	rc = call_switchdev_blocking_notifiers(nt, dev,
-					       &attr_info.info, NULL);
+					       &attr_info.info, extack);
 	err = notifier_to_errno(rc);
 	if (err) {
 		WARN_ON(!attr_info.handled);
@@ -125,9 +126,11 @@ static int switchdev_port_attr_notify(enum switchdev_notifier_type nt,
 }
 
 static int switchdev_port_attr_set_now(struct net_device *dev,
-				       const struct switchdev_attr *attr)
+				       const struct switchdev_attr *attr,
+				       struct netlink_ext_ack *extack)
 {
-	return switchdev_port_attr_notify(SWITCHDEV_PORT_ATTR_SET, dev, attr);
+	return switchdev_port_attr_notify(SWITCHDEV_PORT_ATTR_SET, dev, attr,
+					  extack);
 }
 
 static void switchdev_port_attr_set_deferred(struct net_device *dev,
@@ -136,7 +139,7 @@ static void switchdev_port_attr_set_deferred(struct net_device *dev,
 	const struct switchdev_attr *attr = data;
 	int err;
 
-	err = switchdev_port_attr_set_now(dev, attr);
+	err = switchdev_port_attr_set_now(dev, attr, NULL);
 	if (err && err != -EOPNOTSUPP)
 		netdev_err(dev, "failed (err=%d) to set attribute (id=%d)\n",
 			   err, attr->id);
@@ -156,17 +159,19 @@ static int switchdev_port_attr_set_defer(struct net_device *dev,
  *
  *	@dev: port device
  *	@attr: attribute to set
+ *	@extack: netlink extended ack, for error message propagation
  *
  *	rtnl_lock must be held and must not be in atomic section,
  *	in case SWITCHDEV_F_DEFER flag is not set.
  */
 int switchdev_port_attr_set(struct net_device *dev,
-			    const struct switchdev_attr *attr)
+			    const struct switchdev_attr *attr,
+			    struct netlink_ext_ack *extack)
 {
 	if (attr->flags & SWITCHDEV_F_DEFER)
 		return switchdev_port_attr_set_defer(dev, attr);
 	ASSERT_RTNL();
-	return switchdev_port_attr_set_now(dev, attr);
+	return switchdev_port_attr_set_now(dev, attr, extack);
 }
 EXPORT_SYMBOL_GPL(switchdev_port_attr_set);
 
-- 
2.25.1

