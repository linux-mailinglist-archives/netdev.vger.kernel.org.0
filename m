Return-Path: <netdev+bounces-9871-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BCEF72B022
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 05:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 648EB1C20A96
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 03:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B9A15C3;
	Sun, 11 Jun 2023 03:30:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C09C139B
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 03:30:56 +0000 (UTC)
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E843588;
	Sat, 10 Jun 2023 20:30:54 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-75d4094f9baso263739085a.1;
        Sat, 10 Jun 2023 20:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686454254; x=1689046254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Gvgwzd7tw+mBChsU33LB72GZ1JQ1gSbDmkcwIwsTOA=;
        b=kipQQjSRHltP4/NNGxSuK3iPRyUboNWdWdGIoFBUahSFfL0M+UTUb9ZLZ0yJ6MuOR6
         QfFHTpMO8NAXTx7913SW1wg2QZY7DLDrIwNEUfLrZF/tCG4pvAWHGx88/M0cKF0kOg3h
         +LeR3YsAsVNTQNrCKk8pyIleBuK/78/tMCnzCSj6Z4s9MxBecXsiHSGK39UEVUXURz5N
         uoQq1AxD8fpHaVjVKouqgOW/OvpOEf05pL1SzbtUsOa1uCX8M0ZorXoLULb2n1j9hcQ6
         XSE8Fc4mBrKEipUO3Xqe0cyEEY0dEatdFiDn/XNj6grOabA22RxV7rbzG3uuo0pYubqB
         sSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686454254; x=1689046254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Gvgwzd7tw+mBChsU33LB72GZ1JQ1gSbDmkcwIwsTOA=;
        b=D9uENH4puDx+yIkQEtJQdBZ5NGmd0vx3U2JaPl7FADHmrY4k0YEn4inZL+MdvPYC+R
         5QJ+RMJXUrFh1stTIYSvnOZDz9zVwleQcvWEi2jecSoHipGiLFRGdGkQO9BKHNVumLEC
         QIWcESe+6U9xgZ0QjwfBzqWWIciaxA5jSj0QxQ5iAbZJHDhgCWEE4vhBsBy37qkyO2b8
         Hqw7IzV/tYtLxnMQM3Hici56c2J+glY1e0SPm1IbYAZl6D6+7AsoLN+Vtzgd9ZKVcgN1
         M+bRuogOr8tan3WeCwR4TMg9IDUY9E2EKJHU0Bj2HRpBc/KNYG2hCdQS9UjpNfrQYVyd
         g4Xw==
X-Gm-Message-State: AC+VfDw+NfEfvw9kP2ZWQOUpcL2yTCBFtVyfd/1usdoriqejTCePXrwl
	OAMUM1PkSnKfHGzgkPn4NkDEXHAsdg==
X-Google-Smtp-Source: ACHHUZ6g6jWYHfklfyM0SFxycFH8okP863KtZDQK8+6aixaw+7Mfl7XdqLgWGrDPsWoopDZzlGCVFw==
X-Received: by 2002:a05:620a:440b:b0:75d:5837:fbff with SMTP id v11-20020a05620a440b00b0075d5837fbffmr7821582qkp.63.1686454253576;
        Sat, 10 Jun 2023 20:30:53 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:65a5:6400:a53e:60df:7509:de6])
        by smtp.gmail.com with ESMTPSA id e17-20020a05620a12d100b0075cc95eb30asm2029687qkl.8.2023.06.10.20.30.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Jun 2023 20:30:53 -0700 (PDT)
From: Peilin Ye <yepeilin.cs@gmail.com>
X-Google-Original-From: Peilin Ye <peilin.ye@bytedance.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hillf Danton <hdanton@sina.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 2/2] net/sched: qdisc_destroy() old ingress and clsact Qdiscs before grafting
Date: Sat, 10 Jun 2023 20:30:25 -0700
Message-Id: <c1f67078dc8a3fd7b3c8ed65896c726d1e9b261e.1686355297.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1686355297.git.peilin.ye@bytedance.com>
References: <cover.1686355297.git.peilin.ye@bytedance.com>
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

mini_Qdisc_pair::p_miniq is a double pointer to mini_Qdisc, initialized
in ingress_init() to point to net_device::miniq_ingress.  ingress Qdiscs
access this per-net_device pointer in mini_qdisc_pair_swap().  Similar
for clsact Qdiscs and miniq_egress.

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
@old's RCU state.

Fixing without changing sch_api.c turned out to be difficult (please
refer to Closes: for discussions).  Instead, make sure @new's first call
always happen after @old's last call (in {ingress,clsact}_destroy()) has
finished:

In qdisc_graft(), return -EBUSY if @old has any ongoing filter requests,
and call qdisc_destroy() for @old before grafting @new.

Introduce qdisc_refcount_dec_if_one() as the counterpart of
qdisc_refcount_inc_nz() used for filter requests.  Introduce a
non-static version of qdisc_destroy() that does a TCQ_F_BUILTIN check,
just like qdisc_put() etc.

Depends on patch "net/sched: Refactor qdisc_graft() for ingress and
clsact Qdiscs".

[1] To illustrate, the syzkaller reproducer adds ingress Qdiscs under
TC_H_ROOT (no longer possible after commit c7cfbd115001 ("net/sched:
sch_ingress: Only create under TC_H_INGRESS")) on eth0 that has 8
transmission queues:

  Thread 1 creates ingress Qdisc A (containing mini Qdisc a1 and a2),
  then adds a flower filter X to A.

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

Here, B calls mini_qdisc_pair_swap(), pointing eth0->miniq_ingress to
its mini Qdisc, b1.  Then, A calls mini_qdisc_pair_swap() again during
ingress_destroy(), setting eth0->miniq_ingress to NULL, so ingress
packets on eth0 will not find filter Y in sch_handle_ingress().

This is just one of the possible consequences of concurrently accessing
miniq_{in,e}gress pointers.

Fixes: 7a096d579e8e ("net: sched: ingress: set 'unlocked' flag for Qdisc ops")
Fixes: 87f373921c4e ("net: sched: ingress: set 'unlocked' flag for clsact Qdisc ops")
Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/0000000000006cf87705f79acf1a@google.com/
Cc: Hillf Danton <hdanton@sina.com>
Cc: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 include/net/sch_generic.h |  8 ++++++++
 net/sched/sch_api.c       | 28 +++++++++++++++++++++++-----
 net/sched/sch_generic.c   | 14 +++++++++++---
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 27271f2b37cb..12eadecf8cd0 100644
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
index 094ca3a5b633..aa6b1fe65151 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1086,10 +1086,22 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
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
+			q = rtnl_dereference(dev_queue->qdisc_sleeping);
+
+			/* This is the counterpart of that qdisc_refcount_inc_nz() call in
+			 * __tcf_qdisc_find() for filter requests.
+			 */
+			if (!qdisc_refcount_dec_if_one(q)) {
+				NL_SET_ERR_MSG(extack,
+					       "Current ingress or clsact Qdisc has ongoing filter requests");
+				return -EBUSY;
+			}
 		}
 
 		if (dev->flags & IFF_UP)
@@ -1110,8 +1122,16 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
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
@@ -1125,8 +1145,6 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 			if (new && new->ops->attach)
 				new->ops->attach(new);
-		} else {
-			notify_and_destroy(net, skb, n, classid, old, new, extack);
 		}
 
 		if (dev->flags & IFF_UP)
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 3248259eba32..5d7e23f4cc0e 100644
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


