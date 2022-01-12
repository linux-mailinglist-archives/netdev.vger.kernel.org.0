Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D439A48CC49
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350158AbiALTrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350145AbiALTrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 14:47:48 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4256CC06173F;
        Wed, 12 Jan 2022 11:47:47 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so7161277pjp.0;
        Wed, 12 Jan 2022 11:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zkfG4jRc5wH/qs7fQZkcQpvUz3YW7dIUvtRjFq7VLhY=;
        b=Qbm0NWgPDtzxb5/6mvailwmzY7JgjRlIfRd9bGgRnxYSxIwYMUHUzumBMHAGNBbkbB
         aWif7nG3aNoT5b4c+qKjQdbW8mTu3mBThsM6lsdvXt4aYOrN/T2tluM2IVn43a2clA9G
         w5lENezESgtiAASYrxMoVtvjQ6Lb/LPl/wH36LWfPgCOmLKkz4rzaqRKgPiVtBosVS3o
         mQ+28/EXb9+QjwshI27/TYltk8bC8/3fnGIoqOxDRLGI/h9D5UjKNLSptCPuPRmoZb+E
         Ax/ehC3Lbu1eHmalYLnEgA+FB5u93nieVx+nX2boI+FjCtuK7hBhp46RNBC2bCjyEJMV
         JKyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zkfG4jRc5wH/qs7fQZkcQpvUz3YW7dIUvtRjFq7VLhY=;
        b=IXivdQj9lL/9JFRPIJ5diDcjNzSn5rHc6feLIzuKf50+06yOR93Pc7l109D72TM1kn
         J8PdN5B5ymBRkjElBmGnu2EHIQ3n3CFlTSKW6oRla7wBlCjfFyrvXq6ORTmB2AcVftB6
         ZDmhYF0FcqN0e1ZSjedkNB2mgY3BMM73d3km1kcqGdIZP2ZkzNnQtRitL80nM+pko+rc
         WPxw933lG2AMEYXHWaoTmDBnpbyzJQC+YO8dFsj4w0PNCLnpVThGPhf+G9UEdq/67xoV
         R/y3V/SEeOhQUvRtn0Wa+jvsCw+Ob1Jw+bEgh9aWzuEFJmTyhzWAbYHTMHQJ3r6xmFmT
         gviw==
X-Gm-Message-State: AOAM533G4DaGcNXEdzM/Wxm5zNVd+OOxJgVVKb+jgS3URLv59Bl58x1c
        +i8ZzlKfPqYPpYA4S9p1ecLJzE3OvGgJay2muvgmYkwx
X-Google-Smtp-Source: ABdhPJxKM5AeUyHnUzJhZT4QYKSuZ+nbTXypQZ5piDMsfqk02EGBAZ9KAc5R0eCoRpR+fwFwTC6uqdYFeDGFh6z4iI0=
X-Received: by 2002:a63:1ca:: with SMTP id 193mr986270pgb.497.1642016866712;
 Wed, 12 Jan 2022 11:47:46 -0800 (PST)
MIME-Version: 1.0
References: <cover.1641641663.git.lorenzo@kernel.org> <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
 <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
 <Yd8bVIcA18KIH6+I@lore-desk> <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com> <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
In-Reply-To: <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Jan 2022 11:47:35 -0800
Message-ID: <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Wed, Jan 12, 2022 at 11:21 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jan 12, 2022 at 11:17 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Jan 12, 2022 at 10:24 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Wed, Jan 12, 2022 at 10:18 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > >
> > > > > On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > > > >
> > > > > > Introduce support for the following SEC entries for XDP multi-buff
> > > > > > property:
> > > > > > - SEC("xdp_mb/")
> > > > > > - SEC("xdp_devmap_mb/")
> > > > > > - SEC("xdp_cpumap_mb/")
> > > > >
> > > > > Libbpf seemed to went with .<suffix> rule (e.g., fentry.s for
> > > > > sleepable, seems like we'll have kprobe.multi or  something along
> > > > > those lines as well), so let's stay consistent and call this "xdp_mb",
> > > > > "xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really all that
> > > > > recognizable? would ".multibuf" be too verbose?). Also, why the "/"
> > > > > part? Also it shouldn't be "sloppy" either. Neither expected attach
> > > > > type should be optional.  Also not sure SEC_ATTACHABLE is needed. So
> > > > > at most it should be SEC_XDP_MB, probably.
> > > >
> > > > ack, I fine with it. Something like:
> > > >
> > > >         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
> > > >         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
> > > >         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > > > +       SEC_DEF("xdp_devmap.multibuf",  XDP, BPF_XDP_DEVMAP, 0),
> > > >         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> > > > +       SEC_DEF("xdp_cpumap.multibuf",  XDP, BPF_XDP_CPUMAP, 0),
> > > >         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> > > > +       SEC_DEF("xdp.multibuf",         XDP, BPF_XDP, 0),
> > >
> > > yep, but please use SEC_NONE instead of zero
> > >
> > > >         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
> > > >         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
> > > >         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
> > > >
> > > > >
> > > > > >
> > > > > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > > > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > ---
> > > > > >  tools/lib/bpf/libbpf.c | 8 ++++++++
> > > > > >  1 file changed, 8 insertions(+)
> > > > > >
> > > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > > > index 7f10dd501a52..c93f6afef96c 100644
> > > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > > @@ -235,6 +235,8 @@ enum sec_def_flags {
> > > > > >         SEC_SLEEPABLE = 8,
> > > > > >         /* allow non-strict prefix matching */
> > > > > >         SEC_SLOPPY_PFX = 16,
> > > > > > +       /* BPF program support XDP multi-buff */
> > > > > > +       SEC_XDP_MB = 32,
> > > > > >  };
> > > > > >
> > > > > >  struct bpf_sec_def {
> > > > > > @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
> > > > > >         if (def & SEC_SLEEPABLE)
> > > > > >                 opts->prog_flags |= BPF_F_SLEEPABLE;
> > > > > >
> > > > > > +       if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
> > > > > > +               opts->prog_flags |= BPF_F_XDP_MB;
> > > > >
> > > > > I'd say you don't even need SEC_XDP_MB flag at all, you can just check
> > > > > that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
> > > > > "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem generic
> > > > > enough to warrant a flag.
> > > >
> > > > ack, something like:
> > > >
> > > > +       if (prog->type == BPF_PROG_TYPE_XDP &&
> > > > +           (!strcmp(prog->sec_name, "xdp_devmap.multibuf") ||
> > > > +            !strcmp(prog->sec_name, "xdp_cpumap.multibuf") ||
> > > > +            !strcmp(prog->sec_name, "xdp.multibuf")))
> > > > +               opts->prog_flags |= BPF_F_XDP_MB;
> > >
> > > yep, can also simplify it a bit with strstr(prog->sec_name,
> > > ".multibuf") instead of three strcmp
> >
> > Maybe ".mb" ?
> > ".multibuf" is too verbose.
> > We're fine with ".s" for sleepable :)
>
>
> I had reservations about "mb" because the first and strong association
> is "megabyte", not "multibuf". And it's not like anyone would have
> tens of those programs in a single file so that ".multibuf" becomes
> way too verbose. But I don't feel too strongly about this, if the
> consensus is on ".mb".

The rest of the patches are using _mb everywhere.
I would keep libbpf consistent.
