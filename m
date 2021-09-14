Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF2940B96E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 22:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhINUsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 16:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbhINUsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 16:48:23 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5ECC061574
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 13:47:05 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v1so182724plo.10
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 13:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6sjgsRXHAAZe5EpmfS0mxe4gOnh7qI8vZt4uYNXxzk=;
        b=E92+P6I/zl5VP9TVKRsNL+Ylr6HQVo9mHZ/GiiOaVcKvrSJhfz2YAqxKHcRoGPAouS
         gUGcTf+QgD5OqLQE/23Jw8K+0+WMHUd932I6GUprDEO7F4aRnU9rgIQ+STPts8y8nrv9
         +cvBMgYAsIfDX5vZ2McLpy0jIVA/6UqgpnPzACepffwMZSCbdnbTWoUSGkr3F7wd3MGs
         pu6pcdii/cEFRINOc4mECjUQ1vyKgli82I/4Ckar4LaCEY3k1BMKRD+91ZCW8cIz9TZe
         1HTM73axiD6zbYIBnfp1qs9U8f/hMloM0ZttGHMMvtvPCmCsD0E+IGUiO7V3L+nlyABu
         lvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6sjgsRXHAAZe5EpmfS0mxe4gOnh7qI8vZt4uYNXxzk=;
        b=PzYjmxliaRbv8/2vhWuqlWjsCyLkhaKnQS9XVhvKYRlCdjOcb9WrC9ivSdxsc0VYN2
         mp+Z61gcq8auubKyKqfxP0GWoJcGEV48vFyc9n2sDdAGti5pxv6vhe6g6QsFHNg36F2Z
         lOwq5OmwtgJDOtTrZj2gFeXi8xrgUTH5jsTUmqx8K4GOt3DU4ICBM4lvnCJyqM90NzDE
         bBR+gcQANNu35Xi9aJonfSleRf48sYk9QmXNq5O3loLV0+/3WH5vOH1kSzMIVJ1ctjyD
         6i+TLqEZ2rjrSy2CQqv3p6lyaVw8XvNlgGuvuuiaJ4/eSWS+9QbeoKZetznf7NymG+4Z
         wG4Q==
X-Gm-Message-State: AOAM533J5fX1qbnr+PzLRa/Fl2ggLa4NC+CTTQgkR33y0J9ffViwRiIa
        J0ckADnInS8h5aJPuSaRW6IT7NJGKNVjjMhAJcg7+g==
X-Google-Smtp-Source: ABdhPJyd8cTnpvNGrPcB7rDUXyzlfuperCL06Jsg632npMA9exX1dQjA6dOdA02bgoQpeqRJNkDcGKqaHCx/3gKXW2s=
X-Received: by 2002:a17:90a:1d4c:: with SMTP id u12mr4095618pju.95.1631652424662;
 Tue, 14 Sep 2021 13:47:04 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
 <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
 <120389b9-f90b-0fa3-21d5-1f789b4c984d@linuxfoundation.org>
 <CAFd5g47MgGCoenw08hehegstQSujT7AwksQkxA7mQgKhChimNw@mail.gmail.com> <3bad5d2f-8ce7-d0b9-19ad-def68d4193dd@linuxfoundation.org>
In-Reply-To: <3bad5d2f-8ce7-d0b9-19ad-def68d4193dd@linuxfoundation.org>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Tue, 14 Sep 2021 13:46:53 -0700
Message-ID: <CAFd5g47bZbqGgMn8PVa=DaSFfjnJsLGVsLTYzmmCOpdv-TfUSQ@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

On Mon, Sep 13, 2021 at 1:55 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 9/8/21 3:24 PM, Brendan Higgins wrote:
> > On Wed, Sep 8, 2021 at 10:16 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>
> >> On 9/8/21 11:05 AM, Arnd Bergmann wrote:
> >>> On Wed, Sep 8, 2021 at 4:12 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>>> On 9/7/21 5:14 PM, Linus Torvalds wrote:
> >>>>> The KUNIT macros create all these individually reasonably small
> >>>>> initialized structures on stack, and when you have more than a small
> >>>>> handful of them the KUNIT infrastructure just makes the stack space
> >>>>> explode. Sometimes the compiler will be able to re-use the stack
> >>>>> slots, but it seems to be an iffy proposition to depend on it - it
> >>>>> seems to be a combination of luck and various config options.
> >>>>>
> >>>>
> >>>> I have been concerned about these macros creeping in for a while.
> >>>> I will take a closer look and work with Brendan to come with a plan
> >>>> to address it.
> >>>
> >>> I've previously sent patches to turn off the structleak plugin for
> >>> any kunit test file to work around this, but only a few of those patches
> >>> got merged and new files have been added since. It would
> >>> definitely help to come up with a proper fix, but my structleak-disable
> >>> hack should be sufficient as a quick fix.
> >>>
> >>
> >> Looks like these are RFC patches and the discussion went cold. Let's pick
> >> this back up and we can make progress.
> >>
> >> https://lore.kernel.org/lkml/CAFd5g45+JqKDqewqz2oZtnphA-_0w62FdSTkRs43K_NJUgnLBg@mail.gmail.com/
> >
> > I can try to get the patch reapplying and send it out (I just figured
> > that Arnd or Kees would want to send it out :-)  since it was your
> > idea).
> >
>
> Brendan,
>
> Would you like to send me the fix with Suggested-by for Arnd or Kees?

So it looks like Arnd's fix was accepted (whether by him or someone
else) for property-entry-test and Linus already fixed thunderbolt, so
the only remaining of Arnd's patches is for the bitfield test, so I'll
resend that one in a bit.

Also, I haven't actually tried Linus' suggestion yet, but the logic is
sound and the change *should* be fairly unintrusive - I am going to
give that a try and report back (but I will get the bitfield
structleak disable patch out first since I already got that applying).
