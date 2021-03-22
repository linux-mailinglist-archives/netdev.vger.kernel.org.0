Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66E234534C
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhCVXwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhCVXwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:08 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C82DC061574;
        Mon, 22 Mar 2021 16:52:07 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id hq27so24111759ejc.9;
        Mon, 22 Mar 2021 16:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PqzMdjhV83LXsXb2kivK1TtVxn6ToXVfM5lC7LerSCY=;
        b=V36fTkVTj174Ff6kbcd4RUHIGnsQ2X68qQgURWhEBIEJhIo8aTBgyYG9tH7NnV8/Hr
         3AeWQf4OWxqURjcx4j0zKlKNs7aWrGEfio5ikbWk/uYUbXNBxfGY3KR/LYRtpGGq2bEL
         YAj79ITkwnUuAqfFL1d7PcCrSXzyZpth87K7HLwOwW4qBCWDyggfuE7KwvQ2scgFomUU
         zFZLsdeW4XTzQEtuKf2kdY+ENWVSmqby5Gq6fA3YYDwLu+h9js3xjIqwqwlsriWoTYp3
         27b8M4Onsy862soxmV6nIBLNJ/RbAoCa6yzrm2bFoRFCKU9RD0yAvDTn6PwMBjRf8BZ1
         nnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PqzMdjhV83LXsXb2kivK1TtVxn6ToXVfM5lC7LerSCY=;
        b=KBtAkYcsNl3WbNcw4zIwNbAO3G0hAv7j9O5fxptRtDSF9VAFMKT95fNriZQ22NmJFe
         UCOGgZl7VdxPAQFmNOp2VmNl1Baq4HftYW/vluGy5qRRbDDzaS3nZdssrN3aAW2APkL2
         Z9Pq0pzJ0yU6RjY3dB/rv7MAVH9hnskXRYbkzqVTANb8Vz3r+Z/TxK9kJYegbXqyKKVp
         c3LxodhViQdq0escGxqjrcN+BvR5ffNA97qzthbSbCkSZ7YlK4iKlNoj0eKQSgh85Ryz
         1BakKDZcMrbbQXE+WLoAMkpOOJsYIt5D7Ka3cah0OX9wT10Rty3Rbo9b3eQwbRbzMa84
         ObiQ==
X-Gm-Message-State: AOAM530m/duoYafm7G7z83PpRpwIvw44fayFPCn/0ZzMVKjggejkyIDd
        es2V7vDEIHDSpGiLPHsvOh41RCCpn0Q=
X-Google-Smtp-Source: ABdhPJz7Dys6eSoQpDlOu4Yb2/lmja+Qf5fwPq6I/O2bYqdJ0ipLa4hBcw2catE+XOqHs/Gt0uvROA==
X-Received: by 2002:a17:906:1453:: with SMTP id q19mr2220820ejc.76.1616457126334;
        Mon, 22 Mar 2021 16:52:06 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:06 -0700 (PDT)
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
Subject: [PATCH v4 net-next 04/11] net: bridge: add helper to replay port and local fdb entries
Date:   Tue, 23 Mar 2021 01:51:45 +0200
Message-Id: <20210322235152.268695-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When a switchdev port starts offloading a LAG that is already in a
bridge and has an FDB entry pointing to it:

ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static
ip link set swp0 master bond0

the switchdev driver will have no idea that this FDB entry is there,
because it missed the switchdev event emitted at its creation.

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
 include/linux/if_bridge.h |  9 +++++++
 net/bridge/br_fdb.c       | 50 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index f6472969bb44..b564c4486a45 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -147,6 +147,8 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
 clock_t br_get_ageing_time(struct net_device *br_dev);
+int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  struct notifier_block *nb);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -175,6 +177,13 @@ static inline clock_t br_get_ageing_time(struct net_device *br_dev)
 {
 	return 0;
 }
+
+static inline int br_fdb_replay(struct net_device *br_dev,
+				struct net_device *dev,
+				struct notifier_block *nb)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index b7490237f3fc..698b79747d32 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -726,6 +726,56 @@ static inline size_t fdb_nlmsg_size(void)
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
+	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
+		return -EINVAL;
+
+	br = netdev_priv(br_dev);
+
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+		struct net_bridge_port *dst = READ_ONCE(fdb->dst);
+		struct net_device *dst_dev;
+
+		dst_dev = dst ? dst->dev : br->dev;
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
+EXPORT_SYMBOL_GPL(br_fdb_replay);
+
 static void fdb_notify(struct net_bridge *br,
 		       const struct net_bridge_fdb_entry *fdb, int type,
 		       bool swdev_notify)
-- 
2.25.1

