Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BFC4B8A0E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiBPNa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:30:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbiBPNan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:30:43 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCE5179E50
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:30:31 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id j7so3853726lfu.6
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=sO7CNG0sSQG2qIDEEmS29gE5qWYIsAYkV+SmsMaOSJ4=;
        b=gOrriYj16c35aVCnfYWpRbk0Atd6fYsrMATkiD1ZUM2tcGyId/6rTmembEUOmPLJSt
         gYijA3m/cbaLv75Kj/xyi/3f2Q7QHz96y0zSfBlh4uPonHh+xibUVzAMwPEL6+fhG2AH
         ftAolTsPvTIDoCuNzUzo6W3B3+BAFCyL9ERaqw/WsOwOdlMHiDErnfbSL7oTtmDBmAyj
         oJxh/5dbwEEgXqQuLGtCO3UwBt3jvfHB66SzfHwCPhIYrvatLaSrPCU5unZzssKxe80Y
         NQjwDtsDSqD4ZMOprRF+nJtsB13dFQ54jUCWS+wUh2gHHgRoQb6NpjO8g1+v4MHrT9HX
         4G8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=sO7CNG0sSQG2qIDEEmS29gE5qWYIsAYkV+SmsMaOSJ4=;
        b=GH7QPBi6/CUKuXKR44WvPcOqNCsAMNoEH1CGJgr6aEv1IqWmJ97UNyX6E9GOHB/all
         gxWLvsA5kYSduVXUAUluk0Gb0hEMpRJ+b1/4SH+BXrNlJmfXNq+5C28HLtErJnhA86Er
         looG3hH5yVCeqmVXJ+zCeTgybw3iZqQ7MrtSxwwLjZ1/0d2bySVw/ntwCOFd/s+HcZWw
         qbJPuBCt9iq6QyeQ/5AoB110+gJzW7wPOfOIovoDaidHhddJyRy3zBWsjniCXnM7RqLP
         YVsDzZzWOk+S+9coZZwmK2CNmtFhkMf4OU5NeH1i0S+jVsSPhyzoGOdZLU3fU4Px0w9S
         NJeg==
X-Gm-Message-State: AOAM531nFZAqOGHyya4JvEaRtwOdrRARD87aMuk/sqrsINSvNVXDxXmZ
        +VJx1Dk8m9VZl0IlQXPgL1yvVQ==
X-Google-Smtp-Source: ABdhPJx2UytE2+3TxqwsBnenNFkHZlwOqXn+BLp+1SNYsWCd5bYpzcXqbQsl8/D/zA8Xk6OSWPsezA==
X-Received: by 2002:a19:dc0f:0:b0:439:702c:d83b with SMTP id t15-20020a19dc0f000000b00439702cd83bmr1932630lfg.192.1645018229578;
        Wed, 16 Feb 2022 05:30:29 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v6sm234780ljd.86.2022.02.16.05.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 05:30:28 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [RFC net-next 6/9] net: dsa: Pass MST state changes to driver
Date:   Wed, 16 Feb 2022 14:29:31 +0100
Message-Id: <20220216132934.1775649-7-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216132934.1775649-1-tobias@waldekranz.com>
References: <20220216132934.1775649-1-tobias@waldekranz.com>
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

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/dsa.h  |  2 ++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 30 ++++++++++++++++++++++++++++++
 net/dsa/slave.c    |  6 ++++++
 4 files changed, 40 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2aabe7f0b176..f030afb68f46 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -882,6 +882,8 @@ struct dsa_switch_ops {
 				     struct dsa_bridge bridge);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
+	int	(*port_mst_state_set)(struct dsa_switch *ds, int port,
+				      const struct switchdev_mst_state *state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
 	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
 					 struct switchdev_brport_flags flags,
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 43709c005461..96d09184de5d 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -185,6 +185,8 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
+int dsa_port_set_mst_state(struct dsa_port *dp,
+			   const struct switchdev_mst_state *state);
 int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
 void dsa_port_disable_rt(struct dsa_port *dp);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4fb2bf2383d9..a34779658f17 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -108,6 +108,36 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 	return 0;
 }
 
+int dsa_port_set_mst_state(struct dsa_port *dp,
+			   const struct switchdev_mst_state *state)
+{
+	struct dsa_switch *ds = dp->ds;
+	int err, port = dp->index;
+
+	if (!ds->ops->port_mst_state_set)
+		return -EOPNOTSUPP;
+
+	err = ds->ops->port_mst_state_set(ds, port, state);
+	if (err)
+		return err;
+
+	if (!dsa_port_can_configure_learning(dp) || dp->learning) {
+		switch (state->state) {
+		case BR_STATE_DISABLED:
+		case BR_STATE_BLOCKING:
+		case BR_STATE_LISTENING:
+			/* Ideally we would only fast age entries
+			 * belonging to VLANs controlled by this
+			 * MST.
+			 */
+			dsa_port_fast_age(dp);
+			break;
+		}
+	}
+
+	return 0;
+}
+
 static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
 				   bool do_fast_age)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 0a5e44105add..48075d697588 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -288,6 +288,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 
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

