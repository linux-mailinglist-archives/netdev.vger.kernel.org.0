Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C98F251D58
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 18:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgHYQjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 12:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgHYQiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 12:38:55 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B13C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 09:38:55 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id u131so4107843vsu.11
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 09:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TplzKZDsC2J0AxKw4Abr8U6IUyhKY8wqWZRvEp1GTwg=;
        b=HNIZDknHdIXfBfM2Y4Tvs0t6/QavogZCrz1rQdpmdQXsgLCSb3gXKxgJSuQLkU8mES
         WDQtseMcUNm1xWoPIrRqIohkERnH0oawpI12lHOxiUKvclVBtx8eB2hKhu/lcEpqvb4T
         aOdvQl/ha+Lr4lwviieXIEepYGtIepRpAFOZIabcw0rM4BLBzVKLClDlO2l5izmWYaY7
         vPcBaR4RfbzvwZ3C0SiudozZxuGmWPeK3M0h4o/pXtfZ9fDyPHN0fp34HwJWkJfI1GUE
         Ng4TvlMVuheSpOm9IuiALsRQDXQ4ua/NGDyzBByWIeoQm6Ku6TdjewXGIntuT0wnCWQl
         K3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TplzKZDsC2J0AxKw4Abr8U6IUyhKY8wqWZRvEp1GTwg=;
        b=q/t/kPKSSmW3HlH9PYP+POisb/YVUwOaTZ3GS6+Qi3O0qnzixoDyBk7By6CcJOQTj5
         5Yx0JYC1PkC7SVHiMJhcpr+B27bjZ88gUUSLYdJ4lG+nwUDSO1qCMJ8RmBO0sruIqmKV
         O3Opev/yTVmaxQCGgy9SFGqyn0eAQTk9+cUey249cydPC5L85T1/BARSENC9XtO1rSry
         idGhXGq8RmDMGBc3MAjgZcl4MCA5bzUqVMV6VqnF2v30uXufmbsE1f7D0/IeX2sfkptP
         i8RcAowfmJe0F1d6xeycTEoDtIN5y4lHOTtZMBdl1ell/byHP8wOcgRc6d68Mj1oO38D
         OQhQ==
X-Gm-Message-State: AOAM530G+Ggjw5Nn78lX79izt2fkqeyyUA9yKYXx1UOP/CnDZLzVMN/B
        UnGp2RDwE/WNxCihMf0ws+hOKw33n1OHCywyhx0=
X-Google-Smtp-Source: ABdhPJwnehVcKDgJ7krcbOa2gTgx7anI00H8CsIPycgT5zUCYXMWAqkIr4SE5fn35nT/nl28anWBD2/juIqW7PRWHwM=
X-Received: by 2002:a67:2745:: with SMTP id n66mr5843971vsn.12.1598373534309;
 Tue, 25 Aug 2020 09:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200821190151.9792-1-nbd@nbd.name>
In-Reply-To: <20200821190151.9792-1-nbd@nbd.name>
From:   Wei Wang <tracywwnj@gmail.com>
Date:   Tue, 25 Aug 2020 09:38:42 -0700
Message-ID: <CAC15z3jqbpMPGx4QN3iGF8VmwnpMoy=0Wsz-Cv2wxXbM9=DHOg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] net: add support for threaded NAPI polling
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 12:03 PM Felix Fietkau <nbd@nbd.name> wrote:
>
> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
> poll function does not perform well. Since NAPI poll is bound to the CPU it
> was scheduled from, we can easily end up with a few very busy CPUs spending
> most of their time in softirq/ksoftirqd and some idle ones.
>
> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
> same except for using netif_threaded_napi_add instead of netif_napi_add.
>
> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
> thread.
>
> With threaded NAPI, throughput seems stable and consistent (and higher than
> the best results I got without it).
>
> Based on a patch by Hillf Danton
>
> Cc: Hillf Danton <hdanton@sina.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
> Changes since PATCH v2:
> - Split sysfs attribute into a separate patch
> - Take RTNL on attribute show
> - make napi_threaded attribute static
>
> Changes since PATCH v1:
> - use WQ_SYSFS to make workqueue configurable from user space
> - cancel work in netif_napi_del
> - add a sysfs file to enable/disable threaded NAPI for a netdev
>
> Changes since RFC v2:
> - fix unused but set variable reported by kbuild test robot
>
> Changes since RFC:
> - disable softirq around threaded poll functions
> - reuse most parts of napi_poll()
> - fix re-schedule condition
>
>  include/linux/netdevice.h |  23 +++++++
>  net/core/dev.c            | 139 +++++++++++++++++++++++++++-----------
>  2 files changed, 124 insertions(+), 38 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index b0e303f6603f..69507e6d4dc8 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -347,6 +347,7 @@ struct napi_struct {
>         struct list_head        dev_list;
>         struct hlist_node       napi_hash_node;
>         unsigned int            napi_id;
> +       struct work_struct      work;
>  };
>
>  enum {
> @@ -357,6 +358,7 @@ enum {
>         NAPI_STATE_HASHED,      /* In NAPI hash (busy polling possible) */
>         NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
>         NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
> +       NAPI_STATE_THREADED,    /* Use threaded NAPI */
>  };
>
>  enum {
> @@ -367,6 +369,7 @@ enum {
>         NAPIF_STATE_HASHED       = BIT(NAPI_STATE_HASHED),
>         NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
>         NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
> +       NAPIF_STATE_THREADED     = BIT(NAPI_STATE_THREADED),
>  };
>
>  enum gro_result {
> @@ -2327,6 +2330,26 @@ static inline void *netdev_priv(const struct net_device *dev)
>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>                     int (*poll)(struct napi_struct *, int), int weight);
>
> +/**
> + *     netif_threaded_napi_add - initialize a NAPI context
> + *     @dev:  network device
> + *     @napi: NAPI context
> + *     @poll: polling function
> + *     @weight: default weight
> + *
> + * This variant of netif_napi_add() should be used from drivers using NAPI
> + * with CPU intensive poll functions.
> + * This will schedule polling from a high priority workqueue
> + */
> +static inline void netif_threaded_napi_add(struct net_device *dev,
> +                                          struct napi_struct *napi,
> +                                          int (*poll)(struct napi_struct *, int),
> +                                          int weight)
> +{
> +       set_bit(NAPI_STATE_THREADED, &napi->state);
> +       netif_napi_add(dev, napi, poll, weight);
> +}
> +
>  /**
>   *     netif_tx_napi_add - initialize a NAPI context
>   *     @dev:  network device
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b5d1129d8310..b6165309617c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -157,6 +157,7 @@ static DEFINE_SPINLOCK(offload_lock);
>  struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
>  struct list_head ptype_all __read_mostly;      /* Taps */
>  static struct list_head offload_base __read_mostly;
> +static struct workqueue_struct *napi_workq __read_mostly;
>
>  static int netif_rx_internal(struct sk_buff *skb);
>  static int call_netdevice_notifiers_info(unsigned long val,
> @@ -6282,6 +6283,11 @@ void __napi_schedule(struct napi_struct *n)
>  {
>         unsigned long flags;
>
> +       if (test_bit(NAPI_STATE_THREADED, &n->state)) {
> +               queue_work(napi_workq, &n->work);
> +               return;
> +       }
> +
>         local_irq_save(flags);
>         ____napi_schedule(this_cpu_ptr(&softnet_data), n);
>         local_irq_restore(flags);
> @@ -6329,6 +6335,11 @@ EXPORT_SYMBOL(napi_schedule_prep);
>   */
>  void __napi_schedule_irqoff(struct napi_struct *n)
>  {
> +       if (test_bit(NAPI_STATE_THREADED, &n->state)) {
> +               queue_work(napi_workq, &n->work);
> +               return;
> +       }
> +
>         ____napi_schedule(this_cpu_ptr(&softnet_data), n);
>  }
>  EXPORT_SYMBOL(__napi_schedule_irqoff);
> @@ -6597,6 +6608,86 @@ static void init_gro_hash(struct napi_struct *napi)
>         napi->gro_bitmask = 0;
>  }
>
> +static int __napi_poll(struct napi_struct *n, bool *repoll)
> +{
> +       int work, weight;
> +
> +       weight = n->weight;
> +
> +       /* This NAPI_STATE_SCHED test is for avoiding a race
> +        * with netpoll's poll_napi().  Only the entity which
> +        * obtains the lock and sees NAPI_STATE_SCHED set will
> +        * actually make the ->poll() call.  Therefore we avoid
> +        * accidentally calling ->poll() when NAPI is not scheduled.
> +        */
> +       work = 0;
> +       if (test_bit(NAPI_STATE_SCHED, &n->state)) {
> +               work = n->poll(n, weight);
> +               trace_napi_poll(n, work, weight);
> +       }
> +
> +       if (unlikely(work > weight))
> +               pr_err_once("NAPI poll function %pS returned %d, exceeding its budget of %d.\n",
> +                           n->poll, work, weight);
> +
> +       if (likely(work < weight))
> +               return work;
> +
> +       /* Drivers must not modify the NAPI state if they
> +        * consume the entire weight.  In such cases this code
> +        * still "owns" the NAPI instance and therefore can
> +        * move the instance around on the list at-will.
> +        */
> +       if (unlikely(napi_disable_pending(n))) {
> +               napi_complete(n);
> +               return work;
> +       }
> +
> +       if (n->gro_bitmask) {
> +               /* flush too old packets
> +                * If HZ < 1000, flush all packets.
> +                */
> +               napi_gro_flush(n, HZ >= 1000);
> +       }
> +
> +       gro_normal_list(n);
> +
> +       *repoll = true;
> +
> +       return work;
> +}
> +
> +static void napi_workfn(struct work_struct *work)
> +{
> +       struct napi_struct *n = container_of(work, struct napi_struct, work);
> +       void *have;
> +
> +       for (;;) {
> +               bool repoll = false;
> +
> +               local_bh_disable();
> +
> +               have = netpoll_poll_lock(n);
> +               __napi_poll(n, &repoll);
> +               netpoll_poll_unlock(have);
> +
> +               local_bh_enable();
> +
> +               if (!repoll)
> +                       return;
> +
> +               if (!need_resched())
> +                       continue;
> +
> +               /*
> +                * have to pay for the latency of task switch even if
> +                * napi is scheduled
> +                */
> +               queue_work(napi_workq, work);
> +               return;
> +       }
> +}
> +
>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>                     int (*poll)(struct napi_struct *, int), int weight)
>  {
> @@ -6617,6 +6708,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>  #ifdef CONFIG_NETPOLL
>         napi->poll_owner = -1;
>  #endif
> +       INIT_WORK(&napi->work, napi_workfn);
>         set_bit(NAPI_STATE_SCHED, &napi->state);
>         napi_hash_add(napi);
>  }
> @@ -6655,6 +6747,7 @@ static void flush_gro_hash(struct napi_struct *napi)
>  void netif_napi_del(struct napi_struct *napi)
>  {
>         might_sleep();
> +       cancel_work_sync(&napi->work);
>         if (napi_hash_del(napi))
>                 synchronize_net();
>         list_del_init(&napi->dev_list);
> @@ -6667,53 +6760,19 @@ EXPORT_SYMBOL(netif_napi_del);
>
>  static int napi_poll(struct napi_struct *n, struct list_head *repoll)
>  {
> +       bool do_repoll = false;
>         void *have;
> -       int work, weight;
> +       int work;
>
>         list_del_init(&n->poll_list);
>
>         have = netpoll_poll_lock(n);
>
> -       weight = n->weight;
> +       work = __napi_poll(n, &do_repoll);
>
> -       /* This NAPI_STATE_SCHED test is for avoiding a race
> -        * with netpoll's poll_napi().  Only the entity which
> -        * obtains the lock and sees NAPI_STATE_SCHED set will
> -        * actually make the ->poll() call.  Therefore we avoid
> -        * accidentally calling ->poll() when NAPI is not scheduled.
> -        */
> -       work = 0;
> -       if (test_bit(NAPI_STATE_SCHED, &n->state)) {
> -               work = n->poll(n, weight);
> -               trace_napi_poll(n, work, weight);
> -       }
> -
> -       if (unlikely(work > weight))
> -               pr_err_once("NAPI poll function %pS returned %d, exceeding its budget of %d.\n",
> -                           n->poll, work, weight);
> -
> -       if (likely(work < weight))
> +       if (!do_repoll)
>                 goto out_unlock;
>
> -       /* Drivers must not modify the NAPI state if they
> -        * consume the entire weight.  In such cases this code
> -        * still "owns" the NAPI instance and therefore can
> -        * move the instance around on the list at-will.
> -        */
> -       if (unlikely(napi_disable_pending(n))) {
> -               napi_complete(n);
> -               goto out_unlock;
> -       }
> -
> -       if (n->gro_bitmask) {
> -               /* flush too old packets
> -                * If HZ < 1000, flush all packets.
> -                */
> -               napi_gro_flush(n, HZ >= 1000);
> -       }
> -
> -       gro_normal_list(n);
> -
>         /* Some drivers may have called napi_schedule
>          * prior to exhausting their budget.
>          */
> @@ -10975,6 +11034,10 @@ static int __init net_dev_init(void)
>                 sd->backlog.weight = weight_p;
>         }
>
> +       napi_workq = alloc_workqueue("napi_workq", WQ_UNBOUND | WQ_HIGHPRI,
> +                                    WQ_UNBOUND_MAX_ACTIVE | WQ_SYSFS);

I believe WQ_SYSFS should be passed to the 2nd parameter here.

> +       BUG_ON(!napi_workq);
> +
>         dev_boot_phase = 0;
>
>         /* The loopback device is special if any other network devices
> --
> 2.28.0
>
