Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A41555131
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376473AbiFVQVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237052AbiFVQVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:21:30 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEEB37A9D
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:21:29 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z19so7795790edb.11
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=La2lbdp3UKjWCqW4lfnhUIczS1kJzOzEyt2PeIAhoKo=;
        b=FfAyOh/DVgRc9cG+OdaMU7PGb120Oo+8Kt5ymO0wHtxBrqKW6X7uECKSgxFEsKK7FZ
         ++TO/Q/qoaRDQ3KpT2ZrF2Di7QOCKeDTU2gFD7Id15IeekIIww1BKJvriU3KWot8Qpd6
         m/1qCo3kwFiKykHlUgjb8oqTit3FZn4QWp6Bs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=La2lbdp3UKjWCqW4lfnhUIczS1kJzOzEyt2PeIAhoKo=;
        b=EkcVIA+6CGnuBdUKvgud0Nu5ENYTivSS2KeSyOrcDQWSVRJs0fp8DOqxbF/QduCwD5
         NuIG9OR5J3ZfE2a4gAbbpj1QbfXItxh4tpDnMHD3I0yTJQ5DyFLAUcIeHpQZGouPGO4v
         /m/TUT0Y3uiBLDzOXzsQ91LxJoZOBg5M+vyl6nULjfWFZZmsYCvfMhOcELUL4uVYEKlY
         TdIoJ6eddH7MsysrLCljQFa1ZNDzCY7mxtBylLaIYGg5hJ97J2COBH96wEMCHPzaBXAw
         PyRbgATaHGI/BJ3cT87/QISGZdl2UW9WzDjAT8Y3qrpB6JcSyDKkkyKOYZDjGwFo3tmj
         9+Tw==
X-Gm-Message-State: AJIora/w3pZNqcakhg7Ncg5Vfm4IPONCLicD0MLD6gSBuQWb6bCT4ZdD
        mx1/tlnWOSm4pOXQXSW/0jw9/0QoiEOInnSp
X-Google-Smtp-Source: AGRyM1vXCBMhq4RSATXpM4bi8kX7JA34WNffpUJ1Q0zvpjhH6S7PbrsFoHCGgVBd9ASQS9FNtMoO7A==
X-Received: by 2002:aa7:c846:0:b0:431:6c7b:26af with SMTP id g6-20020aa7c846000000b004316c7b26afmr4953350edt.123.1655914887547;
        Wed, 22 Jun 2022 09:21:27 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id qw21-20020a1709066a1500b0070c4abe4706sm2166174ejc.158.2022.06.22.09.21.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 09:21:26 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id r20so3723578wra.1
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:21:26 -0700 (PDT)
X-Received: by 2002:a5d:6da3:0:b0:219:bcdd:97cd with SMTP id
 u3-20020a5d6da3000000b00219bcdd97cdmr4126190wrs.274.1655914886112; Wed, 22
 Jun 2022 09:21:26 -0700 (PDT)
MIME-Version: 1.0
References: <YrLtpixBqWDmZT/V@debian> <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
 <YrMu5bdhkPzkxv/X@dev-arch.thelio-3990X>
In-Reply-To: <YrMu5bdhkPzkxv/X@dev-arch.thelio-3990X>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 22 Jun 2022 11:21:09 -0500
X-Gmail-Original-Message-ID: <CAHk-=wjTS9OJzggD8=tqtj0DoRCKhjjhpYWoB=bPQAv3QMa+eA@mail.gmail.com>
Message-ID: <CAHk-=wjTS9OJzggD8=tqtj0DoRCKhjjhpYWoB=bPQAv3QMa+eA@mail.gmail.com>
Subject: Re: mainline build failure due to 281d0c962752 ("fortify: Add Clang support")
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_RED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 10:02 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Right, we are working on a statically linked and optimized build of LLVM
> that people can use similar to the GCC builds provided on kernel.org,
> which should make the compile time problem not as bad as well as making
> it easier for developers to get access to a recent version of clang with
> all the fixes and improvements that we have made in upstream LLVM.

So I'm on the road, and will try to see how well I can do that
allmodconfig build on my poor laptop and see what else goes wrong for
now.

But I do have to say that it's just a lot better if the regular distro
compiler build works out of the box. I did build my own clang binary
for a while, just because I was an early adopter of the whole "ask
goto with outputs" thing, but I've been *so* much happier now that I
don't need to do that any more.

So I would prefer not going backwards.

I wish the standard clang build just stopped doing the crazy shared
library thing. The security arguments for it are just ridiculous, when
any shared library update for any security reason would mean a full
clang update _anyway_.

I realize it's partly distro rules too, but the distros only do that
"we always build shared libraries" when the project itself makes that
an option. And it's a really stupid option for the regular C compiler
case.

Side note: I think gcc takes almost exactly the opposite approach, and
does much better as a result. It doesn't do a shared libary, but what
it *does* do is make 'gcc' itself a reasonably small binary that just
does the command line front-end parsing.

The advantage of the gcc model is that it works *really* well for the
"test compiler options" kind of stage, where you only run that much
simpler 'gcc' wrapper binary.

We don't actually take full advantage of that, because we do end up
doing a real "build" of an empty file, so "cc1" does actually get
executed, but even then it's done fairly efficiently with 'vfork()'.
That "cc-option" part of the kernel build is actually noticeable
during configuration etc, and clang is *much* slower because of how it
is built.

See

    time clang -Werror -c -x c /dev/null

and compare it with gcc. And if you want to see a really *big*
difference, pick a command line option that causes an error because it
doesn't exist..

I really wish clang wasn't so much noticeably slower. It's limiting
what I do with it, and I've had other developers say the same.

              Linus
