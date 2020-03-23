Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411C318FC22
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgCWRzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:55:31 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:41337 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbgCWRzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:55:31 -0400
Received: by mail-qv1-f65.google.com with SMTP id o7so5190404qvq.8;
        Mon, 23 Mar 2020 10:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JTBlzXFxtkk0Jeg7LQI5jOcijOtQkd0eDSLVZFTwqWI=;
        b=fgw1REROaklUzZkAH3prOlJi4S6iL6XIKpTBwBUBB+trAxXkJCw8XpnNDDDwWYn4kQ
         t3C5JYTMVYn9mG5pHNaKrm+6TrHO5wmTa39w/Bq+6uJyQLFxNCRVIKxNOqOpu/kuuT6m
         kvaWQTU3J19HzoWA/TBR0a6K43Immnt3I4Z3/eSKFDJs7TsrUWmr+oWFGG0Q+wEBVbDj
         J8HRlp/pn00aSUcc4JE+fhz2rA7QllUJpFuMGlwNOSw5ee1aFC/8z4HvNpskH/YClNj8
         Xy45OABk+Oa8eRoOyTaoAmqOvxE9jLBXSZ+8YoV6It4VNsfhpMg67s+Xk4xT/l2QrYf3
         +jnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JTBlzXFxtkk0Jeg7LQI5jOcijOtQkd0eDSLVZFTwqWI=;
        b=m/WzdSPSpvby7PsxOFonNNE2oA8mkhHDvH+YgRHgnEar0W1/pVnjmU7EEhuNeIxvyd
         lYEtyRw2Zxu/cy2uVOV+MYMuczqNF08KGS2x3YnNkeNm9hby45iUfjBXD5bLJNePwio3
         aXelQ3Uu91Coodl0SuerAm2k3jRjXpj9LK6xfJiECiJSdvHxRfa9CJk7kBNd6pSybgiU
         XF/OQ9h+PJdPTtme1OIaKZfDjV28qxhfNCVtlRaCS0UeKpst5kDQOVHjal5uBoSx2fvU
         RYs7feu2Ly1eBeA73cUxiJjxBNZYx41H0EpLyPpJfHTb91GD4NMpDvcqBbjPzUFZAtx/
         zYxQ==
X-Gm-Message-State: ANhLgQ1piKNFWNRkVYtgoe2olnUN+SSyjumgbYvRjAdT3YzjV/1ZaX6C
        gR3G3GV2yZpzw4f9/iMpHF0MlmfN5eyXo25EdGr/CA==
X-Google-Smtp-Source: ADFU+vsiWh26o272AugdkjUt6PCwTo004HaAJrBF9ELMcfk7SdgMwCuB6grB30KnlVCFDJxf3dFyywXWRZ6i9YyHQSI=
X-Received: by 2002:ad4:4182:: with SMTP id e2mr1658374qvp.247.1584986128771;
 Mon, 23 Mar 2020 10:55:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200320203615.1519013-1-andriin@fb.com> <20200320203615.1519013-5-andriin@fb.com>
 <87zhc749tu.fsf@toke.dk>
In-Reply-To: <87zhc749tu.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Mar 2020 10:55:17 -0700
Message-ID: <CAEf4BzbnZzwUSXMyNetHzOEjLSZS_z-NDAU0LJHH-81JRS=+rw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] bpf: implement bpf_prog replacement for an
 active bpf_cgroup_link
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > Add new operation (LINK_UPDATE), which allows to replace active bpf_pro=
g from
> > under given bpf_link. Currently this is only supported for bpf_cgroup_l=
ink,
> > but will be extended to other kinds of bpf_links in follow-up patches.
> >
> > For bpf_cgroup_link, implemented functionality matches existing semanti=
cs for
> > direct bpf_prog attachment (including BPF_F_REPLACE flag). User can eit=
her
> > unconditionally set new bpf_prog regardless of which bpf_prog is curren=
tly
> > active under given bpf_link, or, optionally, can specify expected activ=
e
> > bpf_prog. If active bpf_prog doesn't match expected one, operation is a=
 noop
> > and returns a failure.
>
> Nit: I'd consider a 'noop' to be something that succeeds, so that last
> sentence is a contradiction. Maybe "If active bpf_prog doesn't match
> expected one, the kernel will abort the operation and return a failure."?

Heh, for me "noop" (no operation) means no changes done, it doesn't
mean that syscall itself is successful. But I'll change the wording to
be less confusing.

>
> > cgroup_bpf_replace() operation is resolving race between auto-detachmen=
t and
> > bpf_prog update in the same fashion as it's done for bpf_link detachmen=
t,
> > except in this case update has no way of succeeding because of target c=
group
> > marked as dying. So in this case error is returned.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  include/linux/bpf-cgroup.h |  4 ++
> >  include/uapi/linux/bpf.h   | 12 ++++++
> >  kernel/bpf/cgroup.c        | 77 ++++++++++++++++++++++++++++++++++++++
> >  kernel/bpf/syscall.c       | 60 +++++++++++++++++++++++++++++
> >  kernel/cgroup/cgroup.c     | 21 +++++++++++
> >  5 files changed, 174 insertions(+)
> >
> > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > index ab95824a1d99..5735d8bfd69e 100644
> > --- a/include/linux/bpf-cgroup.h
> > +++ b/include/linux/bpf-cgroup.h
> > @@ -98,6 +98,8 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
> >  int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >                       struct bpf_cgroup_link *link,
> >                       enum bpf_attach_type type);
> > +int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *=
link,
> > +                      struct bpf_prog *new_prog);
> >  int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr=
,
> >                      union bpf_attr __user *uattr);
> >
> > @@ -108,6 +110,8 @@ int cgroup_bpf_attach(struct cgroup *cgrp,
> >                     u32 flags);
> >  int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >                     enum bpf_attach_type type);
> > +int cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *li=
nk,
> > +                    struct bpf_prog *old_prog, struct bpf_prog *new_pr=
og);
> >  int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> >                    union bpf_attr __user *uattr);
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index fad9f79bb8f1..fa944093f9fc 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -112,6 +112,7 @@ enum bpf_cmd {
> >       BPF_MAP_UPDATE_BATCH,
> >       BPF_MAP_DELETE_BATCH,
> >       BPF_LINK_CREATE,
> > +     BPF_LINK_UPDATE,
> >  };
>
> I feel like there's a BPF_LINK_QUERY operation missing here? Otherwise,
> how is userspace supposed to discover which program is currently
> attached to a link?

Probably, but it should return not just attached BPF program, but also
whatever target it is attached to (e.g., cgroup, ifindex, perf event
fd, etc). But we'll need to design it properly, so I didn't do
implementation yet.

>
> >  enum bpf_map_type {
> > @@ -574,6 +575,17 @@ union bpf_attr {
> >               __u32           target_fd;      /* object to attach to */
> >               __u32           attach_type;    /* attach type */
> >       } link_create;
> > +
> > +     struct { /* struct used by BPF_LINK_UPDATE command */
> > +             __u32           link_fd;        /* link fd */
> > +             /* new program fd to update link with */
> > +             __u32           new_prog_fd;
> > +             __u32           flags;          /* extra flags */
> > +             /* expected link's program fd; is specified only if
> > +              * BPF_F_REPLACE flag is set in flags */
> > +             __u32           old_prog_fd;
> > +     } link_update;
> > +
> >  } __attribute__((aligned(8)));
> >
> >  /* The description below is an attempt at providing documentation to e=
BPF
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index b960e8633f23..b9f4971336f3 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -501,6 +501,83 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       return err;
> >  }
> >
> > +/* Swap updated BPF program for given link in effective program arrays=
 across
> > + * all descendant cgroups. This function is guaranteed to succeed.
> > + */
> > +static void replace_effective_prog(struct cgroup *cgrp,
> > +                                enum bpf_attach_type type,
> > +                                struct bpf_cgroup_link *link)
> > +{
> > +     struct bpf_prog_array_item *item;
> > +     struct cgroup_subsys_state *css;
> > +     struct bpf_prog_array *progs;
> > +     struct bpf_prog_list *pl;
> > +     struct list_head *head;
> > +     struct cgroup *cg;
> > +     int pos;
> > +
> > +     css_for_each_descendant_pre(css, &cgrp->self) {
> > +             struct cgroup *desc =3D container_of(css, struct cgroup, =
self);
> > +
> > +             if (percpu_ref_is_zero(&desc->bpf.refcnt))
> > +                     continue;
> > +
> > +             /* found position of link in effective progs array */
> > +             for (pos =3D 0, cg =3D desc; cg; cg =3D cgroup_parent(cg)=
) {
> > +                     if (pos && !(cg->bpf.flags[type] & BPF_F_ALLOW_MU=
LTI))
> > +                             continue;
> > +
> > +                     head =3D &cg->bpf.progs[type];
> > +                     list_for_each_entry(pl, head, node) {
> > +                             if (!prog_list_prog(pl))
> > +                                     continue;
> > +                             if (pl->link =3D=3D link)
> > +                                     goto found;
> > +                             pos++;
> > +                     }
> > +             }
> > +found:
> > +             BUG_ON(!cg);
> > +             progs =3D rcu_dereference_protected(
> > +                             desc->bpf.effective[type],
> > +                             lockdep_is_held(&cgroup_mutex));
> > +             item =3D &progs->items[pos];
> > +             WRITE_ONCE(item->prog, link->link.prog);
> > +     }
> > +}
> > +
> > +/**
> > + * __cgroup_bpf_replace() - Replace link's program and propagate the c=
hange
> > + *                          to descendants
> > + * @cgrp: The cgroup which descendants to traverse
> > + * @link: A link for which to replace BPF program
> > + * @type: Type of attach operation
> > + *
> > + * Must be called with cgroup_mutex held.
> > + */
> > +int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *=
link,
> > +                      struct bpf_prog *new_prog)
> > +{
> > +     struct list_head *progs =3D &cgrp->bpf.progs[link->type];
> > +     struct bpf_prog *old_prog;
> > +     struct bpf_prog_list *pl;
> > +     bool found =3D false;
> > +
> > +     list_for_each_entry(pl, progs, node) {
> > +             if (pl->link =3D=3D link) {
> > +                     found =3D true;
> > +                     break;
> > +             }
> > +     }
> > +     if (!found)
> > +             return -ENOENT;
> > +
> > +     old_prog =3D xchg(&link->link.prog, new_prog);
> > +     replace_effective_prog(cgrp, link->type, link);
> > +     bpf_prog_put(old_prog);
> > +     return 0;
> > +}
> > +
> >  static struct bpf_prog_list *find_detach_entry(struct list_head *progs=
,
> >                                              struct bpf_prog *prog,
> >                                              struct bpf_cgroup_link *li=
nk,
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index f6e7d32a2632..1ff7aaa2c727 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -3572,6 +3572,63 @@ static int link_create(union bpf_attr *attr)
> >       return ret;
> >  }
> >
> > +#define BPF_LINK_UPDATE_LAST_FIELD link_update.old_prog_fd
> > +
> > +static int link_update(union bpf_attr *attr)
> > +{
> > +     struct bpf_prog *old_prog =3D NULL, *new_prog;
> > +     enum bpf_prog_type ptype;
> > +     struct bpf_link *link;
> > +     u32 flags;
> > +     int ret;
> > +
> > +     if (CHECK_ATTR(BPF_LINK_UPDATE))
> > +             return -EINVAL;
> > +
> > +     flags =3D attr->link_update.flags;
> > +     if (flags & ~BPF_F_REPLACE)
> > +             return -EINVAL;
> > +
> > +     link =3D bpf_link_get_from_fd(attr->link_update.link_fd);
> > +     if (IS_ERR(link))
> > +             return PTR_ERR(link);
> > +
> > +     new_prog =3D bpf_prog_get(attr->link_update.new_prog_fd);
> > +     if (IS_ERR(new_prog))
> > +             return PTR_ERR(new_prog);
> > +
> > +     if (flags & BPF_F_REPLACE) {
> > +             old_prog =3D bpf_prog_get(attr->link_update.old_prog_fd);
> > +             if (IS_ERR(old_prog)) {
> > +                     ret =3D PTR_ERR(old_prog);
> > +                     old_prog =3D NULL;
> > +                     goto out_put_progs;
> > +             }
> > +     }
>
> Shouldn't the default be to require an old FD and do atomic update, but
> provide a flag (BPF_F_CLOBBER?) to opt-in to unconditional replace
> behaviour? Since the unconditional replace is inherently racy I don't
> think it should be the default; in fact, I'm not sure if it should be
> allowed at all?

I don't feel strongly either way, but I expect majority of use cases
to use non-pinned bpf_link with just FD open by an application, where
application knows that no one else can update program from under link.
In which case setting new BPF program won't be racy.

>
> > +     if (link->ops =3D=3D &bpf_cgroup_link_lops) {
> > +             struct bpf_cgroup_link *cg_link;
> > +
> > +             cg_link =3D container_of(link, struct bpf_cgroup_link, li=
nk);
> > +             ptype =3D attach_type_to_prog_type(cg_link->type);
> > +             if (ptype !=3D new_prog->type) {
> > +                     ret =3D -EINVAL;
> > +                     goto out_put_progs;
> > +             }
> > +             ret =3D cgroup_bpf_replace(cg_link->cgroup, cg_link,
> > +                                      old_prog, new_prog);
> > +     } else {
> > +             ret =3D -EINVAL;
> > +     }
> > +
> > +out_put_progs:
> > +     if (old_prog)
> > +             bpf_prog_put(old_prog);
> > +     if (ret)
> > +             bpf_prog_put(new_prog);
> > +     return ret;
> > +}
> > +
> >  SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigne=
d int, size)
> >  {
> >       union bpf_attr attr =3D {};
> > @@ -3685,6 +3742,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __u=
ser *, uattr, unsigned int, siz
> >       case BPF_LINK_CREATE:
> >               err =3D link_create(&attr);
> >               break;
> > +     case BPF_LINK_UPDATE:
> > +             err =3D link_update(&attr);
> > +             break;
> >       default:
> >               err =3D -EINVAL;
> >               break;
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index 219624fba9ba..d4787fccf183 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -6317,6 +6317,27 @@ int cgroup_bpf_attach(struct cgroup *cgrp,
> >       return ret;
> >  }
> >
> > +int cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *li=
nk,
> > +                    struct bpf_prog *old_prog, struct bpf_prog *new_pr=
og)
> > +{
> > +     int ret;
> > +
> > +     mutex_lock(&cgroup_mutex);
> > +     /* link might have been auto-released by dying cgroup, so fail */
> > +     if (!link->cgroup) {
> > +             ret =3D -EINVAL;
> > +             goto out_unlock;
> > +     }
> > +     if (old_prog && link->link.prog !=3D old_prog) {
> > +             ret =3D -EPERM;
> > +             goto out_unlock;
> > +     }
> > +     ret =3D __cgroup_bpf_replace(cgrp, link, new_prog);
> > +out_unlock:
> > +     mutex_unlock(&cgroup_mutex);
> > +     return ret;
> > +}
> > +
> >  int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >                     enum bpf_attach_type type)
> >  {
> > --
> > 2.17.1
>
