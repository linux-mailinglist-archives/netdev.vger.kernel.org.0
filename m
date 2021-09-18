Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F321F4108CC
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 00:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240457AbhIRWLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 18:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240349AbhIRWK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 18:10:57 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F20CC061757
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 15:09:33 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y28so48076882lfb.0
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 15:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hhzplMeBODusyr1H2stA0puUgPSaTtOBgK77tHO282k=;
        b=JTYIBPqLj92nNTxPKVgSXgrpmcBI0kIM1GLPs6qJei5SauEXmL4YjUER2rr88W6PSq
         1DyThW7PUpCkaPaRUzGHd63izjL4GOav/VKQujZg/VmlgUEkUA00v11NnnZZ74r1NHxh
         4wDTaM/CdGI1g53lKb6vt1ECENxdljnyVleYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hhzplMeBODusyr1H2stA0puUgPSaTtOBgK77tHO282k=;
        b=h+foIJWw98lo8nvqfpVGdQy/dyxflrtVj11qBdOIZ0AiVph7SEeAiZPU0Zg+rxGsEz
         2J0bTQwnJMmtBKK2h5DrRsaCe3gKONqr3ZF3U6ySDvpqbY9ChVHOYefKD29o8a8QDQ3Y
         t/+2BGAHgotj9jZB253Ju2RXfhSVP2DE8LwgmkIAFRJnf53POAjIVSVfUDDVt4N6PhRg
         nfb6k80o4kEJVYdIF6pHaowHnUdyDX4kWieZoXG+sj3Vai4JMuR7JpLcO2i+mdud8giG
         S/SIaVyfXCdbmNfelXzmuQmjTRj3UKxgFGd0fUnydNxsd5Ue6Kr9K0DMcY/EzAheiCpU
         qduw==
X-Gm-Message-State: AOAM532QMl/9XrJ7vW5khIKitVtamzFUxVEfjc7OG6OyAXkDtjuRB36v
        yJ35tiyIvIw/ivVStB9NxJmlE9EEtsDEZyFAKNQ=
X-Google-Smtp-Source: ABdhPJwFQtPGTGWfZyfUIRTMW7p4HL2Fa897LPJLdkWXaV25UVnPzD4e8HdaTfylOR0ApHsttuQNkg==
X-Received: by 2002:a19:740b:: with SMTP id v11mr12743204lfe.132.1632002970769;
        Sat, 18 Sep 2021 15:09:30 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id v5sm1238800ljg.117.2021.09.18.15.09.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 15:09:29 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id e15so10612178lfr.10
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 15:09:28 -0700 (PDT)
X-Received: by 2002:a05:6512:3d29:: with SMTP id d41mr2659681lfv.474.1632002968346;
 Sat, 18 Sep 2021 15:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whY5mLggPSr2U00mqgUbRJYnYSxtNZm4FnEtQrHftYr8Q@mail.gmail.com>
 <202109182026.18IKQLng003683@valdese.nms.ulrich-teichert.org>
In-Reply-To: <202109182026.18IKQLng003683@valdese.nms.ulrich-teichert.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 18 Sep 2021 15:09:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh-=tMO9iCA4v+WgPSd+Gbowe5kptwo+okahihnO2fAOA@mail.gmail.com>
Message-ID: <CAHk-=wh-=tMO9iCA4v+WgPSd+Gbowe5kptwo+okahihnO2fAOA@mail.gmail.com>
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
> I was just tinkering with it to get it compiled without warning,
> I certainly didn't get the big picture :-/

Ok, you shamed me into some tinkering too, and I fixed a couple of
issues with the alpha build.

The whole "pci_iounmap()" mess is not something I solved (you were
cc'd on the email I sent out about that), but I did test a few
different Jensen configurations and fixed a couple of uglies.

So at least _some_ Jensen configurations build cleanly once more, and
I re-enabled JENSEN as a valid machine target.

But if it doesn't boot, it's all fairly moot. And those things are a
pain to debug, and if the last booting kernel was years and years ago,
I don't think it realistically will necessarily ever be fixed.

Oh well. I have an odd love-hate relationship with alpha.

I think it's one of the worst architectures ever designed (memory
ordering is completely broken, and the lack of byte operations in the
original specs were a big reason for the initial problems and eventual
failure).

But at the same time, I really did enjoy it back in the day, and it
_was_ the first port I did, and the first truly integrated kernel
architecture (the original Linux m68k port that preceded it was a
"hack up and replace" job rather than "integrate")

           Linus
