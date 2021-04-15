Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EFB3613E4
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbhDOVJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDOVJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 17:09:54 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83EDC061574;
        Thu, 15 Apr 2021 14:09:30 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id x8so22591437ybx.2;
        Thu, 15 Apr 2021 14:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3fZGkzYA9N5sJROBejizGKDoT/jC4hJQX4sdnJU7pCs=;
        b=OLAsbD1KjYeXWHpGKP53B8khpulB/DNpdJEKbMBN3xK9B+UnHwxAh45XvGTfnltHsP
         oNEtygFWvC7W+IqUGOy58M9fLio5xpy1yWOqMAYstu5WsQ6A/40dGkopcCMutP5lynqp
         S+ZlxWn4Prf96qdRjHiG98ETxlNM3ZnYqu1dFuUYtH7B4nE3F0DT6/7457Iu8elcg7TK
         pSB8rg+oweC4/HlTpCUi6uA+rN2HGMpeia+acOsrkHKx/nvWUTdVDK3AvJeAhg65ef95
         1mqY+XH01rjUPsCKEgqrtDz+1f0sidrxERGzvHen9GoqQv+eYD+yaHubyoR85Ljx9Dbn
         JkpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3fZGkzYA9N5sJROBejizGKDoT/jC4hJQX4sdnJU7pCs=;
        b=iqI80LSqcPINAHkZQnGev0GPwZa4Bvc6w8FntfjNbb49YMUYFnbBTc3icXbV9RDGP9
         d2QxakbEvuy+lgt4xNogL6qfa+Hq8SLrjypq0E4gV1LTw0BvtYzcNcuzgav6Hwl5Be0c
         LflL5cxioRtTK4SEomH/GQInUKp7+TL+Xioarm5hWhq7nOyTZtQL/78CgdmCAnPqeaUv
         QaaDSkLsX7jvw9xyapECvihlSe7/R5/CHlje9BQRmeU/7geSO7VVihMSN9ARlaNr8DKF
         axutAfCgYrraa3Mz1ufkzg55JfZfUo7pbtho6R0jWnuwWTG5XmlWpCx02wjy53YunVgc
         lI4Q==
X-Gm-Message-State: AOAM530LXVbyJaBYI0qV59Q7PTwDuk5VLprEUR12P8oaIWXLCRoRi3rj
        9Q1PnUleugRdSBsFKFSZl6PyImWYom5v/7wX/Q8=
X-Google-Smtp-Source: ABdhPJwA8cLUN8qlRjj0AnTv1/B1Yo1mfiax6fiH+fdsMsqUPPlZ9XYhXbHwOvVqC/VQwiqIWhpEPmu3zbE2mX20HKw=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr7046034ybf.425.1618520969984;
 Thu, 15 Apr 2021 14:09:29 -0700 (PDT)
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
 <87v98nilqw.fsf@toke.dk>
In-Reply-To: <87v98nilqw.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Apr 2021 14:09:18 -0700
Message-ID: <CAEf4Bza24pQtszw4Ua6yR7ZwP13Wej1c4rfArRdOP4D1PFLakw@mail.gmail.com>
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

On Thu, Apr 15, 2021 at 8:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Apr 14, 2021 at 3:51 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Wed, Apr 14, 2021 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> >>
> >> >> > On Tue, Apr 6, 2021 at 3:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@redhat.com> wrote:
> >> >> >>
> >> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> >> >>
> >> >> >> > On Sat, Apr 3, 2021 at 10:47 AM Alexei Starovoitov
> >> >> >> > <alexei.starovoitov@gmail.com> wrote:
> >> >> >> >>
> >> >> >> >> On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwi=
vedi wrote:
> >> >> >> >> > On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov =
wrote:
> >> >> >> >> > > On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <m=
emxor@gmail.com> wrote:
> >> >> >> >> > > > [...]
> >> >> >> >> > >
> >> >> >> >> > > All of these things are messy because of tc legacy. bpf t=
ried to follow tc style
> >> >> >> >> > > with cls and act distinction and it didn't quite work. cl=
s with
> >> >> >> >> > > direct-action is the only
> >> >> >> >> > > thing that became mainstream while tc style attach wasn't=
 really addressed.
> >> >> >> >> > > There were several incidents where tc had tens of thousan=
ds of progs attached
> >> >> >> >> > > because of this attach/query/index weirdness described ab=
ove.
> >> >> >> >> > > I think the only way to address this properly is to intro=
duce bpf_link style of
> >> >> >> >> > > attaching to tc. Such bpf_link would support ingress/egre=
ss only.
> >> >> >> >> > > direction-action will be implied. There won't be any inde=
x and query
> >> >> >> >> > > will be obvious.
> >> >> >> >> >
> >> >> >> >> > Note that we already have bpf_link support working (without=
 support for pinning
> >> >> >> >> > ofcourse) in a limited way. The ifindex, protocol, parent_i=
d, priority, handle,
> >> >> >> >> > chain_index tuple uniquely identifies a filter, so we stash=
 this in the bpf_link
> >> >> >> >> > and are able to operate on the exact filter during release.
> >> >> >> >>
> >> >> >> >> Except they're not unique. The library can stash them, but so=
mething else
> >> >> >> >> doing detach via iproute2 or their own netlink calls will det=
ach the prog.
> >> >> >> >> This other app can attach to the same spot a different prog a=
nd now
> >> >> >> >> bpf_link__destroy will be detaching somebody else prog.
> >> >> >> >>
> >> >> >> >> > > So I would like to propose to take this patch set a step =
further from
> >> >> >> >> > > what Daniel said:
> >> >> >> >> > > int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
> >> >> >> >> > > and make this proposed api to return FD.
> >> >> >> >> > > To detach from tc ingress/egress just close(fd).
> >> >> >> >> >
> >> >> >> >> > You mean adding an fd-based TC API to the kernel?
> >> >> >> >>
> >> >> >> >> yes.
> >> >> >> >
> >> >> >> > I'm totally for bpf_link-based TC attachment.
> >> >> >> >
> >> >> >> > But I think *also* having "legacy" netlink-based APIs will all=
ow
> >> >> >> > applications to handle older kernels in a much nicer way witho=
ut extra
> >> >> >> > dependency on iproute2. We have a similar situation with kprob=
e, where
> >> >> >> > currently libbpf only supports "modern" fd-based attachment, b=
ut users
> >> >> >> > periodically ask questions and struggle to figure out issues o=
n older
> >> >> >> > kernels that don't support new APIs.
> >> >> >>
> >> >> >> +1; I am OK with adding a new bpf_link-based way to attach TC pr=
ograms,
> >> >> >> but we still need to support the netlink API in libbpf.
> >> >> >>
> >> >> >> > So I think we'd have to support legacy TC APIs, but I agree wi=
th
> >> >> >> > Alexei and Daniel that we should keep it to the simplest and m=
ost
> >> >> >> > straightforward API of supporting direction-action attachments=
 and
> >> >> >> > setting up qdisc transparently (if I'm getting all the termino=
logy
> >> >> >> > right, after reading Quentin's blog post). That coincidentally=
 should
> >> >> >> > probably match how bpf_link-based TC API will look like, so al=
l that
> >> >> >> > can be abstracted behind a single bpf_link__attach_tc() API as=
 well,
> >> >> >> > right? That's the plan for dealing with kprobe right now, btw.=
 Libbpf
> >> >> >> > will detect the best available API and transparently fall back=
 (maybe
> >> >> >> > with some warning for awareness, due to inherent downsides of =
legacy
> >> >> >> > APIs: no auto-cleanup being the most prominent one).
> >> >> >>
> >> >> >> Yup, SGTM: Expose both in the low-level API (in bpf.c), and make=
 the
> >> >> >> high-level API auto-detect. That way users can also still use th=
e
> >> >> >> netlink attach function if they don't want the fd-based auto-clo=
se
> >> >> >> behaviour of bpf_link.
> >> >> >
> >> >> > So I thought a bit more about this, and it feels like the right m=
ove
> >> >> > would be to expose only higher-level TC BPF API behind bpf_link. =
It
> >> >> > will keep the API complexity and amount of APIs that libbpf will =
have
> >> >> > to support to the minimum, and will keep the API itself simple:
> >> >> > direct-attach with the minimum amount of input arguments. By not
> >> >> > exposing low-level APIs we also table the whole bpf_tc_cls_attach=
_id
> >> >> > design discussion, as we now can keep as much info as needed insi=
de
> >> >> > bpf_link_tc (which will embed bpf_link internally as well) to sup=
port
> >> >> > detachment and possibly some additional querying, if needed.
> >> >>
> >> >> But then there would be no way for the caller to explicitly select =
a
> >> >> mechanism? I.e., if I write a BPF program using this mechanism targ=
eting
> >> >> a 5.12 kernel, I'll get netlink attachment, which can stick around =
when
> >> >> I do bpf_link__disconnect(). But then if the kernel gets upgraded t=
o
> >> >> support bpf_link for TC programs I'll suddenly transparently get
> >> >> bpf_link and the attachments will go away unless I pin them. This
> >> >> seems... less than ideal?
> >> >
> >> > That's what we are doing with bpf_program__attach_kprobe(), though.
> >> > And so far I've only seen people (privately) saying how good it woul=
d
> >> > be to have bpf_link-based TC APIs, doesn't seem like anyone with a
> >> > realistic use case prefers the current APIs. So I suspect it's not
> >> > going to be a problem in practice. But at least I'd start there and
> >> > see how people are using it and if they need anything else.
> >>
> >> *sigh* - I really wish you would stop arbitrarily declaring your own u=
se
> >> cases "realistic" and mine (implied) "unrealistic". Makes it really ha=
rd
> >> to have a productive discussion...
> >
> > Well (sigh?..), this wasn't my intention, sorry you read it this way.
> > But we had similar discussions when I was adding bpf_link-based XDP
> > attach APIs.
>
> Great, thank you! And yeah, we did discuss exactly this before, which is
> where my mental sigh came from - I feel like we already covered this
> ground and that I'm just being dismissed with "that is not a real use
> case". But OK, I'll give it another shot, see below.
>
> > And guess what, now I see that samples/bpf/whatever_xdp is switched to
> > bpf_link-based XDP, because that makes everything simpler and more
> > reliable. What I also know is that in production we ran into multiple
> > issues with anything that doesn't auto-detach on process exit/crash
> > (unless pinned explicitly, of course). And that people that are trying
> > to use TC right now are saying how having bpf_link-based TC APIs would
> > make everything *simpler* and *safer*. So I don't know... I understand
> > it might be convenient in some cases to not care about a lifetime of
> > BPF programs you are attaching, but then there are usually explicit
> > and intentional ways to achieve at least similar behavior with safety
> > by default.
> >
> > So I guess call me unconvinced (yet? still?). Give it another shot,
> > though.
>
> I'm not arguing against adding bpf_link support, and I'm even fine with
> making it the default. As you say, there are plenty of use cases where
> the bpf_link semantics make sense, and the XDP programs in samples all
> fall in this category. So sure, let's add this support and make this
> convenient to use.
>
> But there are also use cases where the BPF program lifetime absolutely
> shouldn't follow that of the userspace application. This includes both
> applications that don't have a long-running daemon at all (like a
> firewall that just loads a ruleset at boot; xdp-filter is such an
> application in the BPF world, but I'm sure there are others). And
> daemons that use BPF as a data path and want the packets to keep flowing
> even when they restart, like Cilium as Daniel mentioned.
>
> So the latter category of applications need their BPF programs to be
> permanently attached to the interface. And sure, this can sorta be done
> by pinning the bpf_link; but not really, because then:
>
> - You incur a new dependency on bpffs, so you have to make sure that is
>   mounted and that you can get at the particular fs instance you're
>   using; the latter is especially painful if you switch namespaces.

So I understand that it's more painful than current TC and legacy XDP
APIs for these specific use cases. But for other types of BPF programs
that want to persist across user-space process exit, all those needs
to be addressed and designed around anyway. And that doesn't prevent
others from doing it, otherwise we wouldn't even implement BPFFS.

>
> - Your BPF program lifetime is no longer tied to the interface, so you
>   have to deal with garbage collecting your pinned files somehow. This
>   is especially painful if you don't have a daemon.

With bpf_link auto-detach, you'll still get the underlying BPF program
freed, only a small bpf_link shell will persist. If you churn through
interface going up/down, whichever application is responsible for
re-attaching BPF programs would deal with clean up.

But yes, I'm not oblivious to the need to change how you design your
applications and new inconveniences that would cause. But think about
this from a slightly different point of view. If we had to choose
between bpf_link model and current TC API, which one would we choose?
I'd argue we should choose bpf_link, because:
  1) it allows to do things more safely (auto-cleanup) by default;
  2) it still allows for having BPF program/link persistence, even if
in a different and slightly more inconvenient way.

So it's a more generic and powerful approach, it's just not as
perfectly aligned with the way it's used for cases you mentioned.

>
> Together, these issues make bpf_link a much less compelling proposition,
> to the point where it's no longer the better API for these use cases,
> IMO. And I know that because I had to work around just these issues with
> bpf_link for xdp-tools.
>
> But I'm not even asking for the netlink API to be the default, I'm
> fine with bpf_link being the default and encouraged API. I'm just asking
> for a way to make it *possible* to select which attach mode I want.
> Either by a flag to bpf_program__attach_tc(), or by exposing the
> low-level bpf_tc_cls_*() netlink functions, like we do for XDP.

Given significant semantic differences between bpf_link and current TC
APIs, I'm not sure anymore if it's a good idea to hide current API
behind bpf_link abstraction. For tracing it's a good fit, so I still
think falling back to legacy kprobe API makes sense there. For TC,
given your and Daniel's replies, I'd rather have low-level APIs
exposed directly instead of having some options switch in
bpf_program__attach_tc() API.

>
> >> >> If we expose the low-level API I can elect to just use this if I kn=
ow I
> >> >> want netlink behaviour, but if bpf_program__attach_tc() is the only=
 API
> >> >> available it would at least need a flag to enforce one mode or the =
other
> >> >> (I can see someone wanting to enforce kernel bpf_link semantics as =
well,
> >> >> so a flag for either mode seems reasonable?).
> >> >
> >> > Sophisticated enough users can also do feature detection to know if
> >> > it's going to work or not.
> >>
> >> Sure, but that won't help if there's no API to pick the attach mode th=
ey
> >> want.
> >
> > I'm not intending to allow legacy kprobe APIs to be "chosen", for
> > instance. Because I'm convinced it's a bad API that no one should use
> > if they can use an FD-based one.
>
> I'd tend to agree with you for the tracing APIs, actually. But a
> BPF-based data plane is different, as I tried to explain above.

Right, see above.

>
> > It might be a different case for TC, who knows. I'd just start with
> > safer APIs and then evaluate whether there is a real demand for less
> > safe ones. It's just some minor refactoring and exposing more APIs,
> > when/if we need them.
>
> There you go again with the "real demand" argument. How can I read this
> in any other way than that you don't consider my use case "real" (as you
> just assured me above was not the case)? What do you consider "real
> demand"?

Please try not to read more in my words than there really is. By real
demand I meant at least few *different* use cases coming from
different parties. That says nothing about whether your use case is
real or not, just that it's a one case (or at least coming from just
one party).

>
> -Toke
>
