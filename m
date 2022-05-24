Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9CE532D41
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiEXPWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiEXPWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:22:12 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E1F49682;
        Tue, 24 May 2022 08:22:10 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id bu29so31462106lfb.0;
        Tue, 24 May 2022 08:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=RXPfkzVJC0TXREVL3rRRxcfjNI7g0vB41N9cqX795jY=;
        b=i+JlVM2Bxlso3CAM/J1gAIYfsNRnHE1FJyJ2Xj1F/P12vheUpc1YBtDDkkoHSZPrTY
         ibacuC5bLO2bOVN/cywIPM8S2ocQG7lT1/yxEFxwbGtl5PWhraSSzOUy7+JU7Wg0/Efq
         mFd4ytPFLItoJqlM42TphDn3WWV9Tn/UyWq8HLF0Euk/cwG4FDzg+zV/VO9ORD1FAclX
         Otv91VcjwlQhukcMcwyR/w8C3ctXnBPcQwU8gLjKV7D1MwAOijYHdAcs09dOsfwbdzHk
         OGQKnBx3LinaBa3Z8rEvit+DTSsCHZRZac+WMhuynGw2Cd6AZH85gt5xu+aUAJryM+JO
         KRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=RXPfkzVJC0TXREVL3rRRxcfjNI7g0vB41N9cqX795jY=;
        b=LYustxoy6gUyXPSeYFBVgCmD3QCWN5hw8XvYqD6qq/9Tbxjenw2O6Fs/PeQPk0cGC8
         4zMcndSfTQOyzYL45YhzFsSk2OlJQIQd9m5qQk5GFDj9L/KkTbvlxhnqgXAPvXfLT+T/
         t6HyiGceUZbyNLUgODdzLEkmsEkrB6hJkHiGvY/33A2m11AJ0u0fSD0Lkudakmkv+mWg
         M53sz7kG14vHG8D4JHezWb43QIuVH1uXPVzZO2CkeZh7MN6u/l10boGfTJgY48sdxRmH
         j0HjQ0ozEsRf1pUCLqStpzQZLJ2EPh/gpxkIDMtGXAuHPSMNJIDG5G96JUqF5AVO1/S1
         sGkQ==
X-Gm-Message-State: AOAM53102uMZsnrl+bBeAF1neujBHHTGALj+mtcjegMVhm59vn1qRWmu
        /7uluELJpeGOBQsH8NbAMdY=
X-Google-Smtp-Source: ABdhPJyOvEGvinpEJQZkzvULkTUkQIIzrd4+78AEL21c5i1z5BTrb/nqGLyN1qypZGneVeUzxVIRyA==
X-Received: by 2002:ac2:550f:0:b0:477:bc6e:9bcc with SMTP id j15-20020ac2550f000000b00477bc6e9bccmr19981896lfk.279.1653405728291;
        Tue, 24 May 2022 08:22:08 -0700 (PDT)
Received: from wse-c0127.westermo.com (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id d22-20020a2e3316000000b00253deeaeb3dsm2441404ljc.131.2022.05.24.08.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 08:22:08 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH V3 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB implementation
Date:   Tue, 24 May 2022 17:21:43 +0200
Message-Id: <20220524152144.40527-4-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implementation for the Marvell mv88e6xxx chip series, is
based on handling ATU miss violations occurring when packets
ingress on a port that is locked. The mac address triggering
the ATU miss violation is communicated through switchdev to
the bridge module, which adds a fdb entry with the fdb locked
flag set. The entry is kept according to the bridges ageing
time, thus simulating a dynamic entry.

Note: The locked port must have learning enabled for the ATU
miss violation to occur.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/Makefile            |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c              |  40 ++-
 drivers/net/dsa/mv88e6xxx/chip.h              |   5 +
 drivers/net/dsa/mv88e6xxx/global1.h           |   1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       |  35 ++-
 .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c   | 249 ++++++++++++++++++
 .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h   |  40 +++
 drivers/net/dsa/mv88e6xxx/port.c              |  32 ++-
 drivers/net/dsa/mv88e6xxx/port.h              |   2 +
 9 files changed, 389 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index c8eca2b6f959..3ca57709730d 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -15,3 +15,4 @@ mv88e6xxx-objs += port_hidden.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
 mv88e6xxx-objs += serdes.o
 mv88e6xxx-objs += smi.o
+mv88e6xxx-objs += mv88e6xxx_switchdev.o
\ No newline at end of file
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5d2c57a7c708..f7a16886bee9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -42,6 +42,7 @@
 #include "ptp.h"
 #include "serdes.h"
 #include "smi.h"
+#include "mv88e6xxx_switchdev.h"
 
 static void assert_reg_lock(struct mv88e6xxx_chip *chip)
 {
@@ -919,6 +920,9 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
 	if (err)
 		dev_err(chip->dev,
 			"p%d: failed to force MAC link down\n", port);
+	else
+		if (mv88e6xxx_port_is_locked(chip, port, true))
+			mv88e6xxx_atu_locked_entry_flush(ds, port);
 }
 
 static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
@@ -1685,6 +1689,9 @@ static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	if (mv88e6xxx_port_is_locked(chip, port, true))
+		mv88e6xxx_atu_locked_entry_flush(ds, port);
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_fast_age_fid(chip, port, 0);
 	mv88e6xxx_reg_unlock(chip);
@@ -1721,11 +1728,11 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
 	return err;
 }
 
-static int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
-			      int (*cb)(struct mv88e6xxx_chip *chip,
-					const struct mv88e6xxx_vtu_entry *entry,
-					void *priv),
-			      void *priv)
+int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
+		       int (*cb)(struct mv88e6xxx_chip *chip,
+				 const struct mv88e6xxx_vtu_entry *entry,
+				 void *priv),
+		       void *priv)
 {
 	struct mv88e6xxx_vtu_entry entry = {
 		.vid = mv88e6xxx_max_vid(chip),
@@ -2722,9 +2729,12 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	if (mv88e6xxx_port_is_locked(chip, port, true))
+		mv88e6xxx_atu_locked_entry_find_purge(ds, port, addr, vid);
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid,
-					   MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC);
+			MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC);
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -2735,12 +2745,17 @@ static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
 				  struct dsa_db db)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	bool locked_found = false;
 	int err;
 
-	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid, 0);
-	mv88e6xxx_reg_unlock(chip);
+	if (mv88e6xxx_port_is_locked(chip, port, true))
+		locked_found = mv88e6xxx_atu_locked_entry_find_purge(ds, port, addr, vid);
 
+	if (!locked_found) {
+		mv88e6xxx_reg_lock(chip);
+		err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid, 0);
+		mv88e6xxx_reg_unlock(chip);
+	}
 	return err;
 }
 
@@ -3809,11 +3824,16 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 static int mv88e6xxx_port_setup(struct dsa_switch *ds, int port)
 {
-	return mv88e6xxx_setup_devlink_regions_port(ds, port);
+	int err;
+
+	err = mv88e6xxx_setup_devlink_regions_port(ds, port);
+	mv88e6xxx_init_violation_handler(ds, port);
+	return err;
 }
 
 static void mv88e6xxx_port_teardown(struct dsa_switch *ds, int port)
 {
+	mv88e6xxx_teardown_violation_handler(ds, port);
 	mv88e6xxx_teardown_devlink_regions_port(ds, port);
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 5e03cfe50156..c9a8404a6293 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -803,6 +803,11 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
 	mutex_unlock(&chip->reg_lock);
 }
 
+int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
+		       int (*cb)(struct mv88e6xxx_chip *chip,
+				 const struct mv88e6xxx_vtu_entry *entry,
+				 void *priv),
+		       void *priv);
 int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
 
 #endif /* _MV88E6XXX_CHIP_H */
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 65958b2a0d3a..503fbf216670 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -136,6 +136,7 @@
 #define MV88E6XXX_G1_ATU_DATA_TRUNK				0x8000
 #define MV88E6XXX_G1_ATU_DATA_TRUNK_ID_MASK			0x00f0
 #define MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_MASK			0x3ff0
+#define MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_NO_EGRESS		0x0000
 #define MV88E6XXX_G1_ATU_DATA_STATE_MASK			0x000f
 #define MV88E6XXX_G1_ATU_DATA_STATE_UC_UNUSED			0x0000
 #define MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_1_OLDEST		0x0001
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 40bd67a5c8e9..517376271f64 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -12,6 +12,8 @@
 
 #include "chip.h"
 #include "global1.h"
+#include "port.h"
+#include "mv88e6xxx_switchdev.h"
 
 /* Offset 0x01: ATU FID Register */
 
@@ -114,6 +116,18 @@ static int mv88e6xxx_g1_atu_op_wait(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_ATU_OP, bit, 0);
 }
 
+static int mv88e6xxx_g1_read_atu_violation(struct mv88e6xxx_chip *chip)
+{
+	int err;
+
+	err = mv88e6xxx_g1_write(chip, MV88E6XXX_G1_ATU_OP,
+				 MV88E6XXX_G1_ATU_OP_BUSY | MV88E6XXX_G1_ATU_OP_GET_CLR_VIOLATION);
+	if (err)
+		return err;
+
+	return mv88e6xxx_g1_atu_op_wait(chip);
+}
+
 static int mv88e6xxx_g1_atu_op(struct mv88e6xxx_chip *chip, u16 fid, u16 op)
 {
 	u16 val;
@@ -356,11 +370,11 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 	int spid;
 	int err;
 	u16 val;
+	u16 fid;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_g1_atu_op(chip, 0,
-				  MV88E6XXX_G1_ATU_OP_GET_CLR_VIOLATION);
+	err = mv88e6xxx_g1_read_atu_violation(chip);
 	if (err)
 		goto out;
 
@@ -368,6 +382,10 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 	if (err)
 		goto out;
 
+	err = mv88e6xxx_g1_read(chip, MV88E6352_G1_ATU_FID, &fid);
+	if (err)
+		goto out;
+
 	err = mv88e6xxx_g1_atu_data_read(chip, &entry);
 	if (err)
 		goto out;
@@ -382,6 +400,11 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 		dev_err_ratelimited(chip->dev,
 				    "ATU age out violation for %pM\n",
 				    entry.mac);
+		err = mv88e6xxx_handle_violation(chip,
+						 chip->ports[spid].port,
+						 &entry,
+						 fid,
+						 MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION);
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_MEMBER_VIOLATION) {
@@ -396,6 +419,14 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 				    "ATU miss violation for %pM portvec %x spid %d\n",
 				    entry.mac, entry.portvec, spid);
 		chip->ports[spid].atu_miss_violation++;
+		if (mv88e6xxx_port_is_locked(chip, chip->ports[spid].port, false))
+			err = mv88e6xxx_handle_violation(chip,
+							 chip->ports[spid].port,
+							 &entry,
+							 fid,
+							 MV88E6XXX_G1_ATU_OP_MISS_VIOLATION);
+		if (err)
+			goto out;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
diff --git a/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c b/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
new file mode 100644
index 000000000000..8436655ceb9a
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * mv88e6xxx_switchdev.c
+ *
+ *	Authors:
+ *	Hans J. Schultz		<hans.schultz@westermo.com>
+ *
+ */
+
+#include <net/switchdev.h>
+#include <linux/list.h>
+#include "chip.h"
+#include "global1.h"
+#include "mv88e6xxx_switchdev.h"
+
+static void mv88e6xxx_atu_locked_entry_timer_work(struct atu_locked_entry *ale)
+{
+	struct switchdev_notifier_fdb_info info = {
+		.addr = ale->mac,
+		.vid = ale->vid,
+		.added_by_user = false,
+		.is_local = false,
+		.offloaded = true,
+		.locked = true,
+	};
+	struct mv88e6xxx_atu_entry entry;
+	struct net_device *brport;
+	struct dsa_port *dp;
+
+	entry.state = MV88E6XXX_G1_ATU_DATA_STATE_UC_UNUSED;
+	entry.trunk = false;
+	memcpy(&entry.mac, &ale->mac, ETH_ALEN);
+
+	mv88e6xxx_reg_lock(ale->chip);
+	mv88e6xxx_g1_atu_loadpurge(ale->chip, ale->fid, &entry);
+	mv88e6xxx_reg_unlock(ale->chip);
+
+	dp = dsa_to_port(ale->chip->ds, ale->port);
+	brport = dsa_port_to_bridge_port(dp);
+
+	if (brport) {
+		if (!rtnl_is_locked()) {
+			rtnl_lock();
+			call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
+						 brport, &info.info, NULL);
+			rtnl_unlock();
+		} else {
+			call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
+						 brport, &info.info, NULL);
+		}
+	} else {
+		dev_err(ale->chip->dev, "ERR: No bridge port for dsa port belonging to port %d\n",
+			ale->port);
+	}
+}
+
+static inline void mv88e6xxx_atu_locked_entry_purge(struct atu_locked_entry *ale)
+{
+	mv88e6xxx_atu_locked_entry_timer_work(ale);
+	del_timer(&ale->timer);
+	list_del(&ale->list);
+	kfree(ale);
+}
+
+static void mv88e6xxx_atu_locked_entry_cleanup(struct work_struct *work)
+{
+	struct dsa_port *dp = container_of(work, struct dsa_port, atu_work.work);
+	struct atu_locked_entry *ale, *tmp;
+
+	mutex_lock(&dp->locked_entries_list_lock);
+	list_for_each_entry_safe(ale, tmp, &dp->atu_locked_entries_list, list) {
+		if (ale->timed_out) {
+			mv88e6xxx_atu_locked_entry_purge(ale);
+			atomic_dec(&dp->atu_locked_entry_cnt);
+		}
+	}
+	mutex_unlock(&dp->locked_entries_list_lock);
+
+	mod_delayed_work(system_long_wq, &dp->atu_work, msecs_to_jiffies(100));
+}
+
+static void mv88e6xxx_atu_locked_entry_timer_handler(struct timer_list *t)
+{
+	struct atu_locked_entry *ale = from_timer(ale, t, timer);
+
+	if (ale)
+		ale->timed_out = true;
+}
+
+struct mv88e6xxx_fid_search_ctx {
+	u16 fid_search;
+	u16 vid_found;
+};
+
+static int mv88e6xxx_find_vid_on_matching_fid(struct mv88e6xxx_chip *chip,
+					      const struct mv88e6xxx_vtu_entry *entry,
+					      void *priv)
+{
+	struct mv88e6xxx_fid_search_ctx *ctx = priv;
+
+	if (ctx->fid_search == entry->fid) {
+		ctx->vid_found = entry->vid;
+		return 1;
+	}
+
+	return 0;
+}
+
+int mv88e6xxx_handle_violation(struct mv88e6xxx_chip *chip,
+			       int port,
+			       struct mv88e6xxx_atu_entry *entry,
+			       u16 fid,
+			       u16 type)
+{
+	struct switchdev_notifier_fdb_info info = {
+		.addr = entry->mac,
+		.vid = 0,
+		.added_by_user = false,
+		.is_local = false,
+		.offloaded = true,
+		.locked = true,
+	};
+	struct atu_locked_entry *locked_entry;
+	struct mv88e6xxx_fid_search_ctx ctx;
+	struct net_device *brport;
+	struct dsa_port *dp;
+	int err;
+
+	ctx.fid_search = fid;
+	err = mv88e6xxx_vtu_walk(chip, mv88e6xxx_find_vid_on_matching_fid, &ctx);
+	if (err < 0)
+		return err;
+	if (err == 1)
+		info.vid = ctx.vid_found;
+	else
+		return -ENODATA;
+
+	dp = dsa_to_port(chip->ds, port);
+	brport = dsa_port_to_bridge_port(dp);
+
+	if (!brport)
+		return -ENODEV;
+
+	switch (type) {
+	case MV88E6XXX_G1_ATU_OP_MISS_VIOLATION:
+		if (atomic_read(&dp->atu_locked_entry_cnt) >= ATU_LOCKED_ENTRIES_MAX) {
+			mv88e6xxx_reg_unlock(chip);
+			return 0;
+		}
+		entry->portvec = MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_NO_EGRESS;
+		entry->state = MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC;
+		entry->trunk = false;
+		err = mv88e6xxx_g1_atu_loadpurge(chip, fid, entry);
+		if (err)
+			goto fail;
+
+		locked_entry = kmalloc(sizeof(*locked_entry), GFP_ATOMIC);
+		if (!locked_entry)
+			return -ENOMEM;
+		timer_setup(&locked_entry->timer, mv88e6xxx_atu_locked_entry_timer_handler, 0);
+		locked_entry->timer.expires = jiffies + dp->ageing_time / 10;
+		locked_entry->chip = chip;
+		locked_entry->port = port;
+		locked_entry->fid = fid;
+		locked_entry->vid = info.vid;
+		locked_entry->timed_out = false;
+		memcpy(&locked_entry->mac, entry->mac, ETH_ALEN);
+
+		mutex_lock(&dp->locked_entries_list_lock);
+		add_timer(&locked_entry->timer);
+		list_add(&locked_entry->list, &dp->atu_locked_entries_list);
+		mutex_unlock(&dp->locked_entries_list_lock);
+		atomic_inc(&dp->atu_locked_entry_cnt);
+
+		mv88e6xxx_reg_unlock(chip);
+
+		rtnl_lock();
+		err = call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
+					       brport, &info.info, NULL);
+		break;
+	}
+	rtnl_unlock();
+
+	return err;
+
+fail:
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
+bool mv88e6xxx_atu_locked_entry_find_purge(struct dsa_switch *ds, int port,
+					   const unsigned char *addr, u16 vid)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct atu_locked_entry *ale, *tmp;
+	bool found = false;
+
+	mutex_lock(&dp->locked_entries_list_lock);
+	list_for_each_entry_safe(ale, tmp, &dp->atu_locked_entries_list, list) {
+		if (!memcmp(&ale->mac, addr, ETH_ALEN)) {
+			if (ale->vid == vid) {
+				mv88e6xxx_atu_locked_entry_purge(ale);
+				atomic_dec(&dp->atu_locked_entry_cnt);
+				found = true;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&dp->locked_entries_list_lock);
+	return found;
+}
+
+void mv88e6xxx_atu_locked_entry_flush(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct atu_locked_entry *ale, *tmp;
+
+	mutex_lock(&dp->locked_entries_list_lock);
+	list_for_each_entry_safe(ale, tmp, &dp->atu_locked_entries_list, list) {
+		mv88e6xxx_atu_locked_entry_purge(ale);
+		atomic_dec(&dp->atu_locked_entry_cnt);
+	}
+	mutex_unlock(&dp->locked_entries_list_lock);
+
+	if (atomic_read(&dp->atu_locked_entry_cnt) != 0)
+		dev_err(ds->dev,
+			"ERROR: Locked entries count is not zero after flush on port %d\n",
+			port);
+}
+
+void mv88e6xxx_init_violation_handler(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+
+	INIT_LIST_HEAD(&dp->atu_locked_entries_list);
+	mutex_init(&dp->locked_entries_list_lock);
+	dp->atu_locked_entry_cnt.counter = 0;
+	INIT_DELAYED_WORK(&dp->atu_work, mv88e6xxx_atu_locked_entry_cleanup);
+	mod_delayed_work(system_long_wq, &dp->atu_work, msecs_to_jiffies(100));
+}
+
+void mv88e6xxx_teardown_violation_handler(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+
+	cancel_delayed_work(&dp->atu_work);
+	mv88e6xxx_atu_locked_entry_flush(ds, port);
+	mutex_destroy(&dp->locked_entries_list_lock);
+}
diff --git a/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h b/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h
new file mode 100644
index 000000000000..f0e7abf7c361
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * mv88e6xxx_switchdev.h
+ *
+ *	Authors:
+ *	Hans J. Schultz		<hans.schultz@westermo.com>
+ *
+ */
+
+#ifndef DRIVERS_NET_DSA_MV88E6XXX_MV88E6XXX_SWITCHDEV_H_
+#define DRIVERS_NET_DSA_MV88E6XXX_MV88E6XXX_SWITCHDEV_H_
+
+#include <net/switchdev.h>
+#include "chip.h"
+
+#define ATU_LOCKED_ENTRIES_MAX	64
+
+struct atu_locked_entry {
+	struct list_head list;
+	struct mv88e6xxx_chip *chip;
+	int port;
+	u8	mac[ETH_ALEN];
+	u16 fid;
+	u16 vid;
+	struct timer_list timer;
+	bool timed_out;
+};
+
+int mv88e6xxx_handle_violation(struct mv88e6xxx_chip *chip,
+			       int port,
+			       struct mv88e6xxx_atu_entry *entry,
+			       u16 fid,
+			       u16 type);
+bool mv88e6xxx_atu_locked_entry_find_purge(struct dsa_switch *ds, int port,
+					   const unsigned char *addr, u16 vid);
+void mv88e6xxx_atu_locked_entry_flush(struct dsa_switch *ds, int port);
+void mv88e6xxx_init_violation_handler(struct dsa_switch *ds, int port);
+void mv88e6xxx_teardown_violation_handler(struct dsa_switch *ds, int port);
+
+#endif /* DRIVERS_NET_DSA_MV88E6XXX_MV88E6XXX_SWITCHDEV_H_ */
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 795b3128768f..c4e5e7174129 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -14,9 +14,11 @@
 #include <linux/phylink.h>
 
 #include "chip.h"
+#include "global1.h"
 #include "global2.h"
 #include "port.h"
 #include "serdes.h"
+#include "mv88e6xxx_switchdev.h"
 
 int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
 			u16 *val)
@@ -1239,6 +1241,25 @@ int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
 	return err;
 }
 
+bool mv88e6xxx_port_is_locked(struct mv88e6xxx_chip *chip, int port, bool chiplock)
+{
+	bool locked = false;
+	u16 reg;
+
+	if (chiplock)
+		mv88e6xxx_reg_lock(chip);
+
+	if (mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg))
+		goto out;
+	locked = reg & MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK;
+
+out:
+	if (chiplock)
+		mv88e6xxx_reg_unlock(chip);
+
+	return locked;
+}
+
 int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
 			    bool locked)
 {
@@ -1261,10 +1282,13 @@ int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
 	if (err)
 		return err;
 
-	reg &= ~MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
-	if (locked)
-		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
-
+	reg &= MV88E6XXX_PORT_ASSOC_VECTOR_PAV_MASK;
+	if (locked) {
+		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG |
+			MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT |
+			MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT |
+			MV88E6XXX_PORT_ASSOC_VECTOR_HOLD_AT_1;
+	}
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, reg);
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index e0a705d82019..d377abd6ab17 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -231,6 +231,7 @@
 #define MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT		0x2000
 #define MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG	0x1000
 #define MV88E6XXX_PORT_ASSOC_VECTOR_REFRESH_LOCKED	0x0800
+#define MV88E6XXX_PORT_ASSOC_VECTOR_PAV_MASK		0x07ff
 
 /* Offset 0x0C: Port ATU Control */
 #define MV88E6XXX_PORT_ATU_CTL		0x0c
@@ -374,6 +375,7 @@ int mv88e6xxx_port_set_fid(struct mv88e6xxx_chip *chip, int port, u16 fid);
 int mv88e6xxx_port_get_pvid(struct mv88e6xxx_chip *chip, int port, u16 *pvid);
 int mv88e6xxx_port_set_pvid(struct mv88e6xxx_chip *chip, int port, u16 pvid);
 
+bool mv88e6xxx_port_is_locked(struct mv88e6xxx_chip *chip, int port, bool chiplock);
 int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
 			    bool locked);
 
-- 
2.30.2

