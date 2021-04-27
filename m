Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B98D36BF76
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 08:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhD0Guk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 02:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbhD0Guh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 02:50:37 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B8FC061574;
        Mon, 26 Apr 2021 23:49:53 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q10so41678148pgj.2;
        Mon, 26 Apr 2021 23:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=08PE1KVycTrApeF3cOQ6uzUk4coiVJPrT96N5qf+Ytw=;
        b=VwsNAs3AaMAvS4GEdOqNVnTB0umfqJIaNzKY/wfGmeXi2FPy9Gg0kOS7fhj374/zFR
         XmR8xafCd+8qD+d2YJrsAquvLPq1LW7O6YEzSTZ9eGqEboG2vmDrAizPJb7k/hqNNV3L
         wVfiIWYRTCoet0x3HdvYSpnVYH3Kn6Qiyg0drdK2l0SxsvJhzzWWuToz4MtzcrXxtm1z
         sVvNRdv7I63vOmkdqCcgb/nIGwjPwFOIXbGHSHnVDtT7+Abe6vkqCmZZJWAJ8KX7dfWm
         d53e7iJZhSFkVJBnBwvz1lnnahe7Ma8TIeIQGw5zueNb7P2kfdfo+ED7uyeEl/ttQwId
         z1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=08PE1KVycTrApeF3cOQ6uzUk4coiVJPrT96N5qf+Ytw=;
        b=CC/yGQbxrdUdkjxwNLBcXU4HO5oYl7TzcmY71dlnSXkuao0Cnt0m+5sah+iu8bM/mJ
         oW3pQcIyUDGr6yos5kbRD+V8ej1cXgwszWl08GvvbOVyK66BSHeja0D27dzF2gNB1vZQ
         fgbOLGoE6E1bOWeTAV0/wpuzC7guiIWIX0lH9UhyAcKUy1XJm8jTeTCJ1dce1cJzT70R
         cTTzRTdXev0gH/0kq1HTlx18L5wXHcztSXUEoA247hp+7exCdqeTptkFdY7yncOvHlux
         0h2FOLZK1cWD6w26glRl4rUaUxnB7fbKDsNYYCShB9x7f7m+eMGmM23LPIbLyL3vyGGR
         rTrA==
X-Gm-Message-State: AOAM531SbcdJ1EtzIPrskVBQCu+m1BWYJ5NiDzj1Jtu8+QrYLsXY1gmv
        hqirvwoYqZAU9cBzc0XrId+pRRGlDMZn+MzDjvg=
X-Google-Smtp-Source: ABdhPJzIzfo1R8r171sP8gpc/1J250m2zKuKf2+X407jnJPIJeAe1qFSISxOh+3gfeFjY4rBE0xHh2mKPKMC2x42Ivs=
X-Received: by 2002:a63:7f41:: with SMTP id p1mr7869953pgn.208.1619506193199;
 Mon, 26 Apr 2021 23:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210426202240.518961-1-memxor@gmail.com> <CAEf4BzaDbVpLvbOnkTKtzHVGq74TfBprLuZ6fJtYqJ+jFZN+Gw@mail.gmail.com>
In-Reply-To: <CAEf4BzaDbVpLvbOnkTKtzHVGq74TfBprLuZ6fJtYqJ+jFZN+Gw@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 27 Apr 2021 08:49:42 +0200
Message-ID: <CAJ8uoz2s9ieED4hs_2weHCRkcW5M8JgOdj1ORntqJzxTdCHa9w@mail.gmail.com>
Subject: Re: [PATCH] libbpf: export inline helpers as symbols for xsk
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Tue, Apr 27, 2021 at 1:20 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Apr 26, 2021 at 1:22 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This helps people writing language bindings to not have to rewrite C
> > wrappers for inline functions in the headers. We force inline the
> > definition from the header for C and C++ consumers, but also export a
> > symbol in the library for others. This keeps the performance
> > advantages similar to using static inline, while also allowing tools
> > like Rust's bindgen to generate wrappers for the functions.
> >
> > Also see
> > https://lore.kernel.org/bpf/CAJ8uoz0QqR97qEYYK=VVCE9A=V=k2tKnH6wNM48jeak2RAmL0A@mail.gmail.com/
> > for some context.
> >
> > Also see https://github.com/xdp-project/xdp-tools/pull/97 for more
> > discussion on the same.
> >
> > extern inline is used as it's slightly better since it warns when an
> > inline definition is missing.
> >
> > The fvisibility attribute goes on the inline definition, as essentially
> > it acts as a declaration for the function, while the extern inline
> > declaration ends up acting as a definition.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
>
> xsk is moving into libxdp, why not do this there, instead of exporting
> a lot of symbols that we'll be deprecating very soon. It will also
> incentivise customers to make a move more promptly.
>
> Bjorn, Magnus, what's the status of libxsk in libxdp?

There is a branch in the repo with the xsk support of libbpf
integrated into libxdp. But it has not been merged yet. Toke might
still have some comments on it, do not know, but we have been fixing a
number of issue during the past months (including one in Linux) so it
is stable and performs well now. A simple sample and some tests are
still missing. But the above Rust support is in that branch.

What is your current time plan on the libbpf 1.0 release? Before that
happens, I need to make the Linux samples and selftests self-contained
and not reliant on the xsk support in libbpf since it will be
disappearing. This basically amounts to moving the xsk libbpf
functionality into a separate file and using that from the samples and
tests. At this point in time, relying on the user having libxdp
installed would not be a good idea since if they do not (the majority
of people at this point I believe) it would break the build of
samples/bpf and selftests/bpf. Please let me know what you think?

> >  tools/lib/bpf/libbpf.map | 16 ++++++++++++++
> >  tools/lib/bpf/xsk.c      | 24 +++++++++++++++++++++
> >  tools/lib/bpf/xsk.h      | 45 +++++++++++++++++++++++-----------------
> >  3 files changed, 66 insertions(+), 19 deletions(-)
> >
>
> [...]
