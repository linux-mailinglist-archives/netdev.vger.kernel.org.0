Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA376404081
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 23:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352518AbhIHV0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 17:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351083AbhIHV0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 17:26:10 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904E9C061757
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 14:25:02 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k24so3962464pgh.8
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 14:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oIrl1iKEkPhOhEiYAXs9Icej/cMm4caDVRBNE890nMk=;
        b=TZmdsHFXh0pLbF1Aki2gtLI09dMbe3Ck4iTtyNnvaXyZ/0MyHfj3eTpEmvvWie3oK0
         cytHyGfWn4YRMdeRykGfsw2GmbCKItYUkNXCjAyqGo7/aybSIK4cB1hK8BHHbDC+Rglm
         +7sBlWMUqHT0wWp7Rs236+DLRPwub1Ity73wYOkcDPMzPoxx/GAUXmcsqWqXI9YuGuwg
         RYuca1gvKTUx1K4VHJOnY7D5fJTJaLdL3ilkulhIb+iGIiJVFwU+rdidcNbIWUtm+owb
         p9mg5VcxFDT4KWJ13LIAknBLMD0rOIdliDjoS+XOmvOKcnXBkz6g3fuawcYn7xjpS/HZ
         1koQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oIrl1iKEkPhOhEiYAXs9Icej/cMm4caDVRBNE890nMk=;
        b=CFTq61pSMoMSmLUdQY0Lz22n/LOwQ8tsRqc2a+O0BlSrxM+Ls/HwkZaCcV1x2kC1cT
         2uW6gY7lzFCFooQD5Xa4hXZ0HsVD9PnNcl9FpYDTzSSdM5tN3JeEHGz2ZF6CnXJx2DXD
         SnwngqPsGeT9e55VeDp5hB144nT6ZSoWaWc5xHQhfEknrkfiQ67IXPKDCpRveIx/ePs7
         N5UV/Q4qdsyqfZT1vNBiUDtLR9EV0bIIbD7Ugvb2pCIlqOYtMQ6vztrdFR96knbLkNIb
         o8ffcApU8kn4iI72rPrC1XKxB3U86zTckhoVOMBWL6TynN+LNd6mSSURQShPM4ndGNJO
         zu4Q==
X-Gm-Message-State: AOAM530HAPV1cPIPxOqNhICNwowZVQ/2/H+tkzbk1UBzyGIz0L294rd5
        P1nNoZ0Zs1MoPALYZ4eFLTHIte5hoEwCJ/SMr5nn3w==
X-Google-Smtp-Source: ABdhPJyUrdsaj05MhT3SMnsbrzqT90+34gdQiJaQ/ddhshRsBjoS6XuOMJPHdXQfVHjUjKB5Qt1vTuPUMgCizyFpLN8=
X-Received: by 2002:a62:1b92:0:b0:3eb:3f92:724 with SMTP id
 b140-20020a621b92000000b003eb3f920724mr147019pfb.3.1631136301711; Wed, 08 Sep
 2021 14:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
 <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com> <120389b9-f90b-0fa3-21d5-1f789b4c984d@linuxfoundation.org>
In-Reply-To: <120389b9-f90b-0fa3-21d5-1f789b4c984d@linuxfoundation.org>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Wed, 8 Sep 2021 14:24:50 -0700
Message-ID: <CAFd5g47MgGCoenw08hehegstQSujT7AwksQkxA7mQgKhChimNw@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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

On Wed, Sep 8, 2021 at 10:16 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 9/8/21 11:05 AM, Arnd Bergmann wrote:
> > On Wed, Sep 8, 2021 at 4:12 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >> On 9/7/21 5:14 PM, Linus Torvalds wrote:
> >>> The KUNIT macros create all these individually reasonably small
> >>> initialized structures on stack, and when you have more than a small
> >>> handful of them the KUNIT infrastructure just makes the stack space
> >>> explode. Sometimes the compiler will be able to re-use the stack
> >>> slots, but it seems to be an iffy proposition to depend on it - it
> >>> seems to be a combination of luck and various config options.
> >>>
> >>
> >> I have been concerned about these macros creeping in for a while.
> >> I will take a closer look and work with Brendan to come with a plan
> >> to address it.
> >
> > I've previously sent patches to turn off the structleak plugin for
> > any kunit test file to work around this, but only a few of those patches
> > got merged and new files have been added since. It would
> > definitely help to come up with a proper fix, but my structleak-disable
> > hack should be sufficient as a quick fix.
> >
>
> Looks like these are RFC patches and the discussion went cold. Let's pick
> this back up and we can make progress.
>
> https://lore.kernel.org/lkml/CAFd5g45+JqKDqewqz2oZtnphA-_0w62FdSTkRs43K_NJUgnLBg@mail.gmail.com/

I can try to get the patch reapplying and send it out (I just figured
that Arnd or Kees would want to send it out :-)  since it was your
idea).

I definitely agree that in the cases where KUnit is not actually
contributing to blowing the stack - struct leak just thinks it is,
this is fine; however, it sounds like Linus' concerns with KUnit's
macros go deeper than this. Arnd, I think you sketched out a way to
make the KUNIT_* macros take up less space, but after some
investigation we found that it was pretty inflexible.

Ideally test cases should never get big enough for KUNIT_* macros to
be a problem (when they do it is usually an indication that your test
case is trying to do too many things); nevertheless, we are still in
this situation.

I think I will need to dust off some cobwebs out of my brain to
remember why I didn't like the idea of making the KUNIT_* macros take
up less stack space.
