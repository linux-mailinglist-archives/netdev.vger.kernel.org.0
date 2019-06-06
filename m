Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E511F36FF1
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfFFJdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:33:43 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34925 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbfFFJdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:33:43 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so1863200qto.2;
        Thu, 06 Jun 2019 02:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9ODbXZaLOIzJvk93kRp0nBcWbVQLkF32VZJ+jV9D3mA=;
        b=K4xBuf1V6Nhb6IK3dp1z/VSXIWT0r882IUzJBNW2+lcjETnym3GqzLn9Daneb20rZa
         sVV9vSHCG11JTTVOapKF4Zmt+zrVb0BAKSw8/nxg8/oJAkeaKmXoz1QwldMUIEQWsF4f
         k9AjKUB7yEM9PyaURhFDu1ydqv6MNtFhos8s9VlUHDS3MkgG37+BNnSiSG4duusavcx4
         qwFRzRmRsL/ZbxOCpNASLnvRF8xbH2Rf9EWgMM8isUQ/7dXl4B9oyTeoDtjHNZMcNF9C
         fayP5/JT2rXWuQkgmf41oO/M9HoRJ2uS/w2PWwYlcho0yM0PZJhzVeAY6SxB9tfWXV4C
         Qt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9ODbXZaLOIzJvk93kRp0nBcWbVQLkF32VZJ+jV9D3mA=;
        b=t0edr2jshlxD9BZEJX3wwSwgO95jF8tvZp4UsTlNjj+6ZXpRIf7cgcSWK7zyFrrnQG
         MpPiEY9bPRdzuo0KwYUn5DI2JuQK9SEYESkHCz9mu1T3bJWQdUyWtHVvYnSYrSjjFx9E
         kRcn+wNEOCPycYK4KauFZOaWEKF2q6b8HxrNoGUS38HLi+IfITi8ZuODMj0O7QbECVrN
         mXayFIgSWkgkWt0oSMMFzP/MryQwZFDb0zVH+UKFMqm+O/10+nu+oVlPoSNdCMa5Mz1g
         255ua/5eF9hCKuL22nV2AgJr8mFB+F8wRuwRnaZMGBtkFkp9PWSdN+jaTlAEI+QKYBKJ
         TUDA==
X-Gm-Message-State: APjAAAUKOT3lXwnXcfpD8VP7BWOI9HDctL7hSnK2e8jK1uq2dlsX1w9A
        mKUbjxp1Kjg63qfFjLo7CLodGKR5Q6m4Djai75g=
X-Google-Smtp-Source: APXvYqw5vSKm20Om6xwSm3uHW+VQTnBjpNMiNjNCTVi/C/Am+Lw4Xv/Nj0xAiJLSyBWIe1CGYUxNMfEaeWwDC4/MxU0=
X-Received: by 2002:ac8:4442:: with SMTP id m2mr17017745qtn.107.1559813621964;
 Thu, 06 Jun 2019 02:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190522133742.7654-1-bjorn.topel@gmail.com> <20190522133742.7654-2-bjorn.topel@gmail.com>
 <CAPhsuW7asezC+0MA3tNyU9ms0rX9iP7Dk0QW4qqXvNvSECrpGA@mail.gmail.com> <CAJ+HfNggDLVCzAqsFS06+xa6uyH95+jC=74kAi-cJYUcwwnmCg@mail.gmail.com>
In-Reply-To: <CAJ+HfNggDLVCzAqsFS06+xa6uyH95+jC=74kAi-cJYUcwwnmCg@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 6 Jun 2019 11:33:30 +0200
Message-ID: <CAJ+HfNh2=_Z8te_jrqVZwenqzxEEEOYSxju8vBAAN1_4JnBXzg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] xsk: remove AF_XDP socket from map when
 the socket is released
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 at 11:25, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> =
wrote:
>
> On Sun, 2 Jun 2019 at 00:32, Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > On Wed, May 22, 2019 at 6:38 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmai=
l.com> wrote:
> > >
> > > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > >
> > > When an AF_XDP socket is released/closed the XSKMAP still holds a
> > > reference to the socket in a "released" state. The socket will still
> > > use the netdev queue resource, and block newly created sockets from
> > > attaching to that queue, but no user application can access the
> > > fill/complete/rx/tx queues. This results in that all applications nee=
d
> > > to explicitly clear the map entry from the old "zombie state"
> > > socket. This should be done automatically.
> > >
> > > After this patch, when a socket is released, it will remove itself
> > > from all the XSKMAPs it resides in, allowing the socket application t=
o
> > > remove the code that cleans the XSKMAP entry.
> > >
> > > This behavior is also closer to that of SOCKMAP, making the two socke=
t
> > > maps more consistent.
> > >
> > > Suggested-by: Bruce Richardson <bruce.richardson@intel.com>
> > > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > > ---
> > >  include/net/xdp_sock.h |   3 ++
> > >  kernel/bpf/xskmap.c    | 101 +++++++++++++++++++++++++++++++++++----=
--
> > >  net/xdp/xsk.c          |  25 ++++++++++
> > >  3 files changed, 116 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> > > index d074b6d60f8a..b5f8f9f826d0 100644
> > > --- a/include/net/xdp_sock.h
> > > +++ b/include/net/xdp_sock.h
> > > @@ -68,6 +68,8 @@ struct xdp_sock {
> > >          */
> > >         spinlock_t tx_completion_lock;
> > >         u64 rx_dropped;
> > > +       struct list_head map_list;
> > > +       spinlock_t map_list_lock;
> > >  };
> > >
> > >  struct xdp_buff;
> > > @@ -87,6 +89,7 @@ struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xd=
p_umem *umem,
> > >                                           struct xdp_umem_fq_reuse *n=
ewq);
> > >  void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
> > >  struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 q=
ueue_id);
> > > +void xsk_map_delete_from_node(struct xdp_sock *xs, struct list_head =
*node);
> > >
> > >  static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 add=
r)
> > >  {
> > > diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> > > index 686d244e798d..318f6a07fa31 100644
> > > --- a/kernel/bpf/xskmap.c
> > > +++ b/kernel/bpf/xskmap.c
> > > @@ -13,8 +13,58 @@ struct xsk_map {
> > >         struct bpf_map map;
> > >         struct xdp_sock **xsk_map;
> > >         struct list_head __percpu *flush_list;
> > > +       spinlock_t lock;
> > >  };
> > >
> > > +/* Nodes are linked in the struct xdp_sock map_list field, and used =
to
> > > + * track which maps a certain socket reside in.
> > > + */
> > > +struct xsk_map_node {
> > > +       struct list_head node;
> > > +       struct xsk_map *map;
> > > +       struct xdp_sock **map_entry;
> > > +};
> >
> > Why do we need map_entry to be struct xdp_sock **? I think we could
> > just use struct xdp_sock *? Or did I miss anytihg?
> >
>
> It's a reference into the map (which is an array of xdp_sock *), so
> that it's simple to clear. Would you prefer storing the index of the
> map, and doing a lookup?
>

Song, does the ** make more sense now?

Thanks for looking at the series.


Bj=C3=B6rn

> Bj=C3=B6rn
>
> > Thanks,
> > Song
> >
> >
> > > +
> > > +static struct xsk_map_node *xsk_map_node_alloc(void)
> > > +{
> > > +       return kzalloc(sizeof(struct xsk_map_node), GFP_ATOMIC | __GF=
P_NOWARN);
> > > +}
> > > +
> > > +static void xsk_map_node_free(struct xsk_map_node *node)
> > > +{
> > > +       kfree(node);
> > > +}
> > > +
> > > +static void xsk_map_node_init(struct xsk_map_node *node,
> > > +                             struct xsk_map *map,
> > > +                             struct xdp_sock **map_entry)
> > > +{
> > > +       node->map =3D map;
> > > +       node->map_entry =3D map_entry;
> > > +}
> > > +
> > > +static void xsk_map_add_node(struct xdp_sock *xs, struct xsk_map_nod=
e *node)
> > > +{
> > > +       spin_lock_bh(&xs->map_list_lock);
> > > +       list_add_tail(&node->node, &xs->map_list);
> > > +       spin_unlock_bh(&xs->map_list_lock);
> > > +}
> > > +
> > > +static void xsk_map_del_node(struct xdp_sock *xs, struct xdp_sock **=
map_entry)
> > > +{
> > > +       struct xsk_map_node *n, *tmp;
> > > +
> > > +       spin_lock_bh(&xs->map_list_lock);
> > > +       list_for_each_entry_safe(n, tmp, &xs->map_list, node) {
> > > +               if (map_entry =3D=3D n->map_entry) {
> > > +                       list_del(&n->node);
> > > +                       xsk_map_node_free(n);
> > > +               }
> > > +       }
> > > +       spin_unlock_bh(&xs->map_list_lock);
> > > +
> > > +}
> > > +
> > >  static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
> > >  {
> > >         int cpu, err =3D -EINVAL;
> > > @@ -34,6 +84,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr=
 *attr)
> > >                 return ERR_PTR(-ENOMEM);
> > >
> > >         bpf_map_init_from_attr(&m->map, attr);
> > > +       spin_lock_init(&m->lock);
> > >
> > >         cost =3D (u64)m->map.max_entries * sizeof(struct xdp_sock *);
> > >         cost +=3D sizeof(struct list_head) * num_possible_cpus();
> > > @@ -78,15 +129,16 @@ static void xsk_map_free(struct bpf_map *map)
> > >         bpf_clear_redirect_map(map);
> > >         synchronize_net();
> > >
> > > +       spin_lock_bh(&m->lock);
> > >         for (i =3D 0; i < map->max_entries; i++) {
> > > -               struct xdp_sock *xs;
> > > -
> > > -               xs =3D m->xsk_map[i];
> > > -               if (!xs)
> > > -                       continue;
> > > +               struct xdp_sock **map_entry =3D &m->xsk_map[i];
> > > +               struct xdp_sock *old_xs;
> > >
> > > -               sock_put((struct sock *)xs);
> > > +               old_xs =3D xchg(map_entry, NULL);
> > > +               if (old_xs)
> > > +                       xsk_map_del_node(old_xs, map_entry);
> > >         }
> > > +       spin_unlock_bh(&m->lock);
> > >
> > >         free_percpu(m->flush_list);
> > >         bpf_map_area_free(m->xsk_map);
> > > @@ -162,7 +214,8 @@ static int xsk_map_update_elem(struct bpf_map *ma=
p, void *key, void *value,
> > >  {
> > >         struct xsk_map *m =3D container_of(map, struct xsk_map, map);
> > >         u32 i =3D *(u32 *)key, fd =3D *(u32 *)value;
> > > -       struct xdp_sock *xs, *old_xs;
> > > +       struct xdp_sock *xs, *old_xs, **entry;
> > > +       struct xsk_map_node *node;
> > >         struct socket *sock;
> > >         int err;
> > >
> > > @@ -189,11 +242,20 @@ static int xsk_map_update_elem(struct bpf_map *=
map, void *key, void *value,
> > >                 return -EOPNOTSUPP;
> > >         }
> > >
> > > -       sock_hold(sock->sk);
> > > +       node =3D xsk_map_node_alloc();
> > > +       if (!node) {
> > > +               sockfd_put(sock);
> > > +               return -ENOMEM;
> > > +       }
> > >
> > > -       old_xs =3D xchg(&m->xsk_map[i], xs);
> > > +       spin_lock_bh(&m->lock);
> > > +       entry =3D &m->xsk_map[i];
> > > +       xsk_map_node_init(node, m, entry);
> > > +       xsk_map_add_node(xs, node);
> > > +       old_xs =3D xchg(entry, xs);
> > >         if (old_xs)
> > > -               sock_put((struct sock *)old_xs);
> > > +               xsk_map_del_node(old_xs, entry);
> > > +       spin_unlock_bh(&m->lock);
> > >
> > >         sockfd_put(sock);
> > >         return 0;
> > > @@ -202,19 +264,32 @@ static int xsk_map_update_elem(struct bpf_map *=
map, void *key, void *value,
> > >  static int xsk_map_delete_elem(struct bpf_map *map, void *key)
> > >  {
> > >         struct xsk_map *m =3D container_of(map, struct xsk_map, map);
> > > -       struct xdp_sock *old_xs;
> > > +       struct xdp_sock *old_xs, **map_entry;
> > >         int k =3D *(u32 *)key;
> > >
> > >         if (k >=3D map->max_entries)
> > >                 return -EINVAL;
> > >
> > > -       old_xs =3D xchg(&m->xsk_map[k], NULL);
> > > +       spin_lock_bh(&m->lock);
> > > +       map_entry =3D &m->xsk_map[k];
> > > +       old_xs =3D xchg(map_entry, NULL);
> > >         if (old_xs)
> > > -               sock_put((struct sock *)old_xs);
> > > +               xsk_map_del_node(old_xs, map_entry);
> > > +       spin_unlock_bh(&m->lock);
> > >
> > >         return 0;
> > >  }
> > >
> > > +void xsk_map_delete_from_node(struct xdp_sock *xs, struct list_head =
*node)
> > > +{
> > > +       struct xsk_map_node *n =3D list_entry(node, struct xsk_map_no=
de, node);
> > > +
> > > +       spin_lock_bh(&n->map->lock);
> > > +       *n->map_entry =3D NULL;
> > > +       spin_unlock_bh(&n->map->lock);
> > > +       xsk_map_node_free(n);
> > > +}
> > > +
> > >  const struct bpf_map_ops xsk_map_ops =3D {
> > >         .map_alloc =3D xsk_map_alloc,
> > >         .map_free =3D xsk_map_free,
> > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > index a14e8864e4fa..1931d98a7754 100644
> > > --- a/net/xdp/xsk.c
> > > +++ b/net/xdp/xsk.c
> > > @@ -335,6 +335,27 @@ static int xsk_init_queue(u32 entries, struct xs=
k_queue **queue,
> > >         return 0;
> > >  }
> > >
> > > +static struct list_head *xsk_map_list_pop(struct xdp_sock *xs)
> > > +{
> > > +       struct list_head *node =3D NULL;
> > > +
> > > +       spin_lock_bh(&xs->map_list_lock);
> > > +       if (!list_empty(&xs->map_list)) {
> > > +               node =3D xs->map_list.next;
> > > +               list_del(node);
> > > +       }
> > > +       spin_unlock_bh(&xs->map_list_lock);
> > > +       return node;
> > > +}
> > > +
> > > +static void xsk_delete_from_maps(struct xdp_sock *xs)
> > > +{
> > > +       struct list_head *node;
> > > +
> > > +       while ((node =3D xsk_map_list_pop(xs)))
> > > +               xsk_map_delete_from_node(xs, node);
> > > +}
> > > +
> > >  static int xsk_release(struct socket *sock)
> > >  {
> > >         struct sock *sk =3D sock->sk;
> > > @@ -354,6 +375,7 @@ static int xsk_release(struct socket *sock)
> > >         sock_prot_inuse_add(net, sk->sk_prot, -1);
> > >         local_bh_enable();
> > >
> > > +       xsk_delete_from_maps(xs);
> > >         if (xs->dev) {
> > >                 struct net_device *dev =3D xs->dev;
> > >
> > > @@ -767,6 +789,9 @@ static int xsk_create(struct net *net, struct soc=
ket *sock, int protocol,
> > >         mutex_init(&xs->mutex);
> > >         spin_lock_init(&xs->tx_completion_lock);
> > >
> > > +       INIT_LIST_HEAD(&xs->map_list);
> > > +       spin_lock_init(&xs->map_list_lock);
> > > +
> > >         mutex_lock(&net->xdp.lock);
> > >         sk_add_node_rcu(sk, &net->xdp.list);
> > >         mutex_unlock(&net->xdp.lock);
> > > --
> > > 2.20.1
> > >
