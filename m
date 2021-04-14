Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8289335FDB9
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 00:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhDNWXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 18:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbhDNWXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 18:23:05 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7049FC061574;
        Wed, 14 Apr 2021 15:22:43 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id k73so17607726ybf.3;
        Wed, 14 Apr 2021 15:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DBrFNOxaMA/7ZTSjVDCpN1Cf8EPs2BVUIE7dJq/XIFY=;
        b=ZASmmu9cCOp0GLby5ge3ySdPHTyYlhTYWt0JOSAB6sZncJ1s1rnPPV+Mz2oZu8G3RO
         bofdF4GlF/hbrO6Pa8d8VSjD+SX1THore3s/+xPaX2IlCEsbfN2SeVI66YR+B0U1gq5G
         +52Qm55upbNs438HLYAax2yyCTikl2QkUb+Czg9yNGHKGFhjgxxOuBWWgbV8A76UfTED
         SMk6If6tUFDT/uK8qBGYwQAVQWIA8NpOGqFptgfKRuCfVZ2XA6hFOlf5tCm8yWhrNmfU
         IlE0XtimzWMa5zTqoZqYJPxhcRX2r9GSW6eGv0YG2ED5ES9mJ2zyS11Kvkk0LFn+alBr
         F7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DBrFNOxaMA/7ZTSjVDCpN1Cf8EPs2BVUIE7dJq/XIFY=;
        b=btySjORW4rvDYnJJ+ULu94FixVQDWqRGpucq1W3CNtjWgvYUsttQSxKiQUjiqiVJhi
         osnCmwLOrDoLcC5dzFMDPSnuAwt3te+8ucs/Iryf/+E8f4zlTfMJ5nhSowx7BC1KQ/kj
         pYClPRL7GkzZgFOpVmKpdaxNhgc3hvGF/zSjJV2KgexXvb1EbVMznOeAAvybp4nSgw9t
         fnC7NVt8JHC/vmjrwQ0v+rYMxUV2laHu0PqAnyPrUNEtA0TbM9ZE7XKaq30P1LSeeRgK
         Izot/nJ9gzQH4qhTUHxTQ0Xs5uDH/XWgFWGT3udrTCUuZxfCT9Je15BnnyX2D6RbJwfA
         qn5Q==
X-Gm-Message-State: AOAM531VMXMfKGV9hTAqFbuLd1IBxD5pyNJ8Ymzzw5Ryb+zQJFZHVpu+
        Y3VtPe8z91YI4jqdiU4j8gRJTnkTCP4GVD7Ha/U=
X-Google-Smtp-Source: ABdhPJxiog5q4JCineo0XCm6gpjbEOo7LKP6Kpc65ooTrU3BbGB4xCtX26vFc3CxiwdhgRLIApa7JjZICSStXX5WWzQ=
X-Received: by 2002:a25:becd:: with SMTP id k13mr222090ybm.459.1618438962678;
 Wed, 14 Apr 2021 15:22:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-4-memxor@gmail.com> <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo> <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net> <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net> <20210402152743.dbadpgcmrgjt4eca@apollo>
 <CAADnVQ+wqrEnOGd8E1yp+1WTAx8ZcAx3HUjJs6ipPd0eKmOrgA@mail.gmail.com>
 <20210402190806.nhcgappm3iocvd3d@apollo> <20210403174721.vg4wle327wvossgl@ast-mbp>
 <CAEf4Bzaeu4apgEtwS_3q1iPuURjPXMs9H43cYUtJSmjPMU5M9A@mail.gmail.com>
 <87blar4ti7.fsf@toke.dk> <CAEf4BzaOJ-WD3A13B2uCrsE2yrctAL8QtJ8TuXHLeP+tm98pbA@mail.gmail.com>
 <874kg9m8t1.fsf@toke.dk>
In-Reply-To: <874kg9m8t1.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Apr 2021 15:22:31 -0700
Message-ID: <CAEf4BzaEkzPeAXqmm5aEdQxnCkrqJTHcSu7afnV11+697KgZTQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Apr 6, 2021 at 3:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Sat, Apr 3, 2021 at 10:47 AM Alexei Starovoitov
> >> > <alexei.starovoitov@gmail.com> wrote:
> >> >>
> >> >> On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwivedi w=
rote:
> >> >> > On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov wrote:
> >> >> > > On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memxor@=
gmail.com> wrote:
> >> >> > > > [...]
> >> >> > >
> >> >> > > All of these things are messy because of tc legacy. bpf tried t=
o follow tc style
> >> >> > > with cls and act distinction and it didn't quite work. cls with
> >> >> > > direct-action is the only
> >> >> > > thing that became mainstream while tc style attach wasn't reall=
y addressed.
> >> >> > > There were several incidents where tc had tens of thousands of =
progs attached
> >> >> > > because of this attach/query/index weirdness described above.
> >> >> > > I think the only way to address this properly is to introduce b=
pf_link style of
> >> >> > > attaching to tc. Such bpf_link would support ingress/egress onl=
y.
> >> >> > > direction-action will be implied. There won't be any index and =
query
> >> >> > > will be obvious.
> >> >> >
> >> >> > Note that we already have bpf_link support working (without suppo=
rt for pinning
> >> >> > ofcourse) in a limited way. The ifindex, protocol, parent_id, pri=
ority, handle,
> >> >> > chain_index tuple uniquely identifies a filter, so we stash this =
in the bpf_link
> >> >> > and are able to operate on the exact filter during release.
> >> >>
> >> >> Except they're not unique. The library can stash them, but somethin=
g else
> >> >> doing detach via iproute2 or their own netlink calls will detach th=
e prog.
> >> >> This other app can attach to the same spot a different prog and now
> >> >> bpf_link__destroy will be detaching somebody else prog.
> >> >>
> >> >> > > So I would like to propose to take this patch set a step furthe=
r from
> >> >> > > what Daniel said:
> >> >> > > int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
> >> >> > > and make this proposed api to return FD.
> >> >> > > To detach from tc ingress/egress just close(fd).
> >> >> >
> >> >> > You mean adding an fd-based TC API to the kernel?
> >> >>
> >> >> yes.
> >> >
> >> > I'm totally for bpf_link-based TC attachment.
> >> >
> >> > But I think *also* having "legacy" netlink-based APIs will allow
> >> > applications to handle older kernels in a much nicer way without ext=
ra
> >> > dependency on iproute2. We have a similar situation with kprobe, whe=
re
> >> > currently libbpf only supports "modern" fd-based attachment, but use=
rs
> >> > periodically ask questions and struggle to figure out issues on olde=
r
> >> > kernels that don't support new APIs.
> >>
> >> +1; I am OK with adding a new bpf_link-based way to attach TC programs=
,
> >> but we still need to support the netlink API in libbpf.
> >>
> >> > So I think we'd have to support legacy TC APIs, but I agree with
> >> > Alexei and Daniel that we should keep it to the simplest and most
> >> > straightforward API of supporting direction-action attachments and
> >> > setting up qdisc transparently (if I'm getting all the terminology
> >> > right, after reading Quentin's blog post). That coincidentally shoul=
d
> >> > probably match how bpf_link-based TC API will look like, so all that
> >> > can be abstracted behind a single bpf_link__attach_tc() API as well,
> >> > right? That's the plan for dealing with kprobe right now, btw. Libbp=
f
> >> > will detect the best available API and transparently fall back (mayb=
e
> >> > with some warning for awareness, due to inherent downsides of legacy
> >> > APIs: no auto-cleanup being the most prominent one).
> >>
> >> Yup, SGTM: Expose both in the low-level API (in bpf.c), and make the
> >> high-level API auto-detect. That way users can also still use the
> >> netlink attach function if they don't want the fd-based auto-close
> >> behaviour of bpf_link.
> >
> > So I thought a bit more about this, and it feels like the right move
> > would be to expose only higher-level TC BPF API behind bpf_link. It
> > will keep the API complexity and amount of APIs that libbpf will have
> > to support to the minimum, and will keep the API itself simple:
> > direct-attach with the minimum amount of input arguments. By not
> > exposing low-level APIs we also table the whole bpf_tc_cls_attach_id
> > design discussion, as we now can keep as much info as needed inside
> > bpf_link_tc (which will embed bpf_link internally as well) to support
> > detachment and possibly some additional querying, if needed.
>
> But then there would be no way for the caller to explicitly select a
> mechanism? I.e., if I write a BPF program using this mechanism targeting
> a 5.12 kernel, I'll get netlink attachment, which can stick around when
> I do bpf_link__disconnect(). But then if the kernel gets upgraded to
> support bpf_link for TC programs I'll suddenly transparently get
> bpf_link and the attachments will go away unless I pin them. This
> seems... less than ideal?

That's what we are doing with bpf_program__attach_kprobe(), though.
And so far I've only seen people (privately) saying how good it would
be to have bpf_link-based TC APIs, doesn't seem like anyone with a
realistic use case prefers the current APIs. So I suspect it's not
going to be a problem in practice. But at least I'd start there and
see how people are using it and if they need anything else.


>
> If we expose the low-level API I can elect to just use this if I know I
> want netlink behaviour, but if bpf_program__attach_tc() is the only API
> available it would at least need a flag to enforce one mode or the other
> (I can see someone wanting to enforce kernel bpf_link semantics as well,
> so a flag for either mode seems reasonable?).

Sophisticated enough users can also do feature detection to know if
it's going to work or not. There are many ways to skin this cat. I'd
prioritize bpf_link-based TC APIs to be added with legacy TC API as a
fallback.

>
> -Toke
>
