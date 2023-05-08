Return-Path: <netdev+bounces-843-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E8A66FAD41
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:32:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51C8F1C20982
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 11:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17757171A2;
	Mon,  8 May 2023 11:32:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072B1171A1
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 11:32:55 +0000 (UTC)
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690243D22C
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 04:32:33 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-b9a6f17f2b6so24354396276.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 04:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683545532; x=1686137532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NUh/Y9OGY0YLjkoqSiVGuy+rTBtcb3eGpspaf7JIQe0=;
        b=q33cT/4W4dXAtIgG6H9w+1q/RiTC6YJhggFOo3EbnQKv1B8FyitEKNbE+0cu/jghEg
         d4R/99gmReGdFNnzFV4IOca5r5BAsbaBmK7G71qgqlg3fntlyb22AUlEb2Geyfuqq8jh
         O8qGJOdx/Aig06a4kaBJswy+DMYFVIOqlYnIzo9DmU9MXTT11FpCdp7t/xYOaykXQKdC
         t5OPyi3iu9l2t+ztcwsfP5QJpEslKhRbb2Gxk8vaJ+/h6g6z/PBtcREP5NIpIyS0yD/S
         m62F/kbwzSG2DIuVC1KMMDqPw9co0RWjn4/ljJhW/c0CriI+Rm2hGM7h0c+h8qDk0Eyu
         O1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683545532; x=1686137532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NUh/Y9OGY0YLjkoqSiVGuy+rTBtcb3eGpspaf7JIQe0=;
        b=gT5Aag4SD2TwExwgv2IHmRkyav1jNUBNfigis3amoUkLcw2G2hNkBKARBMhbn7OMeN
         X8rFpTUbMhzfElFzi6m6GS4gcQZKgqrxqsvcOKbUqnnbgeDYxAE8v8VYTFhmXkStnxjc
         BaorESpg1ko8Mx6nSdRXW9kh6v2hTgRDV9cmzWhTG9G9V5ZTK6s5Q4qBFJrSvmkVwXN2
         CN24WWAp7taT3TPBnWNyxjHsmhL+xkVkw2HYAbi9l983sgVI/F2EvhgHOEcYwiZmOdb7
         ZNDz53EvO8udCdtiyHJKHPXrffmXjBHs7nijnWFnRwQvueI3iaskNQQoLI68mebPFjpU
         RKTg==
X-Gm-Message-State: AC+VfDxN4CdaQ367EqTSuoBB18SrmnwC208YzDLPrQZsJqsX46ZGYUjX
	yaYVjJ+EloQS/FngKPyuoJW2NntLAcW5Nu2S497zEg==
X-Google-Smtp-Source: ACHHUZ4rRcmAJznSLrjwrjInUwXFiqt3BJ1qAoOZzc4mBq9Vm7lwtHyP+WV876fmH+ywi+/ClxVBtypvYSAGYEeZi2c=
X-Received: by 2002:a25:4d0a:0:b0:b8b:eabb:ae86 with SMTP id
 a10-20020a254d0a000000b00b8beabbae86mr11978891ybb.8.1683545532104; Mon, 08
 May 2023 04:32:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1683326865.git.peilin.ye@bytedance.com> <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
In-Reply-To: <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 8 May 2023 07:32:01 -0400
Message-ID: <CAM0EoMmFwgmip7pYSLavfXzduWCwS4AyuAON9oXKYAn5G2Yiog@mail.gmail.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and clsact
 Qdiscs before grafting
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, 
	Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Vlad Buslov <vladbu@mellanox.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Cong Wang <cong.wang@bytedance.com>, John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 5, 2023 at 8:16=E2=80=AFPM Peilin Ye <yepeilin.cs@gmail.com> wr=
ote:
>
> mini_Qdisc_pair::p_miniq is a double pointer to mini_Qdisc, initialized i=
n
> ingress_init() to point to net_device::miniq_ingress.  ingress Qdiscs
> access this per-net_device pointer in mini_qdisc_pair_swap().  Similar fo=
r
> clsact Qdiscs and miniq_egress.
>
> Unfortunately, after introducing RTNL-lockless RTM_{NEW,DEL,GET}TFILTER
> requests, when e.g. replacing ingress (clsact) Qdiscs, the old Qdisc coul=
d
> access the same miniq_{in,e}gress pointer(s) concurrently with the new
> Qdisc, causing race conditions [1] including a use-after-free in
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
> The new (ingress or clsact) Qdisc should only call mini_qdisc_pair_swap()
> after the old Qdisc's last call (in {ingress,clsact}_destroy()) has
> finished.
>
> To achieve this, in qdisc_graft(), return -EBUSY if the old (ingress or
> clsact) Qdisc has ongoing RTNL-lockless filter requests, and call
> qdisc_destroy() for "old" before grafting "new".
>
> Introduce qdisc_refcount_dec_if_one() as the counterpart of
> qdisc_refcount_inc_nz() used for RTNL-lockless filter requests.  Introduc=
e
> a non-static version of qdisc_destroy() that does a TCQ_F_BUILTIN check,
> just like qdisc_put() etc.
>
> [1] To illustrate, the syzkaller reproducer adds ingress Qdiscs under
> TC_H_ROOT (no longer possible after patch "net/sched: sch_ingress: Only
> create under TC_H_INGRESS") on eth0 that has 8 transmission queues:
>
>   Thread 1 creates ingress Qdisc A (containing mini Qdisc a1 and a2), the=
n
>   adds a flower filter X to A.
>
>   Thread 2 creates another ingress Qdisc B (containing mini Qdisc b1 and
>   b2) to replace A, then adds a flower filter Y to B.
>
>  Thread 1               A's refcnt   Thread 2
>   RTM_NEWQDISC (A, RTNL-locked)
>    qdisc_create(A)               1
>    qdisc_graft(A)                9
>
>   RTM_NEWTFILTER (X, RTNL-lockless)
>    __tcf_qdisc_find(A)          10
>    tcf_chain0_head_change(A)
>    mini_qdisc_pair_swap(A) (1st)
>             |
>             |                         RTM_NEWQDISC (B, RTNL-locked)
>            RCU                   2     qdisc_graft(B)
>             |                    1     notify_and_destroy(A)
>             |
>    tcf_block_release(A)          0    RTM_NEWTFILTER (Y, RTNL-lockless)
>    qdisc_destroy(A)                    tcf_chain0_head_change(B)
>    tcf_chain0_head_change_cb_del(A)    mini_qdisc_pair_swap(B) (2nd)
>    mini_qdisc_pair_swap(A) (3rd)                |
>            ...                                 ...
>
> Here, B calls mini_qdisc_pair_swap(), pointing eth0->miniq_ingress to its
> mini Qdisc, b1.  Then, A calls mini_qdisc_pair_swap() again during
> ingress_destroy(), setting eth0->miniq_ingress to NULL, so ingress packet=
s
> on eth0 will not find filter Y in sch_handle_ingress().
>
> This is just one of the possible consequences of concurrently accessing
> net_device::miniq_{in,e}gress pointers.  The point is clear, however:
> B's first call to mini_qdisc_pair_swap() should take place after A's
> last call, in qdisc_destroy().
>
> Fixes: 7a096d579e8e ("net: sched: ingress: set 'unlocked' flag for Qdisc =
ops")
> Fixes: 87f373921c4e ("net: sched: ingress: set 'unlocked' flag for clsact=
 Qdisc ops")
> Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/netdev/0000000000006cf87705f79acf1a@google.=
com
> Cc: Hillf Danton <hdanton@sina.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>



Thanks for the excellent analysis Peilin and for chasing this to the
end. I have no doubt it was a lot of fun! ;->

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  include/net/sch_generic.h |  8 ++++++++
>  net/sched/sch_api.c       | 26 +++++++++++++++++++++-----
>  net/sched/sch_generic.c   | 14 +++++++++++---
>  3 files changed, 40 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index fab5ba3e61b7..3e9cc43cbc90 100644
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
> index f72a581666a2..a2d07bc8ded6 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1080,10 +1080,20 @@ static int qdisc_graft(struct net_device *dev, st=
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
> +                       /* This is the counterpart of that qdisc_refcount=
_inc_nz() call in
> +                        * __tcf_qdisc_find() for RTNL-lockless filter re=
quests.
> +                        */
> +                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_s=
leeping)) {
> +                               NL_SET_ERR_MSG(extack,
> +                                              "Current ingress or clsact=
 Qdisc has ongoing filter request(s)");
> +                               return -EBUSY;
> +                       }
>                 }
>
>                 if (dev->flags & IFF_UP)
> @@ -1104,8 +1114,16 @@ static int qdisc_graft(struct net_device *dev, str=
uct Qdisc *parent,
>                                 qdisc_put(old);
>                         }
>                 } else {
> -                       dev_queue =3D dev_ingress_queue(dev);
> -                       old =3D dev_graft_qdisc(dev_queue, new);
> +                       old =3D dev_graft_qdisc(dev_queue, NULL);
> +
> +                       /* {ingress,clsact}_destroy() "old" before grafti=
ng "new" to avoid
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
> @@ -1119,8 +1137,6 @@ static int qdisc_graft(struct net_device *dev, stru=
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
> index 37e41f972f69..e14ed47f961c 100644
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

