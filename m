Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4152F8A2A
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbhAPBBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbhAPBBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:46 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94CAC061796
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:39 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id q22so15848388eja.2
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=95JRoMYzZ1WZMoMU7A/chkV3G/NZyLsEv9E0hpd8Aa8=;
        b=IQDfwbH+DW9HDrvvqCx5XQBOUG1L4GHPdI0RLiqSTSsXZbzbhr0842pz3QkD4b7O+u
         wVax4UFXaaZhHY8v+4W5msppb7DayAQsWxZagXJ+wlYoNGxog8T4/nCLVSdmm9V8NneI
         k1yEe9QmhtcmSrDfVC8cHLneIkRCV37y6mmzqPeW3mWZzFV/opUQ4EVjXD2hnXCBeMCP
         kTmiOH7fZePbuzgx1Qc7tK2qIS34nqHtKJExGMXpsnF1lhvpvtqe63e85R8kcFtCHpoM
         t5UM0h1wzsurSM2/GCD9I7nE7/CnEjhpTwpTmDzjXGA5RmrZrocn3ssz6fwa2vb/MSeW
         8wcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=95JRoMYzZ1WZMoMU7A/chkV3G/NZyLsEv9E0hpd8Aa8=;
        b=MXij4ZElj4n78Z5mVFpaE4T9etO+H+HT9G2ABnthPZt6qs4pXRAX8h06jKK78rVeoV
         IZsIMaLT6cDxWBbqnAjxM97DadXI7KFTDsUvn+ZUrijKDMiwWQmq445WgH4QaT7VNXXA
         7UQnGTtGyll/8r7RE8kB5T+oLMFFiMpXRWFkEkGpGuZt4J4mAw3bdglpJeQfhrU9FZd8
         VVv2KaN8XmYQ0DoBy2fUPRw3TcmTj/76oi5MUrwRp4tEnJXxuhUkOxKrMsJ03vefnQfc
         4LxH6NL7/gem/IKM3UAEkRig21kU61xbMMffvxD83tzt80ayBRAA0AEntr2olWQ0vQdR
         vgHg==
X-Gm-Message-State: AOAM5331jSGco7RQMI8N3RGKLWCVlSCGJUpvV5KSSJ11r3929x+yS5lu
        HLMntPvjR9jq+7uqNDW9dy0=
X-Google-Smtp-Source: ABdhPJyTFzUOVDjZk9G+uUlHdVzRrqXufVL7dU+G7xA+9pzaT05zfZVdvOSlMnnU32Yz19DoHCvb+A==
X-Received: by 2002:a17:907:96a2:: with SMTP id hd34mr5801697ejc.494.1610758838384;
        Fri, 15 Jan 2021 17:00:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 net-next 04/14] net: mscc: ocelot: don't refuse bonding interfaces we can't offload
Date:   Sat, 16 Jan 2021 02:59:33 +0200
Message-Id: <20210116005943.219479-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since switchdev/DSA exposes network interfaces that fulfill many of the
same user space expectations that dedicated NICs do, it makes sense to
not deny bonding interfaces with a bonding policy that we cannot offload,
but instead allow the bonding driver to select the egress interface in
software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v2:
Adapted to the merged version of the DSA API for LAG offload (i.e.
rejecting a bonding interface due to tx_type now done within the
.port_lag_join callback, caller is supposed to handle -EOPNOTSUPP).

 drivers/net/ethernet/mscc/ocelot.c     |  6 ++++-
 drivers/net/ethernet/mscc/ocelot.h     |  3 ++-
 drivers/net/ethernet/mscc/ocelot_net.c | 36 +++++++-------------------
 3 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a560d6be2a44..d3a92c46f610 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1251,12 +1251,16 @@ static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
 }
 
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-			 struct net_device *bond)
+			 struct net_device *bond,
+			 struct netdev_lag_upper_info *info)
 {
 	struct net_device *ndev;
 	u32 bond_mask = 0;
 	int lag, lp;
 
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return -EOPNOTSUPP;
+
 	rcu_read_lock();
 	for_each_netdev_in_bond_rcu(bond, ndev) {
 		struct ocelot_port_private *priv = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e8621dbc14f7..b6c9ddcee554 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -110,7 +110,8 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid);
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-			 struct net_device *bond);
+			 struct net_device *bond,
+			 struct netdev_lag_upper_info *info);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index b80a5bb95163..f246f8fc535d 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1128,12 +1128,19 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 		}
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
-		if (info->linking)
+		if (info->linking) {
 			err = ocelot_port_lag_join(ocelot, port,
-						   info->upper_dev);
-		else
+						   info->upper_dev,
+						   info->upper_info);
+			if (err == -EOPNOTSUPP) {
+				NL_SET_ERR_MSG_MOD(info->info.extack,
+						   "Offloading not supported");
+				err = 0;
+			}
+		} else {
 			ocelot_port_lag_leave(ocelot, port,
 					      info->upper_dev);
+		}
 	}
 
 	return notifier_from_errno(err);
@@ -1162,29 +1169,6 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
 	switch (event) {
-	case NETDEV_PRECHANGEUPPER: {
-		struct netdev_notifier_changeupper_info *info = ptr;
-		struct netdev_lag_upper_info *lag_upper_info;
-		struct netlink_ext_ack *extack;
-
-		if (!ocelot_netdevice_dev_check(dev))
-			break;
-
-		if (!netif_is_lag_master(info->upper_dev))
-			break;
-
-		lag_upper_info = info->upper_info;
-
-		if (lag_upper_info &&
-		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
-			extack = netdev_notifier_info_to_extack(&info->info);
-			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
-
-			return notifier_from_errno(-EINVAL);
-		}
-
-		break;
-	}
 	case NETDEV_CHANGEUPPER: {
 		struct netdev_notifier_changeupper_info *info = ptr;
 
-- 
2.25.1

