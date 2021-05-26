Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CBB391D72
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhEZRCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhEZRCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 13:02:18 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14B4C061574;
        Wed, 26 May 2021 10:00:46 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id w1so3034756ybt.1;
        Wed, 26 May 2021 10:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vU8HCfAU1zDQh9haIdDJWaUxp2b1UKacwZtI5/JtTMM=;
        b=iCe5zZlLY8TNdnL+i1nIqT5nrnLM+EdrYzgfjkeSLD4MaH9wp3UkW5VMkzCLpYiMFf
         ZlS2518KTOTGWkBnCIb9Nfa4JwLMnRYMGDePJOTMf2yl8NrgJgMCOkF3Mhf/4IgRuMjx
         EMToDKgACE6PR9bjIPP7bDkJzQfeKmiVa+hfjf2DUTNc9WvEVnVGwN8k/ro4+AoC9HhM
         uKjhcZR8Yn5zz3007JHvDQRcEGyARp0DryLWd+IveBEv/Rhii+zsaVfpk+uiUrh/GW6h
         YqPnnzZ6epiGm89MuwRn/qri4zPM7YICrkf1OUMv/kZH2AyeFLkiNwhs013FOZWKd3VS
         gmvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vU8HCfAU1zDQh9haIdDJWaUxp2b1UKacwZtI5/JtTMM=;
        b=H/fzWAyQ+wsMuz0AOST7Lb91igqyPC18nA4sxGWG7DthZXly4kplIPlcoW1QoP+Dyg
         SvDOwXMLNr68skWNDV26sOaMXEufuIl3D6jmN3l+u1vmmrb1w7IHsbVxswWED5XqZBhI
         Y+rxKfw7euoVpDf5K7CDaT+3WJKSgbXi+yJKa23a5t4xeyyuumFvx2MdYPW1zZoXm8ZD
         RPVJhhn+/UYGL3u2Aehaa1QgJrkGD6Wrx7B32MHWvEMELG5wFGLOND1ILJqnRb+KsnBf
         v+o6GYD06/xpwUJT2BWs3QZhUNg/k8L6ubQGS6jYc25c9sk8nPiOoxFxDthyWTne3uZU
         qbKw==
X-Gm-Message-State: AOAM531MCvejNQBPrjAJbS/dgRiHd7FpasBoE3mvFe+s5+uD6Lqb8lB2
        jvtmSvbRLgrH9UeIIHJ0G4Y1RmCYap3or9aGBWI=
X-Google-Smtp-Source: ABdhPJzaq80hq8KVk4ila3PFehhtYyhoVLRMKxhed0Ikxq5o3hfhPIwuLf2lzasTbzinbs0o6hFZsvxfCLvJ38336FU=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr49776676ybg.459.1622048445748;
 Wed, 26 May 2021 10:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210526080741.GW30378@techsingularity.net> <20210526083342.GY8544@kitsune.suse.cz>
In-Reply-To: <20210526083342.GY8544@kitsune.suse.cz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 May 2021 10:00:34 -0700
Message-ID: <CAEf4BzZBW5bNF61p3+n7akUs1qztNJ4FwY4yAYRdjmP4ShFQKQ@mail.gmail.com>
Subject: Re: (BTF) [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
To:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 1:33 AM Michal Such=C3=A1nek <msuchanek@suse.de> wr=
ote:
>
> On Wed, May 26, 2021 at 09:07:41AM +0100, Mel Gorman wrote:
> > Michal Suchanek reported the following problem with linux-next
> >
> >   [    0.000000] Linux version 5.13.0-rc2-next-20210519-1.g3455ff8-vani=
lla (geeko@buildhost) (gcc (SUSE Linux) 10.3.0, GNU ld (GNU Binutils; openS=
USE Tumbleweed) 2.36.1.20210326-3) #1 SMP Wed May 19 10:05:10 UTC 2021 (345=
5ff8)
> >   [    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-ne=
xt-20210519-1.g3455ff8-vanilla root=3DUUID=3Dec42c33e-a2c2-4c61-afcc-93e952=
7 8f687 plymouth.enable=3D0 resume=3D/dev/disk/by-uuid/f1fe4560-a801-4faf-a=
638-834c407027c7 mitigations=3Dauto earlyprintk initcall_debug nomodeset ea=
rlycon ignore_loglevel console=3DttyS0,115200
> > ...
> >   [   26.093364] calling  tracing_set_default_clock+0x0/0x62 @ 1
> >   [   26.098937] initcall tracing_set_default_clock+0x0/0x62 returned 0=
 after 0 usecs
> >   [   26.106330] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0x=
7c @ 1
> >   [   26.113033] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0x=
7c returned 0 after 3 usecs
> >   [   26.121559] calling  clk_disable_unused+0x0/0x102 @ 1
> >   [   26.126620] initcall clk_disable_unused+0x0/0x102 returned 0 after=
 0 usecs
> >   [   26.133491] calling  regulator_init_complete+0x0/0x25 @ 1
> >   [   26.138890] initcall regulator_init_complete+0x0/0x25 returned 0 a=
fter 0 usecs
> >   [   26.147816] Freeing unused decrypted memory: 2036K
> >   [   26.153682] Freeing unused kernel image (initmem) memory: 2308K
> >   [   26.165776] Write protecting the kernel read-only data: 26624k
> >   [   26.173067] Freeing unused kernel image (text/rodata gap) memory: =
2036K
> >   [   26.180416] Freeing unused kernel image (rodata/data gap) memory: =
1184K
> >   [   26.187031] Run /init as init process
> >   [   26.190693]   with arguments:
> >   [   26.193661]     /init
> >   [   26.195933]   with environment:
> >   [   26.199079]     HOME=3D/
> >   [   26.201444]     TERM=3Dlinux
> >   [   26.204152]     BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-next-2021051=
9-1.g3455ff8-vanilla
> >   [   26.254154] BPF:      type_id=3D35503 offset=3D178440 size=3D4
> >   [   26.259125] BPF:
> >   [   26.261054] BPF:Invalid offset
> >   [   26.264119] BPF:
> >   [   26.264119]
> >   [   26.267437] failed to validate module [efivarfs] BTF: -22
> >
> > Andrii Nakryiko bisected the problem to the commit "mm/page_alloc: conv=
ert
> > per-cpu list protection to local_lock" currently staged in mmotm. In hi=
s
> > own words
> >
> >   The immediate problem is two different definitions of numa_node per-c=
pu
> >   variable. They both are at the same offset within .data..percpu ELF
> >   section, they both have the same name, but one of them is marked as
> >   static and another as global. And one is int variable, while another
> >   is struct pagesets. I'll look some more tomorrow, but adding Jiri and
> >   Arnaldo for visibility.
> >
> >   [110907] DATASEC '.data..percpu' size=3D178904 vlen=3D303
> >   ...
> >         type_id=3D27753 offset=3D163976 size=3D4 (VAR 'numa_node')
> >         type_id=3D27754 offset=3D163976 size=3D4 (VAR 'numa_node')
> >
> >   [27753] VAR 'numa_node' type_id=3D27556, linkage=3Dstatic
> >   [27754] VAR 'numa_node' type_id=3D20, linkage=3Dglobal
> >
> >   [20] INT 'int' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3DSIGNE=
D
> >
> >   [27556] STRUCT 'pagesets' size=3D0 vlen=3D1
> >         'lock' type_id=3D507 bits_offset=3D0
> >
> >   [506] STRUCT '(anon)' size=3D0 vlen=3D0
> >   [507] TYPEDEF 'local_lock_t' type_id=3D506
> >
> > The patch in question introduces a zero-sized per-cpu struct and while
> > this is not wrong, versions of pahole prior to 1.22 (unreleased) get
> > confused during BTF generation with two separate variables occupying th=
e
> > same address.
> >
> > This patch checks for older versions of pahole and forces struct pagese=
ts
> > to be non-zero sized as a workaround when CONFIG_DEBUG_INFO_BTF is set.=
 A
> > warning is omitted so that distributions can update pahole when 1.22
> > is released.
> >
> > Reported-by: Michal Suchanek <msuchanek@suse.de>
> > Reported-by: Hritik Vijay <hritikxx8@gmail.com>
> > Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> > ---
> >  lib/Kconfig.debug |  3 +++
> >  mm/page_alloc.c   | 11 +++++++++++
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 678c13967580..f88a155b80a9 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -313,6 +313,9 @@ config DEBUG_INFO_BTF
> >  config PAHOLE_HAS_SPLIT_BTF
> >       def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]=
+)\.([0-9]+)/\1\2/'` -ge "119")
> >
> > +config PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
> > +     def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]=
+)\.([0-9]+)/\1\2/'` -ge "122")
> > +
>
> This does not seem workable with dummy-tools.
>
> Do we even have dummy pahole?
>

I don't know what dummy-tools is, so probably no. But if you don't
have pahole on the build host, you can't have DEBUG_INFO_BTF=3Dy
anyways. As in, your build will fail because it will be impossible to
generate BTF information. So you'll have to disable DEBUG_INFO_BTF if
you can't get pahole onto your build host for some reason.

> Thanks
>
> Michal
>
> >  config DEBUG_INFO_BTF_MODULES
> >       def_bool y
> >       depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index ff8f706839ea..1d56d3de8e08 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -124,6 +124,17 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
> >
> >  struct pagesets {
> >       local_lock_t lock;
> > +#if defined(CONFIG_DEBUG_INFO_BTF) &&                        \
> > +    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&             \
> > +    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
> > +     /*
> > +      * pahole 1.21 and earlier gets confused by zero-sized per-CPU
> > +      * variables and produces invalid BTF. Ensure that
> > +      * sizeof(struct pagesets) !=3D 0 for older versions of pahole.
> > +      */
> > +     char __pahole_hack;
> > +     #warning "pahole too old to support zero-sized struct pagesets"
> > +#endif
> >  };
> >  static DEFINE_PER_CPU(struct pagesets, pagesets) =3D {
> >       .lock =3D INIT_LOCAL_LOCK(lock),
