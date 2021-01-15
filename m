Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8453F2F8806
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 23:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbhAOV5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 16:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbhAOV5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 16:57:18 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B994C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 13:56:38 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 18so6434511ybx.2
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 13:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9a1I29F0G5a8HDPOjdzlOrFwyCTERff5mMnkZyO1JxY=;
        b=LHlBM8bNnsJK4HPrGFD5sxYjOx75fPAP7BrrpxcwO6dkpzF9TWaRdxmd8+0p+cRTzZ
         eUohgzI67FBM+Y4CMqE5Bx21yvopxoj/Ncsrzo2//dVagwKEksDVjMfD+LKFuAzFqdP+
         YsHWpBH43NTW4o/rCr7g/XtLNUHXpzV6Wu3SWiDYW946naAKRi/UGs6EDMsV7q+IySoS
         LI/HdcqiYoe4FGBtEJqawq4/GoDgjKNDYrPOt3wt3IwmRGmJJhWPuB7kC+kZZedBcJhH
         X63vZLsrFeH99ykBCxo5xtr+7lBbcttgD8ch7fm8nPyYK91Y7Su0QifgdYIOX+Ab+ZHR
         lZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9a1I29F0G5a8HDPOjdzlOrFwyCTERff5mMnkZyO1JxY=;
        b=Dx3YyeR2+sDkdR4I6qGJDscRG/J9OCZPyeao6xDPfieERzAH6xqKSTI+uSVyZm7469
         vPGY/NUgg+gNoPpWBeJcTd8NjQCslzocDIa3gsNcKTpsZVkuM7kfUXSrosA/DuHHesag
         KmSlI1P0VMUe4qjN1dzfkZdyNm2Pb8hrUdhohRLR/hy1JLc4PaaxZua/qqtgii1nSBdJ
         yHZI69rDEs7vAlHzfNIWZQnpmk+2f/XNhoS2VRmQwmTGH/u4PcCVwbxukQmYwJoCymAJ
         BNMhYminf+RY28wt22pKzmavDnyVbcx1srHOy8HRpQdctyrCeU/Mdsor7nY1OGCMN7Cy
         Fx+Q==
X-Gm-Message-State: AOAM533/SwH4a7m7kyV3hQGjXQ6EnQnjIAMyUXSKM8x8+NahB9XXl2A1
        aKEXKOD6AKJu8pBx8kMImkdaVcDFtX7ebW854Kki2g==
X-Google-Smtp-Source: ABdhPJzR38z8GlEY3cXh4SYi2aU7uG7EMTfly33+2SVUevtvtQwkKNwP/DyLox+tcTQ5PUtDE92kktJetYqR5FN7xmI=
X-Received: by 2002:a5b:ac4:: with SMTP id a4mr21781058ybr.187.1610747797292;
 Fri, 15 Jan 2021 13:56:37 -0800 (PST)
MIME-Version: 1.0
References: <20210115003123.1254314-1-weiwan@google.com> <20210115003123.1254314-3-weiwan@google.com>
 <CAKgT0UdiBnLiGP=C0XKTpv-_Z-UTGSfkwtL-2QzHZS3AEkMbnA@mail.gmail.com> <CAEA6p_BxQG7ObXG2Qf=fe5ja1hQr_9B=1_0XAn5w+Cf5+YByog@mail.gmail.com>
In-Reply-To: <CAEA6p_BxQG7ObXG2Qf=fe5ja1hQr_9B=1_0XAn5w+Cf5+YByog@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 15 Jan 2021 13:56:25 -0800
Message-ID: <CAEA6p_Bwtk_bxOnH-=4r5SmZgNHb5eFPrxS6=5o46eYi0buxfg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 2/3] net: implement threaded-able napi poll
 loop support
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending the replies in plain text mode to avoid delivery failure.

On Fri, Jan 15, 2021 at 1:38 PM Wei Wang <weiwan@google.com> wrote:
>
>
>
> On Thu, Jan 14, 2021 at 7:14 PM Alexander Duyck <alexander.duyck@gmail.co=
m> wrote:
>>
>> On Thu, Jan 14, 2021 at 4:33 PM Wei Wang <weiwan@google.com> wrote:
>> >
>> > This patch allows running each napi poll loop inside its own
>> > kernel thread.
>> > The threaded mode could be enabled through napi_set_threaded()
>> > api, and does not require a device up/down. The kthread gets
>> > created on demand when napi_set_threaded() is called, and gets
>> > shut down eventually in napi_disable().
>> >
>> > Once that threaded mode is enabled and the kthread is
>> > started, napi_schedule() will wake-up such thread instead
>> > of scheduling the softirq.
>> >
>> > The threaded poll loop behaves quite likely the net_rx_action,
>> > but it does not have to manipulate local irqs and uses
>> > an explicit scheduling point based on netdev_budget.
>> >
>> > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
>> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>> > Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
>> > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
>> > Co-developed-by: Jakub Kicinski <kuba@kernel.org>
>> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> > Signed-off-by: Wei Wang <weiwan@google.com>
>> > ---
>> >  include/linux/netdevice.h |  12 ++--
>> >  net/core/dev.c            | 113 +++++++++++++++++++++++++++++++++++++=
+
>> >  2 files changed, 118 insertions(+), 7 deletions(-)
>> >
>> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> > index 5b949076ed23..c24ed232c746 100644
>> > --- a/include/linux/netdevice.h
>> > +++ b/include/linux/netdevice.h
>> > @@ -347,6 +347,7 @@ struct napi_struct {
>> >         struct list_head        dev_list;
>> >         struct hlist_node       napi_hash_node;
>> >         unsigned int            napi_id;
>> > +       struct task_struct      *thread;
>> >  };
>> >
>> >  enum {
>> > @@ -358,6 +359,7 @@ enum {
>> >         NAPI_STATE_NO_BUSY_POLL,        /* Do not add in napi_hash, no=
 busy polling */
>> >         NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NA=
PI */
>> >         NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over so=
ftirq processing*/
>> > +       NAPI_STATE_THREADED,            /* The poll is performed insid=
e its own thread*/
>> >  };
>> >
>> >  enum {
>> > @@ -369,6 +371,7 @@ enum {
>> >         NAPIF_STATE_NO_BUSY_POLL        =3D BIT(NAPI_STATE_NO_BUSY_POL=
L),
>> >         NAPIF_STATE_IN_BUSY_POLL        =3D BIT(NAPI_STATE_IN_BUSY_POL=
L),
>> >         NAPIF_STATE_PREFER_BUSY_POLL    =3D BIT(NAPI_STATE_PREFER_BUSY=
_POLL),
>> > +       NAPIF_STATE_THREADED            =3D BIT(NAPI_STATE_THREADED),
>> >  };
>> >
>> >  enum gro_result {
>> > @@ -510,13 +513,7 @@ void napi_disable(struct napi_struct *n);
>> >   * Resume NAPI from being scheduled on this context.
>> >   * Must be paired with napi_disable.
>> >   */
>> > -static inline void napi_enable(struct napi_struct *n)
>> > -{
>> > -       BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
>> > -       smp_mb__before_atomic();
>> > -       clear_bit(NAPI_STATE_SCHED, &n->state);
>> > -       clear_bit(NAPI_STATE_NPSVC, &n->state);
>> > -}
>> > +void napi_enable(struct napi_struct *n);
>>
>> If you are reducing the function to just a prototype it might make
>> sense to move the doxygen comments to the definition of the function
>> rather than leaving them here. That way when you change the
>> functionality it is easier to update the comments as it is all in the
>> same place.
>>
>> >
>> >  /**
>> >   *     napi_synchronize - wait until NAPI is not running
>> > @@ -2140,6 +2137,7 @@ struct net_device {
>> >         struct lock_class_key   *qdisc_tx_busylock;
>> >         struct lock_class_key   *qdisc_running_key;
>> >         bool                    proto_down;
>> > +       bool                    threaded;
>> >         unsigned                wol_enabled:1;
>>
>> I would prefer to see this done like the wol_enabled  as a bit field
>> or at least converted to a u8 instead of a bool. Last I knew we
>> weren't really supposed to use bool in structures since some
>> architectures will make it a 32b value.
>>
>>
>> >         struct list_head        net_notifier_list;
>> > diff --git a/net/core/dev.c b/net/core/dev.c
>> > index 83b59e4c0f37..edcfec1361e9 100644
>> > --- a/net/core/dev.c
>> > +++ b/net/core/dev.c
>> > @@ -91,6 +91,7 @@
>> >  #include <linux/etherdevice.h>
>> >  #include <linux/ethtool.h>
>> >  #include <linux/skbuff.h>
>> > +#include <linux/kthread.h>
>> >  #include <linux/bpf.h>
>> >  #include <linux/bpf_trace.h>
>> >  #include <net/net_namespace.h>
>> > @@ -1493,6 +1494,36 @@ void netdev_notify_peers(struct net_device *dev=
)
>> >  }
>> >  EXPORT_SYMBOL(netdev_notify_peers);
>> >
>> > +static int napi_threaded_poll(void *data);
>> > +
>> > +static int napi_kthread_create(struct napi_struct *n)
>> > +{
>> > +       int err =3D 0;
>> > +
>> > +       /* Create and wake up the kthread once to put it in
>> > +        * TASK_INTERRUPTIBLE mode to avoid the blocked task
>> > +        * warning and work with loadavg.
>> > +        */
>> > +       n->thread =3D kthread_run(napi_threaded_poll, n, "napi/%s-%d",
>> > +                               n->dev->name, n->napi_id);
>> > +       if (IS_ERR(n->thread)) {
>> > +               err =3D PTR_ERR(n->thread);
>> > +               pr_err("kthread_run failed with err %d\n", err);
>> > +               n->thread =3D NULL;
>> > +       }
>> > +
>> > +       return err;
>> > +}
>> > +
>> > +static void napi_kthread_stop(struct napi_struct *n)
>> > +{
>> > +       if (!n->thread)
>> > +               return;
>>
>> I would add a blank line after this if statement.
>>
>> > +       kthread_stop(n->thread);
>> > +       clear_bit(NAPI_STATE_THREADED, &n->state);
>> > +       n->thread =3D NULL;
>> > +}
>> > +
>> >  static int __dev_open(struct net_device *dev, struct netlink_ext_ack =
*extack)
>> >  {
>> >         const struct net_device_ops *ops =3D dev->netdev_ops;
>> > @@ -4252,6 +4283,11 @@ int gro_normal_batch __read_mostly =3D 8;
>> >  static inline void ____napi_schedule(struct softnet_data *sd,
>> >                                      struct napi_struct *napi)
>> >  {
>> > +       if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
>> > +               wake_up_process(napi->thread);
>> > +               return;
>> > +       }
>> > +
>> >         list_add_tail(&napi->poll_list, &sd->poll_list);
>> >         __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>> >  }
>> > @@ -6697,6 +6733,27 @@ static void init_gro_hash(struct napi_struct *n=
api)
>> >         napi->gro_bitmask =3D 0;
>> >  }
>> >
>> > +static int napi_set_threaded(struct napi_struct *n, bool threaded)
>> > +{
>> > +       int err =3D 0;
>> > +
>> > +       if (threaded =3D=3D !!test_bit(NAPI_STATE_THREADED, &n->state)=
)
>> > +               return 0;
>>
>> A blank line between these two statements might be nice.
>>
>> > +       if (threaded) {
>> > +               if (!n->thread) {
>> > +                       err =3D napi_kthread_create(n);
>> > +                       if (err)
>> > +                               goto out;
>> > +               }
>> > +               set_bit(NAPI_STATE_THREADED, &n->state);
>> > +       } else {
>> > +               clear_bit(NAPI_STATE_THREADED, &n->state);
>> > +       }
>>
>> You could probably flatten this bit by doing:
>> if (!threaded) {
>>     clear_bit(NAPI_STATE_THREADED, &n->state);
>>     return 0;
>> }
>>
>> Then you could just pull the rest of this out of the if statement and
>> flatten it a bit.
>
>
>
> Ack for all comments before this. Will update in next version.
>
>>
>>
>> > +
>> > +out:
>> > +       return err;
>> > +}
>> > +
>> >  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>> >                     int (*poll)(struct napi_struct *, int), int weight=
)
>> >  {
>> > @@ -6738,12 +6795,23 @@ void napi_disable(struct napi_struct *n)
>> >                 msleep(1);
>> >
>> >         hrtimer_cancel(&n->timer);
>> > +       napi_kthread_stop(n);
>> >
>> >         clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
>> >         clear_bit(NAPI_STATE_DISABLE, &n->state);
>> >  }
>> >  EXPORT_SYMBOL(napi_disable);
>> >
>> > +void napi_enable(struct napi_struct *n)
>> > +{
>> > +       BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
>> > +       smp_mb__before_atomic();
>> > +       clear_bit(NAPI_STATE_SCHED, &n->state);
>> > +       clear_bit(NAPI_STATE_NPSVC, &n->state);
>> > +       WARN_ON(napi_set_threaded(n, n->dev->threaded));
>>
>> I am not sure what the point is in having a return value if you are
>> just using it to trigger a WARN_ON. It might make more sense to
>> actually set the WARN_ON inside of napi_set_threaded instead of having
>> it here as you could then identify the error much more easily. Or for
>> that matter you might be able to use something like pr_warn which
>> would allow you a more detailed message about the specific netdev that
>> experienced the failure.
>
>
> This function is called from modify_napi_threaded() from sysfs path. The =
return value is used from that path.
>
>>
>>
>> > +}
>> > +EXPORT_SYMBOL(napi_enable);
>> > +
>> >  static void flush_gro_hash(struct napi_struct *napi)
>> >  {
>> >         int i;
>> > @@ -6866,6 +6934,51 @@ static int napi_poll(struct napi_struct *n, str=
uct list_head *repoll)
>> >         return work;
>> >  }
>> >
>> > +static int napi_thread_wait(struct napi_struct *napi)
>> > +{
>> > +       set_current_state(TASK_INTERRUPTIBLE);
>> > +
>> > +       while (!kthread_should_stop() && !napi_disable_pending(napi)) =
{
>> > +               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
>> > +                       WARN_ON(!list_empty(&napi->poll_list));
>> > +                       __set_current_state(TASK_RUNNING);
>> > +                       return 0;
>> > +               }
>> > +
>> > +               schedule();
>> > +               set_current_state(TASK_INTERRUPTIBLE);
>> > +       }
>> > +       __set_current_state(TASK_RUNNING);
>> > +       return -1;
>> > +}
>> > +
>> > +static int napi_threaded_poll(void *data)
>> > +{
>> > +       struct napi_struct *napi =3D data;
>> > +       void *have;
>> > +
>> > +       while (!napi_thread_wait(napi)) {
>> > +               for (;;) {
>> > +                       bool repoll =3D false;
>> > +
>> > +                       local_bh_disable();
>> > +
>> > +                       have =3D netpoll_poll_lock(napi);
>> > +                       __napi_poll(napi, &repoll);
>> > +                       netpoll_poll_unlock(have);
>> > +
>>
>> So it looks like v3 of this patch set was making use of the budget but
>> for v4 that went away and you had this. I was wondering why? One thing
>> that seems odd to me is that we are limiting the device to only
>
>
> In v3, the bugdet existed in the previous proposed patch from Paolo. It a=
lso got modified to this same implementation in patch 4 in v3.
>
>>
>> clearing one NAPI_POLL_WEIGHT of packets between flushing the freed
>> skbs and reenabling the bottom halves.
>>
>>
>> I'm wondering if it might make more sense to have a tunable like
>> netdev_budget that could be used for this to allow for more time
>> between flushes, bh enables, and cond_resched checks.
>
>
> I think this depends on how long we want to keep the CPU before yielding.=
 And I think there is a slight difference between this function vs napi_sch=
edule() called from net_rx_action().
> net_rx_action() has a 'budget' parameter. But in that function, there are=
 potentially multiple napi instances queued. And for each napi, it only get=
s polled for max of NAPI_POLL_WEIGHT as well. The 'bugdet' is actually cont=
rolling how many napi instances to poll at most.
> In napi_threaded_poll(), it is only responsible for polling 1 napi instan=
ce. So the behavior here is somewhat consistent: the napi instance gets pol=
led once before reenabling bottem half, and yeild ng the CPU.
>
>>
>>
>> > +                       __kfree_skb_flush();
>> > +                       local_bh_enable();
>> > +
>> > +                       if (!repoll)
>> > +                               break;
>> > +
>> > +                       cond_resched();
>> > +               }
>> > +       }
>> > +       return 0;
>> > +}
>> > +
>> >  static __latent_entropy void net_rx_action(struct softirq_action *h)
>> >  {
>> >         struct softnet_data *sd =3D this_cpu_ptr(&softnet_data);
>> > --
>> > 2.30.0.284.gd98b1dd5eaa7-goog
>> >
