Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2895FC1A22
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 04:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbfI3CJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 22:09:19 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38791 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbfI3CJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 22:09:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id x10so6488775pgi.5
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 19:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m+q8qfRrZeBgpd9Kpe/d6ur2XjjScNHiyDB8B58qb+8=;
        b=Q6UWVsWig247yw6KYC8PhS/e+rmJ9Fe8vtesjHCXe9U3OzkJnIVRbiRjbRI2SOZYaD
         LX/wg0NgNR9mZQhCVnAWbaXR+uQeS51USeCpf38p9nqsi5LERhCY+dRSoJWHCjrmd0CB
         lQXRbsQaxAkzyKMJfTywkAHelK/qWCCuyi7w/sUxoSaNXolIK7l1bc8l/V3JBIp/PLGy
         XKrym9KSmd7OoCx4TldZzo8JlLEM7JpIg1OZ93txox7Sw4Pn+lciyjOlCdSpL70jXKsl
         1C84DFtxMzkzro3jGmmD5AUDiaumioBJ3A/2Tra4CWK/g2hg3D2PPXrJQXqTWh1l84FQ
         V6Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m+q8qfRrZeBgpd9Kpe/d6ur2XjjScNHiyDB8B58qb+8=;
        b=HFDYSKduPTqAniqXwLCqxhS1gvYTxp1X8jMLLKe8xMB2zkKk9xi7IJNA88YSj3bYq4
         3/2KSV33UZDAKnqakMC8nIm7l4dChqPHyrdGxX9+cSv5ibWLJduuIUz2dMzMgtM/AtMg
         7j9vPONzDUw3hTma15a4G986g2X9VwDFK9JZvSPwZlihLXiU/E7/LFHZfglmQSELdrFa
         YZwiNc2Tp09Qdbmdw6s//RB3zIffDxdo6Vq7EJ/334KwKsiZ/BLHVuxZ6duc+7VeCRss
         AYs4gnG+p7866bASg9ZNla6aAlFCt/oRpriCx3VFtwTchbxlwkI/a+bepAe+o+EXx+kg
         2s+w==
X-Gm-Message-State: APjAAAVPrWYwSZlUl506/AnrnospT3C3tR8F4YZIlWdqRosjQH1bYW5H
        hppug7yHJhkttzVglAghgqXaeB5e
X-Google-Smtp-Source: APXvYqz62RA0jaHfdYJt5XHJfh7BvRgI+2veCCSuZPpWNfQt3X3UEf8z3hSuxqQqS79zXmGUGfAHiQ==
X-Received: by 2002:a63:a369:: with SMTP id v41mr22140918pgn.148.1569809357067;
        Sun, 29 Sep 2019 19:09:17 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d69sm9941635pfd.175.2019.09.29.19.09.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 19:09:16 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 9/9] net: openvswitch: simplify the ovs_dp_cmd_new
Date:   Mon, 30 Sep 2019 01:10:06 +0800
Message-Id: <1569777006-7435-10-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

use the specified functions to init resource.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/datapath.c | 60 +++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 3d7b1c4..78b442e 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1576,6 +1576,31 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 	return 0;
 }
 
+static int ovs_dp_stats_init(struct datapath *dp)
+{
+	dp->stats_percpu = netdev_alloc_pcpu_stats(struct dp_stats_percpu);
+	if (!dp->stats_percpu)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int ovs_dp_vport_init(struct datapath *dp)
+{
+	int i;
+
+	dp->ports = kmalloc_array(DP_VPORT_HASH_BUCKETS,
+				  sizeof(struct hlist_head),
+				  GFP_KERNEL);
+	if (!dp->ports)
+		return -ENOMEM;
+
+	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)
+		INIT_HLIST_HEAD(&dp->ports[i]);
+
+	return 0;
+}
+
 static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr **a = info->attrs;
@@ -1584,7 +1609,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	struct datapath *dp;
 	struct vport *vport;
 	struct ovs_net *ovs_net;
-	int err, i;
+	int err;
 
 	err = -EINVAL;
 	if (!a[OVS_DP_ATTR_NAME] || !a[OVS_DP_ATTR_UPCALL_PID])
@@ -1597,35 +1622,26 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	err = -ENOMEM;
 	dp = kzalloc(sizeof(*dp), GFP_KERNEL);
 	if (dp == NULL)
-		goto err_free_reply;
+		goto err_destroy_reply;
 
 	ovs_dp_set_net(dp, sock_net(skb->sk));
 
 	/* Allocate table. */
 	err = ovs_flow_tbl_init(&dp->table);
 	if (err)
-		goto err_free_dp;
+		goto err_destroy_dp;
 
-	dp->stats_percpu = netdev_alloc_pcpu_stats(struct dp_stats_percpu);
-	if (!dp->stats_percpu) {
-		err = -ENOMEM;
+	err = ovs_dp_stats_init(dp);
+	if (err)
 		goto err_destroy_table;
-	}
 
-	dp->ports = kmalloc_array(DP_VPORT_HASH_BUCKETS,
-				  sizeof(struct hlist_head),
-				  GFP_KERNEL);
-	if (!dp->ports) {
-		err = -ENOMEM;
-		goto err_destroy_percpu;
-	}
-
-	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)
-		INIT_HLIST_HEAD(&dp->ports[i]);
+	err = ovs_dp_vport_init(dp);
+	if (err)
+		goto err_destroy_stats;
 
 	err = ovs_meters_init(dp);
 	if (err)
-		goto err_destroy_ports_array;
+		goto err_destroy_ports;
 
 	/* Set up our datapath device. */
 	parms.name = nla_data(a[OVS_DP_ATTR_NAME]);
@@ -1675,15 +1691,15 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 err_destroy_meters:
 	ovs_unlock();
 	ovs_meters_exit(dp);
-err_destroy_ports_array:
+err_destroy_ports:
 	kfree(dp->ports);
-err_destroy_percpu:
+err_destroy_stats:
 	free_percpu(dp->stats_percpu);
 err_destroy_table:
 	ovs_flow_tbl_destroy(&dp->table);
-err_free_dp:
+err_destroy_dp:
 	kfree(dp);
-err_free_reply:
+err_destroy_reply:
 	kfree_skb(reply);
 err:
 	return err;
-- 
1.8.3.1

