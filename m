Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1142D1BD00F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgD1WdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgD1WdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 18:33:19 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7DDC03C1AC;
        Tue, 28 Apr 2020 15:33:19 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id i68so291488qtb.5;
        Tue, 28 Apr 2020 15:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VP2rT8ROh7S0MnyS1t6JGVG5H1MCG74Qx9Ajtfaf+AE=;
        b=ucjcYe7JBqxRxJQ7GEZCO6l7FBxFw5Ys7u4ysrcJj+Kmvkj6w97jb0QSwk4Ey3tJmk
         xQnL2+4WUhF0ZhvQYlqNUD5J9/UcwYswSJLn+R0IpuwiaoQwCSzaGLmEFc+B0+lWbau8
         /RnD0HAhdoXQ5cfT1sAk9lb+SHxBMyNY0orOSQ0njKgLJdNGGZYK16O7OsddPmB34aYs
         o0Aj+IRrPs2V7cDcCeYcj/AtKjwYaGP8PGVb/mMamljwUZBdpIwqrZ10KjofDQQUh+4j
         3cSTX0g//led+aEIHZJzvZBn+lWO97QK7s2yeCKm7bNB/+YpC4RbglElzTdpDIgw42YR
         +KdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VP2rT8ROh7S0MnyS1t6JGVG5H1MCG74Qx9Ajtfaf+AE=;
        b=E3dFP2VrMRwlbG9dSYvwrsMVpvh9XfmSpuz/RxduXugYpAj/0mx9+BUa5C4RJHxKar
         hU4JLqzg8M4fYzGG9UhfnQX0wqKnG7Emigx1pvlM+SJWAxQZ59KhNmN0yiqFTRw4/2yr
         ydKM1HUWZgofHupUD8hVgXCc75vn529MLm6phUCPDEm2i8CiJ7tkP0bjmYpa1hvHF4vc
         5vn3HMM8zvs6h3zCtxk6RVzD4twMhiKtv6X/e0Ri83/kBXrbNT0bC9+yPMDW9+Wwkr9A
         GESfam70YqSLb7T+SiJPJKDJVkhBGvKKzU6ol/n+eJIJRJHhJYd4B+boOgVF66eKsamC
         8DIA==
X-Gm-Message-State: AGi0PuZelajLMvYTgaZbibXTIxxbot0HYyTwsV7YrYc0XSMsoFfThDXk
        FFMlbDlBvSM18GwW+Q5SimoSkRVNw28rBnbzK58=
X-Google-Smtp-Source: APiQypKyfSCkwhJz9ssDaKVO4zAYa8yPSUF0mVEk9NTbjf7U890PzQ+7ci6wcTCYTRKUn/sNJgQ7i1Mr0CINjCWAbL8=
X-Received: by 2002:ac8:193d:: with SMTP id t58mr2487519qtj.93.1588113198540;
 Tue, 28 Apr 2020 15:33:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200428054944.4015462-1-andriin@fb.com> <20200428054944.4015462-3-andriin@fb.com>
 <20200428173120.lof25gzz75bx5ot7@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bza-gqQHz3_9RyX7pKo_2kYeh7cCmNRAxExx48JQdOpfDQ@mail.gmail.com> <20200428203843.pe7d4zbki2ihnq2m@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200428203843.pe7d4zbki2ihnq2m@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 15:33:07 -0700
Message-ID: <CAEf4BzZ4q5ngbF9YQSrCSyXv3UkQL5YWRnuOAuKs4b7nBkYZpg@mail.gmail.com>
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

On Tue, Apr 28, 2020 at 1:38 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Apr 28, 2020 at 11:56:52AM -0700, Andrii Nakryiko wrote:
> > On Tue, Apr 28, 2020 at 10:31 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Apr 27, 2020 at 10:49:36PM -0700, Andrii Nakryiko wrote:
> > > > +int bpf_link_settle(struct bpf_link_primer *primer)
> > > > +{
> > > > +     /* make bpf_link fetchable by ID */
> > > > +     WRITE_ONCE(primer->link->id, primer->id);
> > >
> > > what does WRITE_ONCE serve here?
> >
> > To prevent compiler reordering this write with fd_install. So that by
> > the time FD is exposed to user-space, link has properly set ID.
>
> if you wanted memory barrier then it should have been barrier(),
> but that wouldn't be enough, since patch 2 and 3 race to read and write
> that 32-bit int.
>
> > > bpf_link_settle can only be called at the end of attach.
> > > If attach is slow than parallel get_fd_by_id can get an new FD
> > > instance for link with zero id.
> > > In such case deref of link->id will race with above assignment?
> >
> > Yes, it does race, but it can either see zero and assume bpf_link is
> > not ready (which is fine to do) or will see correct link ID and will
> > proceed to create new FD for it. By the time we do context switch back
> > to user-space and return link FD, ID will definitely be visible due to
> > context switch and associated memory barriers. If anyone is guessing
> > FD and trying to create FD_BY_ID before LINK_CREATE syscall returns --
> > then returning failure due to link ID not yet set is totally fine,
> > IMO.
> >
> > > But I don't see READ_ONCE in patch 3.
> > > It's under link_idr_lock there.
> >
> > It doesn't need READ_ONCE because it does read under spinlock, so
> > compiler can't re-order it with code outside of spinlock.
>
> spin_lock in patch 3 doesn't guarantee that link->id deref in that patch
> will be atomic.

What do you mean by "atomic" here? Are you saying that we can get torn
read on u32 on some architectures? If that was the case, neither
WRITE_ONCE/READ_ONCE nor smp_write_release/smp_load_acquire would
help. But I don't think that's the case, we have code in verifier that
does similar racy u32 write/read (it uses READ_ONCE/WRITE_ONCE) and
seems to be working fine.

> So WRITE_ONCE in patch 2 into link->id is still racy with plain
> read in patch 3.
> Just wait and see kmsan complaining about it.
>
> > > How about grabbing link_idr_lock here as well ?
> > > otherwise it's still racy since WRITE_ONCE is not paired.
> >
> > As indicated above, seems unnecessary? But I also don't object
> > strongly, I don't expect this lock for links to be a major bottleneck
> > or anything like that.
>
> Either READ_ONCE has to be paired with WRITE_ONCE
> (or even better smp_load_acquire with smp_store_release)
> or use spin_lock.

Sure, let me use smp_load_acquite/smp_store_release.

>
> > >
> > > The mix of spin_lock_irqsave(&link_idr_lock)
> > > and spin_lock_bh(&link_idr_lock) looks weird.
> > > We do the same for map_idr because maps have complicated freeing logic,
> > > but prog_idr is consistent.
> > > If you see the need for irqsave variant then please use it in all cases.
> >
> > No, my bad, I don't see any need to intermix them. I'll stick to
> > spin_lock_bh, thanks for catching!
>
> I think that should be fine.
> Please double check that situation described in
> commit 930651a75bf1 ("bpf: do not disable/enable BH in bpf_map_free_id()")
> doesn't apply to link_idr.

If I understand what was the problem for BPF maps, we were taking lock
and trying to disable softirqs while softirqs were already disabled by
caller. This doesn't seem to be the case for links, as far as I can
tell. So I'll just go with spin_lock_bh() everywhere for consistency.
