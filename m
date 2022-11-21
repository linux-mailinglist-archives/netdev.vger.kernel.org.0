Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B096323C8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiKUNfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiKUNfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:35:21 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6A79CF4D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:35:19 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-3691e040abaso113320237b3.9
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AkVA2gbeFi41E2HoJZX47IA5XRYqAdo+42G6zXfvCrQ=;
        b=i9nqHc5IEDhPKfUr6eMNAh6EdyZR4XMALZr8+66IAoeOPqMfROST8/8XnGVQe0zln+
         qv53OnWiNFO23QfMIglLPbz66RSWhqn/9YQXFJg/6WYULqf0rd5Lm3DT/FLnQ9gljs16
         l4QhEYH3ZvKgtFrhZi0UPfnry7VBJ+CZ88v6mqLCFk/bFqu1dvQO4lJPQkZw2brAfdfK
         X6Q1EzIxIA5dWbqSQPBGT1ZFNIkF0i4cWPqjr+Nziau3uyXd5BMk4qn9j07yq9dH/8Qw
         wzn3R6SCxW5x0kLeyxyalVAG7jHtmENlAMKmM+yM5hVHAOTgP8YGUtFn0O11eRHV0gzY
         rGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AkVA2gbeFi41E2HoJZX47IA5XRYqAdo+42G6zXfvCrQ=;
        b=i9/SL6unEvJ8iIZT5Qkh5Wag+8DeovziuBqgMyYHFT9MMViVRnRQ1UPWnEs0thcMqH
         eeGaSqjus4IzYnMGONerOapZStPWRTH4E5DBRUbCNtd/kax+i7vy70yY5lbiK13uqnzk
         8jk+bKrU2DFqFsusJd/DhL2l8tOwOSTmvtzWx7w63T9VpTMkCLeNT0Ec/UD90KWmWQEP
         Sy12PRLgu/AsCvK+sc9T8jjnjgfyyTpIvfTs9FPhPvaEOBQfun40HsAvftjFaZ14Gs7O
         6KCcLYiuvdokRPNtGaVWeDjFIimwrWkWIwZAKA2gyUU+JTtoqy/3EAcP3ueIUIDE1L56
         +c+g==
X-Gm-Message-State: ANoB5plHNop9FbNOPZO8YtQSxCxTVC16JU7DSDACHxZWjxUXA6gkuNGY
        jJ9ZqxPe3oM36VwWumqzflXXTY3whwYDLCk91oBZnw==
X-Google-Smtp-Source: AA0mqf6kCQEkXvgtxPXnOtB2Jg0JrJ3oxTygO5M6P+rnA9h5wQGHzpYbv2SCj1hVgEqRmMGmHzgiN1DYYtFhJDxBA/w=
X-Received: by 2002:a0d:fdc7:0:b0:37a:e8f:3cd3 with SMTP id
 n190-20020a0dfdc7000000b0037a0e8f3cd3mr17064548ywf.187.1669037719041; Mon, 21
 Nov 2022 05:35:19 -0800 (PST)
MIME-Version: 1.0
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
 <88VJLR.GYSEKGBPLGZC1@crapouillou.net> <Y3ernUQfdWMBtO9z@google.com>
 <Y3fF/mCUVepTfTi+@lunn.ch> <Y3fHF9b1YoVTj/jL@google.com>
In-Reply-To: <Y3fHF9b1YoVTj/jL@google.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 21 Nov 2022 14:35:07 +0100
Message-ID: <CACRpkdb=O_dUn6hUrAS1yYZxBR1ZPADtTb9GbLBANHUxcm3sUg@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Paul Cercueil <paul@crapouillou.net>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 6:55 PM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Nov 18, 2022 at 06:50:54PM +0100, Andrew Lunn wrote:
> > > > Why is that 1 magically turned into a 0?
> > >
> > > Because gpiod uses logical states (think active/inactive), not absolute
> > > ones. Here we are deasserting the reset line.
> >
> > This is the same question/answer you had with me. Maybe it is worth
> > putting this into the commit message for other patches in your series
> > to prevent this question/answer again and again.
>
> Right... Actually I think I'll go and define that GPIO_STATE_ACTIVE/
> GPIO_STATE_INACTIVE and try to get Linus and Bart to accept it as code
> speaks louder than words ;)

What I have said about that is that it should be accompanied by some sed
or cocinelle script to change this everywhere in the kernel instead
of using 0/1 to the gpiod_set/direction etc functions. Then Torvalds
can run that toward the end of the merge window to just change this
everywhere at once and be done with it.

The reason I want it that way is that I am royally tired of changes that
begin in one tiny corner and then the change keeps confusing users
for years until it is finally fixed up 15 kernel revisions later.

Since that has created a support nightmare in the past, I am now
advocating an all-or-nothing approach with that type of change.

Yours,
Linus Walleij
