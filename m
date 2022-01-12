Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEEF48CBC4
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345214AbiALTVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241961AbiALTVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 14:21:02 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE55C06173F;
        Wed, 12 Jan 2022 11:21:00 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id r16so3369483ile.8;
        Wed, 12 Jan 2022 11:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mbIdVFwDdEDm9VgrSp8imN1y3sdVv8K2KsXUSowezwI=;
        b=oiR/zGz7KU3ArFilrA3ScSpITPhyKs9ySvel65QwpA5+KRMkfS9+62CFyZj+xFCRfR
         ehf7b5p0VnpSJIn9jcTNnzhI1x7J4xfumhdsSQo9VEgTYdIfcwZ8BxnzGJJ2SvRw48M8
         IFWVzaIT/Oravp2rsStLiFyywa0KjFbXWAIydSs1W5NQJgcuM+hUf/QWl4nwvhd4APKx
         Di5hnKPF+IpEtCOGKFs8JkBaguAWc7mf2MtG4aBMto7CBMH+6YX51aZvtiD2KkjhA9Y+
         squADoQaOIvxxZKBOHiG7db35XFCzZGF79Ozrl+beIOsddHw5R0O3Jiq/sWu59hfhxKb
         HcwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mbIdVFwDdEDm9VgrSp8imN1y3sdVv8K2KsXUSowezwI=;
        b=twN8HZ32L1q1Wv2INlnOGceddvKglhQSgGSq3SokBK/bUby+fn26kUoPGHiBqIiVA/
         hDrwH4+5XXTyHTfAAwWH03xTys3A+h0d0rZtefptxUuEDem34sorntUFm+ofSO8aP80k
         FATxiGbS2FXyoGqMEPjje/L4y5P0ZIO6Xicortwk1r6nxKTjE7khu20UxcAfwpbER4+R
         QJRsFpw317qQ8oj0xLrjpT9z3tRX99t8Y/f2nmRQwoham4wOr+ml4vwLsbUq1VY4Rr5b
         HatfHwSqr/9qJAvDZal/RUsOgUJwkMCT2I119c21+Bozm7RoDIHwjgc8e/f9cSWxFM7x
         0ZrA==
X-Gm-Message-State: AOAM531FMQiD0Kti5yFA/M0D9R3zvPx6CyZMfmV5JYnzWdM2pPxUzFaK
        37tk+QoZUcr8e/X4IJe7YvDwrtPcAh7tFAuybuhapJM9
X-Google-Smtp-Source: ABdhPJxTh7GGXXYOFF5KBx/gQv40wTuNBU/6r/v8nkVb5jNENEjwuPwCbo7k2Ix/17xJje7nz2UILRGFvGWuUK2Gt5U=
X-Received: by 2002:a05:6e02:1a24:: with SMTP id g4mr692391ile.71.1642015260327;
 Wed, 12 Jan 2022 11:21:00 -0800 (PST)
MIME-Version: 1.0
References: <cover.1641641663.git.lorenzo@kernel.org> <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
 <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
 <Yd8bVIcA18KIH6+I@lore-desk> <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
In-Reply-To: <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Jan 2022 11:20:48 -0800
Message-ID: <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 11:17 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jan 12, 2022 at 10:24 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Jan 12, 2022 at 10:18 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
> > > > On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > > >
> > > > > Introduce support for the following SEC entries for XDP multi-buff
> > > > > property:
> > > > > - SEC("xdp_mb/")
> > > > > - SEC("xdp_devmap_mb/")
> > > > > - SEC("xdp_cpumap_mb/")
> > > >
> > > > Libbpf seemed to went with .<suffix> rule (e.g., fentry.s for
> > > > sleepable, seems like we'll have kprobe.multi or  something along
> > > > those lines as well), so let's stay consistent and call this "xdp_mb",
> > > > "xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really all that
> > > > recognizable? would ".multibuf" be too verbose?). Also, why the "/"
> > > > part? Also it shouldn't be "sloppy" either. Neither expected attach
> > > > type should be optional.  Also not sure SEC_ATTACHABLE is needed. So
> > > > at most it should be SEC_XDP_MB, probably.
> > >
> > > ack, I fine with it. Something like:
> > >
> > >         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
> > >         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
> > >         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > > +       SEC_DEF("xdp_devmap.multibuf",  XDP, BPF_XDP_DEVMAP, 0),
> > >         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> > > +       SEC_DEF("xdp_cpumap.multibuf",  XDP, BPF_XDP_CPUMAP, 0),
> > >         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> > > +       SEC_DEF("xdp.multibuf",         XDP, BPF_XDP, 0),
> >
> > yep, but please use SEC_NONE instead of zero
> >
> > >         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
> > >         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
> > >         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
> > >
> > > >
> > > > >
> > > > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > ---
> > > > >  tools/lib/bpf/libbpf.c | 8 ++++++++
> > > > >  1 file changed, 8 insertions(+)
> > > > >
> > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > > index 7f10dd501a52..c93f6afef96c 100644
> > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > @@ -235,6 +235,8 @@ enum sec_def_flags {
> > > > >         SEC_SLEEPABLE = 8,
> > > > >         /* allow non-strict prefix matching */
> > > > >         SEC_SLOPPY_PFX = 16,
> > > > > +       /* BPF program support XDP multi-buff */
> > > > > +       SEC_XDP_MB = 32,
> > > > >  };
> > > > >
> > > > >  struct bpf_sec_def {
> > > > > @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
> > > > >         if (def & SEC_SLEEPABLE)
> > > > >                 opts->prog_flags |= BPF_F_SLEEPABLE;
> > > > >
> > > > > +       if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
> > > > > +               opts->prog_flags |= BPF_F_XDP_MB;
> > > >
> > > > I'd say you don't even need SEC_XDP_MB flag at all, you can just check
> > > > that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
> > > > "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem generic
> > > > enough to warrant a flag.
> > >
> > > ack, something like:
> > >
> > > +       if (prog->type == BPF_PROG_TYPE_XDP &&
> > > +           (!strcmp(prog->sec_name, "xdp_devmap.multibuf") ||
> > > +            !strcmp(prog->sec_name, "xdp_cpumap.multibuf") ||
> > > +            !strcmp(prog->sec_name, "xdp.multibuf")))
> > > +               opts->prog_flags |= BPF_F_XDP_MB;
> >
> > yep, can also simplify it a bit with strstr(prog->sec_name,
> > ".multibuf") instead of three strcmp
>
> Maybe ".mb" ?
> ".multibuf" is too verbose.
> We're fine with ".s" for sleepable :)


I had reservations about "mb" because the first and strong association
is "megabyte", not "multibuf". And it's not like anyone would have
tens of those programs in a single file so that ".multibuf" becomes
way too verbose. But I don't feel too strongly about this, if the
consensus is on ".mb".
