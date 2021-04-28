Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5D436D04F
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 03:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbhD1Bdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 21:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhD1Bdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 21:33:31 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CFDC061574;
        Tue, 27 Apr 2021 18:32:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id lr7so13751545pjb.2;
        Tue, 27 Apr 2021 18:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qca+IPsUAPrq1jWTPf4EozlEUnBTrV+ZPIqiR+ky1JQ=;
        b=ORXh/LLbAfU+8/sWugoYarqa7pusbG91xfssYZE9yhK1NLgZReSmJpOGPNHaT0I4HN
         Yi8vS8GlNvrpBYAmKaJcBUp/HGNPWgGWhahoHUbwDDj1gNpqk99W99UXzS2JUngs+M72
         6VyOPUZkMqB4MFRVDS6IWXI3KcDdQ4OSW6Xwx2og6T3gVvxJiwE1FPl5GnsjMArIpeFR
         /3LKgpoTwptbs7396JO31DOUD9izdPyBO0baeqCa6o5LTU5RErtCRVSyv0bY+fQjcK83
         k/t1OWqhv4gaF0MCzlwQbKx8K6gQ370//hiY5uFx7zxfqh8k1/EuTDrjbyJXPQmfRMZw
         VW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qca+IPsUAPrq1jWTPf4EozlEUnBTrV+ZPIqiR+ky1JQ=;
        b=pMkRkZ3MuDi9Q0IyTLn28YI80U4H1rTxsEOImzQRIO8UYrQmxHBZD3s9TqaEypfN3a
         qP33ozv/l12ZkP9ztnoodwpcVUNX656PvurYLFnCT4O79y1R9S1d7tH3kn68jgETVHx9
         qCry530AY/DtINNvrUEW5PaRX+u+X8meItJOyEiY29Hb1tWHhnpO9cSU1G4Lrvu97hax
         jxyuVhznn2jsdJkWwP45QEDFTp2gNqcPJbEF4eS2m7EZMd55fqdT3EGmUKdpdkg0kNK3
         bpXAHuEESfh022F3beZPV0Xl9kHgFqRRfR/8JRHpRKaQvYkz/tWjipGQc9ZDtn+Wxd1j
         Cz9A==
X-Gm-Message-State: AOAM531OR4aXSRPWfSTrNiAyq/NuwOLn33w724lsox9fGPAi1qG9xcE4
        mSXxgxiTD6VpI1Z84EBgoh4N2tveKJ0=
X-Google-Smtp-Source: ABdhPJwHb7ifWte6HyI1Zi60rgxvNLQ4KMxTUs9V0ymndIrLF3j8UqP7ZXNJjkdQmEVeVz5bYsb1mw==
X-Received: by 2002:a17:90b:797:: with SMTP id l23mr9531980pjz.160.1619573565640;
        Tue, 27 Apr 2021 18:32:45 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2e71])
        by smtp.gmail.com with ESMTPSA id f1sm3228734pjt.50.2021.04.27.18.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 18:32:44 -0700 (PDT)
Date:   Tue, 27 Apr 2021 18:32:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 09/16] libbpf: Support for fd_idx
Message-ID: <20210428013242.2iqeygfpmoyzwvxh@ast-mbp.dhcp.thefacebook.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-10-alexei.starovoitov@gmail.com>
 <CAEf4BzZ5CJmF45_aBWBHt2jYeLjs2o5VXEA3zfLDvTncW_hjZg@mail.gmail.com>
 <20210427025309.yma2vy4m4qbk5srv@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbDUwev3Wk7_K=2LDwTR0GN8_So8nDUwa9TfSXS0J+FCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbDUwev3Wk7_K=2LDwTR0GN8_So8nDUwa9TfSXS0J+FCg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 09:36:54AM -0700, Andrii Nakryiko wrote:
> On Mon, Apr 26, 2021 at 7:53 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Apr 26, 2021 at 10:14:45AM -0700, Andrii Nakryiko wrote:
> > > On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > From: Alexei Starovoitov <ast@kernel.org>
> > > >
> > > > Add support for FD_IDX make libbpf prefer that approach to loading programs.
> > > >
> > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > ---
> > > >  tools/lib/bpf/bpf.c             |  1 +
> > > >  tools/lib/bpf/libbpf.c          | 70 +++++++++++++++++++++++++++++----
> > > >  tools/lib/bpf/libbpf_internal.h |  1 +
> > > >  3 files changed, 65 insertions(+), 7 deletions(-)
> > > >
> > >
> 
> [...]
> 
> > > >         for (i = 0; i < obj->nr_programs; i++) {
> > > >                 prog = &obj->programs[i];
> > > >                 if (prog_is_subprog(obj, prog))
> > > > @@ -7256,10 +7308,14 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
> > > >                         continue;
> > > >                 }
> > > >                 prog->log_level |= log_level;
> > > > +               prog->fd_array = fd_array;
> > >
> > > you are not freeing this memory on success, as far as I can see.
> >
> > hmm. there is free on success below.
> 
> right, my bad, I somehow understood as if it was only for error case
> 
> >
> > > And
> > > given multiple programs are sharing fd_array, it's a bit problematic
> > > for prog to have fd_array. This is per-object properly, so let's add
> > > it at bpf_object level and clean it up on bpf_object__close()? And by
> > > assigning to obj->fd_array at malloc() site, you won't need to do all
> > > the error-handling free()s below.
> >
> > hmm. that sounds worse.
> > why add another 8 byte to bpf_object that won't be used
> > until this last step of bpf_object__load_progs.
> > And only for the duration of this loading.
> > It's cheaper to have this alloc here with two free()s below.
> 
> So if you care about extra 8 bytes, then it's even more efficient to
> have just one obj->fd_array rather than N prog->fd_array, no?

I think it's layer breaking when bpf_program__load()->load_program()
has to reach out to prog->obj to do its work.
The layers are already a mess due to:
&prog->obj->maps[prog->obj->rodata_map_idx]
I wanted to avoid making it uglier.

> And it's
> also not very clean that prog->fd_array will have a dangling pointer
> to deallocated memory after bpf_object__load_progs().

prog->reloc_desc is free and zeroed after __relocate.
prog->insns are freed and _not_ zereod after __load_progs.
so prog->fd_array won't be the first such pointer.
I can add zeroing, of course.

> 
> But that brings the entire question of why use fd_array at all here?
> Commit description doesn't explain why libbpf has to use fd_array and
> why it should be preferred. What are the advantages justifying added
> complexity and extra memory allocation/clean up? It also reduces test
> coverage of the "old ways" that offer the same capabilities. I think
> this should be part of the commit description, if we agree that
> fd_array has to be used outside of the auto-generated loader program.

I can add a knob to it to use it during loader gen for the loader gen
and for the runner of the loader prog.
I think it will add more complexity.
The bpf CI runs on older kernels, so the test coverage of "old ways"
is not reduced regardless.
From the kernel pov BPF_PSEUDO_MAP_FD vs BPF_PSEUDO_MAP_IDX there is
no advantage.
From the libbpf side patch 9 looked trivial enough _not_ do it conditionally,
but whatever. I don't mind more 'if'-s.
