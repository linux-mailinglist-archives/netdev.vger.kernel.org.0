Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9D829F47C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 20:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgJ2TFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 15:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgJ2TFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 15:05:22 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B91C0613CF;
        Thu, 29 Oct 2020 12:05:21 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k21so4707329ioa.9;
        Thu, 29 Oct 2020 12:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x/nfCoCP9F3Ki/1h24iD74gnLDTd/sr95ZiJpeJipjQ=;
        b=vByD0S4shQJ2EaQtKYRzz7+XFAS7Aqc5jt9oNdTGUMKOFZeFxoMIZ64gKMBUjIjRK5
         xUlbjFDmQzMKjPQG4YGliO8oxtI9caunzKS0Drq+7xckqqtq1BCkc0Pv4SqRLkHZWQnz
         aaKJRsXY9LLbqqw7Rb3oeclwijkme/g2o5QktHshhjxEp3kG0mUSi3e4PUH2UbdKZ97K
         N9QdDhfnGT6H7u6x2Aoq3lLP82l4wQWCVfBqQrsntgxBNVTyVyJZABaBBjQoX6lH/pOz
         eYDJEIYHOWiSjS0UJiPIWZ8U/mSNPFYkdxjBL36O5+ysGaTUMFqv3hlozD30hS/cf08R
         Cwog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x/nfCoCP9F3Ki/1h24iD74gnLDTd/sr95ZiJpeJipjQ=;
        b=Rmahflt4JVv7IgcK/c/coDRTv+4bUtdbMaSFxps1jlcAGKVDQNLcw10JVEHmlp4Wny
         nk193n/c1qRPtOaoSuRAcUrn3+CnMXbGNJ9b8AbmEdXLqqBA5V4VSb4maHYp1xTYzeX1
         +s09XT2i97bySCOO4cpXqgNP3Xh9+7VqqIyspwvM2tjwKNifaQ7RuOlH5EEWsoWmMZiG
         zTpx3SNtnYkD4BzscJNowcJWcjF/yMx5+Ilb5Ym2hXkDV5uJF2DpKw/PMVeTRXnwC+M0
         7YG5gPSWRgaGR+On/2olgXTASX1LILTXd0nsd5cILTNA9yShgzXsgMtvZU+uGGWkDrcc
         KC3w==
X-Gm-Message-State: AOAM530FHnntdkr2FBQpKYDOTXZ8ty+1DQlr/UUz72DZgPPRuvwz633N
        DJDjQJySO7QRL+X1qXud8gfM5djQWA4cc5B/uE5SDrw7feWipg==
X-Google-Smtp-Source: ABdhPJxUXRt2nYmHv8IhHOYTIbDN1r0icyesFBkhKRtfKbsahEuVW/ZgNZaiKivAF2hhVh6Lcq4V0eKYqDL8ZA8ATVE=
X-Received: by 2002:a02:b786:: with SMTP id f6mr4952827jam.75.1603998320770;
 Thu, 29 Oct 2020 12:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com> <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
 <1f8ebcde-f5ff-43df-960e-3661706e8d04@huawei.com>
In-Reply-To: <1f8ebcde-f5ff-43df-960e-3661706e8d04@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 29 Oct 2020 12:05:09 -0700
Message-ID: <CAM_iQpUm91x8Q0G=CXE7S43DKryABkyMTa4mz_oEfEOTFS7BgQ@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 7:54 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2020/9/18 3:26, Cong Wang wrote:
> > On Fri, Sep 11, 2020 at 1:13 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> On 2020/9/11 4:07, Cong Wang wrote:
> >>> On Tue, Sep 8, 2020 at 4:06 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>>
> >>>> Currently there is concurrent reset and enqueue operation for the
> >>>> same lockless qdisc when there is no lock to synchronize the
> >>>> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
> >>>> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
> >>>> out-of-bounds access for priv->ring[] in hns3 driver if user has
> >>>> requested a smaller queue num when __dev_xmit_skb() still enqueue a
> >>>> skb with a larger queue_mapping after the corresponding qdisc is
> >>>> reset, and call hns3_nic_net_xmit() with that skb later.
> >>>>
> >>>> Reused the existing synchronize_net() in dev_deactivate_many() to
> >>>> make sure skb with larger queue_mapping enqueued to old qdisc(which
> >>>> is saved in dev_queue->qdisc_sleeping) will always be reset when
> >>>> dev_reset_queue() is called.
> >>>>
> >>>> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
> >>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >>>> ---
> >>>> ChangeLog V2:
> >>>>         Reuse existing synchronize_net().
> >>>> ---
> >>>>  net/sched/sch_generic.c | 48 +++++++++++++++++++++++++++++++++---------------
> >>>>  1 file changed, 33 insertions(+), 15 deletions(-)
> >>>>
> >>>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> >>>> index 265a61d..54c4172 100644
> >>>> --- a/net/sched/sch_generic.c
> >>>> +++ b/net/sched/sch_generic.c
> >>>> @@ -1131,24 +1131,10 @@ EXPORT_SYMBOL(dev_activate);
> >>>>
> >>>>  static void qdisc_deactivate(struct Qdisc *qdisc)
> >>>>  {
> >>>> -       bool nolock = qdisc->flags & TCQ_F_NOLOCK;
> >>>> -
> >>>>         if (qdisc->flags & TCQ_F_BUILTIN)
> >>>>                 return;
> >>>> -       if (test_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state))
> >>>> -               return;
> >>>> -
> >>>> -       if (nolock)
> >>>> -               spin_lock_bh(&qdisc->seqlock);
> >>>> -       spin_lock_bh(qdisc_lock(qdisc));
> >>>>
> >>>>         set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
> >>>> -
> >>>> -       qdisc_reset(qdisc);
> >>>> -
> >>>> -       spin_unlock_bh(qdisc_lock(qdisc));
> >>>> -       if (nolock)
> >>>> -               spin_unlock_bh(&qdisc->seqlock);
> >>>>  }
> >>>>
> >>>>  static void dev_deactivate_queue(struct net_device *dev,
> >>>> @@ -1165,6 +1151,30 @@ static void dev_deactivate_queue(struct net_device *dev,
> >>>>         }
> >>>>  }
> >>>>
> >>>> +static void dev_reset_queue(struct net_device *dev,
> >>>> +                           struct netdev_queue *dev_queue,
> >>>> +                           void *_unused)
> >>>> +{
> >>>> +       struct Qdisc *qdisc;
> >>>> +       bool nolock;
> >>>> +
> >>>> +       qdisc = dev_queue->qdisc_sleeping;
> >>>> +       if (!qdisc)
> >>>> +               return;
> >>>> +
> >>>> +       nolock = qdisc->flags & TCQ_F_NOLOCK;
> >>>> +
> >>>> +       if (nolock)
> >>>> +               spin_lock_bh(&qdisc->seqlock);
> >>>> +       spin_lock_bh(qdisc_lock(qdisc));
> >>>
> >>>
> >>> I think you do not need this lock for lockless one.
> >>
> >> It seems so.
> >> Maybe another patch to remove qdisc_lock(qdisc) for lockless
> >> qdisc?
> >
> > Yeah, but not sure if we still want this lockless qdisc any more,
> > it brings more troubles than gains.
> >
> >>
> >>
> >>>
> >>>> +
> >>>> +       qdisc_reset(qdisc);
> >>>> +
> >>>> +       spin_unlock_bh(qdisc_lock(qdisc));
> >>>> +       if (nolock)
> >>>> +               spin_unlock_bh(&qdisc->seqlock);
> >>>> +}
> >>>> +
> >>>>  static bool some_qdisc_is_busy(struct net_device *dev)
> >>>>  {
> >>>>         unsigned int i;
> >>>> @@ -1213,12 +1223,20 @@ void dev_deactivate_many(struct list_head *head)
> >>>>                 dev_watchdog_down(dev);
> >>>>         }
> >>>>
> >>>> -       /* Wait for outstanding qdisc-less dev_queue_xmit calls.
> >>>> +       /* Wait for outstanding qdisc-less dev_queue_xmit calls or
> >>>> +        * outstanding qdisc enqueuing calls.
> >>>>          * This is avoided if all devices are in dismantle phase :
> >>>>          * Caller will call synchronize_net() for us
> >>>>          */
> >>>>         synchronize_net();
> >>>>
> >>>> +       list_for_each_entry(dev, head, close_list) {
> >>>> +               netdev_for_each_tx_queue(dev, dev_reset_queue, NULL);
> >>>> +
> >>>> +               if (dev_ingress_queue(dev))
> >>>> +                       dev_reset_queue(dev, dev_ingress_queue(dev), NULL);
> >>>> +       }
> >>>> +
> >>>>         /* Wait for outstanding qdisc_run calls. */
> >>>>         list_for_each_entry(dev, head, close_list) {
> >>>>                 while (some_qdisc_is_busy(dev)) {
> >>>
> >>> Do you want to reset before waiting for TX action?
> >>>
> >>> I think it is safer to do it after, at least prior to commit 759ae57f1b
> >>> we did after.
> >>
> >> The reference to the txq->qdisc is always protected by RCU, so the synchronize_net()
> >> should be enought to ensure there is no skb enqueued to the old qdisc that is saved
> >> in the dev_queue->qdisc_sleeping, because __dev_queue_xmit can only see the new qdisc
> >> after synchronize_net(), which is noop_qdisc, and noop_qdisc will make sure any skb
> >> enqueued to it will be dropped and freed, right?
> >
> > Hmm? In net_tx_action(), we do not hold RCU read lock, and we do not
> > reference qdisc via txq->qdisc but via sd->output_queue.
>
> Sorry for the delay reply, I seems to miss this.
>
> I assumed synchronize_net() also wait for outstanding softirq to finish, right?

I do not see how and why it should. synchronize_net() is merely an optimized
version of synchronize_rcu(), it should wait for RCU readers, softirqs are not
necessarily RCU readers, net_tx_action() does not take RCU read lock either.

>
> >
> >
> >>
> >> If we do any additional reset that is not related to qdisc in dev_reset_queue(), we
> >> can move it after some_qdisc_is_busy() checking.
> >
> > I am not suggesting to do an additional reset, I am suggesting to move
> > your reset after the busy waiting.
>
> There maybe a deadlock here if we reset the qdisc after the some_qdisc_is_busy() checking,
> because some_qdisc_is_busy() may require the qdisc reset to clear the skb, so that

some_qdisc_is_busy() checks the status of qdisc, not the skb queue.


> some_qdisc_is_busy() can return false. I am not sure this is really a problem, but
> sch_direct_xmit() may requeue the skb when dev_hard_start_xmit return TX_BUSY.

Sounds like another reason we should move the reset as late as possible?

Thanks.
