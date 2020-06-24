Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E6A2074FC
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 15:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403975AbgFXNzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 09:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389668AbgFXNzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 09:55:35 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8716C061795
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:55:34 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dr13so2558068ejc.3
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w21Ci23CzG+7l6gb+G7nmL1UxVOCUnR9PJd6YmazRAc=;
        b=eed7xBuhblsVioAi9cz5jeRfUyaWbGiTi6hIKOI3I9PL4PBXZ3YZmZ5L7iXP6ejPFI
         xrDQiUmwk6CbOWynhIDsd2axsFCKyzEMHydgxnecq2N95Rhce2whf0VdVUBxI7ICM3WN
         UsoAmNiz6Hr8X1I0pCnuGRh7BOZCe9OE2wu4AgpqcOBPrsuto8odpBF7AYhNknjIp3zM
         3PWfmhyMrunXM3syDmYWSdZ4FmIadxAPZ2PBEwI6vrnGuOMI5ejKKVHLil8P002/2Exd
         cwEnfAnLdt40IGbXARYFmwDrN4bzr+ZS58i1zqvdb1hsuNHxAeBTyX0NzbCRESWxgWWk
         xoFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w21Ci23CzG+7l6gb+G7nmL1UxVOCUnR9PJd6YmazRAc=;
        b=Hb0iaXD2vS8y6xqeMEq5FU7E2icHOCxRL2K+uCoczX2LXOhSOVMkrDiSIIPXoDk5dS
         dwQLkyIow2ER9XKI/5io05iZlN3wE3yFk281/hvliMCDceOi6sbEEKySzYZyCkZC5Uvj
         xD5tLATvYa70bCgYXQ9t757FOwBTD1LkEbBPDYfZ2GpUxIW9rmonFXAm5S6cnXd4F0L+
         DEOKG5K5CAC1QAzNUuHZc3nKnqFxS9HPJCP9xS8WWAYJ++0Ub+yOJtjLiyIFeoiP6wt6
         cwztZSPxjAXKury4Ngp27KX5I6ifQxx2QjE5dH0yi8Ut+LFGv4s1OWqxSwuaP/NUzVd9
         Pddg==
X-Gm-Message-State: AOAM532p4Tp2gb0/CYYfUQERxsZGssfL8/ohdc9kDEhk7Rffel+ePJKL
        al5sjERWLKZy7tftMAuuidSoRe2R
X-Google-Smtp-Source: ABdhPJzo+ZgEsunV+6XEoamD7OsG6wSRuGJRJxu7nBoZLLpQvCl/t2rzk32O53SLY0Vah2kcFAzF9g==
X-Received: by 2002:a17:906:971a:: with SMTP id k26mr23663708ejx.230.1593006933364;
        Wed, 24 Jun 2020 06:55:33 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id j5sm17756649edk.53.2020.06.24.06.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 06:55:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        po.liu@nxp.com, xiaoliang.yang_1@nxp.com, kuba@kernel.org
Subject: [PATCH net 1/4] net: dsa: sja1105: move sja1105_compose_gating_subschedule at the top
Date:   Wed, 24 Jun 2020 16:54:44 +0300
Message-Id: <20200624135447.3261002-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624135447.3261002-1-olteanv@gmail.com>
References: <20200624135447.3261002-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It turns out that sja1105_compose_gating_subschedule must also be called
from sja1105_vl_delete, to recalculate the overall tc-gate
configuration. Currently this is not possible without introducing a
forward declaration. So move the function at the top of the file, along
with its dependencies.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 320 +++++++++++++--------------
 1 file changed, 160 insertions(+), 160 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index 0a33c397d833..2b7966714e55 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -7,6 +7,166 @@
 
 #define SJA1105_SIZE_VL_STATUS			8
 
+/* Insert into the global gate list, sorted by gate action time. */
+static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
+				     struct sja1105_rule *rule,
+				     u8 gate_state, s64 entry_time,
+				     struct netlink_ext_ack *extack)
+{
+	struct sja1105_gate_entry *e;
+	int rc;
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+
+	e->rule = rule;
+	e->gate_state = gate_state;
+	e->interval = entry_time;
+
+	if (list_empty(&gating_cfg->entries)) {
+		list_add(&e->list, &gating_cfg->entries);
+	} else {
+		struct sja1105_gate_entry *p;
+
+		list_for_each_entry(p, &gating_cfg->entries, list) {
+			if (p->interval == e->interval) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Gate conflict");
+				rc = -EBUSY;
+				goto err;
+			}
+
+			if (e->interval < p->interval)
+				break;
+		}
+		list_add(&e->list, p->list.prev);
+	}
+
+	gating_cfg->num_entries++;
+
+	return 0;
+err:
+	kfree(e);
+	return rc;
+}
+
+/* The gate entries contain absolute times in their e->interval field. Convert
+ * that to proper intervals (i.e. "0, 5, 10, 15" to "5, 5, 5, 5").
+ */
+static void
+sja1105_gating_cfg_time_to_interval(struct sja1105_gating_config *gating_cfg,
+				    u64 cycle_time)
+{
+	struct sja1105_gate_entry *last_e;
+	struct sja1105_gate_entry *e;
+	struct list_head *prev;
+
+	list_for_each_entry(e, &gating_cfg->entries, list) {
+		struct sja1105_gate_entry *p;
+
+		prev = e->list.prev;
+
+		if (prev == &gating_cfg->entries)
+			continue;
+
+		p = list_entry(prev, struct sja1105_gate_entry, list);
+		p->interval = e->interval - p->interval;
+	}
+	last_e = list_last_entry(&gating_cfg->entries,
+				 struct sja1105_gate_entry, list);
+	if (last_e->list.prev != &gating_cfg->entries)
+		last_e->interval = cycle_time - last_e->interval;
+}
+
+static void sja1105_free_gating_config(struct sja1105_gating_config *gating_cfg)
+{
+	struct sja1105_gate_entry *e, *n;
+
+	list_for_each_entry_safe(e, n, &gating_cfg->entries, list) {
+		list_del(&e->list);
+		kfree(e);
+	}
+}
+
+static int sja1105_compose_gating_subschedule(struct sja1105_private *priv,
+					      struct netlink_ext_ack *extack)
+{
+	struct sja1105_gating_config *gating_cfg = &priv->tas_data.gating_cfg;
+	struct sja1105_rule *rule;
+	s64 max_cycle_time = 0;
+	s64 its_base_time = 0;
+	int i, rc = 0;
+
+	list_for_each_entry(rule, &priv->flow_block.rules, list) {
+		if (rule->type != SJA1105_RULE_VL)
+			continue;
+		if (rule->vl.type != SJA1105_VL_TIME_TRIGGERED)
+			continue;
+
+		if (max_cycle_time < rule->vl.cycle_time) {
+			max_cycle_time = rule->vl.cycle_time;
+			its_base_time = rule->vl.base_time;
+		}
+	}
+
+	if (!max_cycle_time)
+		return 0;
+
+	dev_dbg(priv->ds->dev, "max_cycle_time %lld its_base_time %lld\n",
+		max_cycle_time, its_base_time);
+
+	sja1105_free_gating_config(gating_cfg);
+
+	gating_cfg->base_time = its_base_time;
+	gating_cfg->cycle_time = max_cycle_time;
+	gating_cfg->num_entries = 0;
+
+	list_for_each_entry(rule, &priv->flow_block.rules, list) {
+		s64 time;
+		s64 rbt;
+
+		if (rule->type != SJA1105_RULE_VL)
+			continue;
+		if (rule->vl.type != SJA1105_VL_TIME_TRIGGERED)
+			continue;
+
+		/* Calculate the difference between this gating schedule's
+		 * base time, and the base time of the gating schedule with the
+		 * longest cycle time. We call it the relative base time (rbt).
+		 */
+		rbt = future_base_time(rule->vl.base_time, rule->vl.cycle_time,
+				       its_base_time);
+		rbt -= its_base_time;
+
+		time = rbt;
+
+		for (i = 0; i < rule->vl.num_entries; i++) {
+			u8 gate_state = rule->vl.entries[i].gate_state;
+			s64 entry_time = time;
+
+			while (entry_time < max_cycle_time) {
+				rc = sja1105_insert_gate_entry(gating_cfg, rule,
+							       gate_state,
+							       entry_time,
+							       extack);
+				if (rc)
+					goto err;
+
+				entry_time += rule->vl.cycle_time;
+			}
+			time += rule->vl.entries[i].interval;
+		}
+	}
+
+	sja1105_gating_cfg_time_to_interval(gating_cfg, max_cycle_time);
+
+	return 0;
+err:
+	sja1105_free_gating_config(gating_cfg);
+	return rc;
+}
+
 /* The switch flow classification core implements TTEthernet, which 'thinks' in
  * terms of Virtual Links (VL), a concept borrowed from ARINC 664 part 7.
  * However it also has one other operating mode (VLLUPFORMAT=0) where it acts
@@ -397,166 +557,6 @@ int sja1105_vl_delete(struct sja1105_private *priv, int port,
 	return sja1105_static_config_reload(priv, SJA1105_VIRTUAL_LINKS);
 }
 
-/* Insert into the global gate list, sorted by gate action time. */
-static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
-				     struct sja1105_rule *rule,
-				     u8 gate_state, s64 entry_time,
-				     struct netlink_ext_ack *extack)
-{
-	struct sja1105_gate_entry *e;
-	int rc;
-
-	e = kzalloc(sizeof(*e), GFP_KERNEL);
-	if (!e)
-		return -ENOMEM;
-
-	e->rule = rule;
-	e->gate_state = gate_state;
-	e->interval = entry_time;
-
-	if (list_empty(&gating_cfg->entries)) {
-		list_add(&e->list, &gating_cfg->entries);
-	} else {
-		struct sja1105_gate_entry *p;
-
-		list_for_each_entry(p, &gating_cfg->entries, list) {
-			if (p->interval == e->interval) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Gate conflict");
-				rc = -EBUSY;
-				goto err;
-			}
-
-			if (e->interval < p->interval)
-				break;
-		}
-		list_add(&e->list, p->list.prev);
-	}
-
-	gating_cfg->num_entries++;
-
-	return 0;
-err:
-	kfree(e);
-	return rc;
-}
-
-/* The gate entries contain absolute times in their e->interval field. Convert
- * that to proper intervals (i.e. "0, 5, 10, 15" to "5, 5, 5, 5").
- */
-static void
-sja1105_gating_cfg_time_to_interval(struct sja1105_gating_config *gating_cfg,
-				    u64 cycle_time)
-{
-	struct sja1105_gate_entry *last_e;
-	struct sja1105_gate_entry *e;
-	struct list_head *prev;
-
-	list_for_each_entry(e, &gating_cfg->entries, list) {
-		struct sja1105_gate_entry *p;
-
-		prev = e->list.prev;
-
-		if (prev == &gating_cfg->entries)
-			continue;
-
-		p = list_entry(prev, struct sja1105_gate_entry, list);
-		p->interval = e->interval - p->interval;
-	}
-	last_e = list_last_entry(&gating_cfg->entries,
-				 struct sja1105_gate_entry, list);
-	if (last_e->list.prev != &gating_cfg->entries)
-		last_e->interval = cycle_time - last_e->interval;
-}
-
-static void sja1105_free_gating_config(struct sja1105_gating_config *gating_cfg)
-{
-	struct sja1105_gate_entry *e, *n;
-
-	list_for_each_entry_safe(e, n, &gating_cfg->entries, list) {
-		list_del(&e->list);
-		kfree(e);
-	}
-}
-
-static int sja1105_compose_gating_subschedule(struct sja1105_private *priv,
-					      struct netlink_ext_ack *extack)
-{
-	struct sja1105_gating_config *gating_cfg = &priv->tas_data.gating_cfg;
-	struct sja1105_rule *rule;
-	s64 max_cycle_time = 0;
-	s64 its_base_time = 0;
-	int i, rc = 0;
-
-	list_for_each_entry(rule, &priv->flow_block.rules, list) {
-		if (rule->type != SJA1105_RULE_VL)
-			continue;
-		if (rule->vl.type != SJA1105_VL_TIME_TRIGGERED)
-			continue;
-
-		if (max_cycle_time < rule->vl.cycle_time) {
-			max_cycle_time = rule->vl.cycle_time;
-			its_base_time = rule->vl.base_time;
-		}
-	}
-
-	if (!max_cycle_time)
-		return 0;
-
-	dev_dbg(priv->ds->dev, "max_cycle_time %lld its_base_time %lld\n",
-		max_cycle_time, its_base_time);
-
-	sja1105_free_gating_config(gating_cfg);
-
-	gating_cfg->base_time = its_base_time;
-	gating_cfg->cycle_time = max_cycle_time;
-	gating_cfg->num_entries = 0;
-
-	list_for_each_entry(rule, &priv->flow_block.rules, list) {
-		s64 time;
-		s64 rbt;
-
-		if (rule->type != SJA1105_RULE_VL)
-			continue;
-		if (rule->vl.type != SJA1105_VL_TIME_TRIGGERED)
-			continue;
-
-		/* Calculate the difference between this gating schedule's
-		 * base time, and the base time of the gating schedule with the
-		 * longest cycle time. We call it the relative base time (rbt).
-		 */
-		rbt = future_base_time(rule->vl.base_time, rule->vl.cycle_time,
-				       its_base_time);
-		rbt -= its_base_time;
-
-		time = rbt;
-
-		for (i = 0; i < rule->vl.num_entries; i++) {
-			u8 gate_state = rule->vl.entries[i].gate_state;
-			s64 entry_time = time;
-
-			while (entry_time < max_cycle_time) {
-				rc = sja1105_insert_gate_entry(gating_cfg, rule,
-							       gate_state,
-							       entry_time,
-							       extack);
-				if (rc)
-					goto err;
-
-				entry_time += rule->vl.cycle_time;
-			}
-			time += rule->vl.entries[i].interval;
-		}
-	}
-
-	sja1105_gating_cfg_time_to_interval(gating_cfg, max_cycle_time);
-
-	return 0;
-err:
-	sja1105_free_gating_config(gating_cfg);
-	return rc;
-}
-
 int sja1105_vl_gate(struct sja1105_private *priv, int port,
 		    struct netlink_ext_ack *extack, unsigned long cookie,
 		    struct sja1105_key *key, u32 index, s32 prio,
-- 
2.25.1

