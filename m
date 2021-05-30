Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE67394F04
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 05:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhE3DM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 23:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhE3DM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 23:12:27 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA183C061574;
        Sat, 29 May 2021 20:10:48 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id f84so11501922ybg.0;
        Sat, 29 May 2021 20:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FcKoFZ0P38MLC340jJCPwKlfNKBvKK6zzlbSELrWy48=;
        b=Tlf2hLmn/ijTjgjwMRyay3uRY5vr1QwsrIeFBVjrDVRcIXHt4FojGz2BCfsCKWAnuO
         +Vee/xlQf7nALXbvV8gW/0KLzSRSYvJp+h6F+QhQ/JaaEQk5zPc8r81Tcz+2nhiQLl21
         zP3rBnX+icd8x+cFVHtdJccv1A8BXq5InvJfxYPGmAbTL5epQAvEfBcqZhIUIQpgSVSA
         Su4JttvANueSnMZZjFomcyi2SGkpbtJRZepcG/XdWonHLkcs45J/gvtZu1MzGr6Jlwf3
         pSq2sWnUOwnry2uxXrhG7vBZM027BdbheW+uDoS5WWVx2q4Nm4RY6VT2j/A7lTpcyEa5
         GAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FcKoFZ0P38MLC340jJCPwKlfNKBvKK6zzlbSELrWy48=;
        b=ZTpbNajz4kS9Gy0v7MlzrTyXK5A7ZJ4WoGIpe80UxaFiVRhgY7l0PuYsVTEfQeef81
         Fz8nSO16h58E8bNz/xgPULExLZutU9ZTwlEZewcxFvcaBkQp1IUvH/5j6QzguZQpKvMM
         sdvUC8iQ9wuc+By+jmBi0JWUWQ7D7ydniEUZjYH74yLhtThUAUjZn9c8riOfqhHqlN55
         NioJWh00Hj0dhakCqv8tkRkWGYr1wGZLv9P6h6i917tzPY2DoBKNfiYxSCzPsbsMmW4S
         mQyC1A2r695FHv7VmgUxeCGI90/60zwiHDKSRlKRbD8+mqBE/oWia3oQlb3EZ5mKd7Lm
         AlJw==
X-Gm-Message-State: AOAM53009ZisIvJ1KQDHDAMuc3mgIJy7O1lPpUnk6dnfxUoIPnCroqFL
        7jyVIRDaCrjqYSoAmZRRfbKayvdzE/Lw7ZNGYlg=
X-Google-Smtp-Source: ABdhPJxurv9vJ+f7Y6dgU2PL7HfRo6NQNymmA7TdAAmPf0Gbu5SH4MZOBeyUH96IwVmWirO8dVVokzMrXYqoJxdxXpk=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr22521804ybr.425.1622344247180;
 Sat, 29 May 2021 20:10:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210527171923.GG30378@techsingularity.net> <CAEf4BzZB7Z3fGyVH1+a9SvTtm1LBBG2T++pYiTjRVxbrodzzZA@mail.gmail.com>
 <20210528074248.GI30378@techsingularity.net>
In-Reply-To: <20210528074248.GI30378@techsingularity.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 29 May 2021 20:10:36 -0700
Message-ID: <CAEf4BzYrfKtecSEbf3yZs5v6aeSkNRJuHfed3kKz-6Vy1eeKuA@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_alloc: Require pahole v1.22 to cope with
 zero-sized struct pagesets
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>,
        Linux-BPF <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, clm@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 12:42 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> On Thu, May 27, 2021 at 03:17:48PM -0700, Andrii Nakryiko wrote:
> > > Andrii Nakryiko bisected the problem to the commit "mm/page_alloc: convert
> > > per-cpu list protection to local_lock" currently staged in mmotm. In his
> > > own words
> > >
> > >   The immediate problem is two different definitions of numa_node per-cpu
> > >   variable. They both are at the same offset within .data..percpu ELF
> > >   section, they both have the same name, but one of them is marked as
> > >   static and another as global. And one is int variable, while another
> > >   is struct pagesets. I'll look some more tomorrow, but adding Jiri and
> > >   Arnaldo for visibility.
> > >
> > >   [110907] DATASEC '.data..percpu' size=178904 vlen=303
> > >   ...
> > >         type_id=27753 offset=163976 size=4 (VAR 'numa_node')
> > >         type_id=27754 offset=163976 size=4 (VAR 'numa_node')
> > >
> > >   [27753] VAR 'numa_node' type_id=27556, linkage=static
> > >   [27754] VAR 'numa_node' type_id=20, linkage=global
> > >
> > >   [20] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> > >
> > >   [27556] STRUCT 'pagesets' size=0 vlen=1
> > >         'lock' type_id=507 bits_offset=0
> > >
> > >   [506] STRUCT '(anon)' size=0 vlen=0
> > >   [507] TYPEDEF 'local_lock_t' type_id=506
> > >
> > > The patch in question introduces a zero-sized per-cpu struct and while
> > > this is not wrong, versions of pahole prior to 1.22 get confused during
> > > BTF generation with two separate variables occupying the same address.
> > >
> > > This patch adds a requirement for pahole 1.22 before setting
> > > DEBUG_INFO_BTF.  While pahole 1.22 does not exist yet, a fix is in the
> > > pahole git tree as ("btf_encoder: fix and complete filtering out zero-sized
> > > per-CPU variables").
> > >
> > > Reported-by: Michal Suchanek <msuchanek@suse.de>
> > > Reported-by: Hritik Vijay <hritikxx8@gmail.com>
> > > Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > > Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> > > ---
> >
> > I still think that v1 ([0]) is a more appropriate temporary solution
> > until pahole 1.22 is released and widely packaged. Suddenly raising
> > the minimum version to 1.22, which is not even released even, is a
> > pretty big compatibility concern for all the users that rely on
> > CONFIG_DEBUG_INFO_BTF.
>
> On the flip side, we have a situation where a build tool (pahole) has a
> problem whereby correct code does not result in a working kernel. It's
> not that dissimilar to preventing the kernel being built on an old
> compiler. While I accept it's unfortunate, Christoph had a point where
> introducing workarounds in the kernel could lead to a prolification of
> workarounds for pahole or other reasons that are potentially tricky to
> revert as long as distributions exist that do not ship with a sufficiently
> reason package.
>
> > Just a few days ago pahole 1.16 worked fine and
> > here we suddenly (and silently due to how Kconfig functions) raise
> > that to a version that doesn't exist. That's going to break workflows
> > for a lot of people.
> >
>
> People do have a workaround though. For the system building the kernel,
> they can patch pahole and revert the check so a bootable kernel can be
> built. It's not convenient but it is manageable and pahole has until
> 5.13 releases to release a v1.22. The downsides for the alternative --
> a non-booting kernel are much more severe.
>
> > I'm asking to have that ugly work-around to ensure sizeof(struct
> > pagesets) > 0 as a temporary solution only.
>
> Another temporary solution is to locally build pahole and either revert
> the check or fake the 1.22 release number with the self-built pahole.
>

Well, luckily it seems we anticipated issues like that and added
--skip_encoding_btf_vars argument, which I completely forgot about and
just accidentally came across reviewing Arnaldo's latest pahole patch.
I think that one is a much better solution, as then it will impact
only those that explicitly relies on availability of BTF for per-CPU
variables, which is a subset of all possible uses for kernel BTF. Sent
a patch ([0]), please take a look.

  [0] https://lore.kernel.org/linux-mm/20210530002536.3193829-1-andrii@kernel.org/T/#u

> --
> Mel Gorman
> SUSE Labs
