Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B8E2F21BA
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbhAKVYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKVYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:24:54 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66A1C061786;
        Mon, 11 Jan 2021 13:24:13 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id d37so180733ybi.4;
        Mon, 11 Jan 2021 13:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oBdVyCE2HN+vpEpmvaUmM7gpHjvI8cKVGXfiI8pp0I0=;
        b=ioQM036GEhCVStlE/8p5hnAz1ltPE4XAT6DY5EUZy2JTLfLmA4IP+38eDcFGPvpJga
         eoNApfGlnWCwdRXWHAQM2rt3O1Le5fTS8gCeGB61elcD7c7rezo8daukKHWvsWZaPPak
         umAR/33jmk+OiBJW3ow5jPb+AUsdD71YSuwH9vyGQD6xatFTDNqwvKvBSEwGRkFiwGwP
         TObRpMakHd/oUI6ZF1kKRJldcooK5V7QIar3cGJpfOHa5CxM2i7rw+RRn6Gqprl1Rzv3
         iMg94DZDdirpCqw1KBx4T0K9JPn9d4hlv+KO2OBdIk8+g1F+mC1Bf6vjTc3v/tvrl+Ff
         nFVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oBdVyCE2HN+vpEpmvaUmM7gpHjvI8cKVGXfiI8pp0I0=;
        b=ucTHb6Z1dH7xb/891DTL07h1FuC2BVygzngnS/8/1Ey83YwtIDUR/VszN3fOSMXK5d
         YnSs0X+po3MaCpXwwIm21wcl2rz09t189yjMsq2+WbXdax05UcFuPhhnHp5d5knDzEg4
         3VoIzWhYxyymUJptyQIBnHW0RmeSnJP3Vn682DX9r9gNcmmA/BDnnr9MipGwtE+Tuz4U
         31GY0w7U8UvuHfB68CWM/VQrXq2Cs+gzmEGEbqVaqh19p76FJsDaAm7lvllkxfMtkDtn
         kwhSwijvnREZ1KLlMEpNtXH0aoT+cKfpTOnvPVaMyyRCC6mpBWMYvZMQuH+6TkMRsI+A
         4AZQ==
X-Gm-Message-State: AOAM532WGRF7UYqXtAhXhqBrg5HjsS1UABVRv4UXUcmVUVDM6UzoiD0O
        8edBuABT5SKAbBpXwqruUEwwsM4c+NugbD/3fAI=
X-Google-Smtp-Source: ABdhPJyKV/u5WB8kkd1V58UPEfiVgu7oFJJaT6fi9MI8b6GouYgos/rSiWyAs2pJtMGuE7UNvCq1wwLJNWBfsDXvi4M=
X-Received: by 2002:a25:4107:: with SMTP id o7mr2430493yba.459.1610400253047;
 Mon, 11 Jan 2021 13:24:13 -0800 (PST)
MIME-Version: 1.0
References: <20210111180609.713998-1-natechancellor@gmail.com>
 <CAK7LNAQ=38BUi-EG5v2UiuAF-BOsVe5BTd-=jVYHHHPD7ikS5A@mail.gmail.com>
 <20210111193400.GA1343746@ubuntu-m3-large-x86> <CAK7LNASZuWp=aPOCKo6QkdHwM5KG6MUv8305v3x-2yR7cKEX-w@mail.gmail.com>
 <20210111200010.GA3635011@ubuntu-m3-large-x86>
In-Reply-To: <20210111200010.GA3635011@ubuntu-m3-large-x86>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 13:24:02 -0800
Message-ID: <CAEf4BzaL18a2+j3EYaD7jcnbJzqwG2MuBxXR2iRZ3KV9Jwrj6w@mail.gmail.com>
Subject: Re: [PATCH] bpf: Hoise pahole version checks into Kconfig
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 12:00 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Tue, Jan 12, 2021 at 04:50:50AM +0900, Masahiro Yamada wrote:
> > On Tue, Jan 12, 2021 at 4:34 AM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 04:19:01AM +0900, Masahiro Yamada wrote:
> > > > On Tue, Jan 12, 2021 at 3:06 AM Nathan Chancellor
> > > > <natechancellor@gmail.com> wrote:
> > > > >
> > > > > After commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for
> > > > > vmlinux BTF"), having CONFIG_DEBUG_INFO_BTF enabled but lacking a valid
> > > > > copy of pahole results in a kernel that will fully compile but fail to
> > > > > link. The user then has to either install pahole or disable
> > > > > CONFIG_DEBUG_INFO_BTF and rebuild the kernel but only after their build
> > > > > has failed, which could have been a significant amount of time depending
> > > > > on the hardware.
> > > > >
> > > > > Avoid a poor user experience and require pahole to be installed with an
> > > > > appropriate version to select and use CONFIG_DEBUG_INFO_BTF, which is
> > > > > standard for options that require a specific tools version.
> > > > >
> > > > > Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > >
> > > >
> > > >
> > > > I am not sure if this is the right direction.
> > > >
> > > >
> > > > I used to believe moving any tool test to the Kconfig
> > > > was the right thing to do.
> > > >
> > > > For example, I tried to move the libelf test to Kconfig,
> > > > and make STACK_VALIDATION depend on it.
> > > >
> > > > https://patchwork.kernel.org/project/linux-kbuild/patch/1531186516-15764-1-git-send-email-yamada.masahiro@socionext.com/
> > > >
> > > > It was rejected.
> > > >
> > > >
> > > > In my understanding, it is good to test target toolchains
> > > > in Kconfig (e.g. cc-option, ld-option, etc).
> > > >
> > > > As for host tools, in contrast, it is better to _intentionally_
> > > > break the build in order to let users know that something needed is missing.
> > > > Then, they will install necessary tools or libraries.
> > > > It is just a one-time setup, in most cases,
> > > > just running 'apt install' or 'dnf install'.
> > > >
> > > >
> > > >
> > > > Recently, a similar thing happened to GCC_PLUGINS
> > > > https://patchwork.kernel.org/project/linux-kbuild/patch/20201203125700.161354-1-masahiroy@kernel.org/#23855673
> > > >
> > > >
> > > >
> > > >
> > > > Following this pattern, if a new pahole is not installed,
> > > > it might be better to break the build instead of hiding
> > > > the CONFIG option.
> > > >
> > > > In my case, it is just a matter of 'apt install pahole'.
> > > > On some distributions, the bundled pahole is not new enough,
> > > > and people may end up with building pahole from the source code.
> > >
> > > This is fair enough. However, I think that parts of this patch could
> > > still be salvaged into something that fits this by making it so that if
> > > pahole is not installed (CONFIG_PAHOLE_VERSION=0) or too old, the build
> > > errors at the beginning, rather at the end. I am not sure where the best
> > > place to put that check would be though.
> >
> > Me neither.
> >
> >
> > Collecting tool checks to the beginning would be user-friendly.
> > However, scattering the related code to multiple places is not
> > nice from the developer point of view.
> >
> > How big is it a problem if the build fails
> > at the very last stage?
> >
> > You can install pahole, then resume "make".
> >
> > Kbuild skips unneeded building, then you will
> > be able to come back to the last build stage shortly.
>
> There will often be times where I am testing multiple configurations in
> a row serially and the longer that a build takes to fail, the longer it
> takes for me to get a "real" result. That is my motivation behind this
> change. If people are happy with the current state of things, I will
> just stick with universally disabling CONFIG_DEBUG_INFO_BTF in my test
> framework.
>

I see where Masahiro is coming from. Not seeing CONFIG_DEBUG_INFO_BTF
option because pahole is not installed (or is not new enough) is, I
believe, for the majority of users, a much bigger confusion. Currently
they will get a specific and helpful message at the link time, which
is much more actionable, IMO. Once you fix pahole dependency, running
make again would skip all the already compiled code and would start
linking almost immediately, so if you are doing build locally there is
a very little downside.

I understand your situation is a bit different in that you are
building from scratch every single time (probably some sort of CI
setup, right?). But it's a rarer and more power-user use case. And
fixing pahole dependency is a one-time fix, so it's frustrating, but
fixable on your side.

As for disabling CONFIG_DEBUG_INFO_BTF. It's up to you and depends on
what you are after, but major distros now enable it by default, so if
you want to resemble common kernel configs, it's probably better to
stick with it.

Ideally, I'd love for Kconfig to have a way to express tool
dependencies in such a way that it's still possible to choose desired
options and if the build environment is lacking dependencies then it
would be communicated early on. I have no idea if that's doable and
how much effort it'd take, though.


> Cheers,
> Nathan
