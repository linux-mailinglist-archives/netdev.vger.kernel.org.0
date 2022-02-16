Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2754B8A05
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbiBPNao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:30:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbiBPNam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:30:42 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639A21738E3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:30:30 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id bu29so3947528lfb.0
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=V1eQh2z2Mp1dVqtDPqG/YccGeTfz3qSetOtmZo+4lcI=;
        b=4Z9spyZJh7I6GdzYp1fUuY70ylRefnQynE2afvnnLFa/c9ru744iYsrV7GcIN6GCIr
         azVyPHTH8XsrmRbOF/9lSx5VTcSZAfTlNk0LmtMdOvUycpITjHKdm01opJv6+j3Yz5Ro
         c/ztRs1SefZd5LUk5cDjkz1Vq+TR6PsWDvLGVHZhnLPP8axeyShWStroQAlIxab7MZp1
         UwS+th+DXfSoDOp92F7yzPH6Xv/F71AhcnEd0lepnoZ5ry01Sf1xg95Y1uTY779/YcvD
         vMgLZV5svdBdcAST0pvnBH6TS1vD0+BOGrVJg6VUSR9cMTYLcbrkYGzHSYtxN3geykH+
         V/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=V1eQh2z2Mp1dVqtDPqG/YccGeTfz3qSetOtmZo+4lcI=;
        b=zX4OQQXPXviEt4U2zuxr7BTAkhkEbbFvO1sSbTiawEc6a95YPMsaT6z0T1kGE/9TjE
         En9IjDzrNFlmmPfqUAlfnzpjzGSq3tW9ydLp0aDn1iPRT6nHTjjR72Ya/b08jRe+QPRm
         ubqHLVGhql4Sp3EVgbXXmAk7jpqku8e0mGvmFsb//yIukMwWlvIVKPbjDXQPAvToHp1l
         kG2ztaEWHq4It5TngKMYB2HREnmwEZhOMp3MR9zcZnBVOOrutuxtoU1nMsoEKsBDXGma
         LUcXejvp5U94zOAaxAl9nCsYPG743x0kEHoGEMSLQTn5TTt/Hfw4tT0zFEfOK1K/sEcr
         Llxg==
X-Gm-Message-State: AOAM531HeSrDkPPQ1MzmzJYpWuyxOYTwIzJNPsFcnGTSOsniBwKVTgxm
        p2XGQVT9ZJ/ukNosrDqWCuBhnQ==
X-Google-Smtp-Source: ABdhPJxrdT9GpN5CD0SXwHRy99cf5gwLF/Zjv5+srBYJhHsU3KKNdraqOtxfe9PAMcnY4S+oWN1L8Q==
X-Received: by 2002:a05:6512:22c5:b0:443:890c:a9e3 with SMTP id g5-20020a05651222c500b00443890ca9e3mr2007506lfu.662.1645018228436;
        Wed, 16 Feb 2022 05:30:28 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v6sm234780ljd.86.2022.02.16.05.30.27
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
Subject: [RFC net-next 5/9] net: dsa: Pass VLAN MST migration notifications to driver
Date:   Wed, 16 Feb 2022 14:29:30 +0100
Message-Id: <20220216132934.1775649-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216132934.1775649-1-tobias@waldekranz.com>
References: <20220216132934.1775649-1-tobias@waldekranz.com>
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
to the drivers for VLAN MST migrations.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/dsa.h    |  3 +++
 net/bridge/br_vlan.c |  2 +-
 net/dsa/dsa_priv.h   |  1 +
 net/dsa/port.c       | 10 ++++++++++
 net/dsa/slave.c      |  6 ++++++
 5 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fd1f62a6e0a8..2aabe7f0b176 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -901,6 +901,9 @@ struct dsa_switch_ops {
 				 struct netlink_ext_ack *extack);
 	int	(*port_vlan_del)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan);
+	int	(*vlan_mstid_set)(struct dsa_switch *ds,
+				  const struct switchdev_attr *attr);
+
 	/*
 	 * Forwarding database
 	 */
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index c45a34c14e10..48b2f5dd277c 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -173,7 +173,7 @@ static int br_vlan_mst_migrate(struct net_bridge_vlan *v, u16 mstid)
 	old_mst = rtnl_dereference(v->mst);
 	rcu_assign_pointer(v->mst, mst);
 
-	if (br_vlan_is_master(v)) {
+	if (!old_mst || br_vlan_is_master(v)) {
 		struct switchdev_attr attr = {
 			.id = SWITCHDEV_ATTR_ID_VLAN_MSTID,
 			.flags = SWITCHDEV_F_DEFER,
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2bbfa9efe9f8..43709c005461 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -204,6 +204,7 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
+int dsa_port_vlan_mstid(struct dsa_port *dp, const struct switchdev_attr *attr);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bd78192e0e47..4fb2bf2383d9 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -729,6 +729,16 @@ int dsa_port_bridge_flags(struct dsa_port *dp,
 	return 0;
 }
 
+int dsa_port_vlan_mstid(struct dsa_port *dp, const struct switchdev_attr *attr)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->vlan_mstid_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->vlan_mstid_set(ds, attr);
+}
+
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2f6caf5d037e..0a5e44105add 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -314,6 +314,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
 		break;
+	case SWITCHDEV_ATTR_ID_VLAN_MSTID:
+		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
+		ret = dsa_port_vlan_mstid(dp, attr);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
-- 
2.25.1

