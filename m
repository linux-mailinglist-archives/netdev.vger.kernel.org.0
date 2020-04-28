Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBFF1BD094
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 01:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgD1XZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 19:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725853AbgD1XZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 19:25:51 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485A1C03C1AC;
        Tue, 28 Apr 2020 16:25:51 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s63so216057qke.4;
        Tue, 28 Apr 2020 16:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jzqQ45GPfLlr0LPdsX7PHnG+9t1z2XimOYXDT4E6YWk=;
        b=lvUf4i/ljRLRqTK/zz9Fumz77YHCxcx9VKIUw1bkneeRWD5s5k/j4gbd8p9OXH6RsV
         t+dbn2TEYYgkjA/DAqJM2EpWlGmB3SwVlcCTxWI5j66tihL4p321HeZ2akjK5/M/Yw0k
         CUbIqXFDXWgw5Ho+Kb+1aUCwtHgihn2fQUVaMoOrdocGy7nLpagOCVMYckJGav+g5VVs
         dYEwkeYS4YYaYJPiCpElxwCx4Kr30HtIiHweysilloMvAXNrbE1yaNQGXRZBFCuEREBg
         gREESraaEcJ/55/NSH6kzN6Oz38ZKJuTSg0CE0nPYTqtNqy0p97oUlUo0k0XEf/pI/sS
         bP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jzqQ45GPfLlr0LPdsX7PHnG+9t1z2XimOYXDT4E6YWk=;
        b=aUvXl3+Aga/db48xPRqgCqwXAZIK/8KDbMawF67ZFzzdZqJms62cVKyyNxhhaA2Vgc
         cbCLXFc5me7ProW8dltXPbTU3nzG7wNCkUi2bPEaBG+DI7vRm8jKr6a1puY3Xcq3160w
         7ONOrdbyEO24YoOGOgK62JU2wVZXJF+i85+CHFTq0lXu0/0AyjRtDs2LcwLyTw/rWMxQ
         igVs6+ugo3T9167Fb3Fqnw00i+OUlc7m9PUjklggBM7ICldL0PRFVKZxLR0MGc+ay1z/
         0LuTH3z7jediZuYFPRXhGx6Jsi2TmNz+EQ8J67UkCQSuWy9S+1dJCUNkuWMIlUNioSg6
         uvdw==
X-Gm-Message-State: AGi0PuYaZLIB3dFNJGeWpxqIdD//QFaev76fY33ElMXi7d+MLP1hHHCY
        r9NTcoH/NtvHsCnFR3tEKzzXk5/njfXs6BoxM/Y=
X-Google-Smtp-Source: APiQypLb8H4/b6p0A4xjxkPiY7TuP0/ZSRTNh6nxTU8NrRoobCkOxoZC1LDeoAurENLkPNyyNVNX/Cb1uQr69J5cBso=
X-Received: by 2002:ae9:e10b:: with SMTP id g11mr32191537qkm.449.1588116350264;
 Tue, 28 Apr 2020 16:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200428054944.4015462-1-andriin@fb.com> <20200428054944.4015462-3-andriin@fb.com>
 <20200428173120.lof25gzz75bx5ot7@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bza-gqQHz3_9RyX7pKo_2kYeh7cCmNRAxExx48JQdOpfDQ@mail.gmail.com>
 <20200428203843.pe7d4zbki2ihnq2m@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZ4q5ngbF9YQSrCSyXv3UkQL5YWRnuOAuKs4b7nBkYZpg@mail.gmail.com> <20200428224309.pod67otmp77mcspp@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200428224309.pod67otmp77mcspp@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 16:25:39 -0700
Message-ID: <CAEf4BzbF1C81J1UkmqkuX5VuGZRo7cwwJcCaZRCPFqC0MEfA8A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 02/10] bpf: allocate ID for bpf_link
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Tue, Apr 28, 2020 at 3:43 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Apr 28, 2020 at 03:33:07PM -0700, Andrii Nakryiko wrote:
> > On Tue, Apr 28, 2020 at 1:38 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Apr 28, 2020 at 11:56:52AM -0700, Andrii Nakryiko wrote:
> > > > On Tue, Apr 28, 2020 at 10:31 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Mon, Apr 27, 2020 at 10:49:36PM -0700, Andrii Nakryiko wrote:
> > > > > > +int bpf_link_settle(struct bpf_link_primer *primer)
> > > > > > +{
> > > > > > +     /* make bpf_link fetchable by ID */
> > > > > > +     WRITE_ONCE(primer->link->id, primer->id);
> > > > >
> > > > > what does WRITE_ONCE serve here?
> > > >
> > > > To prevent compiler reordering this write with fd_install. So that by
> > > > the time FD is exposed to user-space, link has properly set ID.
> > >
> > > if you wanted memory barrier then it should have been barrier(),
> > > but that wouldn't be enough, since patch 2 and 3 race to read and write
> > > that 32-bit int.
> > >
> > > > > bpf_link_settle can only be called at the end of attach.
> > > > > If attach is slow than parallel get_fd_by_id can get an new FD
> > > > > instance for link with zero id.
> > > > > In such case deref of link->id will race with above assignment?
> > > >
> > > > Yes, it does race, but it can either see zero and assume bpf_link is
> > > > not ready (which is fine to do) or will see correct link ID and will
> > > > proceed to create new FD for it. By the time we do context switch back
> > > > to user-space and return link FD, ID will definitely be visible due to
> > > > context switch and associated memory barriers. If anyone is guessing
> > > > FD and trying to create FD_BY_ID before LINK_CREATE syscall returns --
> > > > then returning failure due to link ID not yet set is totally fine,
> > > > IMO.
> > > >
> > > > > But I don't see READ_ONCE in patch 3.
> > > > > It's under link_idr_lock there.
> > > >
> > > > It doesn't need READ_ONCE because it does read under spinlock, so
> > > > compiler can't re-order it with code outside of spinlock.
> > >
> > > spin_lock in patch 3 doesn't guarantee that link->id deref in that patch
> > > will be atomic.
> >
> > What do you mean by "atomic" here? Are you saying that we can get torn
> > read on u32 on some architectures?
>
> compiler doesn't guarantee that plain 32-bit load/store will stay 32-bit
> even on 64-bit archs.
>
> > If that was the case, neither
> > WRITE_ONCE/READ_ONCE nor smp_write_release/smp_load_acquire would
> > help.
>
> what do you mean? They will. That's the point of these macros.

According to Documentation/memory-barriers.txt,
smp_load_acquire/smp_store_release are about ordering and memory
barriers, not about guaranteeing atomicity of reading value.
Especially READ_ONCE/WRITE_ONCE which are volatile read/write, not
atomic read/write. But nevertheless, I'll do lock and this will become
moot.

>
> > But I don't think that's the case, we have code in verifier that
> > does similar racy u32 write/read (it uses READ_ONCE/WRITE_ONCE) and
> > seems to be working fine.
>
> you mean in btf_resolve_helper_id() ?
> What kind of race do you see there?

Two CPUs reading/writing to same variable without lock? Value starts
at 0 (meaning "not yet ready") and eventually becoming valid and final
non-zero value. Even if they race, and one CPU reads 0 while another
CPU already set it to non-zero, it's fine. In verifier's case it will
be eventually overwritten with the same resolved btf id. In case of
bpf_link, GET_FD_BY_ID would pretend link doesn't exist yet and return
error. Seems similar enough to me.

>
> > > So WRITE_ONCE in patch 2 into link->id is still racy with plain
> > > read in patch 3.
> > > Just wait and see kmsan complaining about it.
> > >
> > > > > How about grabbing link_idr_lock here as well ?
> > > > > otherwise it's still racy since WRITE_ONCE is not paired.
> > > >
> > > > As indicated above, seems unnecessary? But I also don't object
> > > > strongly, I don't expect this lock for links to be a major bottleneck
> > > > or anything like that.
> > >
> > > Either READ_ONCE has to be paired with WRITE_ONCE
> > > (or even better smp_load_acquire with smp_store_release)
> > > or use spin_lock.
> >
> > Sure, let me use smp_load_acquite/smp_store_release.
>
> Since there're locks in other places I would use spin_lock_bh
> to update id as well.

Sure, I'll do spin_lock_bh.

>
> >
> > >
> > > > >
> > > > > The mix of spin_lock_irqsave(&link_idr_lock)
> > > > > and spin_lock_bh(&link_idr_lock) looks weird.
> > > > > We do the same for map_idr because maps have complicated freeing logic,
> > > > > but prog_idr is consistent.
> > > > > If you see the need for irqsave variant then please use it in all cases.
> > > >
> > > > No, my bad, I don't see any need to intermix them. I'll stick to
> > > > spin_lock_bh, thanks for catching!
> > >
> > > I think that should be fine.
> > > Please double check that situation described in
> > > commit 930651a75bf1 ("bpf: do not disable/enable BH in bpf_map_free_id()")
> > > doesn't apply to link_idr.
> >
> > If I understand what was the problem for BPF maps, we were taking lock
> > and trying to disable softirqs while softirqs were already disabled by
> > caller. This doesn't seem to be the case for links, as far as I can
> > tell. So I'll just go with spin_lock_bh() everywhere for consistency.
>
> Sounds good.
