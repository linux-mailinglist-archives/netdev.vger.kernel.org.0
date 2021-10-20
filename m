Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD4643438F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 04:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhJTCic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 22:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTCib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 22:38:31 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53419C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 19:36:18 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d9so1650772pfl.6
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 19:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uP74WpUfIxkFQrw13QDTf0eyIC/o9Ip6dzTaEPhVPzY=;
        b=HXX1pftRzORTj8Px5lEdsuaix32dXDrAzRrLMT4qb8+nQ19QkoDo8IfUJcH4WFm2M2
         aP3znHPiJ5Z/OgRt4qlU3oMrhzz4HzGOAGwAg1kLxCIyEDDPI7NnhBtaMKrHSIRsN62O
         w5bA1Y8ada/17UO6bUAl6Tt94fm9GpBGooLZS5L57b0Ob0BqBs9q8VtXOa+s4HtkIH2n
         ui7iyGpclZKWSTd+JOUTkRwnuSRDiTCAxdKg0ASSHQHlie+1syy4orPzNuORgS2XKcC8
         VpH5mcKmTw/rdk3BNIWWyhkebhZALuh4LG3OoNx1SIAYToi/UEOSyhp02XFZsrT7zIAi
         YbZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uP74WpUfIxkFQrw13QDTf0eyIC/o9Ip6dzTaEPhVPzY=;
        b=sL7ArKRIa9oO8+Y5W1wOzUUcI/l+4lRXaOlIbNEEmmcmCHUKy3H8J4YSADNAK3z0kf
         u010bvMt2IdIKr0GXp+beXqrPSGSkPl9DUPR9AKTRQMYIxJ4yh7L6GxbFhY3M/NPvMjC
         eODNte9/DvoImA8H7Oye+iGSW3VbjNs/FkBJQ0pp9YZsoGD3cQjlRWigRugS+43QX0x6
         n9DRjXG8gQiHuHDTrdmjKabuNWJPFWi29nIRV1VRoS6EPEFZ+WUhFsOH1G33RZ2kcJ08
         URIAjHc5KjEGqSYqbTbimfrqzHEy32U3hMXobFGX7f2MnHsGI7ed1Vy5ummPT/azNees
         s3Sg==
X-Gm-Message-State: AOAM533TCdr/HJ9MSJ+kcF2PTz0jCzVt/lWlwcdmEbS1EVc1p2YSxvj8
        XqquStp6LElZQeAJiVe2qn0dQUgvjf8=
X-Google-Smtp-Source: ABdhPJwtuBEQXDL1cCrt1KWlpUZ29vCJwIMVSQE/rzbHQCUkD77aNjUwGn3r0qw7dg1aNj4G4l59sA==
X-Received: by 2002:a62:1887:0:b0:44c:872e:27ed with SMTP id 129-20020a621887000000b0044c872e27edmr3448411pfy.71.1634697377682;
        Tue, 19 Oct 2021 19:36:17 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm524699pfq.207.2021.10.19.19.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 19:36:17 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] net: bridge: mcast: QRI must be less than QI
Date:   Wed, 20 Oct 2021 10:36:04 +0800
Message-Id: <20211020023604.695416-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on RFC3376 8.3:
The number of seconds represented by the [Query Response Interval]
must be less than the [Query Interval].

Fixes: d902eee43f19 ("bridge: Add multicast count/interval sysfs entries")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/bridge/br_multicast.c    | 27 +++++++++++++++++++++++++++
 net/bridge/br_netlink.c      |  8 ++++++--
 net/bridge/br_private.h      |  4 ++++
 net/bridge/br_sysfs_br.c     |  6 ++----
 net/bridge/br_vlan_options.c |  8 ++++++--
 5 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index f3d751105343..1a865d08a87f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4522,6 +4522,33 @@ int br_multicast_set_mld_version(struct net_bridge_mcast *brmctx,
 }
 #endif
 
+/* RFC3376 8.3: The number of seconds represented by the
+ * [Query Response Interval] must be less than the [Query Interval].
+ */
+int br_multicast_set_qi(struct net_bridge_mcast *brmctx, unsigned long val,
+			struct netlink_ext_ack *extack)
+{
+	if (val > brmctx->multicast_query_response_interval) {
+		brmctx->multicast_query_interval = val;
+		return 0;
+	} else {
+		NL_SET_ERR_MSG(extack, "Invalid QI, must greater than QRI");
+		return -EINVAL;
+	}
+}
+
+int br_multicast_set_qri(struct net_bridge_mcast *brmctx, unsigned long val,
+			 struct netlink_ext_ack *extack)
+{
+	if (val < brmctx->multicast_query_interval) {
+		brmctx->multicast_query_response_interval = val;
+		return 0;
+	} else {
+		NL_SET_ERR_MSG(extack, "Invalid QRI, must less than QI");
+		return -EINVAL;
+	}
+}
+
 /**
  * br_multicast_list_adjacent - Returns snooped multicast addresses
  * @dev:	The bridge port adjacent to which to retrieve addresses
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 5c6c4305ed23..2b32d7d2ce31 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1357,13 +1357,17 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_MCAST_QUERY_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_QUERY_INTVL]);
 
-		br->multicast_ctx.multicast_query_interval = clock_t_to_jiffies(val);
+		err = br_multicast_set_qi(&br->multicast_ctx, clock_t_to_jiffies(val), extack);
+		if (err)
+			return err;
 	}
 
 	if (data[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]);
 
-		br->multicast_ctx.multicast_query_response_interval = clock_t_to_jiffies(val);
+		err = br_multicast_set_qri(&br->multicast_ctx, clock_t_to_jiffies(val), extack);
+		if (err)
+			return err;
 	}
 
 	if (data[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 37ca76406f1e..5019c601f689 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -906,6 +906,10 @@ int br_multicast_set_igmp_version(struct net_bridge_mcast *brmctx,
 int br_multicast_set_mld_version(struct net_bridge_mcast *brmctx,
 				 unsigned long val);
 #endif
+int br_multicast_set_qi(struct net_bridge_mcast *brmctx, unsigned long val,
+			struct netlink_ext_ack *extack);
+int br_multicast_set_qri(struct net_bridge_mcast *brmctx, unsigned long val,
+			 struct netlink_ext_ack *extack);
 struct net_bridge_mdb_entry *
 br_mdb_ip_get(struct net_bridge *br, struct br_ip *dst);
 struct net_bridge_mdb_entry *
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index d9a89ddd0331..f794652f8592 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -658,8 +658,7 @@ static ssize_t multicast_query_interval_show(struct device *d,
 static int set_query_interval(struct net_bridge *br, unsigned long val,
 			      struct netlink_ext_ack *extack)
 {
-	br->multicast_ctx.multicast_query_interval = clock_t_to_jiffies(val);
-	return 0;
+	return br_multicast_set_qi(&br->multicast_ctx, clock_t_to_jiffies(val), extack);
 }
 
 static ssize_t multicast_query_interval_store(struct device *d,
@@ -682,8 +681,7 @@ static ssize_t multicast_query_response_interval_show(
 static int set_query_response_interval(struct net_bridge *br, unsigned long val,
 				       struct netlink_ext_ack *extack)
 {
-	br->multicast_ctx.multicast_query_response_interval = clock_t_to_jiffies(val);
-	return 0;
+	return br_multicast_set_qri(&br->multicast_ctx, clock_t_to_jiffies(val), extack);
 }
 
 static ssize_t multicast_query_response_interval_store(
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 8ffd4ed2563c..71e94ff9d926 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -521,14 +521,18 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 		u64 val;
 
 		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL]);
-		v->br_mcast_ctx.multicast_query_interval = clock_t_to_jiffies(val);
+		err = br_multicast_set_qi(&v->br_mcast_ctx, clock_t_to_jiffies(val), extack);
+		if (err)
+			return err;
 		*changed = true;
 	}
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL]) {
 		u64 val;
 
 		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL]);
-		v->br_mcast_ctx.multicast_query_response_interval = clock_t_to_jiffies(val);
+		err = br_multicast_set_qri(&v->br_mcast_ctx, clock_t_to_jiffies(val), extack);
+		if (err)
+			return err;
 		*changed = true;
 	}
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]) {
-- 
2.31.1

