Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0488759C15D
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbiHVOIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiHVOII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:08:08 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5A625290
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 07:08:07 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id z20so10738086ljq.3
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 07:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc;
        bh=VQR+nZGUBmjP3VQet7G1FvAgy6Sw7obJ/9tqJfMUdzM=;
        b=b7Ejox2gKlEO42JOq8fyerh1T8wzUfiB963/m5LY+5AQD6J7pAaZYn1sI5kIVuQDMW
         cXVc8ykFBRhDFhwYbG47gKEo5rdQCnU4Ide9GSQIc8YAaWrxBKxwgeebD50wuLu8jMrc
         Ri8QR37jVIlFeuqs10eTwJ7lLg/R3ZifUjWmyuXQ6yNxJFC1AcepZcdMKQ/S18peKNl9
         kNXpmlo6dxSz7zNiyPKOsempY/xGWRQzgZVxqYgNxLBHK8tals4DfADJPf2/WqZNo9c4
         frJDCZi7K7Ks05V/lbfvfcAhsLuguo4BGmKq6ezmNbrXOZmAIFOEsB6VoSu6n6bzWdxz
         acoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc;
        bh=VQR+nZGUBmjP3VQet7G1FvAgy6Sw7obJ/9tqJfMUdzM=;
        b=q5tzpkDaMRZSxjRBt9taTpKZ3HUne6dEPP+R9hzMVJvPnBD2QlWeEC4NDek4XlFQf/
         t0/JsuLrsYh22xEHl24luiLGOqAFFW2ivJk1xzOZWin+lJ4PUADb3DmHd638cYuMwLsb
         71ZsKIqdcEdFSXJqXuoYj6o2sjWadvd/rIFlvhujgaxdBpBHYkExlfeVhZnzHj7js5+a
         y6T6lnFDDMAxDynAyAM+nNheiVnj8a/fOOEO5taWlZWe1yVuPL/FfFwqkIfpd9KCBI6s
         Sq9VKgyq81h7Pdo04kRBusfVZEXuktCkTiH7RmgmuzloD/r2Mfc5u8jEt1W457ivo3pl
         Iyug==
X-Gm-Message-State: ACgBeo3TSig8BmYiZb7ZMAf7fG4aGrLVRWTpr8fTqgpKT4uKzUzYMNqp
        2Ou7r4wMtf6XarIFMjfE8+c=
X-Google-Smtp-Source: AA6agR4Zh3eBGWfpSW6w1yIeRvyhhvJu21EItsewhTfmurjSFDFfOwRLHZcnz5KBZdTkAeFZg6tkEw==
X-Received: by 2002:a2e:b88b:0:b0:261:c9e7:fc59 with SMTP id r11-20020a2eb88b000000b00261c9e7fc59mr2443853ljp.120.1661177285552;
        Mon, 22 Aug 2022 07:08:05 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id o14-20020a05651205ce00b0048bd7136ef3sm1934126lfo.221.2022.08.22.07.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 07:08:05 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 3/3] net: sparx5: add support for mrouter ports
Date:   Mon, 22 Aug 2022 16:08:00 +0200
Message-Id: <20220822140800.2651029-4-casper.casan@gmail.com>
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

All multicast should be forwarded to mrouter ports. Mrouter ports must
therefore be part of all active multicast groups, and override flooding
from being disabled.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   |  1 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |  2 +
 .../microchip/sparx5/sparx5_switchdev.c       | 77 +++++++++++++++++--
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |  7 ++
 4 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index ad598cf8ef44..bbe41734360e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -277,6 +277,7 @@ static int sparx5_create_port(struct sparx5 *sparx5,
 	spx5_port->custom_etype = 0x8880; /* Vitesse */
 	spx5_port->phylink_pcs.poll = true;
 	spx5_port->phylink_pcs.ops = &sparx5_phylink_pcs_ops;
+	spx5_port->is_mrouter = false;
 	sparx5->ports[config->portno] = spx5_port;
 
 	err = sparx5_port_init(sparx5, spx5_port, &config->conf);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 7c98af99c4f3..80e605837606 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -190,6 +190,7 @@ struct sparx5_port {
 	u8 ptp_cmd;
 	u16 ts_id;
 	struct sk_buff_head tx_skbs;
+	bool is_mrouter;
 };
 
 enum sparx5_core_clockfreq {
@@ -338,6 +339,7 @@ void sparx5_mact_init(struct sparx5 *sparx5);
 
 /* sparx5_vlan.c */
 void sparx5_pgid_update_mask(struct sparx5_port *port, int pgid, bool enable);
+void sparx5_pgid_clear(struct sparx5 *spx5, int pgid);
 void sparx5_pgid_read_mask(struct sparx5 *sparx5, int pgid, u32 portmask[3]);
 void sparx5_update_fwd(struct sparx5 *sparx5);
 void sparx5_vlan_init(struct sparx5 *sparx5);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index dd3290168bcc..47e6555ee33d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -29,14 +29,23 @@ static int sparx5_port_attr_pre_bridge_flags(struct sparx5_port *port,
 	return 0;
 }
 
+static void sparx5_port_update_mcast_ip_flood(struct sparx5_port *port, bool flood_flag)
+{
+	bool should_flood = flood_flag || port->is_mrouter;
+	int pgid;
+
+	for (pgid = PGID_IPV4_MC_DATA; pgid <= PGID_IPV6_MC_CTRL; pgid++)
+		sparx5_pgid_update_mask(port, pgid, should_flood);
+}
+
 static void sparx5_port_attr_bridge_flags(struct sparx5_port *port,
 					  struct switchdev_brport_flags flags)
 {
-	int pgid;
+	if (flags.mask & BR_MCAST_FLOOD) {
+		sparx5_pgid_update_mask(port, PGID_MC_FLOOD, !!(flags.val & BR_MCAST_FLOOD));
+		sparx5_port_update_mcast_ip_flood(port, !!(flags.val & BR_MCAST_FLOOD));
+	}
 
-	if (flags.mask & BR_MCAST_FLOOD)
-		for (pgid = PGID_MC_FLOOD; pgid <= PGID_IPV6_MC_CTRL; pgid++)
-			sparx5_pgid_update_mask(port, pgid, !!(flags.val & BR_MCAST_FLOOD));
 	if (flags.mask & BR_FLOOD)
 		sparx5_pgid_update_mask(port, PGID_UC_FLOOD, !!(flags.val & BR_FLOOD));
 	if (flags.mask & BR_BCAST_FLOOD)
@@ -82,6 +91,37 @@ static void sparx5_port_attr_ageing_set(struct sparx5_port *port,
 	sparx5_set_ageing(port->sparx5, ageing_time);
 }
 
+static void sparx5_port_attr_mrouter_set(struct sparx5_port *port,
+					 struct net_device *orig_dev,
+					 bool enable)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	struct sparx5_mdb_entry *e;
+	bool flood_flag;
+
+	if ((enable && port->is_mrouter) || (!enable && !port->is_mrouter))
+		return;
+
+	/* Add/del mrouter port on all active mdb entries in HW.
+	 * Don't change entry port mask, since that represents
+	 * ports that actually joined that group.
+	 */
+	mutex_lock(&sparx5->mdb_lock);
+	list_for_each_entry(e, &sparx5->mdb_entries, list) {
+		if (!test_bit(port->portno, e->port_mask) &&
+		    ether_addr_is_ip_mcast(e->addr))
+			sparx5_pgid_update_mask(port, e->pgid_idx, enable);
+	}
+	mutex_unlock(&sparx5->mdb_lock);
+
+	/* Enable/disable flooding depeding on if port is mrouter port
+	 * or if mcast flood is enabled.
+	 */
+	port->is_mrouter = enable;
+	flood_flag = br_port_flag_is_set(port->ndev, BR_MCAST_FLOOD);
+	sparx5_port_update_mcast_ip_flood(port, flood_flag);
+}
+
 static int sparx5_port_attr_set(struct net_device *dev, const void *ctx,
 				const struct switchdev_attr *attr,
 				struct netlink_ext_ack *extack)
@@ -110,6 +150,11 @@ static int sparx5_port_attr_set(struct net_device *dev, const void *ctx,
 		port->vlan_aware = attr->u.vlan_filtering;
 		sparx5_vlan_port_apply(port->sparx5, port);
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_MROUTER:
+		sparx5_port_attr_mrouter_set(port,
+					     attr->orig_dev,
+					     attr->u.mrouter);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -470,8 +515,8 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5 *spx5 = port->sparx5;
 	struct sparx5_mdb_entry *entry;
-	bool is_host;
-	int err;
+	bool is_host, is_new;
+	int err, i;
 	u16 vid;
 
 	if (!sparx5_netdevice_check(dev))
@@ -487,14 +532,25 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 	else
 		vid = v->vid;
 
+	is_new = false;
 	entry = sparx5_mdb_get_entry(spx5, v->addr, vid);
 	if (!entry) {
 		err = sparx5_alloc_mdb_entry(spx5, v->addr, vid, &entry);
+		is_new = true;
 		if (err)
 			return err;
 	}
 
 	mutex_lock(&spx5->mdb_lock);
+
+	/* Add any mrouter ports to the new entry */
+	if (is_new && ether_addr_is_ip_mcast(v->addr))
+		for (i = 0; i < SPX5_PORTS; i++)
+			if (spx5->ports[i] && spx5->ports[i]->is_mrouter)
+				sparx5_pgid_update_mask(spx5->ports[i],
+							entry->pgid_idx,
+							true);
+
 	if (is_host && !entry->cpu_copy) {
 		sparx5_cpu_copy_ena(spx5, entry->pgid_idx, true);
 		entry->cpu_copy = true;
@@ -539,11 +595,18 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 		entry->cpu_copy = false;
 	} else if (!is_host) {
 		clear_bit(port->portno, entry->port_mask);
-		sparx5_pgid_update_mask(port, entry->pgid_idx, false);
+
+		/* Port not mrouter port or addr is L2 mcast, remove port from mask. */
+		if (!port->is_mrouter || !ether_addr_is_ip_mcast(v->addr))
+			sparx5_pgid_update_mask(port, entry->pgid_idx, false);
 	}
 	mutex_unlock(&spx5->mdb_lock);
 
 	if (bitmap_empty(entry->port_mask, SPX5_PORTS) && !entry->cpu_copy) {
+		 /* Clear pgid in case mrouter ports exists
+		  * that are not part of the group.
+		  */
+		sparx5_pgid_clear(spx5, entry->pgid_idx);
 		sparx5_mact_forget(spx5, entry->addr, entry->vid);
 		sparx5_free_mdb_entry(spx5, entry->addr, entry->vid);
 	}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
index 37e4ac965849..34f954bbf815 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
@@ -138,6 +138,13 @@ void sparx5_pgid_update_mask(struct sparx5_port *port, int pgid, bool enable)
 	}
 }
 
+void sparx5_pgid_clear(struct sparx5 *spx5, int pgid)
+{
+	spx5_wr(0, spx5, ANA_AC_PGID_CFG(pgid));
+	spx5_wr(0, spx5, ANA_AC_PGID_CFG1(pgid));
+	spx5_wr(0, spx5, ANA_AC_PGID_CFG2(pgid));
+}
+
 void sparx5_pgid_read_mask(struct sparx5 *spx5, int pgid, u32 portmask[3])
 {
 	portmask[0] = spx5_rd(spx5, ANA_AC_PGID_CFG(pgid));
-- 
2.34.1

