Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254B647AB4D
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 15:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhLTOc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 09:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbhLTOc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 09:32:26 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A561C061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 06:32:26 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id w16so10667172edc.11
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 06:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZWHFxnAdlx7SUM4aneujVFnGt2hNYpm1dgWO2W1LkKM=;
        b=CJ6h9bT8sVRvu2A5S95h8+vAMnhwsKwPSWRzwzo9l9kio7SzFFrvrEfrx151LmZQsG
         b2TpXgNMlLRMW3ciiIm0BREt27kMxVikpyjZ1BN0Mtm9vcWoqy+q94JSXHCNj3UnWekM
         m7TudAhBAodGeFmQssCgO8KUdFweqPLj1xB1ml7pemeb/GxUsL/9xZBhEnSjWh7dyBF8
         pHNLJMMUiS9rt5rvzpwvOojtMK1AtdBc6eSaRqYgH7dRpPXF0NcivVqsvS/s3GKKG0hB
         L2oclu5JDEYUUl1BJTeFWdQcKrz9ePGqlolZrcWtkyQ1YYIw7PtHsxTol3MUfiMhhC5d
         koig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZWHFxnAdlx7SUM4aneujVFnGt2hNYpm1dgWO2W1LkKM=;
        b=M/XrCAdVVTlRjzz/7gScvlnDiBo9k+NvoEIt3a/MEWITmxMHNrYVx0UoyQmTN0uY8y
         bxKT3vPrSptgisEyDcYKND+pUVUKfxgaJm3i5F/tAE377bLnG+nf79okzGJEMfB/HWA3
         ojKrLHRsGHNVTCqkGT5Dp6OPspyUlNsf6Wf7+fPqP8r27xNmklWqppgmCaQzbyrG74nP
         4mtAbrN+lupw27QGIH5R8gAB0ILjrhXNESOGlRAYx7eZ8SZLhkYevLVYv9K46B/jsE79
         EN71bhBH+VFvbBEVRSKsAJLx2dO1aQwFEg1C4SS7NjWaJqTiBZ94WLLDcnEWljHJSM+F
         udhg==
X-Gm-Message-State: AOAM531x842Ms3jetLbuvJyrRT4tGCc3wILn6pJbrbQkEGUpJJkEdlr8
        3VhFFobV0HUQfzVia1YLVK3Pz5U+ZenKCDHoviU=
X-Google-Smtp-Source: ABdhPJyBhRIxuU7gPkCBxwVTCSra+7sZiKJ1qq8z9T7fqEyCbkTkprdnUcBi45+IbGFAe5q4oQiXq6XYjB9UGYyHixM=
X-Received: by 2002:a05:6402:74c:: with SMTP id p12mr162047edy.140.1640010744666;
 Mon, 20 Dec 2021 06:32:24 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
 <20211220123839.54664-2-xiangxia.m.yue@gmail.com> <CANn89iLdP061LMUN-gRA8z4=YgMpbxTt7=3_Ny9ZWfKHTA2cpg@mail.gmail.com>
 <CAMDZJNUbJ39w3VTkJnwpRXewcaM-gM8kPck82ThxpAfTJKbGLw@mail.gmail.com>
In-Reply-To: <CAMDZJNUbJ39w3VTkJnwpRXewcaM-gM8kPck82ThxpAfTJKbGLw@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 20 Dec 2021 22:31:48 +0800
Message-ID: <CAMDZJNWLjvV_SfEmLr5FwLx2gcg4FrHqvp1q+fA2AXwAvTCLDg@mail.gmail.com>
Subject: Re: [net-next v5 1/2] net: sched: use queue_mapping to pick tx queue
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On Mon, Dec 20, 2021 at 10:21 PM Tonghao Zhang
<xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Dec 20, 2021 at 9:58 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Dec 20, 2021 at 4:38 AM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > This patch fixes issue:
> > > * If we install tc filters with act_skbedit in clsact hook.
> > >   It doesn't work, because netdev_core_pick_tx() overwrites
> > >   queue_mapping.
> > >
> > >   $ tc filter ... action skbedit queue_mapping 1
> > >
> > > And this patch is useful:
> > > * We can use FQ + EDT to implement efficient policies. Tx queues
> > >   are picked by xps, ndo_select_queue of netdev driver, or skb hash
> > >   in netdev_core_pick_tx(). In fact, the netdev driver, and skb
> > >   hash are _not_ under control. xps uses the CPUs map to select Tx
> > >   queues, but we can't figure out which task_struct of pod/containter
> > >   running on this cpu in most case. We can use clsact filters to classify
> > >   one pod/container traffic to one Tx queue. Why ?
> > >
> > >   In containter networking environment, there are two kinds of pod/
> > >   containter/net-namespace. One kind (e.g. P1, P2), the high throughput
> > >   is key in these applications. But avoid running out of network resource,
> > >   the outbound traffic of these pods is limited, using or sharing one
> > >   dedicated Tx queues assigned HTB/TBF/FQ Qdisc. Other kind of pods
> > >   (e.g. Pn), the low latency of data access is key. And the traffic is not
> > >   limited. Pods use or share other dedicated Tx queues assigned FIFO Qdisc.
> > >   This choice provides two benefits. First, contention on the HTB/FQ Qdisc
> > >   lock is significantly reduced since fewer CPUs contend for the same queue.
> > >   More importantly, Qdisc contention can be eliminated completely if each
> > >   CPU has its own FIFO Qdisc for the second kind of pods.
> > >
> > >   There must be a mechanism in place to support classifying traffic based on
> > >   pods/container to different Tx queues. Note that clsact is outside of Qdisc
> > >   while Qdisc can run a classifier to select a sub-queue under the lock.
> > >
> > >   In general recording the decision in the skb seems a little heavy handed.
> > >   This patch introduces a per-CPU variable, suggested by Eric.
> > >
> > >   The xmit.skip_txqueue flag is firstly cleared in __dev_queue_xmit().
> > >   - Tx Qdisc may install that skbedit actions, then xmit.skip_txqueue flag
> > >     is set in qdisc->enqueue() though tx queue has been selected in
> > >     netdev_tx_queue_mapping() or netdev_core_pick_tx(). That flag is cleared
> > >     firstly in __dev_queue_xmit(), is useful:
> > >   - Avoid picking Tx queue with netdev_tx_queue_mapping() in next netdev
> > >     in such case: eth0 macvlan - eth0.3 vlan - eth0 ixgbe-phy:
> > >     For example, eth0, macvlan in pod, which root Qdisc install skbedit
> > >     queue_mapping, send packets to eth0.3, vlan in host. In __dev_queue_xmit() of
> > >     eth0.3, clear the flag, does not select tx queue according to skb->queue_mapping
> > >     because there is no filters in clsact or tx Qdisc of this netdev.
> > >     Same action taked in eth0, ixgbe in Host.
> > >   - Avoid picking Tx queue for next packet. If we set xmit.skip_txqueue
> > >     in tx Qdisc (qdisc->enqueue()), the proper way to clear it is clearing it
> > >     in __dev_queue_xmit when processing next packets.
> > >
> > >   +----+      +----+      +----+
> > >   | P1 |      | P2 |      | Pn |
> > >   +----+      +----+      +----+
> > >     |           |           |
> > >     +-----------+-----------+
> > >                 |
> > >                 | clsact/skbedit
> > >                 |      MQ
> > >                 v
> > >     +-----------+-----------+
> > >     | q0        | q1        | qn
> > >     v           v           v
> > >   HTB/FQ      HTB/FQ  ...  FIFO
> > >
> > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > Cc: Cong Wang <xiyou.wangcong@gmail.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Alexander Lobakin <alobakin@pm.me>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: Talal Ahmad <talalahmad@google.com>
> > > Cc: Kevin Hao <haokexin@gmail.com>
> > > Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > Cc: Antoine Tenart <atenart@kernel.org>
> > > Cc: Wei Wang <weiwan@google.com>
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Suggested-by: Eric Dumazet <edumazet@google.com>
> >
> > I have not suggested this patch, only to not add yet another bit in sk_buff.
> sorry for that
> >
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > ---
> > >  include/linux/netdevice.h | 19 +++++++++++++++++++
> > >  net/core/dev.c            |  7 ++++++-
> > >  net/sched/act_skbedit.c   |  4 +++-
> > >  3 files changed, 28 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index 8b0bdeb4734e..8d02dafb32ba 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -3009,6 +3009,7 @@ struct softnet_data {
> > >         /* written and read only by owning cpu: */
> > >         struct {
> > >                 u16 recursion;
> > > +               u8  skip_txqueue;
> > >                 u8  more;
> > >         } xmit;
> > >  #ifdef CONFIG_RPS
> > > @@ -4696,6 +4697,24 @@ static inline netdev_tx_t netdev_start_xmit(struct sk_buff *skb, struct net_devi
> > >         return rc;
> > >  }
> > >
> > > +static inline void netdev_xmit_skip_txqueue(bool skip)
> > > +{
> > > +       __this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
> > > +}
> > > +
> > > +static inline bool netdev_xmit_txqueue_skipped(void)
> > > +{
> > > +       return __this_cpu_read(softnet_data.xmit.skip_txqueue);
> > > +}
> > > +
> > > +static inline struct netdev_queue *
> > > +netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
> > > +{
> > > +       int qm = skb_get_queue_mapping(skb);
> > > +
> > > +       return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
> > > +}
> > > +
> > >  int netdev_class_create_file_ns(const struct class_attribute *class_attr,
> > >                                 const void *ns);
> > >  void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index a855e41bbe39..e3f548c54dda 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -4048,6 +4048,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> > >         skb_update_prio(skb);
> > >
> > >         qdisc_pkt_len_init(skb);
> > > +       netdev_xmit_skip_txqueue(false);
> > >  #ifdef CONFIG_NET_CLS_ACT
> > >         skb->tc_at_ingress = 0;
> > >  #endif
> > > @@ -4073,7 +4074,11 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> > >         else
> > >                 skb_dst_force(skb);
> > >
> > > -       txq = netdev_core_pick_tx(dev, skb, sb_dev);
> > > +       if (netdev_xmit_txqueue_skipped())
> > > +               txq = netdev_tx_queue_mapping(dev, skb);
> > > +       else
> > > +               txq = netdev_core_pick_tx(dev, skb, sb_dev);
> > > +
> >
> > If we really need to add yet another conditional in fast path, I would
> > suggest using a static key.
> Thanks, I will add a static key for this patch.
> > Only hosts where SKBEDIT_F_QUEUE_MAPPING is requested would pay the price.
Hi Eirc
Do you mean we need a static key, such as, egress_needed_key ?
static DEFINE_STATIC_KEY_FALSE(egress_needed_key);

and we also should use the per-cpu var to decide to select tx from
netdev_tx_queue_mapping or netdev_core_pick_tx.
> >
> > >         q = rcu_dereference_bh(txq->qdisc);
> > >
> > >         trace_net_dev_queue(skb);
> > > diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> > > index ceba11b198bb..48504ed3b280 100644
> > > --- a/net/sched/act_skbedit.c
> > > +++ b/net/sched/act_skbedit.c
> > > @@ -58,8 +58,10 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
> > >                 }
> > >         }
> > >         if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
> > > -           skb->dev->real_num_tx_queues > params->queue_mapping)
> > > +           skb->dev->real_num_tx_queues > params->queue_mapping) {
> > > +               netdev_xmit_skip_txqueue(true);
> > >                 skb_set_queue_mapping(skb, params->queue_mapping);
> > > +       }
> > >         if (params->flags & SKBEDIT_F_MARK) {
> > >                 skb->mark &= ~params->mask;
> > >                 skb->mark |= params->mark & params->mask;
> > > --
> > > 2.27.0
> > >
>
>
>
> --
> Best regards, Tonghao



-- 
Best regards, Tonghao
