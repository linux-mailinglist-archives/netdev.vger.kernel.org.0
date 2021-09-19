Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BD8410C1B
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 17:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhISPPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 11:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbhISPPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 11:15:12 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48442C061574;
        Sun, 19 Sep 2021 08:13:47 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id q3so18667722iot.3;
        Sun, 19 Sep 2021 08:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vbpoc8nlnfHxnI+l9mWkkIGQVWPI3MGONh3p7LPE7MI=;
        b=VM30cLMK8vCJPnDOrNVJVLKgaM108XQCUD2FUTn/7VOT0R6gTL8DYA/S/xiXNWm3y1
         AayprkuIsnStSNKMVtZw9+Rz5oK+ArUk7DLq906so7hRzOsWC3/sVc+Y/QqCm7iMprv0
         U8iDp/brT1ry6/RqaBObVVPa+OTrlnZw899bln5L0UtucSwwW92pgbh7X8PHCkukvBsU
         Quk23h8w4lJ1Qf+KMkotX488eh7zOcdVmMAns5HQucqLfUTR4GVZTRA7nVMXWqRUo/Z+
         urYeOW/Bh4ymu4grYu4TS/06TjUcAi4d6pUyQGoYzPKqLYLROPr7FwkTthR//Myx8lT1
         4/IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vbpoc8nlnfHxnI+l9mWkkIGQVWPI3MGONh3p7LPE7MI=;
        b=FWgagt+/1A20KZv2EdGNadKtNtPKK7t7Z2fFfLSXvtJO+8QGnKXWacgWUo9G8k+g3e
         9c9BgvXYRXXc6pyWU53xP4fbSQC2ZYsI8AND9Ep0l9Jpudra7pdqAf5YEl/8tHjReBz9
         0ubJXlioUse9poRE72vRvH1GfVGSQxWhO/dCFmFPKLMZGDefySvM/aGWnOrCPJGqHB+I
         FKwocoKLrTtf66PZEEgpjPcn4MqhJz+r77nnhzEXrV7stUWYY/nt4QU9eYFxhKGoMjEk
         JPt/sDEMnoTs93H+xqJWBlHNbOZ+iAFyl0AGg+iLD0U3aDmHNvY/v3b3X2vYXPkJynjM
         0s7g==
X-Gm-Message-State: AOAM533irDzpGMy6vzC+HSJqKiAv9JffFh/DiMxnd95xKrAxNzHtMzjp
        4L22Wna7JfsvWVabVKavVToK+47fHsIaRWGlG7w=
X-Google-Smtp-Source: ABdhPJxguGzRMzwC4iYM/5nKX7PT6FRrg4dZ2/gqzY3RezIzCOEE0tCc8v4TTygFXyyDdCl+gaGST3J79azJLga7LOM=
X-Received: by 2002:a05:6602:180e:: with SMTP id t14mr602481ioh.204.1632064426701;
 Sun, 19 Sep 2021 08:13:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whY5mLggPSr2U00mqgUbRJYnYSxtNZm4FnEtQrHftYr8Q@mail.gmail.com>
 <202109182026.18IKQLng003683@valdese.nms.ulrich-teichert.org> <CAHk-=wh-=tMO9iCA4v+WgPSd+Gbowe5kptwo+okahihnO2fAOA@mail.gmail.com>
In-Reply-To: <CAHk-=wh-=tMO9iCA4v+WgPSd+Gbowe5kptwo+okahihnO2fAOA@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sun, 19 Sep 2021 08:13:32 -0700
Message-ID: <CAA93jw6gK9_PMa_BtabkqyZLT4Vb+x4gsADT7vU+75bucnvrAQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ulrich Teichert <krypton@ulrich-teichert.org>,
        Michael Cree <mcree@orcon.net.nz>,
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 8:01 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> Oh well. I have an odd love-hate relationship with alpha.
>
> I think it's one of the worst architectures ever designed (memory
> ordering is completely broken, and the lack of byte operations in the
> original specs were a big reason for the initial problems and eventual
> failure).
>
> But at the same time, I really did enjoy it back in the day, and it
> _was_ the first port I did, and the first truly integrated kernel
> architecture (the original Linux m68k port that preceded it was a
> "hack up and replace" job rather than "integrate")

As a side note, I loved the Alpha, too. Compared to the VMS port
I was too often working on in the 90s, having Linux run on it was
a joy, and for years I used my remaining older alpha boxes as
firewalls, trusting in the oddity of the architecture to resist
various and sundry attacks.

I retired the last one well over a decade back.

RIP.

>
>            Linus



--=20
Fixing Starlink's Latencies: https://www.youtube.com/watch?v=3Dc9gLo6Xrwgw

Dave T=C3=A4ht CEO, TekLibre, LLC
