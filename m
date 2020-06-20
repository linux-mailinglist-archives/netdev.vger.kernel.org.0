Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CA52024E6
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgFTPoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgFTPoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:44:09 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB8BC0613F0
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:08 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id p18so10137356eds.7
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KmxOY04jyTOxOs44vLWWuJUtC4LfhY4OWKP3g0lXn74=;
        b=MJtzcThkeMzy43cCyhtFLQNeDen/GpqqYdS+btJ8cULNv1LlAdAX0Vs2Yja5ROYoxF
         8Mnn22sYMf+UXCsmvE6mfSpqpbn01A43wq7KGT06ZdFuFbeVIcSJDSl8nD1tbClFMlxt
         i1zjTnuACB+yREEQdBYywa9Gv2u6ewRPu8z/dnAAdEDM66X41lGI35L84aVcwph0lYAW
         +pSoE/P17Brv7hqs6fpXtqvB4k7QCUN4T7Lp7uePqy2pcQBft314JBCzvKlzY25vuxi4
         /+JxgkKN+XXdvPCAOUdbGHZuQOUOihP4bMdGSlsQ5Qz+k3atsc/DyhvmnTDjEKQU8IAt
         BLuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KmxOY04jyTOxOs44vLWWuJUtC4LfhY4OWKP3g0lXn74=;
        b=QhTJ2W220Lea8TN3RJq3y9Xp1kapbzjkrDpUzqDsNzPYyfchZF/KVKT+w4W4dNDlQA
         Or8gjXm2KuvOMpjq2Zqms+eCYL/mSqlsAAYVKh5u65nBjiX6IDXfo2hUkX/d4vBZogrp
         5/Rdh+M/5rB8An6sOeUSgycugvYfoEPo7qtS98ec1w3qrq+jNUUdpdJ1FAGCHp+vd1DD
         5nswKsKgX4Kmr5yhn7jUM6FLqg94H1SMvHh4qTZzErpi6j84QdlQSpT6aKPmw83vk4dg
         z2xMlfaxhsprvDa2u+yKrQp+iD/8RCEhtKUWEMEtL60sxlSpeSffa5n2daL1F/LXmVh3
         mf7g==
X-Gm-Message-State: AOAM533F49Z+hx9U+yzQlPV1wWWEmlX7I/OnZpOJosFbhfytuDlUIMXo
        /KE05keUHt8bd0M9fRe6BLY=
X-Google-Smtp-Source: ABdhPJyJP8TEU5fQRHHhEQtgWwfNljA1yK+B4Ihq5lhKZ70+eslL1UjtInXk6hEp9DqQWadgsNlAsQ==
X-Received: by 2002:aa7:db11:: with SMTP id t17mr1722296eds.365.1592667847235;
        Sat, 20 Jun 2020 08:44:07 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:44:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 11/12] net: mscc: ocelot: generalize the "ACE/ACL" names
Date:   Sat, 20 Jun 2020 18:43:46 +0300
Message-Id: <20200620154347.3587114-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Access Control Lists (and their respective Access Control Entries) are
specifically entries in the VCAP IS2, the security enforcement block,
according to the documentation.
Let's rename the structures and functions to something more generic, so
that VCAP IS1 structures (which would otherwise have to be called
Ingress Classification Entries) can reuse the same code without
confusion.

Some renaming that was done:

struct ocelot_ace_rule -> struct ocelot_vcap_filter
struct ocelot_acl_block -> struct ocelot_vcap_block
enum ocelot_ace_type -> enum ocelot_vcap_key_type
struct ocelot_ace_vlan -> struct ocelot_vcap_key_vlan
enum ocelot_ace_action -> enum ocelot_vcap_action
struct ocelot_ace_stats -> struct ocelot_vcap_stats
enum ocelot_ace_type -> enum ocelot_vcap_key_type
struct ocelot_ace_frame_* -> struct ocelot_vcap_key_*

No functional change is intended.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c        |   2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c | 122 ++++-----
 drivers/net/ethernet/mscc/ocelot_police.h |   6 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 286 +++++++++++-----------
 drivers/net/ethernet/mscc/ocelot_vcap.h   |  88 +++----
 include/soc/mscc/ocelot.h                 |   4 +-
 6 files changed, 257 insertions(+), 251 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d4ad7ffe6f6e..52b180280d2f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1392,7 +1392,7 @@ int ocelot_init(struct ocelot *ocelot)
 	INIT_LIST_HEAD(&ocelot->multicast);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
-	ocelot_ace_init(ocelot);
+	ocelot_vcap_init(ocelot);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		/* Clear all counters (5 groups) */
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index d57d6948ebf2..f2a85b06a6e7 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -9,7 +9,7 @@
 #include "ocelot_vcap.h"
 
 static int ocelot_flower_parse_action(struct flow_cls_offload *f,
-				      struct ocelot_ace_rule *ace)
+				      struct ocelot_vcap_filter *filter)
 {
 	const struct flow_action_entry *a;
 	s64 burst;
@@ -26,17 +26,17 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	flow_action_for_each(i, a, &f->rule->action) {
 		switch (a->id) {
 		case FLOW_ACTION_DROP:
-			ace->action = OCELOT_ACL_ACTION_DROP;
+			filter->action = OCELOT_VCAP_ACTION_DROP;
 			break;
 		case FLOW_ACTION_TRAP:
-			ace->action = OCELOT_ACL_ACTION_TRAP;
+			filter->action = OCELOT_VCAP_ACTION_TRAP;
 			break;
 		case FLOW_ACTION_POLICE:
-			ace->action = OCELOT_ACL_ACTION_POLICE;
+			filter->action = OCELOT_VCAP_ACTION_POLICE;
 			rate = a->police.rate_bytes_ps;
-			ace->pol.rate = div_u64(rate, 1000) * 8;
+			filter->pol.rate = div_u64(rate, 1000) * 8;
 			burst = rate * PSCHED_NS2TICKS(a->police.burst);
-			ace->pol.burst = div_u64(burst, PSCHED_TICKS_PER_SEC);
+			filter->pol.burst = div_u64(burst, PSCHED_TICKS_PER_SEC);
 			break;
 		default:
 			return -EOPNOTSUPP;
@@ -47,7 +47,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 }
 
 static int ocelot_flower_parse(struct flow_cls_offload *f,
-			       struct ocelot_ace_rule *ace)
+			       struct ocelot_vcap_filter *filter)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
@@ -88,14 +88,14 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 			return -EOPNOTSUPP;
 
 		flow_rule_match_eth_addrs(rule, &match);
-		ace->type = OCELOT_ACE_TYPE_ETYPE;
-		ether_addr_copy(ace->frame.etype.dmac.value,
+		filter->key_type = OCELOT_VCAP_KEY_ETYPE;
+		ether_addr_copy(filter->key.etype.dmac.value,
 				match.key->dst);
-		ether_addr_copy(ace->frame.etype.smac.value,
+		ether_addr_copy(filter->key.etype.smac.value,
 				match.key->src);
-		ether_addr_copy(ace->frame.etype.dmac.mask,
+		ether_addr_copy(filter->key.etype.dmac.mask,
 				match.mask->dst);
-		ether_addr_copy(ace->frame.etype.smac.mask,
+		ether_addr_copy(filter->key.etype.smac.mask,
 				match.mask->src);
 		goto finished_key_parsing;
 	}
@@ -105,18 +105,18 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 
 		flow_rule_match_basic(rule, &match);
 		if (ntohs(match.key->n_proto) == ETH_P_IP) {
-			ace->type = OCELOT_ACE_TYPE_IPV4;
-			ace->frame.ipv4.proto.value[0] =
+			filter->key_type = OCELOT_VCAP_KEY_IPV4;
+			filter->key.ipv4.proto.value[0] =
 				match.key->ip_proto;
-			ace->frame.ipv4.proto.mask[0] =
+			filter->key.ipv4.proto.mask[0] =
 				match.mask->ip_proto;
 			match_protocol = false;
 		}
 		if (ntohs(match.key->n_proto) == ETH_P_IPV6) {
-			ace->type = OCELOT_ACE_TYPE_IPV6;
-			ace->frame.ipv6.proto.value[0] =
+			filter->key_type = OCELOT_VCAP_KEY_IPV6;
+			filter->key.ipv6.proto.value[0] =
 				match.key->ip_proto;
-			ace->frame.ipv6.proto.mask[0] =
+			filter->key.ipv6.proto.mask[0] =
 				match.mask->ip_proto;
 			match_protocol = false;
 		}
@@ -128,16 +128,16 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 		u8 *tmp;
 
 		flow_rule_match_ipv4_addrs(rule, &match);
-		tmp = &ace->frame.ipv4.sip.value.addr[0];
+		tmp = &filter->key.ipv4.sip.value.addr[0];
 		memcpy(tmp, &match.key->src, 4);
 
-		tmp = &ace->frame.ipv4.sip.mask.addr[0];
+		tmp = &filter->key.ipv4.sip.mask.addr[0];
 		memcpy(tmp, &match.mask->src, 4);
 
-		tmp = &ace->frame.ipv4.dip.value.addr[0];
+		tmp = &filter->key.ipv4.dip.value.addr[0];
 		memcpy(tmp, &match.key->dst, 4);
 
-		tmp = &ace->frame.ipv4.dip.mask.addr[0];
+		tmp = &filter->key.ipv4.dip.mask.addr[0];
 		memcpy(tmp, &match.mask->dst, 4);
 		match_protocol = false;
 	}
@@ -151,10 +151,10 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 		struct flow_match_ports match;
 
 		flow_rule_match_ports(rule, &match);
-		ace->frame.ipv4.sport.value = ntohs(match.key->src);
-		ace->frame.ipv4.sport.mask = ntohs(match.mask->src);
-		ace->frame.ipv4.dport.value = ntohs(match.key->dst);
-		ace->frame.ipv4.dport.mask = ntohs(match.mask->dst);
+		filter->key.ipv4.sport.value = ntohs(match.key->src);
+		filter->key.ipv4.sport.mask = ntohs(match.mask->src);
+		filter->key.ipv4.dport.value = ntohs(match.key->dst);
+		filter->key.ipv4.dport.mask = ntohs(match.mask->dst);
 		match_protocol = false;
 	}
 
@@ -162,11 +162,11 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 		struct flow_match_vlan match;
 
 		flow_rule_match_vlan(rule, &match);
-		ace->type = OCELOT_ACE_TYPE_ANY;
-		ace->vlan.vid.value = match.key->vlan_id;
-		ace->vlan.vid.mask = match.mask->vlan_id;
-		ace->vlan.pcp.value[0] = match.key->vlan_priority;
-		ace->vlan.pcp.mask[0] = match.mask->vlan_priority;
+		filter->key_type = OCELOT_VCAP_KEY_ANY;
+		filter->vlan.vid.value = match.key->vlan_id;
+		filter->vlan.vid.mask = match.mask->vlan_id;
+		filter->vlan.pcp.value[0] = match.key->vlan_priority;
+		filter->vlan.pcp.mask[0] = match.mask->vlan_priority;
 		match_protocol = false;
 	}
 
@@ -175,76 +175,76 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 		/* TODO: support SNAP, LLC etc */
 		if (proto < ETH_P_802_3_MIN)
 			return -EOPNOTSUPP;
-		ace->type = OCELOT_ACE_TYPE_ETYPE;
-		*(__be16 *)ace->frame.etype.etype.value = htons(proto);
-		*(__be16 *)ace->frame.etype.etype.mask = htons(0xffff);
+		filter->key_type = OCELOT_VCAP_KEY_ETYPE;
+		*(__be16 *)filter->key.etype.etype.value = htons(proto);
+		*(__be16 *)filter->key.etype.etype.mask = htons(0xffff);
 	}
-	/* else, a rule of type OCELOT_ACE_TYPE_ANY is implicitly added */
+	/* else, a filter of type OCELOT_VCAP_KEY_ANY is implicitly added */
 
-	ace->prio = f->common.prio;
-	ace->id = f->cookie;
-	return ocelot_flower_parse_action(f, ace);
+	filter->prio = f->common.prio;
+	filter->id = f->cookie;
+	return ocelot_flower_parse_action(f, filter);
 }
 
-static
-struct ocelot_ace_rule *ocelot_ace_rule_create(struct ocelot *ocelot, int port,
-					       struct flow_cls_offload *f)
+static struct ocelot_vcap_filter
+*ocelot_vcap_filter_create(struct ocelot *ocelot, int port,
+			 struct flow_cls_offload *f)
 {
-	struct ocelot_ace_rule *ace;
+	struct ocelot_vcap_filter *filter;
 
-	ace = kzalloc(sizeof(*ace), GFP_KERNEL);
-	if (!ace)
+	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
+	if (!filter)
 		return NULL;
 
-	ace->ingress_port_mask = BIT(port);
-	return ace;
+	filter->ingress_port_mask = BIT(port);
+	return filter;
 }
 
 int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_ace_rule *ace;
+	struct ocelot_vcap_filter *filter;
 	int ret;
 
-	ace = ocelot_ace_rule_create(ocelot, port, f);
-	if (!ace)
+	filter = ocelot_vcap_filter_create(ocelot, port, f);
+	if (!filter)
 		return -ENOMEM;
 
-	ret = ocelot_flower_parse(f, ace);
+	ret = ocelot_flower_parse(f, filter);
 	if (ret) {
-		kfree(ace);
+		kfree(filter);
 		return ret;
 	}
 
-	return ocelot_ace_rule_offload_add(ocelot, ace, f->common.extack);
+	return ocelot_vcap_filter_add(ocelot, filter, f->common.extack);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 
 int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_ace_rule ace;
+	struct ocelot_vcap_filter filter;
 
-	ace.prio = f->common.prio;
-	ace.id = f->cookie;
+	filter.prio = f->common.prio;
+	filter.id = f->cookie;
 
-	return ocelot_ace_rule_offload_del(ocelot, &ace);
+	return ocelot_vcap_filter_del(ocelot, &filter);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
 
 int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 			    struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_ace_rule ace;
+	struct ocelot_vcap_filter filter;
 	int ret;
 
-	ace.prio = f->common.prio;
-	ace.id = f->cookie;
-	ret = ocelot_ace_rule_stats_update(ocelot, &ace);
+	filter.prio = f->common.prio;
+	filter.id = f->cookie;
+	ret = ocelot_vcap_filter_stats_update(ocelot, &filter);
 	if (ret)
 		return ret;
 
-	flow_stats_update(&f->stats, 0x0, ace.stats.pkts, 0, 0x0,
+	flow_stats_update(&f->stats, 0x0, filter.stats.pkts, 0, 0x0,
 			  FLOW_ACTION_HW_STATS_IMMEDIATE);
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
index 79d18442aa9b..be6f2286a5cd 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.h
+++ b/drivers/net/ethernet/mscc/ocelot_police.h
@@ -33,9 +33,9 @@ struct qos_policer_conf {
 int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
 			 struct qos_policer_conf *conf);
 
-int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
-			   struct ocelot_policer *pol);
+int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
+			    struct ocelot_policer *pol);
 
-int ocelot_ace_policer_del(struct ocelot *ocelot, u32 pol_ix);
+int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix);
 
 #endif /* _MSCC_OCELOT_POLICE_H_ */
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 33b5b015e8a7..8597034fd3b7 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -302,10 +302,10 @@ static void vcap_action_set(struct ocelot *ocelot, struct vcap_data *data,
 }
 
 static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
-			   struct ocelot_ace_rule *ace)
+			   struct ocelot_vcap_filter *filter)
 {
-	switch (ace->action) {
-	case OCELOT_ACL_ACTION_DROP:
+	switch (filter->action) {
+	case OCELOT_VCAP_ACTION_DROP:
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 1);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 1);
@@ -314,7 +314,7 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
 		break;
-	case OCELOT_ACL_ACTION_TRAP:
+	case OCELOT_VCAP_ACTION_TRAP:
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 1);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 0);
@@ -322,12 +322,12 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 1);
 		break;
-	case OCELOT_ACL_ACTION_POLICE:
+	case OCELOT_VCAP_ACTION_POLICE:
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 0);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 1);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_IDX,
-				ace->pol_ix);
+				filter->pol_ix);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
 		break;
@@ -335,11 +335,11 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 }
 
 static void is2_entry_set(struct ocelot *ocelot, int ix,
-			  struct ocelot_ace_rule *ace)
+			  struct ocelot_vcap_filter *filter)
 {
 	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
+	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
 	u32 val, msk, type, type_mask = 0xf, i, count;
-	struct ocelot_ace_vlan *tag = &ace->vlan;
 	struct ocelot_vcap_u64 payload;
 	struct vcap_data data;
 	int row = (ix / 2);
@@ -355,19 +355,19 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	data.tg_sw = VCAP_TG_HALF;
 	is2_data_get(ocelot, &data, ix);
 	data.tg = (data.tg & ~data.tg_mask);
-	if (ace->prio != 0)
+	if (filter->prio != 0)
 		data.tg |= data.tg_value;
 
 	data.type = IS2_ACTION_TYPE_NORMAL;
 
 	vcap_key_set(ocelot, &data, VCAP_IS2_HK_PAG, 0, 0);
 	vcap_key_set(ocelot, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
-		     ~ace->ingress_port_mask);
+		     ~filter->ingress_port_mask);
 	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_1);
 	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_HOST_MATCH,
 			 OCELOT_VCAP_BIT_ANY);
-	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L2_MC, ace->dmac_mc);
-	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L2_BC, ace->dmac_bc);
+	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L2_MC, filter->dmac_mc);
+	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L2_BC, filter->dmac_bc);
 	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_VLAN_TAGGED, tag->tagged);
 	vcap_key_set(ocelot, &data, VCAP_IS2_HK_VID,
 		     tag->vid.value, tag->vid.mask);
@@ -375,9 +375,9 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 		     tag->pcp.value[0], tag->pcp.mask[0]);
 	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_DEI, tag->dei);
 
-	switch (ace->type) {
-	case OCELOT_ACE_TYPE_ETYPE: {
-		struct ocelot_ace_frame_etype *etype = &ace->frame.etype;
+	switch (filter->key_type) {
+	case OCELOT_VCAP_KEY_ETYPE: {
+		struct ocelot_vcap_key_etype *etype = &filter->key.etype;
 
 		type = IS2_TYPE_ETYPE;
 		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_DMAC,
@@ -398,8 +398,8 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 				   etype->data.value, etype->data.mask);
 		break;
 	}
-	case OCELOT_ACE_TYPE_LLC: {
-		struct ocelot_ace_frame_llc *llc = &ace->frame.llc;
+	case OCELOT_VCAP_KEY_LLC: {
+		struct ocelot_vcap_key_llc *llc = &filter->key.llc;
 
 		type = IS2_TYPE_LLC;
 		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_DMAC,
@@ -414,8 +414,8 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 				   payload.value, payload.mask);
 		break;
 	}
-	case OCELOT_ACE_TYPE_SNAP: {
-		struct ocelot_ace_frame_snap *snap = &ace->frame.snap;
+	case OCELOT_VCAP_KEY_SNAP: {
+		struct ocelot_vcap_key_snap *snap = &filter->key.snap;
 
 		type = IS2_TYPE_SNAP;
 		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_DMAC,
@@ -423,12 +423,12 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_SMAC,
 				   snap->smac.value, snap->smac.mask);
 		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_MAC_SNAP_L2_SNAP,
-				   ace->frame.snap.snap.value,
-				   ace->frame.snap.snap.mask);
+				   filter->key.snap.snap.value,
+				   filter->key.snap.snap.mask);
 		break;
 	}
-	case OCELOT_ACE_TYPE_ARP: {
-		struct ocelot_ace_frame_arp *arp = &ace->frame.arp;
+	case OCELOT_VCAP_KEY_ARP: {
+		struct ocelot_vcap_key_arp *arp = &filter->key.arp;
 
 		type = IS2_TYPE_ARP;
 		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_MAC_ARP_SMAC,
@@ -469,20 +469,20 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 			     0, 0);
 		break;
 	}
-	case OCELOT_ACE_TYPE_IPV4:
-	case OCELOT_ACE_TYPE_IPV6: {
+	case OCELOT_VCAP_KEY_IPV4:
+	case OCELOT_VCAP_KEY_IPV6: {
 		enum ocelot_vcap_bit sip_eq_dip, sport_eq_dport, seq_zero, tcp;
 		enum ocelot_vcap_bit ttl, fragment, options, tcp_ack, tcp_urg;
 		enum ocelot_vcap_bit tcp_fin, tcp_syn, tcp_rst, tcp_psh;
-		struct ocelot_ace_frame_ipv4 *ipv4 = NULL;
-		struct ocelot_ace_frame_ipv6 *ipv6 = NULL;
+		struct ocelot_vcap_key_ipv4 *ipv4 = NULL;
+		struct ocelot_vcap_key_ipv6 *ipv6 = NULL;
 		struct ocelot_vcap_udp_tcp *sport, *dport;
 		struct ocelot_vcap_ipv4 sip, dip;
 		struct ocelot_vcap_u8 proto, ds;
 		struct ocelot_vcap_u48 *ip_data;
 
-		if (ace->type == OCELOT_ACE_TYPE_IPV4) {
-			ipv4 = &ace->frame.ipv4;
+		if (filter->key_type == OCELOT_VCAP_KEY_IPV4) {
+			ipv4 = &filter->key.ipv4;
 			ttl = ipv4->ttl;
 			fragment = ipv4->fragment;
 			options = ipv4->options;
@@ -503,7 +503,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 			sport_eq_dport = ipv4->sport_eq_dport;
 			seq_zero = ipv4->seq_zero;
 		} else {
-			ipv6 = &ace->frame.ipv6;
+			ipv6 = &filter->key.ipv6;
 			ttl = ipv6->ttl;
 			fragment = OCELOT_VCAP_BIT_ANY;
 			options = OCELOT_VCAP_BIT_ANY;
@@ -607,7 +607,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 		}
 		break;
 	}
-	case OCELOT_ACE_TYPE_ANY:
+	case OCELOT_VCAP_KEY_ANY:
 	default:
 		type = 0;
 		type_mask = 0;
@@ -623,9 +623,9 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	}
 
 	vcap_key_set(ocelot, &data, VCAP_IS2_TYPE, type, type_mask);
-	is2_action_set(ocelot, &data, ace);
+	is2_action_set(ocelot, &data, filter);
 	vcap_data_set(data.counter, data.counter_offset,
-		      vcap_is2->counter_width, ace->stats.pkts);
+		      vcap_is2->counter_width, filter->stats.pkts);
 
 	/* Write row */
 	vcap_entry2cache(ocelot, &data);
@@ -633,7 +633,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	vcap_row_cmd(ocelot, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
 }
 
-static void is2_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
+static void is2_entry_get(struct ocelot *ocelot, struct ocelot_vcap_filter *filter,
 			  int ix)
 {
 	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
@@ -648,55 +648,56 @@ static void is2_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
 	cnt = vcap_data_get(data.counter, data.counter_offset,
 			    vcap_is2->counter_width);
 
-	rule->stats.pkts = cnt;
+	filter->stats.pkts = cnt;
 }
 
-static void ocelot_ace_rule_add(struct ocelot *ocelot,
-				struct ocelot_acl_block *block,
-				struct ocelot_ace_rule *rule)
+static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
+					    struct ocelot_vcap_block *block,
+					    struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_ace_rule *tmp;
+	struct ocelot_vcap_filter *tmp;
 	struct list_head *pos, *n;
 
-	if (rule->action == OCELOT_ACL_ACTION_POLICE) {
+	if (filter->action == OCELOT_VCAP_ACTION_POLICE) {
 		block->pol_lpr--;
-		rule->pol_ix = block->pol_lpr;
-		ocelot_ace_policer_add(ocelot, rule->pol_ix, &rule->pol);
+		filter->pol_ix = block->pol_lpr;
+		ocelot_vcap_policer_add(ocelot, filter->pol_ix, &filter->pol);
 	}
 
 	block->count++;
 
 	if (list_empty(&block->rules)) {
-		list_add(&rule->list, &block->rules);
+		list_add(&filter->list, &block->rules);
 		return;
 	}
 
 	list_for_each_safe(pos, n, &block->rules) {
-		tmp = list_entry(pos, struct ocelot_ace_rule, list);
-		if (rule->prio < tmp->prio)
+		tmp = list_entry(pos, struct ocelot_vcap_filter, list);
+		if (filter->prio < tmp->prio)
 			break;
 	}
-	list_add(&rule->list, pos->prev);
+	list_add(&filter->list, pos->prev);
 }
 
-static int ocelot_ace_rule_get_index_id(struct ocelot_acl_block *block,
-					struct ocelot_ace_rule *rule)
+static int ocelot_vcap_block_get_filter_index(struct ocelot_vcap_block *block,
+					      struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_ace_rule *tmp;
+	struct ocelot_vcap_filter *tmp;
 	int index = -1;
 
 	list_for_each_entry(tmp, &block->rules, list) {
 		++index;
-		if (rule->id == tmp->id)
+		if (filter->id == tmp->id)
 			break;
 	}
 	return index;
 }
 
-static struct ocelot_ace_rule*
-ocelot_ace_rule_get_rule_index(struct ocelot_acl_block *block, int index)
+static struct ocelot_vcap_filter*
+ocelot_vcap_block_find_filter(struct ocelot_vcap_block *block,
+			      int index)
 {
-	struct ocelot_ace_rule *tmp;
+	struct ocelot_vcap_filter *tmp;
 	int i = 0;
 
 	list_for_each_entry(tmp, &block->rules, list) {
@@ -739,15 +740,16 @@ static void ocelot_match_all_as_mac_etype(struct ocelot *ocelot, int port,
 		       ANA_PORT_VCAP_S2_CFG, port);
 }
 
-static bool ocelot_ace_is_problematic_mac_etype(struct ocelot_ace_rule *ace)
+static bool
+ocelot_vcap_is_problematic_mac_etype(struct ocelot_vcap_filter *filter)
 {
 	u16 proto, mask;
 
-	if (ace->type != OCELOT_ACE_TYPE_ETYPE)
+	if (filter->key_type != OCELOT_VCAP_KEY_ETYPE)
 		return false;
 
-	proto = ntohs(*(__be16 *)ace->frame.etype.etype.value);
-	mask = ntohs(*(__be16 *)ace->frame.etype.etype.mask);
+	proto = ntohs(*(__be16 *)filter->key.etype.etype.value);
+	mask = ntohs(*(__be16 *)filter->key.etype.etype.mask);
 
 	/* ETH_P_ALL match, so all protocols below are included */
 	if (mask == 0)
@@ -762,49 +764,51 @@ static bool ocelot_ace_is_problematic_mac_etype(struct ocelot_ace_rule *ace)
 	return false;
 }
 
-static bool ocelot_ace_is_problematic_non_mac_etype(struct ocelot_ace_rule *ace)
+static bool
+ocelot_vcap_is_problematic_non_mac_etype(struct ocelot_vcap_filter *filter)
 {
-	if (ace->type == OCELOT_ACE_TYPE_SNAP)
+	if (filter->key_type == OCELOT_VCAP_KEY_SNAP)
 		return true;
-	if (ace->type == OCELOT_ACE_TYPE_ARP)
+	if (filter->key_type == OCELOT_VCAP_KEY_ARP)
 		return true;
-	if (ace->type == OCELOT_ACE_TYPE_IPV4)
+	if (filter->key_type == OCELOT_VCAP_KEY_IPV4)
 		return true;
-	if (ace->type == OCELOT_ACE_TYPE_IPV6)
+	if (filter->key_type == OCELOT_VCAP_KEY_IPV6)
 		return true;
 	return false;
 }
 
-static bool ocelot_exclusive_mac_etype_ace_rules(struct ocelot *ocelot,
-						 struct ocelot_ace_rule *ace)
+static bool
+ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
+					struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_acl_block *block = &ocelot->acl_block;
-	struct ocelot_ace_rule *tmp;
+	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_filter *tmp;
 	unsigned long port;
 	int i;
 
-	if (ocelot_ace_is_problematic_mac_etype(ace)) {
+	if (ocelot_vcap_is_problematic_mac_etype(filter)) {
 		/* Search for any non-MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
-			tmp = ocelot_ace_rule_get_rule_index(block, i);
-			if (tmp->ingress_port_mask & ace->ingress_port_mask &&
-			    ocelot_ace_is_problematic_non_mac_etype(tmp))
+			tmp = ocelot_vcap_block_find_filter(block, i);
+			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
+			    ocelot_vcap_is_problematic_non_mac_etype(tmp))
 				return false;
 		}
 
-		for_each_set_bit(port, &ace->ingress_port_mask,
+		for_each_set_bit(port, &filter->ingress_port_mask,
 				 ocelot->num_phys_ports)
 			ocelot_match_all_as_mac_etype(ocelot, port, true);
-	} else if (ocelot_ace_is_problematic_non_mac_etype(ace)) {
+	} else if (ocelot_vcap_is_problematic_non_mac_etype(filter)) {
 		/* Search for any MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
-			tmp = ocelot_ace_rule_get_rule_index(block, i);
-			if (tmp->ingress_port_mask & ace->ingress_port_mask &&
-			    ocelot_ace_is_problematic_mac_etype(tmp))
+			tmp = ocelot_vcap_block_find_filter(block, i);
+			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
+			    ocelot_vcap_is_problematic_mac_etype(tmp))
 				return false;
 		}
 
-		for_each_set_bit(port, &ace->ingress_port_mask,
+		for_each_set_bit(port, &filter->ingress_port_mask,
 				 ocelot->num_phys_ports)
 			ocelot_match_all_as_mac_etype(ocelot, port, false);
 	}
@@ -812,39 +816,40 @@ static bool ocelot_exclusive_mac_etype_ace_rules(struct ocelot *ocelot,
 	return true;
 }
 
-int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
-				struct ocelot_ace_rule *rule,
-				struct netlink_ext_ack *extack)
+int ocelot_vcap_filter_add(struct ocelot *ocelot,
+			   struct ocelot_vcap_filter *filter,
+			   struct netlink_ext_ack *extack)
 {
-	struct ocelot_acl_block *block = &ocelot->acl_block;
-	struct ocelot_ace_rule *ace;
+	struct ocelot_vcap_block *block = &ocelot->block;
 	int i, index;
 
-	if (!ocelot_exclusive_mac_etype_ace_rules(ocelot, rule)) {
+	if (!ocelot_exclusive_mac_etype_filter_rules(ocelot, filter)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules");
 		return -EBUSY;
 	}
 
-	/* Add rule to the linked list */
-	ocelot_ace_rule_add(ocelot, block, rule);
+	/* Add filter to the linked list */
+	ocelot_vcap_filter_add_to_block(ocelot, block, filter);
 
-	/* Get the index of the inserted rule */
-	index = ocelot_ace_rule_get_index_id(block, rule);
+	/* Get the index of the inserted filter */
+	index = ocelot_vcap_block_get_filter_index(block, filter);
 
-	/* Move down the rules to make place for the new rule */
+	/* Move down the rules to make place for the new filter */
 	for (i = block->count - 1; i > index; i--) {
-		ace = ocelot_ace_rule_get_rule_index(block, i);
-		is2_entry_set(ocelot, i, ace);
+		struct ocelot_vcap_filter *tmp;
+
+		tmp = ocelot_vcap_block_find_filter(block, i);
+		is2_entry_set(ocelot, i, tmp);
 	}
 
-	/* Now insert the new rule */
-	is2_entry_set(ocelot, index, rule);
+	/* Now insert the new filter */
+	is2_entry_set(ocelot, index, filter);
 	return 0;
 }
 
-int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
-			   struct ocelot_policer *pol)
+int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
+			    struct ocelot_policer *pol)
 {
 	struct qos_policer_conf pp = { 0 };
 
@@ -858,7 +863,7 @@ int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
 	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
 }
 
-int ocelot_ace_policer_del(struct ocelot *ocelot, u32 pol_ix)
+int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix)
 {
 	struct qos_policer_conf pp = { 0 };
 
@@ -867,44 +872,44 @@ int ocelot_ace_policer_del(struct ocelot *ocelot, u32 pol_ix)
 	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
 }
 
-static void ocelot_ace_police_del(struct ocelot *ocelot,
-				  struct ocelot_acl_block *block,
-				  u32 ix)
+static void ocelot_vcap_police_del(struct ocelot *ocelot,
+				   struct ocelot_vcap_block *block,
+				   u32 ix)
 {
-	struct ocelot_ace_rule *ace;
+	struct ocelot_vcap_filter *filter;
 	int index = -1;
 
 	if (ix < block->pol_lpr)
 		return;
 
-	list_for_each_entry(ace, &block->rules, list) {
+	list_for_each_entry(filter, &block->rules, list) {
 		index++;
-		if (ace->action == OCELOT_ACL_ACTION_POLICE &&
-		    ace->pol_ix < ix) {
-			ace->pol_ix += 1;
-			ocelot_ace_policer_add(ocelot, ace->pol_ix,
-					       &ace->pol);
-			is2_entry_set(ocelot, index, ace);
+		if (filter->action == OCELOT_VCAP_ACTION_POLICE &&
+		    filter->pol_ix < ix) {
+			filter->pol_ix += 1;
+			ocelot_vcap_policer_add(ocelot, filter->pol_ix,
+						&filter->pol);
+			is2_entry_set(ocelot, index, filter);
 		}
 	}
 
-	ocelot_ace_policer_del(ocelot, block->pol_lpr);
+	ocelot_vcap_policer_del(ocelot, block->pol_lpr);
 	block->pol_lpr++;
 }
 
-static void ocelot_ace_rule_del(struct ocelot *ocelot,
-				struct ocelot_acl_block *block,
-				struct ocelot_ace_rule *rule)
+static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
+					    struct ocelot_vcap_block *block,
+					    struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_ace_rule *tmp;
+	struct ocelot_vcap_filter *tmp;
 	struct list_head *pos, *q;
 
 	list_for_each_safe(pos, q, &block->rules) {
-		tmp = list_entry(pos, struct ocelot_ace_rule, list);
-		if (tmp->id == rule->id) {
-			if (tmp->action == OCELOT_ACL_ACTION_POLICE)
-				ocelot_ace_police_del(ocelot, block,
-						      tmp->pol_ix);
+		tmp = list_entry(pos, struct ocelot_vcap_filter, list);
+		if (tmp->id == filter->id) {
+			if (tmp->action == OCELOT_VCAP_ACTION_POLICE)
+				ocelot_vcap_police_del(ocelot, block,
+						       tmp->pol_ix);
 
 			list_del(pos);
 			kfree(tmp);
@@ -914,56 +919,57 @@ static void ocelot_ace_rule_del(struct ocelot *ocelot,
 	block->count--;
 }
 
-int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
-				struct ocelot_ace_rule *rule)
+int ocelot_vcap_filter_del(struct ocelot *ocelot,
+			   struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_acl_block *block = &ocelot->acl_block;
-	struct ocelot_ace_rule del_ace;
-	struct ocelot_ace_rule *ace;
+	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_filter del_filter;
 	int i, index;
 
-	memset(&del_ace, 0, sizeof(del_ace));
+	memset(&del_filter, 0, sizeof(del_filter));
 
-	/* Gets index of the rule */
-	index = ocelot_ace_rule_get_index_id(block, rule);
+	/* Gets index of the filter */
+	index = ocelot_vcap_block_get_filter_index(block, filter);
 
-	/* Delete rule */
-	ocelot_ace_rule_del(ocelot, block, rule);
+	/* Delete filter */
+	ocelot_vcap_block_remove_filter(ocelot, block, filter);
 
-	/* Move up all the blocks over the deleted rule */
+	/* Move up all the blocks over the deleted filter */
 	for (i = index; i < block->count; i++) {
-		ace = ocelot_ace_rule_get_rule_index(block, i);
-		is2_entry_set(ocelot, i, ace);
+		struct ocelot_vcap_filter *tmp;
+
+		tmp = ocelot_vcap_block_find_filter(block, i);
+		is2_entry_set(ocelot, i, tmp);
 	}
 
-	/* Now delete the last rule, because it is duplicated */
-	is2_entry_set(ocelot, block->count, &del_ace);
+	/* Now delete the last filter, because it is duplicated */
+	is2_entry_set(ocelot, block->count, &del_filter);
 
 	return 0;
 }
 
-int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
-				 struct ocelot_ace_rule *rule)
+int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
+				    struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_acl_block *block = &ocelot->acl_block;
-	struct ocelot_ace_rule *tmp;
+	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_filter *tmp;
 	int index;
 
-	index = ocelot_ace_rule_get_index_id(block, rule);
-	is2_entry_get(ocelot, rule, index);
+	index = ocelot_vcap_block_get_filter_index(block, filter);
+	is2_entry_get(ocelot, filter, index);
 
 	/* After we get the result we need to clear the counters */
-	tmp = ocelot_ace_rule_get_rule_index(block, index);
+	tmp = ocelot_vcap_block_find_filter(block, index);
 	tmp->stats.pkts = 0;
 	is2_entry_set(ocelot, index, tmp);
 
 	return 0;
 }
 
-int ocelot_ace_init(struct ocelot *ocelot)
+int ocelot_vcap_init(struct ocelot *ocelot)
 {
 	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
-	struct ocelot_acl_block *block = &ocelot->acl_block;
+	struct ocelot_vcap_block *block = &ocelot->block;
 	struct vcap_data data;
 
 	memset(&data, 0, sizeof(data));
@@ -994,7 +1000,7 @@ int ocelot_ace_init(struct ocelot *ocelot)
 
 	block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
 
-	INIT_LIST_HEAD(&ocelot->acl_block.rules);
+	INIT_LIST_HEAD(&ocelot->block.rules);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index 099e177f2617..0dfbfc011b2e 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -3,8 +3,8 @@
  * Copyright (c) 2019 Microsemi Corporation
  */
 
-#ifndef _MSCC_OCELOT_ACE_H_
-#define _MSCC_OCELOT_ACE_H_
+#ifndef _MSCC_OCELOT_VCAP_H_
+#define _MSCC_OCELOT_VCAP_H_
 
 #include "ocelot.h"
 #include "ocelot_police.h"
@@ -76,31 +76,31 @@ struct ocelot_vcap_udp_tcp {
 	u16 mask;
 };
 
-enum ocelot_ace_type {
-	OCELOT_ACE_TYPE_ANY,
-	OCELOT_ACE_TYPE_ETYPE,
-	OCELOT_ACE_TYPE_LLC,
-	OCELOT_ACE_TYPE_SNAP,
-	OCELOT_ACE_TYPE_ARP,
-	OCELOT_ACE_TYPE_IPV4,
-	OCELOT_ACE_TYPE_IPV6
+enum ocelot_vcap_key_type {
+	OCELOT_VCAP_KEY_ANY,
+	OCELOT_VCAP_KEY_ETYPE,
+	OCELOT_VCAP_KEY_LLC,
+	OCELOT_VCAP_KEY_SNAP,
+	OCELOT_VCAP_KEY_ARP,
+	OCELOT_VCAP_KEY_IPV4,
+	OCELOT_VCAP_KEY_IPV6
 };
 
-struct ocelot_ace_vlan {
+struct ocelot_vcap_key_vlan {
 	struct ocelot_vcap_vid vid;    /* VLAN ID (12 bit) */
 	struct ocelot_vcap_u8  pcp;    /* PCP (3 bit) */
 	enum ocelot_vcap_bit dei;    /* DEI */
 	enum ocelot_vcap_bit tagged; /* Tagged/untagged frame */
 };
 
-struct ocelot_ace_frame_etype {
+struct ocelot_vcap_key_etype {
 	struct ocelot_vcap_u48 dmac;
 	struct ocelot_vcap_u48 smac;
 	struct ocelot_vcap_u16 etype;
 	struct ocelot_vcap_u16 data; /* MAC data */
 };
 
-struct ocelot_ace_frame_llc {
+struct ocelot_vcap_key_llc {
 	struct ocelot_vcap_u48 dmac;
 	struct ocelot_vcap_u48 smac;
 
@@ -108,7 +108,7 @@ struct ocelot_ace_frame_llc {
 	struct ocelot_vcap_u32 llc;
 };
 
-struct ocelot_ace_frame_snap {
+struct ocelot_vcap_key_snap {
 	struct ocelot_vcap_u48 dmac;
 	struct ocelot_vcap_u48 smac;
 
@@ -116,7 +116,7 @@ struct ocelot_ace_frame_snap {
 	struct ocelot_vcap_u40 snap;
 };
 
-struct ocelot_ace_frame_arp {
+struct ocelot_vcap_key_arp {
 	struct ocelot_vcap_u48 smac;
 	enum ocelot_vcap_bit arp;	/* Opcode ARP/RARP */
 	enum ocelot_vcap_bit req;	/* Opcode request/reply */
@@ -133,7 +133,7 @@ struct ocelot_ace_frame_arp {
 	struct ocelot_vcap_ipv4 dip;     /* Target IP address */
 };
 
-struct ocelot_ace_frame_ipv4 {
+struct ocelot_vcap_key_ipv4 {
 	enum ocelot_vcap_bit ttl;      /* TTL zero */
 	enum ocelot_vcap_bit fragment; /* Fragment */
 	enum ocelot_vcap_bit options;  /* Header options */
@@ -155,7 +155,7 @@ struct ocelot_ace_frame_ipv4 {
 	enum ocelot_vcap_bit seq_zero;       /* TCP sequence number is zero */
 };
 
-struct ocelot_ace_frame_ipv6 {
+struct ocelot_vcap_key_ipv6 {
 	struct ocelot_vcap_u8 proto; /* IPv6 protocol */
 	struct ocelot_vcap_u128 sip; /* IPv6 source (byte 0-7 ignored) */
 	enum ocelot_vcap_bit ttl;  /* TTL zero */
@@ -174,58 +174,58 @@ struct ocelot_ace_frame_ipv6 {
 	enum ocelot_vcap_bit seq_zero;       /* TCP sequence number is zero */
 };
 
-enum ocelot_ace_action {
-	OCELOT_ACL_ACTION_DROP,
-	OCELOT_ACL_ACTION_TRAP,
-	OCELOT_ACL_ACTION_POLICE,
+enum ocelot_vcap_action {
+	OCELOT_VCAP_ACTION_DROP,
+	OCELOT_VCAP_ACTION_TRAP,
+	OCELOT_VCAP_ACTION_POLICE,
 };
 
-struct ocelot_ace_stats {
+struct ocelot_vcap_stats {
 	u64 bytes;
 	u64 pkts;
 	u64 used;
 };
 
-struct ocelot_ace_rule {
+struct ocelot_vcap_filter {
 	struct list_head list;
 
 	u16 prio;
 	u32 id;
 
-	enum ocelot_ace_action action;
-	struct ocelot_ace_stats stats;
+	enum ocelot_vcap_action action;
+	struct ocelot_vcap_stats stats;
 	unsigned long ingress_port_mask;
 
 	enum ocelot_vcap_bit dmac_mc;
 	enum ocelot_vcap_bit dmac_bc;
-	struct ocelot_ace_vlan vlan;
+	struct ocelot_vcap_key_vlan vlan;
 
-	enum ocelot_ace_type type;
+	enum ocelot_vcap_key_type key_type;
 	union {
-		/* ocelot_ACE_TYPE_ANY: No specific fields */
-		struct ocelot_ace_frame_etype etype;
-		struct ocelot_ace_frame_llc llc;
-		struct ocelot_ace_frame_snap snap;
-		struct ocelot_ace_frame_arp arp;
-		struct ocelot_ace_frame_ipv4 ipv4;
-		struct ocelot_ace_frame_ipv6 ipv6;
-	} frame;
+		/* OCELOT_VCAP_KEY_ANY: No specific fields */
+		struct ocelot_vcap_key_etype etype;
+		struct ocelot_vcap_key_llc llc;
+		struct ocelot_vcap_key_snap snap;
+		struct ocelot_vcap_key_arp arp;
+		struct ocelot_vcap_key_ipv4 ipv4;
+		struct ocelot_vcap_key_ipv6 ipv6;
+	} key;
 	struct ocelot_policer pol;
 	u32 pol_ix;
 };
 
-int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
-				struct ocelot_ace_rule *rule,
-				struct netlink_ext_ack *extack);
-int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
-				struct ocelot_ace_rule *rule);
-int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
-				 struct ocelot_ace_rule *rule);
+int ocelot_vcap_filter_add(struct ocelot *ocelot,
+			   struct ocelot_vcap_filter *rule,
+			   struct netlink_ext_ack *extack);
+int ocelot_vcap_filter_del(struct ocelot *ocelot,
+			   struct ocelot_vcap_filter *rule);
+int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
+				    struct ocelot_vcap_filter *rule);
 
-int ocelot_ace_init(struct ocelot *ocelot);
+int ocelot_vcap_init(struct ocelot *ocelot);
 
 int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
 			       struct flow_cls_offload *f,
 			       bool ingress);
 
-#endif /* _MSCC_OCELOT_ACE_H_ */
+#endif /* _MSCC_OCELOT_VCAP_H_ */
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 4953e9994df3..fa2c3904049e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -470,7 +470,7 @@ struct ocelot_ops {
 	int (*reset)(struct ocelot *ocelot);
 };
 
-struct ocelot_acl_block {
+struct ocelot_vcap_block {
 	struct list_head rules;
 	int count;
 	int pol_lpr;
@@ -535,7 +535,7 @@ struct ocelot {
 
 	struct list_head		multicast;
 
-	struct ocelot_acl_block		acl_block;
+	struct ocelot_vcap_block	block;
 
 	const struct vcap_field		*vcap_is2_keys;
 	const struct vcap_field		*vcap_is2_actions;
-- 
2.25.1

