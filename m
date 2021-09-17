Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC7440F1AF
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 07:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244891AbhIQFlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 01:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbhIQFlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 01:41:21 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8795C061764
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 22:39:59 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v1so5415727plo.10
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 22:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tDmd8ycUb5A33cqxczJ56wHGFGeWT2rzATobJNiElZc=;
        b=mjKLzQ4indMMpCe2+SSAdTsz4b8weE1gFwDDjCVqrp9B3pKj/bdL1dSfl3/8kMyDCa
         OwNV8mBPxU0bohv0fNfCJuap5gQU8HNWcHGvgWIX9Lhe7vGcS0pmJGS5ohNAPqSW6y2b
         HqPHz2ZXAbYY+37RrveljTcqnLFKRWJM074UPOg0nvYDWFIceiA6ATCiTK4fbdFOd+Vo
         dqzJiLqCMHcx+FD5eJ2pRWB6exkXZDw4haYWbQNDsI6lawjDscBFXvjHFo6B0WPx7Aoy
         3w8qeKXz5bhoAg7yncGtqLrlHT7BrfpztPQ9n7irXnqvU4hMwQ7+uzq+gLEMQP63o4JJ
         +kHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tDmd8ycUb5A33cqxczJ56wHGFGeWT2rzATobJNiElZc=;
        b=XjXEsrTs2tO6h2sgq+sNTS9jnwVuHO9eXM1sOcdl3lcL7XMN0dV+C2gVAsAQpvBW3b
         tzk7IiLRN7x3TfitFhWlWsD8UXxMbBjOEh+TivLIguwAcIRjEHQvMGBY4vtZm0fLK4Y/
         S01DshptoW/PsOGKE12suxo3pyWKz295Fb7L4zEwV9GlzEBbRDDcwrF+FDd9mp82yoLs
         i9PIen764JD1Mp5YQsyQR6+R5ytkqlt15MVkjvtda6VEpkP/bqWLyw21+pU6E/Gpl9PV
         0RcrEANFxlnfL3xQc/JoLX9sKcfdkQtsLyV1XUhPP+3EUfG/Ub9lvl3PeqhAjEeVY6Fz
         I3rQ==
X-Gm-Message-State: AOAM533V0SHPLlZZXdDfQLgUJ4hqC0y71wgplCofyxiYeQWI9evqCHIb
        WyEukp13wsMjJ7fh4m2EGhfn6wy5DKSeMgoalqD2rg==
X-Google-Smtp-Source: ABdhPJzZMkaEHIdpYul5buHW1Dv1P4OGtrg3QMqu5AMf+ifi+Fe4a5b98Wn+iDry0ryDPZOE6JwsAGuPU3s4o9OB4gc=
X-Received: by 2002:a17:902:6f17:b0:139:eec4:867e with SMTP id
 w23-20020a1709026f1700b00139eec4867emr8140416plk.77.1631857198933; Thu, 16
 Sep 2021 22:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
 <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
 <120389b9-f90b-0fa3-21d5-1f789b4c984d@linuxfoundation.org>
 <CAFd5g47MgGCoenw08hehegstQSujT7AwksQkxA7mQgKhChimNw@mail.gmail.com>
 <3bad5d2f-8ce7-d0b9-19ad-def68d4193dd@linuxfoundation.org>
 <CAFd5g47bZbqGgMn8PVa=DaSFfjnJsLGVsLTYzmmCOpdv-TfUSQ@mail.gmail.com> <CAK8P3a0wQC+9_3wJEACgOLa9C5_zLSmDfU=_79h_KMSE_9JxRw@mail.gmail.com>
In-Reply-To: <CAK8P3a0wQC+9_3wJEACgOLa9C5_zLSmDfU=_79h_KMSE_9JxRw@mail.gmail.com>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Thu, 16 Sep 2021 22:39:47 -0700
Message-ID: <CAFd5g44udqkDiYBWh+VeDVJ=ELXeoXwunjv0f9frEN6HJODZng@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
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

On Tue, Sep 14, 2021 at 3:04 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Sep 14, 2021 at 10:48 PM Brendan Higgins
> <brendanhiggins@google.com> wrote:
> >
> > On Mon, Sep 13, 2021 at 1:55 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
> > >
> > > On 9/8/21 3:24 PM, Brendan Higgins wrote:
> > > Brendan,
> > >
> > > Would you like to send me the fix with Suggested-by for Arnd or Kees?
> >
> > So it looks like Arnd's fix was accepted (whether by him or someone
> > else) for property-entry-test and Linus already fixed thunderbolt, so
> > the only remaining of Arnd's patches is for the bitfield test, so I'll
> > resend that one in a bit.
> >
> > Also, I haven't actually tried Linus' suggestion yet, but the logic is
> > sound and the change *should* be fairly unintrusive - I am going to
> > give that a try and report back (but I will get the bitfield
> > structleak disable patch out first since I already got that applying).
>
> Looking at my randconfig tree, I find these six instances:
>
> $ git grep -w DISABLE_STRUCTLEAK_PLUGIN
> drivers/base/test/Makefile:CFLAGS_property-entry-test.o +=
> $(DISABLE_STRUCTLEAK_PLUGIN)
> drivers/iio/test/Makefile:CFLAGS_iio-test-format.o +=
> $(DISABLE_STRUCTLEAK_PLUGIN)
> drivers/mmc/host/Makefile:CFLAGS_sdhci-of-aspeed.o              +=
> $(DISABLE_STRUCTLEAK_PLUGIN)
> drivers/thunderbolt/Makefile:CFLAGS_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
> lib/Makefile:CFLAGS_test_scanf.o += $(DISABLE_STRUCTLEAK_PLUGIN)
> lib/Makefile:CFLAGS_bitfield_kunit.o += $(DISABLE_STRUCTLEAK_PLUGIN)
> scripts/Makefile.gcc-plugins:    DISABLE_STRUCTLEAK_PLUGIN +=
> -fplugin-arg-structleak_plugin-disable
> scripts/Makefile.gcc-plugins:export DISABLE_STRUCTLEAK_PLUGIN

Alright, I incorporated all the above into a patchset that I think is
ready to send out, but I had a couple of issues with the above
suggestions:

- I could not find a config which causes a stacksize warning for
sdhci-of-aspeed.
- test_scanf is not a KUnit test.
- Linus already fixed the thunderbolt test by breaking up the test cases.

I am going to send out patches for the thunderbolt test and for the
sdhci-of-aspeed test for the sake of completeness, but I am not sure
if we should merge those two. I'll let y'all decide on the patch
review.

I only based the thunderbolt and bitfield test fixes on actual patches
from Arnd, but I think Arnd pretty much did all the work here so I am
crediting him with a Co-developed-by on all the other patches, so
Arnd: please follow up on the other patches with a signed-off-by,
unless you would rather me credit you in some other way.

> Sorry for failing to submit these as a proper patch. If you send a new version,
> I think you need to make sure you cover all of the above, using whichever
> change you like best.

I am still going to try to get Linus' suggestion working since it
actually solves the problem, but I would rather get the above
suggested fix out there since it is quick and I know it works.

Cheers
