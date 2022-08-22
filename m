Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF86459C15C
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbiHVOIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbiHVOII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:08:08 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB1B255B2
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 07:08:06 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id s1so12660372lfp.6
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 07:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc;
        bh=qWhrIxHiW8F0SlmDtZEVHE2NhBWoZ9s8pNbOUs/Hzfo=;
        b=eAVE3wZYEfA+NuCEwVEm+iP9z/B6dxjNk66XrZpf2lbm5IL4qsMjLTYuoWKOqZK69E
         mRBE/1ZwZmHexch4dgk/Va2RUo3bCtOywJRF03ysPWuK9+sSoz8s2sjNrqqhGDSUuhFE
         1Y9apMQTJxkeGNvH3yFFfmSQOZSTv7q//EeXiAjfD8c5ScMYhz0sNuFcgA/ONLhSoaoB
         wGORgdbbZYzQul72SdRtUrHn0Tmm7tpmb5AnP6t4ix7sIXP35A0IFGuINE+CFggfq57y
         MubQof7PZ0CtUtrF6pLgDUGPFWV8sTX511Q/0ySzqC+aR1Xfg2b7IapjwxdbIdM/+khX
         iZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc;
        bh=qWhrIxHiW8F0SlmDtZEVHE2NhBWoZ9s8pNbOUs/Hzfo=;
        b=e7rOphKXDxToF7oLtIRoMQYXKO/6CM8FlA3XY7gRu7sa03/t84S959W0sWtJzx5vUD
         xf18/+/Cr5bG2LLhT7T7rgsmQmGmIgcVQNeEoXrgVVchJR5lKwlcVQLkWidaSfrCvPRw
         So77p1XA15APjRnsh+tqSLg2PO/oQkY3vjMyvG9O6FU3wPYflq7pB+3vo0QpVzEuEcYg
         ZosoDMPZ1cNpsu95NZ0mL7OJeaevdplmJuM7EwJ3aXTkquhPCWIUo+qLvWKw1aJ3eHWU
         ZQJuXvHF+Xalrw3dqz2J+pIf82SA3KeyNpOj7Web00zmXOVa+JCFvosCNC4rdUArbn7Q
         8rLQ==
X-Gm-Message-State: ACgBeo10nzHi74JvkutSDGE5tSptUdLHVpjmCu4eckiNhZ0HQryRMd5q
        qrWFu0x8V/vHXPTiA1RHyv27wwjdxGM=
X-Google-Smtp-Source: AA6agR7xcXN4vaVyYaGtLL9FFNcSelDFZ7ZbLWGIgUOcl2kL193CO/33Pg8riTJhkOaV1poY6Ut8Rg==
X-Received: by 2002:ac2:5462:0:b0:48b:2a7b:3c15 with SMTP id e2-20020ac25462000000b0048b2a7b3c15mr7342485lfn.489.1661177284630;
        Mon, 22 Aug 2022 07:08:04 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id o14-20020a05651205ce00b0048bd7136ef3sm1934126lfo.221.2022.08.22.07.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 07:08:04 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/3] net: sparx5: add list for mdb entries in driver
Date:   Mon, 22 Aug 2022 16:07:59 +0200
Message-Id: <20220822140800.2651029-3-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220822140800.2651029-1-casper.casan@gmail.com>
References: <20220822140800.2651029-1-casper.casan@gmail.com>
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

Keep track of all mdb entries in software for easy access.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   |   3 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |  13 ++
 .../microchip/sparx5/sparx5_switchdev.c       | 196 ++++++++++--------
 3 files changed, 130 insertions(+), 82 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 01be7bd84181..ad598cf8ef44 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -661,6 +661,9 @@ static int sparx5_start(struct sparx5 *sparx5)
 	queue_delayed_work(sparx5->mact_queue, &sparx5->mact_work,
 			   SPX5_MACT_PULL_DELAY);
 
+	mutex_init(&sparx5->mdb_lock);
+	INIT_LIST_HEAD(&sparx5->mdb_entries);
+
 	err = sparx5_register_netdevs(sparx5);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index b197129044b5..7c98af99c4f3 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -215,6 +215,15 @@ struct sparx5_skb_cb {
 	unsigned long jiffies;
 };
 
+struct sparx5_mdb_entry {
+	struct list_head list;
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+	DECLARE_BITMAP(port_mask, SPX5_PORTS);
+	bool cpu_copy;
+	u16 pgid_idx;
+};
+
 #define SPARX5_PTP_TIMEOUT		msecs_to_jiffies(10)
 #define SPARX5_SKB_CB(skb) \
 	((struct sparx5_skb_cb *)((skb)->cb))
@@ -256,6 +265,10 @@ struct sparx5 {
 	struct list_head mact_entries;
 	/* mac table list (mact_entries) mutex */
 	struct mutex mact_lock;
+	/* SW MDB table */
+	struct list_head mdb_entries;
+	/* mdb list mutex */
+	struct mutex mdb_lock;
 	struct delayed_work mact_work;
 	struct workqueue_struct *mact_queue;
 	/* Board specifics */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index ec07f7d0528c..dd3290168bcc 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -386,16 +386,93 @@ static int sparx5_handle_port_vlan_add(struct net_device *dev,
 				  v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
 }
 
+static int sparx5_alloc_mdb_entry(struct sparx5 *sparx5,
+				  const unsigned char *addr,
+				  u16 vid,
+				  struct sparx5_mdb_entry **entry_out)
+{
+	struct sparx5_mdb_entry *entry;
+	u16 pgid_idx;
+	int err;
+
+	entry = devm_kzalloc(sparx5->dev, sizeof(struct sparx5_mdb_entry), GFP_ATOMIC);
+	if (!entry)
+		return -ENOMEM;
+
+	err = sparx5_pgid_alloc_mcast(sparx5, &pgid_idx);
+	if (err) {
+		devm_kfree(sparx5->dev, entry);
+		return err;
+	}
+
+	memcpy(entry->addr, addr, ETH_ALEN);
+	entry->vid = vid;
+	entry->pgid_idx = pgid_idx;
+
+	mutex_lock(&sparx5->mdb_lock);
+	list_add_tail(&entry->list, &sparx5->mdb_entries);
+	mutex_unlock(&sparx5->mdb_lock);
+
+	*entry_out = entry;
+	return 0;
+}
+
+static void sparx5_free_mdb_entry(struct sparx5 *sparx5,
+				  const unsigned char *addr,
+				  u16 vid)
+{
+	struct sparx5_mdb_entry *entry, *tmp;
+
+	mutex_lock(&sparx5->mdb_lock);
+	list_for_each_entry_safe(entry, tmp, &sparx5->mdb_entries, list) {
+		if ((vid == 0 || entry->vid == vid) &&
+		    ether_addr_equal(addr, entry->addr)) {
+			list_del(&entry->list);
+
+			sparx5_pgid_free(sparx5, entry->pgid_idx);
+
+			devm_kfree(sparx5->dev, entry);
+		}
+	}
+	mutex_unlock(&sparx5->mdb_lock);
+}
+
+static struct sparx5_mdb_entry *sparx5_mdb_get_entry(struct sparx5 *sparx5,
+						     const unsigned char *addr,
+						     u16 vid)
+{
+	struct sparx5_mdb_entry *e, *found = NULL;
+
+	mutex_lock(&sparx5->mdb_lock);
+	list_for_each_entry(e, &sparx5->mdb_entries, list) {
+		if (ether_addr_equal(e->addr, addr) && e->vid == vid) {
+			found = e;
+			goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&sparx5->mdb_lock);
+	return found;
+}
+
+static void sparx5_cpu_copy_ena(struct sparx5 *spx5, u16 pgid, bool enable)
+{
+	spx5_rmw(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(enable),
+		 ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, spx5,
+		 ANA_AC_PGID_MISC_CFG(pgid));
+}
+
 static int sparx5_handle_port_mdb_add(struct net_device *dev,
 				      struct notifier_block *nb,
 				      const struct switchdev_obj_port_mdb *v)
 {
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5 *spx5 = port->sparx5;
-	u16 pgid_idx, vid;
-	u32 mact_entry;
+	struct sparx5_mdb_entry *entry;
 	bool is_host;
-	int res, err;
+	int err;
+	u16 vid;
 
 	if (!sparx5_netdevice_check(dev))
 		return -EOPNOTSUPP;
@@ -410,66 +487,25 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 	else
 		vid = v->vid;
 
-	res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
-
-	if (res == 0) {
-		pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
-
-		/* MC_IDX starts after the port masks in the PGID table */
-		pgid_idx += SPX5_PORTS;
-
-		if (is_host)
-			spx5_rmw(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1),
-				 ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, spx5,
-				 ANA_AC_PGID_MISC_CFG(pgid_idx));
-		else
-			sparx5_pgid_update_mask(port, pgid_idx, true);
-
-	} else {
-		err = sparx5_pgid_alloc_mcast(spx5, &pgid_idx);
-		if (err) {
-			netdev_warn(dev, "multicast pgid table full\n");
+	entry = sparx5_mdb_get_entry(spx5, v->addr, vid);
+	if (!entry) {
+		err = sparx5_alloc_mdb_entry(spx5, v->addr, vid, &entry);
+		if (err)
 			return err;
-		}
-
-		if (is_host)
-			spx5_rmw(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1),
-				 ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, spx5,
-				 ANA_AC_PGID_MISC_CFG(pgid_idx));
-		else
-			sparx5_pgid_update_mask(port, pgid_idx, true);
-
-		err = sparx5_mact_learn(spx5, pgid_idx, v->addr, vid);
-
-		if (err) {
-			netdev_warn(dev, "could not learn mac address %pM\n", v->addr);
-			sparx5_pgid_free(spx5, pgid_idx);
-			sparx5_pgid_update_mask(port, pgid_idx, false);
-			return err;
-		}
 	}
 
-	return 0;
-}
+	mutex_lock(&spx5->mdb_lock);
+	if (is_host && !entry->cpu_copy) {
+		sparx5_cpu_copy_ena(spx5, entry->pgid_idx, true);
+		entry->cpu_copy = true;
+	} else if (!is_host) {
+		sparx5_pgid_update_mask(port, entry->pgid_idx, true);
+		set_bit(port->portno, entry->port_mask);
+	}
+	mutex_unlock(&spx5->mdb_lock);
 
-static int sparx5_mdb_del_entry(struct net_device *dev,
-				struct sparx5 *spx5,
-				const unsigned char mac[ETH_ALEN],
-				const u16 vid,
-				u16 pgid_idx)
-{
-	int err;
+	sparx5_mact_learn(spx5, entry->pgid_idx, entry->addr, entry->vid);
 
-	err = sparx5_mact_forget(spx5, mac, vid);
-	if (err) {
-		netdev_warn(dev, "could not forget mac address %pM", mac);
-		return err;
-	}
-	err = sparx5_pgid_free(spx5, pgid_idx);
-	if (err) {
-		netdev_err(dev, "attempted to free already freed pgid\n");
-		return err;
-	}
 	return 0;
 }
 
@@ -479,42 +515,38 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 {
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5 *spx5 = port->sparx5;
-	u16 pgid_idx, vid;
-	u32 mact_entry, res, pgid_entry[3], misc_cfg;
-	bool host_ena;
+	struct sparx5_mdb_entry *entry;
+	bool is_host;
+	u16 vid;
 
 	if (!sparx5_netdevice_check(dev))
 		return -EOPNOTSUPP;
 
+	is_host = netif_is_bridge_master(v->obj.orig_dev);
+
 	if (!br_vlan_enabled(spx5->hw_bridge_dev))
 		vid = 1;
 	else
 		vid = v->vid;
 
-	res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
-
-	if (res == 0) {
-		pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
-
-		/* MC_IDX starts after the port masks in the PGID table */
-		pgid_idx += SPX5_PORTS;
-
-		if (netif_is_bridge_master(v->obj.orig_dev))
-			spx5_rmw(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(0),
-				 ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, spx5,
-				 ANA_AC_PGID_MISC_CFG(pgid_idx));
-		else
-			sparx5_pgid_update_mask(port, pgid_idx, false);
-
-		misc_cfg = spx5_rd(spx5, ANA_AC_PGID_MISC_CFG(pgid_idx));
-		host_ena = ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_GET(misc_cfg);
+	entry = sparx5_mdb_get_entry(spx5, v->addr, vid);
+	if (!entry)
+		return 0;
 
-		sparx5_pgid_read_mask(spx5, pgid_idx, pgid_entry);
-		if (bitmap_empty((unsigned long *)pgid_entry, SPX5_PORTS) && !host_ena)
-			/* No ports or CPU are in MC group. Remove entry */
-			return sparx5_mdb_del_entry(dev, spx5, v->addr, vid, pgid_idx);
+	mutex_lock(&spx5->mdb_lock);
+	if (is_host && entry->cpu_copy) {
+		sparx5_cpu_copy_ena(spx5, entry->pgid_idx, false);
+		entry->cpu_copy = false;
+	} else if (!is_host) {
+		clear_bit(port->portno, entry->port_mask);
+		sparx5_pgid_update_mask(port, entry->pgid_idx, false);
 	}
+	mutex_unlock(&spx5->mdb_lock);
 
+	if (bitmap_empty(entry->port_mask, SPX5_PORTS) && !entry->cpu_copy) {
+		sparx5_mact_forget(spx5, entry->addr, entry->vid);
+		sparx5_free_mdb_entry(spx5, entry->addr, entry->vid);
+	}
 	return 0;
 }
 
-- 
2.34.1

