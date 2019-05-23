Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A717B27609
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 08:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfEWGf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 02:35:27 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43205 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfEWGf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 02:35:26 -0400
Received: by mail-qk1-f194.google.com with SMTP id z6so3095429qkl.10;
        Wed, 22 May 2019 23:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ndju+099rXu88q6Yopuox1/QVpCguLpWcEMdi2BfZMw=;
        b=nz1bFKNjoJV1UIhsWCwfHSNcizsAXfhuQB+c6GJ3S0BicKvQSOlQsydzvqvYQDdFAG
         GezR2v9AuTM28cIBZesmMEh+q6mVz/4DssCi5KUQMubeH8AS/cb0D6TJafwolURThBfY
         khxUBUBmyhKpWypjs1ruY4sYCOky4jl1+OOj2iw9Av4T30KkpF4TLrF7y8HG5Y6pKR/A
         REJKPliu/btUCG2Gg4P2ECNShJhEZA4NdFacQ6r9ppacqOdHVgvc584AYqJ/RnyCuP4e
         2iOut1RKV/eCylFDd/1+nEEJg8DtLIe7HBZ/5PcH4Xn4Rq73Za+a8OcDfr5+ybXSOdVT
         RYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ndju+099rXu88q6Yopuox1/QVpCguLpWcEMdi2BfZMw=;
        b=WCw8fdObubyM8Sbuf/X/cpFJPq3XXv8j6d7tIDby9w0j3Z5ULIi9zDlCxcgyLMdoSs
         igacRC88K6LnQgIAOlNMY5YXQEQ50zeaup9S+2vzK9vRetN3O/MreoeZsShvo8nEA8Yq
         ZKLeMT/+jPEoghW29UPFH5MHvOd8TI7XH/UNFv6Z/JT1pRrl76fOPy0pNtS+tT+FDp1I
         +ymjUjKWy2GWbbF7FmFMFwf5sQFZ0pnQZpvnzJb2bpkO75VUxLwNNGDHWzf/iwUzyQCt
         6DP8O+IWpHB2xV13Ikwn9rgDjfkHb3TxW/FL7YAvBbNVOq1o3ZTOlEHqICHpXn2xJ+y1
         cGQA==
X-Gm-Message-State: APjAAAW1AY5oqY+WO9FKcf1NUgFFPCjFKuBA8UDWZHckcq9Sz4129Qg3
        yaiNFZbWUxqqrsTdpXFj+sNidMoXedw5h1dv+Ww=
X-Google-Smtp-Source: APXvYqxwZ4iyVBiiHttXDKsl0VPIoAB0BaE0NhvpdBHuR+zTaQ9dzgix8PCzLpmSZXNp56hk1C7aL3V7QD7Pxb3BJU0=
X-Received: by 2002:a37:a387:: with SMTP id m129mr74144266qke.39.1558593325347;
 Wed, 22 May 2019 23:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190522125353.6106-1-bjorn.topel@gmail.com> <20190522125353.6106-2-bjorn.topel@gmail.com>
 <883964c3ad30ec49db599241857ceb41d8b35567.camel@mellanox.com>
In-Reply-To: <883964c3ad30ec49db599241857ceb41d8b35567.camel@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 23 May 2019 08:35:13 +0200
Message-ID: <CAJ+HfNg947QSVoQ_jV27PAC5EErK5kVdrA3=6WEY=fxdve-QRw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "toke@redhat.com" <toke@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 at 07:47, Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Wed, 2019-05-22 at 14:53 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > All XDP capable drivers need to implement the XDP_QUERY_PROG{,_HW}
> > command of ndo_bpf. The query code is fairly generic. This commit
> > refactors the query code up from the drivers to the netdev level.
> >
> > The struct net_device has gained four new members tracking the XDP
> > program, the corresponding program flags, and which programs
> > (SKB_MODE, DRV_MODE or HW_MODE) that are activated.
> >
> > The xdp_prog member, previously only used for SKB_MODE, is shared
> > with
> > DRV_MODE, since they are mutually exclusive.
> >
> > The program query operations is all done under the rtnl lock.
> > However,
> > the xdp_prog member is __rcu annotated, and used in a lock-less
> > manner
> > for the SKB_MODE. This is because the xdp_prog member is shared from
> > a
> > query program perspective (again, SKB and DRV are mutual exclusive),
> > RCU read and assignments functions are still used when altering
> > xdp_prog, even when only for queries in DRV_MODE. This is for
> > sparse/lockdep correctness.
> >
> > A minor behavioral change was done during this refactorization; When
> > passing a negative file descriptor to a netdev to disable XDP, the
> > same program flag as the running program is required. An example.
> >
> > The eth0 is DRV_DRV capable. Previously, this was OK, but confusing:
> >
> >   # ip link set dev eth0 xdp obj foo.o sec main
> >   # ip link set dev eth0 xdpgeneric off
> >
> > Now, the same commands give:
> >
> >   # ip link set dev eth0 xdp obj foo.o sec main
> >   # ip link set dev eth0 xdpgeneric off
> >   Error: native and generic XDP can't be active at the same time.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
> >  include/linux/netdevice.h |  13 +++--
> >  net/core/dev.c            | 120 ++++++++++++++++++++--------------
> > ----
> >  net/core/rtnetlink.c      |  33 ++---------
> >  3 files changed, 76 insertions(+), 90 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 44b47e9df94a..bdcb20a3946c 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1940,6 +1940,11 @@ struct net_device {
> >  #endif
> >       struct hlist_node       index_hlist;
> >
> > +     struct bpf_prog         *xdp_prog_hw;
> > +     unsigned int            xdp_flags;
> > +     u32                     xdp_prog_flags;
> > +     u32                     xdp_prog_hw_flags;
> > +
>
>
> Maybe it will be nicer if you wrap all xdp related data in one struct,
> This is good as a weak enforcement so future xdp extensions will go to
> the same place and not spread all across the net_device struct.
>
> this is going to be handy when we start introducing XDP offloads.
>
> >  /*
> >   * Cache lines mostly used on transmit path
> >   */
> > @@ -2045,9 +2050,8 @@ struct net_device {
> >
> >  static inline bool netif_elide_gro(const struct net_device *dev)
> >  {
> > -     if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
> > -             return true;
> > -     return false;
> > +     return !(dev->features & NETIF_F_GRO) ||
> > +             dev->xdp_flags & XDP_FLAGS_SKB_MODE;
> >  }
> >
> >  #define      NETDEV_ALIGN            32
> > @@ -3684,8 +3688,7 @@ struct sk_buff *dev_hard_start_xmit(struct
> > sk_buff *skb, struct net_device *dev,
> >  typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf
> > *bpf);
> >  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack
> > *extack,
> >                     int fd, u32 flags);
> > -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
> > -                 enum bpf_netdev_command cmd);
> > +u32 dev_xdp_query(struct net_device *dev, unsigned int flags);
> >  int xdp_umem_query(struct net_device *dev, u16 queue_id);
> >
> >  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index b6b8505cfb3e..ead16c3f955c 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -8005,31 +8005,31 @@ int dev_change_proto_down_generic(struct
> > net_device *dev, bool proto_down)
> >  }
> >  EXPORT_SYMBOL(dev_change_proto_down_generic);
> >
> > -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
> > -                 enum bpf_netdev_command cmd)
> > +u32 dev_xdp_query(struct net_device *dev, unsigned int flags)
> >  {
> > -     struct netdev_bpf xdp;
> > +     struct bpf_prog *prog =3D NULL;
> >
> > -     if (!bpf_op)
> > +     if (hweight32(flags) !=3D 1)
> >               return 0;
> >
> > -     memset(&xdp, 0, sizeof(xdp));
> > -     xdp.command =3D cmd;
> > -
> > -     /* Query must always succeed. */
> > -     WARN_ON(bpf_op(dev, &xdp) < 0 && cmd =3D=3D XDP_QUERY_PROG);
>
> since now this function can only query PROG or PROG_HW it is a good
> time to reflect that in the function name, maybe dev_xdp_query_prog is
> a better name ?
>
> > +     if (flags & (XDP_FLAGS_SKB_MODE | XDP_FLAGS_DRV_MODE))
> > +             prog =3D rtnl_dereference(dev->xdp_prog);
> > +     else if (flags & XDP_FLAGS_HW_MODE)
> > +             prog =3D dev->xdp_prog_hw;
> >
> > -     return xdp.prog_id;
> > +     return prog ? prog->aux->id : 0;
> >  }
> >
> > -static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
> > +static int dev_xdp_install(struct net_device *dev, unsigned int
> > target,
> >                          struct netlink_ext_ack *extack, u32 flags,
> >                          struct bpf_prog *prog)
> >  {
> > +     bpf_op_t bpf_op =3D dev->netdev_ops->ndo_bpf;
>
> I would assing bpf_op below :
> bpf_op =3D (target =3D=3D XDP_FLAGS_SKB_MODE) ?
>          generic_xdp_install :
>          dev->netdev_ops->ndo_bpf;
>
> or just drop bpf_op and call dev->netdev_ops->ndo_bpf in the one place
> it bpf_op is being called.
>
> >       struct netdev_bpf xdp;
> > +     int err;
> >
> >       memset(&xdp, 0, sizeof(xdp));
> > -     if (flags & XDP_FLAGS_HW_MODE)
> > +     if (target =3D=3D XDP_FLAGS_HW_MODE)
> >               xdp.command =3D XDP_SETUP_PROG_HW;
> >       else
> >               xdp.command =3D XDP_SETUP_PROG;
> > @@ -8037,35 +8037,41 @@ static int dev_xdp_install(struct net_device
> > *dev, bpf_op_t bpf_op,
> >       xdp.flags =3D flags;
> >       xdp.prog =3D prog;
>
> Are you sure no one is using flags
> >
> > -     return bpf_op(dev, &xdp);
> > +     err =3D (target =3D=3D XDP_FLAGS_SKB_MODE) ?
> > +           generic_xdp_install(dev, &xdp) :
> > +           bpf_op(dev, &xdp);
> > +     if (!err) {
> > +             if (prog)
> > +                     dev->xdp_flags |=3D target;
> > +             else
> > +                     dev->xdp_flags &=3D ~target;
> > +
> > +             if (target =3D=3D XDP_FLAGS_HW_MODE) {
> > +                     dev->xdp_prog_hw =3D prog;
> > +                     dev->xdp_prog_hw_flags =3D flags;
> > +             } else if (target =3D=3D XDP_FLAGS_DRV_MODE) {
> > +                     rcu_assign_pointer(dev->xdp_prog, prog);
> > +                     dev->xdp_prog_flags =3D flags;
> > +             }
> > +     }
> > +
> > +     return err;
> >  }
> >
> >  static void dev_xdp_uninstall(struct net_device *dev)
> >  {
> > -     struct netdev_bpf xdp;
> > -     bpf_op_t ndo_bpf;
> > -
> > -     /* Remove generic XDP */
> > -     WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0,
> > NULL));
> > -
> > -     /* Remove from the driver */
> > -     ndo_bpf =3D dev->netdev_ops->ndo_bpf;
> > -     if (!ndo_bpf)
> > -             return;
> > -
> > -     memset(&xdp, 0, sizeof(xdp));
> > -     xdp.command =3D XDP_QUERY_PROG;
> > -     WARN_ON(ndo_bpf(dev, &xdp));
> > -     if (xdp.prog_id)
> > -             WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL,
> > xdp.prog_flags,
> > -                                     NULL));
> > -
> > -     /* Remove HW offload */
> > -     memset(&xdp, 0, sizeof(xdp));
> > -     xdp.command =3D XDP_QUERY_PROG_HW;
> > -     if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
> > -             WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL,
> > xdp.prog_flags,
> > -                                     NULL));
> > +     if (dev->xdp_flags & XDP_FLAGS_SKB_MODE) {
> > +             WARN_ON(dev_xdp_install(dev, XDP_FLAGS_SKB_MODE,
> > +                                     NULL, 0, NULL));
> > +     }
> > +     if (dev->xdp_flags & XDP_FLAGS_DRV_MODE) {
> > +             WARN_ON(dev_xdp_install(dev, XDP_FLAGS_DRV_MODE,
> > +                                     NULL, dev->xdp_prog_flags,
> > NULL));
> > +     }
> > +     if (dev->xdp_flags & XDP_FLAGS_HW_MODE) {
> > +             WARN_ON(dev_xdp_install(dev, XDP_FLAGS_HW_MODE,
> > +                                     NULL, dev->xdp_prog_hw_flags,
> > NULL));
> > +     }
>
> instead this long "if" dance, why don't you just use xdp->flags inside
> dev_xdp_install when prog is NULL ?
> I would even consider introducing an uninstall function, which doesn't
> receive flags, and will use xdp->flags directly..
>
> uninstall can be just a two liner function
>
> dev_xdp_uninstall() {
> xdp.prog =3D NULL;
> (dev->xdp_flags =3D=3D XDP_FLAGS_SKB_MODE) ?
>       generic_xdp_install(dev, &xdp) :
>       dev->netdev_ops->ndo_bpf(dev, &xdp);
> dev->xdp_flags &=3D ~(XDP_FLAGS_SKB_MODE | XDP_FLAGS_HW_MODE |
> XDP_FLAGS_DRV_MODE);
> }
>
> >  }
> >
> >  /**
> > @@ -8080,41 +8086,41 @@ static void dev_xdp_uninstall(struct
> > net_device *dev)
> >  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack
> > *extack,
> >                     int fd, u32 flags)
> >  {
> > -     const struct net_device_ops *ops =3D dev->netdev_ops;
> > -     enum bpf_netdev_command query;
> > +     bool offload, drv_supp =3D !!dev->netdev_ops->ndo_bpf;
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
>
> I don't think you really need this target parameter it only complicates
> things for no reason, all information you need are already in flags and
> dev->xdp_flags.
>
> >
> > -     bpf_op =3D bpf_chk =3D ops->ndo_bpf;
> > -     if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE |
> > XDP_FLAGS_HW_MODE))) {
> > +     if (!drv_supp && (flags & (XDP_FLAGS_DRV_MODE |
> > XDP_FLAGS_HW_MODE))) {
> >               NL_SET_ERR_MSG(extack, "underlying driver does not
> > support XDP in native mode");
> >               return -EOPNOTSUPP;
> >       }
> > -     if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
> > -             bpf_op =3D generic_xdp_install;
> > -     if (bpf_op =3D=3D bpf_chk)
> > -             bpf_chk =3D generic_xdp_install;
> > +
> > +     if (!drv_supp || (flags & XDP_FLAGS_SKB_MODE))
> > +             target =3D XDP_FLAGS_SKB_MODE;
> > +
>
> since dev_xdp_install handles all cases now, you don't need this logic
> here, I would move this into dev_xdp_install, maybe introduce a helper
> dedicated function to choose the mode to be used.
>
> > +     if ((target =3D=3D XDP_FLAGS_SKB_MODE &&
> > +          dev->xdp_flags & XDP_FLAGS_DRV_MODE) ||
> > +         (target =3D=3D XDP_FLAGS_DRV_MODE &&
> > +          dev->xdp_flags & XDP_FLAGS_SKB_MODE)) {
> > +             NL_SET_ERR_MSG(extack, "native and generic XDP can't be
> > active at the same time");
> > +             return -EEXIST;
> > +     }
> >
> >       if (fd >=3D 0) {
> > -             if (!offload && __dev_xdp_query(dev, bpf_chk,
> > XDP_QUERY_PROG)) {
> > -                     NL_SET_ERR_MSG(extack, "native and generic XDP
> > can't be active at the same time");
> > -                     return -EEXIST;
> > -             }
> > -             if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) &&
> > -                 __dev_xdp_query(dev, bpf_op, query)) {
> > +             if (flags & XDP_FLAGS_UPDATE_IF_NOEXIST &&
> > +                 dev_xdp_query(dev, target)) {
> >                       NL_SET_ERR_MSG(extack, "XDP program already
> > attached");
> >                       return -EBUSY;
> >               }
> >
> > -             prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
> > -                                          bpf_op =3D=3D ops->ndo_bpf);
> > +             prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
> > drv_supp);
> > +
> >               if (IS_ERR(prog))
> >                       return PTR_ERR(prog);
> >
> > @@ -8125,7 +8131,7 @@ int dev_change_xdp_fd(struct net_device *dev,
> > struct netlink_ext_ack *extack,
> >               }
> >       }
> >
> > -     err =3D dev_xdp_install(dev, bpf_op, extack, flags, prog);
> > +     err =3D dev_xdp_install(dev, target, extack, flags, prog);
> >       if (err < 0 && prog)
> >               bpf_prog_put(prog);
> >
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index adcc045952c2..99ca58db297f 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1360,37 +1360,14 @@ static int rtnl_fill_link_ifmap(struct
> > sk_buff *skb, struct net_device *dev)
> >       return 0;
> >  }
> >
> > -static u32 rtnl_xdp_prog_skb(struct net_device *dev)
> > -{
> > -     const struct bpf_prog *generic_xdp_prog;
> > -
> > -     ASSERT_RTNL();
> > -
> > -     generic_xdp_prog =3D rtnl_dereference(dev->xdp_prog);
> > -     if (!generic_xdp_prog)
> > -             return 0;
> > -     return generic_xdp_prog->aux->id;
> > -}
> > -
> > -static u32 rtnl_xdp_prog_drv(struct net_device *dev)
> > -{
> > -     return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
> > XDP_QUERY_PROG);
> > -}
> > -
> > -static u32 rtnl_xdp_prog_hw(struct net_device *dev)
> > -{
> > -     return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
> > -                            XDP_QUERY_PROG_HW);
> > -}
> > -
> >  static int rtnl_xdp_report_one(struct sk_buff *skb, struct
> > net_device *dev,
> >                              u32 *prog_id, u8 *mode, u8 tgt_mode, u32
> > attr,
> > -                            u32 (*get_prog_id)(struct net_device
> > *dev))
> > +                            unsigned int tgt_flags)
> >  {
> >       u32 curr_id;
> >       int err;
> >
> > -     curr_id =3D get_prog_id(dev);
> > +     curr_id =3D dev_xdp_query(dev, tgt_flags);
> >       if (!curr_id)
> >               return 0;
> >
> > @@ -1421,15 +1398,15 @@ static int rtnl_xdp_fill(struct sk_buff *skb,
> > struct net_device *dev)
> >       prog_id =3D 0;
> >       mode =3D XDP_ATTACHED_NONE;
> >       err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode,
> > XDP_ATTACHED_SKB,
> > -                               IFLA_XDP_SKB_PROG_ID,
> > rtnl_xdp_prog_skb);
> > +                               IFLA_XDP_SKB_PROG_ID,
> > XDP_FLAGS_SKB_MODE);
> >       if (err)
> >               goto err_cancel;
> >       err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode,
> > XDP_ATTACHED_DRV,
> > -                               IFLA_XDP_DRV_PROG_ID,
> > rtnl_xdp_prog_drv);
> > +                               IFLA_XDP_DRV_PROG_ID,
> > XDP_FLAGS_DRV_MODE);
> >       if (err)
> >               goto err_cancel;
> >       err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode,
> > XDP_ATTACHED_HW,
> > -                               IFLA_XDP_HW_PROG_ID,
> > rtnl_xdp_prog_hw);
> > +                               IFLA_XDP_HW_PROG_ID,
> > XDP_FLAGS_HW_MODE);
> >       if (err)
> >               goto err_cancel;
> >

Saeed, thanks a lot for your comments! All good stuff. I'll address
them in the next version!


Thanks,
Bj=C3=B6rn
