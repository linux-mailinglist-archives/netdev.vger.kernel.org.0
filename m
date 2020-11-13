Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD012B135A
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgKMAkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgKMAkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 19:40:20 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CACC0613D1;
        Thu, 12 Nov 2020 16:40:19 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id y16so8578545ljh.0;
        Thu, 12 Nov 2020 16:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8FzHLOaOQ00/R+QLYGTLCa7VRK1T3PSPGkhMlNT6oCs=;
        b=oLWIb3LHta+FFGiNbFftOfig4B0ceBffKz+png7U9DEdW3LeGtR5X9XuS81zZlj8sj
         LMbAgyvbKPGPL6qcWAon+zIdPq/f0zxh8VQ7wAuDwZgXDRr8P7VZB4LG+WDLO/EVJTMe
         08+4YC0c3GGgXSkIfQtuY6XDlvSQEmd/5IrnHxgDBpMnkfA6C3YLXZPFBW/Y1RZHa9L+
         J+z9QyQpMS0aUZXtl7n1sKB8xQZVxkJZOXSGHM4s+HA2vDxp1xs/4SVhBWbhT/ZacXql
         0u5HJaNpylyCsYbdqyDTglACWSqjJYMISFX3p9BZE3oOOticz4Qx6EIha/jf9K8N7zr9
         suLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8FzHLOaOQ00/R+QLYGTLCa7VRK1T3PSPGkhMlNT6oCs=;
        b=F2OGE4ey4ggAL3NNyjln/XAZRTJazjkIYjL8mRL/C8Cd/17RjHFVQM9tbz8O+DryMl
         x9Kg+cTcdCMjMCuMdz1g0GEdG60H+dXCl05ELUTsDFUwvUSqD6DX9O7TpUJyFltPcF8/
         zJVnhzt4o5w8x7i2sykle8FDyEOwnAzyAEOdIXg0/sDIl4jaLzpzVk4fxCgnv6sNenCL
         wyJ8QdyisOi1utf8F2g8a6F8FetCZ1oUXQ0KlCp1vlkKaEJTeX5edpal97GsE+nEPMw0
         q0uYtaq2g4A/EkCk7ShayblYkYsA03JJnHk9MzHRcJZ3DSssYMk2juwP1C1MD1tg50xv
         eAKw==
X-Gm-Message-State: AOAM5326m+07OimftEpFdTvvCe7Zlwz3/jEiB5cVwjwZcbP+SKIkt0oQ
        W+veZrZdUCqryrNlYmFx2XOf4rllyjDOEz7HTVclw6jFWHM=
X-Google-Smtp-Source: ABdhPJzYQf03qKL3+jPSpWlheVZkeFzWsgyppxiqZxp8/H85Un18PNaZdC83Nc4LhwZq6CsjSOJvMPm/Zdxx+B4L4C8=
X-Received: by 2002:a05:651c:1205:: with SMTP id i5mr955098lja.283.1605228018134;
 Thu, 12 Nov 2020 16:40:18 -0800 (PST)
MIME-Version: 1.0
References: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com> <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com> <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local> <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
 <20201109014515.rxz3uppztndbt33k@ast-mbp> <14c9e6da-e764-2e2c-bbbb-bc95992ed258@gmail.com>
 <20201111004749.r37tqrhskrcxjhhx@ast-mbp> <874klwcg1p.fsf@toke.dk>
 <321a2728-7a43-4a48-fe97-dab45b76e6fb@iogearbox.net> <871rgy8aom.fsf@toke.dk>
 <da82603a-cea9-7036-9d9a-4e1174cfa7c0@iogearbox.net> <20201112160437.64c36022@hermes.local>
In-Reply-To: <20201112160437.64c36022@hermes.local>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 Nov 2020 16:40:06 -0800
Message-ID: <CAADnVQLy9QiqRUWND43uC3BvfEz2WXtLMV0v0D-9B+hoBak2yw@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 4:35 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 13 Nov 2020 00:20:52 +0100
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> > On 11/12/20 11:36 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > Daniel Borkmann <daniel@iogearbox.net> writes:
> > >
> > >>> Besides, for the entire history of BPF support in iproute2 so far, =
the
> > >>> benefit has come from all the features that libbpf has just started
> > >>> automatically supporting on load (BTF, etc), so users would have
> > >>> benefited from automatic library updates had it *not* been vendored=
 in.
> > >>
> > >> Not really. What you imply here is that we're living in a perfect
> > >> world and that all distros follow suite and i) add libbpf dependency
> > >> to their official iproute2 package, ii) upgrade iproute2 package alo=
ng
> > >> with new kernel releases and iii) upgrade libbpf along with it so th=
at
> > >> users are able to develop BPF programs against the feature set that
> > >> the kernel offers (as intended). These are a lot of moving parts to
> > >> get right, and as I pointed out earlier in the conversation, it took
> > >> major distros 2 years to get their act together to officially includ=
e
> > >> bpftool as a package - I'm not making this up, and this sort of pace
> > >> is simply not sustainable. It's also not clear whether distros will
> > >> get point iii) correct.
> > >
> > > I totally get that you've been frustrated with the distro adoption an=
d
> > > packaging of BPF-related tools. And rightfully so. I just don't think
> > > that the answer to this is to try to work around distros, but rather =
to
> > > work with them to get things right.
> > >
> > > I'm quite happy to take a shot at getting a cross-distro effort going=
 in
> > > this space; really, having well-supported BPF tooling ought to be in
> > > everyone's interest!
> >
> > Thanks, yes, that is worth a push either way! There is still a long tai=
l
> > of distros that are not considered major and until they all catch up wi=
th
> > points i)-iii) it might take a much longer time until this becomes real=
ly
> > ubiquitous with iproute2 for users of the libbpf loader. Its that this
> > frustrating user experience could be avoided altogether. iproute2 is
> > shipped and run also on small / embedded devices hence it tries to have
> > external dependencies reduced to a bare minimum (well, except that libm=
nl
> > detour, but it's not a mandatory dependency). If I were a user and woul=
d
> > rely on the loader for my progs to be installed I'd probably end up
> > compiling my own version of iproute2 linked with libbpf to move forward
> > instead of being blocked on distro to catch up, but its an additional
> > hassle for shipping SW instead of just having it all pre-installed when
> > built-in given it otherwise comes with the base distro already. But the=
n
> > my question is what is planned here as deprecation process for the buil=
t-in
> > lib/bpf.c code? I presume we'll remove it eventually to move on?
>
> Perf has a similar problem and it made it into most distributions because=
 it is
> a valuable tool. Maybe there is some lessons learned that could apply her=
e.

Indeed.
Please read tools/perf/Documentation/Build.txt
and realize that perf binary _statically_ links libperf library.
