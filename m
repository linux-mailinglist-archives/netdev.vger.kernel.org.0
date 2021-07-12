Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF993C41FF
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhGLDi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhGLDi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:38:59 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8373AC0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:36:10 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id hr1so31703837ejc.1
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a654pq7T0O/qrfgJ5BzV4SlCfsBSJavGvdxWNkrLNy0=;
        b=k890c5TG25onpI7nUPSB/3KueeKuDfvT7xBJ9uERkq0Cbh+nVbQ0ykYwtwFK1CPVck
         jpJOJrHAbNzQE/gzAGFgDCJ7Ychb258OQUjRSmsqQ48SZBU9r51i9qxAv+rqYlv9L0Jq
         vIXOucs/KeNgJalJpt5jBYy87dKnLK0qQjrUo6gTQk60C++y+JgzFSbIeVH4j9VDDTV6
         ucRZlSN/yFsuE0mf681i+3AUe6Vpvu+1fMtG3K6xm17E7nX/72lDGhFzkxQy6WR1cYzd
         SjTojCcIeYhuO5Js+FydeuSvz9dztT97fX3/VFIgZORnz9bYW6dSAiC0F6+/c0k/T50R
         r9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a654pq7T0O/qrfgJ5BzV4SlCfsBSJavGvdxWNkrLNy0=;
        b=HrhZcnbXa2pXBUzpR+vtcRvvfJTXdidA1LiSIpXn31pqPSeRVbdcQrP7saytV0OwoR
         nJuWTlCDNMloNFkpWitZX3ZWG59wbStDTS/73avuzuAe8bsM3YkaAuOb0qhfwAwE/5HN
         P21ZFJVK9VP5LmaDYtAs1+PeJuzOTTkN4wq+ueKZcA+d/fYQ8Kv0NINnZrVb5vJcpaYr
         i/cnW3oAYUsGcC0z5mZcj8pXBskI/nsfWYd8MwXLWYkeF3BBkwmX9uczchFaIJVzrXAs
         ef2vsZuc1iGTlCW8JflH1qWGLGX1RJe3ALMqhxq3Hhk2PUkM1SEhQAY9se91HVTlmXXA
         QfUw==
X-Gm-Message-State: AOAM533fevlvOIG5+1SLsFqKUM9mukqj7ZLtT8xMiESUr9OJS/MPK0b7
        kFfNeDvOrMPFjxnGYuhkw5WJ1SJw9XFsK6cSF7s=
X-Google-Smtp-Source: ABdhPJzATlWPAg7i/mrNSCjJUIaFvMJsnoTzU4guoLxWUvwfkN/xFnwMiYc+S/xjWZSrCohJwFZo7zTlSkvLJEt7nmw=
X-Received: by 2002:a17:907:3f0c:: with SMTP id hq12mr45513416ejc.117.1626060969102;
 Sun, 11 Jul 2021 20:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210711190308.8476-1-xiyou.wangcong@gmail.com>
 <CAMDZJNWWq2TGb6-nZRbBNfLevOyD2oSn941Nw_+7q0QzVep_GA@mail.gmail.com>
 <CAM_iQpUmO8S-7cgG=yy2TsNoc9nHpW__-WCfhcfV-_eAf46K7A@mail.gmail.com>
 <CAMDZJNXbwzXrHX1UT+DLsJvbKPh70-OPyrkTV=D05a5Mwcko3w@mail.gmail.com> <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com>
In-Reply-To: <CAM_iQpUG28PBhXmqQeEzcWq8cNLFH1BzXaZ1FWGu1jqObGfdwg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 12 Jul 2021 11:35:33 +0800
Message-ID: <CAMDZJNV9tbGE0Y1nZgMcp2Z5LU5Cb7YfJ+mS9rVogrin8SGxjQ@mail.gmail.com>
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

On Mon, Jul 12, 2021 at 11:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Jul 11, 2021 at 8:02 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Mon, Jul 12, 2021 at 9:47 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Sun, Jul 11, 2021 at 5:50 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > On Mon, Jul 12, 2021 at 3:03 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > From: Qitao Xu <qitao.xu@bytedance.com>
> > > > >
> > > > > Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
> > > > > the entrance of TC layer on TX side. This is kinda symmetric to
> > > > > trace_qdisc_dequeue(), and together they can be used to calculate
> > > > > the packet queueing latency. It is more accurate than
> > > > > trace_net_dev_queue(), because we already successfully enqueue
> > > > > the packet at that point.
> > > > >
> > > > > Note, trace ring buffer is only accessible to privileged users,
> > > > > it is safe to use %px to print a real kernel address here.
> > > > >
> > > > > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > > > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > > > Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> > > > > ---
> > > > >  include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
> > > > >  net/core/dev.c               |  9 +++++++++
> > > > >  2 files changed, 35 insertions(+)
> > > > >
> > > > > diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> > > > > index 58209557cb3a..c3006c6b4a87 100644
> > > > > --- a/include/trace/events/qdisc.h
> > > > > +++ b/include/trace/events/qdisc.h
> > > > > @@ -46,6 +46,32 @@ TRACE_EVENT(qdisc_dequeue,
> > > > >                   __entry->txq_state, __entry->packets, __entry->skbaddr )
> > > > >  );
> > > > >
> > > > > +TRACE_EVENT(qdisc_enqueue,
> > > > > +
> > > > > +       TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
> > > > > +
> > > > > +       TP_ARGS(qdisc, txq, skb),
> > > > > +
> > > > > +       TP_STRUCT__entry(
> > > > > +               __field(struct Qdisc *, qdisc)
> > > > > +               __field(void *, skbaddr)
> > > > > +               __field(int, ifindex)
> > > > > +               __field(u32, handle)
> > > > > +               __field(u32, parent)
> > > > > +       ),
> > > > > +
> > > > > +       TP_fast_assign(
> > > > > +               __entry->qdisc = qdisc;
> > > > > +               __entry->skbaddr = skb;
> > > > > +               __entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
> > > > > +               __entry->handle  = qdisc->handle;
> > > > > +               __entry->parent  = qdisc->parent;
> > > > > +       ),
> > > > Hi qitao, cong
> > > > Why not support the txq, we get more info from txq.
> > >
> > > Because we only want to calculate queueing latency, not anything
> > > else. If you need it, you are welcome to add anything reasonable
> > > in the future, it won't break ABI (see 3dd344ea84e122f791ab).
> > Thanks!
> > > > and we should take care of the return value of q->enqueue, because we
> > > > can know what happens in the qdisc queue(not necessary to work with
> > > > qdisc:dequeue).
> > > > and we can use a tracepoint filter for the return value too.
> > >
> > > Disagree. Because we really have no interest in dropped packets.
> > > Even if we really do, we could trace kfree_skb(), not really here.
> > The qdisc returns not only the NET_XMIT_DROP, right ?
> > skbprio_enqueue, sfq_enqueue and red_enqueue may return the NET_XMIT_CN.
> >
>
> Sure, in that case a different packet is dropped, once again you
> can trace it with kfree_skb() if you want. What's the problem?
It's ok, but we can make it better. Yunsheng Lin may have explained why?
> >
> > > > we should introduce a new function to instead of now codes, that may
> > > > make the codes clean.  Please review my patch for more info.
> > >
> > > Just 3 lines of code, it is totally personal taste.
> > >
> > > > https://patchwork.kernel.org/project/netdevbpf/patch/20210711050007.1200-1-xiangxia.m.yue@gmail.com/
> > >
> > > I did review it. Like I said, %p does not work. Have you tested your
> > > patches? ;)
> > Yes, I tested them, I didn't find the error.  my patch is based on
> > commit id 89212e160b81e778f829b89743570665810e3b13
>
> I seriously doubt it, because we actually used %p in the beginning
> too and got the same address for two different packets, this is why
> we have to move to %px. It is 100% reproducible, so it probably
> means you didn't test it at all.
I use iperf to send the packets, not found the same address really

          <idle>-0       [043] ..s.    62.493634: qdisc_enqueue:
enqueue ifindex=2 qdisc handle=0x0 parent=0x2C
skbaddr=00000000a40f93fb ret=0
          <idle>-0       [043] ..s.    62.494641: qdisc_enqueue:
enqueue ifindex=2 qdisc handle=0x0 parent=0x20
skbaddr=00000000c3c53e95 ret=0
          <idle>-0       [014] ..s.    64.473877: qdisc_enqueue:
enqueue ifindex=2 qdisc handle=0x0 parent=0x20
skbaddr=00000000ad610424 ret=0
          <idle>-0       [014] ..s.    64.473896: qdisc_enqueue:
enqueue ifindex=2 qdisc handle=0x0 parent=0x20
skbaddr=00000000112a562d ret=0

>
> Thanks.



-- 
Best regards, Tonghao
