Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCB9530F3A
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbiEWKny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234205AbiEWKn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:29 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676EB120BD
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:27 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id j4so14120870edq.6
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IuAqXISDjSHkJt8CP9xEtdbMYAiNqKEvcEBC+IER7fc=;
        b=jjIuJTiMB7qbobNu1JLpIhoEfn0PRp2NW3dqzfNSPdGWwUVZKg4M211jrIMrtvtdSE
         G5jhhqgtwINdOVwNnItI9WDqxnKmR2Wwf2kvQGxuLnj8GWT05cN/ahAdsuUUo4QonhiK
         +YL+OCtVxhmnuIciZtZiDcCI3WYrvszRsoZZjMq88LucBInXr3KsWRefNxWzazSOgkYt
         SrqC0TeaDkPFoOgzxhGopsQoU8rg03EIH6MhH6Q5Mymj+OutKoGYCicFO7rvrAzhQk+g
         6rrfeUVflUUuS1oeW0QjuteKZ9Xsv0fOKTmmJ3nnrkiYoQoP3TZzloGUcmFG+oORwikL
         PXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IuAqXISDjSHkJt8CP9xEtdbMYAiNqKEvcEBC+IER7fc=;
        b=fcbNjn6umV12Xv3AuZpQNDjrEqMHndVeTyxa69ZEvS8knPiR9YcslgDTR2xaJExkP/
         pCcmNqBi7LM1JZU7GG1qudT1bQLsZJUc+b4dUQEDGrsBfUoyt3tKG//W/gVkRS6I9FUI
         qiUqkei/3Y3D8Wh2i7Nqdlg2pQDMHrnliucRMxNp9AOC+nJ2R/Bbp5dh+X9iDOPrzi9A
         EfOAP3iHZvxphdHctV9nxKMQbxir4ocm303sIPo/giiQ8BsYOcWYVwbIcjH+PS0eQ+XS
         Y7GrEWdehSSZray3mKB9GHzN+CcNGSEpHanxO0pGV2ZbypSdwMHCBSQIU5MepIQvzUlP
         EbMA==
X-Gm-Message-State: AOAM531ldDgp6gTCTZhNH/xBQ2Zh8CQXTUD7IyO0dC1bDOQAu/aJBrY2
        4JQ/k88I7mrnH2wKXS+Ci+Qp5bvzN0Q=
X-Google-Smtp-Source: ABdhPJyRSh/zsGoAA+Pa7roPayyQzVA4+yv/ZkpG3UdMne+2so0x3E55sSGG6QerfCWh9TVBkUTY4A==
X-Received: by 2002:a05:6402:1453:b0:42a:ae31:310c with SMTP id d19-20020a056402145300b0042aae31310cmr22611666edx.382.1653302605427;
        Mon, 23 May 2022 03:43:25 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 12/12] net: dsa: felix: add support for changing DSA master
Date:   Mon, 23 May 2022 13:42:56 +0300
Message-Id: <20220523104256.3556016-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
MIME-Version: 1.0
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Changing the DSA master means different things depending on the tagging
protocol in use.

For NPI mode ("ocelot" and "seville"), there is a single port which can
be configured as NPI, but DSA only permits changing the CPU port
affinity of user ports one by one. So changing a user port to a
different NPI port globally changes what the NPI port is, and breaks the
user ports still using the old one.

To address this while still permitting the change of the NPI port,
require that the user ports which are still affine to the old NPI port
are down, and cannot be brought up until they are all affine to the same
NPI port.

The tag_8021q mode ("ocelot-8021q") is more flexible, in that each user
port can be freely assigned to one CPU port or to the other. This works
by filtering host addresses towards both tag_8021q CPU ports, and then
restricting the forwarding from a certain user port only to one of the
two tag_8021q CPU ports.

Additionally, the 2 tag_8021q CPU ports can be placed in a LAG. This
works by enabling forwarding via PGID_SRC from a certain user port
towards the logical port ID containing both tag_8021q CPU ports, but
then restricting forwarding per packet, via the LAG hash codes in
PGID_AGGR, to either one or the other.

When we change the DSA master to a LAG device, DSA guarantees us that
the LAG has at least one lower interface as a physical DSA master.
But DSA masters can come and go as lowers of that LAG, and
ds->ops->port_change_master() will not get called, because the DSA
master is still the same (the LAG). So we need to hook into the
ds->ops->port_lag_{join,leave} calls on the CPU ports and update the
logical port ID of the LAG that user ports are assigned to.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 117 ++++++++++++++++++++++++++++-
 drivers/net/dsa/ocelot/felix.h     |   3 +
 drivers/net/ethernet/mscc/ocelot.c |   3 +-
 include/soc/mscc/ocelot.h          |   1 +
 4 files changed, 121 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3e07dc39007a..4e648382c05d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -42,6 +42,25 @@ static struct net_device *felix_classify_db(struct dsa_db db)
 	}
 }
 
+static int felix_cpu_port_for_master(struct dsa_switch *ds,
+				     struct net_device *master)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct dsa_port *cpu_dp;
+	int lag;
+
+	if (netif_is_lag_master(master)) {
+		mutex_lock(&ocelot->fwd_domain_lock);
+		lag = ocelot_bond_get_id(ocelot, master);
+		mutex_unlock(&ocelot->fwd_domain_lock);
+
+		return lag;
+	}
+
+	cpu_dp = master->dsa_ptr;
+	return cpu_dp->index;
+}
+
 /* Set up VCAP ES0 rules for pushing a tag_8021q VLAN towards the CPU such that
  * the tagger can perform RX source port identification.
  */
@@ -422,6 +441,39 @@ static unsigned long felix_tag_npi_get_host_fwd_mask(struct dsa_switch *ds)
 	return BIT(ocelot->num_phys_ports);
 }
 
+static int felix_tag_npi_change_master(struct dsa_switch *ds, int port,
+				       struct net_device *master,
+				       struct netlink_ext_ack *extack)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
+	struct ocelot *ocelot = ds->priv;
+
+	if (netif_is_lag_master(master)) {
+		NL_SET_ERR_MSG_MOD(extack, "LAG DSA master only supported using ocelot-8021q");
+		return -EOPNOTSUPP;
+	}
+
+	/* Changing the NPI port breaks user ports still assigned to the old
+	 * one, so only allow it while they're down, and don't allow them to
+	 * come back up until they're all changed to the new one.
+	 */
+	dsa_switch_for_each_user_port(other_dp, ds) {
+		struct net_device *slave = other_dp->slave;
+
+		if (other_dp != dp && (slave->flags & IFF_UP) &&
+		    dsa_port_to_master(other_dp) != master) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Cannot change while old master still has users");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	felix_npi_port_deinit(ocelot, ocelot->npi);
+	felix_npi_port_init(ocelot, felix_cpu_port_for_master(ds, master));
+
+	return 0;
+}
+
 /* Alternatively to using the NPI functionality, that same hardware MAC
  * connected internally to the enetc or fman DSA master can be configured to
  * use the software-defined tag_8021q frame format. As far as the hardware is
@@ -433,6 +485,7 @@ static const struct felix_tag_proto_ops felix_tag_npi_proto_ops = {
 	.setup			= felix_tag_npi_setup,
 	.teardown		= felix_tag_npi_teardown,
 	.get_host_fwd_mask	= felix_tag_npi_get_host_fwd_mask,
+	.change_master		= felix_tag_npi_change_master,
 };
 
 static int felix_tag_8021q_setup(struct dsa_switch *ds)
@@ -501,10 +554,24 @@ static unsigned long felix_tag_8021q_get_host_fwd_mask(struct dsa_switch *ds)
 	return dsa_cpu_ports(ds);
 }
 
+static int felix_tag_8021q_change_master(struct dsa_switch *ds, int port,
+					 struct net_device *master,
+					 struct netlink_ext_ack *extack)
+{
+	int cpu = felix_cpu_port_for_master(ds, master);
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_unassign_dsa_8021q_cpu(ocelot, port);
+	ocelot_port_assign_dsa_8021q_cpu(ocelot, port, cpu);
+
+	return felix_update_trapping_destinations(ds, true);
+}
+
 static const struct felix_tag_proto_ops felix_tag_8021q_proto_ops = {
 	.setup			= felix_tag_8021q_setup,
 	.teardown		= felix_tag_8021q_teardown,
 	.get_host_fwd_mask	= felix_tag_8021q_get_host_fwd_mask,
+	.change_master		= felix_tag_8021q_change_master,
 };
 
 static void felix_set_host_flood(struct dsa_switch *ds, unsigned long mask,
@@ -664,6 +731,16 @@ static void felix_port_set_host_flood(struct dsa_switch *ds, int port,
 			     !!felix->host_flood_mc_mask, true);
 }
 
+static int felix_port_change_master(struct dsa_switch *ds, int port,
+				    struct net_device *master,
+				    struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	return felix->tag_proto_ops->change_master(ds, port, master, extack);
+}
+
 static int felix_set_ageing_time(struct dsa_switch *ds,
 				 unsigned int ageing_time)
 {
@@ -855,8 +932,17 @@ static int felix_lag_join(struct dsa_switch *ds, int port,
 			  struct netdev_lag_upper_info *info)
 {
 	struct ocelot *ocelot = ds->priv;
+	int err;
 
-	return ocelot_port_lag_join(ocelot, port, lag.dev, info);
+	err = ocelot_port_lag_join(ocelot, port, lag.dev, info);
+	if (err)
+		return err;
+
+	/* Update the logical LAG port that serves as tag_8021q CPU port */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	return felix_port_change_master(ds, port, lag.dev, NULL);
 }
 
 static int felix_lag_leave(struct dsa_switch *ds, int port,
@@ -866,7 +952,11 @@ static int felix_lag_leave(struct dsa_switch *ds, int port,
 
 	ocelot_port_lag_leave(ocelot, port, lag.dev);
 
-	return 0;
+	/* Update the logical LAG port that serves as tag_8021q CPU port */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	return felix_port_change_master(ds, port, lag.dev, NULL);
 }
 
 static int felix_lag_change(struct dsa_switch *ds, int port)
@@ -1004,6 +1094,27 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 		felix->info->port_sched_speed_set(ocelot, port, speed);
 }
 
+static int felix_port_enable(struct dsa_switch *ds, int port,
+			     struct phy_device *phydev)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct ocelot *ocelot = ds->priv;
+
+	if (!dsa_port_is_user(dp))
+		return 0;
+
+	if (ocelot->npi >= 0) {
+		struct net_device *master = dsa_port_to_master(dp);
+
+		if (felix_cpu_port_for_master(ds, master) != ocelot->npi) {
+			dev_err(ds->dev, "Multiple masters are not allowed\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
 {
 	int i;
@@ -1839,6 +1950,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.phylink_mac_select_pcs		= felix_phylink_mac_select_pcs,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
 	.phylink_mac_link_up		= felix_phylink_mac_link_up,
+	.port_enable			= felix_port_enable,
 	.port_fast_age			= felix_port_fast_age,
 	.port_fdb_dump			= felix_fdb_dump,
 	.port_fdb_add			= felix_fdb_add,
@@ -1894,6 +2006,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_add_dscp_prio		= felix_port_add_dscp_prio,
 	.port_del_dscp_prio		= felix_port_del_dscp_prio,
 	.port_set_host_flood		= felix_port_set_host_flood,
+	.port_change_master		= felix_port_change_master,
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9e07eb7ee28d..a1350342d47c 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -70,6 +70,9 @@ struct felix_tag_proto_ops {
 	int (*setup)(struct dsa_switch *ds);
 	void (*teardown)(struct dsa_switch *ds);
 	unsigned long (*get_host_fwd_mask)(struct dsa_switch *ds);
+	int (*change_master)(struct dsa_switch *ds, int port,
+			     struct net_device *master,
+			     struct netlink_ext_ack *extack);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8da7e25a47c9..3a73bf31f3eb 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2036,7 +2036,7 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 /* The logical port number of a LAG is equal to the lowest numbered physical
  * port ID present in that LAG. It may change if that port ever leaves the LAG.
  */
-static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
+int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
 {
 	int bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
@@ -2045,6 +2045,7 @@ static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
 
 	return __ffs(bond_mask);
 }
+EXPORT_SYMBOL_GPL(ocelot_bond_get_id);
 
 static u32 ocelot_dsa_8021q_cpu_assigned_ports(struct ocelot *ocelot,
 					       struct ocelot_port *cpu)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 5f88385a7748..9b777e4fa98e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -948,6 +948,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
 void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
+int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond);
 
 int ocelot_devlink_sb_register(struct ocelot *ocelot);
 void ocelot_devlink_sb_unregister(struct ocelot *ocelot);
-- 
2.25.1

