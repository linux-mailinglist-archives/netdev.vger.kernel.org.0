Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBF448CCCC
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 21:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350090AbiALUFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 15:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357996AbiALUEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 15:04:50 -0500
Received: from mail-pl1-x662.google.com (mail-pl1-x662.google.com [IPv6:2607:f8b0:4864:20::662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7F7C061763
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 12:04:50 -0800 (PST)
Received: by mail-pl1-x662.google.com with SMTP id u15so5831636ple.2
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 12:04:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:mime-version:references
         :in-reply-to:from:date:message-id:subject:to:cc;
        bh=64TeOckiIOlsQMyhELJYoKH6clLYhhm5T/EofrW5BDg=;
        b=oCw57K3f09NJamqipqTtiZCdPwK9TDgAokBtJWhqV4x/t7hRqglY6+k81hya2M3GfJ
         NHcHV0GFIQnWy6pSY/8KnvL6XVlggqUw5yX5q8LEL8ffZ3sqkSPMKO//hIPSEINZqtvS
         ZxWNRUWy0qAeYFiYm1UhaeREZTvuoqKmro/L1yFU4NWFTx7qFdB32HbBCe0MIUlp/J2O
         T8gL10lVCRIKWs9sySkv/KLEtYSbFE5OlHPFvJ6tKvdEUKylHVqSGOw0t/kzUurAxmE3
         sq2H4fK17y9812S1EKGlTL9T4kEJ9DcXHzrL99OQcl/p3lBvr5KquCJ1t8HKd1f8F1vh
         NOZw==
X-Gm-Message-State: AOAM530YND/6F61ItHLyzi/nRVHfhfPtvdBcumO7ztaItAqu7mYXkOZR
        J3QsSPkhTaoAuZqBOTnu10GUxWXnBydNaQ/e9DmDIMI3o9Jueg==
X-Google-Smtp-Source: ABdhPJyzsxGVQljZsYTRPNnNiDYjRSV0O1Ron/Ye9i1dHoMaZBmJL0sbzlJqT1a84f1ueS8y64/JfSFgOD9a
X-Received: by 2002:a17:902:7c05:b0:149:a3b4:934c with SMTP id x5-20020a1709027c0500b00149a3b4934cmr1098916pll.42.1642017889693;
        Wed, 12 Jan 2022 12:04:49 -0800 (PST)
Received: from netskope.com ([163.116.131.7])
        by smtp-relay.gmail.com with ESMTPS id na11sm241219pjb.3.2022.01.12.12.04.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 12:04:49 -0800 (PST)
X-Relaying-Domain: riotgames.com
Received: by mail-pj1-f70.google.com with SMTP id j5-20020a17090a738500b001b33f47e757so4116737pjg.5
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 12:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=64TeOckiIOlsQMyhELJYoKH6clLYhhm5T/EofrW5BDg=;
        b=lgmC5Fs1Hbkpvm6i9Sn7DVbkM8qZaYjg+WbujUpJqphSSEtI10x8XtCPuHvvAsNHjK
         xEUN9l85F9F2W56oVyGbeJxomRWNBBXuO/uyryWlPg6UfvFFiFqbTtraH7CZMgy0IYR4
         cdjEAYBQm+5l7Ac64gyncY1wnAo1uT86spIG0=
X-Received: by 2002:a17:902:7c09:b0:148:e02f:176b with SMTP id x9-20020a1709027c0900b00148e02f176bmr1375061pll.130.1642017888477;
        Wed, 12 Jan 2022 12:04:48 -0800 (PST)
X-Received: by 2002:a17:902:7c09:b0:148:e02f:176b with SMTP id
 x9-20020a1709027c0900b00148e02f176bmr1375042pll.130.1642017888123; Wed, 12
 Jan 2022 12:04:48 -0800 (PST)
MIME-Version: 1.0
References: <cover.1641641663.git.lorenzo@kernel.org> <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
 <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
 <Yd8bVIcA18KIH6+I@lore-desk> <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com> <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Wed, 12 Jan 2022 12:04:36 -0800
Message-ID: <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
x-netskope-inspected: true
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 11:47 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jan 12, 2022 at 11:21 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Jan 12, 2022 at 11:17 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Jan 12, 2022 at 10:24 AM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Wed, Jan 12, 2022 at 10:18 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > > >
> > > > > > On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > > > > >
> > > > > > > Introduce support for the following SEC entries for XDP multi-buff
> > > > > > > property:
> > > > > > > - SEC("xdp_mb/")
> > > > > > > - SEC("xdp_devmap_mb/")
> > > > > > > - SEC("xdp_cpumap_mb/")
> > > > > >
> > > > > > Libbpf seemed to went with .<suffix> rule (e.g., fentry.s for
> > > > > > sleepable, seems like we'll have kprobe.multi or  something along
> > > > > > those lines as well), so let's stay consistent and call this "xdp_mb",
> > > > > > "xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really all that
> > > > > > recognizable? would ".multibuf" be too verbose?). Also, why the "/"
> > > > > > part? Also it shouldn't be "sloppy" either. Neither expected attach
> > > > > > type should be optional.  Also not sure SEC_ATTACHABLE is needed. So
> > > > > > at most it should be SEC_XDP_MB, probably.
> > > > >
> > > > > ack, I fine with it. Something like:
> > > > >
> > > > >         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
> > > > >         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
> > > > >         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > > > > +       SEC_DEF("xdp_devmap.multibuf",  XDP, BPF_XDP_DEVMAP, 0),
> > > > >         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> > > > > +       SEC_DEF("xdp_cpumap.multibuf",  XDP, BPF_XDP_CPUMAP, 0),
> > > > >         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> > > > > +       SEC_DEF("xdp.multibuf",         XDP, BPF_XDP, 0),
> > > >
> > > > yep, but please use SEC_NONE instead of zero
> > > >
> > > > >         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
> > > > >         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
> > > > >         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
> > > > >
> > > > > >
> > > > > > >
> > > > > > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > > > > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > > ---
> > > > > > >  tools/lib/bpf/libbpf.c | 8 ++++++++
> > > > > > >  1 file changed, 8 insertions(+)
> > > > > > >
> > > > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > > > > index 7f10dd501a52..c93f6afef96c 100644
> > > > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > > > @@ -235,6 +235,8 @@ enum sec_def_flags {
> > > > > > >         SEC_SLEEPABLE = 8,
> > > > > > >         /* allow non-strict prefix matching */
> > > > > > >         SEC_SLOPPY_PFX = 16,
> > > > > > > +       /* BPF program support XDP multi-buff */
> > > > > > > +       SEC_XDP_MB = 32,
> > > > > > >  };
> > > > > > >
> > > > > > >  struct bpf_sec_def {
> > > > > > > @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
> > > > > > >         if (def & SEC_SLEEPABLE)
> > > > > > >                 opts->prog_flags |= BPF_F_SLEEPABLE;
> > > > > > >
> > > > > > > +       if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
> > > > > > > +               opts->prog_flags |= BPF_F_XDP_MB;
> > > > > >
> > > > > > I'd say you don't even need SEC_XDP_MB flag at all, you can just check
> > > > > > that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
> > > > > > "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem generic
> > > > > > enough to warrant a flag.
> > > > >
> > > > > ack, something like:
> > > > >
> > > > > +       if (prog->type == BPF_PROG_TYPE_XDP &&
> > > > > +           (!strcmp(prog->sec_name, "xdp_devmap.multibuf") ||
> > > > > +            !strcmp(prog->sec_name, "xdp_cpumap.multibuf") ||
> > > > > +            !strcmp(prog->sec_name, "xdp.multibuf")))
> > > > > +               opts->prog_flags |= BPF_F_XDP_MB;
> > > >
> > > > yep, can also simplify it a bit with strstr(prog->sec_name,
> > > > ".multibuf") instead of three strcmp
> > >
> > > Maybe ".mb" ?
> > > ".multibuf" is too verbose.
> > > We're fine with ".s" for sleepable :)
> >
> >
> > I had reservations about "mb" because the first and strong association
> > is "megabyte", not "multibuf". And it's not like anyone would have
> > tens of those programs in a single file so that ".multibuf" becomes
> > way too verbose. But I don't feel too strongly about this, if the
> > consensus is on ".mb".
>
> The rest of the patches are using _mb everywhere.
> I would keep libbpf consistent.

Should the rest of the patches maybe use "multibuf" instead of "mb"? I've been
following this patch series closely and excitedly, and I keep having to remind
myself that "mb" is "multibuff" and not "megabyte". If I'm having to correct
myself while following the patch series, I'm wondering if future confusion is
inevitable?

But, is it enough confusion to be worth updating many other patches? I'm not
sure.

I agree consistency is more important than the specific term we're consistent
on.

--Zvi
