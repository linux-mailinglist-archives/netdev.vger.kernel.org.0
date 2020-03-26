Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36025194DA3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgCZX7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:59:18 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36955 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCZX7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 19:59:18 -0400
Received: by mail-qt1-f195.google.com with SMTP id z24so5964566qtu.4;
        Thu, 26 Mar 2020 16:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/FxNegw9Lf/3uqsskw8CCI/KsFDuOVBj2O+3xStUuBg=;
        b=Etq9n2ym/2z81vVlA8c9hirZ2OJjbo/N+t0t8DKjX2r1sfTt44+TBXzDaGi+HVO4dj
         hRorJLm9N6qprTaVqTCcbg0Ndhbpa5GebZR1zvlq2PhsIMZPgcCQGaVgbMCyCiF/HRTk
         MPk01OpPU6oHyoI13etLJboSVTCKuF4UEIx1US9yulQrhjUjDdff8gDOukTokWEmc+QY
         Bk1l9nPFGuXxDiD3kvcZpdfhJH/hV2OvMf2NbLMIQDafYEkQytqJGc/0l1ajeKp5+UnS
         oeaf3Yz7SyBAINQru6PTKpXclUg8Ds4ODzADo3mvJAYYEqTJEUT9qeIpc5c2NEFMgsg3
         /6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/FxNegw9Lf/3uqsskw8CCI/KsFDuOVBj2O+3xStUuBg=;
        b=B3H+3uho9rIhmIkL3rwCXCFyEowqMTVCkLd/+rDrzm/49/wdbCyIMAng9ItGB2oA5Q
         zzyLGxFqkDbK44Bz8MLdoola7jAAd+sXBb93CiSX63fHV6O2ZyHUwF1J24Nus3n8DTrZ
         tLatBOYgufBxy568sinuMuV5p1FxQ1rjJmb6XtxE9AcSBhEC2SiN0mgb7VfHuZC/WoyC
         WsSWx5DPXMaw+EGLM4FT8qypgafoEvlgSW74NI2Rjnsn4v7WNfUaOkHBsFcZ2mI8WJMz
         jp7zxC8B268myHeqVfHzg26Ebx8b0tRXUjgJgB2cn1K4VMK0liTU7jgMxt2CSDMW9gKe
         XvTw==
X-Gm-Message-State: ANhLgQ22yC6tOJEMj41XfJdP+KCvJ3zpvYfH9+QDwOs7abW6J+MoM8eb
        83j5zF9S3XFY3kyrDwWirf2j6BkzPLS8kJcvUl224Tkg6cE=
X-Google-Smtp-Source: ADFU+vvXo+zccjPxl/uTN3q3NlGHLJmIUjGqnYO4Dk9R3BqoMcdWF5tlhlfqrStG/u4ar4w7wAnUrmhcIKckchabmcE=
X-Received: by 2002:ac8:6f1b:: with SMTP id g27mr11408473qtv.117.1585267157161;
 Thu, 26 Mar 2020 16:59:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200325065746.640559-1-andriin@fb.com> <20200325065746.640559-5-andriin@fb.com>
 <20200326233533.gbyogvi57xufe34d@ast-mbp>
In-Reply-To: <20200326233533.gbyogvi57xufe34d@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 26 Mar 2020 16:59:06 -0700
Message-ID: <CAEf4BzYQnzUAFo-Jmikg3va2d8tZ+ZL1x2QSf6NdrY629hKc2g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/6] bpf: implement bpf_prog replacement for
 an active bpf_cgroup_link
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 4:35 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Mar 24, 2020 at 11:57:44PM -0700, Andrii Nakryiko wrote:
> >
> > +/* Swap updated BPF program for given link in effective program arrays across
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
> > +             struct cgroup *desc = container_of(css, struct cgroup, self);
> > +
> > +             if (percpu_ref_is_zero(&desc->bpf.refcnt))
> > +                     continue;
> > +
> > +             /* found position of link in effective progs array */
> > +             for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
> > +                     if (pos && !(cg->bpf.flags[type] & BPF_F_ALLOW_MULTI))
> > +                             continue;
> > +
> > +                     head = &cg->bpf.progs[type];
> > +                     list_for_each_entry(pl, head, node) {
> > +                             if (!prog_list_prog(pl))
> > +                                     continue;
> > +                             if (pl->link == link)
> > +                                     goto found;
> > +                             pos++;
> > +                     }
> > +             }
> > +found:
> > +             BUG_ON(!cg);
> > +             progs = rcu_dereference_protected(
> > +                             desc->bpf.effective[type],
> > +                             lockdep_is_held(&cgroup_mutex));
> > +             item = &progs->items[pos];
> > +             WRITE_ONCE(item->prog, link->link.prog);
> > +     }
> > +}
> > +
> > +/**
> > + * __cgroup_bpf_replace() - Replace link's program and propagate the change
> > + *                          to descendants
> > + * @cgrp: The cgroup which descendants to traverse
> > + * @link: A link for which to replace BPF program
> > + * @type: Type of attach operation
> > + *
> > + * Must be called with cgroup_mutex held.
> > + */
> > +int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
> > +                      struct bpf_prog *new_prog)
> > +{
> > +     struct list_head *progs = &cgrp->bpf.progs[link->type];
> > +     struct bpf_prog *old_prog;
> > +     struct bpf_prog_list *pl;
> > +     bool found = false;
> > +
> > +     if (link->link.prog->type != new_prog->type)
> > +             return -EINVAL;
> > +
> > +     list_for_each_entry(pl, progs, node) {
> > +             if (pl->link == link) {
> > +                     found = true;
> > +                     break;
> > +             }
> > +     }
> > +     if (!found)
> > +             return -ENOENT;
> > +
> > +     old_prog = xchg(&link->link.prog, new_prog);
> > +     replace_effective_prog(cgrp, link->type, link);
>
> I think with 'found = true' in this function you're assuming that it will be
> found in replace_effective_prog() ? I don't think that's the case.
> Try to create bpf_link with BPF_F_ALLOW_OVERRIDE, override it in a child cgroup
> with another link and then try to LINK_UPDATE the former. The link is there,
> but the prog is not executing and it's not in effective array. What LINK_UPDATE
> suppose to do? I guess it should succeed?

Yes, this is a great catch! I should have used ALLOW_OVERRIDE at the
root cgroup level in my selftest, it would catch it immediately.

BUG_ON(!cg) in replace_effective_prog() is too aggressive, if I
replace it with `if (!cg) continue;` it will handle this as well.

> Even trickier that the prog will be in effective array in some of
> css_for_each_descendant_pre() and not in others. This cgroup attach semantics
> were convoluted from the day one. Apparently people use all three variants now,
> but I wouldn't bet that everyone understands it.

Agree about convoluted logic, spent enormous time understanding and
modifying it :)

But apart from BUG_ON(!cg) problem, everything works because each
level of hierarchy is treated independently in
replace_effective_prog(). Search for attached link on each level is
reset and performed anew. If found - we replace program, if not - must
be ALLOW_OVERRIDE case, i.e., actually overridden link.

> Hence my proposal to support F_ALLOW_MULTI for links only. At least initially.
> It's so much simpler to explain. And owning bpf_link will guarantee that the
> prog is executing (unless cgroup is removed and sockets are closed). I guess
> default (no-override) is acceptable to bpf_link as well and in that sense it
> will be very similar to XDP with single prog attached. So I think I can live
> with default and ALLOW_MULTI for now. But we should probably redesign
> overriding capabilities. Folks need to attach multiple progs to a given cgroup
> and disallow all progs in children. Currently it's not possible to do, since
> MULTI in the parent allows at least one (default, override or multi) in the
> children. bpf_link inheriting this logic won't help to solve this use case. It
> feels that link should stay as multi only and override or not in the children
> should be a separate property. Probably not related to link at all. It fits
> better as a cgroup permission.

Yeah, we had a brief discussion with Andrey on mailing list. Not sure
what the solution looks like, but it should be orthogonal to link/prog
attachment operation, probably.

If you insist and Andrey is ok with dropping ALLOW_OVERRIDE, it's
easy. But fixing the logic to handle it is also easy. So are we sure
about supporting 2 out of 3 existing modes? :)

>
> Anyhow I'm going to apply patches 1 and 2, since they are good cleanup
> regardless of what we decide here.

Thanks, will rebase on top of bpf-next master for v3.
