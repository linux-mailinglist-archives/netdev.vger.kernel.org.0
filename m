Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8432935FEAA
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhDNX7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhDNX72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 19:59:28 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FAFC061574;
        Wed, 14 Apr 2021 16:59:04 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id n12so24092334ybf.8;
        Wed, 14 Apr 2021 16:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1bOhd0AsB0Hr/Azp3nR6t9URnVKXG8Wg3PiLHh+ovn8=;
        b=KcWXKn3g04iNI240eUf21d5Z7u/+5rO5bQcjiL1vb5jPQC0SHlB9TYY1uPXa1/6CGN
         913BTa0S9a18R6Ge3zx6tN8E653xV/MU+D6JcbxVmlEdF/BIW1sPLOIDSAAXTtgyl881
         /2DM2I3jV+/Sqk5Lrj6WTy7i50aPCVmXzyXxnpxVwG9gdJ1l+7ItZeMue3FuGO+U64Ee
         JKUdZhC8pL90relaV6QyYJUcsp6F4FHmK9XifJhOno3YWYSORxyj1tTiGWbo2N6GF94n
         JBKLk8dc5FjbcmkOTGNVm+lVKLcn73gYxvsuEjx776snHSOP0qSrPk82UCHERcsdXX4T
         ut1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1bOhd0AsB0Hr/Azp3nR6t9URnVKXG8Wg3PiLHh+ovn8=;
        b=bWyYf42PVHqPBdmmbuU1pZmfzdyvQfI7ya21+pBTPMsrTrvlQdyeIDe3/ioHUj2ZcE
         lDh5FOepBfHT8YJ/bi6e8bNiHEl1XYJ/zS8hzvlYDdvNY30Amb2LHlReNBG1B16UBptK
         ZcFtjpbN1fZnwL9N5s1Y8ulE5BOU7PD3/8AHT3003sd3HvEySX9ofq69G4NweyHFS3Ji
         +j0FFk+FXJG1x2QD4U/iCMyD4WCsaj3YeGrRSo3HCbR3i1XxXl1AqpgQqLbY56oKrkU7
         bWN4mBHflvSL/H5TquiO2uOB0dc2JwlAW6eJVUiA3c89n89mp1fKm+qK2yI43RCYcqek
         75qw==
X-Gm-Message-State: AOAM531l/F8KTdSyaPPQLgaP9EKAmkzOJ7nRR1JM64d+GgluMrVRxhfR
        bGQM6sAS7wiX+4YkcgO6ca9iYIqQfUNCx+VDEGo=
X-Google-Smtp-Source: ABdhPJxPNe6dGisQ1enjUKx/iA3g5c4/5Je27vVDFgIzrwgcRjeR9/aLWyTtqyEWv3s4Zktv182MwbRzL+HAjzL62vA=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr679303ybf.425.1618444743339;
 Wed, 14 Apr 2021 16:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-4-memxor@gmail.com> <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo> <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net> <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net> <20210402152743.dbadpgcmrgjt4eca@apollo>
 <CAADnVQ+wqrEnOGd8E1yp+1WTAx8ZcAx3HUjJs6ipPd0eKmOrgA@mail.gmail.com>
 <20210402190806.nhcgappm3iocvd3d@apollo> <20210403174721.vg4wle327wvossgl@ast-mbp>
 <CAEf4Bzaeu4apgEtwS_3q1iPuURjPXMs9H43cYUtJSmjPMU5M9A@mail.gmail.com>
 <87blar4ti7.fsf@toke.dk> <CAEf4BzaOJ-WD3A13B2uCrsE2yrctAL8QtJ8TuXHLeP+tm98pbA@mail.gmail.com>
 <874kg9m8t1.fsf@toke.dk> <CAEf4BzaEkzPeAXqmm5aEdQxnCkrqJTHcSu7afnV11+697KgZTQ@mail.gmail.com>
 <87wnt4jx8m.fsf@toke.dk> <CAEf4Bzbb0ECMjhAvD-1wpp3qJJcrpgKr_=ONN4ZQmuNUgYrH4A@mail.gmail.com>
 <4b99d6c3-0281-f539-e6dc-0b307c5a7db3@iogearbox.net>
In-Reply-To: <4b99d6c3-0281-f539-e6dc-0b307c5a7db3@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Apr 2021 16:58:52 -0700
Message-ID: <CAEf4BzZtivCFfMLa5vnu6QtNL75BC4WoreS=4v1TScsfVX1jQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
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

On Wed, Apr 14, 2021 at 4:32 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 4/15/21 1:19 AM, Andrii Nakryiko wrote:
> > On Wed, Apr 14, 2021 at 3:51 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>> On Wed, Apr 14, 2021 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> >>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>>>> On Tue, Apr 6, 2021 at 3:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >>>>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>>>>>> On Sat, Apr 3, 2021 at 10:47 AM Alexei Starovoitov
> >>>>>>> <alexei.starovoitov@gmail.com> wrote:
> >>>>>>>> On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwived=
i wrote:
> >>>>>>>>> On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov wrot=
e:
> >>>>>>>>>> On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memxor=
@gmail.com> wrote:
> >>>>>>>>>>> [...]
> >>>>>>>>>>
> >>>>>>>>>> All of these things are messy because of tc legacy. bpf tried =
to follow tc style
> >>>>>>>>>> with cls and act distinction and it didn't quite work. cls wit=
h
> >>>>>>>>>> direct-action is the only
> >>>>>>>>>> thing that became mainstream while tc style attach wasn't real=
ly addressed.
> >>>>>>>>>> There were several incidents where tc had tens of thousands of=
 progs attached
> >>>>>>>>>> because of this attach/query/index weirdness described above.
> >>>>>>>>>> I think the only way to address this properly is to introduce =
bpf_link style of
> >>>>>>>>>> attaching to tc. Such bpf_link would support ingress/egress on=
ly.
> >>>>>>>>>> direction-action will be implied. There won't be any index and=
 query
> >>>>>>>>>> will be obvious.
> >>>>>>>>>
> >>>>>>>>> Note that we already have bpf_link support working (without sup=
port for pinning
> >>>>>>>>> ofcourse) in a limited way. The ifindex, protocol, parent_id, p=
riority, handle,
> >>>>>>>>> chain_index tuple uniquely identifies a filter, so we stash thi=
s in the bpf_link
> >>>>>>>>> and are able to operate on the exact filter during release.
> >>>>>>>>
> >>>>>>>> Except they're not unique. The library can stash them, but somet=
hing else
> >>>>>>>> doing detach via iproute2 or their own netlink calls will detach=
 the prog.
> >>>>>>>> This other app can attach to the same spot a different prog and =
now
> >>>>>>>> bpf_link__destroy will be detaching somebody else prog.
> >>>>>>>>
> >>>>>>>>>> So I would like to propose to take this patch set a step furth=
er from
> >>>>>>>>>> what Daniel said:
> >>>>>>>>>> int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
> >>>>>>>>>> and make this proposed api to return FD.
> >>>>>>>>>> To detach from tc ingress/egress just close(fd).
> >>>>>>>>>
> >>>>>>>>> You mean adding an fd-based TC API to the kernel?
> >>>>>>>>
> >>>>>>>> yes.
> >>>>>>>
> >>>>>>> I'm totally for bpf_link-based TC attachment.
> >>>>>>>
> >>>>>>> But I think *also* having "legacy" netlink-based APIs will allow
> >>>>>>> applications to handle older kernels in a much nicer way without =
extra
> >>>>>>> dependency on iproute2. We have a similar situation with kprobe, =
where
> >>>>>>> currently libbpf only supports "modern" fd-based attachment, but =
users
> >>>>>>> periodically ask questions and struggle to figure out issues on o=
lder
> >>>>>>> kernels that don't support new APIs.
> >>>>>>
> >>>>>> +1; I am OK with adding a new bpf_link-based way to attach TC prog=
rams,
> >>>>>> but we still need to support the netlink API in libbpf.
> >>>>>>
> >>>>>>> So I think we'd have to support legacy TC APIs, but I agree with
> >>>>>>> Alexei and Daniel that we should keep it to the simplest and most
> >>>>>>> straightforward API of supporting direction-action attachments an=
d
> >>>>>>> setting up qdisc transparently (if I'm getting all the terminolog=
y
> >>>>>>> right, after reading Quentin's blog post). That coincidentally sh=
ould
> >>>>>>> probably match how bpf_link-based TC API will look like, so all t=
hat
> >>>>>>> can be abstracted behind a single bpf_link__attach_tc() API as we=
ll,
> >>>>>>> right? That's the plan for dealing with kprobe right now, btw. Li=
bbpf
> >>>>>>> will detect the best available API and transparently fall back (m=
aybe
> >>>>>>> with some warning for awareness, due to inherent downsides of leg=
acy
> >>>>>>> APIs: no auto-cleanup being the most prominent one).
> >>>>>>
> >>>>>> Yup, SGTM: Expose both in the low-level API (in bpf.c), and make t=
he
> >>>>>> high-level API auto-detect. That way users can also still use the
> >>>>>> netlink attach function if they don't want the fd-based auto-close
> >>>>>> behaviour of bpf_link.
> >>>>>
> >>>>> So I thought a bit more about this, and it feels like the right mov=
e
> >>>>> would be to expose only higher-level TC BPF API behind bpf_link. It
> >>>>> will keep the API complexity and amount of APIs that libbpf will ha=
ve
> >>>>> to support to the minimum, and will keep the API itself simple:
> >>>>> direct-attach with the minimum amount of input arguments. By not
> >>>>> exposing low-level APIs we also table the whole bpf_tc_cls_attach_i=
d
> >>>>> design discussion, as we now can keep as much info as needed inside
> >>>>> bpf_link_tc (which will embed bpf_link internally as well) to suppo=
rt
> >>>>> detachment and possibly some additional querying, if needed.
> >>>>
> >>>> But then there would be no way for the caller to explicitly select a
> >>>> mechanism? I.e., if I write a BPF program using this mechanism targe=
ting
> >>>> a 5.12 kernel, I'll get netlink attachment, which can stick around w=
hen
> >>>> I do bpf_link__disconnect(). But then if the kernel gets upgraded to
> >>>> support bpf_link for TC programs I'll suddenly transparently get
> >>>> bpf_link and the attachments will go away unless I pin them. This
> >>>> seems... less than ideal?
> >>>
> >>> That's what we are doing with bpf_program__attach_kprobe(), though.
> >>> And so far I've only seen people (privately) saying how good it would
> >>> be to have bpf_link-based TC APIs, doesn't seem like anyone with a
> >>> realistic use case prefers the current APIs. So I suspect it's not
> >>> going to be a problem in practice. But at least I'd start there and
> >>> see how people are using it and if they need anything else.
> >>
> >> *sigh* - I really wish you would stop arbitrarily declaring your own u=
se
> >> cases "realistic" and mine (implied) "unrealistic". Makes it really ha=
rd
> >> to have a productive discussion...
> >
> > Well (sigh?..), this wasn't my intention, sorry you read it this way.
> > But we had similar discussions when I was adding bpf_link-based XDP
> > attach APIs. And guess what, now I see that samples/bpf/whatever_xdp
> > is switched to bpf_link-based XDP, because that makes everything
> > simpler and more reliable. What I also know is that in production we
> > ran into multiple issues with anything that doesn't auto-detach on
> > process exit/crash (unless pinned explicitly, of course). And that
> > people that are trying to use TC right now are saying how having
> > bpf_link-based TC APIs would make everything *simpler* and *safer*. So
> > I don't know... I understand it might be convenient in some cases to
> > not care about a lifetime of BPF programs you are attaching, but then
> > there are usually explicit and intentional ways to achieve at least
> > similar behavior with safety by default.
>
> [...]
>
>  >>> There are many ways to skin this cat. I'd prioritize bpf_link-based =
TC
>  >>> APIs to be added with legacy TC API as a fallback.
>
> I think the problem here is though that this would need to be determinist=
ic
> when upgrading from one kernel version to another where we don't use the
> fallback anymore, e.g. in case of Cilium we always want to keep the progs
> attached to allow headless updates on the agent, meaning, traffic keeps
> flowing through the BPF datapath while in user space, our agent restarts
> after upgrade, and atomically replaces the BPF progs once up and running
> (we're doing this for the whole range of 4.9 to 5.x kernels that we suppo=
rt).
> While we use the 'simple' api that is discussed here internally in Cilium=
,
> this attach behavior would have to be consistent, so transparent fallback
> inside libbpf on link vs non-link availability won't work (at least in ou=
r
> case).

What about pinning? It's not exactly the same, but bpf_link could
actually pin a BPF program, if using legacy TC, and pin bpf_link, if
using bpf_link-based APIs. Of course before switching from iproute2 to
libbpf APIs you'd need to design your applications to use pinning
instead of relying implicitly on permanently attached BPF program.

>
> > So I guess call me unconvinced (yet? still?). Give it another shot, tho=
ugh.
> >
> >>>> If we expose the low-level API I can elect to just use this if I kno=
w I
> >>>> want netlink behaviour, but if bpf_program__attach_tc() is the only =
API
> >>>> available it would at least need a flag to enforce one mode or the o=
ther
> >>>> (I can see someone wanting to enforce kernel bpf_link semantics as w=
ell,
> >>>> so a flag for either mode seems reasonable?).
> >>>
> >>> Sophisticated enough users can also do feature detection to know if
> >>> it's going to work or not.
> >>
> >> Sure, but that won't help if there's no API to pick the attach mode th=
ey
> >> want.
> >
> > I'm not intending to allow legacy kprobe APIs to be "chosen", for
> > instance. Because I'm convinced it's a bad API that no one should use
> > if they can use an FD-based one. It might be a different case for TC,
> > who knows. I'd just start with safer APIs and then evaluate whether
> > there is a real demand for less safe ones. It's just some minor
> > refactoring and exposing more APIs, when/if we need them.
> >
> >>> There are many ways to skin this cat. I'd prioritize bpf_link-based T=
C
> >>> APIs to be added with legacy TC API as a fallback.
> >>
> >> I'm fine with adding that; I just want the functions implementing the =
TC
> >> API to also be exported so users can use those if they prefer...
> >>
> >> -Toke
>
