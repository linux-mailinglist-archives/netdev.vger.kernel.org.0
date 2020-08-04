Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D60923BDCF
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 18:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgHDQKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 12:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgHDQJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 12:09:16 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D494AC06174A;
        Tue,  4 Aug 2020 09:09:13 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id m19so2549010ejd.8;
        Tue, 04 Aug 2020 09:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aHpL707Nss711rXrUizpThLuemDkqB5ODmR6Us/BMpc=;
        b=RKCtVolN1PDxb8f8DAAlQGFnsZB9sx/M6YI5o8M9ezRPbYAoilaubmC9LXgvQj85xQ
         qBR14pamadnbHGCQwFj1sQV0M2CLHe2KsyN/KdJgHzfNtNp1wCoYZTMjlrZ4KJQX8c7/
         r5dJOSvThAD7I2jxY0eiJoAOjd3gHWsGoBRqIpNJrPHMWPCYoZd9JecE9WmSblVpB2I5
         PBjsmpZIkecclgeIDvk2llNeWwDI781nxShwPkWnezpUqoZRFHhEbOTqWF6egLJByK2R
         KoPUV2zAtlX5POBQEHkJlAEYCqPZV9CJfraVAANj/VtS4cgHkEjw/sspRB5MniAOznXY
         cM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aHpL707Nss711rXrUizpThLuemDkqB5ODmR6Us/BMpc=;
        b=cJsnr3XC/lx+aRjhwVPUbl/AZ6fsKwM/7y/UyDgRpF1w1z4LuDkM5OYYmD5zbLnrcA
         X2o+fPrH5qzPe6DkxC60vRfzr5LnzqgoycmYy3VbW0T97tEPprDDaZcDb6aR80fICe8G
         E8N39wm4MMZJvJcct2J4w4pmU3t0n8pGAB3G/Wht0WPS4o5wDfRb/wFZBJIV147R3Vl0
         ZANTiI1IM2a3osUqKap+/q3bf3TM7DB+BBxEG8I4ov+5/MO7K/MT7AXclcGVUb8hf7yo
         kFadbXVP/OElRmZ8kJwwxyMQgmedbvp6zByuSdSsYS926f6MNAnbnvvCfVOLqaUA8Qzf
         l94Q==
X-Gm-Message-State: AOAM533Dxcui1aGgxDAnxx8gp1nnJbL8rhSULMli6D3onNsWj61Y+3Fe
        7Smpvdykd8d2xkZ6Wjyw4ao=
X-Google-Smtp-Source: ABdhPJzbLBiMYA5MJdi6LAEI6mCPAp1yBqX0h73JQ5aVcDHYwq8GptQyMXf84h1/xiNrOgyr+5SVVQ==
X-Received: by 2002:a17:906:841:: with SMTP id f1mr22756793ejd.158.1596557351011;
        Tue, 04 Aug 2020 09:09:11 -0700 (PDT)
Received: from localhost.localdomain ([185.200.214.168])
        by smtp.gmail.com with ESMTPSA id ov10sm18502616ejb.6.2020.08.04.09.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 09:09:10 -0700 (PDT)
From:   izabela.bakollari@gmail.com
To:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        izabela.bakollari@gmail.com
Subject: [PATCHv2 net-next] dropwatch: Support monitoring of dropped frames
Date:   Tue,  4 Aug 2020 18:09:08 +0200
Message-Id: <20200804160908.46193-1-izabela.bakollari@gmail.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200707171515.110818-1-izabela.bakollari@gmail.com>
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
Sender: netdev-owner@vger.kernel.org
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
Changes in v2:
- protect the dummy ethernet interface from being changed by another
thread/cpu
---
 include/uapi/linux/net_dropmon.h |  3 ++
 net/core/drop_monitor.c          | 84 ++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

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
index 8e33cec9fc4e..781e69876d2f 100644
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
@@ -255,6 +259,21 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 
 out:
 	spin_unlock_irqrestore(&data->lock, flags);
+	spin_lock_irqsave(&interface_lock, flags);
+	if (interface && interface != skb->dev) {
+		skb = skb_clone(skb, GFP_ATOMIC);
+		if (skb) {
+			skb->dev = interface;
+			spin_unlock_irqrestore(&interface_lock, flags);
+			netif_receive_skb(skb);
+		} else {
+			spin_unlock_irqrestore(&interface_lock, flags);
+			pr_err("dropwatch: Not enough memory to clone dropped skb\n");
+			return;
+		}
+	} else {
+		spin_unlock_irqrestore(&interface_lock, flags);
+	}
 }
 
 static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
@@ -1315,6 +1334,53 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
+static int net_dm_interface_start(struct net *net, const char *ifname)
+{
+	struct net_device *nd = dev_get_by_name(net, ifname);
+
+	if (nd)
+		interface = nd;
+	else
+		return -ENODEV;
+
+	return 0;
+}
+
+static int net_dm_interface_stop(struct net *net, const char *ifname)
+{
+	dev_put(interface);
+	interface = NULL;
+
+	return 0;
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
+	memset(ifname, 0, IFNAMSIZ);
+	nla_strlcpy(ifname, info->attrs[NET_DM_ATTR_IFNAME], IFNAMSIZ - 1);
+
+	switch (info->genlhdr->cmd) {
+	case NET_DM_CMD_START_IFC:
+		if (!interface)
+			return net_dm_interface_start(net, ifname);
+		else
+			return -EBUSY;
+	case NET_DM_CMD_STOP_IFC:
+		if (interface)
+			return net_dm_interface_stop(net, interface->name);
+		else
+			return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
 {
 	void *hdr;
@@ -1503,6 +1569,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct dm_hw_stat_delta *new_stat = NULL;
 	struct dm_hw_stat_delta *tmp;
+	unsigned long flags;
 
 	switch (event) {
 	case NETDEV_REGISTER:
@@ -1529,6 +1596,12 @@ static int dropmon_net_event(struct notifier_block *ev_block,
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
@@ -1543,6 +1616,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
 	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
 	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
+	[NET_DM_ATTR_IFNAME] = {. type = NLA_STRING, .len = IFNAMSIZ },
 };
 
 static const struct genl_ops dropmon_ops[] = {
@@ -1570,6 +1644,16 @@ static const struct genl_ops dropmon_ops[] = {
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

