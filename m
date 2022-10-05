Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480B25F5A52
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 21:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiJETEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 15:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiJETEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 15:04:31 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14AA7FFB0
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 12:04:27 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id w70so4472933oie.2
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 12:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=4f0ICfWyI8kHKhWNiXtOzIUTKb5P0gvcoPh1KGUvw6c=;
        b=f7HuLmX8n96SJCHi4+mzLRoFg7rTJXGxGeTH5vOqVTykDiq1zvWuK1Q/lUn1EHB2MI
         77R/yjnUmNXqhZwtA4Y2X/p6Pr1i0FlHqQUSNbm8POAqGRGSZJv9JYVi1MW1VNQjHIlb
         M8+VJLUpNhPSRng2yd2jaBLUfu08AUWLek+JTb799hf00/DS01VZFrY/1oOdSkEXN3Fh
         BY86eRM41xdPrSoryFpPxIj2XpipFrUK5523R+6Rg3lqBm5JqmLeRSzwVs11mCCPEKvk
         ggRModXREjjZMxuGmpC/zY+aHwl7pqTqwrVZr9oHmuZi6sOWDihedOcaB3vjnQu9dI15
         yr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=4f0ICfWyI8kHKhWNiXtOzIUTKb5P0gvcoPh1KGUvw6c=;
        b=EqEqOQMEQGQfJH1qgNJG1DSY8lCUWScNN3INdE6B7viHNgPcjYl4DfURBDXLB67Q23
         c11uke5HGHjAXzNSaaPP6kYfe4qE1ODuOdl6DmRO+xwgd6U9jQw24kfDSURpxSPcGNKT
         CDRv4gnrCPcs03X32a0mPi8ZNlOpL4uF3OHNgtoeFl20t2ea5u5W51H688i91cYCxCsV
         xwRJtvCU5fk6YPXfsuZy9y0d71ynJf3766E8ak7iAco4OQ4DN6mej9r4YuHHKT9NUA0J
         9bUcNlT7OmSt2FCWJEbcJH8EEP4sB7c/wOkfQ2g5DiHHIaTXEUpv4g0L7eUpwbV1qFJi
         0+qw==
X-Gm-Message-State: ACrzQf0BBE37+u5lUlE8oqiF00N+MQw0wEiVlcPN1tfuskXDArYvnEWL
        CJ5Bd2LOOY2TNk8ocymsU9ByTG6ohnCawsA58zHW9A==
X-Google-Smtp-Source: AMsMyM6mlsJmi+Beo8/P4F5Xb+c9re32V2MyuYs9/IzHi3o/UxboycB0EtB5SFYC+Gc3tVV6JEngYZS8t8SPrsSVhH4=
X-Received: by 2002:a05:6808:148d:b0:350:7858:63ce with SMTP id
 e13-20020a056808148d00b00350785863cemr634321oiw.106.1664996666177; Wed, 05
 Oct 2022 12:04:26 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-2-daniel@iogearbox.net>
In-Reply-To: <20221004231143.19190-2-daniel@iogearbox.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 5 Oct 2022 15:04:14 -0400
Message-ID: <CAM0EoM=i_zFMQ5YEtaaWyu-fSE7=wq2LmNTXnwDJoXcBJ9de6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel,

+tc maintainers

So i perused the slides, very fascinating battle debugging that ;->

Let me see if i can summarize the issue of ownership..
It seems there were two users each with root access and one decided they want
to be prio 1 and basically deleted the others programs and added
themselves to the top?
And of course both want to be prio 1. Am i correct? And this feature
basically avoids
this problem by virtue of fd ownership.

IIUC,  this is an issue of resource contention. Both users who have
root access think they should be prio 1. Kubernetes has no controls for this?
For debugging, wouldnt listening to netlink events have caught this?
I may be misunderstanding - but if both users took advantage of this
feature seems the root cause is still unresolved i.e  whoever gets there first
becomes the owner of the highest prio?

Other comments on just this patch (I will pay attention in detail later):
My two qualms:
1) Was bastardizing all things TC_ACT_XXX necessary?
Maybe you could create #define somewhere visible which refers
to the TC_ACT_XXX?
Even these kind of things seems puzzling:
-#ifdef CONFIG_NET_CLS_ACT
+#ifdef CONFIG_NET_XGRESS
TC_ACT_*,
2) Why is xtc_run before tc_run()?
tc_run() existed before xtc_run() - which is the same arguement
used when someone new shows up (eg when nftables did)

Probably lesser concern are thing like dev_xtc_entry_fetch()
which are bpf specific are now in net.

cheers,
jamal

On Tue, Oct 4, 2022 at 7:12 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> This work refactors and adds a lightweight extension to the tc BPF ingress
> and egress data path side for allowing BPF programs via an fd-based attach /
> detach API. The main goal behind this work which we also presented at LPC [0]
> this year is to eventually add support for BPF links for tc BPF programs in
> a second step, thus this prep work is required for the latter which allows
> for a model of safe ownership and program detachment.
> Given the vast rise
> in tc BPF users in cloud native / Kubernetes environments, this becomes
> necessary to avoid hard to debug incidents either through stale leftover
> programs or 3rd party applications stepping on each others toes. Further
> details for BPF link rationale in next patch.
> For the current tc framework, there is no change in behavior with this change
> and neither does this change touch on tc core kernel APIs. The gist of this
> patch is that the ingress and egress hook gets a lightweight, qdisc-less
> extension for BPF to attach its tc BPF programs, in other words, a minimal
> tc-layer entry point for BPF. As part of the feedback from LPC, there was
> a suggestion to provide a name for this infrastructure to more easily differ
> between the classic cls_bpf attachment and the fd-based API. As for most,
> the XDP vs tc layer is already the default mental model for the pkt processing
> pipeline. We refactored this with an xtc internal prefix aka 'express traffic
> control' in order to avoid to deviate too far (and 'express' given its more
> lightweight/faster entry point).



> For the ingress and egress xtc points, the device holds a cache-friendly array
> with programs. Same as with classic tc, programs are attached with a prio that
> can be specified or auto-allocated through an idr, and the program return code
> determines whether to continue in the pipeline or to terminate processing.
> With TC_ACT_UNSPEC code, the processing continues (as the case today). The goal
> was to have maximum compatibility to existing tc BPF programs, so they don't
> need to be adapted. Compatibility to call into classic tcf_classify() is also
> provided in order to allow successive migration or both to cleanly co-exist
> where needed given its one logical layer. The fd-based API is behind a static
> key, so that when unused the code is also not entered. The struct xtc_entry's
> program array is currently static, but could be made dynamic if necessary at
> a point in future. Desire has also been expressed for future work to adapt
> similar framework for XDP to allow multi-attach from in-kernel side, too.
>
> Tested with tc-testing selftest suite which all passes, as well as the tc BPF
> tests from the BPF CI.
>
>   [0] https://lpc.events/event/16/contributions/1353/
>
> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  MAINTAINERS                    |   4 +-
>  include/linux/bpf.h            |   1 +
>  include/linux/netdevice.h      |  14 +-
>  include/linux/skbuff.h         |   4 +-
>  include/net/sch_generic.h      |   2 +-
>  include/net/xtc.h              | 181 ++++++++++++++++++++++
>  include/uapi/linux/bpf.h       |  35 ++++-
>  kernel/bpf/Kconfig             |   1 +
>  kernel/bpf/Makefile            |   1 +
>  kernel/bpf/net.c               | 274 +++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c           |  24 ++-
>  net/Kconfig                    |   5 +
>  net/core/dev.c                 | 262 +++++++++++++++++++------------
>  net/core/filter.c              |   4 +-
>  net/sched/Kconfig              |   4 +-
>  net/sched/sch_ingress.c        |  48 +++++-
>  tools/include/uapi/linux/bpf.h |  35 ++++-
>  17 files changed, 769 insertions(+), 130 deletions(-)
>  create mode 100644 include/net/xtc.h
>  create mode 100644 kernel/bpf/net.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e55a4d47324c..bb63d8d000ea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3850,13 +3850,15 @@ S:      Maintained
>  F:     kernel/trace/bpf_trace.c
>  F:     kernel/bpf/stackmap.c
>
> -BPF [NETWORKING] (tc BPF, sock_addr)
> +BPF [NETWORKING] (xtc & tc BPF, sock_addr)
>  M:     Martin KaFai Lau <martin.lau@linux.dev>
>  M:     Daniel Borkmann <daniel@iogearbox.net>
>  R:     John Fastabend <john.fastabend@gmail.com>
>  L:     bpf@vger.kernel.org
>  L:     netdev@vger.kernel.org
>  S:     Maintained
> +F:     include/net/xtc.h
> +F:     kernel/bpf/net.c
>  F:     net/core/filter.c
>  F:     net/sched/act_bpf.c
>  F:     net/sched/cls_bpf.c
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9e7d46d16032..71e5f43db378 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1473,6 +1473,7 @@ struct bpf_prog_array_item {
>         union {
>                 struct bpf_cgroup_storage *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
>                 u64 bpf_cookie;
> +               u32 bpf_priority;
>         };
>  };
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index eddf8ee270e7..43bbb2303e57 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1880,8 +1880,7 @@ enum netdev_ml_priv_type {
>   *
>   *     @rx_handler:            handler for received packets
>   *     @rx_handler_data:       XXX: need comments on this one
> - *     @miniq_ingress:         ingress/clsact qdisc specific data for
> - *                             ingress processing
> + *     @xtc_ingress:           BPF/clsact qdisc specific data for ingress processing
>   *     @ingress_queue:         XXX: need comments on this one
>   *     @nf_hooks_ingress:      netfilter hooks executed for ingress packets
>   *     @broadcast:             hw bcast address
> @@ -1902,8 +1901,7 @@ enum netdev_ml_priv_type {
>   *     @xps_maps:              all CPUs/RXQs maps for XPS device
>   *
>   *     @xps_maps:      XXX: need comments on this one
> - *     @miniq_egress:          clsact qdisc specific data for
> - *                             egress processing
> + *     @xtc_egress:            BPF/clsact qdisc specific data for egress processing
>   *     @nf_hooks_egress:       netfilter hooks executed for egress packets
>   *     @qdisc_hash:            qdisc hash table
>   *     @watchdog_timeo:        Represents the timeout that is used by
> @@ -2191,8 +2189,8 @@ struct net_device {
>         rx_handler_func_t __rcu *rx_handler;
>         void __rcu              *rx_handler_data;
>
> -#ifdef CONFIG_NET_CLS_ACT
> -       struct mini_Qdisc __rcu *miniq_ingress;
> +#ifdef CONFIG_NET_XGRESS
> +       struct xtc_entry __rcu  *xtc_ingress;
>  #endif
>         struct netdev_queue __rcu *ingress_queue;
>  #ifdef CONFIG_NETFILTER_INGRESS
> @@ -2220,8 +2218,8 @@ struct net_device {
>  #ifdef CONFIG_XPS
>         struct xps_dev_maps __rcu *xps_maps[XPS_MAPS_MAX];
>  #endif
> -#ifdef CONFIG_NET_CLS_ACT
> -       struct mini_Qdisc __rcu *miniq_egress;
> +#ifdef CONFIG_NET_XGRESS
> +       struct xtc_entry __rcu *xtc_egress;
>  #endif
>  #ifdef CONFIG_NETFILTER_EGRESS
>         struct nf_hook_entries __rcu *nf_hooks_egress;
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 9fcf534f2d92..a9ff7a1996e9 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -955,7 +955,7 @@ struct sk_buff {
>         __u8                    csum_level:2;
>         __u8                    dst_pending_confirm:1;
>         __u8                    mono_delivery_time:1;   /* See SKB_MONO_DELIVERY_TIME_MASK */
> -#ifdef CONFIG_NET_CLS_ACT
> +#ifdef CONFIG_NET_XGRESS
>         __u8                    tc_skip_classify:1;
>         __u8                    tc_at_ingress:1;        /* See TC_AT_INGRESS_MASK */
>  #endif
> @@ -983,7 +983,7 @@ struct sk_buff {
>         __u8                    slow_gro:1;
>         __u8                    csum_not_inet:1;
>
> -#ifdef CONFIG_NET_SCHED
> +#if defined(CONFIG_NET_SCHED) || defined(CONFIG_NET_XGRESS)
>         __u16                   tc_index;       /* traffic control index */
>  #endif
>
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index d5517719af4e..bc5c1da2d30f 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -693,7 +693,7 @@ int skb_do_redirect(struct sk_buff *);
>
>  static inline bool skb_at_tc_ingress(const struct sk_buff *skb)
>  {
> -#ifdef CONFIG_NET_CLS_ACT
> +#ifdef CONFIG_NET_XGRESS
>         return skb->tc_at_ingress;
>  #else
>         return false;
> diff --git a/include/net/xtc.h b/include/net/xtc.h
> new file mode 100644
> index 000000000000..627dc18aa433
> --- /dev/null
> +++ b/include/net/xtc.h
> @@ -0,0 +1,181 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2022 Isovalent */
> +#ifndef __NET_XTC_H
> +#define __NET_XTC_H
> +
> +#include <linux/idr.h>
> +#include <linux/bpf.h>
> +
> +#include <net/sch_generic.h>
> +
> +#define XTC_MAX_ENTRIES 30
> +/* Adds 1 NULL entry. */
> +#define XTC_MAX        (XTC_MAX_ENTRIES + 1)
> +
> +struct xtc_entry {
> +       struct bpf_prog_array_item items[XTC_MAX] ____cacheline_aligned;
> +       struct xtc_entry_pair *parent;
> +};
> +
> +struct mini_Qdisc;
> +
> +struct xtc_entry_pair {
> +       struct rcu_head         rcu;
> +       struct idr              idr;
> +       struct mini_Qdisc       *miniq;
> +       struct xtc_entry        a;
> +       struct xtc_entry        b;
> +};
> +
> +static inline void xtc_set_ingress(struct sk_buff *skb, bool ingress)
> +{
> +#ifdef CONFIG_NET_XGRESS
> +       skb->tc_at_ingress = ingress;
> +#endif
> +}
> +
> +#ifdef CONFIG_NET_XGRESS
> +void xtc_inc(void);
> +void xtc_dec(void);
> +
> +static inline void
> +dev_xtc_entry_update(struct net_device *dev, struct xtc_entry *entry,
> +                    bool ingress)
> +{
> +       ASSERT_RTNL();
> +       if (ingress)
> +               rcu_assign_pointer(dev->xtc_ingress, entry);
> +       else
> +               rcu_assign_pointer(dev->xtc_egress, entry);
> +       synchronize_rcu();
> +}
> +
> +static inline struct xtc_entry *dev_xtc_entry_peer(const struct xtc_entry *entry)
> +{
> +       if (entry == &entry->parent->a)
> +               return &entry->parent->b;
> +       else
> +               return &entry->parent->a;
> +}
> +
> +static inline struct xtc_entry *dev_xtc_entry_create(void)
> +{
> +       struct xtc_entry_pair *pair = kzalloc(sizeof(*pair), GFP_KERNEL);
> +
> +       if (pair) {
> +               pair->a.parent = pair;
> +               pair->b.parent = pair;
> +               idr_init(&pair->idr);
> +               return &pair->a;
> +       }
> +       return NULL;
> +}
> +
> +static inline struct xtc_entry *dev_xtc_entry_fetch(struct net_device *dev,
> +                                                   bool ingress, bool *created)
> +{
> +       struct xtc_entry *entry = ingress ?
> +               rcu_dereference_rtnl(dev->xtc_ingress) :
> +               rcu_dereference_rtnl(dev->xtc_egress);
> +
> +       *created = false;
> +       if (!entry) {
> +               entry = dev_xtc_entry_create();
> +               if (!entry)
> +                       return NULL;
> +               *created = true;
> +       }
> +       return entry;
> +}
> +
> +static inline void dev_xtc_entry_clear(struct xtc_entry *entry)
> +{
> +       memset(entry->items, 0, sizeof(entry->items));
> +}
> +
> +static inline int dev_xtc_entry_prio_new(struct xtc_entry *entry, u32 prio,
> +                                        struct bpf_prog *prog)
> +{
> +       int ret;
> +
> +       if (prio == 0)
> +               prio = 1;
> +       ret = idr_alloc_u32(&entry->parent->idr, prog, &prio, U32_MAX,
> +                           GFP_KERNEL);
> +       return ret < 0 ? ret : prio;
> +}
> +
> +static inline void dev_xtc_entry_prio_set(struct xtc_entry *entry, u32 prio,
> +                                         struct bpf_prog *prog)
> +{
> +       idr_replace(&entry->parent->idr, prog, prio);
> +}
> +
> +static inline void dev_xtc_entry_prio_del(struct xtc_entry *entry, u32 prio)
> +{
> +       idr_remove(&entry->parent->idr, prio);
> +}
> +
> +static inline void dev_xtc_entry_free(struct xtc_entry *entry)
> +{
> +       idr_destroy(&entry->parent->idr);
> +       kfree_rcu(entry->parent, rcu);
> +}
> +
> +static inline u32 dev_xtc_entry_total(struct xtc_entry *entry)
> +{
> +       const struct bpf_prog_array_item *item;
> +       const struct bpf_prog *prog;
> +       u32 num = 0;
> +
> +       item = &entry->items[0];
> +       while ((prog = READ_ONCE(item->prog))) {
> +               num++;
> +               item++;
> +       }
> +       return num;
> +}
> +
> +static inline enum tc_action_base xtc_action_code(struct sk_buff *skb, int code)
> +{
> +       switch (code) {
> +       case TC_PASS:
> +               skb->tc_index = qdisc_skb_cb(skb)->tc_classid;
> +               fallthrough;
> +       case TC_DROP:
> +       case TC_REDIRECT:
> +               return code;
> +       case TC_NEXT:
> +       default:
> +               return TC_NEXT;
> +       }
> +}
> +
> +int xtc_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog);
> +int xtc_prog_detach(const union bpf_attr *attr);
> +int xtc_prog_query(const union bpf_attr *attr,
> +                  union bpf_attr __user *uattr);
> +void dev_xtc_uninstall(struct net_device *dev);
> +#else
> +static inline int xtc_prog_attach(const union bpf_attr *attr,
> +                                 struct bpf_prog *prog)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline int xtc_prog_detach(const union bpf_attr *attr)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline int xtc_prog_query(const union bpf_attr *attr,
> +                                union bpf_attr __user *uattr)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline void dev_xtc_uninstall(struct net_device *dev)
> +{
> +}
> +#endif /* CONFIG_NET_XGRESS */
> +#endif /* __NET_XTC_H */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 51b9aa640ad2..de1f5546bcfe 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1025,6 +1025,8 @@ enum bpf_attach_type {
>         BPF_PERF_EVENT,
>         BPF_TRACE_KPROBE_MULTI,
>         BPF_LSM_CGROUP,
> +       BPF_NET_INGRESS,
> +       BPF_NET_EGRESS,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -1399,14 +1401,20 @@ union bpf_attr {
>         };
>
>         struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH commands */
> -               __u32           target_fd;      /* container object to attach to */
> +               union {
> +                       __u32   target_fd;      /* container object to attach to */
> +                       __u32   target_ifindex; /* target ifindex */
> +               };
>                 __u32           attach_bpf_fd;  /* eBPF program to attach */
>                 __u32           attach_type;
>                 __u32           attach_flags;
> -               __u32           replace_bpf_fd; /* previously attached eBPF
> +               union {
> +                       __u32   attach_priority;
> +                       __u32   replace_bpf_fd; /* previously attached eBPF
>                                                  * program to replace if
>                                                  * BPF_F_REPLACE is used
>                                                  */
> +               };
>         };
>
>         struct { /* anonymous struct used by BPF_PROG_TEST_RUN command */
> @@ -1452,7 +1460,10 @@ union bpf_attr {
>         } info;
>
>         struct { /* anonymous struct used by BPF_PROG_QUERY command */
> -               __u32           target_fd;      /* container object to query */
> +               union {
> +                       __u32   target_fd;      /* container object to query */
> +                       __u32   target_ifindex; /* target ifindex */
> +               };
>                 __u32           attach_type;
>                 __u32           query_flags;
>                 __u32           attach_flags;
> @@ -6038,6 +6049,19 @@ struct bpf_sock_tuple {
>         };
>  };
>
> +/* (Simplified) user return codes for tc prog type.
> + * A valid tc program must return one of these defined values. All other
> + * return codes are reserved for future use. Must remain compatible with
> + * their TC_ACT_* counter-parts. For compatibility in behavior, unknown
> + * return codes are mapped to TC_NEXT.
> + */
> +enum tc_action_base {
> +       TC_NEXT         = -1,
> +       TC_PASS         = 0,
> +       TC_DROP         = 2,
> +       TC_REDIRECT     = 7,
> +};
> +
>  struct bpf_xdp_sock {
>         __u32 queue_id;
>  };
> @@ -6804,6 +6828,11 @@ struct bpf_flow_keys {
>         __be32  flow_label;
>  };
>
> +struct bpf_query_info {
> +       __u32 prog_id;
> +       __u32 prio;
> +};
> +
>  struct bpf_func_info {
>         __u32   insn_off;
>         __u32   type_id;
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index 2dfe1079f772..6a906ff93006 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -31,6 +31,7 @@ config BPF_SYSCALL
>         select TASKS_TRACE_RCU
>         select BINARY_PRINTF
>         select NET_SOCK_MSG if NET
> +       select NET_XGRESS if NET
>         select PAGE_POOL if NET
>         default n
>         help
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 341c94f208f4..76c3f9d4e2f3 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_BPF_SYSCALL) += devmap.o
>  obj-$(CONFIG_BPF_SYSCALL) += cpumap.o
>  obj-$(CONFIG_BPF_SYSCALL) += offload.o
>  obj-$(CONFIG_BPF_SYSCALL) += net_namespace.o
> +obj-$(CONFIG_BPF_SYSCALL) += net.o
>  endif
>  ifeq ($(CONFIG_PERF_EVENTS),y)
>  obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
> diff --git a/kernel/bpf/net.c b/kernel/bpf/net.c
> new file mode 100644
> index 000000000000..ab9a9dee615b
> --- /dev/null
> +++ b/kernel/bpf/net.c
> @@ -0,0 +1,274 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2022 Isovalent */
> +
> +#include <linux/bpf.h>
> +#include <linux/filter.h>
> +#include <linux/netdevice.h>
> +
> +#include <net/xtc.h>
> +
> +static int __xtc_prog_attach(struct net_device *dev, bool ingress, u32 limit,
> +                            struct bpf_prog *nprog, u32 prio, u32 flags)
> +{
> +       struct bpf_prog_array_item *item, *tmp;
> +       struct xtc_entry *entry, *peer;
> +       struct bpf_prog *oprog;
> +       bool created;
> +       int i, j;
> +
> +       ASSERT_RTNL();
> +
> +       entry = dev_xtc_entry_fetch(dev, ingress, &created);
> +       if (!entry)
> +               return -ENOMEM;
> +       for (i = 0; i < limit; i++) {
> +               item = &entry->items[i];
> +               oprog = item->prog;
> +               if (!oprog)
> +                       break;
> +               if (item->bpf_priority == prio) {
> +                       if (flags & BPF_F_REPLACE) {
> +                               /* Pairs with READ_ONCE() in xtc_run_progs(). */
> +                               WRITE_ONCE(item->prog, nprog);
> +                               bpf_prog_put(oprog);
> +                               dev_xtc_entry_prio_set(entry, prio, nprog);
> +                               return prio;
> +                       }
> +                       return -EBUSY;
> +               }
> +       }
> +       if (dev_xtc_entry_total(entry) >= limit)
> +               return -ENOSPC;
> +       prio = dev_xtc_entry_prio_new(entry, prio, nprog);
> +       if (prio < 0) {
> +               if (created)
> +                       dev_xtc_entry_free(entry);
> +               return -ENOMEM;
> +       }
> +       peer = dev_xtc_entry_peer(entry);
> +       dev_xtc_entry_clear(peer);
> +       for (i = 0, j = 0; i < limit; i++, j++) {
> +               item = &entry->items[i];
> +               tmp = &peer->items[j];
> +               oprog = item->prog;
> +               if (!oprog) {
> +                       if (i == j) {
> +                               tmp->prog = nprog;
> +                               tmp->bpf_priority = prio;
> +                       }
> +                       break;
> +               } else if (item->bpf_priority < prio) {
> +                       tmp->prog = oprog;
> +                       tmp->bpf_priority = item->bpf_priority;
> +               } else if (item->bpf_priority > prio) {
> +                       if (i == j) {
> +                               tmp->prog = nprog;
> +                               tmp->bpf_priority = prio;
> +                               tmp = &peer->items[++j];
> +                       }
> +                       tmp->prog = oprog;
> +                       tmp->bpf_priority = item->bpf_priority;
> +               }
> +       }
> +       dev_xtc_entry_update(dev, peer, ingress);
> +       if (ingress)
> +               net_inc_ingress_queue();
> +       else
> +               net_inc_egress_queue();
> +       xtc_inc();
> +       return prio;
> +}
> +
> +int xtc_prog_attach(const union bpf_attr *attr, struct bpf_prog *nprog)
> +{
> +       struct net *net = current->nsproxy->net_ns;
> +       bool ingress = attr->attach_type == BPF_NET_INGRESS;
> +       struct net_device *dev;
> +       int ret;
> +
> +       if (attr->attach_flags & ~BPF_F_REPLACE)
> +               return -EINVAL;
> +       rtnl_lock();
> +       dev = __dev_get_by_index(net, attr->target_ifindex);
> +       if (!dev) {
> +               rtnl_unlock();
> +               return -EINVAL;
> +       }
> +       ret = __xtc_prog_attach(dev, ingress, XTC_MAX_ENTRIES, nprog,
> +                               attr->attach_priority, attr->attach_flags);
> +       rtnl_unlock();
> +       return ret;
> +}
> +
> +static int __xtc_prog_detach(struct net_device *dev, bool ingress, u32 limit,
> +                            u32 prio)
> +{
> +       struct bpf_prog_array_item *item, *tmp;
> +       struct bpf_prog *oprog, *fprog = NULL;
> +       struct xtc_entry *entry, *peer;
> +       int i, j;
> +
> +       ASSERT_RTNL();
> +
> +       entry = ingress ?
> +               rcu_dereference_rtnl(dev->xtc_ingress) :
> +               rcu_dereference_rtnl(dev->xtc_egress);
> +       if (!entry)
> +               return -ENOENT;
> +       peer = dev_xtc_entry_peer(entry);
> +       dev_xtc_entry_clear(peer);
> +       for (i = 0, j = 0; i < limit; i++) {
> +               item = &entry->items[i];
> +               tmp = &peer->items[j];
> +               oprog = item->prog;
> +               if (!oprog)
> +                       break;
> +               if (item->bpf_priority != prio) {
> +                       tmp->prog = oprog;
> +                       tmp->bpf_priority = item->bpf_priority;
> +                       j++;
> +               } else {
> +                       fprog = oprog;
> +               }
> +       }
> +       if (fprog) {
> +               dev_xtc_entry_prio_del(peer, prio);
> +               if (dev_xtc_entry_total(peer) == 0 && !entry->parent->miniq)
> +                       peer = NULL;
> +               dev_xtc_entry_update(dev, peer, ingress);
> +               bpf_prog_put(fprog);
> +               if (!peer)
> +                       dev_xtc_entry_free(entry);
> +               if (ingress)
> +                       net_dec_ingress_queue();
> +               else
> +                       net_dec_egress_queue();
> +               xtc_dec();
> +               return 0;
> +       }
> +       return -ENOENT;
> +}
> +
> +int xtc_prog_detach(const union bpf_attr *attr)
> +{
> +       struct net *net = current->nsproxy->net_ns;
> +       bool ingress = attr->attach_type == BPF_NET_INGRESS;
> +       struct net_device *dev;
> +       int ret;
> +
> +       if (attr->attach_flags || !attr->attach_priority)
> +               return -EINVAL;
> +       rtnl_lock();
> +       dev = __dev_get_by_index(net, attr->target_ifindex);
> +       if (!dev) {
> +               rtnl_unlock();
> +               return -EINVAL;
> +       }
> +       ret = __xtc_prog_detach(dev, ingress, XTC_MAX_ENTRIES,
> +                               attr->attach_priority);
> +       rtnl_unlock();
> +       return ret;
> +}
> +
> +static void __xtc_prog_detach_all(struct net_device *dev, bool ingress, u32 limit)
> +{
> +       struct bpf_prog_array_item *item;
> +       struct xtc_entry *entry;
> +       struct bpf_prog *prog;
> +       int i;
> +
> +       ASSERT_RTNL();
> +
> +       entry = ingress ?
> +               rcu_dereference_rtnl(dev->xtc_ingress) :
> +               rcu_dereference_rtnl(dev->xtc_egress);
> +       if (!entry)
> +               return;
> +       dev_xtc_entry_update(dev, NULL, ingress);
> +       for (i = 0; i < limit; i++) {
> +               item = &entry->items[i];
> +               prog = item->prog;
> +               if (!prog)
> +                       break;
> +               dev_xtc_entry_prio_del(entry, item->bpf_priority);
> +               bpf_prog_put(prog);
> +               if (ingress)
> +                       net_dec_ingress_queue();
> +               else
> +                       net_dec_egress_queue();
> +               xtc_dec();
> +       }
> +       dev_xtc_entry_free(entry);
> +}
> +
> +void dev_xtc_uninstall(struct net_device *dev)
> +{
> +       __xtc_prog_detach_all(dev, true,  XTC_MAX_ENTRIES + 1);
> +       __xtc_prog_detach_all(dev, false, XTC_MAX_ENTRIES + 1);
> +}
> +
> +static int
> +__xtc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr,
> +                struct net_device *dev, bool ingress, u32 limit)
> +{
> +       struct bpf_query_info info, __user *uinfo;
> +       struct bpf_prog_array_item *item;
> +       struct xtc_entry *entry;
> +       struct bpf_prog *prog;
> +       u32 i, flags = 0, cnt;
> +       int ret = 0;
> +
> +       ASSERT_RTNL();
> +
> +       entry = ingress ?
> +               rcu_dereference_rtnl(dev->xtc_ingress) :
> +               rcu_dereference_rtnl(dev->xtc_egress);
> +       if (!entry)
> +               return -ENOENT;
> +       cnt = dev_xtc_entry_total(entry);
> +       if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> +               return -EFAULT;
> +       if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> +               return -EFAULT;
> +       uinfo = u64_to_user_ptr(attr->query.prog_ids);
> +       if (attr->query.prog_cnt == 0 || !uinfo || !cnt)
> +               /* return early if user requested only program count + flags */
> +               return 0;
> +       if (attr->query.prog_cnt < cnt) {
> +               cnt = attr->query.prog_cnt;
> +               ret = -ENOSPC;
> +       }
> +       for (i = 0; i < limit; i++) {
> +               item = &entry->items[i];
> +               prog = item->prog;
> +               if (!prog)
> +                       break;
> +               info.prog_id = prog->aux->id;
> +               info.prio = item->bpf_priority;
> +               if (copy_to_user(uinfo + i, &info, sizeof(info)))
> +                       return -EFAULT;
> +               if (i + 1 == cnt)
> +                       break;
> +       }
> +       return ret;
> +}
> +
> +int xtc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
> +{
> +       struct net *net = current->nsproxy->net_ns;
> +       bool ingress = attr->query.attach_type == BPF_NET_INGRESS;
> +       struct net_device *dev;
> +       int ret;
> +
> +       if (attr->query.query_flags || attr->query.attach_flags)
> +               return -EINVAL;
> +       rtnl_lock();
> +       dev = __dev_get_by_index(net, attr->query.target_ifindex);
> +       if (!dev) {
> +               rtnl_unlock();
> +               return -EINVAL;
> +       }
> +       ret = __xtc_prog_query(attr, uattr, dev, ingress, XTC_MAX_ENTRIES);
> +       rtnl_unlock();
> +       return ret;
> +}
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 7b373a5e861f..a0a670b964bb 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -36,6 +36,8 @@
>  #include <linux/memcontrol.h>
>  #include <linux/trace_events.h>
>
> +#include <net/xtc.h>
> +
>  #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
>                           (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
>                           (map)->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
> @@ -3448,6 +3450,9 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>                 return BPF_PROG_TYPE_XDP;
>         case BPF_LSM_CGROUP:
>                 return BPF_PROG_TYPE_LSM;
> +       case BPF_NET_INGRESS:
> +       case BPF_NET_EGRESS:
> +               return BPF_PROG_TYPE_SCHED_CLS;
>         default:
>                 return BPF_PROG_TYPE_UNSPEC;
>         }
> @@ -3466,18 +3471,15 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>
>         if (CHECK_ATTR(BPF_PROG_ATTACH))
>                 return -EINVAL;
> -
>         if (attr->attach_flags & ~BPF_F_ATTACH_MASK)
>                 return -EINVAL;
>
>         ptype = attach_type_to_prog_type(attr->attach_type);
>         if (ptype == BPF_PROG_TYPE_UNSPEC)
>                 return -EINVAL;
> -
>         prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
>         if (IS_ERR(prog))
>                 return PTR_ERR(prog);
> -
>         if (bpf_prog_attach_check_attach_type(prog, attr->attach_type)) {
>                 bpf_prog_put(prog);
>                 return -EINVAL;
> @@ -3508,16 +3510,18 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>
>                 ret = cgroup_bpf_prog_attach(attr, ptype, prog);
>                 break;
> +       case BPF_PROG_TYPE_SCHED_CLS:
> +               ret = xtc_prog_attach(attr, prog);
> +               break;
>         default:
>                 ret = -EINVAL;
>         }
> -
> -       if (ret)
> +       if (ret < 0)
>                 bpf_prog_put(prog);
>         return ret;
>  }
>
> -#define BPF_PROG_DETACH_LAST_FIELD attach_type
> +#define BPF_PROG_DETACH_LAST_FIELD replace_bpf_fd
>
>  static int bpf_prog_detach(const union bpf_attr *attr)
>  {
> @@ -3527,6 +3531,9 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>                 return -EINVAL;
>
>         ptype = attach_type_to_prog_type(attr->attach_type);
> +       if (ptype != BPF_PROG_TYPE_SCHED_CLS &&
> +           (attr->attach_flags || attr->replace_bpf_fd))
> +               return -EINVAL;
>
>         switch (ptype) {
>         case BPF_PROG_TYPE_SK_MSG:
> @@ -3545,6 +3552,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>         case BPF_PROG_TYPE_SOCK_OPS:
>         case BPF_PROG_TYPE_LSM:
>                 return cgroup_bpf_prog_detach(attr, ptype);
> +       case BPF_PROG_TYPE_SCHED_CLS:
> +               return xtc_prog_detach(attr);
>         default:
>                 return -EINVAL;
>         }
> @@ -3598,6 +3607,9 @@ static int bpf_prog_query(const union bpf_attr *attr,
>         case BPF_SK_MSG_VERDICT:
>         case BPF_SK_SKB_VERDICT:
>                 return sock_map_bpf_prog_query(attr, uattr);
> +       case BPF_NET_INGRESS:
> +       case BPF_NET_EGRESS:
> +               return xtc_prog_query(attr, uattr);
>         default:
>                 return -EINVAL;
>         }
> diff --git a/net/Kconfig b/net/Kconfig
> index 48c33c222199..b7a9cd174464 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -52,6 +52,11 @@ config NET_INGRESS
>  config NET_EGRESS
>         bool
>
> +config NET_XGRESS
> +       select NET_INGRESS
> +       select NET_EGRESS
> +       bool
> +
>  config NET_REDIRECT
>         bool
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index fa53830d0683..552b805c27dd 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -107,6 +107,7 @@
>  #include <net/pkt_cls.h>
>  #include <net/checksum.h>
>  #include <net/xfrm.h>
> +#include <net/xtc.h>
>  #include <linux/highmem.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
> @@ -154,7 +155,6 @@
>  #include "dev.h"
>  #include "net-sysfs.h"
>
> -
>  static DEFINE_SPINLOCK(ptype_lock);
>  struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
>  struct list_head ptype_all __read_mostly;      /* Taps */
> @@ -3935,69 +3935,199 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
>  EXPORT_SYMBOL(dev_loopback_xmit);
>
>  #ifdef CONFIG_NET_EGRESS
> -static struct sk_buff *
> -sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> +static struct netdev_queue *
> +netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
> +{
> +       int qm = skb_get_queue_mapping(skb);
> +
> +       return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
> +}
> +
> +static bool netdev_xmit_txqueue_skipped(void)
> +{
> +       return __this_cpu_read(softnet_data.xmit.skip_txqueue);
> +}
> +
> +void netdev_xmit_skip_txqueue(bool skip)
> +{
> +       __this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
> +}
> +EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
> +#endif /* CONFIG_NET_EGRESS */
> +
> +#ifdef CONFIG_NET_XGRESS
> +static int tc_run(struct xtc_entry *entry, struct sk_buff *skb)
>  {
> +       int ret = TC_ACT_UNSPEC;
>  #ifdef CONFIG_NET_CLS_ACT
> -       struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
> -       struct tcf_result cl_res;
> +       struct mini_Qdisc *miniq = rcu_dereference_bh(entry->parent->miniq);
> +       struct tcf_result res;
>
>         if (!miniq)
> -               return skb;
> +               return ret;
>
> -       /* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
>         tc_skb_cb(skb)->mru = 0;
>         tc_skb_cb(skb)->post_ct = false;
> -       mini_qdisc_bstats_cpu_update(miniq, skb);
>
> -       switch (tcf_classify(skb, miniq->block, miniq->filter_list, &cl_res, false)) {
> +       mini_qdisc_bstats_cpu_update(miniq, skb);
> +       ret = tcf_classify(skb, miniq->block, miniq->filter_list, &res, false);
> +       /* Only tcf related quirks below. */
> +       switch (ret) {
> +       case TC_ACT_SHOT:
> +               mini_qdisc_qstats_cpu_drop(miniq);
> +               break;
>         case TC_ACT_OK:
>         case TC_ACT_RECLASSIFY:
> -               skb->tc_index = TC_H_MIN(cl_res.classid);
> +               skb->tc_index = TC_H_MIN(res.classid);
>                 break;
> +       }
> +#endif /* CONFIG_NET_CLS_ACT */
> +       return ret;
> +}
> +
> +static DEFINE_STATIC_KEY_FALSE(xtc_needed_key);
> +
> +void xtc_inc(void)
> +{
> +       static_branch_inc(&xtc_needed_key);
> +}
> +EXPORT_SYMBOL_GPL(xtc_inc);
> +
> +void xtc_dec(void)
> +{
> +       static_branch_dec(&xtc_needed_key);
> +}
> +EXPORT_SYMBOL_GPL(xtc_dec);
> +
> +static __always_inline enum tc_action_base
> +xtc_run(const struct xtc_entry *entry, struct sk_buff *skb,
> +       const bool needs_mac)
> +{
> +       const struct bpf_prog_array_item *item;
> +       const struct bpf_prog *prog;
> +       int ret = TC_NEXT;
> +
> +       if (needs_mac)
> +               __skb_push(skb, skb->mac_len);
> +       item = &entry->items[0];
> +       while ((prog = READ_ONCE(item->prog))) {
> +               bpf_compute_data_pointers(skb);
> +               ret = bpf_prog_run(prog, skb);
> +               if (ret != TC_NEXT)
> +                       break;
> +               item++;
> +       }
> +       if (needs_mac)
> +               __skb_pull(skb, skb->mac_len);
> +       return xtc_action_code(skb, ret);
> +}
> +
> +static __always_inline struct sk_buff *
> +sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
> +                  struct net_device *orig_dev, bool *another)
> +{
> +       struct xtc_entry *entry = rcu_dereference_bh(skb->dev->xtc_ingress);
> +       int sch_ret;
> +
> +       if (!entry)
> +               return skb;
> +       if (*pt_prev) {
> +               *ret = deliver_skb(skb, *pt_prev, orig_dev);
> +               *pt_prev = NULL;
> +       }
> +
> +       qdisc_skb_cb(skb)->pkt_len = skb->len;
> +       xtc_set_ingress(skb, true);
> +
> +       if (static_branch_unlikely(&xtc_needed_key)) {
> +               sch_ret = xtc_run(entry, skb, true);
> +               if (sch_ret != TC_ACT_UNSPEC)
> +                       goto ingress_verdict;
> +       }
> +       sch_ret = tc_run(entry, skb);
> +ingress_verdict:
> +       switch (sch_ret) {
> +       case TC_ACT_REDIRECT:
> +               /* skb_mac_header check was done by BPF, so we can safely
> +                * push the L2 header back before redirecting to another
> +                * netdev.
> +                */
> +               __skb_push(skb, skb->mac_len);
> +               if (skb_do_redirect(skb) == -EAGAIN) {
> +                       __skb_pull(skb, skb->mac_len);
> +                       *another = true;
> +                       break;
> +               }
> +               return NULL;
>         case TC_ACT_SHOT:
> -               mini_qdisc_qstats_cpu_drop(miniq);
> -               *ret = NET_XMIT_DROP;
> -               kfree_skb_reason(skb, SKB_DROP_REASON_TC_EGRESS);
> +               kfree_skb_reason(skb, SKB_DROP_REASON_TC_INGRESS);
>                 return NULL;
> +       /* used by tc_run */
>         case TC_ACT_STOLEN:
>         case TC_ACT_QUEUED:
>         case TC_ACT_TRAP:
> -               *ret = NET_XMIT_SUCCESS;
>                 consume_skb(skb);
> +               fallthrough;
> +       case TC_ACT_CONSUMED:
>                 return NULL;
> +       }
> +
> +       return skb;
> +}
> +
> +static __always_inline struct sk_buff *
> +sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> +{
> +       struct xtc_entry *entry = rcu_dereference_bh(dev->xtc_egress);
> +       int sch_ret;
> +
> +       if (!entry)
> +               return skb;
> +
> +       /* qdisc_skb_cb(skb)->pkt_len & xtc_set_ingress() was
> +        * already set by the caller.
> +        */
> +       if (static_branch_unlikely(&xtc_needed_key)) {
> +               sch_ret = xtc_run(entry, skb, false);
> +               if (sch_ret != TC_ACT_UNSPEC)
> +                       goto egress_verdict;
> +       }
> +       sch_ret = tc_run(entry, skb);
> +egress_verdict:
> +       switch (sch_ret) {
>         case TC_ACT_REDIRECT:
> +               *ret = NET_XMIT_SUCCESS;
>                 /* No need to push/pop skb's mac_header here on egress! */
>                 skb_do_redirect(skb);
> +               return NULL;
> +       case TC_ACT_SHOT:
> +               *ret = NET_XMIT_DROP;
> +               kfree_skb_reason(skb, SKB_DROP_REASON_TC_EGRESS);
> +               return NULL;
> +       /* used by tc_run */
> +       case TC_ACT_STOLEN:
> +       case TC_ACT_QUEUED:
> +       case TC_ACT_TRAP:
>                 *ret = NET_XMIT_SUCCESS;
>                 return NULL;
> -       default:
> -               break;
>         }
> -#endif /* CONFIG_NET_CLS_ACT */
>
>         return skb;
>  }
> -
> -static struct netdev_queue *
> -netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
> -{
> -       int qm = skb_get_queue_mapping(skb);
> -
> -       return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
> -}
> -
> -static bool netdev_xmit_txqueue_skipped(void)
> +#else
> +static __always_inline struct sk_buff *
> +sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
> +                  struct net_device *orig_dev, bool *another)
>  {
> -       return __this_cpu_read(softnet_data.xmit.skip_txqueue);
> +       return skb;
>  }
>
> -void netdev_xmit_skip_txqueue(bool skip)
> +static __always_inline struct sk_buff *
> +sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
>  {
> -       __this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
> +       return skb;
>  }
> -EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
> -#endif /* CONFIG_NET_EGRESS */
> +#endif /* CONFIG_NET_XGRESS */
>
>  #ifdef CONFIG_XPS
>  static int __get_xps_queue_idx(struct net_device *dev, struct sk_buff *skb,
> @@ -4181,9 +4311,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>         skb_update_prio(skb);
>
>         qdisc_pkt_len_init(skb);
> -#ifdef CONFIG_NET_CLS_ACT
> -       skb->tc_at_ingress = 0;
> -#endif
> +       xtc_set_ingress(skb, false);
>  #ifdef CONFIG_NET_EGRESS
>         if (static_branch_unlikely(&egress_needed_key)) {
>                 if (nf_hook_egress_active()) {
> @@ -5101,68 +5229,6 @@ int (*br_fdb_test_addr_hook)(struct net_device *dev,
>  EXPORT_SYMBOL_GPL(br_fdb_test_addr_hook);
>  #endif
>
> -static inline struct sk_buff *
> -sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
> -                  struct net_device *orig_dev, bool *another)
> -{
> -#ifdef CONFIG_NET_CLS_ACT
> -       struct mini_Qdisc *miniq = rcu_dereference_bh(skb->dev->miniq_ingress);
> -       struct tcf_result cl_res;
> -
> -       /* If there's at least one ingress present somewhere (so
> -        * we get here via enabled static key), remaining devices
> -        * that are not configured with an ingress qdisc will bail
> -        * out here.
> -        */
> -       if (!miniq)
> -               return skb;
> -
> -       if (*pt_prev) {
> -               *ret = deliver_skb(skb, *pt_prev, orig_dev);
> -               *pt_prev = NULL;
> -       }
> -
> -       qdisc_skb_cb(skb)->pkt_len = skb->len;
> -       tc_skb_cb(skb)->mru = 0;
> -       tc_skb_cb(skb)->post_ct = false;
> -       skb->tc_at_ingress = 1;
> -       mini_qdisc_bstats_cpu_update(miniq, skb);
> -
> -       switch (tcf_classify(skb, miniq->block, miniq->filter_list, &cl_res, false)) {
> -       case TC_ACT_OK:
> -       case TC_ACT_RECLASSIFY:
> -               skb->tc_index = TC_H_MIN(cl_res.classid);
> -               break;
> -       case TC_ACT_SHOT:
> -               mini_qdisc_qstats_cpu_drop(miniq);
> -               kfree_skb_reason(skb, SKB_DROP_REASON_TC_INGRESS);
> -               return NULL;
> -       case TC_ACT_STOLEN:
> -       case TC_ACT_QUEUED:
> -       case TC_ACT_TRAP:
> -               consume_skb(skb);
> -               return NULL;
> -       case TC_ACT_REDIRECT:
> -               /* skb_mac_header check was done by cls/act_bpf, so
> -                * we can safely push the L2 header back before
> -                * redirecting to another netdev
> -                */
> -               __skb_push(skb, skb->mac_len);
> -               if (skb_do_redirect(skb) == -EAGAIN) {
> -                       __skb_pull(skb, skb->mac_len);
> -                       *another = true;
> -                       break;
> -               }
> -               return NULL;
> -       case TC_ACT_CONSUMED:
> -               return NULL;
> -       default:
> -               break;
> -       }
> -#endif /* CONFIG_NET_CLS_ACT */
> -       return skb;
> -}
> -
>  /**
>   *     netdev_is_rx_handler_busy - check if receive handler is registered
>   *     @dev: device to check
> @@ -10832,7 +10898,7 @@ void unregister_netdevice_many(struct list_head *head)
>
>                 /* Shutdown queueing discipline. */
>                 dev_shutdown(dev);
> -
> +               dev_xtc_uninstall(dev);
>                 dev_xdp_uninstall(dev);
>
>                 netdev_offload_xstats_disable_all(dev);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index bb0136e7a8e4..ac4bb016c5ee 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -9132,7 +9132,7 @@ static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_prog *prog,
>         __u8 value_reg = si->dst_reg;
>         __u8 skb_reg = si->src_reg;
>
> -#ifdef CONFIG_NET_CLS_ACT
> +#ifdef CONFIG_NET_XGRESS
>         /* If the tstamp_type is read,
>          * the bpf prog is aware the tstamp could have delivery time.
>          * Thus, read skb->tstamp as is if tstamp_type_access is true.
> @@ -9166,7 +9166,7 @@ static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_prog *prog,
>         __u8 value_reg = si->src_reg;
>         __u8 skb_reg = si->dst_reg;
>
> -#ifdef CONFIG_NET_CLS_ACT
> +#ifdef CONFIG_NET_XGRESS
>         /* If the tstamp_type is read,
>          * the bpf prog is aware the tstamp could have delivery time.
>          * Thus, write skb->tstamp as is if tstamp_type_access is true.
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index 1e8ab4749c6c..c1b8f2e7d966 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -382,8 +382,7 @@ config NET_SCH_FQ_PIE
>  config NET_SCH_INGRESS
>         tristate "Ingress/classifier-action Qdisc"
>         depends on NET_CLS_ACT
> -       select NET_INGRESS
> -       select NET_EGRESS
> +       select NET_XGRESS
>         help
>           Say Y here if you want to use classifiers for incoming and/or outgoing
>           packets. This qdisc doesn't do anything else besides running classifiers,
> @@ -753,6 +752,7 @@ config NET_EMATCH_IPT
>  config NET_CLS_ACT
>         bool "Actions"
>         select NET_CLS
> +       select NET_XGRESS
>         help
>           Say Y here if you want to use traffic control actions. Actions
>           get attached to classifiers and are invoked after a successful
> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> index 84838128b9c5..3bd37ee898ce 100644
> --- a/net/sched/sch_ingress.c
> +++ b/net/sched/sch_ingress.c
> @@ -13,6 +13,7 @@
>  #include <net/netlink.h>
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
> +#include <net/xtc.h>
>
>  struct ingress_sched_data {
>         struct tcf_block *block;
> @@ -78,11 +79,19 @@ static int ingress_init(struct Qdisc *sch, struct nlattr *opt,
>  {
>         struct ingress_sched_data *q = qdisc_priv(sch);
>         struct net_device *dev = qdisc_dev(sch);
> +       struct xtc_entry *entry;
> +       bool created;
>         int err;
>
>         net_inc_ingress_queue();
>
> -       mini_qdisc_pair_init(&q->miniqp, sch, &dev->miniq_ingress);
> +       entry = dev_xtc_entry_fetch(dev, true, &created);
> +       if (!entry)
> +               return -ENOMEM;
> +
> +       mini_qdisc_pair_init(&q->miniqp, sch, &entry->parent->miniq);
> +       if (created)
> +               dev_xtc_entry_update(dev, entry, true);
>
>         q->block_info.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
>         q->block_info.chain_head_change = clsact_chain_head_change;
> @@ -93,15 +102,20 @@ static int ingress_init(struct Qdisc *sch, struct nlattr *opt,
>                 return err;
>
>         mini_qdisc_pair_block_init(&q->miniqp, q->block);
> -
>         return 0;
>  }
>
>  static void ingress_destroy(struct Qdisc *sch)
>  {
>         struct ingress_sched_data *q = qdisc_priv(sch);
> +       struct net_device *dev = qdisc_dev(sch);
> +       struct xtc_entry *entry = rtnl_dereference(dev->xtc_ingress);
>
>         tcf_block_put_ext(q->block, sch, &q->block_info);
> +       if (entry && dev_xtc_entry_total(entry) == 0) {
> +               dev_xtc_entry_update(dev, NULL, true);
> +               dev_xtc_entry_free(entry);
> +       }
>         net_dec_ingress_queue();
>  }
>
> @@ -217,12 +231,20 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
>  {
>         struct clsact_sched_data *q = qdisc_priv(sch);
>         struct net_device *dev = qdisc_dev(sch);
> +       struct xtc_entry *entry;
> +       bool created;
>         int err;
>
>         net_inc_ingress_queue();
>         net_inc_egress_queue();
>
> -       mini_qdisc_pair_init(&q->miniqp_ingress, sch, &dev->miniq_ingress);
> +       entry = dev_xtc_entry_fetch(dev, true, &created);
> +       if (!entry)
> +               return -ENOMEM;
> +
> +       mini_qdisc_pair_init(&q->miniqp_ingress, sch, &entry->parent->miniq);
> +       if (created)
> +               dev_xtc_entry_update(dev, entry, true);
>
>         q->ingress_block_info.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
>         q->ingress_block_info.chain_head_change = clsact_chain_head_change;
> @@ -235,7 +257,13 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
>
>         mini_qdisc_pair_block_init(&q->miniqp_ingress, q->ingress_block);
>
> -       mini_qdisc_pair_init(&q->miniqp_egress, sch, &dev->miniq_egress);
> +       entry = dev_xtc_entry_fetch(dev, false, &created);
> +       if (!entry)
> +               return -ENOMEM;
> +
> +       mini_qdisc_pair_init(&q->miniqp_egress, sch, &entry->parent->miniq);
> +       if (created)
> +               dev_xtc_entry_update(dev, entry, false);
>
>         q->egress_block_info.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS;
>         q->egress_block_info.chain_head_change = clsact_chain_head_change;
> @@ -247,9 +275,21 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
>  static void clsact_destroy(struct Qdisc *sch)
>  {
>         struct clsact_sched_data *q = qdisc_priv(sch);
> +       struct net_device *dev = qdisc_dev(sch);
> +       struct xtc_entry *ingress_entry = rtnl_dereference(dev->xtc_ingress);
> +       struct xtc_entry *egress_entry = rtnl_dereference(dev->xtc_egress);
>
>         tcf_block_put_ext(q->egress_block, sch, &q->egress_block_info);
> +       if (egress_entry && dev_xtc_entry_total(egress_entry) == 0) {
> +               dev_xtc_entry_update(dev, NULL, false);
> +               dev_xtc_entry_free(egress_entry);
> +       }
> +
>         tcf_block_put_ext(q->ingress_block, sch, &q->ingress_block_info);
> +       if (ingress_entry && dev_xtc_entry_total(ingress_entry) == 0) {
> +               dev_xtc_entry_update(dev, NULL, true);
> +               dev_xtc_entry_free(ingress_entry);
> +       }
>
>         net_dec_ingress_queue();
>         net_dec_egress_queue();
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 51b9aa640ad2..de1f5546bcfe 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -1025,6 +1025,8 @@ enum bpf_attach_type {
>         BPF_PERF_EVENT,
>         BPF_TRACE_KPROBE_MULTI,
>         BPF_LSM_CGROUP,
> +       BPF_NET_INGRESS,
> +       BPF_NET_EGRESS,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -1399,14 +1401,20 @@ union bpf_attr {
>         };
>
>         struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH commands */
> -               __u32           target_fd;      /* container object to attach to */
> +               union {
> +                       __u32   target_fd;      /* container object to attach to */
> +                       __u32   target_ifindex; /* target ifindex */
> +               };
>                 __u32           attach_bpf_fd;  /* eBPF program to attach */
>                 __u32           attach_type;
>                 __u32           attach_flags;
> -               __u32           replace_bpf_fd; /* previously attached eBPF
> +               union {
> +                       __u32   attach_priority;
> +                       __u32   replace_bpf_fd; /* previously attached eBPF
>                                                  * program to replace if
>                                                  * BPF_F_REPLACE is used
>                                                  */
> +               };
>         };
>
>         struct { /* anonymous struct used by BPF_PROG_TEST_RUN command */
> @@ -1452,7 +1460,10 @@ union bpf_attr {
>         } info;
>
>         struct { /* anonymous struct used by BPF_PROG_QUERY command */
> -               __u32           target_fd;      /* container object to query */
> +               union {
> +                       __u32   target_fd;      /* container object to query */
> +                       __u32   target_ifindex; /* target ifindex */
> +               };
>                 __u32           attach_type;
>                 __u32           query_flags;
>                 __u32           attach_flags;
> @@ -6038,6 +6049,19 @@ struct bpf_sock_tuple {
>         };
>  };
>
> +/* (Simplified) user return codes for tc prog type.
> + * A valid tc program must return one of these defined values. All other
> + * return codes are reserved for future use. Must remain compatible with
> + * their TC_ACT_* counter-parts. For compatibility in behavior, unknown
> + * return codes are mapped to TC_NEXT.
> + */
> +enum tc_action_base {
> +       TC_NEXT         = -1,
> +       TC_PASS         = 0,
> +       TC_DROP         = 2,
> +       TC_REDIRECT     = 7,
> +};
> +
>  struct bpf_xdp_sock {
>         __u32 queue_id;
>  };
> @@ -6804,6 +6828,11 @@ struct bpf_flow_keys {
>         __be32  flow_label;
>  };
>
> +struct bpf_query_info {
> +       __u32 prog_id;
> +       __u32 prio;
> +};
> +
>  struct bpf_func_info {
>         __u32   insn_off;
>         __u32   type_id;
> --
> 2.34.1
>
