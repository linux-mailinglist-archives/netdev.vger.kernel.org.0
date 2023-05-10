Return-Path: <netdev+bounces-1526-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 822576FE1C8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:46:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FDF428154D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD468168AE;
	Wed, 10 May 2023 15:46:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC17B6AA8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:46:52 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B0C19B6
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:46:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b9a776a5eb2so16599692276.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683733610; x=1686325610;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wQNs9/mF66N86FuTHCtwPTsRV3BCVF0omcWHqxDMmZE=;
        b=QDWz6Lf30iKF9epEXu6z51V7LVGmBMIlIBPZE0KdtD+/fZKJxtXihLEcz/rLNObHf6
         ULF/J8D4aKOno3JifIkVJvZ47j6IjjhgAalTQmHp8a3MstQMoA/izUMvtcjaE8a+VNXr
         cSAOPCPxazBJ8alBbdNIBmpRiBH5wAuxBfU4I8YOomFp2+f/tkjuRUw/wgcbBcxVfy4M
         +HiR1LIQuveRgfhMIDB2XkWSj2ewmfDd5AUBiA/VXtvk3uzsTuw+cpHUJ3+9qZjtyJP0
         UQr6cwPbavoKhxgLDZ2sqWPDFP0UQEafToeXCjlZ9RxiJ27L6mQYNNchsSg+MqF5buFn
         aJIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683733610; x=1686325610;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wQNs9/mF66N86FuTHCtwPTsRV3BCVF0omcWHqxDMmZE=;
        b=QiBnT4hRHWWWO1slO0cbl2olXHzF+sE+NHhcdKzLhv4mVDXLt71XZabQZQtWzHZ55h
         Bu36I6GCWT8q3XvnOqAOPIzN7/yDjBZkKjjzjRXfmnnguN+8lMENED93hoYRKtEIPfJv
         LNO5+9KgSfezdLk3ubuRem83etLPbm6YUaIJAHtQ44MtsVYgPyya+yBpCnf5+1u7fyU8
         dkrBd4ApzJoIF6xIVstwLQ6Jq0gnbvKHk3FYNgHE7K4/5GrnByU1vwvmObEGvnaC/Chi
         vYmkQ0izSsElPlAOgPdtgx9W2v72ectZIvBV86VGkrtHcbvV0SkI9jd76iLvayySXedX
         OWnA==
X-Gm-Message-State: AC+VfDxqJDX8YFguDEFO1eQFtl3Avm0nzPE0KfDomVsnvSDDZnYSPlsN
	KKY+M48iw7glObbwFxdZqnJjg9b70ngXgg==
X-Google-Smtp-Source: ACHHUZ7wqoHfxHtrzQbJ6NBBLDKTiKuwjcaRxqdvxYVmJN1xiIZ/iA1GvrFQyclsfpTnPc1sTZ/4Bj8hvhYMhg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:5d3:0:b0:ba5:ebb8:129d with SMTP id
 202-20020a2505d3000000b00ba5ebb8129dmr2791612ybf.3.1683733609988; Wed, 10 May
 2023 08:46:49 -0700 (PDT)
Date: Wed, 10 May 2023 15:46:46 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230510154646.370659-1-edumazet@google.com>
Subject: [PATCH net] ipv6: remove nexthop_fib6_nh_bh()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

After blamed commit, nexthop_fib6_nh_bh() and nexthop_fib6_nh()
are the same.

Delete nexthop_fib6_nh_bh(), and convert /proc/net/ipv6_route
to standard rcu to avoid this splat:

[ 5723.180080] WARNING: suspicious RCU usage
[ 5723.180083] -----------------------------
[ 5723.180084] include/net/nexthop.h:516 suspicious rcu_dereference_check() usage!
[ 5723.180086]
other info that might help us debug this:

[ 5723.180087]
rcu_scheduler_active = 2, debug_locks = 1
[ 5723.180089] 2 locks held by cat/55856:
[ 5723.180091] #0: ffff9440a582afa8 (&p->lock){+.+.}-{3:3}, at: seq_read_iter (fs/seq_file.c:188)
[ 5723.180100] #1: ffffffffaac07040 (rcu_read_lock_bh){....}-{1:2}, at: rcu_lock_acquire (include/linux/rcupdate.h:326)
[ 5723.180109]
stack backtrace:
[ 5723.180111] CPU: 14 PID: 55856 Comm: cat Tainted: G S        I        6.3.0-dbx-DEV #528
[ 5723.180115] Call Trace:
[ 5723.180117]  <TASK>
[ 5723.180119] dump_stack_lvl (lib/dump_stack.c:107)
[ 5723.180124] dump_stack (lib/dump_stack.c:114)
[ 5723.180126] lockdep_rcu_suspicious (include/linux/context_tracking.h:122)
[ 5723.180132] ipv6_route_seq_show (include/net/nexthop.h:?)
[ 5723.180135] ? ipv6_route_seq_next (net/ipv6/ip6_fib.c:2605)
[ 5723.180140] seq_read_iter (fs/seq_file.c:272)
[ 5723.180145] seq_read (fs/seq_file.c:163)
[ 5723.180151] proc_reg_read (fs/proc/inode.c:316 fs/proc/inode.c:328)
[ 5723.180155] vfs_read (fs/read_write.c:468)
[ 5723.180160] ? up_read (kernel/locking/rwsem.c:1617)
[ 5723.180164] ksys_read (fs/read_write.c:613)
[ 5723.180168] __x64_sys_read (fs/read_write.c:621)
[ 5723.180170] do_syscall_64 (arch/x86/entry/common.c:?)
[ 5723.180174] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
[ 5723.180177] RIP: 0033:0x7fa455677d2a

Fixes: 09eed1192cec ("neighbour: switch to standard rcu, instead of rcu_bh")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/nexthop.h | 23 -----------------------
 net/ipv6/ip6_fib.c    | 16 ++++++++--------
 2 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 9fa291a046211e4fc1c7ae56094a124c4ce0a516..2b12725de9c094f6ac89831576a2556d5dad5e64 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -497,29 +497,6 @@ static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
 	return NULL;
 }
 
-/* Variant of nexthop_fib6_nh().
- * Caller should either hold rcu_read_lock(), or RTNL.
- */
-static inline struct fib6_nh *nexthop_fib6_nh_bh(struct nexthop *nh)
-{
-	struct nh_info *nhi;
-
-	if (nh->is_group) {
-		struct nh_group *nh_grp;
-
-		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
-		nh = nexthop_mpath_select(nh_grp, 0);
-		if (!nh)
-			return NULL;
-	}
-
-	nhi = rcu_dereference_rtnl(nh->nh_info);
-	if (nhi->family == AF_INET6)
-		return &nhi->fib6_nh;
-
-	return NULL;
-}
-
 static inline struct net_device *fib6_info_nh_dev(struct fib6_info *f6i)
 {
 	struct fib6_nh *fib6_nh;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 2438da5ff6da810d9f612fc66df4d28510f50f10..bac768d36cc19fbaa2ac80be42c15388180bacb3 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2491,7 +2491,7 @@ static int ipv6_route_native_seq_show(struct seq_file *seq, void *v)
 	const struct net_device *dev;
 
 	if (rt->nh)
-		fib6_nh = nexthop_fib6_nh_bh(rt->nh);
+		fib6_nh = nexthop_fib6_nh(rt->nh);
 
 	seq_printf(seq, "%pi6 %02x ", &rt->fib6_dst.addr, rt->fib6_dst.plen);
 
@@ -2556,14 +2556,14 @@ static struct fib6_table *ipv6_route_seq_next_table(struct fib6_table *tbl,
 
 	if (tbl) {
 		h = (tbl->tb6_id & (FIB6_TABLE_HASHSZ - 1)) + 1;
-		node = rcu_dereference_bh(hlist_next_rcu(&tbl->tb6_hlist));
+		node = rcu_dereference(hlist_next_rcu(&tbl->tb6_hlist));
 	} else {
 		h = 0;
 		node = NULL;
 	}
 
 	while (!node && h < FIB6_TABLE_HASHSZ) {
-		node = rcu_dereference_bh(
+		node = rcu_dereference(
 			hlist_first_rcu(&net->ipv6.fib_table_hash[h++]));
 	}
 	return hlist_entry_safe(node, struct fib6_table, tb6_hlist);
@@ -2593,7 +2593,7 @@ static void *ipv6_route_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	if (!v)
 		goto iter_table;
 
-	n = rcu_dereference_bh(((struct fib6_info *)v)->fib6_next);
+	n = rcu_dereference(((struct fib6_info *)v)->fib6_next);
 	if (n)
 		return n;
 
@@ -2619,12 +2619,12 @@ static void *ipv6_route_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void *ipv6_route_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(RCU_BH)
+	__acquires(RCU)
 {
 	struct net *net = seq_file_net(seq);
 	struct ipv6_route_iter *iter = seq->private;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	iter->tbl = ipv6_route_seq_next_table(NULL, net);
 	iter->skip = *pos;
 
@@ -2645,7 +2645,7 @@ static bool ipv6_route_iter_active(struct ipv6_route_iter *iter)
 }
 
 static void ipv6_route_native_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU_BH)
+	__releases(RCU)
 {
 	struct net *net = seq_file_net(seq);
 	struct ipv6_route_iter *iter = seq->private;
@@ -2653,7 +2653,7 @@ static void ipv6_route_native_seq_stop(struct seq_file *seq, void *v)
 	if (ipv6_route_iter_active(iter))
 		fib6_walker_unlink(net, &iter->w);
 
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 }
 
 #if IS_BUILTIN(CONFIG_IPV6) && defined(CONFIG_BPF_SYSCALL)
-- 
2.40.1.521.gf1e218fcd8-goog


