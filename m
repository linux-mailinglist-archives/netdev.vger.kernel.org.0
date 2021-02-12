Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF91E31A162
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhBLPRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhBLPQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:16:51 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB6CC061756;
        Fri, 12 Feb 2021 07:16:11 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id i8so16219593ejc.7;
        Fri, 12 Feb 2021 07:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zlnjjFKVXOU0oDaJe+Eu8LG96OjY+3k7oZOIep+RtFc=;
        b=AIi+qIRyj6gQAHfCJw1wD5QNm2KIo3AWJW58DjXGAYsHdp3nWp6JoVnfd1cUvTMqNq
         C3GBfMMW7hJaYsvqhD7ft7yF9TsPci6nvI4V/+3qfPbHp25fuJjDJDnDhWd56LATg089
         C1QKyJ9b/7GuMpv161MNp1szF+QWgJCqYbLOdyQ2QpGFfdl2kE7PxylqzVapcpxbUBe1
         Ei05eyIF/bR0Cym981XcIabKgmJd1hn4z67Z1ra9ev62+nBmj8jIBdvQyBNoRrFGealn
         /Rdayvj6qls3zRiFOYswgwz/DHcICbq4bjnAdzKmzt/Jap3jGXOkW+/ihZBO69+gJ2eo
         X4+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zlnjjFKVXOU0oDaJe+Eu8LG96OjY+3k7oZOIep+RtFc=;
        b=t7CyJk7YN9RxA6Lck0wdxI9ZIVY7EqeVosbkJSfPyaTQnMAOaFqbTO57C5gTrrHxzK
         Y95JP6gXnnCTr68d/9aXt6pg1mo8ZFZB2heQnAls5tQ0p6nT5FUXHK/WfFIZtfCKQWZZ
         Ho6HgC83bOw45mAtdSVKmAd2XXLookueGgY0MGi7XxyyREWKYm42KoZrZnCu907ZlIea
         5ef66oexUjb5kx3yAjF9UDzlPJuiiKznXv70wdxxTgJhxeXYuOYSt5WZtKlpAtR8vrh0
         ejPuEC1Uqey3evet16N1utqglIMimaCO/fV7/aevP8R2Xf+VPiyQ80hG5eg5q9+wMwxK
         jXpg==
X-Gm-Message-State: AOAM532u1ID8mlRRvlJqsc7TNgt7xquTVnEkkNALwZO25hV170TckGqf
        xg+o/SBKeljJ39yLz/lwAx8=
X-Google-Smtp-Source: ABdhPJxeCyxi9KPbcyN3yxNJUfpgpxfqZIf4SjJr31ziOyajmsidlG4SisiFvs2XHeADyKmNgalz4A==
X-Received: by 2002:a17:906:8159:: with SMTP id z25mr3527245ejw.270.1613142970463;
        Fri, 12 Feb 2021 07:16:10 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z19sm6515456edr.69.2021.02.12.07.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:16:10 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v5 net-next 01/10] net: switchdev: propagate extack to port attributes
Date:   Fri, 12 Feb 2021 17:15:51 +0200
Message-Id: <20210212151600.3357121-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212151600.3357121-1-olteanv@gmail.com>
References: <20210212151600.3357121-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When a struct switchdev_attr is notified through switchdev, there is no
way to report informational messages, unlike for struct switchdev_obj.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
Rebased on top of AM65 CPSW driver merge.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Patch is new.

 .../ethernet/marvell/prestera/prestera_switchdev.c    |  3 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c  |  3 ++-
 drivers/net/ethernet/mscc/ocelot_net.c                |  3 ++-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c         |  3 ++-
 drivers/net/ethernet/ti/cpsw_switchdev.c              |  3 ++-
 include/net/switchdev.h                               |  6 ++++--
 net/dsa/slave.c                                       |  3 ++-
 net/switchdev/switchdev.c                             | 11 ++++++++---
 8 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 8c2b03151736..2c1619715a4b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -695,7 +695,8 @@ static int prestera_port_attr_stp_state_set(struct prestera_port *port,
 }
 
 static int prestera_port_obj_attr_set(struct net_device *dev,
-				      const struct switchdev_attr *attr)
+				      const struct switchdev_attr *attr,
+				      struct netlink_ext_ack *extack)
 {
 	struct prestera_port *port = netdev_priv(dev);
 	int err = 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 20c4f3c2cf23..18e4f1cd5587 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -887,7 +887,8 @@ mlxsw_sp_port_attr_br_mrouter_set(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_attr_set(struct net_device *dev,
-				  const struct switchdev_attr *attr)
+				  const struct switchdev_attr *attr,
+				  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	int err;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 8f12fa45b1b5..f9da4aa39444 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1005,7 +1005,8 @@ static void ocelot_port_attr_mc_set(struct ocelot *ocelot, int port, bool mc)
 }
 
 static int ocelot_port_attr_set(struct net_device *dev,
-				const struct switchdev_attr *attr)
+				const struct switchdev_attr *attr,
+				struct netlink_ext_ack *extack)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 1067e7772dbf..314825acf0a0 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -81,7 +81,8 @@ static int am65_cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
 }
 
 static int am65_cpsw_port_attr_set(struct net_device *ndev,
-				   const struct switchdev_attr *attr)
+				   const struct switchdev_attr *attr,
+				   struct netlink_ext_ack *extack)
 {
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	int ret;
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index 9967cf985728..13524cbaa8b6 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -83,7 +83,8 @@ static int cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
 }
 
 static int cpsw_port_attr_set(struct net_device *ndev,
-			      const struct switchdev_attr *attr)
+			      const struct switchdev_attr *attr,
+			      struct netlink_ext_ack *extack)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	int ret;
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 6dcfc4c51a6e..9279d4245bab 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -281,7 +281,8 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*set_cb)(struct net_device *dev,
-				      const struct switchdev_attr *attr));
+				      const struct switchdev_attr *attr,
+				      struct netlink_ext_ack *extack));
 #else
 
 static inline void switchdev_deferred_process(void)
@@ -372,7 +373,8 @@ switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*set_cb)(struct net_device *dev,
-				      const struct switchdev_attr *attr))
+				      const struct switchdev_attr *attr,
+				      struct netlink_ext_ack *extack))
 {
 	return 0;
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a95e78d59740..be29008477d3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -272,7 +272,8 @@ static int dsa_slave_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 }
 
 static int dsa_slave_port_attr_set(struct net_device *dev,
-				   const struct switchdev_attr *attr)
+				   const struct switchdev_attr *attr,
+				   struct netlink_ext_ack *extack)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 94113ca29dcf..0b84f076591e 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -488,14 +488,18 @@ static int __switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*set_cb)(struct net_device *dev,
-				      const struct switchdev_attr *attr))
+				      const struct switchdev_attr *attr,
+				      struct netlink_ext_ack *extack))
 {
+	struct netlink_ext_ack *extack;
 	struct net_device *lower_dev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
+	extack = switchdev_notifier_info_to_extack(&port_attr_info->info);
+
 	if (check_cb(dev)) {
-		err = set_cb(dev, port_attr_info->attr);
+		err = set_cb(dev, port_attr_info->attr, extack);
 		if (err != -EOPNOTSUPP)
 			port_attr_info->handled = true;
 		return err;
@@ -525,7 +529,8 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*set_cb)(struct net_device *dev,
-				      const struct switchdev_attr *attr))
+				      const struct switchdev_attr *attr,
+				      struct netlink_ext_ack *extack))
 {
 	int err;
 
-- 
2.25.1

