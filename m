Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647B24DB461
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347871AbiCPPKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356985AbiCPPKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:10:40 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED7866FB4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:13 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id b28so4261525lfc.4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=d1BPMRKxP52kqIHBcYfv+0vEKYw9y4Sk7A+PWhYRB3M=;
        b=JvGREIFQ1BG2lwf1zdrkJ+VV4ISKNgYdDxovVbf5NDiAaNU7sTEgx871jrhfLw1+Ex
         QioilQU+3XZhNISk2JtzgRX1RcE+z82KC5LmEMIglOEWU8qziKJrCjjk5V+j8ON1lZUm
         pqxunc2ibDUUQUqJeIujxsx9i1Ed6La3k6/+U7kE4kFf9EdWNpmYkpXNQziPVWhz4Msc
         G715rdUj1E7XZ05Q2pIgbfw89eH4P7+1EH+86J9MDg0hqC8jbl/vAuP4+XfETDAuncx2
         4hRtHFJ/qpLNkJPiZqA90NttDGf+zo9Nkia3fIzezvWnB8WGdH/SFEOV1/sxj4OLvbIw
         s4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=d1BPMRKxP52kqIHBcYfv+0vEKYw9y4Sk7A+PWhYRB3M=;
        b=zmi9DzO1hg5HrSbTvMby2TK1QfAT40n2Z7HcOl4MjZxxeU2Kd4CMvk/asWgti1zkXv
         bONHX08XaszJvDt/UhZvE/bSNmsWzwZ8/rmkGVjmTqukwfbJOlWbCo5rX21yYJ11Zt5u
         OauEVKRUs9l+aEa4RpZlSCgpFMhek1VlGK/pyS9AbMJCP4xjV0jqS2lTGotf5ihULrdU
         LA9+IiZaaAVNXqAjZz8/4OhIa6aolgl9y/ZmKJYcENt/yO8iIob4gRFG6CmQcmjqHO9N
         cj5CsbXJt9VeJcirYHu6xAYA0Q6JsGocVK1qkhQHSs4Fy9DHK26wDMVEDr7VmMeMDcJj
         aP+Q==
X-Gm-Message-State: AOAM53119PICcGF2aKoLG4OcXcp9O2QDpajml9Bma1HAT3Qz7nLpGZrT
        wiGqYuogTV0nDdwJryyAbm+Rew==
X-Google-Smtp-Source: ABdhPJxMW/eT3zQ6KmIHZbGDQZwoxkr1BXNgOZyryO7sKwzMXNNO3abS0nhIysWP9M350MqfyFJP6Q==
X-Received: by 2002:ac2:5932:0:b0:448:bdb3:a23d with SMTP id v18-20020ac25932000000b00448bdb3a23dmr81354lfi.436.1647443352049;
        Wed, 16 Mar 2022 08:09:12 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d2-20020a194f02000000b00448b915e2d3sm176048lfb.99.2022.03.16.08.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:09:11 -0700 (PDT)
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
Subject: [PATCH v5 net-next 05/15] net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrations
Date:   Wed, 16 Mar 2022 16:08:47 +0100
Message-Id: <20220316150857.2442916-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316150857.2442916-1-tobias@waldekranz.com>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
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

Whenever a VLAN moves to a new MSTI, send a switchdev notification so
that switchdevs can track a bridge's VID to MSTI mappings.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/switchdev.h   |  7 ++++++
 net/bridge/br_mst.c       | 13 +++++++++++
 net/bridge/br_switchdev.c | 46 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 85dd004dc9ad..53dfa0f7cf5b 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -29,6 +29,7 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
 	SWITCHDEV_ATTR_ID_BRIDGE_MST,
 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
+	SWITCHDEV_ATTR_ID_VLAN_MSTI,
 };
 
 struct switchdev_brport_flags {
@@ -36,6 +37,11 @@ struct switchdev_brport_flags {
 	unsigned long mask;
 };
 
+struct switchdev_vlan_msti {
+	u16 vid;
+	u16 msti;
+};
+
 struct switchdev_attr {
 	struct net_device *orig_dev;
 	enum switchdev_attr_id id;
@@ -52,6 +58,7 @@ struct switchdev_attr {
 		bool mst;				/* BRIDGE_MST */
 		bool mc_disabled;			/* MC_DISABLED */
 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
+		struct switchdev_vlan_msti vlan_msti;	/* VLAN_MSTI */
 	} u;
 };
 
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 43ca6b97c5c3..29266174e6b4 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -69,13 +69,26 @@ static void br_mst_vlan_sync_state(struct net_bridge_vlan *pv, u16 msti)
 
 int br_mst_vlan_set_msti(struct net_bridge_vlan *mv, u16 msti)
 {
+	struct switchdev_attr attr = {
+		.id = SWITCHDEV_ATTR_ID_VLAN_MSTI,
+		.orig_dev = mv->br->dev,
+		.u.vlan_msti = {
+			.vid = mv->vid,
+			.msti = msti,
+		},
+	};
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *pv;
 	struct net_bridge_port *p;
+	int err;
 
 	if (mv->msti == msti)
 		return 0;
 
+	err = switchdev_port_attr_set(mv->br->dev, &attr, NULL);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	mv->msti = msti;
 
 	list_for_each_entry(p, &mv->br->port_list, list) {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6f6a70121a5e..8cc44c367231 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -331,6 +331,46 @@ br_switchdev_fdb_replay(const struct net_device *br_dev, const void *ctx,
 	return err;
 }
 
+static int br_switchdev_vlan_attr_replay(struct net_device *br_dev,
+					 const void *ctx,
+					 struct notifier_block *nb,
+					 struct netlink_ext_ack *extack)
+{
+	struct switchdev_notifier_port_attr_info attr_info = {
+		.info = {
+			.dev = br_dev,
+			.extack = extack,
+			.ctx = ctx,
+		},
+	};
+	struct net_bridge *br = netdev_priv(br_dev);
+	struct net_bridge_vlan_group *vg;
+	struct switchdev_attr attr;
+	struct net_bridge_vlan *v;
+	int err;
+
+	attr_info.attr = &attr;
+	attr.orig_dev = br_dev;
+
+	vg = br_vlan_group(br);
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		if (v->msti) {
+			attr.id = SWITCHDEV_ATTR_ID_VLAN_MSTI;
+			attr.u.vlan_msti.vid = v->vid;
+			attr.u.vlan_msti.msti = v->msti;
+
+			err = nb->notifier_call(nb, SWITCHDEV_PORT_ATTR_SET,
+						&attr_info);
+			err = notifier_to_errno(err);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
 static int
 br_switchdev_vlan_replay_one(struct notifier_block *nb,
 			     struct net_device *dev,
@@ -425,6 +465,12 @@ static int br_switchdev_vlan_replay(struct net_device *br_dev,
 			return err;
 	}
 
+	if (adding) {
+		err = br_switchdev_vlan_attr_replay(br_dev, ctx, nb, extack);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
2.25.1

