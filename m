Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2AF1BD021
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgD1WnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgD1WnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 18:43:13 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E6EC03C1AC;
        Tue, 28 Apr 2020 15:43:13 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x15so108602pfa.1;
        Tue, 28 Apr 2020 15:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jrHyCDj1B4GI6sHpbhiU8kfnPnVbrYnwV+hUSdwwv4U=;
        b=i9aQJypjPWx2LhepwM9zM6rkCBovV4buykCyRP1CVDK4nihZcKPs8KyoCicpCURche
         tKDEuJu0kCiEIdAsryHQyWo/l7OL3sfOabBSIl56qqANaza2+ey02/Den5pzObKM/ztT
         31u8D6wa1EwmcF2xf5G+0XSEaHwQDvVW2Bq15UWTBhuGuHSuJQXwafjjk3Kk/tOn1E26
         mOBh7aKreJevv3rppKj3/4lDAQoc8dFDkOKDCRsdDbI2Sn0CjaVMjR6NcnTgdlMTOji1
         ZhwVJlJ/XKz71jrNHgxkPXJLH9d4mLmMX6RkcmCKrVuP3UOqgflU3OtTpEt3dZXAaAr6
         Sz7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jrHyCDj1B4GI6sHpbhiU8kfnPnVbrYnwV+hUSdwwv4U=;
        b=Goy8Ma8O/JGMjbvPQSQIx0/oHE8H8hh6ADJJCE1Y5X39nk2KC0zDQrBlsQnL3fcgJ0
         UoA5SJNnKi/QOhun+tT/6Ojy48zlINCWs7DzbhAW93TZyY4ZpuU9THI5UOVDaxRpy/na
         GVZ7GmMhwVBaROshOV40UrMkRBTLjdfdHeLM0TeDHV/9NeuGfcs+KEqloqHQvrcTXTtK
         78nn6i4O5VCWRNSl4kiy6nI2+8rXHM+DgAsP1Ak9lN+ojvUChClgZV2DJQ8RtX7Ochqz
         u7jOzwlUbb55hFB1weksy1O/vmv4OlBZpDkwd6sW+pW0KEqE443KPpzdcsm+uG/qJ6e2
         w2hg==
X-Gm-Message-State: AGi0PuaWYitckPfjk1Cqx0Fz6iGPtZ0rw+boGxUk4wgjZUufp41+jkNg
        TuwRxc/vE7dFdwBgKzvnJzs=
X-Google-Smtp-Source: APiQypIwHDDtLlkPDyGdkejl/EkhDXYesMAR7hKubehQxDQr8i8t08N9dJwrzn77Pl9psNDy4aGYwQ==
X-Received: by 2002:a63:1c6:: with SMTP id 189mr10751239pgb.187.1588113792845;
        Tue, 28 Apr 2020 15:43:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id p190sm16532619pfp.207.2020.04.28.15.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 15:43:11 -0700 (PDT)
Date:   Tue, 28 Apr 2020 15:43:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 02/10] bpf: allocate ID for bpf_link
Message-ID: <20200428224309.pod67otmp77mcspp@ast-mbp.dhcp.thefacebook.com>
References: <20200428054944.4015462-1-andriin@fb.com>
 <20200428054944.4015462-3-andriin@fb.com>
 <20200428173120.lof25gzz75bx5ot7@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bza-gqQHz3_9RyX7pKo_2kYeh7cCmNRAxExx48JQdOpfDQ@mail.gmail.com>
 <20200428203843.pe7d4zbki2ihnq2m@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZ4q5ngbF9YQSrCSyXv3UkQL5YWRnuOAuKs4b7nBkYZpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ4q5ngbF9YQSrCSyXv3UkQL5YWRnuOAuKs4b7nBkYZpg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 03:33:07PM -0700, Andrii Nakryiko wrote:
> On Tue, Apr 28, 2020 at 1:38 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Apr 28, 2020 at 11:56:52AM -0700, Andrii Nakryiko wrote:
> > > On Tue, Apr 28, 2020 at 10:31 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Mon, Apr 27, 2020 at 10:49:36PM -0700, Andrii Nakryiko wrote:
> > > > > +int bpf_link_settle(struct bpf_link_primer *primer)
> > > > > +{
> > > > > +     /* make bpf_link fetchable by ID */
> > > > > +     WRITE_ONCE(primer->link->id, primer->id);
> > > >
> > > > what does WRITE_ONCE serve here?
> > >
> > > To prevent compiler reordering this write with fd_install. So that by
> > > the time FD is exposed to user-space, link has properly set ID.
> >
> > if you wanted memory barrier then it should have been barrier(),
> > but that wouldn't be enough, since patch 2 and 3 race to read and write
> > that 32-bit int.
> >
> > > > bpf_link_settle can only be called at the end of attach.
> > > > If attach is slow than parallel get_fd_by_id can get an new FD
> > > > instance for link with zero id.
> > > > In such case deref of link->id will race with above assignment?
> > >
> > > Yes, it does race, but it can either see zero and assume bpf_link is
> > > not ready (which is fine to do) or will see correct link ID and will
> > > proceed to create new FD for it. By the time we do context switch back
> > > to user-space and return link FD, ID will definitely be visible due to
> > > context switch and associated memory barriers. If anyone is guessing
> > > FD and trying to create FD_BY_ID before LINK_CREATE syscall returns --
> > > then returning failure due to link ID not yet set is totally fine,
> > > IMO.
> > >
> > > > But I don't see READ_ONCE in patch 3.
> > > > It's under link_idr_lock there.
> > >
> > > It doesn't need READ_ONCE because it does read under spinlock, so
> > > compiler can't re-order it with code outside of spinlock.
> >
> > spin_lock in patch 3 doesn't guarantee that link->id deref in that patch
> > will be atomic.
> 
> What do you mean by "atomic" here? Are you saying that we can get torn
> read on u32 on some architectures? 

compiler doesn't guarantee that plain 32-bit load/store will stay 32-bit
even on 64-bit archs.

> If that was the case, neither
> WRITE_ONCE/READ_ONCE nor smp_write_release/smp_load_acquire would
> help. 

what do you mean? They will. That's the point of these macros.

> But I don't think that's the case, we have code in verifier that
> does similar racy u32 write/read (it uses READ_ONCE/WRITE_ONCE) and
> seems to be working fine.

you mean in btf_resolve_helper_id() ?
What kind of race do you see there?

> > So WRITE_ONCE in patch 2 into link->id is still racy with plain
> > read in patch 3.
> > Just wait and see kmsan complaining about it.
> >
> > > > How about grabbing link_idr_lock here as well ?
> > > > otherwise it's still racy since WRITE_ONCE is not paired.
> > >
> > > As indicated above, seems unnecessary? But I also don't object
> > > strongly, I don't expect this lock for links to be a major bottleneck
> > > or anything like that.
> >
> > Either READ_ONCE has to be paired with WRITE_ONCE
> > (or even better smp_load_acquire with smp_store_release)
> > or use spin_lock.
> 
> Sure, let me use smp_load_acquite/smp_store_release.

Since there're locks in other places I would use spin_lock_bh
to update id as well.

> 
> >
> > > >
> > > > The mix of spin_lock_irqsave(&link_idr_lock)
> > > > and spin_lock_bh(&link_idr_lock) looks weird.
> > > > We do the same for map_idr because maps have complicated freeing logic,
> > > > but prog_idr is consistent.
> > > > If you see the need for irqsave variant then please use it in all cases.
> > >
> > > No, my bad, I don't see any need to intermix them. I'll stick to
> > > spin_lock_bh, thanks for catching!
> >
> > I think that should be fine.
> > Please double check that situation described in
> > commit 930651a75bf1 ("bpf: do not disable/enable BH in bpf_map_free_id()")
> > doesn't apply to link_idr.
> 
> If I understand what was the problem for BPF maps, we were taking lock
> and trying to disable softirqs while softirqs were already disabled by
> caller. This doesn't seem to be the case for links, as far as I can
> tell. So I'll just go with spin_lock_bh() everywhere for consistency.

Sounds good.
