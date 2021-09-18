Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB81F4108A3
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 22:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239147AbhIRUxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 16:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbhIRUxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 16:53:17 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FD8C061574
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 13:51:53 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id g41so15263666lfv.1
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 13:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EgyQSOoQGXbqZDY5vmTdmtdWclji1aa8k4Dg+pV0f0o=;
        b=SEpYwuptd5hG3QJm95kYyoOdykEPWmWM41H04iYKD9x+gej2hvZLmI9MuQSd8s9QNq
         BFtt8Khl1a0U7BIzOb2mMeUeYORXvw3f1yoKo69QHfJASnbgDxK63qWoaCvmswBFSfMk
         A/FZp+Rl5zIq56YhAZEa2tHT6K7SetPgVBSjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EgyQSOoQGXbqZDY5vmTdmtdWclji1aa8k4Dg+pV0f0o=;
        b=G08OL79gXKG2JPihJd7EhBZYFJhk6o9TbEns/a4PoZiz7YqaZGQ3puFmHlwVQQMXNf
         zjIoCjfMRiw0sjLZTXqVCwV9TyPLXCWGKqhydC9X0UChIlJ2S1KpmAKLOH7So2lQHx9j
         5taemJ1he55gR0vWtsBfiGjlCgUI/5yI9VE23YUD7pJrDM+eeoIMv80bBGSND9fyn72o
         LHVer/m5nlDMM2YOHrcCeIDq/aIJYe+SVnrGtiKzzjlmp4c8CEVHsX2wFJDEI0R4UXB5
         X3AS5KhO3c2VL1+S8pGIta7hQhHAikTMT5gOEV3HXvJwr5wAJYIKrmZTdOl5bh2oOfOD
         JGkg==
X-Gm-Message-State: AOAM532UJ8a9nkjf1us2Log1Y5WDqdnOUm38893IuRlx1b48zlcDGD3q
        lcXUtN6IjzxCOE0WZ1b3xMvujYe4AFKq5iAH7po=
X-Google-Smtp-Source: ABdhPJyiZmQSyzJSDdMLGThWvciyhEWEwtprVwNuar/OKgG6njmJIhnsAOI+xU00+9347glaiPnJXA==
X-Received: by 2002:a2e:7616:: with SMTP id r22mr15214526ljc.387.1631998311187;
        Sat, 18 Sep 2021 13:51:51 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id e24sm854745lfs.212.2021.09.18.13.51.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 13:51:51 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id e15so10099655lfr.10
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 13:51:50 -0700 (PDT)
X-Received: by 2002:a05:6512:2611:: with SMTP id bt17mr13595935lfb.141.1631997986070;
 Sat, 18 Sep 2021 13:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whY5mLggPSr2U00mqgUbRJYnYSxtNZm4FnEtQrHftYr8Q@mail.gmail.com>
 <202109182026.18IKQLng003683@valdese.nms.ulrich-teichert.org>
In-Reply-To: <202109182026.18IKQLng003683@valdese.nms.ulrich-teichert.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 18 Sep 2021 13:46:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjZukwHDpm6PUP=cFTi8wWQs6Z5Np7xv7SRphNqvm0FPw@mail.gmail.com>
Message-ID: <CAHk-=wjZukwHDpm6PUP=cFTi8wWQs6Z5Np7xv7SRphNqvm0FPw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Ulrich Teichert <krypton@ulrich-teichert.org>
Cc:     Michael Cree <mcree@orcon.net.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 1:26 PM Ulrich Teichert
<krypton@ulrich-teichert.org> wrote:
>
> >
> > (I forget which alpha I had. For some reason I want to think I had an
> > EISA machine and probably Jensen. Maybe upgraded to a 164 later?)
>
> Well, as this was way back in 1995, it was perhaps a Multia? Also
> named UDB, a small "booksize" model.

No, that came later. I had one of the very original ones.

I'm pretty sure it was that Jensen platform, but I'm too lazy to go
back and look.

> > Can you send me your Jensen config?
>
> Sure, attached here. I don't know if it helps - I can't tell you why I
> used 4.18-rc5 for it, that was in 2018... Oh man, I am spending too much
> time at work...

I ended up hacking something up which was enough to show the build
problems, and then some.

But your config shows _other_ errors with the IO functions, so I guess
I'll need to look at that one too.

There's clearly a reason that Jensen was marked BROKEN in the Kconfig,
the whole situation with the IO accessor functions on that platform is
a disaster.

              Linus
