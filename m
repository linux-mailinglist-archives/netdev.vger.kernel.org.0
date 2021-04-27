Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C1536CADC
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 20:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbhD0SGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 14:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236740AbhD0SGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 14:06:18 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF60C061574;
        Tue, 27 Apr 2021 11:05:35 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z1so70439936ybf.6;
        Tue, 27 Apr 2021 11:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4k51v4ojf3lxF5zVb1zpsehG3xYQSt5SLFt1Yt10P9M=;
        b=UTwqXVHLOaKcwBipWncQtnPzb7FDuWhSq/vu3Ou8nDgonX6CVVDIQ6izS6pWkWTcBK
         y4fewkY1Y3hh+XVwzvpN2i79jNuE+P511KRL3Q4yCBInzHLAwVG8OZfTYfpgmcAtn53R
         GKfPHh/3z7wCaRWt3+tqt928O3otA+xhTAtevCscNDs9wu3PjVnYxU8Fw3UHm2QdV8b3
         9dHGnHA2ILz9aNXT+CMkro8wt28LNHOSuCZ33y2SccdON+Auy1R75mtL519/SzUnGpX6
         SYiTHkgbbhjwlLXaI5H2g4Y4iwcD7r3gh128kwYDfKf5bmuw7tKFUoFAZpIW7FATLREu
         eNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4k51v4ojf3lxF5zVb1zpsehG3xYQSt5SLFt1Yt10P9M=;
        b=Y4pwmrE+9Jl24bXqyzkeMiKcOlj0RyBiQ4ExQguas6UeGe7eNzxpqpMiOLFb14hOTj
         QLY4EZ4lWERa+ZEEIlPgGvST63HlnOg4rqdoFe5Q5OOkTTBdb/a1ls5Ds+xz6XV5zez0
         mMTt47NXgTIqcxsn2raJi8cD+VBbL4YgLzQZUW/8PbAMKYZ/OvOJoL+qJLjGXbrpRRGO
         ZVeAGMlPpIQ7KlGTCk8VCKM/fBCgNPCuB8iiT94ya7rOMmspVZUIgx2IIG3Bx6ZDlcZX
         ub7nOCyc6oMJC0n4UAvFL3xDRtefCUyglhhl53b+GsYNuIsorSbGyGp+d0mXmdxYnusf
         PtUg==
X-Gm-Message-State: AOAM5303ExY9fY6/T6yb3pvutKMnp0Xih9pvMYP21LI5R6KLkT47Jiid
        vkw3gYha+xFadkkYVtcx9HyD0+tUM1ECP7dKsnk=
X-Google-Smtp-Source: ABdhPJwzdibhX4camMkiEeaTT8bDcf8WnBJmyIpYRFWFFgEqmwwKK0Qdvljs/3+u1CRxx6Ix/SFQG/3Yheo1XO7cfmI=
X-Received: by 2002:a25:3357:: with SMTP id z84mr34116107ybz.260.1619546734454;
 Tue, 27 Apr 2021 11:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210426202240.518961-1-memxor@gmail.com> <CAEf4BzaDbVpLvbOnkTKtzHVGq74TfBprLuZ6fJtYqJ+jFZN+Gw@mail.gmail.com>
 <CAJ8uoz2s9ieED4hs_2weHCRkcW5M8JgOdj1ORntqJzxTdCHa9w@mail.gmail.com>
In-Reply-To: <CAJ8uoz2s9ieED4hs_2weHCRkcW5M8JgOdj1ORntqJzxTdCHa9w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Apr 2021 11:05:23 -0700
Message-ID: <CAEf4Bza_nRJVbRZj0NJhc6vvg5vOua5hKxpRRw86FL=Bj2rgaw@mail.gmail.com>
Subject: Re: [PATCH] libbpf: export inline helpers as symbols for xsk
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 11:49 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Tue, Apr 27, 2021 at 1:20 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Apr 26, 2021 at 1:22 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > This helps people writing language bindings to not have to rewrite C
> > > wrappers for inline functions in the headers. We force inline the
> > > definition from the header for C and C++ consumers, but also export a
> > > symbol in the library for others. This keeps the performance
> > > advantages similar to using static inline, while also allowing tools
> > > like Rust's bindgen to generate wrappers for the functions.
> > >
> > > Also see
> > > https://lore.kernel.org/bpf/CAJ8uoz0QqR97qEYYK=VVCE9A=V=k2tKnH6wNM48jeak2RAmL0A@mail.gmail.com/
> > > for some context.
> > >
> > > Also see https://github.com/xdp-project/xdp-tools/pull/97 for more
> > > discussion on the same.
> > >
> > > extern inline is used as it's slightly better since it warns when an
> > > inline definition is missing.
> > >
> > > The fvisibility attribute goes on the inline definition, as essentially
> > > it acts as a declaration for the function, while the extern inline
> > > declaration ends up acting as a definition.
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> >
> > xsk is moving into libxdp, why not do this there, instead of exporting
> > a lot of symbols that we'll be deprecating very soon. It will also
> > incentivise customers to make a move more promptly.
> >
> > Bjorn, Magnus, what's the status of libxsk in libxdp?
>
> There is a branch in the repo with the xsk support of libbpf
> integrated into libxdp. But it has not been merged yet. Toke might
> still have some comments on it, do not know, but we have been fixing a
> number of issue during the past months (including one in Linux) so it
> is stable and performs well now. A simple sample and some tests are
> still missing. But the above Rust support is in that branch.
>
> What is your current time plan on the libbpf 1.0 release? Before that
> happens, I need to make the Linux samples and selftests self-contained
> and not reliant on the xsk support in libbpf since it will be
> disappearing. This basically amounts to moving the xsk libbpf
> functionality into a separate file and using that from the samples and
> tests. At this point in time, relying on the user having libxdp
> installed would not be a good idea since if they do not (the majority
> of people at this point I believe) it would break the build of
> samples/bpf and selftests/bpf. Please let me know what you think?

I'm hoping to finish BPF static linker work and then will start doing
libbpf 1.0 work. xsk.c stuff is not going away in at least next few
months. My objection is to keep extending that functionality in libbpf
if we are actively working on having all of that in libxdp.

>
> > >  tools/lib/bpf/libbpf.map | 16 ++++++++++++++
> > >  tools/lib/bpf/xsk.c      | 24 +++++++++++++++++++++
> > >  tools/lib/bpf/xsk.h      | 45 +++++++++++++++++++++++-----------------
> > >  3 files changed, 66 insertions(+), 19 deletions(-)
> > >
> >
> > [...]
