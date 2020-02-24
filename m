Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CDF16A6F8
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgBXNJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:09:22 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43084 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgBXNJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:09:22 -0500
Received: by mail-wr1-f66.google.com with SMTP id r11so10302599wrq.10
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=blJiNz/1ArLjCB6cqRDdXINK4ypkDs1wbUiIfyaUKaE=;
        b=B7ng7FrRKDzKvMJvVqtBEX8Xnx/W7D5A1mfX36BZquSIzt4yZnmvpCdgYG3KGyUfC1
         tWt9wg0oaPbJfqHW7sCLwODooZ/lrhvo3gmcOLolGXXcDFI+PNga2MP4gQDe3ykZ4bMB
         EfiT+AVil73BZwWS4BEbCPPi9RDb85WaAAl+X/879wJa4yBBoLGLq5wflo3pO9+5wdyj
         iJOiWAoIzvsKov8dduqWHLoRImBbdn9mdHcZwRdvDImoZKRBACLk+Z+B9uH8VN0FUqxe
         n1OD0zglzVwODZzrgDrxN/cupHLx8E36ZjipfhlN96AuARF4iPv4/Gux2LWak/ED6875
         a0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=blJiNz/1ArLjCB6cqRDdXINK4ypkDs1wbUiIfyaUKaE=;
        b=YeKVQE+pGStELvm+CbRa4gDEzWY/vBcrwWYOydMWWKE1GB+x/kJuWKUSbDvIaTAqSi
         nYgB3/w/sOZcydzeh2hoFxe/jfBRrAj2kqMetB002DslftoSBND1KeqUpKMmM+YD7laC
         C4y7AT7KaYEgtXwA4GOS1CZLh1fIjpjOQs7nbujhxk4phl6fbEjyWOd+SBATP+DWPqid
         bBB2VPmuPpNXXMrjS/Wa09tDBiLUkQXlVZULd00qpRBr55nUer926ibL9eBUlxWJWddV
         tjvgpYvVyxXrMPGxcN5fgcPU4BGr7KNLBGOt2T3JRNSWsFEZBG2LX9OJa9g3XLig5f+n
         Ju/g==
X-Gm-Message-State: APjAAAVvdW6loYuG75HDWQqi2J9unJ6y0FPzCk1rv8IPoh/AxNyrRVni
        NnwrukZvxBQNf6pthRDaH6A=
X-Google-Smtp-Source: APXvYqyv7eR/zv+S7IlG6t+vkk+ICVYSUQBUb9M54ORuWZta9U/eYYivAgOuEla0wdHZmDMYbhAzNA==
X-Received: by 2002:adf:82ce:: with SMTP id 72mr66668978wrc.14.1582549758600;
        Mon, 24 Feb 2020 05:09:18 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id i204sm18089298wma.44.2020.02.24.05.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:09:18 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH net-next 02/10] net: mscc: ocelot: simplify tc-flower offload structures
Date:   Mon, 24 Feb 2020 15:08:23 +0200
Message-Id: <20200224130831.25347-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224130831.25347-1-olteanv@gmail.com>
References: <20200224130831.25347-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot tc-flower offload binds a second flow block callback (apart
from the one for matchall) just because it uses a different block
private structure (ocelot_port_private for matchall, ocelot_port_block
for flower).

But ocelot_port_block just appears to be boilerplate, and doesn't help
with anything in particular at all, it's just useless glue between the
(global!) struct ocelot_acl_block *block pointer, and a per-netdevice
struct ocelot_port_private *priv.

So let's just simplify that, and make struct ocelot_port_private be the
private structure for the block offload. This makes us able to use the
same flow callback as in the case of matchall.

This also reveals that the struct ocelot_acl_block *block is used rather
strangely, as mentioned above: it is defined globally, allocated at
probe time, and freed at unbind time. So just move the structure to the
main ocelot structure, which gives further opportunity for
simplification.

Also get rid of backpointers from struct ocelot_acl_block and struct
ocelot_ace_rule back to struct ocelot, by reworking the function
prototypes, where necessary, to use a more DSA-friendly "struct ocelot
*ocelot, int port" format.

And finally, remove the debugging prints that were added during
development, since they provide no useful information at this point.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c        |   1 -
 drivers/net/ethernet/mscc/ocelot_ace.c    |  81 +++++------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  24 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c | 155 ++++------------------
 drivers/net/ethernet/mscc/ocelot_tc.c     |  22 +--
 include/soc/mscc/ocelot.h                 |   7 +
 6 files changed, 75 insertions(+), 215 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b85e4fe9466d..3de8267180e2 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2502,7 +2502,6 @@ void ocelot_deinit(struct ocelot *ocelot)
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 	mutex_destroy(&ocelot->stats_lock);
-	ocelot_ace_deinit();
 	if (ocelot->ptp_clock)
 		ptp_clock_unregister(ocelot->ptp_clock);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 18670645d47f..375c7c6aa7d5 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -12,8 +12,6 @@
 
 #define OCELOT_POLICER_DISCARD 0x17f
 
-static struct ocelot_acl_block *acl_block;
-
 struct vcap_props {
 	const char *name; /* Symbolic name */
 	u16 tg_width; /* Type-group width (in bits) */
@@ -574,15 +572,15 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	vcap_row_cmd(ocelot, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
 }
 
-static void is2_entry_get(struct ocelot_ace_rule *rule, int ix)
+static void is2_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
+			  int ix)
 {
-	struct ocelot *op = rule->ocelot;
 	struct vcap_data data;
 	int row = (ix / 2);
 	u32 cnt;
 
-	vcap_row_cmd(op, row, VCAP_CMD_READ, VCAP_SEL_COUNTER);
-	vcap_cache2action(op, &data);
+	vcap_row_cmd(ocelot, row, VCAP_CMD_READ, VCAP_SEL_COUNTER);
+	vcap_cache2action(ocelot, &data);
 	data.tg_sw = VCAP_TG_HALF;
 	is2_data_get(&data, ix);
 	cnt = vcap_data_get(data.counter, data.counter_offset,
@@ -641,25 +639,27 @@ ocelot_ace_rule_get_rule_index(struct ocelot_acl_block *block, int index)
 	return NULL;
 }
 
-int ocelot_ace_rule_offload_add(struct ocelot_ace_rule *rule)
+int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
+				struct ocelot_ace_rule *rule)
 {
+	struct ocelot_acl_block *block = &ocelot->acl_block;
 	struct ocelot_ace_rule *ace;
 	int i, index;
 
 	/* Add rule to the linked list */
-	ocelot_ace_rule_add(acl_block, rule);
+	ocelot_ace_rule_add(block, rule);
 
 	/* Get the index of the inserted rule */
-	index = ocelot_ace_rule_get_index_id(acl_block, rule);
+	index = ocelot_ace_rule_get_index_id(block, rule);
 
 	/* Move down the rules to make place for the new rule */
-	for (i = acl_block->count - 1; i > index; i--) {
-		ace = ocelot_ace_rule_get_rule_index(acl_block, i);
-		is2_entry_set(rule->ocelot, i, ace);
+	for (i = block->count - 1; i > index; i--) {
+		ace = ocelot_ace_rule_get_rule_index(block, i);
+		is2_entry_set(ocelot, i, ace);
 	}
 
 	/* Now insert the new rule */
-	is2_entry_set(rule->ocelot, index, rule);
+	is2_entry_set(ocelot, index, rule);
 	return 0;
 }
 
@@ -680,8 +680,10 @@ static void ocelot_ace_rule_del(struct ocelot_acl_block *block,
 	block->count--;
 }
 
-int ocelot_ace_rule_offload_del(struct ocelot_ace_rule *rule)
+int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
+				struct ocelot_ace_rule *rule)
 {
+	struct ocelot_acl_block *block = &ocelot->acl_block;
 	struct ocelot_ace_rule del_ace;
 	struct ocelot_ace_rule *ace;
 	int i, index;
@@ -689,59 +691,41 @@ int ocelot_ace_rule_offload_del(struct ocelot_ace_rule *rule)
 	memset(&del_ace, 0, sizeof(del_ace));
 
 	/* Gets index of the rule */
-	index = ocelot_ace_rule_get_index_id(acl_block, rule);
+	index = ocelot_ace_rule_get_index_id(block, rule);
 
 	/* Delete rule */
-	ocelot_ace_rule_del(acl_block, rule);
+	ocelot_ace_rule_del(block, rule);
 
 	/* Move up all the blocks over the deleted rule */
-	for (i = index; i < acl_block->count; i++) {
-		ace = ocelot_ace_rule_get_rule_index(acl_block, i);
-		is2_entry_set(rule->ocelot, i, ace);
+	for (i = index; i < block->count; i++) {
+		ace = ocelot_ace_rule_get_rule_index(block, i);
+		is2_entry_set(ocelot, i, ace);
 	}
 
 	/* Now delete the last rule, because it is duplicated */
-	is2_entry_set(rule->ocelot, acl_block->count, &del_ace);
+	is2_entry_set(ocelot, block->count, &del_ace);
 
 	return 0;
 }
 
-int ocelot_ace_rule_stats_update(struct ocelot_ace_rule *rule)
+int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
+				 struct ocelot_ace_rule *rule)
 {
+	struct ocelot_acl_block *block = &ocelot->acl_block;
 	struct ocelot_ace_rule *tmp;
 	int index;
 
-	index = ocelot_ace_rule_get_index_id(acl_block, rule);
-	is2_entry_get(rule, index);
+	index = ocelot_ace_rule_get_index_id(block, rule);
+	is2_entry_get(ocelot, rule, index);
 
 	/* After we get the result we need to clear the counters */
-	tmp = ocelot_ace_rule_get_rule_index(acl_block, index);
+	tmp = ocelot_ace_rule_get_rule_index(block, index);
 	tmp->stats.pkts = 0;
-	is2_entry_set(rule->ocelot, index, tmp);
+	is2_entry_set(ocelot, index, tmp);
 
 	return 0;
 }
 
-static struct ocelot_acl_block *ocelot_acl_block_create(struct ocelot *ocelot)
-{
-	struct ocelot_acl_block *block;
-
-	block = kzalloc(sizeof(*block), GFP_KERNEL);
-	if (!block)
-		return NULL;
-
-	INIT_LIST_HEAD(&block->rules);
-	block->count = 0;
-	block->ocelot = ocelot;
-
-	return block;
-}
-
-static void ocelot_acl_block_destroy(struct ocelot_acl_block *block)
-{
-	kfree(block);
-}
-
 int ocelot_ace_init(struct ocelot *ocelot)
 {
 	struct vcap_data data;
@@ -771,12 +755,7 @@ int ocelot_ace_init(struct ocelot *ocelot)
 	ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_CIR_STATE,
 			 OCELOT_POLICER_DISCARD);
 
-	acl_block = ocelot_acl_block_create(ocelot);
+	INIT_LIST_HEAD(&ocelot->acl_block.rules);
 
 	return 0;
 }
-
-void ocelot_ace_deinit(void)
-{
-	ocelot_acl_block_destroy(acl_block);
-}
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index 2927ac83741b..b9a5868e3f15 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -186,7 +186,6 @@ struct ocelot_ace_stats {
 
 struct ocelot_ace_rule {
 	struct list_head list;
-	struct ocelot *ocelot;
 
 	u16 prio;
 	u32 id;
@@ -211,22 +210,17 @@ struct ocelot_ace_rule {
 	} frame;
 };
 
-struct ocelot_acl_block {
-	struct list_head rules;
-	struct ocelot *ocelot;
-	int count;
-};
-
-int ocelot_ace_rule_offload_add(struct ocelot_ace_rule *rule);
-int ocelot_ace_rule_offload_del(struct ocelot_ace_rule *rule);
-int ocelot_ace_rule_stats_update(struct ocelot_ace_rule *rule);
+int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
+				struct ocelot_ace_rule *rule);
+int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
+				struct ocelot_ace_rule *rule);
+int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
+				 struct ocelot_ace_rule *rule);
 
 int ocelot_ace_init(struct ocelot *ocelot);
-void ocelot_ace_deinit(void);
 
-int ocelot_setup_tc_block_flower_bind(struct ocelot_port_private *priv,
-				      struct flow_block_offload *f);
-void ocelot_setup_tc_block_flower_unbind(struct ocelot_port_private *priv,
-					 struct flow_block_offload *f);
+int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
+			       struct flow_cls_offload *f,
+			       bool ingress);
 
 #endif /* _MSCC_OCELOT_ACE_H_ */
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ffd2bb50cfc3..b9673df6dbc5 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -8,11 +8,6 @@
 
 #include "ocelot_ace.h"
 
-struct ocelot_port_block {
-	struct ocelot_acl_block *block;
-	struct ocelot_port_private *priv;
-};
-
 static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 				      struct ocelot_ace_rule *rule)
 {
@@ -168,8 +163,8 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 }
 
 static
-struct ocelot_ace_rule *ocelot_ace_rule_create(struct flow_cls_offload *f,
-					       struct ocelot_port_block *block)
+struct ocelot_ace_rule *ocelot_ace_rule_create(struct ocelot *ocelot, int port,
+					       struct flow_cls_offload *f)
 {
 	struct ocelot_ace_rule *rule;
 
@@ -177,18 +172,17 @@ struct ocelot_ace_rule *ocelot_ace_rule_create(struct flow_cls_offload *f,
 	if (!rule)
 		return NULL;
 
-	rule->ocelot = block->priv->port.ocelot;
-	rule->ingress_port_mask = BIT(block->priv->chip_port);
+	rule->ingress_port_mask = BIT(port);
 	return rule;
 }
 
-static int ocelot_flower_replace(struct flow_cls_offload *f,
-				 struct ocelot_port_block *port_block)
+int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
+			      struct flow_cls_offload *f, bool ingress)
 {
 	struct ocelot_ace_rule *rule;
 	int ret;
 
-	rule = ocelot_ace_rule_create(f, port_block);
+	rule = ocelot_ace_rule_create(ocelot, port, f);
 	if (!rule)
 		return -ENOMEM;
 
@@ -198,159 +192,66 @@ static int ocelot_flower_replace(struct flow_cls_offload *f,
 		return ret;
 	}
 
-	ret = ocelot_ace_rule_offload_add(rule);
+	ret = ocelot_ace_rule_offload_add(ocelot, rule);
 	if (ret)
 		return ret;
 
-	port_block->priv->tc.offload_cnt++;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 
-static int ocelot_flower_destroy(struct flow_cls_offload *f,
-				 struct ocelot_port_block *port_block)
+int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
+			      struct flow_cls_offload *f, bool ingress)
 {
 	struct ocelot_ace_rule rule;
 	int ret;
 
 	rule.prio = f->common.prio;
-	rule.ocelot = port_block->priv->port.ocelot;
 	rule.id = f->cookie;
 
-	ret = ocelot_ace_rule_offload_del(&rule);
+	ret = ocelot_ace_rule_offload_del(ocelot, &rule);
 	if (ret)
 		return ret;
 
-	port_block->priv->tc.offload_cnt--;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
 
-static int ocelot_flower_stats_update(struct flow_cls_offload *f,
-				      struct ocelot_port_block *port_block)
+int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
+			    struct flow_cls_offload *f, bool ingress)
 {
 	struct ocelot_ace_rule rule;
 	int ret;
 
 	rule.prio = f->common.prio;
-	rule.ocelot = port_block->priv->port.ocelot;
 	rule.id = f->cookie;
-	ret = ocelot_ace_rule_stats_update(&rule);
+	ret = ocelot_ace_rule_stats_update(ocelot, &rule);
 	if (ret)
 		return ret;
 
 	flow_stats_update(&f->stats, 0x0, rule.stats.pkts, 0x0);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ocelot_cls_flower_stats);
 
-static int ocelot_setup_tc_cls_flower(struct flow_cls_offload *f,
-				      struct ocelot_port_block *port_block)
+int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
+			       struct flow_cls_offload *f,
+			       bool ingress)
 {
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	if (!ingress)
+		return -EOPNOTSUPP;
+
 	switch (f->command) {
 	case FLOW_CLS_REPLACE:
-		return ocelot_flower_replace(f, port_block);
+		return ocelot_cls_flower_replace(ocelot, port, f, ingress);
 	case FLOW_CLS_DESTROY:
-		return ocelot_flower_destroy(f, port_block);
+		return ocelot_cls_flower_destroy(ocelot, port, f, ingress);
 	case FLOW_CLS_STATS:
-		return ocelot_flower_stats_update(f, port_block);
+		return ocelot_cls_flower_stats(ocelot, port, f, ingress);
 	default:
 		return -EOPNOTSUPP;
 	}
 }
-
-static int ocelot_setup_tc_block_cb_flower(enum tc_setup_type type,
-					   void *type_data, void *cb_priv)
-{
-	struct ocelot_port_block *port_block = cb_priv;
-
-	if (!tc_cls_can_offload_and_chain0(port_block->priv->dev, type_data))
-		return -EOPNOTSUPP;
-
-	switch (type) {
-	case TC_SETUP_CLSFLOWER:
-		return ocelot_setup_tc_cls_flower(type_data, cb_priv);
-	case TC_SETUP_CLSMATCHALL:
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static struct ocelot_port_block*
-ocelot_port_block_create(struct ocelot_port_private *priv)
-{
-	struct ocelot_port_block *port_block;
-
-	port_block = kzalloc(sizeof(*port_block), GFP_KERNEL);
-	if (!port_block)
-		return NULL;
-
-	port_block->priv = priv;
-
-	return port_block;
-}
-
-static void ocelot_port_block_destroy(struct ocelot_port_block *block)
-{
-	kfree(block);
-}
-
-static void ocelot_tc_block_unbind(void *cb_priv)
-{
-	struct ocelot_port_block *port_block = cb_priv;
-
-	ocelot_port_block_destroy(port_block);
-}
-
-int ocelot_setup_tc_block_flower_bind(struct ocelot_port_private *priv,
-				      struct flow_block_offload *f)
-{
-	struct ocelot_port_block *port_block;
-	struct flow_block_cb *block_cb;
-	int ret;
-
-	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
-		return -EOPNOTSUPP;
-
-	block_cb = flow_block_cb_lookup(f->block,
-					ocelot_setup_tc_block_cb_flower, priv);
-	if (!block_cb) {
-		port_block = ocelot_port_block_create(priv);
-		if (!port_block)
-			return -ENOMEM;
-
-		block_cb = flow_block_cb_alloc(ocelot_setup_tc_block_cb_flower,
-					       priv, port_block,
-					       ocelot_tc_block_unbind);
-		if (IS_ERR(block_cb)) {
-			ret = PTR_ERR(block_cb);
-			goto err_cb_register;
-		}
-		flow_block_cb_add(block_cb, f);
-		list_add_tail(&block_cb->driver_list, f->driver_block_list);
-	} else {
-		port_block = flow_block_cb_priv(block_cb);
-	}
-
-	flow_block_cb_incref(block_cb);
-	return 0;
-
-err_cb_register:
-	ocelot_port_block_destroy(port_block);
-
-	return ret;
-}
-
-void ocelot_setup_tc_block_flower_unbind(struct ocelot_port_private *priv,
-					 struct flow_block_offload *f)
-{
-	struct flow_block_cb *block_cb;
-
-	block_cb = flow_block_cb_lookup(f->block,
-					ocelot_setup_tc_block_cb_flower, priv);
-	if (!block_cb)
-		return;
-
-	if (!flow_block_cb_decref(block_cb)) {
-		flow_block_cb_remove(block_cb, f);
-		list_del(&block_cb->driver_list);
-	}
-}
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index a4f7fbd76507..3ff5ef41eccf 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -20,9 +20,6 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 	int port = priv->chip_port;
 	int err;
 
-	netdev_dbg(priv->dev, "%s: port %u command %d cookie %lu\n",
-		   __func__, port, f->command, f->cookie);
-
 	if (!ingress) {
 		NL_SET_ERR_MSG_MOD(extack, "Only ingress is supported");
 		return -EOPNOTSUPP;
@@ -99,17 +96,10 @@ static int ocelot_setup_tc_block_cb(enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_CLSMATCHALL:
-		netdev_dbg(priv->dev, "tc_block_cb: TC_SETUP_CLSMATCHALL %s\n",
-			   ingress ? "ingress" : "egress");
-
 		return ocelot_setup_tc_cls_matchall(priv, type_data, ingress);
 	case TC_SETUP_CLSFLOWER:
-		return 0;
+		return ocelot_setup_tc_cls_flower(priv, type_data, ingress);
 	default:
-		netdev_dbg(priv->dev, "tc_block_cb: type %d %s\n",
-			   type,
-			   ingress ? "ingress" : "egress");
-
 		return -EOPNOTSUPP;
 	}
 }
@@ -137,10 +127,6 @@ static int ocelot_setup_tc_block(struct ocelot_port_private *priv,
 {
 	struct flow_block_cb *block_cb;
 	flow_setup_cb_t *cb;
-	int err;
-
-	netdev_dbg(priv->dev, "tc_block command %d, binder_type %d\n",
-		   f->command, f->binder_type);
 
 	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
 		cb = ocelot_setup_tc_block_cb_ig;
@@ -162,11 +148,6 @@ static int ocelot_setup_tc_block(struct ocelot_port_private *priv,
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
-		err = ocelot_setup_tc_block_flower_bind(priv, f);
-		if (err < 0) {
-			flow_block_cb_free(block_cb);
-			return err;
-		}
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, f->driver_block_list);
 		return 0;
@@ -175,7 +156,6 @@ static int ocelot_setup_tc_block(struct ocelot_port_private *priv,
 		if (!block_cb)
 			return -ENOENT;
 
-		ocelot_setup_tc_block_flower_unbind(priv, f);
 		flow_block_cb_remove(block_cb, f);
 		list_del(&block_cb->driver_list);
 		return 0;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 068f96b1a83e..74e7c63adad4 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -406,6 +406,11 @@ struct ocelot_ops {
 	int (*reset)(struct ocelot *ocelot);
 };
 
+struct ocelot_acl_block {
+	struct list_head rules;
+	int count;
+};
+
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
@@ -455,6 +460,8 @@ struct ocelot {
 
 	struct list_head		multicast;
 
+	struct ocelot_acl_block		acl_block;
+
 	/* Workqueue to check statistics for overflow with its lock */
 	struct mutex			stats_lock;
 	u64				*stats;
-- 
2.17.1

