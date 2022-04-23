Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15D850CDF9
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 00:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbiDWW5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 18:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbiDWW5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 18:57:13 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3725B25C65
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 15:54:15 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j15so2598663wrb.2
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 15:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=58LTSpfvYXureL2ZRdXqzs4JchNCMeiRPcSufB6AfLs=;
        b=W2/02Zqn5+H+4MGt+Hpa8Yyq4GC068QXZmw8fivU7j8UhtXCgp3UI47RK/tyJJScKh
         D7YQGZqFlUAxrCZCkh1ekHsdp1z2ksL2QadTcvU0E8fwOA/V2hmwEMb6uBNxFC29/oUd
         PRrIXYY9wh+9ecFsywoj1cpYpjupPsHmd0MF5u6xQPObY44GEYbPWY9N6RWHHMgWZjks
         gqikXxZ7y3FRGcO/5WyCgYm2QL3laF2GhOvUIGud4WOXjjjlE8z6Krv7f7BKRaV+/n1m
         ekrsvzR1Lzx8miuCABYqzHXqKYOAkTDqM52u6KviePbHpBaxezlbqrea3+Tax1/X04M2
         lTFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=58LTSpfvYXureL2ZRdXqzs4JchNCMeiRPcSufB6AfLs=;
        b=PcK+omGo0/usTwVVvzSUbRYVWTmEidH1SzNNxtIZIC1XKvYfIKLiWMEWyivSzIXULd
         XfXCRJReaIwjNrBfaRs4pCa9sSxelTIGvmSweAv0dYLY0kKKEh6Ca/8TrnfGCuQleBGC
         f2E7ixuPZnran/2WsFeH1zmplJMD3I3hybyuDAvv4DJlKKyaqCn7jdKv+qLxOYTNIGKR
         py2ZkvOU+Pa70sinW0i1Yts/Wrw97iFtpV+e1V0ZMSSjE59o/JI6vsd5H8YrVmfA7gZ8
         gEqdfa6EmQsvFqyDWooI3p/Jv4oLc+Un80WkfV2NbPtLkhEVj3fMKZV7UG24ckPAtZLg
         ZikQ==
X-Gm-Message-State: AOAM530mcs/BkWez1JTTCVjRIJyhEjKBCcExMhFSb9SjewCOJmZ9f6NV
        kuRfWp786BIugHU880302Pw=
X-Google-Smtp-Source: ABdhPJyG/otKk0TgkWGqjbZQEQBpi2YcuMOC4g81OhuD3B3YjPphJ7JI11WWdGAUpD5h5JDcfpE+Ig==
X-Received: by 2002:a05:6000:144d:b0:20a:a188:7b28 with SMTP id v13-20020a056000144d00b0020aa1887b28mr8458624wrx.643.1650754453744;
        Sat, 23 Apr 2022 15:54:13 -0700 (PDT)
Received: from alaa-emad ([197.57.78.84])
        by smtp.gmail.com with ESMTPSA id az20-20020a05600c601400b0038ffb253bb3sm9327381wmb.36.2022.04.23.15.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 15:54:13 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com,
        roopa.prabhu@gmail.com, jdenham@redhat.com, sbrivio@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v2 1/2] rtnetlink: add extack support in fdb del handlers
Date:   Sun, 24 Apr 2022 00:54:07 +0200
Message-Id: <6a77eca533b7048b85bf0ffe0c3904d36045c320.1650754231.git.eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650754228.git.eng.alaamohamedsoliman.am@gmail.com>
References: <cover.1650754228.git.eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add extack support to .ndo_fdb_del in netdevice.h and
all related methods.

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c        | 3 +--
 drivers/net/ethernet/mscc/ocelot_net.c           | 4 ++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 2 +-
 drivers/net/macvlan.c                            | 2 +-
 drivers/net/vxlan/vxlan_core.c                   | 2 +-
 include/linux/netdevice.h                        | 2 +-
 net/bridge/br_fdb.c                              | 2 +-
 net/bridge/br_private.h                          | 2 +-
 net/core/rtnetlink.c                             | 4 ++--
 9 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d768925785ca..5f9cb4830956 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5678,10 +5678,9 @@ ice_fdb_add(struct ndmsg *ndm, struct nlattr __always_unused *tb[],
 static int
 ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
 	    struct net_device *dev, const unsigned char *addr,
-	    __always_unused u16 vid)
+	    __always_unused u16 vid, struct netlink_ext_ack *extack)
 {
 	int err;
-
 	if (ndm->ndm_state & NUD_PERMANENT) {
 		netdev_err(dev, "FDB only supports static addresses\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 247bc105bdd2..e07c64e3159c 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -774,14 +774,14 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 
 static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			       struct net_device *dev,
-			       const unsigned char *addr, u16 vid)
+			       const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge);
+	return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge, extack);
 }
 
 static int ocelot_port_fdb_dump(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index d320567b2cca..51fa23418f6a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -368,7 +368,7 @@ static int qlcnic_set_mac(struct net_device *netdev, void *p)
 
 static int qlcnic_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			struct net_device *netdev,
-			const unsigned char *addr, u16 vid)
+			const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
 	int err = -EOPNOTSUPP;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 069e8824c264..ffd34d9f7049 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1017,7 +1017,7 @@ static int macvlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 
 static int macvlan_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			   struct net_device *dev,
-			   const unsigned char *addr, u16 vid)
+			   const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	int err = -EINVAL;
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index de97ff98d36e..cf2f60037340 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1280,7 +1280,7 @@ int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
 /* Delete entry (via netlink) */
 static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 			    struct net_device *dev,
-			    const unsigned char *addr, u16 vid)
+			    const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	union vxlan_addr ip;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 28ea4f8269d4..d0d2a8f33c73 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1509,7 +1509,7 @@ struct net_device_ops {
 					       struct nlattr *tb[],
 					       struct net_device *dev,
 					       const unsigned char *addr,
-					       u16 vid);
+					       u16 vid, struct netlink_ext_ack *extack);
 	int			(*ndo_fdb_dump)(struct sk_buff *skb,
 						struct netlink_callback *cb,
 						struct net_device *dev,
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6ccda68bd473..5bfce2e9a553 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1110,7 +1110,7 @@ static int __br_fdb_delete(struct net_bridge *br,
 /* Remove neighbor entry with RTM_DELNEIGH */
 int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 		  struct net_device *dev,
-		  const unsigned char *addr, u16 vid)
+		  const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_port *p = NULL;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 18ccc3d5d296..95348c1c9ce5 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -780,7 +780,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 		   const unsigned char *addr, u16 vid, unsigned long flags);
 
 int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
-		  struct net_device *dev, const unsigned char *addr, u16 vid);
+		  struct net_device *dev, const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack);
 int br_fdb_add(struct ndmsg *nlh, struct nlattr *tb[], struct net_device *dev,
 	       const unsigned char *addr, u16 vid, u16 nlh_flags,
 	       struct netlink_ext_ack *extack);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4041b3e2e8ec..99b30ae58a47 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4223,7 +4223,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		const struct net_device_ops *ops = br_dev->netdev_ops;
 
 		if (ops->ndo_fdb_del)
-			err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
+			err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid, extack);
 
 		if (err)
 			goto out;
@@ -4235,7 +4235,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ndm->ndm_flags & NTF_SELF) {
 		if (dev->netdev_ops->ndo_fdb_del)
 			err = dev->netdev_ops->ndo_fdb_del(ndm, tb, dev, addr,
-							   vid);
+							   vid, extack);
 		else
 			err = ndo_dflt_fdb_del(ndm, tb, dev, addr, vid);
 
-- 
2.36.0

