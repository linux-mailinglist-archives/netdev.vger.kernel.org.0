Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D348125B8EC
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 04:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgICCxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 22:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgICCxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 22:53:51 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC25C061244;
        Wed,  2 Sep 2020 19:53:51 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id b16so1164398ioj.4;
        Wed, 02 Sep 2020 19:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1LDDxx4tHLsuDP2B1AxfiZi8mRN/AWGoz3+SWGn04vU=;
        b=Ri2EagaVjzT6bMJ1TvSn8Ga4mdesq7dEUaTQ0UMWE3QN8HWHdPO7b44zMgiiRdLXqP
         FqS7yT7zDf6ET4I9KwmdJea1ElUopaD4yjibx2JLuAWfJH9WVQbd8vLin65JGP4qtNz+
         MKuG7e6GY8i/I1Ht89fmIGpz9u+O0ePniSmcy3eI2kPnchIVlpWLMDUPyQU5pL9JFlnk
         ArkYQ8es3zO59QvfUiF/fP+2CeU0pn2BhVxDkiHA/llf/uheqT6Gp8XSrcGU6ZizPMKj
         wU2OSSxCm6WQ0NogSUonLeb7y3q1TwqQyZM1I0pQMyjMT3VDvj1jxkISkxkmNWB43F+7
         it5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1LDDxx4tHLsuDP2B1AxfiZi8mRN/AWGoz3+SWGn04vU=;
        b=jvXHk91BaokIW7keU/kX2ZjofniCbZ/CR1Vc2kj+yVZKSaofYIzu/Znv6yfKq1WJk1
         aByo0XnMg9qQrg5URXJ6pcTqUJF4rhngV7xxlHJ8YiL0SA7leE00KtAhT5T9FnmYpMVg
         yFP23UtCOYhls+p5rbqSADASTtuOLTAiOXjrmhQf/LZVXHqJQcEjTuX0StP9DVy4u5+C
         kr2AgKcNIrHo1N3760wc0H5M/vFepwHuPxvhQLikzBtM8RybveIeaI6kIT4hlWrqx0Iy
         Jf+bvuuXw4l2ckWUExgkQKxpX6ktnwDj1E7TQ1qzhzMWVDuHEyBZzrjgOuwvGqPK5IhU
         nelw==
X-Gm-Message-State: AOAM533LjezZdfiJn5JMdyLvYEGjf1bfeQ+k+svVAMiR+sScidTppiOs
        J7I2BO+r9gIqKkhX/zrWnhreyc5odpvUc/jCXiA=
X-Google-Smtp-Source: ABdhPJxy3wR43bAOPYilrd/MYB0OxlNoUb4B4AEAPuxO8J4QGSZ0RgRelOghi1F00ziUBa1W5Lpe40hlBNCsC/3OBXs=
X-Received: by 2002:a5d:980f:: with SMTP id a15mr1259884iol.12.1599101629799;
 Wed, 02 Sep 2020 19:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpVtb3Cks-LacZ865=C8r-_8ek1cy=n3SxELYGxvNgkPtw@mail.gmail.com>
 <511bcb5c-b089-ab4e-4424-a83c6e718bfa@huawei.com> <CAM_iQpW1c1TOKWLxm4uGvCUzK0mKKeDg1Y+3dGAC04pZXeCXcw@mail.gmail.com>
 <f81b534a-5845-ae7d-b103-434232c0f5ff@huawei.com> <CAM_iQpXmpMdxF2JDOROaf+Tjk-8dASiXz53K-Ph_q7jVMe0oVw@mail.gmail.com>
 <cd773132-c98e-18e1-67fd-bbef6babbf0f@huawei.com> <CAM_iQpWbZdh5-UGBi6PM19EBgV+Bq7vmifgJPdak6X=R9yztnw@mail.gmail.com>
 <c0543793-11fa-6ef1-f8ea-6a724ab2de8f@huawei.com>
In-Reply-To: <c0543793-11fa-6ef1-f8ea-6a724ab2de8f@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 2 Sep 2020 19:53:38 -0700
Message-ID: <CAM_iQpWGaTSkg+-Em6u=NSWcyswX-xN=-1p0OAdaR___U1M4rg@mail.gmail.com>
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

On Wed, Sep 2, 2020 at 7:22 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2020/9/3 9:48, Cong Wang wrote:
> > On Wed, Sep 2, 2020 at 6:22 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> On 2020/9/3 8:35, Cong Wang wrote:
> >>> On Tue, Sep 1, 2020 at 11:35 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>>
> >>>> On 2020/9/2 12:41, Cong Wang wrote:
> >>>>> On Tue, Sep 1, 2020 at 6:42 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>>>>
> >>>>>> On 2020/9/2 2:24, Cong Wang wrote:
> >>>>>>> On Mon, Aug 31, 2020 at 5:59 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>>>>>>
> >>>>>>>> Currently there is concurrent reset and enqueue operation for the
> >>>>>>>> same lockless qdisc when there is no lock to synchronize the
> >>>>>>>> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
> >>>>>>>> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
> >>>>>>>> out-of-bounds access for priv->ring[] in hns3 driver if user has
> >>>>>>>> requested a smaller queue num when __dev_xmit_skb() still enqueue a
> >>>>>>>> skb with a larger queue_mapping after the corresponding qdisc is
> >>>>>>>> reset, and call hns3_nic_net_xmit() with that skb later.
> >>>>>>>
> >>>>>>> Can you be more specific here? Which call path requests a smaller
> >>>>>>> tx queue num? If you mean netif_set_real_num_tx_queues(), clearly
> >>>>>>> we already have a synchronize_net() there.
> >>>>>>
> >>>>>> When the netdevice is in active state, the synchronize_net() seems to
> >>>>>> do the correct work, as below:
> >>>>>>
> >>>>>> CPU 0:                                       CPU1:
> >>>>>> __dev_queue_xmit()                       netif_set_real_num_tx_queues()
> >>>>>> rcu_read_lock_bh();
> >>>>>> netdev_core_pick_tx(dev, skb, sb_dev);
> >>>>>>         .
> >>>>>>         .                               dev->real_num_tx_queues = txq;
> >>>>>>         .                                       .
> >>>>>>         .                                       .
> >>>>>>         .                               synchronize_net();
> >>>>>>         .                                       .
> >>>>>> q->enqueue()                                    .
> >>>>>>         .                                       .
> >>>>>> rcu_read_unlock_bh()                            .
> >>>>>>                                         qdisc_reset_all_tx_gt
> >>>>>>
> >>>>>>
> >>>>>
> >>>>> Right.
> >>>>>
> >>>>>
> >>>>>> but dev->real_num_tx_queues is not RCU-protected, maybe that is a problem
> >>>>>> too.
> >>>>>>
> >>>>>> The problem we hit is as below:
> >>>>>> In hns3_set_channels(), hns3_reset_notify(h, HNAE3_DOWN_CLIENT) is called
> >>>>>> to deactive the netdevice when user requested a smaller queue num, and
> >>>>>> txq->qdisc is already changed to noop_qdisc when calling
> >>>>>> netif_set_real_num_tx_queues(), so the synchronize_net() in the function
> >>>>>> netif_set_real_num_tx_queues() does not help here.
> >>>>>
> >>>>> How could qdisc still be running after deactivating the device?
> >>>>
> >>>> qdisc could be running during the device deactivating process.
> >>>>
> >>>> The main process of changing channel number is as below:
> >>>>
> >>>> 1. dev_deactivate()
> >>>> 2. hns3 handware related setup
> >>>> 3. netif_set_real_num_tx_queues()
> >>>> 4. netif_tx_wake_all_queues()
> >>>> 5. dev_activate()
> >>>>
> >>>> During step 1, qdisc could be running while qdisc is resetting, so
> >>>> there could be skb left in the old qdisc(which will be restored back to
> >>>> txq->qdisc during dev_activate()), as below:
> >>>>
> >>>> CPU 0:                                       CPU1:
> >>>> __dev_queue_xmit():                      dev_deactivate_many():
> >>>> rcu_read_lock_bh();                      qdisc_deactivate(qdisc);
> >>>> q = rcu_dereference_bh(txq->qdisc);             .
> >>>> netdev_core_pick_tx(dev, skb, sb_dev);          .
> >>>>         .
> >>>>         .                               rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
> >>>>         .                                       .
> >>>>         .                                       .
> >>>>         .                                       .
> >>>>         .                                       .
> >>>> q->enqueue()                                    .
> >>>
> >>>
> >>> Well, like I said, if the deactivated bit were tested before ->enqueue(),
> >>> there would be no packet queued after qdisc_deactivate().
> >>
> >> Only if the deactivated bit testing is also protected by qdisc->seqlock?
> >> otherwise there is still window between setting and testing the deactivated bit.
> >
> > Can you be more specific here? Why testing or setting a bit is not atomic?
>
> testing a bit or setting a bit separately is atomic.
> But testing a bit and setting a bit is not atomic, right?
>
>   cpu0:                   cpu1:
>                         testing A bit
> setting A bit                .
>        .                     .
>        .               qdisc enqueuing
> qdisc reset
>

Well, this was not a problem until commit d518d2ed8640c1cbbb.
Prior to that commit, qdsic can still be scheduled even with this
race condition, that is, the packet just enqueued after resetting can
still be dequeued with qdisc_run().

It is amazing to see how messy the lockless qdisc is now.

Thanks.
