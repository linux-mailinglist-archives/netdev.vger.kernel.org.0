Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F103564D8
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 09:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346210AbhDGHO6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Apr 2021 03:14:58 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:45761 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbhDGHO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 03:14:57 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MN5S1-1lAzwY10Lt-00J577; Wed, 07 Apr 2021 09:14:47 +0200
Received: by mail-ot1-f54.google.com with SMTP id t23-20020a0568301e37b02901b65ab30024so17146610otr.4;
        Wed, 07 Apr 2021 00:14:46 -0700 (PDT)
X-Gm-Message-State: AOAM533ijP9FsvZaCqFLJmVKfyMnEUedAmzEMkRe4ahxLHmoJOLpemSo
        FVCjzCwaqu48lI8HVNN8FYYv13Z1Ake6FaOGwm8=
X-Google-Smtp-Source: ABdhPJzrIZhYXItVAxtqu5MmrQDcheg3tt+tjK1y9xVKCotkoT58FygXjEd09CP1R5SrCLdP/bDhZsopatSCmobWRH0=
X-Received: by 2002:a9d:316:: with SMTP id 22mr1794535otv.210.1617779685848;
 Wed, 07 Apr 2021 00:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210407002450.10015-1-kabel@kernel.org>
In-Reply-To: <20210407002450.10015-1-kabel@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 7 Apr 2021 09:14:29 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0_ruZSMv-kLMY7Jja7wq0K3aNNDviYqQPmN-3UayiHaQ@mail.gmail.com>
Message-ID: <CAK8P3a0_ruZSMv-kLMY7Jja7wq0K3aNNDviYqQPmN-3UayiHaQ@mail.gmail.com>
Subject: Re: [PATCH kbuild] Makefile.extrawarn: disable -Woverride-init in W=1
To:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:nGe4iDaSAQlxeBYnY1czYXTV1qG5NF3Owh6p2zOLtrNqQlRb+qM
 QYyzLHhOSVUrGXMRPp7Jf/CdFElPmOm5U4IcQEo/reqKiIQ2wIVO+yOIegsrr8rm4CWGFes
 QVZH2gCS57EfVuTDJgcDoT4c+FqPfcxWaJWB0rkfikoUEN5rlQYjCtJ94+XpxtZfS4WphcP
 hWXT8YZRVMzbEnR2BwYzQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:x73bQBwiFBY=:V73UEuG0tWZf0jV9AcbVT4
 NO3Y0tSNwRX9B7VwO7a/1MQ8OhtS0hEtdSdwjOTgtuqh534B0dDQoq3bLl4/ERgweal0dEwSA
 /PA17nf6XmCOYuRF9aDKqoGYYCEFvFxiFaVqC4dxBoMpYb0yRjSb1o4ynaJkwK4bofyEjAkiZ
 tEEF3wB2f4ZDUBZ/6beaTqKr3BAGfJ9RbvxsnvHgOrnsyDzsNrFDLBGNLdUWlfCbU4N4SO6I+
 du+YD3NOD7ZfpYPGaq3u0MFIVb6/XdRxsWunjRLJtSUYOJy/Jnbhe/XRFVJY5SHiiaWTx3RVz
 +LPcB3Os4gkZMKKgwAGMengUbZ0YG+Xtk3Ic5h4zYNirvWA18dE0nEXi7RUuLqOMYLjW2VN1o
 JUw1S2oCkPBI78zhhrhW2Ad3LrE9YZ/Ox9fWN3SQeuqcVoj2wfGvw3pj3JL2tgzmG6SP6FDII
 9yt61tmbVndFbBikHM7EsEJ9rlJgZNs=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 2:24 AM Marek Behún <kabel@kernel.org> wrote:
>
> The -Wextra flag enables -Woverride-init in newer versions of GCC.
>
> This causes the compiler to warn when a value is written twice in a
> designated initializer, for example:
>   int x[1] = {
>     [0] = 3,
>     [0] = 3,
>   };
>
> Note that for clang, this was disabled from the beginning with
> -Wno-initializer-overrides in commit a1494304346a3 ("kbuild: add all
> Clang-specific flags unconditionally").
>
> This prevents us from implementing complex macros for compile-time
> initializers.

I think this is generally a useful warning, and it has found a number
of real bugs. I would want this to be enabled in both gcc and clang
by default, and I have previously sent both bugfixes and patches to
disable it locally.

> For example a macro of the form INITIALIZE_BITMAP(bits...) that can be
> used as
>   static DECLARE_BITMAP(bm, 64) = INITIALIZE_BITMAP(0, 1, 32, 33);
> can only be implemented by allowing a designated initializer to
> initialize the same members multiple times (because the compiler
> complains even if the multiple initializations initialize to the same
> value).

We don't have this kind of macro at the moment, and this may just mean
you need to try harder to come up with a definition that only initializes
each member once if you want to add this.

How do you currently define it?

            Arnd
