Return-Path: <netdev+bounces-4586-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A3D70D4C1
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79A462812EF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A511D2CE;
	Tue, 23 May 2023 07:18:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A471D2B1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:18:33 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26857E46;
	Tue, 23 May 2023 00:18:14 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-75b00e5f8e4so135240385a.0;
        Tue, 23 May 2023 00:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684826293; x=1687418293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d5nW0xJEneX9uqqXTzwuOB5+i2JqjWWSWS/a304uD8A=;
        b=XnS6CNDO/NF7L0a3t0H2omDiPixn5SgTHVwuRmvhCYHjopQ7A45wN4Acz9lvKvE+Z1
         GB7XqC9u2cXi1YjGM29IuCDJaKncNQWsaHOENuQrUh+GKzA5QaevVzZaWaBZClqUPRtT
         P3nbrW+oE0EUn7QRKHfzSyAY41Pckso+NgvsB/j8+5W1WBPbFWNfxiGLWewj8mRWx2dT
         YeKaFzNTcXvTvQ8KxkHwpuU7LaeIo+n0mUrpMWyaevrLximEpCoC3hYojtgECWsg39yo
         ppwj4jO1S2LHbgSJVeByqvGFuUdjzeKIaTaaQo2NhZCl6xHxp6wx4kA8v8HIn2WEPmHs
         WEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684826293; x=1687418293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d5nW0xJEneX9uqqXTzwuOB5+i2JqjWWSWS/a304uD8A=;
        b=kE2Fje1dnbSNvywrkhql0AMzBeZMomJVdpsfZYst7CQx52LwDNP6FZB62Y07127OW6
         sYf/8GFRH8lzFFtWrJnLJb0fdwH5OVMtE3js47HGpPny8ZKJw5mKRuK9c0RsBgE2fufM
         umeo9L3RhBFAT9FaplAj9/AN/2YUFqBq9syIiV+B9xX7of21KCO5ETbB1SaBpxCoAB8X
         jCBRrO+jE25iJshHLCKXlsWUSjbwGl9zicFVkyJ2XErkLiDBeewp7HBD3T6ocy9COgye
         Hu/+Lh0Rivk216a14chsqZvyN37OL79NS3ovEL2NjyZAaQ+/DmAfwFf1CKp9Jmjw8Smf
         yDGg==
X-Gm-Message-State: AC+VfDwN5C1biDy3mJXLbVDLmDkU8e6jFAoxiTd+5v9Jvt7vRbCBKoV8
	I63D3UPxHmksMVD32QigHg==
X-Google-Smtp-Source: ACHHUZ7z0GsGiIRZ8nSNpEt3q01wHJJWYFgQvvynlqmxa+6stIZbFOOpfsjiC9/Scu80Li1Y+N1MPg==
X-Received: by 2002:a37:658b:0:b0:75b:23a0:d9c2 with SMTP id z133-20020a37658b000000b0075b23a0d9c2mr3109101qkb.24.1684826293182;
        Tue, 23 May 2023 00:18:13 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:18c1:dc19:5e29:e9a0])
        by smtp.gmail.com with ESMTPSA id o2-20020a05620a110200b0074adc37ec46sm2301807qkk.84.2023.05.23.00.18.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 00:18:12 -0700 (PDT)
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
Subject: [PATCH v4 net 6/6] net/sched: qdisc_destroy() old ingress and clsact Qdiscs before grafting
Date: Tue, 23 May 2023 00:18:02 -0700
Message-Id: <fdd1db101056ef39b5407314a2c5506f6cafc4e6.1684825171.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1684825171.git.peilin.ye@bytedance.com>
References: <cover.1684825171.git.peilin.ye@bytedance.com>
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
change since v2:
  - add in-body From: tag

changes in v2:
  - replay the request if the current Qdisc has any ongoing RTNL-unlocked
    filter requests (Vlad)
  - minor changes in code comments and commit log

 include/net/sch_generic.h |  8 ++++++++
 net/sched/sch_api.c       | 32 ++++++++++++++++++++++++++------
 net/sched/sch_generic.c   | 14 +++++++++++---
 3 files changed, 45 insertions(+), 9 deletions(-)

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
index f72a581666a2..b3bafa6c1b44 100644
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
@@ -1458,6 +1472,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 	struct Qdisc *p = NULL;
 	int err;
 
+replay:
 	err = nlmsg_parse_deprecated(n, sizeof(*tcm), tca, TCA_MAX,
 				     rtm_tca_policy, extack);
 	if (err < 0)
@@ -1515,8 +1530,11 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
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
@@ -1704,6 +1722,8 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
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


