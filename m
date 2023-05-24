Return-Path: <netdev+bounces-4841-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 794E070EAB1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30160281769
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 01:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62CFA1360;
	Wed, 24 May 2023 01:20:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50697ED5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:20:42 +0000 (UTC)
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8F1127;
	Tue, 23 May 2023 18:20:34 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-75b1219506fso49849385a.1;
        Tue, 23 May 2023 18:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684891234; x=1687483234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKpUR2FFpXmH27P+0k3LZaBzm4wZrrFObgzzkOXFaAo=;
        b=efMfi9QMl8QWY/ux4eAXzVEX+V70xaI3MurHUynBLz+plLkXN4MdhgAsxDmQfgIB8H
         ROtuL/tN/0JJlX5c/eaDT+f1e+AoFk9bq+Oc0Nr9TkM2+gVguu1QvnTxHhvNKXoutoyB
         Ff49L8zUQ9R5s8oRMfFyS6S+MfVrt/PJKfsQ9N6fkKDvMcL/b0zRFf6HtZUfmbXn8yHT
         B5YrM2Wnp7ezjAQcdgk2XVh4puSXNR8T4H3mxDpXZ8xxAGj8eRuZyI/L/j4wzLY6FcOa
         CyRZCrT2EJkDhfqbkQ+yp4Y//ySzHKaFAI3tuUOlzbzsEbni+CwPl7gmUixo74MXNDDR
         akCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684891234; x=1687483234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tKpUR2FFpXmH27P+0k3LZaBzm4wZrrFObgzzkOXFaAo=;
        b=df+FqzfmGjOhk8VSoCHz0EcqnWYaIsJ7JnJR2pOlekAodoiODWRbvARAUrphSYeAug
         kwDDMxckNg/mNvtZlHMMoXeWmkoa2TUHxmJYWuGdfc7wfwt9T9LK3pMNqPh1FOfrBJ1E
         zgfIklxRLf3yPJKiiDfsO5V2mlZi/UdtkVPDmUapZkGk+BIX8NRPHHxqe3xZlN3ckaFK
         Tul/RAiKfOJnkeUuahM1P36WOwFDSLrbyuqbGd0wNK+kbI5pnEN779YPInr6NuA6mWrG
         pfFKb5whw2YCEvsJQUv/2isVGMUZaWIPgfnZJrzMDDnBM9AAdnV3D8NQqeO1CMpBqSDx
         8r1Q==
X-Gm-Message-State: AC+VfDyukoUV9EDOps27lezkn20cXig9GhFBLEMzI8m2qnz8psOfQY+A
	+yaua8Qz+8YMVLaI337WZg==
X-Google-Smtp-Source: ACHHUZ4UHywzf9o4XPmV9szHh2dYEELnGTx+WKgxZFMWy+Sz45zMcC8uOnKR7lWV8SR4s/zUplFTTw==
X-Received: by 2002:a37:c48:0:b0:75b:23a1:8e4e with SMTP id 69-20020a370c48000000b0075b23a18e4emr6207392qkm.31.1684891233700;
        Tue, 23 May 2023 18:20:33 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:c32:b55:eaec:a556])
        by smtp.gmail.com with ESMTPSA id p16-20020ae9f310000000b007577d3d1f65sm2916899qkg.7.2023.05.23.18.20.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 18:20:33 -0700 (PDT)
From: Peilin Ye <yepeilin.cs@gmail.com>
X-Google-Original-From: Peilin Ye <peilin.ye@bytedance.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and clsact Qdiscs before grafting
Date: Tue, 23 May 2023 18:20:20 -0700
Message-Id: <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1684887977.git.peilin.ye@bytedance.com>
References: <cover.1684887977.git.peilin.ye@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Peilin Ye <peilin.ye@bytedance.com>

mini_Qdisc_pair::p_miniq is a double pointer to mini_Qdisc, initialized in
ingress_init() to point to net_device::miniq_ingress.  ingress Qdiscs
access this per-net_device pointer in mini_qdisc_pair_swap().  Similar for
clsact Qdiscs and miniq_egress.

Unfortunately, after introducing RTNL-unlocked RTM_{NEW,DEL,GET}TFILTER
requests (thanks Hillf Danton for the hint), when replacing ingress or
clsact Qdiscs, for example, the old Qdisc ("@old") could access the same
miniq_{in,e}gress pointer(s) concurrently with the new Qdisc ("@new"),
causing race conditions [1] including a use-after-free bug in
mini_qdisc_pair_swap() reported by syzbot:

 BUG: KASAN: slab-use-after-free in mini_qdisc_pair_swap+0x1c2/0x1f0 net/sched/sch_generic.c:1573
 Write of size 8 at addr ffff888045b31308 by task syz-executor690/14901
...
 Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
  print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:319
  print_report mm/kasan/report.c:430 [inline]
  kasan_report+0x11c/0x130 mm/kasan/report.c:536
  mini_qdisc_pair_swap+0x1c2/0x1f0 net/sched/sch_generic.c:1573
  tcf_chain_head_change_item net/sched/cls_api.c:495 [inline]
  tcf_chain0_head_change.isra.0+0xb9/0x120 net/sched/cls_api.c:509
  tcf_chain_tp_insert net/sched/cls_api.c:1826 [inline]
  tcf_chain_tp_insert_unique net/sched/cls_api.c:1875 [inline]
  tc_new_tfilter+0x1de6/0x2290 net/sched/cls_api.c:2266
...

@old and @new should not affect each other.  In other words, @old should
never modify miniq_{in,e}gress after @new, and @new should not update
@old's RCU state.  Fixing without changing sch_api.c turned out to be
difficult (please refer to Closes: for discussions).  Instead, make sure
@new's first call always happen after @old's last call, in
qdisc_destroy(), has finished:

In qdisc_graft(), return -EAGAIN and tell the caller to replay
(suggested by Vlad Buslov) if @old has any ongoing RTNL-unlocked filter
requests, and call qdisc_destroy() for @old before grafting @new.

Introduce qdisc_refcount_dec_if_one() as the counterpart of
qdisc_refcount_inc_nz() used for RTNL-unlocked filter requests.  Introduce
a non-static version of qdisc_destroy() that does a TCQ_F_BUILTIN check,
just like qdisc_put() etc.

Depends on patch "net/sched: Refactor qdisc_graft() for ingress and clsact
Qdiscs".

[1] To illustrate, the syzkaller reproducer adds ingress Qdiscs under
TC_H_ROOT (no longer possible after patch "net/sched: sch_ingress: Only
create under TC_H_INGRESS") on eth0 that has 8 transmission queues:

  Thread 1 creates ingress Qdisc A (containing mini Qdisc a1 and a2), then
  adds a flower filter X to A.

  Thread 2 creates another ingress Qdisc B (containing mini Qdisc b1 and
  b2) to replace A, then adds a flower filter Y to B.

 Thread 1               A's refcnt   Thread 2
  RTM_NEWQDISC (A, RTNL-locked)
   qdisc_create(A)               1
   qdisc_graft(A)                9

  RTM_NEWTFILTER (X, RTNL-unlocked)
   __tcf_qdisc_find(A)          10
   tcf_chain0_head_change(A)
   mini_qdisc_pair_swap(A) (1st)
            |
            |                         RTM_NEWQDISC (B, RTNL-locked)
         RCU sync                2     qdisc_graft(B)
            |                    1     notify_and_destroy(A)
            |
   tcf_block_release(A)          0    RTM_NEWTFILTER (Y, RTNL-unlocked)
   qdisc_destroy(A)                    tcf_chain0_head_change(B)
   tcf_chain0_head_change_cb_del(A)    mini_qdisc_pair_swap(B) (2nd)
   mini_qdisc_pair_swap(A) (3rd)                |
           ...                                 ...

Here, B calls mini_qdisc_pair_swap(), pointing eth0->miniq_ingress to its
mini Qdisc, b1.  Then, A calls mini_qdisc_pair_swap() again during
ingress_destroy(), setting eth0->miniq_ingress to NULL, so ingress packets
on eth0 will not find filter Y in sch_handle_ingress().

This is only one of the possible consequences of concurrently accessing
miniq_{in,e}gress pointers.  The point is clear though: again, A should
never modify those per-net_device pointers after B, and B should not
update A's RCU state.

Fixes: 7a096d579e8e ("net: sched: ingress: set 'unlocked' flag for Qdisc ops")
Fixes: 87f373921c4e ("net: sched: ingress: set 'unlocked' flag for clsact Qdisc ops")
Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/0000000000006cf87705f79acf1a@google.com/
Cc: Hillf Danton <hdanton@sina.com>
Cc: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change in v5:
  - reinitialize @q, @p (suggested by Vlad) and @tcm before replaying,
    just like @flags in tc_new_tfilter()

change in v3, v4:
  - add in-body From: tag

changes in v2:
  - replay the request if the current Qdisc has any ongoing RTNL-unlocked
    filter requests (Vlad)
  - minor changes in code comments and commit log

 include/net/sch_generic.h |  8 ++++++++
 net/sched/sch_api.c       | 40 ++++++++++++++++++++++++++++++---------
 net/sched/sch_generic.c   | 14 +++++++++++---
 3 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index fab5ba3e61b7..3e9cc43cbc90 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -137,6 +137,13 @@ static inline void qdisc_refcount_inc(struct Qdisc *qdisc)
 	refcount_inc(&qdisc->refcnt);
 }
 
+static inline bool qdisc_refcount_dec_if_one(struct Qdisc *qdisc)
+{
+	if (qdisc->flags & TCQ_F_BUILTIN)
+		return true;
+	return refcount_dec_if_one(&qdisc->refcnt);
+}
+
 /* Intended to be used by unlocked users, when concurrent qdisc release is
  * possible.
  */
@@ -652,6 +659,7 @@ void dev_deactivate_many(struct list_head *head);
 struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
 			      struct Qdisc *qdisc);
 void qdisc_reset(struct Qdisc *qdisc);
+void qdisc_destroy(struct Qdisc *qdisc);
 void qdisc_put(struct Qdisc *qdisc);
 void qdisc_put_unlocked(struct Qdisc *qdisc);
 void qdisc_tree_reduce_backlog(struct Qdisc *qdisc, int n, int len);
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index f72a581666a2..286b7c58f5b9 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1080,10 +1080,18 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 		if ((q && q->flags & TCQ_F_INGRESS) ||
 		    (new && new->flags & TCQ_F_INGRESS)) {
 			ingress = 1;
-			if (!dev_ingress_queue(dev)) {
+			dev_queue = dev_ingress_queue(dev);
+			if (!dev_queue) {
 				NL_SET_ERR_MSG(extack, "Device does not have an ingress queue");
 				return -ENOENT;
 			}
+
+			/* Replay if the current ingress (or clsact) Qdisc has ongoing
+			 * RTNL-unlocked filter request(s).  This is the counterpart of that
+			 * qdisc_refcount_inc_nz() call in __tcf_qdisc_find().
+			 */
+			if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_sleeping))
+				return -EAGAIN;
 		}
 
 		if (dev->flags & IFF_UP)
@@ -1104,8 +1112,16 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 				qdisc_put(old);
 			}
 		} else {
-			dev_queue = dev_ingress_queue(dev);
-			old = dev_graft_qdisc(dev_queue, new);
+			old = dev_graft_qdisc(dev_queue, NULL);
+
+			/* {ingress,clsact}_destroy() @old before grafting @new to avoid
+			 * unprotected concurrent accesses to net_device::miniq_{in,e}gress
+			 * pointer(s) in mini_qdisc_pair_swap().
+			 */
+			qdisc_notify(net, skb, n, classid, old, new, extack);
+			qdisc_destroy(old);
+
+			dev_graft_qdisc(dev_queue, new);
 		}
 
 skip:
@@ -1119,8 +1135,6 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 			if (new && new->ops->attach)
 				new->ops->attach(new);
-		} else {
-			notify_and_destroy(net, skb, n, classid, old, new, extack);
 		}
 
 		if (dev->flags & IFF_UP)
@@ -1450,19 +1464,22 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 			struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
-	struct tcmsg *tcm = nlmsg_data(n);
 	struct nlattr *tca[TCA_MAX + 1];
 	struct net_device *dev;
+	struct Qdisc *q, *p;
+	struct tcmsg *tcm;
 	u32 clid;
-	struct Qdisc *q = NULL;
-	struct Qdisc *p = NULL;
 	int err;
 
+replay:
 	err = nlmsg_parse_deprecated(n, sizeof(*tcm), tca, TCA_MAX,
 				     rtm_tca_policy, extack);
 	if (err < 0)
 		return err;
 
+	tcm = nlmsg_data(n);
+	q = p = NULL;
+
 	dev = __dev_get_by_index(net, tcm->tcm_ifindex);
 	if (!dev)
 		return -ENODEV;
@@ -1515,8 +1532,11 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 			return -ENOENT;
 		}
 		err = qdisc_graft(dev, p, skb, n, clid, NULL, q, extack);
-		if (err != 0)
+		if (err != 0) {
+			if (err == -EAGAIN)
+				goto replay;
 			return err;
+		}
 	} else {
 		qdisc_notify(net, skb, n, clid, NULL, q, NULL);
 	}
@@ -1704,6 +1724,8 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 	if (err) {
 		if (q)
 			qdisc_put(q);
+		if (err == -EAGAIN)
+			goto replay;
 		return err;
 	}
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 37e41f972f69..e14ed47f961c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1046,7 +1046,7 @@ static void qdisc_free_cb(struct rcu_head *head)
 	qdisc_free(q);
 }
 
-static void qdisc_destroy(struct Qdisc *qdisc)
+static void __qdisc_destroy(struct Qdisc *qdisc)
 {
 	const struct Qdisc_ops  *ops = qdisc->ops;
 
@@ -1070,6 +1070,14 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 	call_rcu(&qdisc->rcu, qdisc_free_cb);
 }
 
+void qdisc_destroy(struct Qdisc *qdisc)
+{
+	if (qdisc->flags & TCQ_F_BUILTIN)
+		return;
+
+	__qdisc_destroy(qdisc);
+}
+
 void qdisc_put(struct Qdisc *qdisc)
 {
 	if (!qdisc)
@@ -1079,7 +1087,7 @@ void qdisc_put(struct Qdisc *qdisc)
 	    !refcount_dec_and_test(&qdisc->refcnt))
 		return;
 
-	qdisc_destroy(qdisc);
+	__qdisc_destroy(qdisc);
 }
 EXPORT_SYMBOL(qdisc_put);
 
@@ -1094,7 +1102,7 @@ void qdisc_put_unlocked(struct Qdisc *qdisc)
 	    !refcount_dec_and_rtnl_lock(&qdisc->refcnt))
 		return;
 
-	qdisc_destroy(qdisc);
+	__qdisc_destroy(qdisc);
 	rtnl_unlock();
 }
 EXPORT_SYMBOL(qdisc_put_unlocked);
-- 
2.20.1


