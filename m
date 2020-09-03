Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C410325B7A4
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 02:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgICAff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 20:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgICAfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 20:35:33 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306E1C061244;
        Wed,  2 Sep 2020 17:35:33 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b16so893765ioj.4;
        Wed, 02 Sep 2020 17:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VG1rUkZYiTdT3J6cA6RCV2QZRzJ4ZmG//fRcpMw5m0k=;
        b=EqH3sJyXtOrt2OVHcm1IM+61J0RGLDT+V43PfMVjhEyR1JM03G/gnzX37y+aYDqOZm
         Zj+907om3fnBhTscYnatmbXcheBsrtiQ+fNmUXa9s54FMqT/7NiODwlo/LYu189GtLNr
         J/NG3XpoVPxYqnODs2Wd6QMyJ9N4mKwfdbkisfldOh/+AzpL7lLM0yuJnjAt2OsUw/jt
         a0geTwudU2ZolBUgvB4aDt/bkWOZLmr8vke91z+/fbcwFD679frE3ghNwxSG0p4oY7Gw
         kpvoCEdCySQfSnsFcMQ2m74rolrARBRPTIVZRahAjrzqk4SVA4aEY/Aie3zgvv3QWhaS
         Su2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VG1rUkZYiTdT3J6cA6RCV2QZRzJ4ZmG//fRcpMw5m0k=;
        b=HmZSU9cSWF8gMfEcNcI4EJGr8KuCkAjMDzz7/9IoKsOdw3BxEBLQONEzU8eC7Hx3VM
         KhcrvP5Pk0p0KCSdacEhtFSgb1wxV3HHy2cyNLYVg0uWv7UaRE0kiW/tiZh1TkVciOdi
         u/pzSFpAbuJFG6HLnwVNXSz68uaXOu3LBz70VHwXlTGZGJETowUs4D7RMaDykDgIIqrO
         /++36symW7b2a2hGQfoxQbbCh5Hp7qPqbRuyNN+4kEmxlEHHxSaPvZUq1lPW6CBQp/gC
         DFOboD+TMxE6jkMxTvrlxRIHSc8Fch8DlHMGzI+gGOJvpnInxMXfBu0zRLM5ChMkf/zC
         LZdQ==
X-Gm-Message-State: AOAM532vNk4UEXZWzXuI8ULBxCfmq4dljYVYhdkYziOB4UN84/X3XtYj
        h5B+KiV3e05l2cyYoMCJyvMwGR6rED2muM6yjLLwtVyyanNCgg==
X-Google-Smtp-Source: ABdhPJyzKU2f7teTlRfsIwBk8tYrh0u6u0X//xFRi3s/Q/mV9iQHAP6SFXS6wHN/rdL7Xii2Rbz3gFn/xYzithLNJPU=
X-Received: by 2002:a02:b199:: with SMTP id t25mr646738jah.124.1599093331024;
 Wed, 02 Sep 2020 17:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpVtb3Cks-LacZ865=C8r-_8ek1cy=n3SxELYGxvNgkPtw@mail.gmail.com>
 <511bcb5c-b089-ab4e-4424-a83c6e718bfa@huawei.com> <CAM_iQpW1c1TOKWLxm4uGvCUzK0mKKeDg1Y+3dGAC04pZXeCXcw@mail.gmail.com>
 <f81b534a-5845-ae7d-b103-434232c0f5ff@huawei.com>
In-Reply-To: <f81b534a-5845-ae7d-b103-434232c0f5ff@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 2 Sep 2020 17:35:19 -0700
Message-ID: <CAM_iQpXmpMdxF2JDOROaf+Tjk-8dASiXz53K-Ph_q7jVMe0oVw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 11:35 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2020/9/2 12:41, Cong Wang wrote:
> > On Tue, Sep 1, 2020 at 6:42 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> On 2020/9/2 2:24, Cong Wang wrote:
> >>> On Mon, Aug 31, 2020 at 5:59 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>>
> >>>> Currently there is concurrent reset and enqueue operation for the
> >>>> same lockless qdisc when there is no lock to synchronize the
> >>>> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
> >>>> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
> >>>> out-of-bounds access for priv->ring[] in hns3 driver if user has
> >>>> requested a smaller queue num when __dev_xmit_skb() still enqueue a
> >>>> skb with a larger queue_mapping after the corresponding qdisc is
> >>>> reset, and call hns3_nic_net_xmit() with that skb later.
> >>>
> >>> Can you be more specific here? Which call path requests a smaller
> >>> tx queue num? If you mean netif_set_real_num_tx_queues(), clearly
> >>> we already have a synchronize_net() there.
> >>
> >> When the netdevice is in active state, the synchronize_net() seems to
> >> do the correct work, as below:
> >>
> >> CPU 0:                                       CPU1:
> >> __dev_queue_xmit()                       netif_set_real_num_tx_queues()
> >> rcu_read_lock_bh();
> >> netdev_core_pick_tx(dev, skb, sb_dev);
> >>         .
> >>         .                               dev->real_num_tx_queues = txq;
> >>         .                                       .
> >>         .                                       .
> >>         .                               synchronize_net();
> >>         .                                       .
> >> q->enqueue()                                    .
> >>         .                                       .
> >> rcu_read_unlock_bh()                            .
> >>                                         qdisc_reset_all_tx_gt
> >>
> >>
> >
> > Right.
> >
> >
> >> but dev->real_num_tx_queues is not RCU-protected, maybe that is a problem
> >> too.
> >>
> >> The problem we hit is as below:
> >> In hns3_set_channels(), hns3_reset_notify(h, HNAE3_DOWN_CLIENT) is called
> >> to deactive the netdevice when user requested a smaller queue num, and
> >> txq->qdisc is already changed to noop_qdisc when calling
> >> netif_set_real_num_tx_queues(), so the synchronize_net() in the function
> >> netif_set_real_num_tx_queues() does not help here.
> >
> > How could qdisc still be running after deactivating the device?
>
> qdisc could be running during the device deactivating process.
>
> The main process of changing channel number is as below:
>
> 1. dev_deactivate()
> 2. hns3 handware related setup
> 3. netif_set_real_num_tx_queues()
> 4. netif_tx_wake_all_queues()
> 5. dev_activate()
>
> During step 1, qdisc could be running while qdisc is resetting, so
> there could be skb left in the old qdisc(which will be restored back to
> txq->qdisc during dev_activate()), as below:
>
> CPU 0:                                       CPU1:
> __dev_queue_xmit():                      dev_deactivate_many():
> rcu_read_lock_bh();                      qdisc_deactivate(qdisc);
> q = rcu_dereference_bh(txq->qdisc);             .
> netdev_core_pick_tx(dev, skb, sb_dev);          .
>         .
>         .                               rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
>         .                                       .
>         .                                       .
>         .                                       .
>         .                                       .
> q->enqueue()                                    .


Well, like I said, if the deactivated bit were tested before ->enqueue(),
there would be no packet queued after qdisc_deactivate().


>         .                                       .
> rcu_read_unlock_bh()                            .
>
> And During step 3, txq->qdisc is pointing to noop_qdisc, so the qdisc_reset()
> only reset the noop_qdisc, but not the actual qdisc, which is stored in
> txq->qdisc_sleeping, so the actual qdisc may still have skb.
>
> When hns3_link_status_change() call step 4 and 5, it will restore all queue's
> qdisc using txq->qdisc_sleeping and schedule all queue with net_tx_action().
> The skb enqueued in step 1 may be dequeued and run, which cause the problem.
>
> >
> >
> >>
> >>>
> >>>>
> >>>> Avoid the above concurrent op by calling synchronize_rcu_tasks()
> >>>> after assigning new qdisc to dev_queue->qdisc and before calling
> >>>> qdisc_deactivate() to make sure skb with larger queue_mapping
> >>>> enqueued to old qdisc will always be reset when qdisc_deactivate()
> >>>> is called.
> >>>
> >>> Like Eric said, it is not nice to call such a blocking function when
> >>> we have a large number of TX queues. Possibly we just need to
> >>> add a synchronize_net() as in netif_set_real_num_tx_queues(),
> >>> if it is missing.
> >>
> >> As above, the synchronize_net() in netif_set_real_num_tx_queues() seems
> >> to work when netdevice is in active state, but does not work when in
> >> deactive.
> >
> > Please explain why deactivated device still has qdisc running?
> >
> > At least before commit 379349e9bc3b4, we always test deactivate
> > bit before enqueueing. Are you complaining about that commit?
> > That commit is indeed suspicious, at least it does not precisely revert
> > commit ba27b4cdaaa66561aaedb21 as it claims.
>
> I am not familiar with TCQ_F_CAN_BYPASS.
> From my understanding, the problem is that there is no order between
> qdisc enqueuing and qdisc reset.

It has almost nothing to do with BYPASS, my point here is all about
__QDISC_STATE_DEACTIVATED bit, clearly commit 379349e9bc3b4
removed this bit test for lockless qdisc, whether intentionally or accidentally.
That bit test existed prior to BYPASS test, see commit ba27b4cdaaa665.

Thanks.
