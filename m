Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC54D9178
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343844AbiCOA2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343808AbiCOA1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:37 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25F23D1C8
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:26 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id n19so30134635lfh.8
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=zwPtSQCtLYzioD5eRFwE9S8XxeAezByZk3hCyAYzD/c=;
        b=Ph+0sJJpMmVb8h+U+8wMjrjwk1N/jUJxYctER6bsJSBuLH/AjMugyfVSOqfEEAeO4D
         1YvsI1z29Meti5jpzWbAqR+UoI8bE3W8a3pRyZFDZ4EYxp61HLryUidHPmAYusT72q49
         3O2ND5BXOGsIAc+UipIwYmzjGlaUPaAur6kHrUrjRmSwfmJhl2P7f9B0FxcSh3oh2fqS
         uttk6st9gMLfl0Pn2qJp+NyEBCCyQTCUaf8qPdJXoGBnHv/eL2CiM2kopBxoXvtj4TuG
         YG9vKvPfg04TtLcTKJV/qeIbi33Z+3kzopXwFqKLWVPhJJqyishUQpzDya1qxtwPrRKE
         X8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=zwPtSQCtLYzioD5eRFwE9S8XxeAezByZk3hCyAYzD/c=;
        b=xXDnUhEvtwdUNdj3tMfMcHlmfDBoA6YSl1/pA8wInKWNacIrszpPjv36PSqbLuzvrQ
         S9ised/Vz65FZERCglWAEtev15JfwpNAL+eZTKLw5DhWizO5Sdt/HnWGNAFtL4RbzuqH
         y0DMPceknVfnPU/9uKbNBhTxHuqrUYjFCbh/FBKJZeqCehrUnWZK/5Vrfx6+h3ZDJpMA
         RDbHWwse9JbUlIKFiaJGzRXhz+f3UWV/R3zg8aJFmvlp2KHY7KgGdIX+/Ewmls1ByceN
         sJ/E8MZOcUkTes0aSxQP9iVsoKlnV7igtNNkf0qmu8PWPRrkS8DpUQ0diluKcuD0bBvr
         7P1A==
X-Gm-Message-State: AOAM531/vnHbAhRPOwPvlGbBbptKjxyV/Mm64Leg/Ap+647L+hc6BMwc
        begt3LZnoo0EEflslEbKsHhpdw==
X-Google-Smtp-Source: ABdhPJzd4lRx9aeBNfCkCh97K1MXxNyxD8wDh/trNY4NXsicr1TZTuBjwmPf7yrzPlo79R2aNVG6ug==
X-Received: by 2002:a05:6512:2622:b0:448:27b9:5299 with SMTP id bt34-20020a056512262200b0044827b95299mr14109892lfb.86.1647303985191;
        Mon, 14 Mar 2022 17:26:25 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:24 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH v4 net-next 05/15] net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrations
Date:   Tue, 15 Mar 2022 01:25:33 +0100
Message-Id: <20220315002543.190587-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220315002543.190587-1-tobias@waldekranz.com>
References: <20220315002543.190587-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever a VLAN moves to a new MSTI, send a switchdev notification so
that switchdevs can track a bridge's VID to MSTI mappings.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/switchdev.h   |  7 ++++++
 net/bridge/br_mst.c       | 14 ++++++++++++
 net/bridge/br_switchdev.c | 46 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 85dd004dc9ad..53dfa0f7cf5b 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -29,6 +29,7 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
 	SWITCHDEV_ATTR_ID_BRIDGE_MST,
 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
+	SWITCHDEV_ATTR_ID_VLAN_MSTI,
 };
 
 struct switchdev_brport_flags {
@@ -36,6 +37,11 @@ struct switchdev_brport_flags {
 	unsigned long mask;
 };
 
+struct switchdev_vlan_msti {
+	u16 vid;
+	u16 msti;
+};
+
 struct switchdev_attr {
 	struct net_device *orig_dev;
 	enum switchdev_attr_id id;
@@ -52,6 +58,7 @@ struct switchdev_attr {
 		bool mst;				/* BRIDGE_MST */
 		bool mc_disabled;			/* MC_DISABLED */
 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
+		struct switchdev_vlan_msti vlan_msti;	/* VLAN_MSTI */
 	} u;
 };
 
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 051b9358946b..5d3e034b9030 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/kernel.h>
+#include <net/switchdev.h>
 
 #include "br_private.h"
 
@@ -65,13 +66,26 @@ static void br_mst_vlan_sync_state(struct net_bridge_vlan *pv, u16 msti)
 
 int br_mst_vlan_set_msti(struct net_bridge_vlan *mv, u16 msti)
 {
+	struct switchdev_attr attr = {
+		.id = SWITCHDEV_ATTR_ID_VLAN_MSTI,
+		.orig_dev = mv->br->dev,
+		.u.vlan_msti = {
+			.vid = mv->vid,
+			.msti = msti,
+		},
+	};
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *pv;
 	struct net_bridge_port *p;
+	int err;
 
 	if (mv->msti == msti)
 		return 0;
 
+	err = switchdev_port_attr_set(mv->br->dev, &attr, NULL);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	mv->msti = msti;
 
 	list_for_each_entry(p, &mv->br->port_list, list) {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6f6a70121a5e..8cc44c367231 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -331,6 +331,46 @@ br_switchdev_fdb_replay(const struct net_device *br_dev, const void *ctx,
 	return err;
 }
 
+static int br_switchdev_vlan_attr_replay(struct net_device *br_dev,
+					 const void *ctx,
+					 struct notifier_block *nb,
+					 struct netlink_ext_ack *extack)
+{
+	struct switchdev_notifier_port_attr_info attr_info = {
+		.info = {
+			.dev = br_dev,
+			.extack = extack,
+			.ctx = ctx,
+		},
+	};
+	struct net_bridge *br = netdev_priv(br_dev);
+	struct net_bridge_vlan_group *vg;
+	struct switchdev_attr attr;
+	struct net_bridge_vlan *v;
+	int err;
+
+	attr_info.attr = &attr;
+	attr.orig_dev = br_dev;
+
+	vg = br_vlan_group(br);
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		if (v->msti) {
+			attr.id = SWITCHDEV_ATTR_ID_VLAN_MSTI;
+			attr.u.vlan_msti.vid = v->vid;
+			attr.u.vlan_msti.msti = v->msti;
+
+			err = nb->notifier_call(nb, SWITCHDEV_PORT_ATTR_SET,
+						&attr_info);
+			err = notifier_to_errno(err);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
 static int
 br_switchdev_vlan_replay_one(struct notifier_block *nb,
 			     struct net_device *dev,
@@ -425,6 +465,12 @@ static int br_switchdev_vlan_replay(struct net_device *br_dev,
 			return err;
 	}
 
+	if (adding) {
+		err = br_switchdev_vlan_attr_replay(br_dev, ctx, nb, extack);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
2.25.1

