Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF4B4AF8CF
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 18:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbiBIRxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 12:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiBIRxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 12:53:47 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24171C0613C9;
        Wed,  9 Feb 2022 09:53:50 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id e8so2337767ilm.13;
        Wed, 09 Feb 2022 09:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hEg0y0wpaA0NxaOXCTb6FxrWQQ0eOZKttfjrv1FpqYo=;
        b=HKUe2RT5FovFABPNovji/5iHiVLAYEpsmJ/7AjYoUIinKh0yDwrOoncrKmNZsc9xe1
         wuWJ20lL0rm6ca11iQf0DBMb3ahXuK39ugZbSeDqVcbQbJLNw8/9/+az3dV2WWVc1h9k
         Ip8b9TlqByMhmESM94ljNCvK4gNhaPQu98s8tIkSA1NkxYsB6g1GuHxIAoO4LZ7sKDzp
         xz+UxkAw8Vr5srB5FAQBHTOIlozTm/szRsEzxDfCNb41YCjHWEzktBpW/W2egmsnX+Ab
         HS1zxoCcC6hu4iXhoDil4EhQJa6sZLm7fhZfh/NoqPECeV04ewjShOmkszdmmKfYJ8iN
         VCSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hEg0y0wpaA0NxaOXCTb6FxrWQQ0eOZKttfjrv1FpqYo=;
        b=lEdutq+QrIpjOWh0e6SZKbNsnA+6NirwywsnZw2LIJh53hTdf7IUSflm4fSsgkpqbA
         dqAsZ6Pso1srjsRjVVJO6GRb1deA+PssiRzmfyVQ3EiC94wIPrinOTqL4K9Ulh0JPjPz
         EAwXjUcEDGGga2lGUAnp/EnjzPGurer9o5bwir/O5xx5FoekVal/c1oIFx5SHssnVAww
         8gIxEWsNE1zrcJCIVm796HHe8Tqg3iTH29jrDPWQQikeNXnHmudRu6BvQMMNhmeuDCrU
         6rle3h83hqBSQgNBLanvcEkykEwfVc4/wrJWyag/BWfdNWvp1/dBnyZ1hkQAXg9Dkuth
         sLNw==
X-Gm-Message-State: AOAM531Lu1otA6PoFxgzIWViQ74MkAo4mULSqA15XyqqhnjJvMaQcob3
        H2TDmnp5hqWBTcJYtx4YqPtBr9qoSmXZeKrd6/k=
X-Google-Smtp-Source: ABdhPJzH41CpYLPV0G/3jSMxAsfT5EiefksDNC/t8TrD2REpjW4hOlWhGKjGs6OD6iSPirO4i04i11jG7QqYuhTYwP8=
X-Received: by 2002:a05:6e02:1b81:: with SMTP id h1mr1773881ili.239.1644429229412;
 Wed, 09 Feb 2022 09:53:49 -0800 (PST)
MIME-Version: 1.0
References: <20220208120648.49169-1-quentin@isovalent.com> <20220208120648.49169-4-quentin@isovalent.com>
 <CAEf4BzaH1OKZpJ8-CC4TbhGmYe+jv_0iqOTwhOG9+98Lze9Lew@mail.gmail.com> <82da0b01-af9f-ea0d-17a4-76a4c48bc879@isovalent.com>
In-Reply-To: <82da0b01-af9f-ea0d-17a4-76a4c48bc879@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Feb 2022 09:53:38 -0800
Message-ID: <CAEf4BzYPP28afBFwG+9jW4hpt2-iyy2gqATNUbY9yw0eDJU7Vw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/3] bpftool: Update versioning scheme, align
 on libbpf's version number
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 4:37 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2022-02-08 16:39 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Tue, Feb 8, 2022 at 4:07 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> Since the notion of versions was introduced for bpftool, it has been
> >> following the version number of the kernel (using the version number
> >> corresponding to the tree in which bpftool's sources are located). The
> >> rationale was that bpftool's features are loosely tied to BPF features
> >> in the kernel, and that we could defer versioning to the kernel
> >> repository itself.
> >>
> >> But this versioning scheme is confusing today, because a bpftool binary
> >> should be able to work with both older and newer kernels, even if some
> >> of its recent features won't be available on older systems. Furthermore,
> >> if bpftool is ported to other systems in the future, keeping a
> >> Linux-based version number is not a good option.
> >>
> >> Looking at other options, we could either have a totally independent
> >> scheme for bpftool, or we could align it on libbpf's version number
> >> (with an offset on the major version number, to avoid going backwards).
> >> The latter comes with a few drawbacks:
> >>
> >> - We may want bpftool releases in-between two libbpf versions. We can
> >>   always append pre-release numbers to distinguish versions, although
> >>   those won't look as "official" as something with a proper release
> >>   number. But at the same time, having bpftool with version numbers that
> >>   look "official" hasn't really been an issue so far.
> >>
> >> - If no new feature lands in bpftool for some time, we may move from
> >>   e.g. 6.7.0 to 6.8.0 when libbpf levels up and have two different
> >>   versions which are in fact the same.
> >>
> >> - Following libbpf's versioning scheme sounds better than kernel's, but
> >>   ultimately it doesn't make too much sense either, because even though
> >>   bpftool uses the lib a lot, its behaviour is not that much conditioned
> >>   by the internal evolution of the library (or by new APIs that it may
> >>   not use).
> >>
> >> Having an independent versioning scheme solves the above, but at the
> >> cost of heavier maintenance. Developers will likely forget to increase
> >> the numbers when adding features or bug fixes, and we would take the
> >> risk of having to send occasional "catch-up" patches just to update the
> >> version number.
> >>
> >> Based on these considerations, this patch aligns bpftool's version
> >> number on libbpf's. This is not a perfect solution, but 1) it's
> >> certainly an improvement over the current scheme, 2) the issues raised
> >> above are all minor at the moment, and 3) we can still move to an
> >> independent scheme in the future if we realise we need it.
> >>
> >> Given that libbpf is currently at version 0.7.0, and bpftool, before
> >> this patch, was at 5.16, we use an offset of 6 for the major version,
> >> bumping bpftool to 6.7.0.
> >>
> >> It remains possible to manually override the version number by setting
> >> BPFTOOL_VERSION when calling make.
> >>
> >> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >> ---
> >> Contrarily to the previous discussion and to what the first patch of the
> >> set does, I chose not to use the libbpf_version_string() API from libbpf
> >> to compute the version for bpftool. There were three reasons for that:
> >>
> >> - I don't feel comfortable having bpftool's version number computed at
> >>   runtime. Somehow it really feels like we should now it when we compile
> >
> > Fair, but why not use LIBBPF_MAJOR_VERSION and LIBBPF_MINOR_VERSION to
> > define BPFTOOL_VERSION (unless it's overridden).
>
> I forgot the macros were exposed, which is silly, because I was the one
> to help expose them in the first place. Anyway.
>
> > Which all seems to be
> > doable at compilation time in C code, not in Makefile. This will work
> > with Github version of libbpf just as well with no extra Makefile
> > changes (and in general, the less stuff is done in Makefile the
> > better, IMO).
> >
> > Version string can also be "composed" at compile time with a bit of
> > helper macro, see libbpf_version_string() implementation in libbpf.
>
> Sounds good, I can do that.
>
> This won't give me the patch number, though, only major and minor
> version. We could add an additional LIBBPF_PATCH_VERSION to libbpf.
> Although thinking about it, I'm not sure we need a patch version for
> bpftool at the moment, because changes in libbpf's patch number is
> unlikely to reflect any change in bpftool, so it makes little sense to
> copy it. So I'm considering just leaving it at 0 in bpftool, and having
> updates on major/minor numbers only when libbpf releases a major/minor
> version. If we do want bugfix releases, it will still be possible to
> overwrite the version number with BPFTOOL_VERSION anyway. What do you think?

So the patch version is not currently reflected in libbpf.map file. I
do patch version bumps only when we detect some small issue after
official release. It happened 2 or 3 times so far. I'm hesitant to
expose that as LIBBPF_PATCH_VERSION, because I'll need to remember to
bump it manually (and coordinating this between kernel sources and
Github is a slow nightmare). Let's not rely on patch version, too much
burden.

>
> Quentin
