Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A2E232B2A
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgG3FJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3FJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 01:09:32 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22F2C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 22:09:31 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a14so2030777edx.7
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 22:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3LPOdaqjjKsQaZ0aAiXTcBfesHNbp1iEDZZ0fpzJwms=;
        b=Mfm5zqEV7n6+Di4lxThx2LqmyY8tYL0Z5UfCaEyvleOHsV1NEgWSBrfdxMDSnId2hr
         1QZ6+tRmseI4RBaXxSlExwuHAhsSycFGd7GxUHy4eNY6YDJ+tWCbuEQ2nslEHYcj9mgQ
         S0/DyHtB+LNjaQONSE0Cy/CmMS9v+5NPG9iwRz5XpjqpNSfgjq9KdoypJEq0QTuKY8a6
         bqB+oeAME2LH11ktAnyP6pD0nWkE9HV+EXmMZjlfVaVK107yHDR5cCbXkIdu0i6KsgFt
         Jj7NNGoFBR6Jmzq9gtdSbVouD420PRzJTRK96XiWBODU9CWUr16vI3s4pRqXnlM2V0gX
         lovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3LPOdaqjjKsQaZ0aAiXTcBfesHNbp1iEDZZ0fpzJwms=;
        b=TG4ed4pfkDLE5eTihuhDKf+HovEd0eXSKN7eJm0D0hQDTR+lh2Ii/AeaOcPCPOVgD7
         KR771YzbBHRjgCKNDpIrh71UIy9WFcQjUYwGqN6JhyfWBgBRmsWhbavQFOWoucd+sQV9
         NVPXSFLguVKmtauEov76ter3CqyBXslwCpSSr2KIwvnOr+bfEp+TQVMLJegf3JR9agon
         EruR/Q0/wp+aWLJzzjkU6WTUPOCu8/n4TjbGW67nbKrHnRuUYYaXdozDlbJUjlYVgqPn
         gPqp+OFincr75IIOELu/1AzQov/lWuejO3Em3sR64AxXhp1AOaPh9Qhd5zHx+3qZSLYM
         /ozA==
X-Gm-Message-State: AOAM5336bH8Zw2gqax2G9gQY8aPeTQIMLvBxWgSWZaUA26fix1Dfp+2P
        E+/fLj1JNnEY7z+pNYsA9giA/4DI748WUa2ryHdDF0r0oS4=
X-Google-Smtp-Source: ABdhPJxYdkgVYlwIlWP6xbADRP17jbv467LD7Bvwnm7RMjfePYXBnB5kv74ix/15pTVTWMnVOHAGXFvquGQprDrf1co=
X-Received: by 2002:a05:6402:b32:: with SMTP id bo18mr1020535edb.201.1596085770303;
 Wed, 29 Jul 2020 22:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <159602912600.937753.3123982828905970322.stgit@ebuild> <159602917888.937753.17718463910615059058.stgit@ebuild>
In-Reply-To: <159602917888.937753.17718463910615059058.stgit@ebuild>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 30 Jul 2020 13:07:26 +0800
Message-ID: <CAMDZJNUQeScZXRNe0TnAX08mmF-KHVvdM16AcQnaC8fay8ZH-g@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: openvswitch: make masks cache size configurable
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 9:27 PM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> This patch makes the masks cache size configurable, or with
> a size of 0, disable it.
>
> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
> Changes in v3:
>  - Use is_power_of_2() function
>  - Use array_size() function
>  - Fix remaining sparse errors
>
> Changes in v2:
>  - Fix sparse warnings
>  - Fix netlink policy items reported by Florian Westphal
>
>  include/uapi/linux/openvswitch.h |    1
>  net/openvswitch/datapath.c       |   14 +++++
>  net/openvswitch/flow_table.c     |   97 +++++++++++++++++++++++++++++++++-----
>  net/openvswitch/flow_table.h     |   10 ++++
>  4 files changed, 108 insertions(+), 14 deletions(-)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 7cb76e5ca7cf..8300cc29dec8 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -86,6 +86,7 @@ enum ovs_datapath_attr {
>         OVS_DP_ATTR_MEGAFLOW_STATS,     /* struct ovs_dp_megaflow_stats */
>         OVS_DP_ATTR_USER_FEATURES,      /* OVS_DP_F_*  */
>         OVS_DP_ATTR_PAD,
> +       OVS_DP_ATTR_MASKS_CACHE_SIZE,
>         __OVS_DP_ATTR_MAX
>  };
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index a54df1fe3ec4..114b2ddb8037 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1498,6 +1498,7 @@ static size_t ovs_dp_cmd_msg_size(void)
>         msgsize += nla_total_size_64bit(sizeof(struct ovs_dp_stats));
>         msgsize += nla_total_size_64bit(sizeof(struct ovs_dp_megaflow_stats));
>         msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_USER_FEATURES */
> +       msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_MASKS_CACHE_SIZE */
>
>         return msgsize;
>  }
> @@ -1535,6 +1536,10 @@ static int ovs_dp_cmd_fill_info(struct datapath *dp, struct sk_buff *skb,
>         if (nla_put_u32(skb, OVS_DP_ATTR_USER_FEATURES, dp->user_features))
>                 goto nla_put_failure;
>
> +       if (nla_put_u32(skb, OVS_DP_ATTR_MASKS_CACHE_SIZE,
> +                       ovs_flow_tbl_masks_cache_size(&dp->table)))
> +               goto nla_put_failure;
> +
>         genlmsg_end(skb, ovs_header);
>         return 0;
>
> @@ -1599,6 +1604,13 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
>  #endif
>         }
>
> +       if (a[OVS_DP_ATTR_MASKS_CACHE_SIZE]) {
> +               u32 cache_size;
> +
> +               cache_size = nla_get_u32(a[OVS_DP_ATTR_MASKS_CACHE_SIZE]);
> +               ovs_flow_tbl_masks_cache_resize(&dp->table, cache_size);
Do we should return error code, if we can't change the "mask_cache"
size ? for example, -EINVAL, -ENOMEM
> +       }
> +
>         dp->user_features = user_features;
>
>         if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
> @@ -1894,6 +1906,8 @@ static const struct nla_policy datapath_policy[OVS_DP_ATTR_MAX + 1] = {
>         [OVS_DP_ATTR_NAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ - 1 },
>         [OVS_DP_ATTR_UPCALL_PID] = { .type = NLA_U32 },
>         [OVS_DP_ATTR_USER_FEATURES] = { .type = NLA_U32 },
> +       [OVS_DP_ATTR_MASKS_CACHE_SIZE] =  NLA_POLICY_RANGE(NLA_U32, 0,
> +               PCPU_MIN_UNIT_SIZE / sizeof(struct mask_cache_entry)),
>  };
>
>  static const struct genl_ops dp_datapath_genl_ops[] = {
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index a5912ea05352..5280aeeef628 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -38,8 +38,8 @@
>  #define MASK_ARRAY_SIZE_MIN    16
>  #define REHASH_INTERVAL                (10 * 60 * HZ)
>
> +#define MC_DEFAULT_HASH_ENTRIES        256
>  #define MC_HASH_SHIFT          8
> -#define MC_HASH_ENTRIES                (1u << MC_HASH_SHIFT)
>  #define MC_HASH_SEGS           ((sizeof(uint32_t) * 8) / MC_HASH_SHIFT)
>
>  static struct kmem_cache *flow_cache;
> @@ -341,15 +341,75 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
>         }
>  }
>
> +static void __mask_cache_destroy(struct mask_cache *mc)
> +{
> +       if (mc->mask_cache)
> +               free_percpu(mc->mask_cache);
free_percpu the NULL is safe. we can remove the "if".
> +       kfree(mc);
> +}
> +
> +static void mask_cache_rcu_cb(struct rcu_head *rcu)
> +{
> +       struct mask_cache *mc = container_of(rcu, struct mask_cache, rcu);
> +
> +       __mask_cache_destroy(mc);
> +}
> +
> +static struct mask_cache *tbl_mask_cache_alloc(u32 size)
> +{
> +       struct mask_cache_entry __percpu *cache = NULL;
> +       struct mask_cache *new;
> +
> +       /* Only allow size to be 0, or a power of 2, and does not exceed
> +        * percpu allocation size.
> +        */
> +       if ((!is_power_of_2(size) && size != 0) ||
> +           (size * sizeof(struct mask_cache_entry)) > PCPU_MIN_UNIT_SIZE)
> +               return NULL;
> +       new = kzalloc(sizeof(*new), GFP_KERNEL);
> +       if (!new)
> +               return NULL;
> +
> +       new->cache_size = size;
> +       if (new->cache_size > 0) {
> +               cache = __alloc_percpu(array_size(sizeof(struct mask_cache_entry),
> +                                                 new->cache_size),
> +                                      __alignof__(struct mask_cache_entry));
> +               if (!cache) {
> +                       kfree(new);
> +                       return NULL;
> +               }
> +       }
> +
> +       new->mask_cache = cache;
> +       return new;
> +}
> +
> +void ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32 size)
> +{
> +       struct mask_cache *mc = rcu_dereference(table->mask_cache);
> +       struct mask_cache *new;
> +
> +       if (size == mc->cache_size)
> +               return;
> +
> +       new = tbl_mask_cache_alloc(size);
> +       if (!new)
> +               return;
> +
> +       rcu_assign_pointer(table->mask_cache, new);
> +       call_rcu(&mc->rcu, mask_cache_rcu_cb);
> +}
> +
>  int ovs_flow_tbl_init(struct flow_table *table)
>  {
>         struct table_instance *ti, *ufid_ti;
> +       struct mask_cache *mc;
>         struct mask_array *ma;
>
> -       table->mask_cache = __alloc_percpu(sizeof(struct mask_cache_entry) *
> -                                          MC_HASH_ENTRIES,
> -                                          __alignof__(struct mask_cache_entry));
> -       if (!table->mask_cache)
> +       mc = tbl_mask_cache_alloc(MC_DEFAULT_HASH_ENTRIES);
> +       if (!mc)
>                 return -ENOMEM;
>
>         ma = tbl_mask_array_alloc(MASK_ARRAY_SIZE_MIN);
> @@ -367,6 +427,7 @@ int ovs_flow_tbl_init(struct flow_table *table)
>         rcu_assign_pointer(table->ti, ti);
>         rcu_assign_pointer(table->ufid_ti, ufid_ti);
>         rcu_assign_pointer(table->mask_array, ma);
> +       rcu_assign_pointer(table->mask_cache, mc);
>         table->last_rehash = jiffies;
>         table->count = 0;
>         table->ufid_count = 0;
> @@ -377,7 +438,7 @@ int ovs_flow_tbl_init(struct flow_table *table)
>  free_mask_array:
>         __mask_array_destroy(ma);
>  free_mask_cache:
> -       free_percpu(table->mask_cache);
> +       __mask_cache_destroy(mc);
>         return -ENOMEM;
>  }
>
> @@ -453,9 +514,11 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
>  {
>         struct table_instance *ti = rcu_dereference_raw(table->ti);
>         struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
> +       struct mask_cache *mc = rcu_dereference(table->mask_cache);
> +       struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
>
> -       free_percpu(table->mask_cache);
> -       call_rcu(&table->mask_array->rcu, mask_array_rcu_cb);
> +       call_rcu(&mc->rcu, mask_cache_rcu_cb);
> +       call_rcu(&ma->rcu, mask_array_rcu_cb);
>         table_instance_destroy(table, ti, ufid_ti, false);
>  }
>
> @@ -724,6 +787,7 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>                                           u32 *n_mask_hit,
>                                           u32 *n_cache_hit)
>  {
> +       struct mask_cache *mc = rcu_dereference(tbl->mask_cache);
>         struct mask_array *ma = rcu_dereference(tbl->mask_array);
>         struct table_instance *ti = rcu_dereference(tbl->ti);
>         struct mask_cache_entry *entries, *ce;
> @@ -733,7 +797,7 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>
>         *n_mask_hit = 0;
>         *n_cache_hit = 0;
> -       if (unlikely(!skb_hash)) {
> +       if (unlikely(!skb_hash || mc->cache_size == 0)) {
>                 u32 mask_index = 0;
>                 u32 cache = 0;
>
> @@ -749,11 +813,11 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>
>         ce = NULL;
>         hash = skb_hash;
> -       entries = this_cpu_ptr(tbl->mask_cache);
> +       entries = this_cpu_ptr(mc->mask_cache);
>
>         /* Find the cache entry 'ce' to operate on. */
>         for (seg = 0; seg < MC_HASH_SEGS; seg++) {
> -               int index = hash & (MC_HASH_ENTRIES - 1);
> +               int index = hash & (mc->cache_size - 1);
>                 struct mask_cache_entry *e;
>
>                 e = &entries[index];
> @@ -867,6 +931,13 @@ int ovs_flow_tbl_num_masks(const struct flow_table *table)
>         return READ_ONCE(ma->count);
>  }
>
> +u32 ovs_flow_tbl_masks_cache_size(const struct flow_table *table)
> +{
> +       struct mask_cache *mc = rcu_dereference(table->mask_cache);
> +
> +       return READ_ONCE(mc->cache_size);
> +}
> +
>  static struct table_instance *table_instance_expand(struct table_instance *ti,
>                                                     bool ufid)
>  {
> @@ -1095,8 +1166,8 @@ void ovs_flow_masks_rebalance(struct flow_table *table)
>         for (i = 0; i < masks_entries; i++) {
>                 int index = masks_and_count[i].index;
>
> -               new->masks[new->count++] =
> -                       rcu_dereference_ovsl(ma->masks[index]);
> +               if (ovsl_dereference(ma->masks[index]))
> +                       new->masks[new->count++] = ma->masks[index];
>         }
>
>         rcu_assign_pointer(table->mask_array, new);
> diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
> index 325e939371d8..f2dba952db2f 100644
> --- a/net/openvswitch/flow_table.h
> +++ b/net/openvswitch/flow_table.h
> @@ -27,6 +27,12 @@ struct mask_cache_entry {
>         u32 mask_index;
>  };
>
> +struct mask_cache {
> +       struct rcu_head rcu;
> +       u32 cache_size;  /* Must be ^2 value. */
> +       struct mask_cache_entry __percpu *mask_cache;
> +};
> +
>  struct mask_count {
>         int index;
>         u64 counter;
> @@ -53,7 +59,7 @@ struct table_instance {
>  struct flow_table {
>         struct table_instance __rcu *ti;
>         struct table_instance __rcu *ufid_ti;
> -       struct mask_cache_entry __percpu *mask_cache;
> +       struct mask_cache __rcu *mask_cache;
>         struct mask_array __rcu *mask_array;
>         unsigned long last_rehash;
>         unsigned int count;
> @@ -77,6 +83,8 @@ int ovs_flow_tbl_insert(struct flow_table *table, struct sw_flow *flow,
>                         const struct sw_flow_mask *mask);
>  void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow);
>  int  ovs_flow_tbl_num_masks(const struct flow_table *table);
> +u32  ovs_flow_tbl_masks_cache_size(const struct flow_table *table);
> +void ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32 size);
>  struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *table,
>                                        u32 *bucket, u32 *idx);
>  struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *,
>


-- 
Best regards, Tonghao
