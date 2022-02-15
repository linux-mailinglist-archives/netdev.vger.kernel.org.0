Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45ED4B60B4
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 03:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbiBOCDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 21:03:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbiBOCC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 21:02:59 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97D095A0B
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 18:01:30 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id q17so1858888edd.4
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 18:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jG8rCXs2NvaQH8KTNUhKRickItf3v5zGsPDGG5xiOLI=;
        b=A930BIpMu0SgJAKnz8IQyZSizDs8LAPINdvGq2V/W/dSpPom/ukw2uPZCSVDJx3NuI
         fHCwfwzk+GfvoNNd28Kza/jtN+uETuZ7A3D1TV8TIg3/mehDNfd8q9oMAZdAqiAyN8jn
         H/O4CF4T6DL1YdGh79GZhgS1ahAWfQ36GCGdfFolZ+8M1s5Jg2z2iJLmcFBNoN0ZUecN
         0s6NSDoIMjValYdYxE3Y23zJhl3X2JR0oKQUsmTmJIfyrZu+2zSNcrehZYihr9qKbwsz
         +Yn2HOCYjHfOJsOY84pYqCLUUq9c8kyX1kcxUDuBQKdh7RvF3Ob5fvOhaO3ANa/8e23K
         xusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jG8rCXs2NvaQH8KTNUhKRickItf3v5zGsPDGG5xiOLI=;
        b=lnN1Pav+6GxCAN+uZr+Miq1er5Zfbzv/zL9QZsd5jhelJsbo9mqWsg1CD/XWxEjI0T
         tUQd64BsD4RVDPapfxakm2c27N2WdSvhjaWuE8JtVTJ6b61uzR4X9k7rxcSvIR51FsT2
         RjHNeNpzfY/OR8E0ARBQOPECpeL4c/9xPHFMENsiyI8Mi+opWyRsd/lZEiNq0vtvlKdU
         OJDgLA7f0FUaZ94aPpykyRLVUGV106BHdlEBCnde5lpESLoTf2Tg9eh05xHLX6r699N0
         L4fekdsG0LM2JGY0s+eE3pFqKlrT782AQny/8Za7buE4C/cw9GVzbSvoWy8Z2ogq9p64
         wTWg==
X-Gm-Message-State: AOAM5300zKIc/hr6lJG2PZWtQoxLAxlXZUDnOGJR++ioTPGlalvIJbjf
        jE9d/TWATPlf6SrBR1RzihmkzNhDJNih2y2MUO0=
X-Google-Smtp-Source: ABdhPJxKItCLwpN/9b/0xzBlutsczrD9JcttOd+I99WSk6ApaqdNtvndYbU1qQs5kQzTKCQbESUaAdOD79y2vlSjDJY=
X-Received: by 2002:aa7:c78e:: with SMTP id n14mr1706364eds.423.1644890488875;
 Mon, 14 Feb 2022 18:01:28 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-2-xiangxia.m.yue@gmail.com> <b2ec623c-3b2a-3edb-804a-ca2ffd4fe182@mojatatu.com>
In-Reply-To: <b2ec623c-3b2a-3edb-804a-ca2ffd4fe182@mojatatu.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 15 Feb 2022 10:00:52 +0800
Message-ID: <CAMDZJNWSVKDjfRxKubfW_XR5U8knv1zvkaGqE3E8GgJqQLVf2g@mail.gmail.com>
Subject: Re: [net-next v8 1/2] net: sched: use queue_mapping to pick tx queue
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 8:14 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
>
> On 2022-01-26 09:32, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch fixes issue:
> > * If we install tc filters with act_skbedit in clsact hook.
> >    It doesn't work, because netdev_core_pick_tx() overwrites
> >    queue_mapping.
> >
> >    $ tc filter ... action skbedit queue_mapping 1
>
> This seems reasonable but your explanation below is confusing. You
> mention things like xps which apply in the opposite direction.
As I understand, xps is used for CPU-to-queue. The skbedit
queue_mapping is used for tx patch too.

> Can you please help clarify?
> If i understand correctly you are interested in separating the
> bulk vs latency sensitive traffic into different queues on
> outgoing packets, the traditional way of doing this is setting
> skb->priority; a lot of traditional hardware mechanisms and even
> qdiscs in s/w are already mapped to handle this (and cgroup
> priority is also nicely mapped to handle that).
why we don't use the skb->priority?
1. the application developer may use skb->priority. We can't require
them to change that. if the application sets priority, the cgroup
priority doesn't work.
2. it's easy to use the tc powerful filter to classify packets and
then do the action.
3. patch 2/2 will use skbedit action to do balance in tx queue range.
>
> The diagram shows traffic coming out of the pods towards
> the wire. Out of curiosity:
> What is the underlying driver that is expecting queue map to
> be maintained for queue selection?
In our production env, we use the ixgbe, i40e and mlx nic which
support multi tx queue.
>
> cheers,
> jamal
>
> >
> > And this patch is useful:
> > * We can use FQ + EDT to implement efficient policies. Tx queues
> >    are picked by xps, ndo_select_queue of netdev driver, or skb hash
> >    in netdev_core_pick_tx(). In fact, the netdev driver, and skb
> >    hash are _not_ under control. xps uses the CPUs map to select Tx
> >    queues, but we can't figure out which task_struct of pod/containter
> >    running on this cpu in most case. We can use clsact filters to classify
> >    one pod/container traffic to one Tx queue. Why ?
> >
> >    In containter networking environment, there are two kinds of pod/
> >    containter/net-namespace. One kind (e.g. P1, P2), the high throughput
> >    is key in these applications. But avoid running out of network resource,
> >    the outbound traffic of these pods is limited, using or sharing one
> >    dedicated Tx queues assigned HTB/TBF/FQ Qdisc. Other kind of pods
> >    (e.g. Pn), the low latency of data access is key. And the traffic is not
> >    limited. Pods use or share other dedicated Tx queues assigned FIFO Qdisc.
> >    This choice provides two benefits. First, contention on the HTB/FQ Qdisc
> >    lock is significantly reduced since fewer CPUs contend for the same queue.
> >    More importantly, Qdisc contention can be eliminated completely if each
> >    CPU has its own FIFO Qdisc for the second kind of pods.
> >
> >    There must be a mechanism in place to support classifying traffic based on
> >    pods/container to different Tx queues. Note that clsact is outside of Qdisc
> >    while Qdisc can run a classifier to select a sub-queue under the lock.
> >
> >    In general recording the decision in the skb seems a little heavy handed.
> >    This patch introduces a per-CPU variable, suggested by Eric.
> >
> >    The xmit.skip_txqueue flag is firstly cleared in __dev_queue_xmit().
> >    - Tx Qdisc may install that skbedit actions, then xmit.skip_txqueue flag
> >      is set in qdisc->enqueue() though tx queue has been selected in
> >      netdev_tx_queue_mapping() or netdev_core_pick_tx(). That flag is cleared
> >      firstly in __dev_queue_xmit(), is useful:
> >    - Avoid picking Tx queue with netdev_tx_queue_mapping() in next netdev
> >      in such case: eth0 macvlan - eth0.3 vlan - eth0 ixgbe-phy:
> >      For example, eth0, macvlan in pod, which root Qdisc install skbedit
> >      queue_mapping, send packets to eth0.3, vlan in host. In __dev_queue_xmit() of
> >      eth0.3, clear the flag, does not select tx queue according to skb->queue_mapping
> >      because there is no filters in clsact or tx Qdisc of this netdev.
> >      Same action taked in eth0, ixgbe in Host.
> >    - Avoid picking Tx queue for next packet. If we set xmit.skip_txqueue
> >      in tx Qdisc (qdisc->enqueue()), the proper way to clear it is clearing it
> >      in __dev_queue_xmit when processing next packets.
> >
> >    For performance reasons, use the static key. If user does not config the NET_EGRESS,
> >    the patch will not be compiled.
> >
> >    +----+      +----+      +----+
> >    | P1 |      | P2 |      | Pn |
> >    +----+      +----+      +----+
> >      |           |           |
> >      +-----------+-----------+
> >                  |
> >                  | clsact/skbedit
> >                  |      MQ
> >                  v
> >      +-----------+-----------+
> >      | q0        | q1        | qn
> >      v           v           v
> >    HTB/FQ      HTB/FQ  ...  FIFO
> >
> > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > Cc: Cong Wang <xiyou.wangcong@gmail.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Alexander Lobakin <alobakin@pm.me>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Talal Ahmad <talalahmad@google.com>
> > Cc: Kevin Hao <haokexin@gmail.com>
> > Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Cc: Antoine Tenart <atenart@kernel.org>
> > Cc: Wei Wang <weiwan@google.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >   include/linux/netdevice.h |  3 +++
> >   include/linux/rtnetlink.h |  1 +
> >   net/core/dev.c            | 31 +++++++++++++++++++++++++++++--
> >   net/sched/act_skbedit.c   |  6 +++++-
> >   4 files changed, 38 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index e490b84732d1..60e14b2b091d 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3015,6 +3015,9 @@ struct softnet_data {
> >       struct {
> >               u16 recursion;
> >               u8  more;
> > +#ifdef CONFIG_NET_EGRESS
> > +             u8  skip_txqueue;
> > +#endif
> >       } xmit;
> >   #ifdef CONFIG_RPS
> >       /* input_queue_head should be written by cpu owning this struct,
> > diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
> > index bb9cb84114c1..e87c2dccc4d5 100644
> > --- a/include/linux/rtnetlink.h
> > +++ b/include/linux/rtnetlink.h
> > @@ -100,6 +100,7 @@ void net_dec_ingress_queue(void);
> >   #ifdef CONFIG_NET_EGRESS
> >   void net_inc_egress_queue(void);
> >   void net_dec_egress_queue(void);
> > +void netdev_xmit_skip_txqueue(bool skip);
> >   #endif
> >
> >   void rtnetlink_init(void);
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 1baab07820f6..842473fa8e9f 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3860,6 +3860,25 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> >
> >       return skb;
> >   }
> > +
> > +static struct netdev_queue *
> > +netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
> > +{
> > +     int qm = skb_get_queue_mapping(skb);
> > +
> > +     return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
> > +}
> > +
> > +static bool netdev_xmit_txqueue_skipped(void)
> > +{
> > +     return __this_cpu_read(softnet_data.xmit.skip_txqueue);
> > +}
> > +
> > +void netdev_xmit_skip_txqueue(bool skip)
> > +{
> > +     __this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
> > +}
> > +EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
> >   #endif /* CONFIG_NET_EGRESS */
> >
> >   #ifdef CONFIG_XPS
> > @@ -4030,7 +4049,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
> >   static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >   {
> >       struct net_device *dev = skb->dev;
> > -     struct netdev_queue *txq;
> > +     struct netdev_queue *txq = NULL;
> >       struct Qdisc *q;
> >       int rc = -ENOMEM;
> >       bool again = false;
> > @@ -4058,11 +4077,17 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >                       if (!skb)
> >                               goto out;
> >               }
> > +
> > +             netdev_xmit_skip_txqueue(false);
> > +
> >               nf_skip_egress(skb, true);
> >               skb = sch_handle_egress(skb, &rc, dev);
> >               if (!skb)
> >                       goto out;
> >               nf_skip_egress(skb, false);
> > +
> > +             if (netdev_xmit_txqueue_skipped())
> > +                     txq = netdev_tx_queue_mapping(dev, skb);
> >       }
> >   #endif
> >       /* If device/qdisc don't need skb->dst, release it right now while
> > @@ -4073,7 +4098,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >       else
> >               skb_dst_force(skb);
> >
> > -     txq = netdev_core_pick_tx(dev, skb, sb_dev);
> > +     if (likely(!txq))
> > +             txq = netdev_core_pick_tx(dev, skb, sb_dev);
> > +
> >       q = rcu_dereference_bh(txq->qdisc);
> >
> >       trace_net_dev_queue(skb);
> > diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> > index ceba11b198bb..d5799b4fc499 100644
> > --- a/net/sched/act_skbedit.c
> > +++ b/net/sched/act_skbedit.c
> > @@ -58,8 +58,12 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
> >               }
> >       }
> >       if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
> > -         skb->dev->real_num_tx_queues > params->queue_mapping)
> > +         skb->dev->real_num_tx_queues > params->queue_mapping) {
> > +#ifdef CONFIG_NET_EGRESS
> > +             netdev_xmit_skip_txqueue(true);
> > +#endif
> >               skb_set_queue_mapping(skb, params->queue_mapping);
> > +     }
> >       if (params->flags & SKBEDIT_F_MARK) {
> >               skb->mark &= ~params->mask;
> >               skb->mark |= params->mark & params->mask;
>


-- 
Best regards, Tonghao
