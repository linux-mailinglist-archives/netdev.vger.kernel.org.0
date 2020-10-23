Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8E7296922
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 06:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375271AbgJWE3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 00:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S370373AbgJWE3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 00:29:48 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967D2C0613CE;
        Thu, 22 Oct 2020 21:29:48 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id c15so524117ejs.0;
        Thu, 22 Oct 2020 21:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JCYEtAknaYoow1p4w2UL35VcfGDZh6EnoPxbBlVBVmQ=;
        b=Vg7g80b18r5hVqjFLMqOqqBgsFNMXuRbcpjLlvcgoVEkDmwxNEk+6/LIhFmoIN7My8
         dBFQchZ7iN5v8BX2QuNiszhSMOh8ZCuwwkI2LpRazvfO/Y1H8dP4hLJ7acXhiMNkv7EX
         77Mn69chczT1n0AsYA+qpDUKF4+Qel50Bnxc/xYxqHTk54m2gNZvTX0ElLWGPw8PE8Sr
         UTDrZcfYdQ/XPsRzxDsT26MLCIbUoc0Obh73hnY73op/wNOF2GwczfD4Qt/4jomXjA0K
         J9+v9S5VFuydyNLkUnE1YKqYOnGj6xHTuzRpYBHlw6qIk7oT2tezaEXQhrAy3nAlrYGW
         nuew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JCYEtAknaYoow1p4w2UL35VcfGDZh6EnoPxbBlVBVmQ=;
        b=lJJlFlQFXH22b8eRJV6Mb5Gye9i69vLdtoa+TM97Mv8bxYmiMR6V+wI1DiDAhUfBib
         72GVdOMuFKfNnP2TaLcrm0AH1zbcLDgKG1Yo2RAMqPlwFa/y2pDGg+CIkBuvIPv+W6UH
         2ArYpeqH56S6eqIzs+OpwEAMrwJPWEs8mwnFbnByDq90XOW5ZY4qaGLjB2BOyYPiDe24
         gdaVZJ1EUQsP1VdwKnnKhjueoDIUD26aLO03SxU6tIi1/dBzSyduhY4Rlw3mzvo+1P2b
         eKCXkBtUbNrM4C4m3cK9DSBhs1tjG61ixs9tCm0wfZuzSzqABFFNJUCZQLLwCmNPyOvZ
         IswQ==
X-Gm-Message-State: AOAM532PgWBH1bQRHZdKxNkRQyLXeRJfo/pFLXlFx5iAFQK8xFw4hXZj
        B832VDr5TxUnt3imLsUo6VY=
X-Google-Smtp-Source: ABdhPJxmDFsd9WNvB74m7EN9pR9l7vA33L9BOWqceY7JGz59kfaLVT7PirjNqnXzr+FVBryLisHEJw==
X-Received: by 2002:a17:906:3397:: with SMTP id v23mr223950eja.212.1603427387230;
        Thu, 22 Oct 2020 21:29:47 -0700 (PDT)
Received: from localhost.localdomain ([185.200.214.168])
        by smtp.gmail.com with ESMTPSA id r26sm123349eja.13.2020.10.22.21.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 21:29:46 -0700 (PDT)
From:   izabela.bakollari@gmail.com
To:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        izabela.bakollari@gmail.com
Subject: [PATCHv4 net-next] dropwatch: Support monitoring of dropped frames
Date:   Fri, 23 Oct 2020 06:29:43 +0200
Message-Id: <20201023042943.563284-1-izabela.bakollari@gmail.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200707171515.110818-1-izabela.bakollari@gmail.com>
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Izabela Bakollari <izabela.bakollari@gmail.com>

Dropwatch is a utility that monitors dropped frames by having userspace
record them over the dropwatch protocol over a file. This augument
allows live monitoring of dropped frames using tools like tcpdump.

With this feature, dropwatch allows two additional commands (start and
stop interface) which allows the assignment of a net_device to the
dropwatch protocol. When assinged, dropwatch will clone dropped frames,
and receive them on the assigned interface, allowing tools like tcpdump
to monitor for them.

With this feature, create a dummy ethernet interface (ip link add dev
dummy0 type dummy), assign it to the dropwatch kernel subsystem, by using
these new commands, and then monitor dropped frames in real time by
running tcpdump -i dummy0.

Signed-off-by: Izabela Bakollari <izabela.bakollari@gmail.com>
---
 include/uapi/linux/net_dropmon.h |   3 +
 net/core/drop_monitor.c          | 120 +++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 67e31f329190..e8e861e03a8a 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -58,6 +58,8 @@ enum {
 	NET_DM_CMD_CONFIG_NEW,
 	NET_DM_CMD_STATS_GET,
 	NET_DM_CMD_STATS_NEW,
+	NET_DM_CMD_START_IFC,
+	NET_DM_CMD_STOP_IFC,
 	_NET_DM_CMD_MAX,
 };
 
@@ -93,6 +95,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_SW_DROPS,			/* flag */
 	NET_DM_ATTR_HW_DROPS,			/* flag */
 	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
+	NET_DM_ATTR_IFNAME,			/* string */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 8e33cec9fc4e..dea85291808b 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -30,6 +30,7 @@
 #include <net/genetlink.h>
 #include <net/netevent.h>
 #include <net/flow_offload.h>
+#include <net/sock.h>
 
 #include <trace/events/skb.h>
 #include <trace/events/napi.h>
@@ -46,6 +47,7 @@
  */
 static int trace_state = TRACE_OFF;
 static bool monitor_hw;
+struct net_device *interface;
 
 /* net_dm_mutex
  *
@@ -54,6 +56,8 @@ static bool monitor_hw;
  */
 static DEFINE_MUTEX(net_dm_mutex);
 
+static DEFINE_SPINLOCK(interface_lock);
+
 struct net_dm_stats {
 	u64 dropped;
 	struct u64_stats_sync syncp;
@@ -217,6 +221,7 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	struct nlattr *nla;
 	int i;
 	struct sk_buff *dskb;
+	struct sk_buff *nskb = NULL;
 	struct per_cpu_dm_data *data;
 	unsigned long flags;
 
@@ -255,6 +260,20 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 
 out:
 	spin_unlock_irqrestore(&data->lock, flags);
+	spin_lock_irqsave(&interface_lock, flags);
+	if (interface && interface != skb->dev) {
+		nskb = skb_clone(skb, GFP_ATOMIC);
+		if (!nskb)
+			goto free;
+		nskb->dev = interface;
+	}
+	spin_unlock_irqrestore(&interface_lock, flags);
+	if (nskb)
+		netif_receive_skb(nskb);
+
+free:
+	spin_unlock_irqrestore(&interface_lock, flags);
+	return;
 }
 
 static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
@@ -1315,6 +1334,89 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
+static bool is_dummy_dev(struct net_device *dev)
+{
+	struct ethtool_drvinfo drvinfo;
+
+	if (dev->ethtool_ops && dev->ethtool_ops->get_drvinfo) {
+		memset(&drvinfo, 0, sizeof(drvinfo));
+		dev->ethtool_ops->get_drvinfo(dev, &drvinfo);
+
+		if (strcmp(drvinfo.driver, "dummy"))
+			return false;
+		return true;
+	}
+	return false;
+}
+
+static int net_dm_interface_start(struct net *net, const char *ifname)
+{
+	struct net_device *dev = dev_get_by_name(net, ifname);
+	unsigned long flags;
+	int rc = -EBUSY;
+
+	if (!dev)
+		return -ENODEV;
+
+	if (!is_dummy_dev(dev)) {
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+
+	spin_lock_irqsave(&interface_lock, flags);
+	if (!interface) {
+		interface = dev;
+		rc = 0;
+	}
+	spin_unlock_irqrestore(&interface_lock, flags);
+
+	goto out;
+
+out:
+	dev_put(dev);
+	return rc;
+}
+
+static int net_dm_interface_stop(struct net *net, const char *ifname)
+{
+	unsigned long flags;
+	int rc = -ENODEV;
+
+	spin_lock_irqsave(&interface_lock, flags);
+	if (interface && interface->name == ifname) {
+		dev_put(interface);
+		interface = NULL;
+		rc = 0;
+	}
+	spin_unlock_irqrestore(&interface_lock, flags);
+
+	return rc;
+}
+
+static int net_dm_cmd_ifc_trace(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net *net = sock_net(skb->sk);
+	char ifname[IFNAMSIZ];
+
+	if (net_dm_is_monitoring())
+		return -EBUSY;
+
+	if (!info->attrs[NET_DM_ATTR_IFNAME])
+		return -EINVAL;
+
+	memset(ifname, 0, IFNAMSIZ);
+	nla_strlcpy(ifname, info->attrs[NET_DM_ATTR_IFNAME], IFNAMSIZ - 1);
+
+	switch (info->genlhdr->cmd) {
+	case NET_DM_CMD_START_IFC:
+		return net_dm_interface_start(net, ifname);
+	case NET_DM_CMD_STOP_IFC:
+		return net_dm_interface_stop(net, ifname);
+	}
+
+	return 0;
+}
+
 static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
 {
 	void *hdr;
@@ -1503,6 +1605,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct dm_hw_stat_delta *new_stat = NULL;
 	struct dm_hw_stat_delta *tmp;
+	unsigned long flags;
 
 	switch (event) {
 	case NETDEV_REGISTER:
@@ -1529,6 +1632,12 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 				}
 			}
 		}
+		spin_lock_irqsave(&interface_lock, flags);
+		if (interface && interface == dev) {
+			dev_put(interface);
+			interface = NULL;
+		}
+		spin_unlock_irqrestore(&interface_lock, flags);
 		mutex_unlock(&net_dm_mutex);
 		break;
 	}
@@ -1543,6 +1652,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
 	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
 	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
+	[NET_DM_ATTR_IFNAME] = {. type = NLA_STRING, .len = IFNAMSIZ },
 };
 
 static const struct genl_ops dropmon_ops[] = {
@@ -1570,6 +1680,16 @@ static const struct genl_ops dropmon_ops[] = {
 		.cmd = NET_DM_CMD_STATS_GET,
 		.doit = net_dm_cmd_stats_get,
 	},
+	{
+		.cmd = NET_DM_CMD_START_IFC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = net_dm_cmd_ifc_trace,
+	},
+	{
+		.cmd = NET_DM_CMD_STOP_IFC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = net_dm_cmd_ifc_trace,
+	},
 };
 
 static int net_dm_nl_pre_doit(const struct genl_ops *ops,
-- 
2.18.4

