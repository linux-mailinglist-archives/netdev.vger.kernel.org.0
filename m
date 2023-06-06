Return-Path: <netdev+bounces-8433-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FD817240B6
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:19:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DB762812A9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C2515AD0;
	Tue,  6 Jun 2023 11:19:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B23468F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:19:35 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DFF9E
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:19:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bb0cb2e67c5so8492468276.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 04:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686050371; x=1688642371;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4Hutmtpx+G1eS/G879nF3k5Ijeckimekj5SHiyS9i00=;
        b=XKNmlp0mqJSqs11mxPhKuqVFhX0lxDrpvMar9gOKn7OXf+XTzkY1dqdXuRIIngudcM
         tdJJ2opS3DRPQDVlGspnj7VGwZaqO0aAajyXdJawI6ACjbbAFv89YdqmI0UFOR9sWEi7
         3T0yCETT+XE2465WGNlQZgdwjkQ7QEAdhj2vYMVM4YmefMVb5CaYutgLIWOf/nI3yAds
         8L0/gTE5jQCCugGaaUC7XTMyc9Mfyn/d7Vnm2GTUlADBOYnAz+0WZqQTKvVFg1UEL86G
         D0HF06mUkt8/1rObSc69YuZbjOgvZ/EWWQ3+30L5waJd9QfzpfKPyueRST5DaYnKZCYi
         TDOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686050371; x=1688642371;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Hutmtpx+G1eS/G879nF3k5Ijeckimekj5SHiyS9i00=;
        b=kFtVpp3zSu2jRM9Fr5PI4ZwaGncq5ZCHpieFTld0lYfVhB/LgkAdMHI+2PkKgT+NUo
         jAWPLzbTuhoDRnYZUvHvNUCB7vMfnh6di4rQBDtQnGUVAx0A7+tS9aFevhhNFi9Hxx1a
         dPLOQb3rS0j/NkVCIWIfrgAjtNsu2dGk8vpX/U+qRj7EF9f7u6oLftn62oTJLLGaFkff
         MIC5fM+IEr11B8hD90dLm3TZ1NTEDGsSQbqhR+WMtWcU+2FMT7/4t4MgtbyfhK13WUaY
         OocFM9IIi7EacTQMOtWx5ZtMKdmSssbGMgmww1LiuqYfcLLZ0eL1ggmDKFCmz6XQg653
         Rzcw==
X-Gm-Message-State: AC+VfDyZefhn6r+kn2r5ubdlgCiY8rhsl8l6NRVbORPuJ+imyIHfwE3H
	UEVf+TCBNDTC+hcnGwan+VOEPh40i9mvDw==
X-Google-Smtp-Source: ACHHUZ4TP1bRAwEQBR4YF9QMoeEOtzIkDLol6Hl31jahSfZwdUEy8+zpKSUJ06QszVyyusXkaw7md77q2h4c5Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:f0e:0:b0:b9a:6508:1b5f with SMTP id
 x14-20020a5b0f0e000000b00b9a65081b5fmr576944ybr.11.1686050371415; Tue, 06 Jun
 2023 04:19:31 -0700 (PDT)
Date: Tue,  6 Jun 2023 11:19:29 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606111929.4122528-1-edumazet@google.com>
Subject: [PATCH net] net: sched: add rcu annotations around qdisc->qdisc_sleeping
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>, 
	Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot reported a race around qdisc->qdisc_sleeping [1]

It is time we add proper annotations to reads and writes to/from
qdisc->qdisc_sleeping.

[1]
BUG: KCSAN: data-race in dev_graft_qdisc / qdisc_lookup_rcu

read to 0xffff8881286fc618 of 8 bytes by task 6928 on cpu 1:
qdisc_lookup_rcu+0x192/0x2c0 net/sched/sch_api.c:331
__tcf_qdisc_find+0x74/0x3c0 net/sched/cls_api.c:1174
tc_get_tfilter+0x18f/0x990 net/sched/cls_api.c:2547
rtnetlink_rcv_msg+0x7af/0x8c0 net/core/rtnetlink.c:6386
netlink_rcv_skb+0x126/0x220 net/netlink/af_netlink.c:2546
rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:6413
netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
netlink_unicast+0x56f/0x640 net/netlink/af_netlink.c:1365
netlink_sendmsg+0x665/0x770 net/netlink/af_netlink.c:1913
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg net/socket.c:747 [inline]
____sys_sendmsg+0x375/0x4c0 net/socket.c:2503
___sys_sendmsg net/socket.c:2557 [inline]
__sys_sendmsg+0x1e3/0x270 net/socket.c:2586
__do_sys_sendmsg net/socket.c:2595 [inline]
__se_sys_sendmsg net/socket.c:2593 [inline]
__x64_sys_sendmsg+0x46/0x50 net/socket.c:2593
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

write to 0xffff8881286fc618 of 8 bytes by task 6912 on cpu 0:
dev_graft_qdisc+0x4f/0x80 net/sched/sch_generic.c:1115
qdisc_graft+0x7d0/0xb60 net/sched/sch_api.c:1103
tc_modify_qdisc+0x712/0xf10 net/sched/sch_api.c:1693
rtnetlink_rcv_msg+0x807/0x8c0 net/core/rtnetlink.c:6395
netlink_rcv_skb+0x126/0x220 net/netlink/af_netlink.c:2546
rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:6413
netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
netlink_unicast+0x56f/0x640 net/netlink/af_netlink.c:1365
netlink_sendmsg+0x665/0x770 net/netlink/af_netlink.c:1913
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg net/socket.c:747 [inline]
____sys_sendmsg+0x375/0x4c0 net/socket.c:2503
___sys_sendmsg net/socket.c:2557 [inline]
__sys_sendmsg+0x1e3/0x270 net/socket.c:2586
__do_sys_sendmsg net/socket.c:2595 [inline]
__se_sys_sendmsg net/socket.c:2593 [inline]
__x64_sys_sendmsg+0x46/0x50 net/socket.c:2593
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 6912 Comm: syz-executor.5 Not tainted 6.4.0-rc3-syzkaller-00190-g0d85b27b0cc6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/16/2023

Fixes: 3a7d0d07a386 ("net: sched: extend Qdisc with rcu")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vlad Buslov <vladbu@nvidia.com>
---
 include/linux/netdevice.h |  2 +-
 include/net/sch_generic.h |  6 ++++--
 net/core/dev.c            |  2 +-
 net/sched/sch_api.c       | 26 ++++++++++++++++----------
 net/sched/sch_fq_pie.c    |  2 ++
 net/sched/sch_generic.c   | 30 +++++++++++++++---------------
 net/sched/sch_mq.c        |  8 ++++----
 net/sched/sch_mqprio.c    |  8 ++++----
 net/sched/sch_pie.c       |  5 ++++-
 net/sched/sch_red.c       |  5 ++++-
 net/sched/sch_sfq.c       |  5 ++++-
 net/sched/sch_taprio.c    |  6 +++---
 net/sched/sch_teql.c      |  2 +-
 13 files changed, 63 insertions(+), 44 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e6f22b7403d014a2cf4d81d931109a594ce1398e..c2f0c6002a84b206b26a16c432920b92740391b4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -620,7 +620,7 @@ struct netdev_queue {
 	netdevice_tracker	dev_tracker;
 
 	struct Qdisc __rcu	*qdisc;
-	struct Qdisc		*qdisc_sleeping;
+	struct Qdisc __rcu	*qdisc_sleeping;
 #ifdef CONFIG_SYSFS
 	struct kobject		kobj;
 #endif
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index fab5ba3e61b7c8ca92d9f9386fb2aa9a50d6b365..27271f2b37cb37ecbf1c48dcfb6f6b5845296fd2 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -545,7 +545,7 @@ static inline struct Qdisc *qdisc_root_bh(const struct Qdisc *qdisc)
 
 static inline struct Qdisc *qdisc_root_sleeping(const struct Qdisc *qdisc)
 {
-	return qdisc->dev_queue->qdisc_sleeping;
+	return rcu_dereference_rtnl(qdisc->dev_queue->qdisc_sleeping);
 }
 
 static inline spinlock_t *qdisc_root_sleeping_lock(const struct Qdisc *qdisc)
@@ -754,7 +754,9 @@ static inline bool qdisc_tx_changing(const struct net_device *dev)
 
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
-		if (rcu_access_pointer(txq->qdisc) != txq->qdisc_sleeping)
+
+		if (rcu_access_pointer(txq->qdisc) !=
+		    rcu_access_pointer(txq->qdisc_sleeping))
 			return true;
 	}
 	return false;
diff --git a/net/core/dev.c b/net/core/dev.c
index 1495f8aff288e944c8cab21297f244a6fcde752f..c29f3e1db3ca752f21baa68ff651ce694973a020 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10543,7 +10543,7 @@ struct netdev_queue *dev_ingress_queue_create(struct net_device *dev)
 		return NULL;
 	netdev_init_one_queue(dev, queue, NULL);
 	RCU_INIT_POINTER(queue->qdisc, &noop_qdisc);
-	queue->qdisc_sleeping = &noop_qdisc;
+	RCU_INIT_POINTER(queue->qdisc_sleeping, &noop_qdisc);
 	rcu_assign_pointer(dev->ingress_queue, queue);
 #endif
 	return queue;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 9ea51812b9cf28f0121daba1206e34ec864df595..e4b6452318c0afd6e77ec8234c351b2613a8cb19 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -309,7 +309,7 @@ struct Qdisc *qdisc_lookup(struct net_device *dev, u32 handle)
 
 	if (dev_ingress_queue(dev))
 		q = qdisc_match_from_root(
-			dev_ingress_queue(dev)->qdisc_sleeping,
+			rtnl_dereference(dev_ingress_queue(dev)->qdisc_sleeping),
 			handle);
 out:
 	return q;
@@ -328,7 +328,8 @@ struct Qdisc *qdisc_lookup_rcu(struct net_device *dev, u32 handle)
 
 	nq = dev_ingress_queue_rcu(dev);
 	if (nq)
-		q = qdisc_match_from_root(nq->qdisc_sleeping, handle);
+		q = qdisc_match_from_root(rcu_dereference(nq->qdisc_sleeping),
+					  handle);
 out:
 	return q;
 }
@@ -634,8 +635,13 @@ EXPORT_SYMBOL(qdisc_watchdog_init);
 void qdisc_watchdog_schedule_range_ns(struct qdisc_watchdog *wd, u64 expires,
 				      u64 delta_ns)
 {
-	if (test_bit(__QDISC_STATE_DEACTIVATED,
-		     &qdisc_root_sleeping(wd->qdisc)->state))
+	bool deactivated;
+
+	rcu_read_lock();
+	deactivated = test_bit(__QDISC_STATE_DEACTIVATED,
+			       &qdisc_root_sleeping(wd->qdisc)->state);
+	rcu_read_unlock();
+	if (deactivated)
 		return;
 
 	if (hrtimer_is_queued(&wd->timer)) {
@@ -1478,7 +1484,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				}
 				q = qdisc_leaf(p, clid);
 			} else if (dev_ingress_queue(dev)) {
-				q = dev_ingress_queue(dev)->qdisc_sleeping;
+				q = rtnl_dereference(dev_ingress_queue(dev)->qdisc_sleeping);
 			}
 		} else {
 			q = rtnl_dereference(dev->qdisc);
@@ -1564,7 +1570,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				}
 				q = qdisc_leaf(p, clid);
 			} else if (dev_ingress_queue_create(dev)) {
-				q = dev_ingress_queue(dev)->qdisc_sleeping;
+				q = rtnl_dereference(dev_ingress_queue(dev)->qdisc_sleeping);
 			}
 		} else {
 			q = rtnl_dereference(dev->qdisc);
@@ -1805,8 +1811,8 @@ static int tc_dump_qdisc(struct sk_buff *skb, struct netlink_callback *cb)
 
 		dev_queue = dev_ingress_queue(dev);
 		if (dev_queue &&
-		    tc_dump_qdisc_root(dev_queue->qdisc_sleeping, skb, cb,
-				       &q_idx, s_q_idx, false,
+		    tc_dump_qdisc_root(rtnl_dereference(dev_queue->qdisc_sleeping),
+				       skb, cb, &q_idx, s_q_idx, false,
 				       tca[TCA_DUMP_INVISIBLE]) < 0)
 			goto done;
 
@@ -2249,8 +2255,8 @@ static int tc_dump_tclass(struct sk_buff *skb, struct netlink_callback *cb)
 
 	dev_queue = dev_ingress_queue(dev);
 	if (dev_queue &&
-	    tc_dump_tclass_root(dev_queue->qdisc_sleeping, skb, tcm, cb,
-				&t, s_t, false) < 0)
+	    tc_dump_tclass_root(rtnl_dereference(dev_queue->qdisc_sleeping),
+				skb, tcm, cb, &t, s_t, false) < 0)
 		goto done;
 
 done:
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index c699e5095607dedbc921802f31e8f4c78c35985f..591d87d5e5c0f10379645da9eb0f4e7309d74916 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -379,6 +379,7 @@ static void fq_pie_timer(struct timer_list *t)
 	spinlock_t *root_lock; /* to lock qdisc for probability calculations */
 	u32 idx;
 
+	rcu_read_lock();
 	root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 	spin_lock(root_lock);
 
@@ -391,6 +392,7 @@ static void fq_pie_timer(struct timer_list *t)
 		mod_timer(&q->adapt_timer, jiffies + q->p_params.tupdate);
 
 	spin_unlock(root_lock);
+	rcu_read_unlock();
 }
 
 static int fq_pie_init(struct Qdisc *sch, struct nlattr *opt,
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 37e41f972f69fbff15b1817908c473d22ba410d3..3248259eba32ac21276d5d2e2e3613ec9e707d06 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -648,7 +648,7 @@ struct Qdisc_ops noop_qdisc_ops __read_mostly = {
 
 static struct netdev_queue noop_netdev_queue = {
 	RCU_POINTER_INITIALIZER(qdisc, &noop_qdisc),
-	.qdisc_sleeping	=	&noop_qdisc,
+	RCU_POINTER_INITIALIZER(qdisc_sleeping, &noop_qdisc),
 };
 
 struct Qdisc noop_qdisc = {
@@ -1103,7 +1103,7 @@ EXPORT_SYMBOL(qdisc_put_unlocked);
 struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
 			      struct Qdisc *qdisc)
 {
-	struct Qdisc *oqdisc = dev_queue->qdisc_sleeping;
+	struct Qdisc *oqdisc = rtnl_dereference(dev_queue->qdisc_sleeping);
 	spinlock_t *root_lock;
 
 	root_lock = qdisc_lock(oqdisc);
@@ -1112,7 +1112,7 @@ struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
 	/* ... and graft new one */
 	if (qdisc == NULL)
 		qdisc = &noop_qdisc;
-	dev_queue->qdisc_sleeping = qdisc;
+	rcu_assign_pointer(dev_queue->qdisc_sleeping, qdisc);
 	rcu_assign_pointer(dev_queue->qdisc, &noop_qdisc);
 
 	spin_unlock_bh(root_lock);
@@ -1125,12 +1125,12 @@ static void shutdown_scheduler_queue(struct net_device *dev,
 				     struct netdev_queue *dev_queue,
 				     void *_qdisc_default)
 {
-	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
+	struct Qdisc *qdisc = rtnl_dereference(dev_queue->qdisc_sleeping);
 	struct Qdisc *qdisc_default = _qdisc_default;
 
 	if (qdisc) {
 		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
-		dev_queue->qdisc_sleeping = qdisc_default;
+		rcu_assign_pointer(dev_queue->qdisc_sleeping, qdisc_default);
 
 		qdisc_put(qdisc);
 	}
@@ -1154,7 +1154,7 @@ static void attach_one_default_qdisc(struct net_device *dev,
 
 	if (!netif_is_multiqueue(dev))
 		qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
-	dev_queue->qdisc_sleeping = qdisc;
+	rcu_assign_pointer(dev_queue->qdisc_sleeping, qdisc);
 }
 
 static void attach_default_qdiscs(struct net_device *dev)
@@ -1167,7 +1167,7 @@ static void attach_default_qdiscs(struct net_device *dev)
 	if (!netif_is_multiqueue(dev) ||
 	    dev->priv_flags & IFF_NO_QUEUE) {
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
-		qdisc = txq->qdisc_sleeping;
+		qdisc = rtnl_dereference(txq->qdisc_sleeping);
 		rcu_assign_pointer(dev->qdisc, qdisc);
 		qdisc_refcount_inc(qdisc);
 	} else {
@@ -1186,7 +1186,7 @@ static void attach_default_qdiscs(struct net_device *dev)
 		netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
 		dev->priv_flags |= IFF_NO_QUEUE;
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
-		qdisc = txq->qdisc_sleeping;
+		qdisc = rtnl_dereference(txq->qdisc_sleeping);
 		rcu_assign_pointer(dev->qdisc, qdisc);
 		qdisc_refcount_inc(qdisc);
 		dev->priv_flags ^= IFF_NO_QUEUE;
@@ -1202,7 +1202,7 @@ static void transition_one_qdisc(struct net_device *dev,
 				 struct netdev_queue *dev_queue,
 				 void *_need_watchdog)
 {
-	struct Qdisc *new_qdisc = dev_queue->qdisc_sleeping;
+	struct Qdisc *new_qdisc = rtnl_dereference(dev_queue->qdisc_sleeping);
 	int *need_watchdog_p = _need_watchdog;
 
 	if (!(new_qdisc->flags & TCQ_F_BUILTIN))
@@ -1272,7 +1272,7 @@ static void dev_reset_queue(struct net_device *dev,
 	struct Qdisc *qdisc;
 	bool nolock;
 
-	qdisc = dev_queue->qdisc_sleeping;
+	qdisc = rtnl_dereference(dev_queue->qdisc_sleeping);
 	if (!qdisc)
 		return;
 
@@ -1303,7 +1303,7 @@ static bool some_qdisc_is_busy(struct net_device *dev)
 		int val;
 
 		dev_queue = netdev_get_tx_queue(dev, i);
-		q = dev_queue->qdisc_sleeping;
+		q = rtnl_dereference(dev_queue->qdisc_sleeping);
 
 		root_lock = qdisc_lock(q);
 		spin_lock_bh(root_lock);
@@ -1379,7 +1379,7 @@ EXPORT_SYMBOL(dev_deactivate);
 static int qdisc_change_tx_queue_len(struct net_device *dev,
 				     struct netdev_queue *dev_queue)
 {
-	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
+	struct Qdisc *qdisc = rtnl_dereference(dev_queue->qdisc_sleeping);
 	const struct Qdisc_ops *ops = qdisc->ops;
 
 	if (ops->change_tx_queue_len)
@@ -1404,7 +1404,7 @@ void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx)
 	unsigned int i;
 
 	for (i = new_real_tx; i < dev->real_num_tx_queues; i++) {
-		qdisc = netdev_get_tx_queue(dev, i)->qdisc_sleeping;
+		qdisc = rtnl_dereference(netdev_get_tx_queue(dev, i)->qdisc_sleeping);
 		/* Only update the default qdiscs we created,
 		 * qdiscs with handles are always hashed.
 		 */
@@ -1412,7 +1412,7 @@ void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx)
 			qdisc_hash_del(qdisc);
 	}
 	for (i = dev->real_num_tx_queues; i < new_real_tx; i++) {
-		qdisc = netdev_get_tx_queue(dev, i)->qdisc_sleeping;
+		qdisc = rtnl_dereference(netdev_get_tx_queue(dev, i)->qdisc_sleeping);
 		if (qdisc != &noop_qdisc && !qdisc->handle)
 			qdisc_hash_add(qdisc, false);
 	}
@@ -1449,7 +1449,7 @@ static void dev_init_scheduler_queue(struct net_device *dev,
 	struct Qdisc *qdisc = _qdisc;
 
 	rcu_assign_pointer(dev_queue->qdisc, qdisc);
-	dev_queue->qdisc_sleeping = qdisc;
+	rcu_assign_pointer(dev_queue->qdisc_sleeping, qdisc);
 }
 
 void dev_init_scheduler(struct net_device *dev)
diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index d0bc660d7401f9d0b1509ac65e641622f51a99b3..c860119a8f091c68c64932dee48465f4bca6f901 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -141,7 +141,7 @@ static int mq_dump(struct Qdisc *sch, struct sk_buff *skb)
 	 * qdisc totals are added at end.
 	 */
 	for (ntx = 0; ntx < dev->num_tx_queues; ntx++) {
-		qdisc = netdev_get_tx_queue(dev, ntx)->qdisc_sleeping;
+		qdisc = rtnl_dereference(netdev_get_tx_queue(dev, ntx)->qdisc_sleeping);
 		spin_lock_bh(qdisc_lock(qdisc));
 
 		gnet_stats_add_basic(&sch->bstats, qdisc->cpu_bstats,
@@ -202,7 +202,7 @@ static struct Qdisc *mq_leaf(struct Qdisc *sch, unsigned long cl)
 {
 	struct netdev_queue *dev_queue = mq_queue_get(sch, cl);
 
-	return dev_queue->qdisc_sleeping;
+	return rtnl_dereference(dev_queue->qdisc_sleeping);
 }
 
 static unsigned long mq_find(struct Qdisc *sch, u32 classid)
@@ -221,7 +221,7 @@ static int mq_dump_class(struct Qdisc *sch, unsigned long cl,
 
 	tcm->tcm_parent = TC_H_ROOT;
 	tcm->tcm_handle |= TC_H_MIN(cl);
-	tcm->tcm_info = dev_queue->qdisc_sleeping->handle;
+	tcm->tcm_info = rtnl_dereference(dev_queue->qdisc_sleeping)->handle;
 	return 0;
 }
 
@@ -230,7 +230,7 @@ static int mq_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 {
 	struct netdev_queue *dev_queue = mq_queue_get(sch, cl);
 
-	sch = dev_queue->qdisc_sleeping;
+	sch = rtnl_dereference(dev_queue->qdisc_sleeping);
 	if (gnet_stats_copy_basic(d, sch->cpu_bstats, &sch->bstats, true) < 0 ||
 	    qdisc_qstats_copy(d, sch) < 0)
 		return -1;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index dc5a0ff50b142f61c17661590b985a348b51691d..ab69ff7577fc7dba0cc9d899c25bc6a2fcee4b43 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -557,7 +557,7 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	 * qdisc totals are added at end.
 	 */
 	for (ntx = 0; ntx < dev->num_tx_queues; ntx++) {
-		qdisc = netdev_get_tx_queue(dev, ntx)->qdisc_sleeping;
+		qdisc = rtnl_dereference(netdev_get_tx_queue(dev, ntx)->qdisc_sleeping);
 		spin_lock_bh(qdisc_lock(qdisc));
 
 		gnet_stats_add_basic(&sch->bstats, qdisc->cpu_bstats,
@@ -604,7 +604,7 @@ static struct Qdisc *mqprio_leaf(struct Qdisc *sch, unsigned long cl)
 	if (!dev_queue)
 		return NULL;
 
-	return dev_queue->qdisc_sleeping;
+	return rtnl_dereference(dev_queue->qdisc_sleeping);
 }
 
 static unsigned long mqprio_find(struct Qdisc *sch, u32 classid)
@@ -637,7 +637,7 @@ static int mqprio_dump_class(struct Qdisc *sch, unsigned long cl,
 		tcm->tcm_parent = (tc < 0) ? 0 :
 			TC_H_MAKE(TC_H_MAJ(sch->handle),
 				  TC_H_MIN(tc + TC_H_MIN_PRIORITY));
-		tcm->tcm_info = dev_queue->qdisc_sleeping->handle;
+		tcm->tcm_info = rtnl_dereference(dev_queue->qdisc_sleeping)->handle;
 	} else {
 		tcm->tcm_parent = TC_H_ROOT;
 		tcm->tcm_info = 0;
@@ -693,7 +693,7 @@ static int mqprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 	} else {
 		struct netdev_queue *dev_queue = mqprio_queue_get(sch, cl);
 
-		sch = dev_queue->qdisc_sleeping;
+		sch = rtnl_dereference(dev_queue->qdisc_sleeping);
 		if (gnet_stats_copy_basic(d, sch->cpu_bstats,
 					  &sch->bstats, true) < 0 ||
 		    qdisc_qstats_copy(d, sch) < 0)
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 2152a56d73f86eddc432a47c0cf6383c59ab2d43..2da6250ec3463686a1d588da224314befcc1478b 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -421,8 +421,10 @@ static void pie_timer(struct timer_list *t)
 {
 	struct pie_sched_data *q = from_timer(q, t, adapt_timer);
 	struct Qdisc *sch = q->sch;
-	spinlock_t *root_lock = qdisc_lock(qdisc_root_sleeping(sch));
+	spinlock_t *root_lock;
 
+	rcu_read_lock();
+	root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 	spin_lock(root_lock);
 	pie_calculate_probability(&q->params, &q->vars, sch->qstats.backlog);
 
@@ -430,6 +432,7 @@ static void pie_timer(struct timer_list *t)
 	if (q->params.tupdate)
 		mod_timer(&q->adapt_timer, jiffies + q->params.tupdate);
 	spin_unlock(root_lock);
+	rcu_read_unlock();
 }
 
 static int pie_init(struct Qdisc *sch, struct nlattr *opt,
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 98129324e1573b5178c60300ac93666afe154dbe..16277b6a0238dabc18ef78768ad4495d23999025 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -321,12 +321,15 @@ static inline void red_adaptative_timer(struct timer_list *t)
 {
 	struct red_sched_data *q = from_timer(q, t, adapt_timer);
 	struct Qdisc *sch = q->sch;
-	spinlock_t *root_lock = qdisc_lock(qdisc_root_sleeping(sch));
+	spinlock_t *root_lock;
 
+	rcu_read_lock();
+	root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 	spin_lock(root_lock);
 	red_adaptative_algo(&q->parms, &q->vars);
 	mod_timer(&q->adapt_timer, jiffies + HZ/2);
 	spin_unlock(root_lock);
+	rcu_read_unlock();
 }
 
 static int red_init(struct Qdisc *sch, struct nlattr *opt,
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index abd436307d6a8492d2d297c138d3b3e0309b949f..66dcb18638fea440f6f5bce2ca45b6179b060408 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -606,10 +606,12 @@ static void sfq_perturbation(struct timer_list *t)
 {
 	struct sfq_sched_data *q = from_timer(q, t, perturb_timer);
 	struct Qdisc *sch = q->sch;
-	spinlock_t *root_lock = qdisc_lock(qdisc_root_sleeping(sch));
+	spinlock_t *root_lock;
 	siphash_key_t nkey;
 
 	get_random_bytes(&nkey, sizeof(nkey));
+	rcu_read_lock();
+	root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 	spin_lock(root_lock);
 	q->perturbation = nkey;
 	if (!q->filter_list && q->tail)
@@ -618,6 +620,7 @@ static void sfq_perturbation(struct timer_list *t)
 
 	if (q->perturb_period)
 		mod_timer(&q->perturb_timer, jiffies + q->perturb_period);
+	rcu_read_unlock();
 }
 
 static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 76db9a10ef504d6f6adeea1c920bf0e3d49c2df8..dd7dea2f6e836da4051c1726d202e53fe15627ff 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2358,7 +2358,7 @@ static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
 	if (!dev_queue)
 		return NULL;
 
-	return dev_queue->qdisc_sleeping;
+	return rtnl_dereference(dev_queue->qdisc_sleeping);
 }
 
 static unsigned long taprio_find(struct Qdisc *sch, u32 classid)
@@ -2377,7 +2377,7 @@ static int taprio_dump_class(struct Qdisc *sch, unsigned long cl,
 
 	tcm->tcm_parent = TC_H_ROOT;
 	tcm->tcm_handle |= TC_H_MIN(cl);
-	tcm->tcm_info = dev_queue->qdisc_sleeping->handle;
+	tcm->tcm_info = rtnl_dereference(dev_queue->qdisc_sleeping)->handle;
 
 	return 0;
 }
@@ -2389,7 +2389,7 @@ static int taprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 {
 	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
 
-	sch = dev_queue->qdisc_sleeping;
+	sch = rtnl_dereference(dev_queue->qdisc_sleeping);
 	if (gnet_stats_copy_basic(d, NULL, &sch->bstats, true) < 0 ||
 	    qdisc_qstats_copy(d, sch) < 0)
 		return -1;
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 16f9238aa51d133f7004b97b7aa558354634b73d..7721239c185fb0d54ab36300f9138dbc98521ace 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -297,7 +297,7 @@ static netdev_tx_t teql_master_xmit(struct sk_buff *skb, struct net_device *dev)
 		struct net_device *slave = qdisc_dev(q);
 		struct netdev_queue *slave_txq = netdev_get_tx_queue(slave, 0);
 
-		if (slave_txq->qdisc_sleeping != q)
+		if (rcu_access_pointer(slave_txq->qdisc_sleeping) != q)
 			continue;
 		if (netif_xmit_stopped(netdev_get_tx_queue(slave, subq)) ||
 		    !netif_running(slave)) {
-- 
2.41.0.rc0.172.g3f132b7071-goog


