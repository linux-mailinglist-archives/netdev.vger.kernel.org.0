Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC62B18872
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 12:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfEIKkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 06:40:24 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39067 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfEIKkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 06:40:24 -0400
Received: by mail-qt1-f194.google.com with SMTP id y42so1859868qtk.6
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 03:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q8yx7CC1iD6a9q1NblKB2omaiYB8zmt1jnN8j299oa0=;
        b=ae0kKpLZ68OSPA7/QDc6mg01rtKUmry7s3/LdoJ49zXG0z8cb/8iHsy4xPexhgShTQ
         SMjed/9+YH/ID8t5SziA1M8n5E4eJ3tSKU9tNdVVUE9FUPY74+DbsHrPR00foPTEEheY
         WSUH+S5rxVbTaPB0NP7Fm9vN8OGPVbjqc5G+4gcz35o3HfyFHC6mdqVjEM4SMlb+NeWG
         1S7DHxWH1T+Q68eDFyzNE9Yss/jEa6k8kHeWQteasORrUkGn1S1XD9aDvaIM0Z+Na5r4
         zs8M3zYmm6iyMeRjQScfWrPKeSl3HJyl0OkvNdZwmhNzB6nzR4b8fQWTtNRovARo0v5v
         mVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q8yx7CC1iD6a9q1NblKB2omaiYB8zmt1jnN8j299oa0=;
        b=ncn9mefNIS9ma9aU4bCIPq8NN2NACfmwvkbUsL5TwlliFALPili7tFltUEJ6v3LLVk
         JL/UGWUBoHYliGB9s4sUUIjODDFGSyu2B5o3ZLyx2Xq/oz3DE7dvarjxgsbgpPV+JAgl
         lirYI0S/G9CeHLrPIZ3pKym/1Ck8wj+jiEkrf2l4ySjm6tH7R2QwYE01N9hZKmqVO6uK
         7RyIzYMpa0vsFlJ5EdAPcgLBHaSV3aVnGhNuWEBBEj5U9LhZ9HplX8w70iFI577+TJ0U
         NFFJ/bsUbJGG9fFbUZ+arx1A3mz/mZwStk5Y9kHjYNzQ1U8AqB2G5Q+fEnnDMrcugEAP
         gjbg==
X-Gm-Message-State: APjAAAUUGa1Y+lOPAL5RC+L5xGbtO1tjwjpU8BQ6xlVaywO2uzSdVaRP
        oWr5A1bMtOxSMnhPL5Ugh1NMglWAV0mtAnJzZKA=
X-Google-Smtp-Source: APXvYqw2wxqC8FEuItH7cn/TL230CoRckUNJmbgcsfLs6HJ+Vpq3/9B/lMMfUxdv3KSTPLjuVPU4fWqtl7FHW/BNCwU=
X-Received: by 2002:ac8:2bb9:: with SMTP id m54mr2848271qtm.303.1557398423189;
 Thu, 09 May 2019 03:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <155474315642.24432.6179239576879119104.stgit@alrua-x1>
 <155474315660.24432.7026778509168675619.stgit@alrua-x1> <1d5b71d8-00ff-cd3b-e71b-19e351b53125@iogearbox.net>
In-Reply-To: <1d5b71d8-00ff-cd3b-e71b-19e351b53125@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 9 May 2019 12:40:10 +0200
Message-ID: <CAJ+HfNjfcGW=b_Ckox4jXf7od7yr+Sk2dXxFyO8Qpr-WJX0q7A@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/6] net: xdp: refactor XDP attach
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Apr 2019 at 22:23, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 04/08/2019 07:05 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > Generic XDP and driver XDP cannot be enabled at the same time. However,
> > they don't share any state; let's fix that. Here, dev->xdp_prog, is
> > used for both driver and generic mode. This removes the need for the
> > XDP_QUERY_PROG command to ndo_bpf.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
> >  include/linux/netdevice.h |    8 +-
> >  net/core/dev.c            |  148 ++++++++++++++++++++++++++-----------=
--------
> >  net/core/rtnetlink.c      |   14 +---
> >  3 files changed, 93 insertions(+), 77 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index eb9f05e0863d..68d4bbc44c63 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1957,7 +1957,7 @@ struct net_device {
> >       struct cpu_rmap         *rx_cpu_rmap;
> >  #endif
> >       struct hlist_node       index_hlist;
> > -
> > +     unsigned int            xdp_target;
> >  /*
> >   * Cache lines mostly used on transmit path
> >   */
> > @@ -2063,7 +2063,8 @@ struct net_device {
> >
> >  static inline bool netif_elide_gro(const struct net_device *dev)
> >  {
> > -     if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
> > +     if (!(dev->features & NETIF_F_GRO) ||
> > +         dev->xdp_target =3D=3D XDP_FLAGS_SKB_MODE)
> >               return true;
> >       return false;
> >  }
> > @@ -3702,8 +3703,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buf=
f *skb, struct net_device *dev,
> >  typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf=
);
> >  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *=
extack,
> >                     int fd, u32 flags);
> > -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
> > -                 enum bpf_netdev_command cmd);
> > +u32 __dev_xdp_query(struct net_device *dev, unsigned int target);
> >  int xdp_umem_query(struct net_device *dev, u16 queue_id);
> >
> >  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index d5b1315218d3..feafc3580350 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5121,35 +5121,25 @@ static void __netif_receive_skb_list(struct lis=
t_head *head)
> >
> >  static int generic_xdp_install(struct net_device *dev, struct netdev_b=
pf *xdp)
> >  {
> > -     struct bpf_prog *old =3D rtnl_dereference(dev->xdp_prog);
> >       struct bpf_prog *new =3D xdp->prog;
> > -     int ret =3D 0;
> > -
> > -     switch (xdp->command) {
> > -     case XDP_SETUP_PROG:
> > -             rcu_assign_pointer(dev->xdp_prog, new);
> > -             if (old)
> > -                     bpf_prog_put(old);
> >
> > -             if (old && !new) {
> > +     if (xdp->command =3D=3D XDP_SETUP_PROG) {
> > +             if (static_key_enabled(&generic_xdp_needed_key) && !new) =
{
> >                       static_branch_dec(&generic_xdp_needed_key);
> > -             } else if (new && !old) {
> > +             } else if (new &&
> > +                        !static_key_enabled(&generic_xdp_needed_key)) =
{
> >                       static_branch_inc(&generic_xdp_needed_key);
> >                       dev_disable_lro(dev);
> >                       dev_disable_gro_hw(dev);
> >               }
> > -             break;
> >
> > -     case XDP_QUERY_PROG:
> > -             xdp->prog_id =3D old ? old->aux->id : 0;
> > -             break;
> > +             if (new)
> > +                     bpf_prog_put(new);
>
> Hmm, why you drop ref on the new program that you're installing here?
>
> >
> > -     default:
> > -             ret =3D -EINVAL;
> > -             break;
> > +             return 0;
> >       }
> >
> > -     return ret;
> > +     return -EINVAL;
> >  }
> >
> >  static int netif_receive_skb_internal(struct sk_buff *skb)
> > @@ -7981,30 +7971,50 @@ int dev_change_proto_down_generic(struct net_de=
vice *dev, bool proto_down)
> >  }
> >  EXPORT_SYMBOL(dev_change_proto_down_generic);
> >
> > -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
> > -                 enum bpf_netdev_command cmd)
> > +u32 __dev_xdp_query(struct net_device *dev, unsigned int target)
> >  {
> > -     struct netdev_bpf xdp;
> > +     if (target =3D=3D XDP_FLAGS_DRV_MODE || target =3D=3D XDP_FLAGS_S=
KB_MODE) {
> > +             struct bpf_prog *prog =3D rtnl_dereference(dev->xdp_prog)=
;
> >
> > -     if (!bpf_op)
> > -             return 0;
> > +             return prog && (dev->xdp_target =3D=3D target) ? prog->au=
x->id : 0;
> > +     }
> >
> > -     memset(&xdp, 0, sizeof(xdp));
> > -     xdp.command =3D cmd;
> > +     if (target =3D=3D XDP_FLAGS_HW_MODE) {
> > +             struct netdev_bpf xdp =3D { .command =3D XDP_QUERY_PROG_H=
W };
> >
> > -     /* Query must always succeed. */
> > -     WARN_ON(bpf_op(dev, &xdp) < 0 && cmd =3D=3D XDP_QUERY_PROG);
> > +             if (!dev->netdev_ops->ndo_bpf)
> > +                     return 0;
> > +             dev->netdev_ops->ndo_bpf(dev, &xdp);
> > +             return xdp.prog_id;
> > +     }
> >
> > -     return xdp.prog_id;
> > +     WARN_ON(1);
> > +     return 0;
> >  }
> >
> > -static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
> > +static int dev_xdp_install(struct net_device *dev, unsigned int target=
,
> >                          struct netlink_ext_ack *extack, u32 flags,
> >                          struct bpf_prog *prog)
> >  {
> > -     struct netdev_bpf xdp;
> > +     const struct net_device_ops *ops =3D dev->netdev_ops;
> > +     struct bpf_prog *old =3D NULL;
> > +     struct netdev_bpf xdp =3D {};
> > +     int ret;
> > +
> > +     if (target !=3D XDP_FLAGS_HW_MODE) {
> > +             if (prog) {
> > +                     prog =3D bpf_prog_inc(prog);
> > +                     if (IS_ERR(prog))
> > +                             return PTR_ERR(prog);
> > +             }
> > +
> > +             old =3D rtnl_dereference(dev->xdp_prog);
> > +             if (!old && !prog)
> > +                     return 0;
> > +             rcu_assign_pointer(dev->xdp_prog, prog);
> > +             dev->xdp_target =3D prog ? target : 0;
> > +     }
> >
> > -     memset(&xdp, 0, sizeof(xdp));
> >       if (flags & XDP_FLAGS_HW_MODE)
> >               xdp.command =3D XDP_SETUP_PROG_HW;
> >       else
> > @@ -8013,7 +8023,24 @@ static int dev_xdp_install(struct net_device *de=
v, bpf_op_t bpf_op,
> >       xdp.flags =3D flags;
> >       xdp.prog =3D prog;
> >
> > -     return bpf_op(dev, &xdp);
> > +     if (target =3D=3D XDP_FLAGS_SKB_MODE)
> > +             ret =3D generic_xdp_install(dev, &xdp);
> > +     else
> > +             ret =3D ops->ndo_bpf(dev, &xdp);
> > +
> > +     if (target !=3D XDP_FLAGS_HW_MODE) {
> > +             if (ret) {
> > +                     if (prog)
> > +                             bpf_prog_put(prog);
> > +                     rcu_assign_pointer(dev->xdp_prog, old);
> > +                     dev->xdp_target =3D old ? target : 0;
>
> Hmm, please correct me if I'm wrong, but from reading this patch (with fo=
llowing
> generic XDP as a simple example), it means: above we inc ref on prog, fet=
ch old
> prog, assign new prog to dev->xdp_prog, call generic_xdp_install(). If on=
e would
> fail there, we drop the ref of the prog that is currently attached to dev=
->xdp_prog
> (effectively a use-after-free?), and assign the old prog back. So basical=
ly we
> would shortly flake wrt prog assignment. I don't think this is a good des=
ign, the
> update should only really happen once everything else succeeded and there=
 is nothing
> that can fail anymore. The existing code is doing exactly the latter, why=
 diverge
> from this practice?! (Also, why special casing XDP_FLAGS_HW_MODE? Feels a=
 bit like
> a hack tbh.)
>

Really late reply. :-(

Yeah, I need to rework this one. My loose plan was to add the XDP
program to the netdevice (skb/native being mutual exclusive), and
later the per-queue program into the netdev_rx_queue structure. I left
HW programs out, keeping the old query mechanism. It probably makes
sense to add the offloaded program to the netdevice (and later to the
netdev_rx_queue) as well. IOW, two XDP-programs: skb/native and
offloaded in the netdev structure.

The update flow was: 1. update the netdev structures, and 2. call the
ndo (if applicable). 3. revert if fail.

I'll update this patch to follow the existing pattern: 1. try changing
the program via the ndos (if applicable) 2. update the netdevice on
success.


Bj=C3=B6rn

> > +             } else {
> > +                     if (old)
> > +                             bpf_prog_put(old);
> > +             }
> > +     }
> > +
> > +     return ret;
> >  }
> >
> >  static void dev_xdp_uninstall(struct net_device *dev)
> > @@ -8021,27 +8048,28 @@ static void dev_xdp_uninstall(struct net_device=
 *dev)
> >       struct netdev_bpf xdp;
> >       bpf_op_t ndo_bpf;
> >
> > -     /* Remove generic XDP */
> > -     WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL))=
;
> > +     /* Remove generic/native XDP */
> > +     WARN_ON(dev_xdp_install(dev, dev->xdp_target, NULL, 0, NULL));
> >
> >       /* Remove from the driver */
> >       ndo_bpf =3D dev->netdev_ops->ndo_bpf;
> >       if (!ndo_bpf)
> >               return;
> >
> > -     memset(&xdp, 0, sizeof(xdp));
> > -     xdp.command =3D XDP_QUERY_PROG;
> > -     WARN_ON(ndo_bpf(dev, &xdp));
> > -     if (xdp.prog_id)
> > -             WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flag=
s,
> > -                                     NULL));
> > -
> > -     /* Remove HW offload */
> >       memset(&xdp, 0, sizeof(xdp));
> >       xdp.command =3D XDP_QUERY_PROG_HW;
> >       if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
> > -             WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flag=
s,
> > -                                     NULL));
> > +             WARN_ON(dev_xdp_install(dev, XDP_FLAGS_HW_MODE, NULL,
> > +                                     xdp.prog_flags, NULL));
> > +}
> > +
> > +static bool dev_validate_active_xdp(struct net_device *dev, unsigned i=
nt target)
> > +{
> > +     if (target =3D=3D XDP_FLAGS_DRV_MODE)
> > +             return dev->xdp_target !=3D XDP_FLAGS_SKB_MODE;
> > +     if (target =3D=3D XDP_FLAGS_SKB_MODE)
> > +             return dev->xdp_target !=3D XDP_FLAGS_DRV_MODE;
> > +     return true;
> >  }
> >
> >  /**
> > @@ -8057,40 +8085,36 @@ int dev_change_xdp_fd(struct net_device *dev, s=
truct netlink_ext_ack *extack,
> >                     int fd, u32 flags)
> >  {
> >       const struct net_device_ops *ops =3D dev->netdev_ops;
> > -     enum bpf_netdev_command query;
> > +     bool offload, drv =3D !!ops->ndo_bpf;
> >       struct bpf_prog *prog =3D NULL;
> > -     bpf_op_t bpf_op, bpf_chk;
> > -     bool offload;
> > +     unsigned int target;
> >       int err;
> >
> >       ASSERT_RTNL();
> >
> >       offload =3D flags & XDP_FLAGS_HW_MODE;
> > -     query =3D offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
> > +     target =3D offload ? XDP_FLAGS_HW_MODE : XDP_FLAGS_DRV_MODE;
> >
> > -     bpf_op =3D bpf_chk =3D ops->ndo_bpf;
> > -     if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))=
) {
> > +     if (!drv && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
> >               NL_SET_ERR_MSG(extack, "underlying driver does not suppor=
t XDP in native mode");
> >               return -EOPNOTSUPP;
> >       }
> > -     if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
> > -             bpf_op =3D generic_xdp_install;
> > -     if (bpf_op =3D=3D bpf_chk)
> > -             bpf_chk =3D generic_xdp_install;
> > +     if (!drv || (flags & XDP_FLAGS_SKB_MODE))
> > +             target =3D XDP_FLAGS_SKB_MODE;
> > +
> > +     if (!dev_validate_active_xdp(dev, target)) {
> > +             NL_SET_ERR_MSG(extack, "native and generic XDP can't be a=
ctive at the same time");
> > +             return -EEXIST;
> > +     }
> >
> >       if (fd >=3D 0) {
> > -             if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_P=
ROG)) {
> > -                     NL_SET_ERR_MSG(extack, "native and generic XDP ca=
n't be active at the same time");
> > -                     return -EEXIST;
> > -             }
> >               if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) &&
> > -                 __dev_xdp_query(dev, bpf_op, query)) {
> > +                 __dev_xdp_query(dev, target)) {
> >                       NL_SET_ERR_MSG(extack, "XDP program already attac=
hed");
> >                       return -EBUSY;
> >               }
> >
> > -             prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
> > -                                          bpf_op =3D=3D ops->ndo_bpf);
> > +             prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP, drv=
);
> >               if (IS_ERR(prog))
> >                       return PTR_ERR(prog);
> >
> > @@ -8101,7 +8125,7 @@ int dev_change_xdp_fd(struct net_device *dev, str=
uct netlink_ext_ack *extack,
> >               }
> >       }
> >
> > -     err =3D dev_xdp_install(dev, bpf_op, extack, flags, prog);
> > +     err =3D dev_xdp_install(dev, target, extack, flags, prog);
> >       if (err < 0 && prog)
> >               bpf_prog_put(prog);
> >
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index f9b964fd4e4d..d9c7fe34c3a1 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1362,25 +1362,17 @@ static int rtnl_fill_link_ifmap(struct sk_buff =
*skb, struct net_device *dev)
> >
> >  static u32 rtnl_xdp_prog_skb(struct net_device *dev)
> >  {
> > -     const struct bpf_prog *generic_xdp_prog;
> > -
> > -     ASSERT_RTNL();
> > -
> > -     generic_xdp_prog =3D rtnl_dereference(dev->xdp_prog);
> > -     if (!generic_xdp_prog)
> > -             return 0;
> > -     return generic_xdp_prog->aux->id;
> > +     return __dev_xdp_query(dev, XDP_FLAGS_SKB_MODE);
> >  }
> >
> >  static u32 rtnl_xdp_prog_drv(struct net_device *dev)
> >  {
> > -     return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf, XDP_QUERY_P=
ROG);
> > +     return __dev_xdp_query(dev, XDP_FLAGS_DRV_MODE);
> >  }
> >
> >  static u32 rtnl_xdp_prog_hw(struct net_device *dev)
> >  {
> > -     return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
> > -                            XDP_QUERY_PROG_HW);
> > +     return __dev_xdp_query(dev, XDP_FLAGS_HW_MODE);
> >  }
> >
> >  static int rtnl_xdp_report_one(struct sk_buff *skb, struct net_device =
*dev,
> >
>
