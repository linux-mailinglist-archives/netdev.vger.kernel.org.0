Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82482AA173
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 00:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgKFXaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 18:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbgKFXau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 18:30:50 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CFCC0613CF;
        Fri,  6 Nov 2020 15:30:50 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id c129so2581845yba.8;
        Fri, 06 Nov 2020 15:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8qGjZ0TwV8QoKSWq4vsmvBlOOlAUFNrZ9fB5btaray4=;
        b=bg6zh9HBYW8L29N/8MEPwJ1MdUCsjvQRCRLCqvSRwlkuNmWZG3N5vhCrhS9JStSUhP
         2xf4qG4cvWJJqBmv+MCWua+JtjU4hwrlON+tnd4aiKEH0mBxQhbsLDFsVMqtFvFivbVF
         74MFxSRlvLkFXqRHTeH/jUiGgxvSLMyrATdFl3CR6LWgjLCI2DEXCEUO7fI6e49rCAVy
         fca4rvLPzuM/0NrGWlQ6jzIKXe7ahP7SOvJ9uQVu4EHS3ylfMM8N4GWQOXYwj/D4Lboi
         l76Ck1rcuxeZWebf6e/cVL6EKBFK4++gp78Bq1NWdhdgMRav/dUZR3D+cTEtkaSC2G5I
         e4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8qGjZ0TwV8QoKSWq4vsmvBlOOlAUFNrZ9fB5btaray4=;
        b=iCq6eaB7mGNrG2I6i4UtP0xrp8wtVpJt0b+EtR+T5mCvLBPWZJ/lZOlWUzA/q4h8Xw
         /uJu7LlWRT6Gvofdz3EECQmytHUa0bXztI6eet+VHEP04CPo0BmBKYUd4mKHrcgr58N1
         IhjzQS5ySM3UKR6FGdmfNfKt/uQpzziIAcFNX3LqBS5Sr+2UqJqoXtZLCcrg3tikZX6N
         j9QabaLeIANfuRcOIn1j29dPOl1/t5NXlXY+YFQ9oHDjRhQjlSvPMkcQU4MJ9CpCDFi4
         WNMztIApfK46h1mHBjgSH7U0pCaj9y/2tGlloPH8tFJ8w8/RGIgZlaalV2NbzdoKEKOM
         k8YA==
X-Gm-Message-State: AOAM530DxCyQf/JXQYASwvlCdQqHHd4+5nw9RRSuxVqhpyXl6AkLE7ob
        016AS0cGT5FKcNBuwPfP9JpVDI3apgycvUobdk8XWWbumlcV9yZd
X-Google-Smtp-Source: ABdhPJyXaOV8P70kbslC4szGjr4BXGMcBdekeh16dsJsl2r1UMJGusFksfLqfbYyRLb7WTuxEBgXWg9Z97JxPK1UX64=
X-Received: by 2002:a05:6902:72e:: with SMTP id l14mr5738862ybt.230.1604705449235;
 Fri, 06 Nov 2020 15:30:49 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com> <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com> <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com> <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com> <20201106152537.53737086@hermes.local>
In-Reply-To: <20201106152537.53737086@hermes.local>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 15:30:38 -0800
Message-ID: <CAEf4BzY6iqkJZOnPNwVp3Q+UYu=XA7CKo83aD60RvcAapWb0eQ@mail.gmail.com>
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

On Fri, Nov 6, 2020 at 3:25 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 6 Nov 2020 13:04:16 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Fri, Nov 6, 2020 at 12:58 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Nov 6, 2020 at 12:44 AM Jiri Benc <jbenc@redhat.com> wrote:
> > > >
> > > > On Thu, 5 Nov 2020 12:19:00 -0800, Andrii Nakryiko wrote:
> > > > > I'll just quote myself here for your convenience.
> > > >
> > > > Sorry, I missed your original email for some reason.
> > > >
> > > > >   Submodule is a way that I know of to make this better for end users.
> > > > >   If there are other ways to pull this off with shared library use, I'm
> > > > >   all for it, it will save the security angle that distros are arguing
> > > > >   for. E.g., if distributions will always have the latest libbpf
> > > > >   available almost as soon as it's cut upstream *and* new iproute2
> > > > >   versions enforce the latest libbpf when they are packaged/released,
> > > > >   then this might work equivalently for end users. If Linux distros
> > > > >   would be willing to do this faithfully and promptly, I have no
> > > > >   objections whatsoever. Because all that matters is BPF end user
> > > > >   experience, as Daniel explained above.
> > > >
> > > > That's basically what we already do, for both Fedora and RHEL.
> > > >
> > > > Of course, it follows the distro release cycle, i.e. no version
> > > > upgrades - or very limited ones - during lifetime of a particular
> > > > release. But that would not be different if libbpf was bundled in
> > > > individual projects.
> > >
> > > Alright. Hopefully this would be sufficient in practice.
> >
> > I think bumping the minimal version of libbpf with every iproute2 release
> > is necessary as well.
> > Today iproute2-next should require 0.2.0. The cycle after it should be 0.3.0
> > and so on.
> > This way at least some correlation between iproute2 and libbpf will be
> > established.
> > Otherwise it's a mess of versions and functionality from user point of view.
>
> As long as iproute2 6.0 and libbpf 0.11.0 continues to work on older kernel
> (like oldest living LTS 4.19 in 2023?); then it is fine.
>
> Just don't want libbpf to cause visible breakage for users.

libbpf CI validates a bunch of selftests on 4.9 kernel, see [0]. It
should work on even older ones. Not all BPF programs would load and be
verified successfully, but libbpf itself should work regardless.

  [0] https://travis-ci.com/github/libbpf/libbpf/jobs/429362146
