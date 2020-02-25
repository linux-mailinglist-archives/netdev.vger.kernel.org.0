Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366CF16BF07
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgBYKph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:45:37 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53214 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730377AbgBYKpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:45:36 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so2474597wmc.2
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 02:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ai++lULxg0ZN5Kl7gxhRIYJlzkBlKymDyg0FU+/UHQ=;
        b=Jx9GCh9IpAXRVxkXBwHcyPRURq3p/92lUY0b2C2zW1FX4ENctJkIx4dfXK6Mt/fiS8
         mxNAgqRX+RFLbuYto/J3asBnMFS9H8QSTq8RYRlsD+ge9EXjmZ4AcXztgbbxDbR3w4an
         iJDUviU/cOxnO8q0+VV+SvqJUHav8Exif1sHx74X2k9JJ1fUHHOPr5zpLH1q9HplftQZ
         WfBCVy7IfWJAEIqiCpe/eKpFmmK0T4SiFXYJhVEy3WxYjiQtvJBSAOqqbkSTVFHThDrK
         0U99gH9Rl3X06OquX3xmo/8C6xHaNzJnJtdgzlkEK/o0cxtA8uukCA53w06Q8pVREP+E
         KtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ai++lULxg0ZN5Kl7gxhRIYJlzkBlKymDyg0FU+/UHQ=;
        b=Zw8nlCmVn1oYvrdjO6ULF3mHrRlD70mNFqIAoZi9tsqnzpHjnbLjxSld1G5onbB+OK
         /pz4rxxT6amHtc0E2gdEp1LgoCV9GFZbeWYKhIa0xBo0MJ0EXk1+5ojQW2ZWfF++/YQh
         FVtMAbS6Z5eUO3sw04OO3BySCXLSL06XdawB5seP5iqVioJlIeKR6rwtpW0jpU4lONHF
         KG+9bDTRGouJZvlXZ4crRI3mfxkgIpvrgQpSwSMdMxfDo8E9VK1plWUQtrV//3nXu5rO
         K+gSpoGQMMNOF5atuICy9y4VQPj1pCx9A0ekOaRpDbSn9z5vWN5d2aD0MNHtvFZvMb39
         Sz0w==
X-Gm-Message-State: APjAAAXVzntV40QNXHq1MVSPEb8fjwemWGX/PKEH2TYV/w0N46c1vG/K
        WKx6ukOrmY49hj3PALpazZTWIRjW4l4=
X-Google-Smtp-Source: APXvYqwhq5u+kuOs4ISUscu8bDTRwUQERKXbbaV7OVG9VADjvn3OgUsy2zwSAO+azVq/Gk3GTtvciQ==
X-Received: by 2002:a1c:f21a:: with SMTP id s26mr4637633wmc.39.1582627532619;
        Tue, 25 Feb 2020 02:45:32 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id m68sm3558606wme.48.2020.02.25.02.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 02:45:32 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 03/10] drop_monitor: extend by passing cookie from driver
Date:   Tue, 25 Feb 2020 11:45:20 +0100
Message-Id: <20200225104527.2849-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225104527.2849-1-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

If driver passed along the cookie, push it through Netlink.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- removed __GFP_ZERO
---
 include/net/drop_monitor.h       |  3 +++
 include/uapi/linux/net_dropmon.h |  1 +
 net/core/drop_monitor.c          | 33 +++++++++++++++++++++++++++++++-
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/net/drop_monitor.h b/include/net/drop_monitor.h
index 2ab668461463..ddd441a60e03 100644
--- a/include/net/drop_monitor.h
+++ b/include/net/drop_monitor.h
@@ -6,17 +6,20 @@
 #include <linux/ktime.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
+#include <net/flow_offload.h>
 
 /**
  * struct net_dm_hw_metadata - Hardware-supplied packet metadata.
  * @trap_group_name: Hardware trap group name.
  * @trap_name: Hardware trap name.
  * @input_dev: Input netdevice.
+ * @fa_cookie: Flow action user cookie.
  */
 struct net_dm_hw_metadata {
 	const char *trap_group_name;
 	const char *trap_name;
 	struct net_device *input_dev;
+	const struct flow_action_cookie *fa_cookie;
 };
 
 #if IS_ENABLED(CONFIG_NET_DROP_MONITOR)
diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 8bf79a9eb234..66048cc5d7b3 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -92,6 +92,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_HW_TRAP_COUNT,		/* u32 */
 	NET_DM_ATTR_SW_DROPS,			/* flag */
 	NET_DM_ATTR_HW_DROPS,			/* flag */
+	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 31700e0c3928..d58c1c45a895 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -29,6 +29,7 @@
 #include <net/drop_monitor.h>
 #include <net/genetlink.h>
 #include <net/netevent.h>
+#include <net/flow_offload.h>
 
 #include <trace/events/skb.h>
 #include <trace/events/napi.h>
@@ -700,6 +701,13 @@ static void net_dm_packet_work(struct work_struct *work)
 		net_dm_packet_report(skb);
 }
 
+static size_t
+net_dm_flow_action_cookie_size(const struct net_dm_hw_metadata *hw_metadata)
+{
+	return hw_metadata->fa_cookie ?
+	       nla_total_size(hw_metadata->fa_cookie->cookie_len) : 0;
+}
+
 static size_t
 net_dm_hw_packet_report_size(size_t payload_len,
 			     const struct net_dm_hw_metadata *hw_metadata)
@@ -717,6 +725,8 @@ net_dm_hw_packet_report_size(size_t payload_len,
 	       nla_total_size(strlen(hw_metadata->trap_name) + 1) +
 	       /* NET_DM_ATTR_IN_PORT */
 	       net_dm_in_port_size() +
+	       /* NET_DM_ATTR_FLOW_ACTION_COOKIE */
+	       net_dm_flow_action_cookie_size(hw_metadata) +
 	       /* NET_DM_ATTR_TIMESTAMP */
 	       nla_total_size(sizeof(u64)) +
 	       /* NET_DM_ATTR_ORIG_LEN */
@@ -762,6 +772,12 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
 			goto nla_put_failure;
 	}
 
+	if (hw_metadata->fa_cookie &&
+	    nla_put(msg, NET_DM_ATTR_FLOW_ACTION_COOKIE,
+		    hw_metadata->fa_cookie->cookie_len,
+		    hw_metadata->fa_cookie->cookie))
+		goto nla_put_failure;
+
 	if (nla_put_u64_64bit(msg, NET_DM_ATTR_TIMESTAMP,
 			      ktime_to_ns(skb->tstamp), NET_DM_ATTR_PAD))
 		goto nla_put_failure;
@@ -794,11 +810,12 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
 static struct net_dm_hw_metadata *
 net_dm_hw_metadata_clone(const struct net_dm_hw_metadata *hw_metadata)
 {
+	const struct flow_action_cookie *fa_cookie;
 	struct net_dm_hw_metadata *n_hw_metadata;
 	const char *trap_group_name;
 	const char *trap_name;
 
-	n_hw_metadata = kmalloc(sizeof(*hw_metadata), GFP_ATOMIC);
+	n_hw_metadata = kzalloc(sizeof(*hw_metadata), GFP_ATOMIC);
 	if (!n_hw_metadata)
 		return NULL;
 
@@ -812,12 +829,25 @@ net_dm_hw_metadata_clone(const struct net_dm_hw_metadata *hw_metadata)
 		goto free_trap_group;
 	n_hw_metadata->trap_name = trap_name;
 
+	if (hw_metadata->fa_cookie) {
+		size_t cookie_size = sizeof(*fa_cookie) +
+				     hw_metadata->fa_cookie->cookie_len;
+
+		fa_cookie = kmemdup(hw_metadata->fa_cookie, cookie_size,
+				    GFP_ATOMIC);
+		if (!fa_cookie)
+			goto free_trap_name;
+		n_hw_metadata->fa_cookie = fa_cookie;
+	}
+
 	n_hw_metadata->input_dev = hw_metadata->input_dev;
 	if (n_hw_metadata->input_dev)
 		dev_hold(n_hw_metadata->input_dev);
 
 	return n_hw_metadata;
 
+free_trap_name:
+	kfree(trap_name);
 free_trap_group:
 	kfree(trap_group_name);
 free_hw_metadata:
@@ -830,6 +860,7 @@ net_dm_hw_metadata_free(const struct net_dm_hw_metadata *hw_metadata)
 {
 	if (hw_metadata->input_dev)
 		dev_put(hw_metadata->input_dev);
+	kfree(hw_metadata->fa_cookie);
 	kfree(hw_metadata->trap_name);
 	kfree(hw_metadata->trap_group_name);
 	kfree(hw_metadata);
-- 
2.21.1

