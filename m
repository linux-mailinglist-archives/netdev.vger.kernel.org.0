Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9979E6210A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbfGHPBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:01:44 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44407 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730281AbfGHPBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:01:43 -0400
Received: by mail-io1-f66.google.com with SMTP id s7so35917913iob.11
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 08:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VOoN2+xKD1I47YFr07XmF+CXLd76nlEkeL55LMF8i+c=;
        b=gMxMldG75qddCs4rTlH+JAYEohq1O31++G/IASTWbyTA/XR5kS4+tIL+2flE4M2KqH
         8l6JBYoo5IevWSCTAwAC6Tvj0KUEgtrdiQtPRknP8NOqtVoOxdXMwSCyvUqJ+PVSMpAG
         HsoxWItGUlhabarEjfcPIpocy9tjmYCoU8C5ydVYuH/EqGI/BuYFz679PX4NuaaPyyZP
         gE9KDr5jidPmbbTZ8PMdecTfLD5y9qbwxL8FZxF0EFRitpGHIP1CK15xG9MwxQVys1+C
         6hLmxucyX5JCno3nrqzD6gmOUK9SsuAc/GO59jBPVW5xS5VPsQB5G7uEsXQY8LJWOtv/
         53XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VOoN2+xKD1I47YFr07XmF+CXLd76nlEkeL55LMF8i+c=;
        b=tStwYTaFpLq9RTgoPHJSLDLs9foEj8nDp5DjULV2zfjoU78OD9Sg6p70/gKdXaC40I
         lbS+T8vTGswknTHhZdCRKebn7ePpYj5DxbRxjAil0+UG1VhpAJpKPEt29xs5Qe2fyihO
         XIFPal6nx6ipT3Kvr8X/bPxX1VKetEmSzCeELGU9r53HimfPo1wh6mI1+4PhHsAY/DAP
         +nqSelX1SBrUHPWB6+yZhS1fxDV3g3ibE7/WvthaO5rbQGYIDpT0nETyL7t9GaHsPyVH
         6V0gXampbnRj8V3dvMMaq205Ui8mBhY18xAeVsvhB6aRO45VxsNurPLRf6/MLZW6UqHa
         lTxQ==
X-Gm-Message-State: APjAAAWlRbeertjgVOxZzCTv5JR4iQpxtElUW9zGG5DhGHTc0J0/thfg
        tXgglbmT6F7Ne2dxDzHc3kt4NycvooyvFPoMJlY=
X-Google-Smtp-Source: APXvYqx/5KCvgEqaYn6EiS0oKRWy0RtAOML2pTyMs3iPgE5mJ5Vz0DFHME/ihIq9lzVcXZjgfg5KK+Bbkc/1LwLYYeU=
X-Received: by 2002:a5e:8b43:: with SMTP id z3mr19724310iom.287.1562598101972;
 Mon, 08 Jul 2019 08:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
 <156240283595.10171.8867063497268976931.stgit@alrua-x1> <CAH3MdRU+FXDMdQr9Q-BP8eiMLwaV6Mn2oic3kXwK4wxvw+tJAQ@mail.gmail.com>
 <874l3w26lb.fsf@toke.dk>
In-Reply-To: <874l3w26lb.fsf@toke.dk>
From:   Y Song <ys114321@gmail.com>
Date:   Mon, 8 Jul 2019 08:01:05 -0700
Message-ID: <CAH3MdRU02Y_av7eRefUtopOthKib-8pzL-+5VT=G6G9STp1aqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/6] xdp: Add devmap_hash map type for looking
 up devices by hashed index
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 2:55 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Y Song <ys114321@gmail.com> writes:
>
> > On Sat, Jul 6, 2019 at 1:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> A common pattern when using xdp_redirect_map() is to create a device m=
ap
> >> where the lookup key is simply ifindex. Because device maps are arrays=
,
> >> this leaves holes in the map, and the map has to be sized to fit the
> >> largest ifindex, regardless of how many devices actually are actually
> >> needed in the map.
> >>
> >> This patch adds a second type of device map where the key is looked up
> >> using a hashmap, instead of being used as an array index. This allows =
maps
> >> to be densely packed, so they can be smaller.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  include/linux/bpf.h        |    7 ++
> >>  include/linux/bpf_types.h  |    1
> >>  include/trace/events/xdp.h |    3 -
> >>  kernel/bpf/devmap.c        |  192 +++++++++++++++++++++++++++++++++++=
+++++++++
> >>  kernel/bpf/verifier.c      |    2
> >>  net/core/filter.c          |    9 ++
> >>  6 files changed, 211 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >> index bfdb54dd2ad1..f9a506147c8a 100644
> >> --- a/include/linux/bpf.h
> >> +++ b/include/linux/bpf.h
> >> @@ -713,6 +713,7 @@ struct xdp_buff;
> >>  struct sk_buff;
> >>
> >>  struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u3=
2 key);
> >> +struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *ma=
p, u32 key);
> >>  void __dev_map_flush(struct bpf_map *map);
> >>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp=
,
> >>                     struct net_device *dev_rx);
> >> @@ -799,6 +800,12 @@ static inline struct net_device  *__dev_map_looku=
p_elem(struct bpf_map *map,
> >>         return NULL;
> >>  }
> >>
> >> +static inline struct net_device  *__dev_map_hash_lookup_elem(struct b=
pf_map *map,
> >> +                                                            u32 key)
> >> +{
> >> +       return NULL;
> >> +}
> >> +
> >>  static inline void __dev_map_flush(struct bpf_map *map)
> >>  {
> >>  }
> >> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> >> index eec5aeeeaf92..36a9c2325176 100644
> >> --- a/include/linux/bpf_types.h
> >> +++ b/include/linux/bpf_types.h
> >> @@ -62,6 +62,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY_OF_MAPS, array_of_ma=
ps_map_ops)
> >>  BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops)
> >>  #ifdef CONFIG_NET
> >>  BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
> >> +BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
> >>  BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
> >>  #if defined(CONFIG_BPF_STREAM_PARSER)
> >>  BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKMAP, sock_map_ops)
> >> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> >> index 68899fdc985b..8c8420230a10 100644
> >> --- a/include/trace/events/xdp.h
> >> +++ b/include/trace/events/xdp.h
> >> @@ -175,7 +175,8 @@ struct _bpf_dtab_netdev {
> >>  #endif /* __DEVMAP_OBJ_TYPE */
> >>
> >>  #define devmap_ifindex(fwd, map)                               \
> >> -       ((map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP) ?               \
> >> +       ((map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP ||               \
> >> +         map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) ?          \
> >>           ((struct _bpf_dtab_netdev *)fwd)->dev->ifindex : 0)
> >>
> >>  #define _trace_xdp_redirect_map(dev, xdp, fwd, map, idx)             =
  \
> >> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> >> index a2fe16362129..341af02f049d 100644
> >> --- a/kernel/bpf/devmap.c
> >> +++ b/kernel/bpf/devmap.c
> >> @@ -37,6 +37,12 @@
> >>   * notifier hook walks the map we know that new dev references can no=
t be
> >>   * added by the user because core infrastructure ensures dev_get_by_i=
ndex()
> >>   * calls will fail at this point.
> >> + *
> >> + * The devmap_hash type is a map type which interprets keys as ifinde=
xes and
> >> + * indexes these using a hashmap. This allows maps that use ifindex a=
s key to be
> >> + * densely packed instead of having holes in the lookup array for unu=
sed
> >> + * ifindexes. The setup and packet enqueue/send code is shared betwee=
n the two
> >> + * types of devmap; only the lookup and insertion is different.
> >>   */
> >>  #include <linux/bpf.h>
> >>  #include <net/xdp.h>
> >> @@ -59,6 +65,7 @@ struct xdp_bulk_queue {
> >>
> >>  struct bpf_dtab_netdev {
> >>         struct net_device *dev; /* must be first member, due to tracep=
oint */
> >> +       struct hlist_node index_hlist;
> >>         struct bpf_dtab *dtab;
> >>         unsigned int idx; /* keep track of map index for tracepoint */
> >>         struct xdp_bulk_queue __percpu *bulkq;
> >> @@ -70,11 +77,29 @@ struct bpf_dtab {
> >>         struct bpf_dtab_netdev **netdev_map;
> >>         struct list_head __percpu *flush_list;
> >>         struct list_head list;
> >> +
> >> +       /* these are only used for DEVMAP_HASH type maps */
> >> +       unsigned int items;
> >> +       struct hlist_head *dev_index_head;
> >> +       spinlock_t index_lock;
> >>  };
> >>
> >>  static DEFINE_SPINLOCK(dev_map_lock);
> >>  static LIST_HEAD(dev_map_list);
> >>
> >> +static struct hlist_head *dev_map_create_hash(void)
> >> +{
> >> +       int i;
> >> +       struct hlist_head *hash;
> >> +
> >> +       hash =3D kmalloc_array(NETDEV_HASHENTRIES, sizeof(*hash), GFP_=
KERNEL);
> >> +       if (hash !=3D NULL)
> >> +               for (i =3D 0; i < NETDEV_HASHENTRIES; i++)
> >> +                       INIT_HLIST_HEAD(&hash[i]);
> >> +
> >> +       return hash;
> >> +}
> >> +
> >>  static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *at=
tr,
> >>                             bool check_memlock)
> >>  {
> >> @@ -98,6 +123,9 @@ static int dev_map_init_map(struct bpf_dtab *dtab, =
union bpf_attr *attr,
> >>         cost =3D (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_=
netdev *);
> >>         cost +=3D sizeof(struct list_head) * num_possible_cpus();
> >>
> >> +       if (attr->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH)
> >> +               cost +=3D sizeof(struct hlist_head) * NETDEV_HASHENTRI=
ES;
> >> +
> >>         /* if map size is larger than memlock limit, reject it */
> >>         err =3D bpf_map_charge_init(&dtab->map.memory, cost);
> >>         if (err)
> >> @@ -116,8 +144,18 @@ static int dev_map_init_map(struct bpf_dtab *dtab=
, union bpf_attr *attr,
> >>         if (!dtab->netdev_map)
> >>                 goto free_percpu;
> >>
> >> +       if (attr->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) {
> >> +               dtab->dev_index_head =3D dev_map_create_hash();
> >> +               if (!dtab->dev_index_head)
> >> +                       goto free_map_area;
> >> +
> >> +               spin_lock_init(&dtab->index_lock);
> >> +       }
> >> +
> >>         return 0;
> >>
> >> +free_map_area:
> >> +       bpf_map_area_free(dtab->netdev_map);
> >>  free_percpu:
> >>         free_percpu(dtab->flush_list);
> >>  free_charge:
> >> @@ -199,6 +237,7 @@ static void dev_map_free(struct bpf_map *map)
> >>
> >>         free_percpu(dtab->flush_list);
> >>         bpf_map_area_free(dtab->netdev_map);
> >> +       kfree(dtab->dev_index_head);
> >>         kfree(dtab);
> >>  }
> >>
> >> @@ -219,6 +258,70 @@ static int dev_map_get_next_key(struct bpf_map *m=
ap, void *key, void *next_key)
> >>         return 0;
> >>  }
> >>
> >> +static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *=
dtab,
> >> +                                                   int idx)
> >> +{
> >> +       return &dtab->dev_index_head[idx & (NETDEV_HASHENTRIES - 1)];
> >> +}
> >> +
> >> +struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *ma=
p, u32 key)
> >> +{
> >> +       struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, m=
ap);
> >> +       struct hlist_head *head =3D dev_map_index_hash(dtab, key);
> >> +       struct bpf_dtab_netdev *dev;
> >> +
> >> +       hlist_for_each_entry_rcu(dev, head, index_hlist)
> >> +               if (dev->idx =3D=3D key)
> >> +                       return dev;
> >> +
> >> +       return NULL;
> >> +}
> >> +
> >> +static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
> >> +                                   void *next_key)
> >> +{
> >> +       struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, m=
ap);
> >> +       u32 idx, *next =3D next_key;
> >> +       struct bpf_dtab_netdev *dev, *next_dev;
> >> +       struct hlist_head *head;
> >> +       int i =3D 0;
> >> +
> >> +       if (!key)
> >> +               goto find_first;
> >> +
> >> +       idx =3D *(u32 *)key;
> >> +
> >> +       dev =3D __dev_map_hash_lookup_elem(map, idx);
> >> +       if (!dev)
> >> +               goto find_first;
> >> +
> >> +       next_dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_next_r=
cu(&dev->index_hlist)),
> >> +                                   struct bpf_dtab_netdev, index_hlis=
t);
> >
> > Just want to get a better understanding. Why do you want
> > hlist_entry_safe instead of hlist_entry?
>
> Erm, because the entry might not exist? The _safe variant just checks
> the list pointer before casting to the containing struct.

hlist_entry_safe is certainly correct. Just want to better understand when
the entry might not exist. By looking at hashtab.c implementation, it has
the same possible-null-entry assumption, so we should be ok here.

>
> > Also, maybe rcu_dereference instead of rcu_dereference_raw?
>
> Well, the _raw() variant comes from the equivalent function in
> hashtab.c, where I originally nicked most of this function, so think it
> makes more sense to keep them the same.

Okay.

>
> > dev_map_hash_get_next_key() is called in syscall.c within rcu_read_lock=
 region.
> >
> >> +
> >> +       if (next_dev) {
> >> +               *next =3D next_dev->idx;
> >> +               return 0;
> >> +       }
> >> +
> >> +       i =3D idx & (NETDEV_HASHENTRIES - 1);
> >> +       i++;
> >> +
> >> + find_first:
> >> +       for (; i < NETDEV_HASHENTRIES; i++) {
> >> +               head =3D dev_map_index_hash(dtab, i);
> >> +
> >> +               next_dev =3D hlist_entry_safe(rcu_dereference_raw(hlis=
t_first_rcu(head)),
> >> +                                           struct bpf_dtab_netdev,
> >> +                                           index_hlist);
> >
> > ditto. The same question as the above.
> >
> >> +               if (next_dev) {
> >> +                       *next =3D next_dev->idx;
> >> +                       return 0;
> >> +               }
> >> +       }
> >> +
> >> +       return -ENOENT;
> >> +}
> >> +
> >>  static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags,
> >>                        bool in_napi_ctx)
> >>  {
> >> @@ -374,6 +477,15 @@ static void *dev_map_lookup_elem(struct bpf_map *=
map, void *key)
> >>         return dev ? &dev->ifindex : NULL;
> >>  }
> >>
> >> +static void *dev_map_hash_lookup_elem(struct bpf_map *map, void *key)
> >> +{
> >> +       struct bpf_dtab_netdev *obj =3D __dev_map_hash_lookup_elem(map=
,
> >> +                                                               *(u32 =
*)key);
> >> +       struct net_device *dev =3D obj ? obj->dev : NULL;
> >
> > When obj->dev could be NULL?
>
> Never. This could just as well be written as
>
> return obj ? obj->dev->ifindex : NULL;
>
> but writing it this way keeps it consistent with the existing
> dev_map_lookup_elem() function.

Okay then in order to be consistent with the existing code base.

Thanks for all the explanation!
