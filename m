Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAD516A6F6
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgBXNJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:09:23 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34762 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbgBXNJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:09:22 -0500
Received: by mail-wm1-f65.google.com with SMTP id s144so10655657wme.1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gThMWOLdRD0jVo4EuHWI6K0yxQhqvMwqHmK06xkGnYw=;
        b=HvwjPTz0gWvRVG3QbQ4RCPh4cUlaFAR23N9kx3en6rn0wwBKddMLYoEh7TyJdtx0GN
         f6RkUge5fnSrgivwa5sJr+BmFGcrCAUraUCPyANlq8ogRjjDkezx4YySLGlsjhwLVNwF
         pjwltl4NlE8zQisJ/CO8TGYsQzISxMIIVvGnoxY86zJXx7lWC7rHGpLw/bLgj8+ieJ73
         KtB+ZSVmM2G4vcMKK2OOnS9okM8z2uTvThXpqnciMMoNw/GkYSfNkRqnFsBelUFUKyi4
         mRwJDZpz5MI+0t/mBnB6v5dlbOtWekgFXt36l8HpsqS7AkQEFA3Xsg6QMOSx4+vgctAQ
         y22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gThMWOLdRD0jVo4EuHWI6K0yxQhqvMwqHmK06xkGnYw=;
        b=G7IZKS4+9QQO52QfT7lrlqaaGcpCnRP81zpX2q/d97xzmKlyjDyGaFsCSux9wuJKPO
         xvR2/j1sX4uTQI8qkDnpov9ICfRkA/SGQv9gObBVcxxxp0G+NRxKEquOSjAXTEilzmKv
         0GylXI/8mpbkF30ryNWRTimcgnTpEJlUWMyetsG4RbaJ7klIdI6s8DxwK8+jgzjY2sXm
         2PsARR0YRTr5DQ1mFeFYsVcdFyvn52c2hP6qkmYax1d30+Xpnmq+l0AoMxe+cCRs5e5U
         Wv5Gvmf6sWZVCCoVXI6Vnhye3sa5L4/oWqFn3APdJRTpBvxE4vw4yNCYIZRUSQdM7Loa
         uI7g==
X-Gm-Message-State: APjAAAXOA0nKxtDLPbF3G99AVayoqb6Onvr/hL+slb/eAfg9sstgKaZX
        LSZ2Eng21rlibiF8tR1Sjas=
X-Google-Smtp-Source: APXvYqwUoD0QPvVekLf/tKqsgbiNJ/DmANbeS6PT7bErQQaJ5vOblzl6qu4NMwMVqx9qPooYyuy5ow==
X-Received: by 2002:a1c:a9c7:: with SMTP id s190mr21345335wme.97.1582549759975;
        Mon, 24 Feb 2020 05:09:19 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id i204sm18089298wma.44.2020.02.24.05.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:09:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH net-next 03/10] net: mscc: ocelot: replace "rule" and "ocelot_rule" variable names with "ace"
Date:   Mon, 24 Feb 2020 15:08:24 +0200
Message-Id: <20200224130831.25347-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224130831.25347-1-olteanv@gmail.com>
References: <20200224130831.25347-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The "ocelot_rule" variable name is both annoyingly long trying to
distinguish itself from struct flow_rule *rule =
flow_cls_offload_flow_rule(f), as well as actually different from the
"ace" variable name which is used all over the place in ocelot_ace.c and
is referring to the same structure.

And the "rule" variable name is, confusingly, different from f->rule,
but sometimes one has to look up to the beginning of the function to get
an understanding of what structure type is actually being handled.

So let's use the "ace" name wherever possible ("Access Control Entry").

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 102 +++++++++++-----------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index b9673df6dbc5..698e9fee6b1a 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -9,7 +9,7 @@
 #include "ocelot_ace.h"
 
 static int ocelot_flower_parse_action(struct flow_cls_offload *f,
-				      struct ocelot_ace_rule *rule)
+				      struct ocelot_ace_rule *ace)
 {
 	const struct flow_action_entry *a;
 	int i;
@@ -20,10 +20,10 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	flow_action_for_each(i, a, &f->rule->action) {
 		switch (a->id) {
 		case FLOW_ACTION_DROP:
-			rule->action = OCELOT_ACL_ACTION_DROP;
+			ace->action = OCELOT_ACL_ACTION_DROP;
 			break;
 		case FLOW_ACTION_TRAP:
-			rule->action = OCELOT_ACL_ACTION_TRAP;
+			ace->action = OCELOT_ACL_ACTION_TRAP;
 			break;
 		default:
 			return -EOPNOTSUPP;
@@ -34,7 +34,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 }
 
 static int ocelot_flower_parse(struct flow_cls_offload *f,
-			       struct ocelot_ace_rule *ocelot_rule)
+			       struct ocelot_ace_rule *ace)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
@@ -79,14 +79,14 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 			return -EOPNOTSUPP;
 
 		flow_rule_match_eth_addrs(rule, &match);
-		ocelot_rule->type = OCELOT_ACE_TYPE_ETYPE;
-		ether_addr_copy(ocelot_rule->frame.etype.dmac.value,
+		ace->type = OCELOT_ACE_TYPE_ETYPE;
+		ether_addr_copy(ace->frame.etype.dmac.value,
 				match.key->dst);
-		ether_addr_copy(ocelot_rule->frame.etype.smac.value,
+		ether_addr_copy(ace->frame.etype.smac.value,
 				match.key->src);
-		ether_addr_copy(ocelot_rule->frame.etype.dmac.mask,
+		ether_addr_copy(ace->frame.etype.dmac.mask,
 				match.mask->dst);
-		ether_addr_copy(ocelot_rule->frame.etype.smac.mask,
+		ether_addr_copy(ace->frame.etype.smac.mask,
 				match.mask->src);
 		goto finished_key_parsing;
 	}
@@ -96,17 +96,17 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 
 		flow_rule_match_basic(rule, &match);
 		if (ntohs(match.key->n_proto) == ETH_P_IP) {
-			ocelot_rule->type = OCELOT_ACE_TYPE_IPV4;
-			ocelot_rule->frame.ipv4.proto.value[0] =
+			ace->type = OCELOT_ACE_TYPE_IPV4;
+			ace->frame.ipv4.proto.value[0] =
 				match.key->ip_proto;
-			ocelot_rule->frame.ipv4.proto.mask[0] =
+			ace->frame.ipv4.proto.mask[0] =
 				match.mask->ip_proto;
 		}
 		if (ntohs(match.key->n_proto) == ETH_P_IPV6) {
-			ocelot_rule->type = OCELOT_ACE_TYPE_IPV6;
-			ocelot_rule->frame.ipv6.proto.value[0] =
+			ace->type = OCELOT_ACE_TYPE_IPV6;
+			ace->frame.ipv6.proto.value[0] =
 				match.key->ip_proto;
-			ocelot_rule->frame.ipv6.proto.mask[0] =
+			ace->frame.ipv6.proto.mask[0] =
 				match.mask->ip_proto;
 		}
 	}
@@ -117,16 +117,16 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 		u8 *tmp;
 
 		flow_rule_match_ipv4_addrs(rule, &match);
-		tmp = &ocelot_rule->frame.ipv4.sip.value.addr[0];
+		tmp = &ace->frame.ipv4.sip.value.addr[0];
 		memcpy(tmp, &match.key->src, 4);
 
-		tmp = &ocelot_rule->frame.ipv4.sip.mask.addr[0];
+		tmp = &ace->frame.ipv4.sip.mask.addr[0];
 		memcpy(tmp, &match.mask->src, 4);
 
-		tmp = &ocelot_rule->frame.ipv4.dip.value.addr[0];
+		tmp = &ace->frame.ipv4.dip.value.addr[0];
 		memcpy(tmp, &match.key->dst, 4);
 
-		tmp = &ocelot_rule->frame.ipv4.dip.mask.addr[0];
+		tmp = &ace->frame.ipv4.dip.mask.addr[0];
 		memcpy(tmp, &match.mask->dst, 4);
 	}
 
@@ -139,60 +139,60 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 		struct flow_match_ports match;
 
 		flow_rule_match_ports(rule, &match);
-		ocelot_rule->frame.ipv4.sport.value = ntohs(match.key->src);
-		ocelot_rule->frame.ipv4.sport.mask = ntohs(match.mask->src);
-		ocelot_rule->frame.ipv4.dport.value = ntohs(match.key->dst);
-		ocelot_rule->frame.ipv4.dport.mask = ntohs(match.mask->dst);
+		ace->frame.ipv4.sport.value = ntohs(match.key->src);
+		ace->frame.ipv4.sport.mask = ntohs(match.mask->src);
+		ace->frame.ipv4.dport.value = ntohs(match.key->dst);
+		ace->frame.ipv4.dport.mask = ntohs(match.mask->dst);
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
 		struct flow_match_vlan match;
 
 		flow_rule_match_vlan(rule, &match);
-		ocelot_rule->type = OCELOT_ACE_TYPE_ANY;
-		ocelot_rule->vlan.vid.value = match.key->vlan_id;
-		ocelot_rule->vlan.vid.mask = match.mask->vlan_id;
-		ocelot_rule->vlan.pcp.value[0] = match.key->vlan_priority;
-		ocelot_rule->vlan.pcp.mask[0] = match.mask->vlan_priority;
+		ace->type = OCELOT_ACE_TYPE_ANY;
+		ace->vlan.vid.value = match.key->vlan_id;
+		ace->vlan.vid.mask = match.mask->vlan_id;
+		ace->vlan.pcp.value[0] = match.key->vlan_priority;
+		ace->vlan.pcp.mask[0] = match.mask->vlan_priority;
 	}
 
 finished_key_parsing:
-	ocelot_rule->prio = f->common.prio;
-	ocelot_rule->id = f->cookie;
-	return ocelot_flower_parse_action(f, ocelot_rule);
+	ace->prio = f->common.prio;
+	ace->id = f->cookie;
+	return ocelot_flower_parse_action(f, ace);
 }
 
 static
 struct ocelot_ace_rule *ocelot_ace_rule_create(struct ocelot *ocelot, int port,
 					       struct flow_cls_offload *f)
 {
-	struct ocelot_ace_rule *rule;
+	struct ocelot_ace_rule *ace;
 
-	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
-	if (!rule)
+	ace = kzalloc(sizeof(*ace), GFP_KERNEL);
+	if (!ace)
 		return NULL;
 
-	rule->ingress_port_mask = BIT(port);
-	return rule;
+	ace->ingress_port_mask = BIT(port);
+	return ace;
 }
 
 int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_ace_rule *rule;
+	struct ocelot_ace_rule *ace;
 	int ret;
 
-	rule = ocelot_ace_rule_create(ocelot, port, f);
-	if (!rule)
+	ace = ocelot_ace_rule_create(ocelot, port, f);
+	if (!ace)
 		return -ENOMEM;
 
-	ret = ocelot_flower_parse(f, rule);
+	ret = ocelot_flower_parse(f, ace);
 	if (ret) {
-		kfree(rule);
+		kfree(ace);
 		return ret;
 	}
 
-	ret = ocelot_ace_rule_offload_add(ocelot, rule);
+	ret = ocelot_ace_rule_offload_add(ocelot, ace);
 	if (ret)
 		return ret;
 
@@ -203,13 +203,13 @@ EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_ace_rule rule;
+	struct ocelot_ace_rule ace;
 	int ret;
 
-	rule.prio = f->common.prio;
-	rule.id = f->cookie;
+	ace.prio = f->common.prio;
+	ace.id = f->cookie;
 
-	ret = ocelot_ace_rule_offload_del(ocelot, &rule);
+	ret = ocelot_ace_rule_offload_del(ocelot, &ace);
 	if (ret)
 		return ret;
 
@@ -220,16 +220,16 @@ EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
 int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 			    struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_ace_rule rule;
+	struct ocelot_ace_rule ace;
 	int ret;
 
-	rule.prio = f->common.prio;
-	rule.id = f->cookie;
-	ret = ocelot_ace_rule_stats_update(ocelot, &rule);
+	ace.prio = f->common.prio;
+	ace.id = f->cookie;
+	ret = ocelot_ace_rule_stats_update(ocelot, &ace);
 	if (ret)
 		return ret;
 
-	flow_stats_update(&f->stats, 0x0, rule.stats.pkts, 0x0);
+	flow_stats_update(&f->stats, 0x0, ace.stats.pkts, 0x0);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_stats);
-- 
2.17.1

