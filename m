Return-Path: <netdev+bounces-10366-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D598772E27C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57D65281222
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F4C2A9D1;
	Tue, 13 Jun 2023 12:07:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535133C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:07:59 +0000 (UTC)
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489E2E56
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:07:49 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-56cfce8862aso35005337b3.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686658068; x=1689250068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B5DH6L3ZSVCkWDFLRo8TBD78b8ulG/zpLVTh/eOrJNc=;
        b=pP4xX5iAVVbW43cBZOvYlEbRc4P9sftbfrN1e0Ahvf3I15RJjpUnempPIy33ghKcv3
         lFGoKyUCUnx2VGAFRILEFjTz9vnqcAaAbiMgoPSTANrXxjMMpmZ3WesmOvRW6sH3c3b2
         shKazcySDtHpPOvNfuQ0zZDFBLke5vtenZN6AYvZ/1Z4+eJgpTHJlUnrjOlDbR22Z2ND
         3jRYiDfdtO00UG+HnOABGK52BtgM+1f9GI8oCSBDTcNpFgoRbKYslJNslFA1UhTGhWH9
         uFIwUggljYWx2T058mgRkPcnRUfoKBFse/gQmyuTWFW/SeuPiOZ+TswbX8twuoNZKQ8U
         k6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686658068; x=1689250068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B5DH6L3ZSVCkWDFLRo8TBD78b8ulG/zpLVTh/eOrJNc=;
        b=KBYVZn/m6hsXzUH4MSpdNBSEbVB+oM6QMOrvV0t0/vpFiVHtk3dYxvifMze8vHW636
         yQnbSJ5qYE3yzphsVNXi+qpnKtSWb+LXDdbwt/gG7wDq6Zy+Y46YiXvn458H/ieNaK1w
         UzRhJoMtY/Wky9VOQnY7Ky9tYhB9oQmzBC70AoPJSxFCh/IXM842cv4Jz1I0+Rf0rFYi
         VwzZBnaiqsYRud+7tAvJMfk4IcUF40M9htetC8QgS3ru6Hzx5M4N0yPM1BlozpNvkIyM
         H+HpWCHZ+4YZh4I152UY2h0cqdnO3GWwWSu+YQk84MgKvLxBj9xfVDjgHb1ihe80gS9n
         HTFg==
X-Gm-Message-State: AC+VfDzlHt1RasIpTpQVfLtT/xinHbwQhP6uCYEzRBXu4ZjC+wrVYj9c
	CaGvoZCYJ0PrloTSZTGI/5ZeAIOGJOBEt6RKKhmeCQ==
X-Google-Smtp-Source: ACHHUZ5X7iJliaEBuEHxTG50+rtQ7Qjdps1dtCQ15OwmqvHtFbXNd3rHfCddeYTHIxL7T02bzMV0NFKwgjQgqCLpLTk=
X-Received: by 2002:a05:6902:1888:b0:bac:26e5:9463 with SMTP id
 cj8-20020a056902188800b00bac26e59463mr1919955ybb.61.1686658068430; Tue, 13
 Jun 2023 05:07:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1686355297.git.peilin.ye@bytedance.com> <c1f67078dc8a3fd7b3c8ed65896c726d1e9b261e.1686355297.git.peilin.ye@bytedance.com>
In-Reply-To: <c1f67078dc8a3fd7b3c8ed65896c726d1e9b261e.1686355297.git.peilin.ye@bytedance.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 13 Jun 2023 08:07:37 -0400
Message-ID: <CAM0EoMkEL+o-u3-NM8fYcZbynzbbSWdMofVLC-56YvxsUOGA-A@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: qdisc_destroy() old ingress and clsact
 Qdiscs before grafting
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Peilin Ye <peilin.ye@bytedance.com>, 
	Vlad Buslov <vladbu@mellanox.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	John Fastabend <john.fastabend@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Hillf Danton <hdanton@sina.com>, Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 10, 2023 at 11:30=E2=80=AFPM Peilin Ye <yepeilin.cs@gmail.com> =
wrote:
>
> From: Peilin Ye <peilin.ye@bytedance.com>
>
> mini_Qdisc_pair::p_miniq is a double pointer to mini_Qdisc, initialized
> in ingress_init() to point to net_device::miniq_ingress.  ingress Qdiscs
> access this per-net_device pointer in mini_qdisc_pair_swap().  Similar
> for clsact Qdiscs and miniq_egress.
>
> Unfortunately, after introducing RTNL-unlocked RTM_{NEW,DEL,GET}TFILTER
> requests (thanks Hillf Danton for the hint), when replacing ingress or
> clsact Qdiscs, for example, the old Qdisc ("@old") could access the same
> miniq_{in,e}gress pointer(s) concurrently with the new Qdisc ("@new"),
> causing race conditions [1] including a use-after-free bug in
> mini_qdisc_pair_swap() reported by syzbot:
>
>  BUG: KASAN: slab-use-after-free in mini_qdisc_pair_swap+0x1c2/0x1f0 net/=
sched/sch_generic.c:1573
>  Write of size 8 at addr ffff888045b31308 by task syz-executor690/14901
> ...
>  Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>   print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:319
>   print_report mm/kasan/report.c:430 [inline]
>   kasan_report+0x11c/0x130 mm/kasan/report.c:536
>   mini_qdisc_pair_swap+0x1c2/0x1f0 net/sched/sch_generic.c:1573
>   tcf_chain_head_change_item net/sched/cls_api.c:495 [inline]
>   tcf_chain0_head_change.isra.0+0xb9/0x120 net/sched/cls_api.c:509
>   tcf_chain_tp_insert net/sched/cls_api.c:1826 [inline]
>   tcf_chain_tp_insert_unique net/sched/cls_api.c:1875 [inline]
>   tc_new_tfilter+0x1de6/0x2290 net/sched/cls_api.c:2266
> ...
>
> @old and @new should not affect each other.  In other words, @old should
> never modify miniq_{in,e}gress after @new, and @new should not update
> @old's RCU state.
>
> Fixing without changing sch_api.c turned out to be difficult (please
> refer to Closes: for discussions).  Instead, make sure @new's first call
> always happen after @old's last call (in {ingress,clsact}_destroy()) has
> finished:
>
> In qdisc_graft(), return -EBUSY if @old has any ongoing filter requests,
> and call qdisc_destroy() for @old before grafting @new.
>
> Introduce qdisc_refcount_dec_if_one() as the counterpart of
> qdisc_refcount_inc_nz() used for filter requests.  Introduce a
> non-static version of qdisc_destroy() that does a TCQ_F_BUILTIN check,
> just like qdisc_put() etc.
>
> Depends on patch "net/sched: Refactor qdisc_graft() for ingress and
> clsact Qdiscs".
>
> [1] To illustrate, the syzkaller reproducer adds ingress Qdiscs under
> TC_H_ROOT (no longer possible after commit c7cfbd115001 ("net/sched:
> sch_ingress: Only create under TC_H_INGRESS")) on eth0 that has 8
> transmission queues:
>
>   Thread 1 creates ingress Qdisc A (containing mini Qdisc a1 and a2),
>   then adds a flower filter X to A.
>
>   Thread 2 creates another ingress Qdisc B (containing mini Qdisc b1 and
>   b2) to replace A, then adds a flower filter Y to B.
>
>  Thread 1               A's refcnt   Thread 2
>   RTM_NEWQDISC (A, RTNL-locked)
>    qdisc_create(A)               1
>    qdisc_graft(A)                9
>
>   RTM_NEWTFILTER (X, RTNL-unlocked)
>    __tcf_qdisc_find(A)          10
>    tcf_chain0_head_change(A)
>    mini_qdisc_pair_swap(A) (1st)
>             |
>             |                         RTM_NEWQDISC (B, RTNL-locked)
>          RCU sync                2     qdisc_graft(B)
>             |                    1     notify_and_destroy(A)
>             |
>    tcf_block_release(A)          0    RTM_NEWTFILTER (Y, RTNL-unlocked)
>    qdisc_destroy(A)                    tcf_chain0_head_change(B)
>    tcf_chain0_head_change_cb_del(A)    mini_qdisc_pair_swap(B) (2nd)
>    mini_qdisc_pair_swap(A) (3rd)                |
>            ...                                 ...
>
> Here, B calls mini_qdisc_pair_swap(), pointing eth0->miniq_ingress to
> its mini Qdisc, b1.  Then, A calls mini_qdisc_pair_swap() again during
> ingress_destroy(), setting eth0->miniq_ingress to NULL, so ingress
> packets on eth0 will not find filter Y in sch_handle_ingress().
>
> This is just one of the possible consequences of concurrently accessing
> miniq_{in,e}gress pointers.
>
> Fixes: 7a096d579e8e ("net: sched: ingress: set 'unlocked' flag for Qdisc =
ops")
> Fixes: 87f373921c4e ("net: sched: ingress: set 'unlocked' flag for clsact=
 Qdisc ops")
> Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/0000000000006cf87705f79acf1a@google.com=
/
> Cc: Hillf Danton <hdanton@sina.com>
> Cc: Vlad Buslov <vladbu@mellanox.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  include/net/sch_generic.h |  8 ++++++++
>  net/sched/sch_api.c       | 28 +++++++++++++++++++++++-----
>  net/sched/sch_generic.c   | 14 +++++++++++---
>  3 files changed, 42 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index 27271f2b37cb..12eadecf8cd0 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -137,6 +137,13 @@ static inline void qdisc_refcount_inc(struct Qdisc *=
qdisc)
>         refcount_inc(&qdisc->refcnt);
>  }
>
> +static inline bool qdisc_refcount_dec_if_one(struct Qdisc *qdisc)
> +{
> +       if (qdisc->flags & TCQ_F_BUILTIN)
> +               return true;
> +       return refcount_dec_if_one(&qdisc->refcnt);
> +}
> +
>  /* Intended to be used by unlocked users, when concurrent qdisc release =
is
>   * possible.
>   */
> @@ -652,6 +659,7 @@ void dev_deactivate_many(struct list_head *head);
>  struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
>                               struct Qdisc *qdisc);
>  void qdisc_reset(struct Qdisc *qdisc);
> +void qdisc_destroy(struct Qdisc *qdisc);
>  void qdisc_put(struct Qdisc *qdisc);
>  void qdisc_put_unlocked(struct Qdisc *qdisc);
>  void qdisc_tree_reduce_backlog(struct Qdisc *qdisc, int n, int len);
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 094ca3a5b633..aa6b1fe65151 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1086,10 +1086,22 @@ static int qdisc_graft(struct net_device *dev, st=
ruct Qdisc *parent,
>                 if ((q && q->flags & TCQ_F_INGRESS) ||
>                     (new && new->flags & TCQ_F_INGRESS)) {
>                         ingress =3D 1;
> -                       if (!dev_ingress_queue(dev)) {
> +                       dev_queue =3D dev_ingress_queue(dev);
> +                       if (!dev_queue) {
>                                 NL_SET_ERR_MSG(extack, "Device does not h=
ave an ingress queue");
>                                 return -ENOENT;
>                         }
> +
> +                       q =3D rtnl_dereference(dev_queue->qdisc_sleeping)=
;
> +
> +                       /* This is the counterpart of that qdisc_refcount=
_inc_nz() call in
> +                        * __tcf_qdisc_find() for filter requests.
> +                        */
> +                       if (!qdisc_refcount_dec_if_one(q)) {
> +                               NL_SET_ERR_MSG(extack,
> +                                              "Current ingress or clsact=
 Qdisc has ongoing filter requests");
> +                               return -EBUSY;
> +                       }
>                 }
>
>                 if (dev->flags & IFF_UP)
> @@ -1110,8 +1122,16 @@ static int qdisc_graft(struct net_device *dev, str=
uct Qdisc *parent,
>                                 qdisc_put(old);
>                         }
>                 } else {
> -                       dev_queue =3D dev_ingress_queue(dev);
> -                       old =3D dev_graft_qdisc(dev_queue, new);
> +                       old =3D dev_graft_qdisc(dev_queue, NULL);
> +
> +                       /* {ingress,clsact}_destroy() @old before graftin=
g @new to avoid
> +                        * unprotected concurrent accesses to net_device:=
:miniq_{in,e}gress
> +                        * pointer(s) in mini_qdisc_pair_swap().
> +                        */
> +                       qdisc_notify(net, skb, n, classid, old, new, exta=
ck);
> +                       qdisc_destroy(old);
> +
> +                       dev_graft_qdisc(dev_queue, new);
>                 }
>
>  skip:
> @@ -1125,8 +1145,6 @@ static int qdisc_graft(struct net_device *dev, stru=
ct Qdisc *parent,
>
>                         if (new && new->ops->attach)
>                                 new->ops->attach(new);
> -               } else {
> -                       notify_and_destroy(net, skb, n, classid, old, new=
, extack);
>                 }
>
>                 if (dev->flags & IFF_UP)
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 3248259eba32..5d7e23f4cc0e 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1046,7 +1046,7 @@ static void qdisc_free_cb(struct rcu_head *head)
>         qdisc_free(q);
>  }
>
> -static void qdisc_destroy(struct Qdisc *qdisc)
> +static void __qdisc_destroy(struct Qdisc *qdisc)
>  {
>         const struct Qdisc_ops  *ops =3D qdisc->ops;
>
> @@ -1070,6 +1070,14 @@ static void qdisc_destroy(struct Qdisc *qdisc)
>         call_rcu(&qdisc->rcu, qdisc_free_cb);
>  }
>
> +void qdisc_destroy(struct Qdisc *qdisc)
> +{
> +       if (qdisc->flags & TCQ_F_BUILTIN)
> +               return;
> +
> +       __qdisc_destroy(qdisc);
> +}
> +
>  void qdisc_put(struct Qdisc *qdisc)
>  {
>         if (!qdisc)
> @@ -1079,7 +1087,7 @@ void qdisc_put(struct Qdisc *qdisc)
>             !refcount_dec_and_test(&qdisc->refcnt))
>                 return;
>
> -       qdisc_destroy(qdisc);
> +       __qdisc_destroy(qdisc);
>  }
>  EXPORT_SYMBOL(qdisc_put);
>
> @@ -1094,7 +1102,7 @@ void qdisc_put_unlocked(struct Qdisc *qdisc)
>             !refcount_dec_and_rtnl_lock(&qdisc->refcnt))
>                 return;
>
> -       qdisc_destroy(qdisc);
> +       __qdisc_destroy(qdisc);
>         rtnl_unlock();
>  }
>  EXPORT_SYMBOL(qdisc_put_unlocked);
> --
> 2.20.1
>

