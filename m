Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD7518FC3C
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgCWSDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:03:45 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44304 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgCWSDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:03:45 -0400
Received: by mail-qt1-f193.google.com with SMTP id x16so3368015qts.11;
        Mon, 23 Mar 2020 11:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fHu91a/Lr8MUsZOsiLVkd/C4HW7N74BB6IqSYZpx+Aw=;
        b=SI8rcU1tgyYpjNp2i9swb7M3rMAZWoxtSwefg0dcmHWQe0eCaJuQQxI7G9JKFM4TWU
         hCdSnlDhRWXtyEZKAQfjsRqTkmZTvHvlOjN7++m+9lVWgYsIk++omJmFXjKF1tXafld1
         Uhmpz5mnhRiCOzqjLqxkH0MNsgZ2svplNPiQKIgD+zk71/DZyTc2KFzQp9tSUHrhjp4T
         Rwl/1p1ptdRx4n0ZMpme+UzUq202fDwAdRObFkSMJkJWBowe6jxpAanF+Lo3Oam8QSzI
         sMgYwQgug66UfrQ9n+nOy5I5jfYcXc6U7MidCZBL7Z5kF4qXkz9k8SrMkdCnAYUXYnRP
         MnXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fHu91a/Lr8MUsZOsiLVkd/C4HW7N74BB6IqSYZpx+Aw=;
        b=nCGS0VSUZASIPYziIyWVbL45F/Rzqsnye4ZW9LfuLfcR/MelhiJFkJdE8rubtOVN3C
         GQDDALlYM57pgFx1CBw1XIKYU8BjF1i9vfWCNaKvg4YYoFTDRkd42lG/nSBD5UWT25BL
         ih7UX/7eYRRKlVYZFewte5/tO5zTFfAwdUvme8pge/EmaQaB6qt5u9kJvp9f0QRKbjjm
         LzfC9iiiBnXT9mgNHV4wnf2Y3LyJCS2koL1G2qfnq30IPlDqC2YM1Ao10i9N+C+921aq
         rukxTjoOiI2KeQ6lPFYF4R1U5m6fR7c7OuDSSuy0RG7oLEDwwgoCYs+R/u0ksnbIQORB
         tzAg==
X-Gm-Message-State: ANhLgQ2m2OX7Tg/PM4xfWZac7oYQqK45GUbBSrzI9vOtNoq32MRRdYp2
        LFRuSfIwc42pwfP7XtRBd3eRQRcy+sH/EopEOAk=
X-Google-Smtp-Source: ADFU+vtopggPFvOeNPrm7x8MhbmifH1bk+B6z5gdKcLmrow6Orzae/CM2RKt8qrPTdbaAMmWF9MqV5zIT7frDOiCcqc=
X-Received: by 2002:ac8:7cb0:: with SMTP id z16mr6236000qtv.59.1584986621700;
 Mon, 23 Mar 2020 11:03:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200320203615.1519013-1-andriin@fb.com> <20200320203615.1519013-4-andriin@fb.com>
 <20200320234628.GA11775@rdna-mbp> <CAEf4BzYdOUrkAw34qRWjvngSDd4NRiQuvWb2Ka0u7LHJvTMERg@mail.gmail.com>
In-Reply-To: <CAEf4BzYdOUrkAw34qRWjvngSDd4NRiQuvWb2Ka0u7LHJvTMERg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Mar 2020 11:03:30 -0700
Message-ID: <CAEf4BzY_OsQ_+0Pg+mz2tPvRDayTOGUOU_ff5+Ui-YCpwDNwHQ@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 3/6] bpf: implement
 bpf_link-based cgroup BPF program attachment
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 5:19 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Mar 20, 2020 at 4:46 PM Andrey Ignatov <rdna@fb.com> wrote:
> >
> > Andrii Nakryiko <andriin@fb.com> [Fri, 2020-03-20 13:37 -0700]:
> > > Implement new sub-command to attach cgroup BPF programs and return FD-based
> > > bpf_link back on success. bpf_link, once attached to cgroup, cannot be
> > > replaced, except by owner having its FD. cgroup bpf_link has semantics of
> > > BPF_F_ALLOW_MULTI BPF program attachments and can co-exist with
> >
> > Hi Andrii,
> >
> > Is there any reason to limit it to only BPF_F_ALLOW_MULTI?
> >
>
> No technical reason, just felt like the good default behavior. It's
> possible to support all the same flags as with legacy BPF program
> attachment, but see below...

So I went ahead and just added support for all the modes, it's very
minor change in kernel itself, but needs a lot more selftesting logic,
given all the new modes. Once I finish with that, I'll post v2 that
also fixes build with !CONFIG_CGROUP_BPF. We can continue discussing
orthogonal inheritance policies independently, if there is any
intereset.

>
> > The thing is BPF_F_ALLOW_MULTI not only allows to attach multiple
> > programs to specified cgroup but also controls what programs can later
> > be attached to a sub-cgroup, and in BPF_F_ALLOW_MULTI case both
> > sub-cgroup programs and specified cgroup programs will be executed (in
> > this order).
> >
> > There many use-cases though when it's desired to either completely
> > disallow attaching programs to a sub-cgroup or override parent cgroup's
> > program behavior in sub-cgroup. If bpf_link covers only
> > BPF_F_ALLOW_MULTI, those scenarios won't be able to leverage it.
> >
> > This double-purpose of BPF_F_ALLOW_MULTI is a pain ... For example if
>
> Yeah, exactly. I don't know historical reasons for why it was done the
> way it was done (i.e., BPF_F_ALLOW_MULTI and BPF_F_ALLOW_OVERRIDE
> flags), so maybe someone can give some insights there. But I wonder if
> inheritance policy should be orthogonal to a single vs multiple
> bpf_progs limit for a given cgroup. They could be specified on
> per-cgroup level, not per-BPF program (and then making sure flags
> match). That way it would be possible to express more nuanced
> policies, like allowing multiple programs for a root cgroup, but
> disallowing attach new BPF programs for any child cgroup, etc.
>
> Would be good to get some more perspectives on this...
>
> > one wants to attach multiple programs to a cgroup but disallow attaching
> > programs to a sub-cgroup it's currently impossible (well, w/o additional
> > cgroup level just for this).
> >
> > > non-bpf_link-based BPF cgroup attachments.
> > >
> > > To prevent bpf_cgroup_link from keeping cgroup alive past the point when no
> > > BPF program can be executed, implement auto-detachment of link. When
> > > cgroup_bpf_release() is called, all attached bpf_links are forced to release
> > > cgroup refcounts, but they leave bpf_link otherwise active and allocated, as
> > > well as still owning underlying bpf_prog. This is because user-space might
> > > still have FDs open and active, so bpf_link as a user-referenced object can't
> > > be freed yet. Once last active FD is closed, bpf_link will be freed and
> > > underlying bpf_prog refcount will be dropped. But cgroup refcount won't be
> > > touched, because cgroup is released already.
> > >
> > > The inherent race between bpf_cgroup_link release (from closing last FD) and
> > > cgroup_bpf_release() is resolved by both operations taking cgroup_mutex. So
> > > the only additional check required is when bpf_cgroup_link attempts to detach
> > > itself from cgroup. At that time we need to check whether there is still
> > > cgroup associated with that link. And if not, exit with success, because
> > > bpf_cgroup_link was already successfully detached.
> > >
> > > Acked-by: Roman Gushchin <guro@fb.com>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  include/linux/bpf-cgroup.h     |  27 ++-
> > >  include/linux/bpf.h            |  10 +-
> > >  include/uapi/linux/bpf.h       |   9 +-
> > >  kernel/bpf/cgroup.c            | 313 +++++++++++++++++++++++++--------
> > >  kernel/bpf/syscall.c           |  62 +++++--
> > >  kernel/cgroup/cgroup.c         |  14 +-
> > >  tools/include/uapi/linux/bpf.h |   9 +-
> > >  7 files changed, 345 insertions(+), 99 deletions(-)
> > >
>
> [...]
