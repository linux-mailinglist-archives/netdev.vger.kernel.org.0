Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BB6EC4A4
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfKAOYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:24:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33948 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKAOYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:24:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id x195so3709957pfd.1
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 07:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xFv3hcOcNKmj8ZwltKq36bAhvNe+rhJRgoAZb20SCBc=;
        b=oCqb2LufV+1s3CI4oUZsXddPpfQG3yK8NmQOsOgP1D7C1otBNdF1mkR2CPcbVAGwg0
         W8J88nj3UGzEt+vAypas32iVCAtfvkrMK3Lxyyx7x3iJojqiiXcscsIAq/vLu3mjJe/n
         vxFvwAGlbrJt/hwvN9LhBVD79VxDN0co6ySWso+EpeKARZQMrz7sT2ZNGxBvA7SBeeKF
         BchF0pF61OADjSFPHg04zPOUgS0FfIMXCFFtN46Usahh/SMJcmDz8JzxRwHqBkrRjvBU
         W7cf9fyiGjVEr5AjNWs3veCif7RkWv/XTuamQBClacYQmm5qkS4ai5UB/jbC08x7stKU
         zPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xFv3hcOcNKmj8ZwltKq36bAhvNe+rhJRgoAZb20SCBc=;
        b=staGXB1GFwatBy6vSX9HTzF5Y6R6NbE4Vn0tYNHVGGKVHV3AuKE+51gNyZkieqhTAK
         YJtyNP3QdhDjZSjHlT/tLzQQRTGWrAgrD/yjQzDhIsd0zrqNHsHsBKVbuahg3j/yxK5H
         DoeUUo0DG3s0amqLONip5QCz9HW0UBPE36h45UDAsf/9bZDn1YHxc/QzU9iK2C+5Ubbc
         REznV04r9Pzgwtrhc4ccMxpqYaEVq17DH1omz8Vzr7JSnPmCtU+E0z6jJQgKUTBP9yp9
         N4n7LjYcmgs9YRxMSOIsnFPWSoWrYBt4NJhIzz5oH+P/HxGAavg3REDYD1QIKO8/JEl4
         xo/g==
X-Gm-Message-State: APjAAAXDl2naO88uqSRk2cVAhleylmEtFGWYUeMIbNJ40oBaAXSMXlXX
        NU7Y0LR4P/aePzUFAmVU3OQ=
X-Google-Smtp-Source: APXvYqwvt51AGny15fZk1/0fZXsCjGAGSSSDHnGOikoFlGz26J36RXn59Q139wewVSIPgL5087zyAA==
X-Received: by 2002:a65:6290:: with SMTP id f16mr13990808pgv.40.1572618282644;
        Fri, 01 Nov 2019 07:24:42 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([1.203.173.208])
        by smtp.gmail.com with ESMTPSA id c12sm8296499pfp.67.2019.11.01.07.24.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:24:42 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v6 10/10] net: openvswitch: simplify the ovs_dp_cmd_new
Date:   Fri,  1 Nov 2019 22:23:54 +0800
Message-Id: <1572618234-6904-11-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

use the specified functions to init resource.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
---
 net/openvswitch/datapath.c | 60 +++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index aeb76e4..4d48e48 100644
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

