Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEED3C41F5
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhGLDhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbhGLDhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:37:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA56C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:34:44 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d9-20020a17090ae289b0290172f971883bso11344317pjz.1
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yyP/maQwxXT8Ltx2k6ZQ9I0pl6K2MppXwz13RerjOB8=;
        b=tIqw35n5bi64uOKYa4YfynA9jlHN0VCo3wIDMS+CpMoMnQLsCJPZjpMBziSvUn5Ic7
         AcAuce39bU5qgxF4LQBNbuiUdy155aO2Wt+hi2aypHIXuV9X95ysITtp2Tjep1NGrN4s
         RXVHAFwWvqs8ZecHh7nhjFugt/fxr+n0XuNAb6xWNsVxHqUddTS1G4PDIJ4Jiy/l2Dz2
         Ma+17vqfwLFfaMSohcV9SyvzCXB9qwIv0akCXCpMoWcloYZsdNOKkmYsDdY1V5BQZoe+
         Rx3nZ2dcaeZBAD/hocnmUzvhb/tdQtjH9Plqk8s+RWEnYVy2TQ8kS5bbz7WouwiIYP89
         SQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yyP/maQwxXT8Ltx2k6ZQ9I0pl6K2MppXwz13RerjOB8=;
        b=ZfSazoejZSC4+smYn+oacJCRP0b+qO2kjwYBAn2cSN44/Fow9JFrNHWo40BnaJOHU5
         LUtph1u84RTYDUpd7+GdRkEtYjx2g0l60b1SE3C3D7V0/Yo8S/MBJ1MpM3EYPUpDdSES
         xdXF/Xsez/GNErsTcDr809K4q6ia12dCV6ZG7b/aSRrw3rvhUGzcvAyCPwiNeUVP5MxT
         QWv8xP1U0ys4S4qVzm/E2u47aOXR3ZVrvCVZ8tjWyxQ3X0F+LV7ejf5rYbEduMhGMs6X
         AG8nUG3tR8S7I/NXDrVWeL7H8/Pr2wrVwkebr8zLDqayhv0jeBP8HXVDz3kDBZNOS8bS
         CWkw==
X-Gm-Message-State: AOAM533LS1Sz8orRxw1dErjWtLqlLtzhTvTLgiynxuoGoBeusbmbDRHm
        9EkL9sc8B2/yhSsvWRd45p3Ua7pdLD22hvUa3IA=
X-Google-Smtp-Source: ABdhPJxlIihlyvTjKzn+tpfQgBH2L3Mko4ZNyARQG8NAgYrgFl4lmP0HtclXSXAkeoNkgYLKExhl8UWk26qGXRkGZdE=
X-Received: by 2002:a17:903:3015:b029:12a:f5ab:e040 with SMTP id
 o21-20020a1709033015b029012af5abe040mr7957390pla.64.1626060884202; Sun, 11
 Jul 2021 20:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com> <40afda00-0737-d4cc-e801-85a7544fb26b@huawei.com>
In-Reply-To: <40afda00-0737-d4cc-e801-85a7544fb26b@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Jul 2021 20:34:32 -0700
Message-ID: <CAM_iQpV3LjswT8pwGc755Ncc0cT1qH433KhD8VZ-7FKQOTs3Fg@mail.gmail.com>
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 8:01 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/12 3:03, Cong Wang wrote:
> > From: Qitao Xu <qitao.xu@bytedance.com>
> >
> > Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
> > the entrance of TC layer on TX side. This is kinda symmetric to
> > trace_qdisc_dequeue(), and together they can be used to calculate
> > the packet queueing latency. It is more accurate than
> > trace_net_dev_queue(), because we already successfully enqueue
> > the packet at that point.
> >
> > Note, trace ring buffer is only accessible to privileged users,
> > it is safe to use %px to print a real kernel address here.
> >
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>
> > Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> > ---
> >  include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
> >  net/core/dev.c               |  9 +++++++++
> >  2 files changed, 35 insertions(+)
> >
> > diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> > index 58209557cb3a..c3006c6b4a87 100644
> > --- a/include/trace/events/qdisc.h
> > +++ b/include/trace/events/qdisc.h
> > @@ -46,6 +46,32 @@ TRACE_EVENT(qdisc_dequeue,
> >                 __entry->txq_state, __entry->packets, __entry->skbaddr )
> >  );
> >
> > +TRACE_EVENT(qdisc_enqueue,
> > +
> > +     TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
> > +
> > +     TP_ARGS(qdisc, txq, skb),
> > +
> > +     TP_STRUCT__entry(
> > +             __field(struct Qdisc *, qdisc)
> > +             __field(void *, skbaddr)
> > +             __field(int, ifindex)
> > +             __field(u32, handle)
> > +             __field(u32, parent)
> > +     ),
> > +
> > +     TP_fast_assign(
> > +             __entry->qdisc = qdisc;
> > +             __entry->skbaddr = skb;
> > +             __entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
> > +             __entry->handle  = qdisc->handle;
> > +             __entry->parent  = qdisc->parent;
> > +     ),
> > +
> > +     TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%px",
> > +               __entry->ifindex, __entry->handle, __entry->parent, __entry->skbaddr)
> > +);
> > +
> >  TRACE_EVENT(qdisc_reset,
> >
> >       TP_PROTO(struct Qdisc *q),
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index c253c2aafe97..20b9376de301 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -131,6 +131,7 @@
> >  #include <trace/events/napi.h>
> >  #include <trace/events/net.h>
> >  #include <trace/events/skb.h>
> > +#include <trace/events/qdisc.h>
> >  #include <linux/inetdevice.h>
> >  #include <linux/cpu_rmap.h>
> >  #include <linux/static_key.h>
> > @@ -3864,6 +3865,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
> >                       if (unlikely(!nolock_qdisc_is_empty(q))) {
> >                               rc = q->enqueue(skb, q, &to_free) &
> >                                       NET_XMIT_MASK;
> > +                             if (rc == NET_XMIT_SUCCESS)
>
> If NET_XMIT_CN is returned, the skb seems to be enqueued too?

Sure. See the other reply from on why dropped packets are not
interesting here.

>
> Also instead of checking the rc before calling the trace_*, maybe
> it make more sense to add the rc to the tracepoint, so that the checking
> is avoided, and we are able to tell the enqueuing result of a specific skb
> from that tracepoint too.

Totally disagree, because trace_qdisc_dequeue() is only called for
successful cases too (see dequeue_skb()), it does not make sense
to let them be different.

>
> > +                                     trace_qdisc_enqueue(q, txq, skb);
>
> Does it make sense to wrap the about to something like:

Nope. Because ->enqueue() is called by lower layer qdisc's
too, but here we only want to track root, aka, entrance of TC.
I know this may be confusing, please blame trace_qdisc_dequeue()
which only tracks the exit. ;)

Thanks.
