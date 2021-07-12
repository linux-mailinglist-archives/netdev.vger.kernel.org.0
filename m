Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C223C411A
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 03:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGLBua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 21:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhGLBua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 21:50:30 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F76C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 18:47:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h1-20020a17090a3d01b0290172d33bb8bcso11844600pjc.0
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 18:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u4xbfLFX+/W2B7LYHKOHHB5UcvMTe8xD2T2DiUU3L/0=;
        b=A0XriHvfmdq0x6krcPQmnuguoqqKZ0KDz6p8dazbD6IoXJ+bFNbexZkwVBffxbJV2e
         86qyX1nWzZ4v5P3PszaU1DbIRoK1UkiwtHqDpHEQU/NmjSZPTitLaKdydpgwLBwKVRDv
         bdTScWHTedKighbVruQNxJMEXdJwxnl0AqkZNfe1ZVXnVkscCA1hWkpOCTojgRx7UjAw
         PZNs9YisXWvVzJbmIzXi80Y80D23NzJpGR3nOW6mJSbH6eIpkEEFuGPfgvoeadAhOmIN
         LkrXi1vA6ZNJZTb7D82vtICRnIK9I7ERveaCLUlPXcqQc43Ctyz5eqUrf1122FDUXuS+
         8OxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u4xbfLFX+/W2B7LYHKOHHB5UcvMTe8xD2T2DiUU3L/0=;
        b=eJPI0lcYLQYWwfNJNmXFK00Mr3TlllELC0Z7pPeJSaPHtE2yP8FZowAktFSc/dwXif
         /hIhoFl5SetguQVQmzze+cMur7gji2GOsuHHEJhpt2uy/ZSfpcP2Nz2W8xA7Xy4l3EeU
         TqCP2QwF+8Hbo4bz9Xedm+0OlwOr6u8cLhQ+W3DJIZLpyofM7JCV+ldpC03RImeohuA2
         F5SzL+MCiNPnC0YxKqbI8yT7EMo1RubuhHZAivWVWN5/u/vrt6MknyqAfGvOlnt3FP1K
         z5/8JwHHtpFOaifSXHtjt7rp8YxosMUY2c2bNTLkXo5K2iKQBRIabMc26Kji1G2b37JG
         mqjg==
X-Gm-Message-State: AOAM532p1Szni4zebX9DNaFGDPw84/nImtAkrbU5d/TUiNLlc0BaEkPT
        DPNv/Dqh1m8W/RAFp/8DSfiyOi5ttPxofCW8UaY=
X-Google-Smtp-Source: ABdhPJzAwgzZDqtejJYzyYuP/oW+s/zjRjq5ztW+tfKQXrKrEtSS0C4yMNK92Pmf14QBepBnwow3JVfdaBohjvOJC1k=
X-Received: by 2002:a17:90a:7bc3:: with SMTP id d3mr2228698pjl.145.1626054461442;
 Sun, 11 Jul 2021 18:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com> <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
In-Reply-To: <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Jul 2021 18:47:30 -0700
Message-ID: <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
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

On Sun, Jul 11, 2021 at 5:50 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 3:03 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
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
> >                   __entry->txq_state, __entry->packets, __entry->skbaddr )
> >  );
> >
> > +TRACE_EVENT(qdisc_enqueue,
> > +
> > +       TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
> > +
> > +       TP_ARGS(qdisc, txq, skb),
> > +
> > +       TP_STRUCT__entry(
> > +               __field(struct Qdisc *, qdisc)
> > +               __field(void *, skbaddr)
> > +               __field(int, ifindex)
> > +               __field(u32, handle)
> > +               __field(u32, parent)
> > +       ),
> > +
> > +       TP_fast_assign(
> > +               __entry->qdisc = qdisc;
> > +               __entry->skbaddr = skb;
> > +               __entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
> > +               __entry->handle  = qdisc->handle;
> > +               __entry->parent  = qdisc->parent;
> > +       ),
> Hi qitao, cong
> Why not support the txq, we get more info from txq.

Because we only want to calculate queueing latency, not anything
else. If you need it, you are welcome to add anything reasonable
in the future, it won't break ABI (see 3dd344ea84e122f791ab).

> and we should take care of the return value of q->enqueue, because we
> can know what happens in the qdisc queue(not necessary to work with
> qdisc:dequeue).
> and we can use a tracepoint filter for the return value too.

Disagree. Because we really have no interest in dropped packets.
Even if we really do, we could trace kfree_skb(), not really here.

> we should introduce a new function to instead of now codes, that may
> make the codes clean.  Please review my patch for more info.

Just 3 lines of code, it is totally personal taste.

> https://patchwork.kernel.org/project/netdevbpf/patch/20210711050007.1200-1-xiangxia.m.yue@gmail.com/

I did review it. Like I said, %p does not work. Have you tested your
patches? ;)

Thanks.
