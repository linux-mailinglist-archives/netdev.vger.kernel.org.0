Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE54B233309
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 15:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgG3N1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 09:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgG3N1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 09:27:24 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCADC061794
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 06:27:23 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id c2so14086918edx.8
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 06:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ujga9MoEWLiX1cC2WnWkTeFnpAOUYgnKgIrrzwTDe5g=;
        b=MpdZXRUZl+bHKU8zQkDvH4medsqzCgxZ58hPYkRDcTK244kL+sNer7iZWK0SZEeke2
         OBYrh/JLBbefMAMINqrBSVDi7XXR86XVRgLR0zJdVJFawjiTQp5vCkwPPUBkKe4ZqfXW
         AzZRGSU8ByMTSoUgWcUeFQygT77Ucpc3s1NN2/xL9dB2HGTEcHKbkKWBiwMfI/7vm6Om
         uTd01BaDwhCV2q4vI/dOcdnS30DAap8QtML9As1MtQBIyHla+GVHWq+MyN0nFdhkyoSR
         sdKKvj0YM3PkXbPvtojU+loOUFVfR5c4ZtWTbEva9yIQorvM7C3KMbd5OGdrItXPyybN
         EW1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ujga9MoEWLiX1cC2WnWkTeFnpAOUYgnKgIrrzwTDe5g=;
        b=Z8Mux2AwrkkjgicHGFU8fEkm8zmRpTz5cP9H3Y/VYA0C3p3b8amlUODlWDra/nhde5
         ESFS+vxZ4GRHVonNLJVpI4flfubMk99Fi9tJPjirXTJqMZCoNpAxWtoYWKb8qldFWGfu
         S1JkcS4S2YCwTKxeDwu2Rk7m+L4AA7WVILAIfdZzyS4ZpXqszdN47mshNvPbMJPna9Zs
         /sS59+zkhfW3gJnB9X4fRLbxM6oQSTAIKjCyTc+ne6hZiK7wmTtp88sshH3EEI07VSPB
         23TQ4UEjr18gw//HhFQHnrKNyjzaXhwvEVVaii9NKxFjm40/Fo/qKh4N3kGNyp8/Mqtg
         sT6g==
X-Gm-Message-State: AOAM531fDUW6lv3UMDjAb8tBIW7uphgf0ZpLg5PozG8142/fwIm2Csjd
        d9deldFCPfg5Ovf5uhIQhOokVGWQ1iNfDTiZvj0=
X-Google-Smtp-Source: ABdhPJxSwoKwtn0iiQJh6+s2noKMBD+VRH79pENMf91YYv+QOZm7fIwTk8Z/J7tZgTueV+IeUs77P/17KiWIW7zTw/A=
X-Received: by 2002:a50:a187:: with SMTP id 7mr1263733edk.71.1596115641885;
 Thu, 30 Jul 2020 06:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <159602912600.937753.3123982828905970322.stgit@ebuild>
 <159602917888.937753.17718463910615059058.stgit@ebuild> <CAMDZJNUQeScZXRNe0TnAX08mmF-KHVvdM16AcQnaC8fay8ZH-g@mail.gmail.com>
 <C6B2B758-FF29-4463-8F38-757803D77779@redhat.com>
In-Reply-To: <C6B2B758-FF29-4463-8F38-757803D77779@redhat.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 30 Jul 2020 21:25:17 +0800
Message-ID: <CAMDZJNXPU0mqWabVfQJb2nczcOX8T8i-5n=VrVs4TnDHghOTyw@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 8:33 PM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Thanks Tonghao for the review, see comments inline below!
>
> If I get no more reviews by the end of the week I=E2=80=99ll send out a v=
4.
>
> //Eelco
>
>
> On 30 Jul 2020, at 7:07, Tonghao Zhang wrote:
>
> > On Wed, Jul 29, 2020 at 9:27 PM Eelco Chaudron <echaudro@redhat.com>
> > wrote:
> >>
> >> This patch makes the masks cache size configurable, or with
> >> a size of 0, disable it.
> >>
> >> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >> Changes in v3:
> >>  - Use is_power_of_2() function
> >>  - Use array_size() function
> >>  - Fix remaining sparse errors
> >>
> >> Changes in v2:
> >>  - Fix sparse warnings
> >>  - Fix netlink policy items reported by Florian Westphal
> >>
> >>  include/uapi/linux/openvswitch.h |    1
> >>  net/openvswitch/datapath.c       |   14 +++++
> >>  net/openvswitch/flow_table.c     |   97
> >> +++++++++++++++++++++++++++++++++-----
> >>  net/openvswitch/flow_table.h     |   10 ++++
> >>  4 files changed, 108 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/include/uapi/linux/openvswitch.h
> >> b/include/uapi/linux/openvswitch.h
> >> index 7cb76e5ca7cf..8300cc29dec8 100644
> >> --- a/include/uapi/linux/openvswitch.h
> >> +++ b/include/uapi/linux/openvswitch.h
> >> @@ -86,6 +86,7 @@ enum ovs_datapath_attr {
> >>         OVS_DP_ATTR_MEGAFLOW_STATS,     /* struct
> >> ovs_dp_megaflow_stats */
> >>         OVS_DP_ATTR_USER_FEATURES,      /* OVS_DP_F_*  */
> >>         OVS_DP_ATTR_PAD,
> >> +       OVS_DP_ATTR_MASKS_CACHE_SIZE,
> >>         __OVS_DP_ATTR_MAX
> >>  };
> >>
> >> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> >> index a54df1fe3ec4..114b2ddb8037 100644
> >> --- a/net/openvswitch/datapath.c
> >> +++ b/net/openvswitch/datapath.c
> >> @@ -1498,6 +1498,7 @@ static size_t ovs_dp_cmd_msg_size(void)
> >>         msgsize +=3D nla_total_size_64bit(sizeof(struct ovs_dp_stats))=
;
> >>         msgsize +=3D nla_total_size_64bit(sizeof(struct
> >> ovs_dp_megaflow_stats));
> >>         msgsize +=3D nla_total_size(sizeof(u32)); /*
> >> OVS_DP_ATTR_USER_FEATURES */
> >> +       msgsize +=3D nla_total_size(sizeof(u32)); /*
> >> OVS_DP_ATTR_MASKS_CACHE_SIZE */
> >>
> >>         return msgsize;
> >>  }
> >> @@ -1535,6 +1536,10 @@ static int ovs_dp_cmd_fill_info(struct
> >> datapath *dp, struct sk_buff *skb,
> >>         if (nla_put_u32(skb, OVS_DP_ATTR_USER_FEATURES,
> >> dp->user_features))
> >>                 goto nla_put_failure;
> >>
> >> +       if (nla_put_u32(skb, OVS_DP_ATTR_MASKS_CACHE_SIZE,
> >> +                       ovs_flow_tbl_masks_cache_size(&dp->table)))
> >> +               goto nla_put_failure;
> >> +
> >>         genlmsg_end(skb, ovs_header);
> >>         return 0;
> >>
> >> @@ -1599,6 +1604,13 @@ static int ovs_dp_change(struct datapath *dp,
> >> struct nlattr *a[])
> >>  #endif
> >>         }
> >>
> >> +       if (a[OVS_DP_ATTR_MASKS_CACHE_SIZE]) {
> >> +               u32 cache_size;
> >> +
> >> +               cache_size =3D
> >> nla_get_u32(a[OVS_DP_ATTR_MASKS_CACHE_SIZE]);
> >> +               ovs_flow_tbl_masks_cache_resize(&dp->table,
> >> cache_size);
> > Do we should return error code, if we can't change the "mask_cache"
> > size ? for example, -EINVAL, -ENOMEM
>
> Initially, I did not do this due to the fact the new value is reported,
> and on failure, the old value is shown.
> However thinking about it again, it makes more sense to return an error.
> Will sent a v4 with the following to return:
>
> -
> -void ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32
> size)
> +int ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32 size)
>   {
>          struct mask_cache *mc =3D rcu_dereference(table->mask_cache);
>          struct mask_cache *new;
>
>          if (size =3D=3D mc->cache_size)
> -               return;
> +               return 0;
> +
> +       if (!is_power_of_2(size) && size !=3D 0)
> +               return -EINVAL;
add check as below, and we can remove the check in
tbl_mask_cache_alloc function. That
function will only return NULL, if there is no memory. And we can
comment for tbl_mask_cache_alloc, to indicate that size should be a
power of 2.
 if ((!is_power_of_2(size) && size !=3D 0) ||
           (size * sizeof(struct mask_cache_entry)) > PCPU_MIN_UNIT_SIZE)

Thanks Eelco.
Reviewed-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

>          new =3D tbl_mask_cache_alloc(size);
>          if (!new)
> -               return;
> +               return -ENOMEM;
>
>          rcu_assign_pointer(table->mask_cache, new);
>          call_rcu(&mc->rcu, mask_cache_rcu_cb);
> +
> +       return 0;
>   }
>
> >> +       }
> >> +
> >>         dp->user_features =3D user_features;
> >>
> >>         if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
> >> @@ -1894,6 +1906,8 @@ static const struct nla_policy
> >> datapath_policy[OVS_DP_ATTR_MAX + 1] =3D {
> >>         [OVS_DP_ATTR_NAME] =3D { .type =3D NLA_NUL_STRING, .len =3D
> >> IFNAMSIZ - 1 },
> >>         [OVS_DP_ATTR_UPCALL_PID] =3D { .type =3D NLA_U32 },
> >>         [OVS_DP_ATTR_USER_FEATURES] =3D { .type =3D NLA_U32 },
> >> +       [OVS_DP_ATTR_MASKS_CACHE_SIZE] =3D  NLA_POLICY_RANGE(NLA_U32,
> >> 0,
> >> +               PCPU_MIN_UNIT_SIZE / sizeof(struct
> >> mask_cache_entry)),
> >>  };
> >>
> >>  static const struct genl_ops dp_datapath_genl_ops[] =3D {
> >> diff --git a/net/openvswitch/flow_table.c
> >> b/net/openvswitch/flow_table.c
> >> index a5912ea05352..5280aeeef628 100644
> >> --- a/net/openvswitch/flow_table.c
> >> +++ b/net/openvswitch/flow_table.c
> >> @@ -38,8 +38,8 @@
> >>  #define MASK_ARRAY_SIZE_MIN    16
> >>  #define REHASH_INTERVAL                (10 * 60 * HZ)
> >>
> >> +#define MC_DEFAULT_HASH_ENTRIES        256
> >>  #define MC_HASH_SHIFT          8
> >> -#define MC_HASH_ENTRIES                (1u << MC_HASH_SHIFT)
> >>  #define MC_HASH_SEGS           ((sizeof(uint32_t) * 8) /
> >> MC_HASH_SHIFT)
> >>
> >>  static struct kmem_cache *flow_cache;
> >> @@ -341,15 +341,75 @@ static void flow_mask_remove(struct flow_table
> >> *tbl, struct sw_flow_mask *mask)
> >>         }
> >>  }
> >>
> >> +static void __mask_cache_destroy(struct mask_cache *mc)
> >> +{
> >> +       if (mc->mask_cache)
> >> +               free_percpu(mc->mask_cache);
> > free_percpu the NULL is safe. we can remove the "if".
>
> Makes sense, will remove the if() check.
>
> >> +       kfree(mc);
> >> +}
> >> +
> >> +static void mask_cache_rcu_cb(struct rcu_head *rcu)
> >> +{
> >> +       struct mask_cache *mc =3D container_of(rcu, struct mask_cache,
> >> rcu);
> >> +
> >> +       __mask_cache_destroy(mc);
> >> +}
> >> +
> >> +static struct mask_cache *tbl_mask_cache_alloc(u32 size)
> >> +{
> >> +       struct mask_cache_entry __percpu *cache =3D NULL;
> >> +       struct mask_cache *new;
> >> +
> >> +       /* Only allow size to be 0, or a power of 2, and does not
> >> exceed
> >> +        * percpu allocation size.
> >> +        */
> >> +       if ((!is_power_of_2(size) && size !=3D 0) ||
> >> +           (size * sizeof(struct mask_cache_entry)) >
> >> PCPU_MIN_UNIT_SIZE)
> >> +               return NULL;
> >> +       new =3D kzalloc(sizeof(*new), GFP_KERNEL);
> >> +       if (!new)
> >> +               return NULL;
> >> +
> >> +       new->cache_size =3D size;
> >> +       if (new->cache_size > 0) {
> >> +               cache =3D __alloc_percpu(array_size(sizeof(struct
> >> mask_cache_entry),
> >> +                                                 new->cache_size),
> >> +                                      __alignof__(struct
> >> mask_cache_entry));
> >> +               if (!cache) {
> >> +                       kfree(new);
> >> +                       return NULL;
> >> +               }
> >> +       }
> >> +
> >> +       new->mask_cache =3D cache;
> >> +       return new;
> >> +}
> >> +
> >> +void ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32
> >> size)
> >> +{
> >> +       struct mask_cache *mc =3D rcu_dereference(table->mask_cache);
> >> +       struct mask_cache *new;
> >> +
> >> +       if (size =3D=3D mc->cache_size)
> >> +               return;
> >> +
> >> +       new =3D tbl_mask_cache_alloc(size);
> >> +       if (!new)
> >> +               return;
> >> +
> >> +       rcu_assign_pointer(table->mask_cache, new);
> >> +       call_rcu(&mc->rcu, mask_cache_rcu_cb);
> >> +}
> >> +
> >>  int ovs_flow_tbl_init(struct flow_table *table)
> >>  {
> >>         struct table_instance *ti, *ufid_ti;
> >> +       struct mask_cache *mc;
> >>         struct mask_array *ma;
> >>
> >> -       table->mask_cache =3D __alloc_percpu(sizeof(struct
> >> mask_cache_entry) *
> >> -                                          MC_HASH_ENTRIES,
> >> -                                          __alignof__(struct
> >> mask_cache_entry));
> >> -       if (!table->mask_cache)
> >> +       mc =3D tbl_mask_cache_alloc(MC_DEFAULT_HASH_ENTRIES);
> >> +       if (!mc)
> >>                 return -ENOMEM;
> >>
> >>         ma =3D tbl_mask_array_alloc(MASK_ARRAY_SIZE_MIN);
> >> @@ -367,6 +427,7 @@ int ovs_flow_tbl_init(struct flow_table *table)
> >>         rcu_assign_pointer(table->ti, ti);
> >>         rcu_assign_pointer(table->ufid_ti, ufid_ti);
> >>         rcu_assign_pointer(table->mask_array, ma);
> >> +       rcu_assign_pointer(table->mask_cache, mc);
> >>         table->last_rehash =3D jiffies;
> >>         table->count =3D 0;
> >>         table->ufid_count =3D 0;
> >> @@ -377,7 +438,7 @@ int ovs_flow_tbl_init(struct flow_table *table)
> >>  free_mask_array:
> >>         __mask_array_destroy(ma);
> >>  free_mask_cache:
> >> -       free_percpu(table->mask_cache);
> >> +       __mask_cache_destroy(mc);
> >>         return -ENOMEM;
> >>  }
> >>
> >> @@ -453,9 +514,11 @@ void ovs_flow_tbl_destroy(struct flow_table
> >> *table)
> >>  {
> >>         struct table_instance *ti =3D rcu_dereference_raw(table->ti);
> >>         struct table_instance *ufid_ti =3D
> >> rcu_dereference_raw(table->ufid_ti);
> >> +       struct mask_cache *mc =3D rcu_dereference(table->mask_cache);
> >> +       struct mask_array *ma =3D
> >> rcu_dereference_ovsl(table->mask_array);
> >>
> >> -       free_percpu(table->mask_cache);
> >> -       call_rcu(&table->mask_array->rcu, mask_array_rcu_cb);
> >> +       call_rcu(&mc->rcu, mask_cache_rcu_cb);
> >> +       call_rcu(&ma->rcu, mask_array_rcu_cb);
> >>         table_instance_destroy(table, ti, ufid_ti, false);
> >>  }
> >>
> >> @@ -724,6 +787,7 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct
> >> flow_table *tbl,
> >>                                           u32 *n_mask_hit,
> >>                                           u32 *n_cache_hit)
> >>  {
> >> +       struct mask_cache *mc =3D rcu_dereference(tbl->mask_cache);
> >>         struct mask_array *ma =3D rcu_dereference(tbl->mask_array);
> >>         struct table_instance *ti =3D rcu_dereference(tbl->ti);
> >>         struct mask_cache_entry *entries, *ce;
> >> @@ -733,7 +797,7 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct
> >> flow_table *tbl,
> >>
> >>         *n_mask_hit =3D 0;
> >>         *n_cache_hit =3D 0;
> >> -       if (unlikely(!skb_hash)) {
> >> +       if (unlikely(!skb_hash || mc->cache_size =3D=3D 0)) {
> >>                 u32 mask_index =3D 0;
> >>                 u32 cache =3D 0;
> >>
> >> @@ -749,11 +813,11 @@ struct sw_flow
> >> *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
> >>
> >>         ce =3D NULL;
> >>         hash =3D skb_hash;
> >> -       entries =3D this_cpu_ptr(tbl->mask_cache);
> >> +       entries =3D this_cpu_ptr(mc->mask_cache);
> >>
> >>         /* Find the cache entry 'ce' to operate on. */
> >>         for (seg =3D 0; seg < MC_HASH_SEGS; seg++) {
> >> -               int index =3D hash & (MC_HASH_ENTRIES - 1);
> >> +               int index =3D hash & (mc->cache_size - 1);
> >>                 struct mask_cache_entry *e;
> >>
> >>                 e =3D &entries[index];
> >> @@ -867,6 +931,13 @@ int ovs_flow_tbl_num_masks(const struct
> >> flow_table *table)
> >>         return READ_ONCE(ma->count);
> >>  }
> >>
> >> +u32 ovs_flow_tbl_masks_cache_size(const struct flow_table *table)
> >> +{
> >> +       struct mask_cache *mc =3D rcu_dereference(table->mask_cache);
> >> +
> >> +       return READ_ONCE(mc->cache_size);
> >> +}
> >> +
> >>  static struct table_instance *table_instance_expand(struct
> >> table_instance *ti,
> >>                                                     bool ufid)
> >>  {
> >> @@ -1095,8 +1166,8 @@ void ovs_flow_masks_rebalance(struct flow_table
> >> *table)
> >>         for (i =3D 0; i < masks_entries; i++) {
> >>                 int index =3D masks_and_count[i].index;
> >>
> >> -               new->masks[new->count++] =3D
> >> -                       rcu_dereference_ovsl(ma->masks[index]);
> >> +               if (ovsl_dereference(ma->masks[index]))
> >> +                       new->masks[new->count++] =3D ma->masks[index];
> >>         }
> >>
> >>         rcu_assign_pointer(table->mask_array, new);
> >> diff --git a/net/openvswitch/flow_table.h
> >> b/net/openvswitch/flow_table.h
> >> index 325e939371d8..f2dba952db2f 100644
> >> --- a/net/openvswitch/flow_table.h
> >> +++ b/net/openvswitch/flow_table.h
> >> @@ -27,6 +27,12 @@ struct mask_cache_entry {
> >>         u32 mask_index;
> >>  };
> >>
> >> +struct mask_cache {
> >> +       struct rcu_head rcu;
> >> +       u32 cache_size;  /* Must be ^2 value. */
> >> +       struct mask_cache_entry __percpu *mask_cache;
> >> +};
> >> +
> >>  struct mask_count {
> >>         int index;
> >>         u64 counter;
> >> @@ -53,7 +59,7 @@ struct table_instance {
> >>  struct flow_table {
> >>         struct table_instance __rcu *ti;
> >>         struct table_instance __rcu *ufid_ti;
> >> -       struct mask_cache_entry __percpu *mask_cache;
> >> +       struct mask_cache __rcu *mask_cache;
> >>         struct mask_array __rcu *mask_array;
> >>         unsigned long last_rehash;
> >>         unsigned int count;
> >> @@ -77,6 +83,8 @@ int ovs_flow_tbl_insert(struct flow_table *table,
> >> struct sw_flow *flow,
> >>                         const struct sw_flow_mask *mask);
> >>  void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow
> >> *flow);
> >>  int  ovs_flow_tbl_num_masks(const struct flow_table *table);
> >> +u32  ovs_flow_tbl_masks_cache_size(const struct flow_table *table);
> >> +void ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32
> >> size);
> >>  struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *table,
> >>                                        u32 *bucket, u32 *idx);
> >>  struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *,
> >>
> >
> >
> > --
> > Best regards, Tonghao
>


--=20
Best regards, Tonghao
