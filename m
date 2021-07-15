Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678883CA16B
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238380AbhGOP2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhGOP2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 11:28:19 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBE0C06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 08:25:26 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id i16-20020a17090acf90b02901736d9d2218so4564885pju.1
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 08:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Te53RhoyCQuC1OeTe8j8wBCcF0oBfTCSE1Uno2NJgE=;
        b=RTzbFCAuJdDW2DmaEGc8qsgEI8otpppo/mlblEY2YAHlsUSv5hzjJ9MpR3049QtV3F
         35FfyDfQzqL1y8bucJ1KMKuz6Y9kacpVcVkQEHfOoDd6i1XcDoM5bOB1DSGNY1/zKdDK
         dXI0el98UOIuwSzMLBKFrKxCicEEdt1sj728yNPSK7PCON5STVOF7OHCIxrz9PAE1hNy
         cM8HK3zrNZOY/AkTTUgn7nxumgdteIRQ6NiK9/jh8H9VRrIqExgSiE4YH1rYpxBiqUNQ
         Iwl68fZDTQR57e7jYiGD+bmVyk6xySHWDCMXE827sCIqD5l8OA4Zqj2grjoft/dxTAlH
         NBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Te53RhoyCQuC1OeTe8j8wBCcF0oBfTCSE1Uno2NJgE=;
        b=gPy+CKcLBhTE4LbWdCfrccTIcPCq5ydu2Pou1o/Fb5OrLEVdes33TdoADnnyTjw/3y
         9yR1V8mpWVBBuULPIH4mBldzm1x6RjUtdfRu/n3iFd7UPTTs1djRIy7oGOY6lIJECyoC
         F5fMHuID+IaeyvNP9UNhS7NJ70GwdSPqE0o6S+fOMg6sLXp54udZR77lk8lyENR4gz5A
         GIFM0/aMypjWQwIaeyc1WNvmn34Qm12Cb4LtpU5BMKAUSyM1kllUBcaYPRIE9kGt4IUY
         VXsuEbMG0eLXc+Qsjw5fFc3oG5dvF2GtqYn4kDUtKLGHzAkkaX43k0ePU1Bida/tKCPW
         4wXQ==
X-Gm-Message-State: AOAM5304FH7anDyx/GZXBTuH2CVzwQ/Djo1qRwTJt21cLTOf3IgDoFuc
        OFXhd3cLryaDEo9OEirHu7cH79/HTVM5hNHMFzo=
X-Google-Smtp-Source: ABdhPJzbNrQ9xlUxD5Pxn1QgYCWzHABFptkrNW3fLutsf275dmXDaVuUrHaceJ6XiA4H2Ml4CG46MjQsoMiX9a5WlEY=
X-Received: by 2002:a17:90a:ba98:: with SMTP id t24mr1418861pjr.231.1626362725847;
 Thu, 15 Jul 2021 08:25:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210715060324.43337-1-xiyou.wangcong@gmail.com> <484a5342-c66f-f04d-c7b2-c24246e53c83@huawei.com>
In-Reply-To: <484a5342-c66f-f04d-c7b2-c24246e53c83@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 15 Jul 2021 08:25:15 -0700
Message-ID: <CAM_iQpUgDUs6Te8sPFnr2y-6MoGL9CqRu=E-KMOcOY8_3KUxNQ@mail.gmail.com>
Subject: Re: [Patch net-next v3] net_sched: introduce tracepoint trace_qdisc_enqueue()
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 4:24 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/15 14:03, Cong Wang wrote:
> > From: Qitao Xu <qitao.xu@bytedance.com>
> >
> > Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
> > the entrance of TC layer on TX side. This is similar to
> > trace_qdisc_dequeue():
> >
> > 1. For both we only trace successful cases. The failure cases
> >    can be traced via trace_kfree_skb().
> >
> > 2. They are called at entrance or exit of TC layer, not for each
> >    ->enqueue() or ->dequeue(). This is intentional, because
> >    we want to make trace_qdisc_enqueue() symmetric to
> >    trace_qdisc_dequeue(), which is easier to use.
> >
> > The return value of qdisc_enqueue() is not interesting here,
> > we have Qdisc's drop packets in ->dequeue(), it is impossible to
> > trace them even if we have the return value, the only way to trace
> > them is tracing kfree_skb().
> >
> > We only add information we need to trace ring buffer. If any other
> > information is needed, it is easy to extend it without breaking ABI,
> > see commit 3dd344ea84e1 ("net: tracepoint: exposing sk_family in all
> > tcp:tracepoints").
> >
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> > ---
> > v3: expand changelog
> >     add helper dev_qdisc_enqueue()
> >
> > v2: improve changelog
> >
> >  include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
> >  net/core/dev.c               | 20 ++++++++++++++++----
> >  2 files changed, 42 insertions(+), 4 deletions(-)
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
> > index c253c2aafe97..0dcddd077d60 100644
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
> > @@ -3844,6 +3845,18 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
> >       }
> >  }
> >
> > +static int dev_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *q,
> > +                          struct sk_buff **to_free,
> > +                          struct netdev_queue *txq)
> > +{
> > +     int rc;
> > +
> > +     rc = q->enqueue(skb, q, to_free) & NET_XMIT_MASK;
> > +     if (rc == NET_XMIT_SUCCESS)
>
> I do not really understand the usecase you metioned previously,
> but tracepointing the rc in trace_qdisc_enqueue() will avoid the
> above checking, which is in the fast path.

Good point, the solution is clearly not just tracing return value, instead
I use trace_qdisc_enqueue_enabled() which is based on jump label:

        static inline bool                                              \
        trace_##name##_enabled(void)                                    \
        {                                                               \
                return static_key_false(&__tracepoint_##name.key);      \
        }


>
> If there is no extra checking overhead when this tracepoint is
> disabled, then ignore my comment.

Yes, trace_qdisc_enqueue_enabled() should give 0 overhead.

Thanks.
