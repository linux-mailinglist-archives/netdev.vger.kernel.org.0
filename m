Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDCF342FF0
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhCTWf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCTWfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:35:23 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E0AC061574;
        Sat, 20 Mar 2021 15:35:23 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id k10so15306840ejg.0;
        Sat, 20 Mar 2021 15:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RUGlH2C/m3NuHZvHEgwn1gs0Ssb5YYPGSM/24Rpcs0w=;
        b=eZjuYKWgoCGA4mx3ZSrvp3+wjDfhngpVLwrmL7TiGCtVkUyLnLIYKKaO9MChAW4g0q
         TEbkvONJ5VXqV9EjLSx/iagvzwlvI54cZVIHKR/9IVvefRI7wtJ1N6B+eB5i9SDSJ5nb
         HF4xw2CQNs/1qFHzelbptHoynzgQ/EJNeYVUHABuUu8lXE5dGKDOG6RiGSJFmNILu+Cc
         rq2bv4vKKxllkgzsDmHnKXJ0MWh8LF4clYj91pjPZhfWn4r8nhlCInr3gNjHQiSQr62o
         Q4nY3HscKNcOYaTTLtc8+tgJqAMp0nYZeLbSlpZJH/HNctfi0pHCl7ANJGLOEx/cYXfw
         w87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RUGlH2C/m3NuHZvHEgwn1gs0Ssb5YYPGSM/24Rpcs0w=;
        b=n0YDK6ORQqTbtie5A2KndacpfiDtCwjpOIvyOsMCaXNlNCtZHhwJ07Mof53aGYlneK
         ioxIMiwnmebRYmKnp3qHC64dNcdZHEJNOFxCXgx3nCVtW6JSgQPuYqSSj8kymczNgbXI
         ZnR1Rk8YTOSuxkYf8YkETbeMGTMD3bRQ1uAFI1bEakohh7CYVsRe9g2mEKEDUBrtOodf
         o0/w3cwxrHgA45H6EWGtvsF01VL/yvkmS2ItCY08EYkEIZoFcqMndTRXAhN8hCn9OHKh
         5EY1NeFVwkjiigrzFVgVbefB17C+OYegTFz7oovYpKvB2XdSvbBKlJ2nxjIM1rtBbumI
         XwCg==
X-Gm-Message-State: AOAM533QnK6PDSLY4nfTiq8v7SjPMG34ZUmvVXg+rmTb6fREd3oOuPVO
        mhCCtVFrjPrQFaKsaZv8tmQ=
X-Google-Smtp-Source: ABdhPJyOQCaRUtehiroXYVa0ftRRJkMrgX2YeJ3Gj5kH9ulTp7B/WxkLrqTZuZXGzIp/szqi1C+PsQ==
X-Received: by 2002:a17:906:1a16:: with SMTP id i22mr11789473ejf.522.1616279722081;
        Sat, 20 Mar 2021 15:35:22 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n2sm6090850ejl.1.2021.03.20.15.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:35:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 02/12] net: dsa: pass extack to dsa_port_{bridge,lag}_join
Date:   Sun, 21 Mar 2021 00:34:38 +0200
Message-Id: <20210320223448.2452869-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320223448.2452869-1-olteanv@gmail.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a pretty noisy change that was broken out of the larger change
for replaying switchdev attributes and objects at bridge join time,
which is when these extack objects are actually used.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

 net/dsa/dsa_priv.h | 6 ++++--
 net/dsa/port.c     | 8 +++++---
 net/dsa/slave.c    | 7 +++++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 4c43c5406834..b8778c5d8529 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -181,12 +181,14 @@ int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
 void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
-int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
+int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
+			 struct netlink_ext_ack *extack);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
 int dsa_port_lag_change(struct dsa_port *dp,
 			struct netdev_lag_lower_state_info *linfo);
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
-		      struct netdev_lag_upper_info *uinfo);
+		      struct netdev_lag_upper_info *uinfo,
+		      struct netlink_ext_ack *extack);
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d39262a9fe0e..fcbe5b1545b8 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -144,7 +144,8 @@ static void dsa_port_change_brport_flags(struct dsa_port *dp,
 	}
 }
 
-int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
+int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
+			 struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_bridge_info info = {
 		.tree_index = dp->ds->dst->index,
@@ -241,7 +242,8 @@ int dsa_port_lag_change(struct dsa_port *dp,
 }
 
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
-		      struct netdev_lag_upper_info *uinfo)
+		      struct netdev_lag_upper_info *uinfo,
+		      struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
@@ -263,7 +265,7 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
 		return 0;
 
-	err = dsa_port_bridge_join(dp, bridge_dev);
+	err = dsa_port_bridge_join(dp, bridge_dev, extack);
 	if (err)
 		goto err_bridge_join;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 992fcab4b552..1ff48be476bb 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1976,11 +1976,14 @@ static int dsa_slave_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
 
+	extack = netdev_notifier_info_to_extack(&info->info);
+
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking) {
-			err = dsa_port_bridge_join(dp, info->upper_dev);
+			err = dsa_port_bridge_join(dp, info->upper_dev, extack);
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
 			err = notifier_from_errno(err);
@@ -1991,7 +1994,7 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	} else if (netif_is_lag_master(info->upper_dev)) {
 		if (info->linking) {
 			err = dsa_port_lag_join(dp, info->upper_dev,
-						info->upper_info);
+						info->upper_info, extack);
 			if (err == -EOPNOTSUPP) {
 				NL_SET_ERR_MSG_MOD(info->info.extack,
 						   "Offloading not supported");
-- 
2.25.1

