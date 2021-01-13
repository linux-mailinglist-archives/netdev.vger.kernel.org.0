Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F802F551C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 00:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbhAMXJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 18:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbhAMWj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 17:39:57 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05789C061786;
        Wed, 13 Jan 2021 14:38:39 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id v126so4473480qkd.11;
        Wed, 13 Jan 2021 14:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GFmuZbwYLEmY3pcAyxIqKW63OwSHxC/C2Nsx5FErA3M=;
        b=hIir710Y6kxpAHZTvbj+ffs1bXRvZ3R6UMphoJudDGq1vFfwGjoNYxfrfrunyTUfWA
         MncASkBXMdmio6tzJs6zzIiAubWBxk6byNvp9n+USJrqh+Q1ARYS+fxdA6Qb6scDx9RH
         2F6zqYZjxUyUKD95BqzmZ+eWx9xBl0015/HBT8gfhizvmAt0WPduQBNK0A0qgZXNeZc/
         eL0ztWXHKWY6Lwv6x9b/1TTDI4NHANFotVgPzMfpoi0A0O4GS/BTl2BmTs5NbKCYs7Nc
         7RX8eqt9R59x+EFNf4RC/vE1qr/QG+O5VFSQk8Ejo7Aa+HoCv6xwY/rfZP7jRT29oPMR
         ErRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GFmuZbwYLEmY3pcAyxIqKW63OwSHxC/C2Nsx5FErA3M=;
        b=FZv4WZjiNx1DZ2/utr6sdlkRcUI+pOsmxukt00TkLcBFTDnEocdvGkBBfk9kPXxPF6
         IsOyqglVROivJmk4auzjGFWCrk31wnfflF6BvYEcMXrwEve4DtiBCD0fsGD9wq8Q236s
         6x5UhFtBe8sDtCLSzcst6tlbkElLvscbUOmeUh19pagY/Cq4zQHOjt5dtKdsvGkJfnJ4
         Oj14ZCMB/WiSrmvGXyYIQlqxb2XBtN2CYIJnZqSdHlUbuwnYABsC42VJATRII+nu+HtV
         2694/1h4CixewVpqHYYFnY4MnEe0y7XErkHuWrlWosacqNthPGm9KeXGKhr5GuZ8ymxL
         ALCw==
X-Gm-Message-State: AOAM532BaPCMoEmQ/cj49CBc165ZhuPoKl3K+iLlcEiv1a361juteM0Z
        UqVCX6SPxLiK1vWt4pBcWgj9YaoVlJG9pOYBPTzVX6EMCscdIQ==
X-Google-Smtp-Source: ABdhPJzzpwWInqnLViASKl37booGT/1A7M5OcmFRDXKtg+RpYX/VBPCb/A28aLKe7hwx7Rg6ieepYUskBNCWKaZHnpI=
X-Received: by 2002:a25:4107:: with SMTP id o7mr6281815yba.459.1610577518196;
 Wed, 13 Jan 2021 14:38:38 -0800 (PST)
MIME-Version: 1.0
References: <20210111180609.713998-1-natechancellor@gmail.com>
 <CAK7LNAQ=38BUi-EG5v2UiuAF-BOsVe5BTd-=jVYHHHPD7ikS5A@mail.gmail.com>
 <20210111193400.GA1343746@ubuntu-m3-large-x86> <CAK7LNASZuWp=aPOCKo6QkdHwM5KG6MUv8305v3x-2yR7cKEX-w@mail.gmail.com>
 <20210111200010.GA3635011@ubuntu-m3-large-x86> <CAEf4BzaL18a2+j3EYaD7jcnbJzqwG2MuBxXR2iRZ3KV9Jwrj6w@mail.gmail.com>
In-Reply-To: <CAEf4BzaL18a2+j3EYaD7jcnbJzqwG2MuBxXR2iRZ3KV9Jwrj6w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Jan 2021 14:38:27 -0800
Message-ID: <CAEf4Bzbv6nrJNxbZAvFx4Djvf1zbWnrV_i90vPGHtV-W7Tz=bQ@mail.gmail.com>
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

On Mon, Jan 11, 2021 at 1:24 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jan 11, 2021 at 12:00 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 04:50:50AM +0900, Masahiro Yamada wrote:
> > > On Tue, Jan 12, 2021 at 4:34 AM Nathan Chancellor
> > > <natechancellor@gmail.com> wrote:
> > > >
> > > > On Tue, Jan 12, 2021 at 04:19:01AM +0900, Masahiro Yamada wrote:
> > > > > On Tue, Jan 12, 2021 at 3:06 AM Nathan Chancellor
> > > > > <natechancellor@gmail.com> wrote:
> > > > > >
> > > > > > After commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for
> > > > > > vmlinux BTF"), having CONFIG_DEBUG_INFO_BTF enabled but lacking a valid
> > > > > > copy of pahole results in a kernel that will fully compile but fail to
> > > > > > link. The user then has to either install pahole or disable
> > > > > > CONFIG_DEBUG_INFO_BTF and rebuild the kernel but only after their build
> > > > > > has failed, which could have been a significant amount of time depending
> > > > > > on the hardware.
> > > > > >
> > > > > > Avoid a poor user experience and require pahole to be installed with an
> > > > > > appropriate version to select and use CONFIG_DEBUG_INFO_BTF, which is
> > > > > > standard for options that require a specific tools version.
> > > > > >
> > > > > > Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > > > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > > >
> > > > >
> > > > >
> > > > > I am not sure if this is the right direction.
> > > > >
> > > > >
> > > > > I used to believe moving any tool test to the Kconfig
> > > > > was the right thing to do.
> > > > >
> > > > > For example, I tried to move the libelf test to Kconfig,
> > > > > and make STACK_VALIDATION depend on it.
> > > > >
> > > > > https://patchwork.kernel.org/project/linux-kbuild/patch/1531186516-15764-1-git-send-email-yamada.masahiro@socionext.com/
> > > > >
> > > > > It was rejected.
> > > > >
> > > > >
> > > > > In my understanding, it is good to test target toolchains
> > > > > in Kconfig (e.g. cc-option, ld-option, etc).
> > > > >
> > > > > As for host tools, in contrast, it is better to _intentionally_
> > > > > break the build in order to let users know that something needed is missing.
> > > > > Then, they will install necessary tools or libraries.
> > > > > It is just a one-time setup, in most cases,
> > > > > just running 'apt install' or 'dnf install'.
> > > > >
> > > > >
> > > > >
> > > > > Recently, a similar thing happened to GCC_PLUGINS
> > > > > https://patchwork.kernel.org/project/linux-kbuild/patch/20201203125700.161354-1-masahiroy@kernel.org/#23855673
> > > > >
> > > > >
> > > > >
> > > > >
> > > > > Following this pattern, if a new pahole is not installed,
> > > > > it might be better to break the build instead of hiding
> > > > > the CONFIG option.
> > > > >
> > > > > In my case, it is just a matter of 'apt install pahole'.
> > > > > On some distributions, the bundled pahole is not new enough,
> > > > > and people may end up with building pahole from the source code.
> > > >
> > > > This is fair enough. However, I think that parts of this patch could
> > > > still be salvaged into something that fits this by making it so that if
> > > > pahole is not installed (CONFIG_PAHOLE_VERSION=0) or too old, the build
> > > > errors at the beginning, rather at the end. I am not sure where the best
> > > > place to put that check would be though.
> > >
> > > Me neither.
> > >
> > >
> > > Collecting tool checks to the beginning would be user-friendly.
> > > However, scattering the related code to multiple places is not
> > > nice from the developer point of view.
> > >
> > > How big is it a problem if the build fails
> > > at the very last stage?
> > >
> > > You can install pahole, then resume "make".
> > >
> > > Kbuild skips unneeded building, then you will
> > > be able to come back to the last build stage shortly.
> >
> > There will often be times where I am testing multiple configurations in
> > a row serially and the longer that a build takes to fail, the longer it
> > takes for me to get a "real" result. That is my motivation behind this
> > change. If people are happy with the current state of things, I will
> > just stick with universally disabling CONFIG_DEBUG_INFO_BTF in my test
> > framework.
> >
>
> I see where Masahiro is coming from. Not seeing CONFIG_DEBUG_INFO_BTF
> option because pahole is not installed (or is not new enough) is, I
> believe, for the majority of users, a much bigger confusion. Currently
> they will get a specific and helpful message at the link time, which
> is much more actionable, IMO. Once you fix pahole dependency, running
> make again would skip all the already compiled code and would start
> linking almost immediately, so if you are doing build locally there is
> a very little downside.

Hm.. Just saw Linus proposing using $(error-if) in Kconfig for an
unrelated issue ([0]). If we can make this work, then it would catch
such issue early on, yet won't have any downsides of hiding
CONFIG_DEBUG_INFO_BTF if pahole is too old. WDYT?

  [0] https://lore.kernel.org/lkml/CAHk-=wh-+TMHPTFo1qs-MYyK7tZh-OQovA=pP3=e06aCVp6_kA@mail.gmail.com/

>
> I understand your situation is a bit different in that you are
> building from scratch every single time (probably some sort of CI
> setup, right?). But it's a rarer and more power-user use case. And
> fixing pahole dependency is a one-time fix, so it's frustrating, but
> fixable on your side.
>
> As for disabling CONFIG_DEBUG_INFO_BTF. It's up to you and depends on
> what you are after, but major distros now enable it by default, so if
> you want to resemble common kernel configs, it's probably better to
> stick with it.
>
> Ideally, I'd love for Kconfig to have a way to express tool
> dependencies in such a way that it's still possible to choose desired
> options and if the build environment is lacking dependencies then it
> would be communicated early on. I have no idea if that's doable and
> how much effort it'd take, though.
>
>
> > Cheers,
> > Nathan
