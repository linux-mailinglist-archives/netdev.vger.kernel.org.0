Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28984D916B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343857AbiCOA2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbiCOA1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:45 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39EC41624
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:33 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id w12so30135728lfr.9
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=wdABQfDKWmkuhcjeBCHzTi8UwrhYcP2IXUi74HMe6wI=;
        b=yY6gIVVPkpOG4w4jap84wlbIy4nI6IUVGe/uL1xtTVs1JY/YNXrq2DAOhXYDVwUzIC
         20nco/6njKi399jCmVSGXmwncRFf8Bz7s93CFRCU35QEc2Ro7YUNiiqREsy7J6AAtgwU
         4jgElORuCG2NBMT50cHNG3anLZXmHfA5sHwUT+FQzHQBO89INa2LzNglk/JDgkRKM0ln
         3FwINkJJzgqG1JMD5BcLACIqQ7WzoCLNXJ3IwSlrWxLdrJ1dFd/JEWIlX+xKEMsfn/FC
         lomqGcEesRk2rXRbuQ0igoVTJdZV6TNhrPwjo7gXi0QLc+8/5AvXpx6jgx0ZtlPCrWQu
         osew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=wdABQfDKWmkuhcjeBCHzTi8UwrhYcP2IXUi74HMe6wI=;
        b=tRm9O/gnUUtR3g49KhgJ7p2V2fbex8sxexAJynPLNWP5YSqW/gYiLbjvyz6d/Yi0hG
         bHeRaIKbbzldgKghMZ8QltC37q3qqPQDkrRqMExqrfkKSQBrYG2ia7lYKf5LKU0BJtAE
         eBbsc3R9xtG2nfHhINii3ovEK/8tXYDco7nNF/QgnUrkdArCTFSDwyXbwSLPGv3pDOMo
         6gitnZKdIodNm/jakTd4dNGD2TtB4w+J8Vibor7bAa+gBWHbK4JbfAXVfRrzKdFRK8rq
         kHi4pPsjNtJu24vIp1F5zT0LWkcuLsaBhIRdFuQHG9UNId25HoMliY55LEA9GA+05fEA
         +UHQ==
X-Gm-Message-State: AOAM531/zubmmzGp2p8YHNNd7bohGASHM/EUh6tpGQ6k9c7EvHqwJYki
        GMGahKjmjvVH1b0/Z+pWAGa8lA==
X-Google-Smtp-Source: ABdhPJy8bex87DPl5mbWCNRsIve/EshrS8C1txujXLNirED39ZeltN1uRwPfznyH11gD1KgWXm41aw==
X-Received: by 2002:ac2:4e71:0:b0:448:2cf8:dafc with SMTP id y17-20020ac24e71000000b004482cf8dafcmr14809905lfs.558.1647303992219;
        Mon, 14 Mar 2022 17:26:32 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:31 -0700 (PDT)
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
Subject: [PATCH v4 net-next 12/15] net: dsa: Handle MST state changes
Date:   Tue, 15 Mar 2022 01:25:40 +0100
Message-Id: <20220315002543.190587-13-tobias@waldekranz.com>
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

Add the usual trampoline functionality from the generic DSA layer down
to the drivers for MST state changes.

When a state changes to disabled/blocking/listening, make sure to fast
age any dynamic entries in the affected VLANs (those controlled by the
MSTI in question).

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/dsa.h  |  3 ++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 70 +++++++++++++++++++++++++++++++++++++++++++---
 net/dsa/slave.c    |  6 ++++
 4 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1ddaa2cc5842..0f369f2e9a97 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -945,7 +945,10 @@ struct dsa_switch_ops {
 				     struct dsa_bridge bridge);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
+	int	(*port_mst_state_set)(struct dsa_switch *ds, int port,
+				      const struct switchdev_mst_state *state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
+	int	(*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 vid);
 	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
 					 struct switchdev_brport_flags flags,
 					 struct netlink_ext_ack *extack);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d90b4cf0c9d2..2ae8996cf7c8 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -215,6 +215,8 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
+int dsa_port_set_mst_state(struct dsa_port *dp,
+			   const struct switchdev_mst_state *state);
 int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
 void dsa_port_disable_rt(struct dsa_port *dp);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3ac114f6fc22..a2a817bb77b1 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -30,12 +30,11 @@ static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
 	return dsa_tree_notify(dp->ds->dst, e, v);
 }
 
-static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp)
+static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp, u16 vid)
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	struct switchdev_notifier_fdb_info info = {
-		/* flush all VLANs */
-		.vid = 0,
+		.vid = vid,
 	};
 
 	/* When the port becomes standalone it has already left the bridge.
@@ -57,7 +56,42 @@ static void dsa_port_fast_age(const struct dsa_port *dp)
 
 	ds->ops->port_fast_age(ds, dp->index);
 
-	dsa_port_notify_bridge_fdb_flush(dp);
+	/* flush all VLANs */
+	dsa_port_notify_bridge_fdb_flush(dp, 0);
+}
+
+static int dsa_port_vlan_fast_age(const struct dsa_port *dp, u16 vid)
+{
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	if (!ds->ops->port_vlan_fast_age)
+		return -EOPNOTSUPP;
+
+	err = ds->ops->port_vlan_fast_age(ds, dp->index, vid);
+
+	if (!err)
+		dsa_port_notify_bridge_fdb_flush(dp, vid);
+
+	return err;
+}
+
+static int dsa_port_msti_fast_age(const struct dsa_port *dp, u16 msti)
+{
+	DECLARE_BITMAP(vids, VLAN_N_VID) = { 0 };
+	int err, vid;
+
+	err = br_mst_get_info(dsa_port_bridge_dev_get(dp), msti, vids);
+	if (err)
+		return err;
+
+	for_each_set_bit(vid, vids, VLAN_N_VID) {
+		err = dsa_port_vlan_fast_age(dp, vid);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 static bool dsa_port_can_configure_learning(struct dsa_port *dp)
@@ -118,6 +152,32 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
 		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
 }
 
+int dsa_port_set_mst_state(struct dsa_port *dp,
+			   const struct switchdev_mst_state *state)
+{
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	if (!ds->ops->port_mst_state_set)
+		return -EOPNOTSUPP;
+
+	err = ds->ops->port_mst_state_set(ds, dp->index, state);
+	if (err)
+		return err;
+
+	if (dp->learning) {
+		switch (state->state) {
+		case BR_STATE_DISABLED:
+		case BR_STATE_BLOCKING:
+		case BR_STATE_LISTENING:
+			err = dsa_port_msti_fast_age(dp, state->msti);
+			break;
+		}
+	}
+
+	return err;
+}
+
 int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
 {
 	struct dsa_switch *ds = dp->ds;
@@ -326,6 +386,8 @@ static bool dsa_port_supports_mst(struct dsa_port *dp)
 	struct dsa_switch *ds = dp->ds;
 
 	return ds->ops->vlan_msti_set &&
+		ds->ops->port_mst_state_set &&
+		ds->ops->port_vlan_fast_age &&
 		dsa_port_can_configure_learning(dp);
 }
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5e986cdeaae5..4300fc76f3af 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -450,6 +450,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 
 		ret = dsa_port_set_state(dp, attr->u.stp_state, true);
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_MST_STATE:
+		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
+		ret = dsa_port_set_mst_state(dp, &attr->u.mst_state);
+		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
 		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
 			return -EOPNOTSUPP;
-- 
2.25.1

