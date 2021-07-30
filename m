Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EAE3DC074
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 23:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhG3VyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 17:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhG3VyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 17:54:21 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42496C06175F;
        Fri, 30 Jul 2021 14:54:15 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id g76so18323704ybf.4;
        Fri, 30 Jul 2021 14:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=10+9cj+YHmuctGqPzJ4YmJxMfTfyZwwURkkJfdnjXs8=;
        b=LFfj+I4WTrBngx2dKoovp2uTQAU4WOetXfwlMk2qDwzJe80HCm4ivLlIRu20mLK529
         UpZEB+uwsY5e4NTt2DmvEzKm+g0+PwoH4KDJzVdsXapvi9kN5YHmYGxbk/BiFGjmB6H3
         FwClN+JSli+jETCJ29m1t9M1r+3C2NuNeepqIViSJDmShIY8Kl66+Bq9Rm00HPGdNVCl
         eSWv6HAnV3kjeGDr0LPXQzgwyhZIVFYO7l4RVHiJNdxu1ulGCC/dZ3BSeNfRX0u8Rqs7
         nRtsLm5/TonS/JFcBR2PhMTC9RUkLRBY67RwlHnVlLcJFwBe+nxUEMKoGjDRea8uMsNB
         d/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=10+9cj+YHmuctGqPzJ4YmJxMfTfyZwwURkkJfdnjXs8=;
        b=iox3+lAUu1yp0T3SCefrjPjMGB5Zy7MNOqgMfB2pChxcvqd2gsCmSjvxoN9nyEt7E+
         Nek/3Na/0aK+dzlyG0o92ehVIZsVayZCJRwKAfM31KgehJtWZJYW8NvuqEsr9fmG5/Tt
         89fqHX45PVYqGBT4Kytbusc1wNiEITPHrshVXpUjLS5NeTtVtcpT2kV+1tqDi4kiqzln
         LGiYiNIw9XbuEQ1eXTHUEOuRQMif6VEcGH5nAiLYX3u1cZpLrF4ZbVeFet8ZzjpbpLrD
         JtqEb4CENug7fOOXDvNWLF54xbwuJGtQJzUPjIyNkJs/bjmmDUTEgZul7GaCdzzSRFVZ
         8f/g==
X-Gm-Message-State: AOAM530GCFRj/BYR+jGD4JiZqKLuWG4hF390IEzACd0umMLnnPL9AfpZ
        XbFkxR8FnBaNH4bDLFE89TTdr7mebN/yidgx9Dg=
X-Google-Smtp-Source: ABdhPJyDEaYSEU5pCVB0roWfG7gBCERT6xQ1hwpfoGqffGbp+S8m+56SeKedMQy9l7QqUeKrqD+Duund9W8W24v0Mug=
X-Received: by 2002:a5b:648:: with SMTP id o8mr6119981ybq.260.1627682054547;
 Fri, 30 Jul 2021 14:54:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162028.29512-1-quentin@isovalent.com> <CAEf4BzbrQOr8Z2oiywT-zPBEz9jbP9_6oJXOW28LdOaqAy8pLw@mail.gmail.com>
 <22d59def-51e7-2b98-61b6-b700e7de8ef6@isovalent.com> <CAEf4BzbjN+zjio3HPRkGLRgZpbLj9MUGLnXt1KDSsoOHB8_v3Q@mail.gmail.com>
 <CACdoK4KCbseLYzY2aqVM5KC0oXOwzE-5b3-g07uoeyJN4+r70g@mail.gmail.com>
In-Reply-To: <CACdoK4KCbseLYzY2aqVM5KC0oXOwzE-5b3-g07uoeyJN4+r70g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 14:54:03 -0700
Message-ID: <CAEf4BzbaHyGxEYx_+DjaeVhUt5qZS=tMKmAqG9MPZziQHUHPiw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/8] libbpf: rename btf__get_from_id() and
 btf__load() APIs, support split BTF
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 1:23 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On Fri, 30 Jul 2021 at 18:24, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> [...]
>
> > > > The right approach will be to define
> > > > LIBBPF_MAJOR_VERSION/LIBBPF_MINOR_VERSION in some sort of
> > > > auto-generated header, included from libbpf_common.h and installed as
> > > > part of libbpf package.
> > >
> > > So generating this header is easy. Installing it with the other headers
> > > is simple too. It becomes a bit trickier when we build outside of the
> > > directory (it seems I need to pass -I$(OUTPUT) to build libbpf).
> >
> > Not sure why using the header is tricky. We auto-generate
> > bpf_helper_defs.h, which is included from bpf_helpers.h, which is
> > included in every single libbpf-using application. Works good with no
> > extra magic.
>
> bpf_helper_defs.h is the first thing I looked at, and I processed
> libbpf_version.h just like it. But there is a difference:
> bpf_helper_defs.h is _not_ included in libbpf itself, nor is it needed
> in bpftool at the bootstrap stage (it is only included from the eBPF
> skeletons for profiling or showing PIDs etc., which are compiled after
> libbpf). The version header is needed in both cases.

Oh, in that sense. Yeah, sure, I didn't think that would qualify as
tricky. But yeah, -I$(OUTPUT) or something along those lines is fine.

>
> >
> > >
> > > The step I'm most struggling with at the moment is bpftool, which
> > > bootstraps a first version of itself before building libbpf, by looking
> > > at the headers directly in libbpf's directory. It means that the
> > > generated header with the version number has not yet been generated. Do
> > > you think it is worth changing bpftool's build steps to implement this
> > > deprecation helper?
> >
> > If it doesn't do that already, bpftool should do `make install` for
> > libbpf, not just build. Install will put all the headers, generated or
> > otherwise, into a designated destination folder, which should be
> > passed as -I parameter. But that should be already happening due to
> > bpf_helper_defs.h.
>
> bpftool does not run "make install". It compiles libbpf passing
> "OUTPUT=$(LIBBPF_OUTPUT)", sets LIBBPF_PATH to the same directory, and
> then adds "-I$(LIBBPF_PATH)" for accessing bpf_helper_defs.h and compile
> its eBPF programs. It is possible to include libbpf_version.h the same
> way, but only after libbpf has been compiled, after the bootstrap.
>
> I'll look into updating the Makefile to compile and install libbpf
> before the bootstrap, when I have some time.

Cool, `make install` is the best way as it prevents accidental usage
of libbpf's internal header. So it's a good change to make.
