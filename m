Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0D225117D
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 07:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgHYF1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 01:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbgHYF1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 01:27:45 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54117C061574;
        Mon, 24 Aug 2020 22:27:45 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id x69so9946398qkb.1;
        Mon, 24 Aug 2020 22:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KK9qiJEW0ad7Lyf22fdpzMhXTQllIqQXKDsr1j8N6A8=;
        b=CCs1X/KimS+xeJmbZUcEMh0h5Zfr3yH+RSA0ETLqS7fG4bT7LNJgvVYSdVFgfb6C+I
         5Po4I/XcOWTZ6ijvjGaBYflBXhj+CAMysc6/fsbXLxUzYgZ4xToo1Z9ySka/TBj5VDp7
         isFzlnONdUyeGCnPLgopSol+3qO+Rhgg+2yotQIgfHmqcDnkGNr29eHDuq6EIgBTcBfY
         M1VoX10XVpI+Ca6mPjcTmHWX4X8//7SW5JMQP+nr+DgupIErq0qjq/FbajIzJk88B3qh
         Wi6dERSyA0VHJR21nfnIONcqaLeo9wktugx5Yy0UnpiCbHlMdohYcgJs4+vQ16pBOvus
         38ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KK9qiJEW0ad7Lyf22fdpzMhXTQllIqQXKDsr1j8N6A8=;
        b=XxKq0pPN111dWemFLVUlUUL19ZZ9+xJwR12eVVTDXgb7WaTCkH9NpwQtQCR4pGtqyb
         MefBdTAj5JRDJqRzF1YDfVFHwFt3qeP5Yrh893yUS2q2hChRKMm/Qjbl6cNEW9R04S82
         0xXb5Pb/BB75jPwzUZ1QAIuUTCS1vwJP0RWmhE7Tbbv2y+rjl2wsUbLKF22PVDumRdP7
         Iw7+R0nWnDOtaDt06rfzXOIzWpIjZHs0yzM3q4JYRLpb/gYYPvSvggM2q1HVKeqPffOW
         t3VVPv3zDO/vRODdku5Qz28PGRocPTM7Zs0EQl0a316Xtu2wlJbnNZNKqftVjlNc6ePr
         rlUw==
X-Gm-Message-State: AOAM5322Og+pVJNbZAzEZDqTYi/Gwa4UY8niBJwCvC8TFKOqpKqNqsKc
        SSEUdTRyvhy8GYXRStzmi09FZ94PECE=
X-Google-Smtp-Source: ABdhPJz/fmkzKZoTuIHHZvch1RIawjJqYP8XvLEV0K3301UaifAh2dmreurzSojnyPqn/zCqBj/zKQ==
X-Received: by 2002:a37:e315:: with SMTP id y21mr7932852qki.129.1598333264604;
        Mon, 24 Aug 2020 22:27:44 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id o72sm11215457qka.113.2020.08.24.22.27.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 22:27:43 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     sashal@kernel.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, jknoos@google.com,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net backport 5.6.14-5.8.3 v1] net: openvswitch: introduce common code for flushing flows
Date:   Tue, 25 Aug 2020 13:25:32 +0800
Message-Id: <20200825052532.15301-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

[ Upstream commit 77b981c82c1df7c7ad32a046f17f007450b46954 ]

Backport this commit to 5.6.14 - 5.8.3.

To avoid some issues, for example RCU usage warning and double free,
we should flush the flows under ovs_lock. This patch refactors
table_instance_destroy and introduces table_instance_flow_flush
which can be invoked by __dp_destroy or ovs_flow_tbl_flush.

Fixes: 50b0e61b32ee ("net: openvswitch: fix possible memleak on destroy flow-table")
Reported-by: Johan Knöös <jknoos@google.com>
Reported-at: https://mail.openvswitch.org/pipermail/ovs-discuss/2020-August/050489.html
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/openvswitch/datapath.c   | 10 +++++++++-
 net/openvswitch/flow_table.c | 35 +++++++++++++++--------------------
 net/openvswitch/flow_table.h |  3 +++
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 94b024534987..03b81aa99975 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1736,6 +1736,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 /* Called with ovs_mutex. */
 static void __dp_destroy(struct datapath *dp)
 {
+	struct flow_table *table = &dp->table;
 	int i;
 
 	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++) {
@@ -1754,7 +1755,14 @@ static void __dp_destroy(struct datapath *dp)
 	 */
 	ovs_dp_detach_port(ovs_vport_ovsl(dp, OVSP_LOCAL));
 
-	/* RCU destroy the flow table */
+	/* Flush sw_flow in the tables. RCU cb only releases resource
+	 * such as dp, ports and tables. That may avoid some issues
+	 * such as RCU usage warning.
+	 */
+	table_instance_flow_flush(table, ovsl_dereference(table->ti),
+				  ovsl_dereference(table->ufid_ti));
+
+	/* RCU destroy the ports, meters and flow tables. */
 	call_rcu(&dp->rcu, destroy_dp_rcu);
 }
 
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 2398d7238300..f198bbb0c517 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -345,19 +345,15 @@ static void table_instance_flow_free(struct flow_table *table,
 	flow_mask_remove(table, flow->mask);
 }
 
-static void table_instance_destroy(struct flow_table *table,
-				   struct table_instance *ti,
-				   struct table_instance *ufid_ti,
-				   bool deferred)
+/* Must be called with OVS mutex held. */
+void table_instance_flow_flush(struct flow_table *table,
+			       struct table_instance *ti,
+			       struct table_instance *ufid_ti)
 {
 	int i;
 
-	if (!ti)
-		return;
-
-	BUG_ON(!ufid_ti);
 	if (ti->keep_flows)
-		goto skip_flows;
+		return;
 
 	for (i = 0; i < ti->n_buckets; i++) {
 		struct sw_flow *flow;
@@ -369,18 +365,16 @@ static void table_instance_destroy(struct flow_table *table,
 
 			table_instance_flow_free(table, ti, ufid_ti,
 						 flow, false);
-			ovs_flow_free(flow, deferred);
+			ovs_flow_free(flow, true);
 		}
 	}
+}
 
-skip_flows:
-	if (deferred) {
-		call_rcu(&ti->rcu, flow_tbl_destroy_rcu_cb);
-		call_rcu(&ufid_ti->rcu, flow_tbl_destroy_rcu_cb);
-	} else {
-		__table_instance_destroy(ti);
-		__table_instance_destroy(ufid_ti);
-	}
+static void table_instance_destroy(struct table_instance *ti,
+				   struct table_instance *ufid_ti)
+{
+	call_rcu(&ti->rcu, flow_tbl_destroy_rcu_cb);
+	call_rcu(&ufid_ti->rcu, flow_tbl_destroy_rcu_cb);
 }
 
 /* No need for locking this function is called from RCU callback or
@@ -393,7 +387,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 
 	free_percpu(table->mask_cache);
 	kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
-	table_instance_destroy(table, ti, ufid_ti, false);
+	table_instance_destroy(ti, ufid_ti);
 }
 
 struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
@@ -511,7 +505,8 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 	flow_table->count = 0;
 	flow_table->ufid_count = 0;
 
-	table_instance_destroy(flow_table, old_ti, old_ufid_ti, true);
+	table_instance_flow_flush(flow_table, old_ti, old_ufid_ti);
+	table_instance_destroy(old_ti, old_ufid_ti);
 	return 0;
 
 err_free_ti:
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 8a5cea6ae111..8ea8fc957377 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -86,4 +86,7 @@ bool ovs_flow_cmp(const struct sw_flow *, const struct sw_flow_match *);
 
 void ovs_flow_mask_key(struct sw_flow_key *dst, const struct sw_flow_key *src,
 		       bool full, const struct sw_flow_mask *mask);
+void table_instance_flow_flush(struct flow_table *table,
+			       struct table_instance *ti,
+			       struct table_instance *ufid_ti);
 #endif /* flow_table.h */
-- 
2.23.0

