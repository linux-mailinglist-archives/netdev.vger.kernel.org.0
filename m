Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AE5434394
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 04:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhJTCmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 22:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTCml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 22:42:41 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C67C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 19:40:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id lk8-20020a17090b33c800b001a0a284fcc2so1377468pjb.2
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 19:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g/k6QV2vpt3vH8xJxkTx+3DiBVC3hLVwkQHeAK5Mgfk=;
        b=Q4nrYsya+U9yJCD42B+ksihz8DeeiDjP1VfdJd73Pys4FFsx7kSFFTQ9NcOFSmo+br
         R8Z/n7RebPdXUn6VtdcSktRY2xcKlktxC9iETn+uFHH3+qCrdCI8TJWERAxDPLz1fF3m
         a/YAW3Xgk/We2IYSLR3eQb6gjPgdMtQ38UVyl37vRZ+nLiWSL6IxJRv9rwNHIN4sR/dX
         prf2BYq+NHtc5tuTgNMMSxeK8lnFA91sdDHgbTrJoqKbhI9ZDeThKnhVlISaTydDUHCG
         mDcy742Yw3XMCRxB8b8+OtwQWaEDYWjVpoOxuvXJa9weX5cFkXL+xGrfkKfzAC28obto
         5tMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g/k6QV2vpt3vH8xJxkTx+3DiBVC3hLVwkQHeAK5Mgfk=;
        b=yFhHBVF8lltv3YcM0uArujmsXepXTa6cbVVZlx/vPixiI1K8eOy9CLZKx17McRrjsK
         5ZUtkeLrBmyGc5H4eawPFsXAuDFcpqWV79NKHrHyKSaXHXO1+TQ/IE2Yp2N4Pmz2tq0B
         eC/7goYCUiTO+MXJXxlNlpogpmgRQ8QOrLbcsYBSJhdpJqZfmFj4FAm3jtBldQuxfYzC
         1jPNCwh57xFxFtYO6HRoCXzDEq1nUuLgd2xuWoe+bgvjBH6IUtdFjJdiMCLTeDG692xl
         ATdXmidxVebYNGa41BzOt7ZEco33aZs+yzCK4WEHPexY+Rec6JF4Q+B5E8Z1SIA5Ohi8
         hKpg==
X-Gm-Message-State: AOAM532g4qd5vb2OLS402g5/g2OA0GiZHKbDWQ5tx0Om3otCSYL7J+VD
        g03XMGBQnwC1XteAXVBB3hhp5KutBRg=
X-Google-Smtp-Source: ABdhPJyedc2O5NAOq/eUVV0gGxa6O7q5oShLShXdyhgQaO6s66znvqXDXyE/YTLys9d9qbwR9jp7DA==
X-Received: by 2002:a17:902:7ec2:b0:13d:b563:c39 with SMTP id p2-20020a1709027ec200b0013db5630c39mr36455928plb.14.1634697622837;
        Tue, 19 Oct 2021 19:40:22 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bp19sm439990pjb.46.2021.10.19.19.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 19:40:22 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] net: bridge: mcast: QRI must be less than QI
Date:   Wed, 20 Oct 2021 10:40:16 +0800
Message-Id: <20211020024016.695678-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020023604.695416-1-liuhangbin@gmail.com>
References: <20211020023604.695416-1-liuhangbin@gmail.com>
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
index f3d751105343..5931f7c81519 100644
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
+	}
+
+	NL_SET_ERR_MSG(extack, "Invalid QI, must greater than QRI");
+	return -EINVAL;
+}
+
+int br_multicast_set_qri(struct net_bridge_mcast *brmctx, unsigned long val,
+			 struct netlink_ext_ack *extack)
+{
+	if (val < brmctx->multicast_query_interval) {
+		brmctx->multicast_query_response_interval = val;
+		return 0;
+	}
+
+	NL_SET_ERR_MSG(extack, "Invalid QRI, must less than QI");
+	return -EINVAL;
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

