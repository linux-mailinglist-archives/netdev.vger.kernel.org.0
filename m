Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7122AA1F1
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 02:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbgKGBH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 20:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgKGBH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 20:07:59 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE1BC0613CF;
        Fri,  6 Nov 2020 17:07:59 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id i193so2734971yba.1;
        Fri, 06 Nov 2020 17:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P1lNBUwu8TsZvaTrcu6uKv4aAm0utWC6dvPxKfX6a0w=;
        b=NV+pRW9jXoHkbnhc0eqDafiS1Jvl5QQ4YsxNLB0LZwDhhr8MkIGpPdcKlChea3PFNH
         9+FMcY05TZ7KBqVShLwou3PGi0+14g4mU8SeblIWbSXsBv10BNEKfl3zMId+3i17Atz5
         H4fXfRfsHQuQXAtEH8fpp1oZxP95cWmWnAkpWtKzjYKB3U0Iuyk6xP2FtzxcH2GP8PuX
         zGXFplVMql3/qOz6ud83R92bSbsu06mCP//XKvLYxagitBNXoqwKyClzVmMy5gXb+6yk
         JAIkPg/RyppgT1lw0Rz0d5ETcRAceVJgIF1h0XkiNTrL5ooNziK4jPfaYoL9Ru3dfuEM
         xrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P1lNBUwu8TsZvaTrcu6uKv4aAm0utWC6dvPxKfX6a0w=;
        b=GNJzO+4zgsnRG9AAqrPwp4TIqsBTtsxs31/9ZDuuAQqQ9nSfksV3PO8a1V4FagXs5v
         D1Hm/hnMTj3o3KosH+iEQOtVUoNp0gEs0PhxmQoCCQ/h4Pz9miUEyyoGY09Lc6xkow1g
         5FHKbmZKYSngFOmaUNqHjjv+B2N+pQjnPxPQiy812tv+3AzBrNXLZFehWlK/evB29/N5
         EIbq6K7/xRsi7cUp79lSkFwoNMm/Mg3FmG9HvmEM1knXyQ9qxz6u7kG/e2hU6LxY3iHU
         LM/bk7C/yt4jqf8LKt11VdNwktSZukmE42R1Y1eyZ0TGvX7/iNHoyg7BtrLEps22W/qy
         IpmQ==
X-Gm-Message-State: AOAM5318OdEDbhy9KusZ6mPRVjxztv2FD1rI9UT/IQIE9UDY+i2DRDwr
        MvIs//auzMLpIvOCHo4VTY3+gsvLRctFzXXHRPE=
X-Google-Smtp-Source: ABdhPJwK6e/TVvvWSBGiPwA/lcTGwh9iGHlFhYcpYZRT5ZPEF7FAjBxSSk5PYGnm9jiA2m53T4Wr3C3H1PajbdWOJlI=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr6703202ybg.459.1604711278307;
 Fri, 06 Nov 2020 17:07:58 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com> <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com> <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com> <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local> <CAEf4BzY6iqkJZOnPNwVp3Q+UYu=XA7CKo83aD60RvcAapWb0eQ@mail.gmail.com>
 <20201106164142.6d0955f9@hermes.local>
In-Reply-To: <20201106164142.6d0955f9@hermes.local>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 17:07:47 -0800
Message-ID: <CAEf4Bza3GCyagEm7uQ9i0NbGa5WBoo9nTFpB-mUGm+O-SZvEvg@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 4:41 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 6 Nov 2020 15:30:38 -0800
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Fri, Nov 6, 2020 at 3:25 PM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> > >
> > > On Fri, 6 Nov 2020 13:04:16 -0800
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >
> > > > On Fri, Nov 6, 2020 at 12:58 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Fri, Nov 6, 2020 at 12:44 AM Jiri Benc <jbenc@redhat.com> wrote:
> > > > > >
> > > > > > On Thu, 5 Nov 2020 12:19:00 -0800, Andrii Nakryiko wrote:
> > > > > > > I'll just quote myself here for your convenience.
> > > > > >
> > > > > > Sorry, I missed your original email for some reason.
> > > > > >
> > > > > > >   Submodule is a way that I know of to make this better for end users.
> > > > > > >   If there are other ways to pull this off with shared library use, I'm
> > > > > > >   all for it, it will save the security angle that distros are arguing
> > > > > > >   for. E.g., if distributions will always have the latest libbpf
> > > > > > >   available almost as soon as it's cut upstream *and* new iproute2
> > > > > > >   versions enforce the latest libbpf when they are packaged/released,
> > > > > > >   then this might work equivalently for end users. If Linux distros
> > > > > > >   would be willing to do this faithfully and promptly, I have no
> > > > > > >   objections whatsoever. Because all that matters is BPF end user
> > > > > > >   experience, as Daniel explained above.
> > > > > >
> > > > > > That's basically what we already do, for both Fedora and RHEL.
> > > > > >
> > > > > > Of course, it follows the distro release cycle, i.e. no version
> > > > > > upgrades - or very limited ones - during lifetime of a particular
> > > > > > release. But that would not be different if libbpf was bundled in
> > > > > > individual projects.
> > > > >
> > > > > Alright. Hopefully this would be sufficient in practice.
> > > >
> > > > I think bumping the minimal version of libbpf with every iproute2 release
> > > > is necessary as well.
> > > > Today iproute2-next should require 0.2.0. The cycle after it should be 0.3.0
> > > > and so on.
> > > > This way at least some correlation between iproute2 and libbpf will be
> > > > established.
> > > > Otherwise it's a mess of versions and functionality from user point of view.
> > >
> > > As long as iproute2 6.0 and libbpf 0.11.0 continues to work on older kernel
> > > (like oldest living LTS 4.19 in 2023?); then it is fine.
> > >
> > > Just don't want libbpf to cause visible breakage for users.
> >
> > libbpf CI validates a bunch of selftests on 4.9 kernel, see [0]. It
> > should work on even older ones. Not all BPF programs would load and be
> > verified successfully, but libbpf itself should work regardless.
> >
> >   [0] https://travis-ci.com/github/libbpf/libbpf/jobs/429362146
>
> Look at the dates in my note, are you willing to promise that compatibility
> in future versions.
>

I don't understand why after so many emails in this thread it's still
not clear that backwards compatibility is in libbpf's DNA. And no one
can even point out where and when exactly libbpf even had a problem
with backwards compatibility in the first place! Yet, all of this
insinuation of libbpf API instability...

So for the last time (hopefully): yes!

We managed to do that for at least 2 last years, why would we suddenly
break this?
