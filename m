Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF59D3C41B8
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhGLD01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhGLD00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:26:26 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D66C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:23:38 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id d12so16809845pgd.9
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h7ZvWxqTKtCgbOoSLOAXV+TTZtweg/Anz5gPuEsVpck=;
        b=gT8aeZVnwpF2UyGK9z18KGB1hCCzpU/YBjJVP9aNPJjxpJmi8c12ZRmLIGn06uD++v
         80wE70UWNhXgjyemOxBRkPmH7qhJ1dS60FVFe1vAnPFN9HNKHdg1CQks63AyO3FDlief
         48Em10wewuETrsceLsN2FJf79pi+8xACcTyr6qIE7b3VNYKV5Xcak/tz54L6dPbEFR2j
         1BqlSaZeNw//CBdq8phjRnmeQX2xOn84FT1S3haqd8qM8BxJqM/D4jqyBlUm4FkX2xN+
         65IMT/PL7s6WNLObrLyMwKNaykXOkfH4n8sjpb4cRKJSKE3RnCZy2EaHvJjGPJSHZYV8
         LL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h7ZvWxqTKtCgbOoSLOAXV+TTZtweg/Anz5gPuEsVpck=;
        b=nblDp2sdrUDBXjtQhM0Sia3+5ivSuLpqkdGMs9RoyqinuZyO36PBV/USY2mGOBPx8J
         5DlC2x22CHUxpqFRIwI4QHlgw0EKj06szBwChH3SU8YqJHEw6Tmti1T4AXCnJWmCrT6g
         +1WdZiAMzuzMBJFrxu/GVrVot0MjtMLCnk6FIoX0dJGJEX2C97FWpaxx0jUdPR1fWwiq
         FuoxCNyNSdXuKGe/3pFh/4bo2WQvc68g09zjUyimUVfmK8AXcQNpexL22i+rBX3a3wKK
         ZH6CFz/tIfK5a1hdKWAXEp7m1K2u0SwM30ez/TIIGduKI1yoxYfGVMU6Kykj3M/EYW6X
         ygog==
X-Gm-Message-State: AOAM532BziClB8ok89pz40yxhXeSSYgnJPvUgwJouJ2/Xxh7WjVI3i4u
        IHn0giesp9ZwtcVCR81kZM4CO8NMkMod4Vv0KPA=
X-Google-Smtp-Source: ABdhPJz/K51NgPHubEG7bjU6Dc5sqc/rXC+MGIypMBn/f7ls9qDIB14Aos6tY/PKq//Q/rR/EOnbG95ga5/8+17LVts=
X-Received: by 2002:a62:ea1a:0:b029:329:a95a:fab with SMTP id
 t26-20020a62ea1a0000b0290329a95a0fabmr12130315pfh.31.1626060217816; Sun, 11
 Jul 2021 20:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
 <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com> <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
In-Reply-To: <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Jul 2021 20:23:26 -0700
Message-ID: <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com>
Subject: Re: [Patch net-next v2] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 8:02 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 9:47 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Sun, Jul 11, 2021 at 5:50 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > On Mon, Jul 12, 2021 at 3:03 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > From: Qitao Xu <qitao.xu@bytedance.com>
> > > >
> > > > Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
> > > > the entrance of TC layer on TX side. This is kinda symmetric to
> > > > trace_qdisc_dequeue(), and together they can be used to calculate
> > > > the packet queueing latency. It is more accurate than
> > > > trace_net_dev_queue(), because we already successfully enqueue
> > > > the packet at that point.
> > > >
> > > > Note, trace ring buffer is only accessible to privileged users,
> > > > it is safe to use %px to print a real kernel address here.
> > > >
> > > > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > > Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> > > > ---
> > > >  include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
> > > >  net/core/dev.c               |  9 +++++++++
> > > >  2 files changed, 35 insertions(+)
> > > >
> > > > diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> > > > index 58209557cb3a..c3006c6b4a87 100644
> > > > --- a/include/trace/events/qdisc.h
> > > > +++ b/include/trace/events/qdisc.h
> > > > @@ -46,6 +46,32 @@ TRACE_EVENT(qdisc_dequeue,
> > > >                   __entry->txq_state, __entry->packets, __entry->skbaddr )
> > > >  );
> > > >
> > > > +TRACE_EVENT(qdisc_enqueue,
> > > > +
> > > > +       TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
> > > > +
> > > > +       TP_ARGS(qdisc, txq, skb),
> > > > +
> > > > +       TP_STRUCT__entry(
> > > > +               __field(struct Qdisc *, qdisc)
> > > > +               __field(void *, skbaddr)
> > > > +               __field(int, ifindex)
> > > > +               __field(u32, handle)
> > > > +               __field(u32, parent)
> > > > +       ),
> > > > +
> > > > +       TP_fast_assign(
> > > > +               __entry->qdisc = qdisc;
> > > > +               __entry->skbaddr = skb;
> > > > +               __entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
> > > > +               __entry->handle  = qdisc->handle;
> > > > +               __entry->parent  = qdisc->parent;
> > > > +       ),
> > > Hi qitao, cong
> > > Why not support the txq, we get more info from txq.
> >
> > Because we only want to calculate queueing latency, not anything
> > else. If you need it, you are welcome to add anything reasonable
> > in the future, it won't break ABI (see 3dd344ea84e122f791ab).
> Thanks!
> > > and we should take care of the return value of q->enqueue, because we
> > > can know what happens in the qdisc queue(not necessary to work with
> > > qdisc:dequeue).
> > > and we can use a tracepoint filter for the return value too.
> >
> > Disagree. Because we really have no interest in dropped packets.
> > Even if we really do, we could trace kfree_skb(), not really here.
> The qdisc returns not only the NET_XMIT_DROP, right ?
> skbprio_enqueue, sfq_enqueue and red_enqueue may return the NET_XMIT_CN.
>

Sure, in that case a different packet is dropped, once again you
can trace it with kfree_skb() if you want. What's the problem?

>
> > > we should introduce a new function to instead of now codes, that may
> > > make the codes clean.  Please review my patch for more info.
> >
> > Just 3 lines of code, it is totally personal taste.
> >
> > > https://patchwork.kernel.org/project/netdevbpf/patch/20210711050007.1200-1-xiangxia.m.yue@gmail.com/
> >
> > I did review it. Like I said, %p does not work. Have you tested your
> > patches? ;)
> Yes, I tested them, I didn't find the error.  my patch is based on
> commit id 89212e160b81e778f829b89743570665810e3b13

I seriously doubt it, because we actually used %p in the beginning
too and got the same address for two different packets, this is why
we have to move to %px. It is 100% reproducible, so it probably
means you didn't test it at all.

Thanks.
