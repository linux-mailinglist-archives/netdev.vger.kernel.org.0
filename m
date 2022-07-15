Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B08A575E31
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbiGOJG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 05:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiGOJG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 05:06:26 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57A125F0
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 02:06:25 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-31c89653790so40963917b3.13
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 02:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q0DPOX83nEOYBT2gqo/J3SEuTaoRSoS4kdxioklTJSY=;
        b=bL6NK9zKO4cF0qRfb4q+UQm5eVWPmE1UsGAUVb2JulTnOGC+ZHOPgHv8YOF6ELlvuO
         tsPJf7XvoG0KSz/L9unnXiJZCRg4KH3iHPpbXxMwRL5zeFr4zcPU1oQUoSqi23nmC1bv
         NvKLqVo4Q9EcscyRvuEewktdB2sJ5C85ReTH/FQCDxOuLAGEmrsvmd5pMf8XU3wnhOmr
         k4igWNUJH5jo0mJFchvxeB+JW0FwbUxs2GqVOyUk1F+qaaYH0Epv2xB6ES9kCmtHGpc6
         PGKFn4oOCpD1sBRf7utKwRIc3Top6wzPxXEbSN/KGy1UOXx/AFJ39dM4RSq/KitgeF1U
         I0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q0DPOX83nEOYBT2gqo/J3SEuTaoRSoS4kdxioklTJSY=;
        b=3VRBstePleSx9SAveQHveE5sFytq0ixrpCxe5npQd7zNdaSf1A6vxwAGdgxN2m99Zs
         8KPJ76hPuEEF6/DcERUbB97kl3pzHdoOYvbgw94GTxdw1BBWb2uG/Os3MjlecDZej7cd
         r5+4TItpOW7cQcnq+NXff+G1btppfSsyfrtorDTyss1020NPHTsSq3L+yYN+1VNxxGDs
         D871/oV2rmNBIAWF65wOYl/Gxcshg0bHVDttO5mjyrFZ/QXDGx0MYXhHnd9a0UMprbIz
         T5Q7F2BSrd1us1B+n7dojLoXnbCCkYSJuFq3XKcfEbIq7w8rr5vPsh13kC+hiduEb9Mu
         XDqw==
X-Gm-Message-State: AJIora8Iy4dPrp6v4nW3r3J9oRDm5a6WTb+crrhwSz7xHc26zqyO+nTa
        IGx/Vz+34dOCEvoMApbMtJdo/+6w6/iHYRWt3W42pQ==
X-Google-Smtp-Source: AGRyM1s5leLljv0BGgqPThtEEnGyMDEcLTazn4UJBaFRqEfOu1QqpsfkHWf60bdi83+Ld8UdtH4FZktNexZKlc4VTzU=
X-Received: by 2002:a81:9b93:0:b0:317:8c9d:4c22 with SMTP id
 s141-20020a819b93000000b003178c9d4c22mr14920505ywg.278.1657875984559; Fri, 15
 Jul 2022 02:06:24 -0700 (PDT)
MIME-Version: 1.0
References: <1657865077-38272-1-git-send-email-liyonglong@chinatelecom.cn>
In-Reply-To: <1657865077-38272-1-git-send-email-liyonglong@chinatelecom.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 15 Jul 2022 11:06:13 +0200
Message-ID: <CANn89iKn6Z1ZGE-6vNML7s5zmM+_B03NafZ8JCeNP_3oLHGV+Q@mail.gmail.com>
Subject: Re: [PATCH v3] net: sort queues in xps maps
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

echo ff > /sys/class/net/eth0/queues/tx-0/xps_cpus


On Fri, Jul 15, 2022 at 8:04 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>
> in the following case that set xps of each tx-queue with same cpu mask,
> packets in the same tcp stream may be hash to different tx queue. Because
> the order of queues in each xps map is not the same.
>
> first set each tx-queue with different cpu mask
> $ echo 0 > /sys/class/net/eth0/queues/tx-0/xps_cpus
> $ echo 1 > /sys/class/net/eth0/queues/tx-1/xps_cpus
> $ echo 2 > /sys/class/net/eth0/queues/tx-2/xps_cpus
> $ echo 4 > /sys/class/net/eth0/queues/tx-3/xps_cpus
> and then set each tx-queue with same cpu mask
> $ echo f > /sys/class/net/eth0/queues/tx-0/xps_cpus
> $ echo f > /sys/class/net/eth0/queues/tx-1/xps_cpus
> $ echo f > /sys/class/net/eth0/queues/tx-2/xps_cpus
> $ echo f > /sys/class/net/eth0/queues/tx-3/xps_cpus

I am not sure why anybody would do that.

>
> at this point the order of each map queues is differnet, It will cause
> packets in the same stream be hashed to diffetent tx queue:
> attr_map[0].queues = [0,1,2,3]
> attr_map[1].queues = [1,0,2,3]
> attr_map[2].queues = [2,0,1,3]
> attr_map[3].queues = [3,0,1,2]

It is not clear to me what is the problem you want to solve.

XPS also has logic to make sure that we do not spread packets of the
same flow into multiple TX queues,
regardless of chosen configuration.

We only care about OOO.

Each skb has skb->ooo_okay for this.

TCP can know if it is okay to select a different TX queue than prior packets.



>
> It is more reasonable that pacekts in the same stream be hashed to the same
> tx queue when all tx queue bind with the same CPUs.

This won't help if you now select

echo ff > /sys/class/net/eth0/queues/tx-0/xps_cpus
echo fc > /sys/class/net/eth0/queues/tx-1/xps_cpus
echo f0 > /sys/class/net/eth0/queues/tx-2/xps_cpus
echo c0 > /sys/class/net/eth0/queues/tx-3/xps_cpus

So really your patch is not needed IMO.

It also tries to correct user configuration errors.

XPS has not been designed to allow arbitrary settings.

Documentation/networking/scaling.rst has this paragraph :

The goal of this mapping is usually to assign queues
exclusively to a subset of CPUs, where the transmit completions for
these queues are processed on a CPU within this set.




>
> v1 -> v2:
> Jakub suggestion: factor out the second loop in __netif_set_xps_queue() -
> starting from the "add tx-queue to CPU/rx-queue maps" comment into a helper
> v2 -> v3:
> keep the skip_tc in __netif_set_xps_queue()
>
> Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
> ---
>  net/core/dev.c | 45 +++++++++++++++++++++++++++++----------------
>  1 file changed, 29 insertions(+), 16 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 978ed06..f011513 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -150,6 +150,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/prandom.h>
>  #include <linux/once_lite.h>
> +#include <linux/sort.h>
>
>  #include "dev.h"
>  #include "net-sysfs.h"
> @@ -199,6 +200,11 @@ static int call_netdevice_notifiers_extack(unsigned long val,
>
>  static DECLARE_RWSEM(devnet_rename_sem);
>
> +static int cmp_u16(const void *a, const void *b)
> +{
> +       return *(u16 *)a - *(u16 *)b;
> +}
> +
>  static inline void dev_base_seq_inc(struct net *net)
>  {
>         while (++net->dev_base_seq == 0)
> @@ -2537,6 +2543,28 @@ static void xps_copy_dev_maps(struct xps_dev_maps *dev_maps,
>         }
>  }
>
> +static void update_xps_map(struct xps_map *map, int cpu, u16 index,
> +                          int *numa_node_id, enum xps_map_type type)
> +{
> +       int pos = 0;
> +
> +       while ((pos < map->len) && (map->queues[pos] != index))
> +               pos++;
> +
> +       if (pos == map->len)
> +               map->queues[map->len++] = index;
> +
> +       sort(map->queues, map->len, sizeof(u16), cmp_u16, NULL);
> +#ifdef CONFIG_NUMA
> +       if (type == XPS_CPUS) {
> +               if (*numa_node_id == -2)
> +                       *numa_node_id = cpu_to_node(cpu);
> +               else if (*numa_node_id != cpu_to_node(cpu))
> +                       *numa_node_id = -1;
> +       }
> +#endif
> +}
> +
>  /* Must be called under cpus_read_lock */
>  int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>                           u16 index, enum xps_map_type type)
> @@ -2629,24 +2657,9 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>                 if (netif_attr_test_mask(j, mask, nr_ids) &&
>                     netif_attr_test_online(j, online_mask, nr_ids)) {
>                         /* add tx-queue to CPU/rx-queue maps */
> -                       int pos = 0;
> -
>                         skip_tc = true;
> -
>                         map = xmap_dereference(new_dev_maps->attr_map[tci]);
> -                       while ((pos < map->len) && (map->queues[pos] != index))
> -                               pos++;
> -
> -                       if (pos == map->len)
> -                               map->queues[map->len++] = index;
> -#ifdef CONFIG_NUMA
> -                       if (type == XPS_CPUS) {
> -                               if (numa_node_id == -2)
> -                                       numa_node_id = cpu_to_node(j);
> -                               else if (numa_node_id != cpu_to_node(j))
> -                                       numa_node_id = -1;
> -                       }
> -#endif
> +                       update_xps_map(map, j, index, &numa_node_id, type);
>                 }
>
>                 if (copy)
> --
> 1.8.3.1
>
