Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB032A9ED0
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgKFVEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgKFVEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 16:04:30 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9A4C0613CF;
        Fri,  6 Nov 2020 13:04:30 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id r19so1462085lfe.6;
        Fri, 06 Nov 2020 13:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z+0ex8I3tLl6x95xLzb47rCcAAQngF1SRAV1Cc53oC4=;
        b=MwysLVNaSHKRaUmi9iH6w/qYoch4DfIBamYwuGMfSyyH3gbFUA1jbA2l6pCLe/xudg
         wzGpYj3bV0I7Qqk2uNXNWk8slbUePRjeEWacfWjUW7jPTy1a3rjvvXjUOvqaGI6i21zL
         8qDDRJ5H7XzulG5/kt8YpcTZ7ou4JmG14XCCN2VCHOzhteqhBEh6eHuGJYgMFfZB5YTa
         1g9LCLb4fkrP6rh4+0iBwZKgjpijHMP2ouQsWZ62t08xnWC9exlly82JPkQmzqqrqcL4
         yVKul3ilkbnSFMicX4xqKctKJNbpMPc4KSbOSJbsPGGno4fF2r8av4/MfSYx/iCsCJ3Z
         ImBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z+0ex8I3tLl6x95xLzb47rCcAAQngF1SRAV1Cc53oC4=;
        b=ZNKSn56buqKM9TzktVGT3Klkc0gnaczYgo8WSb1C28W7NRUyGsJTZFRBUvRwKwxxMu
         JU2JcDJuoJdZtFitTAeMy/E4ZO1ASDzKWkV772BDN3tCDr95/uFIKFoN5uSrTsy9TAEK
         3qCMZZDifchkQZfSheqUAPnhNYKEoWHvVxgQ0/qWNBxB3mfMYniLBjK3NX5Xb2Qn9X0e
         9W7UlbaclSHf5V4k0ygKlk7OSA+/2IKP0PUtZDgnWQ28hNbAPnYuAMUlGqIQmsKCOl+Q
         FE/NpiqvXBGbBTzp7huWahrvQSWYZzQ3ynQfDUs1h6Z8e5n/vk00grVXTtor+sQtVNJA
         BieA==
X-Gm-Message-State: AOAM533NthKMKh69cy6uxtw6x4LLS28BxMw/Ybps2Novt45KoO3LrsGC
        pqTshRPxf8cm/jnEhy2DYce8X/HHaqAU1KhpodlFvOGx
X-Google-Smtp-Source: ABdhPJyKxdxHs45KWUHFG4GNf7srf59aY8rwNB2aFR4uLkkDU4YyllboPBpDGMDZBNliOtLjvtWEb/tb28BYWcetI4A=
X-Received: by 2002:ac2:5e83:: with SMTP id b3mr1487156lfq.119.1604696668501;
 Fri, 06 Nov 2020 13:04:28 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com> <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com> <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com> <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
In-Reply-To: <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 6 Nov 2020 13:04:16 -0800
Message-ID: <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
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

On Fri, Nov 6, 2020 at 12:58 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Nov 6, 2020 at 12:44 AM Jiri Benc <jbenc@redhat.com> wrote:
> >
> > On Thu, 5 Nov 2020 12:19:00 -0800, Andrii Nakryiko wrote:
> > > I'll just quote myself here for your convenience.
> >
> > Sorry, I missed your original email for some reason.
> >
> > >   Submodule is a way that I know of to make this better for end users.
> > >   If there are other ways to pull this off with shared library use, I'm
> > >   all for it, it will save the security angle that distros are arguing
> > >   for. E.g., if distributions will always have the latest libbpf
> > >   available almost as soon as it's cut upstream *and* new iproute2
> > >   versions enforce the latest libbpf when they are packaged/released,
> > >   then this might work equivalently for end users. If Linux distros
> > >   would be willing to do this faithfully and promptly, I have no
> > >   objections whatsoever. Because all that matters is BPF end user
> > >   experience, as Daniel explained above.
> >
> > That's basically what we already do, for both Fedora and RHEL.
> >
> > Of course, it follows the distro release cycle, i.e. no version
> > upgrades - or very limited ones - during lifetime of a particular
> > release. But that would not be different if libbpf was bundled in
> > individual projects.
>
> Alright. Hopefully this would be sufficient in practice.

I think bumping the minimal version of libbpf with every iproute2 release
is necessary as well.
Today iproute2-next should require 0.2.0. The cycle after it should be 0.3.0
and so on.
This way at least some correlation between iproute2 and libbpf will be
established.
Otherwise it's a mess of versions and functionality from user point of view.
