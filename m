Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7167218DC70
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 01:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgCUATj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 20:19:39 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43641 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCUATj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 20:19:39 -0400
Received: by mail-qt1-f195.google.com with SMTP id l13so6656915qtv.10;
        Fri, 20 Mar 2020 17:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=duRYrXqp9YFeS3Z6CDGDRT4AK9wQKZlIyHr/BiJ6UfQ=;
        b=FpB+FKGkVt8ubutfhkdmtlFnkVGis2J+wUZXTz6EFmWEdS23n6Xgz9t60/VUPalLP6
         Bjkm4bdG9Db7CodbF24gnuS1pNQDst411/m3XdTGbYdhvzM/vqHUFGqbNP84aNS0MKXR
         qVygrtdR5aOfIgTyVRSNqW8PKYXtZF3sstVRtl7K0cShpsJYuZOz3uRhq+SLt69urMr3
         T7eZ1eaZu0UhXPjiELyQ3ixrIraLVPgOnik92VSJ6bpB5Moenq63p+P5+SYrsay3LMTR
         U5Wi74KTB0gcBjDqouBHBwxjFuGkbj64LyXoChdrT8enq+HZxfjqrIE60QoE2DkT3s9W
         w5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=duRYrXqp9YFeS3Z6CDGDRT4AK9wQKZlIyHr/BiJ6UfQ=;
        b=jf6/1aKOPPmmNT02ZKiNZhO5Sb4b2DiG1kvqH7F2lKDwaUKc+wYuUyBVq3Yg0QKwv+
         Omu87BrNQ7TjPDWoOrIqJp2ZoBATX7Za2wZi017hrCxVBqyD/GrB+1w7Hl32yvXF9Bo5
         xuttm5ZeO9Oqv4PCAeLbA5rTKs2G60EMpCu7B8xO1QR13A1aNfMMW0GVeNl8SDQ2Wzph
         NJvnJWNl/3VI3eWtlHeehUkCmHQ2My5pLjNN4yqKT3PjWukkYFEu6VDUntVrYG6p9Crg
         vfoYVaz8Uxnva1UQXz3+sC5f2rLAfqXkxiVxh93WmigVRC66ci8Tzh15fakyB3OjG+5F
         3MMw==
X-Gm-Message-State: ANhLgQ2HlHZTp3Ph7kFowe+IHZLymjYC5HRc2thKWZZEPcong8bTLNWF
        ItytKEJ0Di7tjTSc2LNHEtKDNh/qrQfEGIUJi3M=
X-Google-Smtp-Source: ADFU+vuUzS21vVEMjDoa5ZW+dPbD973PsYoY8m/RCC3OcTAFkMtiZuw0EP3SHXfeqDdJVmwnNovYqJxhSx3+TJjwpkQ=
X-Received: by 2002:ac8:3f62:: with SMTP id w31mr10852936qtk.171.1584749978200;
 Fri, 20 Mar 2020 17:19:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200320203615.1519013-1-andriin@fb.com> <20200320203615.1519013-4-andriin@fb.com>
 <20200320234628.GA11775@rdna-mbp>
In-Reply-To: <20200320234628.GA11775@rdna-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Mar 2020 17:19:26 -0700
Message-ID: <CAEf4BzYdOUrkAw34qRWjvngSDd4NRiQuvWb2Ka0u7LHJvTMERg@mail.gmail.com>
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

On Fri, Mar 20, 2020 at 4:46 PM Andrey Ignatov <rdna@fb.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> [Fri, 2020-03-20 13:37 -0700]:
> > Implement new sub-command to attach cgroup BPF programs and return FD-based
> > bpf_link back on success. bpf_link, once attached to cgroup, cannot be
> > replaced, except by owner having its FD. cgroup bpf_link has semantics of
> > BPF_F_ALLOW_MULTI BPF program attachments and can co-exist with
>
> Hi Andrii,
>
> Is there any reason to limit it to only BPF_F_ALLOW_MULTI?
>

No technical reason, just felt like the good default behavior. It's
possible to support all the same flags as with legacy BPF program
attachment, but see below...

> The thing is BPF_F_ALLOW_MULTI not only allows to attach multiple
> programs to specified cgroup but also controls what programs can later
> be attached to a sub-cgroup, and in BPF_F_ALLOW_MULTI case both
> sub-cgroup programs and specified cgroup programs will be executed (in
> this order).
>
> There many use-cases though when it's desired to either completely
> disallow attaching programs to a sub-cgroup or override parent cgroup's
> program behavior in sub-cgroup. If bpf_link covers only
> BPF_F_ALLOW_MULTI, those scenarios won't be able to leverage it.
>
> This double-purpose of BPF_F_ALLOW_MULTI is a pain ... For example if

Yeah, exactly. I don't know historical reasons for why it was done the
way it was done (i.e., BPF_F_ALLOW_MULTI and BPF_F_ALLOW_OVERRIDE
flags), so maybe someone can give some insights there. But I wonder if
inheritance policy should be orthogonal to a single vs multiple
bpf_progs limit for a given cgroup. They could be specified on
per-cgroup level, not per-BPF program (and then making sure flags
match). That way it would be possible to express more nuanced
policies, like allowing multiple programs for a root cgroup, but
disallowing attach new BPF programs for any child cgroup, etc.

Would be good to get some more perspectives on this...

> one wants to attach multiple programs to a cgroup but disallow attaching
> programs to a sub-cgroup it's currently impossible (well, w/o additional
> cgroup level just for this).
>
> > non-bpf_link-based BPF cgroup attachments.
> >
> > To prevent bpf_cgroup_link from keeping cgroup alive past the point when no
> > BPF program can be executed, implement auto-detachment of link. When
> > cgroup_bpf_release() is called, all attached bpf_links are forced to release
> > cgroup refcounts, but they leave bpf_link otherwise active and allocated, as
> > well as still owning underlying bpf_prog. This is because user-space might
> > still have FDs open and active, so bpf_link as a user-referenced object can't
> > be freed yet. Once last active FD is closed, bpf_link will be freed and
> > underlying bpf_prog refcount will be dropped. But cgroup refcount won't be
> > touched, because cgroup is released already.
> >
> > The inherent race between bpf_cgroup_link release (from closing last FD) and
> > cgroup_bpf_release() is resolved by both operations taking cgroup_mutex. So
> > the only additional check required is when bpf_cgroup_link attempts to detach
> > itself from cgroup. At that time we need to check whether there is still
> > cgroup associated with that link. And if not, exit with success, because
> > bpf_cgroup_link was already successfully detached.
> >
> > Acked-by: Roman Gushchin <guro@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  include/linux/bpf-cgroup.h     |  27 ++-
> >  include/linux/bpf.h            |  10 +-
> >  include/uapi/linux/bpf.h       |   9 +-
> >  kernel/bpf/cgroup.c            | 313 +++++++++++++++++++++++++--------
> >  kernel/bpf/syscall.c           |  62 +++++--
> >  kernel/cgroup/cgroup.c         |  14 +-
> >  tools/include/uapi/linux/bpf.h |   9 +-
> >  7 files changed, 345 insertions(+), 99 deletions(-)
> >

[...]
