Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B5C40F229
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 08:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbhIQGRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 02:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhIQGRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 02:17:38 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC598C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 23:16:16 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso9325457pjj.0
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 23:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=79Z9c6dI9E2uafzLue/bSOxRVu0ZiKuAgi/MUWbArdU=;
        b=GSpHcovIBas53qSSHGPc/nfFYJXH0tpO4pIUIKhhFCQ+XUnveL1E/LLuAUF0rfunQA
         Qu0Ph6+2OpABJjcCT+o4YjRoCrIIZpIXcVBNqB387JH+2bWPAjWr3m00A5i1b5FQx8Uc
         3hWH3HoB1v+qBP3rByKBdmIt+w2Y7FIl/kBR2lHGSxCFFOjyHGWWg39LOzI4DQv6ebkB
         Aj4x0a1KwBDQOF29Ij+L4Wt7xmEQwSGgqPPCDEsR6CEM85AiPxCSE3XDnYtqnMWIDCmm
         ABTZreSFeGTZK42l++JlgzyoNwXJctsZzS4ggGM9JZnWP8Sp3lCLgRZzWiYOlOMckpeE
         H3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=79Z9c6dI9E2uafzLue/bSOxRVu0ZiKuAgi/MUWbArdU=;
        b=NYP4l9XtJmqIEf2IC2UbcybBB/9WuNj38LRgVx9+oIGZmkerVUSdYlkS/370Nr6PF4
         bLDcp/WlNpQpBK7qY2Ewff9kBJrZ+x2AdDW0t/mtwWzpGOdz/xH+GagIQhliEhlSLjro
         tdRYkGyQr0xkBGK0i8gRAMKYaZOE5SxQPYa6V+0BSeMYAs3eDT/X3JPTibfb72jALMJK
         DgEzzTB5EQr3n9li2+Ggbgpb0haIYZO9r/ioU38Hm8UlH53CkQ9973Gr3qpE7SL1A2zY
         pwAvS9GQkLVc9Iw69WqRi4HW8ypxYzFL/JRpCRClhWWz7Pv97Qy7vA8nSGud8DFoYDT1
         9IoQ==
X-Gm-Message-State: AOAM533dWH3moJEHGt/sECoQEBn11QsSMN35nO/5IP3pfRuka5LSwIRv
        Xjp63nmDsxp5zi/1uaXRezM29b395gth25aCz0QMMA==
X-Google-Smtp-Source: ABdhPJwqJYgEceRuQHWNSnG0pghvkpr4ogdDBkgZQI2sBLyILod6wmJXhw/QK328ogFOm/WnzPUzdUzp/8zNdYreqc4=
X-Received: by 2002:a17:90b:4b47:: with SMTP id mi7mr19490735pjb.198.1631859375980;
 Thu, 16 Sep 2021 23:16:15 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
 <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
 <120389b9-f90b-0fa3-21d5-1f789b4c984d@linuxfoundation.org>
 <CAFd5g47MgGCoenw08hehegstQSujT7AwksQkxA7mQgKhChimNw@mail.gmail.com>
 <3bad5d2f-8ce7-d0b9-19ad-def68d4193dd@linuxfoundation.org>
 <CAFd5g47bZbqGgMn8PVa=DaSFfjnJsLGVsLTYzmmCOpdv-TfUSQ@mail.gmail.com>
 <CAK8P3a0wQC+9_3wJEACgOLa9C5_zLSmDfU=_79h_KMSE_9JxRw@mail.gmail.com> <CAFd5g44udqkDiYBWh+VeDVJ=ELXeoXwunjv0f9frEN6HJODZng@mail.gmail.com>
In-Reply-To: <CAFd5g44udqkDiYBWh+VeDVJ=ELXeoXwunjv0f9frEN6HJODZng@mail.gmail.com>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Thu, 16 Sep 2021 23:16:04 -0700
Message-ID: <CAFd5g45=vkZL-H3EDrvYXvhMM2ekM_CBGN0ySyKitq=z+V+EwQ@mail.gmail.com>
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

On Thu, Sep 16, 2021 at 10:39 PM Brendan Higgins
<brendanhiggins@google.com> wrote:
>
> On Tue, Sep 14, 2021 at 3:04 PM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > On Tue, Sep 14, 2021 at 10:48 PM Brendan Higgins
> > <brendanhiggins@google.com> wrote:
> > >
> > > On Mon, Sep 13, 2021 at 1:55 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
> > > >
> > > > On 9/8/21 3:24 PM, Brendan Higgins wrote:
[...]
> Alright, I incorporated all the above into a patchset that I think is
> ready to send out, but I had a couple of issues with the above
> suggestions:
>
> - I could not find a config which causes a stacksize warning for
> sdhci-of-aspeed.
> - test_scanf is not a KUnit test.
> - Linus already fixed the thunderbolt test by breaking up the test cases.
>
> I am going to send out patches for the thunderbolt test and for the
> sdhci-of-aspeed test for the sake of completeness, but I am not sure
> if we should merge those two. I'll let y'all decide on the patch
> review.

Just in case I missed any interested parties on this thread, I posted
my patches here:

https://lore.kernel.org/linux-kselftest/20210917061104.2680133-1-brendanhiggins@google.com/T/#t

> I only based the thunderbolt and bitfield test fixes on actual patches
> from Arnd, but I think Arnd pretty much did all the work here so I am
> crediting him with a Co-developed-by on all the other patches, so
> Arnd: please follow up on the other patches with a signed-off-by,
> unless you would rather me credit you in some other way.
>
> > Sorry for failing to submit these as a proper patch. If you send a new version,
> > I think you need to make sure you cover all of the above, using whichever
> > change you like best.
>
> I am still going to try to get Linus' suggestion working since it
> actually solves the problem, but I would rather get the above
> suggested fix out there since it is quick and I know it works.
