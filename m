Return-Path: <netdev+bounces-10488-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 506AD72EB62
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A96BC280FC6
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6A222E38;
	Tue, 13 Jun 2023 19:00:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DD022D50
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:00:40 +0000 (UTC)
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880F3127
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:00:38 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-54fbcfe65caso619953a12.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686682838; x=1689274838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vs14/fKtr4DPyqSYwzzBe6mXTrCQCHaz4qYHBzynhw0=;
        b=4pKJ7sYEEKq0iMijFJSsPXYV0lyrqI3ifAu2E0A0pQv7jWuR80thyVh5WP3RF6WAAM
         5Ed24mdQwvP8DGEBHv9mU8XeHMMVdlODbYXxgmYtStxVF8dJU5v89d9BgCjbMfxIpsys
         ZhYrsflgT+BmBh3jxZ6SJ2vYITDW6RAHd1IbIPk8lK7dc/9BPFy+NqLIdTxgwt6MaMx3
         FwErFP3lqB3o59x9Vfle8U7dovHHdXzFYTV546L9rRWrBw7b9rgwYMv9RJLvcChO6Syi
         c4luWUt/uUnQMkIa77p36QPHLHFPhdf+4eWHoDTO3wt8P29RU7f/8ZoD6wMDuqqxDgTe
         jX/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686682838; x=1689274838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vs14/fKtr4DPyqSYwzzBe6mXTrCQCHaz4qYHBzynhw0=;
        b=St4Etjpz+5EG+oxYhfFG1kxGvaV4CtkZ7TcgoKq+gOV9Zb4B9ynF9Nk4Qu/HXb/+cL
         cmsghFLEvGuSnSbsKC0PTcvfaTNInz55Cx0vv90nJJ3pT1eJgjQdwWZHIJXAdWEvDDUK
         Po/V8fJzfhORL8aXKq4EpxhaPMDUsCM7pIh2OQj9nnFfmwhi+RANVGsW1xTq9ETcyRX4
         iWleiE7AbFySz1hu6en8z+Z5TQ7Vsg2RTPNyd9uYXOqqwGkEXlsiwU9HSLIjwlwsanuX
         Gl4p3OuYI9DvCw0udUMZDVEcJ8IphAheINkoQVWYJRF8RyyDFBQdf6pSYEZPJ+60zxcd
         UM4w==
X-Gm-Message-State: AC+VfDwczC7vQFgcbQK46VsxenAP0fu/VffRxqJXtbNF85I7UTe2MJXR
	gwEtr35qCaHGQGGEBOdM5ODUEuu0x4DRd3XKyFMYfA==
X-Google-Smtp-Source: ACHHUZ4WqSCGfeQBzyN44zymTgFyUKqOvffFvm0wBFQhenvhw82/9+jv/Gv+Av6Q4x8SS2xQ2S18TlhGe7VMJe3p8kE=
X-Received: by 2002:a17:90a:1a15:b0:25b:a15e:58b8 with SMTP id
 21-20020a17090a1a1500b0025ba15e58b8mr15268500pjk.10.1686682837510; Tue, 13
 Jun 2023 12:00:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230612172307.3923165-4-sdf@google.com>
 <ZIiGVrHLKQRzMzGg@corigine.com>
In-Reply-To: <ZIiGVrHLKQRzMzGg@corigine.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Tue, 13 Jun 2023 12:00:25 -0700
Message-ID: <CAKH8qBvfp7Do1tSD4YiiNVojG2gB9+mrNNLiVFz+ts4gU+pJrA@mail.gmail.com>
Subject: Re: [RFC bpf-next 3/7] bpf: implement devtx hook points
To: Simon Horman <simon.horman@corigine.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com, 
	jolsa@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 8:08=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Mon, Jun 12, 2023 at 10:23:03AM -0700, Stanislav Fomichev wrote:
> > devtx is a lightweight set of hooks before and after packet transmissio=
n.
> > The hook is supposed to work for both skb and xdp paths by exposing
> > a light-weight packet wrapper via devtx_frame (header portion + frags).
> >
> > devtx is implemented as a tracing program which has access to the
> > XDP-metadata-like kfuncs. The initial set of kfuncs is implemented
> > in the next patch, but the idea is similar to XDP metadata:
> > the kfuncs have netdev-specific implementation, but common
> > interface. Upon loading, the kfuncs are resolved to direct
> > calls against per-netdev implementation. This can be achieved
> > by marking devtx-tracing programs as dev-bound (largely
> > reusing xdp-dev-bound program infrastructure).
> >
> > Attachment and detachment is implemented via syscall BPF program
> > by calling bpf_devtx_sb_attach (attach to tx-submission)
> > or bpf_devtx_cp_attach (attach to tx completion). Right now,
> > the attachment does not return a link and doesn't support
> > multiple programs. I plan to switch to Daniel's bpf_mprog infra
> > once it's available.
> >
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>
> ...
>
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -22976,11 +22976,13 @@ L:  bpf@vger.kernel.org
> >  S:   Supported
> >  F:   drivers/net/ethernet/*/*/*/*/*xdp*
> >  F:   drivers/net/ethernet/*/*/*xdp*
> > +F:   include/net/devtx.h
> >  F:   include/net/xdp.h
> >  F:   include/net/xdp_priv.h
> >  F:   include/trace/events/xdp.h
> >  F:   kernel/bpf/cpumap.c
> >  F:   kernel/bpf/devmap.c
> > +F:   net/core/devtx.c
> >  F:   net/core/xdp.c
> >  F:   samples/bpf/xdp*
> >  F:   tools/testing/selftests/bpf/*/*xdp*
>
> Hi Stan,
>
> some feedback from my side.
>
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 08fbd4622ccf..e08e3fd39dfc 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -2238,6 +2238,8 @@ struct net_device {
> >       unsigned int            real_num_rx_queues;
> >
> >       struct bpf_prog __rcu   *xdp_prog;
> > +     struct bpf_prog __rcu   *devtx_sb;
> > +     struct bpf_prog __rcu   *devtx_cp;
>
> It would be good to add these new fields to the kernel doc
> for struct net_device.

Sure, will do!

> >       unsigned long           gro_flush_timeout;
> >       int                     napi_defer_hard_irqs;
> >  #define GRO_LEGACY_MAX_SIZE  65536u
> > diff --git a/include/net/devtx.h b/include/net/devtx.h
> > new file mode 100644
> > index 000000000000..7eab66d0ce80
> > --- /dev/null
> > +++ b/include/net/devtx.h
> > @@ -0,0 +1,76 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +#ifndef __LINUX_NET_DEVTX_H__
> > +#define __LINUX_NET_DEVTX_H__
> > +
> > +#include <linux/jump_label.h>
> > +#include <linux/skbuff.h>
> > +#include <linux/netdevice.h>
> > +#include <net/xdp.h>
> > +
> > +struct devtx_frame {
> > +     void *data;
> > +     u16 len;
> > +     struct skb_shared_info *sinfo; /* for frags */
> > +};
> > +
> > +#ifdef CONFIG_NET
> > +void devtx_submit(struct net_device *netdev, struct devtx_frame *ctx);
> > +void devtx_complete(struct net_device *netdev, struct devtx_frame *ctx=
);
> > +bool is_devtx_kfunc(u32 kfunc_id);
> > +void devtx_shutdown(struct net_device *netdev);
> > +
> > +static inline void devtx_frame_from_skb(struct devtx_frame *ctx, struc=
t sk_buff *skb)
> > +{
> > +     ctx->data =3D skb->data;
> > +     ctx->len =3D skb_headlen(skb);
> > +     ctx->sinfo =3D skb_shinfo(skb);
> > +}
> > +
> > +static inline void devtx_frame_from_xdp(struct devtx_frame *ctx, struc=
t xdp_frame *xdpf)
> > +{
> > +     ctx->data =3D xdpf->data;
> > +     ctx->len =3D xdpf->len;
> > +     ctx->sinfo =3D xdp_frame_has_frags(xdpf) ? xdp_get_shared_info_fr=
om_frame(xdpf) : NULL;
> > +}
> > +
> > +DECLARE_STATIC_KEY_FALSE(devtx_enabled);
> > +
> > +static inline bool devtx_submit_enabled(struct net_device *netdev)
> > +{
> > +     return static_branch_unlikely(&devtx_enabled) &&
> > +            rcu_access_pointer(netdev->devtx_sb);
> > +}
> > +
> > +static inline bool devtx_complete_enabled(struct net_device *netdev)
> > +{
> > +     return static_branch_unlikely(&devtx_enabled) &&
> > +            rcu_access_pointer(netdev->devtx_cp);
> > +}
> > +#else
> > +static inline void devtx_submit(struct net_device *netdev, struct devt=
x_frame *ctx)
> > +{
> > +}
> > +
> > +static inline void devtx_complete(struct net_device *netdev, struct de=
vtx_frame *ctx)
> > +{
> > +}
> > +
> > +static inline bool is_devtx_kfunc(u32 kfunc_id)
> > +{
> > +     return false;
> > +}
> > +
> > +static inline void devtx_shutdown(struct net_device *netdev)
> > +{
> > +}
> > +
> > +static inline void devtx_frame_from_skb(struct devtx_frame *ctx, struc=
t sk_buff *skb)
> > +{
> > +}
> > +
> > +static inline void devtx_frame_from_xdp(struct devtx_frame *ctx, struc=
t xdp_frame *xdpf)
> > +{
> > +}
> > +#endif
> > +
> > +#endif /* __LINUX_NET_DEVTX_H__ */
> > diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> > index 235d81f7e0ed..9cfe96422c80 100644
> > --- a/kernel/bpf/offload.c
> > +++ b/kernel/bpf/offload.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/rhashtable.h>
> >  #include <linux/rtnetlink.h>
> >  #include <linux/rwsem.h>
> > +#include <net/devtx.h>
> >
> >  /* Protects offdevs, members of bpf_offload_netdev and offload members
> >   * of all progs.
> > @@ -228,6 +229,7 @@ int bpf_prog_dev_bound_init(struct bpf_prog *prog, =
union bpf_attr *attr)
> >       int err;
> >
> >       if (attr->prog_type !=3D BPF_PROG_TYPE_SCHED_CLS &&
> > +         attr->prog_type !=3D BPF_PROG_TYPE_TRACING &&
> >           attr->prog_type !=3D BPF_PROG_TYPE_XDP)
> >               return -EINVAL;
> >
> > @@ -238,6 +240,10 @@ int bpf_prog_dev_bound_init(struct bpf_prog *prog,=
 union bpf_attr *attr)
> >           attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY)
> >               return -EINVAL;
> >
> > +     if (attr->prog_type =3D=3D BPF_PROG_TYPE_TRACING &&
> > +         !is_devtx_kfunc(prog->aux->attach_btf_id))
> > +             return -EINVAL;
> > +
> >       netdev =3D dev_get_by_index(current->nsproxy->net_ns, attr->prog_=
ifindex);
> >       if (!netdev)
> >               return -EINVAL;
> > diff --git a/net/core/Makefile b/net/core/Makefile
> > index 8f367813bc68..c1db05ccfac7 100644
> > --- a/net/core/Makefile
> > +++ b/net/core/Makefile
> > @@ -39,4 +39,5 @@ obj-$(CONFIG_FAILOVER) +=3D failover.o
> >  obj-$(CONFIG_NET_SOCK_MSG) +=3D skmsg.o
> >  obj-$(CONFIG_BPF_SYSCALL) +=3D sock_map.o
> >  obj-$(CONFIG_BPF_SYSCALL) +=3D bpf_sk_storage.o
> > +obj-$(CONFIG_BPF_SYSCALL) +=3D devtx.o
> >  obj-$(CONFIG_OF)     +=3D of_net.o
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 3393c2f3dbe8..ef0e65e68024 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -150,6 +150,7 @@
> >  #include <linux/pm_runtime.h>
> >  #include <linux/prandom.h>
> >  #include <linux/once_lite.h>
> > +#include <net/devtx.h>
> >
> >  #include "dev.h"
> >  #include "net-sysfs.h"
> > @@ -10875,6 +10876,7 @@ void unregister_netdevice_many_notify(struct li=
st_head *head,
> >               dev_shutdown(dev);
> >
> >               dev_xdp_uninstall(dev);
> > +             devtx_shutdown(dev);
> >               bpf_dev_bound_netdev_unregister(dev);
> >
> >               netdev_offload_xstats_disable_all(dev);
> > diff --git a/net/core/devtx.c b/net/core/devtx.c
> > new file mode 100644
> > index 000000000000..b7cbc26d1c01
> > --- /dev/null
> > +++ b/net/core/devtx.c
> > @@ -0,0 +1,208 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +#include <net/devtx.h>
> > +#include <linux/filter.h>
> > +
> > +DEFINE_STATIC_KEY_FALSE(devtx_enabled);
> > +EXPORT_SYMBOL_GPL(devtx_enabled);
> > +
> > +static void devtx_run(struct net_device *netdev, struct devtx_frame *c=
tx, struct bpf_prog **pprog)
>
> Is an __rcu annotation appropriate for prog here?
> Also elsewhere in this patch.

Good point. Maybe I should rcu_dereference it them somewhere on top.
Let me try to find the best place..

> > +{
> > +     struct bpf_prog *prog;
> > +     void *real_ctx[1] =3D {ctx};
> > +
> > +     prog =3D rcu_dereference(*pprog);
> > +     if (likely(prog))
> > +             bpf_prog_run(prog, real_ctx);
> > +}
> > +
> > +void devtx_submit(struct net_device *netdev, struct devtx_frame *ctx)
> > +{
> > +     rcu_read_lock();
> > +     devtx_run(netdev, ctx, &netdev->devtx_sb);
> > +     rcu_read_unlock();
> > +}
> > +EXPORT_SYMBOL_GPL(devtx_submit);
> > +
> > +void devtx_complete(struct net_device *netdev, struct devtx_frame *ctx=
)
> > +{
> > +     rcu_read_lock();
> > +     devtx_run(netdev, ctx, &netdev->devtx_cp);
> > +     rcu_read_unlock();
> > +}
> > +EXPORT_SYMBOL_GPL(devtx_complete);
> > +
> > +/**
> > + * devtx_sb - Called for every egress netdev packet
>
> As this is a kernel doc, it would be good to document the ctx parameter h=
ere.

I didn't really find a convincing way to add a comment, I've had the
following which I've removed prio to submission:
@ctx devtx_frame context

But it doesn't seem like it brings anything useful? Or ok to keep it that w=
ay?

> > + *
> > + * Note: this function is never actually called by the kernel and decl=
ared
> > + * only to allow loading an attaching appropriate tracepoints.
> > + */
> > +__weak noinline void devtx_sb(struct devtx_frame *ctx)
>
> I guess this is intentional.
> But gcc complains that this is neither static nor is a forward
> declaration provided. Likewise for devtx_cp()

Copy-pasted from hid-bpf; let me see if they have a forward decl somewhere.=
.

> > +{
> > +}
> > +
> > +/**
> > + * devtx_cp - Called upon egress netdev packet completion
>
> Likewise, here too.
>
> > + *
> > + * Note: this function is never actually called by the kernel and decl=
ared
> > + * only to allow loading an attaching appropriate tracepoints.
> > + */
> > +__weak noinline void devtx_cp(struct devtx_frame *ctx)
> > +{
> > +}
> > +
> > +BTF_SET8_START(bpf_devtx_hook_ids)
> > +BTF_ID_FLAGS(func, devtx_sb)
> > +BTF_ID_FLAGS(func, devtx_cp)
> > +BTF_SET8_END(bpf_devtx_hook_ids)
> > +
> > +static const struct btf_kfunc_id_set bpf_devtx_hook_set =3D {
> > +     .owner =3D THIS_MODULE,
> > +     .set   =3D &bpf_devtx_hook_ids,
> > +};
> > +
> > +static DEFINE_MUTEX(devtx_attach_lock);
> > +
> > +static int __bpf_devtx_detach(struct net_device *netdev, struct bpf_pr=
og **pprog)
> > +{
>
> As per my prior comment about *prog and __rcu annotations.
> I'm genuinely unsure how the usage of **pprog in this function sits with =
RCU.

Yeah, I'm a bit sloppy, let me figure out a proper way to annotate it.


> > +     if (!*pprog)
> > +             return -EINVAL;
> > +     bpf_prog_put(*pprog);
> > +     *pprog =3D NULL;
> > +
> > +     static_branch_dec(&devtx_enabled);
> > +     return 0;
> > +}
> > +
> > +static int __bpf_devtx_attach(struct net_device *netdev, int prog_fd,
> > +                           const char *attach_func_name, struct bpf_pr=
og **pprog)
> > +{
> > +     struct bpf_prog *prog;
> > +     int ret =3D 0;
> > +
> > +     if (prog_fd < 0)
> > +             return __bpf_devtx_detach(netdev, pprog);
> > +
> > +     if (*pprog)
> > +             return -EBUSY;
> > +
> > +     prog =3D bpf_prog_get(prog_fd);
> > +     if (IS_ERR(prog))
> > +             return PTR_ERR(prog);
> > +
> > +     if (prog->type !=3D BPF_PROG_TYPE_TRACING ||
> > +         prog->expected_attach_type !=3D BPF_TRACE_FENTRY ||
> > +         !bpf_prog_is_dev_bound(prog->aux) ||
> > +         !bpf_offload_dev_match(prog, netdev) ||
> > +         strcmp(prog->aux->attach_func_name, attach_func_name)) {
> > +             bpf_prog_put(prog);
> > +             return -EINVAL;
> > +     }
> > +
> > +     *pprog =3D prog;
> > +     static_branch_inc(&devtx_enabled);
> > +
> > +     return ret;
> > +}
>
> ...

