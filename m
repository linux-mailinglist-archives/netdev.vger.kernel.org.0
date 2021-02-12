Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728443197C2
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhBLBGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhBLBG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 20:06:26 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C72C061756;
        Thu, 11 Feb 2021 17:05:46 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id b9so12965930ejy.12;
        Thu, 11 Feb 2021 17:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NsYYUoZirikxAfZHJuEiC70aCOck9XBnivP9XJTWXCE=;
        b=BXMn0rOx9X7XegIpk2IcxDqSSuscQfwbNBXd9qbKBYm1SlJY27Tmdv7gldMckrifvV
         J/PDJYd2XOet3dhV0hmvAzJC52Jp1gfAHBH0XzNFe5/Rz5Eq7lWMPkH91TPAIvaEHCj0
         SirsLoaXkhFhPbjKvmFPa03f4IPyI1BSKFw1qH5R6K1x3kyNhjcm1EW2J8qb9GNyoH80
         HgkjuptGopiqaYjJtko7mf0ir28rBXhbNBMVVB4aeIrMq7lowaTiYEwmhmy3vupz/rNd
         Yp9lczZIsPu/9DYoevi7WUQD52zsCPsG0r2fMmh/OJRTSY6Eb0qV41uHPGZAxxhLt7Y1
         9qLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NsYYUoZirikxAfZHJuEiC70aCOck9XBnivP9XJTWXCE=;
        b=VHUHlz56qOJ0go5lAmR5RFQnSt6T80vba24k6BsuWcb96mvqvRbCwopp8ctaYl6UbH
         qOzdtIzI4y0gh0lt99RrNP1ipbLYDkSguUASPf5Kg8enZJvrAPVCrdBxzkFMlJytpzI3
         2rt8CoIPeUkuJ+kV3kxOj7xzf7KYimkY/gcJ3ZU0VOwzZHYxRvTmx/OkXXCl7mySYQtZ
         ExaAX/QHQ+Nge38FoVhbtMldCjEQc2/l3j+8zVcd80EB2lDq65ty5qMywUsK7MCxSqY+
         Nn04mlaXogRpQvemaDhg8shayP8EVcFpeRqNgHoTonOVaocdLzGFMnVSKaX5FWltnEIy
         ZVrA==
X-Gm-Message-State: AOAM532M5XsHQtejNFcQfvlW8zMj8c2Sru/FPFP89T1ev1AdKlOPTah5
        PLrxMdqB5LbFXzz3IpEIgWU=
X-Google-Smtp-Source: ABdhPJzdhTBKTee0VKd2IHvm3rpatEQarF1x8QltJ7Bqj2h1N/JKQwTlJ1O5eGRJV7Q6/rBEiKVHog==
X-Received: by 2002:a17:906:1355:: with SMTP id x21mr456420ejb.53.1613091944897;
        Thu, 11 Feb 2021 17:05:44 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z13sm5019580edc.73.2021.02.11.17.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 17:05:44 -0800 (PST)
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
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v4 net-next 1/9] net: switchdev: propagate extack to port attributes
Date:   Fri, 12 Feb 2021 03:05:23 +0200
Message-Id: <20210212010531.2722925-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212010531.2722925-1-olteanv@gmail.com>
References: <20210212010531.2722925-1-olteanv@gmail.com>
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
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 .../ethernet/marvell/prestera/prestera_switchdev.c    |  3 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c  |  3 ++-
 drivers/net/ethernet/mscc/ocelot_net.c                |  3 ++-
 drivers/net/ethernet/ti/cpsw_switchdev.c              |  3 ++-
 include/net/switchdev.h                               |  6 ++++--
 net/dsa/slave.c                                       |  3 ++-
 net/switchdev/switchdev.c                             | 11 ++++++++---
 7 files changed, 22 insertions(+), 10 deletions(-)

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
index 431bdbdd8473..8f4c7c232e2c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -271,7 +271,8 @@ static int dsa_slave_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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

