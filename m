Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2952407FAC
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 21:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbhILTWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 15:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbhILTWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 15:22:01 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19DFC061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 12:20:46 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j13so10940155edv.13
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 12:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tzZRty5syTefvslqvSNH1KyI4p4ePIHehKrpq3jNHak=;
        b=UhV7ZB03lfxtT+Ye8FzC9W6hmCQoAxoCGQimJcLY7prrx8mbKe9DIiT4SGaXesQFeB
         bwrVZJdZaPGgx4eSKLVt3nOkqcznQcyPpP9BRmCWBP8k038tMJltDQ1VrUpAU3aNMwNA
         gTOxiP2LUi8KOIoIT19q3qZx861ljKejcehZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tzZRty5syTefvslqvSNH1KyI4p4ePIHehKrpq3jNHak=;
        b=T3ATtpDiaR/qoZUvC3+fXt8N5WcUeYC1x7TqbitPONjohDx/KOPr2BNBXvyMx+46vM
         RmACa/Lj4GyPSESRm+FIUiZaclMcH8rFIvP7GSFaRJBk58IG6AZT3EIZ5Fv+GBNFOMrF
         8l9tX4fII4kZDK/Mo5mobt5vs0JoVLI1E+jBxXR2taMSW7bIk0y+pA2CHVX/V/BXxXDq
         7FDNpWp8YEfHYq4X708oinJpDkcmPsm7LmruDsaPFpxr4QAmeiMj8wEcjoaxzgxIGQeh
         idwcAAjikD+fOXaESJgAr52yxSTTDw12yR3G8lERdA7dO/6J4enuKojf3LYFHYg5P5uf
         6MZA==
X-Gm-Message-State: AOAM5316wBIlgrsaSq3qvwg8KSwSZBX1yh8KUhXxXsMXwmWNYCZvBoWw
        t+bySE2TUqXBrf7zDPxMfODEu/F0tKN05NKRSks=
X-Google-Smtp-Source: ABdhPJwRsg18Hhij/Umj5Oo0GRVC9YgETzdj9WiGVaDtkGAgXcSEPIqEDhhlUwt/ZFL/w4DWxLVFyw==
X-Received: by 2002:aa7:c905:: with SMTP id b5mr5140480edt.380.1631474445296;
        Sun, 12 Sep 2021 12:20:45 -0700 (PDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com. [209.85.221.43])
        by smtp.gmail.com with ESMTPSA id bw12sm1601067ejb.9.2021.09.12.12.20.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 12:20:45 -0700 (PDT)
Received: by mail-wr1-f43.google.com with SMTP id q11so11178692wrr.9
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 12:20:45 -0700 (PDT)
X-Received: by 2002:a05:6512:3da5:: with SMTP id k37mr6351605lfv.655.1631474006987;
 Sun, 12 Sep 2021 12:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210912160149.2227137-1-linux@roeck-us.net> <20210912160149.2227137-5-linux@roeck-us.net>
In-Reply-To: <20210912160149.2227137-5-linux@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 12 Sep 2021 12:13:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi1=8shingNuo1CtfJ7eDByDsmwsz750Nbxq=7q0Gs+zg@mail.gmail.com>
Message-ID: <CAHk-=wi1=8shingNuo1CtfJ7eDByDsmwsz750Nbxq=7q0Gs+zg@mail.gmail.com>
Subject: Re: [PATCH 4/4] alpha: Use absolute_pointer for strcmp on fixed
 memory location
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Richard Henderson <rth@twiddle.net>,
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

On Sun, Sep 12, 2021 at 9:02 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> -       if (strcmp(COMMAND_LINE, "INSTALL") == 0) {
> +       if (strcmp(absolute_pointer(COMMAND_LINE), "INSTALL") == 0) {

Again, this feels very much like treating the symptoms, not actually
fixing the real issue.

It's COMMAND_LINE itself that should have been fixed up, not that one use of it.

Because the only reason you didn't get a warning from later uses is
that 'strcmp()' is doing compiler-specific magic. You're just delaying
the inevitable warnings about the other uses of that thing.

            Linus
