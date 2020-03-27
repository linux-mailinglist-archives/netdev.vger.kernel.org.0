Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6029D194E19
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgC0Aem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:34:42 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39701 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgC0Ael (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 20:34:41 -0400
Received: by mail-pj1-f66.google.com with SMTP id z3so2588498pjr.4;
        Thu, 26 Mar 2020 17:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xwkPmQC4HgCx6riR2jS83Jj8xzneWDB0j1Asv8UfxWc=;
        b=igdtv33zTxSZhTQZhvRszE8ccCFlPisEeMWSrZ7sx/Fmr2QVibzawBlcolNFvzJnv7
         ssUCqdxwjSv0EGqnaMxRBSxl0DO+K6oPSDDAkSSCvsLrkMbQJhbqO1CtSOsYH2nQG0Vm
         P8kynJb4DNqSikysLegQLEOmdUVux2Tr9eYg7BMWGmxTWotErfgrXtmiG8MnpkK9KCXL
         5bW3fGaDnE/1XYflk1ONz5PrsOpyLaFVv65ANTz+1VIOP2Z8B3Vg20rTZDMmXKQ4S9qN
         5JCnW5faa7Pn8EbsQtSyl1/58f4nKUI/ZrfrkGSqDIk7sAucBv4U6VNCf4/4uHWVUWxV
         YJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xwkPmQC4HgCx6riR2jS83Jj8xzneWDB0j1Asv8UfxWc=;
        b=FqTmcMR2zHG0e/AlZoJ0ZDF6rcI2rDoxydp6LFrcAWVEgj1qoISxT7cgcY1LI19TXs
         0NdDGGKrsSk5+mqDLR0EWJF94ETs9uUAYdP9k+wQdigUu/iIzPy25+d6z0Lq9dHOws4J
         3btzk7gB/Ah06esGhJx0syxfLZSuVXUbZRigiFQTrA7kECcPqTAEFFlQjpqCCY7lWGwP
         uJ6MkAlZteAFrbHa1ApIRUqlt37cS56KwXc1GHV38TI4bBdZaWc1PSJZmjY6CjwBJKBS
         ntqj/VB3UoNKrDLeVC0ah+eyh36fHlbCg6kMrDNs3rEFoPkUgUa7m1yDmkfUuFJ3GMHD
         M1KQ==
X-Gm-Message-State: ANhLgQ0frPPOaupBjAnhkhIIJKs0EGfjmVnyTbDF1Favo6KaHL8HNOp1
        yrVNLFBAZXxpzbsCDmNcYGw=
X-Google-Smtp-Source: ADFU+vtczz5D/NODdxrJ7DnaIpJvoTSwfAYo82FrzijKxPkua/a+1/uWX3OQEc/n6DNq2G3gMUj6Qw==
X-Received: by 2002:a17:90a:1f07:: with SMTP id u7mr3068851pja.24.1585269278145;
        Thu, 26 Mar 2020 17:34:38 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c7d9])
        by smtp.gmail.com with ESMTPSA id u18sm2673387pfl.40.2020.03.26.17.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 17:34:37 -0700 (PDT)
Date:   Thu, 26 Mar 2020 17:34:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 4/6] bpf: implement bpf_prog replacement for
 an active bpf_cgroup_link
Message-ID: <20200327003433.btzx5tbpov4dptji@ast-mbp>
References: <20200325065746.640559-1-andriin@fb.com>
 <20200325065746.640559-5-andriin@fb.com>
 <20200326233533.gbyogvi57xufe34d@ast-mbp>
 <CAEf4BzYQnzUAFo-Jmikg3va2d8tZ+ZL1x2QSf6NdrY629hKc2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYQnzUAFo-Jmikg3va2d8tZ+ZL1x2QSf6NdrY629hKc2g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 04:59:06PM -0700, Andrii Nakryiko wrote:
> On Thu, Mar 26, 2020 at 4:35 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Mar 24, 2020 at 11:57:44PM -0700, Andrii Nakryiko wrote:
> > >
> > > +/* Swap updated BPF program for given link in effective program arrays across
> > > + * all descendant cgroups. This function is guaranteed to succeed.
> > > + */
> > > +static void replace_effective_prog(struct cgroup *cgrp,
> > > +                                enum bpf_attach_type type,
> > > +                                struct bpf_cgroup_link *link)
> > > +{
> > > +     struct bpf_prog_array_item *item;
> > > +     struct cgroup_subsys_state *css;
> > > +     struct bpf_prog_array *progs;
> > > +     struct bpf_prog_list *pl;
> > > +     struct list_head *head;
> > > +     struct cgroup *cg;
> > > +     int pos;
> > > +
> > > +     css_for_each_descendant_pre(css, &cgrp->self) {
> > > +             struct cgroup *desc = container_of(css, struct cgroup, self);
> > > +
> > > +             if (percpu_ref_is_zero(&desc->bpf.refcnt))
> > > +                     continue;
> > > +
> > > +             /* found position of link in effective progs array */
> > > +             for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
> > > +                     if (pos && !(cg->bpf.flags[type] & BPF_F_ALLOW_MULTI))
> > > +                             continue;
> > > +
> > > +                     head = &cg->bpf.progs[type];
> > > +                     list_for_each_entry(pl, head, node) {
> > > +                             if (!prog_list_prog(pl))
> > > +                                     continue;
> > > +                             if (pl->link == link)
> > > +                                     goto found;
> > > +                             pos++;
> > > +                     }
> > > +             }
> > > +found:
> > > +             BUG_ON(!cg);
> > > +             progs = rcu_dereference_protected(
> > > +                             desc->bpf.effective[type],
> > > +                             lockdep_is_held(&cgroup_mutex));
> > > +             item = &progs->items[pos];
> > > +             WRITE_ONCE(item->prog, link->link.prog);
> > > +     }
> > > +}
> > > +
> > > +/**
> > > + * __cgroup_bpf_replace() - Replace link's program and propagate the change
> > > + *                          to descendants
> > > + * @cgrp: The cgroup which descendants to traverse
> > > + * @link: A link for which to replace BPF program
> > > + * @type: Type of attach operation
> > > + *
> > > + * Must be called with cgroup_mutex held.
> > > + */
> > > +int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
> > > +                      struct bpf_prog *new_prog)
> > > +{
> > > +     struct list_head *progs = &cgrp->bpf.progs[link->type];
> > > +     struct bpf_prog *old_prog;
> > > +     struct bpf_prog_list *pl;
> > > +     bool found = false;
> > > +
> > > +     if (link->link.prog->type != new_prog->type)
> > > +             return -EINVAL;
> > > +
> > > +     list_for_each_entry(pl, progs, node) {
> > > +             if (pl->link == link) {
> > > +                     found = true;
> > > +                     break;
> > > +             }
> > > +     }
> > > +     if (!found)
> > > +             return -ENOENT;
> > > +
> > > +     old_prog = xchg(&link->link.prog, new_prog);
> > > +     replace_effective_prog(cgrp, link->type, link);
> >
> > I think with 'found = true' in this function you're assuming that it will be
> > found in replace_effective_prog() ? I don't think that's the case.
> > Try to create bpf_link with BPF_F_ALLOW_OVERRIDE, override it in a child cgroup
> > with another link and then try to LINK_UPDATE the former. The link is there,
> > but the prog is not executing and it's not in effective array. What LINK_UPDATE
> > suppose to do? I guess it should succeed?
> 
> Yes, this is a great catch! I should have used ALLOW_OVERRIDE at the
> root cgroup level in my selftest, it would catch it immediately.
> 
> BUG_ON(!cg) in replace_effective_prog() is too aggressive, if I
> replace it with `if (!cg) continue;` it will handle this as well.
> 
> > Even trickier that the prog will be in effective array in some of
> > css_for_each_descendant_pre() and not in others. This cgroup attach semantics
> > were convoluted from the day one. Apparently people use all three variants now,
> > but I wouldn't bet that everyone understands it.
> 
> Agree about convoluted logic, spent enormous time understanding and
> modifying it :)
> 
> But apart from BUG_ON(!cg) problem, everything works because each
> level of hierarchy is treated independently in
> replace_effective_prog(). Search for attached link on each level is
> reset and performed anew. If found - we replace program, if not - must
> be ALLOW_OVERRIDE case, i.e., actually overridden link.
> 
> > Hence my proposal to support F_ALLOW_MULTI for links only. At least initially.
> > It's so much simpler to explain. And owning bpf_link will guarantee that the
> > prog is executing (unless cgroup is removed and sockets are closed). I guess
> > default (no-override) is acceptable to bpf_link as well and in that sense it
> > will be very similar to XDP with single prog attached. So I think I can live
> > with default and ALLOW_MULTI for now. But we should probably redesign
> > overriding capabilities. Folks need to attach multiple progs to a given cgroup
> > and disallow all progs in children. Currently it's not possible to do, since
> > MULTI in the parent allows at least one (default, override or multi) in the
> > children. bpf_link inheriting this logic won't help to solve this use case. It
> > feels that link should stay as multi only and override or not in the children
> > should be a separate property. Probably not related to link at all. It fits
> > better as a cgroup permission.
> 
> Yeah, we had a brief discussion with Andrey on mailing list. Not sure
> what the solution looks like, but it should be orthogonal to link/prog
> attachment operation, probably.
> 
> If you insist and Andrey is ok with dropping ALLOW_OVERRIDE, it's
> easy. But fixing the logic to handle it is also easy. So are we sure
> about supporting 2 out of 3 existing modes? :)

I wasn't clear enough. My preference is only multi for bpf_link with a concrete
plan how cgroup permissions can do no-override, selective override, and
whatever else container folks need.
I can imagine somebody may want to attach bind/connect at outer container level
and disallow this specific attach_type for children while allowing other
cgroup-bpf prog types in inner containers. There is no way to do so now and
flags for bpf_link is not the answer either.

> Thanks, will rebase on top of bpf-next master for v3.

please wait with repost until this discussion settles.
