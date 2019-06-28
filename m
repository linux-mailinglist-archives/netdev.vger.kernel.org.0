Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D637B5A279
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfF1ReE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:34:04 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41903 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfF1ReE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:34:04 -0400
Received: by mail-qk1-f195.google.com with SMTP id c11so5483022qkk.8;
        Fri, 28 Jun 2019 10:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m4FAf5s89iE584IgirOqhJ2dzf1Ot9fHIBm9WLnCcgs=;
        b=EpZ+BmI5fx7Jmrl3SUeZEtQC3v1jSm1DjRZfM18AG5PdVISBqrzKhC/rbqd9YpahiT
         HvUlr3MBR2xtdQxDq9PBWkYI6Fq9duIfx0o+ENIVY1XrpJsTx/1IY/Ircp0kaed92dX7
         Ois52dJRn8bQewiJuQadM/zVTAIrOmasY+5GeNAUFaOzVKhrHpbtc/pEdiQIVKYI2FHf
         b0V0o169asCAZGjdbZGR6o+HA3eIE8K4yZ1gL6zCjf4mDDnxUFTFssomNd9Kl0cFpTAb
         95YdCTXzANti1ul8wb8+Y+2G2sa6saD4DmION+P1pn6btaysV4gn+5G1oG47j215aqmz
         2BKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m4FAf5s89iE584IgirOqhJ2dzf1Ot9fHIBm9WLnCcgs=;
        b=FNnWtfnYn4Vn0FixebSx6jAoOQR/oimfLsT0J7wRH8RF0DbHKmhkWUojYmLPLFBEX5
         s/kjO6bI5R+h8KsphC4TIbAgZj1MpS8bh4emnI3CSvmUXmE2sb8l20/HBPwNCjkbQqEL
         vDRhOaWHikeA2xerItsGmmfI83GYaDFYHub7+Xe8hnz9xAsp6y+JZHgnSNclbnI1pvI1
         rQbJfJOYIV5/6IbQhaWtbPv3nQT3ze+dcS7FZWwO/V2RIkkJDDZDSf/hYEPWbAi9aIFF
         N+Ob6J4b10HHS13J/DiyDQMDW+KqDR0AB6Diw3q8/TNBfUe8bf74D2VnMlG0PBbZERPO
         xcCA==
X-Gm-Message-State: APjAAAUuSwvZstVHZCmbFAjwKFialavGr+LGSvK3G88GlExelJKB9WED
        cPLXgtQ2OtCtLvUuJ/84GE72txAIdU5ISThFuG4=
X-Google-Smtp-Source: APXvYqy3SHgQ4Wdla20pfS3rjdO4thcW1LK+HPYVv0Gg9JeR6oRRsufaYJS/FuspD3tW9iWTbxsjGFE3OGDvq1/10bQ=
X-Received: by 2002:a37:a890:: with SMTP id r138mr9523108qke.218.1561743242860;
 Fri, 28 Jun 2019 10:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190620100652.31283-1-bjorn.topel@gmail.com> <20190620100652.31283-2-bjorn.topel@gmail.com>
 <2417e1ab-16fa-d3ed-564e-1a50c4cb6717@iogearbox.net>
In-Reply-To: <2417e1ab-16fa-d3ed-564e-1a50c4cb6717@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 28 Jun 2019 19:33:44 +0200
Message-ID: <CAJ+HfNh+QciBDd14ukQ-Y0BEnu7Lmg64g9mrqABrc_+-jKDW6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/2] xsk: remove AF_XDP socket from map when
 the socket is released
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 at 02:33, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/20/2019 12:06 PM, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > When an AF_XDP socket is released/closed the XSKMAP still holds a
> > reference to the socket in a "released" state. The socket will still
> > use the netdev queue resource, and block newly created sockets from
> > attaching to that queue, but no user application can access the
> > fill/complete/rx/tx queues. This results in that all applications need
> > to explicitly clear the map entry from the old "zombie state"
> > socket. This should be done automatically.
> >
> > After this patch, when a socket is released, it will remove itself
> > from all the XSKMAPs it resides in, allowing the socket application to
> > remove the code that cleans the XSKMAP entry.
> >
> > This behavior is also closer to that of SOCKMAP, making the two socket
> > maps more consistent.
> >
> > Suggested-by: Bruce Richardson <bruce.richardson@intel.com>
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Sorry for the bit of delay in reviewing, few comments inline:
>

No worries!

> > ---
> >  include/net/xdp_sock.h |   3 ++
> >  kernel/bpf/xskmap.c    | 101 +++++++++++++++++++++++++++++++++++------
> >  net/xdp/xsk.c          |  25 ++++++++++
> >  3 files changed, 116 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> > index ae0f368a62bb..011a1b08d7c9 100644
> > --- a/include/net/xdp_sock.h
> > +++ b/include/net/xdp_sock.h
> > @@ -68,6 +68,8 @@ struct xdp_sock {
> >        */
> >       spinlock_t tx_completion_lock;
> >       u64 rx_dropped;
> > +     struct list_head map_list;
> > +     spinlock_t map_list_lock;
> >  };
> >
> >  struct xdp_buff;
> > @@ -87,6 +89,7 @@ struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_=
umem *umem,
> >                                         struct xdp_umem_fq_reuse *newq)=
;
> >  void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
> >  struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 que=
ue_id);
> > +void xsk_map_delete_from_node(struct xdp_sock *xs, struct list_head *n=
ode);
> >
> >  static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
> >  {
> > diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> > index ef7338cebd18..af802c89ebab 100644
> > --- a/kernel/bpf/xskmap.c
> > +++ b/kernel/bpf/xskmap.c
> > @@ -13,8 +13,58 @@ struct xsk_map {
> >       struct bpf_map map;
> >       struct xdp_sock **xsk_map;
> >       struct list_head __percpu *flush_list;
> > +     spinlock_t lock;
> >  };
> >
> > +/* Nodes are linked in the struct xdp_sock map_list field, and used to
> > + * track which maps a certain socket reside in.
> > + */
> > +struct xsk_map_node {
> > +     struct list_head node;
> > +     struct xsk_map *map;
> > +     struct xdp_sock **map_entry;
> > +};
> > +
> > +static struct xsk_map_node *xsk_map_node_alloc(void)
> > +{
> > +     return kzalloc(sizeof(struct xsk_map_node), GFP_ATOMIC | __GFP_NO=
WARN);
> > +}
> > +
> > +static void xsk_map_node_free(struct xsk_map_node *node)
> > +{
> > +     kfree(node);
> > +}
> > +
> > +static void xsk_map_node_init(struct xsk_map_node *node,
> > +                           struct xsk_map *map,
> > +                           struct xdp_sock **map_entry)
> > +{
> > +     node->map =3D map;
> > +     node->map_entry =3D map_entry;
> > +}
> > +
> > +static void xsk_map_add_node(struct xdp_sock *xs, struct xsk_map_node =
*node)
> > +{
> > +     spin_lock_bh(&xs->map_list_lock);
> > +     list_add_tail(&node->node, &xs->map_list);
> > +     spin_unlock_bh(&xs->map_list_lock);
> > +}
> > +
> > +static void xsk_map_del_node(struct xdp_sock *xs, struct xdp_sock **ma=
p_entry)
> > +{
> > +     struct xsk_map_node *n, *tmp;
> > +
> > +     spin_lock_bh(&xs->map_list_lock);
> > +     list_for_each_entry_safe(n, tmp, &xs->map_list, node) {
> > +             if (map_entry =3D=3D n->map_entry) {
> > +                     list_del(&n->node);
> > +                     xsk_map_node_free(n);
> > +             }
> > +     }
> > +     spin_unlock_bh(&xs->map_list_lock);
> > +
> > +}
> > +
> >  static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
> >  {
> >       struct xsk_map *m;
> > @@ -34,6 +84,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *=
attr)
> >               return ERR_PTR(-ENOMEM);
> >
> >       bpf_map_init_from_attr(&m->map, attr);
> > +     spin_lock_init(&m->lock);
> >
> >       cost =3D (u64)m->map.max_entries * sizeof(struct xdp_sock *);
> >       cost +=3D sizeof(struct list_head) * num_possible_cpus();
> > @@ -76,15 +127,16 @@ static void xsk_map_free(struct bpf_map *map)
> >       bpf_clear_redirect_map(map);
> >       synchronize_net();
> >
> > +     spin_lock_bh(&m->lock);
> >       for (i =3D 0; i < map->max_entries; i++) {
> > -             struct xdp_sock *xs;
> > -
> > -             xs =3D m->xsk_map[i];
> > -             if (!xs)
> > -                     continue;
> > +             struct xdp_sock **map_entry =3D &m->xsk_map[i];
> > +             struct xdp_sock *old_xs;
> >
> > -             sock_put((struct sock *)xs);
> > +             old_xs =3D xchg(map_entry, NULL);
> > +             if (old_xs)
> > +                     xsk_map_del_node(old_xs, map_entry);
> >       }
> > +     spin_unlock_bh(&m->lock);
> >
> >       free_percpu(m->flush_list);
> >       bpf_map_area_free(m->xsk_map);
> > @@ -166,7 +218,8 @@ static int xsk_map_update_elem(struct bpf_map *map,=
 void *key, void *value,
> >  {
> >       struct xsk_map *m =3D container_of(map, struct xsk_map, map);
> >       u32 i =3D *(u32 *)key, fd =3D *(u32 *)value;
> > -     struct xdp_sock *xs, *old_xs;
> > +     struct xdp_sock *xs, *old_xs, **entry;
> > +     struct xsk_map_node *node;
> >       struct socket *sock;
> >       int err;
> >
> > @@ -193,11 +246,20 @@ static int xsk_map_update_elem(struct bpf_map *ma=
p, void *key, void *value,
> >               return -EOPNOTSUPP;
> >       }
> >
> > -     sock_hold(sock->sk);
> > +     node =3D xsk_map_node_alloc();
> > +     if (!node) {
> > +             sockfd_put(sock);
> > +             return -ENOMEM;
> > +     }
> >
> > -     old_xs =3D xchg(&m->xsk_map[i], xs);
> > +     spin_lock_bh(&m->lock);
> > +     entry =3D &m->xsk_map[i];
> > +     xsk_map_node_init(node, m, entry);
> > +     xsk_map_add_node(xs, node);
> > +     old_xs =3D xchg(entry, xs);
> >       if (old_xs)
> > -             sock_put((struct sock *)old_xs);
> > +             xsk_map_del_node(old_xs, entry);
> > +     spin_unlock_bh(&m->lock);
> >
> >       sockfd_put(sock);
> >       return 0;
> > @@ -206,19 +268,32 @@ static int xsk_map_update_elem(struct bpf_map *ma=
p, void *key, void *value,
> >  static int xsk_map_delete_elem(struct bpf_map *map, void *key)
> >  {
> >       struct xsk_map *m =3D container_of(map, struct xsk_map, map);
> > -     struct xdp_sock *old_xs;
> > +     struct xdp_sock *old_xs, **map_entry;
> >       int k =3D *(u32 *)key;
> >
> >       if (k >=3D map->max_entries)
> >               return -EINVAL;
> >
> > -     old_xs =3D xchg(&m->xsk_map[k], NULL);
> > +     spin_lock_bh(&m->lock);
> > +     map_entry =3D &m->xsk_map[k];
> > +     old_xs =3D xchg(map_entry, NULL);
> >       if (old_xs)
> > -             sock_put((struct sock *)old_xs);
> > +             xsk_map_del_node(old_xs, map_entry);
> > +     spin_unlock_bh(&m->lock);
> >
> >       return 0;
> >  }
> >
> > +void xsk_map_delete_from_node(struct xdp_sock *xs, struct list_head *n=
ode)
> > +{
> > +     struct xsk_map_node *n =3D list_entry(node, struct xsk_map_node, =
node);
> > +
> > +     spin_lock_bh(&n->map->lock);
> > +     *n->map_entry =3D NULL;
> > +     spin_unlock_bh(&n->map->lock);
> > +     xsk_map_node_free(n);
> > +}
> > +
> >  const struct bpf_map_ops xsk_map_ops =3D {
> >       .map_alloc =3D xsk_map_alloc,
> >       .map_free =3D xsk_map_free,
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index a14e8864e4fa..1931d98a7754 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -335,6 +335,27 @@ static int xsk_init_queue(u32 entries, struct xsk_=
queue **queue,
> >       return 0;
> >  }
> >
> > +static struct list_head *xsk_map_list_pop(struct xdp_sock *xs)
> > +{
> > +     struct list_head *node =3D NULL;
> > +
> > +     spin_lock_bh(&xs->map_list_lock);
> > +     if (!list_empty(&xs->map_list)) {
> > +             node =3D xs->map_list.next;
> > +             list_del(node);
> > +     }
> > +     spin_unlock_bh(&xs->map_list_lock);
> > +     return node;
> > +}
> > +
> > +static void xsk_delete_from_maps(struct xdp_sock *xs)
> > +{
> > +     struct list_head *node;
> > +
> > +     while ((node =3D xsk_map_list_pop(xs)))
> > +             xsk_map_delete_from_node(xs, node);
> > +}
> > +
>
> I stared at this set for a while and I think there are still two
> issues in the design unless I'm missing something obvious.
>
> 1) xs teardown and parallel map update:
>
> - CPU0 is in xsk_release(), calls xsk_delete_from_maps().
> - CPU1 is in xsk_map_update_elem(), both access the same map slot.
> - CPU0 does the xsk_map_list_pop() for that given slot, gets
>   interrupted before calling into xsk_map_delete_from_node().
> - CPU1 takes m->lock in updates, *entry =3D xs to the new sock,
>   does xsk_map_del_node() to check on the xs (which CPU0 tears
>   down). Given this was popped off the list, it doesn't do
>   anything here, all good. It unlocks m->lock and succeeds.
> - CPU0 now continues in xsk_map_delete_from_node(), takes
>   m->lock, zeroes *n->map_entry, releases m->lock, and frees
>   n. However, at this point *n->map_entry contains the xs that
>   we've just updated on CPU1. So zero'ing it will 1) remove
>   the wrong entry, and ii) leak it since it goes out of reach.
>

Argh. No, you're (again) not missing anything. Thanks for catching this.

> 2) Inconsistent use of xchg() and friends:
>
> - AF_XDP fast-path is doing READ_ONCE(m->xsk_map[key]) without
>   taking m->lock. This is also why you have xchg() for example
>   inside m->lock region since both protect different things (should
>   probably be commented). However, this is not consistently used.
>   E.g. xsk_map_delete_from_node() or xsk_map_update_elem() have
>   plain assignment, so compiler could in theory happily perform
>   store tearing and the READ_ONCE() would see garbage. This needs
>   to be consistently paired.
>

Indeed. Back to the drawing board. Thanks for your time, Daniel.


Bj=C3=B6rn

> >  static int xsk_release(struct socket *sock)
> >  {
> >       struct sock *sk =3D sock->sk;
> > @@ -354,6 +375,7 @@ static int xsk_release(struct socket *sock)
> >       sock_prot_inuse_add(net, sk->sk_prot, -1);
> >       local_bh_enable();
> >
> > +     xsk_delete_from_maps(xs);
> >       if (xs->dev) {
> >               struct net_device *dev =3D xs->dev;
> >
> > @@ -767,6 +789,9 @@ static int xsk_create(struct net *net, struct socke=
t *sock, int protocol,
> >       mutex_init(&xs->mutex);
> >       spin_lock_init(&xs->tx_completion_lock);
> >
> > +     INIT_LIST_HEAD(&xs->map_list);
> > +     spin_lock_init(&xs->map_list_lock);
> > +
> >       mutex_lock(&net->xdp.lock);
> >       sk_add_node_rcu(sk, &net->xdp.list);
> >       mutex_unlock(&net->xdp.lock);
> >
>
