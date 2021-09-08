Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C318404104
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 00:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbhIHW3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 18:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIHW3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 18:29:21 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9495C061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 15:28:12 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id p15so6031552ljn.3
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 15:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HytL3xsN3IMbAtrWbKtS0/nCsgiMyvgWe9lZNEOySKA=;
        b=SJXzuSl05zhxWmOOxzrxPh7OyWUCJWmBdrtaUM4PikTlgdmjLPd/RVuMt8u2D9I6bT
         RMeoTQySffZUogvn6gYJOWzzTpsd+b3QH+x/GYCf4BNoTJcqc/2dIJ2d8ypfcYppmk5I
         6Ere6VJaPGXH1QOd5jA2MTtAJ9xImqzIFObv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HytL3xsN3IMbAtrWbKtS0/nCsgiMyvgWe9lZNEOySKA=;
        b=d9J7XeIdaiC13CkenlRGiGpcwdQzBPy+RxrsZfyuIBTEUyJGiFVGkOEdlDalLmRUBu
         HGhSTJTobNiWqh/WMyKfvxryIdOEHrc6H0NA4SGR1SSRr85IPGJFpCKKEZuTMYonnnzE
         SumBiglCxs3TSW8zOHiufK1e2ir0IqOp7HsURbd+IlKUkuLQwmKwfW5Sr6ZP5diFk+zH
         tj07HKZL5+R9iMzHwNiAJy3fZMG2XPptEru0U0i3abGAmdA7ZS0joO6VKteGAq8Elj8a
         pfnEL8JJW4WistY7r+84553t3f/8Sipu+HtSAx6BeZ6g+4eWhHGvdY1qSSZ9795bnNfp
         vyhA==
X-Gm-Message-State: AOAM5310ifDwr3C5QyJul3mThRt7JyHnoRVbYYbUB5bNB36t0YCeUeU1
        831TiBGRFshxhExg9EBxhadovmhSY6w1TpgqG1A=
X-Google-Smtp-Source: ABdhPJxQfGlsfQZIR0U0YlWq7rRyjl9K95Aegl0/hzNPeIRN1ZHHuJ+1W914uPHSglFztEc1A/gzMg==
X-Received: by 2002:a2e:90ca:: with SMTP id o10mr462638ljg.67.1631140090707;
        Wed, 08 Sep 2021 15:28:10 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id r4sm33460lfc.188.2021.09.08.15.28.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 15:28:09 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id w4so5991893ljh.13
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 15:28:08 -0700 (PDT)
X-Received: by 2002:a2e:a7d0:: with SMTP id x16mr441752ljp.494.1631140088653;
 Wed, 08 Sep 2021 15:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
 <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
 <120389b9-f90b-0fa3-21d5-1f789b4c984d@linuxfoundation.org> <CAFd5g47MgGCoenw08hehegstQSujT7AwksQkxA7mQgKhChimNw@mail.gmail.com>
In-Reply-To: <CAFd5g47MgGCoenw08hehegstQSujT7AwksQkxA7mQgKhChimNw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 15:27:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiQoxwGkMF34k3twte0N2phNCjbxtsgoW9YNybVPXZtsA@mail.gmail.com>
Message-ID: <CAHk-=wiQoxwGkMF34k3twte0N2phNCjbxtsgoW9YNybVPXZtsA@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Brendan Higgins <brendanhiggins@google.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        KUnit Development <kunit-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 2:25 PM Brendan Higgins
<brendanhiggins@google.com> wrote:
>
> I definitely agree that in the cases where KUnit is not actually
> contributing to blowing the stack - struct leak just thinks it is,
> this is fine; however, it sounds like Linus' concerns with KUnit's
> macros go deeper than this.

I don't mind Kunit tests when they don't cause problems, but one very
natural way to use the Kunit test infrastructure does seem to be to
just put a lot of them into one function.

And then the individually fairly small structures just add up.
Probably mainly in some special configurations (ie together with
CONFIG_KASAN_STACK as pointed out by Arnd, but there might be other
cases that cause that issue too) where the compiler then doesn't merge
stack slots.

I wonder if those 'kunit_assert' structures could be split into two:
one part that could be 'static const', and at least shrink the dynamic
stack use that way. Because at a minimun, things like
type/file/line/format-msg seem to be things that really are just
static and const.

Hmm?

          Linus
