Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586AC48CE33
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiALWFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:05:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229562AbiALWFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:05:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642025101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vj/JjjjjtW+vABd5/EQjNU1tF2VEAkq+b64gZeNi07o=;
        b=QyDBLhXKQEQL5w1lvsjVTan8+3MiqAbC84Xvpj+xyq1hQytlON+9bLCHQDVxDMxqhJr+YI
        DC3c4uFfY/ImWHooMIwOjtTaBobME+qnMtDgkj685pT3p4rsRvA7M/lT27d7wi1NuOkmnx
        QuO5gsYqKJGfPFvEBIU161gEDXA50Yw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-loXnY9PvNBmSvrSxcgeFSQ-1; Wed, 12 Jan 2022 17:04:59 -0500
X-MC-Unique: loXnY9PvNBmSvrSxcgeFSQ-1
Received: by mail-ed1-f69.google.com with SMTP id o20-20020a056402439400b003f83cf1e472so3474464edc.18
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:04:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Vj/JjjjjtW+vABd5/EQjNU1tF2VEAkq+b64gZeNi07o=;
        b=Fc5t3TfJfAk8B70zowGtXkykc8JPiFm/EkKcY6xpl+XlR+RnM46Qbs5zxHvJazaNiD
         8khZhONC9TzqlpuKF2mrfSdcZuJv97RgH16cVC3mm0myrHPFzszcNix8US5vh5ByaeXm
         hcTpemWkku/Y07xc8gvY/QQLyKI62jO2TV0+rN3JRLRQpSnQElSl4Sy6UvRf070xUUy6
         UUnXutU/2mQrpmjc5IZ93naZmAJC4DtbQqmmSFzGpY7ufWmakLYVdc3Bx9HTQBuB8kM+
         3ePOZTePJjLjjvoBwH5xzoH+wAeiRszifcYt4u+ydRPaMgA8fZ1JyekpZK/2W3BFD536
         RKYQ==
X-Gm-Message-State: AOAM530kPM+SfQqrB30SxUiEoyvtuLTLYWjIXvybPvzoG/wh98ZSOH4I
        YRzDd/aIQB/qo9EMQRGYgnYSZOgZPZyt1EKGIcR8mZsP8+azHkhbU5UWS1/UuJ6/kkFiKpOhc0L
        EshdaeoiQ2u7R+y9D
X-Received: by 2002:a05:6402:22d2:: with SMTP id dm18mr639211edb.410.1642025098105;
        Wed, 12 Jan 2022 14:04:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXJbMa1ILQCIyYSHsZZt5DmjeICi3M6tZjtTstvCMe4mxyXdv6+tHudLOdLDt5blgTqBChwg==
X-Received: by 2002:a05:6402:22d2:: with SMTP id dm18mr639185edb.410.1642025097704;
        Wed, 12 Jan 2022 14:04:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j4sm381760edk.64.2022.01.12.14.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 14:04:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 91BA21802BD; Wed, 12 Jan 2022 23:04:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Zvi Effron <zeffron@riotgames.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
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
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb
 programs
In-Reply-To: <Yd82J8vxSAR9tvQt@lore-desk>
References: <cover.1641641663.git.lorenzo@kernel.org>
 <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
 <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
 <Yd8bVIcA18KIH6+I@lore-desk>
 <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 12 Jan 2022 23:04:55 +0100
Message-ID: <8735lshapk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> On Wed, Jan 12, 2022 at 11:47 AM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>> >
>> > On Wed, Jan 12, 2022 at 11:21 AM Andrii Nakryiko
>> > <andrii.nakryiko@gmail.com> wrote:
>> > >
>> > > On Wed, Jan 12, 2022 at 11:17 AM Alexei Starovoitov
>> > > <alexei.starovoitov@gmail.com> wrote:
>> > > >
>> > > > On Wed, Jan 12, 2022 at 10:24 AM Andrii Nakryiko
>> > > > <andrii.nakryiko@gmail.com> wrote:
>> > > > >
>> > > > > On Wed, Jan 12, 2022 at 10:18 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>> > > > > >
>> > > > > > > On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>> > > > > > > >
>> > > > > > > > Introduce support for the following SEC entries for XDP multi-buff
>> > > > > > > > property:
>> > > > > > > > - SEC("xdp_mb/")
>> > > > > > > > - SEC("xdp_devmap_mb/")
>> > > > > > > > - SEC("xdp_cpumap_mb/")
>> > > > > > >
>> > > > > > > Libbpf seemed to went with .<suffix> rule (e.g., fentry.s for
>> > > > > > > sleepable, seems like we'll have kprobe.multi or  something along
>> > > > > > > those lines as well), so let's stay consistent and call this "xdp_mb",
>> > > > > > > "xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really all that
>> > > > > > > recognizable? would ".multibuf" be too verbose?). Also, why the "/"
>> > > > > > > part? Also it shouldn't be "sloppy" either. Neither expected attach
>> > > > > > > type should be optional.  Also not sure SEC_ATTACHABLE is needed. So
>> > > > > > > at most it should be SEC_XDP_MB, probably.
>> > > > > >
>> > > > > > ack, I fine with it. Something like:
>> > > > > >
>> > > > > >         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
>> > > > > >         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
>> > > > > >         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
>> > > > > > +       SEC_DEF("xdp_devmap.multibuf",  XDP, BPF_XDP_DEVMAP, 0),
>> > > > > >         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
>> > > > > > +       SEC_DEF("xdp_cpumap.multibuf",  XDP, BPF_XDP_CPUMAP, 0),
>> > > > > >         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
>> > > > > > +       SEC_DEF("xdp.multibuf",         XDP, BPF_XDP, 0),
>> > > > >
>> > > > > yep, but please use SEC_NONE instead of zero
>> > > > >
>> > > > > >         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
>> > > > > >         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
>> > > > > >         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
>> > > > > >
>> > > > > > >
>> > > > > > > >
>> > > > > > > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
>> > > > > > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
>> > > > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> > > > > > > > ---
>> > > > > > > >  tools/lib/bpf/libbpf.c | 8 ++++++++
>> > > > > > > >  1 file changed, 8 insertions(+)
>> > > > > > > >
>> > > > > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> > > > > > > > index 7f10dd501a52..c93f6afef96c 100644
>> > > > > > > > --- a/tools/lib/bpf/libbpf.c
>> > > > > > > > +++ b/tools/lib/bpf/libbpf.c
>> > > > > > > > @@ -235,6 +235,8 @@ enum sec_def_flags {
>> > > > > > > >         SEC_SLEEPABLE = 8,
>> > > > > > > >         /* allow non-strict prefix matching */
>> > > > > > > >         SEC_SLOPPY_PFX = 16,
>> > > > > > > > +       /* BPF program support XDP multi-buff */
>> > > > > > > > +       SEC_XDP_MB = 32,
>> > > > > > > >  };
>> > > > > > > >
>> > > > > > > >  struct bpf_sec_def {
>> > > > > > > > @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
>> > > > > > > >         if (def & SEC_SLEEPABLE)
>> > > > > > > >                 opts->prog_flags |= BPF_F_SLEEPABLE;
>> > > > > > > >
>> > > > > > > > +       if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
>> > > > > > > > +               opts->prog_flags |= BPF_F_XDP_MB;
>> > > > > > >
>> > > > > > > I'd say you don't even need SEC_XDP_MB flag at all, you can just check
>> > > > > > > that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
>> > > > > > > "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem generic
>> > > > > > > enough to warrant a flag.
>> > > > > >
>> > > > > > ack, something like:
>> > > > > >
>> > > > > > +       if (prog->type == BPF_PROG_TYPE_XDP &&
>> > > > > > +           (!strcmp(prog->sec_name, "xdp_devmap.multibuf") ||
>> > > > > > +            !strcmp(prog->sec_name, "xdp_cpumap.multibuf") ||
>> > > > > > +            !strcmp(prog->sec_name, "xdp.multibuf")))
>> > > > > > +               opts->prog_flags |= BPF_F_XDP_MB;
>> > > > >
>> > > > > yep, can also simplify it a bit with strstr(prog->sec_name,
>> > > > > ".multibuf") instead of three strcmp
>> > > >
>> > > > Maybe ".mb" ?
>> > > > ".multibuf" is too verbose.
>> > > > We're fine with ".s" for sleepable :)
>> > >
>> > >
>> > > I had reservations about "mb" because the first and strong association
>> > > is "megabyte", not "multibuf". And it's not like anyone would have
>> > > tens of those programs in a single file so that ".multibuf" becomes
>> > > way too verbose. But I don't feel too strongly about this, if the
>> > > consensus is on ".mb".
>> >
>> > The rest of the patches are using _mb everywhere.
>> > I would keep libbpf consistent.
>> 
>> Should the rest of the patches maybe use "multibuf" instead of "mb"? I've been
>> following this patch series closely and excitedly, and I keep having to remind
>> myself that "mb" is "multibuff" and not "megabyte". If I'm having to correct
>> myself while following the patch series, I'm wondering if future confusion is
>> inevitable?
>> 
>> But, is it enough confusion to be worth updating many other patches? I'm not
>> sure.
>> 
>> I agree consistency is more important than the specific term we're consistent
>> on.
>
> I would prefer to keep the "_mb" postfix, but naming is hard and I am
> polarized :)

I would lean towards keeping _mb as well, but if it does have to be
changed why not _mbuf? At least that's not quite as verbose :)

-Toke

