Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16ECC3EF191
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhHQSNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbhHQSNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 14:13:44 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B46CC0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:13:11 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id p4so18983yba.3
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7NwteNlJ+8u23Hsu+twQzUFRuemkI7ld+ynYvkYabfE=;
        b=qnkltiRrheB1/zeeBQyRovwwnZPrTnoZCc1KiYhGyjZ0LumWrBP5AwNCUd/G5V9YEE
         mUHY59DBJd8QqanxPvUvpe6IJsyR4U6azBJx4SjG5SBt631OzyGhkHkPgN7GPFgbF1Kw
         Qyo3SArQMQd9yvyGmToQxBywYPUIxwxU90KexT8XowUM97Kt+QYDCpgXhr+Fs0mzZIir
         X7cYB7eYFGFhrG9MRTSQNEd9LPGjAUh+n1TovDrAecoVFJP4M59fWfiLKSxXjL4Ggls6
         FTjDUabcyrRaeUC+iAb9XPvNm/8MKzy9kQmDXwHyikhnI1k1wcKrxTZOZlLGJUrhfz4r
         eK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7NwteNlJ+8u23Hsu+twQzUFRuemkI7ld+ynYvkYabfE=;
        b=my26rEmCm0AIvpbsvBqj6kXw4Kkv8As6z3MLJtraXMwnYONHypzMYtLF52gZCqMnW7
         ETC4C0C+Ena906qKZIE386sT569wTN4i8JqynJosR8VyvMLQJOmQleo1v9nFnAtJ27Q7
         YN2C6YS5RgeeRh0yPZ5JNHXkC0tBVPFR4zYrpx91U+b25S+hT9JbHXs9NU2KQhep/9BK
         7hiAB+pVlJCFHISZecT6xTsno+jOZnQEkEwE5/mH2ConDbsm10sPtRk1hdHi75F+lLSi
         CTWhTGCqv5/2N1M2Za15f1YqKk3JMvZW05ozZWnCG6dGQLIJ5OwQMN8eRKwBc6I9/TxX
         aKJQ==
X-Gm-Message-State: AOAM530jbXbQmj6AuuYJN19/iCMXvcV5ndTFIRhf/Ef/AAJA3uGJ7MXS
        U+EPbNopxOqBuRDncp46d4/SkfIfWdxVU7rYQouzmw==
X-Google-Smtp-Source: ABdhPJxg04YMhrsXZwM6lu/UTiwn7kooe/YZ9Az9RT53o7XkLiL3cQyAC7OwEeGCeol8R0kbAV7dGZ7ndc/P9K4N0IM=
X-Received: by 2002:a25:d1c2:: with SMTP id i185mr6203714ybg.466.1629223990252;
 Tue, 17 Aug 2021 11:13:10 -0700 (PDT)
MIME-Version: 1.0
References: <87r1hwwier.wl-maz@kernel.org> <7h7diwgjup.fsf@baylibre.com>
 <87im0m277h.wl-maz@kernel.org> <CAGETcx9OukoWM_qprMse9aXdzCE=GFUgFEkfhhNjg44YYsOQLw@mail.gmail.com>
 <87sfzpwq4f.wl-maz@kernel.org> <CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com>
 <CAGETcx8bpWQEnkpJ0YW9GqX8WE0ewT45zqkbWWdZ0ktJBhG4yQ@mail.gmail.com>
 <YQuZ2cKVE+3Os25Z@google.com> <YRpeVLf18Z+1R7WE@google.com>
 <CAGETcx-gSJD0Ra=U_55k3Anps11N_3Ev9gEQV6NaXOvqwP0J3g@mail.gmail.com> <YRtkE62O+4EiyzF9@google.com>
In-Reply-To: <YRtkE62O+4EiyzF9@google.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 17 Aug 2021 11:12:34 -0700
Message-ID: <CAGETcx-FS_88nQuF=xN4iJJ-nGnaeTnO-iiGpZuNELqE42FtoA@mail.gmail.com>
Subject: Re: [PATCH 1/2] irqchip: irq-meson-gpio: make it possible to build as
 a module
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 12:24 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Mon, 16 Aug 2021, Saravana Kannan wrote:
> > > > > I sent out the proper fix as a series:
> > > > > https://lore.kernel.org/lkml/20210804214333.927985-1-saravanak@go=
ogle.com/T/#t
> > > > >
> > > > > Marc, can you give it a shot please?
> > > > >
> > > > > -Saravana
> > > >
> > > > Superstar!  Thanks for taking the time to rectify this for all of u=
s.
> > >
> > > Just to clarify:
> > >
> > >   Are we waiting on a subsequent patch submission at this point?
> >
> > Not that I'm aware of. Andrew added a "Reviewed-by" to all 3 of my
> > proper fix patches. I didn't think I needed to send any newer patches.
> > Is there some reason you that I needed to?
>
> Actually, I meant *this* patch.

I think it'll be nice if Neil addresses the stuff Marc mentioned
(ideally) using the macros I suggested. Not sure if Marc is waiting on
that though. Marc also probably wants my mdio-mux series to merge
first before he takes this patch. So that it doesn't break networking
in his device.

-Saravana

>
> But happy to have unlocked your patches also. :)
>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Senior Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
