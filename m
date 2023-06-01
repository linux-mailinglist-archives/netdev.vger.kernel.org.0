Return-Path: <netdev+bounces-6981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9FE719183
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42151281689
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC5A5C89;
	Thu,  1 Jun 2023 03:57:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABD146BF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:57:47 +0000 (UTC)
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0894E7
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:57:43 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3f83971680eso9691291cf.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685591863; x=1688183863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uEkdXBgS449KNBss036eO5NEyAZJqh9G3Wj6Prtj4PU=;
        b=S2L9ZiM1uI7q2elIKa2yEeByCGyPNZeXE70G63UxuT2sMlbq5hgiFed06Otkd4cddJ
         gy9i8YSlX0Pq6w950mDvm/VD5HGMI1FFKAJkTMFy4Hn4iE45b4MzOZaNiIVgYoBFsoPM
         21kSncV5Mr4EhLhE7Pg75smBf1gcnzpROKDI82w23UAOjeQUsxbEyO2nFOOFO7F11a13
         vZTuVXd/G6MP2QoWvFkdr/7lasVON1kMu4Tuf81Y58fcfw5I5cs5ybrT/MK8wTZKnqxb
         4DaRO3iMEI4T6dT1t7ReIOf6EP23yycRbgb4Bey9BR94CVllo1UJtUsZxBCWWUv68rkX
         bVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685591863; x=1688183863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uEkdXBgS449KNBss036eO5NEyAZJqh9G3Wj6Prtj4PU=;
        b=jsBJSP3N6S0Fx7ASNO8Bv5EavOc1VJO3j2u5c+upUqfrMr1613672Ex811YHBlH0My
         RgUrrJQS3TTRz9QKIN5hrTcUSfG3L71wMLgUGZS6gm1ezZs3QfJRYzlwUfVA/7HkAMzV
         Z2mU3Bxg/FFuOQSItboOGHfXeG243T5D73n7KAGUotm6Q5PZZgEPnqHm8a224adCEreo
         OGx/AY/8EPaiaB7SZksrYXcvZiakg5sg+odfgP2/J2xctivOU1pHJGfTNv1kNTnl4Lgb
         ThOxqr8Kcw2/A5Atf77AcujHAbl+2zTJ/g03gbSaafjdIVCpGaNreynh6+pVeDdM7zLU
         Jf0Q==
X-Gm-Message-State: AC+VfDwwcHU4eMq0PJNndDcgU08NthV6dSVFXAIbizOEVBbYhyU80Rhf
	w2/0jmw0bX1sh96bYAL8ag==
X-Google-Smtp-Source: ACHHUZ792XMzoWpursJRQ3qZjf87UD5w493xR8NpnZwg/txS6ZOWuMj4zATcMasAGrn32XIpiQlh8Q==
X-Received: by 2002:a05:622a:1104:b0:3f6:aaad:2b60 with SMTP id e4-20020a05622a110400b003f6aaad2b60mr748076qty.7.1685591862880;
        Wed, 31 May 2023 20:57:42 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:d1fd:3da6:fcf2:e941])
        by smtp.gmail.com with ESMTPSA id fc22-20020a05622a489600b003e0945575dasm7048381qtb.1.2023.05.31.20.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 20:57:42 -0700 (PDT)
Date: Wed, 31 May 2023 20:57:35 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Jakub Kicinski <kuba@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
References: <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
 <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com>
 <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
 <87bki2xb3d.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bki2xb3d.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Vlad and all,

On Tue, May 30, 2023 at 03:18:19PM +0300, Vlad Buslov wrote:
> >> If livelock with concurrent filters insertion is an issue, then it can
> >> be remedied by setting a new Qdisc->flags bit
> >> "DELETED-REJECT-NEW-FILTERS" and checking for it together with
> >> QDISC_CLASS_OPS_DOIT_UNLOCKED in order to force any concurrent filter
> >> insertion coming after the flag is set to synchronize on rtnl lock.
> >
> > Thanks for the suggestion!  I'll try this approach.
> >
> > Currently QDISC_CLASS_OPS_DOIT_UNLOCKED is checked after taking a refcnt of
> > the "being-deleted" Qdisc.  I'll try forcing "late" requests (that arrive
> > later than Qdisc is flagged as being-deleted) sync on RTNL lock without
> > (before) taking the Qdisc refcnt (otherwise I think Task 1 will replay for
> > even longer?).
> 
> Yeah, I see what you mean. Looking at the code __tcf_qdisc_find()
> already returns -EINVAL when q->refcnt is zero, so maybe returning
> -EINVAL from that function when "DELETED-REJECT-NEW-FILTERS" flags is
> set is also fine? Would be much easier to implement as opposed to moving
> rtnl_lock there.

I implemented [1] this suggestion and tested the livelock issue in QEMU (-m
16G, CONFIG_NR_CPUS=8).  I tried deleting the ingress Qdisc (let's call it
"request A") while it has a lot of ongoing filter requests, and here's the
result:

                        #1         #2         #3         #4
  ----------------------------------------------------------
   a. refcnt            89         93        230        571
   b. replayed     167,568    196,450    336,291    878,027
   c. time real   0m2.478s   0m2.746s   0m3.693s   0m9.461s
           user   0m0.000s   0m0.000s   0m0.000s   0m0.000s
            sys   0m0.623s   0m0.681s   0m1.119s   0m2.770s

   a. is the Qdisc refcnt when A calls qdisc_graft() for the first time;
   b. is the number of times A has been replayed;
   c. is the time(1) output for A.

a. and b. are collected from printk() output.  This is better than before,
but A could still be replayed for hundreds of thousands of times and hang
for a few seconds.

Is this okay?  If not, is it possible (or should we) to make A really
_wait_ on Qdisc refcnt, instead of "busy-replaying"?

Thanks,
Peilin Ye

[1] Diff against v5 patch 6 (printk() calls not included):

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 3e9cc43cbc90..de7b0538b309 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -94,6 +94,7 @@ struct Qdisc {
 #define TCQ_F_INVISIBLE                0x80 /* invisible by default in dump */
 #define TCQ_F_NOLOCK           0x100 /* qdisc does not require locking */
 #define TCQ_F_OFFLOADED                0x200 /* qdisc is offloaded to HW */
+#define TCQ_F_DESTROYING       0x400 /* destroying, reject filter requests */
        u32                     limit;
        const struct Qdisc_ops  *ops;
        struct qdisc_size_table __rcu *stab;
@@ -185,6 +186,11 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
        return !READ_ONCE(qdisc->q.qlen);
 }

+static inline bool qdisc_is_destroying(const struct Qdisc *qdisc)
+{
+       return qdisc->flags & TCQ_F_DESTROYING;
+}
+
 /* For !TCQ_F_NOLOCK qdisc, qdisc_run_begin/end() must be invoked with
  * the qdisc root lock acquired.
  */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2621550bfddc..3e7f6f286ac0 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1172,7 +1172,7 @@ static int __tcf_qdisc_find(struct net *net, struct Qdisc **q,
                *parent = (*q)->handle;
        } else {
                *q = qdisc_lookup_rcu(dev, TC_H_MAJ(*parent));
-               if (!*q) {
+               if (!*q || qdisc_is_destroying(*q)) {
                        NL_SET_ERR_MSG(extack, "Parent Qdisc doesn't exists");
                        err = -EINVAL;
                        goto errout_rcu;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 286b7c58f5b9..d6e47546c7fe 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1086,12 +1086,18 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
                                return -ENOENT;
                        }

-                       /* Replay if the current ingress (or clsact) Qdisc has ongoing
-                        * RTNL-unlocked filter request(s).  This is the counterpart of that
-                        * qdisc_refcount_inc_nz() call in __tcf_qdisc_find().
+                       /* If current ingress (clsact) Qdisc has ongoing filter requests, stop
+                        * accepting any more by marking it as "being destroyed", then tell the
+                        * caller to replay by returning -EAGAIN.
                         */
-                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_sleeping))
+                       q = dev_queue->qdisc_sleeping;
+                       if (!qdisc_refcount_dec_if_one(q)) {
+                               q->flags |= TCQ_F_DESTROYING;
+                               rtnl_unlock();
+                               schedule();
+                               rtnl_lock();
                                return -EAGAIN;
+                       }
                }

                if (dev->flags & IFF_UP)


