Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254DA2A9F03
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgKFVZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgKFVZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 16:25:16 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC20AC0613CF;
        Fri,  6 Nov 2020 13:25:15 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id m188so2375023ybf.2;
        Fri, 06 Nov 2020 13:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uk6AnU7ayHnhJLTWlzD3dA+szp2bhmyBDhgigxhKFlA=;
        b=QqaPpfcAtIvxs4rBdUwYYVq8C69QZH1BLiXO3yA1CfYKoSCJ5cG8f6tiXh/IorVp1l
         KiSce16Y3DTthPFGY5755eaIRCk6Y1KcxtW+L/uDqVsih4xWOLvDnwVSQ0jat2OuA9bb
         0pkSMXk99B90cwjNIvSo/JzGD4ru85RRiV8Cep/Xb6SeMjLheIEwurTorosLzO1cvfya
         kvBMPvnaPnXoLjKNFd2cADu1U/tIokqr71Wpq9TIByp9qL20yO4AwnNf48Q+Woy9BD/i
         h3tED10MghPGo+cg2ivJawRNEahXsYvZuDWH55FC3zyv0YDc3Sz96E5SNj4FpxshybBB
         ik6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uk6AnU7ayHnhJLTWlzD3dA+szp2bhmyBDhgigxhKFlA=;
        b=UbCIfZIgomlYGaeRxMJ/p1O+npRosOpMMnaYd8k6WYe/3hrGAKt0pjfKqrTFeTtNiA
         bv5SmlNShcYucnaZwFNUS4JBLJdrh1gR2WSm0a1B/G+rehIsP1O7QjMJBG/iTMegwhu+
         P87UrtUxuXWwE1kQdun+dofg0iZJzbFlv0ifbAxPXuuQElkyDWhRX8yEyrCXUZcVIhR6
         so73xZloYLZy5G+HfOCzZtt+eAemxS7ljtgWn0uBusZlLkPRzDosseM5X/neN2tU+dRx
         EbZqC4Bh1h5ta80qOAlj83t0eOEW5y2rNSsIVEpPAX8Ri2sbHIJVUsLtS2Ui8Kht00dN
         FrQg==
X-Gm-Message-State: AOAM533g72ZJhaJ7/kc7+9VCUiHGx64lXy0OBR8pNZpVKCQdMAzKB0Zq
        Ea4QZ9HNXyBFLO9H4WgenkfIU6QmMyox5/OzL7A=
X-Google-Smtp-Source: ABdhPJz9dEqbG2xRwz4ReDlb+mcgEtIp7HQ8J8abNu/WlEui1Hx9zjczKsmrI3lIdZg3ZfVXCdlyWRu0INA74WquVrQ=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr5736661ybg.459.1604697915126;
 Fri, 06 Nov 2020 13:25:15 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net> <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
 <1118ef27-3302-d077-021a-43aa8d8f3ebb@mojatatu.com> <CAEf4Bzag9XCRKCV_vkFU3TyCza3W+NJzm=Vh=NPkSNBY+Qke_A@mail.gmail.com>
 <3d7090ab-8bc9-bc68-642f-1e84d7a6ec08@mojatatu.com>
In-Reply-To: <3d7090ab-8bc9-bc68-642f-1e84d7a6ec08@mojatatu.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 13:25:03 -0800
Message-ID: <CAEf4BzanB7arOamPY7mKf4uxPmcmRYz7dvij_VxewYg9_y+GAg@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 7:27 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2020-11-05 4:01 p.m., Andrii Nakryiko wrote:
> > On Thu, Nov 5, 2020 at 6:05 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >>
> >> On 2020-11-04 10:19 p.m., David Ahern wrote:
> >>
> >> [..]
>
> [..]
>
> >> 2cents feedback from a dabbler in ebpf on user experience:
> >>
> >> What David described above *has held me back*.
> >> Over time it seems things have gotten better with libbpf
> >> (although a few times i find myself copying includes from the
> >> latest iproute into libbpf). I ended up just doing static links.
> >> The idea of upgrading clang/llvm every 2 months i revisit ebpf is
> >> the most painful. At times code that used to compile just fine
> >> earlier doesnt anymore. There's a minor issue of requiring i install
> >
> > Do you have a specific example of something that stopped compiling?
> > I'm not saying that can't happen, but we definitely try hard to avoid
> > any regressions. I might be forgetting something, but I don't recall
> > the situation when something would stop compiling just due to newer
> > libbpf.
> >
>
> Unfortunately the ecosystem is more than libbpf; sometimes it is
> the kernel code that is being exercised by libbpf that is problematic.
> This may sound unfair to libbpf but it is hard to separate the two for
> someone who is dabbling like me.

I get that. Clang is also part of the ecosystem, along the kernel,
pahole, etc. It's a lot of moving parts and we strive to keep them all
working well together. It's not 100% smooth all the time, but that's
at least the goal.

>
> The last issue iirc correctly had to do with one of the tcp notifier
> variants either in samples or selftests(both user space and kernel).
> I can go back and look at the details.
> The fix always more than half the time was need to upgrade
> clang/llvm. At one point i think it required that i had to grab
> the latest and greatest git version. I think the machine i have
> right now has version 11. The first time i found out about these
> clang upgrades was trying to go from 8->9 or maybe it was 9->10.
> Somewhere along there also was discovery that something that
> compiled under earlier version wasnt compiling under newer version.

So with kernel's samples/bpf and selftests/bpf, we do quite often
expect the latest Clang, because it's not just examples, but also a
live set of tests. So to not accumulate too much cruft, we do update
those (sometimes, not all the time) with assumption of latest features
in Clang, libbpf, pahole, and kernel. That's reality and we set those
expectations quite explicitly a while ago. But that's not the
expectation for user applications outside of the kernel tree. Just
wanted to make this clear.

>
> >> kernel headers every time i want to run something in samples, etc
> >> but i am probably lacking knowledge on how to ease the pain in that
> >> regard.
> >>
> >> I find the loader and associated tooling in iproute2/tc to be quiet
> >> stable (not shiny but works everytime).
> >> And for that reason i often find myself sticking to just tc instead
> >> of toying with other areas.
> >
> > That's the part that others on this thread mentioned is bit rotting?
>
> Yes. Reason is i dont have to deal with new discoveries of things
> that require some upgrade or copying etc.
> I should be clear on the "it is the ecosystem": this is not just because
> of user space code but also the simplicity of writing the tc kernel code
> and loading it with tc tooling and then have a separate user tool for
> control.
> Lately i started linking the control tool with static libbpf instead.

There are also two broad categories of BPF applications: networking
and the rest (tracing, now security, etc). Networking historically
dealt with well-defined data structures (ip headers, tcp headers, etc)
and didn't need much to know about the ever-changing nature of kernel
memory layouts. That used to be, arguably, simpler use case from BPF
standpoint.

Tracing, on the other hand, was always challenging. The only viable
option was BCC's approach of bundling compiler, expecting
kernel-headers, etc. We started changing that with BPF CO-RE to make a
traditional per-compiled model viable. That obviously required changes
in all parts of the ecosystem. So tracing BPF apps went from
impossible, to hard, to constantly evolving, and we are right now in a
somewhat mixed evolving/stabilizing stage. Bleeding edge. As Jiri
said, it's to be expected that there would be rough corners. But the
choice is either to live dangerously or wait for a few years for
things to completely settle. Pick your poison ;)

>
> Bpftool seems improved last time i tried to load something in XDP. I
> like the load-map-then-attach-program approach that bpftool gets
> out of libbpf. I dont think that feature is possible with tc tooling.
>
> However, I am still loading with tc and xdp with ip because of old
> habits and what i consider to be a very simple workflow.
>
> > Doesn't seem like everyone is happy about that, though. Stopping any
> > development definitely makes things stable by definition. BPF and
> > libbpf try to be stable while not stagnating, which is harder than
> > just stopping any development, unfortunately.
> >
>
> I am for moving to libbpf. I think it is a bad idea to have multiple
> loaders for example. Note: I am not a demanding user, but there
> are a few useful features that i feel i need that are missing in
> iproute2 version. e.g, one thing i was playing with about a month
> ago was some TOCTOU issue in the kernel code and getting
> the bpf_lock integrated into the tc code proved challenging.
> I ended rewriting the code to work around the tooling.

Right, bpf_lock relies on BTF, that's probably why.

>
> The challenge - when making changes in the name of progress - is to
> not burden a user like myself with a complex workflow but still give
> me the features i need.

This takes time and work, and can't be done perfectly overnight.
That's all. But the thing is: we are working towards it, non-stop.

>
> >> Slight tangent:
> >> One thing that would help libbpf adoption is to include an examples/
> >> directory. Put a bunch of sample apps for tc, probes, xdp etc.
> >> And have them compile outside of the kernel. Maybe useful Makefiles
> >> that people can cutnpaste from. Every time you add a new feature
> >> put some sample code in the examples.
> >
> > That's what tools/testing/selftests/bpf in kernel source are for. It's
> > not the greatest showcase of examples, but all the new features have a
> > test demonstrating its usage. I do agree about having simple Makefiles
> > and we do have that at [0]. I'm also about to do another sample repo
> > with a lot of things pre-setup, for tinkering and using that as a
> > bootstrap for BPF development with libbpf.
> >
> >    [0] https://github.com/iovisor/bcc/tree/master/libbpf-tools
>
>
> I pull that tree regularly.
> selftests is good for aggregating things developers submit and
> then have the robots test.
> For better usability, it has to be something that is standalone that
> would work out of the box with libbf.

It's not yet ready for wider announcement, but give this a try:

https://github.com/anakryiko/libbpf-bootstrap

Should make it easier to play with libbpf and BPF.

> selftests and samples are not what i would consider for the
> faint-hearted.
> It may look easy to you because you eat this stuff for
> breakfast but consider all those masses you want to be part of this.
> They dont have the skills and people with average skills dont
> have the patience.

I acknowledged from the get-go that selftest/bpf are not the best
source of examples, just that's what we've got. It takes contributions
from lots of people to maintain a decent, nice and clean, easy to use
set of realistic examples. It's unrealistic, IMO, to expect a bunch of
core BPF developers to both develop core technology actively, and
provide great educational resources (however unfortunate that is).

>
> This again comes back to "the ecosystem" - just getting libbpf to get
> things stable for userland is not enough. Maybe have part of the libbpf
> testing also to copy things from selftests.
>
> cheers,
> jamal
