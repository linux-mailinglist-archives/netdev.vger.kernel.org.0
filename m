Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A3B323B78
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhBXLt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbhBXLqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:46:40 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2D2C06121E
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:19 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id l12so2094693edt.3
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FNtyx1iBEYhZqSggSZzDB0DtbFNpszhXmYMTCDWdd5s=;
        b=gdNxduoY0fIvVxUjggGGpHiewqs8yNLP9Q/NGO6DMcFcwv24g56vE024YdqV8Q/Lue
         6TaBHREknUnMdCK1SpGZMzU/jItNm0e2Rg0AkV+giw7+FUTMU28YzgVO7iGih2Z5Pj2R
         qMQQBhSdcXD+6VDww7IObOWC0STWE4jZHwhdU3UQDaCW1RwTNbyxKzh9ifF2dhU0WqzQ
         Shu8zPk4R+GSpx2odcAd97s9e4xKubhMR0szmPJt12vf6MddlE7lga1lF6AdxwzN80ak
         BPaqq3GXBsJ+b//kXBkQW1cacMm3bwXjZHO6jGKHgxmEKBrBf/FP5UUbJepo85WaB4a6
         LwSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FNtyx1iBEYhZqSggSZzDB0DtbFNpszhXmYMTCDWdd5s=;
        b=Hlk3PLxMmFEFvZhZe0XGshZErNb4SdI3szfaflcMTBu7rqIm/uuhwgsozMGzmJSNvA
         2OdOSRmOLdajX14M/5yOb5KwUFx3D8Ee5F+M2szgPdN0W5SWOKg9E19YiTwb+/o5fIWb
         bQ1Ih0HOtsk4z/h3buNYIdKC6uFujpicID0L9s15VZRUPYlIgE/B21cnQcL70MaeqjPv
         EcH1fI+0HmRL0Dx3UYejmqPl6cun4Pvld57HVn5NptH69+2ahpW1ydbN7ia1NCzAwahP
         1EkhfRWGuw3eqWaQo5Z5lXItqDsikp2lATtCFkoLlz7XRy6EIt7BzsEhZmtGbP4/9o4+
         iFtA==
X-Gm-Message-State: AOAM5335GQbQdJdfd6YzDnMhOS2ZJUDGgIFf3CS9JjAqT+Qlzw2GpKMD
        YkHkFfLJK1GKhBOq5GcZvqnsCZ/mQoE=
X-Google-Smtp-Source: ABdhPJxxNhFIxG32jfjAuZ1vVOdnkON4glhXRu+TS7usS7wRGgrxYNigRRALQcXGF15lQafBsjmC1g==
X-Received: by 2002:a05:6402:1689:: with SMTP id a9mr17261637edv.273.1614167057592;
        Wed, 24 Feb 2021 03:44:17 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 15/17] net: dsa: replay port and local fdb entries when joining the bridge
Date:   Wed, 24 Feb 2021 13:43:48 +0200
Message-Id: <20210224114350.2791260-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When a DSA port joins a LAG that already had an FDB entry pointing to it:

ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static
ip link set swp0 master bond0

the DSA port will have no idea that this FDB entry is there, because it
missed the switchdev event emitted at its creation.

Ido Schimmel pointed this out during a discussion about challenges with
switchdev offloading of stacked interfaces between the physical port and
the bridge, and recommended to just catch that condition and deny the
CHANGEUPPER event:
https://lore.kernel.org/netdev/20210210105949.GB287766@shredder.lan/

But in fact, we might need to deal with the hard thing anyway, which is
to replay all FDB addresses relevant to this port, because it isn't just
static FDB entries, but also local addresses (ones that are not
forwarded but terminated by the bridge). There, we can't just say 'oh
yeah, there was an upper already so I'm not joining that'.

So, similar to the logic for replaying MDB entries, add a function that
must be called by individual switchdev drivers and replays local FDB
entries as well as ones pointing towards a bridge port. This time, we
use the atomic switchdev notifier block, since that's what FDB entries
expect for some reason.

Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h | 10 ++++++++
 include/net/switchdev.h   |  1 +
 net/bridge/br_fdb.c       | 53 +++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c           |  7 +++++-
 4 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 2f0e5713bf39..2a90ac638b06 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -144,6 +144,8 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 				    __u16 vid);
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
+int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  struct notifier_block *nb);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -162,6 +164,14 @@ br_port_flag_is_set(const struct net_device *dev, unsigned long flag)
 {
 	return false;
 }
+
+static inline int br_fdb_replay(struct net_device *br_dev,
+				struct net_device *dev,
+				struct notifier_block *nb)
+{
+	return -EINVAL;
+}
+
 #endif
 
 #endif
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index f1a5a9a3634d..5b63dfd444c6 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -206,6 +206,7 @@ struct switchdev_notifier_info {
 
 struct switchdev_notifier_fdb_info {
 	struct switchdev_notifier_info info; /* must be first */
+	struct list_head list;
 	const unsigned char *addr;
 	u16 vid;
 	u8 added_by_user:1,
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 1d54ae0f58fb..9eb776503b02 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -726,6 +726,59 @@ static inline size_t fdb_nlmsg_size(void)
 		+ nla_total_size(sizeof(u8)); /* NFEA_ACTIVITY_NOTIFY */
 }
 
+static int br_fdb_replay_one(struct notifier_block *nb,
+			     struct net_bridge_fdb_entry *fdb,
+			     struct net_device *dev)
+{
+	struct switchdev_notifier_fdb_info item;
+	int err;
+
+	item.addr = fdb->key.addr.addr;
+	item.vid = fdb->key.vlan_id;
+	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
+	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	item.info.dev = dev;
+
+	err = nb->notifier_call(nb, SWITCHDEV_FDB_ADD_TO_DEVICE, &item);
+	return notifier_to_errno(err);
+}
+
+int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  struct notifier_block *nb)
+{
+	struct net_bridge_fdb_entry *fdb;
+	struct net_bridge *br;
+	int err = 0;
+
+	if (!netif_is_bridge_master(br_dev))
+		return -EINVAL;
+
+	if (!netif_is_bridge_port(dev))
+		return -EINVAL;
+
+	br = netdev_priv(br_dev);
+
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+		struct net_device *dst_dev;
+
+		dst_dev = fdb->dst ? fdb->dst->dev : br->dev;
+		if (dst_dev != br_dev && dst_dev != dev)
+			continue;
+
+		err = br_fdb_replay_one(nb, fdb, dst_dev);
+		if (err)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	return err;
+}
+EXPORT_SYMBOL(br_fdb_replay);
+
 static void fdb_notify(struct net_bridge *br,
 		       const struct net_bridge_fdb_entry *fdb, int type,
 		       bool swdev_notify)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 10b4a0f72dcb..5fa5737e622c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2290,7 +2290,8 @@ bool dsa_slave_dev_check(const struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(dsa_slave_dev_check);
 
-/* Circular reference */
+/* Circular references */
+static struct notifier_block dsa_slave_switchdev_notifier;
 static struct notifier_block dsa_slave_switchdev_blocking_notifier;
 
 static int dsa_slave_changeupper(struct net_device *dev,
@@ -2306,6 +2307,8 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			err = dsa_port_bridge_join(dp, bridge_dev);
 			if (!err) {
 				dsa_bridge_mtu_normalization(dp);
+				br_fdb_replay(bridge_dev, dev,
+					      &dsa_slave_switchdev_notifier);
 				br_mdb_replay(bridge_dev, dev,
 					      &dsa_slave_switchdev_blocking_notifier);
 			}
@@ -2370,6 +2373,8 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 	}
 
 	if (netif_is_bridge_master(info->upper_dev) && !err) {
+		br_fdb_replay(info->upper_dev, dev,
+			      &dsa_slave_switchdev_notifier);
 		br_mdb_replay(info->upper_dev, dev,
 			      &dsa_slave_switchdev_blocking_notifier);
 	}
-- 
2.25.1

