Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954DF3909A2
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 21:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhEYT2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 15:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhEYT2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 15:28:30 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F62C061574;
        Tue, 25 May 2021 12:26:59 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id w1so33302464ybt.1;
        Tue, 25 May 2021 12:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ChOb8f6gHZMzAjFqmVZtT3Cvb2od/k0A2AQZhrJJelM=;
        b=DTpll6Nv0UmAJiXbHyUemLmqRXs/elcVmX+CvWnyMkxqCbsi+D21UstQjyCPc7vr55
         BQTOkBV1iTKWmPEFovIi2HSFpdjlsfnQTN7mtvaXQf1w5wBW3uRKaQDKxvpgLUMwR7tx
         fenJafgPa1zFyXB55Qdw+DulScg15vKAyZ+wtf888aYVcKMFi8nJFu5HbOy++o5UtQWm
         5XQrHd580EL04NKdwOer71V6O30dj9sqXUK8ysldJvK3z+Ysv5E+6slqX5cHTxInILIi
         iqVtqC5FjTaKPinFPWVSHALPzt8WlFHFseQaysc+jVzRhvUr+bzamEJQK5NzpEjdLUsQ
         EB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ChOb8f6gHZMzAjFqmVZtT3Cvb2od/k0A2AQZhrJJelM=;
        b=TKULPgw0De3ihiBX9y+rPuybobqUOGSgt/gIC8MuTFKxmHFfe+KOTNPPPueyOHwxvM
         J0oTHJnc+0MChEkGguwkXYyQ2DrjnNXT8jCYfNRG8XvRRFad0hKyqGnvxQPGiwrNz7Pt
         JWChyg5NZ7zeMhoiR87cteTMgVm6If62382wgZnFvi8BsF4A/Ksz1j9JgXuBI8CzCmdP
         t8dvKTm757QOjrkPEL+TNuHEmZVryBuwDdUPFsjHOLkoCsr3UWGQnTaPP2RBEb7Hd5qF
         jeBxIqtbPF2/mdLygG0mnPGfZOsuNB3VZOr4adDgB+6iJNYCtoNSqqRUIv6y5fRhaai1
         xTag==
X-Gm-Message-State: AOAM533C2spjxC30mN59mG1yQYk4N245ZkV6u8X9jiW5vTDmNZDQPG3K
        zc4ehW6fRmuW/sTiVPDo+cxqoQXHCbxKMa5X7fk=
X-Google-Smtp-Source: ABdhPJz2hzFj0BygyRm4b+95Mbog98dLS9/rRMlNQh1EaERqhhGXUsWi84JdNdetj0D3jl8lF2d6PytMujzVGYtZL88=
X-Received: by 2002:a5b:286:: with SMTP id x6mr47065650ybl.347.1621970818430;
 Tue, 25 May 2021 12:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210519141936.GV8544@kitsune.suse.cz> <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
 <CAEf4BzZ0-sihSL-UAm21JcaCCY92CqfNxycHRZYXcoj8OYb=wA@mail.gmail.com> <20210525135101.GT30378@techsingularity.net>
In-Reply-To: <20210525135101.GT30378@techsingularity.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 25 May 2021 12:26:47 -0700
Message-ID: <CAEf4BzYwuMVkiUa+iGpVWKvAdwLbrzY_qzhD9N0DYu1pGOEcJA@mail.gmail.com>
Subject: Re: BPF: failed module verification on linux-next
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     "Michal Such?nek" <msuchanek@suse.de>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 6:51 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> On Mon, May 24, 2021 at 03:58:29PM -0700, Andrii Nakryiko wrote:
> > > It took me a while to reliably bisect this, but it clearly points to
> > > this commit:
> > >
> > > e481fac7d80b ("mm/page_alloc: convert per-cpu list protection to local_lock")
> > >
> > > One commit before it, 676535512684 ("mm/page_alloc: split per cpu page
> > > lists and zone stats -fix"), works just fine.
> > >
> > > I'll have to spend more time debugging what exactly is happening, but
> > > the immediate problem is two different definitions of numa_node
> > > per-cpu variable. They both are at the same offset within
> > > .data..percpu ELF section, they both have the same name, but one of
> > > them is marked as static and another as global. And one is int
> > > variable, while another is struct pagesets. I'll look some more
> > > tomorrow, but adding Jiri and Arnaldo for visibility.
> > >
> > > [110907] DATASEC '.data..percpu' size=178904 vlen=303
> > > ...
> > >         type_id=27753 offset=163976 size=4 (VAR 'numa_node')
> > >         type_id=27754 offset=163976 size=4 (VAR 'numa_node')
> > >
> > > [27753] VAR 'numa_node' type_id=27556, linkage=static
> > > [27754] VAR 'numa_node' type_id=20, linkage=global
> > >
> > > [20] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> > >
> > > [27556] STRUCT 'pagesets' size=0 vlen=1
> > >         'lock' type_id=507 bits_offset=0
> > >
> > > [506] STRUCT '(anon)' size=0 vlen=0
> > > [507] TYPEDEF 'local_lock_t' type_id=506
> > >
> > > So also something weird about those zero-sized struct pagesets and
> > > local_lock_t inside it.
> >
> > Ok, so nothing weird about them. local_lock_t is designed to be
> > zero-sized unless CONFIG_DEBUG_LOCK_ALLOC is defined.
> >
> > But such zero-sized per-CPU variables are confusing pahole during BTF
> > generation, as now two different variables "occupy" the same address.
> >
> > Given this seems to be the first zero-sized per-CPU variable, I wonder
> > if it would be ok to make sure it's never zero-sized, while pahole
> > gets fixed and it's latest version gets widely packaged and
> > distributed.
> >
> > Mel, what do you think about something like below? Or maybe you can
> > advise some better solution?
> >
>
> Ouch, something like that may never go away. How about just this?

Yeah, that would work just fine, thanks! Would you like me to send a
formal patch or you'd like to do it?

>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 58426acf5983..dce2df33d823 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -338,6 +338,9 @@ config DEBUG_INFO_BTF
>  config PAHOLE_HAS_SPLIT_BTF
>         def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
>
> +config PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
> +       def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "122")
> +
>  config DEBUG_INFO_BTF_MODULES
>         def_bool y
>         depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1599985e0ee1..cb1f84848c99 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -124,6 +124,17 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
>
>  struct pagesets {
>         local_lock_t lock;
> +#if defined(CONFIG_DEBUG_INFO_BTF) &&                  \
> +    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&               \
> +    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
> +       /*
> +        * pahole 1.21 and earlier gets confused by zero-sized per-CPU
> +        * variables and produces invalid BTF. Ensure that
> +        * sizeof(struct pagesets) != 0 for older versions of pahole.
> +        */
> +       char __pahole_hack;
> +       #warning "pahole too old to support zero-sized struct pagesets"
> +#endif
>  };
>  static DEFINE_PER_CPU(struct pagesets, pagesets) = {
>         .lock = INIT_LOCAL_LOCK(lock),
> diff --git a/scripts/rust-version.sh b/scripts/rust-version.sh
> old mode 100644
> new mode 100755

Probably didn't intend to include this?

> --
> Mel Gorman
> SUSE Labs
