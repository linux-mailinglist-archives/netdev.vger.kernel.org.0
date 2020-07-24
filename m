Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E810422BC10
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 04:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGXCiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 22:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbgGXCiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 22:38:02 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2520CC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 19:38:02 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id b13so3564479edz.7
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 19:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BLOvQ3PjW54fhKTiO7RMZXlrO+5U2CB4towSAPEHNlE=;
        b=RkJ5QTxa+0mWhTX1wKDJTBNqivwjKgMAHIlYm7a5O87pvmzaiwuXQc0mFdnLoODEGM
         wGQqhV4UZZ+jP/trmX1c2sb46LTKU0xQtD+KrH+BW4w1uJfg56cvUb/ytxuRjraPVPM5
         SsPZexepd1cB81eQgC1+mw8W1xEnBMiKVBQtrwY58ntODmSPH/C6q3cr8JhtX0YJyEdX
         iCKgaWHR1qeb2Cj9JenXt5Jhj3ielvhCJDenfEefb0XLa/1Q6Lc8WDGislh/3HeY85uF
         cmY78b18uiSLF1xC031IVSfYqxjaoNpBA8YJ9YiI8yUmy4+dhV77FKFeOzrqExc+/33E
         lzdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BLOvQ3PjW54fhKTiO7RMZXlrO+5U2CB4towSAPEHNlE=;
        b=U2IeIQDeJ5hqRYiW76N+NsjqgifDRbliNOhJOYVGApf/Ry/8MK+fwOMwa0rCs/ILWn
         GBQc/QPO8ucukwt+WPiQuEmhcUusjyAlR8swKwJNKRTcVzdbN1YWSDIhvnbTiGPBGmSV
         6qJwd7W7K1NKy+C6fB+XgnWIvS38zz2zOWEBmzk1nYK1+sIb09tWHlif34ZnXpNGEwM1
         qH4kP8pNkBzb3U7oogMFyiog0GjhqsjZikFiS4g7XAWOC5cWUfYZJ5utwIxurhY0UT4k
         CFLKjQx3SurPljMa2LXjdwOlcshj7yE3iqglZ5iDogDy3UU1Pqt5g8E12gNTorcdAeEx
         f8nw==
X-Gm-Message-State: AOAM531LPK/QhOI98Yf/TPJKy2guZwrpwEez7c22f48q/dPNQ8iJF0uO
        u0Vuk2hJi3GoG9jOydsYgMq8gk8uk11aMfuVn7E=
X-Google-Smtp-Source: ABdhPJzIapDFjZorEipDQYvKYFP7fN4ZYAGvTXFlM8DUyPBP1BSoQU0PwQfhJoVA1rK/yIABevM8PPO7jmw0S25kZMk=
X-Received: by 2002:aa7:c6d1:: with SMTP id b17mr7110512eds.201.1595558280731;
 Thu, 23 Jul 2020 19:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <159550903978.849915.17042128332582130595.stgit@ebuild> <159550910257.849915.11555297647620900746.stgit@ebuild>
In-Reply-To: <159550910257.849915.11555297647620900746.stgit@ebuild>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 24 Jul 2020 10:37:08 +0800
Message-ID: <CAMDZJNVsoUqQcvs4R+MNcrYVkkADRuz8QqHEX=GToT0YofKC6A@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v2 1/2] net: openvswitch: add masks
 cache hit counter
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 8:58 PM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Add a counter that counts the number of masks cache hits, and
> export it through the megaflow netlink statistics.
>
> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
LGTM
Reviewed-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

> ---
>  include/uapi/linux/openvswitch.h |    2 +-
>  net/openvswitch/datapath.c       |    5 ++++-
>  net/openvswitch/datapath.h       |    3 +++
>  net/openvswitch/flow_table.c     |   19 ++++++++++++++-----
>  net/openvswitch/flow_table.h     |    3 ++-
>  5 files changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 9b14519e74d9..7cb76e5ca7cf 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -102,8 +102,8 @@ struct ovs_dp_megaflow_stats {
>         __u64 n_mask_hit;        /* Number of masks used for flow lookups. */
>         __u32 n_masks;           /* Number of masks for the datapath. */
>         __u32 pad0;              /* Pad for future expension. */
> +       __u64 n_cache_hit;       /* Number of cache matches for flow lookups. */
>         __u64 pad1;              /* Pad for future expension. */
> -       __u64 pad2;              /* Pad for future expension. */
>  };
>
>  struct ovs_vport_stats {
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 95805f0e27bd..a54df1fe3ec4 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -225,13 +225,14 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>         struct dp_stats_percpu *stats;
>         u64 *stats_counter;
>         u32 n_mask_hit;
> +       u32 n_cache_hit;
>         int error;
>
>         stats = this_cpu_ptr(dp->stats_percpu);
>
>         /* Look up flow. */
>         flow = ovs_flow_tbl_lookup_stats(&dp->table, key, skb_get_hash(skb),
> -                                        &n_mask_hit);
> +                                        &n_mask_hit, &n_cache_hit);
>         if (unlikely(!flow)) {
>                 struct dp_upcall_info upcall;
>
> @@ -262,6 +263,7 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>         u64_stats_update_begin(&stats->syncp);
>         (*stats_counter)++;
>         stats->n_mask_hit += n_mask_hit;
> +       stats->n_cache_hit += n_cache_hit;
>         u64_stats_update_end(&stats->syncp);
>  }
>
> @@ -699,6 +701,7 @@ static void get_dp_stats(const struct datapath *dp, struct ovs_dp_stats *stats,
>                 stats->n_missed += local_stats.n_missed;
>                 stats->n_lost += local_stats.n_lost;
>                 mega_stats->n_mask_hit += local_stats.n_mask_hit;
> +               mega_stats->n_cache_hit += local_stats.n_cache_hit;
>         }
>  }
>
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index 697a2354194b..86d78613edb4 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -38,12 +38,15 @@
>   * @n_mask_hit: Number of masks looked up for flow match.
>   *   @n_mask_hit / (@n_hit + @n_missed)  will be the average masks looked
>   *   up per packet.
> + * @n_cache_hit: The number of received packets that had their mask found using
> + * the mask cache.
>   */
>  struct dp_stats_percpu {
>         u64 n_hit;
>         u64 n_missed;
>         u64 n_lost;
>         u64 n_mask_hit;
> +       u64 n_cache_hit;
>         struct u64_stats_sync syncp;
>  };
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index af22c9ee28dd..a5912ea05352 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -667,6 +667,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>                                    struct mask_array *ma,
>                                    const struct sw_flow_key *key,
>                                    u32 *n_mask_hit,
> +                                  u32 *n_cache_hit,
>                                    u32 *index)
>  {
>         u64 *usage_counters = this_cpu_ptr(ma->masks_usage_cntr);
> @@ -682,6 +683,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>                                 u64_stats_update_begin(&ma->syncp);
>                                 usage_counters[*index]++;
>                                 u64_stats_update_end(&ma->syncp);
> +                               (*n_cache_hit)++;
>                                 return flow;
>                         }
>                 }
> @@ -719,7 +721,8 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>  struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>                                           const struct sw_flow_key *key,
>                                           u32 skb_hash,
> -                                         u32 *n_mask_hit)
> +                                         u32 *n_mask_hit,
> +                                         u32 *n_cache_hit)
>  {
>         struct mask_array *ma = rcu_dereference(tbl->mask_array);
>         struct table_instance *ti = rcu_dereference(tbl->ti);
> @@ -729,10 +732,13 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>         int seg;
>
>         *n_mask_hit = 0;
> +       *n_cache_hit = 0;
>         if (unlikely(!skb_hash)) {
>                 u32 mask_index = 0;
> +               u32 cache = 0;
>
> -               return flow_lookup(tbl, ti, ma, key, n_mask_hit, &mask_index);
> +               return flow_lookup(tbl, ti, ma, key, n_mask_hit, &cache,
> +                                  &mask_index);
>         }
>
>         /* Pre and post recirulation flows usually have the same skb_hash
> @@ -753,7 +759,7 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>                 e = &entries[index];
>                 if (e->skb_hash == skb_hash) {
>                         flow = flow_lookup(tbl, ti, ma, key, n_mask_hit,
> -                                          &e->mask_index);
> +                                          n_cache_hit, &e->mask_index);
>                         if (!flow)
>                                 e->skb_hash = 0;
>                         return flow;
> @@ -766,10 +772,12 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>         }
>
>         /* Cache miss, do full lookup. */
> -       flow = flow_lookup(tbl, ti, ma, key, n_mask_hit, &ce->mask_index);
> +       flow = flow_lookup(tbl, ti, ma, key, n_mask_hit, n_cache_hit,
> +                          &ce->mask_index);
>         if (flow)
>                 ce->skb_hash = skb_hash;
>
> +       *n_cache_hit = 0;
>         return flow;
>  }
>
> @@ -779,9 +787,10 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
>         struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
>         struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
>         u32 __always_unused n_mask_hit;
> +       u32 __always_unused n_cache_hit;
>         u32 index = 0;
>
> -       return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &index);
> +       return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
>  }
>
>  struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
> diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
> index 1f664b050e3b..325e939371d8 100644
> --- a/net/openvswitch/flow_table.h
> +++ b/net/openvswitch/flow_table.h
> @@ -82,7 +82,8 @@ struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *table,
>  struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *,
>                                           const struct sw_flow_key *,
>                                           u32 skb_hash,
> -                                         u32 *n_mask_hit);
> +                                         u32 *n_mask_hit,
> +                                         u32 *n_cache_hit);
>  struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *,
>                                     const struct sw_flow_key *);
>  struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev



--
Best regards, Tonghao
