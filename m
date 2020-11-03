Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EF22A3D15
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 07:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgKCG6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 01:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCG6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 01:58:18 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91562C0617A6;
        Mon,  2 Nov 2020 22:58:18 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id n142so13950578ybf.7;
        Mon, 02 Nov 2020 22:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I8re0XcSco/tb5V6qDbcAdQaU3PH1zpkwXr6klwq7EM=;
        b=UsO+OePyfDrO5yr1Jmc6l2VLVMJ4vWuIfchqHIhKsvREvgmkRpWQGpP6mkUqmZcuxX
         vOKL+n+VdALCJmR94Arfaf17F3iJ40i1h7phVa5tIJIj9p8LxGsF3HTzrE9ruLz3sjDT
         YdQT2ffnzHk6t1+3nlmWnKVswLASnNevQXLWgpJaPzd3zqmzHFiEKNgoNYwJ3ZP3ukbw
         TmBP2FlWL6WFmaedJiEgRtpPIadEUTvoWqZXaWTZB7dCoxzlqgz+N+6C0pLPzy+QfNXF
         ElibRRoDEJRD5Tq3dNO5GBD8GaU4unLMtAFqgvTryN2SLaD1yzZNjDDkV66QNPhkkXw6
         aLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I8re0XcSco/tb5V6qDbcAdQaU3PH1zpkwXr6klwq7EM=;
        b=WmLyh/8t1/xNeimKEAXpTDQTyZ0rK6muA0lpPih9gP8JViqzFjR7sQycMJgrQxF9jX
         LdSDKUbOGcyRY3NEAraSLssSmCoHDt3laHFyLenEslDmv7PClbzetlzT3JyXA9PDF+gb
         bImRT/eZoMoKohBNcSV+IEUtqtF0tcNlbaR0WQwSjLWhNgPLkHuNy48Ajw1/Oee+/8Oy
         mkmTdfcnZns8fIC2yfGhPZrWXFjlwrXbY6b1joO+MUU5uPS2wpuKk3bhl8UIVpbYTo69
         GgUyA+FsoH3+OCdlXZdUVeMQ3P8zMxpHfF5+MlrkD++tRuE4zNpl51ldz5rc7KdezNXi
         Fj/g==
X-Gm-Message-State: AOAM530Sg77eMtpBy8PH3hSSKICqet/bcVVNrgfS2cZ2EKDHsteYs4b7
        0CYsOoDS2y8HkTKTMz+IbFES/KQ+XmxqpFNKOto=
X-Google-Smtp-Source: ABdhPJxdFf+vfFWS+jm177nC/XH8KmM94xGGpemoWHQWuYao3v7iXBx7Q3j7W01o6pgz/g+A2EpKiOpnEFUk+UgoaLw=
X-Received: by 2002:a25:c001:: with SMTP id c1mr24943266ybf.27.1604386697597;
 Mon, 02 Nov 2020 22:58:17 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
In-Reply-To: <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 22:58:06 -0800
Message-ID: <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 7:47 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 10/29/20 9:11 AM, Hangbin Liu wrote:
> > This series converts iproute2 to use libbpf for loading and attaching
> > BPF programs when it is available. This means that iproute2 will
> > correctly process BTF information and support the new-style BTF-defined
> > maps, while keeping compatibility with the old internal map definition
> > syntax.
> >
> > This is achieved by checking for libbpf at './configure' time, and usin=
g
> > it if available. By default the system libbpf will be used, but static
> > linking against a custom libbpf version can be achieved by passing
> > LIBBPF_DIR to configure. FORCE_LIBBPF can be set to force configure to
> > abort if no suitable libbpf is found (useful for automatic packaging
> > that wants to enforce the dependency).
> >
> > The old iproute2 bpf code is kept and will be used if no suitable libbp=
f
> > is available. When using libbpf, wrapper code ensures that iproute2 wil=
l
> > still understand the old map definition format, including populating
> > map-in-map and tail call maps before load.
> >
> > The examples in bpf/examples are kept, and a separate set of examples
> > are added with BTF-based map definitions for those examples where this
> > is possible (libbpf doesn't currently support declaratively populating
> > tail call maps).
> >
> > At last, Thanks a lot for Toke's help on this patch set.
> >
>
> In regards to comments from v2 of the series:
>
> iproute2 is a stable, production package that requires minimal support
> from external libraries. The external packages it does require are also
> stable with few to no relevant changes.
>
> bpf and libbpf on the other hand are under active development and
> rapidly changing month over month. The git submodule approach has its
> conveniences for rapid development but is inappropriate for a package
> like iproute2 and will not be considered.

It's ok to not consider that, really. I'm trying to understand what's
so bad about the submodule approach, not convince you (anymore) to use
libbpf through submodule. And the submodule is not for rapid
development, it's mainly for guaranteed libbpf features and version,
and simplicity of iproute2 code when using libbpf.

But I don't think I got a real answer as to what's the exact reason
against the submodule. Like what "inappropriate" even means in this
case? Jesper's security argument so far was the only objective
criteria, as far as I can tell.

>
> To explicitly state what I think should be obvious to any experienced
> Linux user, iproute2 code should always compile and work *without
> functionality loss* on LTS versions N and N-1 of well known OS=E2=80=99es=
 with
> LTS releases (e.g., Debian, Ubuntu, RHEL). Meaning iproute2 will compile
> and work with the external dependencies as they exist in that OS version.

I love the appeal to obviousness and "experienced Linux user" ;)

But I also see that using libbpf through submodule gives iproute2
exact control over which version of libbpf is being used. And that
does not depend at all on any specific Linux distribution, its
version, LTS vs non-LTS, etc. iproute2 will just work the same across
all of them. So matches your stated goals very directly and
explicitly.

>
> I believe there are more than enough established compatibility and
> library version checks to find the middle ground to integrate new
> features requiring new versions of libbpf while maintaining stability
> and compatibility with older releases. The biannual releases of Ubuntu
> and Fedora serve as testing grounds for integrating new features
> requiring a newer version of libbpf while continuing to work with
> released versions of libbpf. It appears Debian Bullseye will also fall
> into this category.

Beyond just more unnecessary complexity in iproute2 library to
accommodate older libbpf versions, users basically will need to pay
closer attention not just to which version of iproute2 they have, but
also which version of libbpf is installed on their system. Which is
ok, but an unnecessary burden, IMO. By controlling the libbpf version
through the submodule, it would be simple to say: "iproute2 vX uses
libbpf vY with features Z1, Z2, Z3". Then the user would just know
what to expect from iproute2 and its BPF support. And iproute2 code
base won't have to do as much feature detection and condition
compilation tricks.

That's what I don't understand, why settle for the lowest common
denominator of libbpf versions across a wide range of systems, when
you can take control and develop against a well-known version of
libbpf. I get security upgrades angle (even if I don't rank it higher
than simplicity). But I don't get the ideal behind a blanket statement
"libbpf through submodule is inappropriate".

>
> Finally, bpf-based features in iproute2 will only be committed once
> relevant support exists in a released version of libbpf (ie., the github
> version, not just commits to the in-kernel tree version). Patches can
> and should be sent for review based on testing with the in-kernel tree
> version of libbpf, but I will not commit them until the library has been
> released.

Makes sense. And the submodule approach gives you a great deal of
control and flexibility in this case. For testing, it's easy to use
either Github or even in-kernel sources (with a bit of symlinking,
though). But for upstreaming the submodule should only reference a
released tag from Github repo. Again, everything seems to work out,
no?

>
> Thanks for working on this, Hangbin. It is right direction in the long te=
rm.
