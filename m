Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B494C88DA
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbiCAKEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbiCAKEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:04:38 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68BD8C7D9
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:03:55 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m14so25967821lfu.4
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 02:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=dN16fgCTqmhSfWtON594E0vOkCFf2RmkoetWGdp6JJ4=;
        b=FGP37pZXEBxkL0RxQNnVRGaX5eyOsC22WbmLISe8yfJ43HMUdsFMgaXv9tkRS4DpVG
         tjGzCvGsTtjeWS+jnvH5B8+Yp0D8sycoVCMC3x1VD+fqlEoJdOXBZAkevk4YU74QVAk1
         S5ohNO6qfTP38dNJWcXPMuzxIRN7XtdtSoEONxXDoc74FLrZM4zM8X32zs+4tEagEIkD
         w76Srz/HbjzTAXMO6Jxw6l2CfLw7TcYeWVSyE90AFjDExj1M8DmPp93Em1NJxpYfj38U
         DbO1BDdxtMQwnqJF6B6W6I7OS/++rHXExExII94jWf2+Ux04FqkA2vPbo1YwpemaydjV
         5Tug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=dN16fgCTqmhSfWtON594E0vOkCFf2RmkoetWGdp6JJ4=;
        b=hLsAnRqGCdvenPGE6ki+jf5z1SWU0Fq74cP2jh4wxTC1N6EXBD+GP4pv0hPwp/VhjA
         7ophnZ6HkCwxWAl7yn9PhaO6s6RAP6pm5MZmqVneACQxHIsmF4l3EVWF788ar0Cjqbcj
         a8Mgh15GOf4K/4LbH24grorJwwDp1LkgTJ1IpL6eRJh03F7CBjoHnmtt6W/BcNfE5e5N
         mEZ06bC4PAl7/MPxU8rSXpTGdujFGPn0p7p8zpWZjztGHxjfe+dj7XnJfNCVrTCYb/C1
         vSsk2ztgjEe5X0h/JjBkWtczouoAJHC9ajY5hC4ierIZkP22D6MlQEsnj8qOfpFge6Cy
         zwOw==
X-Gm-Message-State: AOAM531Tf5JTsU/S1l6NvsrhG7DaQUBSdCs8OU2BPtRdLgNz36wGGA/2
        DnJIV/bi1fHrvEDUD81WQVbQzA==
X-Google-Smtp-Source: ABdhPJzd8u7r/RDGEtANGyQfgwedHUl5shTP/BHfpDtp0lTOI/ubmRMWeuVYHto4/ElK6FcsVT7r0g==
X-Received: by 2002:ac2:5295:0:b0:443:ddce:d283 with SMTP id q21-20020ac25295000000b00443ddced283mr15040074lfm.246.1646129034218;
        Tue, 01 Mar 2022 02:03:54 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s27-20020a05651c049b00b002460fd4252asm1826822ljc.100.2022.03.01.02.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 02:03:53 -0800 (PST)
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
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH v2 net-next 07/10] net: dsa: Pass MST state changes to driver
Date:   Tue,  1 Mar 2022 11:03:18 +0100
Message-Id: <20220301100321.951175-8-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301100321.951175-1-tobias@waldekranz.com>
References: <20220301100321.951175-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index cc8acb01bd9b..096e6e3a8e1e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -943,6 +943,8 @@ struct dsa_switch_ops {
 				     struct dsa_bridge bridge);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
+	int	(*port_mst_state_set)(struct dsa_switch *ds, int port,
+				      const struct switchdev_mst_state *state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
 	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
 					 struct switchdev_brport_flags flags,
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 87ec0697e92e..a620e079ebc5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -198,6 +198,8 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
+int dsa_port_set_mst_state(struct dsa_port *dp,
+			   const struct switchdev_mst_state *state);
 int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
 void dsa_port_disable_rt(struct dsa_port *dp);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 5f45cb7d70ba..26cfbc8ab499 100644
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
index c6ffcd782b5a..32b006a5b778 100644
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

