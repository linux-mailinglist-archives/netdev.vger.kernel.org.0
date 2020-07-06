Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A881215FEC
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgGFULB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFULA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:11:00 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E93C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:11:00 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id i18so34038586ilk.10
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oa/aJouFbJLkQLfFA0r1P4W9x+GhQvpGbBemILMpEmc=;
        b=VKos2DRNZXZT2WMF1gMLVPbpcD/4xXpo+62QFY2aJXcm8qwxMIcfcxTHUyhg3/7eaR
         0pXARjkONkN/h831nF6sS577R3tYwDBEsP6yVgcZQBeiXzwHc0k/uQOs1s7UTtFR6yN2
         34kCh5wfP6MQ8FWaKzLFS/5X/H4I5YQVJD4IrV2Zr08kG7TK9nA/WSTKbV0ogmHm0kvr
         /FmBaZse1TkQGVUCgb6eZ51mLmq7jLJ9vS1FOGUdnR0QigqDJeTAIUYhrQ96VhFcXzj0
         JoCFWRPHd7rWXAfQIGTvQXmAUQa+Qy5NcPz7AMKegQRFU//1RFu0KQ/O7ZeZj1VSsYJa
         Piaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oa/aJouFbJLkQLfFA0r1P4W9x+GhQvpGbBemILMpEmc=;
        b=N0i32E7fKiRYeNm7jYqw/dd0XaN+rqAxFNnll9MF+knGT1HFBxhXh0iGr437o7a1zY
         bgeezzBvCtSOIVoD71Byz1yb8mlhHqEp7e5c/3ikJCP+Eloz1yPTnuG7yKLzDIA1i4tm
         59aWL20gpWe9iWVpti94vd2hxOPgOR2K13SbcaZAJPebL/X7we9Mib88yttvF/H9AXO1
         PhVjEj8pfOrX+vSTJLaOc0q9A3uSm5hd61UJuFM8Cmrbq7BC0OX+vNLERJv4qgfVi0MC
         AY8jFaoelLcWydaU5i+x57z9cYv/m/c2KHDOwKOun9SOSb2VM9QTxSJyws62hfvTGfPp
         bTLg==
X-Gm-Message-State: AOAM5339qHDwuryGBBDVXAOMS1HjBu5qSPdS0RXA5lko1gS3kQb7emWP
        ZTjC0fnDUE0VpkIRUZxF3VrvUU3syX5IppKnRRk=
X-Google-Smtp-Source: ABdhPJw+ymCScGxYz829Xh/PZ80rmwT38J53m/QF2cbBozp8R5dkgIQqXsvKnDOpzsNBqmD26BtKKbwvdqqMm/7TSQQ=
X-Received: by 2002:a92:bb0b:: with SMTP id w11mr32812031ili.238.1594066259162;
 Mon, 06 Jul 2020 13:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
In-Reply-To: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 6 Jul 2020 13:10:48 -0700
Message-ID: <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB) Qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 11:11 AM YU, Xiangning
<xiangning.yu@alibaba-inc.com> wrote:
> +static int ltb_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_lock,
> +                      struct sk_buff **to_free)
> +{
> +       struct ltb_sched *ltb = qdisc_priv(sch);
> +       struct ltb_pcpu_sched *pcpu_q;
> +       struct ltb_class *cl;
> +       struct ltb_pcpu_data *pcpu = this_cpu_ptr(ltb->pcpu_data);
> +       int cpu;
> +
> +       cpu = smp_processor_id();
> +       pcpu_q = qdisc_priv(pcpu->qdisc);
> +       ltb_skb_cb(skb)->cpu = cpu;
> +
> +       cl = ltb_classify(sch, ltb, skb);
> +       if (unlikely(!cl)) {
> +               kfree_skb(skb);
> +               return NET_XMIT_DROP;
> +       }
> +
> +       pcpu->active = true;
> +       if (unlikely(kfifo_put(&cl->aggr_queues[cpu], skb) == 0)) {
> +               kfree_skb(skb);
> +               atomic64_inc(&cl->stat_drops);
> +               return NET_XMIT_DROP;
> +       }


How do you prevent out-of-order packets?


> +static int ltb_init(struct Qdisc *sch, struct nlattr *opt,
...
> +       ltb->default_cls = ltb->shadow_cls; /* Default hasn't been created */
> +       tasklet_init(&ltb->fanout_tasklet, ltb_fanout_tasklet,
> +                    (unsigned long)ltb);
> +
> +       /* Bandwidth balancer, this logic can be implemented in user-land. */
> +       init_waitqueue_head(&ltb->bwbalancer_wq);
> +       ltb->bwbalancer_task =
> +           kthread_create(ltb_bw_balancer_kthread, ltb, "ltb-balancer");
> +       wake_up_process(ltb->bwbalancer_task);

Creating a kthread for each qdisc doesn't look good. Why do you
need a per-qdisc kthread or even a kernel thread at all?

Thanks.
