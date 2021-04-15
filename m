Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4605636156B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbhDOWWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbhDOWWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 18:22:49 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859F0C061756;
        Thu, 15 Apr 2021 15:22:24 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 82so27905979yby.7;
        Thu, 15 Apr 2021 15:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fjCr7G5S8lIsVg7P//q3lJVvzQbVjil2B4Znq84dRkA=;
        b=D4UFBLhA2KqAnaOo/QLrvD0IirXX6z057T/ULSRfStJoNfDnXqvVj43TNfMh+8saiT
         iA8Xz3pG7ypQwl2w6j1GZcPUwjPYlVHolu8QjdgYmyZQZ10Ql40hkBdSanuCrzRSJvon
         DKGLWs4dGUzZbU3+6OTSJpznz1jYhc8ECKSl5m+7qgZEkCeBj/51P6x56cMddEJ7oQii
         u0MRB2EMZpmy9i+9oocImLNwmx6ayq/d1/JlyawToGiIgAXgqH9QoNFl7fHiaO3akXsH
         bPQ8hIrbBzrZtmt5yJ8JjPtv6T1MWzLK5MEbHhYyWV9Upkvk0cu81TfKmz2LteSaPk/f
         28pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fjCr7G5S8lIsVg7P//q3lJVvzQbVjil2B4Znq84dRkA=;
        b=jWk5ZBc/10dkyk2pSQeysSun106PScc6pGfHcZCYfdwr5p8X3tikXpF4zAcbmnHjyL
         SIRbcbx3Sxg20JrWP8u8ohXETkLmc+gn52iKpnxIloTsnczVqwB56n/36kTCayH9cL/q
         HLKye1e3Vv9Ja5b2U02C1HSZLXTlMP62hq9hUuse2jSvoICt2y16TpMqZzNKx3Utc9Bz
         bucSRTvH68BOk36+Ujcm9olB60tssShX9xvON692j6mJMHC0hSP4Ye4yAiZLf2i12bbV
         j6R4tdaNYQRhHkcm8iSpMQTLSf5H+ODdUPYgLIn4nOXhrLVyYzWRhOHNY7eiM7yFkk+G
         K+hA==
X-Gm-Message-State: AOAM532VQJYG8c5P0FFzQ12JFmFvS/TN+O0Eweh/IjyErgSwKYMalns4
        ge340m6vJn3Im8modVW+cNyZbHsC0dcDJ3XJ/8A=
X-Google-Smtp-Source: ABdhPJzTFiXxP/4v5lSpyd9e38LPK3LztE82oyGwdHhescHvm+i22ijCihfl5K11gijtz2zyetQlG7B2r7cftpaNoh8=
X-Received: by 2002:a25:5b55:: with SMTP id p82mr7628502ybb.510.1618525343734;
 Thu, 15 Apr 2021 15:22:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-4-memxor@gmail.com> <20210328080648.oorx2no2j6zslejk@apollo>
 <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net> <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net> <20210402152743.dbadpgcmrgjt4eca@apollo>
 <CAADnVQ+wqrEnOGd8E1yp+1WTAx8ZcAx3HUjJs6ipPd0eKmOrgA@mail.gmail.com>
 <20210402190806.nhcgappm3iocvd3d@apollo> <20210403174721.vg4wle327wvossgl@ast-mbp>
 <CAEf4Bzaeu4apgEtwS_3q1iPuURjPXMs9H43cYUtJSmjPMU5M9A@mail.gmail.com>
 <87blar4ti7.fsf@toke.dk> <CAEf4BzaOJ-WD3A13B2uCrsE2yrctAL8QtJ8TuXHLeP+tm98pbA@mail.gmail.com>
 <874kg9m8t1.fsf@toke.dk> <CAEf4BzaEkzPeAXqmm5aEdQxnCkrqJTHcSu7afnV11+697KgZTQ@mail.gmail.com>
 <87wnt4jx8m.fsf@toke.dk> <CAEf4Bzbb0ECMjhAvD-1wpp3qJJcrpgKr_=ONN4ZQmuNUgYrH4A@mail.gmail.com>
 <4b99d6c3-0281-f539-e6dc-0b307c5a7db3@iogearbox.net> <CAEf4BzZtivCFfMLa5vnu6QtNL75BC4WoreS=4v1TScsfVX1jQQ@mail.gmail.com>
 <848d7864-44f3-79a2-ad3c-80adee6aa27a@iogearbox.net>
In-Reply-To: <848d7864-44f3-79a2-ad3c-80adee6aa27a@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Apr 2021 15:22:12 -0700
Message-ID: <CAEf4BzaHwiQLmXOHcDfDtuBuPF7HZgoDW-=u6eYhQ2svHuGAWw@mail.gmail.com>
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

On Thu, Apr 15, 2021 at 3:10 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 4/15/21 1:58 AM, Andrii Nakryiko wrote:
> > On Wed, Apr 14, 2021 at 4:32 PM Daniel Borkmann <daniel@iogearbox.net> =
wrote:
> >> On 4/15/21 1:19 AM, Andrii Nakryiko wrote:
> >>> On Wed, Apr 14, 2021 at 3:51 PM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> >>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>>>> On Wed, Apr 14, 2021 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
> >>>>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>>>>>> On Tue, Apr 6, 2021 at 3:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@redhat.com> wrote:
> >>>>>>>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>>>>>>>> On Sat, Apr 3, 2021 at 10:47 AM Alexei Starovoitov
> >>>>>>>>> <alexei.starovoitov@gmail.com> wrote:
> >>>>>>>>>> On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwiv=
edi wrote:
> >>>>>>>>>>> On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov wr=
ote:
> >>>>>>>>>>>> On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memx=
or@gmail.com> wrote:
> >>>>>>>>>>>>> [...]
> >>>>>>>>>>>>
> >>>>>>>>>>>> All of these things are messy because of tc legacy. bpf trie=
d to follow tc style
> >>>>>>>>>>>> with cls and act distinction and it didn't quite work. cls w=
ith
> >>>>>>>>>>>> direct-action is the only
> >>>>>>>>>>>> thing that became mainstream while tc style attach wasn't re=
ally addressed.
> >>>>>>>>>>>> There were several incidents where tc had tens of thousands =
of progs attached
> >>>>>>>>>>>> because of this attach/query/index weirdness described above=
.
> >>>>>>>>>>>> I think the only way to address this properly is to introduc=
e bpf_link style of
> >>>>>>>>>>>> attaching to tc. Such bpf_link would support ingress/egress =
only.
> >>>>>>>>>>>> direction-action will be implied. There won't be any index a=
nd query
> >>>>>>>>>>>> will be obvious.
> >>>>>>>>>>>
> >>>>>>>>>>> Note that we already have bpf_link support working (without s=
upport for pinning
> >>>>>>>>>>> ofcourse) in a limited way. The ifindex, protocol, parent_id,=
 priority, handle,
> >>>>>>>>>>> chain_index tuple uniquely identifies a filter, so we stash t=
his in the bpf_link
> >>>>>>>>>>> and are able to operate on the exact filter during release.
> >>>>>>>>>>
> >>>>>>>>>> Except they're not unique. The library can stash them, but som=
ething else
> >>>>>>>>>> doing detach via iproute2 or their own netlink calls will deta=
ch the prog.
> >>>>>>>>>> This other app can attach to the same spot a different prog an=
d now
> >>>>>>>>>> bpf_link__destroy will be detaching somebody else prog.
> >>>>>>>>>>
> >>>>>>>>>>>> So I would like to propose to take this patch set a step fur=
ther from
> >>>>>>>>>>>> what Daniel said:
> >>>>>>>>>>>> int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
> >>>>>>>>>>>> and make this proposed api to return FD.
> >>>>>>>>>>>> To detach from tc ingress/egress just close(fd).
> >>>>>>>>>>>
> >>>>>>>>>>> You mean adding an fd-based TC API to the kernel?
> >>>>>>>>>>
> >>>>>>>>>> yes.
> >>>>>>>>>
> >>>>>>>>> I'm totally for bpf_link-based TC attachment.
> >>>>>>>>>
> >>>>>>>>> But I think *also* having "legacy" netlink-based APIs will allo=
w
> >>>>>>>>> applications to handle older kernels in a much nicer way withou=
t extra
> >>>>>>>>> dependency on iproute2. We have a similar situation with kprobe=
, where
> >>>>>>>>> currently libbpf only supports "modern" fd-based attachment, bu=
t users
> >>>>>>>>> periodically ask questions and struggle to figure out issues on=
 older
> >>>>>>>>> kernels that don't support new APIs.
> >>>>>>>>
> >>>>>>>> +1; I am OK with adding a new bpf_link-based way to attach TC pr=
ograms,
> >>>>>>>> but we still need to support the netlink API in libbpf.
> >>>>>>>>
> >>>>>>>>> So I think we'd have to support legacy TC APIs, but I agree wit=
h
> >>>>>>>>> Alexei and Daniel that we should keep it to the simplest and mo=
st
> >>>>>>>>> straightforward API of supporting direction-action attachments =
and
> >>>>>>>>> setting up qdisc transparently (if I'm getting all the terminol=
ogy
> >>>>>>>>> right, after reading Quentin's blog post). That coincidentally =
should
> >>>>>>>>> probably match how bpf_link-based TC API will look like, so all=
 that
> >>>>>>>>> can be abstracted behind a single bpf_link__attach_tc() API as =
well,
> >>>>>>>>> right? That's the plan for dealing with kprobe right now, btw. =
Libbpf
> >>>>>>>>> will detect the best available API and transparently fall back =
(maybe
> >>>>>>>>> with some warning for awareness, due to inherent downsides of l=
egacy
> >>>>>>>>> APIs: no auto-cleanup being the most prominent one).
> >>>>>>>>
> >>>>>>>> Yup, SGTM: Expose both in the low-level API (in bpf.c), and make=
 the
> >>>>>>>> high-level API auto-detect. That way users can also still use th=
e
> >>>>>>>> netlink attach function if they don't want the fd-based auto-clo=
se
> >>>>>>>> behaviour of bpf_link.
> >>>>>>>
> >>>>>>> So I thought a bit more about this, and it feels like the right m=
ove
> >>>>>>> would be to expose only higher-level TC BPF API behind bpf_link. =
It
> >>>>>>> will keep the API complexity and amount of APIs that libbpf will =
have
> >>>>>>> to support to the minimum, and will keep the API itself simple:
> >>>>>>> direct-attach with the minimum amount of input arguments. By not
> >>>>>>> exposing low-level APIs we also table the whole bpf_tc_cls_attach=
_id
> >>>>>>> design discussion, as we now can keep as much info as needed insi=
de
> >>>>>>> bpf_link_tc (which will embed bpf_link internally as well) to sup=
port
> >>>>>>> detachment and possibly some additional querying, if needed.
> >>>>>>
> >>>>>> But then there would be no way for the caller to explicitly select=
 a
> >>>>>> mechanism? I.e., if I write a BPF program using this mechanism tar=
geting
> >>>>>> a 5.12 kernel, I'll get netlink attachment, which can stick around=
 when
> >>>>>> I do bpf_link__disconnect(). But then if the kernel gets upgraded =
to
> >>>>>> support bpf_link for TC programs I'll suddenly transparently get
> >>>>>> bpf_link and the attachments will go away unless I pin them. This
> >>>>>> seems... less than ideal?
> >>>>>
> >>>>> That's what we are doing with bpf_program__attach_kprobe(), though.
> >>>>> And so far I've only seen people (privately) saying how good it wou=
ld
> >>>>> be to have bpf_link-based TC APIs, doesn't seem like anyone with a
> >>>>> realistic use case prefers the current APIs. So I suspect it's not
> >>>>> going to be a problem in practice. But at least I'd start there and
> >>>>> see how people are using it and if they need anything else.
> >>>>
> >>>> *sigh* - I really wish you would stop arbitrarily declaring your own=
 use
> >>>> cases "realistic" and mine (implied) "unrealistic". Makes it really =
hard
> >>>> to have a productive discussion...
> >>>
> >>> Well (sigh?..), this wasn't my intention, sorry you read it this way.
> >>> But we had similar discussions when I was adding bpf_link-based XDP
> >>> attach APIs. And guess what, now I see that samples/bpf/whatever_xdp
> >>> is switched to bpf_link-based XDP, because that makes everything
> >>> simpler and more reliable. What I also know is that in production we
> >>> ran into multiple issues with anything that doesn't auto-detach on
> >>> process exit/crash (unless pinned explicitly, of course). And that
> >>> people that are trying to use TC right now are saying how having
> >>> bpf_link-based TC APIs would make everything *simpler* and *safer*. S=
o
> >>> I don't know... I understand it might be convenient in some cases to
> >>> not care about a lifetime of BPF programs you are attaching, but then
> >>> there are usually explicit and intentional ways to achieve at least
> >>> similar behavior with safety by default.
> >>
> >> [...]
> >>
> >>   >>> There are many ways to skin this cat. I'd prioritize bpf_link-ba=
sed TC
> >>   >>> APIs to be added with legacy TC API as a fallback.
> >>
> >> I think the problem here is though that this would need to be determin=
istic
> >> when upgrading from one kernel version to another where we don't use t=
he
> >> fallback anymore, e.g. in case of Cilium we always want to keep the pr=
ogs
> >> attached to allow headless updates on the agent, meaning, traffic keep=
s
> >> flowing through the BPF datapath while in user space, our agent restar=
ts
> >> after upgrade, and atomically replaces the BPF progs once up and runni=
ng
> >> (we're doing this for the whole range of 4.9 to 5.x kernels that we su=
pport).
> >> While we use the 'simple' api that is discussed here internally in Cil=
ium,
> >> this attach behavior would have to be consistent, so transparent fallb=
ack
> >> inside libbpf on link vs non-link availability won't work (at least in=
 our
> >> case).
> >
> > What about pinning? It's not exactly the same, but bpf_link could
> > actually pin a BPF program, if using legacy TC, and pin bpf_link, if
> > using bpf_link-based APIs. Of course before switching from iproute2 to
> > libbpf APIs you'd need to design your applications to use pinning
> > instead of relying implicitly on permanently attached BPF program.
>
> All the progs we load from Cilium in a K8s setting w/ Pods, we could have=
 easily
> over 100 loaded at the same time on a node, and we template the per Pod o=
nes, so
> the complexity of managing those pinned lifecycles from the agent and dea=
ling with
> the semantic/fallback differences between kernels feels probably not wort=
h the
> gain. So if there would be a libbpf tc simplified attach API, I'd for the=
 time
> being stick to the existing aka legacy means.

Sure. Then what do you think about keeping only low-level TC APIs, and
in the future add bpf_program__attach_tc(), which will use
bpf_link-based one. It seems like it's not worth it to pretend we have
bpf_link-based semantics with "legacy" current TC APIs. Similarly how
we have a low-level XDP attach API, and bpf_link-based (only)
bpf_program__attach_xdp().

>
> Thanks,
> Daniel
