Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B159D345361
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhCVXxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhCVXwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:18 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C36DC061756;
        Mon, 22 Mar 2021 16:52:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id kt15so14623342ejb.12;
        Mon, 22 Mar 2021 16:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3j9IRf1uS0iLbr0h9QeCEpTgMc/Yj8/rDEYeUIAudAc=;
        b=F30raTqhVpI1HIDCM0AWkT4amevPv6V9djZa2FCvv75xrWL7yT7CyjMGf3KeVWjk8h
         +ADlbfGR6MVPV9suYuzKvpzuFUvwULIfR1EZpOveASu4U0aBuoAKKQtCy+EL68iE4jCb
         YKXCHUBu89Ls0g+wq/R0tSg8xvd1fqFFp2DRmgLwWVLpPcUCZOMVrxwtOSeqmjFMQ1QM
         buepLuNzzuoRrmOPKj3jGzLESGd6SLjlu9Des8zZbKEqeKeEcxwGVCDHcSEfioj13G2w
         VJpOG5qxXnA3Ejouz49jH/8UTGfumrF5zr9jFLMPRNQJEMpiyZk7PFEFsicWUWIchZUU
         8U/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3j9IRf1uS0iLbr0h9QeCEpTgMc/Yj8/rDEYeUIAudAc=;
        b=SG1wYmBLdrln4jDpl0Zq88shhIQPvmMiaYwv2X9K5InldrnwLeoo4hIqGd/dHVlo7X
         jWlzg1TwfAmt6P575cZSaecKR6wgz0GIoLnw/vF6LMzDO5e68l90tPlRZch3EMFgHjuE
         Asbv+pjBHn5bgjVDP58GGCwh98/hzRMe/WikO6WAo/5Kdj82DqQ5e7rBDYWAZ6l55P3j
         fE9YI7LfoT769agtWnpLRxCjGt81og3DMkWng0my17K81WUMf4KfaJVLSfbw24/Hp9Tc
         LZLrOZJD0ucFqifucR4uYHy193czZhyEKmjGKKg8+1jv6TScz+MQ6ywevRJ5uvRu2TkS
         4yRg==
X-Gm-Message-State: AOAM530sTnPW9HoC33iRrgcZYbyGUgXmSp+GLCgxoM2Av57CKevpg40P
        a4t3FXfIPESBshu1wrnIK8uZ7uZ5F90=
X-Google-Smtp-Source: ABdhPJwdGMx9ufDQ3y8O5ClwKZ2yNT6BXZMr5NoIo/z0gd4z1fFM0R+yw5Rd4lCowYUfD2Eq7Lfeeg==
X-Received: by 2002:a17:906:80ca:: with SMTP id a10mr2125859ejx.297.1616457130535;
        Mon, 22 Mar 2021 16:52:10 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:10 -0700 (PDT)
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
Subject: [PATCH v4 net-next 07/11] net: dsa: pass extack to dsa_port_{bridge,lag}_join
Date:   Tue, 23 Mar 2021 01:51:48 +0200
Message-Id: <20210322235152.268695-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
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
Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
---
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

