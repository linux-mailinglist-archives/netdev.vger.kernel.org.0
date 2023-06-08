Return-Path: <netdev+bounces-9381-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38FCB728A2A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3C1A281770
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FDC34CD2;
	Thu,  8 Jun 2023 21:20:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C821DCDC;
	Thu,  8 Jun 2023 21:20:17 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA152D7B;
	Thu,  8 Jun 2023 14:20:14 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-5149b63151aso1882352a12.3;
        Thu, 08 Jun 2023 14:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686259213; x=1688851213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOvSh+fOBaKywhUMpRbCMW91BJyD+dHQ1LQJBzikVHQ=;
        b=rNpTkzg+Jj1+VVVqgPgHXngYtrkUAGsPJBO5TSnrsfJ1IPB6IE9k+kZp8xoNRimzRk
         SlhEuQ0BzIID6YpusHOst27zN9iimDbZEUTmpU1BHnYm6I9reBK10+XeOr4JXnhnLB80
         gLnhENO2vq4ZGym/jnLkXb/h5/UtW1oJSM9mAOrdaZ3GGZNY1f//vBgy15p4EgGMyQzk
         /nKhGsRQKM7vECvfNN+m99Qx0cEViso5NnfJ59W6Ivrm7SVPRhmuKXv9qLKB04fzcPoI
         ru940E01My3+Yw4wLgncao7sqF3Xu+2yqdzOftQ+vnD3Zgp41JATf9M5R91UJWNDs84X
         kCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686259213; x=1688851213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mOvSh+fOBaKywhUMpRbCMW91BJyD+dHQ1LQJBzikVHQ=;
        b=QrNmy1kQB7oSde44iOKoCk1UQ3yySzgTlCpxEJ+FyV8AZn5vtX/yctV1t3iJYj9No/
         w/BQ4AlONpPDRxp4fzpLru6qbQaKXnmrbhQijeQqgyrncPIQBa74m/uxTNa7GTv98kND
         b9gAveNQ06ulN5bFV1ZHtBPRI4Tg3mmCCl1SXP2PiZNH2imVZysE5sjAUykalMLddP0o
         KvU7hW7xAm3EW6t6GIDmgv5NKPlIQPqeh+xOxqrcvhqT1wf7SrM/RwFEB3DS8Sxdb5Xu
         Z4GqChCf35MkMo4xELa2ocZJGZNNOdzuQIOcULcrHR5GRgBrHwt9GKbH12H/kCiyn+R8
         aaiQ==
X-Gm-Message-State: AC+VfDzRMTsKFTf4LvIhUO9qYawWqJpkbQfIG0iSZ3t+xrls9yV1cfiE
	zfZ3YUknyRtpl9Bk+95CS1aOHnQBJoPSFpuC7PYUpflob60=
X-Google-Smtp-Source: ACHHUZ4mWMVH8zp9fvbDwwrFSXbmyElyPSdBe6cFyqhIFk3Yb+gUnqsnfr+c/zck+PeMnknSC/LHdfsqU8KkahRn5pg=
X-Received: by 2002:a17:907:868d:b0:978:6f83:54f with SMTP id
 qa13-20020a170907868d00b009786f83054fmr355404ejc.57.1686259212840; Thu, 08
 Jun 2023 14:20:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-3-daniel@iogearbox.net>
In-Reply-To: <20230607192625.22641-3-daniel@iogearbox.net>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 8 Jun 2023 14:20:00 -0700
Message-ID: <CAEf4BzZK7gkQ2B3XguXjs2SALLmV54WXCdGPhkh6VE3s0J-WVg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/7] bpf: Add fd-based tcx multi-prog infra
 with link support
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev, 
	razor@blackwall.org, sdf@google.com, john.fastabend@gmail.com, 
	kuba@kernel.org, dxu@dxuuu.xyz, joe@cilium.io, toke@kernel.org, 
	davem@davemloft.net, bpf@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 7, 2023 at 12:27=E2=80=AFPM Daniel Borkmann <daniel@iogearbox.n=
et> wrote:
>
> This work refactors and adds a lightweight extension ("tcx") to the tc BP=
F
> ingress and egress data path side for allowing BPF program management bas=
ed
> on fds via bpf() syscall through the newly added generic multi-prog API.
> The main goal behind this work which we also presented at LPC [0] last ye=
ar
> and a recent update at LSF/MM/BPF this year [3] is to support long-awaite=
d
> BPF link functionality for tc BPF programs, which allows for a model of s=
afe
> ownership and program detachment.
>
> Given the rise in tc BPF users in cloud native environments, this becomes
> necessary to avoid hard to debug incidents either through stale leftover
> programs or 3rd party applications accidentally stepping on each others t=
oes.
> As a recap, a BPF link represents the attachment of a BPF program to a BP=
F
> hook point. The BPF link holds a single reference to keep BPF program ali=
ve.
> Moreover, hook points do not reference a BPF link, only the application's
> fd or pinning does. A BPF link holds meta-data specific to attachment and
> implements operations for link creation, (atomic) BPF program update,
> detachment and introspection. The motivation for BPF links for tc BPF pro=
grams
> is multi-fold, for example:
>
>   - From Meta: "It's especially important for applications that are deplo=
yed
>     fleet-wide and that don't "control" hosts they are deployed to. If su=
ch
>     application crashes and no one notices and does anything about that, =
BPF
>     program will keep running draining resources or even just, say, dropp=
ing
>     packets. We at FB had outages due to such permanent BPF attachment
>     semantics. With fd-based BPF link we are getting a framework, which a=
llows
>     safe, auto-detachable behavior by default, unless application explici=
tly
>     opts in by pinning the BPF link." [1]
>
>   - From Cilium-side the tc BPF programs we attach to host-facing veth de=
vices
>     and phys devices build the core datapath for Kubernetes Pods, and the=
y
>     implement forwarding, load-balancing, policy, EDT-management, etc, wi=
thin
>     BPF. Currently there is no concept of 'safe' ownership, e.g. we've re=
cently
>     experienced hard-to-debug issues in a user's staging environment wher=
e
>     another Kubernetes application using tc BPF attached to the same prio=
/handle
>     of cls_bpf, accidentally wiping all Cilium-based BPF programs from un=
derneath
>     it. The goal is to establish a clear/safe ownership model via links w=
hich
>     cannot accidentally be overridden. [0,2]
>
> BPF links for tc can co-exist with non-link attachments, and the semantic=
s are
> in line also with XDP links: BPF links cannot replace other BPF links, BP=
F
> links cannot replace non-BPF links, non-BPF links cannot replace BPF link=
s and
> lastly only non-BPF links can replace non-BPF links. In case of Cilium, t=
his
> would solve mentioned issue of safe ownership model as 3rd party applicat=
ions
> would not be able to accidentally wipe Cilium programs, even if they are =
not
> BPF link aware.
>
> Earlier attempts [4] have tried to integrate BPF links into core tc machi=
nery
> to solve cls_bpf, which has been intrusive to the generic tc kernel API w=
ith
> extensions only specific to cls_bpf and suboptimal/complex since cls_bpf =
could
> be wiped from the qdisc also. Locking a tc BPF program in place this way,=
 is
> getting into layering hacks given the two object models are vastly differ=
ent.
>
> We instead implemented the tcx (tc 'express') layer which is an fd-based =
tc BPF
> attach API, so that the BPF link implementation blends in naturally simil=
ar to
> other link types which are fd-based and without the need for changing cor=
e tc
> internal APIs. BPF programs for tc can then be successively migrated from=
 classic
> cls_bpf to the new tc BPF link without needing to change the program's so=
urce
> code, just the BPF loader mechanics for attaching is sufficient.
>
> For the current tc framework, there is no change in behavior with this ch=
ange
> and neither does this change touch on tc core kernel APIs. The gist of th=
is
> patch is that the ingress and egress hook have a lightweight, qdisc-less
> extension for BPF to attach its tc BPF programs, in other words, a minima=
l
> entry point for tc BPF. The name tcx has been suggested from discussion o=
f
> earlier revisions of this work as a good fit, and to more easily differ b=
etween
> the classic cls_bpf attachment and the fd-based one.
>
> For the ingress and egress tcx points, the device holds a cache-friendly =
array
> with program pointers which is separated from control plane (slow-path) d=
ata.
> Earlier versions of this work used priority to determine ordering and exp=
ression
> of dependencies similar as with classic tc, but it was challenged that fo=
r
> something more future-proof a better user experience is required. Hence t=
his
> resulted in the design and development of the generic attach/detach/query=
 API
> for multi-progs. See prior patch with its discussion on the API design. t=
cx is
> the first user and later we plan to integrate also others, for example, o=
ne
> candidate is multi-prog support for XDP which would benefit and have the =
same
> 'look and feel' from API perspective.
>
> The goal with tcx is to have maximum compatibility to existing tc BPF pro=
grams,
> so they don't need to be rewritten specifically. Compatibility to call in=
to
> classic tcf_classify() is also provided in order to allow successive migr=
ation
> or both to cleanly co-exist where needed given its all one logical tc lay=
er.
> tcx supports the simplified return codes TCX_NEXT which is non-terminatin=
g (go
> to next program) and terminating ones with TCX_PASS, TCX_DROP, TCX_REDIRE=
CT.
> The fd-based API is behind a static key, so that when unused the code is =
also
> not entered. The struct tcx_entry's program array is currently static, bu=
t
> could be made dynamic if necessary at a point in future. The a/b pair swa=
p
> design has been chosen so that for detachment there are no allocations wh=
ich
> otherwise could fail. The work has been tested with tc-testing selftest s=
uite
> which all passes, as well as the tc BPF tests from the BPF CI, and also w=
ith
> Cilium's L4LB.
>
> Kudos also to Nikolay Aleksandrov and Martin Lau for in-depth early revie=
ws
> of this work.
>
>   [0] https://lpc.events/event/16/contributions/1353/
>   [1] https://lore.kernel.org/bpf/CAEf4BzbokCJN33Nw_kg82sO=3DxppXnKWEncGT=
WCTB9vGCmLB6pw@mail.gmail.com/
>   [2] https://colocatedeventseu2023.sched.com/event/1Jo6O/tales-from-an-e=
bpf-programs-murder-mystery-hemanth-malla-guillaume-fournier-datadog
>   [3] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netdev_borkman=
n.pdf
>   [4] https://lore.kernel.org/bpf/20210604063116.234316-1-memxor@gmail.co=
m/
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  MAINTAINERS                    |   4 +-
>  include/linux/netdevice.h      |  15 +-
>  include/linux/skbuff.h         |   4 +-
>  include/net/sch_generic.h      |   2 +-
>  include/net/tcx.h              | 157 +++++++++++++++
>  include/uapi/linux/bpf.h       |  35 +++-
>  kernel/bpf/Kconfig             |   1 +
>  kernel/bpf/Makefile            |   1 +
>  kernel/bpf/syscall.c           |  95 +++++++--
>  kernel/bpf/tcx.c               | 347 +++++++++++++++++++++++++++++++++
>  net/Kconfig                    |   5 +
>  net/core/dev.c                 | 267 +++++++++++++++----------
>  net/core/filter.c              |   4 +-
>  net/sched/Kconfig              |   4 +-
>  net/sched/sch_ingress.c        |  45 ++++-
>  tools/include/uapi/linux/bpf.h |  35 +++-
>  16 files changed, 877 insertions(+), 144 deletions(-)
>  create mode 100644 include/net/tcx.h
>  create mode 100644 kernel/bpf/tcx.c
>

[...]

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 207f8a37b327..e7584e24bc83 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1035,6 +1035,8 @@ enum bpf_attach_type {
>         BPF_TRACE_KPROBE_MULTI,
>         BPF_LSM_CGROUP,
>         BPF_STRUCT_OPS,
> +       BPF_TCX_INGRESS,
> +       BPF_TCX_EGRESS,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -1052,7 +1054,7 @@ enum bpf_link_type {
>         BPF_LINK_TYPE_KPROBE_MULTI =3D 8,
>         BPF_LINK_TYPE_STRUCT_OPS =3D 9,
>         BPF_LINK_TYPE_NETFILTER =3D 10,
> -
> +       BPF_LINK_TYPE_TCX =3D 11,
>         MAX_BPF_LINK_TYPE,
>  };
>
> @@ -1559,13 +1561,13 @@ union bpf_attr {
>                         __u32           map_fd;         /* struct_ops to =
attach */
>                 };
>                 union {
> -                       __u32           target_fd;      /* object to atta=
ch to */
> -                       __u32           target_ifindex; /* target ifindex=
 */
> +                       __u32   target_fd;      /* target object to attac=
h to or ... */
> +                       __u32   target_ifindex; /* target ifindex */
>                 };
>                 __u32           attach_type;    /* attach type */
>                 __u32           flags;          /* extra flags */
>                 union {
> -                       __u32           target_btf_id;  /* btf_id of targ=
et to attach to */
> +                       __u32   target_btf_id;  /* btf_id of target to at=
tach to */

nit: should this part be in patch 1?

>                         struct {
>                                 __aligned_u64   iter_info;      /* extra =
bpf_iter_link_info */
>                                 __u32           iter_info_len;  /* iter_i=
nfo length */
> @@ -1599,6 +1601,13 @@ union bpf_attr {
>                                 __s32           priority;
>                                 __u32           flags;
>                         } netfilter;
> +                       struct {
> +                               union {
> +                                       __u32   relative_fd;
> +                                       __u32   relative_id;
> +                               };
> +                               __u32           expected_revision;
> +                       } tcx;
>                 };
>         } link_create;
>

[...]

> +int tcx_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> +{
> +       struct net *net =3D current->nsproxy->net_ns;
> +       struct bpf_link_primer link_primer;
> +       struct net_device *dev;
> +       struct tcx_link *link;
> +       int fd, err;
> +
> +       dev =3D dev_get_by_index(net, attr->link_create.target_ifindex);
> +       if (!dev)
> +               return -EINVAL;
> +       link =3D kzalloc(sizeof(*link), GFP_USER);
> +       if (!link) {
> +               err =3D -ENOMEM;
> +               goto out_put;
> +       }
> +
> +       bpf_link_init(&link->link, BPF_LINK_TYPE_TCX, &tcx_link_lops, pro=
g);
> +       link->location =3D attr->link_create.attach_type;
> +       link->flags =3D attr->link_create.flags & (BPF_F_FIRST | BPF_F_LA=
ST);
> +       link->dev =3D dev;
> +
> +       err =3D bpf_link_prime(&link->link, &link_primer);
> +       if (err) {
> +               kfree(link);
> +               goto out_put;
> +       }
> +       rtnl_lock();
> +       err =3D tcx_link_prog_attach(&link->link, attr->link_create.flags=
,
> +                                  attr->link_create.tcx.relative_fd,
> +                                  attr->link_create.tcx.expected_revisio=
n);
> +       if (!err)
> +               fd =3D bpf_link_settle(&link_primer);

why this early settle? makes the error handling logic more convoluted.
Maybe leave link->dev as is and let bpf_link_cleanup() handle
dev_put(dev)? Can it be just:

err =3D tcx_link_prog_attach(...);

rtnl_unlock();

if (err) {
    link->dev =3D NULL;
    bpf_link_cleanup(&link_primer);
    goto out_put;
}

dev_put(dev);
return bpf_link_settle(&link_primer);

?

> +       rtnl_unlock();
> +       if (err) {
> +               link->dev =3D NULL;
> +               bpf_link_cleanup(&link_primer);
> +               goto out_put;
> +       }
> +       dev_put(dev);
> +       return fd;
> +out_put:
> +       dev_put(dev);
> +       return err;
> +}

[...]

