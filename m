Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8951C3C415C
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhGLDFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLDE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:04:59 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F87C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:02:11 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gb6so31494578ejc.5
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dH+Ng/0j2Cs/OU2HpcMQUY2P4hKd/dbRzK1u5w/pApw=;
        b=lQHTP4NZ1H8WIlo983itz2TiFJhC4JEtxQcfBSh+sb12wwhlF3nGxXDfkL+UKFBsEv
         fGUog+qX7sZo0NAtTW/AEiQoJ3nXed1rfw6vCHwASYB8wS7Fr7ZLyyJ8lK3kNpvRTJ4H
         psvW7ghpuM9t4L0KBowTZVxuASvcPwsxZ2dWYk7+GYWrWYFdgyg2Wko4K7AgxZ/5f38w
         SIX9YQchqJx2nkvtzuPfk8u53B/bl40cwaUm+9WgB9/F7ILGILM4e9sbZpO3i6UKSwMZ
         d2xP3iChaeQNfa+UT8XXLcFRaBmFfLwHh7G7lg/NXqeT6krjO0qul3NEPeR1bbiJaz1R
         iozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dH+Ng/0j2Cs/OU2HpcMQUY2P4hKd/dbRzK1u5w/pApw=;
        b=AOj87B3FpceMIEuSlqKYyZP2W1IBMGOn3iSD7QQZ+DEKXRfxEkVze3I+lBoZ1uUWrz
         5/wvJx1fvwYo6qgKEERlGrfcSvY5BRRaiaNhRzoTmaEsNI5Vs+wGTnP8GMt8+XIJ2hRw
         Or0vzXe+ZK7pjz+bm35DwE5CyQEbyqbiGnJi4CUMzsCICV/rbiaZih1drMhUs06z6qdQ
         GVb8ktWCmRL9PPr1XBJ8ibNPueQeabzunbQ6DoI/tIy/4IMiPgNjYW4bxKtsWMKGji8r
         8ahe0ULYXd442qaByANl4FoqbjNrSL3vTdDTt9wZhR76rbVhId7g3nyo2tHK/fJ8JPN2
         6EjA==
X-Gm-Message-State: AOAM532GKfETosOn1vEfT/j55QuS3aWZrOcfKb6AVc9YbQ4v6OZnc+VB
        bpSRsyzxdhe9ysfEV1mXzDDFjOZiUIhXsrOJpBE=
X-Google-Smtp-Source: ABdhPJznKa9kfQ4H0kTCVwZbN0fCqQxfn7qEZjdE/1Hemc5+PFK3hJXFVXwM9peIGH5dK+IzJBvu6cxmprwVhsfA/as=
X-Received: by 2002:a17:907:7293:: with SMTP id dt19mr10714099ejc.122.1626058929940;
 Sun, 11 Jul 2021 20:02:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com> <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
In-Reply-To: <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 12 Jul 2021 11:01:33 +0800
Message-ID: <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 9:47 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Jul 11, 2021 at 5:50 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Mon, Jul 12, 2021 at 3:03 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > From: Qitao Xu <qitao.xu@bytedance.com>
> > >
> > > Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
> > > the entrance of TC layer on TX side. This is kinda symmetric to
> > > trace_qdisc_dequeue(), and together they can be used to calculate
> > > the packet queueing latency. It is more accurate than
> > > trace_net_dev_queue(), because we already successfully enqueue
> > > the packet at that point.
> > >
> > > Note, trace ring buffer is only accessible to privileged users,
> > > it is safe to use %px to print a real kernel address here.
> > >
> > > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> > > ---
> > >  include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
> > >  net/core/dev.c               |  9 +++++++++
> > >  2 files changed, 35 insertions(+)
> > >
> > > diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> > > index 58209557cb3a..c3006c6b4a87 100644
> > > --- a/include/trace/events/qdisc.h
> > > +++ b/include/trace/events/qdisc.h
> > > @@ -46,6 +46,32 @@ TRACE_EVENT(qdisc_dequeue,
> > >                   __entry->txq_state, __entry->packets, __entry->skbaddr )
> > >  );
> > >
> > > +TRACE_EVENT(qdisc_enqueue,
> > > +
> > > +       TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
> > > +
> > > +       TP_ARGS(qdisc, txq, skb),
> > > +
> > > +       TP_STRUCT__entry(
> > > +               __field(struct Qdisc *, qdisc)
> > > +               __field(void *, skbaddr)
> > > +               __field(int, ifindex)
> > > +               __field(u32, handle)
> > > +               __field(u32, parent)
> > > +       ),
> > > +
> > > +       TP_fast_assign(
> > > +               __entry->qdisc = qdisc;
> > > +               __entry->skbaddr = skb;
> > > +               __entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
> > > +               __entry->handle  = qdisc->handle;
> > > +               __entry->parent  = qdisc->parent;
> > > +       ),
> > Hi qitao, cong
> > Why not support the txq, we get more info from txq.
>
> Because we only want to calculate queueing latency, not anything
> else. If you need it, you are welcome to add anything reasonable
> in the future, it won't break ABI (see 3dd344ea84e122f791ab).
Thanks!
> > and we should take care of the return value of q->enqueue, because we
> > can know what happens in the qdisc queue(not necessary to work with
> > qdisc:dequeue).
> > and we can use a tracepoint filter for the return value too.
>
> Disagree. Because we really have no interest in dropped packets.
> Even if we really do, we could trace kfree_skb(), not really here.
The qdisc returns not only the NET_XMIT_DROP, right ?
skbprio_enqueue, sfq_enqueue and red_enqueue may return the NET_XMIT_CN.


> > we should introduce a new function to instead of now codes, that may
> > make the codes clean.  Please review my patch for more info.
>
> Just 3 lines of code, it is totally personal taste.
>
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210711050007.1200-1-xiangxia.m.yue@gmail.com/
>
> I did review it. Like I said, %p does not work. Have you tested your
> patches? ;)
Yes, I tested them, I didn't find the error.  my patch is based on
commit id 89212e160b81e778f829b89743570665810e3b13
> Thanks.



-- 
Best regards, Tonghao
