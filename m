Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C299135EA1C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 02:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348901AbhDNAr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 20:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244071AbhDNAr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 20:47:58 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C9DC061574;
        Tue, 13 Apr 2021 17:47:37 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id k73so13923875ybf.3;
        Tue, 13 Apr 2021 17:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0/P9lZZjXJ/CszjFIIhNWRAfX45tSlTYsX/AsbrNeN4=;
        b=rIIYrrvjQ1SpRKq07eSeBdPMH9JQrJwqTx87hYYT5H8and95ZEKsirFsGqHwhKPvn4
         h5WuXij6D5flPFrjZpVMXEXgIYI73D5iMGSjzdzLSNpO2evy1kUUn06lMpVflgg8H6dA
         /pwEcHxpke8fOprAQ/vgm3LoRGiTaYZcpb3vemjQKWZ8vsk8tW/psH3MvXbb1ux6LQ1F
         yvz16VyE3qPq7e7apB7QIYAsAgM/TFMe/uVO8hA7DgkQUlDlpM6tZuyx3WsZE1lGJAyZ
         3ulIVr1dAn2UsLhx/OiKjft8w4M6ymryAye2iZIVwn3Fgb8zEtMGyb0roT20Qv3IVpBd
         UxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0/P9lZZjXJ/CszjFIIhNWRAfX45tSlTYsX/AsbrNeN4=;
        b=VavhmSaWkzYDmFNiwA9mMrI+JtaG5O37pBx2QK86dHhm3WS84C8sMgVruJPvS+By3M
         Wb/fhgU3e4ze7VFdVQZq8s91RU9e/VK4Y7Pd4CFX2CfIJspZ4PohwzK8Ug8NPRuWI4EW
         HsF47UtUZqkBwN50erlj9eBqjYbp4Meznmsh1WzUg6qI5EIJ6hVgUkn+kdjBcwN6ue7I
         jKCnAFPmdg/lqSKIBa93A/2QkfPMLfqyCaqmuhUxAnyAbxmJ7K32NvwBQm/Esv/IJMqW
         BA9t3khFZuXszECZkfbOcvFhWB21Ycx74uOPhPvrussjjPHtm2q06daHl/vYgm8oF1oA
         l+bQ==
X-Gm-Message-State: AOAM530AkjHkM7hurW3MjYmtBH/bGuH/LKWLWwBE+3JQiiTXhpPOhN89
        5ILx8N9sV9u1UnS2bwyT6hmOBDaDKMiWnDvV5Zc=
X-Google-Smtp-Source: ABdhPJz39cTCT6bGgpYujxQ+0iywOYj1qNtXBQEGiRdosh0G9hclI+6UU2gd0/LL2aEhvlQ5lm81oPjg0WZfboe0q1k=
X-Received: by 2002:a25:9942:: with SMTP id n2mr47962033ybo.230.1618361256845;
 Tue, 13 Apr 2021 17:47:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-4-memxor@gmail.com> <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo> <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net> <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net> <20210402152743.dbadpgcmrgjt4eca@apollo>
 <CAADnVQ+wqrEnOGd8E1yp+1WTAx8ZcAx3HUjJs6ipPd0eKmOrgA@mail.gmail.com>
 <20210402190806.nhcgappm3iocvd3d@apollo> <20210403174721.vg4wle327wvossgl@ast-mbp>
 <CAEf4Bzaeu4apgEtwS_3q1iPuURjPXMs9H43cYUtJSmjPMU5M9A@mail.gmail.com> <87blar4ti7.fsf@toke.dk>
In-Reply-To: <87blar4ti7.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Apr 2021 17:47:25 -0700
Message-ID: <CAEf4BzaOJ-WD3A13B2uCrsE2yrctAL8QtJ8TuXHLeP+tm98pbA@mail.gmail.com>
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

On Tue, Apr 6, 2021 at 3:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sat, Apr 3, 2021 at 10:47 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwivedi wrot=
e:
> >> > On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov wrote:
> >> > > On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memxor@gma=
il.com> wrote:
> >> > > > [...]
> >> > >
> >> > > All of these things are messy because of tc legacy. bpf tried to f=
ollow tc style
> >> > > with cls and act distinction and it didn't quite work. cls with
> >> > > direct-action is the only
> >> > > thing that became mainstream while tc style attach wasn't really a=
ddressed.
> >> > > There were several incidents where tc had tens of thousands of pro=
gs attached
> >> > > because of this attach/query/index weirdness described above.
> >> > > I think the only way to address this properly is to introduce bpf_=
link style of
> >> > > attaching to tc. Such bpf_link would support ingress/egress only.
> >> > > direction-action will be implied. There won't be any index and que=
ry
> >> > > will be obvious.
> >> >
> >> > Note that we already have bpf_link support working (without support =
for pinning
> >> > ofcourse) in a limited way. The ifindex, protocol, parent_id, priori=
ty, handle,
> >> > chain_index tuple uniquely identifies a filter, so we stash this in =
the bpf_link
> >> > and are able to operate on the exact filter during release.
> >>
> >> Except they're not unique. The library can stash them, but something e=
lse
> >> doing detach via iproute2 or their own netlink calls will detach the p=
rog.
> >> This other app can attach to the same spot a different prog and now
> >> bpf_link__destroy will be detaching somebody else prog.
> >>
> >> > > So I would like to propose to take this patch set a step further f=
rom
> >> > > what Daniel said:
> >> > > int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
> >> > > and make this proposed api to return FD.
> >> > > To detach from tc ingress/egress just close(fd).
> >> >
> >> > You mean adding an fd-based TC API to the kernel?
> >>
> >> yes.
> >
> > I'm totally for bpf_link-based TC attachment.
> >
> > But I think *also* having "legacy" netlink-based APIs will allow
> > applications to handle older kernels in a much nicer way without extra
> > dependency on iproute2. We have a similar situation with kprobe, where
> > currently libbpf only supports "modern" fd-based attachment, but users
> > periodically ask questions and struggle to figure out issues on older
> > kernels that don't support new APIs.
>
> +1; I am OK with adding a new bpf_link-based way to attach TC programs,
> but we still need to support the netlink API in libbpf.
>
> > So I think we'd have to support legacy TC APIs, but I agree with
> > Alexei and Daniel that we should keep it to the simplest and most
> > straightforward API of supporting direction-action attachments and
> > setting up qdisc transparently (if I'm getting all the terminology
> > right, after reading Quentin's blog post). That coincidentally should
> > probably match how bpf_link-based TC API will look like, so all that
> > can be abstracted behind a single bpf_link__attach_tc() API as well,
> > right? That's the plan for dealing with kprobe right now, btw. Libbpf
> > will detect the best available API and transparently fall back (maybe
> > with some warning for awareness, due to inherent downsides of legacy
> > APIs: no auto-cleanup being the most prominent one).
>
> Yup, SGTM: Expose both in the low-level API (in bpf.c), and make the
> high-level API auto-detect. That way users can also still use the
> netlink attach function if they don't want the fd-based auto-close
> behaviour of bpf_link.

So I thought a bit more about this, and it feels like the right move
would be to expose only higher-level TC BPF API behind bpf_link. It
will keep the API complexity and amount of APIs that libbpf will have
to support to the minimum, and will keep the API itself simple:
direct-attach with the minimum amount of input arguments. By not
exposing low-level APIs we also table the whole bpf_tc_cls_attach_id
design discussion, as we now can keep as much info as needed inside
bpf_link_tc (which will embed bpf_link internally as well) to support
detachment and possibly some additional querying, if needed.

I think that's the best and least controversial step forward for
getting this API into libbpf.

>
> -Toke
>
